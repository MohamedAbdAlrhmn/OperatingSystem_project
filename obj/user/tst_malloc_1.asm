
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
  80008d:	68 80 39 80 00       	push   $0x803980
  800092:	6a 14                	push   $0x14
  800094:	68 9c 39 80 00       	push   $0x80399c
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
  8000ca:	e8 6e 1a 00 00       	call   801b3d <sys_calculate_free_frames>
  8000cf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8000d2:	e8 06 1b 00 00       	call   801bdd <sys_pf_calculate_allocated_pages>
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
  800105:	68 b0 39 80 00       	push   $0x8039b0
  80010a:	6a 23                	push   $0x23
  80010c:	68 9c 39 80 00       	push   $0x80399c
  800111:	e8 cb 05 00 00       	call   8006e1 <_panic>
		//		if ((freeFrames - sys_calculate_free_frames()) != 512+1 ) panic("Wrong allocation: ");
		//cprintf("freeFrames - sys_calculate_free_frames() = %d\n", freeFrames - sys_calculate_free_frames()) ;
		//cprintf("Expected = %d\n", (1 + sizeOfMemBlocksArray/PAGE_SIZE));
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800116:	e8 22 1a 00 00       	call   801b3d <sys_calculate_free_frames>
  80011b:	89 c2                	mov    %eax,%edx
  80011d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800120:	39 c2                	cmp    %eax,%edx
  800122:	74 14                	je     800138 <_main+0x100>
  800124:	83 ec 04             	sub    $0x4,%esp
  800127:	68 e0 39 80 00       	push   $0x8039e0
  80012c:	6a 27                	push   $0x27
  80012e:	68 9c 39 80 00       	push   $0x80399c
  800133:	e8 a9 05 00 00       	call   8006e1 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800138:	e8 a0 1a 00 00       	call   801bdd <sys_pf_calculate_allocated_pages>
  80013d:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800140:	74 14                	je     800156 <_main+0x11e>
  800142:	83 ec 04             	sub    $0x4,%esp
  800145:	68 4c 3a 80 00       	push   $0x803a4c
  80014a:	6a 28                	push   $0x28
  80014c:	68 9c 39 80 00       	push   $0x80399c
  800151:	e8 8b 05 00 00       	call   8006e1 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800156:	e8 e2 19 00 00       	call   801b3d <sys_calculate_free_frames>
  80015b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80015e:	e8 7a 1a 00 00       	call   801bdd <sys_pf_calculate_allocated_pages>
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
  8001a6:	68 b0 39 80 00       	push   $0x8039b0
  8001ab:	6a 2d                	push   $0x2d
  8001ad:	68 9c 39 80 00       	push   $0x80399c
  8001b2:	e8 2a 05 00 00       	call   8006e1 <_panic>
		//		if ((freeFrames - sys_calculate_free_frames()) != 512 ) panic("Wrong allocation: ");
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8001b7:	e8 81 19 00 00       	call   801b3d <sys_calculate_free_frames>
  8001bc:	89 c2                	mov    %eax,%edx
  8001be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001c1:	39 c2                	cmp    %eax,%edx
  8001c3:	74 14                	je     8001d9 <_main+0x1a1>
  8001c5:	83 ec 04             	sub    $0x4,%esp
  8001c8:	68 e0 39 80 00       	push   $0x8039e0
  8001cd:	6a 2f                	push   $0x2f
  8001cf:	68 9c 39 80 00       	push   $0x80399c
  8001d4:	e8 08 05 00 00       	call   8006e1 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8001d9:	e8 ff 19 00 00       	call   801bdd <sys_pf_calculate_allocated_pages>
  8001de:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8001e1:	74 14                	je     8001f7 <_main+0x1bf>
  8001e3:	83 ec 04             	sub    $0x4,%esp
  8001e6:	68 4c 3a 80 00       	push   $0x803a4c
  8001eb:	6a 30                	push   $0x30
  8001ed:	68 9c 39 80 00       	push   $0x80399c
  8001f2:	e8 ea 04 00 00       	call   8006e1 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8001f7:	e8 41 19 00 00       	call   801b3d <sys_calculate_free_frames>
  8001fc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8001ff:	e8 d9 19 00 00       	call   801bdd <sys_pf_calculate_allocated_pages>
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
  80024a:	68 b0 39 80 00       	push   $0x8039b0
  80024f:	6a 35                	push   $0x35
  800251:	68 9c 39 80 00       	push   $0x80399c
  800256:	e8 86 04 00 00       	call   8006e1 <_panic>
		//		if ((freeFrames - sys_calculate_free_frames()) != 1+1 ) panic("Wrong allocation: ");
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  80025b:	e8 dd 18 00 00       	call   801b3d <sys_calculate_free_frames>
  800260:	89 c2                	mov    %eax,%edx
  800262:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800265:	39 c2                	cmp    %eax,%edx
  800267:	74 14                	je     80027d <_main+0x245>
  800269:	83 ec 04             	sub    $0x4,%esp
  80026c:	68 e0 39 80 00       	push   $0x8039e0
  800271:	6a 37                	push   $0x37
  800273:	68 9c 39 80 00       	push   $0x80399c
  800278:	e8 64 04 00 00       	call   8006e1 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  80027d:	e8 5b 19 00 00       	call   801bdd <sys_pf_calculate_allocated_pages>
  800282:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800285:	74 14                	je     80029b <_main+0x263>
  800287:	83 ec 04             	sub    $0x4,%esp
  80028a:	68 4c 3a 80 00       	push   $0x803a4c
  80028f:	6a 38                	push   $0x38
  800291:	68 9c 39 80 00       	push   $0x80399c
  800296:	e8 46 04 00 00       	call   8006e1 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  80029b:	e8 9d 18 00 00       	call   801b3d <sys_calculate_free_frames>
  8002a0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8002a3:	e8 35 19 00 00       	call   801bdd <sys_pf_calculate_allocated_pages>
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
  800302:	68 b0 39 80 00       	push   $0x8039b0
  800307:	6a 3d                	push   $0x3d
  800309:	68 9c 39 80 00       	push   $0x80399c
  80030e:	e8 ce 03 00 00       	call   8006e1 <_panic>
		//		if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: ");
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800313:	e8 25 18 00 00       	call   801b3d <sys_calculate_free_frames>
  800318:	89 c2                	mov    %eax,%edx
  80031a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80031d:	39 c2                	cmp    %eax,%edx
  80031f:	74 14                	je     800335 <_main+0x2fd>
  800321:	83 ec 04             	sub    $0x4,%esp
  800324:	68 e0 39 80 00       	push   $0x8039e0
  800329:	6a 3f                	push   $0x3f
  80032b:	68 9c 39 80 00       	push   $0x80399c
  800330:	e8 ac 03 00 00       	call   8006e1 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800335:	e8 a3 18 00 00       	call   801bdd <sys_pf_calculate_allocated_pages>
  80033a:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80033d:	74 14                	je     800353 <_main+0x31b>
  80033f:	83 ec 04             	sub    $0x4,%esp
  800342:	68 4c 3a 80 00       	push   $0x803a4c
  800347:	6a 40                	push   $0x40
  800349:	68 9c 39 80 00       	push   $0x80399c
  80034e:	e8 8e 03 00 00       	call   8006e1 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800353:	e8 e5 17 00 00       	call   801b3d <sys_calculate_free_frames>
  800358:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80035b:	e8 7d 18 00 00       	call   801bdd <sys_pf_calculate_allocated_pages>
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
  8003be:	68 b0 39 80 00       	push   $0x8039b0
  8003c3:	6a 45                	push   $0x45
  8003c5:	68 9c 39 80 00       	push   $0x80399c
  8003ca:	e8 12 03 00 00       	call   8006e1 <_panic>
		//		if ((freeFrames - sys_calculate_free_frames()) != 2)panic("Wrong allocation: ");
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8003cf:	e8 69 17 00 00       	call   801b3d <sys_calculate_free_frames>
  8003d4:	89 c2                	mov    %eax,%edx
  8003d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003d9:	39 c2                	cmp    %eax,%edx
  8003db:	74 14                	je     8003f1 <_main+0x3b9>
  8003dd:	83 ec 04             	sub    $0x4,%esp
  8003e0:	68 e0 39 80 00       	push   $0x8039e0
  8003e5:	6a 47                	push   $0x47
  8003e7:	68 9c 39 80 00       	push   $0x80399c
  8003ec:	e8 f0 02 00 00       	call   8006e1 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8003f1:	e8 e7 17 00 00       	call   801bdd <sys_pf_calculate_allocated_pages>
  8003f6:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8003f9:	74 14                	je     80040f <_main+0x3d7>
  8003fb:	83 ec 04             	sub    $0x4,%esp
  8003fe:	68 4c 3a 80 00       	push   $0x803a4c
  800403:	6a 48                	push   $0x48
  800405:	68 9c 39 80 00       	push   $0x80399c
  80040a:	e8 d2 02 00 00       	call   8006e1 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  80040f:	e8 29 17 00 00       	call   801b3d <sys_calculate_free_frames>
  800414:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800417:	e8 c1 17 00 00       	call   801bdd <sys_pf_calculate_allocated_pages>
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
  800479:	68 b0 39 80 00       	push   $0x8039b0
  80047e:	6a 4d                	push   $0x4d
  800480:	68 9c 39 80 00       	push   $0x80399c
  800485:	e8 57 02 00 00       	call   8006e1 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  80048a:	e8 ae 16 00 00       	call   801b3d <sys_calculate_free_frames>
  80048f:	89 c2                	mov    %eax,%edx
  800491:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800494:	39 c2                	cmp    %eax,%edx
  800496:	74 14                	je     8004ac <_main+0x474>
  800498:	83 ec 04             	sub    $0x4,%esp
  80049b:	68 7a 3a 80 00       	push   $0x803a7a
  8004a0:	6a 4e                	push   $0x4e
  8004a2:	68 9c 39 80 00       	push   $0x80399c
  8004a7:	e8 35 02 00 00       	call   8006e1 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8004ac:	e8 2c 17 00 00       	call   801bdd <sys_pf_calculate_allocated_pages>
  8004b1:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8004b4:	74 14                	je     8004ca <_main+0x492>
  8004b6:	83 ec 04             	sub    $0x4,%esp
  8004b9:	68 4c 3a 80 00       	push   $0x803a4c
  8004be:	6a 4f                	push   $0x4f
  8004c0:	68 9c 39 80 00       	push   $0x80399c
  8004c5:	e8 17 02 00 00       	call   8006e1 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8004ca:	e8 6e 16 00 00       	call   801b3d <sys_calculate_free_frames>
  8004cf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8004d2:	e8 06 17 00 00       	call   801bdd <sys_pf_calculate_allocated_pages>
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
  80053e:	68 b0 39 80 00       	push   $0x8039b0
  800543:	6a 54                	push   $0x54
  800545:	68 9c 39 80 00       	push   $0x80399c
  80054a:	e8 92 01 00 00       	call   8006e1 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  80054f:	e8 e9 15 00 00       	call   801b3d <sys_calculate_free_frames>
  800554:	89 c2                	mov    %eax,%edx
  800556:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800559:	39 c2                	cmp    %eax,%edx
  80055b:	74 14                	je     800571 <_main+0x539>
  80055d:	83 ec 04             	sub    $0x4,%esp
  800560:	68 7a 3a 80 00       	push   $0x803a7a
  800565:	6a 55                	push   $0x55
  800567:	68 9c 39 80 00       	push   $0x80399c
  80056c:	e8 70 01 00 00       	call   8006e1 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800571:	e8 67 16 00 00       	call   801bdd <sys_pf_calculate_allocated_pages>
  800576:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800579:	74 14                	je     80058f <_main+0x557>
  80057b:	83 ec 04             	sub    $0x4,%esp
  80057e:	68 4c 3a 80 00       	push   $0x803a4c
  800583:	6a 56                	push   $0x56
  800585:	68 9c 39 80 00       	push   $0x80399c
  80058a:	e8 52 01 00 00       	call   8006e1 <_panic>
	}

	cprintf("Congratulations!! test malloc (1) completed successfully.\n");
  80058f:	83 ec 0c             	sub    $0xc,%esp
  800592:	68 90 3a 80 00       	push   $0x803a90
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
  8005ab:	e8 6d 18 00 00       	call   801e1d <sys_getenvindex>
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
  800616:	e8 0f 16 00 00       	call   801c2a <sys_disable_interrupt>
	cprintf("**************************************\n");
  80061b:	83 ec 0c             	sub    $0xc,%esp
  80061e:	68 e4 3a 80 00       	push   $0x803ae4
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
  800646:	68 0c 3b 80 00       	push   $0x803b0c
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
  800677:	68 34 3b 80 00       	push   $0x803b34
  80067c:	e8 14 03 00 00       	call   800995 <cprintf>
  800681:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800684:	a1 20 50 80 00       	mov    0x805020,%eax
  800689:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80068f:	83 ec 08             	sub    $0x8,%esp
  800692:	50                   	push   %eax
  800693:	68 8c 3b 80 00       	push   $0x803b8c
  800698:	e8 f8 02 00 00       	call   800995 <cprintf>
  80069d:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8006a0:	83 ec 0c             	sub    $0xc,%esp
  8006a3:	68 e4 3a 80 00       	push   $0x803ae4
  8006a8:	e8 e8 02 00 00       	call   800995 <cprintf>
  8006ad:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8006b0:	e8 8f 15 00 00       	call   801c44 <sys_enable_interrupt>

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
  8006c8:	e8 1c 17 00 00       	call   801de9 <sys_destroy_env>
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
  8006d9:	e8 71 17 00 00       	call   801e4f <sys_exit_env>
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
  800702:	68 a0 3b 80 00       	push   $0x803ba0
  800707:	e8 89 02 00 00       	call   800995 <cprintf>
  80070c:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80070f:	a1 00 50 80 00       	mov    0x805000,%eax
  800714:	ff 75 0c             	pushl  0xc(%ebp)
  800717:	ff 75 08             	pushl  0x8(%ebp)
  80071a:	50                   	push   %eax
  80071b:	68 a5 3b 80 00       	push   $0x803ba5
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
  80073f:	68 c1 3b 80 00       	push   $0x803bc1
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
  80076b:	68 c4 3b 80 00       	push   $0x803bc4
  800770:	6a 26                	push   $0x26
  800772:	68 10 3c 80 00       	push   $0x803c10
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
  80083d:	68 1c 3c 80 00       	push   $0x803c1c
  800842:	6a 3a                	push   $0x3a
  800844:	68 10 3c 80 00       	push   $0x803c10
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
  8008ad:	68 70 3c 80 00       	push   $0x803c70
  8008b2:	6a 44                	push   $0x44
  8008b4:	68 10 3c 80 00       	push   $0x803c10
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
  800907:	e8 70 11 00 00       	call   801a7c <sys_cputs>
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
  80097e:	e8 f9 10 00 00       	call   801a7c <sys_cputs>
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
  8009c8:	e8 5d 12 00 00       	call   801c2a <sys_disable_interrupt>
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
  8009e8:	e8 57 12 00 00       	call   801c44 <sys_enable_interrupt>
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
  800a32:	e8 c9 2c 00 00       	call   803700 <__udivdi3>
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
  800a82:	e8 89 2d 00 00       	call   803810 <__umoddi3>
  800a87:	83 c4 10             	add    $0x10,%esp
  800a8a:	05 d4 3e 80 00       	add    $0x803ed4,%eax
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
  800bdd:	8b 04 85 f8 3e 80 00 	mov    0x803ef8(,%eax,4),%eax
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
  800cbe:	8b 34 9d 40 3d 80 00 	mov    0x803d40(,%ebx,4),%esi
  800cc5:	85 f6                	test   %esi,%esi
  800cc7:	75 19                	jne    800ce2 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800cc9:	53                   	push   %ebx
  800cca:	68 e5 3e 80 00       	push   $0x803ee5
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
  800ce3:	68 ee 3e 80 00       	push   $0x803eee
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
  800d10:	be f1 3e 80 00       	mov    $0x803ef1,%esi
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
  801736:	68 50 40 80 00       	push   $0x804050
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
  801806:	e8 b5 03 00 00       	call   801bc0 <sys_allocate_chunk>
  80180b:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  80180e:	a1 20 51 80 00       	mov    0x805120,%eax
  801813:	83 ec 0c             	sub    $0xc,%esp
  801816:	50                   	push   %eax
  801817:	e8 2a 0a 00 00       	call   802246 <initialize_MemBlocksList>
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
  801844:	68 75 40 80 00       	push   $0x804075
  801849:	6a 33                	push   $0x33
  80184b:	68 93 40 80 00       	push   $0x804093
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
  8018c3:	68 a0 40 80 00       	push   $0x8040a0
  8018c8:	6a 34                	push   $0x34
  8018ca:	68 93 40 80 00       	push   $0x804093
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
  801938:	68 c4 40 80 00       	push   $0x8040c4
  80193d:	6a 46                	push   $0x46
  80193f:	68 93 40 80 00       	push   $0x804093
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
  801954:	68 ec 40 80 00       	push   $0x8040ec
  801959:	6a 61                	push   $0x61
  80195b:	68 93 40 80 00       	push   $0x804093
  801960:	e8 7c ed ff ff       	call   8006e1 <_panic>

00801965 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801965:	55                   	push   %ebp
  801966:	89 e5                	mov    %esp,%ebp
  801968:	83 ec 18             	sub    $0x18,%esp
  80196b:	8b 45 10             	mov    0x10(%ebp),%eax
  80196e:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801971:	e8 a9 fd ff ff       	call   80171f <InitializeUHeap>
	if (size == 0) return NULL ;
  801976:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80197a:	75 07                	jne    801983 <smalloc+0x1e>
  80197c:	b8 00 00 00 00       	mov    $0x0,%eax
  801981:	eb 14                	jmp    801997 <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  801983:	83 ec 04             	sub    $0x4,%esp
  801986:	68 10 41 80 00       	push   $0x804110
  80198b:	6a 76                	push   $0x76
  80198d:	68 93 40 80 00       	push   $0x804093
  801992:	e8 4a ed ff ff       	call   8006e1 <_panic>

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801997:	c9                   	leave  
  801998:	c3                   	ret    

00801999 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801999:	55                   	push   %ebp
  80199a:	89 e5                	mov    %esp,%ebp
  80199c:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80199f:	e8 7b fd ff ff       	call   80171f <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8019a4:	83 ec 04             	sub    $0x4,%esp
  8019a7:	68 38 41 80 00       	push   $0x804138
  8019ac:	68 93 00 00 00       	push   $0x93
  8019b1:	68 93 40 80 00       	push   $0x804093
  8019b6:	e8 26 ed ff ff       	call   8006e1 <_panic>

008019bb <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8019bb:	55                   	push   %ebp
  8019bc:	89 e5                	mov    %esp,%ebp
  8019be:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8019c1:	e8 59 fd ff ff       	call   80171f <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8019c6:	83 ec 04             	sub    $0x4,%esp
  8019c9:	68 5c 41 80 00       	push   $0x80415c
  8019ce:	68 c5 00 00 00       	push   $0xc5
  8019d3:	68 93 40 80 00       	push   $0x804093
  8019d8:	e8 04 ed ff ff       	call   8006e1 <_panic>

