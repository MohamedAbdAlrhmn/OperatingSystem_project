
obj/user/tst_sharing_4:     file format elf32-i386


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
  800031:	e8 34 05 00 00       	call   80056a <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Test the free of shared variables (create_shared_memory)
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	83 ec 44             	sub    $0x44,%esp
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  80003f:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800043:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80004a:	eb 29                	jmp    800075 <_main+0x3d>
		{
			if (myEnv->__uptr_pws[i].empty)
  80004c:	a1 20 30 80 00       	mov    0x803020,%eax
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
_main(void)
{
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800072:	ff 45 f0             	incl   -0x10(%ebp)
  800075:	a1 20 30 80 00       	mov    0x803020,%eax
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
  80008d:	68 00 21 80 00       	push   $0x802100
  800092:	6a 12                	push   $0x12
  800094:	68 1c 21 80 00       	push   $0x80211c
  800099:	e8 08 06 00 00       	call   8006a6 <_panic>
	}

	cprintf("************************************************\n");
  80009e:	83 ec 0c             	sub    $0xc,%esp
  8000a1:	68 34 21 80 00       	push   $0x802134
  8000a6:	e8 af 08 00 00       	call   80095a <cprintf>
  8000ab:	83 c4 10             	add    $0x10,%esp
	cprintf("MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  8000ae:	83 ec 0c             	sub    $0xc,%esp
  8000b1:	68 68 21 80 00       	push   $0x802168
  8000b6:	e8 9f 08 00 00       	call   80095a <cprintf>
  8000bb:	83 c4 10             	add    $0x10,%esp
	cprintf("************************************************\n\n\n");
  8000be:	83 ec 0c             	sub    $0xc,%esp
  8000c1:	68 c4 21 80 00       	push   $0x8021c4
  8000c6:	e8 8f 08 00 00       	call   80095a <cprintf>
  8000cb:	83 c4 10             	add    $0x10,%esp

	int Mega = 1024*1024;
  8000ce:	c7 45 ec 00 00 10 00 	movl   $0x100000,-0x14(%ebp)
	int kilo = 1024;
  8000d5:	c7 45 e8 00 04 00 00 	movl   $0x400,-0x18(%ebp)
	int envID = sys_getenvid();
  8000dc:	e8 f3 1a 00 00       	call   801bd4 <sys_getenvid>
  8000e1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	cprintf("STEP A: checking free of a shared object ... \n");
  8000e4:	83 ec 0c             	sub    $0xc,%esp
  8000e7:	68 f8 21 80 00       	push   $0x8021f8
  8000ec:	e8 69 08 00 00       	call   80095a <cprintf>
  8000f1:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x;
		int freeFrames = sys_calculate_free_frames() ;
  8000f4:	e8 14 18 00 00       	call   80190d <sys_calculate_free_frames>
  8000f9:	89 45 e0             	mov    %eax,-0x20(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8000fc:	83 ec 04             	sub    $0x4,%esp
  8000ff:	6a 01                	push   $0x1
  800101:	68 00 10 00 00       	push   $0x1000
  800106:	68 27 22 80 00       	push   $0x802227
  80010b:	e8 49 16 00 00       	call   801759 <smalloc>
  800110:	83 c4 10             	add    $0x10,%esp
  800113:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (x != (uint32*)USER_HEAP_START) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  800116:	81 7d dc 00 00 00 80 	cmpl   $0x80000000,-0x24(%ebp)
  80011d:	74 14                	je     800133 <_main+0xfb>
  80011f:	83 ec 04             	sub    $0x4,%esp
  800122:	68 2c 22 80 00       	push   $0x80222c
  800127:	6a 21                	push   $0x21
  800129:	68 1c 21 80 00       	push   $0x80211c
  80012e:	e8 73 05 00 00       	call   8006a6 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800133:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800136:	e8 d2 17 00 00       	call   80190d <sys_calculate_free_frames>
  80013b:	29 c3                	sub    %eax,%ebx
  80013d:	89 d8                	mov    %ebx,%eax
  80013f:	83 f8 04             	cmp    $0x4,%eax
  800142:	74 14                	je     800158 <_main+0x120>
  800144:	83 ec 04             	sub    $0x4,%esp
  800147:	68 98 22 80 00       	push   $0x802298
  80014c:	6a 22                	push   $0x22
  80014e:	68 1c 21 80 00       	push   $0x80211c
  800153:	e8 4e 05 00 00       	call   8006a6 <_panic>

		sfree(x);
  800158:	83 ec 0c             	sub    $0xc,%esp
  80015b:	ff 75 dc             	pushl  -0x24(%ebp)
  80015e:	e8 4a 16 00 00       	call   8017ad <sfree>
  800163:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) ==  0+0+2) panic("Wrong free: make sure that you free the shared object by calling free_share_object()");
  800166:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800169:	e8 9f 17 00 00       	call   80190d <sys_calculate_free_frames>
  80016e:	29 c3                	sub    %eax,%ebx
  800170:	89 d8                	mov    %ebx,%eax
  800172:	83 f8 02             	cmp    $0x2,%eax
  800175:	75 14                	jne    80018b <_main+0x153>
  800177:	83 ec 04             	sub    $0x4,%esp
  80017a:	68 18 23 80 00       	push   $0x802318
  80017f:	6a 25                	push   $0x25
  800181:	68 1c 21 80 00       	push   $0x80211c
  800186:	e8 1b 05 00 00       	call   8006a6 <_panic>
		else if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong free: revise your freeSharedObject logic");
  80018b:	e8 7d 17 00 00       	call   80190d <sys_calculate_free_frames>
  800190:	89 c2                	mov    %eax,%edx
  800192:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800195:	39 c2                	cmp    %eax,%edx
  800197:	74 14                	je     8001ad <_main+0x175>
  800199:	83 ec 04             	sub    $0x4,%esp
  80019c:	68 70 23 80 00       	push   $0x802370
  8001a1:	6a 26                	push   $0x26
  8001a3:	68 1c 21 80 00       	push   $0x80211c
  8001a8:	e8 f9 04 00 00       	call   8006a6 <_panic>
	}
	cprintf("Step A completed successfully!!\n\n\n");
  8001ad:	83 ec 0c             	sub    $0xc,%esp
  8001b0:	68 a0 23 80 00       	push   $0x8023a0
  8001b5:	e8 a0 07 00 00       	call   80095a <cprintf>
  8001ba:	83 c4 10             	add    $0x10,%esp


	cprintf("STEP B: checking free of 2 shared objects ... \n");
  8001bd:	83 ec 0c             	sub    $0xc,%esp
  8001c0:	68 c4 23 80 00       	push   $0x8023c4
  8001c5:	e8 90 07 00 00       	call   80095a <cprintf>
  8001ca:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x, *z ;
		int freeFrames = sys_calculate_free_frames() ;
  8001cd:	e8 3b 17 00 00       	call   80190d <sys_calculate_free_frames>
  8001d2:	89 45 d8             	mov    %eax,-0x28(%ebp)
		z = smalloc("z", PAGE_SIZE, 1);
  8001d5:	83 ec 04             	sub    $0x4,%esp
  8001d8:	6a 01                	push   $0x1
  8001da:	68 00 10 00 00       	push   $0x1000
  8001df:	68 f4 23 80 00       	push   $0x8023f4
  8001e4:	e8 70 15 00 00       	call   801759 <smalloc>
  8001e9:	83 c4 10             	add    $0x10,%esp
  8001ec:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8001ef:	83 ec 04             	sub    $0x4,%esp
  8001f2:	6a 01                	push   $0x1
  8001f4:	68 00 10 00 00       	push   $0x1000
  8001f9:	68 27 22 80 00       	push   $0x802227
  8001fe:	e8 56 15 00 00       	call   801759 <smalloc>
  800203:	83 c4 10             	add    $0x10,%esp
  800206:	89 45 d0             	mov    %eax,-0x30(%ebp)

		if(x == NULL) panic("Wrong free: make sure that you free the shared object by calling free_share_object()");
  800209:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80020d:	75 14                	jne    800223 <_main+0x1eb>
  80020f:	83 ec 04             	sub    $0x4,%esp
  800212:	68 18 23 80 00       	push   $0x802318
  800217:	6a 32                	push   $0x32
  800219:	68 1c 21 80 00       	push   $0x80211c
  80021e:	e8 83 04 00 00       	call   8006a6 <_panic>

		if ((freeFrames - sys_calculate_free_frames()) !=  2+1+4) panic("Wrong previous free: make sure that you correctly free shared object before (Step A)");
  800223:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800226:	e8 e2 16 00 00       	call   80190d <sys_calculate_free_frames>
  80022b:	29 c3                	sub    %eax,%ebx
  80022d:	89 d8                	mov    %ebx,%eax
  80022f:	83 f8 07             	cmp    $0x7,%eax
  800232:	74 14                	je     800248 <_main+0x210>
  800234:	83 ec 04             	sub    $0x4,%esp
  800237:	68 f8 23 80 00       	push   $0x8023f8
  80023c:	6a 34                	push   $0x34
  80023e:	68 1c 21 80 00       	push   $0x80211c
  800243:	e8 5e 04 00 00       	call   8006a6 <_panic>

		sfree(z);
  800248:	83 ec 0c             	sub    $0xc,%esp
  80024b:	ff 75 d4             	pushl  -0x2c(%ebp)
  80024e:	e8 5a 15 00 00       	call   8017ad <sfree>
  800253:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong free: check your logic");
  800256:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800259:	e8 af 16 00 00       	call   80190d <sys_calculate_free_frames>
  80025e:	29 c3                	sub    %eax,%ebx
  800260:	89 d8                	mov    %ebx,%eax
  800262:	83 f8 04             	cmp    $0x4,%eax
  800265:	74 14                	je     80027b <_main+0x243>
  800267:	83 ec 04             	sub    $0x4,%esp
  80026a:	68 4d 24 80 00       	push   $0x80244d
  80026f:	6a 37                	push   $0x37
  800271:	68 1c 21 80 00       	push   $0x80211c
  800276:	e8 2b 04 00 00       	call   8006a6 <_panic>

		sfree(x);
  80027b:	83 ec 0c             	sub    $0xc,%esp
  80027e:	ff 75 d0             	pushl  -0x30(%ebp)
  800281:	e8 27 15 00 00       	call   8017ad <sfree>
  800286:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong free: check your logic");
  800289:	e8 7f 16 00 00       	call   80190d <sys_calculate_free_frames>
  80028e:	89 c2                	mov    %eax,%edx
  800290:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800293:	39 c2                	cmp    %eax,%edx
  800295:	74 14                	je     8002ab <_main+0x273>
  800297:	83 ec 04             	sub    $0x4,%esp
  80029a:	68 4d 24 80 00       	push   $0x80244d
  80029f:	6a 3a                	push   $0x3a
  8002a1:	68 1c 21 80 00       	push   $0x80211c
  8002a6:	e8 fb 03 00 00       	call   8006a6 <_panic>

	}
	cprintf("Step B completed successfully!!\n\n\n");
  8002ab:	83 ec 0c             	sub    $0xc,%esp
  8002ae:	68 6c 24 80 00       	push   $0x80246c
  8002b3:	e8 a2 06 00 00       	call   80095a <cprintf>
  8002b8:	83 c4 10             	add    $0x10,%esp

	cprintf("STEP C: checking range of loop during free... \n");
  8002bb:	83 ec 0c             	sub    $0xc,%esp
  8002be:	68 90 24 80 00       	push   $0x802490
  8002c3:	e8 92 06 00 00       	call   80095a <cprintf>
  8002c8:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *w, *u;
		int freeFrames = sys_calculate_free_frames() ;
  8002cb:	e8 3d 16 00 00       	call   80190d <sys_calculate_free_frames>
  8002d0:	89 45 cc             	mov    %eax,-0x34(%ebp)
		w = smalloc("w", 3 * PAGE_SIZE+1, 1);
  8002d3:	83 ec 04             	sub    $0x4,%esp
  8002d6:	6a 01                	push   $0x1
  8002d8:	68 01 30 00 00       	push   $0x3001
  8002dd:	68 c0 24 80 00       	push   $0x8024c0
  8002e2:	e8 72 14 00 00       	call   801759 <smalloc>
  8002e7:	83 c4 10             	add    $0x10,%esp
  8002ea:	89 45 c8             	mov    %eax,-0x38(%ebp)
		u = smalloc("u", PAGE_SIZE, 1);
  8002ed:	83 ec 04             	sub    $0x4,%esp
  8002f0:	6a 01                	push   $0x1
  8002f2:	68 00 10 00 00       	push   $0x1000
  8002f7:	68 c2 24 80 00       	push   $0x8024c2
  8002fc:	e8 58 14 00 00       	call   801759 <smalloc>
  800301:	83 c4 10             	add    $0x10,%esp
  800304:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		if ((freeFrames - sys_calculate_free_frames()) != 5+1+4) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800307:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  80030a:	e8 fe 15 00 00       	call   80190d <sys_calculate_free_frames>
  80030f:	29 c3                	sub    %eax,%ebx
  800311:	89 d8                	mov    %ebx,%eax
  800313:	83 f8 0a             	cmp    $0xa,%eax
  800316:	74 14                	je     80032c <_main+0x2f4>
  800318:	83 ec 04             	sub    $0x4,%esp
  80031b:	68 98 22 80 00       	push   $0x802298
  800320:	6a 45                	push   $0x45
  800322:	68 1c 21 80 00       	push   $0x80211c
  800327:	e8 7a 03 00 00       	call   8006a6 <_panic>

		sfree(w);
  80032c:	83 ec 0c             	sub    $0xc,%esp
  80032f:	ff 75 c8             	pushl  -0x38(%ebp)
  800332:	e8 76 14 00 00       	call   8017ad <sfree>
  800337:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong free: check your logic");
  80033a:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  80033d:	e8 cb 15 00 00       	call   80190d <sys_calculate_free_frames>
  800342:	29 c3                	sub    %eax,%ebx
  800344:	89 d8                	mov    %ebx,%eax
  800346:	83 f8 04             	cmp    $0x4,%eax
  800349:	74 14                	je     80035f <_main+0x327>
  80034b:	83 ec 04             	sub    $0x4,%esp
  80034e:	68 4d 24 80 00       	push   $0x80244d
  800353:	6a 48                	push   $0x48
  800355:	68 1c 21 80 00       	push   $0x80211c
  80035a:	e8 47 03 00 00       	call   8006a6 <_panic>

		uint32 *o;

		o = smalloc("o", 2 * PAGE_SIZE-1,1);
  80035f:	83 ec 04             	sub    $0x4,%esp
  800362:	6a 01                	push   $0x1
  800364:	68 ff 1f 00 00       	push   $0x1fff
  800369:	68 c4 24 80 00       	push   $0x8024c4
  80036e:	e8 e6 13 00 00       	call   801759 <smalloc>
  800373:	83 c4 10             	add    $0x10,%esp
  800376:	89 45 c0             	mov    %eax,-0x40(%ebp)

		cprintf("2\n");
  800379:	83 ec 0c             	sub    $0xc,%esp
  80037c:	68 c6 24 80 00       	push   $0x8024c6
  800381:	e8 d4 05 00 00       	call   80095a <cprintf>
  800386:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) != 3+1+4) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800389:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  80038c:	e8 7c 15 00 00       	call   80190d <sys_calculate_free_frames>
  800391:	29 c3                	sub    %eax,%ebx
  800393:	89 d8                	mov    %ebx,%eax
  800395:	83 f8 08             	cmp    $0x8,%eax
  800398:	74 14                	je     8003ae <_main+0x376>
  80039a:	83 ec 04             	sub    $0x4,%esp
  80039d:	68 98 22 80 00       	push   $0x802298
  8003a2:	6a 4f                	push   $0x4f
  8003a4:	68 1c 21 80 00       	push   $0x80211c
  8003a9:	e8 f8 02 00 00       	call   8006a6 <_panic>

		sfree(o);
  8003ae:	83 ec 0c             	sub    $0xc,%esp
  8003b1:	ff 75 c0             	pushl  -0x40(%ebp)
  8003b4:	e8 f4 13 00 00       	call   8017ad <sfree>
  8003b9:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong free: check your logic");
  8003bc:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8003bf:	e8 49 15 00 00       	call   80190d <sys_calculate_free_frames>
  8003c4:	29 c3                	sub    %eax,%ebx
  8003c6:	89 d8                	mov    %ebx,%eax
  8003c8:	83 f8 04             	cmp    $0x4,%eax
  8003cb:	74 14                	je     8003e1 <_main+0x3a9>
  8003cd:	83 ec 04             	sub    $0x4,%esp
  8003d0:	68 4d 24 80 00       	push   $0x80244d
  8003d5:	6a 52                	push   $0x52
  8003d7:	68 1c 21 80 00       	push   $0x80211c
  8003dc:	e8 c5 02 00 00       	call   8006a6 <_panic>

		sfree(u);
  8003e1:	83 ec 0c             	sub    $0xc,%esp
  8003e4:	ff 75 c4             	pushl  -0x3c(%ebp)
  8003e7:	e8 c1 13 00 00       	call   8017ad <sfree>
  8003ec:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong free: check your logic");
  8003ef:	e8 19 15 00 00       	call   80190d <sys_calculate_free_frames>
  8003f4:	89 c2                	mov    %eax,%edx
  8003f6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8003f9:	39 c2                	cmp    %eax,%edx
  8003fb:	74 14                	je     800411 <_main+0x3d9>
  8003fd:	83 ec 04             	sub    $0x4,%esp
  800400:	68 4d 24 80 00       	push   $0x80244d
  800405:	6a 55                	push   $0x55
  800407:	68 1c 21 80 00       	push   $0x80211c
  80040c:	e8 95 02 00 00       	call   8006a6 <_panic>


		//Checking boundaries of page tables
		freeFrames = sys_calculate_free_frames() ;
  800411:	e8 f7 14 00 00       	call   80190d <sys_calculate_free_frames>
  800416:	89 45 cc             	mov    %eax,-0x34(%ebp)
		w = smalloc("w", 3 * Mega - 1*kilo, 1);
  800419:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80041c:	89 c2                	mov    %eax,%edx
  80041e:	01 d2                	add    %edx,%edx
  800420:	01 d0                	add    %edx,%eax
  800422:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800425:	83 ec 04             	sub    $0x4,%esp
  800428:	6a 01                	push   $0x1
  80042a:	50                   	push   %eax
  80042b:	68 c0 24 80 00       	push   $0x8024c0
  800430:	e8 24 13 00 00       	call   801759 <smalloc>
  800435:	83 c4 10             	add    $0x10,%esp
  800438:	89 45 c8             	mov    %eax,-0x38(%ebp)
		u = smalloc("u", 7 * Mega - 1*kilo, 1);
  80043b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80043e:	89 d0                	mov    %edx,%eax
  800440:	01 c0                	add    %eax,%eax
  800442:	01 d0                	add    %edx,%eax
  800444:	01 c0                	add    %eax,%eax
  800446:	01 d0                	add    %edx,%eax
  800448:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80044b:	83 ec 04             	sub    $0x4,%esp
  80044e:	6a 01                	push   $0x1
  800450:	50                   	push   %eax
  800451:	68 c2 24 80 00       	push   $0x8024c2
  800456:	e8 fe 12 00 00       	call   801759 <smalloc>
  80045b:	83 c4 10             	add    $0x10,%esp
  80045e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		o = smalloc("o", 2 * Mega + 1*kilo, 1);
  800461:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800464:	01 c0                	add    %eax,%eax
  800466:	89 c2                	mov    %eax,%edx
  800468:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80046b:	01 d0                	add    %edx,%eax
  80046d:	83 ec 04             	sub    $0x4,%esp
  800470:	6a 01                	push   $0x1
  800472:	50                   	push   %eax
  800473:	68 c4 24 80 00       	push   $0x8024c4
  800478:	e8 dc 12 00 00       	call   801759 <smalloc>
  80047d:	83 c4 10             	add    $0x10,%esp
  800480:	89 45 c0             	mov    %eax,-0x40(%ebp)

		if ((freeFrames - sys_calculate_free_frames()) != 3073+4+7) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800483:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800486:	e8 82 14 00 00       	call   80190d <sys_calculate_free_frames>
  80048b:	29 c3                	sub    %eax,%ebx
  80048d:	89 d8                	mov    %ebx,%eax
  80048f:	3d 0c 0c 00 00       	cmp    $0xc0c,%eax
  800494:	74 14                	je     8004aa <_main+0x472>
  800496:	83 ec 04             	sub    $0x4,%esp
  800499:	68 98 22 80 00       	push   $0x802298
  80049e:	6a 5e                	push   $0x5e
  8004a0:	68 1c 21 80 00       	push   $0x80211c
  8004a5:	e8 fc 01 00 00       	call   8006a6 <_panic>

		sfree(o);
  8004aa:	83 ec 0c             	sub    $0xc,%esp
  8004ad:	ff 75 c0             	pushl  -0x40(%ebp)
  8004b0:	e8 f8 12 00 00       	call   8017ad <sfree>
  8004b5:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  2560+3+5) panic("Wrong free: check your logic");
  8004b8:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8004bb:	e8 4d 14 00 00       	call   80190d <sys_calculate_free_frames>
  8004c0:	29 c3                	sub    %eax,%ebx
  8004c2:	89 d8                	mov    %ebx,%eax
  8004c4:	3d 08 0a 00 00       	cmp    $0xa08,%eax
  8004c9:	74 14                	je     8004df <_main+0x4a7>
  8004cb:	83 ec 04             	sub    $0x4,%esp
  8004ce:	68 4d 24 80 00       	push   $0x80244d
  8004d3:	6a 61                	push   $0x61
  8004d5:	68 1c 21 80 00       	push   $0x80211c
  8004da:	e8 c7 01 00 00       	call   8006a6 <_panic>

		sfree(w);
  8004df:	83 ec 0c             	sub    $0xc,%esp
  8004e2:	ff 75 c8             	pushl  -0x38(%ebp)
  8004e5:	e8 c3 12 00 00       	call   8017ad <sfree>
  8004ea:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  1792+3+3) panic("Wrong free: check your logic");
  8004ed:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8004f0:	e8 18 14 00 00       	call   80190d <sys_calculate_free_frames>
  8004f5:	29 c3                	sub    %eax,%ebx
  8004f7:	89 d8                	mov    %ebx,%eax
  8004f9:	3d 06 07 00 00       	cmp    $0x706,%eax
  8004fe:	74 14                	je     800514 <_main+0x4dc>
  800500:	83 ec 04             	sub    $0x4,%esp
  800503:	68 4d 24 80 00       	push   $0x80244d
  800508:	6a 64                	push   $0x64
  80050a:	68 1c 21 80 00       	push   $0x80211c
  80050f:	e8 92 01 00 00       	call   8006a6 <_panic>

		sfree(u);
  800514:	83 ec 0c             	sub    $0xc,%esp
  800517:	ff 75 c4             	pushl  -0x3c(%ebp)
  80051a:	e8 8e 12 00 00       	call   8017ad <sfree>
  80051f:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong free: check your logic");
  800522:	e8 e6 13 00 00       	call   80190d <sys_calculate_free_frames>
  800527:	89 c2                	mov    %eax,%edx
  800529:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80052c:	39 c2                	cmp    %eax,%edx
  80052e:	74 14                	je     800544 <_main+0x50c>
  800530:	83 ec 04             	sub    $0x4,%esp
  800533:	68 4d 24 80 00       	push   $0x80244d
  800538:	6a 67                	push   $0x67
  80053a:	68 1c 21 80 00       	push   $0x80211c
  80053f:	e8 62 01 00 00       	call   8006a6 <_panic>
	}
	cprintf("Step C completed successfully!!\n\n\n");
  800544:	83 ec 0c             	sub    $0xc,%esp
  800547:	68 cc 24 80 00       	push   $0x8024cc
  80054c:	e8 09 04 00 00       	call   80095a <cprintf>
  800551:	83 c4 10             	add    $0x10,%esp

	cprintf("Congratulations!! Test of freeSharedObjects [4] completed successfully!!\n\n\n");
  800554:	83 ec 0c             	sub    $0xc,%esp
  800557:	68 f0 24 80 00       	push   $0x8024f0
  80055c:	e8 f9 03 00 00       	call   80095a <cprintf>
  800561:	83 c4 10             	add    $0x10,%esp

	return;
  800564:	90                   	nop
}
  800565:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800568:	c9                   	leave  
  800569:	c3                   	ret    

