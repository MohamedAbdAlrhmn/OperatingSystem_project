
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
  80008d:	68 e0 39 80 00       	push   $0x8039e0
  800092:	6a 14                	push   $0x14
  800094:	68 fc 39 80 00       	push   $0x8039fc
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
  8000ca:	e8 d6 1a 00 00       	call   801ba5 <sys_calculate_free_frames>
  8000cf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8000d2:	e8 6e 1b 00 00       	call   801c45 <sys_pf_calculate_allocated_pages>
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
  800105:	68 10 3a 80 00       	push   $0x803a10
  80010a:	6a 23                	push   $0x23
  80010c:	68 fc 39 80 00       	push   $0x8039fc
  800111:	e8 cb 05 00 00       	call   8006e1 <_panic>
		//		if ((freeFrames - sys_calculate_free_frames()) != 512+1 ) panic("Wrong allocation: ");
		//cprintf("freeFrames - sys_calculate_free_frames() = %d\n", freeFrames - sys_calculate_free_frames()) ;
		//cprintf("Expected = %d\n", (1 + sizeOfMemBlocksArray/PAGE_SIZE));
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800116:	e8 8a 1a 00 00       	call   801ba5 <sys_calculate_free_frames>
  80011b:	89 c2                	mov    %eax,%edx
  80011d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800120:	39 c2                	cmp    %eax,%edx
  800122:	74 14                	je     800138 <_main+0x100>
  800124:	83 ec 04             	sub    $0x4,%esp
  800127:	68 40 3a 80 00       	push   $0x803a40
  80012c:	6a 27                	push   $0x27
  80012e:	68 fc 39 80 00       	push   $0x8039fc
  800133:	e8 a9 05 00 00       	call   8006e1 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800138:	e8 08 1b 00 00       	call   801c45 <sys_pf_calculate_allocated_pages>
  80013d:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800140:	74 14                	je     800156 <_main+0x11e>
  800142:	83 ec 04             	sub    $0x4,%esp
  800145:	68 ac 3a 80 00       	push   $0x803aac
  80014a:	6a 28                	push   $0x28
  80014c:	68 fc 39 80 00       	push   $0x8039fc
  800151:	e8 8b 05 00 00       	call   8006e1 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800156:	e8 4a 1a 00 00       	call   801ba5 <sys_calculate_free_frames>
  80015b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80015e:	e8 e2 1a 00 00       	call   801c45 <sys_pf_calculate_allocated_pages>
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
  8001a6:	68 10 3a 80 00       	push   $0x803a10
  8001ab:	6a 2d                	push   $0x2d
  8001ad:	68 fc 39 80 00       	push   $0x8039fc
  8001b2:	e8 2a 05 00 00       	call   8006e1 <_panic>
		//		if ((freeFrames - sys_calculate_free_frames()) != 512 ) panic("Wrong allocation: ");
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8001b7:	e8 e9 19 00 00       	call   801ba5 <sys_calculate_free_frames>
  8001bc:	89 c2                	mov    %eax,%edx
  8001be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001c1:	39 c2                	cmp    %eax,%edx
  8001c3:	74 14                	je     8001d9 <_main+0x1a1>
  8001c5:	83 ec 04             	sub    $0x4,%esp
  8001c8:	68 40 3a 80 00       	push   $0x803a40
  8001cd:	6a 2f                	push   $0x2f
  8001cf:	68 fc 39 80 00       	push   $0x8039fc
  8001d4:	e8 08 05 00 00       	call   8006e1 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8001d9:	e8 67 1a 00 00       	call   801c45 <sys_pf_calculate_allocated_pages>
  8001de:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8001e1:	74 14                	je     8001f7 <_main+0x1bf>
  8001e3:	83 ec 04             	sub    $0x4,%esp
  8001e6:	68 ac 3a 80 00       	push   $0x803aac
  8001eb:	6a 30                	push   $0x30
  8001ed:	68 fc 39 80 00       	push   $0x8039fc
  8001f2:	e8 ea 04 00 00       	call   8006e1 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8001f7:	e8 a9 19 00 00       	call   801ba5 <sys_calculate_free_frames>
  8001fc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8001ff:	e8 41 1a 00 00       	call   801c45 <sys_pf_calculate_allocated_pages>
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
  80024a:	68 10 3a 80 00       	push   $0x803a10
  80024f:	6a 35                	push   $0x35
  800251:	68 fc 39 80 00       	push   $0x8039fc
  800256:	e8 86 04 00 00       	call   8006e1 <_panic>
		//		if ((freeFrames - sys_calculate_free_frames()) != 1+1 ) panic("Wrong allocation: ");
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  80025b:	e8 45 19 00 00       	call   801ba5 <sys_calculate_free_frames>
  800260:	89 c2                	mov    %eax,%edx
  800262:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800265:	39 c2                	cmp    %eax,%edx
  800267:	74 14                	je     80027d <_main+0x245>
  800269:	83 ec 04             	sub    $0x4,%esp
  80026c:	68 40 3a 80 00       	push   $0x803a40
  800271:	6a 37                	push   $0x37
  800273:	68 fc 39 80 00       	push   $0x8039fc
  800278:	e8 64 04 00 00       	call   8006e1 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  80027d:	e8 c3 19 00 00       	call   801c45 <sys_pf_calculate_allocated_pages>
  800282:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800285:	74 14                	je     80029b <_main+0x263>
  800287:	83 ec 04             	sub    $0x4,%esp
  80028a:	68 ac 3a 80 00       	push   $0x803aac
  80028f:	6a 38                	push   $0x38
  800291:	68 fc 39 80 00       	push   $0x8039fc
  800296:	e8 46 04 00 00       	call   8006e1 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  80029b:	e8 05 19 00 00       	call   801ba5 <sys_calculate_free_frames>
  8002a0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8002a3:	e8 9d 19 00 00       	call   801c45 <sys_pf_calculate_allocated_pages>
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
  800302:	68 10 3a 80 00       	push   $0x803a10
  800307:	6a 3d                	push   $0x3d
  800309:	68 fc 39 80 00       	push   $0x8039fc
  80030e:	e8 ce 03 00 00       	call   8006e1 <_panic>
		//		if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: ");
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800313:	e8 8d 18 00 00       	call   801ba5 <sys_calculate_free_frames>
  800318:	89 c2                	mov    %eax,%edx
  80031a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80031d:	39 c2                	cmp    %eax,%edx
  80031f:	74 14                	je     800335 <_main+0x2fd>
  800321:	83 ec 04             	sub    $0x4,%esp
  800324:	68 40 3a 80 00       	push   $0x803a40
  800329:	6a 3f                	push   $0x3f
  80032b:	68 fc 39 80 00       	push   $0x8039fc
  800330:	e8 ac 03 00 00       	call   8006e1 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800335:	e8 0b 19 00 00       	call   801c45 <sys_pf_calculate_allocated_pages>
  80033a:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80033d:	74 14                	je     800353 <_main+0x31b>
  80033f:	83 ec 04             	sub    $0x4,%esp
  800342:	68 ac 3a 80 00       	push   $0x803aac
  800347:	6a 40                	push   $0x40
  800349:	68 fc 39 80 00       	push   $0x8039fc
  80034e:	e8 8e 03 00 00       	call   8006e1 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800353:	e8 4d 18 00 00       	call   801ba5 <sys_calculate_free_frames>
  800358:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80035b:	e8 e5 18 00 00       	call   801c45 <sys_pf_calculate_allocated_pages>
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
  8003be:	68 10 3a 80 00       	push   $0x803a10
  8003c3:	6a 45                	push   $0x45
  8003c5:	68 fc 39 80 00       	push   $0x8039fc
  8003ca:	e8 12 03 00 00       	call   8006e1 <_panic>
		//		if ((freeFrames - sys_calculate_free_frames()) != 2)panic("Wrong allocation: ");
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8003cf:	e8 d1 17 00 00       	call   801ba5 <sys_calculate_free_frames>
  8003d4:	89 c2                	mov    %eax,%edx
  8003d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003d9:	39 c2                	cmp    %eax,%edx
  8003db:	74 14                	je     8003f1 <_main+0x3b9>
  8003dd:	83 ec 04             	sub    $0x4,%esp
  8003e0:	68 40 3a 80 00       	push   $0x803a40
  8003e5:	6a 47                	push   $0x47
  8003e7:	68 fc 39 80 00       	push   $0x8039fc
  8003ec:	e8 f0 02 00 00       	call   8006e1 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8003f1:	e8 4f 18 00 00       	call   801c45 <sys_pf_calculate_allocated_pages>
  8003f6:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8003f9:	74 14                	je     80040f <_main+0x3d7>
  8003fb:	83 ec 04             	sub    $0x4,%esp
  8003fe:	68 ac 3a 80 00       	push   $0x803aac
  800403:	6a 48                	push   $0x48
  800405:	68 fc 39 80 00       	push   $0x8039fc
  80040a:	e8 d2 02 00 00       	call   8006e1 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  80040f:	e8 91 17 00 00       	call   801ba5 <sys_calculate_free_frames>
  800414:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800417:	e8 29 18 00 00       	call   801c45 <sys_pf_calculate_allocated_pages>
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
  800479:	68 10 3a 80 00       	push   $0x803a10
  80047e:	6a 4d                	push   $0x4d
  800480:	68 fc 39 80 00       	push   $0x8039fc
  800485:	e8 57 02 00 00       	call   8006e1 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  80048a:	e8 16 17 00 00       	call   801ba5 <sys_calculate_free_frames>
  80048f:	89 c2                	mov    %eax,%edx
  800491:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800494:	39 c2                	cmp    %eax,%edx
  800496:	74 14                	je     8004ac <_main+0x474>
  800498:	83 ec 04             	sub    $0x4,%esp
  80049b:	68 da 3a 80 00       	push   $0x803ada
  8004a0:	6a 4e                	push   $0x4e
  8004a2:	68 fc 39 80 00       	push   $0x8039fc
  8004a7:	e8 35 02 00 00       	call   8006e1 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8004ac:	e8 94 17 00 00       	call   801c45 <sys_pf_calculate_allocated_pages>
  8004b1:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8004b4:	74 14                	je     8004ca <_main+0x492>
  8004b6:	83 ec 04             	sub    $0x4,%esp
  8004b9:	68 ac 3a 80 00       	push   $0x803aac
  8004be:	6a 4f                	push   $0x4f
  8004c0:	68 fc 39 80 00       	push   $0x8039fc
  8004c5:	e8 17 02 00 00       	call   8006e1 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8004ca:	e8 d6 16 00 00       	call   801ba5 <sys_calculate_free_frames>
  8004cf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8004d2:	e8 6e 17 00 00       	call   801c45 <sys_pf_calculate_allocated_pages>
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
  80053e:	68 10 3a 80 00       	push   $0x803a10
  800543:	6a 54                	push   $0x54
  800545:	68 fc 39 80 00       	push   $0x8039fc
  80054a:	e8 92 01 00 00       	call   8006e1 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  80054f:	e8 51 16 00 00       	call   801ba5 <sys_calculate_free_frames>
  800554:	89 c2                	mov    %eax,%edx
  800556:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800559:	39 c2                	cmp    %eax,%edx
  80055b:	74 14                	je     800571 <_main+0x539>
  80055d:	83 ec 04             	sub    $0x4,%esp
  800560:	68 da 3a 80 00       	push   $0x803ada
  800565:	6a 55                	push   $0x55
  800567:	68 fc 39 80 00       	push   $0x8039fc
  80056c:	e8 70 01 00 00       	call   8006e1 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800571:	e8 cf 16 00 00       	call   801c45 <sys_pf_calculate_allocated_pages>
  800576:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800579:	74 14                	je     80058f <_main+0x557>
  80057b:	83 ec 04             	sub    $0x4,%esp
  80057e:	68 ac 3a 80 00       	push   $0x803aac
  800583:	6a 56                	push   $0x56
  800585:	68 fc 39 80 00       	push   $0x8039fc
  80058a:	e8 52 01 00 00       	call   8006e1 <_panic>
	}

	cprintf("Congratulations!! test malloc (1) completed successfully.\n");
  80058f:	83 ec 0c             	sub    $0xc,%esp
  800592:	68 f0 3a 80 00       	push   $0x803af0
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
  8005ab:	e8 d5 18 00 00       	call   801e85 <sys_getenvindex>
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
  800616:	e8 77 16 00 00       	call   801c92 <sys_disable_interrupt>
	cprintf("**************************************\n");
  80061b:	83 ec 0c             	sub    $0xc,%esp
  80061e:	68 44 3b 80 00       	push   $0x803b44
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
  800646:	68 6c 3b 80 00       	push   $0x803b6c
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
  800677:	68 94 3b 80 00       	push   $0x803b94
  80067c:	e8 14 03 00 00       	call   800995 <cprintf>
  800681:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800684:	a1 20 50 80 00       	mov    0x805020,%eax
  800689:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80068f:	83 ec 08             	sub    $0x8,%esp
  800692:	50                   	push   %eax
  800693:	68 ec 3b 80 00       	push   $0x803bec
  800698:	e8 f8 02 00 00       	call   800995 <cprintf>
  80069d:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8006a0:	83 ec 0c             	sub    $0xc,%esp
  8006a3:	68 44 3b 80 00       	push   $0x803b44
  8006a8:	e8 e8 02 00 00       	call   800995 <cprintf>
  8006ad:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8006b0:	e8 f7 15 00 00       	call   801cac <sys_enable_interrupt>

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
  8006c8:	e8 84 17 00 00       	call   801e51 <sys_destroy_env>
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
  8006d9:	e8 d9 17 00 00       	call   801eb7 <sys_exit_env>
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
  800702:	68 00 3c 80 00       	push   $0x803c00
  800707:	e8 89 02 00 00       	call   800995 <cprintf>
  80070c:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80070f:	a1 00 50 80 00       	mov    0x805000,%eax
  800714:	ff 75 0c             	pushl  0xc(%ebp)
  800717:	ff 75 08             	pushl  0x8(%ebp)
  80071a:	50                   	push   %eax
  80071b:	68 05 3c 80 00       	push   $0x803c05
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
  80073f:	68 21 3c 80 00       	push   $0x803c21
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
  80076b:	68 24 3c 80 00       	push   $0x803c24
  800770:	6a 26                	push   $0x26
  800772:	68 70 3c 80 00       	push   $0x803c70
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
  80083d:	68 7c 3c 80 00       	push   $0x803c7c
  800842:	6a 3a                	push   $0x3a
  800844:	68 70 3c 80 00       	push   $0x803c70
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
  8008ad:	68 d0 3c 80 00       	push   $0x803cd0
  8008b2:	6a 44                	push   $0x44
  8008b4:	68 70 3c 80 00       	push   $0x803c70
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
  800907:	e8 d8 11 00 00       	call   801ae4 <sys_cputs>
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
  80097e:	e8 61 11 00 00       	call   801ae4 <sys_cputs>
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
  8009c8:	e8 c5 12 00 00       	call   801c92 <sys_disable_interrupt>
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
  8009e8:	e8 bf 12 00 00       	call   801cac <sys_enable_interrupt>
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
  800a32:	e8 31 2d 00 00       	call   803768 <__udivdi3>
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
  800a82:	e8 f1 2d 00 00       	call   803878 <__umoddi3>
  800a87:	83 c4 10             	add    $0x10,%esp
  800a8a:	05 34 3f 80 00       	add    $0x803f34,%eax
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
  800bdd:	8b 04 85 58 3f 80 00 	mov    0x803f58(,%eax,4),%eax
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
  800cbe:	8b 34 9d a0 3d 80 00 	mov    0x803da0(,%ebx,4),%esi
  800cc5:	85 f6                	test   %esi,%esi
  800cc7:	75 19                	jne    800ce2 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800cc9:	53                   	push   %ebx
  800cca:	68 45 3f 80 00       	push   $0x803f45
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
  800ce3:	68 4e 3f 80 00       	push   $0x803f4e
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
  800d10:	be 51 3f 80 00       	mov    $0x803f51,%esi
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
  801736:	68 b0 40 80 00       	push   $0x8040b0
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
  801806:	e8 1d 04 00 00       	call   801c28 <sys_allocate_chunk>
  80180b:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  80180e:	a1 20 51 80 00       	mov    0x805120,%eax
  801813:	83 ec 0c             	sub    $0xc,%esp
  801816:	50                   	push   %eax
  801817:	e8 92 0a 00 00       	call   8022ae <initialize_MemBlocksList>
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
  801844:	68 d5 40 80 00       	push   $0x8040d5
  801849:	6a 33                	push   $0x33
  80184b:	68 f3 40 80 00       	push   $0x8040f3
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
  8018c3:	68 00 41 80 00       	push   $0x804100
  8018c8:	6a 34                	push   $0x34
  8018ca:	68 f3 40 80 00       	push   $0x8040f3
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
  801938:	68 24 41 80 00       	push   $0x804124
  80193d:	6a 46                	push   $0x46
  80193f:	68 f3 40 80 00       	push   $0x8040f3
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
  801954:	68 4c 41 80 00       	push   $0x80414c
  801959:	6a 61                	push   $0x61
  80195b:	68 f3 40 80 00       	push   $0x8040f3
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
  80197a:	75 07                	jne    801983 <smalloc+0x1e>
  80197c:	b8 00 00 00 00       	mov    $0x0,%eax
  801981:	eb 7c                	jmp    8019ff <smalloc+0x9a>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801983:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80198a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80198d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801990:	01 d0                	add    %edx,%eax
  801992:	48                   	dec    %eax
  801993:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801996:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801999:	ba 00 00 00 00       	mov    $0x0,%edx
  80199e:	f7 75 f0             	divl   -0x10(%ebp)
  8019a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019a4:	29 d0                	sub    %edx,%eax
  8019a6:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  8019a9:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  8019b0:	e8 41 06 00 00       	call   801ff6 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8019b5:	85 c0                	test   %eax,%eax
  8019b7:	74 11                	je     8019ca <smalloc+0x65>
		mem_block = alloc_block_FF(allocate_space);
  8019b9:	83 ec 0c             	sub    $0xc,%esp
  8019bc:	ff 75 e8             	pushl  -0x18(%ebp)
  8019bf:	e8 ac 0c 00 00       	call   802670 <alloc_block_FF>
  8019c4:	83 c4 10             	add    $0x10,%esp
  8019c7:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  8019ca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8019ce:	74 2a                	je     8019fa <smalloc+0x95>
	{
		virtual_address = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  8019d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019d3:	8b 40 08             	mov    0x8(%eax),%eax
  8019d6:	89 c2                	mov    %eax,%edx
  8019d8:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8019dc:	52                   	push   %edx
  8019dd:	50                   	push   %eax
  8019de:	ff 75 0c             	pushl  0xc(%ebp)
  8019e1:	ff 75 08             	pushl  0x8(%ebp)
  8019e4:	e8 92 03 00 00       	call   801d7b <sys_createSharedObject>
  8019e9:	83 c4 10             	add    $0x10,%esp
  8019ec:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (virtual_address != -1)
  8019ef:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  8019f3:	74 05                	je     8019fa <smalloc+0x95>
			return (void*)virtual_address;
  8019f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8019f8:	eb 05                	jmp    8019ff <smalloc+0x9a>
	}
	return NULL;
  8019fa:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8019ff:	c9                   	leave  
  801a00:	c3                   	ret    