008019dd <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8019dd:	55                   	push   %ebp
  8019de:	89 e5                	mov    %esp,%ebp
  8019e0:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8019e3:	83 ec 04             	sub    $0x4,%esp
  8019e6:	68 84 41 80 00       	push   $0x804184
  8019eb:	68 d9 00 00 00       	push   $0xd9
  8019f0:	68 93 40 80 00       	push   $0x804093
  8019f5:	e8 e7 ec ff ff       	call   8006e1 <_panic>

008019fa <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8019fa:	55                   	push   %ebp
  8019fb:	89 e5                	mov    %esp,%ebp
  8019fd:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a00:	83 ec 04             	sub    $0x4,%esp
  801a03:	68 a8 41 80 00       	push   $0x8041a8
  801a08:	68 e4 00 00 00       	push   $0xe4
  801a0d:	68 93 40 80 00       	push   $0x804093
  801a12:	e8 ca ec ff ff       	call   8006e1 <_panic>

00801a17 <shrink>:

}
void shrink(uint32 newSize)
{
  801a17:	55                   	push   %ebp
  801a18:	89 e5                	mov    %esp,%ebp
  801a1a:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a1d:	83 ec 04             	sub    $0x4,%esp
  801a20:	68 a8 41 80 00       	push   $0x8041a8
  801a25:	68 e9 00 00 00       	push   $0xe9
  801a2a:	68 93 40 80 00       	push   $0x804093
  801a2f:	e8 ad ec ff ff       	call   8006e1 <_panic>

00801a34 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801a34:	55                   	push   %ebp
  801a35:	89 e5                	mov    %esp,%ebp
  801a37:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a3a:	83 ec 04             	sub    $0x4,%esp
  801a3d:	68 a8 41 80 00       	push   $0x8041a8
  801a42:	68 ee 00 00 00       	push   $0xee
  801a47:	68 93 40 80 00       	push   $0x804093
  801a4c:	e8 90 ec ff ff       	call   8006e1 <_panic>

00801a51 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801a51:	55                   	push   %ebp
  801a52:	89 e5                	mov    %esp,%ebp
  801a54:	57                   	push   %edi
  801a55:	56                   	push   %esi
  801a56:	53                   	push   %ebx
  801a57:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801a5a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a60:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a63:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a66:	8b 7d 18             	mov    0x18(%ebp),%edi
  801a69:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801a6c:	cd 30                	int    $0x30
  801a6e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801a71:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801a74:	83 c4 10             	add    $0x10,%esp
  801a77:	5b                   	pop    %ebx
  801a78:	5e                   	pop    %esi
  801a79:	5f                   	pop    %edi
  801a7a:	5d                   	pop    %ebp
  801a7b:	c3                   	ret    

00801a7c <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801a7c:	55                   	push   %ebp
  801a7d:	89 e5                	mov    %esp,%ebp
  801a7f:	83 ec 04             	sub    $0x4,%esp
  801a82:	8b 45 10             	mov    0x10(%ebp),%eax
  801a85:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801a88:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8f:	6a 00                	push   $0x0
  801a91:	6a 00                	push   $0x0
  801a93:	52                   	push   %edx
  801a94:	ff 75 0c             	pushl  0xc(%ebp)
  801a97:	50                   	push   %eax
  801a98:	6a 00                	push   $0x0
  801a9a:	e8 b2 ff ff ff       	call   801a51 <syscall>
  801a9f:	83 c4 18             	add    $0x18,%esp
}
  801aa2:	90                   	nop
  801aa3:	c9                   	leave  
  801aa4:	c3                   	ret    

00801aa5 <sys_cgetc>:

int
sys_cgetc(void)
{
  801aa5:	55                   	push   %ebp
  801aa6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801aa8:	6a 00                	push   $0x0
  801aaa:	6a 00                	push   $0x0
  801aac:	6a 00                	push   $0x0
  801aae:	6a 00                	push   $0x0
  801ab0:	6a 00                	push   $0x0
  801ab2:	6a 01                	push   $0x1
  801ab4:	e8 98 ff ff ff       	call   801a51 <syscall>
  801ab9:	83 c4 18             	add    $0x18,%esp
}
  801abc:	c9                   	leave  
  801abd:	c3                   	ret    

00801abe <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801abe:	55                   	push   %ebp
  801abf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801ac1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ac4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac7:	6a 00                	push   $0x0
  801ac9:	6a 00                	push   $0x0
  801acb:	6a 00                	push   $0x0
  801acd:	52                   	push   %edx
  801ace:	50                   	push   %eax
  801acf:	6a 05                	push   $0x5
  801ad1:	e8 7b ff ff ff       	call   801a51 <syscall>
  801ad6:	83 c4 18             	add    $0x18,%esp
}
  801ad9:	c9                   	leave  
  801ada:	c3                   	ret    

00801adb <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801adb:	55                   	push   %ebp
  801adc:	89 e5                	mov    %esp,%ebp
  801ade:	56                   	push   %esi
  801adf:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801ae0:	8b 75 18             	mov    0x18(%ebp),%esi
  801ae3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ae6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ae9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aec:	8b 45 08             	mov    0x8(%ebp),%eax
  801aef:	56                   	push   %esi
  801af0:	53                   	push   %ebx
  801af1:	51                   	push   %ecx
  801af2:	52                   	push   %edx
  801af3:	50                   	push   %eax
  801af4:	6a 06                	push   $0x6
  801af6:	e8 56 ff ff ff       	call   801a51 <syscall>
  801afb:	83 c4 18             	add    $0x18,%esp
}
  801afe:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b01:	5b                   	pop    %ebx
  801b02:	5e                   	pop    %esi
  801b03:	5d                   	pop    %ebp
  801b04:	c3                   	ret    

00801b05 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801b05:	55                   	push   %ebp
  801b06:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801b08:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0e:	6a 00                	push   $0x0
  801b10:	6a 00                	push   $0x0
  801b12:	6a 00                	push   $0x0
  801b14:	52                   	push   %edx
  801b15:	50                   	push   %eax
  801b16:	6a 07                	push   $0x7
  801b18:	e8 34 ff ff ff       	call   801a51 <syscall>
  801b1d:	83 c4 18             	add    $0x18,%esp
}
  801b20:	c9                   	leave  
  801b21:	c3                   	ret    

00801b22 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801b22:	55                   	push   %ebp
  801b23:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801b25:	6a 00                	push   $0x0
  801b27:	6a 00                	push   $0x0
  801b29:	6a 00                	push   $0x0
  801b2b:	ff 75 0c             	pushl  0xc(%ebp)
  801b2e:	ff 75 08             	pushl  0x8(%ebp)
  801b31:	6a 08                	push   $0x8
  801b33:	e8 19 ff ff ff       	call   801a51 <syscall>
  801b38:	83 c4 18             	add    $0x18,%esp
}
  801b3b:	c9                   	leave  
  801b3c:	c3                   	ret    

00801b3d <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801b3d:	55                   	push   %ebp
  801b3e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801b40:	6a 00                	push   $0x0
  801b42:	6a 00                	push   $0x0
  801b44:	6a 00                	push   $0x0
  801b46:	6a 00                	push   $0x0
  801b48:	6a 00                	push   $0x0
  801b4a:	6a 09                	push   $0x9
  801b4c:	e8 00 ff ff ff       	call   801a51 <syscall>
  801b51:	83 c4 18             	add    $0x18,%esp
}
  801b54:	c9                   	leave  
  801b55:	c3                   	ret    

00801b56 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801b56:	55                   	push   %ebp
  801b57:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801b59:	6a 00                	push   $0x0
  801b5b:	6a 00                	push   $0x0
  801b5d:	6a 00                	push   $0x0
  801b5f:	6a 00                	push   $0x0
  801b61:	6a 00                	push   $0x0
  801b63:	6a 0a                	push   $0xa
  801b65:	e8 e7 fe ff ff       	call   801a51 <syscall>
  801b6a:	83 c4 18             	add    $0x18,%esp
}
  801b6d:	c9                   	leave  
  801b6e:	c3                   	ret    

00801b6f <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801b6f:	55                   	push   %ebp
  801b70:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801b72:	6a 00                	push   $0x0
  801b74:	6a 00                	push   $0x0
  801b76:	6a 00                	push   $0x0
  801b78:	6a 00                	push   $0x0
  801b7a:	6a 00                	push   $0x0
  801b7c:	6a 0b                	push   $0xb
  801b7e:	e8 ce fe ff ff       	call   801a51 <syscall>
  801b83:	83 c4 18             	add    $0x18,%esp
}
  801b86:	c9                   	leave  
  801b87:	c3                   	ret    

00801b88 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801b88:	55                   	push   %ebp
  801b89:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801b8b:	6a 00                	push   $0x0
  801b8d:	6a 00                	push   $0x0
  801b8f:	6a 00                	push   $0x0
  801b91:	ff 75 0c             	pushl  0xc(%ebp)
  801b94:	ff 75 08             	pushl  0x8(%ebp)
  801b97:	6a 0f                	push   $0xf
  801b99:	e8 b3 fe ff ff       	call   801a51 <syscall>
  801b9e:	83 c4 18             	add    $0x18,%esp
	return;
  801ba1:	90                   	nop
}
  801ba2:	c9                   	leave  
  801ba3:	c3                   	ret    

00801ba4 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801ba4:	55                   	push   %ebp
  801ba5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801ba7:	6a 00                	push   $0x0
  801ba9:	6a 00                	push   $0x0
  801bab:	6a 00                	push   $0x0
  801bad:	ff 75 0c             	pushl  0xc(%ebp)
  801bb0:	ff 75 08             	pushl  0x8(%ebp)
  801bb3:	6a 10                	push   $0x10
  801bb5:	e8 97 fe ff ff       	call   801a51 <syscall>
  801bba:	83 c4 18             	add    $0x18,%esp
	return ;
  801bbd:	90                   	nop
}
  801bbe:	c9                   	leave  
  801bbf:	c3                   	ret    

00801bc0 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801bc0:	55                   	push   %ebp
  801bc1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801bc3:	6a 00                	push   $0x0
  801bc5:	6a 00                	push   $0x0
  801bc7:	ff 75 10             	pushl  0x10(%ebp)
  801bca:	ff 75 0c             	pushl  0xc(%ebp)
  801bcd:	ff 75 08             	pushl  0x8(%ebp)
  801bd0:	6a 11                	push   $0x11
  801bd2:	e8 7a fe ff ff       	call   801a51 <syscall>
  801bd7:	83 c4 18             	add    $0x18,%esp
	return ;
  801bda:	90                   	nop
}
  801bdb:	c9                   	leave  
  801bdc:	c3                   	ret    

00801bdd <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801bdd:	55                   	push   %ebp
  801bde:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801be0:	6a 00                	push   $0x0
  801be2:	6a 00                	push   $0x0
  801be4:	6a 00                	push   $0x0
  801be6:	6a 00                	push   $0x0
  801be8:	6a 00                	push   $0x0
  801bea:	6a 0c                	push   $0xc
  801bec:	e8 60 fe ff ff       	call   801a51 <syscall>
  801bf1:	83 c4 18             	add    $0x18,%esp
}
  801bf4:	c9                   	leave  
  801bf5:	c3                   	ret    

00801bf6 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801bf6:	55                   	push   %ebp
  801bf7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801bf9:	6a 00                	push   $0x0
  801bfb:	6a 00                	push   $0x0
  801bfd:	6a 00                	push   $0x0
  801bff:	6a 00                	push   $0x0
  801c01:	ff 75 08             	pushl  0x8(%ebp)
  801c04:	6a 0d                	push   $0xd
  801c06:	e8 46 fe ff ff       	call   801a51 <syscall>
  801c0b:	83 c4 18             	add    $0x18,%esp
}
  801c0e:	c9                   	leave  
  801c0f:	c3                   	ret    

00801c10 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801c10:	55                   	push   %ebp
  801c11:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801c13:	6a 00                	push   $0x0
  801c15:	6a 00                	push   $0x0
  801c17:	6a 00                	push   $0x0
  801c19:	6a 00                	push   $0x0
  801c1b:	6a 00                	push   $0x0
  801c1d:	6a 0e                	push   $0xe
  801c1f:	e8 2d fe ff ff       	call   801a51 <syscall>
  801c24:	83 c4 18             	add    $0x18,%esp
}
  801c27:	90                   	nop
  801c28:	c9                   	leave  
  801c29:	c3                   	ret    

00801c2a <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801c2a:	55                   	push   %ebp
  801c2b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801c2d:	6a 00                	push   $0x0
  801c2f:	6a 00                	push   $0x0
  801c31:	6a 00                	push   $0x0
  801c33:	6a 00                	push   $0x0
  801c35:	6a 00                	push   $0x0
  801c37:	6a 13                	push   $0x13
  801c39:	e8 13 fe ff ff       	call   801a51 <syscall>
  801c3e:	83 c4 18             	add    $0x18,%esp
}
  801c41:	90                   	nop
  801c42:	c9                   	leave  
  801c43:	c3                   	ret    

00801c44 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801c44:	55                   	push   %ebp
  801c45:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801c47:	6a 00                	push   $0x0
  801c49:	6a 00                	push   $0x0
  801c4b:	6a 00                	push   $0x0
  801c4d:	6a 00                	push   $0x0
  801c4f:	6a 00                	push   $0x0
  801c51:	6a 14                	push   $0x14
  801c53:	e8 f9 fd ff ff       	call   801a51 <syscall>
  801c58:	83 c4 18             	add    $0x18,%esp
}
  801c5b:	90                   	nop
  801c5c:	c9                   	leave  
  801c5d:	c3                   	ret    

00801c5e <sys_cputc>:


void
sys_cputc(const char c)
{
  801c5e:	55                   	push   %ebp
  801c5f:	89 e5                	mov    %esp,%ebp
  801c61:	83 ec 04             	sub    $0x4,%esp
  801c64:	8b 45 08             	mov    0x8(%ebp),%eax
  801c67:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801c6a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c6e:	6a 00                	push   $0x0
  801c70:	6a 00                	push   $0x0
  801c72:	6a 00                	push   $0x0
  801c74:	6a 00                	push   $0x0
  801c76:	50                   	push   %eax
  801c77:	6a 15                	push   $0x15
  801c79:	e8 d3 fd ff ff       	call   801a51 <syscall>
  801c7e:	83 c4 18             	add    $0x18,%esp
}
  801c81:	90                   	nop
  801c82:	c9                   	leave  
  801c83:	c3                   	ret    

00801c84 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801c84:	55                   	push   %ebp
  801c85:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801c87:	6a 00                	push   $0x0
  801c89:	6a 00                	push   $0x0
  801c8b:	6a 00                	push   $0x0
  801c8d:	6a 00                	push   $0x0
  801c8f:	6a 00                	push   $0x0
  801c91:	6a 16                	push   $0x16
  801c93:	e8 b9 fd ff ff       	call   801a51 <syscall>
  801c98:	83 c4 18             	add    $0x18,%esp
}
  801c9b:	90                   	nop
  801c9c:	c9                   	leave  
  801c9d:	c3                   	ret    

00801c9e <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801c9e:	55                   	push   %ebp
  801c9f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801ca1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca4:	6a 00                	push   $0x0
  801ca6:	6a 00                	push   $0x0
  801ca8:	6a 00                	push   $0x0
  801caa:	ff 75 0c             	pushl  0xc(%ebp)
  801cad:	50                   	push   %eax
  801cae:	6a 17                	push   $0x17
  801cb0:	e8 9c fd ff ff       	call   801a51 <syscall>
  801cb5:	83 c4 18             	add    $0x18,%esp
}
  801cb8:	c9                   	leave  
  801cb9:	c3                   	ret    

00801cba <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801cba:	55                   	push   %ebp
  801cbb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801cbd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cc0:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc3:	6a 00                	push   $0x0
  801cc5:	6a 00                	push   $0x0
  801cc7:	6a 00                	push   $0x0
  801cc9:	52                   	push   %edx
  801cca:	50                   	push   %eax
  801ccb:	6a 1a                	push   $0x1a
  801ccd:	e8 7f fd ff ff       	call   801a51 <syscall>
  801cd2:	83 c4 18             	add    $0x18,%esp
}
  801cd5:	c9                   	leave  
  801cd6:	c3                   	ret    

00801cd7 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801cd7:	55                   	push   %ebp
  801cd8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801cda:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cdd:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce0:	6a 00                	push   $0x0
  801ce2:	6a 00                	push   $0x0
  801ce4:	6a 00                	push   $0x0
  801ce6:	52                   	push   %edx
  801ce7:	50                   	push   %eax
  801ce8:	6a 18                	push   $0x18
  801cea:	e8 62 fd ff ff       	call   801a51 <syscall>
  801cef:	83 c4 18             	add    $0x18,%esp
}
  801cf2:	90                   	nop
  801cf3:	c9                   	leave  
  801cf4:	c3                   	ret    

00801cf5 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801cf5:	55                   	push   %ebp
  801cf6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801cf8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cfb:	8b 45 08             	mov    0x8(%ebp),%eax
  801cfe:	6a 00                	push   $0x0
  801d00:	6a 00                	push   $0x0
  801d02:	6a 00                	push   $0x0
  801d04:	52                   	push   %edx
  801d05:	50                   	push   %eax
  801d06:	6a 19                	push   $0x19
  801d08:	e8 44 fd ff ff       	call   801a51 <syscall>
  801d0d:	83 c4 18             	add    $0x18,%esp
}
  801d10:	90                   	nop
  801d11:	c9                   	leave  
  801d12:	c3                   	ret    

00801d13 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801d13:	55                   	push   %ebp
  801d14:	89 e5                	mov    %esp,%ebp
  801d16:	83 ec 04             	sub    $0x4,%esp
  801d19:	8b 45 10             	mov    0x10(%ebp),%eax
  801d1c:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801d1f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801d22:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801d26:	8b 45 08             	mov    0x8(%ebp),%eax
  801d29:	6a 00                	push   $0x0
  801d2b:	51                   	push   %ecx
  801d2c:	52                   	push   %edx
  801d2d:	ff 75 0c             	pushl  0xc(%ebp)
  801d30:	50                   	push   %eax
  801d31:	6a 1b                	push   $0x1b
  801d33:	e8 19 fd ff ff       	call   801a51 <syscall>
  801d38:	83 c4 18             	add    $0x18,%esp
}
  801d3b:	c9                   	leave  
  801d3c:	c3                   	ret    

00801d3d <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801d3d:	55                   	push   %ebp
  801d3e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801d40:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d43:	8b 45 08             	mov    0x8(%ebp),%eax
  801d46:	6a 00                	push   $0x0
  801d48:	6a 00                	push   $0x0
  801d4a:	6a 00                	push   $0x0
  801d4c:	52                   	push   %edx
  801d4d:	50                   	push   %eax
  801d4e:	6a 1c                	push   $0x1c
  801d50:	e8 fc fc ff ff       	call   801a51 <syscall>
  801d55:	83 c4 18             	add    $0x18,%esp
}
  801d58:	c9                   	leave  
  801d59:	c3                   	ret    

