
obj/user/ef_tst_sharing_4:     file format elf32-i386


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
  800031:	e8 5d 05 00 00       	call   800593 <libmain>
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
_main(void)
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
  800092:	6a 12                	push   $0x12
  800094:	68 3c 3a 80 00       	push   $0x803a3c
  800099:	e8 31 06 00 00       	call   8006cf <_panic>
	}

	cprintf("************************************************\n");
  80009e:	83 ec 0c             	sub    $0xc,%esp
  8000a1:	68 54 3a 80 00       	push   $0x803a54
  8000a6:	e8 d8 08 00 00       	call   800983 <cprintf>
  8000ab:	83 c4 10             	add    $0x10,%esp
	cprintf("MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  8000ae:	83 ec 0c             	sub    $0xc,%esp
  8000b1:	68 88 3a 80 00       	push   $0x803a88
  8000b6:	e8 c8 08 00 00       	call   800983 <cprintf>
  8000bb:	83 c4 10             	add    $0x10,%esp
	cprintf("************************************************\n\n\n");
  8000be:	83 ec 0c             	sub    $0xc,%esp
  8000c1:	68 e4 3a 80 00       	push   $0x803ae4
  8000c6:	e8 b8 08 00 00       	call   800983 <cprintf>
  8000cb:	83 c4 10             	add    $0x10,%esp

	int Mega = 1024*1024;
  8000ce:	c7 45 ec 00 00 10 00 	movl   $0x100000,-0x14(%ebp)
	int kilo = 1024;
  8000d5:	c7 45 e8 00 04 00 00 	movl   $0x400,-0x18(%ebp)
	int envID = sys_getenvid();
  8000dc:	e8 c6 1d 00 00       	call   801ea7 <sys_getenvid>
  8000e1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	cprintf("STEP A: checking free of a shared object ... \n");
  8000e4:	83 ec 0c             	sub    $0xc,%esp
  8000e7:	68 18 3b 80 00       	push   $0x803b18
  8000ec:	e8 92 08 00 00       	call   800983 <cprintf>
  8000f1:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x;
		int freeFrames = sys_calculate_free_frames() ;
  8000f4:	e8 e7 1a 00 00       	call   801be0 <sys_calculate_free_frames>
  8000f9:	89 45 e0             	mov    %eax,-0x20(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8000fc:	83 ec 04             	sub    $0x4,%esp
  8000ff:	6a 01                	push   $0x1
  800101:	68 00 10 00 00       	push   $0x1000
  800106:	68 47 3b 80 00       	push   $0x803b47
  80010b:	e8 90 18 00 00       	call   8019a0 <smalloc>
  800110:	83 c4 10             	add    $0x10,%esp
  800113:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (x != (uint32*)USER_HEAP_START) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  800116:	81 7d dc 00 00 00 80 	cmpl   $0x80000000,-0x24(%ebp)
  80011d:	74 14                	je     800133 <_main+0xfb>
  80011f:	83 ec 04             	sub    $0x4,%esp
  800122:	68 4c 3b 80 00       	push   $0x803b4c
  800127:	6a 21                	push   $0x21
  800129:	68 3c 3a 80 00       	push   $0x803a3c
  80012e:	e8 9c 05 00 00       	call   8006cf <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800133:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800136:	e8 a5 1a 00 00       	call   801be0 <sys_calculate_free_frames>
  80013b:	29 c3                	sub    %eax,%ebx
  80013d:	89 d8                	mov    %ebx,%eax
  80013f:	83 f8 04             	cmp    $0x4,%eax
  800142:	74 14                	je     800158 <_main+0x120>
  800144:	83 ec 04             	sub    $0x4,%esp
  800147:	68 b8 3b 80 00       	push   $0x803bb8
  80014c:	6a 22                	push   $0x22
  80014e:	68 3c 3a 80 00       	push   $0x803a3c
  800153:	e8 77 05 00 00       	call   8006cf <_panic>

		sfree(x);
  800158:	83 ec 0c             	sub    $0xc,%esp
  80015b:	ff 75 dc             	pushl  -0x24(%ebp)
  80015e:	e8 1d 19 00 00       	call   801a80 <sfree>
  800163:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) ==  0+0+2) panic("Wrong free: make sure that you free the shared object by calling free_share_object()");
  800166:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800169:	e8 72 1a 00 00       	call   801be0 <sys_calculate_free_frames>
  80016e:	29 c3                	sub    %eax,%ebx
  800170:	89 d8                	mov    %ebx,%eax
  800172:	83 f8 02             	cmp    $0x2,%eax
  800175:	75 14                	jne    80018b <_main+0x153>
  800177:	83 ec 04             	sub    $0x4,%esp
  80017a:	68 38 3c 80 00       	push   $0x803c38
  80017f:	6a 25                	push   $0x25
  800181:	68 3c 3a 80 00       	push   $0x803a3c
  800186:	e8 44 05 00 00       	call   8006cf <_panic>
		else if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong free: revise your freeSharedObject logic");
  80018b:	e8 50 1a 00 00       	call   801be0 <sys_calculate_free_frames>
  800190:	89 c2                	mov    %eax,%edx
  800192:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800195:	39 c2                	cmp    %eax,%edx
  800197:	74 14                	je     8001ad <_main+0x175>
  800199:	83 ec 04             	sub    $0x4,%esp
  80019c:	68 90 3c 80 00       	push   $0x803c90
  8001a1:	6a 26                	push   $0x26
  8001a3:	68 3c 3a 80 00       	push   $0x803a3c
  8001a8:	e8 22 05 00 00       	call   8006cf <_panic>
	}
	cprintf("Step A completed successfully!!\n\n\n");
  8001ad:	83 ec 0c             	sub    $0xc,%esp
  8001b0:	68 c0 3c 80 00       	push   $0x803cc0
  8001b5:	e8 c9 07 00 00       	call   800983 <cprintf>
  8001ba:	83 c4 10             	add    $0x10,%esp


	cprintf("STEP B: checking free of 2 shared objects ... \n");
  8001bd:	83 ec 0c             	sub    $0xc,%esp
  8001c0:	68 e4 3c 80 00       	push   $0x803ce4
  8001c5:	e8 b9 07 00 00       	call   800983 <cprintf>
  8001ca:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x, *z ;
		int freeFrames = sys_calculate_free_frames() ;
  8001cd:	e8 0e 1a 00 00       	call   801be0 <sys_calculate_free_frames>
  8001d2:	89 45 d8             	mov    %eax,-0x28(%ebp)
		z = smalloc("z", PAGE_SIZE, 1);
  8001d5:	83 ec 04             	sub    $0x4,%esp
  8001d8:	6a 01                	push   $0x1
  8001da:	68 00 10 00 00       	push   $0x1000
  8001df:	68 14 3d 80 00       	push   $0x803d14
  8001e4:	e8 b7 17 00 00       	call   8019a0 <smalloc>
  8001e9:	83 c4 10             	add    $0x10,%esp
  8001ec:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8001ef:	83 ec 04             	sub    $0x4,%esp
  8001f2:	6a 01                	push   $0x1
  8001f4:	68 00 10 00 00       	push   $0x1000
  8001f9:	68 47 3b 80 00       	push   $0x803b47
  8001fe:	e8 9d 17 00 00       	call   8019a0 <smalloc>
  800203:	83 c4 10             	add    $0x10,%esp
  800206:	89 45 d0             	mov    %eax,-0x30(%ebp)

		if(x == NULL) panic("Wrong free: make sure that you free the shared object by calling free_share_object()");
  800209:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80020d:	75 14                	jne    800223 <_main+0x1eb>
  80020f:	83 ec 04             	sub    $0x4,%esp
  800212:	68 38 3c 80 00       	push   $0x803c38
  800217:	6a 32                	push   $0x32
  800219:	68 3c 3a 80 00       	push   $0x803a3c
  80021e:	e8 ac 04 00 00       	call   8006cf <_panic>

		if ((freeFrames - sys_calculate_free_frames()) !=  2+1+4) panic("Wrong previous free: make sure that you correctly free shared object before (Step A)");
  800223:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800226:	e8 b5 19 00 00       	call   801be0 <sys_calculate_free_frames>
  80022b:	29 c3                	sub    %eax,%ebx
  80022d:	89 d8                	mov    %ebx,%eax
  80022f:	83 f8 07             	cmp    $0x7,%eax
  800232:	74 14                	je     800248 <_main+0x210>
  800234:	83 ec 04             	sub    $0x4,%esp
  800237:	68 18 3d 80 00       	push   $0x803d18
  80023c:	6a 34                	push   $0x34
  80023e:	68 3c 3a 80 00       	push   $0x803a3c
  800243:	e8 87 04 00 00       	call   8006cf <_panic>

		sfree(z);
  800248:	83 ec 0c             	sub    $0xc,%esp
  80024b:	ff 75 d4             	pushl  -0x2c(%ebp)
  80024e:	e8 2d 18 00 00       	call   801a80 <sfree>
  800253:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong free: check your logic");
  800256:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800259:	e8 82 19 00 00       	call   801be0 <sys_calculate_free_frames>
  80025e:	29 c3                	sub    %eax,%ebx
  800260:	89 d8                	mov    %ebx,%eax
  800262:	83 f8 04             	cmp    $0x4,%eax
  800265:	74 14                	je     80027b <_main+0x243>
  800267:	83 ec 04             	sub    $0x4,%esp
  80026a:	68 6d 3d 80 00       	push   $0x803d6d
  80026f:	6a 37                	push   $0x37
  800271:	68 3c 3a 80 00       	push   $0x803a3c
  800276:	e8 54 04 00 00       	call   8006cf <_panic>

		sfree(x);
  80027b:	83 ec 0c             	sub    $0xc,%esp
  80027e:	ff 75 d0             	pushl  -0x30(%ebp)
  800281:	e8 fa 17 00 00       	call   801a80 <sfree>
  800286:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong free: check your logic");
  800289:	e8 52 19 00 00       	call   801be0 <sys_calculate_free_frames>
  80028e:	89 c2                	mov    %eax,%edx
  800290:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800293:	39 c2                	cmp    %eax,%edx
  800295:	74 14                	je     8002ab <_main+0x273>
  800297:	83 ec 04             	sub    $0x4,%esp
  80029a:	68 6d 3d 80 00       	push   $0x803d6d
  80029f:	6a 3a                	push   $0x3a
  8002a1:	68 3c 3a 80 00       	push   $0x803a3c
  8002a6:	e8 24 04 00 00       	call   8006cf <_panic>

	}
	cprintf("Step B completed successfully!!\n\n\n");
  8002ab:	83 ec 0c             	sub    $0xc,%esp
  8002ae:	68 8c 3d 80 00       	push   $0x803d8c
  8002b3:	e8 cb 06 00 00       	call   800983 <cprintf>
  8002b8:	83 c4 10             	add    $0x10,%esp

	cprintf("STEP C: checking range of loop during free... \n");
  8002bb:	83 ec 0c             	sub    $0xc,%esp
  8002be:	68 b0 3d 80 00       	push   $0x803db0
  8002c3:	e8 bb 06 00 00       	call   800983 <cprintf>
  8002c8:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *w, *u;
		int freeFrames = sys_calculate_free_frames() ;
  8002cb:	e8 10 19 00 00       	call   801be0 <sys_calculate_free_frames>
  8002d0:	89 45 cc             	mov    %eax,-0x34(%ebp)
		w = smalloc("w", 3 * PAGE_SIZE+1, 1);
  8002d3:	83 ec 04             	sub    $0x4,%esp
  8002d6:	6a 01                	push   $0x1
  8002d8:	68 01 30 00 00       	push   $0x3001
  8002dd:	68 e0 3d 80 00       	push   $0x803de0
  8002e2:	e8 b9 16 00 00       	call   8019a0 <smalloc>
  8002e7:	83 c4 10             	add    $0x10,%esp
  8002ea:	89 45 c8             	mov    %eax,-0x38(%ebp)
		u = smalloc("u", PAGE_SIZE, 1);
  8002ed:	83 ec 04             	sub    $0x4,%esp
  8002f0:	6a 01                	push   $0x1
  8002f2:	68 00 10 00 00       	push   $0x1000
  8002f7:	68 e2 3d 80 00       	push   $0x803de2
  8002fc:	e8 9f 16 00 00       	call   8019a0 <smalloc>
  800301:	83 c4 10             	add    $0x10,%esp
  800304:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		if ((freeFrames - sys_calculate_free_frames()) != 5+1+4) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800307:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  80030a:	e8 d1 18 00 00       	call   801be0 <sys_calculate_free_frames>
  80030f:	29 c3                	sub    %eax,%ebx
  800311:	89 d8                	mov    %ebx,%eax
  800313:	83 f8 0a             	cmp    $0xa,%eax
  800316:	74 14                	je     80032c <_main+0x2f4>
  800318:	83 ec 04             	sub    $0x4,%esp
  80031b:	68 b8 3b 80 00       	push   $0x803bb8
  800320:	6a 46                	push   $0x46
  800322:	68 3c 3a 80 00       	push   $0x803a3c
  800327:	e8 a3 03 00 00       	call   8006cf <_panic>

		sfree(w);
  80032c:	83 ec 0c             	sub    $0xc,%esp
  80032f:	ff 75 c8             	pushl  -0x38(%ebp)
  800332:	e8 49 17 00 00       	call   801a80 <sfree>
  800337:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong free: check your logic");
  80033a:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  80033d:	e8 9e 18 00 00       	call   801be0 <sys_calculate_free_frames>
  800342:	29 c3                	sub    %eax,%ebx
  800344:	89 d8                	mov    %ebx,%eax
  800346:	83 f8 04             	cmp    $0x4,%eax
  800349:	74 14                	je     80035f <_main+0x327>
  80034b:	83 ec 04             	sub    $0x4,%esp
  80034e:	68 6d 3d 80 00       	push   $0x803d6d
  800353:	6a 49                	push   $0x49
  800355:	68 3c 3a 80 00       	push   $0x803a3c
  80035a:	e8 70 03 00 00       	call   8006cf <_panic>

		uint32 *o;
		o = smalloc("o", 2 * PAGE_SIZE-1,1);
  80035f:	83 ec 04             	sub    $0x4,%esp
  800362:	6a 01                	push   $0x1
  800364:	68 ff 1f 00 00       	push   $0x1fff
  800369:	68 e4 3d 80 00       	push   $0x803de4
  80036e:	e8 2d 16 00 00       	call   8019a0 <smalloc>
  800373:	83 c4 10             	add    $0x10,%esp
  800376:	89 45 c0             	mov    %eax,-0x40(%ebp)

		if ((freeFrames - sys_calculate_free_frames()) != 3+1+4) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800379:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  80037c:	e8 5f 18 00 00       	call   801be0 <sys_calculate_free_frames>
  800381:	29 c3                	sub    %eax,%ebx
  800383:	89 d8                	mov    %ebx,%eax
  800385:	83 f8 08             	cmp    $0x8,%eax
  800388:	74 14                	je     80039e <_main+0x366>
  80038a:	83 ec 04             	sub    $0x4,%esp
  80038d:	68 b8 3b 80 00       	push   $0x803bb8
  800392:	6a 4e                	push   $0x4e
  800394:	68 3c 3a 80 00       	push   $0x803a3c
  800399:	e8 31 03 00 00       	call   8006cf <_panic>

		sfree(o);
  80039e:	83 ec 0c             	sub    $0xc,%esp
  8003a1:	ff 75 c0             	pushl  -0x40(%ebp)
  8003a4:	e8 d7 16 00 00       	call   801a80 <sfree>
  8003a9:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong free: check your logic");
  8003ac:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8003af:	e8 2c 18 00 00       	call   801be0 <sys_calculate_free_frames>
  8003b4:	29 c3                	sub    %eax,%ebx
  8003b6:	89 d8                	mov    %ebx,%eax
  8003b8:	83 f8 04             	cmp    $0x4,%eax
  8003bb:	74 14                	je     8003d1 <_main+0x399>
  8003bd:	83 ec 04             	sub    $0x4,%esp
  8003c0:	68 6d 3d 80 00       	push   $0x803d6d
  8003c5:	6a 51                	push   $0x51
  8003c7:	68 3c 3a 80 00       	push   $0x803a3c
  8003cc:	e8 fe 02 00 00       	call   8006cf <_panic>

		sfree(u);
  8003d1:	83 ec 0c             	sub    $0xc,%esp
  8003d4:	ff 75 c4             	pushl  -0x3c(%ebp)
  8003d7:	e8 a4 16 00 00       	call   801a80 <sfree>
  8003dc:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong free: check your logic");
  8003df:	e8 fc 17 00 00       	call   801be0 <sys_calculate_free_frames>
  8003e4:	89 c2                	mov    %eax,%edx
  8003e6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8003e9:	39 c2                	cmp    %eax,%edx
  8003eb:	74 14                	je     800401 <_main+0x3c9>
  8003ed:	83 ec 04             	sub    $0x4,%esp
  8003f0:	68 6d 3d 80 00       	push   $0x803d6d
  8003f5:	6a 54                	push   $0x54
  8003f7:	68 3c 3a 80 00       	push   $0x803a3c
  8003fc:	e8 ce 02 00 00       	call   8006cf <_panic>


		//Checking boundaries of page tables
		freeFrames = sys_calculate_free_frames() ;
  800401:	e8 da 17 00 00       	call   801be0 <sys_calculate_free_frames>
  800406:	89 45 cc             	mov    %eax,-0x34(%ebp)
		w = smalloc("w", 3 * Mega - 1*kilo, 1);
  800409:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80040c:	89 c2                	mov    %eax,%edx
  80040e:	01 d2                	add    %edx,%edx
  800410:	01 d0                	add    %edx,%eax
  800412:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800415:	83 ec 04             	sub    $0x4,%esp
  800418:	6a 01                	push   $0x1
  80041a:	50                   	push   %eax
  80041b:	68 e0 3d 80 00       	push   $0x803de0
  800420:	e8 7b 15 00 00       	call   8019a0 <smalloc>
  800425:	83 c4 10             	add    $0x10,%esp
  800428:	89 45 c8             	mov    %eax,-0x38(%ebp)
		u = smalloc("u", 7 * Mega - 1*kilo, 1);
  80042b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80042e:	89 d0                	mov    %edx,%eax
  800430:	01 c0                	add    %eax,%eax
  800432:	01 d0                	add    %edx,%eax
  800434:	01 c0                	add    %eax,%eax
  800436:	01 d0                	add    %edx,%eax
  800438:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80043b:	83 ec 04             	sub    $0x4,%esp
  80043e:	6a 01                	push   $0x1
  800440:	50                   	push   %eax
  800441:	68 e2 3d 80 00       	push   $0x803de2
  800446:	e8 55 15 00 00       	call   8019a0 <smalloc>
  80044b:	83 c4 10             	add    $0x10,%esp
  80044e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		o = smalloc("o", 2 * Mega + 1*kilo, 1);
  800451:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800454:	01 c0                	add    %eax,%eax
  800456:	89 c2                	mov    %eax,%edx
  800458:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80045b:	01 d0                	add    %edx,%eax
  80045d:	83 ec 04             	sub    $0x4,%esp
  800460:	6a 01                	push   $0x1
  800462:	50                   	push   %eax
  800463:	68 e4 3d 80 00       	push   $0x803de4
  800468:	e8 33 15 00 00       	call   8019a0 <smalloc>
  80046d:	83 c4 10             	add    $0x10,%esp
  800470:	89 45 c0             	mov    %eax,-0x40(%ebp)

		if ((freeFrames - sys_calculate_free_frames()) != 3073+4+7) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800473:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800476:	e8 65 17 00 00       	call   801be0 <sys_calculate_free_frames>
  80047b:	29 c3                	sub    %eax,%ebx
  80047d:	89 d8                	mov    %ebx,%eax
  80047f:	3d 0c 0c 00 00       	cmp    $0xc0c,%eax
  800484:	74 14                	je     80049a <_main+0x462>
  800486:	83 ec 04             	sub    $0x4,%esp
  800489:	68 b8 3b 80 00       	push   $0x803bb8
  80048e:	6a 5d                	push   $0x5d
  800490:	68 3c 3a 80 00       	push   $0x803a3c
  800495:	e8 35 02 00 00       	call   8006cf <_panic>

		sfree(o);
  80049a:	83 ec 0c             	sub    $0xc,%esp
  80049d:	ff 75 c0             	pushl  -0x40(%ebp)
  8004a0:	e8 db 15 00 00       	call   801a80 <sfree>
  8004a5:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  2560+3+5) panic("Wrong free: check your logic");
  8004a8:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8004ab:	e8 30 17 00 00       	call   801be0 <sys_calculate_free_frames>
  8004b0:	29 c3                	sub    %eax,%ebx
  8004b2:	89 d8                	mov    %ebx,%eax
  8004b4:	3d 08 0a 00 00       	cmp    $0xa08,%eax
  8004b9:	74 14                	je     8004cf <_main+0x497>
  8004bb:	83 ec 04             	sub    $0x4,%esp
  8004be:	68 6d 3d 80 00       	push   $0x803d6d
  8004c3:	6a 60                	push   $0x60
  8004c5:	68 3c 3a 80 00       	push   $0x803a3c
  8004ca:	e8 00 02 00 00       	call   8006cf <_panic>

		sfree(w);
  8004cf:	83 ec 0c             	sub    $0xc,%esp
  8004d2:	ff 75 c8             	pushl  -0x38(%ebp)
  8004d5:	e8 a6 15 00 00       	call   801a80 <sfree>
  8004da:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  1792+3+3) panic("Wrong free: check your logic");
  8004dd:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8004e0:	e8 fb 16 00 00       	call   801be0 <sys_calculate_free_frames>
  8004e5:	29 c3                	sub    %eax,%ebx
  8004e7:	89 d8                	mov    %ebx,%eax
  8004e9:	3d 06 07 00 00       	cmp    $0x706,%eax
  8004ee:	74 14                	je     800504 <_main+0x4cc>
  8004f0:	83 ec 04             	sub    $0x4,%esp
  8004f3:	68 6d 3d 80 00       	push   $0x803d6d
  8004f8:	6a 63                	push   $0x63
  8004fa:	68 3c 3a 80 00       	push   $0x803a3c
  8004ff:	e8 cb 01 00 00       	call   8006cf <_panic>

		sfree(u);
  800504:	83 ec 0c             	sub    $0xc,%esp
  800507:	ff 75 c4             	pushl  -0x3c(%ebp)
  80050a:	e8 71 15 00 00       	call   801a80 <sfree>
  80050f:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong free: check your logic");
  800512:	e8 c9 16 00 00       	call   801be0 <sys_calculate_free_frames>
  800517:	89 c2                	mov    %eax,%edx
  800519:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80051c:	39 c2                	cmp    %eax,%edx
  80051e:	74 14                	je     800534 <_main+0x4fc>
  800520:	83 ec 04             	sub    $0x4,%esp
  800523:	68 6d 3d 80 00       	push   $0x803d6d
  800528:	6a 66                	push   $0x66
  80052a:	68 3c 3a 80 00       	push   $0x803a3c
  80052f:	e8 9b 01 00 00       	call   8006cf <_panic>
	}
	cprintf("Step C completed successfully!!\n\n\n");
  800534:	83 ec 0c             	sub    $0xc,%esp
  800537:	68 e8 3d 80 00       	push   $0x803de8
  80053c:	e8 42 04 00 00       	call   800983 <cprintf>
  800541:	83 c4 10             	add    $0x10,%esp

	cprintf("Congratulations!! Test of freeSharedObjects [4] completed successfully!!\n\n\n");
  800544:	83 ec 0c             	sub    $0xc,%esp
  800547:	68 0c 3e 80 00       	push   $0x803e0c
  80054c:	e8 32 04 00 00       	call   800983 <cprintf>
  800551:	83 c4 10             	add    $0x10,%esp

	int32 parentenvID = sys_getparentenvid();
  800554:	e8 80 19 00 00       	call   801ed9 <sys_getparentenvid>
  800559:	89 45 bc             	mov    %eax,-0x44(%ebp)
	if(parentenvID > 0)
  80055c:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  800560:	7e 2b                	jle    80058d <_main+0x555>
	{
		//Get the check-finishing counter
		int *finishedCount = NULL;
  800562:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
		finishedCount = sget(parentenvID, "finishedCount") ;
  800569:	83 ec 08             	sub    $0x8,%esp
  80056c:	68 58 3e 80 00       	push   $0x803e58
  800571:	ff 75 bc             	pushl  -0x44(%ebp)
  800574:	e8 c3 14 00 00       	call   801a3c <sget>
  800579:	83 c4 10             	add    $0x10,%esp
  80057c:	89 45 b8             	mov    %eax,-0x48(%ebp)
		(*finishedCount)++ ;
  80057f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800582:	8b 00                	mov    (%eax),%eax
  800584:	8d 50 01             	lea    0x1(%eax),%edx
  800587:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80058a:	89 10                	mov    %edx,(%eax)
	}
	return;
  80058c:	90                   	nop
  80058d:	90                   	nop
}
  80058e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800591:	c9                   	leave  
  800592:	c3                   	ret    

00800593 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800593:	55                   	push   %ebp
  800594:	89 e5                	mov    %esp,%ebp
  800596:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800599:	e8 22 19 00 00       	call   801ec0 <sys_getenvindex>
  80059e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8005a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8005a4:	89 d0                	mov    %edx,%eax
  8005a6:	c1 e0 03             	shl    $0x3,%eax
  8005a9:	01 d0                	add    %edx,%eax
  8005ab:	01 c0                	add    %eax,%eax
  8005ad:	01 d0                	add    %edx,%eax
  8005af:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005b6:	01 d0                	add    %edx,%eax
  8005b8:	c1 e0 04             	shl    $0x4,%eax
  8005bb:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8005c0:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8005c5:	a1 20 50 80 00       	mov    0x805020,%eax
  8005ca:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8005d0:	84 c0                	test   %al,%al
  8005d2:	74 0f                	je     8005e3 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8005d4:	a1 20 50 80 00       	mov    0x805020,%eax
  8005d9:	05 5c 05 00 00       	add    $0x55c,%eax
  8005de:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8005e3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8005e7:	7e 0a                	jle    8005f3 <libmain+0x60>
		binaryname = argv[0];
  8005e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005ec:	8b 00                	mov    (%eax),%eax
  8005ee:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8005f3:	83 ec 08             	sub    $0x8,%esp
  8005f6:	ff 75 0c             	pushl  0xc(%ebp)
  8005f9:	ff 75 08             	pushl  0x8(%ebp)
  8005fc:	e8 37 fa ff ff       	call   800038 <_main>
  800601:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800604:	e8 c4 16 00 00       	call   801ccd <sys_disable_interrupt>
	cprintf("**************************************\n");
  800609:	83 ec 0c             	sub    $0xc,%esp
  80060c:	68 80 3e 80 00       	push   $0x803e80
  800611:	e8 6d 03 00 00       	call   800983 <cprintf>
  800616:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800619:	a1 20 50 80 00       	mov    0x805020,%eax
  80061e:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800624:	a1 20 50 80 00       	mov    0x805020,%eax
  800629:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  80062f:	83 ec 04             	sub    $0x4,%esp
  800632:	52                   	push   %edx
  800633:	50                   	push   %eax
  800634:	68 a8 3e 80 00       	push   $0x803ea8
  800639:	e8 45 03 00 00       	call   800983 <cprintf>
  80063e:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800641:	a1 20 50 80 00       	mov    0x805020,%eax
  800646:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80064c:	a1 20 50 80 00       	mov    0x805020,%eax
  800651:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800657:	a1 20 50 80 00       	mov    0x805020,%eax
  80065c:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800662:	51                   	push   %ecx
  800663:	52                   	push   %edx
  800664:	50                   	push   %eax
  800665:	68 d0 3e 80 00       	push   $0x803ed0
  80066a:	e8 14 03 00 00       	call   800983 <cprintf>
  80066f:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800672:	a1 20 50 80 00       	mov    0x805020,%eax
  800677:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80067d:	83 ec 08             	sub    $0x8,%esp
  800680:	50                   	push   %eax
  800681:	68 28 3f 80 00       	push   $0x803f28
  800686:	e8 f8 02 00 00       	call   800983 <cprintf>
  80068b:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80068e:	83 ec 0c             	sub    $0xc,%esp
  800691:	68 80 3e 80 00       	push   $0x803e80
  800696:	e8 e8 02 00 00       	call   800983 <cprintf>
  80069b:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80069e:	e8 44 16 00 00       	call   801ce7 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8006a3:	e8 19 00 00 00       	call   8006c1 <exit>
}
  8006a8:	90                   	nop
  8006a9:	c9                   	leave  
  8006aa:	c3                   	ret    

008006ab <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8006ab:	55                   	push   %ebp
  8006ac:	89 e5                	mov    %esp,%ebp
  8006ae:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8006b1:	83 ec 0c             	sub    $0xc,%esp
  8006b4:	6a 00                	push   $0x0
  8006b6:	e8 d1 17 00 00       	call   801e8c <sys_destroy_env>
  8006bb:	83 c4 10             	add    $0x10,%esp
}
  8006be:	90                   	nop
  8006bf:	c9                   	leave  
  8006c0:	c3                   	ret    

008006c1 <exit>:

void
exit(void)
{
  8006c1:	55                   	push   %ebp
  8006c2:	89 e5                	mov    %esp,%ebp
  8006c4:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8006c7:	e8 26 18 00 00       	call   801ef2 <sys_exit_env>
}
  8006cc:	90                   	nop
  8006cd:	c9                   	leave  
  8006ce:	c3                   	ret    

008006cf <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8006cf:	55                   	push   %ebp
  8006d0:	89 e5                	mov    %esp,%ebp
  8006d2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8006d5:	8d 45 10             	lea    0x10(%ebp),%eax
  8006d8:	83 c0 04             	add    $0x4,%eax
  8006db:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8006de:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8006e3:	85 c0                	test   %eax,%eax
  8006e5:	74 16                	je     8006fd <_panic+0x2e>
		cprintf("%s: ", argv0);
  8006e7:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8006ec:	83 ec 08             	sub    $0x8,%esp
  8006ef:	50                   	push   %eax
  8006f0:	68 3c 3f 80 00       	push   $0x803f3c
  8006f5:	e8 89 02 00 00       	call   800983 <cprintf>
  8006fa:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8006fd:	a1 00 50 80 00       	mov    0x805000,%eax
  800702:	ff 75 0c             	pushl  0xc(%ebp)
  800705:	ff 75 08             	pushl  0x8(%ebp)
  800708:	50                   	push   %eax
  800709:	68 41 3f 80 00       	push   $0x803f41
  80070e:	e8 70 02 00 00       	call   800983 <cprintf>
  800713:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800716:	8b 45 10             	mov    0x10(%ebp),%eax
  800719:	83 ec 08             	sub    $0x8,%esp
  80071c:	ff 75 f4             	pushl  -0xc(%ebp)
  80071f:	50                   	push   %eax
  800720:	e8 f3 01 00 00       	call   800918 <vcprintf>
  800725:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800728:	83 ec 08             	sub    $0x8,%esp
  80072b:	6a 00                	push   $0x0
  80072d:	68 5d 3f 80 00       	push   $0x803f5d
  800732:	e8 e1 01 00 00       	call   800918 <vcprintf>
  800737:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80073a:	e8 82 ff ff ff       	call   8006c1 <exit>

	// should not return here
	while (1) ;
  80073f:	eb fe                	jmp    80073f <_panic+0x70>