00801a01 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801a01:	55                   	push   %ebp
  801a02:	89 e5                	mov    %esp,%ebp
  801a04:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801a07:	e8 13 fd ff ff       	call   80171f <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801a0c:	83 ec 04             	sub    $0x4,%esp
  801a0f:	68 70 41 80 00       	push   $0x804170
  801a14:	68 a2 00 00 00       	push   $0xa2
  801a19:	68 f3 40 80 00       	push   $0x8040f3
  801a1e:	e8 be ec ff ff       	call   8006e1 <_panic>

00801a23 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801a23:	55                   	push   %ebp
  801a24:	89 e5                	mov    %esp,%ebp
  801a26:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801a29:	e8 f1 fc ff ff       	call   80171f <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801a2e:	83 ec 04             	sub    $0x4,%esp
  801a31:	68 94 41 80 00       	push   $0x804194
  801a36:	68 e6 00 00 00       	push   $0xe6
  801a3b:	68 f3 40 80 00       	push   $0x8040f3
  801a40:	e8 9c ec ff ff       	call   8006e1 <_panic>

00801a45 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801a45:	55                   	push   %ebp
  801a46:	89 e5                	mov    %esp,%ebp
  801a48:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801a4b:	83 ec 04             	sub    $0x4,%esp
  801a4e:	68 bc 41 80 00       	push   $0x8041bc
  801a53:	68 fa 00 00 00       	push   $0xfa
  801a58:	68 f3 40 80 00       	push   $0x8040f3
  801a5d:	e8 7f ec ff ff       	call   8006e1 <_panic>

00801a62 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801a62:	55                   	push   %ebp
  801a63:	89 e5                	mov    %esp,%ebp
  801a65:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a68:	83 ec 04             	sub    $0x4,%esp
  801a6b:	68 e0 41 80 00       	push   $0x8041e0
  801a70:	68 05 01 00 00       	push   $0x105
  801a75:	68 f3 40 80 00       	push   $0x8040f3
  801a7a:	e8 62 ec ff ff       	call   8006e1 <_panic>

00801a7f <shrink>:

}
void shrink(uint32 newSize)
{
  801a7f:	55                   	push   %ebp
  801a80:	89 e5                	mov    %esp,%ebp
  801a82:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a85:	83 ec 04             	sub    $0x4,%esp
  801a88:	68 e0 41 80 00       	push   $0x8041e0
  801a8d:	68 0a 01 00 00       	push   $0x10a
  801a92:	68 f3 40 80 00       	push   $0x8040f3
  801a97:	e8 45 ec ff ff       	call   8006e1 <_panic>

00801a9c <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801a9c:	55                   	push   %ebp
  801a9d:	89 e5                	mov    %esp,%ebp
  801a9f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801aa2:	83 ec 04             	sub    $0x4,%esp
  801aa5:	68 e0 41 80 00       	push   $0x8041e0
  801aaa:	68 0f 01 00 00       	push   $0x10f
  801aaf:	68 f3 40 80 00       	push   $0x8040f3
  801ab4:	e8 28 ec ff ff       	call   8006e1 <_panic>

00801ab9 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801ab9:	55                   	push   %ebp
  801aba:	89 e5                	mov    %esp,%ebp
  801abc:	57                   	push   %edi
  801abd:	56                   	push   %esi
  801abe:	53                   	push   %ebx
  801abf:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801ac2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ac8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801acb:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ace:	8b 7d 18             	mov    0x18(%ebp),%edi
  801ad1:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801ad4:	cd 30                	int    $0x30
  801ad6:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801ad9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801adc:	83 c4 10             	add    $0x10,%esp
  801adf:	5b                   	pop    %ebx
  801ae0:	5e                   	pop    %esi
  801ae1:	5f                   	pop    %edi
  801ae2:	5d                   	pop    %ebp
  801ae3:	c3                   	ret    

00801ae4 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801ae4:	55                   	push   %ebp
  801ae5:	89 e5                	mov    %esp,%ebp
  801ae7:	83 ec 04             	sub    $0x4,%esp
  801aea:	8b 45 10             	mov    0x10(%ebp),%eax
  801aed:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801af0:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801af4:	8b 45 08             	mov    0x8(%ebp),%eax
  801af7:	6a 00                	push   $0x0
  801af9:	6a 00                	push   $0x0
  801afb:	52                   	push   %edx
  801afc:	ff 75 0c             	pushl  0xc(%ebp)
  801aff:	50                   	push   %eax
  801b00:	6a 00                	push   $0x0
  801b02:	e8 b2 ff ff ff       	call   801ab9 <syscall>
  801b07:	83 c4 18             	add    $0x18,%esp
}
  801b0a:	90                   	nop
  801b0b:	c9                   	leave  
  801b0c:	c3                   	ret    

00801b0d <sys_cgetc>:

int
sys_cgetc(void)
{
  801b0d:	55                   	push   %ebp
  801b0e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801b10:	6a 00                	push   $0x0
  801b12:	6a 00                	push   $0x0
  801b14:	6a 00                	push   $0x0
  801b16:	6a 00                	push   $0x0
  801b18:	6a 00                	push   $0x0
  801b1a:	6a 01                	push   $0x1
  801b1c:	e8 98 ff ff ff       	call   801ab9 <syscall>
  801b21:	83 c4 18             	add    $0x18,%esp
}
  801b24:	c9                   	leave  
  801b25:	c3                   	ret    

00801b26 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801b26:	55                   	push   %ebp
  801b27:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801b29:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2f:	6a 00                	push   $0x0
  801b31:	6a 00                	push   $0x0
  801b33:	6a 00                	push   $0x0
  801b35:	52                   	push   %edx
  801b36:	50                   	push   %eax
  801b37:	6a 05                	push   $0x5
  801b39:	e8 7b ff ff ff       	call   801ab9 <syscall>
  801b3e:	83 c4 18             	add    $0x18,%esp
}
  801b41:	c9                   	leave  
  801b42:	c3                   	ret    

00801b43 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801b43:	55                   	push   %ebp
  801b44:	89 e5                	mov    %esp,%ebp
  801b46:	56                   	push   %esi
  801b47:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801b48:	8b 75 18             	mov    0x18(%ebp),%esi
  801b4b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b4e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b51:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b54:	8b 45 08             	mov    0x8(%ebp),%eax
  801b57:	56                   	push   %esi
  801b58:	53                   	push   %ebx
  801b59:	51                   	push   %ecx
  801b5a:	52                   	push   %edx
  801b5b:	50                   	push   %eax
  801b5c:	6a 06                	push   $0x6
  801b5e:	e8 56 ff ff ff       	call   801ab9 <syscall>
  801b63:	83 c4 18             	add    $0x18,%esp
}
  801b66:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b69:	5b                   	pop    %ebx
  801b6a:	5e                   	pop    %esi
  801b6b:	5d                   	pop    %ebp
  801b6c:	c3                   	ret    

00801b6d <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801b6d:	55                   	push   %ebp
  801b6e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801b70:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b73:	8b 45 08             	mov    0x8(%ebp),%eax
  801b76:	6a 00                	push   $0x0
  801b78:	6a 00                	push   $0x0
  801b7a:	6a 00                	push   $0x0
  801b7c:	52                   	push   %edx
  801b7d:	50                   	push   %eax
  801b7e:	6a 07                	push   $0x7
  801b80:	e8 34 ff ff ff       	call   801ab9 <syscall>
  801b85:	83 c4 18             	add    $0x18,%esp
}
  801b88:	c9                   	leave  
  801b89:	c3                   	ret    

00801b8a <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801b8a:	55                   	push   %ebp
  801b8b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801b8d:	6a 00                	push   $0x0
  801b8f:	6a 00                	push   $0x0
  801b91:	6a 00                	push   $0x0
  801b93:	ff 75 0c             	pushl  0xc(%ebp)
  801b96:	ff 75 08             	pushl  0x8(%ebp)
  801b99:	6a 08                	push   $0x8
  801b9b:	e8 19 ff ff ff       	call   801ab9 <syscall>
  801ba0:	83 c4 18             	add    $0x18,%esp
}
  801ba3:	c9                   	leave  
  801ba4:	c3                   	ret    

00801ba5 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801ba5:	55                   	push   %ebp
  801ba6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801ba8:	6a 00                	push   $0x0
  801baa:	6a 00                	push   $0x0
  801bac:	6a 00                	push   $0x0
  801bae:	6a 00                	push   $0x0
  801bb0:	6a 00                	push   $0x0
  801bb2:	6a 09                	push   $0x9
  801bb4:	e8 00 ff ff ff       	call   801ab9 <syscall>
  801bb9:	83 c4 18             	add    $0x18,%esp
}
  801bbc:	c9                   	leave  
  801bbd:	c3                   	ret    

00801bbe <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801bbe:	55                   	push   %ebp
  801bbf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801bc1:	6a 00                	push   $0x0
  801bc3:	6a 00                	push   $0x0
  801bc5:	6a 00                	push   $0x0
  801bc7:	6a 00                	push   $0x0
  801bc9:	6a 00                	push   $0x0
  801bcb:	6a 0a                	push   $0xa
  801bcd:	e8 e7 fe ff ff       	call   801ab9 <syscall>
  801bd2:	83 c4 18             	add    $0x18,%esp
}
  801bd5:	c9                   	leave  
  801bd6:	c3                   	ret    

00801bd7 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801bd7:	55                   	push   %ebp
  801bd8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801bda:	6a 00                	push   $0x0
  801bdc:	6a 00                	push   $0x0
  801bde:	6a 00                	push   $0x0
  801be0:	6a 00                	push   $0x0
  801be2:	6a 00                	push   $0x0
  801be4:	6a 0b                	push   $0xb
  801be6:	e8 ce fe ff ff       	call   801ab9 <syscall>
  801beb:	83 c4 18             	add    $0x18,%esp
}
  801bee:	c9                   	leave  
  801bef:	c3                   	ret    

00801bf0 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801bf0:	55                   	push   %ebp
  801bf1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801bf3:	6a 00                	push   $0x0
  801bf5:	6a 00                	push   $0x0
  801bf7:	6a 00                	push   $0x0
  801bf9:	ff 75 0c             	pushl  0xc(%ebp)
  801bfc:	ff 75 08             	pushl  0x8(%ebp)
  801bff:	6a 0f                	push   $0xf
  801c01:	e8 b3 fe ff ff       	call   801ab9 <syscall>
  801c06:	83 c4 18             	add    $0x18,%esp
	return;
  801c09:	90                   	nop
}
  801c0a:	c9                   	leave  
  801c0b:	c3                   	ret    

00801c0c <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801c0c:	55                   	push   %ebp
  801c0d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801c0f:	6a 00                	push   $0x0
  801c11:	6a 00                	push   $0x0
  801c13:	6a 00                	push   $0x0
  801c15:	ff 75 0c             	pushl  0xc(%ebp)
  801c18:	ff 75 08             	pushl  0x8(%ebp)
  801c1b:	6a 10                	push   $0x10
  801c1d:	e8 97 fe ff ff       	call   801ab9 <syscall>
  801c22:	83 c4 18             	add    $0x18,%esp
	return ;
  801c25:	90                   	nop
}
  801c26:	c9                   	leave  
  801c27:	c3                   	ret    

00801c28 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801c28:	55                   	push   %ebp
  801c29:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801c2b:	6a 00                	push   $0x0
  801c2d:	6a 00                	push   $0x0
  801c2f:	ff 75 10             	pushl  0x10(%ebp)
  801c32:	ff 75 0c             	pushl  0xc(%ebp)
  801c35:	ff 75 08             	pushl  0x8(%ebp)
  801c38:	6a 11                	push   $0x11
  801c3a:	e8 7a fe ff ff       	call   801ab9 <syscall>
  801c3f:	83 c4 18             	add    $0x18,%esp
	return ;
  801c42:	90                   	nop
}
  801c43:	c9                   	leave  
  801c44:	c3                   	ret    

00801c45 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801c45:	55                   	push   %ebp
  801c46:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801c48:	6a 00                	push   $0x0
  801c4a:	6a 00                	push   $0x0
  801c4c:	6a 00                	push   $0x0
  801c4e:	6a 00                	push   $0x0
  801c50:	6a 00                	push   $0x0
  801c52:	6a 0c                	push   $0xc
  801c54:	e8 60 fe ff ff       	call   801ab9 <syscall>
  801c59:	83 c4 18             	add    $0x18,%esp
}
  801c5c:	c9                   	leave  
  801c5d:	c3                   	ret    

00801c5e <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801c5e:	55                   	push   %ebp
  801c5f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801c61:	6a 00                	push   $0x0
  801c63:	6a 00                	push   $0x0
  801c65:	6a 00                	push   $0x0
  801c67:	6a 00                	push   $0x0
  801c69:	ff 75 08             	pushl  0x8(%ebp)
  801c6c:	6a 0d                	push   $0xd
  801c6e:	e8 46 fe ff ff       	call   801ab9 <syscall>
  801c73:	83 c4 18             	add    $0x18,%esp
}
  801c76:	c9                   	leave  
  801c77:	c3                   	ret    

00801c78 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801c78:	55                   	push   %ebp
  801c79:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801c7b:	6a 00                	push   $0x0
  801c7d:	6a 00                	push   $0x0
  801c7f:	6a 00                	push   $0x0
  801c81:	6a 00                	push   $0x0
  801c83:	6a 00                	push   $0x0
  801c85:	6a 0e                	push   $0xe
  801c87:	e8 2d fe ff ff       	call   801ab9 <syscall>
  801c8c:	83 c4 18             	add    $0x18,%esp
}
  801c8f:	90                   	nop
  801c90:	c9                   	leave  
  801c91:	c3                   	ret    

00801c92 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801c92:	55                   	push   %ebp
  801c93:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801c95:	6a 00                	push   $0x0
  801c97:	6a 00                	push   $0x0
  801c99:	6a 00                	push   $0x0
  801c9b:	6a 00                	push   $0x0
  801c9d:	6a 00                	push   $0x0
  801c9f:	6a 13                	push   $0x13
  801ca1:	e8 13 fe ff ff       	call   801ab9 <syscall>
  801ca6:	83 c4 18             	add    $0x18,%esp
}
  801ca9:	90                   	nop
  801caa:	c9                   	leave  
  801cab:	c3                   	ret    

00801cac <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801cac:	55                   	push   %ebp
  801cad:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801caf:	6a 00                	push   $0x0
  801cb1:	6a 00                	push   $0x0
  801cb3:	6a 00                	push   $0x0
  801cb5:	6a 00                	push   $0x0
  801cb7:	6a 00                	push   $0x0
  801cb9:	6a 14                	push   $0x14
  801cbb:	e8 f9 fd ff ff       	call   801ab9 <syscall>
  801cc0:	83 c4 18             	add    $0x18,%esp
}
  801cc3:	90                   	nop
  801cc4:	c9                   	leave  
  801cc5:	c3                   	ret    

00801cc6 <sys_cputc>:


void
sys_cputc(const char c)
{
  801cc6:	55                   	push   %ebp
  801cc7:	89 e5                	mov    %esp,%ebp
  801cc9:	83 ec 04             	sub    $0x4,%esp
  801ccc:	8b 45 08             	mov    0x8(%ebp),%eax
  801ccf:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801cd2:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801cd6:	6a 00                	push   $0x0
  801cd8:	6a 00                	push   $0x0
  801cda:	6a 00                	push   $0x0
  801cdc:	6a 00                	push   $0x0
  801cde:	50                   	push   %eax
  801cdf:	6a 15                	push   $0x15
  801ce1:	e8 d3 fd ff ff       	call   801ab9 <syscall>
  801ce6:	83 c4 18             	add    $0x18,%esp
}
  801ce9:	90                   	nop
  801cea:	c9                   	leave  
  801ceb:	c3                   	ret    

00801cec <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801cec:	55                   	push   %ebp
  801ced:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801cef:	6a 00                	push   $0x0
  801cf1:	6a 00                	push   $0x0
  801cf3:	6a 00                	push   $0x0
  801cf5:	6a 00                	push   $0x0
  801cf7:	6a 00                	push   $0x0
  801cf9:	6a 16                	push   $0x16
  801cfb:	e8 b9 fd ff ff       	call   801ab9 <syscall>
  801d00:	83 c4 18             	add    $0x18,%esp
}
  801d03:	90                   	nop
  801d04:	c9                   	leave  
  801d05:	c3                   	ret    

00801d06 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801d06:	55                   	push   %ebp
  801d07:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801d09:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0c:	6a 00                	push   $0x0
  801d0e:	6a 00                	push   $0x0
  801d10:	6a 00                	push   $0x0
  801d12:	ff 75 0c             	pushl  0xc(%ebp)
  801d15:	50                   	push   %eax
  801d16:	6a 17                	push   $0x17
  801d18:	e8 9c fd ff ff       	call   801ab9 <syscall>
  801d1d:	83 c4 18             	add    $0x18,%esp
}
  801d20:	c9                   	leave  
  801d21:	c3                   	ret    

00801d22 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801d22:	55                   	push   %ebp
  801d23:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d25:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d28:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2b:	6a 00                	push   $0x0
  801d2d:	6a 00                	push   $0x0
  801d2f:	6a 00                	push   $0x0
  801d31:	52                   	push   %edx
  801d32:	50                   	push   %eax
  801d33:	6a 1a                	push   $0x1a
  801d35:	e8 7f fd ff ff       	call   801ab9 <syscall>
  801d3a:	83 c4 18             	add    $0x18,%esp
}
  801d3d:	c9                   	leave  
  801d3e:	c3                   	ret    

00801d3f <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801d3f:	55                   	push   %ebp
  801d40:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d42:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d45:	8b 45 08             	mov    0x8(%ebp),%eax
  801d48:	6a 00                	push   $0x0
  801d4a:	6a 00                	push   $0x0
  801d4c:	6a 00                	push   $0x0
  801d4e:	52                   	push   %edx
  801d4f:	50                   	push   %eax
  801d50:	6a 18                	push   $0x18
  801d52:	e8 62 fd ff ff       	call   801ab9 <syscall>
  801d57:	83 c4 18             	add    $0x18,%esp
}
  801d5a:	90                   	nop
  801d5b:	c9                   	leave  
  801d5c:	c3                   	ret    

00801d5d <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801d5d:	55                   	push   %ebp
  801d5e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d60:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d63:	8b 45 08             	mov    0x8(%ebp),%eax
  801d66:	6a 00                	push   $0x0
  801d68:	6a 00                	push   $0x0
  801d6a:	6a 00                	push   $0x0
  801d6c:	52                   	push   %edx
  801d6d:	50                   	push   %eax
  801d6e:	6a 19                	push   $0x19
  801d70:	e8 44 fd ff ff       	call   801ab9 <syscall>
  801d75:	83 c4 18             	add    $0x18,%esp
}
  801d78:	90                   	nop
  801d79:	c9                   	leave  
  801d7a:	c3                   	ret    

