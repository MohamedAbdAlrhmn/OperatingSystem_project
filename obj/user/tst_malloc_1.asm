
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
  80008d:	68 60 3b 80 00       	push   $0x803b60
  800092:	6a 14                	push   $0x14
  800094:	68 7c 3b 80 00       	push   $0x803b7c
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
  8000ca:	e8 6b 1c 00 00       	call   801d3a <sys_calculate_free_frames>
  8000cf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8000d2:	e8 03 1d 00 00       	call   801dda <sys_pf_calculate_allocated_pages>
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
  800105:	68 90 3b 80 00       	push   $0x803b90
  80010a:	6a 23                	push   $0x23
  80010c:	68 7c 3b 80 00       	push   $0x803b7c
  800111:	e8 cb 05 00 00       	call   8006e1 <_panic>
		//		if ((freeFrames - sys_calculate_free_frames()) != 512+1 ) panic("Wrong allocation: ");
		//cprintf("freeFrames - sys_calculate_free_frames() = %d\n", freeFrames - sys_calculate_free_frames()) ;
		//cprintf("Expected = %d\n", (1 + sizeOfMemBlocksArray/PAGE_SIZE));
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800116:	e8 1f 1c 00 00       	call   801d3a <sys_calculate_free_frames>
  80011b:	89 c2                	mov    %eax,%edx
  80011d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800120:	39 c2                	cmp    %eax,%edx
  800122:	74 14                	je     800138 <_main+0x100>
  800124:	83 ec 04             	sub    $0x4,%esp
  800127:	68 c0 3b 80 00       	push   $0x803bc0
  80012c:	6a 27                	push   $0x27
  80012e:	68 7c 3b 80 00       	push   $0x803b7c
  800133:	e8 a9 05 00 00       	call   8006e1 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800138:	e8 9d 1c 00 00       	call   801dda <sys_pf_calculate_allocated_pages>
  80013d:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800140:	74 14                	je     800156 <_main+0x11e>
  800142:	83 ec 04             	sub    $0x4,%esp
  800145:	68 2c 3c 80 00       	push   $0x803c2c
  80014a:	6a 28                	push   $0x28
  80014c:	68 7c 3b 80 00       	push   $0x803b7c
  800151:	e8 8b 05 00 00       	call   8006e1 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800156:	e8 df 1b 00 00       	call   801d3a <sys_calculate_free_frames>
  80015b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80015e:	e8 77 1c 00 00       	call   801dda <sys_pf_calculate_allocated_pages>
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
  8001a6:	68 90 3b 80 00       	push   $0x803b90
  8001ab:	6a 2d                	push   $0x2d
  8001ad:	68 7c 3b 80 00       	push   $0x803b7c
  8001b2:	e8 2a 05 00 00       	call   8006e1 <_panic>
		//		if ((freeFrames - sys_calculate_free_frames()) != 512 ) panic("Wrong allocation: ");
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8001b7:	e8 7e 1b 00 00       	call   801d3a <sys_calculate_free_frames>
  8001bc:	89 c2                	mov    %eax,%edx
  8001be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001c1:	39 c2                	cmp    %eax,%edx
  8001c3:	74 14                	je     8001d9 <_main+0x1a1>
  8001c5:	83 ec 04             	sub    $0x4,%esp
  8001c8:	68 c0 3b 80 00       	push   $0x803bc0
  8001cd:	6a 2f                	push   $0x2f
  8001cf:	68 7c 3b 80 00       	push   $0x803b7c
  8001d4:	e8 08 05 00 00       	call   8006e1 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8001d9:	e8 fc 1b 00 00       	call   801dda <sys_pf_calculate_allocated_pages>
  8001de:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8001e1:	74 14                	je     8001f7 <_main+0x1bf>
  8001e3:	83 ec 04             	sub    $0x4,%esp
  8001e6:	68 2c 3c 80 00       	push   $0x803c2c
  8001eb:	6a 30                	push   $0x30
  8001ed:	68 7c 3b 80 00       	push   $0x803b7c
  8001f2:	e8 ea 04 00 00       	call   8006e1 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8001f7:	e8 3e 1b 00 00       	call   801d3a <sys_calculate_free_frames>
  8001fc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8001ff:	e8 d6 1b 00 00       	call   801dda <sys_pf_calculate_allocated_pages>
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
  80024a:	68 90 3b 80 00       	push   $0x803b90
  80024f:	6a 35                	push   $0x35
  800251:	68 7c 3b 80 00       	push   $0x803b7c
  800256:	e8 86 04 00 00       	call   8006e1 <_panic>
		//		if ((freeFrames - sys_calculate_free_frames()) != 1+1 ) panic("Wrong allocation: ");
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  80025b:	e8 da 1a 00 00       	call   801d3a <sys_calculate_free_frames>
  800260:	89 c2                	mov    %eax,%edx
  800262:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800265:	39 c2                	cmp    %eax,%edx
  800267:	74 14                	je     80027d <_main+0x245>
  800269:	83 ec 04             	sub    $0x4,%esp
  80026c:	68 c0 3b 80 00       	push   $0x803bc0
  800271:	6a 37                	push   $0x37
  800273:	68 7c 3b 80 00       	push   $0x803b7c
  800278:	e8 64 04 00 00       	call   8006e1 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  80027d:	e8 58 1b 00 00       	call   801dda <sys_pf_calculate_allocated_pages>
  800282:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800285:	74 14                	je     80029b <_main+0x263>
  800287:	83 ec 04             	sub    $0x4,%esp
  80028a:	68 2c 3c 80 00       	push   $0x803c2c
  80028f:	6a 38                	push   $0x38
  800291:	68 7c 3b 80 00       	push   $0x803b7c
  800296:	e8 46 04 00 00       	call   8006e1 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  80029b:	e8 9a 1a 00 00       	call   801d3a <sys_calculate_free_frames>
  8002a0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8002a3:	e8 32 1b 00 00       	call   801dda <sys_pf_calculate_allocated_pages>
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
  800302:	68 90 3b 80 00       	push   $0x803b90
  800307:	6a 3d                	push   $0x3d
  800309:	68 7c 3b 80 00       	push   $0x803b7c
  80030e:	e8 ce 03 00 00       	call   8006e1 <_panic>
		//		if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: ");
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800313:	e8 22 1a 00 00       	call   801d3a <sys_calculate_free_frames>
  800318:	89 c2                	mov    %eax,%edx
  80031a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80031d:	39 c2                	cmp    %eax,%edx
  80031f:	74 14                	je     800335 <_main+0x2fd>
  800321:	83 ec 04             	sub    $0x4,%esp
  800324:	68 c0 3b 80 00       	push   $0x803bc0
  800329:	6a 3f                	push   $0x3f
  80032b:	68 7c 3b 80 00       	push   $0x803b7c
  800330:	e8 ac 03 00 00       	call   8006e1 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800335:	e8 a0 1a 00 00       	call   801dda <sys_pf_calculate_allocated_pages>
  80033a:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80033d:	74 14                	je     800353 <_main+0x31b>
  80033f:	83 ec 04             	sub    $0x4,%esp
  800342:	68 2c 3c 80 00       	push   $0x803c2c
  800347:	6a 40                	push   $0x40
  800349:	68 7c 3b 80 00       	push   $0x803b7c
  80034e:	e8 8e 03 00 00       	call   8006e1 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800353:	e8 e2 19 00 00       	call   801d3a <sys_calculate_free_frames>
  800358:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80035b:	e8 7a 1a 00 00       	call   801dda <sys_pf_calculate_allocated_pages>
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
  8003be:	68 90 3b 80 00       	push   $0x803b90
  8003c3:	6a 45                	push   $0x45
  8003c5:	68 7c 3b 80 00       	push   $0x803b7c
  8003ca:	e8 12 03 00 00       	call   8006e1 <_panic>
		//		if ((freeFrames - sys_calculate_free_frames()) != 2)panic("Wrong allocation: ");
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8003cf:	e8 66 19 00 00       	call   801d3a <sys_calculate_free_frames>
  8003d4:	89 c2                	mov    %eax,%edx
  8003d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003d9:	39 c2                	cmp    %eax,%edx
  8003db:	74 14                	je     8003f1 <_main+0x3b9>
  8003dd:	83 ec 04             	sub    $0x4,%esp
  8003e0:	68 c0 3b 80 00       	push   $0x803bc0
  8003e5:	6a 47                	push   $0x47
  8003e7:	68 7c 3b 80 00       	push   $0x803b7c
  8003ec:	e8 f0 02 00 00       	call   8006e1 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8003f1:	e8 e4 19 00 00       	call   801dda <sys_pf_calculate_allocated_pages>
  8003f6:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8003f9:	74 14                	je     80040f <_main+0x3d7>
  8003fb:	83 ec 04             	sub    $0x4,%esp
  8003fe:	68 2c 3c 80 00       	push   $0x803c2c
  800403:	6a 48                	push   $0x48
  800405:	68 7c 3b 80 00       	push   $0x803b7c
  80040a:	e8 d2 02 00 00       	call   8006e1 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  80040f:	e8 26 19 00 00       	call   801d3a <sys_calculate_free_frames>
  800414:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800417:	e8 be 19 00 00       	call   801dda <sys_pf_calculate_allocated_pages>
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
  800479:	68 90 3b 80 00       	push   $0x803b90
  80047e:	6a 4d                	push   $0x4d
  800480:	68 7c 3b 80 00       	push   $0x803b7c
  800485:	e8 57 02 00 00       	call   8006e1 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  80048a:	e8 ab 18 00 00       	call   801d3a <sys_calculate_free_frames>
  80048f:	89 c2                	mov    %eax,%edx
  800491:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800494:	39 c2                	cmp    %eax,%edx
  800496:	74 14                	je     8004ac <_main+0x474>
  800498:	83 ec 04             	sub    $0x4,%esp
  80049b:	68 5a 3c 80 00       	push   $0x803c5a
  8004a0:	6a 4e                	push   $0x4e
  8004a2:	68 7c 3b 80 00       	push   $0x803b7c
  8004a7:	e8 35 02 00 00       	call   8006e1 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8004ac:	e8 29 19 00 00       	call   801dda <sys_pf_calculate_allocated_pages>
  8004b1:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8004b4:	74 14                	je     8004ca <_main+0x492>
  8004b6:	83 ec 04             	sub    $0x4,%esp
  8004b9:	68 2c 3c 80 00       	push   $0x803c2c
  8004be:	6a 4f                	push   $0x4f
  8004c0:	68 7c 3b 80 00       	push   $0x803b7c
  8004c5:	e8 17 02 00 00       	call   8006e1 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8004ca:	e8 6b 18 00 00       	call   801d3a <sys_calculate_free_frames>
  8004cf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8004d2:	e8 03 19 00 00       	call   801dda <sys_pf_calculate_allocated_pages>
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
  80053e:	68 90 3b 80 00       	push   $0x803b90
  800543:	6a 54                	push   $0x54
  800545:	68 7c 3b 80 00       	push   $0x803b7c
  80054a:	e8 92 01 00 00       	call   8006e1 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  80054f:	e8 e6 17 00 00       	call   801d3a <sys_calculate_free_frames>
  800554:	89 c2                	mov    %eax,%edx
  800556:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800559:	39 c2                	cmp    %eax,%edx
  80055b:	74 14                	je     800571 <_main+0x539>
  80055d:	83 ec 04             	sub    $0x4,%esp
  800560:	68 5a 3c 80 00       	push   $0x803c5a
  800565:	6a 55                	push   $0x55
  800567:	68 7c 3b 80 00       	push   $0x803b7c
  80056c:	e8 70 01 00 00       	call   8006e1 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800571:	e8 64 18 00 00       	call   801dda <sys_pf_calculate_allocated_pages>
  800576:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800579:	74 14                	je     80058f <_main+0x557>
  80057b:	83 ec 04             	sub    $0x4,%esp
  80057e:	68 2c 3c 80 00       	push   $0x803c2c
  800583:	6a 56                	push   $0x56
  800585:	68 7c 3b 80 00       	push   $0x803b7c
  80058a:	e8 52 01 00 00       	call   8006e1 <_panic>
	}

	cprintf("Congratulations!! test malloc (1) completed successfully.\n");
  80058f:	83 ec 0c             	sub    $0xc,%esp
  800592:	68 70 3c 80 00       	push   $0x803c70
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
  8005ab:	e8 6a 1a 00 00       	call   80201a <sys_getenvindex>
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
  800616:	e8 0c 18 00 00       	call   801e27 <sys_disable_interrupt>
	cprintf("**************************************\n");
  80061b:	83 ec 0c             	sub    $0xc,%esp
  80061e:	68 c4 3c 80 00       	push   $0x803cc4
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
  800646:	68 ec 3c 80 00       	push   $0x803cec
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
  800677:	68 14 3d 80 00       	push   $0x803d14
  80067c:	e8 14 03 00 00       	call   800995 <cprintf>
  800681:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800684:	a1 20 50 80 00       	mov    0x805020,%eax
  800689:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80068f:	83 ec 08             	sub    $0x8,%esp
  800692:	50                   	push   %eax
  800693:	68 6c 3d 80 00       	push   $0x803d6c
  800698:	e8 f8 02 00 00       	call   800995 <cprintf>
  80069d:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8006a0:	83 ec 0c             	sub    $0xc,%esp
  8006a3:	68 c4 3c 80 00       	push   $0x803cc4
  8006a8:	e8 e8 02 00 00       	call   800995 <cprintf>
  8006ad:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8006b0:	e8 8c 17 00 00       	call   801e41 <sys_enable_interrupt>

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
  8006c8:	e8 19 19 00 00       	call   801fe6 <sys_destroy_env>
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
  8006d9:	e8 6e 19 00 00       	call   80204c <sys_exit_env>
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
  800702:	68 80 3d 80 00       	push   $0x803d80
  800707:	e8 89 02 00 00       	call   800995 <cprintf>
  80070c:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80070f:	a1 00 50 80 00       	mov    0x805000,%eax
  800714:	ff 75 0c             	pushl  0xc(%ebp)
  800717:	ff 75 08             	pushl  0x8(%ebp)
  80071a:	50                   	push   %eax
  80071b:	68 85 3d 80 00       	push   $0x803d85
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
  80073f:	68 a1 3d 80 00       	push   $0x803da1
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
  80076b:	68 a4 3d 80 00       	push   $0x803da4
  800770:	6a 26                	push   $0x26
  800772:	68 f0 3d 80 00       	push   $0x803df0
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
  80083d:	68 fc 3d 80 00       	push   $0x803dfc
  800842:	6a 3a                	push   $0x3a
  800844:	68 f0 3d 80 00       	push   $0x803df0
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
  8008ad:	68 50 3e 80 00       	push   $0x803e50
  8008b2:	6a 44                	push   $0x44
  8008b4:	68 f0 3d 80 00       	push   $0x803df0
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
  800907:	e8 6d 13 00 00       	call   801c79 <sys_cputs>
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
  80097e:	e8 f6 12 00 00       	call   801c79 <sys_cputs>
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
  8009c8:	e8 5a 14 00 00       	call   801e27 <sys_disable_interrupt>
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
  8009e8:	e8 54 14 00 00       	call   801e41 <sys_enable_interrupt>
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
  800a32:	e8 c5 2e 00 00       	call   8038fc <__udivdi3>
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
  800a82:	e8 85 2f 00 00       	call   803a0c <__umoddi3>
  800a87:	83 c4 10             	add    $0x10,%esp
  800a8a:	05 b4 40 80 00       	add    $0x8040b4,%eax
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
  800bdd:	8b 04 85 d8 40 80 00 	mov    0x8040d8(,%eax,4),%eax
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
  800cbe:	8b 34 9d 20 3f 80 00 	mov    0x803f20(,%ebx,4),%esi
  800cc5:	85 f6                	test   %esi,%esi
  800cc7:	75 19                	jne    800ce2 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800cc9:	53                   	push   %ebx
  800cca:	68 c5 40 80 00       	push   $0x8040c5
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
  800ce3:	68 ce 40 80 00       	push   $0x8040ce
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
  800d10:	be d1 40 80 00       	mov    $0x8040d1,%esi
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
  801736:	68 30 42 80 00       	push   $0x804230
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
  801806:	e8 b2 05 00 00       	call   801dbd <sys_allocate_chunk>
  80180b:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  80180e:	a1 20 51 80 00       	mov    0x805120,%eax
  801813:	83 ec 0c             	sub    $0xc,%esp
  801816:	50                   	push   %eax
  801817:	e8 27 0c 00 00       	call   802443 <initialize_MemBlocksList>
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
  801844:	68 55 42 80 00       	push   $0x804255
  801849:	6a 33                	push   $0x33
  80184b:	68 73 42 80 00       	push   $0x804273
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
  8018c3:	68 80 42 80 00       	push   $0x804280
  8018c8:	6a 34                	push   $0x34
  8018ca:	68 73 42 80 00       	push   $0x804273
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
  80195b:	e8 2b 08 00 00       	call   80218b <sys_isUHeapPlacementStrategyFIRSTFIT>
  801960:	85 c0                	test   %eax,%eax
  801962:	74 11                	je     801975 <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  801964:	83 ec 0c             	sub    $0xc,%esp
  801967:	ff 75 e8             	pushl  -0x18(%ebp)
  80196a:	e8 96 0e 00 00       	call   802805 <alloc_block_FF>
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
  801981:	e8 f2 0b 00 00       	call   802578 <insert_sorted_allocList>
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
  80199b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	struct MemBlock * free_block=find_block(&AllocMemBlocksList,(uint32)virtual_address);
  80199e:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a1:	83 ec 08             	sub    $0x8,%esp
  8019a4:	50                   	push   %eax
  8019a5:	68 40 50 80 00       	push   $0x805040
  8019aa:	e8 71 0b 00 00       	call   802520 <find_block>
  8019af:	83 c4 10             	add    $0x10,%esp
  8019b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(free_block!=NULL)
  8019b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8019b9:	0f 84 a6 00 00 00    	je     801a65 <free+0xcd>
	{
		sys_free_user_mem(free_block->sva,free_block->size);
  8019bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019c2:	8b 50 0c             	mov    0xc(%eax),%edx
  8019c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019c8:	8b 40 08             	mov    0x8(%eax),%eax
  8019cb:	83 ec 08             	sub    $0x8,%esp
  8019ce:	52                   	push   %edx
  8019cf:	50                   	push   %eax
  8019d0:	e8 b0 03 00 00       	call   801d85 <sys_free_user_mem>
  8019d5:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,free_block);
  8019d8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8019dc:	75 14                	jne    8019f2 <free+0x5a>
  8019de:	83 ec 04             	sub    $0x4,%esp
  8019e1:	68 55 42 80 00       	push   $0x804255
  8019e6:	6a 74                	push   $0x74
  8019e8:	68 73 42 80 00       	push   $0x804273
  8019ed:	e8 ef ec ff ff       	call   8006e1 <_panic>
  8019f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019f5:	8b 00                	mov    (%eax),%eax
  8019f7:	85 c0                	test   %eax,%eax
  8019f9:	74 10                	je     801a0b <free+0x73>
  8019fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019fe:	8b 00                	mov    (%eax),%eax
  801a00:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a03:	8b 52 04             	mov    0x4(%edx),%edx
  801a06:	89 50 04             	mov    %edx,0x4(%eax)
  801a09:	eb 0b                	jmp    801a16 <free+0x7e>
  801a0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a0e:	8b 40 04             	mov    0x4(%eax),%eax
  801a11:	a3 44 50 80 00       	mov    %eax,0x805044
  801a16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a19:	8b 40 04             	mov    0x4(%eax),%eax
  801a1c:	85 c0                	test   %eax,%eax
  801a1e:	74 0f                	je     801a2f <free+0x97>
  801a20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a23:	8b 40 04             	mov    0x4(%eax),%eax
  801a26:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a29:	8b 12                	mov    (%edx),%edx
  801a2b:	89 10                	mov    %edx,(%eax)
  801a2d:	eb 0a                	jmp    801a39 <free+0xa1>
  801a2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a32:	8b 00                	mov    (%eax),%eax
  801a34:	a3 40 50 80 00       	mov    %eax,0x805040
  801a39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a3c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801a42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a45:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801a4c:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801a51:	48                   	dec    %eax
  801a52:	a3 4c 50 80 00       	mov    %eax,0x80504c
		insert_sorted_with_merge_freeList(free_block);
  801a57:	83 ec 0c             	sub    $0xc,%esp
  801a5a:	ff 75 f4             	pushl  -0xc(%ebp)
  801a5d:	e8 4e 17 00 00       	call   8031b0 <insert_sorted_with_merge_freeList>
  801a62:	83 c4 10             	add    $0x10,%esp
	}

	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  801a65:	90                   	nop
  801a66:	c9                   	leave  
  801a67:	c3                   	ret    