00801d5a <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801d5a:	55                   	push   %ebp
  801d5b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801d5d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d60:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d63:	8b 45 08             	mov    0x8(%ebp),%eax
  801d66:	6a 00                	push   $0x0
  801d68:	6a 00                	push   $0x0
  801d6a:	51                   	push   %ecx
  801d6b:	52                   	push   %edx
  801d6c:	50                   	push   %eax
  801d6d:	6a 1d                	push   $0x1d
  801d6f:	e8 dd fc ff ff       	call   801a51 <syscall>
  801d74:	83 c4 18             	add    $0x18,%esp
}
  801d77:	c9                   	leave  
  801d78:	c3                   	ret    

00801d79 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801d79:	55                   	push   %ebp
  801d7a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801d7c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d82:	6a 00                	push   $0x0
  801d84:	6a 00                	push   $0x0
  801d86:	6a 00                	push   $0x0
  801d88:	52                   	push   %edx
  801d89:	50                   	push   %eax
  801d8a:	6a 1e                	push   $0x1e
  801d8c:	e8 c0 fc ff ff       	call   801a51 <syscall>
  801d91:	83 c4 18             	add    $0x18,%esp
}
  801d94:	c9                   	leave  
  801d95:	c3                   	ret    

00801d96 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801d96:	55                   	push   %ebp
  801d97:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801d99:	6a 00                	push   $0x0
  801d9b:	6a 00                	push   $0x0
  801d9d:	6a 00                	push   $0x0
  801d9f:	6a 00                	push   $0x0
  801da1:	6a 00                	push   $0x0
  801da3:	6a 1f                	push   $0x1f
  801da5:	e8 a7 fc ff ff       	call   801a51 <syscall>
  801daa:	83 c4 18             	add    $0x18,%esp
}
  801dad:	c9                   	leave  
  801dae:	c3                   	ret    

00801daf <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801daf:	55                   	push   %ebp
  801db0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801db2:	8b 45 08             	mov    0x8(%ebp),%eax
  801db5:	6a 00                	push   $0x0
  801db7:	ff 75 14             	pushl  0x14(%ebp)
  801dba:	ff 75 10             	pushl  0x10(%ebp)
  801dbd:	ff 75 0c             	pushl  0xc(%ebp)
  801dc0:	50                   	push   %eax
  801dc1:	6a 20                	push   $0x20
  801dc3:	e8 89 fc ff ff       	call   801a51 <syscall>
  801dc8:	83 c4 18             	add    $0x18,%esp
}
  801dcb:	c9                   	leave  
  801dcc:	c3                   	ret    

00801dcd <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801dcd:	55                   	push   %ebp
  801dce:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801dd0:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd3:	6a 00                	push   $0x0
  801dd5:	6a 00                	push   $0x0
  801dd7:	6a 00                	push   $0x0
  801dd9:	6a 00                	push   $0x0
  801ddb:	50                   	push   %eax
  801ddc:	6a 21                	push   $0x21
  801dde:	e8 6e fc ff ff       	call   801a51 <syscall>
  801de3:	83 c4 18             	add    $0x18,%esp
}
  801de6:	90                   	nop
  801de7:	c9                   	leave  
  801de8:	c3                   	ret    

00801de9 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801de9:	55                   	push   %ebp
  801dea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801dec:	8b 45 08             	mov    0x8(%ebp),%eax
  801def:	6a 00                	push   $0x0
  801df1:	6a 00                	push   $0x0
  801df3:	6a 00                	push   $0x0
  801df5:	6a 00                	push   $0x0
  801df7:	50                   	push   %eax
  801df8:	6a 22                	push   $0x22
  801dfa:	e8 52 fc ff ff       	call   801a51 <syscall>
  801dff:	83 c4 18             	add    $0x18,%esp
}
  801e02:	c9                   	leave  
  801e03:	c3                   	ret    

00801e04 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801e04:	55                   	push   %ebp
  801e05:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801e07:	6a 00                	push   $0x0
  801e09:	6a 00                	push   $0x0
  801e0b:	6a 00                	push   $0x0
  801e0d:	6a 00                	push   $0x0
  801e0f:	6a 00                	push   $0x0
  801e11:	6a 02                	push   $0x2
  801e13:	e8 39 fc ff ff       	call   801a51 <syscall>
  801e18:	83 c4 18             	add    $0x18,%esp
}
  801e1b:	c9                   	leave  
  801e1c:	c3                   	ret    

00801e1d <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801e1d:	55                   	push   %ebp
  801e1e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801e20:	6a 00                	push   $0x0
  801e22:	6a 00                	push   $0x0
  801e24:	6a 00                	push   $0x0
  801e26:	6a 00                	push   $0x0
  801e28:	6a 00                	push   $0x0
  801e2a:	6a 03                	push   $0x3
  801e2c:	e8 20 fc ff ff       	call   801a51 <syscall>
  801e31:	83 c4 18             	add    $0x18,%esp
}
  801e34:	c9                   	leave  
  801e35:	c3                   	ret    

00801e36 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801e36:	55                   	push   %ebp
  801e37:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801e39:	6a 00                	push   $0x0
  801e3b:	6a 00                	push   $0x0
  801e3d:	6a 00                	push   $0x0
  801e3f:	6a 00                	push   $0x0
  801e41:	6a 00                	push   $0x0
  801e43:	6a 04                	push   $0x4
  801e45:	e8 07 fc ff ff       	call   801a51 <syscall>
  801e4a:	83 c4 18             	add    $0x18,%esp
}
  801e4d:	c9                   	leave  
  801e4e:	c3                   	ret    

00801e4f <sys_exit_env>:


void sys_exit_env(void)
{
  801e4f:	55                   	push   %ebp
  801e50:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801e52:	6a 00                	push   $0x0
  801e54:	6a 00                	push   $0x0
  801e56:	6a 00                	push   $0x0
  801e58:	6a 00                	push   $0x0
  801e5a:	6a 00                	push   $0x0
  801e5c:	6a 23                	push   $0x23
  801e5e:	e8 ee fb ff ff       	call   801a51 <syscall>
  801e63:	83 c4 18             	add    $0x18,%esp
}
  801e66:	90                   	nop
  801e67:	c9                   	leave  
  801e68:	c3                   	ret    

00801e69 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801e69:	55                   	push   %ebp
  801e6a:	89 e5                	mov    %esp,%ebp
  801e6c:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801e6f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e72:	8d 50 04             	lea    0x4(%eax),%edx
  801e75:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e78:	6a 00                	push   $0x0
  801e7a:	6a 00                	push   $0x0
  801e7c:	6a 00                	push   $0x0
  801e7e:	52                   	push   %edx
  801e7f:	50                   	push   %eax
  801e80:	6a 24                	push   $0x24
  801e82:	e8 ca fb ff ff       	call   801a51 <syscall>
  801e87:	83 c4 18             	add    $0x18,%esp
	return result;
  801e8a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e8d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e90:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e93:	89 01                	mov    %eax,(%ecx)
  801e95:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801e98:	8b 45 08             	mov    0x8(%ebp),%eax
  801e9b:	c9                   	leave  
  801e9c:	c2 04 00             	ret    $0x4

00801e9f <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801e9f:	55                   	push   %ebp
  801ea0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801ea2:	6a 00                	push   $0x0
  801ea4:	6a 00                	push   $0x0
  801ea6:	ff 75 10             	pushl  0x10(%ebp)
  801ea9:	ff 75 0c             	pushl  0xc(%ebp)
  801eac:	ff 75 08             	pushl  0x8(%ebp)
  801eaf:	6a 12                	push   $0x12
  801eb1:	e8 9b fb ff ff       	call   801a51 <syscall>
  801eb6:	83 c4 18             	add    $0x18,%esp
	return ;
  801eb9:	90                   	nop
}
  801eba:	c9                   	leave  
  801ebb:	c3                   	ret    

00801ebc <sys_rcr2>:
uint32 sys_rcr2()
{
  801ebc:	55                   	push   %ebp
  801ebd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801ebf:	6a 00                	push   $0x0
  801ec1:	6a 00                	push   $0x0
  801ec3:	6a 00                	push   $0x0
  801ec5:	6a 00                	push   $0x0
  801ec7:	6a 00                	push   $0x0
  801ec9:	6a 25                	push   $0x25
  801ecb:	e8 81 fb ff ff       	call   801a51 <syscall>
  801ed0:	83 c4 18             	add    $0x18,%esp
}
  801ed3:	c9                   	leave  
  801ed4:	c3                   	ret    

00801ed5 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801ed5:	55                   	push   %ebp
  801ed6:	89 e5                	mov    %esp,%ebp
  801ed8:	83 ec 04             	sub    $0x4,%esp
  801edb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ede:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801ee1:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801ee5:	6a 00                	push   $0x0
  801ee7:	6a 00                	push   $0x0
  801ee9:	6a 00                	push   $0x0
  801eeb:	6a 00                	push   $0x0
  801eed:	50                   	push   %eax
  801eee:	6a 26                	push   $0x26
  801ef0:	e8 5c fb ff ff       	call   801a51 <syscall>
  801ef5:	83 c4 18             	add    $0x18,%esp
	return ;
  801ef8:	90                   	nop
}
  801ef9:	c9                   	leave  
  801efa:	c3                   	ret    

00801efb <rsttst>:
void rsttst()
{
  801efb:	55                   	push   %ebp
  801efc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801efe:	6a 00                	push   $0x0
  801f00:	6a 00                	push   $0x0
  801f02:	6a 00                	push   $0x0
  801f04:	6a 00                	push   $0x0
  801f06:	6a 00                	push   $0x0
  801f08:	6a 28                	push   $0x28
  801f0a:	e8 42 fb ff ff       	call   801a51 <syscall>
  801f0f:	83 c4 18             	add    $0x18,%esp
	return ;
  801f12:	90                   	nop
}
  801f13:	c9                   	leave  
  801f14:	c3                   	ret    

00801f15 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801f15:	55                   	push   %ebp
  801f16:	89 e5                	mov    %esp,%ebp
  801f18:	83 ec 04             	sub    $0x4,%esp
  801f1b:	8b 45 14             	mov    0x14(%ebp),%eax
  801f1e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801f21:	8b 55 18             	mov    0x18(%ebp),%edx
  801f24:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801f28:	52                   	push   %edx
  801f29:	50                   	push   %eax
  801f2a:	ff 75 10             	pushl  0x10(%ebp)
  801f2d:	ff 75 0c             	pushl  0xc(%ebp)
  801f30:	ff 75 08             	pushl  0x8(%ebp)
  801f33:	6a 27                	push   $0x27
  801f35:	e8 17 fb ff ff       	call   801a51 <syscall>
  801f3a:	83 c4 18             	add    $0x18,%esp
	return ;
  801f3d:	90                   	nop
}
  801f3e:	c9                   	leave  
  801f3f:	c3                   	ret    

00801f40 <chktst>:
void chktst(uint32 n)
{
  801f40:	55                   	push   %ebp
  801f41:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801f43:	6a 00                	push   $0x0
  801f45:	6a 00                	push   $0x0
  801f47:	6a 00                	push   $0x0
  801f49:	6a 00                	push   $0x0
  801f4b:	ff 75 08             	pushl  0x8(%ebp)
  801f4e:	6a 29                	push   $0x29
  801f50:	e8 fc fa ff ff       	call   801a51 <syscall>
  801f55:	83 c4 18             	add    $0x18,%esp
	return ;
  801f58:	90                   	nop
}
  801f59:	c9                   	leave  
  801f5a:	c3                   	ret    

00801f5b <inctst>:

void inctst()
{
  801f5b:	55                   	push   %ebp
  801f5c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801f5e:	6a 00                	push   $0x0
  801f60:	6a 00                	push   $0x0
  801f62:	6a 00                	push   $0x0
  801f64:	6a 00                	push   $0x0
  801f66:	6a 00                	push   $0x0
  801f68:	6a 2a                	push   $0x2a
  801f6a:	e8 e2 fa ff ff       	call   801a51 <syscall>
  801f6f:	83 c4 18             	add    $0x18,%esp
	return ;
  801f72:	90                   	nop
}
  801f73:	c9                   	leave  
  801f74:	c3                   	ret    

00801f75 <gettst>:
uint32 gettst()
{
  801f75:	55                   	push   %ebp
  801f76:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801f78:	6a 00                	push   $0x0
  801f7a:	6a 00                	push   $0x0
  801f7c:	6a 00                	push   $0x0
  801f7e:	6a 00                	push   $0x0
  801f80:	6a 00                	push   $0x0
  801f82:	6a 2b                	push   $0x2b
  801f84:	e8 c8 fa ff ff       	call   801a51 <syscall>
  801f89:	83 c4 18             	add    $0x18,%esp
}
  801f8c:	c9                   	leave  
  801f8d:	c3                   	ret    

00801f8e <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801f8e:	55                   	push   %ebp
  801f8f:	89 e5                	mov    %esp,%ebp
  801f91:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f94:	6a 00                	push   $0x0
  801f96:	6a 00                	push   $0x0
  801f98:	6a 00                	push   $0x0
  801f9a:	6a 00                	push   $0x0
  801f9c:	6a 00                	push   $0x0
  801f9e:	6a 2c                	push   $0x2c
  801fa0:	e8 ac fa ff ff       	call   801a51 <syscall>
  801fa5:	83 c4 18             	add    $0x18,%esp
  801fa8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801fab:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801faf:	75 07                	jne    801fb8 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801fb1:	b8 01 00 00 00       	mov    $0x1,%eax
  801fb6:	eb 05                	jmp    801fbd <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801fb8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fbd:	c9                   	leave  
  801fbe:	c3                   	ret    

00801fbf <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801fbf:	55                   	push   %ebp
  801fc0:	89 e5                	mov    %esp,%ebp
  801fc2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fc5:	6a 00                	push   $0x0
  801fc7:	6a 00                	push   $0x0
  801fc9:	6a 00                	push   $0x0
  801fcb:	6a 00                	push   $0x0
  801fcd:	6a 00                	push   $0x0
  801fcf:	6a 2c                	push   $0x2c
  801fd1:	e8 7b fa ff ff       	call   801a51 <syscall>
  801fd6:	83 c4 18             	add    $0x18,%esp
  801fd9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801fdc:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801fe0:	75 07                	jne    801fe9 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801fe2:	b8 01 00 00 00       	mov    $0x1,%eax
  801fe7:	eb 05                	jmp    801fee <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801fe9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fee:	c9                   	leave  
  801fef:	c3                   	ret    

00801ff0 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801ff0:	55                   	push   %ebp
  801ff1:	89 e5                	mov    %esp,%ebp
  801ff3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ff6:	6a 00                	push   $0x0
  801ff8:	6a 00                	push   $0x0
  801ffa:	6a 00                	push   $0x0
  801ffc:	6a 00                	push   $0x0
  801ffe:	6a 00                	push   $0x0
  802000:	6a 2c                	push   $0x2c
  802002:	e8 4a fa ff ff       	call   801a51 <syscall>
  802007:	83 c4 18             	add    $0x18,%esp
  80200a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80200d:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802011:	75 07                	jne    80201a <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802013:	b8 01 00 00 00       	mov    $0x1,%eax
  802018:	eb 05                	jmp    80201f <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80201a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80201f:	c9                   	leave  
  802020:	c3                   	ret    

00802021 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802021:	55                   	push   %ebp
  802022:	89 e5                	mov    %esp,%ebp
  802024:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802027:	6a 00                	push   $0x0
  802029:	6a 00                	push   $0x0
  80202b:	6a 00                	push   $0x0
  80202d:	6a 00                	push   $0x0
  80202f:	6a 00                	push   $0x0
  802031:	6a 2c                	push   $0x2c
  802033:	e8 19 fa ff ff       	call   801a51 <syscall>
  802038:	83 c4 18             	add    $0x18,%esp
  80203b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80203e:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802042:	75 07                	jne    80204b <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802044:	b8 01 00 00 00       	mov    $0x1,%eax
  802049:	eb 05                	jmp    802050 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80204b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802050:	c9                   	leave  
  802051:	c3                   	ret    

00802052 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802052:	55                   	push   %ebp
  802053:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802055:	6a 00                	push   $0x0
  802057:	6a 00                	push   $0x0
  802059:	6a 00                	push   $0x0
  80205b:	6a 00                	push   $0x0
  80205d:	ff 75 08             	pushl  0x8(%ebp)
  802060:	6a 2d                	push   $0x2d
  802062:	e8 ea f9 ff ff       	call   801a51 <syscall>
  802067:	83 c4 18             	add    $0x18,%esp
	return ;
  80206a:	90                   	nop
}
  80206b:	c9                   	leave  
  80206c:	c3                   	ret    

0080206d <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80206d:	55                   	push   %ebp
  80206e:	89 e5                	mov    %esp,%ebp
  802070:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802071:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802074:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802077:	8b 55 0c             	mov    0xc(%ebp),%edx
  80207a:	8b 45 08             	mov    0x8(%ebp),%eax
  80207d:	6a 00                	push   $0x0
  80207f:	53                   	push   %ebx
  802080:	51                   	push   %ecx
  802081:	52                   	push   %edx
  802082:	50                   	push   %eax
  802083:	6a 2e                	push   $0x2e
  802085:	e8 c7 f9 ff ff       	call   801a51 <syscall>
  80208a:	83 c4 18             	add    $0x18,%esp
}
  80208d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802090:	c9                   	leave  
  802091:	c3                   	ret    

00802092 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802092:	55                   	push   %ebp
  802093:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802095:	8b 55 0c             	mov    0xc(%ebp),%edx
  802098:	8b 45 08             	mov    0x8(%ebp),%eax
  80209b:	6a 00                	push   $0x0
  80209d:	6a 00                	push   $0x0
  80209f:	6a 00                	push   $0x0
  8020a1:	52                   	push   %edx
  8020a2:	50                   	push   %eax
  8020a3:	6a 2f                	push   $0x2f
  8020a5:	e8 a7 f9 ff ff       	call   801a51 <syscall>
  8020aa:	83 c4 18             	add    $0x18,%esp
}
  8020ad:	c9                   	leave  
  8020ae:	c3                   	ret    