0080056a <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80056a:	55                   	push   %ebp
  80056b:	89 e5                	mov    %esp,%ebp
  80056d:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800570:	e8 78 16 00 00       	call   801bed <sys_getenvindex>
  800575:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800578:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80057b:	89 d0                	mov    %edx,%eax
  80057d:	c1 e0 03             	shl    $0x3,%eax
  800580:	01 d0                	add    %edx,%eax
  800582:	01 c0                	add    %eax,%eax
  800584:	01 d0                	add    %edx,%eax
  800586:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80058d:	01 d0                	add    %edx,%eax
  80058f:	c1 e0 04             	shl    $0x4,%eax
  800592:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800597:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80059c:	a1 20 30 80 00       	mov    0x803020,%eax
  8005a1:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8005a7:	84 c0                	test   %al,%al
  8005a9:	74 0f                	je     8005ba <libmain+0x50>
		binaryname = myEnv->prog_name;
  8005ab:	a1 20 30 80 00       	mov    0x803020,%eax
  8005b0:	05 5c 05 00 00       	add    $0x55c,%eax
  8005b5:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8005ba:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8005be:	7e 0a                	jle    8005ca <libmain+0x60>
		binaryname = argv[0];
  8005c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005c3:	8b 00                	mov    (%eax),%eax
  8005c5:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8005ca:	83 ec 08             	sub    $0x8,%esp
  8005cd:	ff 75 0c             	pushl  0xc(%ebp)
  8005d0:	ff 75 08             	pushl  0x8(%ebp)
  8005d3:	e8 60 fa ff ff       	call   800038 <_main>
  8005d8:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8005db:	e8 1a 14 00 00       	call   8019fa <sys_disable_interrupt>
	cprintf("**************************************\n");
  8005e0:	83 ec 0c             	sub    $0xc,%esp
  8005e3:	68 54 25 80 00       	push   $0x802554
  8005e8:	e8 6d 03 00 00       	call   80095a <cprintf>
  8005ed:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8005f0:	a1 20 30 80 00       	mov    0x803020,%eax
  8005f5:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8005fb:	a1 20 30 80 00       	mov    0x803020,%eax
  800600:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800606:	83 ec 04             	sub    $0x4,%esp
  800609:	52                   	push   %edx
  80060a:	50                   	push   %eax
  80060b:	68 7c 25 80 00       	push   $0x80257c
  800610:	e8 45 03 00 00       	call   80095a <cprintf>
  800615:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800618:	a1 20 30 80 00       	mov    0x803020,%eax
  80061d:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800623:	a1 20 30 80 00       	mov    0x803020,%eax
  800628:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  80062e:	a1 20 30 80 00       	mov    0x803020,%eax
  800633:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800639:	51                   	push   %ecx
  80063a:	52                   	push   %edx
  80063b:	50                   	push   %eax
  80063c:	68 a4 25 80 00       	push   $0x8025a4
  800641:	e8 14 03 00 00       	call   80095a <cprintf>
  800646:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800649:	a1 20 30 80 00       	mov    0x803020,%eax
  80064e:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800654:	83 ec 08             	sub    $0x8,%esp
  800657:	50                   	push   %eax
  800658:	68 fc 25 80 00       	push   $0x8025fc
  80065d:	e8 f8 02 00 00       	call   80095a <cprintf>
  800662:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800665:	83 ec 0c             	sub    $0xc,%esp
  800668:	68 54 25 80 00       	push   $0x802554
  80066d:	e8 e8 02 00 00       	call   80095a <cprintf>
  800672:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800675:	e8 9a 13 00 00       	call   801a14 <sys_enable_interrupt>

	// exit gracefully
	exit();
  80067a:	e8 19 00 00 00       	call   800698 <exit>
}
  80067f:	90                   	nop
  800680:	c9                   	leave  
  800681:	c3                   	ret    

00800682 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800682:	55                   	push   %ebp
  800683:	89 e5                	mov    %esp,%ebp
  800685:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800688:	83 ec 0c             	sub    $0xc,%esp
  80068b:	6a 00                	push   $0x0
  80068d:	e8 27 15 00 00       	call   801bb9 <sys_destroy_env>
  800692:	83 c4 10             	add    $0x10,%esp
}
  800695:	90                   	nop
  800696:	c9                   	leave  
  800697:	c3                   	ret    

00800698 <exit>:

void
exit(void)
{
  800698:	55                   	push   %ebp
  800699:	89 e5                	mov    %esp,%ebp
  80069b:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80069e:	e8 7c 15 00 00       	call   801c1f <sys_exit_env>
}
  8006a3:	90                   	nop
  8006a4:	c9                   	leave  
  8006a5:	c3                   	ret    

008006a6 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8006a6:	55                   	push   %ebp
  8006a7:	89 e5                	mov    %esp,%ebp
  8006a9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8006ac:	8d 45 10             	lea    0x10(%ebp),%eax
  8006af:	83 c0 04             	add    $0x4,%eax
  8006b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8006b5:	a1 5c 31 80 00       	mov    0x80315c,%eax
  8006ba:	85 c0                	test   %eax,%eax
  8006bc:	74 16                	je     8006d4 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8006be:	a1 5c 31 80 00       	mov    0x80315c,%eax
  8006c3:	83 ec 08             	sub    $0x8,%esp
  8006c6:	50                   	push   %eax
  8006c7:	68 10 26 80 00       	push   $0x802610
  8006cc:	e8 89 02 00 00       	call   80095a <cprintf>
  8006d1:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8006d4:	a1 00 30 80 00       	mov    0x803000,%eax
  8006d9:	ff 75 0c             	pushl  0xc(%ebp)
  8006dc:	ff 75 08             	pushl  0x8(%ebp)
  8006df:	50                   	push   %eax
  8006e0:	68 15 26 80 00       	push   $0x802615
  8006e5:	e8 70 02 00 00       	call   80095a <cprintf>
  8006ea:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8006ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8006f0:	83 ec 08             	sub    $0x8,%esp
  8006f3:	ff 75 f4             	pushl  -0xc(%ebp)
  8006f6:	50                   	push   %eax
  8006f7:	e8 f3 01 00 00       	call   8008ef <vcprintf>
  8006fc:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8006ff:	83 ec 08             	sub    $0x8,%esp
  800702:	6a 00                	push   $0x0
  800704:	68 31 26 80 00       	push   $0x802631
  800709:	e8 e1 01 00 00       	call   8008ef <vcprintf>
  80070e:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800711:	e8 82 ff ff ff       	call   800698 <exit>

	// should not return here
	while (1) ;
  800716:	eb fe                	jmp    800716 <_panic+0x70>