00800741 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800741:	55                   	push   %ebp
  800742:	89 e5                	mov    %esp,%ebp
  800744:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800747:	a1 20 50 80 00       	mov    0x805020,%eax
  80074c:	8b 50 74             	mov    0x74(%eax),%edx
  80074f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800752:	39 c2                	cmp    %eax,%edx
  800754:	74 14                	je     80076a <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800756:	83 ec 04             	sub    $0x4,%esp
  800759:	68 60 3f 80 00       	push   $0x803f60
  80075e:	6a 26                	push   $0x26
  800760:	68 ac 3f 80 00       	push   $0x803fac
  800765:	e8 65 ff ff ff       	call   8006cf <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80076a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800771:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800778:	e9 c2 00 00 00       	jmp    80083f <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80077d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800780:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800787:	8b 45 08             	mov    0x8(%ebp),%eax
  80078a:	01 d0                	add    %edx,%eax
  80078c:	8b 00                	mov    (%eax),%eax
  80078e:	85 c0                	test   %eax,%eax
  800790:	75 08                	jne    80079a <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800792:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800795:	e9 a2 00 00 00       	jmp    80083c <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80079a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8007a1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8007a8:	eb 69                	jmp    800813 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8007aa:	a1 20 50 80 00       	mov    0x805020,%eax
  8007af:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8007b5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8007b8:	89 d0                	mov    %edx,%eax
  8007ba:	01 c0                	add    %eax,%eax
  8007bc:	01 d0                	add    %edx,%eax
  8007be:	c1 e0 03             	shl    $0x3,%eax
  8007c1:	01 c8                	add    %ecx,%eax
  8007c3:	8a 40 04             	mov    0x4(%eax),%al
  8007c6:	84 c0                	test   %al,%al
  8007c8:	75 46                	jne    800810 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8007ca:	a1 20 50 80 00       	mov    0x805020,%eax
  8007cf:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8007d5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8007d8:	89 d0                	mov    %edx,%eax
  8007da:	01 c0                	add    %eax,%eax
  8007dc:	01 d0                	add    %edx,%eax
  8007de:	c1 e0 03             	shl    $0x3,%eax
  8007e1:	01 c8                	add    %ecx,%eax
  8007e3:	8b 00                	mov    (%eax),%eax
  8007e5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8007e8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8007eb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8007f0:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8007f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007f5:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8007fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ff:	01 c8                	add    %ecx,%eax
  800801:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800803:	39 c2                	cmp    %eax,%edx
  800805:	75 09                	jne    800810 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800807:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80080e:	eb 12                	jmp    800822 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800810:	ff 45 e8             	incl   -0x18(%ebp)
  800813:	a1 20 50 80 00       	mov    0x805020,%eax
  800818:	8b 50 74             	mov    0x74(%eax),%edx
  80081b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80081e:	39 c2                	cmp    %eax,%edx
  800820:	77 88                	ja     8007aa <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800822:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800826:	75 14                	jne    80083c <CheckWSWithoutLastIndex+0xfb>
			panic(
  800828:	83 ec 04             	sub    $0x4,%esp
  80082b:	68 b8 3f 80 00       	push   $0x803fb8
  800830:	6a 3a                	push   $0x3a
  800832:	68 ac 3f 80 00       	push   $0x803fac
  800837:	e8 93 fe ff ff       	call   8006cf <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80083c:	ff 45 f0             	incl   -0x10(%ebp)
  80083f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800842:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800845:	0f 8c 32 ff ff ff    	jl     80077d <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80084b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800852:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800859:	eb 26                	jmp    800881 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80085b:	a1 20 50 80 00       	mov    0x805020,%eax
  800860:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800866:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800869:	89 d0                	mov    %edx,%eax
  80086b:	01 c0                	add    %eax,%eax
  80086d:	01 d0                	add    %edx,%eax
  80086f:	c1 e0 03             	shl    $0x3,%eax
  800872:	01 c8                	add    %ecx,%eax
  800874:	8a 40 04             	mov    0x4(%eax),%al
  800877:	3c 01                	cmp    $0x1,%al
  800879:	75 03                	jne    80087e <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80087b:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80087e:	ff 45 e0             	incl   -0x20(%ebp)
  800881:	a1 20 50 80 00       	mov    0x805020,%eax
  800886:	8b 50 74             	mov    0x74(%eax),%edx
  800889:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80088c:	39 c2                	cmp    %eax,%edx
  80088e:	77 cb                	ja     80085b <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800890:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800893:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800896:	74 14                	je     8008ac <CheckWSWithoutLastIndex+0x16b>
		panic(
  800898:	83 ec 04             	sub    $0x4,%esp
  80089b:	68 0c 40 80 00       	push   $0x80400c
  8008a0:	6a 44                	push   $0x44
  8008a2:	68 ac 3f 80 00       	push   $0x803fac
  8008a7:	e8 23 fe ff ff       	call   8006cf <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8008ac:	90                   	nop
  8008ad:	c9                   	leave  
  8008ae:	c3                   	ret    

008008af <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8008af:	55                   	push   %ebp
  8008b0:	89 e5                	mov    %esp,%ebp
  8008b2:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8008b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008b8:	8b 00                	mov    (%eax),%eax
  8008ba:	8d 48 01             	lea    0x1(%eax),%ecx
  8008bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008c0:	89 0a                	mov    %ecx,(%edx)
  8008c2:	8b 55 08             	mov    0x8(%ebp),%edx
  8008c5:	88 d1                	mov    %dl,%cl
  8008c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008ca:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8008ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008d1:	8b 00                	mov    (%eax),%eax
  8008d3:	3d ff 00 00 00       	cmp    $0xff,%eax
  8008d8:	75 2c                	jne    800906 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8008da:	a0 24 50 80 00       	mov    0x805024,%al
  8008df:	0f b6 c0             	movzbl %al,%eax
  8008e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008e5:	8b 12                	mov    (%edx),%edx
  8008e7:	89 d1                	mov    %edx,%ecx
  8008e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008ec:	83 c2 08             	add    $0x8,%edx
  8008ef:	83 ec 04             	sub    $0x4,%esp
  8008f2:	50                   	push   %eax
  8008f3:	51                   	push   %ecx
  8008f4:	52                   	push   %edx
  8008f5:	e8 25 12 00 00       	call   801b1f <sys_cputs>
  8008fa:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8008fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800900:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800906:	8b 45 0c             	mov    0xc(%ebp),%eax
  800909:	8b 40 04             	mov    0x4(%eax),%eax
  80090c:	8d 50 01             	lea    0x1(%eax),%edx
  80090f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800912:	89 50 04             	mov    %edx,0x4(%eax)
}
  800915:	90                   	nop
  800916:	c9                   	leave  
  800917:	c3                   	ret    

00800918 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800918:	55                   	push   %ebp
  800919:	89 e5                	mov    %esp,%ebp
  80091b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800921:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800928:	00 00 00 
	b.cnt = 0;
  80092b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800932:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800935:	ff 75 0c             	pushl  0xc(%ebp)
  800938:	ff 75 08             	pushl  0x8(%ebp)
  80093b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800941:	50                   	push   %eax
  800942:	68 af 08 80 00       	push   $0x8008af
  800947:	e8 11 02 00 00       	call   800b5d <vprintfmt>
  80094c:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80094f:	a0 24 50 80 00       	mov    0x805024,%al
  800954:	0f b6 c0             	movzbl %al,%eax
  800957:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80095d:	83 ec 04             	sub    $0x4,%esp
  800960:	50                   	push   %eax
  800961:	52                   	push   %edx
  800962:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800968:	83 c0 08             	add    $0x8,%eax
  80096b:	50                   	push   %eax
  80096c:	e8 ae 11 00 00       	call   801b1f <sys_cputs>
  800971:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800974:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  80097b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800981:	c9                   	leave  
  800982:	c3                   	ret    

00800983 <cprintf>:

int cprintf(const char *fmt, ...) {
  800983:	55                   	push   %ebp
  800984:	89 e5                	mov    %esp,%ebp
  800986:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800989:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  800990:	8d 45 0c             	lea    0xc(%ebp),%eax
  800993:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800996:	8b 45 08             	mov    0x8(%ebp),%eax
  800999:	83 ec 08             	sub    $0x8,%esp
  80099c:	ff 75 f4             	pushl  -0xc(%ebp)
  80099f:	50                   	push   %eax
  8009a0:	e8 73 ff ff ff       	call   800918 <vcprintf>
  8009a5:	83 c4 10             	add    $0x10,%esp
  8009a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8009ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009ae:	c9                   	leave  
  8009af:	c3                   	ret    

008009b0 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8009b0:	55                   	push   %ebp
  8009b1:	89 e5                	mov    %esp,%ebp
  8009b3:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8009b6:	e8 12 13 00 00       	call   801ccd <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8009bb:	8d 45 0c             	lea    0xc(%ebp),%eax
  8009be:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8009c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c4:	83 ec 08             	sub    $0x8,%esp
  8009c7:	ff 75 f4             	pushl  -0xc(%ebp)
  8009ca:	50                   	push   %eax
  8009cb:	e8 48 ff ff ff       	call   800918 <vcprintf>
  8009d0:	83 c4 10             	add    $0x10,%esp
  8009d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8009d6:	e8 0c 13 00 00       	call   801ce7 <sys_enable_interrupt>
	return cnt;
  8009db:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009de:	c9                   	leave  
  8009df:	c3                   	ret    

008009e0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8009e0:	55                   	push   %ebp
  8009e1:	89 e5                	mov    %esp,%ebp
  8009e3:	53                   	push   %ebx
  8009e4:	83 ec 14             	sub    $0x14,%esp
  8009e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8009ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8009f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8009f3:	8b 45 18             	mov    0x18(%ebp),%eax
  8009f6:	ba 00 00 00 00       	mov    $0x0,%edx
  8009fb:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8009fe:	77 55                	ja     800a55 <printnum+0x75>
  800a00:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a03:	72 05                	jb     800a0a <printnum+0x2a>
  800a05:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800a08:	77 4b                	ja     800a55 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800a0a:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800a0d:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800a10:	8b 45 18             	mov    0x18(%ebp),%eax
  800a13:	ba 00 00 00 00       	mov    $0x0,%edx
  800a18:	52                   	push   %edx
  800a19:	50                   	push   %eax
  800a1a:	ff 75 f4             	pushl  -0xc(%ebp)
  800a1d:	ff 75 f0             	pushl  -0x10(%ebp)
  800a20:	e8 7f 2d 00 00       	call   8037a4 <__udivdi3>
  800a25:	83 c4 10             	add    $0x10,%esp
  800a28:	83 ec 04             	sub    $0x4,%esp
  800a2b:	ff 75 20             	pushl  0x20(%ebp)
  800a2e:	53                   	push   %ebx
  800a2f:	ff 75 18             	pushl  0x18(%ebp)
  800a32:	52                   	push   %edx
  800a33:	50                   	push   %eax
  800a34:	ff 75 0c             	pushl  0xc(%ebp)
  800a37:	ff 75 08             	pushl  0x8(%ebp)
  800a3a:	e8 a1 ff ff ff       	call   8009e0 <printnum>
  800a3f:	83 c4 20             	add    $0x20,%esp
  800a42:	eb 1a                	jmp    800a5e <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800a44:	83 ec 08             	sub    $0x8,%esp
  800a47:	ff 75 0c             	pushl  0xc(%ebp)
  800a4a:	ff 75 20             	pushl  0x20(%ebp)
  800a4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a50:	ff d0                	call   *%eax
  800a52:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800a55:	ff 4d 1c             	decl   0x1c(%ebp)
  800a58:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800a5c:	7f e6                	jg     800a44 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800a5e:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800a61:	bb 00 00 00 00       	mov    $0x0,%ebx
  800a66:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a69:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a6c:	53                   	push   %ebx
  800a6d:	51                   	push   %ecx
  800a6e:	52                   	push   %edx
  800a6f:	50                   	push   %eax
  800a70:	e8 3f 2e 00 00       	call   8038b4 <__umoddi3>
  800a75:	83 c4 10             	add    $0x10,%esp
  800a78:	05 74 42 80 00       	add    $0x804274,%eax
  800a7d:	8a 00                	mov    (%eax),%al
  800a7f:	0f be c0             	movsbl %al,%eax
  800a82:	83 ec 08             	sub    $0x8,%esp
  800a85:	ff 75 0c             	pushl  0xc(%ebp)
  800a88:	50                   	push   %eax
  800a89:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8c:	ff d0                	call   *%eax
  800a8e:	83 c4 10             	add    $0x10,%esp
}
  800a91:	90                   	nop
  800a92:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a95:	c9                   	leave  
  800a96:	c3                   	ret    

00800a97 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800a97:	55                   	push   %ebp
  800a98:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800a9a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800a9e:	7e 1c                	jle    800abc <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800aa0:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa3:	8b 00                	mov    (%eax),%eax
  800aa5:	8d 50 08             	lea    0x8(%eax),%edx
  800aa8:	8b 45 08             	mov    0x8(%ebp),%eax
  800aab:	89 10                	mov    %edx,(%eax)
  800aad:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab0:	8b 00                	mov    (%eax),%eax
  800ab2:	83 e8 08             	sub    $0x8,%eax
  800ab5:	8b 50 04             	mov    0x4(%eax),%edx
  800ab8:	8b 00                	mov    (%eax),%eax
  800aba:	eb 40                	jmp    800afc <getuint+0x65>
	else if (lflag)
  800abc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ac0:	74 1e                	je     800ae0 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800ac2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac5:	8b 00                	mov    (%eax),%eax
  800ac7:	8d 50 04             	lea    0x4(%eax),%edx
  800aca:	8b 45 08             	mov    0x8(%ebp),%eax
  800acd:	89 10                	mov    %edx,(%eax)
  800acf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad2:	8b 00                	mov    (%eax),%eax
  800ad4:	83 e8 04             	sub    $0x4,%eax
  800ad7:	8b 00                	mov    (%eax),%eax
  800ad9:	ba 00 00 00 00       	mov    $0x0,%edx
  800ade:	eb 1c                	jmp    800afc <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800ae0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae3:	8b 00                	mov    (%eax),%eax
  800ae5:	8d 50 04             	lea    0x4(%eax),%edx
  800ae8:	8b 45 08             	mov    0x8(%ebp),%eax
  800aeb:	89 10                	mov    %edx,(%eax)
  800aed:	8b 45 08             	mov    0x8(%ebp),%eax
  800af0:	8b 00                	mov    (%eax),%eax
  800af2:	83 e8 04             	sub    $0x4,%eax
  800af5:	8b 00                	mov    (%eax),%eax
  800af7:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800afc:	5d                   	pop    %ebp
  800afd:	c3                   	ret    

00800afe <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800afe:	55                   	push   %ebp
  800aff:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b01:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b05:	7e 1c                	jle    800b23 <getint+0x25>
		return va_arg(*ap, long long);
  800b07:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0a:	8b 00                	mov    (%eax),%eax
  800b0c:	8d 50 08             	lea    0x8(%eax),%edx
  800b0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b12:	89 10                	mov    %edx,(%eax)
  800b14:	8b 45 08             	mov    0x8(%ebp),%eax
  800b17:	8b 00                	mov    (%eax),%eax
  800b19:	83 e8 08             	sub    $0x8,%eax
  800b1c:	8b 50 04             	mov    0x4(%eax),%edx
  800b1f:	8b 00                	mov    (%eax),%eax
  800b21:	eb 38                	jmp    800b5b <getint+0x5d>
	else if (lflag)
  800b23:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b27:	74 1a                	je     800b43 <getint+0x45>
		return va_arg(*ap, long);
  800b29:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2c:	8b 00                	mov    (%eax),%eax
  800b2e:	8d 50 04             	lea    0x4(%eax),%edx
  800b31:	8b 45 08             	mov    0x8(%ebp),%eax
  800b34:	89 10                	mov    %edx,(%eax)
  800b36:	8b 45 08             	mov    0x8(%ebp),%eax
  800b39:	8b 00                	mov    (%eax),%eax
  800b3b:	83 e8 04             	sub    $0x4,%eax
  800b3e:	8b 00                	mov    (%eax),%eax
  800b40:	99                   	cltd   
  800b41:	eb 18                	jmp    800b5b <getint+0x5d>
	else
		return va_arg(*ap, int);
  800b43:	8b 45 08             	mov    0x8(%ebp),%eax
  800b46:	8b 00                	mov    (%eax),%eax
  800b48:	8d 50 04             	lea    0x4(%eax),%edx
  800b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4e:	89 10                	mov    %edx,(%eax)
  800b50:	8b 45 08             	mov    0x8(%ebp),%eax
  800b53:	8b 00                	mov    (%eax),%eax
  800b55:	83 e8 04             	sub    $0x4,%eax
  800b58:	8b 00                	mov    (%eax),%eax
  800b5a:	99                   	cltd   
}
  800b5b:	5d                   	pop    %ebp
  800b5c:	c3                   	ret    

00800b5d <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800b5d:	55                   	push   %ebp
  800b5e:	89 e5                	mov    %esp,%ebp
  800b60:	56                   	push   %esi
  800b61:	53                   	push   %ebx
  800b62:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b65:	eb 17                	jmp    800b7e <vprintfmt+0x21>
			if (ch == '\0')
  800b67:	85 db                	test   %ebx,%ebx
  800b69:	0f 84 af 03 00 00    	je     800f1e <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800b6f:	83 ec 08             	sub    $0x8,%esp
  800b72:	ff 75 0c             	pushl  0xc(%ebp)
  800b75:	53                   	push   %ebx
  800b76:	8b 45 08             	mov    0x8(%ebp),%eax
  800b79:	ff d0                	call   *%eax
  800b7b:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b7e:	8b 45 10             	mov    0x10(%ebp),%eax
  800b81:	8d 50 01             	lea    0x1(%eax),%edx
  800b84:	89 55 10             	mov    %edx,0x10(%ebp)
  800b87:	8a 00                	mov    (%eax),%al
  800b89:	0f b6 d8             	movzbl %al,%ebx
  800b8c:	83 fb 25             	cmp    $0x25,%ebx
  800b8f:	75 d6                	jne    800b67 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800b91:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800b95:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800b9c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800ba3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800baa:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800bb1:	8b 45 10             	mov    0x10(%ebp),%eax
  800bb4:	8d 50 01             	lea    0x1(%eax),%edx
  800bb7:	89 55 10             	mov    %edx,0x10(%ebp)
  800bba:	8a 00                	mov    (%eax),%al
  800bbc:	0f b6 d8             	movzbl %al,%ebx
  800bbf:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800bc2:	83 f8 55             	cmp    $0x55,%eax
  800bc5:	0f 87 2b 03 00 00    	ja     800ef6 <vprintfmt+0x399>
  800bcb:	8b 04 85 98 42 80 00 	mov    0x804298(,%eax,4),%eax
  800bd2:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800bd4:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800bd8:	eb d7                	jmp    800bb1 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800bda:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800bde:	eb d1                	jmp    800bb1 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800be0:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800be7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800bea:	89 d0                	mov    %edx,%eax
  800bec:	c1 e0 02             	shl    $0x2,%eax
  800bef:	01 d0                	add    %edx,%eax
  800bf1:	01 c0                	add    %eax,%eax
  800bf3:	01 d8                	add    %ebx,%eax
  800bf5:	83 e8 30             	sub    $0x30,%eax
  800bf8:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800bfb:	8b 45 10             	mov    0x10(%ebp),%eax
  800bfe:	8a 00                	mov    (%eax),%al
  800c00:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800c03:	83 fb 2f             	cmp    $0x2f,%ebx
  800c06:	7e 3e                	jle    800c46 <vprintfmt+0xe9>
  800c08:	83 fb 39             	cmp    $0x39,%ebx
  800c0b:	7f 39                	jg     800c46 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c0d:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800c10:	eb d5                	jmp    800be7 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800c12:	8b 45 14             	mov    0x14(%ebp),%eax
  800c15:	83 c0 04             	add    $0x4,%eax
  800c18:	89 45 14             	mov    %eax,0x14(%ebp)
  800c1b:	8b 45 14             	mov    0x14(%ebp),%eax
  800c1e:	83 e8 04             	sub    $0x4,%eax
  800c21:	8b 00                	mov    (%eax),%eax
  800c23:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800c26:	eb 1f                	jmp    800c47 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800c28:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c2c:	79 83                	jns    800bb1 <vprintfmt+0x54>
				width = 0;
  800c2e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800c35:	e9 77 ff ff ff       	jmp    800bb1 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800c3a:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800c41:	e9 6b ff ff ff       	jmp    800bb1 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800c46:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800c47:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c4b:	0f 89 60 ff ff ff    	jns    800bb1 <vprintfmt+0x54>
				width = precision, precision = -1;
  800c51:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c54:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800c57:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800c5e:	e9 4e ff ff ff       	jmp    800bb1 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800c63:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800c66:	e9 46 ff ff ff       	jmp    800bb1 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800c6b:	8b 45 14             	mov    0x14(%ebp),%eax
  800c6e:	83 c0 04             	add    $0x4,%eax
  800c71:	89 45 14             	mov    %eax,0x14(%ebp)
  800c74:	8b 45 14             	mov    0x14(%ebp),%eax
  800c77:	83 e8 04             	sub    $0x4,%eax
  800c7a:	8b 00                	mov    (%eax),%eax
  800c7c:	83 ec 08             	sub    $0x8,%esp
  800c7f:	ff 75 0c             	pushl  0xc(%ebp)
  800c82:	50                   	push   %eax
  800c83:	8b 45 08             	mov    0x8(%ebp),%eax
  800c86:	ff d0                	call   *%eax
  800c88:	83 c4 10             	add    $0x10,%esp
			break;
  800c8b:	e9 89 02 00 00       	jmp    800f19 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800c90:	8b 45 14             	mov    0x14(%ebp),%eax
  800c93:	83 c0 04             	add    $0x4,%eax
  800c96:	89 45 14             	mov    %eax,0x14(%ebp)
  800c99:	8b 45 14             	mov    0x14(%ebp),%eax
  800c9c:	83 e8 04             	sub    $0x4,%eax
  800c9f:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800ca1:	85 db                	test   %ebx,%ebx
  800ca3:	79 02                	jns    800ca7 <vprintfmt+0x14a>
				err = -err;
  800ca5:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800ca7:	83 fb 64             	cmp    $0x64,%ebx
  800caa:	7f 0b                	jg     800cb7 <vprintfmt+0x15a>
  800cac:	8b 34 9d e0 40 80 00 	mov    0x8040e0(,%ebx,4),%esi
  800cb3:	85 f6                	test   %esi,%esi
  800cb5:	75 19                	jne    800cd0 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800cb7:	53                   	push   %ebx
  800cb8:	68 85 42 80 00       	push   $0x804285
  800cbd:	ff 75 0c             	pushl  0xc(%ebp)
  800cc0:	ff 75 08             	pushl  0x8(%ebp)
  800cc3:	e8 5e 02 00 00       	call   800f26 <printfmt>
  800cc8:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800ccb:	e9 49 02 00 00       	jmp    800f19 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800cd0:	56                   	push   %esi
  800cd1:	68 8e 42 80 00       	push   $0x80428e
  800cd6:	ff 75 0c             	pushl  0xc(%ebp)
  800cd9:	ff 75 08             	pushl  0x8(%ebp)
  800cdc:	e8 45 02 00 00       	call   800f26 <printfmt>
  800ce1:	83 c4 10             	add    $0x10,%esp
			break;
  800ce4:	e9 30 02 00 00       	jmp    800f19 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800ce9:	8b 45 14             	mov    0x14(%ebp),%eax
  800cec:	83 c0 04             	add    $0x4,%eax
  800cef:	89 45 14             	mov    %eax,0x14(%ebp)
  800cf2:	8b 45 14             	mov    0x14(%ebp),%eax
  800cf5:	83 e8 04             	sub    $0x4,%eax
  800cf8:	8b 30                	mov    (%eax),%esi
  800cfa:	85 f6                	test   %esi,%esi
  800cfc:	75 05                	jne    800d03 <vprintfmt+0x1a6>
				p = "(null)";
  800cfe:	be 91 42 80 00       	mov    $0x804291,%esi
			if (width > 0 && padc != '-')
  800d03:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d07:	7e 6d                	jle    800d76 <vprintfmt+0x219>
  800d09:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800d0d:	74 67                	je     800d76 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800d0f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d12:	83 ec 08             	sub    $0x8,%esp
  800d15:	50                   	push   %eax
  800d16:	56                   	push   %esi
  800d17:	e8 0c 03 00 00       	call   801028 <strnlen>
  800d1c:	83 c4 10             	add    $0x10,%esp
  800d1f:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800d22:	eb 16                	jmp    800d3a <vprintfmt+0x1dd>
					putch(padc, putdat);
  800d24:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800d28:	83 ec 08             	sub    $0x8,%esp
  800d2b:	ff 75 0c             	pushl  0xc(%ebp)
  800d2e:	50                   	push   %eax
  800d2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d32:	ff d0                	call   *%eax
  800d34:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800d37:	ff 4d e4             	decl   -0x1c(%ebp)
  800d3a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d3e:	7f e4                	jg     800d24 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d40:	eb 34                	jmp    800d76 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800d42:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800d46:	74 1c                	je     800d64 <vprintfmt+0x207>
  800d48:	83 fb 1f             	cmp    $0x1f,%ebx
  800d4b:	7e 05                	jle    800d52 <vprintfmt+0x1f5>
  800d4d:	83 fb 7e             	cmp    $0x7e,%ebx
  800d50:	7e 12                	jle    800d64 <vprintfmt+0x207>
					putch('?', putdat);
  800d52:	83 ec 08             	sub    $0x8,%esp
  800d55:	ff 75 0c             	pushl  0xc(%ebp)
  800d58:	6a 3f                	push   $0x3f
  800d5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5d:	ff d0                	call   *%eax
  800d5f:	83 c4 10             	add    $0x10,%esp
  800d62:	eb 0f                	jmp    800d73 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800d64:	83 ec 08             	sub    $0x8,%esp
  800d67:	ff 75 0c             	pushl  0xc(%ebp)
  800d6a:	53                   	push   %ebx
  800d6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6e:	ff d0                	call   *%eax
  800d70:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d73:	ff 4d e4             	decl   -0x1c(%ebp)
  800d76:	89 f0                	mov    %esi,%eax
  800d78:	8d 70 01             	lea    0x1(%eax),%esi
  800d7b:	8a 00                	mov    (%eax),%al
  800d7d:	0f be d8             	movsbl %al,%ebx
  800d80:	85 db                	test   %ebx,%ebx
  800d82:	74 24                	je     800da8 <vprintfmt+0x24b>
  800d84:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800d88:	78 b8                	js     800d42 <vprintfmt+0x1e5>
  800d8a:	ff 4d e0             	decl   -0x20(%ebp)
  800d8d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800d91:	79 af                	jns    800d42 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d93:	eb 13                	jmp    800da8 <vprintfmt+0x24b>
				putch(' ', putdat);
  800d95:	83 ec 08             	sub    $0x8,%esp
  800d98:	ff 75 0c             	pushl  0xc(%ebp)
  800d9b:	6a 20                	push   $0x20
  800d9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800da0:	ff d0                	call   *%eax
  800da2:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800da5:	ff 4d e4             	decl   -0x1c(%ebp)
  800da8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800dac:	7f e7                	jg     800d95 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800dae:	e9 66 01 00 00       	jmp    800f19 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800db3:	83 ec 08             	sub    $0x8,%esp
  800db6:	ff 75 e8             	pushl  -0x18(%ebp)
  800db9:	8d 45 14             	lea    0x14(%ebp),%eax
  800dbc:	50                   	push   %eax
  800dbd:	e8 3c fd ff ff       	call   800afe <getint>
  800dc2:	83 c4 10             	add    $0x10,%esp
  800dc5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dc8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800dcb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800dd1:	85 d2                	test   %edx,%edx
  800dd3:	79 23                	jns    800df8 <vprintfmt+0x29b>
				putch('-', putdat);
  800dd5:	83 ec 08             	sub    $0x8,%esp
  800dd8:	ff 75 0c             	pushl  0xc(%ebp)
  800ddb:	6a 2d                	push   $0x2d
  800ddd:	8b 45 08             	mov    0x8(%ebp),%eax
  800de0:	ff d0                	call   *%eax
  800de2:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800de5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800de8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800deb:	f7 d8                	neg    %eax
  800ded:	83 d2 00             	adc    $0x0,%edx
  800df0:	f7 da                	neg    %edx
  800df2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800df5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800df8:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800dff:	e9 bc 00 00 00       	jmp    800ec0 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800e04:	83 ec 08             	sub    $0x8,%esp
  800e07:	ff 75 e8             	pushl  -0x18(%ebp)
  800e0a:	8d 45 14             	lea    0x14(%ebp),%eax
  800e0d:	50                   	push   %eax
  800e0e:	e8 84 fc ff ff       	call   800a97 <getuint>
  800e13:	83 c4 10             	add    $0x10,%esp
  800e16:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e19:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800e1c:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e23:	e9 98 00 00 00       	jmp    800ec0 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800e28:	83 ec 08             	sub    $0x8,%esp
  800e2b:	ff 75 0c             	pushl  0xc(%ebp)
  800e2e:	6a 58                	push   $0x58
  800e30:	8b 45 08             	mov    0x8(%ebp),%eax
  800e33:	ff d0                	call   *%eax
  800e35:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e38:	83 ec 08             	sub    $0x8,%esp
  800e3b:	ff 75 0c             	pushl  0xc(%ebp)
  800e3e:	6a 58                	push   $0x58
  800e40:	8b 45 08             	mov    0x8(%ebp),%eax
  800e43:	ff d0                	call   *%eax
  800e45:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e48:	83 ec 08             	sub    $0x8,%esp
  800e4b:	ff 75 0c             	pushl  0xc(%ebp)
  800e4e:	6a 58                	push   $0x58
  800e50:	8b 45 08             	mov    0x8(%ebp),%eax
  800e53:	ff d0                	call   *%eax
  800e55:	83 c4 10             	add    $0x10,%esp
			break;
  800e58:	e9 bc 00 00 00       	jmp    800f19 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800e5d:	83 ec 08             	sub    $0x8,%esp
  800e60:	ff 75 0c             	pushl  0xc(%ebp)
  800e63:	6a 30                	push   $0x30
  800e65:	8b 45 08             	mov    0x8(%ebp),%eax
  800e68:	ff d0                	call   *%eax
  800e6a:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800e6d:	83 ec 08             	sub    $0x8,%esp
  800e70:	ff 75 0c             	pushl  0xc(%ebp)
  800e73:	6a 78                	push   $0x78
  800e75:	8b 45 08             	mov    0x8(%ebp),%eax
  800e78:	ff d0                	call   *%eax
  800e7a:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800e7d:	8b 45 14             	mov    0x14(%ebp),%eax
  800e80:	83 c0 04             	add    $0x4,%eax
  800e83:	89 45 14             	mov    %eax,0x14(%ebp)
  800e86:	8b 45 14             	mov    0x14(%ebp),%eax
  800e89:	83 e8 04             	sub    $0x4,%eax
  800e8c:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e8e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e91:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800e98:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800e9f:	eb 1f                	jmp    800ec0 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800ea1:	83 ec 08             	sub    $0x8,%esp
  800ea4:	ff 75 e8             	pushl  -0x18(%ebp)
  800ea7:	8d 45 14             	lea    0x14(%ebp),%eax
  800eaa:	50                   	push   %eax
  800eab:	e8 e7 fb ff ff       	call   800a97 <getuint>
  800eb0:	83 c4 10             	add    $0x10,%esp
  800eb3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800eb6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800eb9:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ec0:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800ec4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ec7:	83 ec 04             	sub    $0x4,%esp
  800eca:	52                   	push   %edx
  800ecb:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ece:	50                   	push   %eax
  800ecf:	ff 75 f4             	pushl  -0xc(%ebp)
  800ed2:	ff 75 f0             	pushl  -0x10(%ebp)
  800ed5:	ff 75 0c             	pushl  0xc(%ebp)
  800ed8:	ff 75 08             	pushl  0x8(%ebp)
  800edb:	e8 00 fb ff ff       	call   8009e0 <printnum>
  800ee0:	83 c4 20             	add    $0x20,%esp
			break;
  800ee3:	eb 34                	jmp    800f19 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ee5:	83 ec 08             	sub    $0x8,%esp
  800ee8:	ff 75 0c             	pushl  0xc(%ebp)
  800eeb:	53                   	push   %ebx
  800eec:	8b 45 08             	mov    0x8(%ebp),%eax
  800eef:	ff d0                	call   *%eax
  800ef1:	83 c4 10             	add    $0x10,%esp
			break;
  800ef4:	eb 23                	jmp    800f19 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ef6:	83 ec 08             	sub    $0x8,%esp
  800ef9:	ff 75 0c             	pushl  0xc(%ebp)
  800efc:	6a 25                	push   $0x25
  800efe:	8b 45 08             	mov    0x8(%ebp),%eax
  800f01:	ff d0                	call   *%eax
  800f03:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800f06:	ff 4d 10             	decl   0x10(%ebp)
  800f09:	eb 03                	jmp    800f0e <vprintfmt+0x3b1>
  800f0b:	ff 4d 10             	decl   0x10(%ebp)
  800f0e:	8b 45 10             	mov    0x10(%ebp),%eax
  800f11:	48                   	dec    %eax
  800f12:	8a 00                	mov    (%eax),%al
  800f14:	3c 25                	cmp    $0x25,%al
  800f16:	75 f3                	jne    800f0b <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800f18:	90                   	nop
		}
	}
  800f19:	e9 47 fc ff ff       	jmp    800b65 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800f1e:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800f1f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f22:	5b                   	pop    %ebx
  800f23:	5e                   	pop    %esi
  800f24:	5d                   	pop    %ebp
  800f25:	c3                   	ret    