00801d7b <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801d7b:	55                   	push   %ebp
  801d7c:	89 e5                	mov    %esp,%ebp
  801d7e:	83 ec 04             	sub    $0x4,%esp
  801d81:	8b 45 10             	mov    0x10(%ebp),%eax
  801d84:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801d87:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801d8a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801d8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d91:	6a 00                	push   $0x0
  801d93:	51                   	push   %ecx
  801d94:	52                   	push   %edx
  801d95:	ff 75 0c             	pushl  0xc(%ebp)
  801d98:	50                   	push   %eax
  801d99:	6a 1b                	push   $0x1b
  801d9b:	e8 19 fd ff ff       	call   801ab9 <syscall>
  801da0:	83 c4 18             	add    $0x18,%esp
}
  801da3:	c9                   	leave  
  801da4:	c3                   	ret    

00801da5 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801da5:	55                   	push   %ebp
  801da6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801da8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dab:	8b 45 08             	mov    0x8(%ebp),%eax
  801dae:	6a 00                	push   $0x0
  801db0:	6a 00                	push   $0x0
  801db2:	6a 00                	push   $0x0
  801db4:	52                   	push   %edx
  801db5:	50                   	push   %eax
  801db6:	6a 1c                	push   $0x1c
  801db8:	e8 fc fc ff ff       	call   801ab9 <syscall>
  801dbd:	83 c4 18             	add    $0x18,%esp
}
  801dc0:	c9                   	leave  
  801dc1:	c3                   	ret    

00801dc2 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801dc2:	55                   	push   %ebp
  801dc3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801dc5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801dc8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dcb:	8b 45 08             	mov    0x8(%ebp),%eax
  801dce:	6a 00                	push   $0x0
  801dd0:	6a 00                	push   $0x0
  801dd2:	51                   	push   %ecx
  801dd3:	52                   	push   %edx
  801dd4:	50                   	push   %eax
  801dd5:	6a 1d                	push   $0x1d
  801dd7:	e8 dd fc ff ff       	call   801ab9 <syscall>
  801ddc:	83 c4 18             	add    $0x18,%esp
}
  801ddf:	c9                   	leave  
  801de0:	c3                   	ret    

00801de1 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801de1:	55                   	push   %ebp
  801de2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801de4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801de7:	8b 45 08             	mov    0x8(%ebp),%eax
  801dea:	6a 00                	push   $0x0
  801dec:	6a 00                	push   $0x0
  801dee:	6a 00                	push   $0x0
  801df0:	52                   	push   %edx
  801df1:	50                   	push   %eax
  801df2:	6a 1e                	push   $0x1e
  801df4:	e8 c0 fc ff ff       	call   801ab9 <syscall>
  801df9:	83 c4 18             	add    $0x18,%esp
}
  801dfc:	c9                   	leave  
  801dfd:	c3                   	ret    

00801dfe <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801dfe:	55                   	push   %ebp
  801dff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801e01:	6a 00                	push   $0x0
  801e03:	6a 00                	push   $0x0
  801e05:	6a 00                	push   $0x0
  801e07:	6a 00                	push   $0x0
  801e09:	6a 00                	push   $0x0
  801e0b:	6a 1f                	push   $0x1f
  801e0d:	e8 a7 fc ff ff       	call   801ab9 <syscall>
  801e12:	83 c4 18             	add    $0x18,%esp
}
  801e15:	c9                   	leave  
  801e16:	c3                   	ret    

00801e17 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801e17:	55                   	push   %ebp
  801e18:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801e1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e1d:	6a 00                	push   $0x0
  801e1f:	ff 75 14             	pushl  0x14(%ebp)
  801e22:	ff 75 10             	pushl  0x10(%ebp)
  801e25:	ff 75 0c             	pushl  0xc(%ebp)
  801e28:	50                   	push   %eax
  801e29:	6a 20                	push   $0x20
  801e2b:	e8 89 fc ff ff       	call   801ab9 <syscall>
  801e30:	83 c4 18             	add    $0x18,%esp
}
  801e33:	c9                   	leave  
  801e34:	c3                   	ret    

00801e35 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801e35:	55                   	push   %ebp
  801e36:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801e38:	8b 45 08             	mov    0x8(%ebp),%eax
  801e3b:	6a 00                	push   $0x0
  801e3d:	6a 00                	push   $0x0
  801e3f:	6a 00                	push   $0x0
  801e41:	6a 00                	push   $0x0
  801e43:	50                   	push   %eax
  801e44:	6a 21                	push   $0x21
  801e46:	e8 6e fc ff ff       	call   801ab9 <syscall>
  801e4b:	83 c4 18             	add    $0x18,%esp
}
  801e4e:	90                   	nop
  801e4f:	c9                   	leave  
  801e50:	c3                   	ret    

00801e51 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801e51:	55                   	push   %ebp
  801e52:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801e54:	8b 45 08             	mov    0x8(%ebp),%eax
  801e57:	6a 00                	push   $0x0
  801e59:	6a 00                	push   $0x0
  801e5b:	6a 00                	push   $0x0
  801e5d:	6a 00                	push   $0x0
  801e5f:	50                   	push   %eax
  801e60:	6a 22                	push   $0x22
  801e62:	e8 52 fc ff ff       	call   801ab9 <syscall>
  801e67:	83 c4 18             	add    $0x18,%esp
}
  801e6a:	c9                   	leave  
  801e6b:	c3                   	ret    

00801e6c <sys_getenvid>:

int32 sys_getenvid(void)
{
  801e6c:	55                   	push   %ebp
  801e6d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801e6f:	6a 00                	push   $0x0
  801e71:	6a 00                	push   $0x0
  801e73:	6a 00                	push   $0x0
  801e75:	6a 00                	push   $0x0
  801e77:	6a 00                	push   $0x0
  801e79:	6a 02                	push   $0x2
  801e7b:	e8 39 fc ff ff       	call   801ab9 <syscall>
  801e80:	83 c4 18             	add    $0x18,%esp
}
  801e83:	c9                   	leave  
  801e84:	c3                   	ret    

00801e85 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801e85:	55                   	push   %ebp
  801e86:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801e88:	6a 00                	push   $0x0
  801e8a:	6a 00                	push   $0x0
  801e8c:	6a 00                	push   $0x0
  801e8e:	6a 00                	push   $0x0
  801e90:	6a 00                	push   $0x0
  801e92:	6a 03                	push   $0x3
  801e94:	e8 20 fc ff ff       	call   801ab9 <syscall>
  801e99:	83 c4 18             	add    $0x18,%esp
}
  801e9c:	c9                   	leave  
  801e9d:	c3                   	ret    

00801e9e <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801e9e:	55                   	push   %ebp
  801e9f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801ea1:	6a 00                	push   $0x0
  801ea3:	6a 00                	push   $0x0
  801ea5:	6a 00                	push   $0x0
  801ea7:	6a 00                	push   $0x0
  801ea9:	6a 00                	push   $0x0
  801eab:	6a 04                	push   $0x4
  801ead:	e8 07 fc ff ff       	call   801ab9 <syscall>
  801eb2:	83 c4 18             	add    $0x18,%esp
}
  801eb5:	c9                   	leave  
  801eb6:	c3                   	ret    

00801eb7 <sys_exit_env>:


void sys_exit_env(void)
{
  801eb7:	55                   	push   %ebp
  801eb8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801eba:	6a 00                	push   $0x0
  801ebc:	6a 00                	push   $0x0
  801ebe:	6a 00                	push   $0x0
  801ec0:	6a 00                	push   $0x0
  801ec2:	6a 00                	push   $0x0
  801ec4:	6a 23                	push   $0x23
  801ec6:	e8 ee fb ff ff       	call   801ab9 <syscall>
  801ecb:	83 c4 18             	add    $0x18,%esp
}
  801ece:	90                   	nop
  801ecf:	c9                   	leave  
  801ed0:	c3                   	ret    

00801ed1 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801ed1:	55                   	push   %ebp
  801ed2:	89 e5                	mov    %esp,%ebp
  801ed4:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801ed7:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801eda:	8d 50 04             	lea    0x4(%eax),%edx
  801edd:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ee0:	6a 00                	push   $0x0
  801ee2:	6a 00                	push   $0x0
  801ee4:	6a 00                	push   $0x0
  801ee6:	52                   	push   %edx
  801ee7:	50                   	push   %eax
  801ee8:	6a 24                	push   $0x24
  801eea:	e8 ca fb ff ff       	call   801ab9 <syscall>
  801eef:	83 c4 18             	add    $0x18,%esp
	return result;
  801ef2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ef5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ef8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801efb:	89 01                	mov    %eax,(%ecx)
  801efd:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801f00:	8b 45 08             	mov    0x8(%ebp),%eax
  801f03:	c9                   	leave  
  801f04:	c2 04 00             	ret    $0x4

00801f07 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801f07:	55                   	push   %ebp
  801f08:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801f0a:	6a 00                	push   $0x0
  801f0c:	6a 00                	push   $0x0
  801f0e:	ff 75 10             	pushl  0x10(%ebp)
  801f11:	ff 75 0c             	pushl  0xc(%ebp)
  801f14:	ff 75 08             	pushl  0x8(%ebp)
  801f17:	6a 12                	push   $0x12
  801f19:	e8 9b fb ff ff       	call   801ab9 <syscall>
  801f1e:	83 c4 18             	add    $0x18,%esp
	return ;
  801f21:	90                   	nop
}
  801f22:	c9                   	leave  
  801f23:	c3                   	ret    

00801f24 <sys_rcr2>:
uint32 sys_rcr2()
{
  801f24:	55                   	push   %ebp
  801f25:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801f27:	6a 00                	push   $0x0
  801f29:	6a 00                	push   $0x0
  801f2b:	6a 00                	push   $0x0
  801f2d:	6a 00                	push   $0x0
  801f2f:	6a 00                	push   $0x0
  801f31:	6a 25                	push   $0x25
  801f33:	e8 81 fb ff ff       	call   801ab9 <syscall>
  801f38:	83 c4 18             	add    $0x18,%esp
}
  801f3b:	c9                   	leave  
  801f3c:	c3                   	ret    

00801f3d <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801f3d:	55                   	push   %ebp
  801f3e:	89 e5                	mov    %esp,%ebp
  801f40:	83 ec 04             	sub    $0x4,%esp
  801f43:	8b 45 08             	mov    0x8(%ebp),%eax
  801f46:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801f49:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801f4d:	6a 00                	push   $0x0
  801f4f:	6a 00                	push   $0x0
  801f51:	6a 00                	push   $0x0
  801f53:	6a 00                	push   $0x0
  801f55:	50                   	push   %eax
  801f56:	6a 26                	push   $0x26
  801f58:	e8 5c fb ff ff       	call   801ab9 <syscall>
  801f5d:	83 c4 18             	add    $0x18,%esp
	return ;
  801f60:	90                   	nop
}
  801f61:	c9                   	leave  
  801f62:	c3                   	ret    

00801f63 <rsttst>:
void rsttst()
{
  801f63:	55                   	push   %ebp
  801f64:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801f66:	6a 00                	push   $0x0
  801f68:	6a 00                	push   $0x0
  801f6a:	6a 00                	push   $0x0
  801f6c:	6a 00                	push   $0x0
  801f6e:	6a 00                	push   $0x0
  801f70:	6a 28                	push   $0x28
  801f72:	e8 42 fb ff ff       	call   801ab9 <syscall>
  801f77:	83 c4 18             	add    $0x18,%esp
	return ;
  801f7a:	90                   	nop
}
  801f7b:	c9                   	leave  
  801f7c:	c3                   	ret    

00801f7d <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801f7d:	55                   	push   %ebp
  801f7e:	89 e5                	mov    %esp,%ebp
  801f80:	83 ec 04             	sub    $0x4,%esp
  801f83:	8b 45 14             	mov    0x14(%ebp),%eax
  801f86:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801f89:	8b 55 18             	mov    0x18(%ebp),%edx
  801f8c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801f90:	52                   	push   %edx
  801f91:	50                   	push   %eax
  801f92:	ff 75 10             	pushl  0x10(%ebp)
  801f95:	ff 75 0c             	pushl  0xc(%ebp)
  801f98:	ff 75 08             	pushl  0x8(%ebp)
  801f9b:	6a 27                	push   $0x27
  801f9d:	e8 17 fb ff ff       	call   801ab9 <syscall>
  801fa2:	83 c4 18             	add    $0x18,%esp
	return ;
  801fa5:	90                   	nop
}
  801fa6:	c9                   	leave  
  801fa7:	c3                   	ret    

00801fa8 <chktst>:
void chktst(uint32 n)
{
  801fa8:	55                   	push   %ebp
  801fa9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801fab:	6a 00                	push   $0x0
  801fad:	6a 00                	push   $0x0
  801faf:	6a 00                	push   $0x0
  801fb1:	6a 00                	push   $0x0
  801fb3:	ff 75 08             	pushl  0x8(%ebp)
  801fb6:	6a 29                	push   $0x29
  801fb8:	e8 fc fa ff ff       	call   801ab9 <syscall>
  801fbd:	83 c4 18             	add    $0x18,%esp
	return ;
  801fc0:	90                   	nop
}
  801fc1:	c9                   	leave  
  801fc2:	c3                   	ret    

00801fc3 <inctst>:

void inctst()
{
  801fc3:	55                   	push   %ebp
  801fc4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801fc6:	6a 00                	push   $0x0
  801fc8:	6a 00                	push   $0x0
  801fca:	6a 00                	push   $0x0
  801fcc:	6a 00                	push   $0x0
  801fce:	6a 00                	push   $0x0
  801fd0:	6a 2a                	push   $0x2a
  801fd2:	e8 e2 fa ff ff       	call   801ab9 <syscall>
  801fd7:	83 c4 18             	add    $0x18,%esp
	return ;
  801fda:	90                   	nop
}
  801fdb:	c9                   	leave  
  801fdc:	c3                   	ret    

00801fdd <gettst>:
uint32 gettst()
{
  801fdd:	55                   	push   %ebp
  801fde:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801fe0:	6a 00                	push   $0x0
  801fe2:	6a 00                	push   $0x0
  801fe4:	6a 00                	push   $0x0
  801fe6:	6a 00                	push   $0x0
  801fe8:	6a 00                	push   $0x0
  801fea:	6a 2b                	push   $0x2b
  801fec:	e8 c8 fa ff ff       	call   801ab9 <syscall>
  801ff1:	83 c4 18             	add    $0x18,%esp
}
  801ff4:	c9                   	leave  
  801ff5:	c3                   	ret    

00801ff6 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801ff6:	55                   	push   %ebp
  801ff7:	89 e5                	mov    %esp,%ebp
  801ff9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ffc:	6a 00                	push   $0x0
  801ffe:	6a 00                	push   $0x0
  802000:	6a 00                	push   $0x0
  802002:	6a 00                	push   $0x0
  802004:	6a 00                	push   $0x0
  802006:	6a 2c                	push   $0x2c
  802008:	e8 ac fa ff ff       	call   801ab9 <syscall>
  80200d:	83 c4 18             	add    $0x18,%esp
  802010:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802013:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802017:	75 07                	jne    802020 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802019:	b8 01 00 00 00       	mov    $0x1,%eax
  80201e:	eb 05                	jmp    802025 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802020:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802025:	c9                   	leave  
  802026:	c3                   	ret    

00802027 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802027:	55                   	push   %ebp
  802028:	89 e5                	mov    %esp,%ebp
  80202a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80202d:	6a 00                	push   $0x0
  80202f:	6a 00                	push   $0x0
  802031:	6a 00                	push   $0x0
  802033:	6a 00                	push   $0x0
  802035:	6a 00                	push   $0x0
  802037:	6a 2c                	push   $0x2c
  802039:	e8 7b fa ff ff       	call   801ab9 <syscall>
  80203e:	83 c4 18             	add    $0x18,%esp
  802041:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802044:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802048:	75 07                	jne    802051 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80204a:	b8 01 00 00 00       	mov    $0x1,%eax
  80204f:	eb 05                	jmp    802056 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802051:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802056:	c9                   	leave  
  802057:	c3                   	ret    

00802058 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802058:	55                   	push   %ebp
  802059:	89 e5                	mov    %esp,%ebp
  80205b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80205e:	6a 00                	push   $0x0
  802060:	6a 00                	push   $0x0
  802062:	6a 00                	push   $0x0
  802064:	6a 00                	push   $0x0
  802066:	6a 00                	push   $0x0
  802068:	6a 2c                	push   $0x2c
  80206a:	e8 4a fa ff ff       	call   801ab9 <syscall>
  80206f:	83 c4 18             	add    $0x18,%esp
  802072:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802075:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802079:	75 07                	jne    802082 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80207b:	b8 01 00 00 00       	mov    $0x1,%eax
  802080:	eb 05                	jmp    802087 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802082:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802087:	c9                   	leave  
  802088:	c3                   	ret    

00802089 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802089:	55                   	push   %ebp
  80208a:	89 e5                	mov    %esp,%ebp
  80208c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80208f:	6a 00                	push   $0x0
  802091:	6a 00                	push   $0x0
  802093:	6a 00                	push   $0x0
  802095:	6a 00                	push   $0x0
  802097:	6a 00                	push   $0x0
  802099:	6a 2c                	push   $0x2c
  80209b:	e8 19 fa ff ff       	call   801ab9 <syscall>
  8020a0:	83 c4 18             	add    $0x18,%esp
  8020a3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8020a6:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8020aa:	75 07                	jne    8020b3 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8020ac:	b8 01 00 00 00       	mov    $0x1,%eax
  8020b1:	eb 05                	jmp    8020b8 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8020b3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020b8:	c9                   	leave  
  8020b9:	c3                   	ret    

008020ba <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8020ba:	55                   	push   %ebp
  8020bb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8020bd:	6a 00                	push   $0x0
  8020bf:	6a 00                	push   $0x0
  8020c1:	6a 00                	push   $0x0
  8020c3:	6a 00                	push   $0x0
  8020c5:	ff 75 08             	pushl  0x8(%ebp)
  8020c8:	6a 2d                	push   $0x2d
  8020ca:	e8 ea f9 ff ff       	call   801ab9 <syscall>
  8020cf:	83 c4 18             	add    $0x18,%esp
	return ;
  8020d2:	90                   	nop
}
  8020d3:	c9                   	leave  
  8020d4:	c3                   	ret    

008020d5 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8020d5:	55                   	push   %ebp
  8020d6:	89 e5                	mov    %esp,%ebp
  8020d8:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8020d9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8020dc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8020df:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e5:	6a 00                	push   $0x0
  8020e7:	53                   	push   %ebx
  8020e8:	51                   	push   %ecx
  8020e9:	52                   	push   %edx
  8020ea:	50                   	push   %eax
  8020eb:	6a 2e                	push   $0x2e
  8020ed:	e8 c7 f9 ff ff       	call   801ab9 <syscall>
  8020f2:	83 c4 18             	add    $0x18,%esp
}
  8020f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020f8:	c9                   	leave  
  8020f9:	c3                   	ret    