00801a68 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801a68:	55                   	push   %ebp
  801a69:	89 e5                	mov    %esp,%ebp
  801a6b:	83 ec 38             	sub    $0x38,%esp
  801a6e:	8b 45 10             	mov    0x10(%ebp),%eax
  801a71:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801a74:	e8 a6 fc ff ff       	call   80171f <InitializeUHeap>
	if (size == 0) return NULL ;
  801a79:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801a7d:	75 0a                	jne    801a89 <smalloc+0x21>
  801a7f:	b8 00 00 00 00       	mov    $0x0,%eax
  801a84:	e9 8b 00 00 00       	jmp    801b14 <smalloc+0xac>
	//	   Else, return NULL

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801a89:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801a90:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a93:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a96:	01 d0                	add    %edx,%eax
  801a98:	48                   	dec    %eax
  801a99:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801a9c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a9f:	ba 00 00 00 00       	mov    $0x0,%edx
  801aa4:	f7 75 f0             	divl   -0x10(%ebp)
  801aa7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801aaa:	29 d0                	sub    %edx,%eax
  801aac:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801aaf:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801ab6:	e8 d0 06 00 00       	call   80218b <sys_isUHeapPlacementStrategyFIRSTFIT>
  801abb:	85 c0                	test   %eax,%eax
  801abd:	74 11                	je     801ad0 <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  801abf:	83 ec 0c             	sub    $0xc,%esp
  801ac2:	ff 75 e8             	pushl  -0x18(%ebp)
  801ac5:	e8 3b 0d 00 00       	call   802805 <alloc_block_FF>
  801aca:	83 c4 10             	add    $0x10,%esp
  801acd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(mem_block != NULL)
  801ad0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ad4:	74 39                	je     801b0f <smalloc+0xa7>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801ad6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ad9:	8b 40 08             	mov    0x8(%eax),%eax
  801adc:	89 c2                	mov    %eax,%edx
  801ade:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801ae2:	52                   	push   %edx
  801ae3:	50                   	push   %eax
  801ae4:	ff 75 0c             	pushl  0xc(%ebp)
  801ae7:	ff 75 08             	pushl  0x8(%ebp)
  801aea:	e8 21 04 00 00       	call   801f10 <sys_createSharedObject>
  801aef:	83 c4 10             	add    $0x10,%esp
  801af2:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  801af5:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  801af9:	74 14                	je     801b0f <smalloc+0xa7>
  801afb:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  801aff:	74 0e                	je     801b0f <smalloc+0xa7>
  801b01:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  801b05:	74 08                	je     801b0f <smalloc+0xa7>
			return (void*) mem_block->sva;
  801b07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b0a:	8b 40 08             	mov    0x8(%eax),%eax
  801b0d:	eb 05                	jmp    801b14 <smalloc+0xac>
	}
	return NULL;
  801b0f:	b8 00 00 00 00       	mov    $0x0,%eax

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801b14:	c9                   	leave  
  801b15:	c3                   	ret    

00801b16 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801b16:	55                   	push   %ebp
  801b17:	89 e5                	mov    %esp,%ebp
  801b19:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801b1c:	e8 fe fb ff ff       	call   80171f <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801b21:	83 ec 08             	sub    $0x8,%esp
  801b24:	ff 75 0c             	pushl  0xc(%ebp)
  801b27:	ff 75 08             	pushl  0x8(%ebp)
  801b2a:	e8 0b 04 00 00       	call   801f3a <sys_getSizeOfSharedObject>
  801b2f:	83 c4 10             	add    $0x10,%esp
  801b32:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size != E_SHARED_MEM_NOT_EXISTS)
  801b35:	83 7d f0 f0          	cmpl   $0xfffffff0,-0x10(%ebp)
  801b39:	74 76                	je     801bb1 <sget+0x9b>
	{
		uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801b3b:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801b42:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b45:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b48:	01 d0                	add    %edx,%eax
  801b4a:	48                   	dec    %eax
  801b4b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801b4e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b51:	ba 00 00 00 00       	mov    $0x0,%edx
  801b56:	f7 75 ec             	divl   -0x14(%ebp)
  801b59:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b5c:	29 d0                	sub    %edx,%eax
  801b5e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		struct MemBlock * mem_block = NULL;
  801b61:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801b68:	e8 1e 06 00 00       	call   80218b <sys_isUHeapPlacementStrategyFIRSTFIT>
  801b6d:	85 c0                	test   %eax,%eax
  801b6f:	74 11                	je     801b82 <sget+0x6c>
			mem_block = alloc_block_FF(allocate_space);
  801b71:	83 ec 0c             	sub    $0xc,%esp
  801b74:	ff 75 e4             	pushl  -0x1c(%ebp)
  801b77:	e8 89 0c 00 00       	call   802805 <alloc_block_FF>
  801b7c:	83 c4 10             	add    $0x10,%esp
  801b7f:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(mem_block != NULL)
  801b82:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801b86:	74 29                	je     801bb1 <sget+0x9b>
		{
			uint32 shared_object_id = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)mem_block->sva);
  801b88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b8b:	8b 40 08             	mov    0x8(%eax),%eax
  801b8e:	83 ec 04             	sub    $0x4,%esp
  801b91:	50                   	push   %eax
  801b92:	ff 75 0c             	pushl  0xc(%ebp)
  801b95:	ff 75 08             	pushl  0x8(%ebp)
  801b98:	e8 ba 03 00 00       	call   801f57 <sys_getSharedObject>
  801b9d:	83 c4 10             	add    $0x10,%esp
  801ba0:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (shared_object_id != E_SHARED_MEM_NOT_EXISTS)
  801ba3:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%ebp)
  801ba7:	74 08                	je     801bb1 <sget+0x9b>
				return (void *)mem_block->sva;
  801ba9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bac:	8b 40 08             	mov    0x8(%eax),%eax
  801baf:	eb 05                	jmp    801bb6 <sget+0xa0>
		}
	}
	return NULL;
  801bb1:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801bb6:	c9                   	leave  
  801bb7:	c3                   	ret    

00801bb8 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801bb8:	55                   	push   %ebp
  801bb9:	89 e5                	mov    %esp,%ebp
  801bbb:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801bbe:	e8 5c fb ff ff       	call   80171f <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801bc3:	83 ec 04             	sub    $0x4,%esp
  801bc6:	68 a4 42 80 00       	push   $0x8042a4
  801bcb:	68 f7 00 00 00       	push   $0xf7
  801bd0:	68 73 42 80 00       	push   $0x804273
  801bd5:	e8 07 eb ff ff       	call   8006e1 <_panic>

00801bda <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801bda:	55                   	push   %ebp
  801bdb:	89 e5                	mov    %esp,%ebp
  801bdd:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801be0:	83 ec 04             	sub    $0x4,%esp
  801be3:	68 cc 42 80 00       	push   $0x8042cc
  801be8:	68 0b 01 00 00       	push   $0x10b
  801bed:	68 73 42 80 00       	push   $0x804273
  801bf2:	e8 ea ea ff ff       	call   8006e1 <_panic>

00801bf7 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801bf7:	55                   	push   %ebp
  801bf8:	89 e5                	mov    %esp,%ebp
  801bfa:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801bfd:	83 ec 04             	sub    $0x4,%esp
  801c00:	68 f0 42 80 00       	push   $0x8042f0
  801c05:	68 16 01 00 00       	push   $0x116
  801c0a:	68 73 42 80 00       	push   $0x804273
  801c0f:	e8 cd ea ff ff       	call   8006e1 <_panic>

00801c14 <shrink>:

}
void shrink(uint32 newSize)
{
  801c14:	55                   	push   %ebp
  801c15:	89 e5                	mov    %esp,%ebp
  801c17:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801c1a:	83 ec 04             	sub    $0x4,%esp
  801c1d:	68 f0 42 80 00       	push   $0x8042f0
  801c22:	68 1b 01 00 00       	push   $0x11b
  801c27:	68 73 42 80 00       	push   $0x804273
  801c2c:	e8 b0 ea ff ff       	call   8006e1 <_panic>

00801c31 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801c31:	55                   	push   %ebp
  801c32:	89 e5                	mov    %esp,%ebp
  801c34:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801c37:	83 ec 04             	sub    $0x4,%esp
  801c3a:	68 f0 42 80 00       	push   $0x8042f0
  801c3f:	68 20 01 00 00       	push   $0x120
  801c44:	68 73 42 80 00       	push   $0x804273
  801c49:	e8 93 ea ff ff       	call   8006e1 <_panic>

00801c4e <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801c4e:	55                   	push   %ebp
  801c4f:	89 e5                	mov    %esp,%ebp
  801c51:	57                   	push   %edi
  801c52:	56                   	push   %esi
  801c53:	53                   	push   %ebx
  801c54:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801c57:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c5d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c60:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c63:	8b 7d 18             	mov    0x18(%ebp),%edi
  801c66:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801c69:	cd 30                	int    $0x30
  801c6b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801c6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801c71:	83 c4 10             	add    $0x10,%esp
  801c74:	5b                   	pop    %ebx
  801c75:	5e                   	pop    %esi
  801c76:	5f                   	pop    %edi
  801c77:	5d                   	pop    %ebp
  801c78:	c3                   	ret    

00801c79 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801c79:	55                   	push   %ebp
  801c7a:	89 e5                	mov    %esp,%ebp
  801c7c:	83 ec 04             	sub    $0x4,%esp
  801c7f:	8b 45 10             	mov    0x10(%ebp),%eax
  801c82:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801c85:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801c89:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8c:	6a 00                	push   $0x0
  801c8e:	6a 00                	push   $0x0
  801c90:	52                   	push   %edx
  801c91:	ff 75 0c             	pushl  0xc(%ebp)
  801c94:	50                   	push   %eax
  801c95:	6a 00                	push   $0x0
  801c97:	e8 b2 ff ff ff       	call   801c4e <syscall>
  801c9c:	83 c4 18             	add    $0x18,%esp
}
  801c9f:	90                   	nop
  801ca0:	c9                   	leave  
  801ca1:	c3                   	ret    

00801ca2 <sys_cgetc>:

int
sys_cgetc(void)
{
  801ca2:	55                   	push   %ebp
  801ca3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801ca5:	6a 00                	push   $0x0
  801ca7:	6a 00                	push   $0x0
  801ca9:	6a 00                	push   $0x0
  801cab:	6a 00                	push   $0x0
  801cad:	6a 00                	push   $0x0
  801caf:	6a 01                	push   $0x1
  801cb1:	e8 98 ff ff ff       	call   801c4e <syscall>
  801cb6:	83 c4 18             	add    $0x18,%esp
}
  801cb9:	c9                   	leave  
  801cba:	c3                   	ret    

00801cbb <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801cbb:	55                   	push   %ebp
  801cbc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801cbe:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cc1:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc4:	6a 00                	push   $0x0
  801cc6:	6a 00                	push   $0x0
  801cc8:	6a 00                	push   $0x0
  801cca:	52                   	push   %edx
  801ccb:	50                   	push   %eax
  801ccc:	6a 05                	push   $0x5
  801cce:	e8 7b ff ff ff       	call   801c4e <syscall>
  801cd3:	83 c4 18             	add    $0x18,%esp
}
  801cd6:	c9                   	leave  
  801cd7:	c3                   	ret    

00801cd8 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801cd8:	55                   	push   %ebp
  801cd9:	89 e5                	mov    %esp,%ebp
  801cdb:	56                   	push   %esi
  801cdc:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801cdd:	8b 75 18             	mov    0x18(%ebp),%esi
  801ce0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ce3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ce6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ce9:	8b 45 08             	mov    0x8(%ebp),%eax
  801cec:	56                   	push   %esi
  801ced:	53                   	push   %ebx
  801cee:	51                   	push   %ecx
  801cef:	52                   	push   %edx
  801cf0:	50                   	push   %eax
  801cf1:	6a 06                	push   $0x6
  801cf3:	e8 56 ff ff ff       	call   801c4e <syscall>
  801cf8:	83 c4 18             	add    $0x18,%esp
}
  801cfb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cfe:	5b                   	pop    %ebx
  801cff:	5e                   	pop    %esi
  801d00:	5d                   	pop    %ebp
  801d01:	c3                   	ret    

00801d02 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801d02:	55                   	push   %ebp
  801d03:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801d05:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d08:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0b:	6a 00                	push   $0x0
  801d0d:	6a 00                	push   $0x0
  801d0f:	6a 00                	push   $0x0
  801d11:	52                   	push   %edx
  801d12:	50                   	push   %eax
  801d13:	6a 07                	push   $0x7
  801d15:	e8 34 ff ff ff       	call   801c4e <syscall>
  801d1a:	83 c4 18             	add    $0x18,%esp
}
  801d1d:	c9                   	leave  
  801d1e:	c3                   	ret    

00801d1f <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801d1f:	55                   	push   %ebp
  801d20:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801d22:	6a 00                	push   $0x0
  801d24:	6a 00                	push   $0x0
  801d26:	6a 00                	push   $0x0
  801d28:	ff 75 0c             	pushl  0xc(%ebp)
  801d2b:	ff 75 08             	pushl  0x8(%ebp)
  801d2e:	6a 08                	push   $0x8
  801d30:	e8 19 ff ff ff       	call   801c4e <syscall>
  801d35:	83 c4 18             	add    $0x18,%esp
}
  801d38:	c9                   	leave  
  801d39:	c3                   	ret    

00801d3a <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801d3a:	55                   	push   %ebp
  801d3b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801d3d:	6a 00                	push   $0x0
  801d3f:	6a 00                	push   $0x0
  801d41:	6a 00                	push   $0x0
  801d43:	6a 00                	push   $0x0
  801d45:	6a 00                	push   $0x0
  801d47:	6a 09                	push   $0x9
  801d49:	e8 00 ff ff ff       	call   801c4e <syscall>
  801d4e:	83 c4 18             	add    $0x18,%esp
}
  801d51:	c9                   	leave  
  801d52:	c3                   	ret    

00801d53 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801d53:	55                   	push   %ebp
  801d54:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801d56:	6a 00                	push   $0x0
  801d58:	6a 00                	push   $0x0
  801d5a:	6a 00                	push   $0x0
  801d5c:	6a 00                	push   $0x0
  801d5e:	6a 00                	push   $0x0
  801d60:	6a 0a                	push   $0xa
  801d62:	e8 e7 fe ff ff       	call   801c4e <syscall>
  801d67:	83 c4 18             	add    $0x18,%esp
}
  801d6a:	c9                   	leave  
  801d6b:	c3                   	ret    

00801d6c <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801d6c:	55                   	push   %ebp
  801d6d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801d6f:	6a 00                	push   $0x0
  801d71:	6a 00                	push   $0x0
  801d73:	6a 00                	push   $0x0
  801d75:	6a 00                	push   $0x0
  801d77:	6a 00                	push   $0x0
  801d79:	6a 0b                	push   $0xb
  801d7b:	e8 ce fe ff ff       	call   801c4e <syscall>
  801d80:	83 c4 18             	add    $0x18,%esp
}
  801d83:	c9                   	leave  
  801d84:	c3                   	ret    

00801d85 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801d85:	55                   	push   %ebp
  801d86:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801d88:	6a 00                	push   $0x0
  801d8a:	6a 00                	push   $0x0
  801d8c:	6a 00                	push   $0x0
  801d8e:	ff 75 0c             	pushl  0xc(%ebp)
  801d91:	ff 75 08             	pushl  0x8(%ebp)
  801d94:	6a 0f                	push   $0xf
  801d96:	e8 b3 fe ff ff       	call   801c4e <syscall>
  801d9b:	83 c4 18             	add    $0x18,%esp
	return;
  801d9e:	90                   	nop
}
  801d9f:	c9                   	leave  
  801da0:	c3                   	ret    

00801da1 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801da1:	55                   	push   %ebp
  801da2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801da4:	6a 00                	push   $0x0
  801da6:	6a 00                	push   $0x0
  801da8:	6a 00                	push   $0x0
  801daa:	ff 75 0c             	pushl  0xc(%ebp)
  801dad:	ff 75 08             	pushl  0x8(%ebp)
  801db0:	6a 10                	push   $0x10
  801db2:	e8 97 fe ff ff       	call   801c4e <syscall>
  801db7:	83 c4 18             	add    $0x18,%esp
	return ;
  801dba:	90                   	nop
}
  801dbb:	c9                   	leave  
  801dbc:	c3                   	ret    

00801dbd <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801dbd:	55                   	push   %ebp
  801dbe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801dc0:	6a 00                	push   $0x0
  801dc2:	6a 00                	push   $0x0
  801dc4:	ff 75 10             	pushl  0x10(%ebp)
  801dc7:	ff 75 0c             	pushl  0xc(%ebp)
  801dca:	ff 75 08             	pushl  0x8(%ebp)
  801dcd:	6a 11                	push   $0x11
  801dcf:	e8 7a fe ff ff       	call   801c4e <syscall>
  801dd4:	83 c4 18             	add    $0x18,%esp
	return ;
  801dd7:	90                   	nop
}
  801dd8:	c9                   	leave  
  801dd9:	c3                   	ret    

00801dda <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801dda:	55                   	push   %ebp
  801ddb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801ddd:	6a 00                	push   $0x0
  801ddf:	6a 00                	push   $0x0
  801de1:	6a 00                	push   $0x0
  801de3:	6a 00                	push   $0x0
  801de5:	6a 00                	push   $0x0
  801de7:	6a 0c                	push   $0xc
  801de9:	e8 60 fe ff ff       	call   801c4e <syscall>
  801dee:	83 c4 18             	add    $0x18,%esp
}
  801df1:	c9                   	leave  
  801df2:	c3                   	ret    

00801df3 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801df3:	55                   	push   %ebp
  801df4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801df6:	6a 00                	push   $0x0
  801df8:	6a 00                	push   $0x0
  801dfa:	6a 00                	push   $0x0
  801dfc:	6a 00                	push   $0x0
  801dfe:	ff 75 08             	pushl  0x8(%ebp)
  801e01:	6a 0d                	push   $0xd
  801e03:	e8 46 fe ff ff       	call   801c4e <syscall>
  801e08:	83 c4 18             	add    $0x18,%esp
}
  801e0b:	c9                   	leave  
  801e0c:	c3                   	ret    

00801e0d <sys_scarce_memory>:

void sys_scarce_memory()
{
  801e0d:	55                   	push   %ebp
  801e0e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801e10:	6a 00                	push   $0x0
  801e12:	6a 00                	push   $0x0
  801e14:	6a 00                	push   $0x0
  801e16:	6a 00                	push   $0x0
  801e18:	6a 00                	push   $0x0
  801e1a:	6a 0e                	push   $0xe
  801e1c:	e8 2d fe ff ff       	call   801c4e <syscall>
  801e21:	83 c4 18             	add    $0x18,%esp
}
  801e24:	90                   	nop
  801e25:	c9                   	leave  
  801e26:	c3                   	ret    

00801e27 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801e27:	55                   	push   %ebp
  801e28:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801e2a:	6a 00                	push   $0x0
  801e2c:	6a 00                	push   $0x0
  801e2e:	6a 00                	push   $0x0
  801e30:	6a 00                	push   $0x0
  801e32:	6a 00                	push   $0x0
  801e34:	6a 13                	push   $0x13
  801e36:	e8 13 fe ff ff       	call   801c4e <syscall>
  801e3b:	83 c4 18             	add    $0x18,%esp
}
  801e3e:	90                   	nop
  801e3f:	c9                   	leave  
  801e40:	c3                   	ret    