00800f26 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800f26:	55                   	push   %ebp
  800f27:	89 e5                	mov    %esp,%ebp
  800f29:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800f2c:	8d 45 10             	lea    0x10(%ebp),%eax
  800f2f:	83 c0 04             	add    $0x4,%eax
  800f32:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800f35:	8b 45 10             	mov    0x10(%ebp),%eax
  800f38:	ff 75 f4             	pushl  -0xc(%ebp)
  800f3b:	50                   	push   %eax
  800f3c:	ff 75 0c             	pushl  0xc(%ebp)
  800f3f:	ff 75 08             	pushl  0x8(%ebp)
  800f42:	e8 16 fc ff ff       	call   800b5d <vprintfmt>
  800f47:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800f4a:	90                   	nop
  800f4b:	c9                   	leave  
  800f4c:	c3                   	ret    

00800f4d <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800f4d:	55                   	push   %ebp
  800f4e:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800f50:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f53:	8b 40 08             	mov    0x8(%eax),%eax
  800f56:	8d 50 01             	lea    0x1(%eax),%edx
  800f59:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f5c:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800f5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f62:	8b 10                	mov    (%eax),%edx
  800f64:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f67:	8b 40 04             	mov    0x4(%eax),%eax
  800f6a:	39 c2                	cmp    %eax,%edx
  800f6c:	73 12                	jae    800f80 <sprintputch+0x33>
		*b->buf++ = ch;
  800f6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f71:	8b 00                	mov    (%eax),%eax
  800f73:	8d 48 01             	lea    0x1(%eax),%ecx
  800f76:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f79:	89 0a                	mov    %ecx,(%edx)
  800f7b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f7e:	88 10                	mov    %dl,(%eax)
}
  800f80:	90                   	nop
  800f81:	5d                   	pop    %ebp
  800f82:	c3                   	ret    

00800f83 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800f83:	55                   	push   %ebp
  800f84:	89 e5                	mov    %esp,%ebp
  800f86:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800f89:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800f8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f92:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f95:	8b 45 08             	mov    0x8(%ebp),%eax
  800f98:	01 d0                	add    %edx,%eax
  800f9a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f9d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800fa4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800fa8:	74 06                	je     800fb0 <vsnprintf+0x2d>
  800faa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800fae:	7f 07                	jg     800fb7 <vsnprintf+0x34>
		return -E_INVAL;
  800fb0:	b8 03 00 00 00       	mov    $0x3,%eax
  800fb5:	eb 20                	jmp    800fd7 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800fb7:	ff 75 14             	pushl  0x14(%ebp)
  800fba:	ff 75 10             	pushl  0x10(%ebp)
  800fbd:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800fc0:	50                   	push   %eax
  800fc1:	68 4d 0f 80 00       	push   $0x800f4d
  800fc6:	e8 92 fb ff ff       	call   800b5d <vprintfmt>
  800fcb:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800fce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800fd1:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800fd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800fd7:	c9                   	leave  
  800fd8:	c3                   	ret    

00800fd9 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800fd9:	55                   	push   %ebp
  800fda:	89 e5                	mov    %esp,%ebp
  800fdc:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800fdf:	8d 45 10             	lea    0x10(%ebp),%eax
  800fe2:	83 c0 04             	add    $0x4,%eax
  800fe5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800fe8:	8b 45 10             	mov    0x10(%ebp),%eax
  800feb:	ff 75 f4             	pushl  -0xc(%ebp)
  800fee:	50                   	push   %eax
  800fef:	ff 75 0c             	pushl  0xc(%ebp)
  800ff2:	ff 75 08             	pushl  0x8(%ebp)
  800ff5:	e8 89 ff ff ff       	call   800f83 <vsnprintf>
  800ffa:	83 c4 10             	add    $0x10,%esp
  800ffd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801000:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801003:	c9                   	leave  
  801004:	c3                   	ret    

00801005 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801005:	55                   	push   %ebp
  801006:	89 e5                	mov    %esp,%ebp
  801008:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80100b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801012:	eb 06                	jmp    80101a <strlen+0x15>
		n++;
  801014:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801017:	ff 45 08             	incl   0x8(%ebp)
  80101a:	8b 45 08             	mov    0x8(%ebp),%eax
  80101d:	8a 00                	mov    (%eax),%al
  80101f:	84 c0                	test   %al,%al
  801021:	75 f1                	jne    801014 <strlen+0xf>
		n++;
	return n;
  801023:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801026:	c9                   	leave  
  801027:	c3                   	ret    

00801028 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801028:	55                   	push   %ebp
  801029:	89 e5                	mov    %esp,%ebp
  80102b:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80102e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801035:	eb 09                	jmp    801040 <strnlen+0x18>
		n++;
  801037:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80103a:	ff 45 08             	incl   0x8(%ebp)
  80103d:	ff 4d 0c             	decl   0xc(%ebp)
  801040:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801044:	74 09                	je     80104f <strnlen+0x27>
  801046:	8b 45 08             	mov    0x8(%ebp),%eax
  801049:	8a 00                	mov    (%eax),%al
  80104b:	84 c0                	test   %al,%al
  80104d:	75 e8                	jne    801037 <strnlen+0xf>
		n++;
	return n;
  80104f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801052:	c9                   	leave  
  801053:	c3                   	ret    

00801054 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801054:	55                   	push   %ebp
  801055:	89 e5                	mov    %esp,%ebp
  801057:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80105a:	8b 45 08             	mov    0x8(%ebp),%eax
  80105d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801060:	90                   	nop
  801061:	8b 45 08             	mov    0x8(%ebp),%eax
  801064:	8d 50 01             	lea    0x1(%eax),%edx
  801067:	89 55 08             	mov    %edx,0x8(%ebp)
  80106a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80106d:	8d 4a 01             	lea    0x1(%edx),%ecx
  801070:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801073:	8a 12                	mov    (%edx),%dl
  801075:	88 10                	mov    %dl,(%eax)
  801077:	8a 00                	mov    (%eax),%al
  801079:	84 c0                	test   %al,%al
  80107b:	75 e4                	jne    801061 <strcpy+0xd>
		/* do nothing */;
	return ret;
  80107d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801080:	c9                   	leave  
  801081:	c3                   	ret    

00801082 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801082:	55                   	push   %ebp
  801083:	89 e5                	mov    %esp,%ebp
  801085:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801088:	8b 45 08             	mov    0x8(%ebp),%eax
  80108b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  80108e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801095:	eb 1f                	jmp    8010b6 <strncpy+0x34>
		*dst++ = *src;
  801097:	8b 45 08             	mov    0x8(%ebp),%eax
  80109a:	8d 50 01             	lea    0x1(%eax),%edx
  80109d:	89 55 08             	mov    %edx,0x8(%ebp)
  8010a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010a3:	8a 12                	mov    (%edx),%dl
  8010a5:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8010a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010aa:	8a 00                	mov    (%eax),%al
  8010ac:	84 c0                	test   %al,%al
  8010ae:	74 03                	je     8010b3 <strncpy+0x31>
			src++;
  8010b0:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8010b3:	ff 45 fc             	incl   -0x4(%ebp)
  8010b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010b9:	3b 45 10             	cmp    0x10(%ebp),%eax
  8010bc:	72 d9                	jb     801097 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8010be:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8010c1:	c9                   	leave  
  8010c2:	c3                   	ret    

008010c3 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8010c3:	55                   	push   %ebp
  8010c4:	89 e5                	mov    %esp,%ebp
  8010c6:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8010c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8010cf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010d3:	74 30                	je     801105 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8010d5:	eb 16                	jmp    8010ed <strlcpy+0x2a>
			*dst++ = *src++;
  8010d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010da:	8d 50 01             	lea    0x1(%eax),%edx
  8010dd:	89 55 08             	mov    %edx,0x8(%ebp)
  8010e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010e3:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010e6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8010e9:	8a 12                	mov    (%edx),%dl
  8010eb:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8010ed:	ff 4d 10             	decl   0x10(%ebp)
  8010f0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010f4:	74 09                	je     8010ff <strlcpy+0x3c>
  8010f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f9:	8a 00                	mov    (%eax),%al
  8010fb:	84 c0                	test   %al,%al
  8010fd:	75 d8                	jne    8010d7 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8010ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801102:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801105:	8b 55 08             	mov    0x8(%ebp),%edx
  801108:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80110b:	29 c2                	sub    %eax,%edx
  80110d:	89 d0                	mov    %edx,%eax
}
  80110f:	c9                   	leave  
  801110:	c3                   	ret    

00801111 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801111:	55                   	push   %ebp
  801112:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801114:	eb 06                	jmp    80111c <strcmp+0xb>
		p++, q++;
  801116:	ff 45 08             	incl   0x8(%ebp)
  801119:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80111c:	8b 45 08             	mov    0x8(%ebp),%eax
  80111f:	8a 00                	mov    (%eax),%al
  801121:	84 c0                	test   %al,%al
  801123:	74 0e                	je     801133 <strcmp+0x22>
  801125:	8b 45 08             	mov    0x8(%ebp),%eax
  801128:	8a 10                	mov    (%eax),%dl
  80112a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80112d:	8a 00                	mov    (%eax),%al
  80112f:	38 c2                	cmp    %al,%dl
  801131:	74 e3                	je     801116 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801133:	8b 45 08             	mov    0x8(%ebp),%eax
  801136:	8a 00                	mov    (%eax),%al
  801138:	0f b6 d0             	movzbl %al,%edx
  80113b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80113e:	8a 00                	mov    (%eax),%al
  801140:	0f b6 c0             	movzbl %al,%eax
  801143:	29 c2                	sub    %eax,%edx
  801145:	89 d0                	mov    %edx,%eax
}
  801147:	5d                   	pop    %ebp
  801148:	c3                   	ret    

00801149 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801149:	55                   	push   %ebp
  80114a:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80114c:	eb 09                	jmp    801157 <strncmp+0xe>
		n--, p++, q++;
  80114e:	ff 4d 10             	decl   0x10(%ebp)
  801151:	ff 45 08             	incl   0x8(%ebp)
  801154:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801157:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80115b:	74 17                	je     801174 <strncmp+0x2b>
  80115d:	8b 45 08             	mov    0x8(%ebp),%eax
  801160:	8a 00                	mov    (%eax),%al
  801162:	84 c0                	test   %al,%al
  801164:	74 0e                	je     801174 <strncmp+0x2b>
  801166:	8b 45 08             	mov    0x8(%ebp),%eax
  801169:	8a 10                	mov    (%eax),%dl
  80116b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116e:	8a 00                	mov    (%eax),%al
  801170:	38 c2                	cmp    %al,%dl
  801172:	74 da                	je     80114e <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801174:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801178:	75 07                	jne    801181 <strncmp+0x38>
		return 0;
  80117a:	b8 00 00 00 00       	mov    $0x0,%eax
  80117f:	eb 14                	jmp    801195 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801181:	8b 45 08             	mov    0x8(%ebp),%eax
  801184:	8a 00                	mov    (%eax),%al
  801186:	0f b6 d0             	movzbl %al,%edx
  801189:	8b 45 0c             	mov    0xc(%ebp),%eax
  80118c:	8a 00                	mov    (%eax),%al
  80118e:	0f b6 c0             	movzbl %al,%eax
  801191:	29 c2                	sub    %eax,%edx
  801193:	89 d0                	mov    %edx,%eax
}
  801195:	5d                   	pop    %ebp
  801196:	c3                   	ret    

00801197 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801197:	55                   	push   %ebp
  801198:	89 e5                	mov    %esp,%ebp
  80119a:	83 ec 04             	sub    $0x4,%esp
  80119d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a0:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8011a3:	eb 12                	jmp    8011b7 <strchr+0x20>
		if (*s == c)
  8011a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a8:	8a 00                	mov    (%eax),%al
  8011aa:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8011ad:	75 05                	jne    8011b4 <strchr+0x1d>
			return (char *) s;
  8011af:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b2:	eb 11                	jmp    8011c5 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8011b4:	ff 45 08             	incl   0x8(%ebp)
  8011b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ba:	8a 00                	mov    (%eax),%al
  8011bc:	84 c0                	test   %al,%al
  8011be:	75 e5                	jne    8011a5 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8011c0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011c5:	c9                   	leave  
  8011c6:	c3                   	ret    

008011c7 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8011c7:	55                   	push   %ebp
  8011c8:	89 e5                	mov    %esp,%ebp
  8011ca:	83 ec 04             	sub    $0x4,%esp
  8011cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d0:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8011d3:	eb 0d                	jmp    8011e2 <strfind+0x1b>
		if (*s == c)
  8011d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d8:	8a 00                	mov    (%eax),%al
  8011da:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8011dd:	74 0e                	je     8011ed <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8011df:	ff 45 08             	incl   0x8(%ebp)
  8011e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e5:	8a 00                	mov    (%eax),%al
  8011e7:	84 c0                	test   %al,%al
  8011e9:	75 ea                	jne    8011d5 <strfind+0xe>
  8011eb:	eb 01                	jmp    8011ee <strfind+0x27>
		if (*s == c)
			break;
  8011ed:	90                   	nop
	return (char *) s;
  8011ee:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011f1:	c9                   	leave  
  8011f2:	c3                   	ret    

008011f3 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8011f3:	55                   	push   %ebp
  8011f4:	89 e5                	mov    %esp,%ebp
  8011f6:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8011f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8011ff:	8b 45 10             	mov    0x10(%ebp),%eax
  801202:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801205:	eb 0e                	jmp    801215 <memset+0x22>
		*p++ = c;
  801207:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80120a:	8d 50 01             	lea    0x1(%eax),%edx
  80120d:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801210:	8b 55 0c             	mov    0xc(%ebp),%edx
  801213:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801215:	ff 4d f8             	decl   -0x8(%ebp)
  801218:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80121c:	79 e9                	jns    801207 <memset+0x14>
		*p++ = c;

	return v;
  80121e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801221:	c9                   	leave  
  801222:	c3                   	ret    

00801223 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801223:	55                   	push   %ebp
  801224:	89 e5                	mov    %esp,%ebp
  801226:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801229:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80122f:	8b 45 08             	mov    0x8(%ebp),%eax
  801232:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801235:	eb 16                	jmp    80124d <memcpy+0x2a>
		*d++ = *s++;
  801237:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80123a:	8d 50 01             	lea    0x1(%eax),%edx
  80123d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801240:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801243:	8d 4a 01             	lea    0x1(%edx),%ecx
  801246:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801249:	8a 12                	mov    (%edx),%dl
  80124b:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  80124d:	8b 45 10             	mov    0x10(%ebp),%eax
  801250:	8d 50 ff             	lea    -0x1(%eax),%edx
  801253:	89 55 10             	mov    %edx,0x10(%ebp)
  801256:	85 c0                	test   %eax,%eax
  801258:	75 dd                	jne    801237 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80125a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80125d:	c9                   	leave  
  80125e:	c3                   	ret    

0080125f <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80125f:	55                   	push   %ebp
  801260:	89 e5                	mov    %esp,%ebp
  801262:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801265:	8b 45 0c             	mov    0xc(%ebp),%eax
  801268:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80126b:	8b 45 08             	mov    0x8(%ebp),%eax
  80126e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801271:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801274:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801277:	73 50                	jae    8012c9 <memmove+0x6a>
  801279:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80127c:	8b 45 10             	mov    0x10(%ebp),%eax
  80127f:	01 d0                	add    %edx,%eax
  801281:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801284:	76 43                	jbe    8012c9 <memmove+0x6a>
		s += n;
  801286:	8b 45 10             	mov    0x10(%ebp),%eax
  801289:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80128c:	8b 45 10             	mov    0x10(%ebp),%eax
  80128f:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801292:	eb 10                	jmp    8012a4 <memmove+0x45>
			*--d = *--s;
  801294:	ff 4d f8             	decl   -0x8(%ebp)
  801297:	ff 4d fc             	decl   -0x4(%ebp)
  80129a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80129d:	8a 10                	mov    (%eax),%dl
  80129f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012a2:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8012a4:	8b 45 10             	mov    0x10(%ebp),%eax
  8012a7:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012aa:	89 55 10             	mov    %edx,0x10(%ebp)
  8012ad:	85 c0                	test   %eax,%eax
  8012af:	75 e3                	jne    801294 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8012b1:	eb 23                	jmp    8012d6 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8012b3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012b6:	8d 50 01             	lea    0x1(%eax),%edx
  8012b9:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012bc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012bf:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012c2:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8012c5:	8a 12                	mov    (%edx),%dl
  8012c7:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8012c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8012cc:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012cf:	89 55 10             	mov    %edx,0x10(%ebp)
  8012d2:	85 c0                	test   %eax,%eax
  8012d4:	75 dd                	jne    8012b3 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8012d6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012d9:	c9                   	leave  
  8012da:	c3                   	ret    

008012db <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8012db:	55                   	push   %ebp
  8012dc:	89 e5                	mov    %esp,%ebp
  8012de:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8012e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8012e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ea:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8012ed:	eb 2a                	jmp    801319 <memcmp+0x3e>
		if (*s1 != *s2)
  8012ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012f2:	8a 10                	mov    (%eax),%dl
  8012f4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012f7:	8a 00                	mov    (%eax),%al
  8012f9:	38 c2                	cmp    %al,%dl
  8012fb:	74 16                	je     801313 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8012fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801300:	8a 00                	mov    (%eax),%al
  801302:	0f b6 d0             	movzbl %al,%edx
  801305:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801308:	8a 00                	mov    (%eax),%al
  80130a:	0f b6 c0             	movzbl %al,%eax
  80130d:	29 c2                	sub    %eax,%edx
  80130f:	89 d0                	mov    %edx,%eax
  801311:	eb 18                	jmp    80132b <memcmp+0x50>
		s1++, s2++;
  801313:	ff 45 fc             	incl   -0x4(%ebp)
  801316:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801319:	8b 45 10             	mov    0x10(%ebp),%eax
  80131c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80131f:	89 55 10             	mov    %edx,0x10(%ebp)
  801322:	85 c0                	test   %eax,%eax
  801324:	75 c9                	jne    8012ef <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801326:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80132b:	c9                   	leave  
  80132c:	c3                   	ret    

0080132d <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80132d:	55                   	push   %ebp
  80132e:	89 e5                	mov    %esp,%ebp
  801330:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801333:	8b 55 08             	mov    0x8(%ebp),%edx
  801336:	8b 45 10             	mov    0x10(%ebp),%eax
  801339:	01 d0                	add    %edx,%eax
  80133b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80133e:	eb 15                	jmp    801355 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801340:	8b 45 08             	mov    0x8(%ebp),%eax
  801343:	8a 00                	mov    (%eax),%al
  801345:	0f b6 d0             	movzbl %al,%edx
  801348:	8b 45 0c             	mov    0xc(%ebp),%eax
  80134b:	0f b6 c0             	movzbl %al,%eax
  80134e:	39 c2                	cmp    %eax,%edx
  801350:	74 0d                	je     80135f <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801352:	ff 45 08             	incl   0x8(%ebp)
  801355:	8b 45 08             	mov    0x8(%ebp),%eax
  801358:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80135b:	72 e3                	jb     801340 <memfind+0x13>
  80135d:	eb 01                	jmp    801360 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80135f:	90                   	nop
	return (void *) s;
  801360:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801363:	c9                   	leave  
  801364:	c3                   	ret    

00801365 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801365:	55                   	push   %ebp
  801366:	89 e5                	mov    %esp,%ebp
  801368:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80136b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801372:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801379:	eb 03                	jmp    80137e <strtol+0x19>
		s++;
  80137b:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80137e:	8b 45 08             	mov    0x8(%ebp),%eax
  801381:	8a 00                	mov    (%eax),%al
  801383:	3c 20                	cmp    $0x20,%al
  801385:	74 f4                	je     80137b <strtol+0x16>
  801387:	8b 45 08             	mov    0x8(%ebp),%eax
  80138a:	8a 00                	mov    (%eax),%al
  80138c:	3c 09                	cmp    $0x9,%al
  80138e:	74 eb                	je     80137b <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801390:	8b 45 08             	mov    0x8(%ebp),%eax
  801393:	8a 00                	mov    (%eax),%al
  801395:	3c 2b                	cmp    $0x2b,%al
  801397:	75 05                	jne    80139e <strtol+0x39>
		s++;
  801399:	ff 45 08             	incl   0x8(%ebp)
  80139c:	eb 13                	jmp    8013b1 <strtol+0x4c>
	else if (*s == '-')
  80139e:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a1:	8a 00                	mov    (%eax),%al
  8013a3:	3c 2d                	cmp    $0x2d,%al
  8013a5:	75 0a                	jne    8013b1 <strtol+0x4c>
		s++, neg = 1;
  8013a7:	ff 45 08             	incl   0x8(%ebp)
  8013aa:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8013b1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013b5:	74 06                	je     8013bd <strtol+0x58>
  8013b7:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8013bb:	75 20                	jne    8013dd <strtol+0x78>
  8013bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c0:	8a 00                	mov    (%eax),%al
  8013c2:	3c 30                	cmp    $0x30,%al
  8013c4:	75 17                	jne    8013dd <strtol+0x78>
  8013c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c9:	40                   	inc    %eax
  8013ca:	8a 00                	mov    (%eax),%al
  8013cc:	3c 78                	cmp    $0x78,%al
  8013ce:	75 0d                	jne    8013dd <strtol+0x78>
		s += 2, base = 16;
  8013d0:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8013d4:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8013db:	eb 28                	jmp    801405 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8013dd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013e1:	75 15                	jne    8013f8 <strtol+0x93>
  8013e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e6:	8a 00                	mov    (%eax),%al
  8013e8:	3c 30                	cmp    $0x30,%al
  8013ea:	75 0c                	jne    8013f8 <strtol+0x93>
		s++, base = 8;
  8013ec:	ff 45 08             	incl   0x8(%ebp)
  8013ef:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8013f6:	eb 0d                	jmp    801405 <strtol+0xa0>
	else if (base == 0)
  8013f8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013fc:	75 07                	jne    801405 <strtol+0xa0>
		base = 10;
  8013fe:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801405:	8b 45 08             	mov    0x8(%ebp),%eax
  801408:	8a 00                	mov    (%eax),%al
  80140a:	3c 2f                	cmp    $0x2f,%al
  80140c:	7e 19                	jle    801427 <strtol+0xc2>
  80140e:	8b 45 08             	mov    0x8(%ebp),%eax
  801411:	8a 00                	mov    (%eax),%al
  801413:	3c 39                	cmp    $0x39,%al
  801415:	7f 10                	jg     801427 <strtol+0xc2>
			dig = *s - '0';
  801417:	8b 45 08             	mov    0x8(%ebp),%eax
  80141a:	8a 00                	mov    (%eax),%al
  80141c:	0f be c0             	movsbl %al,%eax
  80141f:	83 e8 30             	sub    $0x30,%eax
  801422:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801425:	eb 42                	jmp    801469 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801427:	8b 45 08             	mov    0x8(%ebp),%eax
  80142a:	8a 00                	mov    (%eax),%al
  80142c:	3c 60                	cmp    $0x60,%al
  80142e:	7e 19                	jle    801449 <strtol+0xe4>
  801430:	8b 45 08             	mov    0x8(%ebp),%eax
  801433:	8a 00                	mov    (%eax),%al
  801435:	3c 7a                	cmp    $0x7a,%al
  801437:	7f 10                	jg     801449 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801439:	8b 45 08             	mov    0x8(%ebp),%eax
  80143c:	8a 00                	mov    (%eax),%al
  80143e:	0f be c0             	movsbl %al,%eax
  801441:	83 e8 57             	sub    $0x57,%eax
  801444:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801447:	eb 20                	jmp    801469 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801449:	8b 45 08             	mov    0x8(%ebp),%eax
  80144c:	8a 00                	mov    (%eax),%al
  80144e:	3c 40                	cmp    $0x40,%al
  801450:	7e 39                	jle    80148b <strtol+0x126>
  801452:	8b 45 08             	mov    0x8(%ebp),%eax
  801455:	8a 00                	mov    (%eax),%al
  801457:	3c 5a                	cmp    $0x5a,%al
  801459:	7f 30                	jg     80148b <strtol+0x126>
			dig = *s - 'A' + 10;
  80145b:	8b 45 08             	mov    0x8(%ebp),%eax
  80145e:	8a 00                	mov    (%eax),%al
  801460:	0f be c0             	movsbl %al,%eax
  801463:	83 e8 37             	sub    $0x37,%eax
  801466:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801469:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80146c:	3b 45 10             	cmp    0x10(%ebp),%eax
  80146f:	7d 19                	jge    80148a <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801471:	ff 45 08             	incl   0x8(%ebp)
  801474:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801477:	0f af 45 10          	imul   0x10(%ebp),%eax
  80147b:	89 c2                	mov    %eax,%edx
  80147d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801480:	01 d0                	add    %edx,%eax
  801482:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801485:	e9 7b ff ff ff       	jmp    801405 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80148a:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80148b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80148f:	74 08                	je     801499 <strtol+0x134>
		*endptr = (char *) s;
  801491:	8b 45 0c             	mov    0xc(%ebp),%eax
  801494:	8b 55 08             	mov    0x8(%ebp),%edx
  801497:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801499:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80149d:	74 07                	je     8014a6 <strtol+0x141>
  80149f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014a2:	f7 d8                	neg    %eax
  8014a4:	eb 03                	jmp    8014a9 <strtol+0x144>
  8014a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8014a9:	c9                   	leave  
  8014aa:	c3                   	ret    

008014ab <ltostr>:

void
ltostr(long value, char *str)
{
  8014ab:	55                   	push   %ebp
  8014ac:	89 e5                	mov    %esp,%ebp
  8014ae:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8014b1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8014b8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8014bf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014c3:	79 13                	jns    8014d8 <ltostr+0x2d>
	{
		neg = 1;
  8014c5:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8014cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014cf:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8014d2:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8014d5:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8014d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014db:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8014e0:	99                   	cltd   
  8014e1:	f7 f9                	idiv   %ecx
  8014e3:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8014e6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014e9:	8d 50 01             	lea    0x1(%eax),%edx
  8014ec:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8014ef:	89 c2                	mov    %eax,%edx
  8014f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014f4:	01 d0                	add    %edx,%eax
  8014f6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8014f9:	83 c2 30             	add    $0x30,%edx
  8014fc:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8014fe:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801501:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801506:	f7 e9                	imul   %ecx
  801508:	c1 fa 02             	sar    $0x2,%edx
  80150b:	89 c8                	mov    %ecx,%eax
  80150d:	c1 f8 1f             	sar    $0x1f,%eax
  801510:	29 c2                	sub    %eax,%edx
  801512:	89 d0                	mov    %edx,%eax
  801514:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801517:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80151a:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80151f:	f7 e9                	imul   %ecx
  801521:	c1 fa 02             	sar    $0x2,%edx
  801524:	89 c8                	mov    %ecx,%eax
  801526:	c1 f8 1f             	sar    $0x1f,%eax
  801529:	29 c2                	sub    %eax,%edx
  80152b:	89 d0                	mov    %edx,%eax
  80152d:	c1 e0 02             	shl    $0x2,%eax
  801530:	01 d0                	add    %edx,%eax
  801532:	01 c0                	add    %eax,%eax
  801534:	29 c1                	sub    %eax,%ecx
  801536:	89 ca                	mov    %ecx,%edx
  801538:	85 d2                	test   %edx,%edx
  80153a:	75 9c                	jne    8014d8 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80153c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801543:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801546:	48                   	dec    %eax
  801547:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80154a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80154e:	74 3d                	je     80158d <ltostr+0xe2>
		start = 1 ;
  801550:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801557:	eb 34                	jmp    80158d <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801559:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80155c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80155f:	01 d0                	add    %edx,%eax
  801561:	8a 00                	mov    (%eax),%al
  801563:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801566:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801569:	8b 45 0c             	mov    0xc(%ebp),%eax
  80156c:	01 c2                	add    %eax,%edx
  80156e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801571:	8b 45 0c             	mov    0xc(%ebp),%eax
  801574:	01 c8                	add    %ecx,%eax
  801576:	8a 00                	mov    (%eax),%al
  801578:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80157a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80157d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801580:	01 c2                	add    %eax,%edx
  801582:	8a 45 eb             	mov    -0x15(%ebp),%al
  801585:	88 02                	mov    %al,(%edx)
		start++ ;
  801587:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80158a:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80158d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801590:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801593:	7c c4                	jl     801559 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801595:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801598:	8b 45 0c             	mov    0xc(%ebp),%eax
  80159b:	01 d0                	add    %edx,%eax
  80159d:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8015a0:	90                   	nop
  8015a1:	c9                   	leave  
  8015a2:	c3                   	ret    

008015a3 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8015a3:	55                   	push   %ebp
  8015a4:	89 e5                	mov    %esp,%ebp
  8015a6:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8015a9:	ff 75 08             	pushl  0x8(%ebp)
  8015ac:	e8 54 fa ff ff       	call   801005 <strlen>
  8015b1:	83 c4 04             	add    $0x4,%esp
  8015b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8015b7:	ff 75 0c             	pushl  0xc(%ebp)
  8015ba:	e8 46 fa ff ff       	call   801005 <strlen>
  8015bf:	83 c4 04             	add    $0x4,%esp
  8015c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8015c5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8015cc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015d3:	eb 17                	jmp    8015ec <strcconcat+0x49>
		final[s] = str1[s] ;
  8015d5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8015db:	01 c2                	add    %eax,%edx
  8015dd:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8015e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e3:	01 c8                	add    %ecx,%eax
  8015e5:	8a 00                	mov    (%eax),%al
  8015e7:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8015e9:	ff 45 fc             	incl   -0x4(%ebp)
  8015ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015ef:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8015f2:	7c e1                	jl     8015d5 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8015f4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8015fb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801602:	eb 1f                	jmp    801623 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801604:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801607:	8d 50 01             	lea    0x1(%eax),%edx
  80160a:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80160d:	89 c2                	mov    %eax,%edx
  80160f:	8b 45 10             	mov    0x10(%ebp),%eax
  801612:	01 c2                	add    %eax,%edx
  801614:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801617:	8b 45 0c             	mov    0xc(%ebp),%eax
  80161a:	01 c8                	add    %ecx,%eax
  80161c:	8a 00                	mov    (%eax),%al
  80161e:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801620:	ff 45 f8             	incl   -0x8(%ebp)
  801623:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801626:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801629:	7c d9                	jl     801604 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80162b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80162e:	8b 45 10             	mov    0x10(%ebp),%eax
  801631:	01 d0                	add    %edx,%eax
  801633:	c6 00 00             	movb   $0x0,(%eax)
}
  801636:	90                   	nop
  801637:	c9                   	leave  
  801638:	c3                   	ret    

00801639 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801639:	55                   	push   %ebp
  80163a:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80163c:	8b 45 14             	mov    0x14(%ebp),%eax
  80163f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801645:	8b 45 14             	mov    0x14(%ebp),%eax
  801648:	8b 00                	mov    (%eax),%eax
  80164a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801651:	8b 45 10             	mov    0x10(%ebp),%eax
  801654:	01 d0                	add    %edx,%eax
  801656:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80165c:	eb 0c                	jmp    80166a <strsplit+0x31>
			*string++ = 0;
  80165e:	8b 45 08             	mov    0x8(%ebp),%eax
  801661:	8d 50 01             	lea    0x1(%eax),%edx
  801664:	89 55 08             	mov    %edx,0x8(%ebp)
  801667:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80166a:	8b 45 08             	mov    0x8(%ebp),%eax
  80166d:	8a 00                	mov    (%eax),%al
  80166f:	84 c0                	test   %al,%al
  801671:	74 18                	je     80168b <strsplit+0x52>
  801673:	8b 45 08             	mov    0x8(%ebp),%eax
  801676:	8a 00                	mov    (%eax),%al
  801678:	0f be c0             	movsbl %al,%eax
  80167b:	50                   	push   %eax
  80167c:	ff 75 0c             	pushl  0xc(%ebp)
  80167f:	e8 13 fb ff ff       	call   801197 <strchr>
  801684:	83 c4 08             	add    $0x8,%esp
  801687:	85 c0                	test   %eax,%eax
  801689:	75 d3                	jne    80165e <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80168b:	8b 45 08             	mov    0x8(%ebp),%eax
  80168e:	8a 00                	mov    (%eax),%al
  801690:	84 c0                	test   %al,%al
  801692:	74 5a                	je     8016ee <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801694:	8b 45 14             	mov    0x14(%ebp),%eax
  801697:	8b 00                	mov    (%eax),%eax
  801699:	83 f8 0f             	cmp    $0xf,%eax
  80169c:	75 07                	jne    8016a5 <strsplit+0x6c>
		{
			return 0;
  80169e:	b8 00 00 00 00       	mov    $0x0,%eax
  8016a3:	eb 66                	jmp    80170b <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8016a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8016a8:	8b 00                	mov    (%eax),%eax
  8016aa:	8d 48 01             	lea    0x1(%eax),%ecx
  8016ad:	8b 55 14             	mov    0x14(%ebp),%edx
  8016b0:	89 0a                	mov    %ecx,(%edx)
  8016b2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8016bc:	01 c2                	add    %eax,%edx
  8016be:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c1:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8016c3:	eb 03                	jmp    8016c8 <strsplit+0x8f>
			string++;
  8016c5:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8016c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016cb:	8a 00                	mov    (%eax),%al
  8016cd:	84 c0                	test   %al,%al
  8016cf:	74 8b                	je     80165c <strsplit+0x23>
  8016d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d4:	8a 00                	mov    (%eax),%al
  8016d6:	0f be c0             	movsbl %al,%eax
  8016d9:	50                   	push   %eax
  8016da:	ff 75 0c             	pushl  0xc(%ebp)
  8016dd:	e8 b5 fa ff ff       	call   801197 <strchr>
  8016e2:	83 c4 08             	add    $0x8,%esp
  8016e5:	85 c0                	test   %eax,%eax
  8016e7:	74 dc                	je     8016c5 <strsplit+0x8c>
			string++;
	}
  8016e9:	e9 6e ff ff ff       	jmp    80165c <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8016ee:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8016ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8016f2:	8b 00                	mov    (%eax),%eax
  8016f4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8016fe:	01 d0                	add    %edx,%eax
  801700:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801706:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80170b:	c9                   	leave  
  80170c:	c3                   	ret    

0080170d <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  80170d:	55                   	push   %ebp
  80170e:	89 e5                	mov    %esp,%ebp
  801710:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801713:	a1 04 50 80 00       	mov    0x805004,%eax
  801718:	85 c0                	test   %eax,%eax
  80171a:	74 1f                	je     80173b <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  80171c:	e8 1d 00 00 00       	call   80173e <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801721:	83 ec 0c             	sub    $0xc,%esp
  801724:	68 f0 43 80 00       	push   $0x8043f0
  801729:	e8 55 f2 ff ff       	call   800983 <cprintf>
  80172e:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801731:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801738:	00 00 00 
	}
}
  80173b:	90                   	nop
  80173c:	c9                   	leave  
  80173d:	c3                   	ret    

0080173e <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  80173e:	55                   	push   %ebp
  80173f:	89 e5                	mov    %esp,%ebp
  801741:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	LIST_INIT(&AllocMemBlocksList);
  801744:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  80174b:	00 00 00 
  80174e:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801755:	00 00 00 
  801758:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  80175f:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801762:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801769:	00 00 00 
  80176c:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801773:	00 00 00 
  801776:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  80177d:	00 00 00 
	uint32 arr_size = 0;
  801780:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	MemBlockNodes  =(struct MemBlock*) USER_DYN_BLKS_ARRAY;
  801787:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  80178e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801791:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801796:	2d 00 10 00 00       	sub    $0x1000,%eax
  80179b:	a3 50 50 80 00       	mov    %eax,0x805050
	MAX_MEM_BLOCK_CNT = (USER_HEAP_MAX-USER_HEAP_START)/PAGE_SIZE;
  8017a0:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  8017a7:	00 02 00 
	arr_size =  ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock), PAGE_SIZE);
  8017aa:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8017b1:	a1 20 51 80 00       	mov    0x805120,%eax
  8017b6:	c1 e0 04             	shl    $0x4,%eax
  8017b9:	89 c2                	mov    %eax,%edx
  8017bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017be:	01 d0                	add    %edx,%eax
  8017c0:	48                   	dec    %eax
  8017c1:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8017c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017c7:	ba 00 00 00 00       	mov    $0x0,%edx
  8017cc:	f7 75 ec             	divl   -0x14(%ebp)
  8017cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017d2:	29 d0                	sub    %edx,%eax
  8017d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY , arr_size , PERM_WRITEABLE | PERM_USER);
  8017d7:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  8017de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017e1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8017e6:	2d 00 10 00 00       	sub    $0x1000,%eax
  8017eb:	83 ec 04             	sub    $0x4,%esp
  8017ee:	6a 06                	push   $0x6
  8017f0:	ff 75 f4             	pushl  -0xc(%ebp)
  8017f3:	50                   	push   %eax
  8017f4:	e8 6a 04 00 00       	call   801c63 <sys_allocate_chunk>
  8017f9:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8017fc:	a1 20 51 80 00       	mov    0x805120,%eax
  801801:	83 ec 0c             	sub    $0xc,%esp
  801804:	50                   	push   %eax
  801805:	e8 df 0a 00 00       	call   8022e9 <initialize_MemBlocksList>
  80180a:	83 c4 10             	add    $0x10,%esp
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	struct MemBlock * NewBlock = LIST_FIRST(&AvailableMemBlocksList);
  80180d:	a1 48 51 80 00       	mov    0x805148,%eax
  801812:	89 45 e0             	mov    %eax,-0x20(%ebp)
	NewBlock->sva = USER_HEAP_START;
  801815:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801818:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	NewBlock->size = (USER_HEAP_MAX-USER_HEAP_START);
  80181f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801822:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	LIST_REMOVE(&AvailableMemBlocksList,NewBlock);
  801829:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80182d:	75 14                	jne    801843 <initialize_dyn_block_system+0x105>
  80182f:	83 ec 04             	sub    $0x4,%esp
  801832:	68 15 44 80 00       	push   $0x804415
  801837:	6a 33                	push   $0x33
  801839:	68 33 44 80 00       	push   $0x804433
  80183e:	e8 8c ee ff ff       	call   8006cf <_panic>
  801843:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801846:	8b 00                	mov    (%eax),%eax
  801848:	85 c0                	test   %eax,%eax
  80184a:	74 10                	je     80185c <initialize_dyn_block_system+0x11e>
  80184c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80184f:	8b 00                	mov    (%eax),%eax
  801851:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801854:	8b 52 04             	mov    0x4(%edx),%edx
  801857:	89 50 04             	mov    %edx,0x4(%eax)
  80185a:	eb 0b                	jmp    801867 <initialize_dyn_block_system+0x129>
  80185c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80185f:	8b 40 04             	mov    0x4(%eax),%eax
  801862:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801867:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80186a:	8b 40 04             	mov    0x4(%eax),%eax
  80186d:	85 c0                	test   %eax,%eax
  80186f:	74 0f                	je     801880 <initialize_dyn_block_system+0x142>
  801871:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801874:	8b 40 04             	mov    0x4(%eax),%eax
  801877:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80187a:	8b 12                	mov    (%edx),%edx
  80187c:	89 10                	mov    %edx,(%eax)
  80187e:	eb 0a                	jmp    80188a <initialize_dyn_block_system+0x14c>
  801880:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801883:	8b 00                	mov    (%eax),%eax
  801885:	a3 48 51 80 00       	mov    %eax,0x805148
  80188a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80188d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801893:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801896:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80189d:	a1 54 51 80 00       	mov    0x805154,%eax
  8018a2:	48                   	dec    %eax
  8018a3:	a3 54 51 80 00       	mov    %eax,0x805154
	LIST_INSERT_HEAD(&FreeMemBlocksList, NewBlock);
  8018a8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8018ac:	75 14                	jne    8018c2 <initialize_dyn_block_system+0x184>
  8018ae:	83 ec 04             	sub    $0x4,%esp
  8018b1:	68 40 44 80 00       	push   $0x804440
  8018b6:	6a 34                	push   $0x34
  8018b8:	68 33 44 80 00       	push   $0x804433
  8018bd:	e8 0d ee ff ff       	call   8006cf <_panic>
  8018c2:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8018c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018cb:	89 10                	mov    %edx,(%eax)
  8018cd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018d0:	8b 00                	mov    (%eax),%eax
  8018d2:	85 c0                	test   %eax,%eax
  8018d4:	74 0d                	je     8018e3 <initialize_dyn_block_system+0x1a5>
  8018d6:	a1 38 51 80 00       	mov    0x805138,%eax
  8018db:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8018de:	89 50 04             	mov    %edx,0x4(%eax)
  8018e1:	eb 08                	jmp    8018eb <initialize_dyn_block_system+0x1ad>
  8018e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018e6:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8018eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018ee:	a3 38 51 80 00       	mov    %eax,0x805138
  8018f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018f6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8018fd:	a1 44 51 80 00       	mov    0x805144,%eax
  801902:	40                   	inc    %eax
  801903:	a3 44 51 80 00       	mov    %eax,0x805144
}
  801908:	90                   	nop
  801909:	c9                   	leave  
  80190a:	c3                   	ret    

0080190b <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  80190b:	55                   	push   %ebp
  80190c:	89 e5                	mov    %esp,%ebp
  80190e:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801911:	e8 f7 fd ff ff       	call   80170d <InitializeUHeap>
	if (size == 0) return NULL ;
  801916:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80191a:	75 07                	jne    801923 <malloc+0x18>
  80191c:	b8 00 00 00 00       	mov    $0x0,%eax
  801921:	eb 61                	jmp    801984 <malloc+0x79>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
	uint32 malloc_allocsize=ROUNDUP(size,PAGE_SIZE);
  801923:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80192a:	8b 55 08             	mov    0x8(%ebp),%edx
  80192d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801930:	01 d0                	add    %edx,%eax
  801932:	48                   	dec    %eax
  801933:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801936:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801939:	ba 00 00 00 00       	mov    $0x0,%edx
  80193e:	f7 75 f0             	divl   -0x10(%ebp)
  801941:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801944:	29 d0                	sub    %edx,%eax
  801946:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 //int ret=0;
	struct MemBlock * user_block;
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801949:	e8 e3 06 00 00       	call   802031 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80194e:	85 c0                	test   %eax,%eax
  801950:	74 11                	je     801963 <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  801952:	83 ec 0c             	sub    $0xc,%esp
  801955:	ff 75 e8             	pushl  -0x18(%ebp)
  801958:	e8 4e 0d 00 00       	call   8026ab <alloc_block_FF>
  80195d:	83 c4 10             	add    $0x10,%esp
  801960:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(user_block!=NULL)
  801963:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801967:	74 16                	je     80197f <malloc+0x74>
	{
		//sys_allocate_chunk(user_block->sva,malloc_allocsize,PERM_WRITEABLE| PERM_PRESENT);
		insert_sorted_allocList(user_block);
  801969:	83 ec 0c             	sub    $0xc,%esp
  80196c:	ff 75 f4             	pushl  -0xc(%ebp)
  80196f:	e8 aa 0a 00 00       	call   80241e <insert_sorted_allocList>
  801974:	83 c4 10             	add    $0x10,%esp
		return (uint32 *)user_block->sva;
  801977:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80197a:	8b 40 08             	mov    0x8(%eax),%eax
  80197d:	eb 05                	jmp    801984 <malloc+0x79>
	}

    return NULL;
  80197f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801984:	c9                   	leave  
  801985:	c3                   	ret    

00801986 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801986:	55                   	push   %ebp
  801987:	89 e5                	mov    %esp,%ebp
  801989:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  80198c:	83 ec 04             	sub    $0x4,%esp
  80198f:	68 64 44 80 00       	push   $0x804464
  801994:	6a 6f                	push   $0x6f
  801996:	68 33 44 80 00       	push   $0x804433
  80199b:	e8 2f ed ff ff       	call   8006cf <_panic>

008019a0 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8019a0:	55                   	push   %ebp
  8019a1:	89 e5                	mov    %esp,%ebp
  8019a3:	83 ec 38             	sub    $0x38,%esp
  8019a6:	8b 45 10             	mov    0x10(%ebp),%eax
  8019a9:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8019ac:	e8 5c fd ff ff       	call   80170d <InitializeUHeap>
	if (size == 0) return NULL ;
  8019b1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8019b5:	75 07                	jne    8019be <smalloc+0x1e>
  8019b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8019bc:	eb 7c                	jmp    801a3a <smalloc+0x9a>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  8019be:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8019c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019cb:	01 d0                	add    %edx,%eax
  8019cd:	48                   	dec    %eax
  8019ce:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8019d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019d4:	ba 00 00 00 00       	mov    $0x0,%edx
  8019d9:	f7 75 f0             	divl   -0x10(%ebp)
  8019dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019df:	29 d0                	sub    %edx,%eax
  8019e1:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  8019e4:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  8019eb:	e8 41 06 00 00       	call   802031 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8019f0:	85 c0                	test   %eax,%eax
  8019f2:	74 11                	je     801a05 <smalloc+0x65>
		mem_block = alloc_block_FF(allocate_space);
  8019f4:	83 ec 0c             	sub    $0xc,%esp
  8019f7:	ff 75 e8             	pushl  -0x18(%ebp)
  8019fa:	e8 ac 0c 00 00       	call   8026ab <alloc_block_FF>
  8019ff:	83 c4 10             	add    $0x10,%esp
  801a02:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  801a05:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801a09:	74 2a                	je     801a35 <smalloc+0x95>
	{
		virtual_address = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801a0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a0e:	8b 40 08             	mov    0x8(%eax),%eax
  801a11:	89 c2                	mov    %eax,%edx
  801a13:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801a17:	52                   	push   %edx
  801a18:	50                   	push   %eax
  801a19:	ff 75 0c             	pushl  0xc(%ebp)
  801a1c:	ff 75 08             	pushl  0x8(%ebp)
  801a1f:	e8 92 03 00 00       	call   801db6 <sys_createSharedObject>
  801a24:	83 c4 10             	add    $0x10,%esp
  801a27:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (virtual_address != -1)
  801a2a:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  801a2e:	74 05                	je     801a35 <smalloc+0x95>
			return (void*)virtual_address;
  801a30:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a33:	eb 05                	jmp    801a3a <smalloc+0x9a>
	}
	return NULL;
  801a35:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801a3a:	c9                   	leave  
  801a3b:	c3                   	ret    

00801a3c <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801a3c:	55                   	push   %ebp
  801a3d:	89 e5                	mov    %esp,%ebp
  801a3f:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801a42:	e8 c6 fc ff ff       	call   80170d <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801a47:	83 ec 04             	sub    $0x4,%esp
  801a4a:	68 88 44 80 00       	push   $0x804488
  801a4f:	68 b0 00 00 00       	push   $0xb0
  801a54:	68 33 44 80 00       	push   $0x804433
  801a59:	e8 71 ec ff ff       	call   8006cf <_panic>

00801a5e <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801a5e:	55                   	push   %ebp
  801a5f:	89 e5                	mov    %esp,%ebp
  801a61:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801a64:	e8 a4 fc ff ff       	call   80170d <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801a69:	83 ec 04             	sub    $0x4,%esp
  801a6c:	68 ac 44 80 00       	push   $0x8044ac
  801a71:	68 f4 00 00 00       	push   $0xf4
  801a76:	68 33 44 80 00       	push   $0x804433
  801a7b:	e8 4f ec ff ff       	call   8006cf <_panic>

00801a80 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801a80:	55                   	push   %ebp
  801a81:	89 e5                	mov    %esp,%ebp
  801a83:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801a86:	83 ec 04             	sub    $0x4,%esp
  801a89:	68 d4 44 80 00       	push   $0x8044d4
  801a8e:	68 08 01 00 00       	push   $0x108
  801a93:	68 33 44 80 00       	push   $0x804433
  801a98:	e8 32 ec ff ff       	call   8006cf <_panic>

00801a9d <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801a9d:	55                   	push   %ebp
  801a9e:	89 e5                	mov    %esp,%ebp
  801aa0:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801aa3:	83 ec 04             	sub    $0x4,%esp
  801aa6:	68 f8 44 80 00       	push   $0x8044f8
  801aab:	68 13 01 00 00       	push   $0x113
  801ab0:	68 33 44 80 00       	push   $0x804433
  801ab5:	e8 15 ec ff ff       	call   8006cf <_panic>

00801aba <shrink>:

}
void shrink(uint32 newSize)
{
  801aba:	55                   	push   %ebp
  801abb:	89 e5                	mov    %esp,%ebp
  801abd:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ac0:	83 ec 04             	sub    $0x4,%esp
  801ac3:	68 f8 44 80 00       	push   $0x8044f8
  801ac8:	68 18 01 00 00       	push   $0x118
  801acd:	68 33 44 80 00       	push   $0x804433
  801ad2:	e8 f8 eb ff ff       	call   8006cf <_panic>

00801ad7 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801ad7:	55                   	push   %ebp
  801ad8:	89 e5                	mov    %esp,%ebp
  801ada:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801add:	83 ec 04             	sub    $0x4,%esp
  801ae0:	68 f8 44 80 00       	push   $0x8044f8
  801ae5:	68 1d 01 00 00       	push   $0x11d
  801aea:	68 33 44 80 00       	push   $0x804433
  801aef:	e8 db eb ff ff       	call   8006cf <_panic>

00801af4 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801af4:	55                   	push   %ebp
  801af5:	89 e5                	mov    %esp,%ebp
  801af7:	57                   	push   %edi
  801af8:	56                   	push   %esi
  801af9:	53                   	push   %ebx
  801afa:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801afd:	8b 45 08             	mov    0x8(%ebp),%eax
  801b00:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b03:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b06:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b09:	8b 7d 18             	mov    0x18(%ebp),%edi
  801b0c:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801b0f:	cd 30                	int    $0x30
  801b11:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801b14:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801b17:	83 c4 10             	add    $0x10,%esp
  801b1a:	5b                   	pop    %ebx
  801b1b:	5e                   	pop    %esi
  801b1c:	5f                   	pop    %edi
  801b1d:	5d                   	pop    %ebp
  801b1e:	c3                   	ret    

00801b1f <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801b1f:	55                   	push   %ebp
  801b20:	89 e5                	mov    %esp,%ebp
  801b22:	83 ec 04             	sub    $0x4,%esp
  801b25:	8b 45 10             	mov    0x10(%ebp),%eax
  801b28:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801b2b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b32:	6a 00                	push   $0x0
  801b34:	6a 00                	push   $0x0
  801b36:	52                   	push   %edx
  801b37:	ff 75 0c             	pushl  0xc(%ebp)
  801b3a:	50                   	push   %eax
  801b3b:	6a 00                	push   $0x0
  801b3d:	e8 b2 ff ff ff       	call   801af4 <syscall>
  801b42:	83 c4 18             	add    $0x18,%esp
}
  801b45:	90                   	nop
  801b46:	c9                   	leave  
  801b47:	c3                   	ret    

00801b48 <sys_cgetc>:

int
sys_cgetc(void)
{
  801b48:	55                   	push   %ebp
  801b49:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801b4b:	6a 00                	push   $0x0
  801b4d:	6a 00                	push   $0x0
  801b4f:	6a 00                	push   $0x0
  801b51:	6a 00                	push   $0x0
  801b53:	6a 00                	push   $0x0
  801b55:	6a 01                	push   $0x1
  801b57:	e8 98 ff ff ff       	call   801af4 <syscall>
  801b5c:	83 c4 18             	add    $0x18,%esp
}
  801b5f:	c9                   	leave  
  801b60:	c3                   	ret    

00801b61 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801b61:	55                   	push   %ebp
  801b62:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801b64:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b67:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6a:	6a 00                	push   $0x0
  801b6c:	6a 00                	push   $0x0
  801b6e:	6a 00                	push   $0x0
  801b70:	52                   	push   %edx
  801b71:	50                   	push   %eax
  801b72:	6a 05                	push   $0x5
  801b74:	e8 7b ff ff ff       	call   801af4 <syscall>
  801b79:	83 c4 18             	add    $0x18,%esp
}
  801b7c:	c9                   	leave  
  801b7d:	c3                   	ret    

00801b7e <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801b7e:	55                   	push   %ebp
  801b7f:	89 e5                	mov    %esp,%ebp
  801b81:	56                   	push   %esi
  801b82:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801b83:	8b 75 18             	mov    0x18(%ebp),%esi
  801b86:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b89:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b8c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b92:	56                   	push   %esi
  801b93:	53                   	push   %ebx
  801b94:	51                   	push   %ecx
  801b95:	52                   	push   %edx
  801b96:	50                   	push   %eax
  801b97:	6a 06                	push   $0x6
  801b99:	e8 56 ff ff ff       	call   801af4 <syscall>
  801b9e:	83 c4 18             	add    $0x18,%esp
}
  801ba1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ba4:	5b                   	pop    %ebx
  801ba5:	5e                   	pop    %esi
  801ba6:	5d                   	pop    %ebp
  801ba7:	c3                   	ret    

00801ba8 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801ba8:	55                   	push   %ebp
  801ba9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801bab:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bae:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb1:	6a 00                	push   $0x0
  801bb3:	6a 00                	push   $0x0
  801bb5:	6a 00                	push   $0x0
  801bb7:	52                   	push   %edx
  801bb8:	50                   	push   %eax
  801bb9:	6a 07                	push   $0x7
  801bbb:	e8 34 ff ff ff       	call   801af4 <syscall>
  801bc0:	83 c4 18             	add    $0x18,%esp
}
  801bc3:	c9                   	leave  
  801bc4:	c3                   	ret    

00801bc5 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801bc5:	55                   	push   %ebp
  801bc6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801bc8:	6a 00                	push   $0x0
  801bca:	6a 00                	push   $0x0
  801bcc:	6a 00                	push   $0x0
  801bce:	ff 75 0c             	pushl  0xc(%ebp)
  801bd1:	ff 75 08             	pushl  0x8(%ebp)
  801bd4:	6a 08                	push   $0x8
  801bd6:	e8 19 ff ff ff       	call   801af4 <syscall>
  801bdb:	83 c4 18             	add    $0x18,%esp
}
  801bde:	c9                   	leave  
  801bdf:	c3                   	ret    

00801be0 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801be0:	55                   	push   %ebp
  801be1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801be3:	6a 00                	push   $0x0
  801be5:	6a 00                	push   $0x0
  801be7:	6a 00                	push   $0x0
  801be9:	6a 00                	push   $0x0
  801beb:	6a 00                	push   $0x0
  801bed:	6a 09                	push   $0x9
  801bef:	e8 00 ff ff ff       	call   801af4 <syscall>
  801bf4:	83 c4 18             	add    $0x18,%esp
}
  801bf7:	c9                   	leave  
  801bf8:	c3                   	ret    

00801bf9 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801bf9:	55                   	push   %ebp
  801bfa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801bfc:	6a 00                	push   $0x0
  801bfe:	6a 00                	push   $0x0
  801c00:	6a 00                	push   $0x0
  801c02:	6a 00                	push   $0x0
  801c04:	6a 00                	push   $0x0
  801c06:	6a 0a                	push   $0xa
  801c08:	e8 e7 fe ff ff       	call   801af4 <syscall>
  801c0d:	83 c4 18             	add    $0x18,%esp
}
  801c10:	c9                   	leave  
  801c11:	c3                   	ret    

00801c12 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801c12:	55                   	push   %ebp
  801c13:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801c15:	6a 00                	push   $0x0
  801c17:	6a 00                	push   $0x0
  801c19:	6a 00                	push   $0x0
  801c1b:	6a 00                	push   $0x0
  801c1d:	6a 00                	push   $0x0
  801c1f:	6a 0b                	push   $0xb
  801c21:	e8 ce fe ff ff       	call   801af4 <syscall>
  801c26:	83 c4 18             	add    $0x18,%esp
}
  801c29:	c9                   	leave  
  801c2a:	c3                   	ret    

00801c2b <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801c2b:	55                   	push   %ebp
  801c2c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801c2e:	6a 00                	push   $0x0
  801c30:	6a 00                	push   $0x0
  801c32:	6a 00                	push   $0x0
  801c34:	ff 75 0c             	pushl  0xc(%ebp)
  801c37:	ff 75 08             	pushl  0x8(%ebp)
  801c3a:	6a 0f                	push   $0xf
  801c3c:	e8 b3 fe ff ff       	call   801af4 <syscall>
  801c41:	83 c4 18             	add    $0x18,%esp
	return;
  801c44:	90                   	nop
}
  801c45:	c9                   	leave  
  801c46:	c3                   	ret    