00800718 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800718:	55                   	push   %ebp
  800719:	89 e5                	mov    %esp,%ebp
  80071b:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80071e:	a1 20 30 80 00       	mov    0x803020,%eax
  800723:	8b 50 74             	mov    0x74(%eax),%edx
  800726:	8b 45 0c             	mov    0xc(%ebp),%eax
  800729:	39 c2                	cmp    %eax,%edx
  80072b:	74 14                	je     800741 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80072d:	83 ec 04             	sub    $0x4,%esp
  800730:	68 34 26 80 00       	push   $0x802634
  800735:	6a 26                	push   $0x26
  800737:	68 80 26 80 00       	push   $0x802680
  80073c:	e8 65 ff ff ff       	call   8006a6 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800741:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800748:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80074f:	e9 c2 00 00 00       	jmp    800816 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800754:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800757:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80075e:	8b 45 08             	mov    0x8(%ebp),%eax
  800761:	01 d0                	add    %edx,%eax
  800763:	8b 00                	mov    (%eax),%eax
  800765:	85 c0                	test   %eax,%eax
  800767:	75 08                	jne    800771 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800769:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80076c:	e9 a2 00 00 00       	jmp    800813 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800771:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800778:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80077f:	eb 69                	jmp    8007ea <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800781:	a1 20 30 80 00       	mov    0x803020,%eax
  800786:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80078c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80078f:	89 d0                	mov    %edx,%eax
  800791:	01 c0                	add    %eax,%eax
  800793:	01 d0                	add    %edx,%eax
  800795:	c1 e0 03             	shl    $0x3,%eax
  800798:	01 c8                	add    %ecx,%eax
  80079a:	8a 40 04             	mov    0x4(%eax),%al
  80079d:	84 c0                	test   %al,%al
  80079f:	75 46                	jne    8007e7 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8007a1:	a1 20 30 80 00       	mov    0x803020,%eax
  8007a6:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8007ac:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8007af:	89 d0                	mov    %edx,%eax
  8007b1:	01 c0                	add    %eax,%eax
  8007b3:	01 d0                	add    %edx,%eax
  8007b5:	c1 e0 03             	shl    $0x3,%eax
  8007b8:	01 c8                	add    %ecx,%eax
  8007ba:	8b 00                	mov    (%eax),%eax
  8007bc:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8007bf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8007c2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8007c7:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8007c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007cc:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8007d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d6:	01 c8                	add    %ecx,%eax
  8007d8:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8007da:	39 c2                	cmp    %eax,%edx
  8007dc:	75 09                	jne    8007e7 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8007de:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8007e5:	eb 12                	jmp    8007f9 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8007e7:	ff 45 e8             	incl   -0x18(%ebp)
  8007ea:	a1 20 30 80 00       	mov    0x803020,%eax
  8007ef:	8b 50 74             	mov    0x74(%eax),%edx
  8007f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8007f5:	39 c2                	cmp    %eax,%edx
  8007f7:	77 88                	ja     800781 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8007f9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8007fd:	75 14                	jne    800813 <CheckWSWithoutLastIndex+0xfb>
			panic(
  8007ff:	83 ec 04             	sub    $0x4,%esp
  800802:	68 8c 26 80 00       	push   $0x80268c
  800807:	6a 3a                	push   $0x3a
  800809:	68 80 26 80 00       	push   $0x802680
  80080e:	e8 93 fe ff ff       	call   8006a6 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800813:	ff 45 f0             	incl   -0x10(%ebp)
  800816:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800819:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80081c:	0f 8c 32 ff ff ff    	jl     800754 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800822:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800829:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800830:	eb 26                	jmp    800858 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800832:	a1 20 30 80 00       	mov    0x803020,%eax
  800837:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80083d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800840:	89 d0                	mov    %edx,%eax
  800842:	01 c0                	add    %eax,%eax
  800844:	01 d0                	add    %edx,%eax
  800846:	c1 e0 03             	shl    $0x3,%eax
  800849:	01 c8                	add    %ecx,%eax
  80084b:	8a 40 04             	mov    0x4(%eax),%al
  80084e:	3c 01                	cmp    $0x1,%al
  800850:	75 03                	jne    800855 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800852:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800855:	ff 45 e0             	incl   -0x20(%ebp)
  800858:	a1 20 30 80 00       	mov    0x803020,%eax
  80085d:	8b 50 74             	mov    0x74(%eax),%edx
  800860:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800863:	39 c2                	cmp    %eax,%edx
  800865:	77 cb                	ja     800832 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800867:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80086a:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80086d:	74 14                	je     800883 <CheckWSWithoutLastIndex+0x16b>
		panic(
  80086f:	83 ec 04             	sub    $0x4,%esp
  800872:	68 e0 26 80 00       	push   $0x8026e0
  800877:	6a 44                	push   $0x44
  800879:	68 80 26 80 00       	push   $0x802680
  80087e:	e8 23 fe ff ff       	call   8006a6 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800883:	90                   	nop
  800884:	c9                   	leave  
  800885:	c3                   	ret    

00800886 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800886:	55                   	push   %ebp
  800887:	89 e5                	mov    %esp,%ebp
  800889:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80088c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80088f:	8b 00                	mov    (%eax),%eax
  800891:	8d 48 01             	lea    0x1(%eax),%ecx
  800894:	8b 55 0c             	mov    0xc(%ebp),%edx
  800897:	89 0a                	mov    %ecx,(%edx)
  800899:	8b 55 08             	mov    0x8(%ebp),%edx
  80089c:	88 d1                	mov    %dl,%cl
  80089e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008a1:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8008a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008a8:	8b 00                	mov    (%eax),%eax
  8008aa:	3d ff 00 00 00       	cmp    $0xff,%eax
  8008af:	75 2c                	jne    8008dd <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8008b1:	a0 24 30 80 00       	mov    0x803024,%al
  8008b6:	0f b6 c0             	movzbl %al,%eax
  8008b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008bc:	8b 12                	mov    (%edx),%edx
  8008be:	89 d1                	mov    %edx,%ecx
  8008c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008c3:	83 c2 08             	add    $0x8,%edx
  8008c6:	83 ec 04             	sub    $0x4,%esp
  8008c9:	50                   	push   %eax
  8008ca:	51                   	push   %ecx
  8008cb:	52                   	push   %edx
  8008cc:	e8 7b 0f 00 00       	call   80184c <sys_cputs>
  8008d1:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8008d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008d7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8008dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008e0:	8b 40 04             	mov    0x4(%eax),%eax
  8008e3:	8d 50 01             	lea    0x1(%eax),%edx
  8008e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008e9:	89 50 04             	mov    %edx,0x4(%eax)
}
  8008ec:	90                   	nop
  8008ed:	c9                   	leave  
  8008ee:	c3                   	ret    

008008ef <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8008ef:	55                   	push   %ebp
  8008f0:	89 e5                	mov    %esp,%ebp
  8008f2:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8008f8:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8008ff:	00 00 00 
	b.cnt = 0;
  800902:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800909:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80090c:	ff 75 0c             	pushl  0xc(%ebp)
  80090f:	ff 75 08             	pushl  0x8(%ebp)
  800912:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800918:	50                   	push   %eax
  800919:	68 86 08 80 00       	push   $0x800886
  80091e:	e8 11 02 00 00       	call   800b34 <vprintfmt>
  800923:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800926:	a0 24 30 80 00       	mov    0x803024,%al
  80092b:	0f b6 c0             	movzbl %al,%eax
  80092e:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800934:	83 ec 04             	sub    $0x4,%esp
  800937:	50                   	push   %eax
  800938:	52                   	push   %edx
  800939:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80093f:	83 c0 08             	add    $0x8,%eax
  800942:	50                   	push   %eax
  800943:	e8 04 0f 00 00       	call   80184c <sys_cputs>
  800948:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80094b:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  800952:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800958:	c9                   	leave  
  800959:	c3                   	ret    

0080095a <cprintf>:

int cprintf(const char *fmt, ...) {
  80095a:	55                   	push   %ebp
  80095b:	89 e5                	mov    %esp,%ebp
  80095d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800960:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  800967:	8d 45 0c             	lea    0xc(%ebp),%eax
  80096a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80096d:	8b 45 08             	mov    0x8(%ebp),%eax
  800970:	83 ec 08             	sub    $0x8,%esp
  800973:	ff 75 f4             	pushl  -0xc(%ebp)
  800976:	50                   	push   %eax
  800977:	e8 73 ff ff ff       	call   8008ef <vcprintf>
  80097c:	83 c4 10             	add    $0x10,%esp
  80097f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800982:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800985:	c9                   	leave  
  800986:	c3                   	ret    

00800987 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800987:	55                   	push   %ebp
  800988:	89 e5                	mov    %esp,%ebp
  80098a:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80098d:	e8 68 10 00 00       	call   8019fa <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800992:	8d 45 0c             	lea    0xc(%ebp),%eax
  800995:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800998:	8b 45 08             	mov    0x8(%ebp),%eax
  80099b:	83 ec 08             	sub    $0x8,%esp
  80099e:	ff 75 f4             	pushl  -0xc(%ebp)
  8009a1:	50                   	push   %eax
  8009a2:	e8 48 ff ff ff       	call   8008ef <vcprintf>
  8009a7:	83 c4 10             	add    $0x10,%esp
  8009aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8009ad:	e8 62 10 00 00       	call   801a14 <sys_enable_interrupt>
	return cnt;
  8009b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009b5:	c9                   	leave  
  8009b6:	c3                   	ret    

008009b7 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8009b7:	55                   	push   %ebp
  8009b8:	89 e5                	mov    %esp,%ebp
  8009ba:	53                   	push   %ebx
  8009bb:	83 ec 14             	sub    $0x14,%esp
  8009be:	8b 45 10             	mov    0x10(%ebp),%eax
  8009c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8009c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8009ca:	8b 45 18             	mov    0x18(%ebp),%eax
  8009cd:	ba 00 00 00 00       	mov    $0x0,%edx
  8009d2:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8009d5:	77 55                	ja     800a2c <printnum+0x75>
  8009d7:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8009da:	72 05                	jb     8009e1 <printnum+0x2a>
  8009dc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8009df:	77 4b                	ja     800a2c <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8009e1:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8009e4:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8009e7:	8b 45 18             	mov    0x18(%ebp),%eax
  8009ea:	ba 00 00 00 00       	mov    $0x0,%edx
  8009ef:	52                   	push   %edx
  8009f0:	50                   	push   %eax
  8009f1:	ff 75 f4             	pushl  -0xc(%ebp)
  8009f4:	ff 75 f0             	pushl  -0x10(%ebp)
  8009f7:	e8 84 14 00 00       	call   801e80 <__udivdi3>
  8009fc:	83 c4 10             	add    $0x10,%esp
  8009ff:	83 ec 04             	sub    $0x4,%esp
  800a02:	ff 75 20             	pushl  0x20(%ebp)
  800a05:	53                   	push   %ebx
  800a06:	ff 75 18             	pushl  0x18(%ebp)
  800a09:	52                   	push   %edx
  800a0a:	50                   	push   %eax
  800a0b:	ff 75 0c             	pushl  0xc(%ebp)
  800a0e:	ff 75 08             	pushl  0x8(%ebp)
  800a11:	e8 a1 ff ff ff       	call   8009b7 <printnum>
  800a16:	83 c4 20             	add    $0x20,%esp
  800a19:	eb 1a                	jmp    800a35 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800a1b:	83 ec 08             	sub    $0x8,%esp
  800a1e:	ff 75 0c             	pushl  0xc(%ebp)
  800a21:	ff 75 20             	pushl  0x20(%ebp)
  800a24:	8b 45 08             	mov    0x8(%ebp),%eax
  800a27:	ff d0                	call   *%eax
  800a29:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800a2c:	ff 4d 1c             	decl   0x1c(%ebp)
  800a2f:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800a33:	7f e6                	jg     800a1b <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800a35:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800a38:	bb 00 00 00 00       	mov    $0x0,%ebx
  800a3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a40:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a43:	53                   	push   %ebx
  800a44:	51                   	push   %ecx
  800a45:	52                   	push   %edx
  800a46:	50                   	push   %eax
  800a47:	e8 44 15 00 00       	call   801f90 <__umoddi3>
  800a4c:	83 c4 10             	add    $0x10,%esp
  800a4f:	05 54 29 80 00       	add    $0x802954,%eax
  800a54:	8a 00                	mov    (%eax),%al
  800a56:	0f be c0             	movsbl %al,%eax
  800a59:	83 ec 08             	sub    $0x8,%esp
  800a5c:	ff 75 0c             	pushl  0xc(%ebp)
  800a5f:	50                   	push   %eax
  800a60:	8b 45 08             	mov    0x8(%ebp),%eax
  800a63:	ff d0                	call   *%eax
  800a65:	83 c4 10             	add    $0x10,%esp
}
  800a68:	90                   	nop
  800a69:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a6c:	c9                   	leave  
  800a6d:	c3                   	ret    

00800a6e <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800a6e:	55                   	push   %ebp
  800a6f:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800a71:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800a75:	7e 1c                	jle    800a93 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800a77:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7a:	8b 00                	mov    (%eax),%eax
  800a7c:	8d 50 08             	lea    0x8(%eax),%edx
  800a7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a82:	89 10                	mov    %edx,(%eax)
  800a84:	8b 45 08             	mov    0x8(%ebp),%eax
  800a87:	8b 00                	mov    (%eax),%eax
  800a89:	83 e8 08             	sub    $0x8,%eax
  800a8c:	8b 50 04             	mov    0x4(%eax),%edx
  800a8f:	8b 00                	mov    (%eax),%eax
  800a91:	eb 40                	jmp    800ad3 <getuint+0x65>
	else if (lflag)
  800a93:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a97:	74 1e                	je     800ab7 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800a99:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9c:	8b 00                	mov    (%eax),%eax
  800a9e:	8d 50 04             	lea    0x4(%eax),%edx
  800aa1:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa4:	89 10                	mov    %edx,(%eax)
  800aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa9:	8b 00                	mov    (%eax),%eax
  800aab:	83 e8 04             	sub    $0x4,%eax
  800aae:	8b 00                	mov    (%eax),%eax
  800ab0:	ba 00 00 00 00       	mov    $0x0,%edx
  800ab5:	eb 1c                	jmp    800ad3 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800ab7:	8b 45 08             	mov    0x8(%ebp),%eax
  800aba:	8b 00                	mov    (%eax),%eax
  800abc:	8d 50 04             	lea    0x4(%eax),%edx
  800abf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac2:	89 10                	mov    %edx,(%eax)
  800ac4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac7:	8b 00                	mov    (%eax),%eax
  800ac9:	83 e8 04             	sub    $0x4,%eax
  800acc:	8b 00                	mov    (%eax),%eax
  800ace:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800ad3:	5d                   	pop    %ebp
  800ad4:	c3                   	ret    

00800ad5 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800ad5:	55                   	push   %ebp
  800ad6:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800ad8:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800adc:	7e 1c                	jle    800afa <getint+0x25>
		return va_arg(*ap, long long);
  800ade:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae1:	8b 00                	mov    (%eax),%eax
  800ae3:	8d 50 08             	lea    0x8(%eax),%edx
  800ae6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae9:	89 10                	mov    %edx,(%eax)
  800aeb:	8b 45 08             	mov    0x8(%ebp),%eax
  800aee:	8b 00                	mov    (%eax),%eax
  800af0:	83 e8 08             	sub    $0x8,%eax
  800af3:	8b 50 04             	mov    0x4(%eax),%edx
  800af6:	8b 00                	mov    (%eax),%eax
  800af8:	eb 38                	jmp    800b32 <getint+0x5d>
	else if (lflag)
  800afa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800afe:	74 1a                	je     800b1a <getint+0x45>
		return va_arg(*ap, long);
  800b00:	8b 45 08             	mov    0x8(%ebp),%eax
  800b03:	8b 00                	mov    (%eax),%eax
  800b05:	8d 50 04             	lea    0x4(%eax),%edx
  800b08:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0b:	89 10                	mov    %edx,(%eax)
  800b0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b10:	8b 00                	mov    (%eax),%eax
  800b12:	83 e8 04             	sub    $0x4,%eax
  800b15:	8b 00                	mov    (%eax),%eax
  800b17:	99                   	cltd   
  800b18:	eb 18                	jmp    800b32 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800b1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1d:	8b 00                	mov    (%eax),%eax
  800b1f:	8d 50 04             	lea    0x4(%eax),%edx
  800b22:	8b 45 08             	mov    0x8(%ebp),%eax
  800b25:	89 10                	mov    %edx,(%eax)
  800b27:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2a:	8b 00                	mov    (%eax),%eax
  800b2c:	83 e8 04             	sub    $0x4,%eax
  800b2f:	8b 00                	mov    (%eax),%eax
  800b31:	99                   	cltd   
}
  800b32:	5d                   	pop    %ebp
  800b33:	c3                   	ret    

00800b34 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800b34:	55                   	push   %ebp
  800b35:	89 e5                	mov    %esp,%ebp
  800b37:	56                   	push   %esi
  800b38:	53                   	push   %ebx
  800b39:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b3c:	eb 17                	jmp    800b55 <vprintfmt+0x21>
			if (ch == '\0')
  800b3e:	85 db                	test   %ebx,%ebx
  800b40:	0f 84 af 03 00 00    	je     800ef5 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800b46:	83 ec 08             	sub    $0x8,%esp
  800b49:	ff 75 0c             	pushl  0xc(%ebp)
  800b4c:	53                   	push   %ebx
  800b4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b50:	ff d0                	call   *%eax
  800b52:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b55:	8b 45 10             	mov    0x10(%ebp),%eax
  800b58:	8d 50 01             	lea    0x1(%eax),%edx
  800b5b:	89 55 10             	mov    %edx,0x10(%ebp)
  800b5e:	8a 00                	mov    (%eax),%al
  800b60:	0f b6 d8             	movzbl %al,%ebx
  800b63:	83 fb 25             	cmp    $0x25,%ebx
  800b66:	75 d6                	jne    800b3e <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800b68:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800b6c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800b73:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800b7a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800b81:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800b88:	8b 45 10             	mov    0x10(%ebp),%eax
  800b8b:	8d 50 01             	lea    0x1(%eax),%edx
  800b8e:	89 55 10             	mov    %edx,0x10(%ebp)
  800b91:	8a 00                	mov    (%eax),%al
  800b93:	0f b6 d8             	movzbl %al,%ebx
  800b96:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800b99:	83 f8 55             	cmp    $0x55,%eax
  800b9c:	0f 87 2b 03 00 00    	ja     800ecd <vprintfmt+0x399>
  800ba2:	8b 04 85 78 29 80 00 	mov    0x802978(,%eax,4),%eax
  800ba9:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800bab:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800baf:	eb d7                	jmp    800b88 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800bb1:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800bb5:	eb d1                	jmp    800b88 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800bb7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800bbe:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800bc1:	89 d0                	mov    %edx,%eax
  800bc3:	c1 e0 02             	shl    $0x2,%eax
  800bc6:	01 d0                	add    %edx,%eax
  800bc8:	01 c0                	add    %eax,%eax
  800bca:	01 d8                	add    %ebx,%eax
  800bcc:	83 e8 30             	sub    $0x30,%eax
  800bcf:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800bd2:	8b 45 10             	mov    0x10(%ebp),%eax
  800bd5:	8a 00                	mov    (%eax),%al
  800bd7:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800bda:	83 fb 2f             	cmp    $0x2f,%ebx
  800bdd:	7e 3e                	jle    800c1d <vprintfmt+0xe9>
  800bdf:	83 fb 39             	cmp    $0x39,%ebx
  800be2:	7f 39                	jg     800c1d <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800be4:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800be7:	eb d5                	jmp    800bbe <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800be9:	8b 45 14             	mov    0x14(%ebp),%eax
  800bec:	83 c0 04             	add    $0x4,%eax
  800bef:	89 45 14             	mov    %eax,0x14(%ebp)
  800bf2:	8b 45 14             	mov    0x14(%ebp),%eax
  800bf5:	83 e8 04             	sub    $0x4,%eax
  800bf8:	8b 00                	mov    (%eax),%eax
  800bfa:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800bfd:	eb 1f                	jmp    800c1e <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800bff:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c03:	79 83                	jns    800b88 <vprintfmt+0x54>
				width = 0;
  800c05:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800c0c:	e9 77 ff ff ff       	jmp    800b88 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800c11:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800c18:	e9 6b ff ff ff       	jmp    800b88 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800c1d:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800c1e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c22:	0f 89 60 ff ff ff    	jns    800b88 <vprintfmt+0x54>
				width = precision, precision = -1;
  800c28:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c2b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800c2e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800c35:	e9 4e ff ff ff       	jmp    800b88 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800c3a:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800c3d:	e9 46 ff ff ff       	jmp    800b88 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800c42:	8b 45 14             	mov    0x14(%ebp),%eax
  800c45:	83 c0 04             	add    $0x4,%eax
  800c48:	89 45 14             	mov    %eax,0x14(%ebp)
  800c4b:	8b 45 14             	mov    0x14(%ebp),%eax
  800c4e:	83 e8 04             	sub    $0x4,%eax
  800c51:	8b 00                	mov    (%eax),%eax
  800c53:	83 ec 08             	sub    $0x8,%esp
  800c56:	ff 75 0c             	pushl  0xc(%ebp)
  800c59:	50                   	push   %eax
  800c5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5d:	ff d0                	call   *%eax
  800c5f:	83 c4 10             	add    $0x10,%esp
			break;
  800c62:	e9 89 02 00 00       	jmp    800ef0 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800c67:	8b 45 14             	mov    0x14(%ebp),%eax
  800c6a:	83 c0 04             	add    $0x4,%eax
  800c6d:	89 45 14             	mov    %eax,0x14(%ebp)
  800c70:	8b 45 14             	mov    0x14(%ebp),%eax
  800c73:	83 e8 04             	sub    $0x4,%eax
  800c76:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800c78:	85 db                	test   %ebx,%ebx
  800c7a:	79 02                	jns    800c7e <vprintfmt+0x14a>
				err = -err;
  800c7c:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800c7e:	83 fb 64             	cmp    $0x64,%ebx
  800c81:	7f 0b                	jg     800c8e <vprintfmt+0x15a>
  800c83:	8b 34 9d c0 27 80 00 	mov    0x8027c0(,%ebx,4),%esi
  800c8a:	85 f6                	test   %esi,%esi
  800c8c:	75 19                	jne    800ca7 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800c8e:	53                   	push   %ebx
  800c8f:	68 65 29 80 00       	push   $0x802965
  800c94:	ff 75 0c             	pushl  0xc(%ebp)
  800c97:	ff 75 08             	pushl  0x8(%ebp)
  800c9a:	e8 5e 02 00 00       	call   800efd <printfmt>
  800c9f:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800ca2:	e9 49 02 00 00       	jmp    800ef0 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800ca7:	56                   	push   %esi
  800ca8:	68 6e 29 80 00       	push   $0x80296e
  800cad:	ff 75 0c             	pushl  0xc(%ebp)
  800cb0:	ff 75 08             	pushl  0x8(%ebp)
  800cb3:	e8 45 02 00 00       	call   800efd <printfmt>
  800cb8:	83 c4 10             	add    $0x10,%esp
			break;
  800cbb:	e9 30 02 00 00       	jmp    800ef0 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800cc0:	8b 45 14             	mov    0x14(%ebp),%eax
  800cc3:	83 c0 04             	add    $0x4,%eax
  800cc6:	89 45 14             	mov    %eax,0x14(%ebp)
  800cc9:	8b 45 14             	mov    0x14(%ebp),%eax
  800ccc:	83 e8 04             	sub    $0x4,%eax
  800ccf:	8b 30                	mov    (%eax),%esi
  800cd1:	85 f6                	test   %esi,%esi
  800cd3:	75 05                	jne    800cda <vprintfmt+0x1a6>
				p = "(null)";
  800cd5:	be 71 29 80 00       	mov    $0x802971,%esi
			if (width > 0 && padc != '-')
  800cda:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800cde:	7e 6d                	jle    800d4d <vprintfmt+0x219>
  800ce0:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800ce4:	74 67                	je     800d4d <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800ce6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ce9:	83 ec 08             	sub    $0x8,%esp
  800cec:	50                   	push   %eax
  800ced:	56                   	push   %esi
  800cee:	e8 0c 03 00 00       	call   800fff <strnlen>
  800cf3:	83 c4 10             	add    $0x10,%esp
  800cf6:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800cf9:	eb 16                	jmp    800d11 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800cfb:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800cff:	83 ec 08             	sub    $0x8,%esp
  800d02:	ff 75 0c             	pushl  0xc(%ebp)
  800d05:	50                   	push   %eax
  800d06:	8b 45 08             	mov    0x8(%ebp),%eax
  800d09:	ff d0                	call   *%eax
  800d0b:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800d0e:	ff 4d e4             	decl   -0x1c(%ebp)
  800d11:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d15:	7f e4                	jg     800cfb <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d17:	eb 34                	jmp    800d4d <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800d19:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800d1d:	74 1c                	je     800d3b <vprintfmt+0x207>
  800d1f:	83 fb 1f             	cmp    $0x1f,%ebx
  800d22:	7e 05                	jle    800d29 <vprintfmt+0x1f5>
  800d24:	83 fb 7e             	cmp    $0x7e,%ebx
  800d27:	7e 12                	jle    800d3b <vprintfmt+0x207>
					putch('?', putdat);
  800d29:	83 ec 08             	sub    $0x8,%esp
  800d2c:	ff 75 0c             	pushl  0xc(%ebp)
  800d2f:	6a 3f                	push   $0x3f
  800d31:	8b 45 08             	mov    0x8(%ebp),%eax
  800d34:	ff d0                	call   *%eax
  800d36:	83 c4 10             	add    $0x10,%esp
  800d39:	eb 0f                	jmp    800d4a <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800d3b:	83 ec 08             	sub    $0x8,%esp
  800d3e:	ff 75 0c             	pushl  0xc(%ebp)
  800d41:	53                   	push   %ebx
  800d42:	8b 45 08             	mov    0x8(%ebp),%eax
  800d45:	ff d0                	call   *%eax
  800d47:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d4a:	ff 4d e4             	decl   -0x1c(%ebp)
  800d4d:	89 f0                	mov    %esi,%eax
  800d4f:	8d 70 01             	lea    0x1(%eax),%esi
  800d52:	8a 00                	mov    (%eax),%al
  800d54:	0f be d8             	movsbl %al,%ebx
  800d57:	85 db                	test   %ebx,%ebx
  800d59:	74 24                	je     800d7f <vprintfmt+0x24b>
  800d5b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800d5f:	78 b8                	js     800d19 <vprintfmt+0x1e5>
  800d61:	ff 4d e0             	decl   -0x20(%ebp)
  800d64:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800d68:	79 af                	jns    800d19 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d6a:	eb 13                	jmp    800d7f <vprintfmt+0x24b>
				putch(' ', putdat);
  800d6c:	83 ec 08             	sub    $0x8,%esp
  800d6f:	ff 75 0c             	pushl  0xc(%ebp)
  800d72:	6a 20                	push   $0x20
  800d74:	8b 45 08             	mov    0x8(%ebp),%eax
  800d77:	ff d0                	call   *%eax
  800d79:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d7c:	ff 4d e4             	decl   -0x1c(%ebp)
  800d7f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d83:	7f e7                	jg     800d6c <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800d85:	e9 66 01 00 00       	jmp    800ef0 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800d8a:	83 ec 08             	sub    $0x8,%esp
  800d8d:	ff 75 e8             	pushl  -0x18(%ebp)
  800d90:	8d 45 14             	lea    0x14(%ebp),%eax
  800d93:	50                   	push   %eax
  800d94:	e8 3c fd ff ff       	call   800ad5 <getint>
  800d99:	83 c4 10             	add    $0x10,%esp
  800d9c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d9f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800da2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800da5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800da8:	85 d2                	test   %edx,%edx
  800daa:	79 23                	jns    800dcf <vprintfmt+0x29b>
				putch('-', putdat);
  800dac:	83 ec 08             	sub    $0x8,%esp
  800daf:	ff 75 0c             	pushl  0xc(%ebp)
  800db2:	6a 2d                	push   $0x2d
  800db4:	8b 45 08             	mov    0x8(%ebp),%eax
  800db7:	ff d0                	call   *%eax
  800db9:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800dbc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dbf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800dc2:	f7 d8                	neg    %eax
  800dc4:	83 d2 00             	adc    $0x0,%edx
  800dc7:	f7 da                	neg    %edx
  800dc9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dcc:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800dcf:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800dd6:	e9 bc 00 00 00       	jmp    800e97 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800ddb:	83 ec 08             	sub    $0x8,%esp
  800dde:	ff 75 e8             	pushl  -0x18(%ebp)
  800de1:	8d 45 14             	lea    0x14(%ebp),%eax
  800de4:	50                   	push   %eax
  800de5:	e8 84 fc ff ff       	call   800a6e <getuint>
  800dea:	83 c4 10             	add    $0x10,%esp
  800ded:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800df0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800df3:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800dfa:	e9 98 00 00 00       	jmp    800e97 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800dff:	83 ec 08             	sub    $0x8,%esp
  800e02:	ff 75 0c             	pushl  0xc(%ebp)
  800e05:	6a 58                	push   $0x58
  800e07:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0a:	ff d0                	call   *%eax
  800e0c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e0f:	83 ec 08             	sub    $0x8,%esp
  800e12:	ff 75 0c             	pushl  0xc(%ebp)
  800e15:	6a 58                	push   $0x58
  800e17:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1a:	ff d0                	call   *%eax
  800e1c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e1f:	83 ec 08             	sub    $0x8,%esp
  800e22:	ff 75 0c             	pushl  0xc(%ebp)
  800e25:	6a 58                	push   $0x58
  800e27:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2a:	ff d0                	call   *%eax
  800e2c:	83 c4 10             	add    $0x10,%esp
			break;
  800e2f:	e9 bc 00 00 00       	jmp    800ef0 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800e34:	83 ec 08             	sub    $0x8,%esp
  800e37:	ff 75 0c             	pushl  0xc(%ebp)
  800e3a:	6a 30                	push   $0x30
  800e3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3f:	ff d0                	call   *%eax
  800e41:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800e44:	83 ec 08             	sub    $0x8,%esp
  800e47:	ff 75 0c             	pushl  0xc(%ebp)
  800e4a:	6a 78                	push   $0x78
  800e4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4f:	ff d0                	call   *%eax
  800e51:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800e54:	8b 45 14             	mov    0x14(%ebp),%eax
  800e57:	83 c0 04             	add    $0x4,%eax
  800e5a:	89 45 14             	mov    %eax,0x14(%ebp)
  800e5d:	8b 45 14             	mov    0x14(%ebp),%eax
  800e60:	83 e8 04             	sub    $0x4,%eax
  800e63:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e65:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e68:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800e6f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800e76:	eb 1f                	jmp    800e97 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800e78:	83 ec 08             	sub    $0x8,%esp
  800e7b:	ff 75 e8             	pushl  -0x18(%ebp)
  800e7e:	8d 45 14             	lea    0x14(%ebp),%eax
  800e81:	50                   	push   %eax
  800e82:	e8 e7 fb ff ff       	call   800a6e <getuint>
  800e87:	83 c4 10             	add    $0x10,%esp
  800e8a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e8d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800e90:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800e97:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800e9b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e9e:	83 ec 04             	sub    $0x4,%esp
  800ea1:	52                   	push   %edx
  800ea2:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ea5:	50                   	push   %eax
  800ea6:	ff 75 f4             	pushl  -0xc(%ebp)
  800ea9:	ff 75 f0             	pushl  -0x10(%ebp)
  800eac:	ff 75 0c             	pushl  0xc(%ebp)
  800eaf:	ff 75 08             	pushl  0x8(%ebp)
  800eb2:	e8 00 fb ff ff       	call   8009b7 <printnum>
  800eb7:	83 c4 20             	add    $0x20,%esp
			break;
  800eba:	eb 34                	jmp    800ef0 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ebc:	83 ec 08             	sub    $0x8,%esp
  800ebf:	ff 75 0c             	pushl  0xc(%ebp)
  800ec2:	53                   	push   %ebx
  800ec3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec6:	ff d0                	call   *%eax
  800ec8:	83 c4 10             	add    $0x10,%esp
			break;
  800ecb:	eb 23                	jmp    800ef0 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ecd:	83 ec 08             	sub    $0x8,%esp
  800ed0:	ff 75 0c             	pushl  0xc(%ebp)
  800ed3:	6a 25                	push   $0x25
  800ed5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed8:	ff d0                	call   *%eax
  800eda:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800edd:	ff 4d 10             	decl   0x10(%ebp)
  800ee0:	eb 03                	jmp    800ee5 <vprintfmt+0x3b1>
  800ee2:	ff 4d 10             	decl   0x10(%ebp)
  800ee5:	8b 45 10             	mov    0x10(%ebp),%eax
  800ee8:	48                   	dec    %eax
  800ee9:	8a 00                	mov    (%eax),%al
  800eeb:	3c 25                	cmp    $0x25,%al
  800eed:	75 f3                	jne    800ee2 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800eef:	90                   	nop
		}
	}
  800ef0:	e9 47 fc ff ff       	jmp    800b3c <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800ef5:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800ef6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ef9:	5b                   	pop    %ebx
  800efa:	5e                   	pop    %esi
  800efb:	5d                   	pop    %ebp
  800efc:	c3                   	ret    