00801e41 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801e41:	55                   	push   %ebp
  801e42:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801e44:	6a 00                	push   $0x0
  801e46:	6a 00                	push   $0x0
  801e48:	6a 00                	push   $0x0
  801e4a:	6a 00                	push   $0x0
  801e4c:	6a 00                	push   $0x0
  801e4e:	6a 14                	push   $0x14
  801e50:	e8 f9 fd ff ff       	call   801c4e <syscall>
  801e55:	83 c4 18             	add    $0x18,%esp
}
  801e58:	90                   	nop
  801e59:	c9                   	leave  
  801e5a:	c3                   	ret    

00801e5b <sys_cputc>:


void
sys_cputc(const char c)
{
  801e5b:	55                   	push   %ebp
  801e5c:	89 e5                	mov    %esp,%ebp
  801e5e:	83 ec 04             	sub    $0x4,%esp
  801e61:	8b 45 08             	mov    0x8(%ebp),%eax
  801e64:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801e67:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801e6b:	6a 00                	push   $0x0
  801e6d:	6a 00                	push   $0x0
  801e6f:	6a 00                	push   $0x0
  801e71:	6a 00                	push   $0x0
  801e73:	50                   	push   %eax
  801e74:	6a 15                	push   $0x15
  801e76:	e8 d3 fd ff ff       	call   801c4e <syscall>
  801e7b:	83 c4 18             	add    $0x18,%esp
}
  801e7e:	90                   	nop
  801e7f:	c9                   	leave  
  801e80:	c3                   	ret    

00801e81 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801e81:	55                   	push   %ebp
  801e82:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801e84:	6a 00                	push   $0x0
  801e86:	6a 00                	push   $0x0
  801e88:	6a 00                	push   $0x0
  801e8a:	6a 00                	push   $0x0
  801e8c:	6a 00                	push   $0x0
  801e8e:	6a 16                	push   $0x16
  801e90:	e8 b9 fd ff ff       	call   801c4e <syscall>
  801e95:	83 c4 18             	add    $0x18,%esp
}
  801e98:	90                   	nop
  801e99:	c9                   	leave  
  801e9a:	c3                   	ret    

00801e9b <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801e9b:	55                   	push   %ebp
  801e9c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801e9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea1:	6a 00                	push   $0x0
  801ea3:	6a 00                	push   $0x0
  801ea5:	6a 00                	push   $0x0
  801ea7:	ff 75 0c             	pushl  0xc(%ebp)
  801eaa:	50                   	push   %eax
  801eab:	6a 17                	push   $0x17
  801ead:	e8 9c fd ff ff       	call   801c4e <syscall>
  801eb2:	83 c4 18             	add    $0x18,%esp
}
  801eb5:	c9                   	leave  
  801eb6:	c3                   	ret    

00801eb7 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801eb7:	55                   	push   %ebp
  801eb8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801eba:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ebd:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec0:	6a 00                	push   $0x0
  801ec2:	6a 00                	push   $0x0
  801ec4:	6a 00                	push   $0x0
  801ec6:	52                   	push   %edx
  801ec7:	50                   	push   %eax
  801ec8:	6a 1a                	push   $0x1a
  801eca:	e8 7f fd ff ff       	call   801c4e <syscall>
  801ecf:	83 c4 18             	add    $0x18,%esp
}
  801ed2:	c9                   	leave  
  801ed3:	c3                   	ret    

00801ed4 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801ed4:	55                   	push   %ebp
  801ed5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ed7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eda:	8b 45 08             	mov    0x8(%ebp),%eax
  801edd:	6a 00                	push   $0x0
  801edf:	6a 00                	push   $0x0
  801ee1:	6a 00                	push   $0x0
  801ee3:	52                   	push   %edx
  801ee4:	50                   	push   %eax
  801ee5:	6a 18                	push   $0x18
  801ee7:	e8 62 fd ff ff       	call   801c4e <syscall>
  801eec:	83 c4 18             	add    $0x18,%esp
}
  801eef:	90                   	nop
  801ef0:	c9                   	leave  
  801ef1:	c3                   	ret    

00801ef2 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801ef2:	55                   	push   %ebp
  801ef3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ef5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ef8:	8b 45 08             	mov    0x8(%ebp),%eax
  801efb:	6a 00                	push   $0x0
  801efd:	6a 00                	push   $0x0
  801eff:	6a 00                	push   $0x0
  801f01:	52                   	push   %edx
  801f02:	50                   	push   %eax
  801f03:	6a 19                	push   $0x19
  801f05:	e8 44 fd ff ff       	call   801c4e <syscall>
  801f0a:	83 c4 18             	add    $0x18,%esp
}
  801f0d:	90                   	nop
  801f0e:	c9                   	leave  
  801f0f:	c3                   	ret    

00801f10 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801f10:	55                   	push   %ebp
  801f11:	89 e5                	mov    %esp,%ebp
  801f13:	83 ec 04             	sub    $0x4,%esp
  801f16:	8b 45 10             	mov    0x10(%ebp),%eax
  801f19:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801f1c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801f1f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801f23:	8b 45 08             	mov    0x8(%ebp),%eax
  801f26:	6a 00                	push   $0x0
  801f28:	51                   	push   %ecx
  801f29:	52                   	push   %edx
  801f2a:	ff 75 0c             	pushl  0xc(%ebp)
  801f2d:	50                   	push   %eax
  801f2e:	6a 1b                	push   $0x1b
  801f30:	e8 19 fd ff ff       	call   801c4e <syscall>
  801f35:	83 c4 18             	add    $0x18,%esp
}
  801f38:	c9                   	leave  
  801f39:	c3                   	ret    

00801f3a <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801f3a:	55                   	push   %ebp
  801f3b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801f3d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f40:	8b 45 08             	mov    0x8(%ebp),%eax
  801f43:	6a 00                	push   $0x0
  801f45:	6a 00                	push   $0x0
  801f47:	6a 00                	push   $0x0
  801f49:	52                   	push   %edx
  801f4a:	50                   	push   %eax
  801f4b:	6a 1c                	push   $0x1c
  801f4d:	e8 fc fc ff ff       	call   801c4e <syscall>
  801f52:	83 c4 18             	add    $0x18,%esp
}
  801f55:	c9                   	leave  
  801f56:	c3                   	ret    

00801f57 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801f57:	55                   	push   %ebp
  801f58:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801f5a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f5d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f60:	8b 45 08             	mov    0x8(%ebp),%eax
  801f63:	6a 00                	push   $0x0
  801f65:	6a 00                	push   $0x0
  801f67:	51                   	push   %ecx
  801f68:	52                   	push   %edx
  801f69:	50                   	push   %eax
  801f6a:	6a 1d                	push   $0x1d
  801f6c:	e8 dd fc ff ff       	call   801c4e <syscall>
  801f71:	83 c4 18             	add    $0x18,%esp
}
  801f74:	c9                   	leave  
  801f75:	c3                   	ret    

00801f76 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801f76:	55                   	push   %ebp
  801f77:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801f79:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f7f:	6a 00                	push   $0x0
  801f81:	6a 00                	push   $0x0
  801f83:	6a 00                	push   $0x0
  801f85:	52                   	push   %edx
  801f86:	50                   	push   %eax
  801f87:	6a 1e                	push   $0x1e
  801f89:	e8 c0 fc ff ff       	call   801c4e <syscall>
  801f8e:	83 c4 18             	add    $0x18,%esp
}
  801f91:	c9                   	leave  
  801f92:	c3                   	ret    

00801f93 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801f93:	55                   	push   %ebp
  801f94:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801f96:	6a 00                	push   $0x0
  801f98:	6a 00                	push   $0x0
  801f9a:	6a 00                	push   $0x0
  801f9c:	6a 00                	push   $0x0
  801f9e:	6a 00                	push   $0x0
  801fa0:	6a 1f                	push   $0x1f
  801fa2:	e8 a7 fc ff ff       	call   801c4e <syscall>
  801fa7:	83 c4 18             	add    $0x18,%esp
}
  801faa:	c9                   	leave  
  801fab:	c3                   	ret    

00801fac <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801fac:	55                   	push   %ebp
  801fad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801faf:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb2:	6a 00                	push   $0x0
  801fb4:	ff 75 14             	pushl  0x14(%ebp)
  801fb7:	ff 75 10             	pushl  0x10(%ebp)
  801fba:	ff 75 0c             	pushl  0xc(%ebp)
  801fbd:	50                   	push   %eax
  801fbe:	6a 20                	push   $0x20
  801fc0:	e8 89 fc ff ff       	call   801c4e <syscall>
  801fc5:	83 c4 18             	add    $0x18,%esp
}
  801fc8:	c9                   	leave  
  801fc9:	c3                   	ret    

00801fca <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801fca:	55                   	push   %ebp
  801fcb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801fcd:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd0:	6a 00                	push   $0x0
  801fd2:	6a 00                	push   $0x0
  801fd4:	6a 00                	push   $0x0
  801fd6:	6a 00                	push   $0x0
  801fd8:	50                   	push   %eax
  801fd9:	6a 21                	push   $0x21
  801fdb:	e8 6e fc ff ff       	call   801c4e <syscall>
  801fe0:	83 c4 18             	add    $0x18,%esp
}
  801fe3:	90                   	nop
  801fe4:	c9                   	leave  
  801fe5:	c3                   	ret    

00801fe6 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801fe6:	55                   	push   %ebp
  801fe7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801fe9:	8b 45 08             	mov    0x8(%ebp),%eax
  801fec:	6a 00                	push   $0x0
  801fee:	6a 00                	push   $0x0
  801ff0:	6a 00                	push   $0x0
  801ff2:	6a 00                	push   $0x0
  801ff4:	50                   	push   %eax
  801ff5:	6a 22                	push   $0x22
  801ff7:	e8 52 fc ff ff       	call   801c4e <syscall>
  801ffc:	83 c4 18             	add    $0x18,%esp
}
  801fff:	c9                   	leave  
  802000:	c3                   	ret    

00802001 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802001:	55                   	push   %ebp
  802002:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802004:	6a 00                	push   $0x0
  802006:	6a 00                	push   $0x0
  802008:	6a 00                	push   $0x0
  80200a:	6a 00                	push   $0x0
  80200c:	6a 00                	push   $0x0
  80200e:	6a 02                	push   $0x2
  802010:	e8 39 fc ff ff       	call   801c4e <syscall>
  802015:	83 c4 18             	add    $0x18,%esp
}
  802018:	c9                   	leave  
  802019:	c3                   	ret    

0080201a <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80201a:	55                   	push   %ebp
  80201b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80201d:	6a 00                	push   $0x0
  80201f:	6a 00                	push   $0x0
  802021:	6a 00                	push   $0x0
  802023:	6a 00                	push   $0x0
  802025:	6a 00                	push   $0x0
  802027:	6a 03                	push   $0x3
  802029:	e8 20 fc ff ff       	call   801c4e <syscall>
  80202e:	83 c4 18             	add    $0x18,%esp
}
  802031:	c9                   	leave  
  802032:	c3                   	ret    

00802033 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802033:	55                   	push   %ebp
  802034:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802036:	6a 00                	push   $0x0
  802038:	6a 00                	push   $0x0
  80203a:	6a 00                	push   $0x0
  80203c:	6a 00                	push   $0x0
  80203e:	6a 00                	push   $0x0
  802040:	6a 04                	push   $0x4
  802042:	e8 07 fc ff ff       	call   801c4e <syscall>
  802047:	83 c4 18             	add    $0x18,%esp
}
  80204a:	c9                   	leave  
  80204b:	c3                   	ret    

0080204c <sys_exit_env>:


void sys_exit_env(void)
{
  80204c:	55                   	push   %ebp
  80204d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80204f:	6a 00                	push   $0x0
  802051:	6a 00                	push   $0x0
  802053:	6a 00                	push   $0x0
  802055:	6a 00                	push   $0x0
  802057:	6a 00                	push   $0x0
  802059:	6a 23                	push   $0x23
  80205b:	e8 ee fb ff ff       	call   801c4e <syscall>
  802060:	83 c4 18             	add    $0x18,%esp
}
  802063:	90                   	nop
  802064:	c9                   	leave  
  802065:	c3                   	ret    

00802066 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802066:	55                   	push   %ebp
  802067:	89 e5                	mov    %esp,%ebp
  802069:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80206c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80206f:	8d 50 04             	lea    0x4(%eax),%edx
  802072:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802075:	6a 00                	push   $0x0
  802077:	6a 00                	push   $0x0
  802079:	6a 00                	push   $0x0
  80207b:	52                   	push   %edx
  80207c:	50                   	push   %eax
  80207d:	6a 24                	push   $0x24
  80207f:	e8 ca fb ff ff       	call   801c4e <syscall>
  802084:	83 c4 18             	add    $0x18,%esp
	return result;
  802087:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80208a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80208d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802090:	89 01                	mov    %eax,(%ecx)
  802092:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802095:	8b 45 08             	mov    0x8(%ebp),%eax
  802098:	c9                   	leave  
  802099:	c2 04 00             	ret    $0x4

0080209c <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80209c:	55                   	push   %ebp
  80209d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80209f:	6a 00                	push   $0x0
  8020a1:	6a 00                	push   $0x0
  8020a3:	ff 75 10             	pushl  0x10(%ebp)
  8020a6:	ff 75 0c             	pushl  0xc(%ebp)
  8020a9:	ff 75 08             	pushl  0x8(%ebp)
  8020ac:	6a 12                	push   $0x12
  8020ae:	e8 9b fb ff ff       	call   801c4e <syscall>
  8020b3:	83 c4 18             	add    $0x18,%esp
	return ;
  8020b6:	90                   	nop
}
  8020b7:	c9                   	leave  
  8020b8:	c3                   	ret    

008020b9 <sys_rcr2>:
uint32 sys_rcr2()
{
  8020b9:	55                   	push   %ebp
  8020ba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8020bc:	6a 00                	push   $0x0
  8020be:	6a 00                	push   $0x0
  8020c0:	6a 00                	push   $0x0
  8020c2:	6a 00                	push   $0x0
  8020c4:	6a 00                	push   $0x0
  8020c6:	6a 25                	push   $0x25
  8020c8:	e8 81 fb ff ff       	call   801c4e <syscall>
  8020cd:	83 c4 18             	add    $0x18,%esp
}
  8020d0:	c9                   	leave  
  8020d1:	c3                   	ret    

008020d2 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8020d2:	55                   	push   %ebp
  8020d3:	89 e5                	mov    %esp,%ebp
  8020d5:	83 ec 04             	sub    $0x4,%esp
  8020d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020db:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8020de:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8020e2:	6a 00                	push   $0x0
  8020e4:	6a 00                	push   $0x0
  8020e6:	6a 00                	push   $0x0
  8020e8:	6a 00                	push   $0x0
  8020ea:	50                   	push   %eax
  8020eb:	6a 26                	push   $0x26
  8020ed:	e8 5c fb ff ff       	call   801c4e <syscall>
  8020f2:	83 c4 18             	add    $0x18,%esp
	return ;
  8020f5:	90                   	nop
}
  8020f6:	c9                   	leave  
  8020f7:	c3                   	ret    

008020f8 <rsttst>:
void rsttst()
{
  8020f8:	55                   	push   %ebp
  8020f9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8020fb:	6a 00                	push   $0x0
  8020fd:	6a 00                	push   $0x0
  8020ff:	6a 00                	push   $0x0
  802101:	6a 00                	push   $0x0
  802103:	6a 00                	push   $0x0
  802105:	6a 28                	push   $0x28
  802107:	e8 42 fb ff ff       	call   801c4e <syscall>
  80210c:	83 c4 18             	add    $0x18,%esp
	return ;
  80210f:	90                   	nop
}
  802110:	c9                   	leave  
  802111:	c3                   	ret    

00802112 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802112:	55                   	push   %ebp
  802113:	89 e5                	mov    %esp,%ebp
  802115:	83 ec 04             	sub    $0x4,%esp
  802118:	8b 45 14             	mov    0x14(%ebp),%eax
  80211b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80211e:	8b 55 18             	mov    0x18(%ebp),%edx
  802121:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802125:	52                   	push   %edx
  802126:	50                   	push   %eax
  802127:	ff 75 10             	pushl  0x10(%ebp)
  80212a:	ff 75 0c             	pushl  0xc(%ebp)
  80212d:	ff 75 08             	pushl  0x8(%ebp)
  802130:	6a 27                	push   $0x27
  802132:	e8 17 fb ff ff       	call   801c4e <syscall>
  802137:	83 c4 18             	add    $0x18,%esp
	return ;
  80213a:	90                   	nop
}
  80213b:	c9                   	leave  
  80213c:	c3                   	ret    

0080213d <chktst>:
void chktst(uint32 n)
{
  80213d:	55                   	push   %ebp
  80213e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802140:	6a 00                	push   $0x0
  802142:	6a 00                	push   $0x0
  802144:	6a 00                	push   $0x0
  802146:	6a 00                	push   $0x0
  802148:	ff 75 08             	pushl  0x8(%ebp)
  80214b:	6a 29                	push   $0x29
  80214d:	e8 fc fa ff ff       	call   801c4e <syscall>
  802152:	83 c4 18             	add    $0x18,%esp
	return ;
  802155:	90                   	nop
}
  802156:	c9                   	leave  
  802157:	c3                   	ret    

00802158 <inctst>:

void inctst()
{
  802158:	55                   	push   %ebp
  802159:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80215b:	6a 00                	push   $0x0
  80215d:	6a 00                	push   $0x0
  80215f:	6a 00                	push   $0x0
  802161:	6a 00                	push   $0x0
  802163:	6a 00                	push   $0x0
  802165:	6a 2a                	push   $0x2a
  802167:	e8 e2 fa ff ff       	call   801c4e <syscall>
  80216c:	83 c4 18             	add    $0x18,%esp
	return ;
  80216f:	90                   	nop
}
  802170:	c9                   	leave  
  802171:	c3                   	ret    

00802172 <gettst>:
uint32 gettst()
{
  802172:	55                   	push   %ebp
  802173:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802175:	6a 00                	push   $0x0
  802177:	6a 00                	push   $0x0
  802179:	6a 00                	push   $0x0
  80217b:	6a 00                	push   $0x0
  80217d:	6a 00                	push   $0x0
  80217f:	6a 2b                	push   $0x2b
  802181:	e8 c8 fa ff ff       	call   801c4e <syscall>
  802186:	83 c4 18             	add    $0x18,%esp
}
  802189:	c9                   	leave  
  80218a:	c3                   	ret    

0080218b <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80218b:	55                   	push   %ebp
  80218c:	89 e5                	mov    %esp,%ebp
  80218e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802191:	6a 00                	push   $0x0
  802193:	6a 00                	push   $0x0
  802195:	6a 00                	push   $0x0
  802197:	6a 00                	push   $0x0
  802199:	6a 00                	push   $0x0
  80219b:	6a 2c                	push   $0x2c
  80219d:	e8 ac fa ff ff       	call   801c4e <syscall>
  8021a2:	83 c4 18             	add    $0x18,%esp
  8021a5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8021a8:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8021ac:	75 07                	jne    8021b5 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8021ae:	b8 01 00 00 00       	mov    $0x1,%eax
  8021b3:	eb 05                	jmp    8021ba <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8021b5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021ba:	c9                   	leave  
  8021bb:	c3                   	ret    

008021bc <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8021bc:	55                   	push   %ebp
  8021bd:	89 e5                	mov    %esp,%ebp
  8021bf:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8021c2:	6a 00                	push   $0x0
  8021c4:	6a 00                	push   $0x0
  8021c6:	6a 00                	push   $0x0
  8021c8:	6a 00                	push   $0x0
  8021ca:	6a 00                	push   $0x0
  8021cc:	6a 2c                	push   $0x2c
  8021ce:	e8 7b fa ff ff       	call   801c4e <syscall>
  8021d3:	83 c4 18             	add    $0x18,%esp
  8021d6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8021d9:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8021dd:	75 07                	jne    8021e6 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8021df:	b8 01 00 00 00       	mov    $0x1,%eax
  8021e4:	eb 05                	jmp    8021eb <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8021e6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021eb:	c9                   	leave  
  8021ec:	c3                   	ret    