00801c47 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801c47:	55                   	push   %ebp
  801c48:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801c4a:	6a 00                	push   $0x0
  801c4c:	6a 00                	push   $0x0
  801c4e:	6a 00                	push   $0x0
  801c50:	ff 75 0c             	pushl  0xc(%ebp)
  801c53:	ff 75 08             	pushl  0x8(%ebp)
  801c56:	6a 10                	push   $0x10
  801c58:	e8 97 fe ff ff       	call   801af4 <syscall>
  801c5d:	83 c4 18             	add    $0x18,%esp
	return ;
  801c60:	90                   	nop
}
  801c61:	c9                   	leave  
  801c62:	c3                   	ret    

00801c63 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801c63:	55                   	push   %ebp
  801c64:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801c66:	6a 00                	push   $0x0
  801c68:	6a 00                	push   $0x0
  801c6a:	ff 75 10             	pushl  0x10(%ebp)
  801c6d:	ff 75 0c             	pushl  0xc(%ebp)
  801c70:	ff 75 08             	pushl  0x8(%ebp)
  801c73:	6a 11                	push   $0x11
  801c75:	e8 7a fe ff ff       	call   801af4 <syscall>
  801c7a:	83 c4 18             	add    $0x18,%esp
	return ;
  801c7d:	90                   	nop
}
  801c7e:	c9                   	leave  
  801c7f:	c3                   	ret    

00801c80 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801c80:	55                   	push   %ebp
  801c81:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801c83:	6a 00                	push   $0x0
  801c85:	6a 00                	push   $0x0
  801c87:	6a 00                	push   $0x0
  801c89:	6a 00                	push   $0x0
  801c8b:	6a 00                	push   $0x0
  801c8d:	6a 0c                	push   $0xc
  801c8f:	e8 60 fe ff ff       	call   801af4 <syscall>
  801c94:	83 c4 18             	add    $0x18,%esp
}
  801c97:	c9                   	leave  
  801c98:	c3                   	ret    

00801c99 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801c99:	55                   	push   %ebp
  801c9a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801c9c:	6a 00                	push   $0x0
  801c9e:	6a 00                	push   $0x0
  801ca0:	6a 00                	push   $0x0
  801ca2:	6a 00                	push   $0x0
  801ca4:	ff 75 08             	pushl  0x8(%ebp)
  801ca7:	6a 0d                	push   $0xd
  801ca9:	e8 46 fe ff ff       	call   801af4 <syscall>
  801cae:	83 c4 18             	add    $0x18,%esp
}
  801cb1:	c9                   	leave  
  801cb2:	c3                   	ret    

00801cb3 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801cb3:	55                   	push   %ebp
  801cb4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801cb6:	6a 00                	push   $0x0
  801cb8:	6a 00                	push   $0x0
  801cba:	6a 00                	push   $0x0
  801cbc:	6a 00                	push   $0x0
  801cbe:	6a 00                	push   $0x0
  801cc0:	6a 0e                	push   $0xe
  801cc2:	e8 2d fe ff ff       	call   801af4 <syscall>
  801cc7:	83 c4 18             	add    $0x18,%esp
}
  801cca:	90                   	nop
  801ccb:	c9                   	leave  
  801ccc:	c3                   	ret    

00801ccd <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801ccd:	55                   	push   %ebp
  801cce:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801cd0:	6a 00                	push   $0x0
  801cd2:	6a 00                	push   $0x0
  801cd4:	6a 00                	push   $0x0
  801cd6:	6a 00                	push   $0x0
  801cd8:	6a 00                	push   $0x0
  801cda:	6a 13                	push   $0x13
  801cdc:	e8 13 fe ff ff       	call   801af4 <syscall>
  801ce1:	83 c4 18             	add    $0x18,%esp
}
  801ce4:	90                   	nop
  801ce5:	c9                   	leave  
  801ce6:	c3                   	ret    

00801ce7 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801ce7:	55                   	push   %ebp
  801ce8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801cea:	6a 00                	push   $0x0
  801cec:	6a 00                	push   $0x0
  801cee:	6a 00                	push   $0x0
  801cf0:	6a 00                	push   $0x0
  801cf2:	6a 00                	push   $0x0
  801cf4:	6a 14                	push   $0x14
  801cf6:	e8 f9 fd ff ff       	call   801af4 <syscall>
  801cfb:	83 c4 18             	add    $0x18,%esp
}
  801cfe:	90                   	nop
  801cff:	c9                   	leave  
  801d00:	c3                   	ret    

00801d01 <sys_cputc>:


void
sys_cputc(const char c)
{
  801d01:	55                   	push   %ebp
  801d02:	89 e5                	mov    %esp,%ebp
  801d04:	83 ec 04             	sub    $0x4,%esp
  801d07:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801d0d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d11:	6a 00                	push   $0x0
  801d13:	6a 00                	push   $0x0
  801d15:	6a 00                	push   $0x0
  801d17:	6a 00                	push   $0x0
  801d19:	50                   	push   %eax
  801d1a:	6a 15                	push   $0x15
  801d1c:	e8 d3 fd ff ff       	call   801af4 <syscall>
  801d21:	83 c4 18             	add    $0x18,%esp
}
  801d24:	90                   	nop
  801d25:	c9                   	leave  
  801d26:	c3                   	ret    

00801d27 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801d27:	55                   	push   %ebp
  801d28:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801d2a:	6a 00                	push   $0x0
  801d2c:	6a 00                	push   $0x0
  801d2e:	6a 00                	push   $0x0
  801d30:	6a 00                	push   $0x0
  801d32:	6a 00                	push   $0x0
  801d34:	6a 16                	push   $0x16
  801d36:	e8 b9 fd ff ff       	call   801af4 <syscall>
  801d3b:	83 c4 18             	add    $0x18,%esp
}
  801d3e:	90                   	nop
  801d3f:	c9                   	leave  
  801d40:	c3                   	ret    

00801d41 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801d41:	55                   	push   %ebp
  801d42:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801d44:	8b 45 08             	mov    0x8(%ebp),%eax
  801d47:	6a 00                	push   $0x0
  801d49:	6a 00                	push   $0x0
  801d4b:	6a 00                	push   $0x0
  801d4d:	ff 75 0c             	pushl  0xc(%ebp)
  801d50:	50                   	push   %eax
  801d51:	6a 17                	push   $0x17
  801d53:	e8 9c fd ff ff       	call   801af4 <syscall>
  801d58:	83 c4 18             	add    $0x18,%esp
}
  801d5b:	c9                   	leave  
  801d5c:	c3                   	ret    

00801d5d <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801d5d:	55                   	push   %ebp
  801d5e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d60:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d63:	8b 45 08             	mov    0x8(%ebp),%eax
  801d66:	6a 00                	push   $0x0
  801d68:	6a 00                	push   $0x0
  801d6a:	6a 00                	push   $0x0
  801d6c:	52                   	push   %edx
  801d6d:	50                   	push   %eax
  801d6e:	6a 1a                	push   $0x1a
  801d70:	e8 7f fd ff ff       	call   801af4 <syscall>
  801d75:	83 c4 18             	add    $0x18,%esp
}
  801d78:	c9                   	leave  
  801d79:	c3                   	ret    

00801d7a <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801d7a:	55                   	push   %ebp
  801d7b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d7d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d80:	8b 45 08             	mov    0x8(%ebp),%eax
  801d83:	6a 00                	push   $0x0
  801d85:	6a 00                	push   $0x0
  801d87:	6a 00                	push   $0x0
  801d89:	52                   	push   %edx
  801d8a:	50                   	push   %eax
  801d8b:	6a 18                	push   $0x18
  801d8d:	e8 62 fd ff ff       	call   801af4 <syscall>
  801d92:	83 c4 18             	add    $0x18,%esp
}
  801d95:	90                   	nop
  801d96:	c9                   	leave  
  801d97:	c3                   	ret    

00801d98 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801d98:	55                   	push   %ebp
  801d99:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d9b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801da1:	6a 00                	push   $0x0
  801da3:	6a 00                	push   $0x0
  801da5:	6a 00                	push   $0x0
  801da7:	52                   	push   %edx
  801da8:	50                   	push   %eax
  801da9:	6a 19                	push   $0x19
  801dab:	e8 44 fd ff ff       	call   801af4 <syscall>
  801db0:	83 c4 18             	add    $0x18,%esp
}
  801db3:	90                   	nop
  801db4:	c9                   	leave  
  801db5:	c3                   	ret    

00801db6 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801db6:	55                   	push   %ebp
  801db7:	89 e5                	mov    %esp,%ebp
  801db9:	83 ec 04             	sub    $0x4,%esp
  801dbc:	8b 45 10             	mov    0x10(%ebp),%eax
  801dbf:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801dc2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801dc5:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801dc9:	8b 45 08             	mov    0x8(%ebp),%eax
  801dcc:	6a 00                	push   $0x0
  801dce:	51                   	push   %ecx
  801dcf:	52                   	push   %edx
  801dd0:	ff 75 0c             	pushl  0xc(%ebp)
  801dd3:	50                   	push   %eax
  801dd4:	6a 1b                	push   $0x1b
  801dd6:	e8 19 fd ff ff       	call   801af4 <syscall>
  801ddb:	83 c4 18             	add    $0x18,%esp
}
  801dde:	c9                   	leave  
  801ddf:	c3                   	ret    

00801de0 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801de0:	55                   	push   %ebp
  801de1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801de3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801de6:	8b 45 08             	mov    0x8(%ebp),%eax
  801de9:	6a 00                	push   $0x0
  801deb:	6a 00                	push   $0x0
  801ded:	6a 00                	push   $0x0
  801def:	52                   	push   %edx
  801df0:	50                   	push   %eax
  801df1:	6a 1c                	push   $0x1c
  801df3:	e8 fc fc ff ff       	call   801af4 <syscall>
  801df8:	83 c4 18             	add    $0x18,%esp
}
  801dfb:	c9                   	leave  
  801dfc:	c3                   	ret    

00801dfd <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801dfd:	55                   	push   %ebp
  801dfe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801e00:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e03:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e06:	8b 45 08             	mov    0x8(%ebp),%eax
  801e09:	6a 00                	push   $0x0
  801e0b:	6a 00                	push   $0x0
  801e0d:	51                   	push   %ecx
  801e0e:	52                   	push   %edx
  801e0f:	50                   	push   %eax
  801e10:	6a 1d                	push   $0x1d
  801e12:	e8 dd fc ff ff       	call   801af4 <syscall>
  801e17:	83 c4 18             	add    $0x18,%esp
}
  801e1a:	c9                   	leave  
  801e1b:	c3                   	ret    

00801e1c <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801e1c:	55                   	push   %ebp
  801e1d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801e1f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e22:	8b 45 08             	mov    0x8(%ebp),%eax
  801e25:	6a 00                	push   $0x0
  801e27:	6a 00                	push   $0x0
  801e29:	6a 00                	push   $0x0
  801e2b:	52                   	push   %edx
  801e2c:	50                   	push   %eax
  801e2d:	6a 1e                	push   $0x1e
  801e2f:	e8 c0 fc ff ff       	call   801af4 <syscall>
  801e34:	83 c4 18             	add    $0x18,%esp
}
  801e37:	c9                   	leave  
  801e38:	c3                   	ret    

00801e39 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801e39:	55                   	push   %ebp
  801e3a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801e3c:	6a 00                	push   $0x0
  801e3e:	6a 00                	push   $0x0
  801e40:	6a 00                	push   $0x0
  801e42:	6a 00                	push   $0x0
  801e44:	6a 00                	push   $0x0
  801e46:	6a 1f                	push   $0x1f
  801e48:	e8 a7 fc ff ff       	call   801af4 <syscall>
  801e4d:	83 c4 18             	add    $0x18,%esp
}
  801e50:	c9                   	leave  
  801e51:	c3                   	ret    

00801e52 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801e52:	55                   	push   %ebp
  801e53:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801e55:	8b 45 08             	mov    0x8(%ebp),%eax
  801e58:	6a 00                	push   $0x0
  801e5a:	ff 75 14             	pushl  0x14(%ebp)
  801e5d:	ff 75 10             	pushl  0x10(%ebp)
  801e60:	ff 75 0c             	pushl  0xc(%ebp)
  801e63:	50                   	push   %eax
  801e64:	6a 20                	push   $0x20
  801e66:	e8 89 fc ff ff       	call   801af4 <syscall>
  801e6b:	83 c4 18             	add    $0x18,%esp
}
  801e6e:	c9                   	leave  
  801e6f:	c3                   	ret    

00801e70 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801e70:	55                   	push   %ebp
  801e71:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801e73:	8b 45 08             	mov    0x8(%ebp),%eax
  801e76:	6a 00                	push   $0x0
  801e78:	6a 00                	push   $0x0
  801e7a:	6a 00                	push   $0x0
  801e7c:	6a 00                	push   $0x0
  801e7e:	50                   	push   %eax
  801e7f:	6a 21                	push   $0x21
  801e81:	e8 6e fc ff ff       	call   801af4 <syscall>
  801e86:	83 c4 18             	add    $0x18,%esp
}
  801e89:	90                   	nop
  801e8a:	c9                   	leave  
  801e8b:	c3                   	ret    

00801e8c <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801e8c:	55                   	push   %ebp
  801e8d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801e8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e92:	6a 00                	push   $0x0
  801e94:	6a 00                	push   $0x0
  801e96:	6a 00                	push   $0x0
  801e98:	6a 00                	push   $0x0
  801e9a:	50                   	push   %eax
  801e9b:	6a 22                	push   $0x22
  801e9d:	e8 52 fc ff ff       	call   801af4 <syscall>
  801ea2:	83 c4 18             	add    $0x18,%esp
}
  801ea5:	c9                   	leave  
  801ea6:	c3                   	ret    

00801ea7 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801ea7:	55                   	push   %ebp
  801ea8:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801eaa:	6a 00                	push   $0x0
  801eac:	6a 00                	push   $0x0
  801eae:	6a 00                	push   $0x0
  801eb0:	6a 00                	push   $0x0
  801eb2:	6a 00                	push   $0x0
  801eb4:	6a 02                	push   $0x2
  801eb6:	e8 39 fc ff ff       	call   801af4 <syscall>
  801ebb:	83 c4 18             	add    $0x18,%esp
}
  801ebe:	c9                   	leave  
  801ebf:	c3                   	ret    

00801ec0 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801ec0:	55                   	push   %ebp
  801ec1:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801ec3:	6a 00                	push   $0x0
  801ec5:	6a 00                	push   $0x0
  801ec7:	6a 00                	push   $0x0
  801ec9:	6a 00                	push   $0x0
  801ecb:	6a 00                	push   $0x0
  801ecd:	6a 03                	push   $0x3
  801ecf:	e8 20 fc ff ff       	call   801af4 <syscall>
  801ed4:	83 c4 18             	add    $0x18,%esp
}
  801ed7:	c9                   	leave  
  801ed8:	c3                   	ret    

00801ed9 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801ed9:	55                   	push   %ebp
  801eda:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801edc:	6a 00                	push   $0x0
  801ede:	6a 00                	push   $0x0
  801ee0:	6a 00                	push   $0x0
  801ee2:	6a 00                	push   $0x0
  801ee4:	6a 00                	push   $0x0
  801ee6:	6a 04                	push   $0x4
  801ee8:	e8 07 fc ff ff       	call   801af4 <syscall>
  801eed:	83 c4 18             	add    $0x18,%esp
}
  801ef0:	c9                   	leave  
  801ef1:	c3                   	ret    

00801ef2 <sys_exit_env>:


void sys_exit_env(void)
{
  801ef2:	55                   	push   %ebp
  801ef3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801ef5:	6a 00                	push   $0x0
  801ef7:	6a 00                	push   $0x0
  801ef9:	6a 00                	push   $0x0
  801efb:	6a 00                	push   $0x0
  801efd:	6a 00                	push   $0x0
  801eff:	6a 23                	push   $0x23
  801f01:	e8 ee fb ff ff       	call   801af4 <syscall>
  801f06:	83 c4 18             	add    $0x18,%esp
}
  801f09:	90                   	nop
  801f0a:	c9                   	leave  
  801f0b:	c3                   	ret    

00801f0c <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801f0c:	55                   	push   %ebp
  801f0d:	89 e5                	mov    %esp,%ebp
  801f0f:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801f12:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801f15:	8d 50 04             	lea    0x4(%eax),%edx
  801f18:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801f1b:	6a 00                	push   $0x0
  801f1d:	6a 00                	push   $0x0
  801f1f:	6a 00                	push   $0x0
  801f21:	52                   	push   %edx
  801f22:	50                   	push   %eax
  801f23:	6a 24                	push   $0x24
  801f25:	e8 ca fb ff ff       	call   801af4 <syscall>
  801f2a:	83 c4 18             	add    $0x18,%esp
	return result;
  801f2d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f30:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801f33:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801f36:	89 01                	mov    %eax,(%ecx)
  801f38:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801f3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f3e:	c9                   	leave  
  801f3f:	c2 04 00             	ret    $0x4

00801f42 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801f42:	55                   	push   %ebp
  801f43:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801f45:	6a 00                	push   $0x0
  801f47:	6a 00                	push   $0x0
  801f49:	ff 75 10             	pushl  0x10(%ebp)
  801f4c:	ff 75 0c             	pushl  0xc(%ebp)
  801f4f:	ff 75 08             	pushl  0x8(%ebp)
  801f52:	6a 12                	push   $0x12
  801f54:	e8 9b fb ff ff       	call   801af4 <syscall>
  801f59:	83 c4 18             	add    $0x18,%esp
	return ;
  801f5c:	90                   	nop
}
  801f5d:	c9                   	leave  
  801f5e:	c3                   	ret    

00801f5f <sys_rcr2>:
uint32 sys_rcr2()
{
  801f5f:	55                   	push   %ebp
  801f60:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801f62:	6a 00                	push   $0x0
  801f64:	6a 00                	push   $0x0
  801f66:	6a 00                	push   $0x0
  801f68:	6a 00                	push   $0x0
  801f6a:	6a 00                	push   $0x0
  801f6c:	6a 25                	push   $0x25
  801f6e:	e8 81 fb ff ff       	call   801af4 <syscall>
  801f73:	83 c4 18             	add    $0x18,%esp
}
  801f76:	c9                   	leave  
  801f77:	c3                   	ret    

00801f78 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801f78:	55                   	push   %ebp
  801f79:	89 e5                	mov    %esp,%ebp
  801f7b:	83 ec 04             	sub    $0x4,%esp
  801f7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f81:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801f84:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801f88:	6a 00                	push   $0x0
  801f8a:	6a 00                	push   $0x0
  801f8c:	6a 00                	push   $0x0
  801f8e:	6a 00                	push   $0x0
  801f90:	50                   	push   %eax
  801f91:	6a 26                	push   $0x26
  801f93:	e8 5c fb ff ff       	call   801af4 <syscall>
  801f98:	83 c4 18             	add    $0x18,%esp
	return ;
  801f9b:	90                   	nop
}
  801f9c:	c9                   	leave  
  801f9d:	c3                   	ret    

00801f9e <rsttst>:
void rsttst()
{
  801f9e:	55                   	push   %ebp
  801f9f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801fa1:	6a 00                	push   $0x0
  801fa3:	6a 00                	push   $0x0
  801fa5:	6a 00                	push   $0x0
  801fa7:	6a 00                	push   $0x0
  801fa9:	6a 00                	push   $0x0
  801fab:	6a 28                	push   $0x28
  801fad:	e8 42 fb ff ff       	call   801af4 <syscall>
  801fb2:	83 c4 18             	add    $0x18,%esp
	return ;
  801fb5:	90                   	nop
}
  801fb6:	c9                   	leave  
  801fb7:	c3                   	ret    

00801fb8 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801fb8:	55                   	push   %ebp
  801fb9:	89 e5                	mov    %esp,%ebp
  801fbb:	83 ec 04             	sub    $0x4,%esp
  801fbe:	8b 45 14             	mov    0x14(%ebp),%eax
  801fc1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801fc4:	8b 55 18             	mov    0x18(%ebp),%edx
  801fc7:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801fcb:	52                   	push   %edx
  801fcc:	50                   	push   %eax
  801fcd:	ff 75 10             	pushl  0x10(%ebp)
  801fd0:	ff 75 0c             	pushl  0xc(%ebp)
  801fd3:	ff 75 08             	pushl  0x8(%ebp)
  801fd6:	6a 27                	push   $0x27
  801fd8:	e8 17 fb ff ff       	call   801af4 <syscall>
  801fdd:	83 c4 18             	add    $0x18,%esp
	return ;
  801fe0:	90                   	nop
}
  801fe1:	c9                   	leave  
  801fe2:	c3                   	ret    

00801fe3 <chktst>:
void chktst(uint32 n)
{
  801fe3:	55                   	push   %ebp
  801fe4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801fe6:	6a 00                	push   $0x0
  801fe8:	6a 00                	push   $0x0
  801fea:	6a 00                	push   $0x0
  801fec:	6a 00                	push   $0x0
  801fee:	ff 75 08             	pushl  0x8(%ebp)
  801ff1:	6a 29                	push   $0x29
  801ff3:	e8 fc fa ff ff       	call   801af4 <syscall>
  801ff8:	83 c4 18             	add    $0x18,%esp
	return ;
  801ffb:	90                   	nop
}
  801ffc:	c9                   	leave  
  801ffd:	c3                   	ret    

00801ffe <inctst>:

void inctst()
{
  801ffe:	55                   	push   %ebp
  801fff:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802001:	6a 00                	push   $0x0
  802003:	6a 00                	push   $0x0
  802005:	6a 00                	push   $0x0
  802007:	6a 00                	push   $0x0
  802009:	6a 00                	push   $0x0
  80200b:	6a 2a                	push   $0x2a
  80200d:	e8 e2 fa ff ff       	call   801af4 <syscall>
  802012:	83 c4 18             	add    $0x18,%esp
	return ;
  802015:	90                   	nop
}
  802016:	c9                   	leave  
  802017:	c3                   	ret    

00802018 <gettst>:
uint32 gettst()
{
  802018:	55                   	push   %ebp
  802019:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80201b:	6a 00                	push   $0x0
  80201d:	6a 00                	push   $0x0
  80201f:	6a 00                	push   $0x0
  802021:	6a 00                	push   $0x0
  802023:	6a 00                	push   $0x0
  802025:	6a 2b                	push   $0x2b
  802027:	e8 c8 fa ff ff       	call   801af4 <syscall>
  80202c:	83 c4 18             	add    $0x18,%esp
}
  80202f:	c9                   	leave  
  802030:	c3                   	ret    

00802031 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802031:	55                   	push   %ebp
  802032:	89 e5                	mov    %esp,%ebp
  802034:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802037:	6a 00                	push   $0x0
  802039:	6a 00                	push   $0x0
  80203b:	6a 00                	push   $0x0
  80203d:	6a 00                	push   $0x0
  80203f:	6a 00                	push   $0x0
  802041:	6a 2c                	push   $0x2c
  802043:	e8 ac fa ff ff       	call   801af4 <syscall>
  802048:	83 c4 18             	add    $0x18,%esp
  80204b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80204e:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802052:	75 07                	jne    80205b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802054:	b8 01 00 00 00       	mov    $0x1,%eax
  802059:	eb 05                	jmp    802060 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80205b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802060:	c9                   	leave  
  802061:	c3                   	ret    

00802062 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802062:	55                   	push   %ebp
  802063:	89 e5                	mov    %esp,%ebp
  802065:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802068:	6a 00                	push   $0x0
  80206a:	6a 00                	push   $0x0
  80206c:	6a 00                	push   $0x0
  80206e:	6a 00                	push   $0x0
  802070:	6a 00                	push   $0x0
  802072:	6a 2c                	push   $0x2c
  802074:	e8 7b fa ff ff       	call   801af4 <syscall>
  802079:	83 c4 18             	add    $0x18,%esp
  80207c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80207f:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802083:	75 07                	jne    80208c <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802085:	b8 01 00 00 00       	mov    $0x1,%eax
  80208a:	eb 05                	jmp    802091 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80208c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802091:	c9                   	leave  
  802092:	c3                   	ret    

00802093 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802093:	55                   	push   %ebp
  802094:	89 e5                	mov    %esp,%ebp
  802096:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802099:	6a 00                	push   $0x0
  80209b:	6a 00                	push   $0x0
  80209d:	6a 00                	push   $0x0
  80209f:	6a 00                	push   $0x0
  8020a1:	6a 00                	push   $0x0
  8020a3:	6a 2c                	push   $0x2c
  8020a5:	e8 4a fa ff ff       	call   801af4 <syscall>
  8020aa:	83 c4 18             	add    $0x18,%esp
  8020ad:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8020b0:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8020b4:	75 07                	jne    8020bd <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8020b6:	b8 01 00 00 00       	mov    $0x1,%eax
  8020bb:	eb 05                	jmp    8020c2 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8020bd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020c2:	c9                   	leave  
  8020c3:	c3                   	ret    

008020c4 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8020c4:	55                   	push   %ebp
  8020c5:	89 e5                	mov    %esp,%ebp
  8020c7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8020ca:	6a 00                	push   $0x0
  8020cc:	6a 00                	push   $0x0
  8020ce:	6a 00                	push   $0x0
  8020d0:	6a 00                	push   $0x0
  8020d2:	6a 00                	push   $0x0
  8020d4:	6a 2c                	push   $0x2c
  8020d6:	e8 19 fa ff ff       	call   801af4 <syscall>
  8020db:	83 c4 18             	add    $0x18,%esp
  8020de:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8020e1:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8020e5:	75 07                	jne    8020ee <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8020e7:	b8 01 00 00 00       	mov    $0x1,%eax
  8020ec:	eb 05                	jmp    8020f3 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8020ee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020f3:	c9                   	leave  
  8020f4:	c3                   	ret    

008020f5 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8020f5:	55                   	push   %ebp
  8020f6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8020f8:	6a 00                	push   $0x0
  8020fa:	6a 00                	push   $0x0
  8020fc:	6a 00                	push   $0x0
  8020fe:	6a 00                	push   $0x0
  802100:	ff 75 08             	pushl  0x8(%ebp)
  802103:	6a 2d                	push   $0x2d
  802105:	e8 ea f9 ff ff       	call   801af4 <syscall>
  80210a:	83 c4 18             	add    $0x18,%esp
	return ;
  80210d:	90                   	nop
}
  80210e:	c9                   	leave  
  80210f:	c3                   	ret    

00802110 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802110:	55                   	push   %ebp
  802111:	89 e5                	mov    %esp,%ebp
  802113:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802114:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802117:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80211a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80211d:	8b 45 08             	mov    0x8(%ebp),%eax
  802120:	6a 00                	push   $0x0
  802122:	53                   	push   %ebx
  802123:	51                   	push   %ecx
  802124:	52                   	push   %edx
  802125:	50                   	push   %eax
  802126:	6a 2e                	push   $0x2e
  802128:	e8 c7 f9 ff ff       	call   801af4 <syscall>
  80212d:	83 c4 18             	add    $0x18,%esp
}
  802130:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802133:	c9                   	leave  
  802134:	c3                   	ret    

00802135 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802135:	55                   	push   %ebp
  802136:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802138:	8b 55 0c             	mov    0xc(%ebp),%edx
  80213b:	8b 45 08             	mov    0x8(%ebp),%eax
  80213e:	6a 00                	push   $0x0
  802140:	6a 00                	push   $0x0
  802142:	6a 00                	push   $0x0
  802144:	52                   	push   %edx
  802145:	50                   	push   %eax
  802146:	6a 2f                	push   $0x2f
  802148:	e8 a7 f9 ff ff       	call   801af4 <syscall>
  80214d:	83 c4 18             	add    $0x18,%esp
}
  802150:	c9                   	leave  
  802151:	c3                   	ret    