00800efd <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800efd:	55                   	push   %ebp
  800efe:	89 e5                	mov    %esp,%ebp
  800f00:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800f03:	8d 45 10             	lea    0x10(%ebp),%eax
  800f06:	83 c0 04             	add    $0x4,%eax
  800f09:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800f0c:	8b 45 10             	mov    0x10(%ebp),%eax
  800f0f:	ff 75 f4             	pushl  -0xc(%ebp)
  800f12:	50                   	push   %eax
  800f13:	ff 75 0c             	pushl  0xc(%ebp)
  800f16:	ff 75 08             	pushl  0x8(%ebp)
  800f19:	e8 16 fc ff ff       	call   800b34 <vprintfmt>
  800f1e:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800f21:	90                   	nop
  800f22:	c9                   	leave  
  800f23:	c3                   	ret    

00800f24 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800f24:	55                   	push   %ebp
  800f25:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800f27:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f2a:	8b 40 08             	mov    0x8(%eax),%eax
  800f2d:	8d 50 01             	lea    0x1(%eax),%edx
  800f30:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f33:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800f36:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f39:	8b 10                	mov    (%eax),%edx
  800f3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f3e:	8b 40 04             	mov    0x4(%eax),%eax
  800f41:	39 c2                	cmp    %eax,%edx
  800f43:	73 12                	jae    800f57 <sprintputch+0x33>
		*b->buf++ = ch;
  800f45:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f48:	8b 00                	mov    (%eax),%eax
  800f4a:	8d 48 01             	lea    0x1(%eax),%ecx
  800f4d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f50:	89 0a                	mov    %ecx,(%edx)
  800f52:	8b 55 08             	mov    0x8(%ebp),%edx
  800f55:	88 10                	mov    %dl,(%eax)
}
  800f57:	90                   	nop
  800f58:	5d                   	pop    %ebp
  800f59:	c3                   	ret    

00800f5a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800f5a:	55                   	push   %ebp
  800f5b:	89 e5                	mov    %esp,%ebp
  800f5d:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800f60:	8b 45 08             	mov    0x8(%ebp),%eax
  800f63:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800f66:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f69:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6f:	01 d0                	add    %edx,%eax
  800f71:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f74:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800f7b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800f7f:	74 06                	je     800f87 <vsnprintf+0x2d>
  800f81:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f85:	7f 07                	jg     800f8e <vsnprintf+0x34>
		return -E_INVAL;
  800f87:	b8 03 00 00 00       	mov    $0x3,%eax
  800f8c:	eb 20                	jmp    800fae <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800f8e:	ff 75 14             	pushl  0x14(%ebp)
  800f91:	ff 75 10             	pushl  0x10(%ebp)
  800f94:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800f97:	50                   	push   %eax
  800f98:	68 24 0f 80 00       	push   $0x800f24
  800f9d:	e8 92 fb ff ff       	call   800b34 <vprintfmt>
  800fa2:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800fa5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800fa8:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800fab:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800fae:	c9                   	leave  
  800faf:	c3                   	ret    

00800fb0 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800fb0:	55                   	push   %ebp
  800fb1:	89 e5                	mov    %esp,%ebp
  800fb3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800fb6:	8d 45 10             	lea    0x10(%ebp),%eax
  800fb9:	83 c0 04             	add    $0x4,%eax
  800fbc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800fbf:	8b 45 10             	mov    0x10(%ebp),%eax
  800fc2:	ff 75 f4             	pushl  -0xc(%ebp)
  800fc5:	50                   	push   %eax
  800fc6:	ff 75 0c             	pushl  0xc(%ebp)
  800fc9:	ff 75 08             	pushl  0x8(%ebp)
  800fcc:	e8 89 ff ff ff       	call   800f5a <vsnprintf>
  800fd1:	83 c4 10             	add    $0x10,%esp
  800fd4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800fd7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800fda:	c9                   	leave  
  800fdb:	c3                   	ret    

00800fdc <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800fdc:	55                   	push   %ebp
  800fdd:	89 e5                	mov    %esp,%ebp
  800fdf:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800fe2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800fe9:	eb 06                	jmp    800ff1 <strlen+0x15>
		n++;
  800feb:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800fee:	ff 45 08             	incl   0x8(%ebp)
  800ff1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff4:	8a 00                	mov    (%eax),%al
  800ff6:	84 c0                	test   %al,%al
  800ff8:	75 f1                	jne    800feb <strlen+0xf>
		n++;
	return n;
  800ffa:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ffd:	c9                   	leave  
  800ffe:	c3                   	ret    

00800fff <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800fff:	55                   	push   %ebp
  801000:	89 e5                	mov    %esp,%ebp
  801002:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801005:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80100c:	eb 09                	jmp    801017 <strnlen+0x18>
		n++;
  80100e:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801011:	ff 45 08             	incl   0x8(%ebp)
  801014:	ff 4d 0c             	decl   0xc(%ebp)
  801017:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80101b:	74 09                	je     801026 <strnlen+0x27>
  80101d:	8b 45 08             	mov    0x8(%ebp),%eax
  801020:	8a 00                	mov    (%eax),%al
  801022:	84 c0                	test   %al,%al
  801024:	75 e8                	jne    80100e <strnlen+0xf>
		n++;
	return n;
  801026:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801029:	c9                   	leave  
  80102a:	c3                   	ret    

0080102b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80102b:	55                   	push   %ebp
  80102c:	89 e5                	mov    %esp,%ebp
  80102e:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801031:	8b 45 08             	mov    0x8(%ebp),%eax
  801034:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801037:	90                   	nop
  801038:	8b 45 08             	mov    0x8(%ebp),%eax
  80103b:	8d 50 01             	lea    0x1(%eax),%edx
  80103e:	89 55 08             	mov    %edx,0x8(%ebp)
  801041:	8b 55 0c             	mov    0xc(%ebp),%edx
  801044:	8d 4a 01             	lea    0x1(%edx),%ecx
  801047:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80104a:	8a 12                	mov    (%edx),%dl
  80104c:	88 10                	mov    %dl,(%eax)
  80104e:	8a 00                	mov    (%eax),%al
  801050:	84 c0                	test   %al,%al
  801052:	75 e4                	jne    801038 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801054:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801057:	c9                   	leave  
  801058:	c3                   	ret    

00801059 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801059:	55                   	push   %ebp
  80105a:	89 e5                	mov    %esp,%ebp
  80105c:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80105f:	8b 45 08             	mov    0x8(%ebp),%eax
  801062:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801065:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80106c:	eb 1f                	jmp    80108d <strncpy+0x34>
		*dst++ = *src;
  80106e:	8b 45 08             	mov    0x8(%ebp),%eax
  801071:	8d 50 01             	lea    0x1(%eax),%edx
  801074:	89 55 08             	mov    %edx,0x8(%ebp)
  801077:	8b 55 0c             	mov    0xc(%ebp),%edx
  80107a:	8a 12                	mov    (%edx),%dl
  80107c:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80107e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801081:	8a 00                	mov    (%eax),%al
  801083:	84 c0                	test   %al,%al
  801085:	74 03                	je     80108a <strncpy+0x31>
			src++;
  801087:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80108a:	ff 45 fc             	incl   -0x4(%ebp)
  80108d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801090:	3b 45 10             	cmp    0x10(%ebp),%eax
  801093:	72 d9                	jb     80106e <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801095:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801098:	c9                   	leave  
  801099:	c3                   	ret    

0080109a <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80109a:	55                   	push   %ebp
  80109b:	89 e5                	mov    %esp,%ebp
  80109d:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8010a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8010a6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010aa:	74 30                	je     8010dc <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8010ac:	eb 16                	jmp    8010c4 <strlcpy+0x2a>
			*dst++ = *src++;
  8010ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b1:	8d 50 01             	lea    0x1(%eax),%edx
  8010b4:	89 55 08             	mov    %edx,0x8(%ebp)
  8010b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010ba:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010bd:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8010c0:	8a 12                	mov    (%edx),%dl
  8010c2:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8010c4:	ff 4d 10             	decl   0x10(%ebp)
  8010c7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010cb:	74 09                	je     8010d6 <strlcpy+0x3c>
  8010cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010d0:	8a 00                	mov    (%eax),%al
  8010d2:	84 c0                	test   %al,%al
  8010d4:	75 d8                	jne    8010ae <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8010d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d9:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8010dc:	8b 55 08             	mov    0x8(%ebp),%edx
  8010df:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010e2:	29 c2                	sub    %eax,%edx
  8010e4:	89 d0                	mov    %edx,%eax
}
  8010e6:	c9                   	leave  
  8010e7:	c3                   	ret    

008010e8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8010e8:	55                   	push   %ebp
  8010e9:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8010eb:	eb 06                	jmp    8010f3 <strcmp+0xb>
		p++, q++;
  8010ed:	ff 45 08             	incl   0x8(%ebp)
  8010f0:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8010f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f6:	8a 00                	mov    (%eax),%al
  8010f8:	84 c0                	test   %al,%al
  8010fa:	74 0e                	je     80110a <strcmp+0x22>
  8010fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ff:	8a 10                	mov    (%eax),%dl
  801101:	8b 45 0c             	mov    0xc(%ebp),%eax
  801104:	8a 00                	mov    (%eax),%al
  801106:	38 c2                	cmp    %al,%dl
  801108:	74 e3                	je     8010ed <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80110a:	8b 45 08             	mov    0x8(%ebp),%eax
  80110d:	8a 00                	mov    (%eax),%al
  80110f:	0f b6 d0             	movzbl %al,%edx
  801112:	8b 45 0c             	mov    0xc(%ebp),%eax
  801115:	8a 00                	mov    (%eax),%al
  801117:	0f b6 c0             	movzbl %al,%eax
  80111a:	29 c2                	sub    %eax,%edx
  80111c:	89 d0                	mov    %edx,%eax
}
  80111e:	5d                   	pop    %ebp
  80111f:	c3                   	ret    

00801120 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801120:	55                   	push   %ebp
  801121:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801123:	eb 09                	jmp    80112e <strncmp+0xe>
		n--, p++, q++;
  801125:	ff 4d 10             	decl   0x10(%ebp)
  801128:	ff 45 08             	incl   0x8(%ebp)
  80112b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80112e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801132:	74 17                	je     80114b <strncmp+0x2b>
  801134:	8b 45 08             	mov    0x8(%ebp),%eax
  801137:	8a 00                	mov    (%eax),%al
  801139:	84 c0                	test   %al,%al
  80113b:	74 0e                	je     80114b <strncmp+0x2b>
  80113d:	8b 45 08             	mov    0x8(%ebp),%eax
  801140:	8a 10                	mov    (%eax),%dl
  801142:	8b 45 0c             	mov    0xc(%ebp),%eax
  801145:	8a 00                	mov    (%eax),%al
  801147:	38 c2                	cmp    %al,%dl
  801149:	74 da                	je     801125 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80114b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80114f:	75 07                	jne    801158 <strncmp+0x38>
		return 0;
  801151:	b8 00 00 00 00       	mov    $0x0,%eax
  801156:	eb 14                	jmp    80116c <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801158:	8b 45 08             	mov    0x8(%ebp),%eax
  80115b:	8a 00                	mov    (%eax),%al
  80115d:	0f b6 d0             	movzbl %al,%edx
  801160:	8b 45 0c             	mov    0xc(%ebp),%eax
  801163:	8a 00                	mov    (%eax),%al
  801165:	0f b6 c0             	movzbl %al,%eax
  801168:	29 c2                	sub    %eax,%edx
  80116a:	89 d0                	mov    %edx,%eax
}
  80116c:	5d                   	pop    %ebp
  80116d:	c3                   	ret    

0080116e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80116e:	55                   	push   %ebp
  80116f:	89 e5                	mov    %esp,%ebp
  801171:	83 ec 04             	sub    $0x4,%esp
  801174:	8b 45 0c             	mov    0xc(%ebp),%eax
  801177:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80117a:	eb 12                	jmp    80118e <strchr+0x20>
		if (*s == c)
  80117c:	8b 45 08             	mov    0x8(%ebp),%eax
  80117f:	8a 00                	mov    (%eax),%al
  801181:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801184:	75 05                	jne    80118b <strchr+0x1d>
			return (char *) s;
  801186:	8b 45 08             	mov    0x8(%ebp),%eax
  801189:	eb 11                	jmp    80119c <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80118b:	ff 45 08             	incl   0x8(%ebp)
  80118e:	8b 45 08             	mov    0x8(%ebp),%eax
  801191:	8a 00                	mov    (%eax),%al
  801193:	84 c0                	test   %al,%al
  801195:	75 e5                	jne    80117c <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801197:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80119c:	c9                   	leave  
  80119d:	c3                   	ret    