008020af <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  8020af:	55                   	push   %ebp
  8020b0:	89 e5                	mov    %esp,%ebp
  8020b2:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  8020b5:	83 ec 0c             	sub    $0xc,%esp
  8020b8:	68 b8 41 80 00       	push   $0x8041b8
  8020bd:	e8 d3 e8 ff ff       	call   800995 <cprintf>
  8020c2:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  8020c5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8020cc:	83 ec 0c             	sub    $0xc,%esp
  8020cf:	68 e4 41 80 00       	push   $0x8041e4
  8020d4:	e8 bc e8 ff ff       	call   800995 <cprintf>
  8020d9:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8020dc:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8020e0:	a1 38 51 80 00       	mov    0x805138,%eax
  8020e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020e8:	eb 56                	jmp    802140 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8020ea:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8020ee:	74 1c                	je     80210c <print_mem_block_lists+0x5d>
  8020f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020f3:	8b 50 08             	mov    0x8(%eax),%edx
  8020f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020f9:	8b 48 08             	mov    0x8(%eax),%ecx
  8020fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020ff:	8b 40 0c             	mov    0xc(%eax),%eax
  802102:	01 c8                	add    %ecx,%eax
  802104:	39 c2                	cmp    %eax,%edx
  802106:	73 04                	jae    80210c <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802108:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80210c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80210f:	8b 50 08             	mov    0x8(%eax),%edx
  802112:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802115:	8b 40 0c             	mov    0xc(%eax),%eax
  802118:	01 c2                	add    %eax,%edx
  80211a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80211d:	8b 40 08             	mov    0x8(%eax),%eax
  802120:	83 ec 04             	sub    $0x4,%esp
  802123:	52                   	push   %edx
  802124:	50                   	push   %eax
  802125:	68 f9 41 80 00       	push   $0x8041f9
  80212a:	e8 66 e8 ff ff       	call   800995 <cprintf>
  80212f:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802132:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802135:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802138:	a1 40 51 80 00       	mov    0x805140,%eax
  80213d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802140:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802144:	74 07                	je     80214d <print_mem_block_lists+0x9e>
  802146:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802149:	8b 00                	mov    (%eax),%eax
  80214b:	eb 05                	jmp    802152 <print_mem_block_lists+0xa3>
  80214d:	b8 00 00 00 00       	mov    $0x0,%eax
  802152:	a3 40 51 80 00       	mov    %eax,0x805140
  802157:	a1 40 51 80 00       	mov    0x805140,%eax
  80215c:	85 c0                	test   %eax,%eax
  80215e:	75 8a                	jne    8020ea <print_mem_block_lists+0x3b>
  802160:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802164:	75 84                	jne    8020ea <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802166:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80216a:	75 10                	jne    80217c <print_mem_block_lists+0xcd>
  80216c:	83 ec 0c             	sub    $0xc,%esp
  80216f:	68 08 42 80 00       	push   $0x804208
  802174:	e8 1c e8 ff ff       	call   800995 <cprintf>
  802179:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  80217c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802183:	83 ec 0c             	sub    $0xc,%esp
  802186:	68 2c 42 80 00       	push   $0x80422c
  80218b:	e8 05 e8 ff ff       	call   800995 <cprintf>
  802190:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802193:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802197:	a1 40 50 80 00       	mov    0x805040,%eax
  80219c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80219f:	eb 56                	jmp    8021f7 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8021a1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8021a5:	74 1c                	je     8021c3 <print_mem_block_lists+0x114>
  8021a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021aa:	8b 50 08             	mov    0x8(%eax),%edx
  8021ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021b0:	8b 48 08             	mov    0x8(%eax),%ecx
  8021b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021b6:	8b 40 0c             	mov    0xc(%eax),%eax
  8021b9:	01 c8                	add    %ecx,%eax
  8021bb:	39 c2                	cmp    %eax,%edx
  8021bd:	73 04                	jae    8021c3 <print_mem_block_lists+0x114>
			sorted = 0 ;
  8021bf:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8021c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c6:	8b 50 08             	mov    0x8(%eax),%edx
  8021c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021cc:	8b 40 0c             	mov    0xc(%eax),%eax
  8021cf:	01 c2                	add    %eax,%edx
  8021d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d4:	8b 40 08             	mov    0x8(%eax),%eax
  8021d7:	83 ec 04             	sub    $0x4,%esp
  8021da:	52                   	push   %edx
  8021db:	50                   	push   %eax
  8021dc:	68 f9 41 80 00       	push   $0x8041f9
  8021e1:	e8 af e7 ff ff       	call   800995 <cprintf>
  8021e6:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8021e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8021ef:	a1 48 50 80 00       	mov    0x805048,%eax
  8021f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021f7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021fb:	74 07                	je     802204 <print_mem_block_lists+0x155>
  8021fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802200:	8b 00                	mov    (%eax),%eax
  802202:	eb 05                	jmp    802209 <print_mem_block_lists+0x15a>
  802204:	b8 00 00 00 00       	mov    $0x0,%eax
  802209:	a3 48 50 80 00       	mov    %eax,0x805048
  80220e:	a1 48 50 80 00       	mov    0x805048,%eax
  802213:	85 c0                	test   %eax,%eax
  802215:	75 8a                	jne    8021a1 <print_mem_block_lists+0xf2>
  802217:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80221b:	75 84                	jne    8021a1 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  80221d:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802221:	75 10                	jne    802233 <print_mem_block_lists+0x184>
  802223:	83 ec 0c             	sub    $0xc,%esp
  802226:	68 44 42 80 00       	push   $0x804244
  80222b:	e8 65 e7 ff ff       	call   800995 <cprintf>
  802230:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802233:	83 ec 0c             	sub    $0xc,%esp
  802236:	68 b8 41 80 00       	push   $0x8041b8
  80223b:	e8 55 e7 ff ff       	call   800995 <cprintf>
  802240:	83 c4 10             	add    $0x10,%esp

}
  802243:	90                   	nop
  802244:	c9                   	leave  
  802245:	c3                   	ret    

00802246 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802246:	55                   	push   %ebp
  802247:	89 e5                	mov    %esp,%ebp
  802249:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  80224c:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802253:	00 00 00 
  802256:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  80225d:	00 00 00 
  802260:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802267:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  80226a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802271:	e9 9e 00 00 00       	jmp    802314 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  802276:	a1 50 50 80 00       	mov    0x805050,%eax
  80227b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80227e:	c1 e2 04             	shl    $0x4,%edx
  802281:	01 d0                	add    %edx,%eax
  802283:	85 c0                	test   %eax,%eax
  802285:	75 14                	jne    80229b <initialize_MemBlocksList+0x55>
  802287:	83 ec 04             	sub    $0x4,%esp
  80228a:	68 6c 42 80 00       	push   $0x80426c
  80228f:	6a 46                	push   $0x46
  802291:	68 8f 42 80 00       	push   $0x80428f
  802296:	e8 46 e4 ff ff       	call   8006e1 <_panic>
  80229b:	a1 50 50 80 00       	mov    0x805050,%eax
  8022a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022a3:	c1 e2 04             	shl    $0x4,%edx
  8022a6:	01 d0                	add    %edx,%eax
  8022a8:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8022ae:	89 10                	mov    %edx,(%eax)
  8022b0:	8b 00                	mov    (%eax),%eax
  8022b2:	85 c0                	test   %eax,%eax
  8022b4:	74 18                	je     8022ce <initialize_MemBlocksList+0x88>
  8022b6:	a1 48 51 80 00       	mov    0x805148,%eax
  8022bb:	8b 15 50 50 80 00    	mov    0x805050,%edx
  8022c1:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8022c4:	c1 e1 04             	shl    $0x4,%ecx
  8022c7:	01 ca                	add    %ecx,%edx
  8022c9:	89 50 04             	mov    %edx,0x4(%eax)
  8022cc:	eb 12                	jmp    8022e0 <initialize_MemBlocksList+0x9a>
  8022ce:	a1 50 50 80 00       	mov    0x805050,%eax
  8022d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022d6:	c1 e2 04             	shl    $0x4,%edx
  8022d9:	01 d0                	add    %edx,%eax
  8022db:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8022e0:	a1 50 50 80 00       	mov    0x805050,%eax
  8022e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022e8:	c1 e2 04             	shl    $0x4,%edx
  8022eb:	01 d0                	add    %edx,%eax
  8022ed:	a3 48 51 80 00       	mov    %eax,0x805148
  8022f2:	a1 50 50 80 00       	mov    0x805050,%eax
  8022f7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022fa:	c1 e2 04             	shl    $0x4,%edx
  8022fd:	01 d0                	add    %edx,%eax
  8022ff:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802306:	a1 54 51 80 00       	mov    0x805154,%eax
  80230b:	40                   	inc    %eax
  80230c:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  802311:	ff 45 f4             	incl   -0xc(%ebp)
  802314:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802317:	3b 45 08             	cmp    0x8(%ebp),%eax
  80231a:	0f 82 56 ff ff ff    	jb     802276 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  802320:	90                   	nop
  802321:	c9                   	leave  
  802322:	c3                   	ret    