00802152 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802152:	55                   	push   %ebp
  802153:	89 e5                	mov    %esp,%ebp
  802155:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802158:	83 ec 0c             	sub    $0xc,%esp
  80215b:	68 08 45 80 00       	push   $0x804508
  802160:	e8 1e e8 ff ff       	call   800983 <cprintf>
  802165:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802168:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  80216f:	83 ec 0c             	sub    $0xc,%esp
  802172:	68 34 45 80 00       	push   $0x804534
  802177:	e8 07 e8 ff ff       	call   800983 <cprintf>
  80217c:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  80217f:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802183:	a1 38 51 80 00       	mov    0x805138,%eax
  802188:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80218b:	eb 56                	jmp    8021e3 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80218d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802191:	74 1c                	je     8021af <print_mem_block_lists+0x5d>
  802193:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802196:	8b 50 08             	mov    0x8(%eax),%edx
  802199:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80219c:	8b 48 08             	mov    0x8(%eax),%ecx
  80219f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021a2:	8b 40 0c             	mov    0xc(%eax),%eax
  8021a5:	01 c8                	add    %ecx,%eax
  8021a7:	39 c2                	cmp    %eax,%edx
  8021a9:	73 04                	jae    8021af <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8021ab:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8021af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b2:	8b 50 08             	mov    0x8(%eax),%edx
  8021b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b8:	8b 40 0c             	mov    0xc(%eax),%eax
  8021bb:	01 c2                	add    %eax,%edx
  8021bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c0:	8b 40 08             	mov    0x8(%eax),%eax
  8021c3:	83 ec 04             	sub    $0x4,%esp
  8021c6:	52                   	push   %edx
  8021c7:	50                   	push   %eax
  8021c8:	68 49 45 80 00       	push   $0x804549
  8021cd:	e8 b1 e7 ff ff       	call   800983 <cprintf>
  8021d2:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8021d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8021db:	a1 40 51 80 00       	mov    0x805140,%eax
  8021e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021e7:	74 07                	je     8021f0 <print_mem_block_lists+0x9e>
  8021e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ec:	8b 00                	mov    (%eax),%eax
  8021ee:	eb 05                	jmp    8021f5 <print_mem_block_lists+0xa3>
  8021f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8021f5:	a3 40 51 80 00       	mov    %eax,0x805140
  8021fa:	a1 40 51 80 00       	mov    0x805140,%eax
  8021ff:	85 c0                	test   %eax,%eax
  802201:	75 8a                	jne    80218d <print_mem_block_lists+0x3b>
  802203:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802207:	75 84                	jne    80218d <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802209:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80220d:	75 10                	jne    80221f <print_mem_block_lists+0xcd>
  80220f:	83 ec 0c             	sub    $0xc,%esp
  802212:	68 58 45 80 00       	push   $0x804558
  802217:	e8 67 e7 ff ff       	call   800983 <cprintf>
  80221c:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  80221f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802226:	83 ec 0c             	sub    $0xc,%esp
  802229:	68 7c 45 80 00       	push   $0x80457c
  80222e:	e8 50 e7 ff ff       	call   800983 <cprintf>
  802233:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802236:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80223a:	a1 40 50 80 00       	mov    0x805040,%eax
  80223f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802242:	eb 56                	jmp    80229a <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802244:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802248:	74 1c                	je     802266 <print_mem_block_lists+0x114>
  80224a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80224d:	8b 50 08             	mov    0x8(%eax),%edx
  802250:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802253:	8b 48 08             	mov    0x8(%eax),%ecx
  802256:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802259:	8b 40 0c             	mov    0xc(%eax),%eax
  80225c:	01 c8                	add    %ecx,%eax
  80225e:	39 c2                	cmp    %eax,%edx
  802260:	73 04                	jae    802266 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802262:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802266:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802269:	8b 50 08             	mov    0x8(%eax),%edx
  80226c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80226f:	8b 40 0c             	mov    0xc(%eax),%eax
  802272:	01 c2                	add    %eax,%edx
  802274:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802277:	8b 40 08             	mov    0x8(%eax),%eax
  80227a:	83 ec 04             	sub    $0x4,%esp
  80227d:	52                   	push   %edx
  80227e:	50                   	push   %eax
  80227f:	68 49 45 80 00       	push   $0x804549
  802284:	e8 fa e6 ff ff       	call   800983 <cprintf>
  802289:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80228c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80228f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802292:	a1 48 50 80 00       	mov    0x805048,%eax
  802297:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80229a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80229e:	74 07                	je     8022a7 <print_mem_block_lists+0x155>
  8022a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a3:	8b 00                	mov    (%eax),%eax
  8022a5:	eb 05                	jmp    8022ac <print_mem_block_lists+0x15a>
  8022a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8022ac:	a3 48 50 80 00       	mov    %eax,0x805048
  8022b1:	a1 48 50 80 00       	mov    0x805048,%eax
  8022b6:	85 c0                	test   %eax,%eax
  8022b8:	75 8a                	jne    802244 <print_mem_block_lists+0xf2>
  8022ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022be:	75 84                	jne    802244 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8022c0:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8022c4:	75 10                	jne    8022d6 <print_mem_block_lists+0x184>
  8022c6:	83 ec 0c             	sub    $0xc,%esp
  8022c9:	68 94 45 80 00       	push   $0x804594
  8022ce:	e8 b0 e6 ff ff       	call   800983 <cprintf>
  8022d3:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8022d6:	83 ec 0c             	sub    $0xc,%esp
  8022d9:	68 08 45 80 00       	push   $0x804508
  8022de:	e8 a0 e6 ff ff       	call   800983 <cprintf>
  8022e3:	83 c4 10             	add    $0x10,%esp

}
  8022e6:	90                   	nop
  8022e7:	c9                   	leave  
  8022e8:	c3                   	ret    

008022e9 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8022e9:	55                   	push   %ebp
  8022ea:	89 e5                	mov    %esp,%ebp
  8022ec:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  8022ef:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  8022f6:	00 00 00 
  8022f9:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802300:	00 00 00 
  802303:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  80230a:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  80230d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802314:	e9 9e 00 00 00       	jmp    8023b7 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  802319:	a1 50 50 80 00       	mov    0x805050,%eax
  80231e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802321:	c1 e2 04             	shl    $0x4,%edx
  802324:	01 d0                	add    %edx,%eax
  802326:	85 c0                	test   %eax,%eax
  802328:	75 14                	jne    80233e <initialize_MemBlocksList+0x55>
  80232a:	83 ec 04             	sub    $0x4,%esp
  80232d:	68 bc 45 80 00       	push   $0x8045bc
  802332:	6a 46                	push   $0x46
  802334:	68 df 45 80 00       	push   $0x8045df
  802339:	e8 91 e3 ff ff       	call   8006cf <_panic>
  80233e:	a1 50 50 80 00       	mov    0x805050,%eax
  802343:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802346:	c1 e2 04             	shl    $0x4,%edx
  802349:	01 d0                	add    %edx,%eax
  80234b:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802351:	89 10                	mov    %edx,(%eax)
  802353:	8b 00                	mov    (%eax),%eax
  802355:	85 c0                	test   %eax,%eax
  802357:	74 18                	je     802371 <initialize_MemBlocksList+0x88>
  802359:	a1 48 51 80 00       	mov    0x805148,%eax
  80235e:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802364:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802367:	c1 e1 04             	shl    $0x4,%ecx
  80236a:	01 ca                	add    %ecx,%edx
  80236c:	89 50 04             	mov    %edx,0x4(%eax)
  80236f:	eb 12                	jmp    802383 <initialize_MemBlocksList+0x9a>
  802371:	a1 50 50 80 00       	mov    0x805050,%eax
  802376:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802379:	c1 e2 04             	shl    $0x4,%edx
  80237c:	01 d0                	add    %edx,%eax
  80237e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802383:	a1 50 50 80 00       	mov    0x805050,%eax
  802388:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80238b:	c1 e2 04             	shl    $0x4,%edx
  80238e:	01 d0                	add    %edx,%eax
  802390:	a3 48 51 80 00       	mov    %eax,0x805148
  802395:	a1 50 50 80 00       	mov    0x805050,%eax
  80239a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80239d:	c1 e2 04             	shl    $0x4,%edx
  8023a0:	01 d0                	add    %edx,%eax
  8023a2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023a9:	a1 54 51 80 00       	mov    0x805154,%eax
  8023ae:	40                   	inc    %eax
  8023af:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  8023b4:	ff 45 f4             	incl   -0xc(%ebp)
  8023b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ba:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023bd:	0f 82 56 ff ff ff    	jb     802319 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  8023c3:	90                   	nop
  8023c4:	c9                   	leave  
  8023c5:	c3                   	ret    

008023c6 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8023c6:	55                   	push   %ebp
  8023c7:	89 e5                	mov    %esp,%ebp
  8023c9:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8023cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8023cf:	8b 00                	mov    (%eax),%eax
  8023d1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8023d4:	eb 19                	jmp    8023ef <find_block+0x29>
	{
		if(va==point->sva)
  8023d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8023d9:	8b 40 08             	mov    0x8(%eax),%eax
  8023dc:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8023df:	75 05                	jne    8023e6 <find_block+0x20>
		   return point;
  8023e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8023e4:	eb 36                	jmp    80241c <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8023e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e9:	8b 40 08             	mov    0x8(%eax),%eax
  8023ec:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8023ef:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8023f3:	74 07                	je     8023fc <find_block+0x36>
  8023f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8023f8:	8b 00                	mov    (%eax),%eax
  8023fa:	eb 05                	jmp    802401 <find_block+0x3b>
  8023fc:	b8 00 00 00 00       	mov    $0x0,%eax
  802401:	8b 55 08             	mov    0x8(%ebp),%edx
  802404:	89 42 08             	mov    %eax,0x8(%edx)
  802407:	8b 45 08             	mov    0x8(%ebp),%eax
  80240a:	8b 40 08             	mov    0x8(%eax),%eax
  80240d:	85 c0                	test   %eax,%eax
  80240f:	75 c5                	jne    8023d6 <find_block+0x10>
  802411:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802415:	75 bf                	jne    8023d6 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802417:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80241c:	c9                   	leave  
  80241d:	c3                   	ret    

0080241e <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80241e:	55                   	push   %ebp
  80241f:	89 e5                	mov    %esp,%ebp
  802421:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  802424:	a1 40 50 80 00       	mov    0x805040,%eax
  802429:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  80242c:	a1 44 50 80 00       	mov    0x805044,%eax
  802431:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  802434:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802437:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80243a:	74 24                	je     802460 <insert_sorted_allocList+0x42>
  80243c:	8b 45 08             	mov    0x8(%ebp),%eax
  80243f:	8b 50 08             	mov    0x8(%eax),%edx
  802442:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802445:	8b 40 08             	mov    0x8(%eax),%eax
  802448:	39 c2                	cmp    %eax,%edx
  80244a:	76 14                	jbe    802460 <insert_sorted_allocList+0x42>
  80244c:	8b 45 08             	mov    0x8(%ebp),%eax
  80244f:	8b 50 08             	mov    0x8(%eax),%edx
  802452:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802455:	8b 40 08             	mov    0x8(%eax),%eax
  802458:	39 c2                	cmp    %eax,%edx
  80245a:	0f 82 60 01 00 00    	jb     8025c0 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802460:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802464:	75 65                	jne    8024cb <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802466:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80246a:	75 14                	jne    802480 <insert_sorted_allocList+0x62>
  80246c:	83 ec 04             	sub    $0x4,%esp
  80246f:	68 bc 45 80 00       	push   $0x8045bc
  802474:	6a 6b                	push   $0x6b
  802476:	68 df 45 80 00       	push   $0x8045df
  80247b:	e8 4f e2 ff ff       	call   8006cf <_panic>
  802480:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802486:	8b 45 08             	mov    0x8(%ebp),%eax
  802489:	89 10                	mov    %edx,(%eax)
  80248b:	8b 45 08             	mov    0x8(%ebp),%eax
  80248e:	8b 00                	mov    (%eax),%eax
  802490:	85 c0                	test   %eax,%eax
  802492:	74 0d                	je     8024a1 <insert_sorted_allocList+0x83>
  802494:	a1 40 50 80 00       	mov    0x805040,%eax
  802499:	8b 55 08             	mov    0x8(%ebp),%edx
  80249c:	89 50 04             	mov    %edx,0x4(%eax)
  80249f:	eb 08                	jmp    8024a9 <insert_sorted_allocList+0x8b>
  8024a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a4:	a3 44 50 80 00       	mov    %eax,0x805044
  8024a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ac:	a3 40 50 80 00       	mov    %eax,0x805040
  8024b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024bb:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8024c0:	40                   	inc    %eax
  8024c1:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8024c6:	e9 dc 01 00 00       	jmp    8026a7 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  8024cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ce:	8b 50 08             	mov    0x8(%eax),%edx
  8024d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024d4:	8b 40 08             	mov    0x8(%eax),%eax
  8024d7:	39 c2                	cmp    %eax,%edx
  8024d9:	77 6c                	ja     802547 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  8024db:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8024df:	74 06                	je     8024e7 <insert_sorted_allocList+0xc9>
  8024e1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8024e5:	75 14                	jne    8024fb <insert_sorted_allocList+0xdd>
  8024e7:	83 ec 04             	sub    $0x4,%esp
  8024ea:	68 f8 45 80 00       	push   $0x8045f8
  8024ef:	6a 6f                	push   $0x6f
  8024f1:	68 df 45 80 00       	push   $0x8045df
  8024f6:	e8 d4 e1 ff ff       	call   8006cf <_panic>
  8024fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024fe:	8b 50 04             	mov    0x4(%eax),%edx
  802501:	8b 45 08             	mov    0x8(%ebp),%eax
  802504:	89 50 04             	mov    %edx,0x4(%eax)
  802507:	8b 45 08             	mov    0x8(%ebp),%eax
  80250a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80250d:	89 10                	mov    %edx,(%eax)
  80250f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802512:	8b 40 04             	mov    0x4(%eax),%eax
  802515:	85 c0                	test   %eax,%eax
  802517:	74 0d                	je     802526 <insert_sorted_allocList+0x108>
  802519:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80251c:	8b 40 04             	mov    0x4(%eax),%eax
  80251f:	8b 55 08             	mov    0x8(%ebp),%edx
  802522:	89 10                	mov    %edx,(%eax)
  802524:	eb 08                	jmp    80252e <insert_sorted_allocList+0x110>
  802526:	8b 45 08             	mov    0x8(%ebp),%eax
  802529:	a3 40 50 80 00       	mov    %eax,0x805040
  80252e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802531:	8b 55 08             	mov    0x8(%ebp),%edx
  802534:	89 50 04             	mov    %edx,0x4(%eax)
  802537:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80253c:	40                   	inc    %eax
  80253d:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802542:	e9 60 01 00 00       	jmp    8026a7 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802547:	8b 45 08             	mov    0x8(%ebp),%eax
  80254a:	8b 50 08             	mov    0x8(%eax),%edx
  80254d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802550:	8b 40 08             	mov    0x8(%eax),%eax
  802553:	39 c2                	cmp    %eax,%edx
  802555:	0f 82 4c 01 00 00    	jb     8026a7 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  80255b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80255f:	75 14                	jne    802575 <insert_sorted_allocList+0x157>
  802561:	83 ec 04             	sub    $0x4,%esp
  802564:	68 30 46 80 00       	push   $0x804630
  802569:	6a 73                	push   $0x73
  80256b:	68 df 45 80 00       	push   $0x8045df
  802570:	e8 5a e1 ff ff       	call   8006cf <_panic>
  802575:	8b 15 44 50 80 00    	mov    0x805044,%edx
  80257b:	8b 45 08             	mov    0x8(%ebp),%eax
  80257e:	89 50 04             	mov    %edx,0x4(%eax)
  802581:	8b 45 08             	mov    0x8(%ebp),%eax
  802584:	8b 40 04             	mov    0x4(%eax),%eax
  802587:	85 c0                	test   %eax,%eax
  802589:	74 0c                	je     802597 <insert_sorted_allocList+0x179>
  80258b:	a1 44 50 80 00       	mov    0x805044,%eax
  802590:	8b 55 08             	mov    0x8(%ebp),%edx
  802593:	89 10                	mov    %edx,(%eax)
  802595:	eb 08                	jmp    80259f <insert_sorted_allocList+0x181>
  802597:	8b 45 08             	mov    0x8(%ebp),%eax
  80259a:	a3 40 50 80 00       	mov    %eax,0x805040
  80259f:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a2:	a3 44 50 80 00       	mov    %eax,0x805044
  8025a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8025aa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025b0:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8025b5:	40                   	inc    %eax
  8025b6:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8025bb:	e9 e7 00 00 00       	jmp    8026a7 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  8025c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  8025c6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8025cd:	a1 40 50 80 00       	mov    0x805040,%eax
  8025d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025d5:	e9 9d 00 00 00       	jmp    802677 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  8025da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025dd:	8b 00                	mov    (%eax),%eax
  8025df:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  8025e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8025e5:	8b 50 08             	mov    0x8(%eax),%edx
  8025e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025eb:	8b 40 08             	mov    0x8(%eax),%eax
  8025ee:	39 c2                	cmp    %eax,%edx
  8025f0:	76 7d                	jbe    80266f <insert_sorted_allocList+0x251>
  8025f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8025f5:	8b 50 08             	mov    0x8(%eax),%edx
  8025f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8025fb:	8b 40 08             	mov    0x8(%eax),%eax
  8025fe:	39 c2                	cmp    %eax,%edx
  802600:	73 6d                	jae    80266f <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802602:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802606:	74 06                	je     80260e <insert_sorted_allocList+0x1f0>
  802608:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80260c:	75 14                	jne    802622 <insert_sorted_allocList+0x204>
  80260e:	83 ec 04             	sub    $0x4,%esp
  802611:	68 54 46 80 00       	push   $0x804654
  802616:	6a 7f                	push   $0x7f
  802618:	68 df 45 80 00       	push   $0x8045df
  80261d:	e8 ad e0 ff ff       	call   8006cf <_panic>
  802622:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802625:	8b 10                	mov    (%eax),%edx
  802627:	8b 45 08             	mov    0x8(%ebp),%eax
  80262a:	89 10                	mov    %edx,(%eax)
  80262c:	8b 45 08             	mov    0x8(%ebp),%eax
  80262f:	8b 00                	mov    (%eax),%eax
  802631:	85 c0                	test   %eax,%eax
  802633:	74 0b                	je     802640 <insert_sorted_allocList+0x222>
  802635:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802638:	8b 00                	mov    (%eax),%eax
  80263a:	8b 55 08             	mov    0x8(%ebp),%edx
  80263d:	89 50 04             	mov    %edx,0x4(%eax)
  802640:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802643:	8b 55 08             	mov    0x8(%ebp),%edx
  802646:	89 10                	mov    %edx,(%eax)
  802648:	8b 45 08             	mov    0x8(%ebp),%eax
  80264b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80264e:	89 50 04             	mov    %edx,0x4(%eax)
  802651:	8b 45 08             	mov    0x8(%ebp),%eax
  802654:	8b 00                	mov    (%eax),%eax
  802656:	85 c0                	test   %eax,%eax
  802658:	75 08                	jne    802662 <insert_sorted_allocList+0x244>
  80265a:	8b 45 08             	mov    0x8(%ebp),%eax
  80265d:	a3 44 50 80 00       	mov    %eax,0x805044
  802662:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802667:	40                   	inc    %eax
  802668:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  80266d:	eb 39                	jmp    8026a8 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80266f:	a1 48 50 80 00       	mov    0x805048,%eax
  802674:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802677:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80267b:	74 07                	je     802684 <insert_sorted_allocList+0x266>
  80267d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802680:	8b 00                	mov    (%eax),%eax
  802682:	eb 05                	jmp    802689 <insert_sorted_allocList+0x26b>
  802684:	b8 00 00 00 00       	mov    $0x0,%eax
  802689:	a3 48 50 80 00       	mov    %eax,0x805048
  80268e:	a1 48 50 80 00       	mov    0x805048,%eax
  802693:	85 c0                	test   %eax,%eax
  802695:	0f 85 3f ff ff ff    	jne    8025da <insert_sorted_allocList+0x1bc>
  80269b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80269f:	0f 85 35 ff ff ff    	jne    8025da <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8026a5:	eb 01                	jmp    8026a8 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8026a7:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8026a8:	90                   	nop
  8026a9:	c9                   	leave  
  8026aa:	c3                   	ret    

008026ab <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8026ab:	55                   	push   %ebp
  8026ac:	89 e5                	mov    %esp,%ebp
  8026ae:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8026b1:	a1 38 51 80 00       	mov    0x805138,%eax
  8026b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026b9:	e9 85 01 00 00       	jmp    802843 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  8026be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c1:	8b 40 0c             	mov    0xc(%eax),%eax
  8026c4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026c7:	0f 82 6e 01 00 00    	jb     80283b <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  8026cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d0:	8b 40 0c             	mov    0xc(%eax),%eax
  8026d3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026d6:	0f 85 8a 00 00 00    	jne    802766 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  8026dc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026e0:	75 17                	jne    8026f9 <alloc_block_FF+0x4e>
  8026e2:	83 ec 04             	sub    $0x4,%esp
  8026e5:	68 88 46 80 00       	push   $0x804688
  8026ea:	68 93 00 00 00       	push   $0x93
  8026ef:	68 df 45 80 00       	push   $0x8045df
  8026f4:	e8 d6 df ff ff       	call   8006cf <_panic>
  8026f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fc:	8b 00                	mov    (%eax),%eax
  8026fe:	85 c0                	test   %eax,%eax
  802700:	74 10                	je     802712 <alloc_block_FF+0x67>
  802702:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802705:	8b 00                	mov    (%eax),%eax
  802707:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80270a:	8b 52 04             	mov    0x4(%edx),%edx
  80270d:	89 50 04             	mov    %edx,0x4(%eax)
  802710:	eb 0b                	jmp    80271d <alloc_block_FF+0x72>
  802712:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802715:	8b 40 04             	mov    0x4(%eax),%eax
  802718:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80271d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802720:	8b 40 04             	mov    0x4(%eax),%eax
  802723:	85 c0                	test   %eax,%eax
  802725:	74 0f                	je     802736 <alloc_block_FF+0x8b>
  802727:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272a:	8b 40 04             	mov    0x4(%eax),%eax
  80272d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802730:	8b 12                	mov    (%edx),%edx
  802732:	89 10                	mov    %edx,(%eax)
  802734:	eb 0a                	jmp    802740 <alloc_block_FF+0x95>
  802736:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802739:	8b 00                	mov    (%eax),%eax
  80273b:	a3 38 51 80 00       	mov    %eax,0x805138
  802740:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802743:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802749:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802753:	a1 44 51 80 00       	mov    0x805144,%eax
  802758:	48                   	dec    %eax
  802759:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  80275e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802761:	e9 10 01 00 00       	jmp    802876 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802766:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802769:	8b 40 0c             	mov    0xc(%eax),%eax
  80276c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80276f:	0f 86 c6 00 00 00    	jbe    80283b <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802775:	a1 48 51 80 00       	mov    0x805148,%eax
  80277a:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  80277d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802780:	8b 50 08             	mov    0x8(%eax),%edx
  802783:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802786:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802789:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80278c:	8b 55 08             	mov    0x8(%ebp),%edx
  80278f:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802792:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802796:	75 17                	jne    8027af <alloc_block_FF+0x104>
  802798:	83 ec 04             	sub    $0x4,%esp
  80279b:	68 88 46 80 00       	push   $0x804688
  8027a0:	68 9b 00 00 00       	push   $0x9b
  8027a5:	68 df 45 80 00       	push   $0x8045df
  8027aa:	e8 20 df ff ff       	call   8006cf <_panic>
  8027af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027b2:	8b 00                	mov    (%eax),%eax
  8027b4:	85 c0                	test   %eax,%eax
  8027b6:	74 10                	je     8027c8 <alloc_block_FF+0x11d>
  8027b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027bb:	8b 00                	mov    (%eax),%eax
  8027bd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027c0:	8b 52 04             	mov    0x4(%edx),%edx
  8027c3:	89 50 04             	mov    %edx,0x4(%eax)
  8027c6:	eb 0b                	jmp    8027d3 <alloc_block_FF+0x128>
  8027c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027cb:	8b 40 04             	mov    0x4(%eax),%eax
  8027ce:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8027d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027d6:	8b 40 04             	mov    0x4(%eax),%eax
  8027d9:	85 c0                	test   %eax,%eax
  8027db:	74 0f                	je     8027ec <alloc_block_FF+0x141>
  8027dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027e0:	8b 40 04             	mov    0x4(%eax),%eax
  8027e3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027e6:	8b 12                	mov    (%edx),%edx
  8027e8:	89 10                	mov    %edx,(%eax)
  8027ea:	eb 0a                	jmp    8027f6 <alloc_block_FF+0x14b>
  8027ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027ef:	8b 00                	mov    (%eax),%eax
  8027f1:	a3 48 51 80 00       	mov    %eax,0x805148
  8027f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027f9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802802:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802809:	a1 54 51 80 00       	mov    0x805154,%eax
  80280e:	48                   	dec    %eax
  80280f:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802814:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802817:	8b 50 08             	mov    0x8(%eax),%edx
  80281a:	8b 45 08             	mov    0x8(%ebp),%eax
  80281d:	01 c2                	add    %eax,%edx
  80281f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802822:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802825:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802828:	8b 40 0c             	mov    0xc(%eax),%eax
  80282b:	2b 45 08             	sub    0x8(%ebp),%eax
  80282e:	89 c2                	mov    %eax,%edx
  802830:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802833:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802836:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802839:	eb 3b                	jmp    802876 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  80283b:	a1 40 51 80 00       	mov    0x805140,%eax
  802840:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802843:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802847:	74 07                	je     802850 <alloc_block_FF+0x1a5>
  802849:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284c:	8b 00                	mov    (%eax),%eax
  80284e:	eb 05                	jmp    802855 <alloc_block_FF+0x1aa>
  802850:	b8 00 00 00 00       	mov    $0x0,%eax
  802855:	a3 40 51 80 00       	mov    %eax,0x805140
  80285a:	a1 40 51 80 00       	mov    0x805140,%eax
  80285f:	85 c0                	test   %eax,%eax
  802861:	0f 85 57 fe ff ff    	jne    8026be <alloc_block_FF+0x13>
  802867:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80286b:	0f 85 4d fe ff ff    	jne    8026be <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802871:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802876:	c9                   	leave  
  802877:	c3                   	ret    

00802878 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802878:	55                   	push   %ebp
  802879:	89 e5                	mov    %esp,%ebp
  80287b:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  80287e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802885:	a1 38 51 80 00       	mov    0x805138,%eax
  80288a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80288d:	e9 df 00 00 00       	jmp    802971 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802892:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802895:	8b 40 0c             	mov    0xc(%eax),%eax
  802898:	3b 45 08             	cmp    0x8(%ebp),%eax
  80289b:	0f 82 c8 00 00 00    	jb     802969 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  8028a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a4:	8b 40 0c             	mov    0xc(%eax),%eax
  8028a7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028aa:	0f 85 8a 00 00 00    	jne    80293a <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  8028b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028b4:	75 17                	jne    8028cd <alloc_block_BF+0x55>
  8028b6:	83 ec 04             	sub    $0x4,%esp
  8028b9:	68 88 46 80 00       	push   $0x804688
  8028be:	68 b7 00 00 00       	push   $0xb7
  8028c3:	68 df 45 80 00       	push   $0x8045df
  8028c8:	e8 02 de ff ff       	call   8006cf <_panic>
  8028cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d0:	8b 00                	mov    (%eax),%eax
  8028d2:	85 c0                	test   %eax,%eax
  8028d4:	74 10                	je     8028e6 <alloc_block_BF+0x6e>
  8028d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d9:	8b 00                	mov    (%eax),%eax
  8028db:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028de:	8b 52 04             	mov    0x4(%edx),%edx
  8028e1:	89 50 04             	mov    %edx,0x4(%eax)
  8028e4:	eb 0b                	jmp    8028f1 <alloc_block_BF+0x79>
  8028e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e9:	8b 40 04             	mov    0x4(%eax),%eax
  8028ec:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8028f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f4:	8b 40 04             	mov    0x4(%eax),%eax
  8028f7:	85 c0                	test   %eax,%eax
  8028f9:	74 0f                	je     80290a <alloc_block_BF+0x92>
  8028fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028fe:	8b 40 04             	mov    0x4(%eax),%eax
  802901:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802904:	8b 12                	mov    (%edx),%edx
  802906:	89 10                	mov    %edx,(%eax)
  802908:	eb 0a                	jmp    802914 <alloc_block_BF+0x9c>
  80290a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290d:	8b 00                	mov    (%eax),%eax
  80290f:	a3 38 51 80 00       	mov    %eax,0x805138
  802914:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802917:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80291d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802920:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802927:	a1 44 51 80 00       	mov    0x805144,%eax
  80292c:	48                   	dec    %eax
  80292d:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802932:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802935:	e9 4d 01 00 00       	jmp    802a87 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  80293a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293d:	8b 40 0c             	mov    0xc(%eax),%eax
  802940:	3b 45 08             	cmp    0x8(%ebp),%eax
  802943:	76 24                	jbe    802969 <alloc_block_BF+0xf1>
  802945:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802948:	8b 40 0c             	mov    0xc(%eax),%eax
  80294b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80294e:	73 19                	jae    802969 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802950:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802957:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295a:	8b 40 0c             	mov    0xc(%eax),%eax
  80295d:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802960:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802963:	8b 40 08             	mov    0x8(%eax),%eax
  802966:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802969:	a1 40 51 80 00       	mov    0x805140,%eax
  80296e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802971:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802975:	74 07                	je     80297e <alloc_block_BF+0x106>
  802977:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297a:	8b 00                	mov    (%eax),%eax
  80297c:	eb 05                	jmp    802983 <alloc_block_BF+0x10b>
  80297e:	b8 00 00 00 00       	mov    $0x0,%eax
  802983:	a3 40 51 80 00       	mov    %eax,0x805140
  802988:	a1 40 51 80 00       	mov    0x805140,%eax
  80298d:	85 c0                	test   %eax,%eax
  80298f:	0f 85 fd fe ff ff    	jne    802892 <alloc_block_BF+0x1a>
  802995:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802999:	0f 85 f3 fe ff ff    	jne    802892 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  80299f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8029a3:	0f 84 d9 00 00 00    	je     802a82 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  8029a9:	a1 48 51 80 00       	mov    0x805148,%eax
  8029ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  8029b1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029b4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8029b7:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  8029ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029bd:	8b 55 08             	mov    0x8(%ebp),%edx
  8029c0:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  8029c3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8029c7:	75 17                	jne    8029e0 <alloc_block_BF+0x168>
  8029c9:	83 ec 04             	sub    $0x4,%esp
  8029cc:	68 88 46 80 00       	push   $0x804688
  8029d1:	68 c7 00 00 00       	push   $0xc7
  8029d6:	68 df 45 80 00       	push   $0x8045df
  8029db:	e8 ef dc ff ff       	call   8006cf <_panic>
  8029e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029e3:	8b 00                	mov    (%eax),%eax
  8029e5:	85 c0                	test   %eax,%eax
  8029e7:	74 10                	je     8029f9 <alloc_block_BF+0x181>
  8029e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029ec:	8b 00                	mov    (%eax),%eax
  8029ee:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8029f1:	8b 52 04             	mov    0x4(%edx),%edx
  8029f4:	89 50 04             	mov    %edx,0x4(%eax)
  8029f7:	eb 0b                	jmp    802a04 <alloc_block_BF+0x18c>
  8029f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029fc:	8b 40 04             	mov    0x4(%eax),%eax
  8029ff:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802a04:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a07:	8b 40 04             	mov    0x4(%eax),%eax
  802a0a:	85 c0                	test   %eax,%eax
  802a0c:	74 0f                	je     802a1d <alloc_block_BF+0x1a5>
  802a0e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a11:	8b 40 04             	mov    0x4(%eax),%eax
  802a14:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802a17:	8b 12                	mov    (%edx),%edx
  802a19:	89 10                	mov    %edx,(%eax)
  802a1b:	eb 0a                	jmp    802a27 <alloc_block_BF+0x1af>
  802a1d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a20:	8b 00                	mov    (%eax),%eax
  802a22:	a3 48 51 80 00       	mov    %eax,0x805148
  802a27:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a2a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a30:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a33:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a3a:	a1 54 51 80 00       	mov    0x805154,%eax
  802a3f:	48                   	dec    %eax
  802a40:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802a45:	83 ec 08             	sub    $0x8,%esp
  802a48:	ff 75 ec             	pushl  -0x14(%ebp)
  802a4b:	68 38 51 80 00       	push   $0x805138
  802a50:	e8 71 f9 ff ff       	call   8023c6 <find_block>
  802a55:	83 c4 10             	add    $0x10,%esp
  802a58:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802a5b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a5e:	8b 50 08             	mov    0x8(%eax),%edx
  802a61:	8b 45 08             	mov    0x8(%ebp),%eax
  802a64:	01 c2                	add    %eax,%edx
  802a66:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a69:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802a6c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a6f:	8b 40 0c             	mov    0xc(%eax),%eax
  802a72:	2b 45 08             	sub    0x8(%ebp),%eax
  802a75:	89 c2                	mov    %eax,%edx
  802a77:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a7a:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802a7d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a80:	eb 05                	jmp    802a87 <alloc_block_BF+0x20f>
	}
	return NULL;
  802a82:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a87:	c9                   	leave  
  802a88:	c3                   	ret    