008020fa <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8020fa:	55                   	push   %ebp
  8020fb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8020fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  802100:	8b 45 08             	mov    0x8(%ebp),%eax
  802103:	6a 00                	push   $0x0
  802105:	6a 00                	push   $0x0
  802107:	6a 00                	push   $0x0
  802109:	52                   	push   %edx
  80210a:	50                   	push   %eax
  80210b:	6a 2f                	push   $0x2f
  80210d:	e8 a7 f9 ff ff       	call   801ab9 <syscall>
  802112:	83 c4 18             	add    $0x18,%esp
}
  802115:	c9                   	leave  
  802116:	c3                   	ret    

00802117 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802117:	55                   	push   %ebp
  802118:	89 e5                	mov    %esp,%ebp
  80211a:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  80211d:	83 ec 0c             	sub    $0xc,%esp
  802120:	68 f0 41 80 00       	push   $0x8041f0
  802125:	e8 6b e8 ff ff       	call   800995 <cprintf>
  80212a:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  80212d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802134:	83 ec 0c             	sub    $0xc,%esp
  802137:	68 1c 42 80 00       	push   $0x80421c
  80213c:	e8 54 e8 ff ff       	call   800995 <cprintf>
  802141:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802144:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802148:	a1 38 51 80 00       	mov    0x805138,%eax
  80214d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802150:	eb 56                	jmp    8021a8 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802152:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802156:	74 1c                	je     802174 <print_mem_block_lists+0x5d>
  802158:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80215b:	8b 50 08             	mov    0x8(%eax),%edx
  80215e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802161:	8b 48 08             	mov    0x8(%eax),%ecx
  802164:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802167:	8b 40 0c             	mov    0xc(%eax),%eax
  80216a:	01 c8                	add    %ecx,%eax
  80216c:	39 c2                	cmp    %eax,%edx
  80216e:	73 04                	jae    802174 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802170:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802174:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802177:	8b 50 08             	mov    0x8(%eax),%edx
  80217a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80217d:	8b 40 0c             	mov    0xc(%eax),%eax
  802180:	01 c2                	add    %eax,%edx
  802182:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802185:	8b 40 08             	mov    0x8(%eax),%eax
  802188:	83 ec 04             	sub    $0x4,%esp
  80218b:	52                   	push   %edx
  80218c:	50                   	push   %eax
  80218d:	68 31 42 80 00       	push   $0x804231
  802192:	e8 fe e7 ff ff       	call   800995 <cprintf>
  802197:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80219a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80219d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8021a0:	a1 40 51 80 00       	mov    0x805140,%eax
  8021a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021a8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021ac:	74 07                	je     8021b5 <print_mem_block_lists+0x9e>
  8021ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b1:	8b 00                	mov    (%eax),%eax
  8021b3:	eb 05                	jmp    8021ba <print_mem_block_lists+0xa3>
  8021b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8021ba:	a3 40 51 80 00       	mov    %eax,0x805140
  8021bf:	a1 40 51 80 00       	mov    0x805140,%eax
  8021c4:	85 c0                	test   %eax,%eax
  8021c6:	75 8a                	jne    802152 <print_mem_block_lists+0x3b>
  8021c8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021cc:	75 84                	jne    802152 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8021ce:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8021d2:	75 10                	jne    8021e4 <print_mem_block_lists+0xcd>
  8021d4:	83 ec 0c             	sub    $0xc,%esp
  8021d7:	68 40 42 80 00       	push   $0x804240
  8021dc:	e8 b4 e7 ff ff       	call   800995 <cprintf>
  8021e1:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8021e4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8021eb:	83 ec 0c             	sub    $0xc,%esp
  8021ee:	68 64 42 80 00       	push   $0x804264
  8021f3:	e8 9d e7 ff ff       	call   800995 <cprintf>
  8021f8:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8021fb:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8021ff:	a1 40 50 80 00       	mov    0x805040,%eax
  802204:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802207:	eb 56                	jmp    80225f <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802209:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80220d:	74 1c                	je     80222b <print_mem_block_lists+0x114>
  80220f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802212:	8b 50 08             	mov    0x8(%eax),%edx
  802215:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802218:	8b 48 08             	mov    0x8(%eax),%ecx
  80221b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80221e:	8b 40 0c             	mov    0xc(%eax),%eax
  802221:	01 c8                	add    %ecx,%eax
  802223:	39 c2                	cmp    %eax,%edx
  802225:	73 04                	jae    80222b <print_mem_block_lists+0x114>
			sorted = 0 ;
  802227:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80222b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80222e:	8b 50 08             	mov    0x8(%eax),%edx
  802231:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802234:	8b 40 0c             	mov    0xc(%eax),%eax
  802237:	01 c2                	add    %eax,%edx
  802239:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80223c:	8b 40 08             	mov    0x8(%eax),%eax
  80223f:	83 ec 04             	sub    $0x4,%esp
  802242:	52                   	push   %edx
  802243:	50                   	push   %eax
  802244:	68 31 42 80 00       	push   $0x804231
  802249:	e8 47 e7 ff ff       	call   800995 <cprintf>
  80224e:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802251:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802254:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802257:	a1 48 50 80 00       	mov    0x805048,%eax
  80225c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80225f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802263:	74 07                	je     80226c <print_mem_block_lists+0x155>
  802265:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802268:	8b 00                	mov    (%eax),%eax
  80226a:	eb 05                	jmp    802271 <print_mem_block_lists+0x15a>
  80226c:	b8 00 00 00 00       	mov    $0x0,%eax
  802271:	a3 48 50 80 00       	mov    %eax,0x805048
  802276:	a1 48 50 80 00       	mov    0x805048,%eax
  80227b:	85 c0                	test   %eax,%eax
  80227d:	75 8a                	jne    802209 <print_mem_block_lists+0xf2>
  80227f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802283:	75 84                	jne    802209 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802285:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802289:	75 10                	jne    80229b <print_mem_block_lists+0x184>
  80228b:	83 ec 0c             	sub    $0xc,%esp
  80228e:	68 7c 42 80 00       	push   $0x80427c
  802293:	e8 fd e6 ff ff       	call   800995 <cprintf>
  802298:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  80229b:	83 ec 0c             	sub    $0xc,%esp
  80229e:	68 f0 41 80 00       	push   $0x8041f0
  8022a3:	e8 ed e6 ff ff       	call   800995 <cprintf>
  8022a8:	83 c4 10             	add    $0x10,%esp

}
  8022ab:	90                   	nop
  8022ac:	c9                   	leave  
  8022ad:	c3                   	ret    

008022ae <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8022ae:	55                   	push   %ebp
  8022af:	89 e5                	mov    %esp,%ebp
  8022b1:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  8022b4:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  8022bb:	00 00 00 
  8022be:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  8022c5:	00 00 00 
  8022c8:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  8022cf:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  8022d2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8022d9:	e9 9e 00 00 00       	jmp    80237c <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  8022de:	a1 50 50 80 00       	mov    0x805050,%eax
  8022e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022e6:	c1 e2 04             	shl    $0x4,%edx
  8022e9:	01 d0                	add    %edx,%eax
  8022eb:	85 c0                	test   %eax,%eax
  8022ed:	75 14                	jne    802303 <initialize_MemBlocksList+0x55>
  8022ef:	83 ec 04             	sub    $0x4,%esp
  8022f2:	68 a4 42 80 00       	push   $0x8042a4
  8022f7:	6a 46                	push   $0x46
  8022f9:	68 c7 42 80 00       	push   $0x8042c7
  8022fe:	e8 de e3 ff ff       	call   8006e1 <_panic>
  802303:	a1 50 50 80 00       	mov    0x805050,%eax
  802308:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80230b:	c1 e2 04             	shl    $0x4,%edx
  80230e:	01 d0                	add    %edx,%eax
  802310:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802316:	89 10                	mov    %edx,(%eax)
  802318:	8b 00                	mov    (%eax),%eax
  80231a:	85 c0                	test   %eax,%eax
  80231c:	74 18                	je     802336 <initialize_MemBlocksList+0x88>
  80231e:	a1 48 51 80 00       	mov    0x805148,%eax
  802323:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802329:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80232c:	c1 e1 04             	shl    $0x4,%ecx
  80232f:	01 ca                	add    %ecx,%edx
  802331:	89 50 04             	mov    %edx,0x4(%eax)
  802334:	eb 12                	jmp    802348 <initialize_MemBlocksList+0x9a>
  802336:	a1 50 50 80 00       	mov    0x805050,%eax
  80233b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80233e:	c1 e2 04             	shl    $0x4,%edx
  802341:	01 d0                	add    %edx,%eax
  802343:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802348:	a1 50 50 80 00       	mov    0x805050,%eax
  80234d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802350:	c1 e2 04             	shl    $0x4,%edx
  802353:	01 d0                	add    %edx,%eax
  802355:	a3 48 51 80 00       	mov    %eax,0x805148
  80235a:	a1 50 50 80 00       	mov    0x805050,%eax
  80235f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802362:	c1 e2 04             	shl    $0x4,%edx
  802365:	01 d0                	add    %edx,%eax
  802367:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80236e:	a1 54 51 80 00       	mov    0x805154,%eax
  802373:	40                   	inc    %eax
  802374:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  802379:	ff 45 f4             	incl   -0xc(%ebp)
  80237c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802382:	0f 82 56 ff ff ff    	jb     8022de <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  802388:	90                   	nop
  802389:	c9                   	leave  
  80238a:	c3                   	ret    