00802323 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802323:	55                   	push   %ebp
  802324:	89 e5                	mov    %esp,%ebp
  802326:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802329:	8b 45 08             	mov    0x8(%ebp),%eax
  80232c:	8b 00                	mov    (%eax),%eax
  80232e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802331:	eb 19                	jmp    80234c <find_block+0x29>
	{
		if(va==point->sva)
  802333:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802336:	8b 40 08             	mov    0x8(%eax),%eax
  802339:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80233c:	75 05                	jne    802343 <find_block+0x20>
		   return point;
  80233e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802341:	eb 36                	jmp    802379 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802343:	8b 45 08             	mov    0x8(%ebp),%eax
  802346:	8b 40 08             	mov    0x8(%eax),%eax
  802349:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80234c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802350:	74 07                	je     802359 <find_block+0x36>
  802352:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802355:	8b 00                	mov    (%eax),%eax
  802357:	eb 05                	jmp    80235e <find_block+0x3b>
  802359:	b8 00 00 00 00       	mov    $0x0,%eax
  80235e:	8b 55 08             	mov    0x8(%ebp),%edx
  802361:	89 42 08             	mov    %eax,0x8(%edx)
  802364:	8b 45 08             	mov    0x8(%ebp),%eax
  802367:	8b 40 08             	mov    0x8(%eax),%eax
  80236a:	85 c0                	test   %eax,%eax
  80236c:	75 c5                	jne    802333 <find_block+0x10>
  80236e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802372:	75 bf                	jne    802333 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802374:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802379:	c9                   	leave  
  80237a:	c3                   	ret    

0080237b <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80237b:	55                   	push   %ebp
  80237c:	89 e5                	mov    %esp,%ebp
  80237e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  802381:	a1 40 50 80 00       	mov    0x805040,%eax
  802386:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802389:	a1 44 50 80 00       	mov    0x805044,%eax
  80238e:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  802391:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802394:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802397:	74 24                	je     8023bd <insert_sorted_allocList+0x42>
  802399:	8b 45 08             	mov    0x8(%ebp),%eax
  80239c:	8b 50 08             	mov    0x8(%eax),%edx
  80239f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023a2:	8b 40 08             	mov    0x8(%eax),%eax
  8023a5:	39 c2                	cmp    %eax,%edx
  8023a7:	76 14                	jbe    8023bd <insert_sorted_allocList+0x42>
  8023a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ac:	8b 50 08             	mov    0x8(%eax),%edx
  8023af:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023b2:	8b 40 08             	mov    0x8(%eax),%eax
  8023b5:	39 c2                	cmp    %eax,%edx
  8023b7:	0f 82 60 01 00 00    	jb     80251d <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  8023bd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8023c1:	75 65                	jne    802428 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  8023c3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023c7:	75 14                	jne    8023dd <insert_sorted_allocList+0x62>
  8023c9:	83 ec 04             	sub    $0x4,%esp
  8023cc:	68 6c 42 80 00       	push   $0x80426c
  8023d1:	6a 6b                	push   $0x6b
  8023d3:	68 8f 42 80 00       	push   $0x80428f
  8023d8:	e8 04 e3 ff ff       	call   8006e1 <_panic>
  8023dd:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8023e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e6:	89 10                	mov    %edx,(%eax)
  8023e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023eb:	8b 00                	mov    (%eax),%eax
  8023ed:	85 c0                	test   %eax,%eax
  8023ef:	74 0d                	je     8023fe <insert_sorted_allocList+0x83>
  8023f1:	a1 40 50 80 00       	mov    0x805040,%eax
  8023f6:	8b 55 08             	mov    0x8(%ebp),%edx
  8023f9:	89 50 04             	mov    %edx,0x4(%eax)
  8023fc:	eb 08                	jmp    802406 <insert_sorted_allocList+0x8b>
  8023fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802401:	a3 44 50 80 00       	mov    %eax,0x805044
  802406:	8b 45 08             	mov    0x8(%ebp),%eax
  802409:	a3 40 50 80 00       	mov    %eax,0x805040
  80240e:	8b 45 08             	mov    0x8(%ebp),%eax
  802411:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802418:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80241d:	40                   	inc    %eax
  80241e:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802423:	e9 dc 01 00 00       	jmp    802604 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802428:	8b 45 08             	mov    0x8(%ebp),%eax
  80242b:	8b 50 08             	mov    0x8(%eax),%edx
  80242e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802431:	8b 40 08             	mov    0x8(%eax),%eax
  802434:	39 c2                	cmp    %eax,%edx
  802436:	77 6c                	ja     8024a4 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802438:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80243c:	74 06                	je     802444 <insert_sorted_allocList+0xc9>
  80243e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802442:	75 14                	jne    802458 <insert_sorted_allocList+0xdd>
  802444:	83 ec 04             	sub    $0x4,%esp
  802447:	68 a8 42 80 00       	push   $0x8042a8
  80244c:	6a 6f                	push   $0x6f
  80244e:	68 8f 42 80 00       	push   $0x80428f
  802453:	e8 89 e2 ff ff       	call   8006e1 <_panic>
  802458:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80245b:	8b 50 04             	mov    0x4(%eax),%edx
  80245e:	8b 45 08             	mov    0x8(%ebp),%eax
  802461:	89 50 04             	mov    %edx,0x4(%eax)
  802464:	8b 45 08             	mov    0x8(%ebp),%eax
  802467:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80246a:	89 10                	mov    %edx,(%eax)
  80246c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80246f:	8b 40 04             	mov    0x4(%eax),%eax
  802472:	85 c0                	test   %eax,%eax
  802474:	74 0d                	je     802483 <insert_sorted_allocList+0x108>
  802476:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802479:	8b 40 04             	mov    0x4(%eax),%eax
  80247c:	8b 55 08             	mov    0x8(%ebp),%edx
  80247f:	89 10                	mov    %edx,(%eax)
  802481:	eb 08                	jmp    80248b <insert_sorted_allocList+0x110>
  802483:	8b 45 08             	mov    0x8(%ebp),%eax
  802486:	a3 40 50 80 00       	mov    %eax,0x805040
  80248b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80248e:	8b 55 08             	mov    0x8(%ebp),%edx
  802491:	89 50 04             	mov    %edx,0x4(%eax)
  802494:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802499:	40                   	inc    %eax
  80249a:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80249f:	e9 60 01 00 00       	jmp    802604 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  8024a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a7:	8b 50 08             	mov    0x8(%eax),%edx
  8024aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024ad:	8b 40 08             	mov    0x8(%eax),%eax
  8024b0:	39 c2                	cmp    %eax,%edx
  8024b2:	0f 82 4c 01 00 00    	jb     802604 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8024b8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8024bc:	75 14                	jne    8024d2 <insert_sorted_allocList+0x157>
  8024be:	83 ec 04             	sub    $0x4,%esp
  8024c1:	68 e0 42 80 00       	push   $0x8042e0
  8024c6:	6a 73                	push   $0x73
  8024c8:	68 8f 42 80 00       	push   $0x80428f
  8024cd:	e8 0f e2 ff ff       	call   8006e1 <_panic>
  8024d2:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8024d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8024db:	89 50 04             	mov    %edx,0x4(%eax)
  8024de:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e1:	8b 40 04             	mov    0x4(%eax),%eax
  8024e4:	85 c0                	test   %eax,%eax
  8024e6:	74 0c                	je     8024f4 <insert_sorted_allocList+0x179>
  8024e8:	a1 44 50 80 00       	mov    0x805044,%eax
  8024ed:	8b 55 08             	mov    0x8(%ebp),%edx
  8024f0:	89 10                	mov    %edx,(%eax)
  8024f2:	eb 08                	jmp    8024fc <insert_sorted_allocList+0x181>
  8024f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f7:	a3 40 50 80 00       	mov    %eax,0x805040
  8024fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ff:	a3 44 50 80 00       	mov    %eax,0x805044
  802504:	8b 45 08             	mov    0x8(%ebp),%eax
  802507:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80250d:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802512:	40                   	inc    %eax
  802513:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802518:	e9 e7 00 00 00       	jmp    802604 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  80251d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802520:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802523:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80252a:	a1 40 50 80 00       	mov    0x805040,%eax
  80252f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802532:	e9 9d 00 00 00       	jmp    8025d4 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802537:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253a:	8b 00                	mov    (%eax),%eax
  80253c:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  80253f:	8b 45 08             	mov    0x8(%ebp),%eax
  802542:	8b 50 08             	mov    0x8(%eax),%edx
  802545:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802548:	8b 40 08             	mov    0x8(%eax),%eax
  80254b:	39 c2                	cmp    %eax,%edx
  80254d:	76 7d                	jbe    8025cc <insert_sorted_allocList+0x251>
  80254f:	8b 45 08             	mov    0x8(%ebp),%eax
  802552:	8b 50 08             	mov    0x8(%eax),%edx
  802555:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802558:	8b 40 08             	mov    0x8(%eax),%eax
  80255b:	39 c2                	cmp    %eax,%edx
  80255d:	73 6d                	jae    8025cc <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  80255f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802563:	74 06                	je     80256b <insert_sorted_allocList+0x1f0>
  802565:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802569:	75 14                	jne    80257f <insert_sorted_allocList+0x204>
  80256b:	83 ec 04             	sub    $0x4,%esp
  80256e:	68 04 43 80 00       	push   $0x804304
  802573:	6a 7f                	push   $0x7f
  802575:	68 8f 42 80 00       	push   $0x80428f
  80257a:	e8 62 e1 ff ff       	call   8006e1 <_panic>
  80257f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802582:	8b 10                	mov    (%eax),%edx
  802584:	8b 45 08             	mov    0x8(%ebp),%eax
  802587:	89 10                	mov    %edx,(%eax)
  802589:	8b 45 08             	mov    0x8(%ebp),%eax
  80258c:	8b 00                	mov    (%eax),%eax
  80258e:	85 c0                	test   %eax,%eax
  802590:	74 0b                	je     80259d <insert_sorted_allocList+0x222>
  802592:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802595:	8b 00                	mov    (%eax),%eax
  802597:	8b 55 08             	mov    0x8(%ebp),%edx
  80259a:	89 50 04             	mov    %edx,0x4(%eax)
  80259d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a0:	8b 55 08             	mov    0x8(%ebp),%edx
  8025a3:	89 10                	mov    %edx,(%eax)
  8025a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025ab:	89 50 04             	mov    %edx,0x4(%eax)
  8025ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b1:	8b 00                	mov    (%eax),%eax
  8025b3:	85 c0                	test   %eax,%eax
  8025b5:	75 08                	jne    8025bf <insert_sorted_allocList+0x244>
  8025b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ba:	a3 44 50 80 00       	mov    %eax,0x805044
  8025bf:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8025c4:	40                   	inc    %eax
  8025c5:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  8025ca:	eb 39                	jmp    802605 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8025cc:	a1 48 50 80 00       	mov    0x805048,%eax
  8025d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025d4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025d8:	74 07                	je     8025e1 <insert_sorted_allocList+0x266>
  8025da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025dd:	8b 00                	mov    (%eax),%eax
  8025df:	eb 05                	jmp    8025e6 <insert_sorted_allocList+0x26b>
  8025e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8025e6:	a3 48 50 80 00       	mov    %eax,0x805048
  8025eb:	a1 48 50 80 00       	mov    0x805048,%eax
  8025f0:	85 c0                	test   %eax,%eax
  8025f2:	0f 85 3f ff ff ff    	jne    802537 <insert_sorted_allocList+0x1bc>
  8025f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025fc:	0f 85 35 ff ff ff    	jne    802537 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802602:	eb 01                	jmp    802605 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802604:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802605:	90                   	nop
  802606:	c9                   	leave  
  802607:	c3                   	ret    

00802608 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802608:	55                   	push   %ebp
  802609:	89 e5                	mov    %esp,%ebp
  80260b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  80260e:	a1 38 51 80 00       	mov    0x805138,%eax
  802613:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802616:	e9 85 01 00 00       	jmp    8027a0 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  80261b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261e:	8b 40 0c             	mov    0xc(%eax),%eax
  802621:	3b 45 08             	cmp    0x8(%ebp),%eax
  802624:	0f 82 6e 01 00 00    	jb     802798 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  80262a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262d:	8b 40 0c             	mov    0xc(%eax),%eax
  802630:	3b 45 08             	cmp    0x8(%ebp),%eax
  802633:	0f 85 8a 00 00 00    	jne    8026c3 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802639:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80263d:	75 17                	jne    802656 <alloc_block_FF+0x4e>
  80263f:	83 ec 04             	sub    $0x4,%esp
  802642:	68 38 43 80 00       	push   $0x804338
  802647:	68 93 00 00 00       	push   $0x93
  80264c:	68 8f 42 80 00       	push   $0x80428f
  802651:	e8 8b e0 ff ff       	call   8006e1 <_panic>
  802656:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802659:	8b 00                	mov    (%eax),%eax
  80265b:	85 c0                	test   %eax,%eax
  80265d:	74 10                	je     80266f <alloc_block_FF+0x67>
  80265f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802662:	8b 00                	mov    (%eax),%eax
  802664:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802667:	8b 52 04             	mov    0x4(%edx),%edx
  80266a:	89 50 04             	mov    %edx,0x4(%eax)
  80266d:	eb 0b                	jmp    80267a <alloc_block_FF+0x72>
  80266f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802672:	8b 40 04             	mov    0x4(%eax),%eax
  802675:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80267a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267d:	8b 40 04             	mov    0x4(%eax),%eax
  802680:	85 c0                	test   %eax,%eax
  802682:	74 0f                	je     802693 <alloc_block_FF+0x8b>
  802684:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802687:	8b 40 04             	mov    0x4(%eax),%eax
  80268a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80268d:	8b 12                	mov    (%edx),%edx
  80268f:	89 10                	mov    %edx,(%eax)
  802691:	eb 0a                	jmp    80269d <alloc_block_FF+0x95>
  802693:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802696:	8b 00                	mov    (%eax),%eax
  802698:	a3 38 51 80 00       	mov    %eax,0x805138
  80269d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026b0:	a1 44 51 80 00       	mov    0x805144,%eax
  8026b5:	48                   	dec    %eax
  8026b6:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  8026bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026be:	e9 10 01 00 00       	jmp    8027d3 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  8026c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c6:	8b 40 0c             	mov    0xc(%eax),%eax
  8026c9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026cc:	0f 86 c6 00 00 00    	jbe    802798 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8026d2:	a1 48 51 80 00       	mov    0x805148,%eax
  8026d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  8026da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026dd:	8b 50 08             	mov    0x8(%eax),%edx
  8026e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026e3:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  8026e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026e9:	8b 55 08             	mov    0x8(%ebp),%edx
  8026ec:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8026ef:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8026f3:	75 17                	jne    80270c <alloc_block_FF+0x104>
  8026f5:	83 ec 04             	sub    $0x4,%esp
  8026f8:	68 38 43 80 00       	push   $0x804338
  8026fd:	68 9b 00 00 00       	push   $0x9b
  802702:	68 8f 42 80 00       	push   $0x80428f
  802707:	e8 d5 df ff ff       	call   8006e1 <_panic>
  80270c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80270f:	8b 00                	mov    (%eax),%eax
  802711:	85 c0                	test   %eax,%eax
  802713:	74 10                	je     802725 <alloc_block_FF+0x11d>
  802715:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802718:	8b 00                	mov    (%eax),%eax
  80271a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80271d:	8b 52 04             	mov    0x4(%edx),%edx
  802720:	89 50 04             	mov    %edx,0x4(%eax)
  802723:	eb 0b                	jmp    802730 <alloc_block_FF+0x128>
  802725:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802728:	8b 40 04             	mov    0x4(%eax),%eax
  80272b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802730:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802733:	8b 40 04             	mov    0x4(%eax),%eax
  802736:	85 c0                	test   %eax,%eax
  802738:	74 0f                	je     802749 <alloc_block_FF+0x141>
  80273a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80273d:	8b 40 04             	mov    0x4(%eax),%eax
  802740:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802743:	8b 12                	mov    (%edx),%edx
  802745:	89 10                	mov    %edx,(%eax)
  802747:	eb 0a                	jmp    802753 <alloc_block_FF+0x14b>
  802749:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80274c:	8b 00                	mov    (%eax),%eax
  80274e:	a3 48 51 80 00       	mov    %eax,0x805148
  802753:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802756:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80275c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80275f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802766:	a1 54 51 80 00       	mov    0x805154,%eax
  80276b:	48                   	dec    %eax
  80276c:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802771:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802774:	8b 50 08             	mov    0x8(%eax),%edx
  802777:	8b 45 08             	mov    0x8(%ebp),%eax
  80277a:	01 c2                	add    %eax,%edx
  80277c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277f:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802782:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802785:	8b 40 0c             	mov    0xc(%eax),%eax
  802788:	2b 45 08             	sub    0x8(%ebp),%eax
  80278b:	89 c2                	mov    %eax,%edx
  80278d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802790:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802793:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802796:	eb 3b                	jmp    8027d3 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802798:	a1 40 51 80 00       	mov    0x805140,%eax
  80279d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027a0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027a4:	74 07                	je     8027ad <alloc_block_FF+0x1a5>
  8027a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a9:	8b 00                	mov    (%eax),%eax
  8027ab:	eb 05                	jmp    8027b2 <alloc_block_FF+0x1aa>
  8027ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8027b2:	a3 40 51 80 00       	mov    %eax,0x805140
  8027b7:	a1 40 51 80 00       	mov    0x805140,%eax
  8027bc:	85 c0                	test   %eax,%eax
  8027be:	0f 85 57 fe ff ff    	jne    80261b <alloc_block_FF+0x13>
  8027c4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027c8:	0f 85 4d fe ff ff    	jne    80261b <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  8027ce:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027d3:	c9                   	leave  
  8027d4:	c3                   	ret    

008027d5 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8027d5:	55                   	push   %ebp
  8027d6:	89 e5                	mov    %esp,%ebp
  8027d8:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  8027db:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8027e2:	a1 38 51 80 00       	mov    0x805138,%eax
  8027e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027ea:	e9 df 00 00 00       	jmp    8028ce <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  8027ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f2:	8b 40 0c             	mov    0xc(%eax),%eax
  8027f5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027f8:	0f 82 c8 00 00 00    	jb     8028c6 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  8027fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802801:	8b 40 0c             	mov    0xc(%eax),%eax
  802804:	3b 45 08             	cmp    0x8(%ebp),%eax
  802807:	0f 85 8a 00 00 00    	jne    802897 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  80280d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802811:	75 17                	jne    80282a <alloc_block_BF+0x55>
  802813:	83 ec 04             	sub    $0x4,%esp
  802816:	68 38 43 80 00       	push   $0x804338
  80281b:	68 b7 00 00 00       	push   $0xb7
  802820:	68 8f 42 80 00       	push   $0x80428f
  802825:	e8 b7 de ff ff       	call   8006e1 <_panic>
  80282a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282d:	8b 00                	mov    (%eax),%eax
  80282f:	85 c0                	test   %eax,%eax
  802831:	74 10                	je     802843 <alloc_block_BF+0x6e>
  802833:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802836:	8b 00                	mov    (%eax),%eax
  802838:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80283b:	8b 52 04             	mov    0x4(%edx),%edx
  80283e:	89 50 04             	mov    %edx,0x4(%eax)
  802841:	eb 0b                	jmp    80284e <alloc_block_BF+0x79>
  802843:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802846:	8b 40 04             	mov    0x4(%eax),%eax
  802849:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80284e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802851:	8b 40 04             	mov    0x4(%eax),%eax
  802854:	85 c0                	test   %eax,%eax
  802856:	74 0f                	je     802867 <alloc_block_BF+0x92>
  802858:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285b:	8b 40 04             	mov    0x4(%eax),%eax
  80285e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802861:	8b 12                	mov    (%edx),%edx
  802863:	89 10                	mov    %edx,(%eax)
  802865:	eb 0a                	jmp    802871 <alloc_block_BF+0x9c>
  802867:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286a:	8b 00                	mov    (%eax),%eax
  80286c:	a3 38 51 80 00       	mov    %eax,0x805138
  802871:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802874:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80287a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802884:	a1 44 51 80 00       	mov    0x805144,%eax
  802889:	48                   	dec    %eax
  80288a:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  80288f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802892:	e9 4d 01 00 00       	jmp    8029e4 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802897:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289a:	8b 40 0c             	mov    0xc(%eax),%eax
  80289d:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028a0:	76 24                	jbe    8028c6 <alloc_block_BF+0xf1>
  8028a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a5:	8b 40 0c             	mov    0xc(%eax),%eax
  8028a8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8028ab:	73 19                	jae    8028c6 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  8028ad:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  8028b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b7:	8b 40 0c             	mov    0xc(%eax),%eax
  8028ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  8028bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c0:	8b 40 08             	mov    0x8(%eax),%eax
  8028c3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8028c6:	a1 40 51 80 00       	mov    0x805140,%eax
  8028cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028ce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028d2:	74 07                	je     8028db <alloc_block_BF+0x106>
  8028d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d7:	8b 00                	mov    (%eax),%eax
  8028d9:	eb 05                	jmp    8028e0 <alloc_block_BF+0x10b>
  8028db:	b8 00 00 00 00       	mov    $0x0,%eax
  8028e0:	a3 40 51 80 00       	mov    %eax,0x805140
  8028e5:	a1 40 51 80 00       	mov    0x805140,%eax
  8028ea:	85 c0                	test   %eax,%eax
  8028ec:	0f 85 fd fe ff ff    	jne    8027ef <alloc_block_BF+0x1a>
  8028f2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028f6:	0f 85 f3 fe ff ff    	jne    8027ef <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  8028fc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802900:	0f 84 d9 00 00 00    	je     8029df <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802906:	a1 48 51 80 00       	mov    0x805148,%eax
  80290b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  80290e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802911:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802914:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802917:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80291a:	8b 55 08             	mov    0x8(%ebp),%edx
  80291d:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802920:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802924:	75 17                	jne    80293d <alloc_block_BF+0x168>
  802926:	83 ec 04             	sub    $0x4,%esp
  802929:	68 38 43 80 00       	push   $0x804338
  80292e:	68 c7 00 00 00       	push   $0xc7
  802933:	68 8f 42 80 00       	push   $0x80428f
  802938:	e8 a4 dd ff ff       	call   8006e1 <_panic>
  80293d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802940:	8b 00                	mov    (%eax),%eax
  802942:	85 c0                	test   %eax,%eax
  802944:	74 10                	je     802956 <alloc_block_BF+0x181>
  802946:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802949:	8b 00                	mov    (%eax),%eax
  80294b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80294e:	8b 52 04             	mov    0x4(%edx),%edx
  802951:	89 50 04             	mov    %edx,0x4(%eax)
  802954:	eb 0b                	jmp    802961 <alloc_block_BF+0x18c>
  802956:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802959:	8b 40 04             	mov    0x4(%eax),%eax
  80295c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802961:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802964:	8b 40 04             	mov    0x4(%eax),%eax
  802967:	85 c0                	test   %eax,%eax
  802969:	74 0f                	je     80297a <alloc_block_BF+0x1a5>
  80296b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80296e:	8b 40 04             	mov    0x4(%eax),%eax
  802971:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802974:	8b 12                	mov    (%edx),%edx
  802976:	89 10                	mov    %edx,(%eax)
  802978:	eb 0a                	jmp    802984 <alloc_block_BF+0x1af>
  80297a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80297d:	8b 00                	mov    (%eax),%eax
  80297f:	a3 48 51 80 00       	mov    %eax,0x805148
  802984:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802987:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80298d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802990:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802997:	a1 54 51 80 00       	mov    0x805154,%eax
  80299c:	48                   	dec    %eax
  80299d:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  8029a2:	83 ec 08             	sub    $0x8,%esp
  8029a5:	ff 75 ec             	pushl  -0x14(%ebp)
  8029a8:	68 38 51 80 00       	push   $0x805138
  8029ad:	e8 71 f9 ff ff       	call   802323 <find_block>
  8029b2:	83 c4 10             	add    $0x10,%esp
  8029b5:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  8029b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029bb:	8b 50 08             	mov    0x8(%eax),%edx
  8029be:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c1:	01 c2                	add    %eax,%edx
  8029c3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029c6:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  8029c9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029cc:	8b 40 0c             	mov    0xc(%eax),%eax
  8029cf:	2b 45 08             	sub    0x8(%ebp),%eax
  8029d2:	89 c2                	mov    %eax,%edx
  8029d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029d7:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  8029da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029dd:	eb 05                	jmp    8029e4 <alloc_block_BF+0x20f>
	}
	return NULL;
  8029df:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029e4:	c9                   	leave  
  8029e5:	c3                   	ret    