0080119e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80119e:	55                   	push   %ebp
  80119f:	89 e5                	mov    %esp,%ebp
  8011a1:	83 ec 04             	sub    $0x4,%esp
  8011a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a7:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8011aa:	eb 0d                	jmp    8011b9 <strfind+0x1b>
		if (*s == c)
  8011ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8011af:	8a 00                	mov    (%eax),%al
  8011b1:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8011b4:	74 0e                	je     8011c4 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8011b6:	ff 45 08             	incl   0x8(%ebp)
  8011b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011bc:	8a 00                	mov    (%eax),%al
  8011be:	84 c0                	test   %al,%al
  8011c0:	75 ea                	jne    8011ac <strfind+0xe>
  8011c2:	eb 01                	jmp    8011c5 <strfind+0x27>
		if (*s == c)
			break;
  8011c4:	90                   	nop
	return (char *) s;
  8011c5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011c8:	c9                   	leave  
  8011c9:	c3                   	ret    

008011ca <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8011ca:	55                   	push   %ebp
  8011cb:	89 e5                	mov    %esp,%ebp
  8011cd:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8011d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8011d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8011d9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8011dc:	eb 0e                	jmp    8011ec <memset+0x22>
		*p++ = c;
  8011de:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011e1:	8d 50 01             	lea    0x1(%eax),%edx
  8011e4:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011ea:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8011ec:	ff 4d f8             	decl   -0x8(%ebp)
  8011ef:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8011f3:	79 e9                	jns    8011de <memset+0x14>
		*p++ = c;

	return v;
  8011f5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011f8:	c9                   	leave  
  8011f9:	c3                   	ret    

008011fa <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8011fa:	55                   	push   %ebp
  8011fb:	89 e5                	mov    %esp,%ebp
  8011fd:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801200:	8b 45 0c             	mov    0xc(%ebp),%eax
  801203:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801206:	8b 45 08             	mov    0x8(%ebp),%eax
  801209:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  80120c:	eb 16                	jmp    801224 <memcpy+0x2a>
		*d++ = *s++;
  80120e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801211:	8d 50 01             	lea    0x1(%eax),%edx
  801214:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801217:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80121a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80121d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801220:	8a 12                	mov    (%edx),%dl
  801222:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801224:	8b 45 10             	mov    0x10(%ebp),%eax
  801227:	8d 50 ff             	lea    -0x1(%eax),%edx
  80122a:	89 55 10             	mov    %edx,0x10(%ebp)
  80122d:	85 c0                	test   %eax,%eax
  80122f:	75 dd                	jne    80120e <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801231:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801234:	c9                   	leave  
  801235:	c3                   	ret    

00801236 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801236:	55                   	push   %ebp
  801237:	89 e5                	mov    %esp,%ebp
  801239:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80123c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80123f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801242:	8b 45 08             	mov    0x8(%ebp),%eax
  801245:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801248:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80124b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80124e:	73 50                	jae    8012a0 <memmove+0x6a>
  801250:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801253:	8b 45 10             	mov    0x10(%ebp),%eax
  801256:	01 d0                	add    %edx,%eax
  801258:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80125b:	76 43                	jbe    8012a0 <memmove+0x6a>
		s += n;
  80125d:	8b 45 10             	mov    0x10(%ebp),%eax
  801260:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801263:	8b 45 10             	mov    0x10(%ebp),%eax
  801266:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801269:	eb 10                	jmp    80127b <memmove+0x45>
			*--d = *--s;
  80126b:	ff 4d f8             	decl   -0x8(%ebp)
  80126e:	ff 4d fc             	decl   -0x4(%ebp)
  801271:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801274:	8a 10                	mov    (%eax),%dl
  801276:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801279:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80127b:	8b 45 10             	mov    0x10(%ebp),%eax
  80127e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801281:	89 55 10             	mov    %edx,0x10(%ebp)
  801284:	85 c0                	test   %eax,%eax
  801286:	75 e3                	jne    80126b <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801288:	eb 23                	jmp    8012ad <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80128a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80128d:	8d 50 01             	lea    0x1(%eax),%edx
  801290:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801293:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801296:	8d 4a 01             	lea    0x1(%edx),%ecx
  801299:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80129c:	8a 12                	mov    (%edx),%dl
  80129e:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8012a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8012a3:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012a6:	89 55 10             	mov    %edx,0x10(%ebp)
  8012a9:	85 c0                	test   %eax,%eax
  8012ab:	75 dd                	jne    80128a <memmove+0x54>
			*d++ = *s++;

	return dst;
  8012ad:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012b0:	c9                   	leave  
  8012b1:	c3                   	ret    

008012b2 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8012b2:	55                   	push   %ebp
  8012b3:	89 e5                	mov    %esp,%ebp
  8012b5:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8012b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012bb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8012be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c1:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8012c4:	eb 2a                	jmp    8012f0 <memcmp+0x3e>
		if (*s1 != *s2)
  8012c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012c9:	8a 10                	mov    (%eax),%dl
  8012cb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012ce:	8a 00                	mov    (%eax),%al
  8012d0:	38 c2                	cmp    %al,%dl
  8012d2:	74 16                	je     8012ea <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8012d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012d7:	8a 00                	mov    (%eax),%al
  8012d9:	0f b6 d0             	movzbl %al,%edx
  8012dc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012df:	8a 00                	mov    (%eax),%al
  8012e1:	0f b6 c0             	movzbl %al,%eax
  8012e4:	29 c2                	sub    %eax,%edx
  8012e6:	89 d0                	mov    %edx,%eax
  8012e8:	eb 18                	jmp    801302 <memcmp+0x50>
		s1++, s2++;
  8012ea:	ff 45 fc             	incl   -0x4(%ebp)
  8012ed:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8012f0:	8b 45 10             	mov    0x10(%ebp),%eax
  8012f3:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012f6:	89 55 10             	mov    %edx,0x10(%ebp)
  8012f9:	85 c0                	test   %eax,%eax
  8012fb:	75 c9                	jne    8012c6 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8012fd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801302:	c9                   	leave  
  801303:	c3                   	ret    

00801304 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801304:	55                   	push   %ebp
  801305:	89 e5                	mov    %esp,%ebp
  801307:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80130a:	8b 55 08             	mov    0x8(%ebp),%edx
  80130d:	8b 45 10             	mov    0x10(%ebp),%eax
  801310:	01 d0                	add    %edx,%eax
  801312:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801315:	eb 15                	jmp    80132c <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801317:	8b 45 08             	mov    0x8(%ebp),%eax
  80131a:	8a 00                	mov    (%eax),%al
  80131c:	0f b6 d0             	movzbl %al,%edx
  80131f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801322:	0f b6 c0             	movzbl %al,%eax
  801325:	39 c2                	cmp    %eax,%edx
  801327:	74 0d                	je     801336 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801329:	ff 45 08             	incl   0x8(%ebp)
  80132c:	8b 45 08             	mov    0x8(%ebp),%eax
  80132f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801332:	72 e3                	jb     801317 <memfind+0x13>
  801334:	eb 01                	jmp    801337 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801336:	90                   	nop
	return (void *) s;
  801337:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80133a:	c9                   	leave  
  80133b:	c3                   	ret    

0080133c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80133c:	55                   	push   %ebp
  80133d:	89 e5                	mov    %esp,%ebp
  80133f:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801342:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801349:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801350:	eb 03                	jmp    801355 <strtol+0x19>
		s++;
  801352:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801355:	8b 45 08             	mov    0x8(%ebp),%eax
  801358:	8a 00                	mov    (%eax),%al
  80135a:	3c 20                	cmp    $0x20,%al
  80135c:	74 f4                	je     801352 <strtol+0x16>
  80135e:	8b 45 08             	mov    0x8(%ebp),%eax
  801361:	8a 00                	mov    (%eax),%al
  801363:	3c 09                	cmp    $0x9,%al
  801365:	74 eb                	je     801352 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801367:	8b 45 08             	mov    0x8(%ebp),%eax
  80136a:	8a 00                	mov    (%eax),%al
  80136c:	3c 2b                	cmp    $0x2b,%al
  80136e:	75 05                	jne    801375 <strtol+0x39>
		s++;
  801370:	ff 45 08             	incl   0x8(%ebp)
  801373:	eb 13                	jmp    801388 <strtol+0x4c>
	else if (*s == '-')
  801375:	8b 45 08             	mov    0x8(%ebp),%eax
  801378:	8a 00                	mov    (%eax),%al
  80137a:	3c 2d                	cmp    $0x2d,%al
  80137c:	75 0a                	jne    801388 <strtol+0x4c>
		s++, neg = 1;
  80137e:	ff 45 08             	incl   0x8(%ebp)
  801381:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801388:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80138c:	74 06                	je     801394 <strtol+0x58>
  80138e:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801392:	75 20                	jne    8013b4 <strtol+0x78>
  801394:	8b 45 08             	mov    0x8(%ebp),%eax
  801397:	8a 00                	mov    (%eax),%al
  801399:	3c 30                	cmp    $0x30,%al
  80139b:	75 17                	jne    8013b4 <strtol+0x78>
  80139d:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a0:	40                   	inc    %eax
  8013a1:	8a 00                	mov    (%eax),%al
  8013a3:	3c 78                	cmp    $0x78,%al
  8013a5:	75 0d                	jne    8013b4 <strtol+0x78>
		s += 2, base = 16;
  8013a7:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8013ab:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8013b2:	eb 28                	jmp    8013dc <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8013b4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013b8:	75 15                	jne    8013cf <strtol+0x93>
  8013ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bd:	8a 00                	mov    (%eax),%al
  8013bf:	3c 30                	cmp    $0x30,%al
  8013c1:	75 0c                	jne    8013cf <strtol+0x93>
		s++, base = 8;
  8013c3:	ff 45 08             	incl   0x8(%ebp)
  8013c6:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8013cd:	eb 0d                	jmp    8013dc <strtol+0xa0>
	else if (base == 0)
  8013cf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013d3:	75 07                	jne    8013dc <strtol+0xa0>
		base = 10;
  8013d5:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8013dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8013df:	8a 00                	mov    (%eax),%al
  8013e1:	3c 2f                	cmp    $0x2f,%al
  8013e3:	7e 19                	jle    8013fe <strtol+0xc2>
  8013e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e8:	8a 00                	mov    (%eax),%al
  8013ea:	3c 39                	cmp    $0x39,%al
  8013ec:	7f 10                	jg     8013fe <strtol+0xc2>
			dig = *s - '0';
  8013ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f1:	8a 00                	mov    (%eax),%al
  8013f3:	0f be c0             	movsbl %al,%eax
  8013f6:	83 e8 30             	sub    $0x30,%eax
  8013f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8013fc:	eb 42                	jmp    801440 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8013fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801401:	8a 00                	mov    (%eax),%al
  801403:	3c 60                	cmp    $0x60,%al
  801405:	7e 19                	jle    801420 <strtol+0xe4>
  801407:	8b 45 08             	mov    0x8(%ebp),%eax
  80140a:	8a 00                	mov    (%eax),%al
  80140c:	3c 7a                	cmp    $0x7a,%al
  80140e:	7f 10                	jg     801420 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801410:	8b 45 08             	mov    0x8(%ebp),%eax
  801413:	8a 00                	mov    (%eax),%al
  801415:	0f be c0             	movsbl %al,%eax
  801418:	83 e8 57             	sub    $0x57,%eax
  80141b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80141e:	eb 20                	jmp    801440 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801420:	8b 45 08             	mov    0x8(%ebp),%eax
  801423:	8a 00                	mov    (%eax),%al
  801425:	3c 40                	cmp    $0x40,%al
  801427:	7e 39                	jle    801462 <strtol+0x126>
  801429:	8b 45 08             	mov    0x8(%ebp),%eax
  80142c:	8a 00                	mov    (%eax),%al
  80142e:	3c 5a                	cmp    $0x5a,%al
  801430:	7f 30                	jg     801462 <strtol+0x126>
			dig = *s - 'A' + 10;
  801432:	8b 45 08             	mov    0x8(%ebp),%eax
  801435:	8a 00                	mov    (%eax),%al
  801437:	0f be c0             	movsbl %al,%eax
  80143a:	83 e8 37             	sub    $0x37,%eax
  80143d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801440:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801443:	3b 45 10             	cmp    0x10(%ebp),%eax
  801446:	7d 19                	jge    801461 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801448:	ff 45 08             	incl   0x8(%ebp)
  80144b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80144e:	0f af 45 10          	imul   0x10(%ebp),%eax
  801452:	89 c2                	mov    %eax,%edx
  801454:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801457:	01 d0                	add    %edx,%eax
  801459:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80145c:	e9 7b ff ff ff       	jmp    8013dc <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801461:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801462:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801466:	74 08                	je     801470 <strtol+0x134>
		*endptr = (char *) s;
  801468:	8b 45 0c             	mov    0xc(%ebp),%eax
  80146b:	8b 55 08             	mov    0x8(%ebp),%edx
  80146e:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801470:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801474:	74 07                	je     80147d <strtol+0x141>
  801476:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801479:	f7 d8                	neg    %eax
  80147b:	eb 03                	jmp    801480 <strtol+0x144>
  80147d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801480:	c9                   	leave  
  801481:	c3                   	ret    

00801482 <ltostr>:

void
ltostr(long value, char *str)
{
  801482:	55                   	push   %ebp
  801483:	89 e5                	mov    %esp,%ebp
  801485:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801488:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80148f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801496:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80149a:	79 13                	jns    8014af <ltostr+0x2d>
	{
		neg = 1;
  80149c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8014a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014a6:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8014a9:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8014ac:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8014af:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b2:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8014b7:	99                   	cltd   
  8014b8:	f7 f9                	idiv   %ecx
  8014ba:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8014bd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014c0:	8d 50 01             	lea    0x1(%eax),%edx
  8014c3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8014c6:	89 c2                	mov    %eax,%edx
  8014c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014cb:	01 d0                	add    %edx,%eax
  8014cd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8014d0:	83 c2 30             	add    $0x30,%edx
  8014d3:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8014d5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8014d8:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8014dd:	f7 e9                	imul   %ecx
  8014df:	c1 fa 02             	sar    $0x2,%edx
  8014e2:	89 c8                	mov    %ecx,%eax
  8014e4:	c1 f8 1f             	sar    $0x1f,%eax
  8014e7:	29 c2                	sub    %eax,%edx
  8014e9:	89 d0                	mov    %edx,%eax
  8014eb:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8014ee:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8014f1:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8014f6:	f7 e9                	imul   %ecx
  8014f8:	c1 fa 02             	sar    $0x2,%edx
  8014fb:	89 c8                	mov    %ecx,%eax
  8014fd:	c1 f8 1f             	sar    $0x1f,%eax
  801500:	29 c2                	sub    %eax,%edx
  801502:	89 d0                	mov    %edx,%eax
  801504:	c1 e0 02             	shl    $0x2,%eax
  801507:	01 d0                	add    %edx,%eax
  801509:	01 c0                	add    %eax,%eax
  80150b:	29 c1                	sub    %eax,%ecx
  80150d:	89 ca                	mov    %ecx,%edx
  80150f:	85 d2                	test   %edx,%edx
  801511:	75 9c                	jne    8014af <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801513:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80151a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80151d:	48                   	dec    %eax
  80151e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801521:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801525:	74 3d                	je     801564 <ltostr+0xe2>
		start = 1 ;
  801527:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80152e:	eb 34                	jmp    801564 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801530:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801533:	8b 45 0c             	mov    0xc(%ebp),%eax
  801536:	01 d0                	add    %edx,%eax
  801538:	8a 00                	mov    (%eax),%al
  80153a:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80153d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801540:	8b 45 0c             	mov    0xc(%ebp),%eax
  801543:	01 c2                	add    %eax,%edx
  801545:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801548:	8b 45 0c             	mov    0xc(%ebp),%eax
  80154b:	01 c8                	add    %ecx,%eax
  80154d:	8a 00                	mov    (%eax),%al
  80154f:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801551:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801554:	8b 45 0c             	mov    0xc(%ebp),%eax
  801557:	01 c2                	add    %eax,%edx
  801559:	8a 45 eb             	mov    -0x15(%ebp),%al
  80155c:	88 02                	mov    %al,(%edx)
		start++ ;
  80155e:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801561:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801564:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801567:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80156a:	7c c4                	jl     801530 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80156c:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80156f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801572:	01 d0                	add    %edx,%eax
  801574:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801577:	90                   	nop
  801578:	c9                   	leave  
  801579:	c3                   	ret    

0080157a <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80157a:	55                   	push   %ebp
  80157b:	89 e5                	mov    %esp,%ebp
  80157d:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801580:	ff 75 08             	pushl  0x8(%ebp)
  801583:	e8 54 fa ff ff       	call   800fdc <strlen>
  801588:	83 c4 04             	add    $0x4,%esp
  80158b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80158e:	ff 75 0c             	pushl  0xc(%ebp)
  801591:	e8 46 fa ff ff       	call   800fdc <strlen>
  801596:	83 c4 04             	add    $0x4,%esp
  801599:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80159c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8015a3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015aa:	eb 17                	jmp    8015c3 <strcconcat+0x49>
		final[s] = str1[s] ;
  8015ac:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015af:	8b 45 10             	mov    0x10(%ebp),%eax
  8015b2:	01 c2                	add    %eax,%edx
  8015b4:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8015b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ba:	01 c8                	add    %ecx,%eax
  8015bc:	8a 00                	mov    (%eax),%al
  8015be:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8015c0:	ff 45 fc             	incl   -0x4(%ebp)
  8015c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015c6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8015c9:	7c e1                	jl     8015ac <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8015cb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8015d2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8015d9:	eb 1f                	jmp    8015fa <strcconcat+0x80>
		final[s++] = str2[i] ;
  8015db:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015de:	8d 50 01             	lea    0x1(%eax),%edx
  8015e1:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8015e4:	89 c2                	mov    %eax,%edx
  8015e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8015e9:	01 c2                	add    %eax,%edx
  8015eb:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8015ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015f1:	01 c8                	add    %ecx,%eax
  8015f3:	8a 00                	mov    (%eax),%al
  8015f5:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8015f7:	ff 45 f8             	incl   -0x8(%ebp)
  8015fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015fd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801600:	7c d9                	jl     8015db <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801602:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801605:	8b 45 10             	mov    0x10(%ebp),%eax
  801608:	01 d0                	add    %edx,%eax
  80160a:	c6 00 00             	movb   $0x0,(%eax)
}
  80160d:	90                   	nop
  80160e:	c9                   	leave  
  80160f:	c3                   	ret    

00801610 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801610:	55                   	push   %ebp
  801611:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801613:	8b 45 14             	mov    0x14(%ebp),%eax
  801616:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80161c:	8b 45 14             	mov    0x14(%ebp),%eax
  80161f:	8b 00                	mov    (%eax),%eax
  801621:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801628:	8b 45 10             	mov    0x10(%ebp),%eax
  80162b:	01 d0                	add    %edx,%eax
  80162d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801633:	eb 0c                	jmp    801641 <strsplit+0x31>
			*string++ = 0;
  801635:	8b 45 08             	mov    0x8(%ebp),%eax
  801638:	8d 50 01             	lea    0x1(%eax),%edx
  80163b:	89 55 08             	mov    %edx,0x8(%ebp)
  80163e:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801641:	8b 45 08             	mov    0x8(%ebp),%eax
  801644:	8a 00                	mov    (%eax),%al
  801646:	84 c0                	test   %al,%al
  801648:	74 18                	je     801662 <strsplit+0x52>
  80164a:	8b 45 08             	mov    0x8(%ebp),%eax
  80164d:	8a 00                	mov    (%eax),%al
  80164f:	0f be c0             	movsbl %al,%eax
  801652:	50                   	push   %eax
  801653:	ff 75 0c             	pushl  0xc(%ebp)
  801656:	e8 13 fb ff ff       	call   80116e <strchr>
  80165b:	83 c4 08             	add    $0x8,%esp
  80165e:	85 c0                	test   %eax,%eax
  801660:	75 d3                	jne    801635 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801662:	8b 45 08             	mov    0x8(%ebp),%eax
  801665:	8a 00                	mov    (%eax),%al
  801667:	84 c0                	test   %al,%al
  801669:	74 5a                	je     8016c5 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80166b:	8b 45 14             	mov    0x14(%ebp),%eax
  80166e:	8b 00                	mov    (%eax),%eax
  801670:	83 f8 0f             	cmp    $0xf,%eax
  801673:	75 07                	jne    80167c <strsplit+0x6c>
		{
			return 0;
  801675:	b8 00 00 00 00       	mov    $0x0,%eax
  80167a:	eb 66                	jmp    8016e2 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80167c:	8b 45 14             	mov    0x14(%ebp),%eax
  80167f:	8b 00                	mov    (%eax),%eax
  801681:	8d 48 01             	lea    0x1(%eax),%ecx
  801684:	8b 55 14             	mov    0x14(%ebp),%edx
  801687:	89 0a                	mov    %ecx,(%edx)
  801689:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801690:	8b 45 10             	mov    0x10(%ebp),%eax
  801693:	01 c2                	add    %eax,%edx
  801695:	8b 45 08             	mov    0x8(%ebp),%eax
  801698:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80169a:	eb 03                	jmp    80169f <strsplit+0x8f>
			string++;
  80169c:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80169f:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a2:	8a 00                	mov    (%eax),%al
  8016a4:	84 c0                	test   %al,%al
  8016a6:	74 8b                	je     801633 <strsplit+0x23>
  8016a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ab:	8a 00                	mov    (%eax),%al
  8016ad:	0f be c0             	movsbl %al,%eax
  8016b0:	50                   	push   %eax
  8016b1:	ff 75 0c             	pushl  0xc(%ebp)
  8016b4:	e8 b5 fa ff ff       	call   80116e <strchr>
  8016b9:	83 c4 08             	add    $0x8,%esp
  8016bc:	85 c0                	test   %eax,%eax
  8016be:	74 dc                	je     80169c <strsplit+0x8c>
			string++;
	}
  8016c0:	e9 6e ff ff ff       	jmp    801633 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8016c5:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8016c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8016c9:	8b 00                	mov    (%eax),%eax
  8016cb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8016d5:	01 d0                	add    %edx,%eax
  8016d7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8016dd:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8016e2:	c9                   	leave  
  8016e3:	c3                   	ret    

008016e4 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8016e4:	55                   	push   %ebp
  8016e5:	89 e5                	mov    %esp,%ebp
  8016e7:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	panic("initialize_dyn_block_system() is not implemented yet...!!");
  8016ea:	83 ec 04             	sub    $0x4,%esp
  8016ed:	68 d0 2a 80 00       	push   $0x802ad0
  8016f2:	6a 0e                	push   $0xe
  8016f4:	68 0a 2b 80 00       	push   $0x802b0a
  8016f9:	e8 a8 ef ff ff       	call   8006a6 <_panic>

008016fe <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
int FirstTimeFlag = 1;
void* malloc(uint32 size)
{
  8016fe:	55                   	push   %ebp
  8016ff:	89 e5                	mov    %esp,%ebp
  801701:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if(FirstTimeFlag)
  801704:	a1 04 30 80 00       	mov    0x803004,%eax
  801709:	85 c0                	test   %eax,%eax
  80170b:	74 0f                	je     80171c <malloc+0x1e>
	{
		initialize_dyn_block_system();
  80170d:	e8 d2 ff ff ff       	call   8016e4 <initialize_dyn_block_system>
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801712:	c7 05 04 30 80 00 00 	movl   $0x0,0x803004
  801719:	00 00 00 
	}
	if (size == 0) return NULL ;
  80171c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801720:	75 07                	jne    801729 <malloc+0x2b>
  801722:	b8 00 00 00 00       	mov    $0x0,%eax
  801727:	eb 14                	jmp    80173d <malloc+0x3f>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  801729:	83 ec 04             	sub    $0x4,%esp
  80172c:	68 18 2b 80 00       	push   $0x802b18
  801731:	6a 2e                	push   $0x2e
  801733:	68 0a 2b 80 00       	push   $0x802b0a
  801738:	e8 69 ef ff ff       	call   8006a6 <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyNEXTFIT()... to check the current strategy
}
  80173d:	c9                   	leave  
  80173e:	c3                   	ret    

0080173f <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  80173f:	55                   	push   %ebp
  801740:	89 e5                	mov    %esp,%ebp
  801742:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801745:	83 ec 04             	sub    $0x4,%esp
  801748:	68 40 2b 80 00       	push   $0x802b40
  80174d:	6a 49                	push   $0x49
  80174f:	68 0a 2b 80 00       	push   $0x802b0a
  801754:	e8 4d ef ff ff       	call   8006a6 <_panic>

00801759 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801759:	55                   	push   %ebp
  80175a:	89 e5                	mov    %esp,%ebp
  80175c:	83 ec 18             	sub    $0x18,%esp
  80175f:	8b 45 10             	mov    0x10(%ebp),%eax
  801762:	88 45 f4             	mov    %al,-0xc(%ebp)
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  801765:	83 ec 04             	sub    $0x4,%esp
  801768:	68 64 2b 80 00       	push   $0x802b64
  80176d:	6a 57                	push   $0x57
  80176f:	68 0a 2b 80 00       	push   $0x802b0a
  801774:	e8 2d ef ff ff       	call   8006a6 <_panic>

00801779 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801779:	55                   	push   %ebp
  80177a:	89 e5                	mov    %esp,%ebp
  80177c:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  80177f:	83 ec 04             	sub    $0x4,%esp
  801782:	68 8c 2b 80 00       	push   $0x802b8c
  801787:	6a 60                	push   $0x60
  801789:	68 0a 2b 80 00       	push   $0x802b0a
  80178e:	e8 13 ef ff ff       	call   8006a6 <_panic>

00801793 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801793:	55                   	push   %ebp
  801794:	89 e5                	mov    %esp,%ebp
  801796:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801799:	83 ec 04             	sub    $0x4,%esp
  80179c:	68 b0 2b 80 00       	push   $0x802bb0
  8017a1:	6a 7c                	push   $0x7c
  8017a3:	68 0a 2b 80 00       	push   $0x802b0a
  8017a8:	e8 f9 ee ff ff       	call   8006a6 <_panic>

008017ad <sfree>:

//=================================
// FREE SHARED VARIABLE:
//=================================
void sfree(void* virtual_address)
{
  8017ad:	55                   	push   %ebp
  8017ae:	89 e5                	mov    %esp,%ebp
  8017b0:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8017b3:	83 ec 04             	sub    $0x4,%esp
  8017b6:	68 d8 2b 80 00       	push   $0x802bd8
  8017bb:	68 86 00 00 00       	push   $0x86
  8017c0:	68 0a 2b 80 00       	push   $0x802b0a
  8017c5:	e8 dc ee ff ff       	call   8006a6 <_panic>

008017ca <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8017ca:	55                   	push   %ebp
  8017cb:	89 e5                	mov    %esp,%ebp
  8017cd:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017d0:	83 ec 04             	sub    $0x4,%esp
  8017d3:	68 fc 2b 80 00       	push   $0x802bfc
  8017d8:	68 91 00 00 00       	push   $0x91
  8017dd:	68 0a 2b 80 00       	push   $0x802b0a
  8017e2:	e8 bf ee ff ff       	call   8006a6 <_panic>

008017e7 <shrink>:

}
void shrink(uint32 newSize)
{
  8017e7:	55                   	push   %ebp
  8017e8:	89 e5                	mov    %esp,%ebp
  8017ea:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017ed:	83 ec 04             	sub    $0x4,%esp
  8017f0:	68 fc 2b 80 00       	push   $0x802bfc
  8017f5:	68 96 00 00 00       	push   $0x96
  8017fa:	68 0a 2b 80 00       	push   $0x802b0a
  8017ff:	e8 a2 ee ff ff       	call   8006a6 <_panic>

00801804 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801804:	55                   	push   %ebp
  801805:	89 e5                	mov    %esp,%ebp
  801807:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80180a:	83 ec 04             	sub    $0x4,%esp
  80180d:	68 fc 2b 80 00       	push   $0x802bfc
  801812:	68 9b 00 00 00       	push   $0x9b
  801817:	68 0a 2b 80 00       	push   $0x802b0a
  80181c:	e8 85 ee ff ff       	call   8006a6 <_panic>

00801821 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801821:	55                   	push   %ebp
  801822:	89 e5                	mov    %esp,%ebp
  801824:	57                   	push   %edi
  801825:	56                   	push   %esi
  801826:	53                   	push   %ebx
  801827:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80182a:	8b 45 08             	mov    0x8(%ebp),%eax
  80182d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801830:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801833:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801836:	8b 7d 18             	mov    0x18(%ebp),%edi
  801839:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80183c:	cd 30                	int    $0x30
  80183e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801841:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801844:	83 c4 10             	add    $0x10,%esp
  801847:	5b                   	pop    %ebx
  801848:	5e                   	pop    %esi
  801849:	5f                   	pop    %edi
  80184a:	5d                   	pop    %ebp
  80184b:	c3                   	ret    

0080184c <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80184c:	55                   	push   %ebp
  80184d:	89 e5                	mov    %esp,%ebp
  80184f:	83 ec 04             	sub    $0x4,%esp
  801852:	8b 45 10             	mov    0x10(%ebp),%eax
  801855:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801858:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80185c:	8b 45 08             	mov    0x8(%ebp),%eax
  80185f:	6a 00                	push   $0x0
  801861:	6a 00                	push   $0x0
  801863:	52                   	push   %edx
  801864:	ff 75 0c             	pushl  0xc(%ebp)
  801867:	50                   	push   %eax
  801868:	6a 00                	push   $0x0
  80186a:	e8 b2 ff ff ff       	call   801821 <syscall>
  80186f:	83 c4 18             	add    $0x18,%esp
}
  801872:	90                   	nop
  801873:	c9                   	leave  
  801874:	c3                   	ret    

00801875 <sys_cgetc>:

int
sys_cgetc(void)
{
  801875:	55                   	push   %ebp
  801876:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801878:	6a 00                	push   $0x0
  80187a:	6a 00                	push   $0x0
  80187c:	6a 00                	push   $0x0
  80187e:	6a 00                	push   $0x0
  801880:	6a 00                	push   $0x0
  801882:	6a 01                	push   $0x1
  801884:	e8 98 ff ff ff       	call   801821 <syscall>
  801889:	83 c4 18             	add    $0x18,%esp
}
  80188c:	c9                   	leave  
  80188d:	c3                   	ret    

0080188e <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80188e:	55                   	push   %ebp
  80188f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801891:	8b 55 0c             	mov    0xc(%ebp),%edx
  801894:	8b 45 08             	mov    0x8(%ebp),%eax
  801897:	6a 00                	push   $0x0
  801899:	6a 00                	push   $0x0
  80189b:	6a 00                	push   $0x0
  80189d:	52                   	push   %edx
  80189e:	50                   	push   %eax
  80189f:	6a 05                	push   $0x5
  8018a1:	e8 7b ff ff ff       	call   801821 <syscall>
  8018a6:	83 c4 18             	add    $0x18,%esp
}
  8018a9:	c9                   	leave  
  8018aa:	c3                   	ret    

008018ab <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8018ab:	55                   	push   %ebp
  8018ac:	89 e5                	mov    %esp,%ebp
  8018ae:	56                   	push   %esi
  8018af:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8018b0:	8b 75 18             	mov    0x18(%ebp),%esi
  8018b3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018b6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8018bf:	56                   	push   %esi
  8018c0:	53                   	push   %ebx
  8018c1:	51                   	push   %ecx
  8018c2:	52                   	push   %edx
  8018c3:	50                   	push   %eax
  8018c4:	6a 06                	push   $0x6
  8018c6:	e8 56 ff ff ff       	call   801821 <syscall>
  8018cb:	83 c4 18             	add    $0x18,%esp
}
  8018ce:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018d1:	5b                   	pop    %ebx
  8018d2:	5e                   	pop    %esi
  8018d3:	5d                   	pop    %ebp
  8018d4:	c3                   	ret    

008018d5 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8018d5:	55                   	push   %ebp
  8018d6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8018d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018db:	8b 45 08             	mov    0x8(%ebp),%eax
  8018de:	6a 00                	push   $0x0
  8018e0:	6a 00                	push   $0x0
  8018e2:	6a 00                	push   $0x0
  8018e4:	52                   	push   %edx
  8018e5:	50                   	push   %eax
  8018e6:	6a 07                	push   $0x7
  8018e8:	e8 34 ff ff ff       	call   801821 <syscall>
  8018ed:	83 c4 18             	add    $0x18,%esp
}
  8018f0:	c9                   	leave  
  8018f1:	c3                   	ret    

008018f2 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8018f2:	55                   	push   %ebp
  8018f3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8018f5:	6a 00                	push   $0x0
  8018f7:	6a 00                	push   $0x0
  8018f9:	6a 00                	push   $0x0
  8018fb:	ff 75 0c             	pushl  0xc(%ebp)
  8018fe:	ff 75 08             	pushl  0x8(%ebp)
  801901:	6a 08                	push   $0x8
  801903:	e8 19 ff ff ff       	call   801821 <syscall>
  801908:	83 c4 18             	add    $0x18,%esp
}
  80190b:	c9                   	leave  
  80190c:	c3                   	ret    

0080190d <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80190d:	55                   	push   %ebp
  80190e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801910:	6a 00                	push   $0x0
  801912:	6a 00                	push   $0x0
  801914:	6a 00                	push   $0x0
  801916:	6a 00                	push   $0x0
  801918:	6a 00                	push   $0x0
  80191a:	6a 09                	push   $0x9
  80191c:	e8 00 ff ff ff       	call   801821 <syscall>
  801921:	83 c4 18             	add    $0x18,%esp
}
  801924:	c9                   	leave  
  801925:	c3                   	ret    

00801926 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801926:	55                   	push   %ebp
  801927:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801929:	6a 00                	push   $0x0
  80192b:	6a 00                	push   $0x0
  80192d:	6a 00                	push   $0x0
  80192f:	6a 00                	push   $0x0
  801931:	6a 00                	push   $0x0
  801933:	6a 0a                	push   $0xa
  801935:	e8 e7 fe ff ff       	call   801821 <syscall>
  80193a:	83 c4 18             	add    $0x18,%esp
}
  80193d:	c9                   	leave  
  80193e:	c3                   	ret    

0080193f <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80193f:	55                   	push   %ebp
  801940:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801942:	6a 00                	push   $0x0
  801944:	6a 00                	push   $0x0
  801946:	6a 00                	push   $0x0
  801948:	6a 00                	push   $0x0
  80194a:	6a 00                	push   $0x0
  80194c:	6a 0b                	push   $0xb
  80194e:	e8 ce fe ff ff       	call   801821 <syscall>
  801953:	83 c4 18             	add    $0x18,%esp
}
  801956:	c9                   	leave  
  801957:	c3                   	ret    

00801958 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801958:	55                   	push   %ebp
  801959:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80195b:	6a 00                	push   $0x0
  80195d:	6a 00                	push   $0x0
  80195f:	6a 00                	push   $0x0
  801961:	ff 75 0c             	pushl  0xc(%ebp)
  801964:	ff 75 08             	pushl  0x8(%ebp)
  801967:	6a 0f                	push   $0xf
  801969:	e8 b3 fe ff ff       	call   801821 <syscall>
  80196e:	83 c4 18             	add    $0x18,%esp
	return;
  801971:	90                   	nop
}
  801972:	c9                   	leave  
  801973:	c3                   	ret    

00801974 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801974:	55                   	push   %ebp
  801975:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801977:	6a 00                	push   $0x0
  801979:	6a 00                	push   $0x0
  80197b:	6a 00                	push   $0x0
  80197d:	ff 75 0c             	pushl  0xc(%ebp)
  801980:	ff 75 08             	pushl  0x8(%ebp)
  801983:	6a 10                	push   $0x10
  801985:	e8 97 fe ff ff       	call   801821 <syscall>
  80198a:	83 c4 18             	add    $0x18,%esp
	return ;
  80198d:	90                   	nop
}
  80198e:	c9                   	leave  
  80198f:	c3                   	ret    

00801990 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801990:	55                   	push   %ebp
  801991:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801993:	6a 00                	push   $0x0
  801995:	6a 00                	push   $0x0
  801997:	ff 75 10             	pushl  0x10(%ebp)
  80199a:	ff 75 0c             	pushl  0xc(%ebp)
  80199d:	ff 75 08             	pushl  0x8(%ebp)
  8019a0:	6a 11                	push   $0x11
  8019a2:	e8 7a fe ff ff       	call   801821 <syscall>
  8019a7:	83 c4 18             	add    $0x18,%esp
	return ;
  8019aa:	90                   	nop
}
  8019ab:	c9                   	leave  
  8019ac:	c3                   	ret    

008019ad <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8019ad:	55                   	push   %ebp
  8019ae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8019b0:	6a 00                	push   $0x0
  8019b2:	6a 00                	push   $0x0
  8019b4:	6a 00                	push   $0x0
  8019b6:	6a 00                	push   $0x0
  8019b8:	6a 00                	push   $0x0
  8019ba:	6a 0c                	push   $0xc
  8019bc:	e8 60 fe ff ff       	call   801821 <syscall>
  8019c1:	83 c4 18             	add    $0x18,%esp
}
  8019c4:	c9                   	leave  
  8019c5:	c3                   	ret    

008019c6 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8019c6:	55                   	push   %ebp
  8019c7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8019c9:	6a 00                	push   $0x0
  8019cb:	6a 00                	push   $0x0
  8019cd:	6a 00                	push   $0x0
  8019cf:	6a 00                	push   $0x0
  8019d1:	ff 75 08             	pushl  0x8(%ebp)
  8019d4:	6a 0d                	push   $0xd
  8019d6:	e8 46 fe ff ff       	call   801821 <syscall>
  8019db:	83 c4 18             	add    $0x18,%esp
}
  8019de:	c9                   	leave  
  8019df:	c3                   	ret    

008019e0 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8019e0:	55                   	push   %ebp
  8019e1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8019e3:	6a 00                	push   $0x0
  8019e5:	6a 00                	push   $0x0
  8019e7:	6a 00                	push   $0x0
  8019e9:	6a 00                	push   $0x0
  8019eb:	6a 00                	push   $0x0
  8019ed:	6a 0e                	push   $0xe
  8019ef:	e8 2d fe ff ff       	call   801821 <syscall>
  8019f4:	83 c4 18             	add    $0x18,%esp
}
  8019f7:	90                   	nop
  8019f8:	c9                   	leave  
  8019f9:	c3                   	ret    

008019fa <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8019fa:	55                   	push   %ebp
  8019fb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8019fd:	6a 00                	push   $0x0
  8019ff:	6a 00                	push   $0x0
  801a01:	6a 00                	push   $0x0
  801a03:	6a 00                	push   $0x0
  801a05:	6a 00                	push   $0x0
  801a07:	6a 13                	push   $0x13
  801a09:	e8 13 fe ff ff       	call   801821 <syscall>
  801a0e:	83 c4 18             	add    $0x18,%esp
}
  801a11:	90                   	nop
  801a12:	c9                   	leave  
  801a13:	c3                   	ret    