0080238b <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80238b:	55                   	push   %ebp
  80238c:	89 e5                	mov    %esp,%ebp
  80238e:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802391:	8b 45 08             	mov    0x8(%ebp),%eax
  802394:	8b 00                	mov    (%eax),%eax
  802396:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802399:	eb 19                	jmp    8023b4 <find_block+0x29>
	{
		if(va==point->sva)
  80239b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80239e:	8b 40 08             	mov    0x8(%eax),%eax
  8023a1:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8023a4:	75 05                	jne    8023ab <find_block+0x20>
		   return point;
  8023a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8023a9:	eb 36                	jmp    8023e1 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8023ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ae:	8b 40 08             	mov    0x8(%eax),%eax
  8023b1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8023b4:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8023b8:	74 07                	je     8023c1 <find_block+0x36>
  8023ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8023bd:	8b 00                	mov    (%eax),%eax
  8023bf:	eb 05                	jmp    8023c6 <find_block+0x3b>
  8023c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8023c6:	8b 55 08             	mov    0x8(%ebp),%edx
  8023c9:	89 42 08             	mov    %eax,0x8(%edx)
  8023cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8023cf:	8b 40 08             	mov    0x8(%eax),%eax
  8023d2:	85 c0                	test   %eax,%eax
  8023d4:	75 c5                	jne    80239b <find_block+0x10>
  8023d6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8023da:	75 bf                	jne    80239b <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  8023dc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023e1:	c9                   	leave  
  8023e2:	c3                   	ret    

008023e3 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8023e3:	55                   	push   %ebp
  8023e4:	89 e5                	mov    %esp,%ebp
  8023e6:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  8023e9:	a1 40 50 80 00       	mov    0x805040,%eax
  8023ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  8023f1:	a1 44 50 80 00       	mov    0x805044,%eax
  8023f6:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  8023f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023fc:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8023ff:	74 24                	je     802425 <insert_sorted_allocList+0x42>
  802401:	8b 45 08             	mov    0x8(%ebp),%eax
  802404:	8b 50 08             	mov    0x8(%eax),%edx
  802407:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80240a:	8b 40 08             	mov    0x8(%eax),%eax
  80240d:	39 c2                	cmp    %eax,%edx
  80240f:	76 14                	jbe    802425 <insert_sorted_allocList+0x42>
  802411:	8b 45 08             	mov    0x8(%ebp),%eax
  802414:	8b 50 08             	mov    0x8(%eax),%edx
  802417:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80241a:	8b 40 08             	mov    0x8(%eax),%eax
  80241d:	39 c2                	cmp    %eax,%edx
  80241f:	0f 82 60 01 00 00    	jb     802585 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802425:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802429:	75 65                	jne    802490 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  80242b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80242f:	75 14                	jne    802445 <insert_sorted_allocList+0x62>
  802431:	83 ec 04             	sub    $0x4,%esp
  802434:	68 a4 42 80 00       	push   $0x8042a4
  802439:	6a 6b                	push   $0x6b
  80243b:	68 c7 42 80 00       	push   $0x8042c7
  802440:	e8 9c e2 ff ff       	call   8006e1 <_panic>
  802445:	8b 15 40 50 80 00    	mov    0x805040,%edx
  80244b:	8b 45 08             	mov    0x8(%ebp),%eax
  80244e:	89 10                	mov    %edx,(%eax)
  802450:	8b 45 08             	mov    0x8(%ebp),%eax
  802453:	8b 00                	mov    (%eax),%eax
  802455:	85 c0                	test   %eax,%eax
  802457:	74 0d                	je     802466 <insert_sorted_allocList+0x83>
  802459:	a1 40 50 80 00       	mov    0x805040,%eax
  80245e:	8b 55 08             	mov    0x8(%ebp),%edx
  802461:	89 50 04             	mov    %edx,0x4(%eax)
  802464:	eb 08                	jmp    80246e <insert_sorted_allocList+0x8b>
  802466:	8b 45 08             	mov    0x8(%ebp),%eax
  802469:	a3 44 50 80 00       	mov    %eax,0x805044
  80246e:	8b 45 08             	mov    0x8(%ebp),%eax
  802471:	a3 40 50 80 00       	mov    %eax,0x805040
  802476:	8b 45 08             	mov    0x8(%ebp),%eax
  802479:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802480:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802485:	40                   	inc    %eax
  802486:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80248b:	e9 dc 01 00 00       	jmp    80266c <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802490:	8b 45 08             	mov    0x8(%ebp),%eax
  802493:	8b 50 08             	mov    0x8(%eax),%edx
  802496:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802499:	8b 40 08             	mov    0x8(%eax),%eax
  80249c:	39 c2                	cmp    %eax,%edx
  80249e:	77 6c                	ja     80250c <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  8024a0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8024a4:	74 06                	je     8024ac <insert_sorted_allocList+0xc9>
  8024a6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8024aa:	75 14                	jne    8024c0 <insert_sorted_allocList+0xdd>
  8024ac:	83 ec 04             	sub    $0x4,%esp
  8024af:	68 e0 42 80 00       	push   $0x8042e0
  8024b4:	6a 6f                	push   $0x6f
  8024b6:	68 c7 42 80 00       	push   $0x8042c7
  8024bb:	e8 21 e2 ff ff       	call   8006e1 <_panic>
  8024c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024c3:	8b 50 04             	mov    0x4(%eax),%edx
  8024c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c9:	89 50 04             	mov    %edx,0x4(%eax)
  8024cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8024cf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024d2:	89 10                	mov    %edx,(%eax)
  8024d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024d7:	8b 40 04             	mov    0x4(%eax),%eax
  8024da:	85 c0                	test   %eax,%eax
  8024dc:	74 0d                	je     8024eb <insert_sorted_allocList+0x108>
  8024de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024e1:	8b 40 04             	mov    0x4(%eax),%eax
  8024e4:	8b 55 08             	mov    0x8(%ebp),%edx
  8024e7:	89 10                	mov    %edx,(%eax)
  8024e9:	eb 08                	jmp    8024f3 <insert_sorted_allocList+0x110>
  8024eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ee:	a3 40 50 80 00       	mov    %eax,0x805040
  8024f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024f6:	8b 55 08             	mov    0x8(%ebp),%edx
  8024f9:	89 50 04             	mov    %edx,0x4(%eax)
  8024fc:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802501:	40                   	inc    %eax
  802502:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802507:	e9 60 01 00 00       	jmp    80266c <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  80250c:	8b 45 08             	mov    0x8(%ebp),%eax
  80250f:	8b 50 08             	mov    0x8(%eax),%edx
  802512:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802515:	8b 40 08             	mov    0x8(%eax),%eax
  802518:	39 c2                	cmp    %eax,%edx
  80251a:	0f 82 4c 01 00 00    	jb     80266c <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802520:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802524:	75 14                	jne    80253a <insert_sorted_allocList+0x157>
  802526:	83 ec 04             	sub    $0x4,%esp
  802529:	68 18 43 80 00       	push   $0x804318
  80252e:	6a 73                	push   $0x73
  802530:	68 c7 42 80 00       	push   $0x8042c7
  802535:	e8 a7 e1 ff ff       	call   8006e1 <_panic>
  80253a:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802540:	8b 45 08             	mov    0x8(%ebp),%eax
  802543:	89 50 04             	mov    %edx,0x4(%eax)
  802546:	8b 45 08             	mov    0x8(%ebp),%eax
  802549:	8b 40 04             	mov    0x4(%eax),%eax
  80254c:	85 c0                	test   %eax,%eax
  80254e:	74 0c                	je     80255c <insert_sorted_allocList+0x179>
  802550:	a1 44 50 80 00       	mov    0x805044,%eax
  802555:	8b 55 08             	mov    0x8(%ebp),%edx
  802558:	89 10                	mov    %edx,(%eax)
  80255a:	eb 08                	jmp    802564 <insert_sorted_allocList+0x181>
  80255c:	8b 45 08             	mov    0x8(%ebp),%eax
  80255f:	a3 40 50 80 00       	mov    %eax,0x805040
  802564:	8b 45 08             	mov    0x8(%ebp),%eax
  802567:	a3 44 50 80 00       	mov    %eax,0x805044
  80256c:	8b 45 08             	mov    0x8(%ebp),%eax
  80256f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802575:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80257a:	40                   	inc    %eax
  80257b:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802580:	e9 e7 00 00 00       	jmp    80266c <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802585:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802588:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  80258b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802592:	a1 40 50 80 00       	mov    0x805040,%eax
  802597:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80259a:	e9 9d 00 00 00       	jmp    80263c <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  80259f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a2:	8b 00                	mov    (%eax),%eax
  8025a4:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  8025a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8025aa:	8b 50 08             	mov    0x8(%eax),%edx
  8025ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b0:	8b 40 08             	mov    0x8(%eax),%eax
  8025b3:	39 c2                	cmp    %eax,%edx
  8025b5:	76 7d                	jbe    802634 <insert_sorted_allocList+0x251>
  8025b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ba:	8b 50 08             	mov    0x8(%eax),%edx
  8025bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8025c0:	8b 40 08             	mov    0x8(%eax),%eax
  8025c3:	39 c2                	cmp    %eax,%edx
  8025c5:	73 6d                	jae    802634 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  8025c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025cb:	74 06                	je     8025d3 <insert_sorted_allocList+0x1f0>
  8025cd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8025d1:	75 14                	jne    8025e7 <insert_sorted_allocList+0x204>
  8025d3:	83 ec 04             	sub    $0x4,%esp
  8025d6:	68 3c 43 80 00       	push   $0x80433c
  8025db:	6a 7f                	push   $0x7f
  8025dd:	68 c7 42 80 00       	push   $0x8042c7
  8025e2:	e8 fa e0 ff ff       	call   8006e1 <_panic>
  8025e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ea:	8b 10                	mov    (%eax),%edx
  8025ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ef:	89 10                	mov    %edx,(%eax)
  8025f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8025f4:	8b 00                	mov    (%eax),%eax
  8025f6:	85 c0                	test   %eax,%eax
  8025f8:	74 0b                	je     802605 <insert_sorted_allocList+0x222>
  8025fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fd:	8b 00                	mov    (%eax),%eax
  8025ff:	8b 55 08             	mov    0x8(%ebp),%edx
  802602:	89 50 04             	mov    %edx,0x4(%eax)
  802605:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802608:	8b 55 08             	mov    0x8(%ebp),%edx
  80260b:	89 10                	mov    %edx,(%eax)
  80260d:	8b 45 08             	mov    0x8(%ebp),%eax
  802610:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802613:	89 50 04             	mov    %edx,0x4(%eax)
  802616:	8b 45 08             	mov    0x8(%ebp),%eax
  802619:	8b 00                	mov    (%eax),%eax
  80261b:	85 c0                	test   %eax,%eax
  80261d:	75 08                	jne    802627 <insert_sorted_allocList+0x244>
  80261f:	8b 45 08             	mov    0x8(%ebp),%eax
  802622:	a3 44 50 80 00       	mov    %eax,0x805044
  802627:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80262c:	40                   	inc    %eax
  80262d:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802632:	eb 39                	jmp    80266d <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802634:	a1 48 50 80 00       	mov    0x805048,%eax
  802639:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80263c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802640:	74 07                	je     802649 <insert_sorted_allocList+0x266>
  802642:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802645:	8b 00                	mov    (%eax),%eax
  802647:	eb 05                	jmp    80264e <insert_sorted_allocList+0x26b>
  802649:	b8 00 00 00 00       	mov    $0x0,%eax
  80264e:	a3 48 50 80 00       	mov    %eax,0x805048
  802653:	a1 48 50 80 00       	mov    0x805048,%eax
  802658:	85 c0                	test   %eax,%eax
  80265a:	0f 85 3f ff ff ff    	jne    80259f <insert_sorted_allocList+0x1bc>
  802660:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802664:	0f 85 35 ff ff ff    	jne    80259f <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80266a:	eb 01                	jmp    80266d <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80266c:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80266d:	90                   	nop
  80266e:	c9                   	leave  
  80266f:	c3                   	ret    

00802670 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802670:	55                   	push   %ebp
  802671:	89 e5                	mov    %esp,%ebp
  802673:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802676:	a1 38 51 80 00       	mov    0x805138,%eax
  80267b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80267e:	e9 85 01 00 00       	jmp    802808 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802683:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802686:	8b 40 0c             	mov    0xc(%eax),%eax
  802689:	3b 45 08             	cmp    0x8(%ebp),%eax
  80268c:	0f 82 6e 01 00 00    	jb     802800 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802692:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802695:	8b 40 0c             	mov    0xc(%eax),%eax
  802698:	3b 45 08             	cmp    0x8(%ebp),%eax
  80269b:	0f 85 8a 00 00 00    	jne    80272b <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  8026a1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026a5:	75 17                	jne    8026be <alloc_block_FF+0x4e>
  8026a7:	83 ec 04             	sub    $0x4,%esp
  8026aa:	68 70 43 80 00       	push   $0x804370
  8026af:	68 93 00 00 00       	push   $0x93
  8026b4:	68 c7 42 80 00       	push   $0x8042c7
  8026b9:	e8 23 e0 ff ff       	call   8006e1 <_panic>
  8026be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c1:	8b 00                	mov    (%eax),%eax
  8026c3:	85 c0                	test   %eax,%eax
  8026c5:	74 10                	je     8026d7 <alloc_block_FF+0x67>
  8026c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ca:	8b 00                	mov    (%eax),%eax
  8026cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026cf:	8b 52 04             	mov    0x4(%edx),%edx
  8026d2:	89 50 04             	mov    %edx,0x4(%eax)
  8026d5:	eb 0b                	jmp    8026e2 <alloc_block_FF+0x72>
  8026d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026da:	8b 40 04             	mov    0x4(%eax),%eax
  8026dd:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8026e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e5:	8b 40 04             	mov    0x4(%eax),%eax
  8026e8:	85 c0                	test   %eax,%eax
  8026ea:	74 0f                	je     8026fb <alloc_block_FF+0x8b>
  8026ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ef:	8b 40 04             	mov    0x4(%eax),%eax
  8026f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026f5:	8b 12                	mov    (%edx),%edx
  8026f7:	89 10                	mov    %edx,(%eax)
  8026f9:	eb 0a                	jmp    802705 <alloc_block_FF+0x95>
  8026fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fe:	8b 00                	mov    (%eax),%eax
  802700:	a3 38 51 80 00       	mov    %eax,0x805138
  802705:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802708:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80270e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802711:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802718:	a1 44 51 80 00       	mov    0x805144,%eax
  80271d:	48                   	dec    %eax
  80271e:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802723:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802726:	e9 10 01 00 00       	jmp    80283b <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  80272b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272e:	8b 40 0c             	mov    0xc(%eax),%eax
  802731:	3b 45 08             	cmp    0x8(%ebp),%eax
  802734:	0f 86 c6 00 00 00    	jbe    802800 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80273a:	a1 48 51 80 00       	mov    0x805148,%eax
  80273f:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802742:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802745:	8b 50 08             	mov    0x8(%eax),%edx
  802748:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80274b:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  80274e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802751:	8b 55 08             	mov    0x8(%ebp),%edx
  802754:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802757:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80275b:	75 17                	jne    802774 <alloc_block_FF+0x104>
  80275d:	83 ec 04             	sub    $0x4,%esp
  802760:	68 70 43 80 00       	push   $0x804370
  802765:	68 9b 00 00 00       	push   $0x9b
  80276a:	68 c7 42 80 00       	push   $0x8042c7
  80276f:	e8 6d df ff ff       	call   8006e1 <_panic>
  802774:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802777:	8b 00                	mov    (%eax),%eax
  802779:	85 c0                	test   %eax,%eax
  80277b:	74 10                	je     80278d <alloc_block_FF+0x11d>
  80277d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802780:	8b 00                	mov    (%eax),%eax
  802782:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802785:	8b 52 04             	mov    0x4(%edx),%edx
  802788:	89 50 04             	mov    %edx,0x4(%eax)
  80278b:	eb 0b                	jmp    802798 <alloc_block_FF+0x128>
  80278d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802790:	8b 40 04             	mov    0x4(%eax),%eax
  802793:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802798:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80279b:	8b 40 04             	mov    0x4(%eax),%eax
  80279e:	85 c0                	test   %eax,%eax
  8027a0:	74 0f                	je     8027b1 <alloc_block_FF+0x141>
  8027a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027a5:	8b 40 04             	mov    0x4(%eax),%eax
  8027a8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027ab:	8b 12                	mov    (%edx),%edx
  8027ad:	89 10                	mov    %edx,(%eax)
  8027af:	eb 0a                	jmp    8027bb <alloc_block_FF+0x14b>
  8027b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027b4:	8b 00                	mov    (%eax),%eax
  8027b6:	a3 48 51 80 00       	mov    %eax,0x805148
  8027bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027be:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027c7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027ce:	a1 54 51 80 00       	mov    0x805154,%eax
  8027d3:	48                   	dec    %eax
  8027d4:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  8027d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027dc:	8b 50 08             	mov    0x8(%eax),%edx
  8027df:	8b 45 08             	mov    0x8(%ebp),%eax
  8027e2:	01 c2                	add    %eax,%edx
  8027e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e7:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  8027ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ed:	8b 40 0c             	mov    0xc(%eax),%eax
  8027f0:	2b 45 08             	sub    0x8(%ebp),%eax
  8027f3:	89 c2                	mov    %eax,%edx
  8027f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f8:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  8027fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027fe:	eb 3b                	jmp    80283b <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802800:	a1 40 51 80 00       	mov    0x805140,%eax
  802805:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802808:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80280c:	74 07                	je     802815 <alloc_block_FF+0x1a5>
  80280e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802811:	8b 00                	mov    (%eax),%eax
  802813:	eb 05                	jmp    80281a <alloc_block_FF+0x1aa>
  802815:	b8 00 00 00 00       	mov    $0x0,%eax
  80281a:	a3 40 51 80 00       	mov    %eax,0x805140
  80281f:	a1 40 51 80 00       	mov    0x805140,%eax
  802824:	85 c0                	test   %eax,%eax
  802826:	0f 85 57 fe ff ff    	jne    802683 <alloc_block_FF+0x13>
  80282c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802830:	0f 85 4d fe ff ff    	jne    802683 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802836:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80283b:	c9                   	leave  
  80283c:	c3                   	ret    

0080283d <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  80283d:	55                   	push   %ebp
  80283e:	89 e5                	mov    %esp,%ebp
  802840:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802843:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  80284a:	a1 38 51 80 00       	mov    0x805138,%eax
  80284f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802852:	e9 df 00 00 00       	jmp    802936 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802857:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285a:	8b 40 0c             	mov    0xc(%eax),%eax
  80285d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802860:	0f 82 c8 00 00 00    	jb     80292e <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802866:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802869:	8b 40 0c             	mov    0xc(%eax),%eax
  80286c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80286f:	0f 85 8a 00 00 00    	jne    8028ff <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802875:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802879:	75 17                	jne    802892 <alloc_block_BF+0x55>
  80287b:	83 ec 04             	sub    $0x4,%esp
  80287e:	68 70 43 80 00       	push   $0x804370
  802883:	68 b7 00 00 00       	push   $0xb7
  802888:	68 c7 42 80 00       	push   $0x8042c7
  80288d:	e8 4f de ff ff       	call   8006e1 <_panic>
  802892:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802895:	8b 00                	mov    (%eax),%eax
  802897:	85 c0                	test   %eax,%eax
  802899:	74 10                	je     8028ab <alloc_block_BF+0x6e>
  80289b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289e:	8b 00                	mov    (%eax),%eax
  8028a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028a3:	8b 52 04             	mov    0x4(%edx),%edx
  8028a6:	89 50 04             	mov    %edx,0x4(%eax)
  8028a9:	eb 0b                	jmp    8028b6 <alloc_block_BF+0x79>
  8028ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ae:	8b 40 04             	mov    0x4(%eax),%eax
  8028b1:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8028b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b9:	8b 40 04             	mov    0x4(%eax),%eax
  8028bc:	85 c0                	test   %eax,%eax
  8028be:	74 0f                	je     8028cf <alloc_block_BF+0x92>
  8028c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c3:	8b 40 04             	mov    0x4(%eax),%eax
  8028c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028c9:	8b 12                	mov    (%edx),%edx
  8028cb:	89 10                	mov    %edx,(%eax)
  8028cd:	eb 0a                	jmp    8028d9 <alloc_block_BF+0x9c>
  8028cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d2:	8b 00                	mov    (%eax),%eax
  8028d4:	a3 38 51 80 00       	mov    %eax,0x805138
  8028d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028dc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028ec:	a1 44 51 80 00       	mov    0x805144,%eax
  8028f1:	48                   	dec    %eax
  8028f2:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  8028f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028fa:	e9 4d 01 00 00       	jmp    802a4c <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  8028ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802902:	8b 40 0c             	mov    0xc(%eax),%eax
  802905:	3b 45 08             	cmp    0x8(%ebp),%eax
  802908:	76 24                	jbe    80292e <alloc_block_BF+0xf1>
  80290a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290d:	8b 40 0c             	mov    0xc(%eax),%eax
  802910:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802913:	73 19                	jae    80292e <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802915:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  80291c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291f:	8b 40 0c             	mov    0xc(%eax),%eax
  802922:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802925:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802928:	8b 40 08             	mov    0x8(%eax),%eax
  80292b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  80292e:	a1 40 51 80 00       	mov    0x805140,%eax
  802933:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802936:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80293a:	74 07                	je     802943 <alloc_block_BF+0x106>
  80293c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293f:	8b 00                	mov    (%eax),%eax
  802941:	eb 05                	jmp    802948 <alloc_block_BF+0x10b>
  802943:	b8 00 00 00 00       	mov    $0x0,%eax
  802948:	a3 40 51 80 00       	mov    %eax,0x805140
  80294d:	a1 40 51 80 00       	mov    0x805140,%eax
  802952:	85 c0                	test   %eax,%eax
  802954:	0f 85 fd fe ff ff    	jne    802857 <alloc_block_BF+0x1a>
  80295a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80295e:	0f 85 f3 fe ff ff    	jne    802857 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802964:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802968:	0f 84 d9 00 00 00    	je     802a47 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  80296e:	a1 48 51 80 00       	mov    0x805148,%eax
  802973:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802976:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802979:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80297c:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  80297f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802982:	8b 55 08             	mov    0x8(%ebp),%edx
  802985:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802988:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80298c:	75 17                	jne    8029a5 <alloc_block_BF+0x168>
  80298e:	83 ec 04             	sub    $0x4,%esp
  802991:	68 70 43 80 00       	push   $0x804370
  802996:	68 c7 00 00 00       	push   $0xc7
  80299b:	68 c7 42 80 00       	push   $0x8042c7
  8029a0:	e8 3c dd ff ff       	call   8006e1 <_panic>
  8029a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029a8:	8b 00                	mov    (%eax),%eax
  8029aa:	85 c0                	test   %eax,%eax
  8029ac:	74 10                	je     8029be <alloc_block_BF+0x181>
  8029ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029b1:	8b 00                	mov    (%eax),%eax
  8029b3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8029b6:	8b 52 04             	mov    0x4(%edx),%edx
  8029b9:	89 50 04             	mov    %edx,0x4(%eax)
  8029bc:	eb 0b                	jmp    8029c9 <alloc_block_BF+0x18c>
  8029be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029c1:	8b 40 04             	mov    0x4(%eax),%eax
  8029c4:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8029c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029cc:	8b 40 04             	mov    0x4(%eax),%eax
  8029cf:	85 c0                	test   %eax,%eax
  8029d1:	74 0f                	je     8029e2 <alloc_block_BF+0x1a5>
  8029d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029d6:	8b 40 04             	mov    0x4(%eax),%eax
  8029d9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8029dc:	8b 12                	mov    (%edx),%edx
  8029de:	89 10                	mov    %edx,(%eax)
  8029e0:	eb 0a                	jmp    8029ec <alloc_block_BF+0x1af>
  8029e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029e5:	8b 00                	mov    (%eax),%eax
  8029e7:	a3 48 51 80 00       	mov    %eax,0x805148
  8029ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029ef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029f8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029ff:	a1 54 51 80 00       	mov    0x805154,%eax
  802a04:	48                   	dec    %eax
  802a05:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802a0a:	83 ec 08             	sub    $0x8,%esp
  802a0d:	ff 75 ec             	pushl  -0x14(%ebp)
  802a10:	68 38 51 80 00       	push   $0x805138
  802a15:	e8 71 f9 ff ff       	call   80238b <find_block>
  802a1a:	83 c4 10             	add    $0x10,%esp
  802a1d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802a20:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a23:	8b 50 08             	mov    0x8(%eax),%edx
  802a26:	8b 45 08             	mov    0x8(%ebp),%eax
  802a29:	01 c2                	add    %eax,%edx
  802a2b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a2e:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802a31:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a34:	8b 40 0c             	mov    0xc(%eax),%eax
  802a37:	2b 45 08             	sub    0x8(%ebp),%eax
  802a3a:	89 c2                	mov    %eax,%edx
  802a3c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a3f:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802a42:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a45:	eb 05                	jmp    802a4c <alloc_block_BF+0x20f>
	}
	return NULL;
  802a47:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a4c:	c9                   	leave  
  802a4d:	c3                   	ret    