008021ed <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8021ed:	55                   	push   %ebp
  8021ee:	89 e5                	mov    %esp,%ebp
  8021f0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8021f3:	6a 00                	push   $0x0
  8021f5:	6a 00                	push   $0x0
  8021f7:	6a 00                	push   $0x0
  8021f9:	6a 00                	push   $0x0
  8021fb:	6a 00                	push   $0x0
  8021fd:	6a 2c                	push   $0x2c
  8021ff:	e8 4a fa ff ff       	call   801c4e <syscall>
  802204:	83 c4 18             	add    $0x18,%esp
  802207:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80220a:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80220e:	75 07                	jne    802217 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802210:	b8 01 00 00 00       	mov    $0x1,%eax
  802215:	eb 05                	jmp    80221c <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802217:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80221c:	c9                   	leave  
  80221d:	c3                   	ret    

0080221e <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80221e:	55                   	push   %ebp
  80221f:	89 e5                	mov    %esp,%ebp
  802221:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802224:	6a 00                	push   $0x0
  802226:	6a 00                	push   $0x0
  802228:	6a 00                	push   $0x0
  80222a:	6a 00                	push   $0x0
  80222c:	6a 00                	push   $0x0
  80222e:	6a 2c                	push   $0x2c
  802230:	e8 19 fa ff ff       	call   801c4e <syscall>
  802235:	83 c4 18             	add    $0x18,%esp
  802238:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80223b:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80223f:	75 07                	jne    802248 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802241:	b8 01 00 00 00       	mov    $0x1,%eax
  802246:	eb 05                	jmp    80224d <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802248:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80224d:	c9                   	leave  
  80224e:	c3                   	ret    

0080224f <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80224f:	55                   	push   %ebp
  802250:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802252:	6a 00                	push   $0x0
  802254:	6a 00                	push   $0x0
  802256:	6a 00                	push   $0x0
  802258:	6a 00                	push   $0x0
  80225a:	ff 75 08             	pushl  0x8(%ebp)
  80225d:	6a 2d                	push   $0x2d
  80225f:	e8 ea f9 ff ff       	call   801c4e <syscall>
  802264:	83 c4 18             	add    $0x18,%esp
	return ;
  802267:	90                   	nop
}
  802268:	c9                   	leave  
  802269:	c3                   	ret    

0080226a <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80226a:	55                   	push   %ebp
  80226b:	89 e5                	mov    %esp,%ebp
  80226d:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80226e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802271:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802274:	8b 55 0c             	mov    0xc(%ebp),%edx
  802277:	8b 45 08             	mov    0x8(%ebp),%eax
  80227a:	6a 00                	push   $0x0
  80227c:	53                   	push   %ebx
  80227d:	51                   	push   %ecx
  80227e:	52                   	push   %edx
  80227f:	50                   	push   %eax
  802280:	6a 2e                	push   $0x2e
  802282:	e8 c7 f9 ff ff       	call   801c4e <syscall>
  802287:	83 c4 18             	add    $0x18,%esp
}
  80228a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80228d:	c9                   	leave  
  80228e:	c3                   	ret    

0080228f <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80228f:	55                   	push   %ebp
  802290:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802292:	8b 55 0c             	mov    0xc(%ebp),%edx
  802295:	8b 45 08             	mov    0x8(%ebp),%eax
  802298:	6a 00                	push   $0x0
  80229a:	6a 00                	push   $0x0
  80229c:	6a 00                	push   $0x0
  80229e:	52                   	push   %edx
  80229f:	50                   	push   %eax
  8022a0:	6a 2f                	push   $0x2f
  8022a2:	e8 a7 f9 ff ff       	call   801c4e <syscall>
  8022a7:	83 c4 18             	add    $0x18,%esp
}
  8022aa:	c9                   	leave  
  8022ab:	c3                   	ret    

008022ac <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  8022ac:	55                   	push   %ebp
  8022ad:	89 e5                	mov    %esp,%ebp
  8022af:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  8022b2:	83 ec 0c             	sub    $0xc,%esp
  8022b5:	68 00 43 80 00       	push   $0x804300
  8022ba:	e8 d6 e6 ff ff       	call   800995 <cprintf>
  8022bf:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  8022c2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8022c9:	83 ec 0c             	sub    $0xc,%esp
  8022cc:	68 2c 43 80 00       	push   $0x80432c
  8022d1:	e8 bf e6 ff ff       	call   800995 <cprintf>
  8022d6:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8022d9:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8022dd:	a1 38 51 80 00       	mov    0x805138,%eax
  8022e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022e5:	eb 56                	jmp    80233d <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8022e7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8022eb:	74 1c                	je     802309 <print_mem_block_lists+0x5d>
  8022ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f0:	8b 50 08             	mov    0x8(%eax),%edx
  8022f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022f6:	8b 48 08             	mov    0x8(%eax),%ecx
  8022f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022fc:	8b 40 0c             	mov    0xc(%eax),%eax
  8022ff:	01 c8                	add    %ecx,%eax
  802301:	39 c2                	cmp    %eax,%edx
  802303:	73 04                	jae    802309 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802305:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802309:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80230c:	8b 50 08             	mov    0x8(%eax),%edx
  80230f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802312:	8b 40 0c             	mov    0xc(%eax),%eax
  802315:	01 c2                	add    %eax,%edx
  802317:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80231a:	8b 40 08             	mov    0x8(%eax),%eax
  80231d:	83 ec 04             	sub    $0x4,%esp
  802320:	52                   	push   %edx
  802321:	50                   	push   %eax
  802322:	68 41 43 80 00       	push   $0x804341
  802327:	e8 69 e6 ff ff       	call   800995 <cprintf>
  80232c:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80232f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802332:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802335:	a1 40 51 80 00       	mov    0x805140,%eax
  80233a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80233d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802341:	74 07                	je     80234a <print_mem_block_lists+0x9e>
  802343:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802346:	8b 00                	mov    (%eax),%eax
  802348:	eb 05                	jmp    80234f <print_mem_block_lists+0xa3>
  80234a:	b8 00 00 00 00       	mov    $0x0,%eax
  80234f:	a3 40 51 80 00       	mov    %eax,0x805140
  802354:	a1 40 51 80 00       	mov    0x805140,%eax
  802359:	85 c0                	test   %eax,%eax
  80235b:	75 8a                	jne    8022e7 <print_mem_block_lists+0x3b>
  80235d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802361:	75 84                	jne    8022e7 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802363:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802367:	75 10                	jne    802379 <print_mem_block_lists+0xcd>
  802369:	83 ec 0c             	sub    $0xc,%esp
  80236c:	68 50 43 80 00       	push   $0x804350
  802371:	e8 1f e6 ff ff       	call   800995 <cprintf>
  802376:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802379:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802380:	83 ec 0c             	sub    $0xc,%esp
  802383:	68 74 43 80 00       	push   $0x804374
  802388:	e8 08 e6 ff ff       	call   800995 <cprintf>
  80238d:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802390:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802394:	a1 40 50 80 00       	mov    0x805040,%eax
  802399:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80239c:	eb 56                	jmp    8023f4 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80239e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8023a2:	74 1c                	je     8023c0 <print_mem_block_lists+0x114>
  8023a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a7:	8b 50 08             	mov    0x8(%eax),%edx
  8023aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023ad:	8b 48 08             	mov    0x8(%eax),%ecx
  8023b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023b3:	8b 40 0c             	mov    0xc(%eax),%eax
  8023b6:	01 c8                	add    %ecx,%eax
  8023b8:	39 c2                	cmp    %eax,%edx
  8023ba:	73 04                	jae    8023c0 <print_mem_block_lists+0x114>
			sorted = 0 ;
  8023bc:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8023c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c3:	8b 50 08             	mov    0x8(%eax),%edx
  8023c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c9:	8b 40 0c             	mov    0xc(%eax),%eax
  8023cc:	01 c2                	add    %eax,%edx
  8023ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d1:	8b 40 08             	mov    0x8(%eax),%eax
  8023d4:	83 ec 04             	sub    $0x4,%esp
  8023d7:	52                   	push   %edx
  8023d8:	50                   	push   %eax
  8023d9:	68 41 43 80 00       	push   $0x804341
  8023de:	e8 b2 e5 ff ff       	call   800995 <cprintf>
  8023e3:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8023e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8023ec:	a1 48 50 80 00       	mov    0x805048,%eax
  8023f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023f4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023f8:	74 07                	je     802401 <print_mem_block_lists+0x155>
  8023fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023fd:	8b 00                	mov    (%eax),%eax
  8023ff:	eb 05                	jmp    802406 <print_mem_block_lists+0x15a>
  802401:	b8 00 00 00 00       	mov    $0x0,%eax
  802406:	a3 48 50 80 00       	mov    %eax,0x805048
  80240b:	a1 48 50 80 00       	mov    0x805048,%eax
  802410:	85 c0                	test   %eax,%eax
  802412:	75 8a                	jne    80239e <print_mem_block_lists+0xf2>
  802414:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802418:	75 84                	jne    80239e <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  80241a:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80241e:	75 10                	jne    802430 <print_mem_block_lists+0x184>
  802420:	83 ec 0c             	sub    $0xc,%esp
  802423:	68 8c 43 80 00       	push   $0x80438c
  802428:	e8 68 e5 ff ff       	call   800995 <cprintf>
  80242d:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802430:	83 ec 0c             	sub    $0xc,%esp
  802433:	68 00 43 80 00       	push   $0x804300
  802438:	e8 58 e5 ff ff       	call   800995 <cprintf>
  80243d:	83 c4 10             	add    $0x10,%esp

}
  802440:	90                   	nop
  802441:	c9                   	leave  
  802442:	c3                   	ret    

00802443 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802443:	55                   	push   %ebp
  802444:	89 e5                	mov    %esp,%ebp
  802446:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  802449:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802450:	00 00 00 
  802453:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  80245a:	00 00 00 
  80245d:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802464:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  802467:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80246e:	e9 9e 00 00 00       	jmp    802511 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  802473:	a1 50 50 80 00       	mov    0x805050,%eax
  802478:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80247b:	c1 e2 04             	shl    $0x4,%edx
  80247e:	01 d0                	add    %edx,%eax
  802480:	85 c0                	test   %eax,%eax
  802482:	75 14                	jne    802498 <initialize_MemBlocksList+0x55>
  802484:	83 ec 04             	sub    $0x4,%esp
  802487:	68 b4 43 80 00       	push   $0x8043b4
  80248c:	6a 46                	push   $0x46
  80248e:	68 d7 43 80 00       	push   $0x8043d7
  802493:	e8 49 e2 ff ff       	call   8006e1 <_panic>
  802498:	a1 50 50 80 00       	mov    0x805050,%eax
  80249d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024a0:	c1 e2 04             	shl    $0x4,%edx
  8024a3:	01 d0                	add    %edx,%eax
  8024a5:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8024ab:	89 10                	mov    %edx,(%eax)
  8024ad:	8b 00                	mov    (%eax),%eax
  8024af:	85 c0                	test   %eax,%eax
  8024b1:	74 18                	je     8024cb <initialize_MemBlocksList+0x88>
  8024b3:	a1 48 51 80 00       	mov    0x805148,%eax
  8024b8:	8b 15 50 50 80 00    	mov    0x805050,%edx
  8024be:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8024c1:	c1 e1 04             	shl    $0x4,%ecx
  8024c4:	01 ca                	add    %ecx,%edx
  8024c6:	89 50 04             	mov    %edx,0x4(%eax)
  8024c9:	eb 12                	jmp    8024dd <initialize_MemBlocksList+0x9a>
  8024cb:	a1 50 50 80 00       	mov    0x805050,%eax
  8024d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024d3:	c1 e2 04             	shl    $0x4,%edx
  8024d6:	01 d0                	add    %edx,%eax
  8024d8:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8024dd:	a1 50 50 80 00       	mov    0x805050,%eax
  8024e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024e5:	c1 e2 04             	shl    $0x4,%edx
  8024e8:	01 d0                	add    %edx,%eax
  8024ea:	a3 48 51 80 00       	mov    %eax,0x805148
  8024ef:	a1 50 50 80 00       	mov    0x805050,%eax
  8024f4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024f7:	c1 e2 04             	shl    $0x4,%edx
  8024fa:	01 d0                	add    %edx,%eax
  8024fc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802503:	a1 54 51 80 00       	mov    0x805154,%eax
  802508:	40                   	inc    %eax
  802509:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  80250e:	ff 45 f4             	incl   -0xc(%ebp)
  802511:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802514:	3b 45 08             	cmp    0x8(%ebp),%eax
  802517:	0f 82 56 ff ff ff    	jb     802473 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  80251d:	90                   	nop
  80251e:	c9                   	leave  
  80251f:	c3                   	ret    