00801a14 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801a14:	55                   	push   %ebp
  801a15:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801a17:	6a 00                	push   $0x0
  801a19:	6a 00                	push   $0x0
  801a1b:	6a 00                	push   $0x0
  801a1d:	6a 00                	push   $0x0
  801a1f:	6a 00                	push   $0x0
  801a21:	6a 14                	push   $0x14
  801a23:	e8 f9 fd ff ff       	call   801821 <syscall>
  801a28:	83 c4 18             	add    $0x18,%esp
}
  801a2b:	90                   	nop
  801a2c:	c9                   	leave  
  801a2d:	c3                   	ret    

00801a2e <sys_cputc>:


void
sys_cputc(const char c)
{
  801a2e:	55                   	push   %ebp
  801a2f:	89 e5                	mov    %esp,%ebp
  801a31:	83 ec 04             	sub    $0x4,%esp
  801a34:	8b 45 08             	mov    0x8(%ebp),%eax
  801a37:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801a3a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a3e:	6a 00                	push   $0x0
  801a40:	6a 00                	push   $0x0
  801a42:	6a 00                	push   $0x0
  801a44:	6a 00                	push   $0x0
  801a46:	50                   	push   %eax
  801a47:	6a 15                	push   $0x15
  801a49:	e8 d3 fd ff ff       	call   801821 <syscall>
  801a4e:	83 c4 18             	add    $0x18,%esp
}
  801a51:	90                   	nop
  801a52:	c9                   	leave  
  801a53:	c3                   	ret    

00801a54 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a54:	55                   	push   %ebp
  801a55:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a57:	6a 00                	push   $0x0
  801a59:	6a 00                	push   $0x0
  801a5b:	6a 00                	push   $0x0
  801a5d:	6a 00                	push   $0x0
  801a5f:	6a 00                	push   $0x0
  801a61:	6a 16                	push   $0x16
  801a63:	e8 b9 fd ff ff       	call   801821 <syscall>
  801a68:	83 c4 18             	add    $0x18,%esp
}
  801a6b:	90                   	nop
  801a6c:	c9                   	leave  
  801a6d:	c3                   	ret    

00801a6e <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801a6e:	55                   	push   %ebp
  801a6f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801a71:	8b 45 08             	mov    0x8(%ebp),%eax
  801a74:	6a 00                	push   $0x0
  801a76:	6a 00                	push   $0x0
  801a78:	6a 00                	push   $0x0
  801a7a:	ff 75 0c             	pushl  0xc(%ebp)
  801a7d:	50                   	push   %eax
  801a7e:	6a 17                	push   $0x17
  801a80:	e8 9c fd ff ff       	call   801821 <syscall>
  801a85:	83 c4 18             	add    $0x18,%esp
}
  801a88:	c9                   	leave  
  801a89:	c3                   	ret    

00801a8a <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801a8a:	55                   	push   %ebp
  801a8b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a8d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a90:	8b 45 08             	mov    0x8(%ebp),%eax
  801a93:	6a 00                	push   $0x0
  801a95:	6a 00                	push   $0x0
  801a97:	6a 00                	push   $0x0
  801a99:	52                   	push   %edx
  801a9a:	50                   	push   %eax
  801a9b:	6a 1a                	push   $0x1a
  801a9d:	e8 7f fd ff ff       	call   801821 <syscall>
  801aa2:	83 c4 18             	add    $0x18,%esp
}
  801aa5:	c9                   	leave  
  801aa6:	c3                   	ret    

00801aa7 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801aa7:	55                   	push   %ebp
  801aa8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801aaa:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aad:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab0:	6a 00                	push   $0x0
  801ab2:	6a 00                	push   $0x0
  801ab4:	6a 00                	push   $0x0
  801ab6:	52                   	push   %edx
  801ab7:	50                   	push   %eax
  801ab8:	6a 18                	push   $0x18
  801aba:	e8 62 fd ff ff       	call   801821 <syscall>
  801abf:	83 c4 18             	add    $0x18,%esp
}
  801ac2:	90                   	nop
  801ac3:	c9                   	leave  
  801ac4:	c3                   	ret    

00801ac5 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801ac5:	55                   	push   %ebp
  801ac6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ac8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801acb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ace:	6a 00                	push   $0x0
  801ad0:	6a 00                	push   $0x0
  801ad2:	6a 00                	push   $0x0
  801ad4:	52                   	push   %edx
  801ad5:	50                   	push   %eax
  801ad6:	6a 19                	push   $0x19
  801ad8:	e8 44 fd ff ff       	call   801821 <syscall>
  801add:	83 c4 18             	add    $0x18,%esp
}
  801ae0:	90                   	nop
  801ae1:	c9                   	leave  
  801ae2:	c3                   	ret    

00801ae3 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801ae3:	55                   	push   %ebp
  801ae4:	89 e5                	mov    %esp,%ebp
  801ae6:	83 ec 04             	sub    $0x4,%esp
  801ae9:	8b 45 10             	mov    0x10(%ebp),%eax
  801aec:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801aef:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801af2:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801af6:	8b 45 08             	mov    0x8(%ebp),%eax
  801af9:	6a 00                	push   $0x0
  801afb:	51                   	push   %ecx
  801afc:	52                   	push   %edx
  801afd:	ff 75 0c             	pushl  0xc(%ebp)
  801b00:	50                   	push   %eax
  801b01:	6a 1b                	push   $0x1b
  801b03:	e8 19 fd ff ff       	call   801821 <syscall>
  801b08:	83 c4 18             	add    $0x18,%esp
}
  801b0b:	c9                   	leave  
  801b0c:	c3                   	ret    

00801b0d <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801b0d:	55                   	push   %ebp
  801b0e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b10:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b13:	8b 45 08             	mov    0x8(%ebp),%eax
  801b16:	6a 00                	push   $0x0
  801b18:	6a 00                	push   $0x0
  801b1a:	6a 00                	push   $0x0
  801b1c:	52                   	push   %edx
  801b1d:	50                   	push   %eax
  801b1e:	6a 1c                	push   $0x1c
  801b20:	e8 fc fc ff ff       	call   801821 <syscall>
  801b25:	83 c4 18             	add    $0x18,%esp
}
  801b28:	c9                   	leave  
  801b29:	c3                   	ret    

00801b2a <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801b2a:	55                   	push   %ebp
  801b2b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801b2d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b30:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b33:	8b 45 08             	mov    0x8(%ebp),%eax
  801b36:	6a 00                	push   $0x0
  801b38:	6a 00                	push   $0x0
  801b3a:	51                   	push   %ecx
  801b3b:	52                   	push   %edx
  801b3c:	50                   	push   %eax
  801b3d:	6a 1d                	push   $0x1d
  801b3f:	e8 dd fc ff ff       	call   801821 <syscall>
  801b44:	83 c4 18             	add    $0x18,%esp
}
  801b47:	c9                   	leave  
  801b48:	c3                   	ret    

00801b49 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801b49:	55                   	push   %ebp
  801b4a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b4c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b52:	6a 00                	push   $0x0
  801b54:	6a 00                	push   $0x0
  801b56:	6a 00                	push   $0x0
  801b58:	52                   	push   %edx
  801b59:	50                   	push   %eax
  801b5a:	6a 1e                	push   $0x1e
  801b5c:	e8 c0 fc ff ff       	call   801821 <syscall>
  801b61:	83 c4 18             	add    $0x18,%esp
}
  801b64:	c9                   	leave  
  801b65:	c3                   	ret    

00801b66 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801b66:	55                   	push   %ebp
  801b67:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801b69:	6a 00                	push   $0x0
  801b6b:	6a 00                	push   $0x0
  801b6d:	6a 00                	push   $0x0
  801b6f:	6a 00                	push   $0x0
  801b71:	6a 00                	push   $0x0
  801b73:	6a 1f                	push   $0x1f
  801b75:	e8 a7 fc ff ff       	call   801821 <syscall>
  801b7a:	83 c4 18             	add    $0x18,%esp
}
  801b7d:	c9                   	leave  
  801b7e:	c3                   	ret    

00801b7f <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801b7f:	55                   	push   %ebp
  801b80:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801b82:	8b 45 08             	mov    0x8(%ebp),%eax
  801b85:	6a 00                	push   $0x0
  801b87:	ff 75 14             	pushl  0x14(%ebp)
  801b8a:	ff 75 10             	pushl  0x10(%ebp)
  801b8d:	ff 75 0c             	pushl  0xc(%ebp)
  801b90:	50                   	push   %eax
  801b91:	6a 20                	push   $0x20
  801b93:	e8 89 fc ff ff       	call   801821 <syscall>
  801b98:	83 c4 18             	add    $0x18,%esp
}
  801b9b:	c9                   	leave  
  801b9c:	c3                   	ret    

00801b9d <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801b9d:	55                   	push   %ebp
  801b9e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801ba0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba3:	6a 00                	push   $0x0
  801ba5:	6a 00                	push   $0x0
  801ba7:	6a 00                	push   $0x0
  801ba9:	6a 00                	push   $0x0
  801bab:	50                   	push   %eax
  801bac:	6a 21                	push   $0x21
  801bae:	e8 6e fc ff ff       	call   801821 <syscall>
  801bb3:	83 c4 18             	add    $0x18,%esp
}
  801bb6:	90                   	nop
  801bb7:	c9                   	leave  
  801bb8:	c3                   	ret    

00801bb9 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801bb9:	55                   	push   %ebp
  801bba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801bbc:	8b 45 08             	mov    0x8(%ebp),%eax
  801bbf:	6a 00                	push   $0x0
  801bc1:	6a 00                	push   $0x0
  801bc3:	6a 00                	push   $0x0
  801bc5:	6a 00                	push   $0x0
  801bc7:	50                   	push   %eax
  801bc8:	6a 22                	push   $0x22
  801bca:	e8 52 fc ff ff       	call   801821 <syscall>
  801bcf:	83 c4 18             	add    $0x18,%esp
}
  801bd2:	c9                   	leave  
  801bd3:	c3                   	ret    

00801bd4 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801bd4:	55                   	push   %ebp
  801bd5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801bd7:	6a 00                	push   $0x0
  801bd9:	6a 00                	push   $0x0
  801bdb:	6a 00                	push   $0x0
  801bdd:	6a 00                	push   $0x0
  801bdf:	6a 00                	push   $0x0
  801be1:	6a 02                	push   $0x2
  801be3:	e8 39 fc ff ff       	call   801821 <syscall>
  801be8:	83 c4 18             	add    $0x18,%esp
}
  801beb:	c9                   	leave  
  801bec:	c3                   	ret    

00801bed <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801bed:	55                   	push   %ebp
  801bee:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801bf0:	6a 00                	push   $0x0
  801bf2:	6a 00                	push   $0x0
  801bf4:	6a 00                	push   $0x0
  801bf6:	6a 00                	push   $0x0
  801bf8:	6a 00                	push   $0x0
  801bfa:	6a 03                	push   $0x3
  801bfc:	e8 20 fc ff ff       	call   801821 <syscall>
  801c01:	83 c4 18             	add    $0x18,%esp
}
  801c04:	c9                   	leave  
  801c05:	c3                   	ret    

00801c06 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c06:	55                   	push   %ebp
  801c07:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c09:	6a 00                	push   $0x0
  801c0b:	6a 00                	push   $0x0
  801c0d:	6a 00                	push   $0x0
  801c0f:	6a 00                	push   $0x0
  801c11:	6a 00                	push   $0x0
  801c13:	6a 04                	push   $0x4
  801c15:	e8 07 fc ff ff       	call   801821 <syscall>
  801c1a:	83 c4 18             	add    $0x18,%esp
}
  801c1d:	c9                   	leave  
  801c1e:	c3                   	ret    

00801c1f <sys_exit_env>:


void sys_exit_env(void)
{
  801c1f:	55                   	push   %ebp
  801c20:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801c22:	6a 00                	push   $0x0
  801c24:	6a 00                	push   $0x0
  801c26:	6a 00                	push   $0x0
  801c28:	6a 00                	push   $0x0
  801c2a:	6a 00                	push   $0x0
  801c2c:	6a 23                	push   $0x23
  801c2e:	e8 ee fb ff ff       	call   801821 <syscall>
  801c33:	83 c4 18             	add    $0x18,%esp
}
  801c36:	90                   	nop
  801c37:	c9                   	leave  
  801c38:	c3                   	ret    

00801c39 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801c39:	55                   	push   %ebp
  801c3a:	89 e5                	mov    %esp,%ebp
  801c3c:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c3f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c42:	8d 50 04             	lea    0x4(%eax),%edx
  801c45:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c48:	6a 00                	push   $0x0
  801c4a:	6a 00                	push   $0x0
  801c4c:	6a 00                	push   $0x0
  801c4e:	52                   	push   %edx
  801c4f:	50                   	push   %eax
  801c50:	6a 24                	push   $0x24
  801c52:	e8 ca fb ff ff       	call   801821 <syscall>
  801c57:	83 c4 18             	add    $0x18,%esp
	return result;
  801c5a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c5d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c60:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c63:	89 01                	mov    %eax,(%ecx)
  801c65:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c68:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6b:	c9                   	leave  
  801c6c:	c2 04 00             	ret    $0x4

00801c6f <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c6f:	55                   	push   %ebp
  801c70:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801c72:	6a 00                	push   $0x0
  801c74:	6a 00                	push   $0x0
  801c76:	ff 75 10             	pushl  0x10(%ebp)
  801c79:	ff 75 0c             	pushl  0xc(%ebp)
  801c7c:	ff 75 08             	pushl  0x8(%ebp)
  801c7f:	6a 12                	push   $0x12
  801c81:	e8 9b fb ff ff       	call   801821 <syscall>
  801c86:	83 c4 18             	add    $0x18,%esp
	return ;
  801c89:	90                   	nop
}
  801c8a:	c9                   	leave  
  801c8b:	c3                   	ret    

00801c8c <sys_rcr2>:
uint32 sys_rcr2()
{
  801c8c:	55                   	push   %ebp
  801c8d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801c8f:	6a 00                	push   $0x0
  801c91:	6a 00                	push   $0x0
  801c93:	6a 00                	push   $0x0
  801c95:	6a 00                	push   $0x0
  801c97:	6a 00                	push   $0x0
  801c99:	6a 25                	push   $0x25
  801c9b:	e8 81 fb ff ff       	call   801821 <syscall>
  801ca0:	83 c4 18             	add    $0x18,%esp
}
  801ca3:	c9                   	leave  
  801ca4:	c3                   	ret    

00801ca5 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801ca5:	55                   	push   %ebp
  801ca6:	89 e5                	mov    %esp,%ebp
  801ca8:	83 ec 04             	sub    $0x4,%esp
  801cab:	8b 45 08             	mov    0x8(%ebp),%eax
  801cae:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801cb1:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801cb5:	6a 00                	push   $0x0
  801cb7:	6a 00                	push   $0x0
  801cb9:	6a 00                	push   $0x0
  801cbb:	6a 00                	push   $0x0
  801cbd:	50                   	push   %eax
  801cbe:	6a 26                	push   $0x26
  801cc0:	e8 5c fb ff ff       	call   801821 <syscall>
  801cc5:	83 c4 18             	add    $0x18,%esp
	return ;
  801cc8:	90                   	nop
}
  801cc9:	c9                   	leave  
  801cca:	c3                   	ret    

00801ccb <rsttst>:
void rsttst()
{
  801ccb:	55                   	push   %ebp
  801ccc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801cce:	6a 00                	push   $0x0
  801cd0:	6a 00                	push   $0x0
  801cd2:	6a 00                	push   $0x0
  801cd4:	6a 00                	push   $0x0
  801cd6:	6a 00                	push   $0x0
  801cd8:	6a 28                	push   $0x28
  801cda:	e8 42 fb ff ff       	call   801821 <syscall>
  801cdf:	83 c4 18             	add    $0x18,%esp
	return ;
  801ce2:	90                   	nop
}
  801ce3:	c9                   	leave  
  801ce4:	c3                   	ret    

00801ce5 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801ce5:	55                   	push   %ebp
  801ce6:	89 e5                	mov    %esp,%ebp
  801ce8:	83 ec 04             	sub    $0x4,%esp
  801ceb:	8b 45 14             	mov    0x14(%ebp),%eax
  801cee:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801cf1:	8b 55 18             	mov    0x18(%ebp),%edx
  801cf4:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801cf8:	52                   	push   %edx
  801cf9:	50                   	push   %eax
  801cfa:	ff 75 10             	pushl  0x10(%ebp)
  801cfd:	ff 75 0c             	pushl  0xc(%ebp)
  801d00:	ff 75 08             	pushl  0x8(%ebp)
  801d03:	6a 27                	push   $0x27
  801d05:	e8 17 fb ff ff       	call   801821 <syscall>
  801d0a:	83 c4 18             	add    $0x18,%esp
	return ;
  801d0d:	90                   	nop
}
  801d0e:	c9                   	leave  
  801d0f:	c3                   	ret    

00801d10 <chktst>:
void chktst(uint32 n)
{
  801d10:	55                   	push   %ebp
  801d11:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d13:	6a 00                	push   $0x0
  801d15:	6a 00                	push   $0x0
  801d17:	6a 00                	push   $0x0
  801d19:	6a 00                	push   $0x0
  801d1b:	ff 75 08             	pushl  0x8(%ebp)
  801d1e:	6a 29                	push   $0x29
  801d20:	e8 fc fa ff ff       	call   801821 <syscall>
  801d25:	83 c4 18             	add    $0x18,%esp
	return ;
  801d28:	90                   	nop
}
  801d29:	c9                   	leave  
  801d2a:	c3                   	ret    

00801d2b <inctst>:

void inctst()
{
  801d2b:	55                   	push   %ebp
  801d2c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d2e:	6a 00                	push   $0x0
  801d30:	6a 00                	push   $0x0
  801d32:	6a 00                	push   $0x0
  801d34:	6a 00                	push   $0x0
  801d36:	6a 00                	push   $0x0
  801d38:	6a 2a                	push   $0x2a
  801d3a:	e8 e2 fa ff ff       	call   801821 <syscall>
  801d3f:	83 c4 18             	add    $0x18,%esp
	return ;
  801d42:	90                   	nop
}
  801d43:	c9                   	leave  
  801d44:	c3                   	ret    

00801d45 <gettst>:
uint32 gettst()
{
  801d45:	55                   	push   %ebp
  801d46:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d48:	6a 00                	push   $0x0
  801d4a:	6a 00                	push   $0x0
  801d4c:	6a 00                	push   $0x0
  801d4e:	6a 00                	push   $0x0
  801d50:	6a 00                	push   $0x0
  801d52:	6a 2b                	push   $0x2b
  801d54:	e8 c8 fa ff ff       	call   801821 <syscall>
  801d59:	83 c4 18             	add    $0x18,%esp
}
  801d5c:	c9                   	leave  
  801d5d:	c3                   	ret    

00801d5e <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d5e:	55                   	push   %ebp
  801d5f:	89 e5                	mov    %esp,%ebp
  801d61:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d64:	6a 00                	push   $0x0
  801d66:	6a 00                	push   $0x0
  801d68:	6a 00                	push   $0x0
  801d6a:	6a 00                	push   $0x0
  801d6c:	6a 00                	push   $0x0
  801d6e:	6a 2c                	push   $0x2c
  801d70:	e8 ac fa ff ff       	call   801821 <syscall>
  801d75:	83 c4 18             	add    $0x18,%esp
  801d78:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801d7b:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801d7f:	75 07                	jne    801d88 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801d81:	b8 01 00 00 00       	mov    $0x1,%eax
  801d86:	eb 05                	jmp    801d8d <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801d88:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d8d:	c9                   	leave  
  801d8e:	c3                   	ret    