008029e6 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  8029e6:	55                   	push   %ebp
  8029e7:	89 e5                	mov    %esp,%ebp
  8029e9:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  8029ec:	a1 28 50 80 00       	mov    0x805028,%eax
  8029f1:	85 c0                	test   %eax,%eax
  8029f3:	0f 85 de 01 00 00    	jne    802bd7 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8029f9:	a1 38 51 80 00       	mov    0x805138,%eax
  8029fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a01:	e9 9e 01 00 00       	jmp    802ba4 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802a06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a09:	8b 40 0c             	mov    0xc(%eax),%eax
  802a0c:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a0f:	0f 82 87 01 00 00    	jb     802b9c <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802a15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a18:	8b 40 0c             	mov    0xc(%eax),%eax
  802a1b:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a1e:	0f 85 95 00 00 00    	jne    802ab9 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802a24:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a28:	75 17                	jne    802a41 <alloc_block_NF+0x5b>
  802a2a:	83 ec 04             	sub    $0x4,%esp
  802a2d:	68 38 43 80 00       	push   $0x804338
  802a32:	68 e0 00 00 00       	push   $0xe0
  802a37:	68 8f 42 80 00       	push   $0x80428f
  802a3c:	e8 a0 dc ff ff       	call   8006e1 <_panic>
  802a41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a44:	8b 00                	mov    (%eax),%eax
  802a46:	85 c0                	test   %eax,%eax
  802a48:	74 10                	je     802a5a <alloc_block_NF+0x74>
  802a4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4d:	8b 00                	mov    (%eax),%eax
  802a4f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a52:	8b 52 04             	mov    0x4(%edx),%edx
  802a55:	89 50 04             	mov    %edx,0x4(%eax)
  802a58:	eb 0b                	jmp    802a65 <alloc_block_NF+0x7f>
  802a5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5d:	8b 40 04             	mov    0x4(%eax),%eax
  802a60:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802a65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a68:	8b 40 04             	mov    0x4(%eax),%eax
  802a6b:	85 c0                	test   %eax,%eax
  802a6d:	74 0f                	je     802a7e <alloc_block_NF+0x98>
  802a6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a72:	8b 40 04             	mov    0x4(%eax),%eax
  802a75:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a78:	8b 12                	mov    (%edx),%edx
  802a7a:	89 10                	mov    %edx,(%eax)
  802a7c:	eb 0a                	jmp    802a88 <alloc_block_NF+0xa2>
  802a7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a81:	8b 00                	mov    (%eax),%eax
  802a83:	a3 38 51 80 00       	mov    %eax,0x805138
  802a88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a94:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a9b:	a1 44 51 80 00       	mov    0x805144,%eax
  802aa0:	48                   	dec    %eax
  802aa1:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802aa6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa9:	8b 40 08             	mov    0x8(%eax),%eax
  802aac:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  802ab1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab4:	e9 f8 04 00 00       	jmp    802fb1 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802ab9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802abc:	8b 40 0c             	mov    0xc(%eax),%eax
  802abf:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ac2:	0f 86 d4 00 00 00    	jbe    802b9c <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802ac8:	a1 48 51 80 00       	mov    0x805148,%eax
  802acd:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802ad0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad3:	8b 50 08             	mov    0x8(%eax),%edx
  802ad6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ad9:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802adc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802adf:	8b 55 08             	mov    0x8(%ebp),%edx
  802ae2:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802ae5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ae9:	75 17                	jne    802b02 <alloc_block_NF+0x11c>
  802aeb:	83 ec 04             	sub    $0x4,%esp
  802aee:	68 38 43 80 00       	push   $0x804338
  802af3:	68 e9 00 00 00       	push   $0xe9
  802af8:	68 8f 42 80 00       	push   $0x80428f
  802afd:	e8 df db ff ff       	call   8006e1 <_panic>
  802b02:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b05:	8b 00                	mov    (%eax),%eax
  802b07:	85 c0                	test   %eax,%eax
  802b09:	74 10                	je     802b1b <alloc_block_NF+0x135>
  802b0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b0e:	8b 00                	mov    (%eax),%eax
  802b10:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b13:	8b 52 04             	mov    0x4(%edx),%edx
  802b16:	89 50 04             	mov    %edx,0x4(%eax)
  802b19:	eb 0b                	jmp    802b26 <alloc_block_NF+0x140>
  802b1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b1e:	8b 40 04             	mov    0x4(%eax),%eax
  802b21:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b26:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b29:	8b 40 04             	mov    0x4(%eax),%eax
  802b2c:	85 c0                	test   %eax,%eax
  802b2e:	74 0f                	je     802b3f <alloc_block_NF+0x159>
  802b30:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b33:	8b 40 04             	mov    0x4(%eax),%eax
  802b36:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b39:	8b 12                	mov    (%edx),%edx
  802b3b:	89 10                	mov    %edx,(%eax)
  802b3d:	eb 0a                	jmp    802b49 <alloc_block_NF+0x163>
  802b3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b42:	8b 00                	mov    (%eax),%eax
  802b44:	a3 48 51 80 00       	mov    %eax,0x805148
  802b49:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b4c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b52:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b55:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b5c:	a1 54 51 80 00       	mov    0x805154,%eax
  802b61:	48                   	dec    %eax
  802b62:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802b67:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b6a:	8b 40 08             	mov    0x8(%eax),%eax
  802b6d:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802b72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b75:	8b 50 08             	mov    0x8(%eax),%edx
  802b78:	8b 45 08             	mov    0x8(%ebp),%eax
  802b7b:	01 c2                	add    %eax,%edx
  802b7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b80:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802b83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b86:	8b 40 0c             	mov    0xc(%eax),%eax
  802b89:	2b 45 08             	sub    0x8(%ebp),%eax
  802b8c:	89 c2                	mov    %eax,%edx
  802b8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b91:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802b94:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b97:	e9 15 04 00 00       	jmp    802fb1 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802b9c:	a1 40 51 80 00       	mov    0x805140,%eax
  802ba1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ba4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ba8:	74 07                	je     802bb1 <alloc_block_NF+0x1cb>
  802baa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bad:	8b 00                	mov    (%eax),%eax
  802baf:	eb 05                	jmp    802bb6 <alloc_block_NF+0x1d0>
  802bb1:	b8 00 00 00 00       	mov    $0x0,%eax
  802bb6:	a3 40 51 80 00       	mov    %eax,0x805140
  802bbb:	a1 40 51 80 00       	mov    0x805140,%eax
  802bc0:	85 c0                	test   %eax,%eax
  802bc2:	0f 85 3e fe ff ff    	jne    802a06 <alloc_block_NF+0x20>
  802bc8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bcc:	0f 85 34 fe ff ff    	jne    802a06 <alloc_block_NF+0x20>
  802bd2:	e9 d5 03 00 00       	jmp    802fac <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802bd7:	a1 38 51 80 00       	mov    0x805138,%eax
  802bdc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bdf:	e9 b1 01 00 00       	jmp    802d95 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802be4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be7:	8b 50 08             	mov    0x8(%eax),%edx
  802bea:	a1 28 50 80 00       	mov    0x805028,%eax
  802bef:	39 c2                	cmp    %eax,%edx
  802bf1:	0f 82 96 01 00 00    	jb     802d8d <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802bf7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bfa:	8b 40 0c             	mov    0xc(%eax),%eax
  802bfd:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c00:	0f 82 87 01 00 00    	jb     802d8d <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802c06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c09:	8b 40 0c             	mov    0xc(%eax),%eax
  802c0c:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c0f:	0f 85 95 00 00 00    	jne    802caa <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802c15:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c19:	75 17                	jne    802c32 <alloc_block_NF+0x24c>
  802c1b:	83 ec 04             	sub    $0x4,%esp
  802c1e:	68 38 43 80 00       	push   $0x804338
  802c23:	68 fc 00 00 00       	push   $0xfc
  802c28:	68 8f 42 80 00       	push   $0x80428f
  802c2d:	e8 af da ff ff       	call   8006e1 <_panic>
  802c32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c35:	8b 00                	mov    (%eax),%eax
  802c37:	85 c0                	test   %eax,%eax
  802c39:	74 10                	je     802c4b <alloc_block_NF+0x265>
  802c3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c3e:	8b 00                	mov    (%eax),%eax
  802c40:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c43:	8b 52 04             	mov    0x4(%edx),%edx
  802c46:	89 50 04             	mov    %edx,0x4(%eax)
  802c49:	eb 0b                	jmp    802c56 <alloc_block_NF+0x270>
  802c4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4e:	8b 40 04             	mov    0x4(%eax),%eax
  802c51:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c59:	8b 40 04             	mov    0x4(%eax),%eax
  802c5c:	85 c0                	test   %eax,%eax
  802c5e:	74 0f                	je     802c6f <alloc_block_NF+0x289>
  802c60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c63:	8b 40 04             	mov    0x4(%eax),%eax
  802c66:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c69:	8b 12                	mov    (%edx),%edx
  802c6b:	89 10                	mov    %edx,(%eax)
  802c6d:	eb 0a                	jmp    802c79 <alloc_block_NF+0x293>
  802c6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c72:	8b 00                	mov    (%eax),%eax
  802c74:	a3 38 51 80 00       	mov    %eax,0x805138
  802c79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c7c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c85:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c8c:	a1 44 51 80 00       	mov    0x805144,%eax
  802c91:	48                   	dec    %eax
  802c92:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802c97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9a:	8b 40 08             	mov    0x8(%eax),%eax
  802c9d:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802ca2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca5:	e9 07 03 00 00       	jmp    802fb1 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802caa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cad:	8b 40 0c             	mov    0xc(%eax),%eax
  802cb0:	3b 45 08             	cmp    0x8(%ebp),%eax
  802cb3:	0f 86 d4 00 00 00    	jbe    802d8d <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802cb9:	a1 48 51 80 00       	mov    0x805148,%eax
  802cbe:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802cc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc4:	8b 50 08             	mov    0x8(%eax),%edx
  802cc7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cca:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802ccd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cd0:	8b 55 08             	mov    0x8(%ebp),%edx
  802cd3:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802cd6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802cda:	75 17                	jne    802cf3 <alloc_block_NF+0x30d>
  802cdc:	83 ec 04             	sub    $0x4,%esp
  802cdf:	68 38 43 80 00       	push   $0x804338
  802ce4:	68 04 01 00 00       	push   $0x104
  802ce9:	68 8f 42 80 00       	push   $0x80428f
  802cee:	e8 ee d9 ff ff       	call   8006e1 <_panic>
  802cf3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cf6:	8b 00                	mov    (%eax),%eax
  802cf8:	85 c0                	test   %eax,%eax
  802cfa:	74 10                	je     802d0c <alloc_block_NF+0x326>
  802cfc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cff:	8b 00                	mov    (%eax),%eax
  802d01:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d04:	8b 52 04             	mov    0x4(%edx),%edx
  802d07:	89 50 04             	mov    %edx,0x4(%eax)
  802d0a:	eb 0b                	jmp    802d17 <alloc_block_NF+0x331>
  802d0c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d0f:	8b 40 04             	mov    0x4(%eax),%eax
  802d12:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d17:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d1a:	8b 40 04             	mov    0x4(%eax),%eax
  802d1d:	85 c0                	test   %eax,%eax
  802d1f:	74 0f                	je     802d30 <alloc_block_NF+0x34a>
  802d21:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d24:	8b 40 04             	mov    0x4(%eax),%eax
  802d27:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d2a:	8b 12                	mov    (%edx),%edx
  802d2c:	89 10                	mov    %edx,(%eax)
  802d2e:	eb 0a                	jmp    802d3a <alloc_block_NF+0x354>
  802d30:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d33:	8b 00                	mov    (%eax),%eax
  802d35:	a3 48 51 80 00       	mov    %eax,0x805148
  802d3a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d3d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d43:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d46:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d4d:	a1 54 51 80 00       	mov    0x805154,%eax
  802d52:	48                   	dec    %eax
  802d53:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802d58:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d5b:	8b 40 08             	mov    0x8(%eax),%eax
  802d5e:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802d63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d66:	8b 50 08             	mov    0x8(%eax),%edx
  802d69:	8b 45 08             	mov    0x8(%ebp),%eax
  802d6c:	01 c2                	add    %eax,%edx
  802d6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d71:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802d74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d77:	8b 40 0c             	mov    0xc(%eax),%eax
  802d7a:	2b 45 08             	sub    0x8(%ebp),%eax
  802d7d:	89 c2                	mov    %eax,%edx
  802d7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d82:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802d85:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d88:	e9 24 02 00 00       	jmp    802fb1 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802d8d:	a1 40 51 80 00       	mov    0x805140,%eax
  802d92:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d95:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d99:	74 07                	je     802da2 <alloc_block_NF+0x3bc>
  802d9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d9e:	8b 00                	mov    (%eax),%eax
  802da0:	eb 05                	jmp    802da7 <alloc_block_NF+0x3c1>
  802da2:	b8 00 00 00 00       	mov    $0x0,%eax
  802da7:	a3 40 51 80 00       	mov    %eax,0x805140
  802dac:	a1 40 51 80 00       	mov    0x805140,%eax
  802db1:	85 c0                	test   %eax,%eax
  802db3:	0f 85 2b fe ff ff    	jne    802be4 <alloc_block_NF+0x1fe>
  802db9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dbd:	0f 85 21 fe ff ff    	jne    802be4 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802dc3:	a1 38 51 80 00       	mov    0x805138,%eax
  802dc8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802dcb:	e9 ae 01 00 00       	jmp    802f7e <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802dd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd3:	8b 50 08             	mov    0x8(%eax),%edx
  802dd6:	a1 28 50 80 00       	mov    0x805028,%eax
  802ddb:	39 c2                	cmp    %eax,%edx
  802ddd:	0f 83 93 01 00 00    	jae    802f76 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802de3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de6:	8b 40 0c             	mov    0xc(%eax),%eax
  802de9:	3b 45 08             	cmp    0x8(%ebp),%eax
  802dec:	0f 82 84 01 00 00    	jb     802f76 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802df2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df5:	8b 40 0c             	mov    0xc(%eax),%eax
  802df8:	3b 45 08             	cmp    0x8(%ebp),%eax
  802dfb:	0f 85 95 00 00 00    	jne    802e96 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802e01:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e05:	75 17                	jne    802e1e <alloc_block_NF+0x438>
  802e07:	83 ec 04             	sub    $0x4,%esp
  802e0a:	68 38 43 80 00       	push   $0x804338
  802e0f:	68 14 01 00 00       	push   $0x114
  802e14:	68 8f 42 80 00       	push   $0x80428f
  802e19:	e8 c3 d8 ff ff       	call   8006e1 <_panic>
  802e1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e21:	8b 00                	mov    (%eax),%eax
  802e23:	85 c0                	test   %eax,%eax
  802e25:	74 10                	je     802e37 <alloc_block_NF+0x451>
  802e27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e2a:	8b 00                	mov    (%eax),%eax
  802e2c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e2f:	8b 52 04             	mov    0x4(%edx),%edx
  802e32:	89 50 04             	mov    %edx,0x4(%eax)
  802e35:	eb 0b                	jmp    802e42 <alloc_block_NF+0x45c>
  802e37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e3a:	8b 40 04             	mov    0x4(%eax),%eax
  802e3d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e45:	8b 40 04             	mov    0x4(%eax),%eax
  802e48:	85 c0                	test   %eax,%eax
  802e4a:	74 0f                	je     802e5b <alloc_block_NF+0x475>
  802e4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e4f:	8b 40 04             	mov    0x4(%eax),%eax
  802e52:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e55:	8b 12                	mov    (%edx),%edx
  802e57:	89 10                	mov    %edx,(%eax)
  802e59:	eb 0a                	jmp    802e65 <alloc_block_NF+0x47f>
  802e5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e5e:	8b 00                	mov    (%eax),%eax
  802e60:	a3 38 51 80 00       	mov    %eax,0x805138
  802e65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e68:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e71:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e78:	a1 44 51 80 00       	mov    0x805144,%eax
  802e7d:	48                   	dec    %eax
  802e7e:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802e83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e86:	8b 40 08             	mov    0x8(%eax),%eax
  802e89:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802e8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e91:	e9 1b 01 00 00       	jmp    802fb1 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802e96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e99:	8b 40 0c             	mov    0xc(%eax),%eax
  802e9c:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e9f:	0f 86 d1 00 00 00    	jbe    802f76 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802ea5:	a1 48 51 80 00       	mov    0x805148,%eax
  802eaa:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802ead:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb0:	8b 50 08             	mov    0x8(%eax),%edx
  802eb3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802eb6:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802eb9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ebc:	8b 55 08             	mov    0x8(%ebp),%edx
  802ebf:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802ec2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802ec6:	75 17                	jne    802edf <alloc_block_NF+0x4f9>
  802ec8:	83 ec 04             	sub    $0x4,%esp
  802ecb:	68 38 43 80 00       	push   $0x804338
  802ed0:	68 1c 01 00 00       	push   $0x11c
  802ed5:	68 8f 42 80 00       	push   $0x80428f
  802eda:	e8 02 d8 ff ff       	call   8006e1 <_panic>
  802edf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ee2:	8b 00                	mov    (%eax),%eax
  802ee4:	85 c0                	test   %eax,%eax
  802ee6:	74 10                	je     802ef8 <alloc_block_NF+0x512>
  802ee8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802eeb:	8b 00                	mov    (%eax),%eax
  802eed:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ef0:	8b 52 04             	mov    0x4(%edx),%edx
  802ef3:	89 50 04             	mov    %edx,0x4(%eax)
  802ef6:	eb 0b                	jmp    802f03 <alloc_block_NF+0x51d>
  802ef8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802efb:	8b 40 04             	mov    0x4(%eax),%eax
  802efe:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f03:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f06:	8b 40 04             	mov    0x4(%eax),%eax
  802f09:	85 c0                	test   %eax,%eax
  802f0b:	74 0f                	je     802f1c <alloc_block_NF+0x536>
  802f0d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f10:	8b 40 04             	mov    0x4(%eax),%eax
  802f13:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802f16:	8b 12                	mov    (%edx),%edx
  802f18:	89 10                	mov    %edx,(%eax)
  802f1a:	eb 0a                	jmp    802f26 <alloc_block_NF+0x540>
  802f1c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f1f:	8b 00                	mov    (%eax),%eax
  802f21:	a3 48 51 80 00       	mov    %eax,0x805148
  802f26:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f29:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f2f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f32:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f39:	a1 54 51 80 00       	mov    0x805154,%eax
  802f3e:	48                   	dec    %eax
  802f3f:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802f44:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f47:	8b 40 08             	mov    0x8(%eax),%eax
  802f4a:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802f4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f52:	8b 50 08             	mov    0x8(%eax),%edx
  802f55:	8b 45 08             	mov    0x8(%ebp),%eax
  802f58:	01 c2                	add    %eax,%edx
  802f5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f5d:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802f60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f63:	8b 40 0c             	mov    0xc(%eax),%eax
  802f66:	2b 45 08             	sub    0x8(%ebp),%eax
  802f69:	89 c2                	mov    %eax,%edx
  802f6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f6e:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802f71:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f74:	eb 3b                	jmp    802fb1 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802f76:	a1 40 51 80 00       	mov    0x805140,%eax
  802f7b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f7e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f82:	74 07                	je     802f8b <alloc_block_NF+0x5a5>
  802f84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f87:	8b 00                	mov    (%eax),%eax
  802f89:	eb 05                	jmp    802f90 <alloc_block_NF+0x5aa>
  802f8b:	b8 00 00 00 00       	mov    $0x0,%eax
  802f90:	a3 40 51 80 00       	mov    %eax,0x805140
  802f95:	a1 40 51 80 00       	mov    0x805140,%eax
  802f9a:	85 c0                	test   %eax,%eax
  802f9c:	0f 85 2e fe ff ff    	jne    802dd0 <alloc_block_NF+0x3ea>
  802fa2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fa6:	0f 85 24 fe ff ff    	jne    802dd0 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802fac:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802fb1:	c9                   	leave  
  802fb2:	c3                   	ret    