00802a89 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802a89:	55                   	push   %ebp
  802a8a:	89 e5                	mov    %esp,%ebp
  802a8c:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802a8f:	a1 28 50 80 00       	mov    0x805028,%eax
  802a94:	85 c0                	test   %eax,%eax
  802a96:	0f 85 de 01 00 00    	jne    802c7a <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802a9c:	a1 38 51 80 00       	mov    0x805138,%eax
  802aa1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802aa4:	e9 9e 01 00 00       	jmp    802c47 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802aa9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aac:	8b 40 0c             	mov    0xc(%eax),%eax
  802aaf:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ab2:	0f 82 87 01 00 00    	jb     802c3f <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802ab8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802abb:	8b 40 0c             	mov    0xc(%eax),%eax
  802abe:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ac1:	0f 85 95 00 00 00    	jne    802b5c <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802ac7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802acb:	75 17                	jne    802ae4 <alloc_block_NF+0x5b>
  802acd:	83 ec 04             	sub    $0x4,%esp
  802ad0:	68 88 46 80 00       	push   $0x804688
  802ad5:	68 e0 00 00 00       	push   $0xe0
  802ada:	68 df 45 80 00       	push   $0x8045df
  802adf:	e8 eb db ff ff       	call   8006cf <_panic>
  802ae4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae7:	8b 00                	mov    (%eax),%eax
  802ae9:	85 c0                	test   %eax,%eax
  802aeb:	74 10                	je     802afd <alloc_block_NF+0x74>
  802aed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af0:	8b 00                	mov    (%eax),%eax
  802af2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802af5:	8b 52 04             	mov    0x4(%edx),%edx
  802af8:	89 50 04             	mov    %edx,0x4(%eax)
  802afb:	eb 0b                	jmp    802b08 <alloc_block_NF+0x7f>
  802afd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b00:	8b 40 04             	mov    0x4(%eax),%eax
  802b03:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802b08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0b:	8b 40 04             	mov    0x4(%eax),%eax
  802b0e:	85 c0                	test   %eax,%eax
  802b10:	74 0f                	je     802b21 <alloc_block_NF+0x98>
  802b12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b15:	8b 40 04             	mov    0x4(%eax),%eax
  802b18:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b1b:	8b 12                	mov    (%edx),%edx
  802b1d:	89 10                	mov    %edx,(%eax)
  802b1f:	eb 0a                	jmp    802b2b <alloc_block_NF+0xa2>
  802b21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b24:	8b 00                	mov    (%eax),%eax
  802b26:	a3 38 51 80 00       	mov    %eax,0x805138
  802b2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b2e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b37:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b3e:	a1 44 51 80 00       	mov    0x805144,%eax
  802b43:	48                   	dec    %eax
  802b44:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802b49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4c:	8b 40 08             	mov    0x8(%eax),%eax
  802b4f:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  802b54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b57:	e9 f8 04 00 00       	jmp    803054 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802b5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5f:	8b 40 0c             	mov    0xc(%eax),%eax
  802b62:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b65:	0f 86 d4 00 00 00    	jbe    802c3f <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802b6b:	a1 48 51 80 00       	mov    0x805148,%eax
  802b70:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802b73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b76:	8b 50 08             	mov    0x8(%eax),%edx
  802b79:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b7c:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802b7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b82:	8b 55 08             	mov    0x8(%ebp),%edx
  802b85:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802b88:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b8c:	75 17                	jne    802ba5 <alloc_block_NF+0x11c>
  802b8e:	83 ec 04             	sub    $0x4,%esp
  802b91:	68 88 46 80 00       	push   $0x804688
  802b96:	68 e9 00 00 00       	push   $0xe9
  802b9b:	68 df 45 80 00       	push   $0x8045df
  802ba0:	e8 2a db ff ff       	call   8006cf <_panic>
  802ba5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ba8:	8b 00                	mov    (%eax),%eax
  802baa:	85 c0                	test   %eax,%eax
  802bac:	74 10                	je     802bbe <alloc_block_NF+0x135>
  802bae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bb1:	8b 00                	mov    (%eax),%eax
  802bb3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bb6:	8b 52 04             	mov    0x4(%edx),%edx
  802bb9:	89 50 04             	mov    %edx,0x4(%eax)
  802bbc:	eb 0b                	jmp    802bc9 <alloc_block_NF+0x140>
  802bbe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bc1:	8b 40 04             	mov    0x4(%eax),%eax
  802bc4:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802bc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bcc:	8b 40 04             	mov    0x4(%eax),%eax
  802bcf:	85 c0                	test   %eax,%eax
  802bd1:	74 0f                	je     802be2 <alloc_block_NF+0x159>
  802bd3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bd6:	8b 40 04             	mov    0x4(%eax),%eax
  802bd9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bdc:	8b 12                	mov    (%edx),%edx
  802bde:	89 10                	mov    %edx,(%eax)
  802be0:	eb 0a                	jmp    802bec <alloc_block_NF+0x163>
  802be2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802be5:	8b 00                	mov    (%eax),%eax
  802be7:	a3 48 51 80 00       	mov    %eax,0x805148
  802bec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bf5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bf8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bff:	a1 54 51 80 00       	mov    0x805154,%eax
  802c04:	48                   	dec    %eax
  802c05:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802c0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c0d:	8b 40 08             	mov    0x8(%eax),%eax
  802c10:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802c15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c18:	8b 50 08             	mov    0x8(%eax),%edx
  802c1b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c1e:	01 c2                	add    %eax,%edx
  802c20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c23:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802c26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c29:	8b 40 0c             	mov    0xc(%eax),%eax
  802c2c:	2b 45 08             	sub    0x8(%ebp),%eax
  802c2f:	89 c2                	mov    %eax,%edx
  802c31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c34:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802c37:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c3a:	e9 15 04 00 00       	jmp    803054 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802c3f:	a1 40 51 80 00       	mov    0x805140,%eax
  802c44:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c47:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c4b:	74 07                	je     802c54 <alloc_block_NF+0x1cb>
  802c4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c50:	8b 00                	mov    (%eax),%eax
  802c52:	eb 05                	jmp    802c59 <alloc_block_NF+0x1d0>
  802c54:	b8 00 00 00 00       	mov    $0x0,%eax
  802c59:	a3 40 51 80 00       	mov    %eax,0x805140
  802c5e:	a1 40 51 80 00       	mov    0x805140,%eax
  802c63:	85 c0                	test   %eax,%eax
  802c65:	0f 85 3e fe ff ff    	jne    802aa9 <alloc_block_NF+0x20>
  802c6b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c6f:	0f 85 34 fe ff ff    	jne    802aa9 <alloc_block_NF+0x20>
  802c75:	e9 d5 03 00 00       	jmp    80304f <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802c7a:	a1 38 51 80 00       	mov    0x805138,%eax
  802c7f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c82:	e9 b1 01 00 00       	jmp    802e38 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802c87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c8a:	8b 50 08             	mov    0x8(%eax),%edx
  802c8d:	a1 28 50 80 00       	mov    0x805028,%eax
  802c92:	39 c2                	cmp    %eax,%edx
  802c94:	0f 82 96 01 00 00    	jb     802e30 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802c9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9d:	8b 40 0c             	mov    0xc(%eax),%eax
  802ca0:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ca3:	0f 82 87 01 00 00    	jb     802e30 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802ca9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cac:	8b 40 0c             	mov    0xc(%eax),%eax
  802caf:	3b 45 08             	cmp    0x8(%ebp),%eax
  802cb2:	0f 85 95 00 00 00    	jne    802d4d <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802cb8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cbc:	75 17                	jne    802cd5 <alloc_block_NF+0x24c>
  802cbe:	83 ec 04             	sub    $0x4,%esp
  802cc1:	68 88 46 80 00       	push   $0x804688
  802cc6:	68 fc 00 00 00       	push   $0xfc
  802ccb:	68 df 45 80 00       	push   $0x8045df
  802cd0:	e8 fa d9 ff ff       	call   8006cf <_panic>
  802cd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd8:	8b 00                	mov    (%eax),%eax
  802cda:	85 c0                	test   %eax,%eax
  802cdc:	74 10                	je     802cee <alloc_block_NF+0x265>
  802cde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce1:	8b 00                	mov    (%eax),%eax
  802ce3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ce6:	8b 52 04             	mov    0x4(%edx),%edx
  802ce9:	89 50 04             	mov    %edx,0x4(%eax)
  802cec:	eb 0b                	jmp    802cf9 <alloc_block_NF+0x270>
  802cee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf1:	8b 40 04             	mov    0x4(%eax),%eax
  802cf4:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802cf9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cfc:	8b 40 04             	mov    0x4(%eax),%eax
  802cff:	85 c0                	test   %eax,%eax
  802d01:	74 0f                	je     802d12 <alloc_block_NF+0x289>
  802d03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d06:	8b 40 04             	mov    0x4(%eax),%eax
  802d09:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d0c:	8b 12                	mov    (%edx),%edx
  802d0e:	89 10                	mov    %edx,(%eax)
  802d10:	eb 0a                	jmp    802d1c <alloc_block_NF+0x293>
  802d12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d15:	8b 00                	mov    (%eax),%eax
  802d17:	a3 38 51 80 00       	mov    %eax,0x805138
  802d1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d1f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d28:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d2f:	a1 44 51 80 00       	mov    0x805144,%eax
  802d34:	48                   	dec    %eax
  802d35:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802d3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3d:	8b 40 08             	mov    0x8(%eax),%eax
  802d40:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802d45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d48:	e9 07 03 00 00       	jmp    803054 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802d4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d50:	8b 40 0c             	mov    0xc(%eax),%eax
  802d53:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d56:	0f 86 d4 00 00 00    	jbe    802e30 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802d5c:	a1 48 51 80 00       	mov    0x805148,%eax
  802d61:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802d64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d67:	8b 50 08             	mov    0x8(%eax),%edx
  802d6a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d6d:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802d70:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d73:	8b 55 08             	mov    0x8(%ebp),%edx
  802d76:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802d79:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802d7d:	75 17                	jne    802d96 <alloc_block_NF+0x30d>
  802d7f:	83 ec 04             	sub    $0x4,%esp
  802d82:	68 88 46 80 00       	push   $0x804688
  802d87:	68 04 01 00 00       	push   $0x104
  802d8c:	68 df 45 80 00       	push   $0x8045df
  802d91:	e8 39 d9 ff ff       	call   8006cf <_panic>
  802d96:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d99:	8b 00                	mov    (%eax),%eax
  802d9b:	85 c0                	test   %eax,%eax
  802d9d:	74 10                	je     802daf <alloc_block_NF+0x326>
  802d9f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802da2:	8b 00                	mov    (%eax),%eax
  802da4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802da7:	8b 52 04             	mov    0x4(%edx),%edx
  802daa:	89 50 04             	mov    %edx,0x4(%eax)
  802dad:	eb 0b                	jmp    802dba <alloc_block_NF+0x331>
  802daf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802db2:	8b 40 04             	mov    0x4(%eax),%eax
  802db5:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802dba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dbd:	8b 40 04             	mov    0x4(%eax),%eax
  802dc0:	85 c0                	test   %eax,%eax
  802dc2:	74 0f                	je     802dd3 <alloc_block_NF+0x34a>
  802dc4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dc7:	8b 40 04             	mov    0x4(%eax),%eax
  802dca:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802dcd:	8b 12                	mov    (%edx),%edx
  802dcf:	89 10                	mov    %edx,(%eax)
  802dd1:	eb 0a                	jmp    802ddd <alloc_block_NF+0x354>
  802dd3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dd6:	8b 00                	mov    (%eax),%eax
  802dd8:	a3 48 51 80 00       	mov    %eax,0x805148
  802ddd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802de0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802de6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802de9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802df0:	a1 54 51 80 00       	mov    0x805154,%eax
  802df5:	48                   	dec    %eax
  802df6:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802dfb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dfe:	8b 40 08             	mov    0x8(%eax),%eax
  802e01:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802e06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e09:	8b 50 08             	mov    0x8(%eax),%edx
  802e0c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e0f:	01 c2                	add    %eax,%edx
  802e11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e14:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802e17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e1a:	8b 40 0c             	mov    0xc(%eax),%eax
  802e1d:	2b 45 08             	sub    0x8(%ebp),%eax
  802e20:	89 c2                	mov    %eax,%edx
  802e22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e25:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802e28:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e2b:	e9 24 02 00 00       	jmp    803054 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802e30:	a1 40 51 80 00       	mov    0x805140,%eax
  802e35:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e38:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e3c:	74 07                	je     802e45 <alloc_block_NF+0x3bc>
  802e3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e41:	8b 00                	mov    (%eax),%eax
  802e43:	eb 05                	jmp    802e4a <alloc_block_NF+0x3c1>
  802e45:	b8 00 00 00 00       	mov    $0x0,%eax
  802e4a:	a3 40 51 80 00       	mov    %eax,0x805140
  802e4f:	a1 40 51 80 00       	mov    0x805140,%eax
  802e54:	85 c0                	test   %eax,%eax
  802e56:	0f 85 2b fe ff ff    	jne    802c87 <alloc_block_NF+0x1fe>
  802e5c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e60:	0f 85 21 fe ff ff    	jne    802c87 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802e66:	a1 38 51 80 00       	mov    0x805138,%eax
  802e6b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e6e:	e9 ae 01 00 00       	jmp    803021 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802e73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e76:	8b 50 08             	mov    0x8(%eax),%edx
  802e79:	a1 28 50 80 00       	mov    0x805028,%eax
  802e7e:	39 c2                	cmp    %eax,%edx
  802e80:	0f 83 93 01 00 00    	jae    803019 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802e86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e89:	8b 40 0c             	mov    0xc(%eax),%eax
  802e8c:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e8f:	0f 82 84 01 00 00    	jb     803019 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802e95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e98:	8b 40 0c             	mov    0xc(%eax),%eax
  802e9b:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e9e:	0f 85 95 00 00 00    	jne    802f39 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802ea4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ea8:	75 17                	jne    802ec1 <alloc_block_NF+0x438>
  802eaa:	83 ec 04             	sub    $0x4,%esp
  802ead:	68 88 46 80 00       	push   $0x804688
  802eb2:	68 14 01 00 00       	push   $0x114
  802eb7:	68 df 45 80 00       	push   $0x8045df
  802ebc:	e8 0e d8 ff ff       	call   8006cf <_panic>
  802ec1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec4:	8b 00                	mov    (%eax),%eax
  802ec6:	85 c0                	test   %eax,%eax
  802ec8:	74 10                	je     802eda <alloc_block_NF+0x451>
  802eca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ecd:	8b 00                	mov    (%eax),%eax
  802ecf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ed2:	8b 52 04             	mov    0x4(%edx),%edx
  802ed5:	89 50 04             	mov    %edx,0x4(%eax)
  802ed8:	eb 0b                	jmp    802ee5 <alloc_block_NF+0x45c>
  802eda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802edd:	8b 40 04             	mov    0x4(%eax),%eax
  802ee0:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ee5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee8:	8b 40 04             	mov    0x4(%eax),%eax
  802eeb:	85 c0                	test   %eax,%eax
  802eed:	74 0f                	je     802efe <alloc_block_NF+0x475>
  802eef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef2:	8b 40 04             	mov    0x4(%eax),%eax
  802ef5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ef8:	8b 12                	mov    (%edx),%edx
  802efa:	89 10                	mov    %edx,(%eax)
  802efc:	eb 0a                	jmp    802f08 <alloc_block_NF+0x47f>
  802efe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f01:	8b 00                	mov    (%eax),%eax
  802f03:	a3 38 51 80 00       	mov    %eax,0x805138
  802f08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f0b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f14:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f1b:	a1 44 51 80 00       	mov    0x805144,%eax
  802f20:	48                   	dec    %eax
  802f21:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802f26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f29:	8b 40 08             	mov    0x8(%eax),%eax
  802f2c:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802f31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f34:	e9 1b 01 00 00       	jmp    803054 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802f39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f3c:	8b 40 0c             	mov    0xc(%eax),%eax
  802f3f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f42:	0f 86 d1 00 00 00    	jbe    803019 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802f48:	a1 48 51 80 00       	mov    0x805148,%eax
  802f4d:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802f50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f53:	8b 50 08             	mov    0x8(%eax),%edx
  802f56:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f59:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802f5c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f5f:	8b 55 08             	mov    0x8(%ebp),%edx
  802f62:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802f65:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802f69:	75 17                	jne    802f82 <alloc_block_NF+0x4f9>
  802f6b:	83 ec 04             	sub    $0x4,%esp
  802f6e:	68 88 46 80 00       	push   $0x804688
  802f73:	68 1c 01 00 00       	push   $0x11c
  802f78:	68 df 45 80 00       	push   $0x8045df
  802f7d:	e8 4d d7 ff ff       	call   8006cf <_panic>
  802f82:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f85:	8b 00                	mov    (%eax),%eax
  802f87:	85 c0                	test   %eax,%eax
  802f89:	74 10                	je     802f9b <alloc_block_NF+0x512>
  802f8b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f8e:	8b 00                	mov    (%eax),%eax
  802f90:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802f93:	8b 52 04             	mov    0x4(%edx),%edx
  802f96:	89 50 04             	mov    %edx,0x4(%eax)
  802f99:	eb 0b                	jmp    802fa6 <alloc_block_NF+0x51d>
  802f9b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f9e:	8b 40 04             	mov    0x4(%eax),%eax
  802fa1:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802fa6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fa9:	8b 40 04             	mov    0x4(%eax),%eax
  802fac:	85 c0                	test   %eax,%eax
  802fae:	74 0f                	je     802fbf <alloc_block_NF+0x536>
  802fb0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fb3:	8b 40 04             	mov    0x4(%eax),%eax
  802fb6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802fb9:	8b 12                	mov    (%edx),%edx
  802fbb:	89 10                	mov    %edx,(%eax)
  802fbd:	eb 0a                	jmp    802fc9 <alloc_block_NF+0x540>
  802fbf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fc2:	8b 00                	mov    (%eax),%eax
  802fc4:	a3 48 51 80 00       	mov    %eax,0x805148
  802fc9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fcc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fd2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fd5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fdc:	a1 54 51 80 00       	mov    0x805154,%eax
  802fe1:	48                   	dec    %eax
  802fe2:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802fe7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fea:	8b 40 08             	mov    0x8(%eax),%eax
  802fed:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802ff2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff5:	8b 50 08             	mov    0x8(%eax),%edx
  802ff8:	8b 45 08             	mov    0x8(%ebp),%eax
  802ffb:	01 c2                	add    %eax,%edx
  802ffd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803000:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  803003:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803006:	8b 40 0c             	mov    0xc(%eax),%eax
  803009:	2b 45 08             	sub    0x8(%ebp),%eax
  80300c:	89 c2                	mov    %eax,%edx
  80300e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803011:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  803014:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803017:	eb 3b                	jmp    803054 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  803019:	a1 40 51 80 00       	mov    0x805140,%eax
  80301e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803021:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803025:	74 07                	je     80302e <alloc_block_NF+0x5a5>
  803027:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80302a:	8b 00                	mov    (%eax),%eax
  80302c:	eb 05                	jmp    803033 <alloc_block_NF+0x5aa>
  80302e:	b8 00 00 00 00       	mov    $0x0,%eax
  803033:	a3 40 51 80 00       	mov    %eax,0x805140
  803038:	a1 40 51 80 00       	mov    0x805140,%eax
  80303d:	85 c0                	test   %eax,%eax
  80303f:	0f 85 2e fe ff ff    	jne    802e73 <alloc_block_NF+0x3ea>
  803045:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803049:	0f 85 24 fe ff ff    	jne    802e73 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  80304f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803054:	c9                   	leave  
  803055:	c3                   	ret    