00802520 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802520:	55                   	push   %ebp
  802521:	89 e5                	mov    %esp,%ebp
  802523:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802526:	8b 45 08             	mov    0x8(%ebp),%eax
  802529:	8b 00                	mov    (%eax),%eax
  80252b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80252e:	eb 19                	jmp    802549 <find_block+0x29>
	{
		if(va==point->sva)
  802530:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802533:	8b 40 08             	mov    0x8(%eax),%eax
  802536:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802539:	75 05                	jne    802540 <find_block+0x20>
		   return point;
  80253b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80253e:	eb 36                	jmp    802576 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802540:	8b 45 08             	mov    0x8(%ebp),%eax
  802543:	8b 40 08             	mov    0x8(%eax),%eax
  802546:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802549:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80254d:	74 07                	je     802556 <find_block+0x36>
  80254f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802552:	8b 00                	mov    (%eax),%eax
  802554:	eb 05                	jmp    80255b <find_block+0x3b>
  802556:	b8 00 00 00 00       	mov    $0x0,%eax
  80255b:	8b 55 08             	mov    0x8(%ebp),%edx
  80255e:	89 42 08             	mov    %eax,0x8(%edx)
  802561:	8b 45 08             	mov    0x8(%ebp),%eax
  802564:	8b 40 08             	mov    0x8(%eax),%eax
  802567:	85 c0                	test   %eax,%eax
  802569:	75 c5                	jne    802530 <find_block+0x10>
  80256b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80256f:	75 bf                	jne    802530 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802571:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802576:	c9                   	leave  
  802577:	c3                   	ret    

00802578 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802578:	55                   	push   %ebp
  802579:	89 e5                	mov    %esp,%ebp
  80257b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  80257e:	a1 40 50 80 00       	mov    0x805040,%eax
  802583:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802586:	a1 44 50 80 00       	mov    0x805044,%eax
  80258b:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  80258e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802591:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802594:	74 24                	je     8025ba <insert_sorted_allocList+0x42>
  802596:	8b 45 08             	mov    0x8(%ebp),%eax
  802599:	8b 50 08             	mov    0x8(%eax),%edx
  80259c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80259f:	8b 40 08             	mov    0x8(%eax),%eax
  8025a2:	39 c2                	cmp    %eax,%edx
  8025a4:	76 14                	jbe    8025ba <insert_sorted_allocList+0x42>
  8025a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a9:	8b 50 08             	mov    0x8(%eax),%edx
  8025ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025af:	8b 40 08             	mov    0x8(%eax),%eax
  8025b2:	39 c2                	cmp    %eax,%edx
  8025b4:	0f 82 60 01 00 00    	jb     80271a <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  8025ba:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8025be:	75 65                	jne    802625 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  8025c0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8025c4:	75 14                	jne    8025da <insert_sorted_allocList+0x62>
  8025c6:	83 ec 04             	sub    $0x4,%esp
  8025c9:	68 b4 43 80 00       	push   $0x8043b4
  8025ce:	6a 6b                	push   $0x6b
  8025d0:	68 d7 43 80 00       	push   $0x8043d7
  8025d5:	e8 07 e1 ff ff       	call   8006e1 <_panic>
  8025da:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8025e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8025e3:	89 10                	mov    %edx,(%eax)
  8025e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8025e8:	8b 00                	mov    (%eax),%eax
  8025ea:	85 c0                	test   %eax,%eax
  8025ec:	74 0d                	je     8025fb <insert_sorted_allocList+0x83>
  8025ee:	a1 40 50 80 00       	mov    0x805040,%eax
  8025f3:	8b 55 08             	mov    0x8(%ebp),%edx
  8025f6:	89 50 04             	mov    %edx,0x4(%eax)
  8025f9:	eb 08                	jmp    802603 <insert_sorted_allocList+0x8b>
  8025fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8025fe:	a3 44 50 80 00       	mov    %eax,0x805044
  802603:	8b 45 08             	mov    0x8(%ebp),%eax
  802606:	a3 40 50 80 00       	mov    %eax,0x805040
  80260b:	8b 45 08             	mov    0x8(%ebp),%eax
  80260e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802615:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80261a:	40                   	inc    %eax
  80261b:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802620:	e9 dc 01 00 00       	jmp    802801 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802625:	8b 45 08             	mov    0x8(%ebp),%eax
  802628:	8b 50 08             	mov    0x8(%eax),%edx
  80262b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80262e:	8b 40 08             	mov    0x8(%eax),%eax
  802631:	39 c2                	cmp    %eax,%edx
  802633:	77 6c                	ja     8026a1 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802635:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802639:	74 06                	je     802641 <insert_sorted_allocList+0xc9>
  80263b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80263f:	75 14                	jne    802655 <insert_sorted_allocList+0xdd>
  802641:	83 ec 04             	sub    $0x4,%esp
  802644:	68 f0 43 80 00       	push   $0x8043f0
  802649:	6a 6f                	push   $0x6f
  80264b:	68 d7 43 80 00       	push   $0x8043d7
  802650:	e8 8c e0 ff ff       	call   8006e1 <_panic>
  802655:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802658:	8b 50 04             	mov    0x4(%eax),%edx
  80265b:	8b 45 08             	mov    0x8(%ebp),%eax
  80265e:	89 50 04             	mov    %edx,0x4(%eax)
  802661:	8b 45 08             	mov    0x8(%ebp),%eax
  802664:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802667:	89 10                	mov    %edx,(%eax)
  802669:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80266c:	8b 40 04             	mov    0x4(%eax),%eax
  80266f:	85 c0                	test   %eax,%eax
  802671:	74 0d                	je     802680 <insert_sorted_allocList+0x108>
  802673:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802676:	8b 40 04             	mov    0x4(%eax),%eax
  802679:	8b 55 08             	mov    0x8(%ebp),%edx
  80267c:	89 10                	mov    %edx,(%eax)
  80267e:	eb 08                	jmp    802688 <insert_sorted_allocList+0x110>
  802680:	8b 45 08             	mov    0x8(%ebp),%eax
  802683:	a3 40 50 80 00       	mov    %eax,0x805040
  802688:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80268b:	8b 55 08             	mov    0x8(%ebp),%edx
  80268e:	89 50 04             	mov    %edx,0x4(%eax)
  802691:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802696:	40                   	inc    %eax
  802697:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80269c:	e9 60 01 00 00       	jmp    802801 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  8026a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a4:	8b 50 08             	mov    0x8(%eax),%edx
  8026a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026aa:	8b 40 08             	mov    0x8(%eax),%eax
  8026ad:	39 c2                	cmp    %eax,%edx
  8026af:	0f 82 4c 01 00 00    	jb     802801 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8026b5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8026b9:	75 14                	jne    8026cf <insert_sorted_allocList+0x157>
  8026bb:	83 ec 04             	sub    $0x4,%esp
  8026be:	68 28 44 80 00       	push   $0x804428
  8026c3:	6a 73                	push   $0x73
  8026c5:	68 d7 43 80 00       	push   $0x8043d7
  8026ca:	e8 12 e0 ff ff       	call   8006e1 <_panic>
  8026cf:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8026d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8026d8:	89 50 04             	mov    %edx,0x4(%eax)
  8026db:	8b 45 08             	mov    0x8(%ebp),%eax
  8026de:	8b 40 04             	mov    0x4(%eax),%eax
  8026e1:	85 c0                	test   %eax,%eax
  8026e3:	74 0c                	je     8026f1 <insert_sorted_allocList+0x179>
  8026e5:	a1 44 50 80 00       	mov    0x805044,%eax
  8026ea:	8b 55 08             	mov    0x8(%ebp),%edx
  8026ed:	89 10                	mov    %edx,(%eax)
  8026ef:	eb 08                	jmp    8026f9 <insert_sorted_allocList+0x181>
  8026f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f4:	a3 40 50 80 00       	mov    %eax,0x805040
  8026f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8026fc:	a3 44 50 80 00       	mov    %eax,0x805044
  802701:	8b 45 08             	mov    0x8(%ebp),%eax
  802704:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80270a:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80270f:	40                   	inc    %eax
  802710:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802715:	e9 e7 00 00 00       	jmp    802801 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  80271a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80271d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802720:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802727:	a1 40 50 80 00       	mov    0x805040,%eax
  80272c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80272f:	e9 9d 00 00 00       	jmp    8027d1 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802734:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802737:	8b 00                	mov    (%eax),%eax
  802739:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  80273c:	8b 45 08             	mov    0x8(%ebp),%eax
  80273f:	8b 50 08             	mov    0x8(%eax),%edx
  802742:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802745:	8b 40 08             	mov    0x8(%eax),%eax
  802748:	39 c2                	cmp    %eax,%edx
  80274a:	76 7d                	jbe    8027c9 <insert_sorted_allocList+0x251>
  80274c:	8b 45 08             	mov    0x8(%ebp),%eax
  80274f:	8b 50 08             	mov    0x8(%eax),%edx
  802752:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802755:	8b 40 08             	mov    0x8(%eax),%eax
  802758:	39 c2                	cmp    %eax,%edx
  80275a:	73 6d                	jae    8027c9 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  80275c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802760:	74 06                	je     802768 <insert_sorted_allocList+0x1f0>
  802762:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802766:	75 14                	jne    80277c <insert_sorted_allocList+0x204>
  802768:	83 ec 04             	sub    $0x4,%esp
  80276b:	68 4c 44 80 00       	push   $0x80444c
  802770:	6a 7f                	push   $0x7f
  802772:	68 d7 43 80 00       	push   $0x8043d7
  802777:	e8 65 df ff ff       	call   8006e1 <_panic>
  80277c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277f:	8b 10                	mov    (%eax),%edx
  802781:	8b 45 08             	mov    0x8(%ebp),%eax
  802784:	89 10                	mov    %edx,(%eax)
  802786:	8b 45 08             	mov    0x8(%ebp),%eax
  802789:	8b 00                	mov    (%eax),%eax
  80278b:	85 c0                	test   %eax,%eax
  80278d:	74 0b                	je     80279a <insert_sorted_allocList+0x222>
  80278f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802792:	8b 00                	mov    (%eax),%eax
  802794:	8b 55 08             	mov    0x8(%ebp),%edx
  802797:	89 50 04             	mov    %edx,0x4(%eax)
  80279a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279d:	8b 55 08             	mov    0x8(%ebp),%edx
  8027a0:	89 10                	mov    %edx,(%eax)
  8027a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027a8:	89 50 04             	mov    %edx,0x4(%eax)
  8027ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ae:	8b 00                	mov    (%eax),%eax
  8027b0:	85 c0                	test   %eax,%eax
  8027b2:	75 08                	jne    8027bc <insert_sorted_allocList+0x244>
  8027b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8027b7:	a3 44 50 80 00       	mov    %eax,0x805044
  8027bc:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8027c1:	40                   	inc    %eax
  8027c2:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  8027c7:	eb 39                	jmp    802802 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8027c9:	a1 48 50 80 00       	mov    0x805048,%eax
  8027ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027d1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027d5:	74 07                	je     8027de <insert_sorted_allocList+0x266>
  8027d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027da:	8b 00                	mov    (%eax),%eax
  8027dc:	eb 05                	jmp    8027e3 <insert_sorted_allocList+0x26b>
  8027de:	b8 00 00 00 00       	mov    $0x0,%eax
  8027e3:	a3 48 50 80 00       	mov    %eax,0x805048
  8027e8:	a1 48 50 80 00       	mov    0x805048,%eax
  8027ed:	85 c0                	test   %eax,%eax
  8027ef:	0f 85 3f ff ff ff    	jne    802734 <insert_sorted_allocList+0x1bc>
  8027f5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027f9:	0f 85 35 ff ff ff    	jne    802734 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8027ff:	eb 01                	jmp    802802 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802801:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802802:	90                   	nop
  802803:	c9                   	leave  
  802804:	c3                   	ret    

00802805 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802805:	55                   	push   %ebp
  802806:	89 e5                	mov    %esp,%ebp
  802808:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  80280b:	a1 38 51 80 00       	mov    0x805138,%eax
  802810:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802813:	e9 85 01 00 00       	jmp    80299d <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802818:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281b:	8b 40 0c             	mov    0xc(%eax),%eax
  80281e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802821:	0f 82 6e 01 00 00    	jb     802995 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802827:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282a:	8b 40 0c             	mov    0xc(%eax),%eax
  80282d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802830:	0f 85 8a 00 00 00    	jne    8028c0 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802836:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80283a:	75 17                	jne    802853 <alloc_block_FF+0x4e>
  80283c:	83 ec 04             	sub    $0x4,%esp
  80283f:	68 80 44 80 00       	push   $0x804480
  802844:	68 93 00 00 00       	push   $0x93
  802849:	68 d7 43 80 00       	push   $0x8043d7
  80284e:	e8 8e de ff ff       	call   8006e1 <_panic>
  802853:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802856:	8b 00                	mov    (%eax),%eax
  802858:	85 c0                	test   %eax,%eax
  80285a:	74 10                	je     80286c <alloc_block_FF+0x67>
  80285c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285f:	8b 00                	mov    (%eax),%eax
  802861:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802864:	8b 52 04             	mov    0x4(%edx),%edx
  802867:	89 50 04             	mov    %edx,0x4(%eax)
  80286a:	eb 0b                	jmp    802877 <alloc_block_FF+0x72>
  80286c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286f:	8b 40 04             	mov    0x4(%eax),%eax
  802872:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802877:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287a:	8b 40 04             	mov    0x4(%eax),%eax
  80287d:	85 c0                	test   %eax,%eax
  80287f:	74 0f                	je     802890 <alloc_block_FF+0x8b>
  802881:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802884:	8b 40 04             	mov    0x4(%eax),%eax
  802887:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80288a:	8b 12                	mov    (%edx),%edx
  80288c:	89 10                	mov    %edx,(%eax)
  80288e:	eb 0a                	jmp    80289a <alloc_block_FF+0x95>
  802890:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802893:	8b 00                	mov    (%eax),%eax
  802895:	a3 38 51 80 00       	mov    %eax,0x805138
  80289a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028ad:	a1 44 51 80 00       	mov    0x805144,%eax
  8028b2:	48                   	dec    %eax
  8028b3:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  8028b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028bb:	e9 10 01 00 00       	jmp    8029d0 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  8028c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c3:	8b 40 0c             	mov    0xc(%eax),%eax
  8028c6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028c9:	0f 86 c6 00 00 00    	jbe    802995 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8028cf:	a1 48 51 80 00       	mov    0x805148,%eax
  8028d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  8028d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028da:	8b 50 08             	mov    0x8(%eax),%edx
  8028dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028e0:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  8028e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028e6:	8b 55 08             	mov    0x8(%ebp),%edx
  8028e9:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8028ec:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8028f0:	75 17                	jne    802909 <alloc_block_FF+0x104>
  8028f2:	83 ec 04             	sub    $0x4,%esp
  8028f5:	68 80 44 80 00       	push   $0x804480
  8028fa:	68 9b 00 00 00       	push   $0x9b
  8028ff:	68 d7 43 80 00       	push   $0x8043d7
  802904:	e8 d8 dd ff ff       	call   8006e1 <_panic>
  802909:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80290c:	8b 00                	mov    (%eax),%eax
  80290e:	85 c0                	test   %eax,%eax
  802910:	74 10                	je     802922 <alloc_block_FF+0x11d>
  802912:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802915:	8b 00                	mov    (%eax),%eax
  802917:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80291a:	8b 52 04             	mov    0x4(%edx),%edx
  80291d:	89 50 04             	mov    %edx,0x4(%eax)
  802920:	eb 0b                	jmp    80292d <alloc_block_FF+0x128>
  802922:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802925:	8b 40 04             	mov    0x4(%eax),%eax
  802928:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80292d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802930:	8b 40 04             	mov    0x4(%eax),%eax
  802933:	85 c0                	test   %eax,%eax
  802935:	74 0f                	je     802946 <alloc_block_FF+0x141>
  802937:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80293a:	8b 40 04             	mov    0x4(%eax),%eax
  80293d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802940:	8b 12                	mov    (%edx),%edx
  802942:	89 10                	mov    %edx,(%eax)
  802944:	eb 0a                	jmp    802950 <alloc_block_FF+0x14b>
  802946:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802949:	8b 00                	mov    (%eax),%eax
  80294b:	a3 48 51 80 00       	mov    %eax,0x805148
  802950:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802953:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802959:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80295c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802963:	a1 54 51 80 00       	mov    0x805154,%eax
  802968:	48                   	dec    %eax
  802969:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  80296e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802971:	8b 50 08             	mov    0x8(%eax),%edx
  802974:	8b 45 08             	mov    0x8(%ebp),%eax
  802977:	01 c2                	add    %eax,%edx
  802979:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297c:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  80297f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802982:	8b 40 0c             	mov    0xc(%eax),%eax
  802985:	2b 45 08             	sub    0x8(%ebp),%eax
  802988:	89 c2                	mov    %eax,%edx
  80298a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298d:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802990:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802993:	eb 3b                	jmp    8029d0 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802995:	a1 40 51 80 00       	mov    0x805140,%eax
  80299a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80299d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029a1:	74 07                	je     8029aa <alloc_block_FF+0x1a5>
  8029a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a6:	8b 00                	mov    (%eax),%eax
  8029a8:	eb 05                	jmp    8029af <alloc_block_FF+0x1aa>
  8029aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8029af:	a3 40 51 80 00       	mov    %eax,0x805140
  8029b4:	a1 40 51 80 00       	mov    0x805140,%eax
  8029b9:	85 c0                	test   %eax,%eax
  8029bb:	0f 85 57 fe ff ff    	jne    802818 <alloc_block_FF+0x13>
  8029c1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029c5:	0f 85 4d fe ff ff    	jne    802818 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  8029cb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029d0:	c9                   	leave  
  8029d1:	c3                   	ret    

008029d2 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8029d2:	55                   	push   %ebp
  8029d3:	89 e5                	mov    %esp,%ebp
  8029d5:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  8029d8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8029df:	a1 38 51 80 00       	mov    0x805138,%eax
  8029e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029e7:	e9 df 00 00 00       	jmp    802acb <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  8029ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ef:	8b 40 0c             	mov    0xc(%eax),%eax
  8029f2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029f5:	0f 82 c8 00 00 00    	jb     802ac3 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  8029fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029fe:	8b 40 0c             	mov    0xc(%eax),%eax
  802a01:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a04:	0f 85 8a 00 00 00    	jne    802a94 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802a0a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a0e:	75 17                	jne    802a27 <alloc_block_BF+0x55>
  802a10:	83 ec 04             	sub    $0x4,%esp
  802a13:	68 80 44 80 00       	push   $0x804480
  802a18:	68 b7 00 00 00       	push   $0xb7
  802a1d:	68 d7 43 80 00       	push   $0x8043d7
  802a22:	e8 ba dc ff ff       	call   8006e1 <_panic>
  802a27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2a:	8b 00                	mov    (%eax),%eax
  802a2c:	85 c0                	test   %eax,%eax
  802a2e:	74 10                	je     802a40 <alloc_block_BF+0x6e>
  802a30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a33:	8b 00                	mov    (%eax),%eax
  802a35:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a38:	8b 52 04             	mov    0x4(%edx),%edx
  802a3b:	89 50 04             	mov    %edx,0x4(%eax)
  802a3e:	eb 0b                	jmp    802a4b <alloc_block_BF+0x79>
  802a40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a43:	8b 40 04             	mov    0x4(%eax),%eax
  802a46:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802a4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4e:	8b 40 04             	mov    0x4(%eax),%eax
  802a51:	85 c0                	test   %eax,%eax
  802a53:	74 0f                	je     802a64 <alloc_block_BF+0x92>
  802a55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a58:	8b 40 04             	mov    0x4(%eax),%eax
  802a5b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a5e:	8b 12                	mov    (%edx),%edx
  802a60:	89 10                	mov    %edx,(%eax)
  802a62:	eb 0a                	jmp    802a6e <alloc_block_BF+0x9c>
  802a64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a67:	8b 00                	mov    (%eax),%eax
  802a69:	a3 38 51 80 00       	mov    %eax,0x805138
  802a6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a71:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a81:	a1 44 51 80 00       	mov    0x805144,%eax
  802a86:	48                   	dec    %eax
  802a87:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802a8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8f:	e9 4d 01 00 00       	jmp    802be1 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802a94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a97:	8b 40 0c             	mov    0xc(%eax),%eax
  802a9a:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a9d:	76 24                	jbe    802ac3 <alloc_block_BF+0xf1>
  802a9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa2:	8b 40 0c             	mov    0xc(%eax),%eax
  802aa5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802aa8:	73 19                	jae    802ac3 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802aaa:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802ab1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab4:	8b 40 0c             	mov    0xc(%eax),%eax
  802ab7:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802aba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802abd:	8b 40 08             	mov    0x8(%eax),%eax
  802ac0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802ac3:	a1 40 51 80 00       	mov    0x805140,%eax
  802ac8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802acb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802acf:	74 07                	je     802ad8 <alloc_block_BF+0x106>
  802ad1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad4:	8b 00                	mov    (%eax),%eax
  802ad6:	eb 05                	jmp    802add <alloc_block_BF+0x10b>
  802ad8:	b8 00 00 00 00       	mov    $0x0,%eax
  802add:	a3 40 51 80 00       	mov    %eax,0x805140
  802ae2:	a1 40 51 80 00       	mov    0x805140,%eax
  802ae7:	85 c0                	test   %eax,%eax
  802ae9:	0f 85 fd fe ff ff    	jne    8029ec <alloc_block_BF+0x1a>
  802aef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802af3:	0f 85 f3 fe ff ff    	jne    8029ec <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802af9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802afd:	0f 84 d9 00 00 00    	je     802bdc <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802b03:	a1 48 51 80 00       	mov    0x805148,%eax
  802b08:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802b0b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b0e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b11:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802b14:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b17:	8b 55 08             	mov    0x8(%ebp),%edx
  802b1a:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802b1d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802b21:	75 17                	jne    802b3a <alloc_block_BF+0x168>
  802b23:	83 ec 04             	sub    $0x4,%esp
  802b26:	68 80 44 80 00       	push   $0x804480
  802b2b:	68 c7 00 00 00       	push   $0xc7
  802b30:	68 d7 43 80 00       	push   $0x8043d7
  802b35:	e8 a7 db ff ff       	call   8006e1 <_panic>
  802b3a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b3d:	8b 00                	mov    (%eax),%eax
  802b3f:	85 c0                	test   %eax,%eax
  802b41:	74 10                	je     802b53 <alloc_block_BF+0x181>
  802b43:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b46:	8b 00                	mov    (%eax),%eax
  802b48:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802b4b:	8b 52 04             	mov    0x4(%edx),%edx
  802b4e:	89 50 04             	mov    %edx,0x4(%eax)
  802b51:	eb 0b                	jmp    802b5e <alloc_block_BF+0x18c>
  802b53:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b56:	8b 40 04             	mov    0x4(%eax),%eax
  802b59:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b5e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b61:	8b 40 04             	mov    0x4(%eax),%eax
  802b64:	85 c0                	test   %eax,%eax
  802b66:	74 0f                	je     802b77 <alloc_block_BF+0x1a5>
  802b68:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b6b:	8b 40 04             	mov    0x4(%eax),%eax
  802b6e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802b71:	8b 12                	mov    (%edx),%edx
  802b73:	89 10                	mov    %edx,(%eax)
  802b75:	eb 0a                	jmp    802b81 <alloc_block_BF+0x1af>
  802b77:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b7a:	8b 00                	mov    (%eax),%eax
  802b7c:	a3 48 51 80 00       	mov    %eax,0x805148
  802b81:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b84:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b8a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b8d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b94:	a1 54 51 80 00       	mov    0x805154,%eax
  802b99:	48                   	dec    %eax
  802b9a:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802b9f:	83 ec 08             	sub    $0x8,%esp
  802ba2:	ff 75 ec             	pushl  -0x14(%ebp)
  802ba5:	68 38 51 80 00       	push   $0x805138
  802baa:	e8 71 f9 ff ff       	call   802520 <find_block>
  802baf:	83 c4 10             	add    $0x10,%esp
  802bb2:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802bb5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bb8:	8b 50 08             	mov    0x8(%eax),%edx
  802bbb:	8b 45 08             	mov    0x8(%ebp),%eax
  802bbe:	01 c2                	add    %eax,%edx
  802bc0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bc3:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802bc6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bc9:	8b 40 0c             	mov    0xc(%eax),%eax
  802bcc:	2b 45 08             	sub    0x8(%ebp),%eax
  802bcf:	89 c2                	mov    %eax,%edx
  802bd1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bd4:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802bd7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bda:	eb 05                	jmp    802be1 <alloc_block_BF+0x20f>
	}
	return NULL;
  802bdc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802be1:	c9                   	leave  
  802be2:	c3                   	ret    