00801d8f <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801d8f:	55                   	push   %ebp
  801d90:	89 e5                	mov    %esp,%ebp
  801d92:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d95:	6a 00                	push   $0x0
  801d97:	6a 00                	push   $0x0
  801d99:	6a 00                	push   $0x0
  801d9b:	6a 00                	push   $0x0
  801d9d:	6a 00                	push   $0x0
  801d9f:	6a 2c                	push   $0x2c
  801da1:	e8 7b fa ff ff       	call   801821 <syscall>
  801da6:	83 c4 18             	add    $0x18,%esp
  801da9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801dac:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801db0:	75 07                	jne    801db9 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801db2:	b8 01 00 00 00       	mov    $0x1,%eax
  801db7:	eb 05                	jmp    801dbe <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801db9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dbe:	c9                   	leave  
  801dbf:	c3                   	ret    

00801dc0 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801dc0:	55                   	push   %ebp
  801dc1:	89 e5                	mov    %esp,%ebp
  801dc3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dc6:	6a 00                	push   $0x0
  801dc8:	6a 00                	push   $0x0
  801dca:	6a 00                	push   $0x0
  801dcc:	6a 00                	push   $0x0
  801dce:	6a 00                	push   $0x0
  801dd0:	6a 2c                	push   $0x2c
  801dd2:	e8 4a fa ff ff       	call   801821 <syscall>
  801dd7:	83 c4 18             	add    $0x18,%esp
  801dda:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801ddd:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801de1:	75 07                	jne    801dea <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801de3:	b8 01 00 00 00       	mov    $0x1,%eax
  801de8:	eb 05                	jmp    801def <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801dea:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801def:	c9                   	leave  
  801df0:	c3                   	ret    

00801df1 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801df1:	55                   	push   %ebp
  801df2:	89 e5                	mov    %esp,%ebp
  801df4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801df7:	6a 00                	push   $0x0
  801df9:	6a 00                	push   $0x0
  801dfb:	6a 00                	push   $0x0
  801dfd:	6a 00                	push   $0x0
  801dff:	6a 00                	push   $0x0
  801e01:	6a 2c                	push   $0x2c
  801e03:	e8 19 fa ff ff       	call   801821 <syscall>
  801e08:	83 c4 18             	add    $0x18,%esp
  801e0b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801e0e:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801e12:	75 07                	jne    801e1b <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801e14:	b8 01 00 00 00       	mov    $0x1,%eax
  801e19:	eb 05                	jmp    801e20 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801e1b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e20:	c9                   	leave  
  801e21:	c3                   	ret    

00801e22 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801e22:	55                   	push   %ebp
  801e23:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e25:	6a 00                	push   $0x0
  801e27:	6a 00                	push   $0x0
  801e29:	6a 00                	push   $0x0
  801e2b:	6a 00                	push   $0x0
  801e2d:	ff 75 08             	pushl  0x8(%ebp)
  801e30:	6a 2d                	push   $0x2d
  801e32:	e8 ea f9 ff ff       	call   801821 <syscall>
  801e37:	83 c4 18             	add    $0x18,%esp
	return ;
  801e3a:	90                   	nop
}
  801e3b:	c9                   	leave  
  801e3c:	c3                   	ret    

00801e3d <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e3d:	55                   	push   %ebp
  801e3e:	89 e5                	mov    %esp,%ebp
  801e40:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e41:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e44:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e47:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e4d:	6a 00                	push   $0x0
  801e4f:	53                   	push   %ebx
  801e50:	51                   	push   %ecx
  801e51:	52                   	push   %edx
  801e52:	50                   	push   %eax
  801e53:	6a 2e                	push   $0x2e
  801e55:	e8 c7 f9 ff ff       	call   801821 <syscall>
  801e5a:	83 c4 18             	add    $0x18,%esp
}
  801e5d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e60:	c9                   	leave  
  801e61:	c3                   	ret    

00801e62 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e62:	55                   	push   %ebp
  801e63:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e65:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e68:	8b 45 08             	mov    0x8(%ebp),%eax
  801e6b:	6a 00                	push   $0x0
  801e6d:	6a 00                	push   $0x0
  801e6f:	6a 00                	push   $0x0
  801e71:	52                   	push   %edx
  801e72:	50                   	push   %eax
  801e73:	6a 2f                	push   $0x2f
  801e75:	e8 a7 f9 ff ff       	call   801821 <syscall>
  801e7a:	83 c4 18             	add    $0x18,%esp
}
  801e7d:	c9                   	leave  
  801e7e:	c3                   	ret    
  801e7f:	90                   	nop

00801e80 <__udivdi3>:
  801e80:	55                   	push   %ebp
  801e81:	57                   	push   %edi
  801e82:	56                   	push   %esi
  801e83:	53                   	push   %ebx
  801e84:	83 ec 1c             	sub    $0x1c,%esp
  801e87:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801e8b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801e8f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801e93:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801e97:	89 ca                	mov    %ecx,%edx
  801e99:	89 f8                	mov    %edi,%eax
  801e9b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801e9f:	85 f6                	test   %esi,%esi
  801ea1:	75 2d                	jne    801ed0 <__udivdi3+0x50>
  801ea3:	39 cf                	cmp    %ecx,%edi
  801ea5:	77 65                	ja     801f0c <__udivdi3+0x8c>
  801ea7:	89 fd                	mov    %edi,%ebp
  801ea9:	85 ff                	test   %edi,%edi
  801eab:	75 0b                	jne    801eb8 <__udivdi3+0x38>
  801ead:	b8 01 00 00 00       	mov    $0x1,%eax
  801eb2:	31 d2                	xor    %edx,%edx
  801eb4:	f7 f7                	div    %edi
  801eb6:	89 c5                	mov    %eax,%ebp
  801eb8:	31 d2                	xor    %edx,%edx
  801eba:	89 c8                	mov    %ecx,%eax
  801ebc:	f7 f5                	div    %ebp
  801ebe:	89 c1                	mov    %eax,%ecx
  801ec0:	89 d8                	mov    %ebx,%eax
  801ec2:	f7 f5                	div    %ebp
  801ec4:	89 cf                	mov    %ecx,%edi
  801ec6:	89 fa                	mov    %edi,%edx
  801ec8:	83 c4 1c             	add    $0x1c,%esp
  801ecb:	5b                   	pop    %ebx
  801ecc:	5e                   	pop    %esi
  801ecd:	5f                   	pop    %edi
  801ece:	5d                   	pop    %ebp
  801ecf:	c3                   	ret    
  801ed0:	39 ce                	cmp    %ecx,%esi
  801ed2:	77 28                	ja     801efc <__udivdi3+0x7c>
  801ed4:	0f bd fe             	bsr    %esi,%edi
  801ed7:	83 f7 1f             	xor    $0x1f,%edi
  801eda:	75 40                	jne    801f1c <__udivdi3+0x9c>
  801edc:	39 ce                	cmp    %ecx,%esi
  801ede:	72 0a                	jb     801eea <__udivdi3+0x6a>
  801ee0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801ee4:	0f 87 9e 00 00 00    	ja     801f88 <__udivdi3+0x108>
  801eea:	b8 01 00 00 00       	mov    $0x1,%eax
  801eef:	89 fa                	mov    %edi,%edx
  801ef1:	83 c4 1c             	add    $0x1c,%esp
  801ef4:	5b                   	pop    %ebx
  801ef5:	5e                   	pop    %esi
  801ef6:	5f                   	pop    %edi
  801ef7:	5d                   	pop    %ebp
  801ef8:	c3                   	ret    
  801ef9:	8d 76 00             	lea    0x0(%esi),%esi
  801efc:	31 ff                	xor    %edi,%edi
  801efe:	31 c0                	xor    %eax,%eax
  801f00:	89 fa                	mov    %edi,%edx
  801f02:	83 c4 1c             	add    $0x1c,%esp
  801f05:	5b                   	pop    %ebx
  801f06:	5e                   	pop    %esi
  801f07:	5f                   	pop    %edi
  801f08:	5d                   	pop    %ebp
  801f09:	c3                   	ret    
  801f0a:	66 90                	xchg   %ax,%ax
  801f0c:	89 d8                	mov    %ebx,%eax
  801f0e:	f7 f7                	div    %edi
  801f10:	31 ff                	xor    %edi,%edi
  801f12:	89 fa                	mov    %edi,%edx
  801f14:	83 c4 1c             	add    $0x1c,%esp
  801f17:	5b                   	pop    %ebx
  801f18:	5e                   	pop    %esi
  801f19:	5f                   	pop    %edi
  801f1a:	5d                   	pop    %ebp
  801f1b:	c3                   	ret    
  801f1c:	bd 20 00 00 00       	mov    $0x20,%ebp
  801f21:	89 eb                	mov    %ebp,%ebx
  801f23:	29 fb                	sub    %edi,%ebx
  801f25:	89 f9                	mov    %edi,%ecx
  801f27:	d3 e6                	shl    %cl,%esi
  801f29:	89 c5                	mov    %eax,%ebp
  801f2b:	88 d9                	mov    %bl,%cl
  801f2d:	d3 ed                	shr    %cl,%ebp
  801f2f:	89 e9                	mov    %ebp,%ecx
  801f31:	09 f1                	or     %esi,%ecx
  801f33:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801f37:	89 f9                	mov    %edi,%ecx
  801f39:	d3 e0                	shl    %cl,%eax
  801f3b:	89 c5                	mov    %eax,%ebp
  801f3d:	89 d6                	mov    %edx,%esi
  801f3f:	88 d9                	mov    %bl,%cl
  801f41:	d3 ee                	shr    %cl,%esi
  801f43:	89 f9                	mov    %edi,%ecx
  801f45:	d3 e2                	shl    %cl,%edx
  801f47:	8b 44 24 08          	mov    0x8(%esp),%eax
  801f4b:	88 d9                	mov    %bl,%cl
  801f4d:	d3 e8                	shr    %cl,%eax
  801f4f:	09 c2                	or     %eax,%edx
  801f51:	89 d0                	mov    %edx,%eax
  801f53:	89 f2                	mov    %esi,%edx
  801f55:	f7 74 24 0c          	divl   0xc(%esp)
  801f59:	89 d6                	mov    %edx,%esi
  801f5b:	89 c3                	mov    %eax,%ebx
  801f5d:	f7 e5                	mul    %ebp
  801f5f:	39 d6                	cmp    %edx,%esi
  801f61:	72 19                	jb     801f7c <__udivdi3+0xfc>
  801f63:	74 0b                	je     801f70 <__udivdi3+0xf0>
  801f65:	89 d8                	mov    %ebx,%eax
  801f67:	31 ff                	xor    %edi,%edi
  801f69:	e9 58 ff ff ff       	jmp    801ec6 <__udivdi3+0x46>
  801f6e:	66 90                	xchg   %ax,%ax
  801f70:	8b 54 24 08          	mov    0x8(%esp),%edx
  801f74:	89 f9                	mov    %edi,%ecx
  801f76:	d3 e2                	shl    %cl,%edx
  801f78:	39 c2                	cmp    %eax,%edx
  801f7a:	73 e9                	jae    801f65 <__udivdi3+0xe5>
  801f7c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801f7f:	31 ff                	xor    %edi,%edi
  801f81:	e9 40 ff ff ff       	jmp    801ec6 <__udivdi3+0x46>
  801f86:	66 90                	xchg   %ax,%ax
  801f88:	31 c0                	xor    %eax,%eax
  801f8a:	e9 37 ff ff ff       	jmp    801ec6 <__udivdi3+0x46>
  801f8f:	90                   	nop

00801f90 <__umoddi3>:
  801f90:	55                   	push   %ebp
  801f91:	57                   	push   %edi
  801f92:	56                   	push   %esi
  801f93:	53                   	push   %ebx
  801f94:	83 ec 1c             	sub    $0x1c,%esp
  801f97:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801f9b:	8b 74 24 34          	mov    0x34(%esp),%esi
  801f9f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801fa3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801fa7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801fab:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801faf:	89 f3                	mov    %esi,%ebx
  801fb1:	89 fa                	mov    %edi,%edx
  801fb3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801fb7:	89 34 24             	mov    %esi,(%esp)
  801fba:	85 c0                	test   %eax,%eax
  801fbc:	75 1a                	jne    801fd8 <__umoddi3+0x48>
  801fbe:	39 f7                	cmp    %esi,%edi
  801fc0:	0f 86 a2 00 00 00    	jbe    802068 <__umoddi3+0xd8>
  801fc6:	89 c8                	mov    %ecx,%eax
  801fc8:	89 f2                	mov    %esi,%edx
  801fca:	f7 f7                	div    %edi
  801fcc:	89 d0                	mov    %edx,%eax
  801fce:	31 d2                	xor    %edx,%edx
  801fd0:	83 c4 1c             	add    $0x1c,%esp
  801fd3:	5b                   	pop    %ebx
  801fd4:	5e                   	pop    %esi
  801fd5:	5f                   	pop    %edi
  801fd6:	5d                   	pop    %ebp
  801fd7:	c3                   	ret    
  801fd8:	39 f0                	cmp    %esi,%eax
  801fda:	0f 87 ac 00 00 00    	ja     80208c <__umoddi3+0xfc>
  801fe0:	0f bd e8             	bsr    %eax,%ebp
  801fe3:	83 f5 1f             	xor    $0x1f,%ebp
  801fe6:	0f 84 ac 00 00 00    	je     802098 <__umoddi3+0x108>
  801fec:	bf 20 00 00 00       	mov    $0x20,%edi
  801ff1:	29 ef                	sub    %ebp,%edi
  801ff3:	89 fe                	mov    %edi,%esi
  801ff5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801ff9:	89 e9                	mov    %ebp,%ecx
  801ffb:	d3 e0                	shl    %cl,%eax
  801ffd:	89 d7                	mov    %edx,%edi
  801fff:	89 f1                	mov    %esi,%ecx
  802001:	d3 ef                	shr    %cl,%edi
  802003:	09 c7                	or     %eax,%edi
  802005:	89 e9                	mov    %ebp,%ecx
  802007:	d3 e2                	shl    %cl,%edx
  802009:	89 14 24             	mov    %edx,(%esp)
  80200c:	89 d8                	mov    %ebx,%eax
  80200e:	d3 e0                	shl    %cl,%eax
  802010:	89 c2                	mov    %eax,%edx
  802012:	8b 44 24 08          	mov    0x8(%esp),%eax
  802016:	d3 e0                	shl    %cl,%eax
  802018:	89 44 24 04          	mov    %eax,0x4(%esp)
  80201c:	8b 44 24 08          	mov    0x8(%esp),%eax
  802020:	89 f1                	mov    %esi,%ecx
  802022:	d3 e8                	shr    %cl,%eax
  802024:	09 d0                	or     %edx,%eax
  802026:	d3 eb                	shr    %cl,%ebx
  802028:	89 da                	mov    %ebx,%edx
  80202a:	f7 f7                	div    %edi
  80202c:	89 d3                	mov    %edx,%ebx
  80202e:	f7 24 24             	mull   (%esp)
  802031:	89 c6                	mov    %eax,%esi
  802033:	89 d1                	mov    %edx,%ecx
  802035:	39 d3                	cmp    %edx,%ebx
  802037:	0f 82 87 00 00 00    	jb     8020c4 <__umoddi3+0x134>
  80203d:	0f 84 91 00 00 00    	je     8020d4 <__umoddi3+0x144>
  802043:	8b 54 24 04          	mov    0x4(%esp),%edx
  802047:	29 f2                	sub    %esi,%edx
  802049:	19 cb                	sbb    %ecx,%ebx
  80204b:	89 d8                	mov    %ebx,%eax
  80204d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802051:	d3 e0                	shl    %cl,%eax
  802053:	89 e9                	mov    %ebp,%ecx
  802055:	d3 ea                	shr    %cl,%edx
  802057:	09 d0                	or     %edx,%eax
  802059:	89 e9                	mov    %ebp,%ecx
  80205b:	d3 eb                	shr    %cl,%ebx
  80205d:	89 da                	mov    %ebx,%edx
  80205f:	83 c4 1c             	add    $0x1c,%esp
  802062:	5b                   	pop    %ebx
  802063:	5e                   	pop    %esi
  802064:	5f                   	pop    %edi
  802065:	5d                   	pop    %ebp
  802066:	c3                   	ret    
  802067:	90                   	nop
  802068:	89 fd                	mov    %edi,%ebp
  80206a:	85 ff                	test   %edi,%edi
  80206c:	75 0b                	jne    802079 <__umoddi3+0xe9>
  80206e:	b8 01 00 00 00       	mov    $0x1,%eax
  802073:	31 d2                	xor    %edx,%edx
  802075:	f7 f7                	div    %edi
  802077:	89 c5                	mov    %eax,%ebp
  802079:	89 f0                	mov    %esi,%eax
  80207b:	31 d2                	xor    %edx,%edx
  80207d:	f7 f5                	div    %ebp
  80207f:	89 c8                	mov    %ecx,%eax
  802081:	f7 f5                	div    %ebp
  802083:	89 d0                	mov    %edx,%eax
  802085:	e9 44 ff ff ff       	jmp    801fce <__umoddi3+0x3e>
  80208a:	66 90                	xchg   %ax,%ax
  80208c:	89 c8                	mov    %ecx,%eax
  80208e:	89 f2                	mov    %esi,%edx
  802090:	83 c4 1c             	add    $0x1c,%esp
  802093:	5b                   	pop    %ebx
  802094:	5e                   	pop    %esi
  802095:	5f                   	pop    %edi
  802096:	5d                   	pop    %ebp
  802097:	c3                   	ret    
  802098:	3b 04 24             	cmp    (%esp),%eax
  80209b:	72 06                	jb     8020a3 <__umoddi3+0x113>
  80209d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8020a1:	77 0f                	ja     8020b2 <__umoddi3+0x122>
  8020a3:	89 f2                	mov    %esi,%edx
  8020a5:	29 f9                	sub    %edi,%ecx
  8020a7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8020ab:	89 14 24             	mov    %edx,(%esp)
  8020ae:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8020b2:	8b 44 24 04          	mov    0x4(%esp),%eax
  8020b6:	8b 14 24             	mov    (%esp),%edx
  8020b9:	83 c4 1c             	add    $0x1c,%esp
  8020bc:	5b                   	pop    %ebx
  8020bd:	5e                   	pop    %esi
  8020be:	5f                   	pop    %edi
  8020bf:	5d                   	pop    %ebp
  8020c0:	c3                   	ret    
  8020c1:	8d 76 00             	lea    0x0(%esi),%esi
  8020c4:	2b 04 24             	sub    (%esp),%eax
  8020c7:	19 fa                	sbb    %edi,%edx
  8020c9:	89 d1                	mov    %edx,%ecx
  8020cb:	89 c6                	mov    %eax,%esi
  8020cd:	e9 71 ff ff ff       	jmp    802043 <__umoddi3+0xb3>
  8020d2:	66 90                	xchg   %ax,%ax
  8020d4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8020d8:	72 ea                	jb     8020c4 <__umoddi3+0x134>
  8020da:	89 d9                	mov    %ebx,%ecx
  8020dc:	e9 62 ff ff ff       	jmp    802043 <__umoddi3+0xb3>