00803056 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  803056:	55                   	push   %ebp
  803057:	89 e5                	mov    %esp,%ebp
  803059:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  80305c:	a1 38 51 80 00       	mov    0x805138,%eax
  803061:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  803064:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803069:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  80306c:	a1 38 51 80 00       	mov    0x805138,%eax
  803071:	85 c0                	test   %eax,%eax
  803073:	74 14                	je     803089 <insert_sorted_with_merge_freeList+0x33>
  803075:	8b 45 08             	mov    0x8(%ebp),%eax
  803078:	8b 50 08             	mov    0x8(%eax),%edx
  80307b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80307e:	8b 40 08             	mov    0x8(%eax),%eax
  803081:	39 c2                	cmp    %eax,%edx
  803083:	0f 87 9b 01 00 00    	ja     803224 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  803089:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80308d:	75 17                	jne    8030a6 <insert_sorted_with_merge_freeList+0x50>
  80308f:	83 ec 04             	sub    $0x4,%esp
  803092:	68 bc 45 80 00       	push   $0x8045bc
  803097:	68 38 01 00 00       	push   $0x138
  80309c:	68 df 45 80 00       	push   $0x8045df
  8030a1:	e8 29 d6 ff ff       	call   8006cf <_panic>
  8030a6:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8030ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8030af:	89 10                	mov    %edx,(%eax)
  8030b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b4:	8b 00                	mov    (%eax),%eax
  8030b6:	85 c0                	test   %eax,%eax
  8030b8:	74 0d                	je     8030c7 <insert_sorted_with_merge_freeList+0x71>
  8030ba:	a1 38 51 80 00       	mov    0x805138,%eax
  8030bf:	8b 55 08             	mov    0x8(%ebp),%edx
  8030c2:	89 50 04             	mov    %edx,0x4(%eax)
  8030c5:	eb 08                	jmp    8030cf <insert_sorted_with_merge_freeList+0x79>
  8030c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ca:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8030cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d2:	a3 38 51 80 00       	mov    %eax,0x805138
  8030d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8030da:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030e1:	a1 44 51 80 00       	mov    0x805144,%eax
  8030e6:	40                   	inc    %eax
  8030e7:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8030ec:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8030f0:	0f 84 a8 06 00 00    	je     80379e <insert_sorted_with_merge_freeList+0x748>
  8030f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f9:	8b 50 08             	mov    0x8(%eax),%edx
  8030fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ff:	8b 40 0c             	mov    0xc(%eax),%eax
  803102:	01 c2                	add    %eax,%edx
  803104:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803107:	8b 40 08             	mov    0x8(%eax),%eax
  80310a:	39 c2                	cmp    %eax,%edx
  80310c:	0f 85 8c 06 00 00    	jne    80379e <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  803112:	8b 45 08             	mov    0x8(%ebp),%eax
  803115:	8b 50 0c             	mov    0xc(%eax),%edx
  803118:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80311b:	8b 40 0c             	mov    0xc(%eax),%eax
  80311e:	01 c2                	add    %eax,%edx
  803120:	8b 45 08             	mov    0x8(%ebp),%eax
  803123:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  803126:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80312a:	75 17                	jne    803143 <insert_sorted_with_merge_freeList+0xed>
  80312c:	83 ec 04             	sub    $0x4,%esp
  80312f:	68 88 46 80 00       	push   $0x804688
  803134:	68 3c 01 00 00       	push   $0x13c
  803139:	68 df 45 80 00       	push   $0x8045df
  80313e:	e8 8c d5 ff ff       	call   8006cf <_panic>
  803143:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803146:	8b 00                	mov    (%eax),%eax
  803148:	85 c0                	test   %eax,%eax
  80314a:	74 10                	je     80315c <insert_sorted_with_merge_freeList+0x106>
  80314c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80314f:	8b 00                	mov    (%eax),%eax
  803151:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803154:	8b 52 04             	mov    0x4(%edx),%edx
  803157:	89 50 04             	mov    %edx,0x4(%eax)
  80315a:	eb 0b                	jmp    803167 <insert_sorted_with_merge_freeList+0x111>
  80315c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80315f:	8b 40 04             	mov    0x4(%eax),%eax
  803162:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803167:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80316a:	8b 40 04             	mov    0x4(%eax),%eax
  80316d:	85 c0                	test   %eax,%eax
  80316f:	74 0f                	je     803180 <insert_sorted_with_merge_freeList+0x12a>
  803171:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803174:	8b 40 04             	mov    0x4(%eax),%eax
  803177:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80317a:	8b 12                	mov    (%edx),%edx
  80317c:	89 10                	mov    %edx,(%eax)
  80317e:	eb 0a                	jmp    80318a <insert_sorted_with_merge_freeList+0x134>
  803180:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803183:	8b 00                	mov    (%eax),%eax
  803185:	a3 38 51 80 00       	mov    %eax,0x805138
  80318a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80318d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803193:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803196:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80319d:	a1 44 51 80 00       	mov    0x805144,%eax
  8031a2:	48                   	dec    %eax
  8031a3:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  8031a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031ab:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  8031b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031b5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  8031bc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8031c0:	75 17                	jne    8031d9 <insert_sorted_with_merge_freeList+0x183>
  8031c2:	83 ec 04             	sub    $0x4,%esp
  8031c5:	68 bc 45 80 00       	push   $0x8045bc
  8031ca:	68 3f 01 00 00       	push   $0x13f
  8031cf:	68 df 45 80 00       	push   $0x8045df
  8031d4:	e8 f6 d4 ff ff       	call   8006cf <_panic>
  8031d9:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8031df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031e2:	89 10                	mov    %edx,(%eax)
  8031e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031e7:	8b 00                	mov    (%eax),%eax
  8031e9:	85 c0                	test   %eax,%eax
  8031eb:	74 0d                	je     8031fa <insert_sorted_with_merge_freeList+0x1a4>
  8031ed:	a1 48 51 80 00       	mov    0x805148,%eax
  8031f2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031f5:	89 50 04             	mov    %edx,0x4(%eax)
  8031f8:	eb 08                	jmp    803202 <insert_sorted_with_merge_freeList+0x1ac>
  8031fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031fd:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803202:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803205:	a3 48 51 80 00       	mov    %eax,0x805148
  80320a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80320d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803214:	a1 54 51 80 00       	mov    0x805154,%eax
  803219:	40                   	inc    %eax
  80321a:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80321f:	e9 7a 05 00 00       	jmp    80379e <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  803224:	8b 45 08             	mov    0x8(%ebp),%eax
  803227:	8b 50 08             	mov    0x8(%eax),%edx
  80322a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80322d:	8b 40 08             	mov    0x8(%eax),%eax
  803230:	39 c2                	cmp    %eax,%edx
  803232:	0f 82 14 01 00 00    	jb     80334c <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  803238:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80323b:	8b 50 08             	mov    0x8(%eax),%edx
  80323e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803241:	8b 40 0c             	mov    0xc(%eax),%eax
  803244:	01 c2                	add    %eax,%edx
  803246:	8b 45 08             	mov    0x8(%ebp),%eax
  803249:	8b 40 08             	mov    0x8(%eax),%eax
  80324c:	39 c2                	cmp    %eax,%edx
  80324e:	0f 85 90 00 00 00    	jne    8032e4 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  803254:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803257:	8b 50 0c             	mov    0xc(%eax),%edx
  80325a:	8b 45 08             	mov    0x8(%ebp),%eax
  80325d:	8b 40 0c             	mov    0xc(%eax),%eax
  803260:	01 c2                	add    %eax,%edx
  803262:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803265:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  803268:	8b 45 08             	mov    0x8(%ebp),%eax
  80326b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  803272:	8b 45 08             	mov    0x8(%ebp),%eax
  803275:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80327c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803280:	75 17                	jne    803299 <insert_sorted_with_merge_freeList+0x243>
  803282:	83 ec 04             	sub    $0x4,%esp
  803285:	68 bc 45 80 00       	push   $0x8045bc
  80328a:	68 49 01 00 00       	push   $0x149
  80328f:	68 df 45 80 00       	push   $0x8045df
  803294:	e8 36 d4 ff ff       	call   8006cf <_panic>
  803299:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80329f:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a2:	89 10                	mov    %edx,(%eax)
  8032a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a7:	8b 00                	mov    (%eax),%eax
  8032a9:	85 c0                	test   %eax,%eax
  8032ab:	74 0d                	je     8032ba <insert_sorted_with_merge_freeList+0x264>
  8032ad:	a1 48 51 80 00       	mov    0x805148,%eax
  8032b2:	8b 55 08             	mov    0x8(%ebp),%edx
  8032b5:	89 50 04             	mov    %edx,0x4(%eax)
  8032b8:	eb 08                	jmp    8032c2 <insert_sorted_with_merge_freeList+0x26c>
  8032ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8032bd:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8032c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c5:	a3 48 51 80 00       	mov    %eax,0x805148
  8032ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8032cd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032d4:	a1 54 51 80 00       	mov    0x805154,%eax
  8032d9:	40                   	inc    %eax
  8032da:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8032df:	e9 bb 04 00 00       	jmp    80379f <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  8032e4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032e8:	75 17                	jne    803301 <insert_sorted_with_merge_freeList+0x2ab>
  8032ea:	83 ec 04             	sub    $0x4,%esp
  8032ed:	68 30 46 80 00       	push   $0x804630
  8032f2:	68 4c 01 00 00       	push   $0x14c
  8032f7:	68 df 45 80 00       	push   $0x8045df
  8032fc:	e8 ce d3 ff ff       	call   8006cf <_panic>
  803301:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803307:	8b 45 08             	mov    0x8(%ebp),%eax
  80330a:	89 50 04             	mov    %edx,0x4(%eax)
  80330d:	8b 45 08             	mov    0x8(%ebp),%eax
  803310:	8b 40 04             	mov    0x4(%eax),%eax
  803313:	85 c0                	test   %eax,%eax
  803315:	74 0c                	je     803323 <insert_sorted_with_merge_freeList+0x2cd>
  803317:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80331c:	8b 55 08             	mov    0x8(%ebp),%edx
  80331f:	89 10                	mov    %edx,(%eax)
  803321:	eb 08                	jmp    80332b <insert_sorted_with_merge_freeList+0x2d5>
  803323:	8b 45 08             	mov    0x8(%ebp),%eax
  803326:	a3 38 51 80 00       	mov    %eax,0x805138
  80332b:	8b 45 08             	mov    0x8(%ebp),%eax
  80332e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803333:	8b 45 08             	mov    0x8(%ebp),%eax
  803336:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80333c:	a1 44 51 80 00       	mov    0x805144,%eax
  803341:	40                   	inc    %eax
  803342:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803347:	e9 53 04 00 00       	jmp    80379f <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  80334c:	a1 38 51 80 00       	mov    0x805138,%eax
  803351:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803354:	e9 15 04 00 00       	jmp    80376e <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  803359:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80335c:	8b 00                	mov    (%eax),%eax
  80335e:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  803361:	8b 45 08             	mov    0x8(%ebp),%eax
  803364:	8b 50 08             	mov    0x8(%eax),%edx
  803367:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80336a:	8b 40 08             	mov    0x8(%eax),%eax
  80336d:	39 c2                	cmp    %eax,%edx
  80336f:	0f 86 f1 03 00 00    	jbe    803766 <insert_sorted_with_merge_freeList+0x710>
  803375:	8b 45 08             	mov    0x8(%ebp),%eax
  803378:	8b 50 08             	mov    0x8(%eax),%edx
  80337b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80337e:	8b 40 08             	mov    0x8(%eax),%eax
  803381:	39 c2                	cmp    %eax,%edx
  803383:	0f 83 dd 03 00 00    	jae    803766 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  803389:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80338c:	8b 50 08             	mov    0x8(%eax),%edx
  80338f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803392:	8b 40 0c             	mov    0xc(%eax),%eax
  803395:	01 c2                	add    %eax,%edx
  803397:	8b 45 08             	mov    0x8(%ebp),%eax
  80339a:	8b 40 08             	mov    0x8(%eax),%eax
  80339d:	39 c2                	cmp    %eax,%edx
  80339f:	0f 85 b9 01 00 00    	jne    80355e <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8033a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a8:	8b 50 08             	mov    0x8(%eax),%edx
  8033ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ae:	8b 40 0c             	mov    0xc(%eax),%eax
  8033b1:	01 c2                	add    %eax,%edx
  8033b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033b6:	8b 40 08             	mov    0x8(%eax),%eax
  8033b9:	39 c2                	cmp    %eax,%edx
  8033bb:	0f 85 0d 01 00 00    	jne    8034ce <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  8033c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033c4:	8b 50 0c             	mov    0xc(%eax),%edx
  8033c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033ca:	8b 40 0c             	mov    0xc(%eax),%eax
  8033cd:	01 c2                	add    %eax,%edx
  8033cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033d2:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8033d5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8033d9:	75 17                	jne    8033f2 <insert_sorted_with_merge_freeList+0x39c>
  8033db:	83 ec 04             	sub    $0x4,%esp
  8033de:	68 88 46 80 00       	push   $0x804688
  8033e3:	68 5c 01 00 00       	push   $0x15c
  8033e8:	68 df 45 80 00       	push   $0x8045df
  8033ed:	e8 dd d2 ff ff       	call   8006cf <_panic>
  8033f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033f5:	8b 00                	mov    (%eax),%eax
  8033f7:	85 c0                	test   %eax,%eax
  8033f9:	74 10                	je     80340b <insert_sorted_with_merge_freeList+0x3b5>
  8033fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033fe:	8b 00                	mov    (%eax),%eax
  803400:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803403:	8b 52 04             	mov    0x4(%edx),%edx
  803406:	89 50 04             	mov    %edx,0x4(%eax)
  803409:	eb 0b                	jmp    803416 <insert_sorted_with_merge_freeList+0x3c0>
  80340b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80340e:	8b 40 04             	mov    0x4(%eax),%eax
  803411:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803416:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803419:	8b 40 04             	mov    0x4(%eax),%eax
  80341c:	85 c0                	test   %eax,%eax
  80341e:	74 0f                	je     80342f <insert_sorted_with_merge_freeList+0x3d9>
  803420:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803423:	8b 40 04             	mov    0x4(%eax),%eax
  803426:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803429:	8b 12                	mov    (%edx),%edx
  80342b:	89 10                	mov    %edx,(%eax)
  80342d:	eb 0a                	jmp    803439 <insert_sorted_with_merge_freeList+0x3e3>
  80342f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803432:	8b 00                	mov    (%eax),%eax
  803434:	a3 38 51 80 00       	mov    %eax,0x805138
  803439:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80343c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803442:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803445:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80344c:	a1 44 51 80 00       	mov    0x805144,%eax
  803451:	48                   	dec    %eax
  803452:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  803457:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80345a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803461:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803464:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80346b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80346f:	75 17                	jne    803488 <insert_sorted_with_merge_freeList+0x432>
  803471:	83 ec 04             	sub    $0x4,%esp
  803474:	68 bc 45 80 00       	push   $0x8045bc
  803479:	68 5f 01 00 00       	push   $0x15f
  80347e:	68 df 45 80 00       	push   $0x8045df
  803483:	e8 47 d2 ff ff       	call   8006cf <_panic>
  803488:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80348e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803491:	89 10                	mov    %edx,(%eax)
  803493:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803496:	8b 00                	mov    (%eax),%eax
  803498:	85 c0                	test   %eax,%eax
  80349a:	74 0d                	je     8034a9 <insert_sorted_with_merge_freeList+0x453>
  80349c:	a1 48 51 80 00       	mov    0x805148,%eax
  8034a1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8034a4:	89 50 04             	mov    %edx,0x4(%eax)
  8034a7:	eb 08                	jmp    8034b1 <insert_sorted_with_merge_freeList+0x45b>
  8034a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034ac:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8034b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034b4:	a3 48 51 80 00       	mov    %eax,0x805148
  8034b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034bc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034c3:	a1 54 51 80 00       	mov    0x805154,%eax
  8034c8:	40                   	inc    %eax
  8034c9:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  8034ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034d1:	8b 50 0c             	mov    0xc(%eax),%edx
  8034d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8034d7:	8b 40 0c             	mov    0xc(%eax),%eax
  8034da:	01 c2                	add    %eax,%edx
  8034dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034df:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  8034e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  8034ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ef:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8034f6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034fa:	75 17                	jne    803513 <insert_sorted_with_merge_freeList+0x4bd>
  8034fc:	83 ec 04             	sub    $0x4,%esp
  8034ff:	68 bc 45 80 00       	push   $0x8045bc
  803504:	68 64 01 00 00       	push   $0x164
  803509:	68 df 45 80 00       	push   $0x8045df
  80350e:	e8 bc d1 ff ff       	call   8006cf <_panic>
  803513:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803519:	8b 45 08             	mov    0x8(%ebp),%eax
  80351c:	89 10                	mov    %edx,(%eax)
  80351e:	8b 45 08             	mov    0x8(%ebp),%eax
  803521:	8b 00                	mov    (%eax),%eax
  803523:	85 c0                	test   %eax,%eax
  803525:	74 0d                	je     803534 <insert_sorted_with_merge_freeList+0x4de>
  803527:	a1 48 51 80 00       	mov    0x805148,%eax
  80352c:	8b 55 08             	mov    0x8(%ebp),%edx
  80352f:	89 50 04             	mov    %edx,0x4(%eax)
  803532:	eb 08                	jmp    80353c <insert_sorted_with_merge_freeList+0x4e6>
  803534:	8b 45 08             	mov    0x8(%ebp),%eax
  803537:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80353c:	8b 45 08             	mov    0x8(%ebp),%eax
  80353f:	a3 48 51 80 00       	mov    %eax,0x805148
  803544:	8b 45 08             	mov    0x8(%ebp),%eax
  803547:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80354e:	a1 54 51 80 00       	mov    0x805154,%eax
  803553:	40                   	inc    %eax
  803554:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803559:	e9 41 02 00 00       	jmp    80379f <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  80355e:	8b 45 08             	mov    0x8(%ebp),%eax
  803561:	8b 50 08             	mov    0x8(%eax),%edx
  803564:	8b 45 08             	mov    0x8(%ebp),%eax
  803567:	8b 40 0c             	mov    0xc(%eax),%eax
  80356a:	01 c2                	add    %eax,%edx
  80356c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80356f:	8b 40 08             	mov    0x8(%eax),%eax
  803572:	39 c2                	cmp    %eax,%edx
  803574:	0f 85 7c 01 00 00    	jne    8036f6 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  80357a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80357e:	74 06                	je     803586 <insert_sorted_with_merge_freeList+0x530>
  803580:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803584:	75 17                	jne    80359d <insert_sorted_with_merge_freeList+0x547>
  803586:	83 ec 04             	sub    $0x4,%esp
  803589:	68 f8 45 80 00       	push   $0x8045f8
  80358e:	68 69 01 00 00       	push   $0x169
  803593:	68 df 45 80 00       	push   $0x8045df
  803598:	e8 32 d1 ff ff       	call   8006cf <_panic>
  80359d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035a0:	8b 50 04             	mov    0x4(%eax),%edx
  8035a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8035a6:	89 50 04             	mov    %edx,0x4(%eax)
  8035a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ac:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8035af:	89 10                	mov    %edx,(%eax)
  8035b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035b4:	8b 40 04             	mov    0x4(%eax),%eax
  8035b7:	85 c0                	test   %eax,%eax
  8035b9:	74 0d                	je     8035c8 <insert_sorted_with_merge_freeList+0x572>
  8035bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035be:	8b 40 04             	mov    0x4(%eax),%eax
  8035c1:	8b 55 08             	mov    0x8(%ebp),%edx
  8035c4:	89 10                	mov    %edx,(%eax)
  8035c6:	eb 08                	jmp    8035d0 <insert_sorted_with_merge_freeList+0x57a>
  8035c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8035cb:	a3 38 51 80 00       	mov    %eax,0x805138
  8035d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035d3:	8b 55 08             	mov    0x8(%ebp),%edx
  8035d6:	89 50 04             	mov    %edx,0x4(%eax)
  8035d9:	a1 44 51 80 00       	mov    0x805144,%eax
  8035de:	40                   	inc    %eax
  8035df:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  8035e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8035e7:	8b 50 0c             	mov    0xc(%eax),%edx
  8035ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035ed:	8b 40 0c             	mov    0xc(%eax),%eax
  8035f0:	01 c2                	add    %eax,%edx
  8035f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8035f5:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8035f8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8035fc:	75 17                	jne    803615 <insert_sorted_with_merge_freeList+0x5bf>
  8035fe:	83 ec 04             	sub    $0x4,%esp
  803601:	68 88 46 80 00       	push   $0x804688
  803606:	68 6b 01 00 00       	push   $0x16b
  80360b:	68 df 45 80 00       	push   $0x8045df
  803610:	e8 ba d0 ff ff       	call   8006cf <_panic>
  803615:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803618:	8b 00                	mov    (%eax),%eax
  80361a:	85 c0                	test   %eax,%eax
  80361c:	74 10                	je     80362e <insert_sorted_with_merge_freeList+0x5d8>
  80361e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803621:	8b 00                	mov    (%eax),%eax
  803623:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803626:	8b 52 04             	mov    0x4(%edx),%edx
  803629:	89 50 04             	mov    %edx,0x4(%eax)
  80362c:	eb 0b                	jmp    803639 <insert_sorted_with_merge_freeList+0x5e3>
  80362e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803631:	8b 40 04             	mov    0x4(%eax),%eax
  803634:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803639:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80363c:	8b 40 04             	mov    0x4(%eax),%eax
  80363f:	85 c0                	test   %eax,%eax
  803641:	74 0f                	je     803652 <insert_sorted_with_merge_freeList+0x5fc>
  803643:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803646:	8b 40 04             	mov    0x4(%eax),%eax
  803649:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80364c:	8b 12                	mov    (%edx),%edx
  80364e:	89 10                	mov    %edx,(%eax)
  803650:	eb 0a                	jmp    80365c <insert_sorted_with_merge_freeList+0x606>
  803652:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803655:	8b 00                	mov    (%eax),%eax
  803657:	a3 38 51 80 00       	mov    %eax,0x805138
  80365c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80365f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803665:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803668:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80366f:	a1 44 51 80 00       	mov    0x805144,%eax
  803674:	48                   	dec    %eax
  803675:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  80367a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80367d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803684:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803687:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80368e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803692:	75 17                	jne    8036ab <insert_sorted_with_merge_freeList+0x655>
  803694:	83 ec 04             	sub    $0x4,%esp
  803697:	68 bc 45 80 00       	push   $0x8045bc
  80369c:	68 6e 01 00 00       	push   $0x16e
  8036a1:	68 df 45 80 00       	push   $0x8045df
  8036a6:	e8 24 d0 ff ff       	call   8006cf <_panic>
  8036ab:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8036b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036b4:	89 10                	mov    %edx,(%eax)
  8036b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036b9:	8b 00                	mov    (%eax),%eax
  8036bb:	85 c0                	test   %eax,%eax
  8036bd:	74 0d                	je     8036cc <insert_sorted_with_merge_freeList+0x676>
  8036bf:	a1 48 51 80 00       	mov    0x805148,%eax
  8036c4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8036c7:	89 50 04             	mov    %edx,0x4(%eax)
  8036ca:	eb 08                	jmp    8036d4 <insert_sorted_with_merge_freeList+0x67e>
  8036cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036cf:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8036d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036d7:	a3 48 51 80 00       	mov    %eax,0x805148
  8036dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036df:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036e6:	a1 54 51 80 00       	mov    0x805154,%eax
  8036eb:	40                   	inc    %eax
  8036ec:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8036f1:	e9 a9 00 00 00       	jmp    80379f <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  8036f6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036fa:	74 06                	je     803702 <insert_sorted_with_merge_freeList+0x6ac>
  8036fc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803700:	75 17                	jne    803719 <insert_sorted_with_merge_freeList+0x6c3>
  803702:	83 ec 04             	sub    $0x4,%esp
  803705:	68 54 46 80 00       	push   $0x804654
  80370a:	68 73 01 00 00       	push   $0x173
  80370f:	68 df 45 80 00       	push   $0x8045df
  803714:	e8 b6 cf ff ff       	call   8006cf <_panic>
  803719:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80371c:	8b 10                	mov    (%eax),%edx
  80371e:	8b 45 08             	mov    0x8(%ebp),%eax
  803721:	89 10                	mov    %edx,(%eax)
  803723:	8b 45 08             	mov    0x8(%ebp),%eax
  803726:	8b 00                	mov    (%eax),%eax
  803728:	85 c0                	test   %eax,%eax
  80372a:	74 0b                	je     803737 <insert_sorted_with_merge_freeList+0x6e1>
  80372c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80372f:	8b 00                	mov    (%eax),%eax
  803731:	8b 55 08             	mov    0x8(%ebp),%edx
  803734:	89 50 04             	mov    %edx,0x4(%eax)
  803737:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80373a:	8b 55 08             	mov    0x8(%ebp),%edx
  80373d:	89 10                	mov    %edx,(%eax)
  80373f:	8b 45 08             	mov    0x8(%ebp),%eax
  803742:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803745:	89 50 04             	mov    %edx,0x4(%eax)
  803748:	8b 45 08             	mov    0x8(%ebp),%eax
  80374b:	8b 00                	mov    (%eax),%eax
  80374d:	85 c0                	test   %eax,%eax
  80374f:	75 08                	jne    803759 <insert_sorted_with_merge_freeList+0x703>
  803751:	8b 45 08             	mov    0x8(%ebp),%eax
  803754:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803759:	a1 44 51 80 00       	mov    0x805144,%eax
  80375e:	40                   	inc    %eax
  80375f:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803764:	eb 39                	jmp    80379f <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803766:	a1 40 51 80 00       	mov    0x805140,%eax
  80376b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80376e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803772:	74 07                	je     80377b <insert_sorted_with_merge_freeList+0x725>
  803774:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803777:	8b 00                	mov    (%eax),%eax
  803779:	eb 05                	jmp    803780 <insert_sorted_with_merge_freeList+0x72a>
  80377b:	b8 00 00 00 00       	mov    $0x0,%eax
  803780:	a3 40 51 80 00       	mov    %eax,0x805140
  803785:	a1 40 51 80 00       	mov    0x805140,%eax
  80378a:	85 c0                	test   %eax,%eax
  80378c:	0f 85 c7 fb ff ff    	jne    803359 <insert_sorted_with_merge_freeList+0x303>
  803792:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803796:	0f 85 bd fb ff ff    	jne    803359 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80379c:	eb 01                	jmp    80379f <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80379e:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80379f:	90                   	nop
  8037a0:	c9                   	leave  
  8037a1:	c3                   	ret    
  8037a2:	66 90                	xchg   %ax,%ax

008037a4 <__udivdi3>:
  8037a4:	55                   	push   %ebp
  8037a5:	57                   	push   %edi
  8037a6:	56                   	push   %esi
  8037a7:	53                   	push   %ebx
  8037a8:	83 ec 1c             	sub    $0x1c,%esp
  8037ab:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8037af:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8037b3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8037b7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8037bb:	89 ca                	mov    %ecx,%edx
  8037bd:	89 f8                	mov    %edi,%eax
  8037bf:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8037c3:	85 f6                	test   %esi,%esi
  8037c5:	75 2d                	jne    8037f4 <__udivdi3+0x50>
  8037c7:	39 cf                	cmp    %ecx,%edi
  8037c9:	77 65                	ja     803830 <__udivdi3+0x8c>
  8037cb:	89 fd                	mov    %edi,%ebp
  8037cd:	85 ff                	test   %edi,%edi
  8037cf:	75 0b                	jne    8037dc <__udivdi3+0x38>
  8037d1:	b8 01 00 00 00       	mov    $0x1,%eax
  8037d6:	31 d2                	xor    %edx,%edx
  8037d8:	f7 f7                	div    %edi
  8037da:	89 c5                	mov    %eax,%ebp
  8037dc:	31 d2                	xor    %edx,%edx
  8037de:	89 c8                	mov    %ecx,%eax
  8037e0:	f7 f5                	div    %ebp
  8037e2:	89 c1                	mov    %eax,%ecx
  8037e4:	89 d8                	mov    %ebx,%eax
  8037e6:	f7 f5                	div    %ebp
  8037e8:	89 cf                	mov    %ecx,%edi
  8037ea:	89 fa                	mov    %edi,%edx
  8037ec:	83 c4 1c             	add    $0x1c,%esp
  8037ef:	5b                   	pop    %ebx
  8037f0:	5e                   	pop    %esi
  8037f1:	5f                   	pop    %edi
  8037f2:	5d                   	pop    %ebp
  8037f3:	c3                   	ret    
  8037f4:	39 ce                	cmp    %ecx,%esi
  8037f6:	77 28                	ja     803820 <__udivdi3+0x7c>
  8037f8:	0f bd fe             	bsr    %esi,%edi
  8037fb:	83 f7 1f             	xor    $0x1f,%edi
  8037fe:	75 40                	jne    803840 <__udivdi3+0x9c>
  803800:	39 ce                	cmp    %ecx,%esi
  803802:	72 0a                	jb     80380e <__udivdi3+0x6a>
  803804:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803808:	0f 87 9e 00 00 00    	ja     8038ac <__udivdi3+0x108>
  80380e:	b8 01 00 00 00       	mov    $0x1,%eax
  803813:	89 fa                	mov    %edi,%edx
  803815:	83 c4 1c             	add    $0x1c,%esp
  803818:	5b                   	pop    %ebx
  803819:	5e                   	pop    %esi
  80381a:	5f                   	pop    %edi
  80381b:	5d                   	pop    %ebp
  80381c:	c3                   	ret    
  80381d:	8d 76 00             	lea    0x0(%esi),%esi
  803820:	31 ff                	xor    %edi,%edi
  803822:	31 c0                	xor    %eax,%eax
  803824:	89 fa                	mov    %edi,%edx
  803826:	83 c4 1c             	add    $0x1c,%esp
  803829:	5b                   	pop    %ebx
  80382a:	5e                   	pop    %esi
  80382b:	5f                   	pop    %edi
  80382c:	5d                   	pop    %ebp
  80382d:	c3                   	ret    
  80382e:	66 90                	xchg   %ax,%ax
  803830:	89 d8                	mov    %ebx,%eax
  803832:	f7 f7                	div    %edi
  803834:	31 ff                	xor    %edi,%edi
  803836:	89 fa                	mov    %edi,%edx
  803838:	83 c4 1c             	add    $0x1c,%esp
  80383b:	5b                   	pop    %ebx
  80383c:	5e                   	pop    %esi
  80383d:	5f                   	pop    %edi
  80383e:	5d                   	pop    %ebp
  80383f:	c3                   	ret    
  803840:	bd 20 00 00 00       	mov    $0x20,%ebp
  803845:	89 eb                	mov    %ebp,%ebx
  803847:	29 fb                	sub    %edi,%ebx
  803849:	89 f9                	mov    %edi,%ecx
  80384b:	d3 e6                	shl    %cl,%esi
  80384d:	89 c5                	mov    %eax,%ebp
  80384f:	88 d9                	mov    %bl,%cl
  803851:	d3 ed                	shr    %cl,%ebp
  803853:	89 e9                	mov    %ebp,%ecx
  803855:	09 f1                	or     %esi,%ecx
  803857:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80385b:	89 f9                	mov    %edi,%ecx
  80385d:	d3 e0                	shl    %cl,%eax
  80385f:	89 c5                	mov    %eax,%ebp
  803861:	89 d6                	mov    %edx,%esi
  803863:	88 d9                	mov    %bl,%cl
  803865:	d3 ee                	shr    %cl,%esi
  803867:	89 f9                	mov    %edi,%ecx
  803869:	d3 e2                	shl    %cl,%edx
  80386b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80386f:	88 d9                	mov    %bl,%cl
  803871:	d3 e8                	shr    %cl,%eax
  803873:	09 c2                	or     %eax,%edx
  803875:	89 d0                	mov    %edx,%eax
  803877:	89 f2                	mov    %esi,%edx
  803879:	f7 74 24 0c          	divl   0xc(%esp)
  80387d:	89 d6                	mov    %edx,%esi
  80387f:	89 c3                	mov    %eax,%ebx
  803881:	f7 e5                	mul    %ebp
  803883:	39 d6                	cmp    %edx,%esi
  803885:	72 19                	jb     8038a0 <__udivdi3+0xfc>
  803887:	74 0b                	je     803894 <__udivdi3+0xf0>
  803889:	89 d8                	mov    %ebx,%eax
  80388b:	31 ff                	xor    %edi,%edi
  80388d:	e9 58 ff ff ff       	jmp    8037ea <__udivdi3+0x46>
  803892:	66 90                	xchg   %ax,%ax
  803894:	8b 54 24 08          	mov    0x8(%esp),%edx
  803898:	89 f9                	mov    %edi,%ecx
  80389a:	d3 e2                	shl    %cl,%edx
  80389c:	39 c2                	cmp    %eax,%edx
  80389e:	73 e9                	jae    803889 <__udivdi3+0xe5>
  8038a0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8038a3:	31 ff                	xor    %edi,%edi
  8038a5:	e9 40 ff ff ff       	jmp    8037ea <__udivdi3+0x46>
  8038aa:	66 90                	xchg   %ax,%ax
  8038ac:	31 c0                	xor    %eax,%eax
  8038ae:	e9 37 ff ff ff       	jmp    8037ea <__udivdi3+0x46>
  8038b3:	90                   	nop

008038b4 <__umoddi3>:
  8038b4:	55                   	push   %ebp
  8038b5:	57                   	push   %edi
  8038b6:	56                   	push   %esi
  8038b7:	53                   	push   %ebx
  8038b8:	83 ec 1c             	sub    $0x1c,%esp
  8038bb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8038bf:	8b 74 24 34          	mov    0x34(%esp),%esi
  8038c3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8038c7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8038cb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8038cf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8038d3:	89 f3                	mov    %esi,%ebx
  8038d5:	89 fa                	mov    %edi,%edx
  8038d7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8038db:	89 34 24             	mov    %esi,(%esp)
  8038de:	85 c0                	test   %eax,%eax
  8038e0:	75 1a                	jne    8038fc <__umoddi3+0x48>
  8038e2:	39 f7                	cmp    %esi,%edi
  8038e4:	0f 86 a2 00 00 00    	jbe    80398c <__umoddi3+0xd8>
  8038ea:	89 c8                	mov    %ecx,%eax
  8038ec:	89 f2                	mov    %esi,%edx
  8038ee:	f7 f7                	div    %edi
  8038f0:	89 d0                	mov    %edx,%eax
  8038f2:	31 d2                	xor    %edx,%edx
  8038f4:	83 c4 1c             	add    $0x1c,%esp
  8038f7:	5b                   	pop    %ebx
  8038f8:	5e                   	pop    %esi
  8038f9:	5f                   	pop    %edi
  8038fa:	5d                   	pop    %ebp
  8038fb:	c3                   	ret    
  8038fc:	39 f0                	cmp    %esi,%eax
  8038fe:	0f 87 ac 00 00 00    	ja     8039b0 <__umoddi3+0xfc>
  803904:	0f bd e8             	bsr    %eax,%ebp
  803907:	83 f5 1f             	xor    $0x1f,%ebp
  80390a:	0f 84 ac 00 00 00    	je     8039bc <__umoddi3+0x108>
  803910:	bf 20 00 00 00       	mov    $0x20,%edi
  803915:	29 ef                	sub    %ebp,%edi
  803917:	89 fe                	mov    %edi,%esi
  803919:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80391d:	89 e9                	mov    %ebp,%ecx
  80391f:	d3 e0                	shl    %cl,%eax
  803921:	89 d7                	mov    %edx,%edi
  803923:	89 f1                	mov    %esi,%ecx
  803925:	d3 ef                	shr    %cl,%edi
  803927:	09 c7                	or     %eax,%edi
  803929:	89 e9                	mov    %ebp,%ecx
  80392b:	d3 e2                	shl    %cl,%edx
  80392d:	89 14 24             	mov    %edx,(%esp)
  803930:	89 d8                	mov    %ebx,%eax
  803932:	d3 e0                	shl    %cl,%eax
  803934:	89 c2                	mov    %eax,%edx
  803936:	8b 44 24 08          	mov    0x8(%esp),%eax
  80393a:	d3 e0                	shl    %cl,%eax
  80393c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803940:	8b 44 24 08          	mov    0x8(%esp),%eax
  803944:	89 f1                	mov    %esi,%ecx
  803946:	d3 e8                	shr    %cl,%eax
  803948:	09 d0                	or     %edx,%eax
  80394a:	d3 eb                	shr    %cl,%ebx
  80394c:	89 da                	mov    %ebx,%edx
  80394e:	f7 f7                	div    %edi
  803950:	89 d3                	mov    %edx,%ebx
  803952:	f7 24 24             	mull   (%esp)
  803955:	89 c6                	mov    %eax,%esi
  803957:	89 d1                	mov    %edx,%ecx
  803959:	39 d3                	cmp    %edx,%ebx
  80395b:	0f 82 87 00 00 00    	jb     8039e8 <__umoddi3+0x134>
  803961:	0f 84 91 00 00 00    	je     8039f8 <__umoddi3+0x144>
  803967:	8b 54 24 04          	mov    0x4(%esp),%edx
  80396b:	29 f2                	sub    %esi,%edx
  80396d:	19 cb                	sbb    %ecx,%ebx
  80396f:	89 d8                	mov    %ebx,%eax
  803971:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803975:	d3 e0                	shl    %cl,%eax
  803977:	89 e9                	mov    %ebp,%ecx
  803979:	d3 ea                	shr    %cl,%edx
  80397b:	09 d0                	or     %edx,%eax
  80397d:	89 e9                	mov    %ebp,%ecx
  80397f:	d3 eb                	shr    %cl,%ebx
  803981:	89 da                	mov    %ebx,%edx
  803983:	83 c4 1c             	add    $0x1c,%esp
  803986:	5b                   	pop    %ebx
  803987:	5e                   	pop    %esi
  803988:	5f                   	pop    %edi
  803989:	5d                   	pop    %ebp
  80398a:	c3                   	ret    
  80398b:	90                   	nop
  80398c:	89 fd                	mov    %edi,%ebp
  80398e:	85 ff                	test   %edi,%edi
  803990:	75 0b                	jne    80399d <__umoddi3+0xe9>
  803992:	b8 01 00 00 00       	mov    $0x1,%eax
  803997:	31 d2                	xor    %edx,%edx
  803999:	f7 f7                	div    %edi
  80399b:	89 c5                	mov    %eax,%ebp
  80399d:	89 f0                	mov    %esi,%eax
  80399f:	31 d2                	xor    %edx,%edx
  8039a1:	f7 f5                	div    %ebp
  8039a3:	89 c8                	mov    %ecx,%eax
  8039a5:	f7 f5                	div    %ebp
  8039a7:	89 d0                	mov    %edx,%eax
  8039a9:	e9 44 ff ff ff       	jmp    8038f2 <__umoddi3+0x3e>
  8039ae:	66 90                	xchg   %ax,%ax
  8039b0:	89 c8                	mov    %ecx,%eax
  8039b2:	89 f2                	mov    %esi,%edx
  8039b4:	83 c4 1c             	add    $0x1c,%esp
  8039b7:	5b                   	pop    %ebx
  8039b8:	5e                   	pop    %esi
  8039b9:	5f                   	pop    %edi
  8039ba:	5d                   	pop    %ebp
  8039bb:	c3                   	ret    
  8039bc:	3b 04 24             	cmp    (%esp),%eax
  8039bf:	72 06                	jb     8039c7 <__umoddi3+0x113>
  8039c1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8039c5:	77 0f                	ja     8039d6 <__umoddi3+0x122>
  8039c7:	89 f2                	mov    %esi,%edx
  8039c9:	29 f9                	sub    %edi,%ecx
  8039cb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8039cf:	89 14 24             	mov    %edx,(%esp)
  8039d2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8039d6:	8b 44 24 04          	mov    0x4(%esp),%eax
  8039da:	8b 14 24             	mov    (%esp),%edx
  8039dd:	83 c4 1c             	add    $0x1c,%esp
  8039e0:	5b                   	pop    %ebx
  8039e1:	5e                   	pop    %esi
  8039e2:	5f                   	pop    %edi
  8039e3:	5d                   	pop    %ebp
  8039e4:	c3                   	ret    
  8039e5:	8d 76 00             	lea    0x0(%esi),%esi
  8039e8:	2b 04 24             	sub    (%esp),%eax
  8039eb:	19 fa                	sbb    %edi,%edx
  8039ed:	89 d1                	mov    %edx,%ecx
  8039ef:	89 c6                	mov    %eax,%esi
  8039f1:	e9 71 ff ff ff       	jmp    803967 <__umoddi3+0xb3>
  8039f6:	66 90                	xchg   %ax,%ax
  8039f8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8039fc:	72 ea                	jb     8039e8 <__umoddi3+0x134>
  8039fe:	89 d9                	mov    %ebx,%ecx
  803a00:	e9 62 ff ff ff       	jmp    803967 <__umoddi3+0xb3>