00802be3 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802be3:	55                   	push   %ebp
  802be4:	89 e5                	mov    %esp,%ebp
  802be6:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802be9:	a1 28 50 80 00       	mov    0x805028,%eax
  802bee:	85 c0                	test   %eax,%eax
  802bf0:	0f 85 de 01 00 00    	jne    802dd4 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802bf6:	a1 38 51 80 00       	mov    0x805138,%eax
  802bfb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bfe:	e9 9e 01 00 00       	jmp    802da1 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802c03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c06:	8b 40 0c             	mov    0xc(%eax),%eax
  802c09:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c0c:	0f 82 87 01 00 00    	jb     802d99 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802c12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c15:	8b 40 0c             	mov    0xc(%eax),%eax
  802c18:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c1b:	0f 85 95 00 00 00    	jne    802cb6 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802c21:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c25:	75 17                	jne    802c3e <alloc_block_NF+0x5b>
  802c27:	83 ec 04             	sub    $0x4,%esp
  802c2a:	68 80 44 80 00       	push   $0x804480
  802c2f:	68 e0 00 00 00       	push   $0xe0
  802c34:	68 d7 43 80 00       	push   $0x8043d7
  802c39:	e8 a3 da ff ff       	call   8006e1 <_panic>
  802c3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c41:	8b 00                	mov    (%eax),%eax
  802c43:	85 c0                	test   %eax,%eax
  802c45:	74 10                	je     802c57 <alloc_block_NF+0x74>
  802c47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4a:	8b 00                	mov    (%eax),%eax
  802c4c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c4f:	8b 52 04             	mov    0x4(%edx),%edx
  802c52:	89 50 04             	mov    %edx,0x4(%eax)
  802c55:	eb 0b                	jmp    802c62 <alloc_block_NF+0x7f>
  802c57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c5a:	8b 40 04             	mov    0x4(%eax),%eax
  802c5d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c65:	8b 40 04             	mov    0x4(%eax),%eax
  802c68:	85 c0                	test   %eax,%eax
  802c6a:	74 0f                	je     802c7b <alloc_block_NF+0x98>
  802c6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c6f:	8b 40 04             	mov    0x4(%eax),%eax
  802c72:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c75:	8b 12                	mov    (%edx),%edx
  802c77:	89 10                	mov    %edx,(%eax)
  802c79:	eb 0a                	jmp    802c85 <alloc_block_NF+0xa2>
  802c7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c7e:	8b 00                	mov    (%eax),%eax
  802c80:	a3 38 51 80 00       	mov    %eax,0x805138
  802c85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c88:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c91:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c98:	a1 44 51 80 00       	mov    0x805144,%eax
  802c9d:	48                   	dec    %eax
  802c9e:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802ca3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca6:	8b 40 08             	mov    0x8(%eax),%eax
  802ca9:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  802cae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb1:	e9 f8 04 00 00       	jmp    8031ae <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802cb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb9:	8b 40 0c             	mov    0xc(%eax),%eax
  802cbc:	3b 45 08             	cmp    0x8(%ebp),%eax
  802cbf:	0f 86 d4 00 00 00    	jbe    802d99 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802cc5:	a1 48 51 80 00       	mov    0x805148,%eax
  802cca:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802ccd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd0:	8b 50 08             	mov    0x8(%eax),%edx
  802cd3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cd6:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802cd9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cdc:	8b 55 08             	mov    0x8(%ebp),%edx
  802cdf:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802ce2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ce6:	75 17                	jne    802cff <alloc_block_NF+0x11c>
  802ce8:	83 ec 04             	sub    $0x4,%esp
  802ceb:	68 80 44 80 00       	push   $0x804480
  802cf0:	68 e9 00 00 00       	push   $0xe9
  802cf5:	68 d7 43 80 00       	push   $0x8043d7
  802cfa:	e8 e2 d9 ff ff       	call   8006e1 <_panic>
  802cff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d02:	8b 00                	mov    (%eax),%eax
  802d04:	85 c0                	test   %eax,%eax
  802d06:	74 10                	je     802d18 <alloc_block_NF+0x135>
  802d08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d0b:	8b 00                	mov    (%eax),%eax
  802d0d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d10:	8b 52 04             	mov    0x4(%edx),%edx
  802d13:	89 50 04             	mov    %edx,0x4(%eax)
  802d16:	eb 0b                	jmp    802d23 <alloc_block_NF+0x140>
  802d18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d1b:	8b 40 04             	mov    0x4(%eax),%eax
  802d1e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d23:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d26:	8b 40 04             	mov    0x4(%eax),%eax
  802d29:	85 c0                	test   %eax,%eax
  802d2b:	74 0f                	je     802d3c <alloc_block_NF+0x159>
  802d2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d30:	8b 40 04             	mov    0x4(%eax),%eax
  802d33:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d36:	8b 12                	mov    (%edx),%edx
  802d38:	89 10                	mov    %edx,(%eax)
  802d3a:	eb 0a                	jmp    802d46 <alloc_block_NF+0x163>
  802d3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d3f:	8b 00                	mov    (%eax),%eax
  802d41:	a3 48 51 80 00       	mov    %eax,0x805148
  802d46:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d49:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d52:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d59:	a1 54 51 80 00       	mov    0x805154,%eax
  802d5e:	48                   	dec    %eax
  802d5f:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802d64:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d67:	8b 40 08             	mov    0x8(%eax),%eax
  802d6a:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802d6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d72:	8b 50 08             	mov    0x8(%eax),%edx
  802d75:	8b 45 08             	mov    0x8(%ebp),%eax
  802d78:	01 c2                	add    %eax,%edx
  802d7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d7d:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802d80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d83:	8b 40 0c             	mov    0xc(%eax),%eax
  802d86:	2b 45 08             	sub    0x8(%ebp),%eax
  802d89:	89 c2                	mov    %eax,%edx
  802d8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d8e:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802d91:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d94:	e9 15 04 00 00       	jmp    8031ae <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802d99:	a1 40 51 80 00       	mov    0x805140,%eax
  802d9e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802da1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802da5:	74 07                	je     802dae <alloc_block_NF+0x1cb>
  802da7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802daa:	8b 00                	mov    (%eax),%eax
  802dac:	eb 05                	jmp    802db3 <alloc_block_NF+0x1d0>
  802dae:	b8 00 00 00 00       	mov    $0x0,%eax
  802db3:	a3 40 51 80 00       	mov    %eax,0x805140
  802db8:	a1 40 51 80 00       	mov    0x805140,%eax
  802dbd:	85 c0                	test   %eax,%eax
  802dbf:	0f 85 3e fe ff ff    	jne    802c03 <alloc_block_NF+0x20>
  802dc5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dc9:	0f 85 34 fe ff ff    	jne    802c03 <alloc_block_NF+0x20>
  802dcf:	e9 d5 03 00 00       	jmp    8031a9 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802dd4:	a1 38 51 80 00       	mov    0x805138,%eax
  802dd9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ddc:	e9 b1 01 00 00       	jmp    802f92 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802de1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de4:	8b 50 08             	mov    0x8(%eax),%edx
  802de7:	a1 28 50 80 00       	mov    0x805028,%eax
  802dec:	39 c2                	cmp    %eax,%edx
  802dee:	0f 82 96 01 00 00    	jb     802f8a <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802df4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df7:	8b 40 0c             	mov    0xc(%eax),%eax
  802dfa:	3b 45 08             	cmp    0x8(%ebp),%eax
  802dfd:	0f 82 87 01 00 00    	jb     802f8a <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802e03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e06:	8b 40 0c             	mov    0xc(%eax),%eax
  802e09:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e0c:	0f 85 95 00 00 00    	jne    802ea7 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802e12:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e16:	75 17                	jne    802e2f <alloc_block_NF+0x24c>
  802e18:	83 ec 04             	sub    $0x4,%esp
  802e1b:	68 80 44 80 00       	push   $0x804480
  802e20:	68 fc 00 00 00       	push   $0xfc
  802e25:	68 d7 43 80 00       	push   $0x8043d7
  802e2a:	e8 b2 d8 ff ff       	call   8006e1 <_panic>
  802e2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e32:	8b 00                	mov    (%eax),%eax
  802e34:	85 c0                	test   %eax,%eax
  802e36:	74 10                	je     802e48 <alloc_block_NF+0x265>
  802e38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e3b:	8b 00                	mov    (%eax),%eax
  802e3d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e40:	8b 52 04             	mov    0x4(%edx),%edx
  802e43:	89 50 04             	mov    %edx,0x4(%eax)
  802e46:	eb 0b                	jmp    802e53 <alloc_block_NF+0x270>
  802e48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e4b:	8b 40 04             	mov    0x4(%eax),%eax
  802e4e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e56:	8b 40 04             	mov    0x4(%eax),%eax
  802e59:	85 c0                	test   %eax,%eax
  802e5b:	74 0f                	je     802e6c <alloc_block_NF+0x289>
  802e5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e60:	8b 40 04             	mov    0x4(%eax),%eax
  802e63:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e66:	8b 12                	mov    (%edx),%edx
  802e68:	89 10                	mov    %edx,(%eax)
  802e6a:	eb 0a                	jmp    802e76 <alloc_block_NF+0x293>
  802e6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e6f:	8b 00                	mov    (%eax),%eax
  802e71:	a3 38 51 80 00       	mov    %eax,0x805138
  802e76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e79:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e82:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e89:	a1 44 51 80 00       	mov    0x805144,%eax
  802e8e:	48                   	dec    %eax
  802e8f:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802e94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e97:	8b 40 08             	mov    0x8(%eax),%eax
  802e9a:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802e9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea2:	e9 07 03 00 00       	jmp    8031ae <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802ea7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eaa:	8b 40 0c             	mov    0xc(%eax),%eax
  802ead:	3b 45 08             	cmp    0x8(%ebp),%eax
  802eb0:	0f 86 d4 00 00 00    	jbe    802f8a <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802eb6:	a1 48 51 80 00       	mov    0x805148,%eax
  802ebb:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802ebe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec1:	8b 50 08             	mov    0x8(%eax),%edx
  802ec4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ec7:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802eca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ecd:	8b 55 08             	mov    0x8(%ebp),%edx
  802ed0:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802ed3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802ed7:	75 17                	jne    802ef0 <alloc_block_NF+0x30d>
  802ed9:	83 ec 04             	sub    $0x4,%esp
  802edc:	68 80 44 80 00       	push   $0x804480
  802ee1:	68 04 01 00 00       	push   $0x104
  802ee6:	68 d7 43 80 00       	push   $0x8043d7
  802eeb:	e8 f1 d7 ff ff       	call   8006e1 <_panic>
  802ef0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ef3:	8b 00                	mov    (%eax),%eax
  802ef5:	85 c0                	test   %eax,%eax
  802ef7:	74 10                	je     802f09 <alloc_block_NF+0x326>
  802ef9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802efc:	8b 00                	mov    (%eax),%eax
  802efe:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f01:	8b 52 04             	mov    0x4(%edx),%edx
  802f04:	89 50 04             	mov    %edx,0x4(%eax)
  802f07:	eb 0b                	jmp    802f14 <alloc_block_NF+0x331>
  802f09:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f0c:	8b 40 04             	mov    0x4(%eax),%eax
  802f0f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f14:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f17:	8b 40 04             	mov    0x4(%eax),%eax
  802f1a:	85 c0                	test   %eax,%eax
  802f1c:	74 0f                	je     802f2d <alloc_block_NF+0x34a>
  802f1e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f21:	8b 40 04             	mov    0x4(%eax),%eax
  802f24:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f27:	8b 12                	mov    (%edx),%edx
  802f29:	89 10                	mov    %edx,(%eax)
  802f2b:	eb 0a                	jmp    802f37 <alloc_block_NF+0x354>
  802f2d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f30:	8b 00                	mov    (%eax),%eax
  802f32:	a3 48 51 80 00       	mov    %eax,0x805148
  802f37:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f3a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f40:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f43:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f4a:	a1 54 51 80 00       	mov    0x805154,%eax
  802f4f:	48                   	dec    %eax
  802f50:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802f55:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f58:	8b 40 08             	mov    0x8(%eax),%eax
  802f5b:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802f60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f63:	8b 50 08             	mov    0x8(%eax),%edx
  802f66:	8b 45 08             	mov    0x8(%ebp),%eax
  802f69:	01 c2                	add    %eax,%edx
  802f6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f6e:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802f71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f74:	8b 40 0c             	mov    0xc(%eax),%eax
  802f77:	2b 45 08             	sub    0x8(%ebp),%eax
  802f7a:	89 c2                	mov    %eax,%edx
  802f7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f7f:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802f82:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f85:	e9 24 02 00 00       	jmp    8031ae <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802f8a:	a1 40 51 80 00       	mov    0x805140,%eax
  802f8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f92:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f96:	74 07                	je     802f9f <alloc_block_NF+0x3bc>
  802f98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f9b:	8b 00                	mov    (%eax),%eax
  802f9d:	eb 05                	jmp    802fa4 <alloc_block_NF+0x3c1>
  802f9f:	b8 00 00 00 00       	mov    $0x0,%eax
  802fa4:	a3 40 51 80 00       	mov    %eax,0x805140
  802fa9:	a1 40 51 80 00       	mov    0x805140,%eax
  802fae:	85 c0                	test   %eax,%eax
  802fb0:	0f 85 2b fe ff ff    	jne    802de1 <alloc_block_NF+0x1fe>
  802fb6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fba:	0f 85 21 fe ff ff    	jne    802de1 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802fc0:	a1 38 51 80 00       	mov    0x805138,%eax
  802fc5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fc8:	e9 ae 01 00 00       	jmp    80317b <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802fcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd0:	8b 50 08             	mov    0x8(%eax),%edx
  802fd3:	a1 28 50 80 00       	mov    0x805028,%eax
  802fd8:	39 c2                	cmp    %eax,%edx
  802fda:	0f 83 93 01 00 00    	jae    803173 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802fe0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe3:	8b 40 0c             	mov    0xc(%eax),%eax
  802fe6:	3b 45 08             	cmp    0x8(%ebp),%eax
  802fe9:	0f 82 84 01 00 00    	jb     803173 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802fef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff2:	8b 40 0c             	mov    0xc(%eax),%eax
  802ff5:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ff8:	0f 85 95 00 00 00    	jne    803093 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802ffe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803002:	75 17                	jne    80301b <alloc_block_NF+0x438>
  803004:	83 ec 04             	sub    $0x4,%esp
  803007:	68 80 44 80 00       	push   $0x804480
  80300c:	68 14 01 00 00       	push   $0x114
  803011:	68 d7 43 80 00       	push   $0x8043d7
  803016:	e8 c6 d6 ff ff       	call   8006e1 <_panic>
  80301b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80301e:	8b 00                	mov    (%eax),%eax
  803020:	85 c0                	test   %eax,%eax
  803022:	74 10                	je     803034 <alloc_block_NF+0x451>
  803024:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803027:	8b 00                	mov    (%eax),%eax
  803029:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80302c:	8b 52 04             	mov    0x4(%edx),%edx
  80302f:	89 50 04             	mov    %edx,0x4(%eax)
  803032:	eb 0b                	jmp    80303f <alloc_block_NF+0x45c>
  803034:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803037:	8b 40 04             	mov    0x4(%eax),%eax
  80303a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80303f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803042:	8b 40 04             	mov    0x4(%eax),%eax
  803045:	85 c0                	test   %eax,%eax
  803047:	74 0f                	je     803058 <alloc_block_NF+0x475>
  803049:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80304c:	8b 40 04             	mov    0x4(%eax),%eax
  80304f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803052:	8b 12                	mov    (%edx),%edx
  803054:	89 10                	mov    %edx,(%eax)
  803056:	eb 0a                	jmp    803062 <alloc_block_NF+0x47f>
  803058:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80305b:	8b 00                	mov    (%eax),%eax
  80305d:	a3 38 51 80 00       	mov    %eax,0x805138
  803062:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803065:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80306b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80306e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803075:	a1 44 51 80 00       	mov    0x805144,%eax
  80307a:	48                   	dec    %eax
  80307b:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  803080:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803083:	8b 40 08             	mov    0x8(%eax),%eax
  803086:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  80308b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80308e:	e9 1b 01 00 00       	jmp    8031ae <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  803093:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803096:	8b 40 0c             	mov    0xc(%eax),%eax
  803099:	3b 45 08             	cmp    0x8(%ebp),%eax
  80309c:	0f 86 d1 00 00 00    	jbe    803173 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8030a2:	a1 48 51 80 00       	mov    0x805148,%eax
  8030a7:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  8030aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ad:	8b 50 08             	mov    0x8(%eax),%edx
  8030b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030b3:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8030b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030b9:	8b 55 08             	mov    0x8(%ebp),%edx
  8030bc:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8030bf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8030c3:	75 17                	jne    8030dc <alloc_block_NF+0x4f9>
  8030c5:	83 ec 04             	sub    $0x4,%esp
  8030c8:	68 80 44 80 00       	push   $0x804480
  8030cd:	68 1c 01 00 00       	push   $0x11c
  8030d2:	68 d7 43 80 00       	push   $0x8043d7
  8030d7:	e8 05 d6 ff ff       	call   8006e1 <_panic>
  8030dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030df:	8b 00                	mov    (%eax),%eax
  8030e1:	85 c0                	test   %eax,%eax
  8030e3:	74 10                	je     8030f5 <alloc_block_NF+0x512>
  8030e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030e8:	8b 00                	mov    (%eax),%eax
  8030ea:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8030ed:	8b 52 04             	mov    0x4(%edx),%edx
  8030f0:	89 50 04             	mov    %edx,0x4(%eax)
  8030f3:	eb 0b                	jmp    803100 <alloc_block_NF+0x51d>
  8030f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030f8:	8b 40 04             	mov    0x4(%eax),%eax
  8030fb:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803100:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803103:	8b 40 04             	mov    0x4(%eax),%eax
  803106:	85 c0                	test   %eax,%eax
  803108:	74 0f                	je     803119 <alloc_block_NF+0x536>
  80310a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80310d:	8b 40 04             	mov    0x4(%eax),%eax
  803110:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803113:	8b 12                	mov    (%edx),%edx
  803115:	89 10                	mov    %edx,(%eax)
  803117:	eb 0a                	jmp    803123 <alloc_block_NF+0x540>
  803119:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80311c:	8b 00                	mov    (%eax),%eax
  80311e:	a3 48 51 80 00       	mov    %eax,0x805148
  803123:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803126:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80312c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80312f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803136:	a1 54 51 80 00       	mov    0x805154,%eax
  80313b:	48                   	dec    %eax
  80313c:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  803141:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803144:	8b 40 08             	mov    0x8(%eax),%eax
  803147:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  80314c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80314f:	8b 50 08             	mov    0x8(%eax),%edx
  803152:	8b 45 08             	mov    0x8(%ebp),%eax
  803155:	01 c2                	add    %eax,%edx
  803157:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80315a:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  80315d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803160:	8b 40 0c             	mov    0xc(%eax),%eax
  803163:	2b 45 08             	sub    0x8(%ebp),%eax
  803166:	89 c2                	mov    %eax,%edx
  803168:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80316b:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  80316e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803171:	eb 3b                	jmp    8031ae <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  803173:	a1 40 51 80 00       	mov    0x805140,%eax
  803178:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80317b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80317f:	74 07                	je     803188 <alloc_block_NF+0x5a5>
  803181:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803184:	8b 00                	mov    (%eax),%eax
  803186:	eb 05                	jmp    80318d <alloc_block_NF+0x5aa>
  803188:	b8 00 00 00 00       	mov    $0x0,%eax
  80318d:	a3 40 51 80 00       	mov    %eax,0x805140
  803192:	a1 40 51 80 00       	mov    0x805140,%eax
  803197:	85 c0                	test   %eax,%eax
  803199:	0f 85 2e fe ff ff    	jne    802fcd <alloc_block_NF+0x3ea>
  80319f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031a3:	0f 85 24 fe ff ff    	jne    802fcd <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  8031a9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8031ae:	c9                   	leave  
  8031af:	c3                   	ret    