00802fb3 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802fb3:	55                   	push   %ebp
  802fb4:	89 e5                	mov    %esp,%ebp
  802fb6:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802fb9:	a1 38 51 80 00       	mov    0x805138,%eax
  802fbe:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802fc1:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802fc6:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802fc9:	a1 38 51 80 00       	mov    0x805138,%eax
  802fce:	85 c0                	test   %eax,%eax
  802fd0:	74 14                	je     802fe6 <insert_sorted_with_merge_freeList+0x33>
  802fd2:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd5:	8b 50 08             	mov    0x8(%eax),%edx
  802fd8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fdb:	8b 40 08             	mov    0x8(%eax),%eax
  802fde:	39 c2                	cmp    %eax,%edx
  802fe0:	0f 87 9b 01 00 00    	ja     803181 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802fe6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fea:	75 17                	jne    803003 <insert_sorted_with_merge_freeList+0x50>
  802fec:	83 ec 04             	sub    $0x4,%esp
  802fef:	68 6c 42 80 00       	push   $0x80426c
  802ff4:	68 38 01 00 00       	push   $0x138
  802ff9:	68 8f 42 80 00       	push   $0x80428f
  802ffe:	e8 de d6 ff ff       	call   8006e1 <_panic>
  803003:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803009:	8b 45 08             	mov    0x8(%ebp),%eax
  80300c:	89 10                	mov    %edx,(%eax)
  80300e:	8b 45 08             	mov    0x8(%ebp),%eax
  803011:	8b 00                	mov    (%eax),%eax
  803013:	85 c0                	test   %eax,%eax
  803015:	74 0d                	je     803024 <insert_sorted_with_merge_freeList+0x71>
  803017:	a1 38 51 80 00       	mov    0x805138,%eax
  80301c:	8b 55 08             	mov    0x8(%ebp),%edx
  80301f:	89 50 04             	mov    %edx,0x4(%eax)
  803022:	eb 08                	jmp    80302c <insert_sorted_with_merge_freeList+0x79>
  803024:	8b 45 08             	mov    0x8(%ebp),%eax
  803027:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80302c:	8b 45 08             	mov    0x8(%ebp),%eax
  80302f:	a3 38 51 80 00       	mov    %eax,0x805138
  803034:	8b 45 08             	mov    0x8(%ebp),%eax
  803037:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80303e:	a1 44 51 80 00       	mov    0x805144,%eax
  803043:	40                   	inc    %eax
  803044:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803049:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80304d:	0f 84 a8 06 00 00    	je     8036fb <insert_sorted_with_merge_freeList+0x748>
  803053:	8b 45 08             	mov    0x8(%ebp),%eax
  803056:	8b 50 08             	mov    0x8(%eax),%edx
  803059:	8b 45 08             	mov    0x8(%ebp),%eax
  80305c:	8b 40 0c             	mov    0xc(%eax),%eax
  80305f:	01 c2                	add    %eax,%edx
  803061:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803064:	8b 40 08             	mov    0x8(%eax),%eax
  803067:	39 c2                	cmp    %eax,%edx
  803069:	0f 85 8c 06 00 00    	jne    8036fb <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  80306f:	8b 45 08             	mov    0x8(%ebp),%eax
  803072:	8b 50 0c             	mov    0xc(%eax),%edx
  803075:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803078:	8b 40 0c             	mov    0xc(%eax),%eax
  80307b:	01 c2                	add    %eax,%edx
  80307d:	8b 45 08             	mov    0x8(%ebp),%eax
  803080:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  803083:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803087:	75 17                	jne    8030a0 <insert_sorted_with_merge_freeList+0xed>
  803089:	83 ec 04             	sub    $0x4,%esp
  80308c:	68 38 43 80 00       	push   $0x804338
  803091:	68 3c 01 00 00       	push   $0x13c
  803096:	68 8f 42 80 00       	push   $0x80428f
  80309b:	e8 41 d6 ff ff       	call   8006e1 <_panic>
  8030a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030a3:	8b 00                	mov    (%eax),%eax
  8030a5:	85 c0                	test   %eax,%eax
  8030a7:	74 10                	je     8030b9 <insert_sorted_with_merge_freeList+0x106>
  8030a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030ac:	8b 00                	mov    (%eax),%eax
  8030ae:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8030b1:	8b 52 04             	mov    0x4(%edx),%edx
  8030b4:	89 50 04             	mov    %edx,0x4(%eax)
  8030b7:	eb 0b                	jmp    8030c4 <insert_sorted_with_merge_freeList+0x111>
  8030b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030bc:	8b 40 04             	mov    0x4(%eax),%eax
  8030bf:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8030c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030c7:	8b 40 04             	mov    0x4(%eax),%eax
  8030ca:	85 c0                	test   %eax,%eax
  8030cc:	74 0f                	je     8030dd <insert_sorted_with_merge_freeList+0x12a>
  8030ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030d1:	8b 40 04             	mov    0x4(%eax),%eax
  8030d4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8030d7:	8b 12                	mov    (%edx),%edx
  8030d9:	89 10                	mov    %edx,(%eax)
  8030db:	eb 0a                	jmp    8030e7 <insert_sorted_with_merge_freeList+0x134>
  8030dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030e0:	8b 00                	mov    (%eax),%eax
  8030e2:	a3 38 51 80 00       	mov    %eax,0x805138
  8030e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030ea:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030f3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030fa:	a1 44 51 80 00       	mov    0x805144,%eax
  8030ff:	48                   	dec    %eax
  803100:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  803105:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803108:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  80310f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803112:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  803119:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80311d:	75 17                	jne    803136 <insert_sorted_with_merge_freeList+0x183>
  80311f:	83 ec 04             	sub    $0x4,%esp
  803122:	68 6c 42 80 00       	push   $0x80426c
  803127:	68 3f 01 00 00       	push   $0x13f
  80312c:	68 8f 42 80 00       	push   $0x80428f
  803131:	e8 ab d5 ff ff       	call   8006e1 <_panic>
  803136:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80313c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80313f:	89 10                	mov    %edx,(%eax)
  803141:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803144:	8b 00                	mov    (%eax),%eax
  803146:	85 c0                	test   %eax,%eax
  803148:	74 0d                	je     803157 <insert_sorted_with_merge_freeList+0x1a4>
  80314a:	a1 48 51 80 00       	mov    0x805148,%eax
  80314f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803152:	89 50 04             	mov    %edx,0x4(%eax)
  803155:	eb 08                	jmp    80315f <insert_sorted_with_merge_freeList+0x1ac>
  803157:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80315a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80315f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803162:	a3 48 51 80 00       	mov    %eax,0x805148
  803167:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80316a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803171:	a1 54 51 80 00       	mov    0x805154,%eax
  803176:	40                   	inc    %eax
  803177:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80317c:	e9 7a 05 00 00       	jmp    8036fb <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  803181:	8b 45 08             	mov    0x8(%ebp),%eax
  803184:	8b 50 08             	mov    0x8(%eax),%edx
  803187:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80318a:	8b 40 08             	mov    0x8(%eax),%eax
  80318d:	39 c2                	cmp    %eax,%edx
  80318f:	0f 82 14 01 00 00    	jb     8032a9 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  803195:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803198:	8b 50 08             	mov    0x8(%eax),%edx
  80319b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80319e:	8b 40 0c             	mov    0xc(%eax),%eax
  8031a1:	01 c2                	add    %eax,%edx
  8031a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a6:	8b 40 08             	mov    0x8(%eax),%eax
  8031a9:	39 c2                	cmp    %eax,%edx
  8031ab:	0f 85 90 00 00 00    	jne    803241 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  8031b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031b4:	8b 50 0c             	mov    0xc(%eax),%edx
  8031b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ba:	8b 40 0c             	mov    0xc(%eax),%eax
  8031bd:	01 c2                	add    %eax,%edx
  8031bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031c2:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  8031c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c8:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  8031cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8031d9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031dd:	75 17                	jne    8031f6 <insert_sorted_with_merge_freeList+0x243>
  8031df:	83 ec 04             	sub    $0x4,%esp
  8031e2:	68 6c 42 80 00       	push   $0x80426c
  8031e7:	68 49 01 00 00       	push   $0x149
  8031ec:	68 8f 42 80 00       	push   $0x80428f
  8031f1:	e8 eb d4 ff ff       	call   8006e1 <_panic>
  8031f6:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8031fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ff:	89 10                	mov    %edx,(%eax)
  803201:	8b 45 08             	mov    0x8(%ebp),%eax
  803204:	8b 00                	mov    (%eax),%eax
  803206:	85 c0                	test   %eax,%eax
  803208:	74 0d                	je     803217 <insert_sorted_with_merge_freeList+0x264>
  80320a:	a1 48 51 80 00       	mov    0x805148,%eax
  80320f:	8b 55 08             	mov    0x8(%ebp),%edx
  803212:	89 50 04             	mov    %edx,0x4(%eax)
  803215:	eb 08                	jmp    80321f <insert_sorted_with_merge_freeList+0x26c>
  803217:	8b 45 08             	mov    0x8(%ebp),%eax
  80321a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80321f:	8b 45 08             	mov    0x8(%ebp),%eax
  803222:	a3 48 51 80 00       	mov    %eax,0x805148
  803227:	8b 45 08             	mov    0x8(%ebp),%eax
  80322a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803231:	a1 54 51 80 00       	mov    0x805154,%eax
  803236:	40                   	inc    %eax
  803237:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80323c:	e9 bb 04 00 00       	jmp    8036fc <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  803241:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803245:	75 17                	jne    80325e <insert_sorted_with_merge_freeList+0x2ab>
  803247:	83 ec 04             	sub    $0x4,%esp
  80324a:	68 e0 42 80 00       	push   $0x8042e0
  80324f:	68 4c 01 00 00       	push   $0x14c
  803254:	68 8f 42 80 00       	push   $0x80428f
  803259:	e8 83 d4 ff ff       	call   8006e1 <_panic>
  80325e:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803264:	8b 45 08             	mov    0x8(%ebp),%eax
  803267:	89 50 04             	mov    %edx,0x4(%eax)
  80326a:	8b 45 08             	mov    0x8(%ebp),%eax
  80326d:	8b 40 04             	mov    0x4(%eax),%eax
  803270:	85 c0                	test   %eax,%eax
  803272:	74 0c                	je     803280 <insert_sorted_with_merge_freeList+0x2cd>
  803274:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803279:	8b 55 08             	mov    0x8(%ebp),%edx
  80327c:	89 10                	mov    %edx,(%eax)
  80327e:	eb 08                	jmp    803288 <insert_sorted_with_merge_freeList+0x2d5>
  803280:	8b 45 08             	mov    0x8(%ebp),%eax
  803283:	a3 38 51 80 00       	mov    %eax,0x805138
  803288:	8b 45 08             	mov    0x8(%ebp),%eax
  80328b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803290:	8b 45 08             	mov    0x8(%ebp),%eax
  803293:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803299:	a1 44 51 80 00       	mov    0x805144,%eax
  80329e:	40                   	inc    %eax
  80329f:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8032a4:	e9 53 04 00 00       	jmp    8036fc <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8032a9:	a1 38 51 80 00       	mov    0x805138,%eax
  8032ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8032b1:	e9 15 04 00 00       	jmp    8036cb <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  8032b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032b9:	8b 00                	mov    (%eax),%eax
  8032bb:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  8032be:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c1:	8b 50 08             	mov    0x8(%eax),%edx
  8032c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032c7:	8b 40 08             	mov    0x8(%eax),%eax
  8032ca:	39 c2                	cmp    %eax,%edx
  8032cc:	0f 86 f1 03 00 00    	jbe    8036c3 <insert_sorted_with_merge_freeList+0x710>
  8032d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d5:	8b 50 08             	mov    0x8(%eax),%edx
  8032d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032db:	8b 40 08             	mov    0x8(%eax),%eax
  8032de:	39 c2                	cmp    %eax,%edx
  8032e0:	0f 83 dd 03 00 00    	jae    8036c3 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  8032e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032e9:	8b 50 08             	mov    0x8(%eax),%edx
  8032ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ef:	8b 40 0c             	mov    0xc(%eax),%eax
  8032f2:	01 c2                	add    %eax,%edx
  8032f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f7:	8b 40 08             	mov    0x8(%eax),%eax
  8032fa:	39 c2                	cmp    %eax,%edx
  8032fc:	0f 85 b9 01 00 00    	jne    8034bb <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803302:	8b 45 08             	mov    0x8(%ebp),%eax
  803305:	8b 50 08             	mov    0x8(%eax),%edx
  803308:	8b 45 08             	mov    0x8(%ebp),%eax
  80330b:	8b 40 0c             	mov    0xc(%eax),%eax
  80330e:	01 c2                	add    %eax,%edx
  803310:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803313:	8b 40 08             	mov    0x8(%eax),%eax
  803316:	39 c2                	cmp    %eax,%edx
  803318:	0f 85 0d 01 00 00    	jne    80342b <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  80331e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803321:	8b 50 0c             	mov    0xc(%eax),%edx
  803324:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803327:	8b 40 0c             	mov    0xc(%eax),%eax
  80332a:	01 c2                	add    %eax,%edx
  80332c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80332f:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803332:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803336:	75 17                	jne    80334f <insert_sorted_with_merge_freeList+0x39c>
  803338:	83 ec 04             	sub    $0x4,%esp
  80333b:	68 38 43 80 00       	push   $0x804338
  803340:	68 5c 01 00 00       	push   $0x15c
  803345:	68 8f 42 80 00       	push   $0x80428f
  80334a:	e8 92 d3 ff ff       	call   8006e1 <_panic>
  80334f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803352:	8b 00                	mov    (%eax),%eax
  803354:	85 c0                	test   %eax,%eax
  803356:	74 10                	je     803368 <insert_sorted_with_merge_freeList+0x3b5>
  803358:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80335b:	8b 00                	mov    (%eax),%eax
  80335d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803360:	8b 52 04             	mov    0x4(%edx),%edx
  803363:	89 50 04             	mov    %edx,0x4(%eax)
  803366:	eb 0b                	jmp    803373 <insert_sorted_with_merge_freeList+0x3c0>
  803368:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80336b:	8b 40 04             	mov    0x4(%eax),%eax
  80336e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803373:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803376:	8b 40 04             	mov    0x4(%eax),%eax
  803379:	85 c0                	test   %eax,%eax
  80337b:	74 0f                	je     80338c <insert_sorted_with_merge_freeList+0x3d9>
  80337d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803380:	8b 40 04             	mov    0x4(%eax),%eax
  803383:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803386:	8b 12                	mov    (%edx),%edx
  803388:	89 10                	mov    %edx,(%eax)
  80338a:	eb 0a                	jmp    803396 <insert_sorted_with_merge_freeList+0x3e3>
  80338c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80338f:	8b 00                	mov    (%eax),%eax
  803391:	a3 38 51 80 00       	mov    %eax,0x805138
  803396:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803399:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80339f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033a2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033a9:	a1 44 51 80 00       	mov    0x805144,%eax
  8033ae:	48                   	dec    %eax
  8033af:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  8033b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033b7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  8033be:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033c1:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8033c8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8033cc:	75 17                	jne    8033e5 <insert_sorted_with_merge_freeList+0x432>
  8033ce:	83 ec 04             	sub    $0x4,%esp
  8033d1:	68 6c 42 80 00       	push   $0x80426c
  8033d6:	68 5f 01 00 00       	push   $0x15f
  8033db:	68 8f 42 80 00       	push   $0x80428f
  8033e0:	e8 fc d2 ff ff       	call   8006e1 <_panic>
  8033e5:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8033eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033ee:	89 10                	mov    %edx,(%eax)
  8033f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033f3:	8b 00                	mov    (%eax),%eax
  8033f5:	85 c0                	test   %eax,%eax
  8033f7:	74 0d                	je     803406 <insert_sorted_with_merge_freeList+0x453>
  8033f9:	a1 48 51 80 00       	mov    0x805148,%eax
  8033fe:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803401:	89 50 04             	mov    %edx,0x4(%eax)
  803404:	eb 08                	jmp    80340e <insert_sorted_with_merge_freeList+0x45b>
  803406:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803409:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80340e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803411:	a3 48 51 80 00       	mov    %eax,0x805148
  803416:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803419:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803420:	a1 54 51 80 00       	mov    0x805154,%eax
  803425:	40                   	inc    %eax
  803426:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  80342b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80342e:	8b 50 0c             	mov    0xc(%eax),%edx
  803431:	8b 45 08             	mov    0x8(%ebp),%eax
  803434:	8b 40 0c             	mov    0xc(%eax),%eax
  803437:	01 c2                	add    %eax,%edx
  803439:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80343c:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  80343f:	8b 45 08             	mov    0x8(%ebp),%eax
  803442:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803449:	8b 45 08             	mov    0x8(%ebp),%eax
  80344c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803453:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803457:	75 17                	jne    803470 <insert_sorted_with_merge_freeList+0x4bd>
  803459:	83 ec 04             	sub    $0x4,%esp
  80345c:	68 6c 42 80 00       	push   $0x80426c
  803461:	68 64 01 00 00       	push   $0x164
  803466:	68 8f 42 80 00       	push   $0x80428f
  80346b:	e8 71 d2 ff ff       	call   8006e1 <_panic>
  803470:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803476:	8b 45 08             	mov    0x8(%ebp),%eax
  803479:	89 10                	mov    %edx,(%eax)
  80347b:	8b 45 08             	mov    0x8(%ebp),%eax
  80347e:	8b 00                	mov    (%eax),%eax
  803480:	85 c0                	test   %eax,%eax
  803482:	74 0d                	je     803491 <insert_sorted_with_merge_freeList+0x4de>
  803484:	a1 48 51 80 00       	mov    0x805148,%eax
  803489:	8b 55 08             	mov    0x8(%ebp),%edx
  80348c:	89 50 04             	mov    %edx,0x4(%eax)
  80348f:	eb 08                	jmp    803499 <insert_sorted_with_merge_freeList+0x4e6>
  803491:	8b 45 08             	mov    0x8(%ebp),%eax
  803494:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803499:	8b 45 08             	mov    0x8(%ebp),%eax
  80349c:	a3 48 51 80 00       	mov    %eax,0x805148
  8034a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8034a4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034ab:	a1 54 51 80 00       	mov    0x805154,%eax
  8034b0:	40                   	inc    %eax
  8034b1:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8034b6:	e9 41 02 00 00       	jmp    8036fc <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8034bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8034be:	8b 50 08             	mov    0x8(%eax),%edx
  8034c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8034c4:	8b 40 0c             	mov    0xc(%eax),%eax
  8034c7:	01 c2                	add    %eax,%edx
  8034c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034cc:	8b 40 08             	mov    0x8(%eax),%eax
  8034cf:	39 c2                	cmp    %eax,%edx
  8034d1:	0f 85 7c 01 00 00    	jne    803653 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  8034d7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8034db:	74 06                	je     8034e3 <insert_sorted_with_merge_freeList+0x530>
  8034dd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034e1:	75 17                	jne    8034fa <insert_sorted_with_merge_freeList+0x547>
  8034e3:	83 ec 04             	sub    $0x4,%esp
  8034e6:	68 a8 42 80 00       	push   $0x8042a8
  8034eb:	68 69 01 00 00       	push   $0x169
  8034f0:	68 8f 42 80 00       	push   $0x80428f
  8034f5:	e8 e7 d1 ff ff       	call   8006e1 <_panic>
  8034fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034fd:	8b 50 04             	mov    0x4(%eax),%edx
  803500:	8b 45 08             	mov    0x8(%ebp),%eax
  803503:	89 50 04             	mov    %edx,0x4(%eax)
  803506:	8b 45 08             	mov    0x8(%ebp),%eax
  803509:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80350c:	89 10                	mov    %edx,(%eax)
  80350e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803511:	8b 40 04             	mov    0x4(%eax),%eax
  803514:	85 c0                	test   %eax,%eax
  803516:	74 0d                	je     803525 <insert_sorted_with_merge_freeList+0x572>
  803518:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80351b:	8b 40 04             	mov    0x4(%eax),%eax
  80351e:	8b 55 08             	mov    0x8(%ebp),%edx
  803521:	89 10                	mov    %edx,(%eax)
  803523:	eb 08                	jmp    80352d <insert_sorted_with_merge_freeList+0x57a>
  803525:	8b 45 08             	mov    0x8(%ebp),%eax
  803528:	a3 38 51 80 00       	mov    %eax,0x805138
  80352d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803530:	8b 55 08             	mov    0x8(%ebp),%edx
  803533:	89 50 04             	mov    %edx,0x4(%eax)
  803536:	a1 44 51 80 00       	mov    0x805144,%eax
  80353b:	40                   	inc    %eax
  80353c:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803541:	8b 45 08             	mov    0x8(%ebp),%eax
  803544:	8b 50 0c             	mov    0xc(%eax),%edx
  803547:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80354a:	8b 40 0c             	mov    0xc(%eax),%eax
  80354d:	01 c2                	add    %eax,%edx
  80354f:	8b 45 08             	mov    0x8(%ebp),%eax
  803552:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803555:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803559:	75 17                	jne    803572 <insert_sorted_with_merge_freeList+0x5bf>
  80355b:	83 ec 04             	sub    $0x4,%esp
  80355e:	68 38 43 80 00       	push   $0x804338
  803563:	68 6b 01 00 00       	push   $0x16b
  803568:	68 8f 42 80 00       	push   $0x80428f
  80356d:	e8 6f d1 ff ff       	call   8006e1 <_panic>
  803572:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803575:	8b 00                	mov    (%eax),%eax
  803577:	85 c0                	test   %eax,%eax
  803579:	74 10                	je     80358b <insert_sorted_with_merge_freeList+0x5d8>
  80357b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80357e:	8b 00                	mov    (%eax),%eax
  803580:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803583:	8b 52 04             	mov    0x4(%edx),%edx
  803586:	89 50 04             	mov    %edx,0x4(%eax)
  803589:	eb 0b                	jmp    803596 <insert_sorted_with_merge_freeList+0x5e3>
  80358b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80358e:	8b 40 04             	mov    0x4(%eax),%eax
  803591:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803596:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803599:	8b 40 04             	mov    0x4(%eax),%eax
  80359c:	85 c0                	test   %eax,%eax
  80359e:	74 0f                	je     8035af <insert_sorted_with_merge_freeList+0x5fc>
  8035a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035a3:	8b 40 04             	mov    0x4(%eax),%eax
  8035a6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8035a9:	8b 12                	mov    (%edx),%edx
  8035ab:	89 10                	mov    %edx,(%eax)
  8035ad:	eb 0a                	jmp    8035b9 <insert_sorted_with_merge_freeList+0x606>
  8035af:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035b2:	8b 00                	mov    (%eax),%eax
  8035b4:	a3 38 51 80 00       	mov    %eax,0x805138
  8035b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035bc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035c5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035cc:	a1 44 51 80 00       	mov    0x805144,%eax
  8035d1:	48                   	dec    %eax
  8035d2:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  8035d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035da:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  8035e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035e4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8035eb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8035ef:	75 17                	jne    803608 <insert_sorted_with_merge_freeList+0x655>
  8035f1:	83 ec 04             	sub    $0x4,%esp
  8035f4:	68 6c 42 80 00       	push   $0x80426c
  8035f9:	68 6e 01 00 00       	push   $0x16e
  8035fe:	68 8f 42 80 00       	push   $0x80428f
  803603:	e8 d9 d0 ff ff       	call   8006e1 <_panic>
  803608:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80360e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803611:	89 10                	mov    %edx,(%eax)
  803613:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803616:	8b 00                	mov    (%eax),%eax
  803618:	85 c0                	test   %eax,%eax
  80361a:	74 0d                	je     803629 <insert_sorted_with_merge_freeList+0x676>
  80361c:	a1 48 51 80 00       	mov    0x805148,%eax
  803621:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803624:	89 50 04             	mov    %edx,0x4(%eax)
  803627:	eb 08                	jmp    803631 <insert_sorted_with_merge_freeList+0x67e>
  803629:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80362c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803631:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803634:	a3 48 51 80 00       	mov    %eax,0x805148
  803639:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80363c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803643:	a1 54 51 80 00       	mov    0x805154,%eax
  803648:	40                   	inc    %eax
  803649:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  80364e:	e9 a9 00 00 00       	jmp    8036fc <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803653:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803657:	74 06                	je     80365f <insert_sorted_with_merge_freeList+0x6ac>
  803659:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80365d:	75 17                	jne    803676 <insert_sorted_with_merge_freeList+0x6c3>
  80365f:	83 ec 04             	sub    $0x4,%esp
  803662:	68 04 43 80 00       	push   $0x804304
  803667:	68 73 01 00 00       	push   $0x173
  80366c:	68 8f 42 80 00       	push   $0x80428f
  803671:	e8 6b d0 ff ff       	call   8006e1 <_panic>
  803676:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803679:	8b 10                	mov    (%eax),%edx
  80367b:	8b 45 08             	mov    0x8(%ebp),%eax
  80367e:	89 10                	mov    %edx,(%eax)
  803680:	8b 45 08             	mov    0x8(%ebp),%eax
  803683:	8b 00                	mov    (%eax),%eax
  803685:	85 c0                	test   %eax,%eax
  803687:	74 0b                	je     803694 <insert_sorted_with_merge_freeList+0x6e1>
  803689:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80368c:	8b 00                	mov    (%eax),%eax
  80368e:	8b 55 08             	mov    0x8(%ebp),%edx
  803691:	89 50 04             	mov    %edx,0x4(%eax)
  803694:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803697:	8b 55 08             	mov    0x8(%ebp),%edx
  80369a:	89 10                	mov    %edx,(%eax)
  80369c:	8b 45 08             	mov    0x8(%ebp),%eax
  80369f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8036a2:	89 50 04             	mov    %edx,0x4(%eax)
  8036a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8036a8:	8b 00                	mov    (%eax),%eax
  8036aa:	85 c0                	test   %eax,%eax
  8036ac:	75 08                	jne    8036b6 <insert_sorted_with_merge_freeList+0x703>
  8036ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8036b1:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8036b6:	a1 44 51 80 00       	mov    0x805144,%eax
  8036bb:	40                   	inc    %eax
  8036bc:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  8036c1:	eb 39                	jmp    8036fc <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8036c3:	a1 40 51 80 00       	mov    0x805140,%eax
  8036c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8036cb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036cf:	74 07                	je     8036d8 <insert_sorted_with_merge_freeList+0x725>
  8036d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036d4:	8b 00                	mov    (%eax),%eax
  8036d6:	eb 05                	jmp    8036dd <insert_sorted_with_merge_freeList+0x72a>
  8036d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8036dd:	a3 40 51 80 00       	mov    %eax,0x805140
  8036e2:	a1 40 51 80 00       	mov    0x805140,%eax
  8036e7:	85 c0                	test   %eax,%eax
  8036e9:	0f 85 c7 fb ff ff    	jne    8032b6 <insert_sorted_with_merge_freeList+0x303>
  8036ef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036f3:	0f 85 bd fb ff ff    	jne    8032b6 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8036f9:	eb 01                	jmp    8036fc <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8036fb:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8036fc:	90                   	nop
  8036fd:	c9                   	leave  
  8036fe:	c3                   	ret    
  8036ff:	90                   	nop