00802a4e <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802a4e:	55                   	push   %ebp
  802a4f:	89 e5                	mov    %esp,%ebp
  802a51:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802a54:	a1 28 50 80 00       	mov    0x805028,%eax
  802a59:	85 c0                	test   %eax,%eax
  802a5b:	0f 85 de 01 00 00    	jne    802c3f <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802a61:	a1 38 51 80 00       	mov    0x805138,%eax
  802a66:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a69:	e9 9e 01 00 00       	jmp    802c0c <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802a6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a71:	8b 40 0c             	mov    0xc(%eax),%eax
  802a74:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a77:	0f 82 87 01 00 00    	jb     802c04 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802a7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a80:	8b 40 0c             	mov    0xc(%eax),%eax
  802a83:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a86:	0f 85 95 00 00 00    	jne    802b21 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802a8c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a90:	75 17                	jne    802aa9 <alloc_block_NF+0x5b>
  802a92:	83 ec 04             	sub    $0x4,%esp
  802a95:	68 70 43 80 00       	push   $0x804370
  802a9a:	68 e0 00 00 00       	push   $0xe0
  802a9f:	68 c7 42 80 00       	push   $0x8042c7
  802aa4:	e8 38 dc ff ff       	call   8006e1 <_panic>
  802aa9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aac:	8b 00                	mov    (%eax),%eax
  802aae:	85 c0                	test   %eax,%eax
  802ab0:	74 10                	je     802ac2 <alloc_block_NF+0x74>
  802ab2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab5:	8b 00                	mov    (%eax),%eax
  802ab7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802aba:	8b 52 04             	mov    0x4(%edx),%edx
  802abd:	89 50 04             	mov    %edx,0x4(%eax)
  802ac0:	eb 0b                	jmp    802acd <alloc_block_NF+0x7f>
  802ac2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac5:	8b 40 04             	mov    0x4(%eax),%eax
  802ac8:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802acd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad0:	8b 40 04             	mov    0x4(%eax),%eax
  802ad3:	85 c0                	test   %eax,%eax
  802ad5:	74 0f                	je     802ae6 <alloc_block_NF+0x98>
  802ad7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ada:	8b 40 04             	mov    0x4(%eax),%eax
  802add:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ae0:	8b 12                	mov    (%edx),%edx
  802ae2:	89 10                	mov    %edx,(%eax)
  802ae4:	eb 0a                	jmp    802af0 <alloc_block_NF+0xa2>
  802ae6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae9:	8b 00                	mov    (%eax),%eax
  802aeb:	a3 38 51 80 00       	mov    %eax,0x805138
  802af0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802af9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802afc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b03:	a1 44 51 80 00       	mov    0x805144,%eax
  802b08:	48                   	dec    %eax
  802b09:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802b0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b11:	8b 40 08             	mov    0x8(%eax),%eax
  802b14:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  802b19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1c:	e9 f8 04 00 00       	jmp    803019 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802b21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b24:	8b 40 0c             	mov    0xc(%eax),%eax
  802b27:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b2a:	0f 86 d4 00 00 00    	jbe    802c04 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802b30:	a1 48 51 80 00       	mov    0x805148,%eax
  802b35:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802b38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b3b:	8b 50 08             	mov    0x8(%eax),%edx
  802b3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b41:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802b44:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b47:	8b 55 08             	mov    0x8(%ebp),%edx
  802b4a:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802b4d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b51:	75 17                	jne    802b6a <alloc_block_NF+0x11c>
  802b53:	83 ec 04             	sub    $0x4,%esp
  802b56:	68 70 43 80 00       	push   $0x804370
  802b5b:	68 e9 00 00 00       	push   $0xe9
  802b60:	68 c7 42 80 00       	push   $0x8042c7
  802b65:	e8 77 db ff ff       	call   8006e1 <_panic>
  802b6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b6d:	8b 00                	mov    (%eax),%eax
  802b6f:	85 c0                	test   %eax,%eax
  802b71:	74 10                	je     802b83 <alloc_block_NF+0x135>
  802b73:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b76:	8b 00                	mov    (%eax),%eax
  802b78:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b7b:	8b 52 04             	mov    0x4(%edx),%edx
  802b7e:	89 50 04             	mov    %edx,0x4(%eax)
  802b81:	eb 0b                	jmp    802b8e <alloc_block_NF+0x140>
  802b83:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b86:	8b 40 04             	mov    0x4(%eax),%eax
  802b89:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b91:	8b 40 04             	mov    0x4(%eax),%eax
  802b94:	85 c0                	test   %eax,%eax
  802b96:	74 0f                	je     802ba7 <alloc_block_NF+0x159>
  802b98:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b9b:	8b 40 04             	mov    0x4(%eax),%eax
  802b9e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ba1:	8b 12                	mov    (%edx),%edx
  802ba3:	89 10                	mov    %edx,(%eax)
  802ba5:	eb 0a                	jmp    802bb1 <alloc_block_NF+0x163>
  802ba7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802baa:	8b 00                	mov    (%eax),%eax
  802bac:	a3 48 51 80 00       	mov    %eax,0x805148
  802bb1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bb4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bbd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bc4:	a1 54 51 80 00       	mov    0x805154,%eax
  802bc9:	48                   	dec    %eax
  802bca:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802bcf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bd2:	8b 40 08             	mov    0x8(%eax),%eax
  802bd5:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802bda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bdd:	8b 50 08             	mov    0x8(%eax),%edx
  802be0:	8b 45 08             	mov    0x8(%ebp),%eax
  802be3:	01 c2                	add    %eax,%edx
  802be5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be8:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802beb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bee:	8b 40 0c             	mov    0xc(%eax),%eax
  802bf1:	2b 45 08             	sub    0x8(%ebp),%eax
  802bf4:	89 c2                	mov    %eax,%edx
  802bf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf9:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802bfc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bff:	e9 15 04 00 00       	jmp    803019 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802c04:	a1 40 51 80 00       	mov    0x805140,%eax
  802c09:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c0c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c10:	74 07                	je     802c19 <alloc_block_NF+0x1cb>
  802c12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c15:	8b 00                	mov    (%eax),%eax
  802c17:	eb 05                	jmp    802c1e <alloc_block_NF+0x1d0>
  802c19:	b8 00 00 00 00       	mov    $0x0,%eax
  802c1e:	a3 40 51 80 00       	mov    %eax,0x805140
  802c23:	a1 40 51 80 00       	mov    0x805140,%eax
  802c28:	85 c0                	test   %eax,%eax
  802c2a:	0f 85 3e fe ff ff    	jne    802a6e <alloc_block_NF+0x20>
  802c30:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c34:	0f 85 34 fe ff ff    	jne    802a6e <alloc_block_NF+0x20>
  802c3a:	e9 d5 03 00 00       	jmp    803014 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802c3f:	a1 38 51 80 00       	mov    0x805138,%eax
  802c44:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c47:	e9 b1 01 00 00       	jmp    802dfd <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802c4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4f:	8b 50 08             	mov    0x8(%eax),%edx
  802c52:	a1 28 50 80 00       	mov    0x805028,%eax
  802c57:	39 c2                	cmp    %eax,%edx
  802c59:	0f 82 96 01 00 00    	jb     802df5 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802c5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c62:	8b 40 0c             	mov    0xc(%eax),%eax
  802c65:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c68:	0f 82 87 01 00 00    	jb     802df5 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802c6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c71:	8b 40 0c             	mov    0xc(%eax),%eax
  802c74:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c77:	0f 85 95 00 00 00    	jne    802d12 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802c7d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c81:	75 17                	jne    802c9a <alloc_block_NF+0x24c>
  802c83:	83 ec 04             	sub    $0x4,%esp
  802c86:	68 70 43 80 00       	push   $0x804370
  802c8b:	68 fc 00 00 00       	push   $0xfc
  802c90:	68 c7 42 80 00       	push   $0x8042c7
  802c95:	e8 47 da ff ff       	call   8006e1 <_panic>
  802c9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9d:	8b 00                	mov    (%eax),%eax
  802c9f:	85 c0                	test   %eax,%eax
  802ca1:	74 10                	je     802cb3 <alloc_block_NF+0x265>
  802ca3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca6:	8b 00                	mov    (%eax),%eax
  802ca8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cab:	8b 52 04             	mov    0x4(%edx),%edx
  802cae:	89 50 04             	mov    %edx,0x4(%eax)
  802cb1:	eb 0b                	jmp    802cbe <alloc_block_NF+0x270>
  802cb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb6:	8b 40 04             	mov    0x4(%eax),%eax
  802cb9:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802cbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc1:	8b 40 04             	mov    0x4(%eax),%eax
  802cc4:	85 c0                	test   %eax,%eax
  802cc6:	74 0f                	je     802cd7 <alloc_block_NF+0x289>
  802cc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ccb:	8b 40 04             	mov    0x4(%eax),%eax
  802cce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cd1:	8b 12                	mov    (%edx),%edx
  802cd3:	89 10                	mov    %edx,(%eax)
  802cd5:	eb 0a                	jmp    802ce1 <alloc_block_NF+0x293>
  802cd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cda:	8b 00                	mov    (%eax),%eax
  802cdc:	a3 38 51 80 00       	mov    %eax,0x805138
  802ce1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ced:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cf4:	a1 44 51 80 00       	mov    0x805144,%eax
  802cf9:	48                   	dec    %eax
  802cfa:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802cff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d02:	8b 40 08             	mov    0x8(%eax),%eax
  802d05:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802d0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0d:	e9 07 03 00 00       	jmp    803019 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802d12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d15:	8b 40 0c             	mov    0xc(%eax),%eax
  802d18:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d1b:	0f 86 d4 00 00 00    	jbe    802df5 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802d21:	a1 48 51 80 00       	mov    0x805148,%eax
  802d26:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802d29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d2c:	8b 50 08             	mov    0x8(%eax),%edx
  802d2f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d32:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802d35:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d38:	8b 55 08             	mov    0x8(%ebp),%edx
  802d3b:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802d3e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802d42:	75 17                	jne    802d5b <alloc_block_NF+0x30d>
  802d44:	83 ec 04             	sub    $0x4,%esp
  802d47:	68 70 43 80 00       	push   $0x804370
  802d4c:	68 04 01 00 00       	push   $0x104
  802d51:	68 c7 42 80 00       	push   $0x8042c7
  802d56:	e8 86 d9 ff ff       	call   8006e1 <_panic>
  802d5b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d5e:	8b 00                	mov    (%eax),%eax
  802d60:	85 c0                	test   %eax,%eax
  802d62:	74 10                	je     802d74 <alloc_block_NF+0x326>
  802d64:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d67:	8b 00                	mov    (%eax),%eax
  802d69:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d6c:	8b 52 04             	mov    0x4(%edx),%edx
  802d6f:	89 50 04             	mov    %edx,0x4(%eax)
  802d72:	eb 0b                	jmp    802d7f <alloc_block_NF+0x331>
  802d74:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d77:	8b 40 04             	mov    0x4(%eax),%eax
  802d7a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d7f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d82:	8b 40 04             	mov    0x4(%eax),%eax
  802d85:	85 c0                	test   %eax,%eax
  802d87:	74 0f                	je     802d98 <alloc_block_NF+0x34a>
  802d89:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d8c:	8b 40 04             	mov    0x4(%eax),%eax
  802d8f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d92:	8b 12                	mov    (%edx),%edx
  802d94:	89 10                	mov    %edx,(%eax)
  802d96:	eb 0a                	jmp    802da2 <alloc_block_NF+0x354>
  802d98:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d9b:	8b 00                	mov    (%eax),%eax
  802d9d:	a3 48 51 80 00       	mov    %eax,0x805148
  802da2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802da5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802dab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dae:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802db5:	a1 54 51 80 00       	mov    0x805154,%eax
  802dba:	48                   	dec    %eax
  802dbb:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802dc0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dc3:	8b 40 08             	mov    0x8(%eax),%eax
  802dc6:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802dcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dce:	8b 50 08             	mov    0x8(%eax),%edx
  802dd1:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd4:	01 c2                	add    %eax,%edx
  802dd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd9:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802ddc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ddf:	8b 40 0c             	mov    0xc(%eax),%eax
  802de2:	2b 45 08             	sub    0x8(%ebp),%eax
  802de5:	89 c2                	mov    %eax,%edx
  802de7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dea:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802ded:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802df0:	e9 24 02 00 00       	jmp    803019 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802df5:	a1 40 51 80 00       	mov    0x805140,%eax
  802dfa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802dfd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e01:	74 07                	je     802e0a <alloc_block_NF+0x3bc>
  802e03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e06:	8b 00                	mov    (%eax),%eax
  802e08:	eb 05                	jmp    802e0f <alloc_block_NF+0x3c1>
  802e0a:	b8 00 00 00 00       	mov    $0x0,%eax
  802e0f:	a3 40 51 80 00       	mov    %eax,0x805140
  802e14:	a1 40 51 80 00       	mov    0x805140,%eax
  802e19:	85 c0                	test   %eax,%eax
  802e1b:	0f 85 2b fe ff ff    	jne    802c4c <alloc_block_NF+0x1fe>
  802e21:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e25:	0f 85 21 fe ff ff    	jne    802c4c <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802e2b:	a1 38 51 80 00       	mov    0x805138,%eax
  802e30:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e33:	e9 ae 01 00 00       	jmp    802fe6 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802e38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e3b:	8b 50 08             	mov    0x8(%eax),%edx
  802e3e:	a1 28 50 80 00       	mov    0x805028,%eax
  802e43:	39 c2                	cmp    %eax,%edx
  802e45:	0f 83 93 01 00 00    	jae    802fde <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802e4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e4e:	8b 40 0c             	mov    0xc(%eax),%eax
  802e51:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e54:	0f 82 84 01 00 00    	jb     802fde <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802e5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e5d:	8b 40 0c             	mov    0xc(%eax),%eax
  802e60:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e63:	0f 85 95 00 00 00    	jne    802efe <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802e69:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e6d:	75 17                	jne    802e86 <alloc_block_NF+0x438>
  802e6f:	83 ec 04             	sub    $0x4,%esp
  802e72:	68 70 43 80 00       	push   $0x804370
  802e77:	68 14 01 00 00       	push   $0x114
  802e7c:	68 c7 42 80 00       	push   $0x8042c7
  802e81:	e8 5b d8 ff ff       	call   8006e1 <_panic>
  802e86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e89:	8b 00                	mov    (%eax),%eax
  802e8b:	85 c0                	test   %eax,%eax
  802e8d:	74 10                	je     802e9f <alloc_block_NF+0x451>
  802e8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e92:	8b 00                	mov    (%eax),%eax
  802e94:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e97:	8b 52 04             	mov    0x4(%edx),%edx
  802e9a:	89 50 04             	mov    %edx,0x4(%eax)
  802e9d:	eb 0b                	jmp    802eaa <alloc_block_NF+0x45c>
  802e9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea2:	8b 40 04             	mov    0x4(%eax),%eax
  802ea5:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802eaa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ead:	8b 40 04             	mov    0x4(%eax),%eax
  802eb0:	85 c0                	test   %eax,%eax
  802eb2:	74 0f                	je     802ec3 <alloc_block_NF+0x475>
  802eb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb7:	8b 40 04             	mov    0x4(%eax),%eax
  802eba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ebd:	8b 12                	mov    (%edx),%edx
  802ebf:	89 10                	mov    %edx,(%eax)
  802ec1:	eb 0a                	jmp    802ecd <alloc_block_NF+0x47f>
  802ec3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec6:	8b 00                	mov    (%eax),%eax
  802ec8:	a3 38 51 80 00       	mov    %eax,0x805138
  802ecd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ed6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ee0:	a1 44 51 80 00       	mov    0x805144,%eax
  802ee5:	48                   	dec    %eax
  802ee6:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802eeb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eee:	8b 40 08             	mov    0x8(%eax),%eax
  802ef1:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802ef6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef9:	e9 1b 01 00 00       	jmp    803019 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802efe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f01:	8b 40 0c             	mov    0xc(%eax),%eax
  802f04:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f07:	0f 86 d1 00 00 00    	jbe    802fde <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802f0d:	a1 48 51 80 00       	mov    0x805148,%eax
  802f12:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802f15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f18:	8b 50 08             	mov    0x8(%eax),%edx
  802f1b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f1e:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802f21:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f24:	8b 55 08             	mov    0x8(%ebp),%edx
  802f27:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802f2a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802f2e:	75 17                	jne    802f47 <alloc_block_NF+0x4f9>
  802f30:	83 ec 04             	sub    $0x4,%esp
  802f33:	68 70 43 80 00       	push   $0x804370
  802f38:	68 1c 01 00 00       	push   $0x11c
  802f3d:	68 c7 42 80 00       	push   $0x8042c7
  802f42:	e8 9a d7 ff ff       	call   8006e1 <_panic>
  802f47:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f4a:	8b 00                	mov    (%eax),%eax
  802f4c:	85 c0                	test   %eax,%eax
  802f4e:	74 10                	je     802f60 <alloc_block_NF+0x512>
  802f50:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f53:	8b 00                	mov    (%eax),%eax
  802f55:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802f58:	8b 52 04             	mov    0x4(%edx),%edx
  802f5b:	89 50 04             	mov    %edx,0x4(%eax)
  802f5e:	eb 0b                	jmp    802f6b <alloc_block_NF+0x51d>
  802f60:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f63:	8b 40 04             	mov    0x4(%eax),%eax
  802f66:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f6b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f6e:	8b 40 04             	mov    0x4(%eax),%eax
  802f71:	85 c0                	test   %eax,%eax
  802f73:	74 0f                	je     802f84 <alloc_block_NF+0x536>
  802f75:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f78:	8b 40 04             	mov    0x4(%eax),%eax
  802f7b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802f7e:	8b 12                	mov    (%edx),%edx
  802f80:	89 10                	mov    %edx,(%eax)
  802f82:	eb 0a                	jmp    802f8e <alloc_block_NF+0x540>
  802f84:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f87:	8b 00                	mov    (%eax),%eax
  802f89:	a3 48 51 80 00       	mov    %eax,0x805148
  802f8e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f91:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f97:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f9a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fa1:	a1 54 51 80 00       	mov    0x805154,%eax
  802fa6:	48                   	dec    %eax
  802fa7:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802fac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802faf:	8b 40 08             	mov    0x8(%eax),%eax
  802fb2:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802fb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fba:	8b 50 08             	mov    0x8(%eax),%edx
  802fbd:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc0:	01 c2                	add    %eax,%edx
  802fc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc5:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802fc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fcb:	8b 40 0c             	mov    0xc(%eax),%eax
  802fce:	2b 45 08             	sub    0x8(%ebp),%eax
  802fd1:	89 c2                	mov    %eax,%edx
  802fd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd6:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802fd9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fdc:	eb 3b                	jmp    803019 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802fde:	a1 40 51 80 00       	mov    0x805140,%eax
  802fe3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fe6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fea:	74 07                	je     802ff3 <alloc_block_NF+0x5a5>
  802fec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fef:	8b 00                	mov    (%eax),%eax
  802ff1:	eb 05                	jmp    802ff8 <alloc_block_NF+0x5aa>
  802ff3:	b8 00 00 00 00       	mov    $0x0,%eax
  802ff8:	a3 40 51 80 00       	mov    %eax,0x805140
  802ffd:	a1 40 51 80 00       	mov    0x805140,%eax
  803002:	85 c0                	test   %eax,%eax
  803004:	0f 85 2e fe ff ff    	jne    802e38 <alloc_block_NF+0x3ea>
  80300a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80300e:	0f 85 24 fe ff ff    	jne    802e38 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  803014:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803019:	c9                   	leave  
  80301a:	c3                   	ret    