008031b0 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  8031b0:	55                   	push   %ebp
  8031b1:	89 e5                	mov    %esp,%ebp
  8031b3:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  8031b6:	a1 38 51 80 00       	mov    0x805138,%eax
  8031bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  8031be:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8031c3:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  8031c6:	a1 38 51 80 00       	mov    0x805138,%eax
  8031cb:	85 c0                	test   %eax,%eax
  8031cd:	74 14                	je     8031e3 <insert_sorted_with_merge_freeList+0x33>
  8031cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d2:	8b 50 08             	mov    0x8(%eax),%edx
  8031d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031d8:	8b 40 08             	mov    0x8(%eax),%eax
  8031db:	39 c2                	cmp    %eax,%edx
  8031dd:	0f 87 9b 01 00 00    	ja     80337e <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  8031e3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031e7:	75 17                	jne    803200 <insert_sorted_with_merge_freeList+0x50>
  8031e9:	83 ec 04             	sub    $0x4,%esp
  8031ec:	68 b4 43 80 00       	push   $0x8043b4
  8031f1:	68 38 01 00 00       	push   $0x138
  8031f6:	68 d7 43 80 00       	push   $0x8043d7
  8031fb:	e8 e1 d4 ff ff       	call   8006e1 <_panic>
  803200:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803206:	8b 45 08             	mov    0x8(%ebp),%eax
  803209:	89 10                	mov    %edx,(%eax)
  80320b:	8b 45 08             	mov    0x8(%ebp),%eax
  80320e:	8b 00                	mov    (%eax),%eax
  803210:	85 c0                	test   %eax,%eax
  803212:	74 0d                	je     803221 <insert_sorted_with_merge_freeList+0x71>
  803214:	a1 38 51 80 00       	mov    0x805138,%eax
  803219:	8b 55 08             	mov    0x8(%ebp),%edx
  80321c:	89 50 04             	mov    %edx,0x4(%eax)
  80321f:	eb 08                	jmp    803229 <insert_sorted_with_merge_freeList+0x79>
  803221:	8b 45 08             	mov    0x8(%ebp),%eax
  803224:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803229:	8b 45 08             	mov    0x8(%ebp),%eax
  80322c:	a3 38 51 80 00       	mov    %eax,0x805138
  803231:	8b 45 08             	mov    0x8(%ebp),%eax
  803234:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80323b:	a1 44 51 80 00       	mov    0x805144,%eax
  803240:	40                   	inc    %eax
  803241:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803246:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80324a:	0f 84 a8 06 00 00    	je     8038f8 <insert_sorted_with_merge_freeList+0x748>
  803250:	8b 45 08             	mov    0x8(%ebp),%eax
  803253:	8b 50 08             	mov    0x8(%eax),%edx
  803256:	8b 45 08             	mov    0x8(%ebp),%eax
  803259:	8b 40 0c             	mov    0xc(%eax),%eax
  80325c:	01 c2                	add    %eax,%edx
  80325e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803261:	8b 40 08             	mov    0x8(%eax),%eax
  803264:	39 c2                	cmp    %eax,%edx
  803266:	0f 85 8c 06 00 00    	jne    8038f8 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  80326c:	8b 45 08             	mov    0x8(%ebp),%eax
  80326f:	8b 50 0c             	mov    0xc(%eax),%edx
  803272:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803275:	8b 40 0c             	mov    0xc(%eax),%eax
  803278:	01 c2                	add    %eax,%edx
  80327a:	8b 45 08             	mov    0x8(%ebp),%eax
  80327d:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  803280:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803284:	75 17                	jne    80329d <insert_sorted_with_merge_freeList+0xed>
  803286:	83 ec 04             	sub    $0x4,%esp
  803289:	68 80 44 80 00       	push   $0x804480
  80328e:	68 3c 01 00 00       	push   $0x13c
  803293:	68 d7 43 80 00       	push   $0x8043d7
  803298:	e8 44 d4 ff ff       	call   8006e1 <_panic>
  80329d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032a0:	8b 00                	mov    (%eax),%eax
  8032a2:	85 c0                	test   %eax,%eax
  8032a4:	74 10                	je     8032b6 <insert_sorted_with_merge_freeList+0x106>
  8032a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032a9:	8b 00                	mov    (%eax),%eax
  8032ab:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8032ae:	8b 52 04             	mov    0x4(%edx),%edx
  8032b1:	89 50 04             	mov    %edx,0x4(%eax)
  8032b4:	eb 0b                	jmp    8032c1 <insert_sorted_with_merge_freeList+0x111>
  8032b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032b9:	8b 40 04             	mov    0x4(%eax),%eax
  8032bc:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8032c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032c4:	8b 40 04             	mov    0x4(%eax),%eax
  8032c7:	85 c0                	test   %eax,%eax
  8032c9:	74 0f                	je     8032da <insert_sorted_with_merge_freeList+0x12a>
  8032cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032ce:	8b 40 04             	mov    0x4(%eax),%eax
  8032d1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8032d4:	8b 12                	mov    (%edx),%edx
  8032d6:	89 10                	mov    %edx,(%eax)
  8032d8:	eb 0a                	jmp    8032e4 <insert_sorted_with_merge_freeList+0x134>
  8032da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032dd:	8b 00                	mov    (%eax),%eax
  8032df:	a3 38 51 80 00       	mov    %eax,0x805138
  8032e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032e7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032f0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032f7:	a1 44 51 80 00       	mov    0x805144,%eax
  8032fc:	48                   	dec    %eax
  8032fd:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  803302:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803305:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  80330c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80330f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  803316:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80331a:	75 17                	jne    803333 <insert_sorted_with_merge_freeList+0x183>
  80331c:	83 ec 04             	sub    $0x4,%esp
  80331f:	68 b4 43 80 00       	push   $0x8043b4
  803324:	68 3f 01 00 00       	push   $0x13f
  803329:	68 d7 43 80 00       	push   $0x8043d7
  80332e:	e8 ae d3 ff ff       	call   8006e1 <_panic>
  803333:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803339:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80333c:	89 10                	mov    %edx,(%eax)
  80333e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803341:	8b 00                	mov    (%eax),%eax
  803343:	85 c0                	test   %eax,%eax
  803345:	74 0d                	je     803354 <insert_sorted_with_merge_freeList+0x1a4>
  803347:	a1 48 51 80 00       	mov    0x805148,%eax
  80334c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80334f:	89 50 04             	mov    %edx,0x4(%eax)
  803352:	eb 08                	jmp    80335c <insert_sorted_with_merge_freeList+0x1ac>
  803354:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803357:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80335c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80335f:	a3 48 51 80 00       	mov    %eax,0x805148
  803364:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803367:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80336e:	a1 54 51 80 00       	mov    0x805154,%eax
  803373:	40                   	inc    %eax
  803374:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803379:	e9 7a 05 00 00       	jmp    8038f8 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  80337e:	8b 45 08             	mov    0x8(%ebp),%eax
  803381:	8b 50 08             	mov    0x8(%eax),%edx
  803384:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803387:	8b 40 08             	mov    0x8(%eax),%eax
  80338a:	39 c2                	cmp    %eax,%edx
  80338c:	0f 82 14 01 00 00    	jb     8034a6 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  803392:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803395:	8b 50 08             	mov    0x8(%eax),%edx
  803398:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80339b:	8b 40 0c             	mov    0xc(%eax),%eax
  80339e:	01 c2                	add    %eax,%edx
  8033a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a3:	8b 40 08             	mov    0x8(%eax),%eax
  8033a6:	39 c2                	cmp    %eax,%edx
  8033a8:	0f 85 90 00 00 00    	jne    80343e <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  8033ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033b1:	8b 50 0c             	mov    0xc(%eax),%edx
  8033b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b7:	8b 40 0c             	mov    0xc(%eax),%eax
  8033ba:	01 c2                	add    %eax,%edx
  8033bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033bf:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  8033c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  8033cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8033cf:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8033d6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033da:	75 17                	jne    8033f3 <insert_sorted_with_merge_freeList+0x243>
  8033dc:	83 ec 04             	sub    $0x4,%esp
  8033df:	68 b4 43 80 00       	push   $0x8043b4
  8033e4:	68 49 01 00 00       	push   $0x149
  8033e9:	68 d7 43 80 00       	push   $0x8043d7
  8033ee:	e8 ee d2 ff ff       	call   8006e1 <_panic>
  8033f3:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8033f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8033fc:	89 10                	mov    %edx,(%eax)
  8033fe:	8b 45 08             	mov    0x8(%ebp),%eax
  803401:	8b 00                	mov    (%eax),%eax
  803403:	85 c0                	test   %eax,%eax
  803405:	74 0d                	je     803414 <insert_sorted_with_merge_freeList+0x264>
  803407:	a1 48 51 80 00       	mov    0x805148,%eax
  80340c:	8b 55 08             	mov    0x8(%ebp),%edx
  80340f:	89 50 04             	mov    %edx,0x4(%eax)
  803412:	eb 08                	jmp    80341c <insert_sorted_with_merge_freeList+0x26c>
  803414:	8b 45 08             	mov    0x8(%ebp),%eax
  803417:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80341c:	8b 45 08             	mov    0x8(%ebp),%eax
  80341f:	a3 48 51 80 00       	mov    %eax,0x805148
  803424:	8b 45 08             	mov    0x8(%ebp),%eax
  803427:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80342e:	a1 54 51 80 00       	mov    0x805154,%eax
  803433:	40                   	inc    %eax
  803434:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803439:	e9 bb 04 00 00       	jmp    8038f9 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  80343e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803442:	75 17                	jne    80345b <insert_sorted_with_merge_freeList+0x2ab>
  803444:	83 ec 04             	sub    $0x4,%esp
  803447:	68 28 44 80 00       	push   $0x804428
  80344c:	68 4c 01 00 00       	push   $0x14c
  803451:	68 d7 43 80 00       	push   $0x8043d7
  803456:	e8 86 d2 ff ff       	call   8006e1 <_panic>
  80345b:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803461:	8b 45 08             	mov    0x8(%ebp),%eax
  803464:	89 50 04             	mov    %edx,0x4(%eax)
  803467:	8b 45 08             	mov    0x8(%ebp),%eax
  80346a:	8b 40 04             	mov    0x4(%eax),%eax
  80346d:	85 c0                	test   %eax,%eax
  80346f:	74 0c                	je     80347d <insert_sorted_with_merge_freeList+0x2cd>
  803471:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803476:	8b 55 08             	mov    0x8(%ebp),%edx
  803479:	89 10                	mov    %edx,(%eax)
  80347b:	eb 08                	jmp    803485 <insert_sorted_with_merge_freeList+0x2d5>
  80347d:	8b 45 08             	mov    0x8(%ebp),%eax
  803480:	a3 38 51 80 00       	mov    %eax,0x805138
  803485:	8b 45 08             	mov    0x8(%ebp),%eax
  803488:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80348d:	8b 45 08             	mov    0x8(%ebp),%eax
  803490:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803496:	a1 44 51 80 00       	mov    0x805144,%eax
  80349b:	40                   	inc    %eax
  80349c:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8034a1:	e9 53 04 00 00       	jmp    8038f9 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8034a6:	a1 38 51 80 00       	mov    0x805138,%eax
  8034ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8034ae:	e9 15 04 00 00       	jmp    8038c8 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  8034b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034b6:	8b 00                	mov    (%eax),%eax
  8034b8:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  8034bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8034be:	8b 50 08             	mov    0x8(%eax),%edx
  8034c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034c4:	8b 40 08             	mov    0x8(%eax),%eax
  8034c7:	39 c2                	cmp    %eax,%edx
  8034c9:	0f 86 f1 03 00 00    	jbe    8038c0 <insert_sorted_with_merge_freeList+0x710>
  8034cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8034d2:	8b 50 08             	mov    0x8(%eax),%edx
  8034d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034d8:	8b 40 08             	mov    0x8(%eax),%eax
  8034db:	39 c2                	cmp    %eax,%edx
  8034dd:	0f 83 dd 03 00 00    	jae    8038c0 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  8034e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034e6:	8b 50 08             	mov    0x8(%eax),%edx
  8034e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034ec:	8b 40 0c             	mov    0xc(%eax),%eax
  8034ef:	01 c2                	add    %eax,%edx
  8034f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8034f4:	8b 40 08             	mov    0x8(%eax),%eax
  8034f7:	39 c2                	cmp    %eax,%edx
  8034f9:	0f 85 b9 01 00 00    	jne    8036b8 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8034ff:	8b 45 08             	mov    0x8(%ebp),%eax
  803502:	8b 50 08             	mov    0x8(%eax),%edx
  803505:	8b 45 08             	mov    0x8(%ebp),%eax
  803508:	8b 40 0c             	mov    0xc(%eax),%eax
  80350b:	01 c2                	add    %eax,%edx
  80350d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803510:	8b 40 08             	mov    0x8(%eax),%eax
  803513:	39 c2                	cmp    %eax,%edx
  803515:	0f 85 0d 01 00 00    	jne    803628 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  80351b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80351e:	8b 50 0c             	mov    0xc(%eax),%edx
  803521:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803524:	8b 40 0c             	mov    0xc(%eax),%eax
  803527:	01 c2                	add    %eax,%edx
  803529:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80352c:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80352f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803533:	75 17                	jne    80354c <insert_sorted_with_merge_freeList+0x39c>
  803535:	83 ec 04             	sub    $0x4,%esp
  803538:	68 80 44 80 00       	push   $0x804480
  80353d:	68 5c 01 00 00       	push   $0x15c
  803542:	68 d7 43 80 00       	push   $0x8043d7
  803547:	e8 95 d1 ff ff       	call   8006e1 <_panic>
  80354c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80354f:	8b 00                	mov    (%eax),%eax
  803551:	85 c0                	test   %eax,%eax
  803553:	74 10                	je     803565 <insert_sorted_with_merge_freeList+0x3b5>
  803555:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803558:	8b 00                	mov    (%eax),%eax
  80355a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80355d:	8b 52 04             	mov    0x4(%edx),%edx
  803560:	89 50 04             	mov    %edx,0x4(%eax)
  803563:	eb 0b                	jmp    803570 <insert_sorted_with_merge_freeList+0x3c0>
  803565:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803568:	8b 40 04             	mov    0x4(%eax),%eax
  80356b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803570:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803573:	8b 40 04             	mov    0x4(%eax),%eax
  803576:	85 c0                	test   %eax,%eax
  803578:	74 0f                	je     803589 <insert_sorted_with_merge_freeList+0x3d9>
  80357a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80357d:	8b 40 04             	mov    0x4(%eax),%eax
  803580:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803583:	8b 12                	mov    (%edx),%edx
  803585:	89 10                	mov    %edx,(%eax)
  803587:	eb 0a                	jmp    803593 <insert_sorted_with_merge_freeList+0x3e3>
  803589:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80358c:	8b 00                	mov    (%eax),%eax
  80358e:	a3 38 51 80 00       	mov    %eax,0x805138
  803593:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803596:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80359c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80359f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035a6:	a1 44 51 80 00       	mov    0x805144,%eax
  8035ab:	48                   	dec    %eax
  8035ac:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  8035b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035b4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  8035bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035be:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8035c5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8035c9:	75 17                	jne    8035e2 <insert_sorted_with_merge_freeList+0x432>
  8035cb:	83 ec 04             	sub    $0x4,%esp
  8035ce:	68 b4 43 80 00       	push   $0x8043b4
  8035d3:	68 5f 01 00 00       	push   $0x15f
  8035d8:	68 d7 43 80 00       	push   $0x8043d7
  8035dd:	e8 ff d0 ff ff       	call   8006e1 <_panic>
  8035e2:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8035e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035eb:	89 10                	mov    %edx,(%eax)
  8035ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035f0:	8b 00                	mov    (%eax),%eax
  8035f2:	85 c0                	test   %eax,%eax
  8035f4:	74 0d                	je     803603 <insert_sorted_with_merge_freeList+0x453>
  8035f6:	a1 48 51 80 00       	mov    0x805148,%eax
  8035fb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8035fe:	89 50 04             	mov    %edx,0x4(%eax)
  803601:	eb 08                	jmp    80360b <insert_sorted_with_merge_freeList+0x45b>
  803603:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803606:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80360b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80360e:	a3 48 51 80 00       	mov    %eax,0x805148
  803613:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803616:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80361d:	a1 54 51 80 00       	mov    0x805154,%eax
  803622:	40                   	inc    %eax
  803623:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803628:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80362b:	8b 50 0c             	mov    0xc(%eax),%edx
  80362e:	8b 45 08             	mov    0x8(%ebp),%eax
  803631:	8b 40 0c             	mov    0xc(%eax),%eax
  803634:	01 c2                	add    %eax,%edx
  803636:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803639:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  80363c:	8b 45 08             	mov    0x8(%ebp),%eax
  80363f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803646:	8b 45 08             	mov    0x8(%ebp),%eax
  803649:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803650:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803654:	75 17                	jne    80366d <insert_sorted_with_merge_freeList+0x4bd>
  803656:	83 ec 04             	sub    $0x4,%esp
  803659:	68 b4 43 80 00       	push   $0x8043b4
  80365e:	68 64 01 00 00       	push   $0x164
  803663:	68 d7 43 80 00       	push   $0x8043d7
  803668:	e8 74 d0 ff ff       	call   8006e1 <_panic>
  80366d:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803673:	8b 45 08             	mov    0x8(%ebp),%eax
  803676:	89 10                	mov    %edx,(%eax)
  803678:	8b 45 08             	mov    0x8(%ebp),%eax
  80367b:	8b 00                	mov    (%eax),%eax
  80367d:	85 c0                	test   %eax,%eax
  80367f:	74 0d                	je     80368e <insert_sorted_with_merge_freeList+0x4de>
  803681:	a1 48 51 80 00       	mov    0x805148,%eax
  803686:	8b 55 08             	mov    0x8(%ebp),%edx
  803689:	89 50 04             	mov    %edx,0x4(%eax)
  80368c:	eb 08                	jmp    803696 <insert_sorted_with_merge_freeList+0x4e6>
  80368e:	8b 45 08             	mov    0x8(%ebp),%eax
  803691:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803696:	8b 45 08             	mov    0x8(%ebp),%eax
  803699:	a3 48 51 80 00       	mov    %eax,0x805148
  80369e:	8b 45 08             	mov    0x8(%ebp),%eax
  8036a1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036a8:	a1 54 51 80 00       	mov    0x805154,%eax
  8036ad:	40                   	inc    %eax
  8036ae:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8036b3:	e9 41 02 00 00       	jmp    8038f9 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8036b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8036bb:	8b 50 08             	mov    0x8(%eax),%edx
  8036be:	8b 45 08             	mov    0x8(%ebp),%eax
  8036c1:	8b 40 0c             	mov    0xc(%eax),%eax
  8036c4:	01 c2                	add    %eax,%edx
  8036c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036c9:	8b 40 08             	mov    0x8(%eax),%eax
  8036cc:	39 c2                	cmp    %eax,%edx
  8036ce:	0f 85 7c 01 00 00    	jne    803850 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  8036d4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8036d8:	74 06                	je     8036e0 <insert_sorted_with_merge_freeList+0x530>
  8036da:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8036de:	75 17                	jne    8036f7 <insert_sorted_with_merge_freeList+0x547>
  8036e0:	83 ec 04             	sub    $0x4,%esp
  8036e3:	68 f0 43 80 00       	push   $0x8043f0
  8036e8:	68 69 01 00 00       	push   $0x169
  8036ed:	68 d7 43 80 00       	push   $0x8043d7
  8036f2:	e8 ea cf ff ff       	call   8006e1 <_panic>
  8036f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036fa:	8b 50 04             	mov    0x4(%eax),%edx
  8036fd:	8b 45 08             	mov    0x8(%ebp),%eax
  803700:	89 50 04             	mov    %edx,0x4(%eax)
  803703:	8b 45 08             	mov    0x8(%ebp),%eax
  803706:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803709:	89 10                	mov    %edx,(%eax)
  80370b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80370e:	8b 40 04             	mov    0x4(%eax),%eax
  803711:	85 c0                	test   %eax,%eax
  803713:	74 0d                	je     803722 <insert_sorted_with_merge_freeList+0x572>
  803715:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803718:	8b 40 04             	mov    0x4(%eax),%eax
  80371b:	8b 55 08             	mov    0x8(%ebp),%edx
  80371e:	89 10                	mov    %edx,(%eax)
  803720:	eb 08                	jmp    80372a <insert_sorted_with_merge_freeList+0x57a>
  803722:	8b 45 08             	mov    0x8(%ebp),%eax
  803725:	a3 38 51 80 00       	mov    %eax,0x805138
  80372a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80372d:	8b 55 08             	mov    0x8(%ebp),%edx
  803730:	89 50 04             	mov    %edx,0x4(%eax)
  803733:	a1 44 51 80 00       	mov    0x805144,%eax
  803738:	40                   	inc    %eax
  803739:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  80373e:	8b 45 08             	mov    0x8(%ebp),%eax
  803741:	8b 50 0c             	mov    0xc(%eax),%edx
  803744:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803747:	8b 40 0c             	mov    0xc(%eax),%eax
  80374a:	01 c2                	add    %eax,%edx
  80374c:	8b 45 08             	mov    0x8(%ebp),%eax
  80374f:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803752:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803756:	75 17                	jne    80376f <insert_sorted_with_merge_freeList+0x5bf>
  803758:	83 ec 04             	sub    $0x4,%esp
  80375b:	68 80 44 80 00       	push   $0x804480
  803760:	68 6b 01 00 00       	push   $0x16b
  803765:	68 d7 43 80 00       	push   $0x8043d7
  80376a:	e8 72 cf ff ff       	call   8006e1 <_panic>
  80376f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803772:	8b 00                	mov    (%eax),%eax
  803774:	85 c0                	test   %eax,%eax
  803776:	74 10                	je     803788 <insert_sorted_with_merge_freeList+0x5d8>
  803778:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80377b:	8b 00                	mov    (%eax),%eax
  80377d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803780:	8b 52 04             	mov    0x4(%edx),%edx
  803783:	89 50 04             	mov    %edx,0x4(%eax)
  803786:	eb 0b                	jmp    803793 <insert_sorted_with_merge_freeList+0x5e3>
  803788:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80378b:	8b 40 04             	mov    0x4(%eax),%eax
  80378e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803793:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803796:	8b 40 04             	mov    0x4(%eax),%eax
  803799:	85 c0                	test   %eax,%eax
  80379b:	74 0f                	je     8037ac <insert_sorted_with_merge_freeList+0x5fc>
  80379d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037a0:	8b 40 04             	mov    0x4(%eax),%eax
  8037a3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8037a6:	8b 12                	mov    (%edx),%edx
  8037a8:	89 10                	mov    %edx,(%eax)
  8037aa:	eb 0a                	jmp    8037b6 <insert_sorted_with_merge_freeList+0x606>
  8037ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037af:	8b 00                	mov    (%eax),%eax
  8037b1:	a3 38 51 80 00       	mov    %eax,0x805138
  8037b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037b9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037c2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037c9:	a1 44 51 80 00       	mov    0x805144,%eax
  8037ce:	48                   	dec    %eax
  8037cf:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  8037d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037d7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  8037de:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037e1:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8037e8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8037ec:	75 17                	jne    803805 <insert_sorted_with_merge_freeList+0x655>
  8037ee:	83 ec 04             	sub    $0x4,%esp
  8037f1:	68 b4 43 80 00       	push   $0x8043b4
  8037f6:	68 6e 01 00 00       	push   $0x16e
  8037fb:	68 d7 43 80 00       	push   $0x8043d7
  803800:	e8 dc ce ff ff       	call   8006e1 <_panic>
  803805:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80380b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80380e:	89 10                	mov    %edx,(%eax)
  803810:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803813:	8b 00                	mov    (%eax),%eax
  803815:	85 c0                	test   %eax,%eax
  803817:	74 0d                	je     803826 <insert_sorted_with_merge_freeList+0x676>
  803819:	a1 48 51 80 00       	mov    0x805148,%eax
  80381e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803821:	89 50 04             	mov    %edx,0x4(%eax)
  803824:	eb 08                	jmp    80382e <insert_sorted_with_merge_freeList+0x67e>
  803826:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803829:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80382e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803831:	a3 48 51 80 00       	mov    %eax,0x805148
  803836:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803839:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803840:	a1 54 51 80 00       	mov    0x805154,%eax
  803845:	40                   	inc    %eax
  803846:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  80384b:	e9 a9 00 00 00       	jmp    8038f9 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803850:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803854:	74 06                	je     80385c <insert_sorted_with_merge_freeList+0x6ac>
  803856:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80385a:	75 17                	jne    803873 <insert_sorted_with_merge_freeList+0x6c3>
  80385c:	83 ec 04             	sub    $0x4,%esp
  80385f:	68 4c 44 80 00       	push   $0x80444c
  803864:	68 73 01 00 00       	push   $0x173
  803869:	68 d7 43 80 00       	push   $0x8043d7
  80386e:	e8 6e ce ff ff       	call   8006e1 <_panic>
  803873:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803876:	8b 10                	mov    (%eax),%edx
  803878:	8b 45 08             	mov    0x8(%ebp),%eax
  80387b:	89 10                	mov    %edx,(%eax)
  80387d:	8b 45 08             	mov    0x8(%ebp),%eax
  803880:	8b 00                	mov    (%eax),%eax
  803882:	85 c0                	test   %eax,%eax
  803884:	74 0b                	je     803891 <insert_sorted_with_merge_freeList+0x6e1>
  803886:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803889:	8b 00                	mov    (%eax),%eax
  80388b:	8b 55 08             	mov    0x8(%ebp),%edx
  80388e:	89 50 04             	mov    %edx,0x4(%eax)
  803891:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803894:	8b 55 08             	mov    0x8(%ebp),%edx
  803897:	89 10                	mov    %edx,(%eax)
  803899:	8b 45 08             	mov    0x8(%ebp),%eax
  80389c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80389f:	89 50 04             	mov    %edx,0x4(%eax)
  8038a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8038a5:	8b 00                	mov    (%eax),%eax
  8038a7:	85 c0                	test   %eax,%eax
  8038a9:	75 08                	jne    8038b3 <insert_sorted_with_merge_freeList+0x703>
  8038ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ae:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8038b3:	a1 44 51 80 00       	mov    0x805144,%eax
  8038b8:	40                   	inc    %eax
  8038b9:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  8038be:	eb 39                	jmp    8038f9 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8038c0:	a1 40 51 80 00       	mov    0x805140,%eax
  8038c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8038c8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8038cc:	74 07                	je     8038d5 <insert_sorted_with_merge_freeList+0x725>
  8038ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038d1:	8b 00                	mov    (%eax),%eax
  8038d3:	eb 05                	jmp    8038da <insert_sorted_with_merge_freeList+0x72a>
  8038d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8038da:	a3 40 51 80 00       	mov    %eax,0x805140
  8038df:	a1 40 51 80 00       	mov    0x805140,%eax
  8038e4:	85 c0                	test   %eax,%eax
  8038e6:	0f 85 c7 fb ff ff    	jne    8034b3 <insert_sorted_with_merge_freeList+0x303>
  8038ec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8038f0:	0f 85 bd fb ff ff    	jne    8034b3 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8038f6:	eb 01                	jmp    8038f9 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8038f8:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8038f9:	90                   	nop
  8038fa:	c9                   	leave  
  8038fb:	c3                   	ret    