00803700 <__udivdi3>:
  803700:	55                   	push   %ebp
  803701:	57                   	push   %edi
  803702:	56                   	push   %esi
  803703:	53                   	push   %ebx
  803704:	83 ec 1c             	sub    $0x1c,%esp
  803707:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80370b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80370f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803713:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803717:	89 ca                	mov    %ecx,%edx
  803719:	89 f8                	mov    %edi,%eax
  80371b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80371f:	85 f6                	test   %esi,%esi
  803721:	75 2d                	jne    803750 <__udivdi3+0x50>
  803723:	39 cf                	cmp    %ecx,%edi
  803725:	77 65                	ja     80378c <__udivdi3+0x8c>
  803727:	89 fd                	mov    %edi,%ebp
  803729:	85 ff                	test   %edi,%edi
  80372b:	75 0b                	jne    803738 <__udivdi3+0x38>
  80372d:	b8 01 00 00 00       	mov    $0x1,%eax
  803732:	31 d2                	xor    %edx,%edx
  803734:	f7 f7                	div    %edi
  803736:	89 c5                	mov    %eax,%ebp
  803738:	31 d2                	xor    %edx,%edx
  80373a:	89 c8                	mov    %ecx,%eax
  80373c:	f7 f5                	div    %ebp
  80373e:	89 c1                	mov    %eax,%ecx
  803740:	89 d8                	mov    %ebx,%eax
  803742:	f7 f5                	div    %ebp
  803744:	89 cf                	mov    %ecx,%edi
  803746:	89 fa                	mov    %edi,%edx
  803748:	83 c4 1c             	add    $0x1c,%esp
  80374b:	5b                   	pop    %ebx
  80374c:	5e                   	pop    %esi
  80374d:	5f                   	pop    %edi
  80374e:	5d                   	pop    %ebp
  80374f:	c3                   	ret    
  803750:	39 ce                	cmp    %ecx,%esi
  803752:	77 28                	ja     80377c <__udivdi3+0x7c>
  803754:	0f bd fe             	bsr    %esi,%edi
  803757:	83 f7 1f             	xor    $0x1f,%edi
  80375a:	75 40                	jne    80379c <__udivdi3+0x9c>
  80375c:	39 ce                	cmp    %ecx,%esi
  80375e:	72 0a                	jb     80376a <__udivdi3+0x6a>
  803760:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803764:	0f 87 9e 00 00 00    	ja     803808 <__udivdi3+0x108>
  80376a:	b8 01 00 00 00       	mov    $0x1,%eax
  80376f:	89 fa                	mov    %edi,%edx
  803771:	83 c4 1c             	add    $0x1c,%esp
  803774:	5b                   	pop    %ebx
  803775:	5e                   	pop    %esi
  803776:	5f                   	pop    %edi
  803777:	5d                   	pop    %ebp
  803778:	c3                   	ret    
  803779:	8d 76 00             	lea    0x0(%esi),%esi
  80377c:	31 ff                	xor    %edi,%edi
  80377e:	31 c0                	xor    %eax,%eax
  803780:	89 fa                	mov    %edi,%edx
  803782:	83 c4 1c             	add    $0x1c,%esp
  803785:	5b                   	pop    %ebx
  803786:	5e                   	pop    %esi
  803787:	5f                   	pop    %edi
  803788:	5d                   	pop    %ebp
  803789:	c3                   	ret    
  80378a:	66 90                	xchg   %ax,%ax
  80378c:	89 d8                	mov    %ebx,%eax
  80378e:	f7 f7                	div    %edi
  803790:	31 ff                	xor    %edi,%edi
  803792:	89 fa                	mov    %edi,%edx
  803794:	83 c4 1c             	add    $0x1c,%esp
  803797:	5b                   	pop    %ebx
  803798:	5e                   	pop    %esi
  803799:	5f                   	pop    %edi
  80379a:	5d                   	pop    %ebp
  80379b:	c3                   	ret    
  80379c:	bd 20 00 00 00       	mov    $0x20,%ebp
  8037a1:	89 eb                	mov    %ebp,%ebx
  8037a3:	29 fb                	sub    %edi,%ebx
  8037a5:	89 f9                	mov    %edi,%ecx
  8037a7:	d3 e6                	shl    %cl,%esi
  8037a9:	89 c5                	mov    %eax,%ebp
  8037ab:	88 d9                	mov    %bl,%cl
  8037ad:	d3 ed                	shr    %cl,%ebp
  8037af:	89 e9                	mov    %ebp,%ecx
  8037b1:	09 f1                	or     %esi,%ecx
  8037b3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8037b7:	89 f9                	mov    %edi,%ecx
  8037b9:	d3 e0                	shl    %cl,%eax
  8037bb:	89 c5                	mov    %eax,%ebp
  8037bd:	89 d6                	mov    %edx,%esi
  8037bf:	88 d9                	mov    %bl,%cl
  8037c1:	d3 ee                	shr    %cl,%esi
  8037c3:	89 f9                	mov    %edi,%ecx
  8037c5:	d3 e2                	shl    %cl,%edx
  8037c7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8037cb:	88 d9                	mov    %bl,%cl
  8037cd:	d3 e8                	shr    %cl,%eax
  8037cf:	09 c2                	or     %eax,%edx
  8037d1:	89 d0                	mov    %edx,%eax
  8037d3:	89 f2                	mov    %esi,%edx
  8037d5:	f7 74 24 0c          	divl   0xc(%esp)
  8037d9:	89 d6                	mov    %edx,%esi
  8037db:	89 c3                	mov    %eax,%ebx
  8037dd:	f7 e5                	mul    %ebp
  8037df:	39 d6                	cmp    %edx,%esi
  8037e1:	72 19                	jb     8037fc <__udivdi3+0xfc>
  8037e3:	74 0b                	je     8037f0 <__udivdi3+0xf0>
  8037e5:	89 d8                	mov    %ebx,%eax
  8037e7:	31 ff                	xor    %edi,%edi
  8037e9:	e9 58 ff ff ff       	jmp    803746 <__udivdi3+0x46>
  8037ee:	66 90                	xchg   %ax,%ax
  8037f0:	8b 54 24 08          	mov    0x8(%esp),%edx
  8037f4:	89 f9                	mov    %edi,%ecx
  8037f6:	d3 e2                	shl    %cl,%edx
  8037f8:	39 c2                	cmp    %eax,%edx
  8037fa:	73 e9                	jae    8037e5 <__udivdi3+0xe5>
  8037fc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8037ff:	31 ff                	xor    %edi,%edi
  803801:	e9 40 ff ff ff       	jmp    803746 <__udivdi3+0x46>
  803806:	66 90                	xchg   %ax,%ax
  803808:	31 c0                	xor    %eax,%eax
  80380a:	e9 37 ff ff ff       	jmp    803746 <__udivdi3+0x46>
  80380f:	90                   	nop

00803810 <__umoddi3>:
  803810:	55                   	push   %ebp
  803811:	57                   	push   %edi
  803812:	56                   	push   %esi
  803813:	53                   	push   %ebx
  803814:	83 ec 1c             	sub    $0x1c,%esp
  803817:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80381b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80381f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803823:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803827:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80382b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80382f:	89 f3                	mov    %esi,%ebx
  803831:	89 fa                	mov    %edi,%edx
  803833:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803837:	89 34 24             	mov    %esi,(%esp)
  80383a:	85 c0                	test   %eax,%eax
  80383c:	75 1a                	jne    803858 <__umoddi3+0x48>
  80383e:	39 f7                	cmp    %esi,%edi
  803840:	0f 86 a2 00 00 00    	jbe    8038e8 <__umoddi3+0xd8>
  803846:	89 c8                	mov    %ecx,%eax
  803848:	89 f2                	mov    %esi,%edx
  80384a:	f7 f7                	div    %edi
  80384c:	89 d0                	mov    %edx,%eax
  80384e:	31 d2                	xor    %edx,%edx
  803850:	83 c4 1c             	add    $0x1c,%esp
  803853:	5b                   	pop    %ebx
  803854:	5e                   	pop    %esi
  803855:	5f                   	pop    %edi
  803856:	5d                   	pop    %ebp
  803857:	c3                   	ret    
  803858:	39 f0                	cmp    %esi,%eax
  80385a:	0f 87 ac 00 00 00    	ja     80390c <__umoddi3+0xfc>
  803860:	0f bd e8             	bsr    %eax,%ebp
  803863:	83 f5 1f             	xor    $0x1f,%ebp
  803866:	0f 84 ac 00 00 00    	je     803918 <__umoddi3+0x108>
  80386c:	bf 20 00 00 00       	mov    $0x20,%edi
  803871:	29 ef                	sub    %ebp,%edi
  803873:	89 fe                	mov    %edi,%esi
  803875:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803879:	89 e9                	mov    %ebp,%ecx
  80387b:	d3 e0                	shl    %cl,%eax
  80387d:	89 d7                	mov    %edx,%edi
  80387f:	89 f1                	mov    %esi,%ecx
  803881:	d3 ef                	shr    %cl,%edi
  803883:	09 c7                	or     %eax,%edi
  803885:	89 e9                	mov    %ebp,%ecx
  803887:	d3 e2                	shl    %cl,%edx
  803889:	89 14 24             	mov    %edx,(%esp)
  80388c:	89 d8                	mov    %ebx,%eax
  80388e:	d3 e0                	shl    %cl,%eax
  803890:	89 c2                	mov    %eax,%edx
  803892:	8b 44 24 08          	mov    0x8(%esp),%eax
  803896:	d3 e0                	shl    %cl,%eax
  803898:	89 44 24 04          	mov    %eax,0x4(%esp)
  80389c:	8b 44 24 08          	mov    0x8(%esp),%eax
  8038a0:	89 f1                	mov    %esi,%ecx
  8038a2:	d3 e8                	shr    %cl,%eax
  8038a4:	09 d0                	or     %edx,%eax
  8038a6:	d3 eb                	shr    %cl,%ebx
  8038a8:	89 da                	mov    %ebx,%edx
  8038aa:	f7 f7                	div    %edi
  8038ac:	89 d3                	mov    %edx,%ebx
  8038ae:	f7 24 24             	mull   (%esp)
  8038b1:	89 c6                	mov    %eax,%esi
  8038b3:	89 d1                	mov    %edx,%ecx
  8038b5:	39 d3                	cmp    %edx,%ebx
  8038b7:	0f 82 87 00 00 00    	jb     803944 <__umoddi3+0x134>
  8038bd:	0f 84 91 00 00 00    	je     803954 <__umoddi3+0x144>
  8038c3:	8b 54 24 04          	mov    0x4(%esp),%edx
  8038c7:	29 f2                	sub    %esi,%edx
  8038c9:	19 cb                	sbb    %ecx,%ebx
  8038cb:	89 d8                	mov    %ebx,%eax
  8038cd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8038d1:	d3 e0                	shl    %cl,%eax
  8038d3:	89 e9                	mov    %ebp,%ecx
  8038d5:	d3 ea                	shr    %cl,%edx
  8038d7:	09 d0                	or     %edx,%eax
  8038d9:	89 e9                	mov    %ebp,%ecx
  8038db:	d3 eb                	shr    %cl,%ebx
  8038dd:	89 da                	mov    %ebx,%edx
  8038df:	83 c4 1c             	add    $0x1c,%esp
  8038e2:	5b                   	pop    %ebx
  8038e3:	5e                   	pop    %esi
  8038e4:	5f                   	pop    %edi
  8038e5:	5d                   	pop    %ebp
  8038e6:	c3                   	ret    
  8038e7:	90                   	nop
  8038e8:	89 fd                	mov    %edi,%ebp
  8038ea:	85 ff                	test   %edi,%edi
  8038ec:	75 0b                	jne    8038f9 <__umoddi3+0xe9>
  8038ee:	b8 01 00 00 00       	mov    $0x1,%eax
  8038f3:	31 d2                	xor    %edx,%edx
  8038f5:	f7 f7                	div    %edi
  8038f7:	89 c5                	mov    %eax,%ebp
  8038f9:	89 f0                	mov    %esi,%eax
  8038fb:	31 d2                	xor    %edx,%edx
  8038fd:	f7 f5                	div    %ebp
  8038ff:	89 c8                	mov    %ecx,%eax
  803901:	f7 f5                	div    %ebp
  803903:	89 d0                	mov    %edx,%eax
  803905:	e9 44 ff ff ff       	jmp    80384e <__umoddi3+0x3e>
  80390a:	66 90                	xchg   %ax,%ax
  80390c:	89 c8                	mov    %ecx,%eax
  80390e:	89 f2                	mov    %esi,%edx
  803910:	83 c4 1c             	add    $0x1c,%esp
  803913:	5b                   	pop    %ebx
  803914:	5e                   	pop    %esi
  803915:	5f                   	pop    %edi
  803916:	5d                   	pop    %ebp
  803917:	c3                   	ret    
  803918:	3b 04 24             	cmp    (%esp),%eax
  80391b:	72 06                	jb     803923 <__umoddi3+0x113>
  80391d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803921:	77 0f                	ja     803932 <__umoddi3+0x122>
  803923:	89 f2                	mov    %esi,%edx
  803925:	29 f9                	sub    %edi,%ecx
  803927:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80392b:	89 14 24             	mov    %edx,(%esp)
  80392e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803932:	8b 44 24 04          	mov    0x4(%esp),%eax
  803936:	8b 14 24             	mov    (%esp),%edx
  803939:	83 c4 1c             	add    $0x1c,%esp
  80393c:	5b                   	pop    %ebx
  80393d:	5e                   	pop    %esi
  80393e:	5f                   	pop    %edi
  80393f:	5d                   	pop    %ebp
  803940:	c3                   	ret    
  803941:	8d 76 00             	lea    0x0(%esi),%esi
  803944:	2b 04 24             	sub    (%esp),%eax
  803947:	19 fa                	sbb    %edi,%edx
  803949:	89 d1                	mov    %edx,%ecx
  80394b:	89 c6                	mov    %eax,%esi
  80394d:	e9 71 ff ff ff       	jmp    8038c3 <__umoddi3+0xb3>
  803952:	66 90                	xchg   %ax,%ax
  803954:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803958:	72 ea                	jb     803944 <__umoddi3+0x134>
  80395a:	89 d9                	mov    %ebx,%ecx
  80395c:	e9 62 ff ff ff       	jmp    8038c3 <__umoddi3+0xb3>