0080301b <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  80301b:	55                   	push   %ebp
  80301c:	89 e5                	mov    %esp,%ebp
  80301e:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  803021:	a1 38 51 80 00       	mov    0x805138,%eax
  803026:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  803029:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80302e:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  803031:	a1 38 51 80 00       	mov    0x805138,%eax
  803036:	85 c0                	test   %eax,%eax
  803038:	74 14                	je     80304e <insert_sorted_with_merge_freeList+0x33>
  80303a:	8b 45 08             	mov    0x8(%ebp),%eax
  80303d:	8b 50 08             	mov    0x8(%eax),%edx
  803040:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803043:	8b 40 08             	mov    0x8(%eax),%eax
  803046:	39 c2                	cmp    %eax,%edx
  803048:	0f 87 9b 01 00 00    	ja     8031e9 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  80304e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803052:	75 17                	jne    80306b <insert_sorted_with_merge_freeList+0x50>
  803054:	83 ec 04             	sub    $0x4,%esp
  803057:	68 a4 42 80 00       	push   $0x8042a4
  80305c:	68 38 01 00 00       	push   $0x138
  803061:	68 c7 42 80 00       	push   $0x8042c7
  803066:	e8 76 d6 ff ff       	call   8006e1 <_panic>
  80306b:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803071:	8b 45 08             	mov    0x8(%ebp),%eax
  803074:	89 10                	mov    %edx,(%eax)
  803076:	8b 45 08             	mov    0x8(%ebp),%eax
  803079:	8b 00                	mov    (%eax),%eax
  80307b:	85 c0                	test   %eax,%eax
  80307d:	74 0d                	je     80308c <insert_sorted_with_merge_freeList+0x71>
  80307f:	a1 38 51 80 00       	mov    0x805138,%eax
  803084:	8b 55 08             	mov    0x8(%ebp),%edx
  803087:	89 50 04             	mov    %edx,0x4(%eax)
  80308a:	eb 08                	jmp    803094 <insert_sorted_with_merge_freeList+0x79>
  80308c:	8b 45 08             	mov    0x8(%ebp),%eax
  80308f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803094:	8b 45 08             	mov    0x8(%ebp),%eax
  803097:	a3 38 51 80 00       	mov    %eax,0x805138
  80309c:	8b 45 08             	mov    0x8(%ebp),%eax
  80309f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030a6:	a1 44 51 80 00       	mov    0x805144,%eax
  8030ab:	40                   	inc    %eax
  8030ac:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8030b1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8030b5:	0f 84 a8 06 00 00    	je     803763 <insert_sorted_with_merge_freeList+0x748>
  8030bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8030be:	8b 50 08             	mov    0x8(%eax),%edx
  8030c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c4:	8b 40 0c             	mov    0xc(%eax),%eax
  8030c7:	01 c2                	add    %eax,%edx
  8030c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030cc:	8b 40 08             	mov    0x8(%eax),%eax
  8030cf:	39 c2                	cmp    %eax,%edx
  8030d1:	0f 85 8c 06 00 00    	jne    803763 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  8030d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8030da:	8b 50 0c             	mov    0xc(%eax),%edx
  8030dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030e0:	8b 40 0c             	mov    0xc(%eax),%eax
  8030e3:	01 c2                	add    %eax,%edx
  8030e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e8:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  8030eb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8030ef:	75 17                	jne    803108 <insert_sorted_with_merge_freeList+0xed>
  8030f1:	83 ec 04             	sub    $0x4,%esp
  8030f4:	68 70 43 80 00       	push   $0x804370
  8030f9:	68 3c 01 00 00       	push   $0x13c
  8030fe:	68 c7 42 80 00       	push   $0x8042c7
  803103:	e8 d9 d5 ff ff       	call   8006e1 <_panic>
  803108:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80310b:	8b 00                	mov    (%eax),%eax
  80310d:	85 c0                	test   %eax,%eax
  80310f:	74 10                	je     803121 <insert_sorted_with_merge_freeList+0x106>
  803111:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803114:	8b 00                	mov    (%eax),%eax
  803116:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803119:	8b 52 04             	mov    0x4(%edx),%edx
  80311c:	89 50 04             	mov    %edx,0x4(%eax)
  80311f:	eb 0b                	jmp    80312c <insert_sorted_with_merge_freeList+0x111>
  803121:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803124:	8b 40 04             	mov    0x4(%eax),%eax
  803127:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80312c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80312f:	8b 40 04             	mov    0x4(%eax),%eax
  803132:	85 c0                	test   %eax,%eax
  803134:	74 0f                	je     803145 <insert_sorted_with_merge_freeList+0x12a>
  803136:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803139:	8b 40 04             	mov    0x4(%eax),%eax
  80313c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80313f:	8b 12                	mov    (%edx),%edx
  803141:	89 10                	mov    %edx,(%eax)
  803143:	eb 0a                	jmp    80314f <insert_sorted_with_merge_freeList+0x134>
  803145:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803148:	8b 00                	mov    (%eax),%eax
  80314a:	a3 38 51 80 00       	mov    %eax,0x805138
  80314f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803152:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803158:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80315b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803162:	a1 44 51 80 00       	mov    0x805144,%eax
  803167:	48                   	dec    %eax
  803168:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  80316d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803170:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  803177:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80317a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  803181:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803185:	75 17                	jne    80319e <insert_sorted_with_merge_freeList+0x183>
  803187:	83 ec 04             	sub    $0x4,%esp
  80318a:	68 a4 42 80 00       	push   $0x8042a4
  80318f:	68 3f 01 00 00       	push   $0x13f
  803194:	68 c7 42 80 00       	push   $0x8042c7
  803199:	e8 43 d5 ff ff       	call   8006e1 <_panic>
  80319e:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8031a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031a7:	89 10                	mov    %edx,(%eax)
  8031a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031ac:	8b 00                	mov    (%eax),%eax
  8031ae:	85 c0                	test   %eax,%eax
  8031b0:	74 0d                	je     8031bf <insert_sorted_with_merge_freeList+0x1a4>
  8031b2:	a1 48 51 80 00       	mov    0x805148,%eax
  8031b7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031ba:	89 50 04             	mov    %edx,0x4(%eax)
  8031bd:	eb 08                	jmp    8031c7 <insert_sorted_with_merge_freeList+0x1ac>
  8031bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031c2:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8031c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031ca:	a3 48 51 80 00       	mov    %eax,0x805148
  8031cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031d2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031d9:	a1 54 51 80 00       	mov    0x805154,%eax
  8031de:	40                   	inc    %eax
  8031df:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8031e4:	e9 7a 05 00 00       	jmp    803763 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  8031e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ec:	8b 50 08             	mov    0x8(%eax),%edx
  8031ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031f2:	8b 40 08             	mov    0x8(%eax),%eax
  8031f5:	39 c2                	cmp    %eax,%edx
  8031f7:	0f 82 14 01 00 00    	jb     803311 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  8031fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803200:	8b 50 08             	mov    0x8(%eax),%edx
  803203:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803206:	8b 40 0c             	mov    0xc(%eax),%eax
  803209:	01 c2                	add    %eax,%edx
  80320b:	8b 45 08             	mov    0x8(%ebp),%eax
  80320e:	8b 40 08             	mov    0x8(%eax),%eax
  803211:	39 c2                	cmp    %eax,%edx
  803213:	0f 85 90 00 00 00    	jne    8032a9 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  803219:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80321c:	8b 50 0c             	mov    0xc(%eax),%edx
  80321f:	8b 45 08             	mov    0x8(%ebp),%eax
  803222:	8b 40 0c             	mov    0xc(%eax),%eax
  803225:	01 c2                	add    %eax,%edx
  803227:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80322a:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  80322d:	8b 45 08             	mov    0x8(%ebp),%eax
  803230:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  803237:	8b 45 08             	mov    0x8(%ebp),%eax
  80323a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803241:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803245:	75 17                	jne    80325e <insert_sorted_with_merge_freeList+0x243>
  803247:	83 ec 04             	sub    $0x4,%esp
  80324a:	68 a4 42 80 00       	push   $0x8042a4
  80324f:	68 49 01 00 00       	push   $0x149
  803254:	68 c7 42 80 00       	push   $0x8042c7
  803259:	e8 83 d4 ff ff       	call   8006e1 <_panic>
  80325e:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803264:	8b 45 08             	mov    0x8(%ebp),%eax
  803267:	89 10                	mov    %edx,(%eax)
  803269:	8b 45 08             	mov    0x8(%ebp),%eax
  80326c:	8b 00                	mov    (%eax),%eax
  80326e:	85 c0                	test   %eax,%eax
  803270:	74 0d                	je     80327f <insert_sorted_with_merge_freeList+0x264>
  803272:	a1 48 51 80 00       	mov    0x805148,%eax
  803277:	8b 55 08             	mov    0x8(%ebp),%edx
  80327a:	89 50 04             	mov    %edx,0x4(%eax)
  80327d:	eb 08                	jmp    803287 <insert_sorted_with_merge_freeList+0x26c>
  80327f:	8b 45 08             	mov    0x8(%ebp),%eax
  803282:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803287:	8b 45 08             	mov    0x8(%ebp),%eax
  80328a:	a3 48 51 80 00       	mov    %eax,0x805148
  80328f:	8b 45 08             	mov    0x8(%ebp),%eax
  803292:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803299:	a1 54 51 80 00       	mov    0x805154,%eax
  80329e:	40                   	inc    %eax
  80329f:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8032a4:	e9 bb 04 00 00       	jmp    803764 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  8032a9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032ad:	75 17                	jne    8032c6 <insert_sorted_with_merge_freeList+0x2ab>
  8032af:	83 ec 04             	sub    $0x4,%esp
  8032b2:	68 18 43 80 00       	push   $0x804318
  8032b7:	68 4c 01 00 00       	push   $0x14c
  8032bc:	68 c7 42 80 00       	push   $0x8042c7
  8032c1:	e8 1b d4 ff ff       	call   8006e1 <_panic>
  8032c6:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  8032cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8032cf:	89 50 04             	mov    %edx,0x4(%eax)
  8032d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d5:	8b 40 04             	mov    0x4(%eax),%eax
  8032d8:	85 c0                	test   %eax,%eax
  8032da:	74 0c                	je     8032e8 <insert_sorted_with_merge_freeList+0x2cd>
  8032dc:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8032e1:	8b 55 08             	mov    0x8(%ebp),%edx
  8032e4:	89 10                	mov    %edx,(%eax)
  8032e6:	eb 08                	jmp    8032f0 <insert_sorted_with_merge_freeList+0x2d5>
  8032e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8032eb:	a3 38 51 80 00       	mov    %eax,0x805138
  8032f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f3:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8032f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8032fb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803301:	a1 44 51 80 00       	mov    0x805144,%eax
  803306:	40                   	inc    %eax
  803307:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80330c:	e9 53 04 00 00       	jmp    803764 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803311:	a1 38 51 80 00       	mov    0x805138,%eax
  803316:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803319:	e9 15 04 00 00       	jmp    803733 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  80331e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803321:	8b 00                	mov    (%eax),%eax
  803323:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  803326:	8b 45 08             	mov    0x8(%ebp),%eax
  803329:	8b 50 08             	mov    0x8(%eax),%edx
  80332c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80332f:	8b 40 08             	mov    0x8(%eax),%eax
  803332:	39 c2                	cmp    %eax,%edx
  803334:	0f 86 f1 03 00 00    	jbe    80372b <insert_sorted_with_merge_freeList+0x710>
  80333a:	8b 45 08             	mov    0x8(%ebp),%eax
  80333d:	8b 50 08             	mov    0x8(%eax),%edx
  803340:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803343:	8b 40 08             	mov    0x8(%eax),%eax
  803346:	39 c2                	cmp    %eax,%edx
  803348:	0f 83 dd 03 00 00    	jae    80372b <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  80334e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803351:	8b 50 08             	mov    0x8(%eax),%edx
  803354:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803357:	8b 40 0c             	mov    0xc(%eax),%eax
  80335a:	01 c2                	add    %eax,%edx
  80335c:	8b 45 08             	mov    0x8(%ebp),%eax
  80335f:	8b 40 08             	mov    0x8(%eax),%eax
  803362:	39 c2                	cmp    %eax,%edx
  803364:	0f 85 b9 01 00 00    	jne    803523 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  80336a:	8b 45 08             	mov    0x8(%ebp),%eax
  80336d:	8b 50 08             	mov    0x8(%eax),%edx
  803370:	8b 45 08             	mov    0x8(%ebp),%eax
  803373:	8b 40 0c             	mov    0xc(%eax),%eax
  803376:	01 c2                	add    %eax,%edx
  803378:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80337b:	8b 40 08             	mov    0x8(%eax),%eax
  80337e:	39 c2                	cmp    %eax,%edx
  803380:	0f 85 0d 01 00 00    	jne    803493 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  803386:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803389:	8b 50 0c             	mov    0xc(%eax),%edx
  80338c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80338f:	8b 40 0c             	mov    0xc(%eax),%eax
  803392:	01 c2                	add    %eax,%edx
  803394:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803397:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80339a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80339e:	75 17                	jne    8033b7 <insert_sorted_with_merge_freeList+0x39c>
  8033a0:	83 ec 04             	sub    $0x4,%esp
  8033a3:	68 70 43 80 00       	push   $0x804370
  8033a8:	68 5c 01 00 00       	push   $0x15c
  8033ad:	68 c7 42 80 00       	push   $0x8042c7
  8033b2:	e8 2a d3 ff ff       	call   8006e1 <_panic>
  8033b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033ba:	8b 00                	mov    (%eax),%eax
  8033bc:	85 c0                	test   %eax,%eax
  8033be:	74 10                	je     8033d0 <insert_sorted_with_merge_freeList+0x3b5>
  8033c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033c3:	8b 00                	mov    (%eax),%eax
  8033c5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8033c8:	8b 52 04             	mov    0x4(%edx),%edx
  8033cb:	89 50 04             	mov    %edx,0x4(%eax)
  8033ce:	eb 0b                	jmp    8033db <insert_sorted_with_merge_freeList+0x3c0>
  8033d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033d3:	8b 40 04             	mov    0x4(%eax),%eax
  8033d6:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8033db:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033de:	8b 40 04             	mov    0x4(%eax),%eax
  8033e1:	85 c0                	test   %eax,%eax
  8033e3:	74 0f                	je     8033f4 <insert_sorted_with_merge_freeList+0x3d9>
  8033e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033e8:	8b 40 04             	mov    0x4(%eax),%eax
  8033eb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8033ee:	8b 12                	mov    (%edx),%edx
  8033f0:	89 10                	mov    %edx,(%eax)
  8033f2:	eb 0a                	jmp    8033fe <insert_sorted_with_merge_freeList+0x3e3>
  8033f4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033f7:	8b 00                	mov    (%eax),%eax
  8033f9:	a3 38 51 80 00       	mov    %eax,0x805138
  8033fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803401:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803407:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80340a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803411:	a1 44 51 80 00       	mov    0x805144,%eax
  803416:	48                   	dec    %eax
  803417:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  80341c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80341f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803426:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803429:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803430:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803434:	75 17                	jne    80344d <insert_sorted_with_merge_freeList+0x432>
  803436:	83 ec 04             	sub    $0x4,%esp
  803439:	68 a4 42 80 00       	push   $0x8042a4
  80343e:	68 5f 01 00 00       	push   $0x15f
  803443:	68 c7 42 80 00       	push   $0x8042c7
  803448:	e8 94 d2 ff ff       	call   8006e1 <_panic>
  80344d:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803453:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803456:	89 10                	mov    %edx,(%eax)
  803458:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80345b:	8b 00                	mov    (%eax),%eax
  80345d:	85 c0                	test   %eax,%eax
  80345f:	74 0d                	je     80346e <insert_sorted_with_merge_freeList+0x453>
  803461:	a1 48 51 80 00       	mov    0x805148,%eax
  803466:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803469:	89 50 04             	mov    %edx,0x4(%eax)
  80346c:	eb 08                	jmp    803476 <insert_sorted_with_merge_freeList+0x45b>
  80346e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803471:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803476:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803479:	a3 48 51 80 00       	mov    %eax,0x805148
  80347e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803481:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803488:	a1 54 51 80 00       	mov    0x805154,%eax
  80348d:	40                   	inc    %eax
  80348e:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803493:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803496:	8b 50 0c             	mov    0xc(%eax),%edx
  803499:	8b 45 08             	mov    0x8(%ebp),%eax
  80349c:	8b 40 0c             	mov    0xc(%eax),%eax
  80349f:	01 c2                	add    %eax,%edx
  8034a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034a4:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  8034a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8034aa:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  8034b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8034b4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8034bb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034bf:	75 17                	jne    8034d8 <insert_sorted_with_merge_freeList+0x4bd>
  8034c1:	83 ec 04             	sub    $0x4,%esp
  8034c4:	68 a4 42 80 00       	push   $0x8042a4
  8034c9:	68 64 01 00 00       	push   $0x164
  8034ce:	68 c7 42 80 00       	push   $0x8042c7
  8034d3:	e8 09 d2 ff ff       	call   8006e1 <_panic>
  8034d8:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8034de:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e1:	89 10                	mov    %edx,(%eax)
  8034e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e6:	8b 00                	mov    (%eax),%eax
  8034e8:	85 c0                	test   %eax,%eax
  8034ea:	74 0d                	je     8034f9 <insert_sorted_with_merge_freeList+0x4de>
  8034ec:	a1 48 51 80 00       	mov    0x805148,%eax
  8034f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8034f4:	89 50 04             	mov    %edx,0x4(%eax)
  8034f7:	eb 08                	jmp    803501 <insert_sorted_with_merge_freeList+0x4e6>
  8034f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8034fc:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803501:	8b 45 08             	mov    0x8(%ebp),%eax
  803504:	a3 48 51 80 00       	mov    %eax,0x805148
  803509:	8b 45 08             	mov    0x8(%ebp),%eax
  80350c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803513:	a1 54 51 80 00       	mov    0x805154,%eax
  803518:	40                   	inc    %eax
  803519:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  80351e:	e9 41 02 00 00       	jmp    803764 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803523:	8b 45 08             	mov    0x8(%ebp),%eax
  803526:	8b 50 08             	mov    0x8(%eax),%edx
  803529:	8b 45 08             	mov    0x8(%ebp),%eax
  80352c:	8b 40 0c             	mov    0xc(%eax),%eax
  80352f:	01 c2                	add    %eax,%edx
  803531:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803534:	8b 40 08             	mov    0x8(%eax),%eax
  803537:	39 c2                	cmp    %eax,%edx
  803539:	0f 85 7c 01 00 00    	jne    8036bb <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  80353f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803543:	74 06                	je     80354b <insert_sorted_with_merge_freeList+0x530>
  803545:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803549:	75 17                	jne    803562 <insert_sorted_with_merge_freeList+0x547>
  80354b:	83 ec 04             	sub    $0x4,%esp
  80354e:	68 e0 42 80 00       	push   $0x8042e0
  803553:	68 69 01 00 00       	push   $0x169
  803558:	68 c7 42 80 00       	push   $0x8042c7
  80355d:	e8 7f d1 ff ff       	call   8006e1 <_panic>
  803562:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803565:	8b 50 04             	mov    0x4(%eax),%edx
  803568:	8b 45 08             	mov    0x8(%ebp),%eax
  80356b:	89 50 04             	mov    %edx,0x4(%eax)
  80356e:	8b 45 08             	mov    0x8(%ebp),%eax
  803571:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803574:	89 10                	mov    %edx,(%eax)
  803576:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803579:	8b 40 04             	mov    0x4(%eax),%eax
  80357c:	85 c0                	test   %eax,%eax
  80357e:	74 0d                	je     80358d <insert_sorted_with_merge_freeList+0x572>
  803580:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803583:	8b 40 04             	mov    0x4(%eax),%eax
  803586:	8b 55 08             	mov    0x8(%ebp),%edx
  803589:	89 10                	mov    %edx,(%eax)
  80358b:	eb 08                	jmp    803595 <insert_sorted_with_merge_freeList+0x57a>
  80358d:	8b 45 08             	mov    0x8(%ebp),%eax
  803590:	a3 38 51 80 00       	mov    %eax,0x805138
  803595:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803598:	8b 55 08             	mov    0x8(%ebp),%edx
  80359b:	89 50 04             	mov    %edx,0x4(%eax)
  80359e:	a1 44 51 80 00       	mov    0x805144,%eax
  8035a3:	40                   	inc    %eax
  8035a4:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  8035a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ac:	8b 50 0c             	mov    0xc(%eax),%edx
  8035af:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035b2:	8b 40 0c             	mov    0xc(%eax),%eax
  8035b5:	01 c2                	add    %eax,%edx
  8035b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ba:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8035bd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8035c1:	75 17                	jne    8035da <insert_sorted_with_merge_freeList+0x5bf>
  8035c3:	83 ec 04             	sub    $0x4,%esp
  8035c6:	68 70 43 80 00       	push   $0x804370
  8035cb:	68 6b 01 00 00       	push   $0x16b
  8035d0:	68 c7 42 80 00       	push   $0x8042c7
  8035d5:	e8 07 d1 ff ff       	call   8006e1 <_panic>
  8035da:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035dd:	8b 00                	mov    (%eax),%eax
  8035df:	85 c0                	test   %eax,%eax
  8035e1:	74 10                	je     8035f3 <insert_sorted_with_merge_freeList+0x5d8>
  8035e3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035e6:	8b 00                	mov    (%eax),%eax
  8035e8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8035eb:	8b 52 04             	mov    0x4(%edx),%edx
  8035ee:	89 50 04             	mov    %edx,0x4(%eax)
  8035f1:	eb 0b                	jmp    8035fe <insert_sorted_with_merge_freeList+0x5e3>
  8035f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035f6:	8b 40 04             	mov    0x4(%eax),%eax
  8035f9:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8035fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803601:	8b 40 04             	mov    0x4(%eax),%eax
  803604:	85 c0                	test   %eax,%eax
  803606:	74 0f                	je     803617 <insert_sorted_with_merge_freeList+0x5fc>
  803608:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80360b:	8b 40 04             	mov    0x4(%eax),%eax
  80360e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803611:	8b 12                	mov    (%edx),%edx
  803613:	89 10                	mov    %edx,(%eax)
  803615:	eb 0a                	jmp    803621 <insert_sorted_with_merge_freeList+0x606>
  803617:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80361a:	8b 00                	mov    (%eax),%eax
  80361c:	a3 38 51 80 00       	mov    %eax,0x805138
  803621:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803624:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80362a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80362d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803634:	a1 44 51 80 00       	mov    0x805144,%eax
  803639:	48                   	dec    %eax
  80363a:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  80363f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803642:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803649:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80364c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803653:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803657:	75 17                	jne    803670 <insert_sorted_with_merge_freeList+0x655>
  803659:	83 ec 04             	sub    $0x4,%esp
  80365c:	68 a4 42 80 00       	push   $0x8042a4
  803661:	68 6e 01 00 00       	push   $0x16e
  803666:	68 c7 42 80 00       	push   $0x8042c7
  80366b:	e8 71 d0 ff ff       	call   8006e1 <_panic>
  803670:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803676:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803679:	89 10                	mov    %edx,(%eax)
  80367b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80367e:	8b 00                	mov    (%eax),%eax
  803680:	85 c0                	test   %eax,%eax
  803682:	74 0d                	je     803691 <insert_sorted_with_merge_freeList+0x676>
  803684:	a1 48 51 80 00       	mov    0x805148,%eax
  803689:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80368c:	89 50 04             	mov    %edx,0x4(%eax)
  80368f:	eb 08                	jmp    803699 <insert_sorted_with_merge_freeList+0x67e>
  803691:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803694:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803699:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80369c:	a3 48 51 80 00       	mov    %eax,0x805148
  8036a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036a4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036ab:	a1 54 51 80 00       	mov    0x805154,%eax
  8036b0:	40                   	inc    %eax
  8036b1:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8036b6:	e9 a9 00 00 00       	jmp    803764 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  8036bb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036bf:	74 06                	je     8036c7 <insert_sorted_with_merge_freeList+0x6ac>
  8036c1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8036c5:	75 17                	jne    8036de <insert_sorted_with_merge_freeList+0x6c3>
  8036c7:	83 ec 04             	sub    $0x4,%esp
  8036ca:	68 3c 43 80 00       	push   $0x80433c
  8036cf:	68 73 01 00 00       	push   $0x173
  8036d4:	68 c7 42 80 00       	push   $0x8042c7
  8036d9:	e8 03 d0 ff ff       	call   8006e1 <_panic>
  8036de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036e1:	8b 10                	mov    (%eax),%edx
  8036e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8036e6:	89 10                	mov    %edx,(%eax)
  8036e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8036eb:	8b 00                	mov    (%eax),%eax
  8036ed:	85 c0                	test   %eax,%eax
  8036ef:	74 0b                	je     8036fc <insert_sorted_with_merge_freeList+0x6e1>
  8036f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036f4:	8b 00                	mov    (%eax),%eax
  8036f6:	8b 55 08             	mov    0x8(%ebp),%edx
  8036f9:	89 50 04             	mov    %edx,0x4(%eax)
  8036fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036ff:	8b 55 08             	mov    0x8(%ebp),%edx
  803702:	89 10                	mov    %edx,(%eax)
  803704:	8b 45 08             	mov    0x8(%ebp),%eax
  803707:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80370a:	89 50 04             	mov    %edx,0x4(%eax)
  80370d:	8b 45 08             	mov    0x8(%ebp),%eax
  803710:	8b 00                	mov    (%eax),%eax
  803712:	85 c0                	test   %eax,%eax
  803714:	75 08                	jne    80371e <insert_sorted_with_merge_freeList+0x703>
  803716:	8b 45 08             	mov    0x8(%ebp),%eax
  803719:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80371e:	a1 44 51 80 00       	mov    0x805144,%eax
  803723:	40                   	inc    %eax
  803724:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803729:	eb 39                	jmp    803764 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  80372b:	a1 40 51 80 00       	mov    0x805140,%eax
  803730:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803733:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803737:	74 07                	je     803740 <insert_sorted_with_merge_freeList+0x725>
  803739:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80373c:	8b 00                	mov    (%eax),%eax
  80373e:	eb 05                	jmp    803745 <insert_sorted_with_merge_freeList+0x72a>
  803740:	b8 00 00 00 00       	mov    $0x0,%eax
  803745:	a3 40 51 80 00       	mov    %eax,0x805140
  80374a:	a1 40 51 80 00       	mov    0x805140,%eax
  80374f:	85 c0                	test   %eax,%eax
  803751:	0f 85 c7 fb ff ff    	jne    80331e <insert_sorted_with_merge_freeList+0x303>
  803757:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80375b:	0f 85 bd fb ff ff    	jne    80331e <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803761:	eb 01                	jmp    803764 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803763:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803764:	90                   	nop
  803765:	c9                   	leave  
  803766:	c3                   	ret    
  803767:	90                   	nop