008038fc <__udivdi3>:
  8038fc:	55                   	push   %ebp
  8038fd:	57                   	push   %edi
  8038fe:	56                   	push   %esi
  8038ff:	53                   	push   %ebx
  803900:	83 ec 1c             	sub    $0x1c,%esp
  803903:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803907:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80390b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80390f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803913:	89 ca                	mov    %ecx,%edx
  803915:	89 f8                	mov    %edi,%eax
  803917:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80391b:	85 f6                	test   %esi,%esi
  80391d:	75 2d                	jne    80394c <__udivdi3+0x50>
  80391f:	39 cf                	cmp    %ecx,%edi
  803921:	77 65                	ja     803988 <__udivdi3+0x8c>
  803923:	89 fd                	mov    %edi,%ebp
  803925:	85 ff                	test   %edi,%edi
  803927:	75 0b                	jne    803934 <__udivdi3+0x38>
  803929:	b8 01 00 00 00       	mov    $0x1,%eax
  80392e:	31 d2                	xor    %edx,%edx
  803930:	f7 f7                	div    %edi
  803932:	89 c5                	mov    %eax,%ebp
  803934:	31 d2                	xor    %edx,%edx
  803936:	89 c8                	mov    %ecx,%eax
  803938:	f7 f5                	div    %ebp
  80393a:	89 c1                	mov    %eax,%ecx
  80393c:	89 d8                	mov    %ebx,%eax
  80393e:	f7 f5                	div    %ebp
  803940:	89 cf                	mov    %ecx,%edi
  803942:	89 fa                	mov    %edi,%edx
  803944:	83 c4 1c             	add    $0x1c,%esp
  803947:	5b                   	pop    %ebx
  803948:	5e                   	pop    %esi
  803949:	5f                   	pop    %edi
  80394a:	5d                   	pop    %ebp
  80394b:	c3                   	ret    
  80394c:	39 ce                	cmp    %ecx,%esi
  80394e:	77 28                	ja     803978 <__udivdi3+0x7c>
  803950:	0f bd fe             	bsr    %esi,%edi
  803953:	83 f7 1f             	xor    $0x1f,%edi
  803956:	75 40                	jne    803998 <__udivdi3+0x9c>
  803958:	39 ce                	cmp    %ecx,%esi
  80395a:	72 0a                	jb     803966 <__udivdi3+0x6a>
  80395c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803960:	0f 87 9e 00 00 00    	ja     803a04 <__udivdi3+0x108>
  803966:	b8 01 00 00 00       	mov    $0x1,%eax
  80396b:	89 fa                	mov    %edi,%edx
  80396d:	83 c4 1c             	add    $0x1c,%esp
  803970:	5b                   	pop    %ebx
  803971:	5e                   	pop    %esi
  803972:	5f                   	pop    %edi
  803973:	5d                   	pop    %ebp
  803974:	c3                   	ret    
  803975:	8d 76 00             	lea    0x0(%esi),%esi
  803978:	31 ff                	xor    %edi,%edi
  80397a:	31 c0                	xor    %eax,%eax
  80397c:	89 fa                	mov    %edi,%edx
  80397e:	83 c4 1c             	add    $0x1c,%esp
  803981:	5b                   	pop    %ebx
  803982:	5e                   	pop    %esi
  803983:	5f                   	pop    %edi
  803984:	5d                   	pop    %ebp
  803985:	c3                   	ret    
  803986:	66 90                	xchg   %ax,%ax
  803988:	89 d8                	mov    %ebx,%eax
  80398a:	f7 f7                	div    %edi
  80398c:	31 ff                	xor    %edi,%edi
  80398e:	89 fa                	mov    %edi,%edx
  803990:	83 c4 1c             	add    $0x1c,%esp
  803993:	5b                   	pop    %ebx
  803994:	5e                   	pop    %esi
  803995:	5f                   	pop    %edi
  803996:	5d                   	pop    %ebp
  803997:	c3                   	ret    
  803998:	bd 20 00 00 00       	mov    $0x20,%ebp
  80399d:	89 eb                	mov    %ebp,%ebx
  80399f:	29 fb                	sub    %edi,%ebx
  8039a1:	89 f9                	mov    %edi,%ecx
  8039a3:	d3 e6                	shl    %cl,%esi
  8039a5:	89 c5                	mov    %eax,%ebp
  8039a7:	88 d9                	mov    %bl,%cl
  8039a9:	d3 ed                	shr    %cl,%ebp
  8039ab:	89 e9                	mov    %ebp,%ecx
  8039ad:	09 f1                	or     %esi,%ecx
  8039af:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8039b3:	89 f9                	mov    %edi,%ecx
  8039b5:	d3 e0                	shl    %cl,%eax
  8039b7:	89 c5                	mov    %eax,%ebp
  8039b9:	89 d6                	mov    %edx,%esi
  8039bb:	88 d9                	mov    %bl,%cl
  8039bd:	d3 ee                	shr    %cl,%esi
  8039bf:	89 f9                	mov    %edi,%ecx
  8039c1:	d3 e2                	shl    %cl,%edx
  8039c3:	8b 44 24 08          	mov    0x8(%esp),%eax
  8039c7:	88 d9                	mov    %bl,%cl
  8039c9:	d3 e8                	shr    %cl,%eax
  8039cb:	09 c2                	or     %eax,%edx
  8039cd:	89 d0                	mov    %edx,%eax
  8039cf:	89 f2                	mov    %esi,%edx
  8039d1:	f7 74 24 0c          	divl   0xc(%esp)
  8039d5:	89 d6                	mov    %edx,%esi
  8039d7:	89 c3                	mov    %eax,%ebx
  8039d9:	f7 e5                	mul    %ebp
  8039db:	39 d6                	cmp    %edx,%esi
  8039dd:	72 19                	jb     8039f8 <__udivdi3+0xfc>
  8039df:	74 0b                	je     8039ec <__udivdi3+0xf0>
  8039e1:	89 d8                	mov    %ebx,%eax
  8039e3:	31 ff                	xor    %edi,%edi
  8039e5:	e9 58 ff ff ff       	jmp    803942 <__udivdi3+0x46>
  8039ea:	66 90                	xchg   %ax,%ax
  8039ec:	8b 54 24 08          	mov    0x8(%esp),%edx
  8039f0:	89 f9                	mov    %edi,%ecx
  8039f2:	d3 e2                	shl    %cl,%edx
  8039f4:	39 c2                	cmp    %eax,%edx
  8039f6:	73 e9                	jae    8039e1 <__udivdi3+0xe5>
  8039f8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8039fb:	31 ff                	xor    %edi,%edi
  8039fd:	e9 40 ff ff ff       	jmp    803942 <__udivdi3+0x46>
  803a02:	66 90                	xchg   %ax,%ax
  803a04:	31 c0                	xor    %eax,%eax
  803a06:	e9 37 ff ff ff       	jmp    803942 <__udivdi3+0x46>
  803a0b:	90                   	nop

00803a0c <__umoddi3>:
  803a0c:	55                   	push   %ebp
  803a0d:	57                   	push   %edi
  803a0e:	56                   	push   %esi
  803a0f:	53                   	push   %ebx
  803a10:	83 ec 1c             	sub    $0x1c,%esp
  803a13:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803a17:	8b 74 24 34          	mov    0x34(%esp),%esi
  803a1b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803a1f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803a23:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803a27:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803a2b:	89 f3                	mov    %esi,%ebx
  803a2d:	89 fa                	mov    %edi,%edx
  803a2f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803a33:	89 34 24             	mov    %esi,(%esp)
  803a36:	85 c0                	test   %eax,%eax
  803a38:	75 1a                	jne    803a54 <__umoddi3+0x48>
  803a3a:	39 f7                	cmp    %esi,%edi
  803a3c:	0f 86 a2 00 00 00    	jbe    803ae4 <__umoddi3+0xd8>
  803a42:	89 c8                	mov    %ecx,%eax
  803a44:	89 f2                	mov    %esi,%edx
  803a46:	f7 f7                	div    %edi
  803a48:	89 d0                	mov    %edx,%eax
  803a4a:	31 d2                	xor    %edx,%edx
  803a4c:	83 c4 1c             	add    $0x1c,%esp
  803a4f:	5b                   	pop    %ebx
  803a50:	5e                   	pop    %esi
  803a51:	5f                   	pop    %edi
  803a52:	5d                   	pop    %ebp
  803a53:	c3                   	ret    
  803a54:	39 f0                	cmp    %esi,%eax
  803a56:	0f 87 ac 00 00 00    	ja     803b08 <__umoddi3+0xfc>
  803a5c:	0f bd e8             	bsr    %eax,%ebp
  803a5f:	83 f5 1f             	xor    $0x1f,%ebp
  803a62:	0f 84 ac 00 00 00    	je     803b14 <__umoddi3+0x108>
  803a68:	bf 20 00 00 00       	mov    $0x20,%edi
  803a6d:	29 ef                	sub    %ebp,%edi
  803a6f:	89 fe                	mov    %edi,%esi
  803a71:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803a75:	89 e9                	mov    %ebp,%ecx
  803a77:	d3 e0                	shl    %cl,%eax
  803a79:	89 d7                	mov    %edx,%edi
  803a7b:	89 f1                	mov    %esi,%ecx
  803a7d:	d3 ef                	shr    %cl,%edi
  803a7f:	09 c7                	or     %eax,%edi
  803a81:	89 e9                	mov    %ebp,%ecx
  803a83:	d3 e2                	shl    %cl,%edx
  803a85:	89 14 24             	mov    %edx,(%esp)
  803a88:	89 d8                	mov    %ebx,%eax
  803a8a:	d3 e0                	shl    %cl,%eax
  803a8c:	89 c2                	mov    %eax,%edx
  803a8e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803a92:	d3 e0                	shl    %cl,%eax
  803a94:	89 44 24 04          	mov    %eax,0x4(%esp)
  803a98:	8b 44 24 08          	mov    0x8(%esp),%eax
  803a9c:	89 f1                	mov    %esi,%ecx
  803a9e:	d3 e8                	shr    %cl,%eax
  803aa0:	09 d0                	or     %edx,%eax
  803aa2:	d3 eb                	shr    %cl,%ebx
  803aa4:	89 da                	mov    %ebx,%edx
  803aa6:	f7 f7                	div    %edi
  803aa8:	89 d3                	mov    %edx,%ebx
  803aaa:	f7 24 24             	mull   (%esp)
  803aad:	89 c6                	mov    %eax,%esi
  803aaf:	89 d1                	mov    %edx,%ecx
  803ab1:	39 d3                	cmp    %edx,%ebx
  803ab3:	0f 82 87 00 00 00    	jb     803b40 <__umoddi3+0x134>
  803ab9:	0f 84 91 00 00 00    	je     803b50 <__umoddi3+0x144>
  803abf:	8b 54 24 04          	mov    0x4(%esp),%edx
  803ac3:	29 f2                	sub    %esi,%edx
  803ac5:	19 cb                	sbb    %ecx,%ebx
  803ac7:	89 d8                	mov    %ebx,%eax
  803ac9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803acd:	d3 e0                	shl    %cl,%eax
  803acf:	89 e9                	mov    %ebp,%ecx
  803ad1:	d3 ea                	shr    %cl,%edx
  803ad3:	09 d0                	or     %edx,%eax
  803ad5:	89 e9                	mov    %ebp,%ecx
  803ad7:	d3 eb                	shr    %cl,%ebx
  803ad9:	89 da                	mov    %ebx,%edx
  803adb:	83 c4 1c             	add    $0x1c,%esp
  803ade:	5b                   	pop    %ebx
  803adf:	5e                   	pop    %esi
  803ae0:	5f                   	pop    %edi
  803ae1:	5d                   	pop    %ebp
  803ae2:	c3                   	ret    
  803ae3:	90                   	nop
  803ae4:	89 fd                	mov    %edi,%ebp
  803ae6:	85 ff                	test   %edi,%edi
  803ae8:	75 0b                	jne    803af5 <__umoddi3+0xe9>
  803aea:	b8 01 00 00 00       	mov    $0x1,%eax
  803aef:	31 d2                	xor    %edx,%edx
  803af1:	f7 f7                	div    %edi
  803af3:	89 c5                	mov    %eax,%ebp
  803af5:	89 f0                	mov    %esi,%eax
  803af7:	31 d2                	xor    %edx,%edx
  803af9:	f7 f5                	div    %ebp
  803afb:	89 c8                	mov    %ecx,%eax
  803afd:	f7 f5                	div    %ebp
  803aff:	89 d0                	mov    %edx,%eax
  803b01:	e9 44 ff ff ff       	jmp    803a4a <__umoddi3+0x3e>
  803b06:	66 90                	xchg   %ax,%ax
  803b08:	89 c8                	mov    %ecx,%eax
  803b0a:	89 f2                	mov    %esi,%edx
  803b0c:	83 c4 1c             	add    $0x1c,%esp
  803b0f:	5b                   	pop    %ebx
  803b10:	5e                   	pop    %esi
  803b11:	5f                   	pop    %edi
  803b12:	5d                   	pop    %ebp
  803b13:	c3                   	ret    
  803b14:	3b 04 24             	cmp    (%esp),%eax
  803b17:	72 06                	jb     803b1f <__umoddi3+0x113>
  803b19:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803b1d:	77 0f                	ja     803b2e <__umoddi3+0x122>
  803b1f:	89 f2                	mov    %esi,%edx
  803b21:	29 f9                	sub    %edi,%ecx
  803b23:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803b27:	89 14 24             	mov    %edx,(%esp)
  803b2a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803b2e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803b32:	8b 14 24             	mov    (%esp),%edx
  803b35:	83 c4 1c             	add    $0x1c,%esp
  803b38:	5b                   	pop    %ebx
  803b39:	5e                   	pop    %esi
  803b3a:	5f                   	pop    %edi
  803b3b:	5d                   	pop    %ebp
  803b3c:	c3                   	ret    
  803b3d:	8d 76 00             	lea    0x0(%esi),%esi
  803b40:	2b 04 24             	sub    (%esp),%eax
  803b43:	19 fa                	sbb    %edi,%edx
  803b45:	89 d1                	mov    %edx,%ecx
  803b47:	89 c6                	mov    %eax,%esi
  803b49:	e9 71 ff ff ff       	jmp    803abf <__umoddi3+0xb3>
  803b4e:	66 90                	xchg   %ax,%ax
  803b50:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803b54:	72 ea                	jb     803b40 <__umoddi3+0x134>
  803b56:	89 d9                	mov    %ebx,%ecx
  803b58:	e9 62 ff ff ff       	jmp    803abf <__umoddi3+0xb3>