00803768 <__udivdi3>:
  803768:	55                   	push   %ebp
  803769:	57                   	push   %edi
  80376a:	56                   	push   %esi
  80376b:	53                   	push   %ebx
  80376c:	83 ec 1c             	sub    $0x1c,%esp
  80376f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803773:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803777:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80377b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80377f:	89 ca                	mov    %ecx,%edx
  803781:	89 f8                	mov    %edi,%eax
  803783:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803787:	85 f6                	test   %esi,%esi
  803789:	75 2d                	jne    8037b8 <__udivdi3+0x50>
  80378b:	39 cf                	cmp    %ecx,%edi
  80378d:	77 65                	ja     8037f4 <__udivdi3+0x8c>
  80378f:	89 fd                	mov    %edi,%ebp
  803791:	85 ff                	test   %edi,%edi
  803793:	75 0b                	jne    8037a0 <__udivdi3+0x38>
  803795:	b8 01 00 00 00       	mov    $0x1,%eax
  80379a:	31 d2                	xor    %edx,%edx
  80379c:	f7 f7                	div    %edi
  80379e:	89 c5                	mov    %eax,%ebp
  8037a0:	31 d2                	xor    %edx,%edx
  8037a2:	89 c8                	mov    %ecx,%eax
  8037a4:	f7 f5                	div    %ebp
  8037a6:	89 c1                	mov    %eax,%ecx
  8037a8:	89 d8                	mov    %ebx,%eax
  8037aa:	f7 f5                	div    %ebp
  8037ac:	89 cf                	mov    %ecx,%edi
  8037ae:	89 fa                	mov    %edi,%edx
  8037b0:	83 c4 1c             	add    $0x1c,%esp
  8037b3:	5b                   	pop    %ebx
  8037b4:	5e                   	pop    %esi
  8037b5:	5f                   	pop    %edi
  8037b6:	5d                   	pop    %ebp
  8037b7:	c3                   	ret    
  8037b8:	39 ce                	cmp    %ecx,%esi
  8037ba:	77 28                	ja     8037e4 <__udivdi3+0x7c>
  8037bc:	0f bd fe             	bsr    %esi,%edi
  8037bf:	83 f7 1f             	xor    $0x1f,%edi
  8037c2:	75 40                	jne    803804 <__udivdi3+0x9c>
  8037c4:	39 ce                	cmp    %ecx,%esi
  8037c6:	72 0a                	jb     8037d2 <__udivdi3+0x6a>
  8037c8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8037cc:	0f 87 9e 00 00 00    	ja     803870 <__udivdi3+0x108>
  8037d2:	b8 01 00 00 00       	mov    $0x1,%eax
  8037d7:	89 fa                	mov    %edi,%edx
  8037d9:	83 c4 1c             	add    $0x1c,%esp
  8037dc:	5b                   	pop    %ebx
  8037dd:	5e                   	pop    %esi
  8037de:	5f                   	pop    %edi
  8037df:	5d                   	pop    %ebp
  8037e0:	c3                   	ret    
  8037e1:	8d 76 00             	lea    0x0(%esi),%esi
  8037e4:	31 ff                	xor    %edi,%edi
  8037e6:	31 c0                	xor    %eax,%eax
  8037e8:	89 fa                	mov    %edi,%edx
  8037ea:	83 c4 1c             	add    $0x1c,%esp
  8037ed:	5b                   	pop    %ebx
  8037ee:	5e                   	pop    %esi
  8037ef:	5f                   	pop    %edi
  8037f0:	5d                   	pop    %ebp
  8037f1:	c3                   	ret    
  8037f2:	66 90                	xchg   %ax,%ax
  8037f4:	89 d8                	mov    %ebx,%eax
  8037f6:	f7 f7                	div    %edi
  8037f8:	31 ff                	xor    %edi,%edi
  8037fa:	89 fa                	mov    %edi,%edx
  8037fc:	83 c4 1c             	add    $0x1c,%esp
  8037ff:	5b                   	pop    %ebx
  803800:	5e                   	pop    %esi
  803801:	5f                   	pop    %edi
  803802:	5d                   	pop    %ebp
  803803:	c3                   	ret    
  803804:	bd 20 00 00 00       	mov    $0x20,%ebp
  803809:	89 eb                	mov    %ebp,%ebx
  80380b:	29 fb                	sub    %edi,%ebx
  80380d:	89 f9                	mov    %edi,%ecx
  80380f:	d3 e6                	shl    %cl,%esi
  803811:	89 c5                	mov    %eax,%ebp
  803813:	88 d9                	mov    %bl,%cl
  803815:	d3 ed                	shr    %cl,%ebp
  803817:	89 e9                	mov    %ebp,%ecx
  803819:	09 f1                	or     %esi,%ecx
  80381b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80381f:	89 f9                	mov    %edi,%ecx
  803821:	d3 e0                	shl    %cl,%eax
  803823:	89 c5                	mov    %eax,%ebp
  803825:	89 d6                	mov    %edx,%esi
  803827:	88 d9                	mov    %bl,%cl
  803829:	d3 ee                	shr    %cl,%esi
  80382b:	89 f9                	mov    %edi,%ecx
  80382d:	d3 e2                	shl    %cl,%edx
  80382f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803833:	88 d9                	mov    %bl,%cl
  803835:	d3 e8                	shr    %cl,%eax
  803837:	09 c2                	or     %eax,%edx
  803839:	89 d0                	mov    %edx,%eax
  80383b:	89 f2                	mov    %esi,%edx
  80383d:	f7 74 24 0c          	divl   0xc(%esp)
  803841:	89 d6                	mov    %edx,%esi
  803843:	89 c3                	mov    %eax,%ebx
  803845:	f7 e5                	mul    %ebp
  803847:	39 d6                	cmp    %edx,%esi
  803849:	72 19                	jb     803864 <__udivdi3+0xfc>
  80384b:	74 0b                	je     803858 <__udivdi3+0xf0>
  80384d:	89 d8                	mov    %ebx,%eax
  80384f:	31 ff                	xor    %edi,%edi
  803851:	e9 58 ff ff ff       	jmp    8037ae <__udivdi3+0x46>
  803856:	66 90                	xchg   %ax,%ax
  803858:	8b 54 24 08          	mov    0x8(%esp),%edx
  80385c:	89 f9                	mov    %edi,%ecx
  80385e:	d3 e2                	shl    %cl,%edx
  803860:	39 c2                	cmp    %eax,%edx
  803862:	73 e9                	jae    80384d <__udivdi3+0xe5>
  803864:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803867:	31 ff                	xor    %edi,%edi
  803869:	e9 40 ff ff ff       	jmp    8037ae <__udivdi3+0x46>
  80386e:	66 90                	xchg   %ax,%ax
  803870:	31 c0                	xor    %eax,%eax
  803872:	e9 37 ff ff ff       	jmp    8037ae <__udivdi3+0x46>
  803877:	90                   	nop

00803878 <__umoddi3>:
  803878:	55                   	push   %ebp
  803879:	57                   	push   %edi
  80387a:	56                   	push   %esi
  80387b:	53                   	push   %ebx
  80387c:	83 ec 1c             	sub    $0x1c,%esp
  80387f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803883:	8b 74 24 34          	mov    0x34(%esp),%esi
  803887:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80388b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80388f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803893:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803897:	89 f3                	mov    %esi,%ebx
  803899:	89 fa                	mov    %edi,%edx
  80389b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80389f:	89 34 24             	mov    %esi,(%esp)
  8038a2:	85 c0                	test   %eax,%eax
  8038a4:	75 1a                	jne    8038c0 <__umoddi3+0x48>
  8038a6:	39 f7                	cmp    %esi,%edi
  8038a8:	0f 86 a2 00 00 00    	jbe    803950 <__umoddi3+0xd8>
  8038ae:	89 c8                	mov    %ecx,%eax
  8038b0:	89 f2                	mov    %esi,%edx
  8038b2:	f7 f7                	div    %edi
  8038b4:	89 d0                	mov    %edx,%eax
  8038b6:	31 d2                	xor    %edx,%edx
  8038b8:	83 c4 1c             	add    $0x1c,%esp
  8038bb:	5b                   	pop    %ebx
  8038bc:	5e                   	pop    %esi
  8038bd:	5f                   	pop    %edi
  8038be:	5d                   	pop    %ebp
  8038bf:	c3                   	ret    
  8038c0:	39 f0                	cmp    %esi,%eax
  8038c2:	0f 87 ac 00 00 00    	ja     803974 <__umoddi3+0xfc>
  8038c8:	0f bd e8             	bsr    %eax,%ebp
  8038cb:	83 f5 1f             	xor    $0x1f,%ebp
  8038ce:	0f 84 ac 00 00 00    	je     803980 <__umoddi3+0x108>
  8038d4:	bf 20 00 00 00       	mov    $0x20,%edi
  8038d9:	29 ef                	sub    %ebp,%edi
  8038db:	89 fe                	mov    %edi,%esi
  8038dd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8038e1:	89 e9                	mov    %ebp,%ecx
  8038e3:	d3 e0                	shl    %cl,%eax
  8038e5:	89 d7                	mov    %edx,%edi
  8038e7:	89 f1                	mov    %esi,%ecx
  8038e9:	d3 ef                	shr    %cl,%edi
  8038eb:	09 c7                	or     %eax,%edi
  8038ed:	89 e9                	mov    %ebp,%ecx
  8038ef:	d3 e2                	shl    %cl,%edx
  8038f1:	89 14 24             	mov    %edx,(%esp)
  8038f4:	89 d8                	mov    %ebx,%eax
  8038f6:	d3 e0                	shl    %cl,%eax
  8038f8:	89 c2                	mov    %eax,%edx
  8038fa:	8b 44 24 08          	mov    0x8(%esp),%eax
  8038fe:	d3 e0                	shl    %cl,%eax
  803900:	89 44 24 04          	mov    %eax,0x4(%esp)
  803904:	8b 44 24 08          	mov    0x8(%esp),%eax
  803908:	89 f1                	mov    %esi,%ecx
  80390a:	d3 e8                	shr    %cl,%eax
  80390c:	09 d0                	or     %edx,%eax
  80390e:	d3 eb                	shr    %cl,%ebx
  803910:	89 da                	mov    %ebx,%edx
  803912:	f7 f7                	div    %edi
  803914:	89 d3                	mov    %edx,%ebx
  803916:	f7 24 24             	mull   (%esp)
  803919:	89 c6                	mov    %eax,%esi
  80391b:	89 d1                	mov    %edx,%ecx
  80391d:	39 d3                	cmp    %edx,%ebx
  80391f:	0f 82 87 00 00 00    	jb     8039ac <__umoddi3+0x134>
  803925:	0f 84 91 00 00 00    	je     8039bc <__umoddi3+0x144>
  80392b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80392f:	29 f2                	sub    %esi,%edx
  803931:	19 cb                	sbb    %ecx,%ebx
  803933:	89 d8                	mov    %ebx,%eax
  803935:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803939:	d3 e0                	shl    %cl,%eax
  80393b:	89 e9                	mov    %ebp,%ecx
  80393d:	d3 ea                	shr    %cl,%edx
  80393f:	09 d0                	or     %edx,%eax
  803941:	89 e9                	mov    %ebp,%ecx
  803943:	d3 eb                	shr    %cl,%ebx
  803945:	89 da                	mov    %ebx,%edx
  803947:	83 c4 1c             	add    $0x1c,%esp
  80394a:	5b                   	pop    %ebx
  80394b:	5e                   	pop    %esi
  80394c:	5f                   	pop    %edi
  80394d:	5d                   	pop    %ebp
  80394e:	c3                   	ret    
  80394f:	90                   	nop
  803950:	89 fd                	mov    %edi,%ebp
  803952:	85 ff                	test   %edi,%edi
  803954:	75 0b                	jne    803961 <__umoddi3+0xe9>
  803956:	b8 01 00 00 00       	mov    $0x1,%eax
  80395b:	31 d2                	xor    %edx,%edx
  80395d:	f7 f7                	div    %edi
  80395f:	89 c5                	mov    %eax,%ebp
  803961:	89 f0                	mov    %esi,%eax
  803963:	31 d2                	xor    %edx,%edx
  803965:	f7 f5                	div    %ebp
  803967:	89 c8                	mov    %ecx,%eax
  803969:	f7 f5                	div    %ebp
  80396b:	89 d0                	mov    %edx,%eax
  80396d:	e9 44 ff ff ff       	jmp    8038b6 <__umoddi3+0x3e>
  803972:	66 90                	xchg   %ax,%ax
  803974:	89 c8                	mov    %ecx,%eax
  803976:	89 f2                	mov    %esi,%edx
  803978:	83 c4 1c             	add    $0x1c,%esp
  80397b:	5b                   	pop    %ebx
  80397c:	5e                   	pop    %esi
  80397d:	5f                   	pop    %edi
  80397e:	5d                   	pop    %ebp
  80397f:	c3                   	ret    
  803980:	3b 04 24             	cmp    (%esp),%eax
  803983:	72 06                	jb     80398b <__umoddi3+0x113>
  803985:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803989:	77 0f                	ja     80399a <__umoddi3+0x122>
  80398b:	89 f2                	mov    %esi,%edx
  80398d:	29 f9                	sub    %edi,%ecx
  80398f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803993:	89 14 24             	mov    %edx,(%esp)
  803996:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80399a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80399e:	8b 14 24             	mov    (%esp),%edx
  8039a1:	83 c4 1c             	add    $0x1c,%esp
  8039a4:	5b                   	pop    %ebx
  8039a5:	5e                   	pop    %esi
  8039a6:	5f                   	pop    %edi
  8039a7:	5d                   	pop    %ebp
  8039a8:	c3                   	ret    
  8039a9:	8d 76 00             	lea    0x0(%esi),%esi
  8039ac:	2b 04 24             	sub    (%esp),%eax
  8039af:	19 fa                	sbb    %edi,%edx
  8039b1:	89 d1                	mov    %edx,%ecx
  8039b3:	89 c6                	mov    %eax,%esi
  8039b5:	e9 71 ff ff ff       	jmp    80392b <__umoddi3+0xb3>
  8039ba:	66 90                	xchg   %ax,%ax
  8039bc:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8039c0:	72 ea                	jb     8039ac <__umoddi3+0x134>
  8039c2:	89 d9                	mov    %ebx,%ecx
  8039c4:	e9 62 ff ff ff       	jmp    80392b <__umoddi3+0xb3>
