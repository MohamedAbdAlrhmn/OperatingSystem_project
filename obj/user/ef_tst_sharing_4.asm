
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
  80008d:	68 a0 3a 80 00       	push   $0x803aa0
  800092:	6a 12                	push   $0x12
  800094:	68 bc 3a 80 00       	push   $0x803abc
  800099:	e8 31 06 00 00       	call   8006cf <_panic>
	}

	cprintf("************************************************\n");
  80009e:	83 ec 0c             	sub    $0xc,%esp
  8000a1:	68 d4 3a 80 00       	push   $0x803ad4
  8000a6:	e8 d8 08 00 00       	call   800983 <cprintf>
  8000ab:	83 c4 10             	add    $0x10,%esp
	cprintf("MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  8000ae:	83 ec 0c             	sub    $0xc,%esp
  8000b1:	68 08 3b 80 00       	push   $0x803b08
  8000b6:	e8 c8 08 00 00       	call   800983 <cprintf>
  8000bb:	83 c4 10             	add    $0x10,%esp
	cprintf("************************************************\n\n\n");
  8000be:	83 ec 0c             	sub    $0xc,%esp
  8000c1:	68 64 3b 80 00       	push   $0x803b64
  8000c6:	e8 b8 08 00 00       	call   800983 <cprintf>
  8000cb:	83 c4 10             	add    $0x10,%esp

	int Mega = 1024*1024;
  8000ce:	c7 45 ec 00 00 10 00 	movl   $0x100000,-0x14(%ebp)
	int kilo = 1024;
  8000d5:	c7 45 e8 00 04 00 00 	movl   $0x400,-0x18(%ebp)
	int envID = sys_getenvid();
  8000dc:	e8 58 1e 00 00       	call   801f39 <sys_getenvid>
  8000e1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	cprintf("STEP A: checking free of a shared object ... \n");
  8000e4:	83 ec 0c             	sub    $0xc,%esp
  8000e7:	68 98 3b 80 00       	push   $0x803b98
  8000ec:	e8 92 08 00 00       	call   800983 <cprintf>
  8000f1:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x;
		int freeFrames = sys_calculate_free_frames() ;
  8000f4:	e8 79 1b 00 00       	call   801c72 <sys_calculate_free_frames>
  8000f9:	89 45 e0             	mov    %eax,-0x20(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8000fc:	83 ec 04             	sub    $0x4,%esp
  8000ff:	6a 01                	push   $0x1
  800101:	68 00 10 00 00       	push   $0x1000
  800106:	68 c7 3b 80 00       	push   $0x803bc7
  80010b:	e8 90 18 00 00       	call   8019a0 <smalloc>
  800110:	83 c4 10             	add    $0x10,%esp
  800113:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (x != (uint32*)USER_HEAP_START) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  800116:	81 7d dc 00 00 00 80 	cmpl   $0x80000000,-0x24(%ebp)
  80011d:	74 14                	je     800133 <_main+0xfb>
  80011f:	83 ec 04             	sub    $0x4,%esp
  800122:	68 cc 3b 80 00       	push   $0x803bcc
  800127:	6a 21                	push   $0x21
  800129:	68 bc 3a 80 00       	push   $0x803abc
  80012e:	e8 9c 05 00 00       	call   8006cf <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800133:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800136:	e8 37 1b 00 00       	call   801c72 <sys_calculate_free_frames>
  80013b:	29 c3                	sub    %eax,%ebx
  80013d:	89 d8                	mov    %ebx,%eax
  80013f:	83 f8 04             	cmp    $0x4,%eax
  800142:	74 14                	je     800158 <_main+0x120>
  800144:	83 ec 04             	sub    $0x4,%esp
  800147:	68 38 3c 80 00       	push   $0x803c38
  80014c:	6a 22                	push   $0x22
  80014e:	68 bc 3a 80 00       	push   $0x803abc
  800153:	e8 77 05 00 00       	call   8006cf <_panic>

		sfree(x);
  800158:	83 ec 0c             	sub    $0xc,%esp
  80015b:	ff 75 dc             	pushl  -0x24(%ebp)
  80015e:	e8 af 19 00 00       	call   801b12 <sfree>
  800163:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) ==  0+0+2) panic("Wrong free: make sure that you free the shared object by calling free_share_object()");
  800166:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800169:	e8 04 1b 00 00       	call   801c72 <sys_calculate_free_frames>
  80016e:	29 c3                	sub    %eax,%ebx
  800170:	89 d8                	mov    %ebx,%eax
  800172:	83 f8 02             	cmp    $0x2,%eax
  800175:	75 14                	jne    80018b <_main+0x153>
  800177:	83 ec 04             	sub    $0x4,%esp
  80017a:	68 b8 3c 80 00       	push   $0x803cb8
  80017f:	6a 25                	push   $0x25
  800181:	68 bc 3a 80 00       	push   $0x803abc
  800186:	e8 44 05 00 00       	call   8006cf <_panic>
		else if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong free: revise your freeSharedObject logic");
  80018b:	e8 e2 1a 00 00       	call   801c72 <sys_calculate_free_frames>
  800190:	89 c2                	mov    %eax,%edx
  800192:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800195:	39 c2                	cmp    %eax,%edx
  800197:	74 14                	je     8001ad <_main+0x175>
  800199:	83 ec 04             	sub    $0x4,%esp
  80019c:	68 10 3d 80 00       	push   $0x803d10
  8001a1:	6a 26                	push   $0x26
  8001a3:	68 bc 3a 80 00       	push   $0x803abc
  8001a8:	e8 22 05 00 00       	call   8006cf <_panic>
	}
	cprintf("Step A completed successfully!!\n\n\n");
  8001ad:	83 ec 0c             	sub    $0xc,%esp
  8001b0:	68 40 3d 80 00       	push   $0x803d40
  8001b5:	e8 c9 07 00 00       	call   800983 <cprintf>
  8001ba:	83 c4 10             	add    $0x10,%esp


	cprintf("STEP B: checking free of 2 shared objects ... \n");
  8001bd:	83 ec 0c             	sub    $0xc,%esp
  8001c0:	68 64 3d 80 00       	push   $0x803d64
  8001c5:	e8 b9 07 00 00       	call   800983 <cprintf>
  8001ca:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x, *z ;
		int freeFrames = sys_calculate_free_frames() ;
  8001cd:	e8 a0 1a 00 00       	call   801c72 <sys_calculate_free_frames>
  8001d2:	89 45 d8             	mov    %eax,-0x28(%ebp)
		z = smalloc("z", PAGE_SIZE, 1);
  8001d5:	83 ec 04             	sub    $0x4,%esp
  8001d8:	6a 01                	push   $0x1
  8001da:	68 00 10 00 00       	push   $0x1000
  8001df:	68 94 3d 80 00       	push   $0x803d94
  8001e4:	e8 b7 17 00 00       	call   8019a0 <smalloc>
  8001e9:	83 c4 10             	add    $0x10,%esp
  8001ec:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8001ef:	83 ec 04             	sub    $0x4,%esp
  8001f2:	6a 01                	push   $0x1
  8001f4:	68 00 10 00 00       	push   $0x1000
  8001f9:	68 c7 3b 80 00       	push   $0x803bc7
  8001fe:	e8 9d 17 00 00       	call   8019a0 <smalloc>
  800203:	83 c4 10             	add    $0x10,%esp
  800206:	89 45 d0             	mov    %eax,-0x30(%ebp)

		if(x == NULL) panic("Wrong free: make sure that you free the shared object by calling free_share_object()");
  800209:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80020d:	75 14                	jne    800223 <_main+0x1eb>
  80020f:	83 ec 04             	sub    $0x4,%esp
  800212:	68 b8 3c 80 00       	push   $0x803cb8
  800217:	6a 32                	push   $0x32
  800219:	68 bc 3a 80 00       	push   $0x803abc
  80021e:	e8 ac 04 00 00       	call   8006cf <_panic>

		if ((freeFrames - sys_calculate_free_frames()) !=  2+1+4) panic("Wrong previous free: make sure that you correctly free shared object before (Step A)");
  800223:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800226:	e8 47 1a 00 00       	call   801c72 <sys_calculate_free_frames>
  80022b:	29 c3                	sub    %eax,%ebx
  80022d:	89 d8                	mov    %ebx,%eax
  80022f:	83 f8 07             	cmp    $0x7,%eax
  800232:	74 14                	je     800248 <_main+0x210>
  800234:	83 ec 04             	sub    $0x4,%esp
  800237:	68 98 3d 80 00       	push   $0x803d98
  80023c:	6a 34                	push   $0x34
  80023e:	68 bc 3a 80 00       	push   $0x803abc
  800243:	e8 87 04 00 00       	call   8006cf <_panic>

		sfree(z);
  800248:	83 ec 0c             	sub    $0xc,%esp
  80024b:	ff 75 d4             	pushl  -0x2c(%ebp)
  80024e:	e8 bf 18 00 00       	call   801b12 <sfree>
  800253:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong free: check your logic");
  800256:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800259:	e8 14 1a 00 00       	call   801c72 <sys_calculate_free_frames>
  80025e:	29 c3                	sub    %eax,%ebx
  800260:	89 d8                	mov    %ebx,%eax
  800262:	83 f8 04             	cmp    $0x4,%eax
  800265:	74 14                	je     80027b <_main+0x243>
  800267:	83 ec 04             	sub    $0x4,%esp
  80026a:	68 ed 3d 80 00       	push   $0x803ded
  80026f:	6a 37                	push   $0x37
  800271:	68 bc 3a 80 00       	push   $0x803abc
  800276:	e8 54 04 00 00       	call   8006cf <_panic>

		sfree(x);
  80027b:	83 ec 0c             	sub    $0xc,%esp
  80027e:	ff 75 d0             	pushl  -0x30(%ebp)
  800281:	e8 8c 18 00 00       	call   801b12 <sfree>
  800286:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong free: check your logic");
  800289:	e8 e4 19 00 00       	call   801c72 <sys_calculate_free_frames>
  80028e:	89 c2                	mov    %eax,%edx
  800290:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800293:	39 c2                	cmp    %eax,%edx
  800295:	74 14                	je     8002ab <_main+0x273>
  800297:	83 ec 04             	sub    $0x4,%esp
  80029a:	68 ed 3d 80 00       	push   $0x803ded
  80029f:	6a 3a                	push   $0x3a
  8002a1:	68 bc 3a 80 00       	push   $0x803abc
  8002a6:	e8 24 04 00 00       	call   8006cf <_panic>

	}
	cprintf("Step B completed successfully!!\n\n\n");
  8002ab:	83 ec 0c             	sub    $0xc,%esp
  8002ae:	68 0c 3e 80 00       	push   $0x803e0c
  8002b3:	e8 cb 06 00 00       	call   800983 <cprintf>
  8002b8:	83 c4 10             	add    $0x10,%esp

	cprintf("STEP C: checking range of loop during free... \n");
  8002bb:	83 ec 0c             	sub    $0xc,%esp
  8002be:	68 30 3e 80 00       	push   $0x803e30
  8002c3:	e8 bb 06 00 00       	call   800983 <cprintf>
  8002c8:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *w, *u;
		int freeFrames = sys_calculate_free_frames() ;
  8002cb:	e8 a2 19 00 00       	call   801c72 <sys_calculate_free_frames>
  8002d0:	89 45 cc             	mov    %eax,-0x34(%ebp)
		w = smalloc("w", 3 * PAGE_SIZE+1, 1);
  8002d3:	83 ec 04             	sub    $0x4,%esp
  8002d6:	6a 01                	push   $0x1
  8002d8:	68 01 30 00 00       	push   $0x3001
  8002dd:	68 60 3e 80 00       	push   $0x803e60
  8002e2:	e8 b9 16 00 00       	call   8019a0 <smalloc>
  8002e7:	83 c4 10             	add    $0x10,%esp
  8002ea:	89 45 c8             	mov    %eax,-0x38(%ebp)
		u = smalloc("u", PAGE_SIZE, 1);
  8002ed:	83 ec 04             	sub    $0x4,%esp
  8002f0:	6a 01                	push   $0x1
  8002f2:	68 00 10 00 00       	push   $0x1000
  8002f7:	68 62 3e 80 00       	push   $0x803e62
  8002fc:	e8 9f 16 00 00       	call   8019a0 <smalloc>
  800301:	83 c4 10             	add    $0x10,%esp
  800304:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		if ((freeFrames - sys_calculate_free_frames()) != 5+1+4) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800307:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  80030a:	e8 63 19 00 00       	call   801c72 <sys_calculate_free_frames>
  80030f:	29 c3                	sub    %eax,%ebx
  800311:	89 d8                	mov    %ebx,%eax
  800313:	83 f8 0a             	cmp    $0xa,%eax
  800316:	74 14                	je     80032c <_main+0x2f4>
  800318:	83 ec 04             	sub    $0x4,%esp
  80031b:	68 38 3c 80 00       	push   $0x803c38
  800320:	6a 46                	push   $0x46
  800322:	68 bc 3a 80 00       	push   $0x803abc
  800327:	e8 a3 03 00 00       	call   8006cf <_panic>

		sfree(w);
  80032c:	83 ec 0c             	sub    $0xc,%esp
  80032f:	ff 75 c8             	pushl  -0x38(%ebp)
  800332:	e8 db 17 00 00       	call   801b12 <sfree>
  800337:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong free: check your logic");
  80033a:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  80033d:	e8 30 19 00 00       	call   801c72 <sys_calculate_free_frames>
  800342:	29 c3                	sub    %eax,%ebx
  800344:	89 d8                	mov    %ebx,%eax
  800346:	83 f8 04             	cmp    $0x4,%eax
  800349:	74 14                	je     80035f <_main+0x327>
  80034b:	83 ec 04             	sub    $0x4,%esp
  80034e:	68 ed 3d 80 00       	push   $0x803ded
  800353:	6a 49                	push   $0x49
  800355:	68 bc 3a 80 00       	push   $0x803abc
  80035a:	e8 70 03 00 00       	call   8006cf <_panic>

		uint32 *o;
		o = smalloc("o", 2 * PAGE_SIZE-1,1);
  80035f:	83 ec 04             	sub    $0x4,%esp
  800362:	6a 01                	push   $0x1
  800364:	68 ff 1f 00 00       	push   $0x1fff
  800369:	68 64 3e 80 00       	push   $0x803e64
  80036e:	e8 2d 16 00 00       	call   8019a0 <smalloc>
  800373:	83 c4 10             	add    $0x10,%esp
  800376:	89 45 c0             	mov    %eax,-0x40(%ebp)

		if ((freeFrames - sys_calculate_free_frames()) != 3+1+4) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800379:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  80037c:	e8 f1 18 00 00       	call   801c72 <sys_calculate_free_frames>
  800381:	29 c3                	sub    %eax,%ebx
  800383:	89 d8                	mov    %ebx,%eax
  800385:	83 f8 08             	cmp    $0x8,%eax
  800388:	74 14                	je     80039e <_main+0x366>
  80038a:	83 ec 04             	sub    $0x4,%esp
  80038d:	68 38 3c 80 00       	push   $0x803c38
  800392:	6a 4e                	push   $0x4e
  800394:	68 bc 3a 80 00       	push   $0x803abc
  800399:	e8 31 03 00 00       	call   8006cf <_panic>

		sfree(o);
  80039e:	83 ec 0c             	sub    $0xc,%esp
  8003a1:	ff 75 c0             	pushl  -0x40(%ebp)
  8003a4:	e8 69 17 00 00       	call   801b12 <sfree>
  8003a9:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong free: check your logic");
  8003ac:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8003af:	e8 be 18 00 00       	call   801c72 <sys_calculate_free_frames>
  8003b4:	29 c3                	sub    %eax,%ebx
  8003b6:	89 d8                	mov    %ebx,%eax
  8003b8:	83 f8 04             	cmp    $0x4,%eax
  8003bb:	74 14                	je     8003d1 <_main+0x399>
  8003bd:	83 ec 04             	sub    $0x4,%esp
  8003c0:	68 ed 3d 80 00       	push   $0x803ded
  8003c5:	6a 51                	push   $0x51
  8003c7:	68 bc 3a 80 00       	push   $0x803abc
  8003cc:	e8 fe 02 00 00       	call   8006cf <_panic>

		sfree(u);
  8003d1:	83 ec 0c             	sub    $0xc,%esp
  8003d4:	ff 75 c4             	pushl  -0x3c(%ebp)
  8003d7:	e8 36 17 00 00       	call   801b12 <sfree>
  8003dc:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong free: check your logic");
  8003df:	e8 8e 18 00 00       	call   801c72 <sys_calculate_free_frames>
  8003e4:	89 c2                	mov    %eax,%edx
  8003e6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8003e9:	39 c2                	cmp    %eax,%edx
  8003eb:	74 14                	je     800401 <_main+0x3c9>
  8003ed:	83 ec 04             	sub    $0x4,%esp
  8003f0:	68 ed 3d 80 00       	push   $0x803ded
  8003f5:	6a 54                	push   $0x54
  8003f7:	68 bc 3a 80 00       	push   $0x803abc
  8003fc:	e8 ce 02 00 00       	call   8006cf <_panic>


		//Checking boundaries of page tables
		freeFrames = sys_calculate_free_frames() ;
  800401:	e8 6c 18 00 00       	call   801c72 <sys_calculate_free_frames>
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
  80041b:	68 60 3e 80 00       	push   $0x803e60
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
  800441:	68 62 3e 80 00       	push   $0x803e62
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
  800463:	68 64 3e 80 00       	push   $0x803e64
  800468:	e8 33 15 00 00       	call   8019a0 <smalloc>
  80046d:	83 c4 10             	add    $0x10,%esp
  800470:	89 45 c0             	mov    %eax,-0x40(%ebp)

		if ((freeFrames - sys_calculate_free_frames()) != 3073+4+7) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800473:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800476:	e8 f7 17 00 00       	call   801c72 <sys_calculate_free_frames>
  80047b:	29 c3                	sub    %eax,%ebx
  80047d:	89 d8                	mov    %ebx,%eax
  80047f:	3d 0c 0c 00 00       	cmp    $0xc0c,%eax
  800484:	74 14                	je     80049a <_main+0x462>
  800486:	83 ec 04             	sub    $0x4,%esp
  800489:	68 38 3c 80 00       	push   $0x803c38
  80048e:	6a 5d                	push   $0x5d
  800490:	68 bc 3a 80 00       	push   $0x803abc
  800495:	e8 35 02 00 00       	call   8006cf <_panic>

		sfree(o);
  80049a:	83 ec 0c             	sub    $0xc,%esp
  80049d:	ff 75 c0             	pushl  -0x40(%ebp)
  8004a0:	e8 6d 16 00 00       	call   801b12 <sfree>
  8004a5:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  2560+3+5) panic("Wrong free: check your logic");
  8004a8:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8004ab:	e8 c2 17 00 00       	call   801c72 <sys_calculate_free_frames>
  8004b0:	29 c3                	sub    %eax,%ebx
  8004b2:	89 d8                	mov    %ebx,%eax
  8004b4:	3d 08 0a 00 00       	cmp    $0xa08,%eax
  8004b9:	74 14                	je     8004cf <_main+0x497>
  8004bb:	83 ec 04             	sub    $0x4,%esp
  8004be:	68 ed 3d 80 00       	push   $0x803ded
  8004c3:	6a 60                	push   $0x60
  8004c5:	68 bc 3a 80 00       	push   $0x803abc
  8004ca:	e8 00 02 00 00       	call   8006cf <_panic>

		sfree(w);
  8004cf:	83 ec 0c             	sub    $0xc,%esp
  8004d2:	ff 75 c8             	pushl  -0x38(%ebp)
  8004d5:	e8 38 16 00 00       	call   801b12 <sfree>
  8004da:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  1792+3+3) panic("Wrong free: check your logic");
  8004dd:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8004e0:	e8 8d 17 00 00       	call   801c72 <sys_calculate_free_frames>
  8004e5:	29 c3                	sub    %eax,%ebx
  8004e7:	89 d8                	mov    %ebx,%eax
  8004e9:	3d 06 07 00 00       	cmp    $0x706,%eax
  8004ee:	74 14                	je     800504 <_main+0x4cc>
  8004f0:	83 ec 04             	sub    $0x4,%esp
  8004f3:	68 ed 3d 80 00       	push   $0x803ded
  8004f8:	6a 63                	push   $0x63
  8004fa:	68 bc 3a 80 00       	push   $0x803abc
  8004ff:	e8 cb 01 00 00       	call   8006cf <_panic>

		sfree(u);
  800504:	83 ec 0c             	sub    $0xc,%esp
  800507:	ff 75 c4             	pushl  -0x3c(%ebp)
  80050a:	e8 03 16 00 00       	call   801b12 <sfree>
  80050f:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong free: check your logic");
  800512:	e8 5b 17 00 00       	call   801c72 <sys_calculate_free_frames>
  800517:	89 c2                	mov    %eax,%edx
  800519:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80051c:	39 c2                	cmp    %eax,%edx
  80051e:	74 14                	je     800534 <_main+0x4fc>
  800520:	83 ec 04             	sub    $0x4,%esp
  800523:	68 ed 3d 80 00       	push   $0x803ded
  800528:	6a 66                	push   $0x66
  80052a:	68 bc 3a 80 00       	push   $0x803abc
  80052f:	e8 9b 01 00 00       	call   8006cf <_panic>
	}
	cprintf("Step C completed successfully!!\n\n\n");
  800534:	83 ec 0c             	sub    $0xc,%esp
  800537:	68 68 3e 80 00       	push   $0x803e68
  80053c:	e8 42 04 00 00       	call   800983 <cprintf>
  800541:	83 c4 10             	add    $0x10,%esp

	cprintf("Congratulations!! Test of freeSharedObjects [4] completed successfully!!\n\n\n");
  800544:	83 ec 0c             	sub    $0xc,%esp
  800547:	68 8c 3e 80 00       	push   $0x803e8c
  80054c:	e8 32 04 00 00       	call   800983 <cprintf>
  800551:	83 c4 10             	add    $0x10,%esp

	int32 parentenvID = sys_getparentenvid();
  800554:	e8 12 1a 00 00       	call   801f6b <sys_getparentenvid>
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
  80056c:	68 d8 3e 80 00       	push   $0x803ed8
  800571:	ff 75 bc             	pushl  -0x44(%ebp)
  800574:	e8 d5 14 00 00       	call   801a4e <sget>
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
  800599:	e8 b4 19 00 00       	call   801f52 <sys_getenvindex>
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
  800604:	e8 56 17 00 00       	call   801d5f <sys_disable_interrupt>
	cprintf("**************************************\n");
  800609:	83 ec 0c             	sub    $0xc,%esp
  80060c:	68 00 3f 80 00       	push   $0x803f00
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
  800634:	68 28 3f 80 00       	push   $0x803f28
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
  800665:	68 50 3f 80 00       	push   $0x803f50
  80066a:	e8 14 03 00 00       	call   800983 <cprintf>
  80066f:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800672:	a1 20 50 80 00       	mov    0x805020,%eax
  800677:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80067d:	83 ec 08             	sub    $0x8,%esp
  800680:	50                   	push   %eax
  800681:	68 a8 3f 80 00       	push   $0x803fa8
  800686:	e8 f8 02 00 00       	call   800983 <cprintf>
  80068b:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80068e:	83 ec 0c             	sub    $0xc,%esp
  800691:	68 00 3f 80 00       	push   $0x803f00
  800696:	e8 e8 02 00 00       	call   800983 <cprintf>
  80069b:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80069e:	e8 d6 16 00 00       	call   801d79 <sys_enable_interrupt>

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
  8006b6:	e8 63 18 00 00       	call   801f1e <sys_destroy_env>
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
  8006c7:	e8 b8 18 00 00       	call   801f84 <sys_exit_env>
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
  8006f0:	68 bc 3f 80 00       	push   $0x803fbc
  8006f5:	e8 89 02 00 00       	call   800983 <cprintf>
  8006fa:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8006fd:	a1 00 50 80 00       	mov    0x805000,%eax
  800702:	ff 75 0c             	pushl  0xc(%ebp)
  800705:	ff 75 08             	pushl  0x8(%ebp)
  800708:	50                   	push   %eax
  800709:	68 c1 3f 80 00       	push   $0x803fc1
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
  80072d:	68 dd 3f 80 00       	push   $0x803fdd
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
  800759:	68 e0 3f 80 00       	push   $0x803fe0
  80075e:	6a 26                	push   $0x26
  800760:	68 2c 40 80 00       	push   $0x80402c
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
  80082b:	68 38 40 80 00       	push   $0x804038
  800830:	6a 3a                	push   $0x3a
  800832:	68 2c 40 80 00       	push   $0x80402c
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
  80089b:	68 8c 40 80 00       	push   $0x80408c
  8008a0:	6a 44                	push   $0x44
  8008a2:	68 2c 40 80 00       	push   $0x80402c
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
  8008f5:	e8 b7 12 00 00       	call   801bb1 <sys_cputs>
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
  80096c:	e8 40 12 00 00       	call   801bb1 <sys_cputs>
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
  8009b6:	e8 a4 13 00 00       	call   801d5f <sys_disable_interrupt>
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
  8009d6:	e8 9e 13 00 00       	call   801d79 <sys_enable_interrupt>
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
  800a20:	e8 0f 2e 00 00       	call   803834 <__udivdi3>
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
  800a70:	e8 cf 2e 00 00       	call   803944 <__umoddi3>
  800a75:	83 c4 10             	add    $0x10,%esp
  800a78:	05 f4 42 80 00       	add    $0x8042f4,%eax
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
  800bcb:	8b 04 85 18 43 80 00 	mov    0x804318(,%eax,4),%eax
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
  800cac:	8b 34 9d 60 41 80 00 	mov    0x804160(,%ebx,4),%esi
  800cb3:	85 f6                	test   %esi,%esi
  800cb5:	75 19                	jne    800cd0 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800cb7:	53                   	push   %ebx
  800cb8:	68 05 43 80 00       	push   $0x804305
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
  800cd1:	68 0e 43 80 00       	push   $0x80430e
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
  800cfe:	be 11 43 80 00       	mov    $0x804311,%esi
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
  801724:	68 70 44 80 00       	push   $0x804470
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
  8017f4:	e8 fc 04 00 00       	call   801cf5 <sys_allocate_chunk>
  8017f9:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8017fc:	a1 20 51 80 00       	mov    0x805120,%eax
  801801:	83 ec 0c             	sub    $0xc,%esp
  801804:	50                   	push   %eax
  801805:	e8 71 0b 00 00       	call   80237b <initialize_MemBlocksList>
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
  801832:	68 95 44 80 00       	push   $0x804495
  801837:	6a 33                	push   $0x33
  801839:	68 b3 44 80 00       	push   $0x8044b3
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
  8018b1:	68 c0 44 80 00       	push   $0x8044c0
  8018b6:	6a 34                	push   $0x34
  8018b8:	68 b3 44 80 00       	push   $0x8044b3
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
  801949:	e8 75 07 00 00       	call   8020c3 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80194e:	85 c0                	test   %eax,%eax
  801950:	74 11                	je     801963 <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  801952:	83 ec 0c             	sub    $0xc,%esp
  801955:	ff 75 e8             	pushl  -0x18(%ebp)
  801958:	e8 e0 0d 00 00       	call   80273d <alloc_block_FF>
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
  80196f:	e8 3c 0b 00 00       	call   8024b0 <insert_sorted_allocList>
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
  80198f:	68 e4 44 80 00       	push   $0x8044e4
  801994:	6a 6f                	push   $0x6f
  801996:	68 b3 44 80 00       	push   $0x8044b3
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
  8019b5:	75 0a                	jne    8019c1 <smalloc+0x21>
  8019b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8019bc:	e9 8b 00 00 00       	jmp    801a4c <smalloc+0xac>
	//	   Else, return NULL

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  8019c1:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8019c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019ce:	01 d0                	add    %edx,%eax
  8019d0:	48                   	dec    %eax
  8019d1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8019d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019d7:	ba 00 00 00 00       	mov    $0x0,%edx
  8019dc:	f7 75 f0             	divl   -0x10(%ebp)
  8019df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019e2:	29 d0                	sub    %edx,%eax
  8019e4:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  8019e7:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  8019ee:	e8 d0 06 00 00       	call   8020c3 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8019f3:	85 c0                	test   %eax,%eax
  8019f5:	74 11                	je     801a08 <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  8019f7:	83 ec 0c             	sub    $0xc,%esp
  8019fa:	ff 75 e8             	pushl  -0x18(%ebp)
  8019fd:	e8 3b 0d 00 00       	call   80273d <alloc_block_FF>
  801a02:	83 c4 10             	add    $0x10,%esp
  801a05:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(mem_block != NULL)
  801a08:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801a0c:	74 39                	je     801a47 <smalloc+0xa7>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801a0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a11:	8b 40 08             	mov    0x8(%eax),%eax
  801a14:	89 c2                	mov    %eax,%edx
  801a16:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801a1a:	52                   	push   %edx
  801a1b:	50                   	push   %eax
  801a1c:	ff 75 0c             	pushl  0xc(%ebp)
  801a1f:	ff 75 08             	pushl  0x8(%ebp)
  801a22:	e8 21 04 00 00       	call   801e48 <sys_createSharedObject>
  801a27:	83 c4 10             	add    $0x10,%esp
  801a2a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  801a2d:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  801a31:	74 14                	je     801a47 <smalloc+0xa7>
  801a33:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  801a37:	74 0e                	je     801a47 <smalloc+0xa7>
  801a39:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  801a3d:	74 08                	je     801a47 <smalloc+0xa7>
			return (void*) mem_block->sva;
  801a3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a42:	8b 40 08             	mov    0x8(%eax),%eax
  801a45:	eb 05                	jmp    801a4c <smalloc+0xac>
	}
	return NULL;
  801a47:	b8 00 00 00 00       	mov    $0x0,%eax

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
  801a51:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801a54:	e8 b4 fc ff ff       	call   80170d <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801a59:	83 ec 08             	sub    $0x8,%esp
  801a5c:	ff 75 0c             	pushl  0xc(%ebp)
  801a5f:	ff 75 08             	pushl  0x8(%ebp)
  801a62:	e8 0b 04 00 00       	call   801e72 <sys_getSizeOfSharedObject>
  801a67:	83 c4 10             	add    $0x10,%esp
  801a6a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size != E_SHARED_MEM_NOT_EXISTS)
  801a6d:	83 7d f0 f0          	cmpl   $0xfffffff0,-0x10(%ebp)
  801a71:	74 76                	je     801ae9 <sget+0x9b>
	{
		uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801a73:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801a7a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a7d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a80:	01 d0                	add    %edx,%eax
  801a82:	48                   	dec    %eax
  801a83:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801a86:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a89:	ba 00 00 00 00       	mov    $0x0,%edx
  801a8e:	f7 75 ec             	divl   -0x14(%ebp)
  801a91:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a94:	29 d0                	sub    %edx,%eax
  801a96:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		struct MemBlock * mem_block = NULL;
  801a99:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801aa0:	e8 1e 06 00 00       	call   8020c3 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801aa5:	85 c0                	test   %eax,%eax
  801aa7:	74 11                	je     801aba <sget+0x6c>
			mem_block = alloc_block_FF(allocate_space);
  801aa9:	83 ec 0c             	sub    $0xc,%esp
  801aac:	ff 75 e4             	pushl  -0x1c(%ebp)
  801aaf:	e8 89 0c 00 00       	call   80273d <alloc_block_FF>
  801ab4:	83 c4 10             	add    $0x10,%esp
  801ab7:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(mem_block != NULL)
  801aba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801abe:	74 29                	je     801ae9 <sget+0x9b>
		{
			uint32 shared_object_id = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)mem_block->sva);
  801ac0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ac3:	8b 40 08             	mov    0x8(%eax),%eax
  801ac6:	83 ec 04             	sub    $0x4,%esp
  801ac9:	50                   	push   %eax
  801aca:	ff 75 0c             	pushl  0xc(%ebp)
  801acd:	ff 75 08             	pushl  0x8(%ebp)
  801ad0:	e8 ba 03 00 00       	call   801e8f <sys_getSharedObject>
  801ad5:	83 c4 10             	add    $0x10,%esp
  801ad8:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (shared_object_id != E_SHARED_MEM_NOT_EXISTS)
  801adb:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%ebp)
  801adf:	74 08                	je     801ae9 <sget+0x9b>
				return (void *)mem_block->sva;
  801ae1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ae4:	8b 40 08             	mov    0x8(%eax),%eax
  801ae7:	eb 05                	jmp    801aee <sget+0xa0>
		}
	}
	return NULL;
  801ae9:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801aee:	c9                   	leave  
  801aef:	c3                   	ret    

00801af0 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801af0:	55                   	push   %ebp
  801af1:	89 e5                	mov    %esp,%ebp
  801af3:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801af6:	e8 12 fc ff ff       	call   80170d <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801afb:	83 ec 04             	sub    $0x4,%esp
  801afe:	68 08 45 80 00       	push   $0x804508
  801b03:	68 f1 00 00 00       	push   $0xf1
  801b08:	68 b3 44 80 00       	push   $0x8044b3
  801b0d:	e8 bd eb ff ff       	call   8006cf <_panic>

00801b12 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801b12:	55                   	push   %ebp
  801b13:	89 e5                	mov    %esp,%ebp
  801b15:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801b18:	83 ec 04             	sub    $0x4,%esp
  801b1b:	68 30 45 80 00       	push   $0x804530
  801b20:	68 05 01 00 00       	push   $0x105
  801b25:	68 b3 44 80 00       	push   $0x8044b3
  801b2a:	e8 a0 eb ff ff       	call   8006cf <_panic>

00801b2f <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801b2f:	55                   	push   %ebp
  801b30:	89 e5                	mov    %esp,%ebp
  801b32:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801b35:	83 ec 04             	sub    $0x4,%esp
  801b38:	68 54 45 80 00       	push   $0x804554
  801b3d:	68 10 01 00 00       	push   $0x110
  801b42:	68 b3 44 80 00       	push   $0x8044b3
  801b47:	e8 83 eb ff ff       	call   8006cf <_panic>

00801b4c <shrink>:

}
void shrink(uint32 newSize)
{
  801b4c:	55                   	push   %ebp
  801b4d:	89 e5                	mov    %esp,%ebp
  801b4f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801b52:	83 ec 04             	sub    $0x4,%esp
  801b55:	68 54 45 80 00       	push   $0x804554
  801b5a:	68 15 01 00 00       	push   $0x115
  801b5f:	68 b3 44 80 00       	push   $0x8044b3
  801b64:	e8 66 eb ff ff       	call   8006cf <_panic>

00801b69 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801b69:	55                   	push   %ebp
  801b6a:	89 e5                	mov    %esp,%ebp
  801b6c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801b6f:	83 ec 04             	sub    $0x4,%esp
  801b72:	68 54 45 80 00       	push   $0x804554
  801b77:	68 1a 01 00 00       	push   $0x11a
  801b7c:	68 b3 44 80 00       	push   $0x8044b3
  801b81:	e8 49 eb ff ff       	call   8006cf <_panic>

00801b86 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801b86:	55                   	push   %ebp
  801b87:	89 e5                	mov    %esp,%ebp
  801b89:	57                   	push   %edi
  801b8a:	56                   	push   %esi
  801b8b:	53                   	push   %ebx
  801b8c:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801b8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b92:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b95:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b98:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b9b:	8b 7d 18             	mov    0x18(%ebp),%edi
  801b9e:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801ba1:	cd 30                	int    $0x30
  801ba3:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801ba6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801ba9:	83 c4 10             	add    $0x10,%esp
  801bac:	5b                   	pop    %ebx
  801bad:	5e                   	pop    %esi
  801bae:	5f                   	pop    %edi
  801baf:	5d                   	pop    %ebp
  801bb0:	c3                   	ret    

00801bb1 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801bb1:	55                   	push   %ebp
  801bb2:	89 e5                	mov    %esp,%ebp
  801bb4:	83 ec 04             	sub    $0x4,%esp
  801bb7:	8b 45 10             	mov    0x10(%ebp),%eax
  801bba:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801bbd:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801bc1:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc4:	6a 00                	push   $0x0
  801bc6:	6a 00                	push   $0x0
  801bc8:	52                   	push   %edx
  801bc9:	ff 75 0c             	pushl  0xc(%ebp)
  801bcc:	50                   	push   %eax
  801bcd:	6a 00                	push   $0x0
  801bcf:	e8 b2 ff ff ff       	call   801b86 <syscall>
  801bd4:	83 c4 18             	add    $0x18,%esp
}
  801bd7:	90                   	nop
  801bd8:	c9                   	leave  
  801bd9:	c3                   	ret    

00801bda <sys_cgetc>:

int
sys_cgetc(void)
{
  801bda:	55                   	push   %ebp
  801bdb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801bdd:	6a 00                	push   $0x0
  801bdf:	6a 00                	push   $0x0
  801be1:	6a 00                	push   $0x0
  801be3:	6a 00                	push   $0x0
  801be5:	6a 00                	push   $0x0
  801be7:	6a 01                	push   $0x1
  801be9:	e8 98 ff ff ff       	call   801b86 <syscall>
  801bee:	83 c4 18             	add    $0x18,%esp
}
  801bf1:	c9                   	leave  
  801bf2:	c3                   	ret    

00801bf3 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801bf3:	55                   	push   %ebp
  801bf4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801bf6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bf9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bfc:	6a 00                	push   $0x0
  801bfe:	6a 00                	push   $0x0
  801c00:	6a 00                	push   $0x0
  801c02:	52                   	push   %edx
  801c03:	50                   	push   %eax
  801c04:	6a 05                	push   $0x5
  801c06:	e8 7b ff ff ff       	call   801b86 <syscall>
  801c0b:	83 c4 18             	add    $0x18,%esp
}
  801c0e:	c9                   	leave  
  801c0f:	c3                   	ret    

00801c10 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801c10:	55                   	push   %ebp
  801c11:	89 e5                	mov    %esp,%ebp
  801c13:	56                   	push   %esi
  801c14:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801c15:	8b 75 18             	mov    0x18(%ebp),%esi
  801c18:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c1b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c1e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c21:	8b 45 08             	mov    0x8(%ebp),%eax
  801c24:	56                   	push   %esi
  801c25:	53                   	push   %ebx
  801c26:	51                   	push   %ecx
  801c27:	52                   	push   %edx
  801c28:	50                   	push   %eax
  801c29:	6a 06                	push   $0x6
  801c2b:	e8 56 ff ff ff       	call   801b86 <syscall>
  801c30:	83 c4 18             	add    $0x18,%esp
}
  801c33:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c36:	5b                   	pop    %ebx
  801c37:	5e                   	pop    %esi
  801c38:	5d                   	pop    %ebp
  801c39:	c3                   	ret    

00801c3a <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801c3a:	55                   	push   %ebp
  801c3b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801c3d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c40:	8b 45 08             	mov    0x8(%ebp),%eax
  801c43:	6a 00                	push   $0x0
  801c45:	6a 00                	push   $0x0
  801c47:	6a 00                	push   $0x0
  801c49:	52                   	push   %edx
  801c4a:	50                   	push   %eax
  801c4b:	6a 07                	push   $0x7
  801c4d:	e8 34 ff ff ff       	call   801b86 <syscall>
  801c52:	83 c4 18             	add    $0x18,%esp
}
  801c55:	c9                   	leave  
  801c56:	c3                   	ret    

00801c57 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801c57:	55                   	push   %ebp
  801c58:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801c5a:	6a 00                	push   $0x0
  801c5c:	6a 00                	push   $0x0
  801c5e:	6a 00                	push   $0x0
  801c60:	ff 75 0c             	pushl  0xc(%ebp)
  801c63:	ff 75 08             	pushl  0x8(%ebp)
  801c66:	6a 08                	push   $0x8
  801c68:	e8 19 ff ff ff       	call   801b86 <syscall>
  801c6d:	83 c4 18             	add    $0x18,%esp
}
  801c70:	c9                   	leave  
  801c71:	c3                   	ret    

00801c72 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801c72:	55                   	push   %ebp
  801c73:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801c75:	6a 00                	push   $0x0
  801c77:	6a 00                	push   $0x0
  801c79:	6a 00                	push   $0x0
  801c7b:	6a 00                	push   $0x0
  801c7d:	6a 00                	push   $0x0
  801c7f:	6a 09                	push   $0x9
  801c81:	e8 00 ff ff ff       	call   801b86 <syscall>
  801c86:	83 c4 18             	add    $0x18,%esp
}
  801c89:	c9                   	leave  
  801c8a:	c3                   	ret    

00801c8b <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801c8b:	55                   	push   %ebp
  801c8c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801c8e:	6a 00                	push   $0x0
  801c90:	6a 00                	push   $0x0
  801c92:	6a 00                	push   $0x0
  801c94:	6a 00                	push   $0x0
  801c96:	6a 00                	push   $0x0
  801c98:	6a 0a                	push   $0xa
  801c9a:	e8 e7 fe ff ff       	call   801b86 <syscall>
  801c9f:	83 c4 18             	add    $0x18,%esp
}
  801ca2:	c9                   	leave  
  801ca3:	c3                   	ret    

00801ca4 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801ca4:	55                   	push   %ebp
  801ca5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801ca7:	6a 00                	push   $0x0
  801ca9:	6a 00                	push   $0x0
  801cab:	6a 00                	push   $0x0
  801cad:	6a 00                	push   $0x0
  801caf:	6a 00                	push   $0x0
  801cb1:	6a 0b                	push   $0xb
  801cb3:	e8 ce fe ff ff       	call   801b86 <syscall>
  801cb8:	83 c4 18             	add    $0x18,%esp
}
  801cbb:	c9                   	leave  
  801cbc:	c3                   	ret    

00801cbd <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801cbd:	55                   	push   %ebp
  801cbe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801cc0:	6a 00                	push   $0x0
  801cc2:	6a 00                	push   $0x0
  801cc4:	6a 00                	push   $0x0
  801cc6:	ff 75 0c             	pushl  0xc(%ebp)
  801cc9:	ff 75 08             	pushl  0x8(%ebp)
  801ccc:	6a 0f                	push   $0xf
  801cce:	e8 b3 fe ff ff       	call   801b86 <syscall>
  801cd3:	83 c4 18             	add    $0x18,%esp
	return;
  801cd6:	90                   	nop
}
  801cd7:	c9                   	leave  
  801cd8:	c3                   	ret    

00801cd9 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801cd9:	55                   	push   %ebp
  801cda:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801cdc:	6a 00                	push   $0x0
  801cde:	6a 00                	push   $0x0
  801ce0:	6a 00                	push   $0x0
  801ce2:	ff 75 0c             	pushl  0xc(%ebp)
  801ce5:	ff 75 08             	pushl  0x8(%ebp)
  801ce8:	6a 10                	push   $0x10
  801cea:	e8 97 fe ff ff       	call   801b86 <syscall>
  801cef:	83 c4 18             	add    $0x18,%esp
	return ;
  801cf2:	90                   	nop
}
  801cf3:	c9                   	leave  
  801cf4:	c3                   	ret    

00801cf5 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801cf5:	55                   	push   %ebp
  801cf6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801cf8:	6a 00                	push   $0x0
  801cfa:	6a 00                	push   $0x0
  801cfc:	ff 75 10             	pushl  0x10(%ebp)
  801cff:	ff 75 0c             	pushl  0xc(%ebp)
  801d02:	ff 75 08             	pushl  0x8(%ebp)
  801d05:	6a 11                	push   $0x11
  801d07:	e8 7a fe ff ff       	call   801b86 <syscall>
  801d0c:	83 c4 18             	add    $0x18,%esp
	return ;
  801d0f:	90                   	nop
}
  801d10:	c9                   	leave  
  801d11:	c3                   	ret    

00801d12 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801d12:	55                   	push   %ebp
  801d13:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801d15:	6a 00                	push   $0x0
  801d17:	6a 00                	push   $0x0
  801d19:	6a 00                	push   $0x0
  801d1b:	6a 00                	push   $0x0
  801d1d:	6a 00                	push   $0x0
  801d1f:	6a 0c                	push   $0xc
  801d21:	e8 60 fe ff ff       	call   801b86 <syscall>
  801d26:	83 c4 18             	add    $0x18,%esp
}
  801d29:	c9                   	leave  
  801d2a:	c3                   	ret    

00801d2b <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801d2b:	55                   	push   %ebp
  801d2c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801d2e:	6a 00                	push   $0x0
  801d30:	6a 00                	push   $0x0
  801d32:	6a 00                	push   $0x0
  801d34:	6a 00                	push   $0x0
  801d36:	ff 75 08             	pushl  0x8(%ebp)
  801d39:	6a 0d                	push   $0xd
  801d3b:	e8 46 fe ff ff       	call   801b86 <syscall>
  801d40:	83 c4 18             	add    $0x18,%esp
}
  801d43:	c9                   	leave  
  801d44:	c3                   	ret    

00801d45 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801d45:	55                   	push   %ebp
  801d46:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801d48:	6a 00                	push   $0x0
  801d4a:	6a 00                	push   $0x0
  801d4c:	6a 00                	push   $0x0
  801d4e:	6a 00                	push   $0x0
  801d50:	6a 00                	push   $0x0
  801d52:	6a 0e                	push   $0xe
  801d54:	e8 2d fe ff ff       	call   801b86 <syscall>
  801d59:	83 c4 18             	add    $0x18,%esp
}
  801d5c:	90                   	nop
  801d5d:	c9                   	leave  
  801d5e:	c3                   	ret    

00801d5f <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801d5f:	55                   	push   %ebp
  801d60:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801d62:	6a 00                	push   $0x0
  801d64:	6a 00                	push   $0x0
  801d66:	6a 00                	push   $0x0
  801d68:	6a 00                	push   $0x0
  801d6a:	6a 00                	push   $0x0
  801d6c:	6a 13                	push   $0x13
  801d6e:	e8 13 fe ff ff       	call   801b86 <syscall>
  801d73:	83 c4 18             	add    $0x18,%esp
}
  801d76:	90                   	nop
  801d77:	c9                   	leave  
  801d78:	c3                   	ret    

00801d79 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801d79:	55                   	push   %ebp
  801d7a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801d7c:	6a 00                	push   $0x0
  801d7e:	6a 00                	push   $0x0
  801d80:	6a 00                	push   $0x0
  801d82:	6a 00                	push   $0x0
  801d84:	6a 00                	push   $0x0
  801d86:	6a 14                	push   $0x14
  801d88:	e8 f9 fd ff ff       	call   801b86 <syscall>
  801d8d:	83 c4 18             	add    $0x18,%esp
}
  801d90:	90                   	nop
  801d91:	c9                   	leave  
  801d92:	c3                   	ret    

00801d93 <sys_cputc>:


void
sys_cputc(const char c)
{
  801d93:	55                   	push   %ebp
  801d94:	89 e5                	mov    %esp,%ebp
  801d96:	83 ec 04             	sub    $0x4,%esp
  801d99:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801d9f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801da3:	6a 00                	push   $0x0
  801da5:	6a 00                	push   $0x0
  801da7:	6a 00                	push   $0x0
  801da9:	6a 00                	push   $0x0
  801dab:	50                   	push   %eax
  801dac:	6a 15                	push   $0x15
  801dae:	e8 d3 fd ff ff       	call   801b86 <syscall>
  801db3:	83 c4 18             	add    $0x18,%esp
}
  801db6:	90                   	nop
  801db7:	c9                   	leave  
  801db8:	c3                   	ret    

00801db9 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801db9:	55                   	push   %ebp
  801dba:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801dbc:	6a 00                	push   $0x0
  801dbe:	6a 00                	push   $0x0
  801dc0:	6a 00                	push   $0x0
  801dc2:	6a 00                	push   $0x0
  801dc4:	6a 00                	push   $0x0
  801dc6:	6a 16                	push   $0x16
  801dc8:	e8 b9 fd ff ff       	call   801b86 <syscall>
  801dcd:	83 c4 18             	add    $0x18,%esp
}
  801dd0:	90                   	nop
  801dd1:	c9                   	leave  
  801dd2:	c3                   	ret    

00801dd3 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801dd3:	55                   	push   %ebp
  801dd4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801dd6:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd9:	6a 00                	push   $0x0
  801ddb:	6a 00                	push   $0x0
  801ddd:	6a 00                	push   $0x0
  801ddf:	ff 75 0c             	pushl  0xc(%ebp)
  801de2:	50                   	push   %eax
  801de3:	6a 17                	push   $0x17
  801de5:	e8 9c fd ff ff       	call   801b86 <syscall>
  801dea:	83 c4 18             	add    $0x18,%esp
}
  801ded:	c9                   	leave  
  801dee:	c3                   	ret    

00801def <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801def:	55                   	push   %ebp
  801df0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801df2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801df5:	8b 45 08             	mov    0x8(%ebp),%eax
  801df8:	6a 00                	push   $0x0
  801dfa:	6a 00                	push   $0x0
  801dfc:	6a 00                	push   $0x0
  801dfe:	52                   	push   %edx
  801dff:	50                   	push   %eax
  801e00:	6a 1a                	push   $0x1a
  801e02:	e8 7f fd ff ff       	call   801b86 <syscall>
  801e07:	83 c4 18             	add    $0x18,%esp
}
  801e0a:	c9                   	leave  
  801e0b:	c3                   	ret    

00801e0c <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801e0c:	55                   	push   %ebp
  801e0d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801e0f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e12:	8b 45 08             	mov    0x8(%ebp),%eax
  801e15:	6a 00                	push   $0x0
  801e17:	6a 00                	push   $0x0
  801e19:	6a 00                	push   $0x0
  801e1b:	52                   	push   %edx
  801e1c:	50                   	push   %eax
  801e1d:	6a 18                	push   $0x18
  801e1f:	e8 62 fd ff ff       	call   801b86 <syscall>
  801e24:	83 c4 18             	add    $0x18,%esp
}
  801e27:	90                   	nop
  801e28:	c9                   	leave  
  801e29:	c3                   	ret    

00801e2a <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801e2a:	55                   	push   %ebp
  801e2b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801e2d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e30:	8b 45 08             	mov    0x8(%ebp),%eax
  801e33:	6a 00                	push   $0x0
  801e35:	6a 00                	push   $0x0
  801e37:	6a 00                	push   $0x0
  801e39:	52                   	push   %edx
  801e3a:	50                   	push   %eax
  801e3b:	6a 19                	push   $0x19
  801e3d:	e8 44 fd ff ff       	call   801b86 <syscall>
  801e42:	83 c4 18             	add    $0x18,%esp
}
  801e45:	90                   	nop
  801e46:	c9                   	leave  
  801e47:	c3                   	ret    

00801e48 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801e48:	55                   	push   %ebp
  801e49:	89 e5                	mov    %esp,%ebp
  801e4b:	83 ec 04             	sub    $0x4,%esp
  801e4e:	8b 45 10             	mov    0x10(%ebp),%eax
  801e51:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801e54:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801e57:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801e5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5e:	6a 00                	push   $0x0
  801e60:	51                   	push   %ecx
  801e61:	52                   	push   %edx
  801e62:	ff 75 0c             	pushl  0xc(%ebp)
  801e65:	50                   	push   %eax
  801e66:	6a 1b                	push   $0x1b
  801e68:	e8 19 fd ff ff       	call   801b86 <syscall>
  801e6d:	83 c4 18             	add    $0x18,%esp
}
  801e70:	c9                   	leave  
  801e71:	c3                   	ret    

00801e72 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801e72:	55                   	push   %ebp
  801e73:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801e75:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e78:	8b 45 08             	mov    0x8(%ebp),%eax
  801e7b:	6a 00                	push   $0x0
  801e7d:	6a 00                	push   $0x0
  801e7f:	6a 00                	push   $0x0
  801e81:	52                   	push   %edx
  801e82:	50                   	push   %eax
  801e83:	6a 1c                	push   $0x1c
  801e85:	e8 fc fc ff ff       	call   801b86 <syscall>
  801e8a:	83 c4 18             	add    $0x18,%esp
}
  801e8d:	c9                   	leave  
  801e8e:	c3                   	ret    

00801e8f <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801e8f:	55                   	push   %ebp
  801e90:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801e92:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e95:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e98:	8b 45 08             	mov    0x8(%ebp),%eax
  801e9b:	6a 00                	push   $0x0
  801e9d:	6a 00                	push   $0x0
  801e9f:	51                   	push   %ecx
  801ea0:	52                   	push   %edx
  801ea1:	50                   	push   %eax
  801ea2:	6a 1d                	push   $0x1d
  801ea4:	e8 dd fc ff ff       	call   801b86 <syscall>
  801ea9:	83 c4 18             	add    $0x18,%esp
}
  801eac:	c9                   	leave  
  801ead:	c3                   	ret    

00801eae <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801eae:	55                   	push   %ebp
  801eaf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801eb1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eb4:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb7:	6a 00                	push   $0x0
  801eb9:	6a 00                	push   $0x0
  801ebb:	6a 00                	push   $0x0
  801ebd:	52                   	push   %edx
  801ebe:	50                   	push   %eax
  801ebf:	6a 1e                	push   $0x1e
  801ec1:	e8 c0 fc ff ff       	call   801b86 <syscall>
  801ec6:	83 c4 18             	add    $0x18,%esp
}
  801ec9:	c9                   	leave  
  801eca:	c3                   	ret    

00801ecb <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801ecb:	55                   	push   %ebp
  801ecc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801ece:	6a 00                	push   $0x0
  801ed0:	6a 00                	push   $0x0
  801ed2:	6a 00                	push   $0x0
  801ed4:	6a 00                	push   $0x0
  801ed6:	6a 00                	push   $0x0
  801ed8:	6a 1f                	push   $0x1f
  801eda:	e8 a7 fc ff ff       	call   801b86 <syscall>
  801edf:	83 c4 18             	add    $0x18,%esp
}
  801ee2:	c9                   	leave  
  801ee3:	c3                   	ret    

00801ee4 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801ee4:	55                   	push   %ebp
  801ee5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801ee7:	8b 45 08             	mov    0x8(%ebp),%eax
  801eea:	6a 00                	push   $0x0
  801eec:	ff 75 14             	pushl  0x14(%ebp)
  801eef:	ff 75 10             	pushl  0x10(%ebp)
  801ef2:	ff 75 0c             	pushl  0xc(%ebp)
  801ef5:	50                   	push   %eax
  801ef6:	6a 20                	push   $0x20
  801ef8:	e8 89 fc ff ff       	call   801b86 <syscall>
  801efd:	83 c4 18             	add    $0x18,%esp
}
  801f00:	c9                   	leave  
  801f01:	c3                   	ret    

00801f02 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801f02:	55                   	push   %ebp
  801f03:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801f05:	8b 45 08             	mov    0x8(%ebp),%eax
  801f08:	6a 00                	push   $0x0
  801f0a:	6a 00                	push   $0x0
  801f0c:	6a 00                	push   $0x0
  801f0e:	6a 00                	push   $0x0
  801f10:	50                   	push   %eax
  801f11:	6a 21                	push   $0x21
  801f13:	e8 6e fc ff ff       	call   801b86 <syscall>
  801f18:	83 c4 18             	add    $0x18,%esp
}
  801f1b:	90                   	nop
  801f1c:	c9                   	leave  
  801f1d:	c3                   	ret    

00801f1e <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801f1e:	55                   	push   %ebp
  801f1f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801f21:	8b 45 08             	mov    0x8(%ebp),%eax
  801f24:	6a 00                	push   $0x0
  801f26:	6a 00                	push   $0x0
  801f28:	6a 00                	push   $0x0
  801f2a:	6a 00                	push   $0x0
  801f2c:	50                   	push   %eax
  801f2d:	6a 22                	push   $0x22
  801f2f:	e8 52 fc ff ff       	call   801b86 <syscall>
  801f34:	83 c4 18             	add    $0x18,%esp
}
  801f37:	c9                   	leave  
  801f38:	c3                   	ret    

00801f39 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801f39:	55                   	push   %ebp
  801f3a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801f3c:	6a 00                	push   $0x0
  801f3e:	6a 00                	push   $0x0
  801f40:	6a 00                	push   $0x0
  801f42:	6a 00                	push   $0x0
  801f44:	6a 00                	push   $0x0
  801f46:	6a 02                	push   $0x2
  801f48:	e8 39 fc ff ff       	call   801b86 <syscall>
  801f4d:	83 c4 18             	add    $0x18,%esp
}
  801f50:	c9                   	leave  
  801f51:	c3                   	ret    

00801f52 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801f52:	55                   	push   %ebp
  801f53:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801f55:	6a 00                	push   $0x0
  801f57:	6a 00                	push   $0x0
  801f59:	6a 00                	push   $0x0
  801f5b:	6a 00                	push   $0x0
  801f5d:	6a 00                	push   $0x0
  801f5f:	6a 03                	push   $0x3
  801f61:	e8 20 fc ff ff       	call   801b86 <syscall>
  801f66:	83 c4 18             	add    $0x18,%esp
}
  801f69:	c9                   	leave  
  801f6a:	c3                   	ret    

00801f6b <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801f6b:	55                   	push   %ebp
  801f6c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801f6e:	6a 00                	push   $0x0
  801f70:	6a 00                	push   $0x0
  801f72:	6a 00                	push   $0x0
  801f74:	6a 00                	push   $0x0
  801f76:	6a 00                	push   $0x0
  801f78:	6a 04                	push   $0x4
  801f7a:	e8 07 fc ff ff       	call   801b86 <syscall>
  801f7f:	83 c4 18             	add    $0x18,%esp
}
  801f82:	c9                   	leave  
  801f83:	c3                   	ret    

00801f84 <sys_exit_env>:


void sys_exit_env(void)
{
  801f84:	55                   	push   %ebp
  801f85:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801f87:	6a 00                	push   $0x0
  801f89:	6a 00                	push   $0x0
  801f8b:	6a 00                	push   $0x0
  801f8d:	6a 00                	push   $0x0
  801f8f:	6a 00                	push   $0x0
  801f91:	6a 23                	push   $0x23
  801f93:	e8 ee fb ff ff       	call   801b86 <syscall>
  801f98:	83 c4 18             	add    $0x18,%esp
}
  801f9b:	90                   	nop
  801f9c:	c9                   	leave  
  801f9d:	c3                   	ret    

00801f9e <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801f9e:	55                   	push   %ebp
  801f9f:	89 e5                	mov    %esp,%ebp
  801fa1:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801fa4:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801fa7:	8d 50 04             	lea    0x4(%eax),%edx
  801faa:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801fad:	6a 00                	push   $0x0
  801faf:	6a 00                	push   $0x0
  801fb1:	6a 00                	push   $0x0
  801fb3:	52                   	push   %edx
  801fb4:	50                   	push   %eax
  801fb5:	6a 24                	push   $0x24
  801fb7:	e8 ca fb ff ff       	call   801b86 <syscall>
  801fbc:	83 c4 18             	add    $0x18,%esp
	return result;
  801fbf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801fc2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801fc5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801fc8:	89 01                	mov    %eax,(%ecx)
  801fca:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801fcd:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd0:	c9                   	leave  
  801fd1:	c2 04 00             	ret    $0x4

00801fd4 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801fd4:	55                   	push   %ebp
  801fd5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801fd7:	6a 00                	push   $0x0
  801fd9:	6a 00                	push   $0x0
  801fdb:	ff 75 10             	pushl  0x10(%ebp)
  801fde:	ff 75 0c             	pushl  0xc(%ebp)
  801fe1:	ff 75 08             	pushl  0x8(%ebp)
  801fe4:	6a 12                	push   $0x12
  801fe6:	e8 9b fb ff ff       	call   801b86 <syscall>
  801feb:	83 c4 18             	add    $0x18,%esp
	return ;
  801fee:	90                   	nop
}
  801fef:	c9                   	leave  
  801ff0:	c3                   	ret    

00801ff1 <sys_rcr2>:
uint32 sys_rcr2()
{
  801ff1:	55                   	push   %ebp
  801ff2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801ff4:	6a 00                	push   $0x0
  801ff6:	6a 00                	push   $0x0
  801ff8:	6a 00                	push   $0x0
  801ffa:	6a 00                	push   $0x0
  801ffc:	6a 00                	push   $0x0
  801ffe:	6a 25                	push   $0x25
  802000:	e8 81 fb ff ff       	call   801b86 <syscall>
  802005:	83 c4 18             	add    $0x18,%esp
}
  802008:	c9                   	leave  
  802009:	c3                   	ret    

0080200a <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  80200a:	55                   	push   %ebp
  80200b:	89 e5                	mov    %esp,%ebp
  80200d:	83 ec 04             	sub    $0x4,%esp
  802010:	8b 45 08             	mov    0x8(%ebp),%eax
  802013:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802016:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80201a:	6a 00                	push   $0x0
  80201c:	6a 00                	push   $0x0
  80201e:	6a 00                	push   $0x0
  802020:	6a 00                	push   $0x0
  802022:	50                   	push   %eax
  802023:	6a 26                	push   $0x26
  802025:	e8 5c fb ff ff       	call   801b86 <syscall>
  80202a:	83 c4 18             	add    $0x18,%esp
	return ;
  80202d:	90                   	nop
}
  80202e:	c9                   	leave  
  80202f:	c3                   	ret    

00802030 <rsttst>:
void rsttst()
{
  802030:	55                   	push   %ebp
  802031:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802033:	6a 00                	push   $0x0
  802035:	6a 00                	push   $0x0
  802037:	6a 00                	push   $0x0
  802039:	6a 00                	push   $0x0
  80203b:	6a 00                	push   $0x0
  80203d:	6a 28                	push   $0x28
  80203f:	e8 42 fb ff ff       	call   801b86 <syscall>
  802044:	83 c4 18             	add    $0x18,%esp
	return ;
  802047:	90                   	nop
}
  802048:	c9                   	leave  
  802049:	c3                   	ret    

0080204a <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80204a:	55                   	push   %ebp
  80204b:	89 e5                	mov    %esp,%ebp
  80204d:	83 ec 04             	sub    $0x4,%esp
  802050:	8b 45 14             	mov    0x14(%ebp),%eax
  802053:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802056:	8b 55 18             	mov    0x18(%ebp),%edx
  802059:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80205d:	52                   	push   %edx
  80205e:	50                   	push   %eax
  80205f:	ff 75 10             	pushl  0x10(%ebp)
  802062:	ff 75 0c             	pushl  0xc(%ebp)
  802065:	ff 75 08             	pushl  0x8(%ebp)
  802068:	6a 27                	push   $0x27
  80206a:	e8 17 fb ff ff       	call   801b86 <syscall>
  80206f:	83 c4 18             	add    $0x18,%esp
	return ;
  802072:	90                   	nop
}
  802073:	c9                   	leave  
  802074:	c3                   	ret    

00802075 <chktst>:
void chktst(uint32 n)
{
  802075:	55                   	push   %ebp
  802076:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802078:	6a 00                	push   $0x0
  80207a:	6a 00                	push   $0x0
  80207c:	6a 00                	push   $0x0
  80207e:	6a 00                	push   $0x0
  802080:	ff 75 08             	pushl  0x8(%ebp)
  802083:	6a 29                	push   $0x29
  802085:	e8 fc fa ff ff       	call   801b86 <syscall>
  80208a:	83 c4 18             	add    $0x18,%esp
	return ;
  80208d:	90                   	nop
}
  80208e:	c9                   	leave  
  80208f:	c3                   	ret    

00802090 <inctst>:

void inctst()
{
  802090:	55                   	push   %ebp
  802091:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802093:	6a 00                	push   $0x0
  802095:	6a 00                	push   $0x0
  802097:	6a 00                	push   $0x0
  802099:	6a 00                	push   $0x0
  80209b:	6a 00                	push   $0x0
  80209d:	6a 2a                	push   $0x2a
  80209f:	e8 e2 fa ff ff       	call   801b86 <syscall>
  8020a4:	83 c4 18             	add    $0x18,%esp
	return ;
  8020a7:	90                   	nop
}
  8020a8:	c9                   	leave  
  8020a9:	c3                   	ret    

008020aa <gettst>:
uint32 gettst()
{
  8020aa:	55                   	push   %ebp
  8020ab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8020ad:	6a 00                	push   $0x0
  8020af:	6a 00                	push   $0x0
  8020b1:	6a 00                	push   $0x0
  8020b3:	6a 00                	push   $0x0
  8020b5:	6a 00                	push   $0x0
  8020b7:	6a 2b                	push   $0x2b
  8020b9:	e8 c8 fa ff ff       	call   801b86 <syscall>
  8020be:	83 c4 18             	add    $0x18,%esp
}
  8020c1:	c9                   	leave  
  8020c2:	c3                   	ret    

008020c3 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8020c3:	55                   	push   %ebp
  8020c4:	89 e5                	mov    %esp,%ebp
  8020c6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8020c9:	6a 00                	push   $0x0
  8020cb:	6a 00                	push   $0x0
  8020cd:	6a 00                	push   $0x0
  8020cf:	6a 00                	push   $0x0
  8020d1:	6a 00                	push   $0x0
  8020d3:	6a 2c                	push   $0x2c
  8020d5:	e8 ac fa ff ff       	call   801b86 <syscall>
  8020da:	83 c4 18             	add    $0x18,%esp
  8020dd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8020e0:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8020e4:	75 07                	jne    8020ed <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8020e6:	b8 01 00 00 00       	mov    $0x1,%eax
  8020eb:	eb 05                	jmp    8020f2 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8020ed:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020f2:	c9                   	leave  
  8020f3:	c3                   	ret    

008020f4 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8020f4:	55                   	push   %ebp
  8020f5:	89 e5                	mov    %esp,%ebp
  8020f7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8020fa:	6a 00                	push   $0x0
  8020fc:	6a 00                	push   $0x0
  8020fe:	6a 00                	push   $0x0
  802100:	6a 00                	push   $0x0
  802102:	6a 00                	push   $0x0
  802104:	6a 2c                	push   $0x2c
  802106:	e8 7b fa ff ff       	call   801b86 <syscall>
  80210b:	83 c4 18             	add    $0x18,%esp
  80210e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802111:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802115:	75 07                	jne    80211e <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802117:	b8 01 00 00 00       	mov    $0x1,%eax
  80211c:	eb 05                	jmp    802123 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80211e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802123:	c9                   	leave  
  802124:	c3                   	ret    

00802125 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802125:	55                   	push   %ebp
  802126:	89 e5                	mov    %esp,%ebp
  802128:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80212b:	6a 00                	push   $0x0
  80212d:	6a 00                	push   $0x0
  80212f:	6a 00                	push   $0x0
  802131:	6a 00                	push   $0x0
  802133:	6a 00                	push   $0x0
  802135:	6a 2c                	push   $0x2c
  802137:	e8 4a fa ff ff       	call   801b86 <syscall>
  80213c:	83 c4 18             	add    $0x18,%esp
  80213f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802142:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802146:	75 07                	jne    80214f <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802148:	b8 01 00 00 00       	mov    $0x1,%eax
  80214d:	eb 05                	jmp    802154 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80214f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802154:	c9                   	leave  
  802155:	c3                   	ret    

00802156 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802156:	55                   	push   %ebp
  802157:	89 e5                	mov    %esp,%ebp
  802159:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80215c:	6a 00                	push   $0x0
  80215e:	6a 00                	push   $0x0
  802160:	6a 00                	push   $0x0
  802162:	6a 00                	push   $0x0
  802164:	6a 00                	push   $0x0
  802166:	6a 2c                	push   $0x2c
  802168:	e8 19 fa ff ff       	call   801b86 <syscall>
  80216d:	83 c4 18             	add    $0x18,%esp
  802170:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802173:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802177:	75 07                	jne    802180 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802179:	b8 01 00 00 00       	mov    $0x1,%eax
  80217e:	eb 05                	jmp    802185 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802180:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802185:	c9                   	leave  
  802186:	c3                   	ret    

00802187 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802187:	55                   	push   %ebp
  802188:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80218a:	6a 00                	push   $0x0
  80218c:	6a 00                	push   $0x0
  80218e:	6a 00                	push   $0x0
  802190:	6a 00                	push   $0x0
  802192:	ff 75 08             	pushl  0x8(%ebp)
  802195:	6a 2d                	push   $0x2d
  802197:	e8 ea f9 ff ff       	call   801b86 <syscall>
  80219c:	83 c4 18             	add    $0x18,%esp
	return ;
  80219f:	90                   	nop
}
  8021a0:	c9                   	leave  
  8021a1:	c3                   	ret    

008021a2 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8021a2:	55                   	push   %ebp
  8021a3:	89 e5                	mov    %esp,%ebp
  8021a5:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8021a6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8021a9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8021ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021af:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b2:	6a 00                	push   $0x0
  8021b4:	53                   	push   %ebx
  8021b5:	51                   	push   %ecx
  8021b6:	52                   	push   %edx
  8021b7:	50                   	push   %eax
  8021b8:	6a 2e                	push   $0x2e
  8021ba:	e8 c7 f9 ff ff       	call   801b86 <syscall>
  8021bf:	83 c4 18             	add    $0x18,%esp
}
  8021c2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021c5:	c9                   	leave  
  8021c6:	c3                   	ret    

008021c7 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8021c7:	55                   	push   %ebp
  8021c8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8021ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d0:	6a 00                	push   $0x0
  8021d2:	6a 00                	push   $0x0
  8021d4:	6a 00                	push   $0x0
  8021d6:	52                   	push   %edx
  8021d7:	50                   	push   %eax
  8021d8:	6a 2f                	push   $0x2f
  8021da:	e8 a7 f9 ff ff       	call   801b86 <syscall>
  8021df:	83 c4 18             	add    $0x18,%esp
}
  8021e2:	c9                   	leave  
  8021e3:	c3                   	ret    

008021e4 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  8021e4:	55                   	push   %ebp
  8021e5:	89 e5                	mov    %esp,%ebp
  8021e7:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  8021ea:	83 ec 0c             	sub    $0xc,%esp
  8021ed:	68 64 45 80 00       	push   $0x804564
  8021f2:	e8 8c e7 ff ff       	call   800983 <cprintf>
  8021f7:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  8021fa:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802201:	83 ec 0c             	sub    $0xc,%esp
  802204:	68 90 45 80 00       	push   $0x804590
  802209:	e8 75 e7 ff ff       	call   800983 <cprintf>
  80220e:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802211:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802215:	a1 38 51 80 00       	mov    0x805138,%eax
  80221a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80221d:	eb 56                	jmp    802275 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80221f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802223:	74 1c                	je     802241 <print_mem_block_lists+0x5d>
  802225:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802228:	8b 50 08             	mov    0x8(%eax),%edx
  80222b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80222e:	8b 48 08             	mov    0x8(%eax),%ecx
  802231:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802234:	8b 40 0c             	mov    0xc(%eax),%eax
  802237:	01 c8                	add    %ecx,%eax
  802239:	39 c2                	cmp    %eax,%edx
  80223b:	73 04                	jae    802241 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  80223d:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802241:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802244:	8b 50 08             	mov    0x8(%eax),%edx
  802247:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80224a:	8b 40 0c             	mov    0xc(%eax),%eax
  80224d:	01 c2                	add    %eax,%edx
  80224f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802252:	8b 40 08             	mov    0x8(%eax),%eax
  802255:	83 ec 04             	sub    $0x4,%esp
  802258:	52                   	push   %edx
  802259:	50                   	push   %eax
  80225a:	68 a5 45 80 00       	push   $0x8045a5
  80225f:	e8 1f e7 ff ff       	call   800983 <cprintf>
  802264:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802267:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80226a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80226d:	a1 40 51 80 00       	mov    0x805140,%eax
  802272:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802275:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802279:	74 07                	je     802282 <print_mem_block_lists+0x9e>
  80227b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80227e:	8b 00                	mov    (%eax),%eax
  802280:	eb 05                	jmp    802287 <print_mem_block_lists+0xa3>
  802282:	b8 00 00 00 00       	mov    $0x0,%eax
  802287:	a3 40 51 80 00       	mov    %eax,0x805140
  80228c:	a1 40 51 80 00       	mov    0x805140,%eax
  802291:	85 c0                	test   %eax,%eax
  802293:	75 8a                	jne    80221f <print_mem_block_lists+0x3b>
  802295:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802299:	75 84                	jne    80221f <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  80229b:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80229f:	75 10                	jne    8022b1 <print_mem_block_lists+0xcd>
  8022a1:	83 ec 0c             	sub    $0xc,%esp
  8022a4:	68 b4 45 80 00       	push   $0x8045b4
  8022a9:	e8 d5 e6 ff ff       	call   800983 <cprintf>
  8022ae:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8022b1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8022b8:	83 ec 0c             	sub    $0xc,%esp
  8022bb:	68 d8 45 80 00       	push   $0x8045d8
  8022c0:	e8 be e6 ff ff       	call   800983 <cprintf>
  8022c5:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8022c8:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8022cc:	a1 40 50 80 00       	mov    0x805040,%eax
  8022d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022d4:	eb 56                	jmp    80232c <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8022d6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8022da:	74 1c                	je     8022f8 <print_mem_block_lists+0x114>
  8022dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022df:	8b 50 08             	mov    0x8(%eax),%edx
  8022e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022e5:	8b 48 08             	mov    0x8(%eax),%ecx
  8022e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022eb:	8b 40 0c             	mov    0xc(%eax),%eax
  8022ee:	01 c8                	add    %ecx,%eax
  8022f0:	39 c2                	cmp    %eax,%edx
  8022f2:	73 04                	jae    8022f8 <print_mem_block_lists+0x114>
			sorted = 0 ;
  8022f4:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8022f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022fb:	8b 50 08             	mov    0x8(%eax),%edx
  8022fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802301:	8b 40 0c             	mov    0xc(%eax),%eax
  802304:	01 c2                	add    %eax,%edx
  802306:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802309:	8b 40 08             	mov    0x8(%eax),%eax
  80230c:	83 ec 04             	sub    $0x4,%esp
  80230f:	52                   	push   %edx
  802310:	50                   	push   %eax
  802311:	68 a5 45 80 00       	push   $0x8045a5
  802316:	e8 68 e6 ff ff       	call   800983 <cprintf>
  80231b:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80231e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802321:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802324:	a1 48 50 80 00       	mov    0x805048,%eax
  802329:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80232c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802330:	74 07                	je     802339 <print_mem_block_lists+0x155>
  802332:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802335:	8b 00                	mov    (%eax),%eax
  802337:	eb 05                	jmp    80233e <print_mem_block_lists+0x15a>
  802339:	b8 00 00 00 00       	mov    $0x0,%eax
  80233e:	a3 48 50 80 00       	mov    %eax,0x805048
  802343:	a1 48 50 80 00       	mov    0x805048,%eax
  802348:	85 c0                	test   %eax,%eax
  80234a:	75 8a                	jne    8022d6 <print_mem_block_lists+0xf2>
  80234c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802350:	75 84                	jne    8022d6 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802352:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802356:	75 10                	jne    802368 <print_mem_block_lists+0x184>
  802358:	83 ec 0c             	sub    $0xc,%esp
  80235b:	68 f0 45 80 00       	push   $0x8045f0
  802360:	e8 1e e6 ff ff       	call   800983 <cprintf>
  802365:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802368:	83 ec 0c             	sub    $0xc,%esp
  80236b:	68 64 45 80 00       	push   $0x804564
  802370:	e8 0e e6 ff ff       	call   800983 <cprintf>
  802375:	83 c4 10             	add    $0x10,%esp

}
  802378:	90                   	nop
  802379:	c9                   	leave  
  80237a:	c3                   	ret    

0080237b <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  80237b:	55                   	push   %ebp
  80237c:	89 e5                	mov    %esp,%ebp
  80237e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  802381:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802388:	00 00 00 
  80238b:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802392:	00 00 00 
  802395:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  80239c:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  80239f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8023a6:	e9 9e 00 00 00       	jmp    802449 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  8023ab:	a1 50 50 80 00       	mov    0x805050,%eax
  8023b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023b3:	c1 e2 04             	shl    $0x4,%edx
  8023b6:	01 d0                	add    %edx,%eax
  8023b8:	85 c0                	test   %eax,%eax
  8023ba:	75 14                	jne    8023d0 <initialize_MemBlocksList+0x55>
  8023bc:	83 ec 04             	sub    $0x4,%esp
  8023bf:	68 18 46 80 00       	push   $0x804618
  8023c4:	6a 46                	push   $0x46
  8023c6:	68 3b 46 80 00       	push   $0x80463b
  8023cb:	e8 ff e2 ff ff       	call   8006cf <_panic>
  8023d0:	a1 50 50 80 00       	mov    0x805050,%eax
  8023d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023d8:	c1 e2 04             	shl    $0x4,%edx
  8023db:	01 d0                	add    %edx,%eax
  8023dd:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8023e3:	89 10                	mov    %edx,(%eax)
  8023e5:	8b 00                	mov    (%eax),%eax
  8023e7:	85 c0                	test   %eax,%eax
  8023e9:	74 18                	je     802403 <initialize_MemBlocksList+0x88>
  8023eb:	a1 48 51 80 00       	mov    0x805148,%eax
  8023f0:	8b 15 50 50 80 00    	mov    0x805050,%edx
  8023f6:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8023f9:	c1 e1 04             	shl    $0x4,%ecx
  8023fc:	01 ca                	add    %ecx,%edx
  8023fe:	89 50 04             	mov    %edx,0x4(%eax)
  802401:	eb 12                	jmp    802415 <initialize_MemBlocksList+0x9a>
  802403:	a1 50 50 80 00       	mov    0x805050,%eax
  802408:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80240b:	c1 e2 04             	shl    $0x4,%edx
  80240e:	01 d0                	add    %edx,%eax
  802410:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802415:	a1 50 50 80 00       	mov    0x805050,%eax
  80241a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80241d:	c1 e2 04             	shl    $0x4,%edx
  802420:	01 d0                	add    %edx,%eax
  802422:	a3 48 51 80 00       	mov    %eax,0x805148
  802427:	a1 50 50 80 00       	mov    0x805050,%eax
  80242c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80242f:	c1 e2 04             	shl    $0x4,%edx
  802432:	01 d0                	add    %edx,%eax
  802434:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80243b:	a1 54 51 80 00       	mov    0x805154,%eax
  802440:	40                   	inc    %eax
  802441:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  802446:	ff 45 f4             	incl   -0xc(%ebp)
  802449:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80244f:	0f 82 56 ff ff ff    	jb     8023ab <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  802455:	90                   	nop
  802456:	c9                   	leave  
  802457:	c3                   	ret    

00802458 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802458:	55                   	push   %ebp
  802459:	89 e5                	mov    %esp,%ebp
  80245b:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  80245e:	8b 45 08             	mov    0x8(%ebp),%eax
  802461:	8b 00                	mov    (%eax),%eax
  802463:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802466:	eb 19                	jmp    802481 <find_block+0x29>
	{
		if(va==point->sva)
  802468:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80246b:	8b 40 08             	mov    0x8(%eax),%eax
  80246e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802471:	75 05                	jne    802478 <find_block+0x20>
		   return point;
  802473:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802476:	eb 36                	jmp    8024ae <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802478:	8b 45 08             	mov    0x8(%ebp),%eax
  80247b:	8b 40 08             	mov    0x8(%eax),%eax
  80247e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802481:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802485:	74 07                	je     80248e <find_block+0x36>
  802487:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80248a:	8b 00                	mov    (%eax),%eax
  80248c:	eb 05                	jmp    802493 <find_block+0x3b>
  80248e:	b8 00 00 00 00       	mov    $0x0,%eax
  802493:	8b 55 08             	mov    0x8(%ebp),%edx
  802496:	89 42 08             	mov    %eax,0x8(%edx)
  802499:	8b 45 08             	mov    0x8(%ebp),%eax
  80249c:	8b 40 08             	mov    0x8(%eax),%eax
  80249f:	85 c0                	test   %eax,%eax
  8024a1:	75 c5                	jne    802468 <find_block+0x10>
  8024a3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8024a7:	75 bf                	jne    802468 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  8024a9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024ae:	c9                   	leave  
  8024af:	c3                   	ret    

008024b0 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8024b0:	55                   	push   %ebp
  8024b1:	89 e5                	mov    %esp,%ebp
  8024b3:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  8024b6:	a1 40 50 80 00       	mov    0x805040,%eax
  8024bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  8024be:	a1 44 50 80 00       	mov    0x805044,%eax
  8024c3:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  8024c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024c9:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8024cc:	74 24                	je     8024f2 <insert_sorted_allocList+0x42>
  8024ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d1:	8b 50 08             	mov    0x8(%eax),%edx
  8024d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024d7:	8b 40 08             	mov    0x8(%eax),%eax
  8024da:	39 c2                	cmp    %eax,%edx
  8024dc:	76 14                	jbe    8024f2 <insert_sorted_allocList+0x42>
  8024de:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e1:	8b 50 08             	mov    0x8(%eax),%edx
  8024e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024e7:	8b 40 08             	mov    0x8(%eax),%eax
  8024ea:	39 c2                	cmp    %eax,%edx
  8024ec:	0f 82 60 01 00 00    	jb     802652 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  8024f2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8024f6:	75 65                	jne    80255d <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  8024f8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8024fc:	75 14                	jne    802512 <insert_sorted_allocList+0x62>
  8024fe:	83 ec 04             	sub    $0x4,%esp
  802501:	68 18 46 80 00       	push   $0x804618
  802506:	6a 6b                	push   $0x6b
  802508:	68 3b 46 80 00       	push   $0x80463b
  80250d:	e8 bd e1 ff ff       	call   8006cf <_panic>
  802512:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802518:	8b 45 08             	mov    0x8(%ebp),%eax
  80251b:	89 10                	mov    %edx,(%eax)
  80251d:	8b 45 08             	mov    0x8(%ebp),%eax
  802520:	8b 00                	mov    (%eax),%eax
  802522:	85 c0                	test   %eax,%eax
  802524:	74 0d                	je     802533 <insert_sorted_allocList+0x83>
  802526:	a1 40 50 80 00       	mov    0x805040,%eax
  80252b:	8b 55 08             	mov    0x8(%ebp),%edx
  80252e:	89 50 04             	mov    %edx,0x4(%eax)
  802531:	eb 08                	jmp    80253b <insert_sorted_allocList+0x8b>
  802533:	8b 45 08             	mov    0x8(%ebp),%eax
  802536:	a3 44 50 80 00       	mov    %eax,0x805044
  80253b:	8b 45 08             	mov    0x8(%ebp),%eax
  80253e:	a3 40 50 80 00       	mov    %eax,0x805040
  802543:	8b 45 08             	mov    0x8(%ebp),%eax
  802546:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80254d:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802552:	40                   	inc    %eax
  802553:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802558:	e9 dc 01 00 00       	jmp    802739 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  80255d:	8b 45 08             	mov    0x8(%ebp),%eax
  802560:	8b 50 08             	mov    0x8(%eax),%edx
  802563:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802566:	8b 40 08             	mov    0x8(%eax),%eax
  802569:	39 c2                	cmp    %eax,%edx
  80256b:	77 6c                	ja     8025d9 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  80256d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802571:	74 06                	je     802579 <insert_sorted_allocList+0xc9>
  802573:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802577:	75 14                	jne    80258d <insert_sorted_allocList+0xdd>
  802579:	83 ec 04             	sub    $0x4,%esp
  80257c:	68 54 46 80 00       	push   $0x804654
  802581:	6a 6f                	push   $0x6f
  802583:	68 3b 46 80 00       	push   $0x80463b
  802588:	e8 42 e1 ff ff       	call   8006cf <_panic>
  80258d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802590:	8b 50 04             	mov    0x4(%eax),%edx
  802593:	8b 45 08             	mov    0x8(%ebp),%eax
  802596:	89 50 04             	mov    %edx,0x4(%eax)
  802599:	8b 45 08             	mov    0x8(%ebp),%eax
  80259c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80259f:	89 10                	mov    %edx,(%eax)
  8025a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025a4:	8b 40 04             	mov    0x4(%eax),%eax
  8025a7:	85 c0                	test   %eax,%eax
  8025a9:	74 0d                	je     8025b8 <insert_sorted_allocList+0x108>
  8025ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025ae:	8b 40 04             	mov    0x4(%eax),%eax
  8025b1:	8b 55 08             	mov    0x8(%ebp),%edx
  8025b4:	89 10                	mov    %edx,(%eax)
  8025b6:	eb 08                	jmp    8025c0 <insert_sorted_allocList+0x110>
  8025b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8025bb:	a3 40 50 80 00       	mov    %eax,0x805040
  8025c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025c3:	8b 55 08             	mov    0x8(%ebp),%edx
  8025c6:	89 50 04             	mov    %edx,0x4(%eax)
  8025c9:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8025ce:	40                   	inc    %eax
  8025cf:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8025d4:	e9 60 01 00 00       	jmp    802739 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  8025d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8025dc:	8b 50 08             	mov    0x8(%eax),%edx
  8025df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025e2:	8b 40 08             	mov    0x8(%eax),%eax
  8025e5:	39 c2                	cmp    %eax,%edx
  8025e7:	0f 82 4c 01 00 00    	jb     802739 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8025ed:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8025f1:	75 14                	jne    802607 <insert_sorted_allocList+0x157>
  8025f3:	83 ec 04             	sub    $0x4,%esp
  8025f6:	68 8c 46 80 00       	push   $0x80468c
  8025fb:	6a 73                	push   $0x73
  8025fd:	68 3b 46 80 00       	push   $0x80463b
  802602:	e8 c8 e0 ff ff       	call   8006cf <_panic>
  802607:	8b 15 44 50 80 00    	mov    0x805044,%edx
  80260d:	8b 45 08             	mov    0x8(%ebp),%eax
  802610:	89 50 04             	mov    %edx,0x4(%eax)
  802613:	8b 45 08             	mov    0x8(%ebp),%eax
  802616:	8b 40 04             	mov    0x4(%eax),%eax
  802619:	85 c0                	test   %eax,%eax
  80261b:	74 0c                	je     802629 <insert_sorted_allocList+0x179>
  80261d:	a1 44 50 80 00       	mov    0x805044,%eax
  802622:	8b 55 08             	mov    0x8(%ebp),%edx
  802625:	89 10                	mov    %edx,(%eax)
  802627:	eb 08                	jmp    802631 <insert_sorted_allocList+0x181>
  802629:	8b 45 08             	mov    0x8(%ebp),%eax
  80262c:	a3 40 50 80 00       	mov    %eax,0x805040
  802631:	8b 45 08             	mov    0x8(%ebp),%eax
  802634:	a3 44 50 80 00       	mov    %eax,0x805044
  802639:	8b 45 08             	mov    0x8(%ebp),%eax
  80263c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802642:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802647:	40                   	inc    %eax
  802648:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80264d:	e9 e7 00 00 00       	jmp    802739 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802652:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802655:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802658:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80265f:	a1 40 50 80 00       	mov    0x805040,%eax
  802664:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802667:	e9 9d 00 00 00       	jmp    802709 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  80266c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266f:	8b 00                	mov    (%eax),%eax
  802671:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802674:	8b 45 08             	mov    0x8(%ebp),%eax
  802677:	8b 50 08             	mov    0x8(%eax),%edx
  80267a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267d:	8b 40 08             	mov    0x8(%eax),%eax
  802680:	39 c2                	cmp    %eax,%edx
  802682:	76 7d                	jbe    802701 <insert_sorted_allocList+0x251>
  802684:	8b 45 08             	mov    0x8(%ebp),%eax
  802687:	8b 50 08             	mov    0x8(%eax),%edx
  80268a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80268d:	8b 40 08             	mov    0x8(%eax),%eax
  802690:	39 c2                	cmp    %eax,%edx
  802692:	73 6d                	jae    802701 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802694:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802698:	74 06                	je     8026a0 <insert_sorted_allocList+0x1f0>
  80269a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80269e:	75 14                	jne    8026b4 <insert_sorted_allocList+0x204>
  8026a0:	83 ec 04             	sub    $0x4,%esp
  8026a3:	68 b0 46 80 00       	push   $0x8046b0
  8026a8:	6a 7f                	push   $0x7f
  8026aa:	68 3b 46 80 00       	push   $0x80463b
  8026af:	e8 1b e0 ff ff       	call   8006cf <_panic>
  8026b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b7:	8b 10                	mov    (%eax),%edx
  8026b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8026bc:	89 10                	mov    %edx,(%eax)
  8026be:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c1:	8b 00                	mov    (%eax),%eax
  8026c3:	85 c0                	test   %eax,%eax
  8026c5:	74 0b                	je     8026d2 <insert_sorted_allocList+0x222>
  8026c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ca:	8b 00                	mov    (%eax),%eax
  8026cc:	8b 55 08             	mov    0x8(%ebp),%edx
  8026cf:	89 50 04             	mov    %edx,0x4(%eax)
  8026d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d5:	8b 55 08             	mov    0x8(%ebp),%edx
  8026d8:	89 10                	mov    %edx,(%eax)
  8026da:	8b 45 08             	mov    0x8(%ebp),%eax
  8026dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026e0:	89 50 04             	mov    %edx,0x4(%eax)
  8026e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8026e6:	8b 00                	mov    (%eax),%eax
  8026e8:	85 c0                	test   %eax,%eax
  8026ea:	75 08                	jne    8026f4 <insert_sorted_allocList+0x244>
  8026ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ef:	a3 44 50 80 00       	mov    %eax,0x805044
  8026f4:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8026f9:	40                   	inc    %eax
  8026fa:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  8026ff:	eb 39                	jmp    80273a <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802701:	a1 48 50 80 00       	mov    0x805048,%eax
  802706:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802709:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80270d:	74 07                	je     802716 <insert_sorted_allocList+0x266>
  80270f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802712:	8b 00                	mov    (%eax),%eax
  802714:	eb 05                	jmp    80271b <insert_sorted_allocList+0x26b>
  802716:	b8 00 00 00 00       	mov    $0x0,%eax
  80271b:	a3 48 50 80 00       	mov    %eax,0x805048
  802720:	a1 48 50 80 00       	mov    0x805048,%eax
  802725:	85 c0                	test   %eax,%eax
  802727:	0f 85 3f ff ff ff    	jne    80266c <insert_sorted_allocList+0x1bc>
  80272d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802731:	0f 85 35 ff ff ff    	jne    80266c <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802737:	eb 01                	jmp    80273a <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802739:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80273a:	90                   	nop
  80273b:	c9                   	leave  
  80273c:	c3                   	ret    

0080273d <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80273d:	55                   	push   %ebp
  80273e:	89 e5                	mov    %esp,%ebp
  802740:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802743:	a1 38 51 80 00       	mov    0x805138,%eax
  802748:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80274b:	e9 85 01 00 00       	jmp    8028d5 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802750:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802753:	8b 40 0c             	mov    0xc(%eax),%eax
  802756:	3b 45 08             	cmp    0x8(%ebp),%eax
  802759:	0f 82 6e 01 00 00    	jb     8028cd <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  80275f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802762:	8b 40 0c             	mov    0xc(%eax),%eax
  802765:	3b 45 08             	cmp    0x8(%ebp),%eax
  802768:	0f 85 8a 00 00 00    	jne    8027f8 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  80276e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802772:	75 17                	jne    80278b <alloc_block_FF+0x4e>
  802774:	83 ec 04             	sub    $0x4,%esp
  802777:	68 e4 46 80 00       	push   $0x8046e4
  80277c:	68 93 00 00 00       	push   $0x93
  802781:	68 3b 46 80 00       	push   $0x80463b
  802786:	e8 44 df ff ff       	call   8006cf <_panic>
  80278b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278e:	8b 00                	mov    (%eax),%eax
  802790:	85 c0                	test   %eax,%eax
  802792:	74 10                	je     8027a4 <alloc_block_FF+0x67>
  802794:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802797:	8b 00                	mov    (%eax),%eax
  802799:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80279c:	8b 52 04             	mov    0x4(%edx),%edx
  80279f:	89 50 04             	mov    %edx,0x4(%eax)
  8027a2:	eb 0b                	jmp    8027af <alloc_block_FF+0x72>
  8027a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a7:	8b 40 04             	mov    0x4(%eax),%eax
  8027aa:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8027af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b2:	8b 40 04             	mov    0x4(%eax),%eax
  8027b5:	85 c0                	test   %eax,%eax
  8027b7:	74 0f                	je     8027c8 <alloc_block_FF+0x8b>
  8027b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027bc:	8b 40 04             	mov    0x4(%eax),%eax
  8027bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027c2:	8b 12                	mov    (%edx),%edx
  8027c4:	89 10                	mov    %edx,(%eax)
  8027c6:	eb 0a                	jmp    8027d2 <alloc_block_FF+0x95>
  8027c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027cb:	8b 00                	mov    (%eax),%eax
  8027cd:	a3 38 51 80 00       	mov    %eax,0x805138
  8027d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027de:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027e5:	a1 44 51 80 00       	mov    0x805144,%eax
  8027ea:	48                   	dec    %eax
  8027eb:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  8027f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f3:	e9 10 01 00 00       	jmp    802908 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  8027f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027fb:	8b 40 0c             	mov    0xc(%eax),%eax
  8027fe:	3b 45 08             	cmp    0x8(%ebp),%eax
  802801:	0f 86 c6 00 00 00    	jbe    8028cd <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802807:	a1 48 51 80 00       	mov    0x805148,%eax
  80280c:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  80280f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802812:	8b 50 08             	mov    0x8(%eax),%edx
  802815:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802818:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  80281b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80281e:	8b 55 08             	mov    0x8(%ebp),%edx
  802821:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802824:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802828:	75 17                	jne    802841 <alloc_block_FF+0x104>
  80282a:	83 ec 04             	sub    $0x4,%esp
  80282d:	68 e4 46 80 00       	push   $0x8046e4
  802832:	68 9b 00 00 00       	push   $0x9b
  802837:	68 3b 46 80 00       	push   $0x80463b
  80283c:	e8 8e de ff ff       	call   8006cf <_panic>
  802841:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802844:	8b 00                	mov    (%eax),%eax
  802846:	85 c0                	test   %eax,%eax
  802848:	74 10                	je     80285a <alloc_block_FF+0x11d>
  80284a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80284d:	8b 00                	mov    (%eax),%eax
  80284f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802852:	8b 52 04             	mov    0x4(%edx),%edx
  802855:	89 50 04             	mov    %edx,0x4(%eax)
  802858:	eb 0b                	jmp    802865 <alloc_block_FF+0x128>
  80285a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80285d:	8b 40 04             	mov    0x4(%eax),%eax
  802860:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802865:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802868:	8b 40 04             	mov    0x4(%eax),%eax
  80286b:	85 c0                	test   %eax,%eax
  80286d:	74 0f                	je     80287e <alloc_block_FF+0x141>
  80286f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802872:	8b 40 04             	mov    0x4(%eax),%eax
  802875:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802878:	8b 12                	mov    (%edx),%edx
  80287a:	89 10                	mov    %edx,(%eax)
  80287c:	eb 0a                	jmp    802888 <alloc_block_FF+0x14b>
  80287e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802881:	8b 00                	mov    (%eax),%eax
  802883:	a3 48 51 80 00       	mov    %eax,0x805148
  802888:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80288b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802891:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802894:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80289b:	a1 54 51 80 00       	mov    0x805154,%eax
  8028a0:	48                   	dec    %eax
  8028a1:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  8028a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a9:	8b 50 08             	mov    0x8(%eax),%edx
  8028ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8028af:	01 c2                	add    %eax,%edx
  8028b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b4:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  8028b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ba:	8b 40 0c             	mov    0xc(%eax),%eax
  8028bd:	2b 45 08             	sub    0x8(%ebp),%eax
  8028c0:	89 c2                	mov    %eax,%edx
  8028c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c5:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  8028c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028cb:	eb 3b                	jmp    802908 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8028cd:	a1 40 51 80 00       	mov    0x805140,%eax
  8028d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028d5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028d9:	74 07                	je     8028e2 <alloc_block_FF+0x1a5>
  8028db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028de:	8b 00                	mov    (%eax),%eax
  8028e0:	eb 05                	jmp    8028e7 <alloc_block_FF+0x1aa>
  8028e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8028e7:	a3 40 51 80 00       	mov    %eax,0x805140
  8028ec:	a1 40 51 80 00       	mov    0x805140,%eax
  8028f1:	85 c0                	test   %eax,%eax
  8028f3:	0f 85 57 fe ff ff    	jne    802750 <alloc_block_FF+0x13>
  8028f9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028fd:	0f 85 4d fe ff ff    	jne    802750 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802903:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802908:	c9                   	leave  
  802909:	c3                   	ret    

0080290a <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  80290a:	55                   	push   %ebp
  80290b:	89 e5                	mov    %esp,%ebp
  80290d:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802910:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802917:	a1 38 51 80 00       	mov    0x805138,%eax
  80291c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80291f:	e9 df 00 00 00       	jmp    802a03 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802924:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802927:	8b 40 0c             	mov    0xc(%eax),%eax
  80292a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80292d:	0f 82 c8 00 00 00    	jb     8029fb <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802933:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802936:	8b 40 0c             	mov    0xc(%eax),%eax
  802939:	3b 45 08             	cmp    0x8(%ebp),%eax
  80293c:	0f 85 8a 00 00 00    	jne    8029cc <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802942:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802946:	75 17                	jne    80295f <alloc_block_BF+0x55>
  802948:	83 ec 04             	sub    $0x4,%esp
  80294b:	68 e4 46 80 00       	push   $0x8046e4
  802950:	68 b7 00 00 00       	push   $0xb7
  802955:	68 3b 46 80 00       	push   $0x80463b
  80295a:	e8 70 dd ff ff       	call   8006cf <_panic>
  80295f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802962:	8b 00                	mov    (%eax),%eax
  802964:	85 c0                	test   %eax,%eax
  802966:	74 10                	je     802978 <alloc_block_BF+0x6e>
  802968:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296b:	8b 00                	mov    (%eax),%eax
  80296d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802970:	8b 52 04             	mov    0x4(%edx),%edx
  802973:	89 50 04             	mov    %edx,0x4(%eax)
  802976:	eb 0b                	jmp    802983 <alloc_block_BF+0x79>
  802978:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297b:	8b 40 04             	mov    0x4(%eax),%eax
  80297e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802983:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802986:	8b 40 04             	mov    0x4(%eax),%eax
  802989:	85 c0                	test   %eax,%eax
  80298b:	74 0f                	je     80299c <alloc_block_BF+0x92>
  80298d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802990:	8b 40 04             	mov    0x4(%eax),%eax
  802993:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802996:	8b 12                	mov    (%edx),%edx
  802998:	89 10                	mov    %edx,(%eax)
  80299a:	eb 0a                	jmp    8029a6 <alloc_block_BF+0x9c>
  80299c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299f:	8b 00                	mov    (%eax),%eax
  8029a1:	a3 38 51 80 00       	mov    %eax,0x805138
  8029a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029b9:	a1 44 51 80 00       	mov    0x805144,%eax
  8029be:	48                   	dec    %eax
  8029bf:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  8029c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c7:	e9 4d 01 00 00       	jmp    802b19 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  8029cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029cf:	8b 40 0c             	mov    0xc(%eax),%eax
  8029d2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029d5:	76 24                	jbe    8029fb <alloc_block_BF+0xf1>
  8029d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029da:	8b 40 0c             	mov    0xc(%eax),%eax
  8029dd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8029e0:	73 19                	jae    8029fb <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  8029e2:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  8029e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ec:	8b 40 0c             	mov    0xc(%eax),%eax
  8029ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  8029f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f5:	8b 40 08             	mov    0x8(%eax),%eax
  8029f8:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8029fb:	a1 40 51 80 00       	mov    0x805140,%eax
  802a00:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a03:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a07:	74 07                	je     802a10 <alloc_block_BF+0x106>
  802a09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0c:	8b 00                	mov    (%eax),%eax
  802a0e:	eb 05                	jmp    802a15 <alloc_block_BF+0x10b>
  802a10:	b8 00 00 00 00       	mov    $0x0,%eax
  802a15:	a3 40 51 80 00       	mov    %eax,0x805140
  802a1a:	a1 40 51 80 00       	mov    0x805140,%eax
  802a1f:	85 c0                	test   %eax,%eax
  802a21:	0f 85 fd fe ff ff    	jne    802924 <alloc_block_BF+0x1a>
  802a27:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a2b:	0f 85 f3 fe ff ff    	jne    802924 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802a31:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802a35:	0f 84 d9 00 00 00    	je     802b14 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802a3b:	a1 48 51 80 00       	mov    0x805148,%eax
  802a40:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802a43:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a46:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a49:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802a4c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a4f:	8b 55 08             	mov    0x8(%ebp),%edx
  802a52:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802a55:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802a59:	75 17                	jne    802a72 <alloc_block_BF+0x168>
  802a5b:	83 ec 04             	sub    $0x4,%esp
  802a5e:	68 e4 46 80 00       	push   $0x8046e4
  802a63:	68 c7 00 00 00       	push   $0xc7
  802a68:	68 3b 46 80 00       	push   $0x80463b
  802a6d:	e8 5d dc ff ff       	call   8006cf <_panic>
  802a72:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a75:	8b 00                	mov    (%eax),%eax
  802a77:	85 c0                	test   %eax,%eax
  802a79:	74 10                	je     802a8b <alloc_block_BF+0x181>
  802a7b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a7e:	8b 00                	mov    (%eax),%eax
  802a80:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802a83:	8b 52 04             	mov    0x4(%edx),%edx
  802a86:	89 50 04             	mov    %edx,0x4(%eax)
  802a89:	eb 0b                	jmp    802a96 <alloc_block_BF+0x18c>
  802a8b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a8e:	8b 40 04             	mov    0x4(%eax),%eax
  802a91:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802a96:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a99:	8b 40 04             	mov    0x4(%eax),%eax
  802a9c:	85 c0                	test   %eax,%eax
  802a9e:	74 0f                	je     802aaf <alloc_block_BF+0x1a5>
  802aa0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802aa3:	8b 40 04             	mov    0x4(%eax),%eax
  802aa6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802aa9:	8b 12                	mov    (%edx),%edx
  802aab:	89 10                	mov    %edx,(%eax)
  802aad:	eb 0a                	jmp    802ab9 <alloc_block_BF+0x1af>
  802aaf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ab2:	8b 00                	mov    (%eax),%eax
  802ab4:	a3 48 51 80 00       	mov    %eax,0x805148
  802ab9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802abc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ac2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ac5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802acc:	a1 54 51 80 00       	mov    0x805154,%eax
  802ad1:	48                   	dec    %eax
  802ad2:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802ad7:	83 ec 08             	sub    $0x8,%esp
  802ada:	ff 75 ec             	pushl  -0x14(%ebp)
  802add:	68 38 51 80 00       	push   $0x805138
  802ae2:	e8 71 f9 ff ff       	call   802458 <find_block>
  802ae7:	83 c4 10             	add    $0x10,%esp
  802aea:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802aed:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802af0:	8b 50 08             	mov    0x8(%eax),%edx
  802af3:	8b 45 08             	mov    0x8(%ebp),%eax
  802af6:	01 c2                	add    %eax,%edx
  802af8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802afb:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802afe:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b01:	8b 40 0c             	mov    0xc(%eax),%eax
  802b04:	2b 45 08             	sub    0x8(%ebp),%eax
  802b07:	89 c2                	mov    %eax,%edx
  802b09:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b0c:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802b0f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b12:	eb 05                	jmp    802b19 <alloc_block_BF+0x20f>
	}
	return NULL;
  802b14:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b19:	c9                   	leave  
  802b1a:	c3                   	ret    

00802b1b <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802b1b:	55                   	push   %ebp
  802b1c:	89 e5                	mov    %esp,%ebp
  802b1e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802b21:	a1 28 50 80 00       	mov    0x805028,%eax
  802b26:	85 c0                	test   %eax,%eax
  802b28:	0f 85 de 01 00 00    	jne    802d0c <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802b2e:	a1 38 51 80 00       	mov    0x805138,%eax
  802b33:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b36:	e9 9e 01 00 00       	jmp    802cd9 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802b3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b3e:	8b 40 0c             	mov    0xc(%eax),%eax
  802b41:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b44:	0f 82 87 01 00 00    	jb     802cd1 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802b4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4d:	8b 40 0c             	mov    0xc(%eax),%eax
  802b50:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b53:	0f 85 95 00 00 00    	jne    802bee <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802b59:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b5d:	75 17                	jne    802b76 <alloc_block_NF+0x5b>
  802b5f:	83 ec 04             	sub    $0x4,%esp
  802b62:	68 e4 46 80 00       	push   $0x8046e4
  802b67:	68 e0 00 00 00       	push   $0xe0
  802b6c:	68 3b 46 80 00       	push   $0x80463b
  802b71:	e8 59 db ff ff       	call   8006cf <_panic>
  802b76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b79:	8b 00                	mov    (%eax),%eax
  802b7b:	85 c0                	test   %eax,%eax
  802b7d:	74 10                	je     802b8f <alloc_block_NF+0x74>
  802b7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b82:	8b 00                	mov    (%eax),%eax
  802b84:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b87:	8b 52 04             	mov    0x4(%edx),%edx
  802b8a:	89 50 04             	mov    %edx,0x4(%eax)
  802b8d:	eb 0b                	jmp    802b9a <alloc_block_NF+0x7f>
  802b8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b92:	8b 40 04             	mov    0x4(%eax),%eax
  802b95:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802b9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9d:	8b 40 04             	mov    0x4(%eax),%eax
  802ba0:	85 c0                	test   %eax,%eax
  802ba2:	74 0f                	je     802bb3 <alloc_block_NF+0x98>
  802ba4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba7:	8b 40 04             	mov    0x4(%eax),%eax
  802baa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bad:	8b 12                	mov    (%edx),%edx
  802baf:	89 10                	mov    %edx,(%eax)
  802bb1:	eb 0a                	jmp    802bbd <alloc_block_NF+0xa2>
  802bb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb6:	8b 00                	mov    (%eax),%eax
  802bb8:	a3 38 51 80 00       	mov    %eax,0x805138
  802bbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bd0:	a1 44 51 80 00       	mov    0x805144,%eax
  802bd5:	48                   	dec    %eax
  802bd6:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802bdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bde:	8b 40 08             	mov    0x8(%eax),%eax
  802be1:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  802be6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be9:	e9 f8 04 00 00       	jmp    8030e6 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802bee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf1:	8b 40 0c             	mov    0xc(%eax),%eax
  802bf4:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bf7:	0f 86 d4 00 00 00    	jbe    802cd1 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802bfd:	a1 48 51 80 00       	mov    0x805148,%eax
  802c02:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802c05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c08:	8b 50 08             	mov    0x8(%eax),%edx
  802c0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c0e:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802c11:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c14:	8b 55 08             	mov    0x8(%ebp),%edx
  802c17:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802c1a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c1e:	75 17                	jne    802c37 <alloc_block_NF+0x11c>
  802c20:	83 ec 04             	sub    $0x4,%esp
  802c23:	68 e4 46 80 00       	push   $0x8046e4
  802c28:	68 e9 00 00 00       	push   $0xe9
  802c2d:	68 3b 46 80 00       	push   $0x80463b
  802c32:	e8 98 da ff ff       	call   8006cf <_panic>
  802c37:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c3a:	8b 00                	mov    (%eax),%eax
  802c3c:	85 c0                	test   %eax,%eax
  802c3e:	74 10                	je     802c50 <alloc_block_NF+0x135>
  802c40:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c43:	8b 00                	mov    (%eax),%eax
  802c45:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c48:	8b 52 04             	mov    0x4(%edx),%edx
  802c4b:	89 50 04             	mov    %edx,0x4(%eax)
  802c4e:	eb 0b                	jmp    802c5b <alloc_block_NF+0x140>
  802c50:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c53:	8b 40 04             	mov    0x4(%eax),%eax
  802c56:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802c5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c5e:	8b 40 04             	mov    0x4(%eax),%eax
  802c61:	85 c0                	test   %eax,%eax
  802c63:	74 0f                	je     802c74 <alloc_block_NF+0x159>
  802c65:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c68:	8b 40 04             	mov    0x4(%eax),%eax
  802c6b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c6e:	8b 12                	mov    (%edx),%edx
  802c70:	89 10                	mov    %edx,(%eax)
  802c72:	eb 0a                	jmp    802c7e <alloc_block_NF+0x163>
  802c74:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c77:	8b 00                	mov    (%eax),%eax
  802c79:	a3 48 51 80 00       	mov    %eax,0x805148
  802c7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c81:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c87:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c8a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c91:	a1 54 51 80 00       	mov    0x805154,%eax
  802c96:	48                   	dec    %eax
  802c97:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802c9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c9f:	8b 40 08             	mov    0x8(%eax),%eax
  802ca2:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802ca7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802caa:	8b 50 08             	mov    0x8(%eax),%edx
  802cad:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb0:	01 c2                	add    %eax,%edx
  802cb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb5:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802cb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cbb:	8b 40 0c             	mov    0xc(%eax),%eax
  802cbe:	2b 45 08             	sub    0x8(%ebp),%eax
  802cc1:	89 c2                	mov    %eax,%edx
  802cc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc6:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802cc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ccc:	e9 15 04 00 00       	jmp    8030e6 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802cd1:	a1 40 51 80 00       	mov    0x805140,%eax
  802cd6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cd9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cdd:	74 07                	je     802ce6 <alloc_block_NF+0x1cb>
  802cdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce2:	8b 00                	mov    (%eax),%eax
  802ce4:	eb 05                	jmp    802ceb <alloc_block_NF+0x1d0>
  802ce6:	b8 00 00 00 00       	mov    $0x0,%eax
  802ceb:	a3 40 51 80 00       	mov    %eax,0x805140
  802cf0:	a1 40 51 80 00       	mov    0x805140,%eax
  802cf5:	85 c0                	test   %eax,%eax
  802cf7:	0f 85 3e fe ff ff    	jne    802b3b <alloc_block_NF+0x20>
  802cfd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d01:	0f 85 34 fe ff ff    	jne    802b3b <alloc_block_NF+0x20>
  802d07:	e9 d5 03 00 00       	jmp    8030e1 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802d0c:	a1 38 51 80 00       	mov    0x805138,%eax
  802d11:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d14:	e9 b1 01 00 00       	jmp    802eca <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802d19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d1c:	8b 50 08             	mov    0x8(%eax),%edx
  802d1f:	a1 28 50 80 00       	mov    0x805028,%eax
  802d24:	39 c2                	cmp    %eax,%edx
  802d26:	0f 82 96 01 00 00    	jb     802ec2 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802d2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d2f:	8b 40 0c             	mov    0xc(%eax),%eax
  802d32:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d35:	0f 82 87 01 00 00    	jb     802ec2 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802d3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3e:	8b 40 0c             	mov    0xc(%eax),%eax
  802d41:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d44:	0f 85 95 00 00 00    	jne    802ddf <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802d4a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d4e:	75 17                	jne    802d67 <alloc_block_NF+0x24c>
  802d50:	83 ec 04             	sub    $0x4,%esp
  802d53:	68 e4 46 80 00       	push   $0x8046e4
  802d58:	68 fc 00 00 00       	push   $0xfc
  802d5d:	68 3b 46 80 00       	push   $0x80463b
  802d62:	e8 68 d9 ff ff       	call   8006cf <_panic>
  802d67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d6a:	8b 00                	mov    (%eax),%eax
  802d6c:	85 c0                	test   %eax,%eax
  802d6e:	74 10                	je     802d80 <alloc_block_NF+0x265>
  802d70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d73:	8b 00                	mov    (%eax),%eax
  802d75:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d78:	8b 52 04             	mov    0x4(%edx),%edx
  802d7b:	89 50 04             	mov    %edx,0x4(%eax)
  802d7e:	eb 0b                	jmp    802d8b <alloc_block_NF+0x270>
  802d80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d83:	8b 40 04             	mov    0x4(%eax),%eax
  802d86:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d8e:	8b 40 04             	mov    0x4(%eax),%eax
  802d91:	85 c0                	test   %eax,%eax
  802d93:	74 0f                	je     802da4 <alloc_block_NF+0x289>
  802d95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d98:	8b 40 04             	mov    0x4(%eax),%eax
  802d9b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d9e:	8b 12                	mov    (%edx),%edx
  802da0:	89 10                	mov    %edx,(%eax)
  802da2:	eb 0a                	jmp    802dae <alloc_block_NF+0x293>
  802da4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da7:	8b 00                	mov    (%eax),%eax
  802da9:	a3 38 51 80 00       	mov    %eax,0x805138
  802dae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802db7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dba:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dc1:	a1 44 51 80 00       	mov    0x805144,%eax
  802dc6:	48                   	dec    %eax
  802dc7:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802dcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dcf:	8b 40 08             	mov    0x8(%eax),%eax
  802dd2:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802dd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dda:	e9 07 03 00 00       	jmp    8030e6 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802ddf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de2:	8b 40 0c             	mov    0xc(%eax),%eax
  802de5:	3b 45 08             	cmp    0x8(%ebp),%eax
  802de8:	0f 86 d4 00 00 00    	jbe    802ec2 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802dee:	a1 48 51 80 00       	mov    0x805148,%eax
  802df3:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802df6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df9:	8b 50 08             	mov    0x8(%eax),%edx
  802dfc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dff:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802e02:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e05:	8b 55 08             	mov    0x8(%ebp),%edx
  802e08:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802e0b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802e0f:	75 17                	jne    802e28 <alloc_block_NF+0x30d>
  802e11:	83 ec 04             	sub    $0x4,%esp
  802e14:	68 e4 46 80 00       	push   $0x8046e4
  802e19:	68 04 01 00 00       	push   $0x104
  802e1e:	68 3b 46 80 00       	push   $0x80463b
  802e23:	e8 a7 d8 ff ff       	call   8006cf <_panic>
  802e28:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e2b:	8b 00                	mov    (%eax),%eax
  802e2d:	85 c0                	test   %eax,%eax
  802e2f:	74 10                	je     802e41 <alloc_block_NF+0x326>
  802e31:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e34:	8b 00                	mov    (%eax),%eax
  802e36:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e39:	8b 52 04             	mov    0x4(%edx),%edx
  802e3c:	89 50 04             	mov    %edx,0x4(%eax)
  802e3f:	eb 0b                	jmp    802e4c <alloc_block_NF+0x331>
  802e41:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e44:	8b 40 04             	mov    0x4(%eax),%eax
  802e47:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e4c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e4f:	8b 40 04             	mov    0x4(%eax),%eax
  802e52:	85 c0                	test   %eax,%eax
  802e54:	74 0f                	je     802e65 <alloc_block_NF+0x34a>
  802e56:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e59:	8b 40 04             	mov    0x4(%eax),%eax
  802e5c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e5f:	8b 12                	mov    (%edx),%edx
  802e61:	89 10                	mov    %edx,(%eax)
  802e63:	eb 0a                	jmp    802e6f <alloc_block_NF+0x354>
  802e65:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e68:	8b 00                	mov    (%eax),%eax
  802e6a:	a3 48 51 80 00       	mov    %eax,0x805148
  802e6f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e72:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e78:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e7b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e82:	a1 54 51 80 00       	mov    0x805154,%eax
  802e87:	48                   	dec    %eax
  802e88:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802e8d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e90:	8b 40 08             	mov    0x8(%eax),%eax
  802e93:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802e98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e9b:	8b 50 08             	mov    0x8(%eax),%edx
  802e9e:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea1:	01 c2                	add    %eax,%edx
  802ea3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea6:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802ea9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eac:	8b 40 0c             	mov    0xc(%eax),%eax
  802eaf:	2b 45 08             	sub    0x8(%ebp),%eax
  802eb2:	89 c2                	mov    %eax,%edx
  802eb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb7:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802eba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ebd:	e9 24 02 00 00       	jmp    8030e6 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802ec2:	a1 40 51 80 00       	mov    0x805140,%eax
  802ec7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802eca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ece:	74 07                	je     802ed7 <alloc_block_NF+0x3bc>
  802ed0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed3:	8b 00                	mov    (%eax),%eax
  802ed5:	eb 05                	jmp    802edc <alloc_block_NF+0x3c1>
  802ed7:	b8 00 00 00 00       	mov    $0x0,%eax
  802edc:	a3 40 51 80 00       	mov    %eax,0x805140
  802ee1:	a1 40 51 80 00       	mov    0x805140,%eax
  802ee6:	85 c0                	test   %eax,%eax
  802ee8:	0f 85 2b fe ff ff    	jne    802d19 <alloc_block_NF+0x1fe>
  802eee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ef2:	0f 85 21 fe ff ff    	jne    802d19 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802ef8:	a1 38 51 80 00       	mov    0x805138,%eax
  802efd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f00:	e9 ae 01 00 00       	jmp    8030b3 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802f05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f08:	8b 50 08             	mov    0x8(%eax),%edx
  802f0b:	a1 28 50 80 00       	mov    0x805028,%eax
  802f10:	39 c2                	cmp    %eax,%edx
  802f12:	0f 83 93 01 00 00    	jae    8030ab <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802f18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f1b:	8b 40 0c             	mov    0xc(%eax),%eax
  802f1e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f21:	0f 82 84 01 00 00    	jb     8030ab <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802f27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f2a:	8b 40 0c             	mov    0xc(%eax),%eax
  802f2d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f30:	0f 85 95 00 00 00    	jne    802fcb <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802f36:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f3a:	75 17                	jne    802f53 <alloc_block_NF+0x438>
  802f3c:	83 ec 04             	sub    $0x4,%esp
  802f3f:	68 e4 46 80 00       	push   $0x8046e4
  802f44:	68 14 01 00 00       	push   $0x114
  802f49:	68 3b 46 80 00       	push   $0x80463b
  802f4e:	e8 7c d7 ff ff       	call   8006cf <_panic>
  802f53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f56:	8b 00                	mov    (%eax),%eax
  802f58:	85 c0                	test   %eax,%eax
  802f5a:	74 10                	je     802f6c <alloc_block_NF+0x451>
  802f5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f5f:	8b 00                	mov    (%eax),%eax
  802f61:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f64:	8b 52 04             	mov    0x4(%edx),%edx
  802f67:	89 50 04             	mov    %edx,0x4(%eax)
  802f6a:	eb 0b                	jmp    802f77 <alloc_block_NF+0x45c>
  802f6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f6f:	8b 40 04             	mov    0x4(%eax),%eax
  802f72:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f7a:	8b 40 04             	mov    0x4(%eax),%eax
  802f7d:	85 c0                	test   %eax,%eax
  802f7f:	74 0f                	je     802f90 <alloc_block_NF+0x475>
  802f81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f84:	8b 40 04             	mov    0x4(%eax),%eax
  802f87:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f8a:	8b 12                	mov    (%edx),%edx
  802f8c:	89 10                	mov    %edx,(%eax)
  802f8e:	eb 0a                	jmp    802f9a <alloc_block_NF+0x47f>
  802f90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f93:	8b 00                	mov    (%eax),%eax
  802f95:	a3 38 51 80 00       	mov    %eax,0x805138
  802f9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f9d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fa3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fad:	a1 44 51 80 00       	mov    0x805144,%eax
  802fb2:	48                   	dec    %eax
  802fb3:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802fb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fbb:	8b 40 08             	mov    0x8(%eax),%eax
  802fbe:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802fc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc6:	e9 1b 01 00 00       	jmp    8030e6 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802fcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fce:	8b 40 0c             	mov    0xc(%eax),%eax
  802fd1:	3b 45 08             	cmp    0x8(%ebp),%eax
  802fd4:	0f 86 d1 00 00 00    	jbe    8030ab <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802fda:	a1 48 51 80 00       	mov    0x805148,%eax
  802fdf:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802fe2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe5:	8b 50 08             	mov    0x8(%eax),%edx
  802fe8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802feb:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802fee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ff1:	8b 55 08             	mov    0x8(%ebp),%edx
  802ff4:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802ff7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802ffb:	75 17                	jne    803014 <alloc_block_NF+0x4f9>
  802ffd:	83 ec 04             	sub    $0x4,%esp
  803000:	68 e4 46 80 00       	push   $0x8046e4
  803005:	68 1c 01 00 00       	push   $0x11c
  80300a:	68 3b 46 80 00       	push   $0x80463b
  80300f:	e8 bb d6 ff ff       	call   8006cf <_panic>
  803014:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803017:	8b 00                	mov    (%eax),%eax
  803019:	85 c0                	test   %eax,%eax
  80301b:	74 10                	je     80302d <alloc_block_NF+0x512>
  80301d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803020:	8b 00                	mov    (%eax),%eax
  803022:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803025:	8b 52 04             	mov    0x4(%edx),%edx
  803028:	89 50 04             	mov    %edx,0x4(%eax)
  80302b:	eb 0b                	jmp    803038 <alloc_block_NF+0x51d>
  80302d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803030:	8b 40 04             	mov    0x4(%eax),%eax
  803033:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803038:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80303b:	8b 40 04             	mov    0x4(%eax),%eax
  80303e:	85 c0                	test   %eax,%eax
  803040:	74 0f                	je     803051 <alloc_block_NF+0x536>
  803042:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803045:	8b 40 04             	mov    0x4(%eax),%eax
  803048:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80304b:	8b 12                	mov    (%edx),%edx
  80304d:	89 10                	mov    %edx,(%eax)
  80304f:	eb 0a                	jmp    80305b <alloc_block_NF+0x540>
  803051:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803054:	8b 00                	mov    (%eax),%eax
  803056:	a3 48 51 80 00       	mov    %eax,0x805148
  80305b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80305e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803064:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803067:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80306e:	a1 54 51 80 00       	mov    0x805154,%eax
  803073:	48                   	dec    %eax
  803074:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  803079:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80307c:	8b 40 08             	mov    0x8(%eax),%eax
  80307f:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  803084:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803087:	8b 50 08             	mov    0x8(%eax),%edx
  80308a:	8b 45 08             	mov    0x8(%ebp),%eax
  80308d:	01 c2                	add    %eax,%edx
  80308f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803092:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  803095:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803098:	8b 40 0c             	mov    0xc(%eax),%eax
  80309b:	2b 45 08             	sub    0x8(%ebp),%eax
  80309e:	89 c2                	mov    %eax,%edx
  8030a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a3:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  8030a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030a9:	eb 3b                	jmp    8030e6 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  8030ab:	a1 40 51 80 00       	mov    0x805140,%eax
  8030b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030b7:	74 07                	je     8030c0 <alloc_block_NF+0x5a5>
  8030b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030bc:	8b 00                	mov    (%eax),%eax
  8030be:	eb 05                	jmp    8030c5 <alloc_block_NF+0x5aa>
  8030c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8030c5:	a3 40 51 80 00       	mov    %eax,0x805140
  8030ca:	a1 40 51 80 00       	mov    0x805140,%eax
  8030cf:	85 c0                	test   %eax,%eax
  8030d1:	0f 85 2e fe ff ff    	jne    802f05 <alloc_block_NF+0x3ea>
  8030d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030db:	0f 85 24 fe ff ff    	jne    802f05 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  8030e1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8030e6:	c9                   	leave  
  8030e7:	c3                   	ret    

008030e8 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  8030e8:	55                   	push   %ebp
  8030e9:	89 e5                	mov    %esp,%ebp
  8030eb:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  8030ee:	a1 38 51 80 00       	mov    0x805138,%eax
  8030f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  8030f6:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8030fb:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  8030fe:	a1 38 51 80 00       	mov    0x805138,%eax
  803103:	85 c0                	test   %eax,%eax
  803105:	74 14                	je     80311b <insert_sorted_with_merge_freeList+0x33>
  803107:	8b 45 08             	mov    0x8(%ebp),%eax
  80310a:	8b 50 08             	mov    0x8(%eax),%edx
  80310d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803110:	8b 40 08             	mov    0x8(%eax),%eax
  803113:	39 c2                	cmp    %eax,%edx
  803115:	0f 87 9b 01 00 00    	ja     8032b6 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  80311b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80311f:	75 17                	jne    803138 <insert_sorted_with_merge_freeList+0x50>
  803121:	83 ec 04             	sub    $0x4,%esp
  803124:	68 18 46 80 00       	push   $0x804618
  803129:	68 38 01 00 00       	push   $0x138
  80312e:	68 3b 46 80 00       	push   $0x80463b
  803133:	e8 97 d5 ff ff       	call   8006cf <_panic>
  803138:	8b 15 38 51 80 00    	mov    0x805138,%edx
  80313e:	8b 45 08             	mov    0x8(%ebp),%eax
  803141:	89 10                	mov    %edx,(%eax)
  803143:	8b 45 08             	mov    0x8(%ebp),%eax
  803146:	8b 00                	mov    (%eax),%eax
  803148:	85 c0                	test   %eax,%eax
  80314a:	74 0d                	je     803159 <insert_sorted_with_merge_freeList+0x71>
  80314c:	a1 38 51 80 00       	mov    0x805138,%eax
  803151:	8b 55 08             	mov    0x8(%ebp),%edx
  803154:	89 50 04             	mov    %edx,0x4(%eax)
  803157:	eb 08                	jmp    803161 <insert_sorted_with_merge_freeList+0x79>
  803159:	8b 45 08             	mov    0x8(%ebp),%eax
  80315c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803161:	8b 45 08             	mov    0x8(%ebp),%eax
  803164:	a3 38 51 80 00       	mov    %eax,0x805138
  803169:	8b 45 08             	mov    0x8(%ebp),%eax
  80316c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803173:	a1 44 51 80 00       	mov    0x805144,%eax
  803178:	40                   	inc    %eax
  803179:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80317e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803182:	0f 84 a8 06 00 00    	je     803830 <insert_sorted_with_merge_freeList+0x748>
  803188:	8b 45 08             	mov    0x8(%ebp),%eax
  80318b:	8b 50 08             	mov    0x8(%eax),%edx
  80318e:	8b 45 08             	mov    0x8(%ebp),%eax
  803191:	8b 40 0c             	mov    0xc(%eax),%eax
  803194:	01 c2                	add    %eax,%edx
  803196:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803199:	8b 40 08             	mov    0x8(%eax),%eax
  80319c:	39 c2                	cmp    %eax,%edx
  80319e:	0f 85 8c 06 00 00    	jne    803830 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  8031a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a7:	8b 50 0c             	mov    0xc(%eax),%edx
  8031aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031ad:	8b 40 0c             	mov    0xc(%eax),%eax
  8031b0:	01 c2                	add    %eax,%edx
  8031b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b5:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  8031b8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8031bc:	75 17                	jne    8031d5 <insert_sorted_with_merge_freeList+0xed>
  8031be:	83 ec 04             	sub    $0x4,%esp
  8031c1:	68 e4 46 80 00       	push   $0x8046e4
  8031c6:	68 3c 01 00 00       	push   $0x13c
  8031cb:	68 3b 46 80 00       	push   $0x80463b
  8031d0:	e8 fa d4 ff ff       	call   8006cf <_panic>
  8031d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031d8:	8b 00                	mov    (%eax),%eax
  8031da:	85 c0                	test   %eax,%eax
  8031dc:	74 10                	je     8031ee <insert_sorted_with_merge_freeList+0x106>
  8031de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031e1:	8b 00                	mov    (%eax),%eax
  8031e3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031e6:	8b 52 04             	mov    0x4(%edx),%edx
  8031e9:	89 50 04             	mov    %edx,0x4(%eax)
  8031ec:	eb 0b                	jmp    8031f9 <insert_sorted_with_merge_freeList+0x111>
  8031ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031f1:	8b 40 04             	mov    0x4(%eax),%eax
  8031f4:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8031f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031fc:	8b 40 04             	mov    0x4(%eax),%eax
  8031ff:	85 c0                	test   %eax,%eax
  803201:	74 0f                	je     803212 <insert_sorted_with_merge_freeList+0x12a>
  803203:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803206:	8b 40 04             	mov    0x4(%eax),%eax
  803209:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80320c:	8b 12                	mov    (%edx),%edx
  80320e:	89 10                	mov    %edx,(%eax)
  803210:	eb 0a                	jmp    80321c <insert_sorted_with_merge_freeList+0x134>
  803212:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803215:	8b 00                	mov    (%eax),%eax
  803217:	a3 38 51 80 00       	mov    %eax,0x805138
  80321c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80321f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803225:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803228:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80322f:	a1 44 51 80 00       	mov    0x805144,%eax
  803234:	48                   	dec    %eax
  803235:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  80323a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80323d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  803244:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803247:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  80324e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803252:	75 17                	jne    80326b <insert_sorted_with_merge_freeList+0x183>
  803254:	83 ec 04             	sub    $0x4,%esp
  803257:	68 18 46 80 00       	push   $0x804618
  80325c:	68 3f 01 00 00       	push   $0x13f
  803261:	68 3b 46 80 00       	push   $0x80463b
  803266:	e8 64 d4 ff ff       	call   8006cf <_panic>
  80326b:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803271:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803274:	89 10                	mov    %edx,(%eax)
  803276:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803279:	8b 00                	mov    (%eax),%eax
  80327b:	85 c0                	test   %eax,%eax
  80327d:	74 0d                	je     80328c <insert_sorted_with_merge_freeList+0x1a4>
  80327f:	a1 48 51 80 00       	mov    0x805148,%eax
  803284:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803287:	89 50 04             	mov    %edx,0x4(%eax)
  80328a:	eb 08                	jmp    803294 <insert_sorted_with_merge_freeList+0x1ac>
  80328c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80328f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803294:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803297:	a3 48 51 80 00       	mov    %eax,0x805148
  80329c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80329f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032a6:	a1 54 51 80 00       	mov    0x805154,%eax
  8032ab:	40                   	inc    %eax
  8032ac:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8032b1:	e9 7a 05 00 00       	jmp    803830 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  8032b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b9:	8b 50 08             	mov    0x8(%eax),%edx
  8032bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032bf:	8b 40 08             	mov    0x8(%eax),%eax
  8032c2:	39 c2                	cmp    %eax,%edx
  8032c4:	0f 82 14 01 00 00    	jb     8033de <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  8032ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032cd:	8b 50 08             	mov    0x8(%eax),%edx
  8032d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032d3:	8b 40 0c             	mov    0xc(%eax),%eax
  8032d6:	01 c2                	add    %eax,%edx
  8032d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8032db:	8b 40 08             	mov    0x8(%eax),%eax
  8032de:	39 c2                	cmp    %eax,%edx
  8032e0:	0f 85 90 00 00 00    	jne    803376 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  8032e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032e9:	8b 50 0c             	mov    0xc(%eax),%edx
  8032ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ef:	8b 40 0c             	mov    0xc(%eax),%eax
  8032f2:	01 c2                	add    %eax,%edx
  8032f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032f7:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  8032fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8032fd:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  803304:	8b 45 08             	mov    0x8(%ebp),%eax
  803307:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80330e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803312:	75 17                	jne    80332b <insert_sorted_with_merge_freeList+0x243>
  803314:	83 ec 04             	sub    $0x4,%esp
  803317:	68 18 46 80 00       	push   $0x804618
  80331c:	68 49 01 00 00       	push   $0x149
  803321:	68 3b 46 80 00       	push   $0x80463b
  803326:	e8 a4 d3 ff ff       	call   8006cf <_panic>
  80332b:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803331:	8b 45 08             	mov    0x8(%ebp),%eax
  803334:	89 10                	mov    %edx,(%eax)
  803336:	8b 45 08             	mov    0x8(%ebp),%eax
  803339:	8b 00                	mov    (%eax),%eax
  80333b:	85 c0                	test   %eax,%eax
  80333d:	74 0d                	je     80334c <insert_sorted_with_merge_freeList+0x264>
  80333f:	a1 48 51 80 00       	mov    0x805148,%eax
  803344:	8b 55 08             	mov    0x8(%ebp),%edx
  803347:	89 50 04             	mov    %edx,0x4(%eax)
  80334a:	eb 08                	jmp    803354 <insert_sorted_with_merge_freeList+0x26c>
  80334c:	8b 45 08             	mov    0x8(%ebp),%eax
  80334f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803354:	8b 45 08             	mov    0x8(%ebp),%eax
  803357:	a3 48 51 80 00       	mov    %eax,0x805148
  80335c:	8b 45 08             	mov    0x8(%ebp),%eax
  80335f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803366:	a1 54 51 80 00       	mov    0x805154,%eax
  80336b:	40                   	inc    %eax
  80336c:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803371:	e9 bb 04 00 00       	jmp    803831 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  803376:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80337a:	75 17                	jne    803393 <insert_sorted_with_merge_freeList+0x2ab>
  80337c:	83 ec 04             	sub    $0x4,%esp
  80337f:	68 8c 46 80 00       	push   $0x80468c
  803384:	68 4c 01 00 00       	push   $0x14c
  803389:	68 3b 46 80 00       	push   $0x80463b
  80338e:	e8 3c d3 ff ff       	call   8006cf <_panic>
  803393:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803399:	8b 45 08             	mov    0x8(%ebp),%eax
  80339c:	89 50 04             	mov    %edx,0x4(%eax)
  80339f:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a2:	8b 40 04             	mov    0x4(%eax),%eax
  8033a5:	85 c0                	test   %eax,%eax
  8033a7:	74 0c                	je     8033b5 <insert_sorted_with_merge_freeList+0x2cd>
  8033a9:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8033ae:	8b 55 08             	mov    0x8(%ebp),%edx
  8033b1:	89 10                	mov    %edx,(%eax)
  8033b3:	eb 08                	jmp    8033bd <insert_sorted_with_merge_freeList+0x2d5>
  8033b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b8:	a3 38 51 80 00       	mov    %eax,0x805138
  8033bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c0:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8033c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033ce:	a1 44 51 80 00       	mov    0x805144,%eax
  8033d3:	40                   	inc    %eax
  8033d4:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8033d9:	e9 53 04 00 00       	jmp    803831 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8033de:	a1 38 51 80 00       	mov    0x805138,%eax
  8033e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033e6:	e9 15 04 00 00       	jmp    803800 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  8033eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033ee:	8b 00                	mov    (%eax),%eax
  8033f0:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  8033f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f6:	8b 50 08             	mov    0x8(%eax),%edx
  8033f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033fc:	8b 40 08             	mov    0x8(%eax),%eax
  8033ff:	39 c2                	cmp    %eax,%edx
  803401:	0f 86 f1 03 00 00    	jbe    8037f8 <insert_sorted_with_merge_freeList+0x710>
  803407:	8b 45 08             	mov    0x8(%ebp),%eax
  80340a:	8b 50 08             	mov    0x8(%eax),%edx
  80340d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803410:	8b 40 08             	mov    0x8(%eax),%eax
  803413:	39 c2                	cmp    %eax,%edx
  803415:	0f 83 dd 03 00 00    	jae    8037f8 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  80341b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80341e:	8b 50 08             	mov    0x8(%eax),%edx
  803421:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803424:	8b 40 0c             	mov    0xc(%eax),%eax
  803427:	01 c2                	add    %eax,%edx
  803429:	8b 45 08             	mov    0x8(%ebp),%eax
  80342c:	8b 40 08             	mov    0x8(%eax),%eax
  80342f:	39 c2                	cmp    %eax,%edx
  803431:	0f 85 b9 01 00 00    	jne    8035f0 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803437:	8b 45 08             	mov    0x8(%ebp),%eax
  80343a:	8b 50 08             	mov    0x8(%eax),%edx
  80343d:	8b 45 08             	mov    0x8(%ebp),%eax
  803440:	8b 40 0c             	mov    0xc(%eax),%eax
  803443:	01 c2                	add    %eax,%edx
  803445:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803448:	8b 40 08             	mov    0x8(%eax),%eax
  80344b:	39 c2                	cmp    %eax,%edx
  80344d:	0f 85 0d 01 00 00    	jne    803560 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  803453:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803456:	8b 50 0c             	mov    0xc(%eax),%edx
  803459:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80345c:	8b 40 0c             	mov    0xc(%eax),%eax
  80345f:	01 c2                	add    %eax,%edx
  803461:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803464:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803467:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80346b:	75 17                	jne    803484 <insert_sorted_with_merge_freeList+0x39c>
  80346d:	83 ec 04             	sub    $0x4,%esp
  803470:	68 e4 46 80 00       	push   $0x8046e4
  803475:	68 5c 01 00 00       	push   $0x15c
  80347a:	68 3b 46 80 00       	push   $0x80463b
  80347f:	e8 4b d2 ff ff       	call   8006cf <_panic>
  803484:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803487:	8b 00                	mov    (%eax),%eax
  803489:	85 c0                	test   %eax,%eax
  80348b:	74 10                	je     80349d <insert_sorted_with_merge_freeList+0x3b5>
  80348d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803490:	8b 00                	mov    (%eax),%eax
  803492:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803495:	8b 52 04             	mov    0x4(%edx),%edx
  803498:	89 50 04             	mov    %edx,0x4(%eax)
  80349b:	eb 0b                	jmp    8034a8 <insert_sorted_with_merge_freeList+0x3c0>
  80349d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034a0:	8b 40 04             	mov    0x4(%eax),%eax
  8034a3:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8034a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034ab:	8b 40 04             	mov    0x4(%eax),%eax
  8034ae:	85 c0                	test   %eax,%eax
  8034b0:	74 0f                	je     8034c1 <insert_sorted_with_merge_freeList+0x3d9>
  8034b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034b5:	8b 40 04             	mov    0x4(%eax),%eax
  8034b8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8034bb:	8b 12                	mov    (%edx),%edx
  8034bd:	89 10                	mov    %edx,(%eax)
  8034bf:	eb 0a                	jmp    8034cb <insert_sorted_with_merge_freeList+0x3e3>
  8034c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034c4:	8b 00                	mov    (%eax),%eax
  8034c6:	a3 38 51 80 00       	mov    %eax,0x805138
  8034cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034ce:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034d7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034de:	a1 44 51 80 00       	mov    0x805144,%eax
  8034e3:	48                   	dec    %eax
  8034e4:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  8034e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034ec:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  8034f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034f6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8034fd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803501:	75 17                	jne    80351a <insert_sorted_with_merge_freeList+0x432>
  803503:	83 ec 04             	sub    $0x4,%esp
  803506:	68 18 46 80 00       	push   $0x804618
  80350b:	68 5f 01 00 00       	push   $0x15f
  803510:	68 3b 46 80 00       	push   $0x80463b
  803515:	e8 b5 d1 ff ff       	call   8006cf <_panic>
  80351a:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803520:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803523:	89 10                	mov    %edx,(%eax)
  803525:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803528:	8b 00                	mov    (%eax),%eax
  80352a:	85 c0                	test   %eax,%eax
  80352c:	74 0d                	je     80353b <insert_sorted_with_merge_freeList+0x453>
  80352e:	a1 48 51 80 00       	mov    0x805148,%eax
  803533:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803536:	89 50 04             	mov    %edx,0x4(%eax)
  803539:	eb 08                	jmp    803543 <insert_sorted_with_merge_freeList+0x45b>
  80353b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80353e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803543:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803546:	a3 48 51 80 00       	mov    %eax,0x805148
  80354b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80354e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803555:	a1 54 51 80 00       	mov    0x805154,%eax
  80355a:	40                   	inc    %eax
  80355b:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803560:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803563:	8b 50 0c             	mov    0xc(%eax),%edx
  803566:	8b 45 08             	mov    0x8(%ebp),%eax
  803569:	8b 40 0c             	mov    0xc(%eax),%eax
  80356c:	01 c2                	add    %eax,%edx
  80356e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803571:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803574:	8b 45 08             	mov    0x8(%ebp),%eax
  803577:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  80357e:	8b 45 08             	mov    0x8(%ebp),%eax
  803581:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803588:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80358c:	75 17                	jne    8035a5 <insert_sorted_with_merge_freeList+0x4bd>
  80358e:	83 ec 04             	sub    $0x4,%esp
  803591:	68 18 46 80 00       	push   $0x804618
  803596:	68 64 01 00 00       	push   $0x164
  80359b:	68 3b 46 80 00       	push   $0x80463b
  8035a0:	e8 2a d1 ff ff       	call   8006cf <_panic>
  8035a5:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8035ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ae:	89 10                	mov    %edx,(%eax)
  8035b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8035b3:	8b 00                	mov    (%eax),%eax
  8035b5:	85 c0                	test   %eax,%eax
  8035b7:	74 0d                	je     8035c6 <insert_sorted_with_merge_freeList+0x4de>
  8035b9:	a1 48 51 80 00       	mov    0x805148,%eax
  8035be:	8b 55 08             	mov    0x8(%ebp),%edx
  8035c1:	89 50 04             	mov    %edx,0x4(%eax)
  8035c4:	eb 08                	jmp    8035ce <insert_sorted_with_merge_freeList+0x4e6>
  8035c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8035c9:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8035ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8035d1:	a3 48 51 80 00       	mov    %eax,0x805148
  8035d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8035d9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035e0:	a1 54 51 80 00       	mov    0x805154,%eax
  8035e5:	40                   	inc    %eax
  8035e6:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8035eb:	e9 41 02 00 00       	jmp    803831 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8035f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8035f3:	8b 50 08             	mov    0x8(%eax),%edx
  8035f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8035f9:	8b 40 0c             	mov    0xc(%eax),%eax
  8035fc:	01 c2                	add    %eax,%edx
  8035fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803601:	8b 40 08             	mov    0x8(%eax),%eax
  803604:	39 c2                	cmp    %eax,%edx
  803606:	0f 85 7c 01 00 00    	jne    803788 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  80360c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803610:	74 06                	je     803618 <insert_sorted_with_merge_freeList+0x530>
  803612:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803616:	75 17                	jne    80362f <insert_sorted_with_merge_freeList+0x547>
  803618:	83 ec 04             	sub    $0x4,%esp
  80361b:	68 54 46 80 00       	push   $0x804654
  803620:	68 69 01 00 00       	push   $0x169
  803625:	68 3b 46 80 00       	push   $0x80463b
  80362a:	e8 a0 d0 ff ff       	call   8006cf <_panic>
  80362f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803632:	8b 50 04             	mov    0x4(%eax),%edx
  803635:	8b 45 08             	mov    0x8(%ebp),%eax
  803638:	89 50 04             	mov    %edx,0x4(%eax)
  80363b:	8b 45 08             	mov    0x8(%ebp),%eax
  80363e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803641:	89 10                	mov    %edx,(%eax)
  803643:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803646:	8b 40 04             	mov    0x4(%eax),%eax
  803649:	85 c0                	test   %eax,%eax
  80364b:	74 0d                	je     80365a <insert_sorted_with_merge_freeList+0x572>
  80364d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803650:	8b 40 04             	mov    0x4(%eax),%eax
  803653:	8b 55 08             	mov    0x8(%ebp),%edx
  803656:	89 10                	mov    %edx,(%eax)
  803658:	eb 08                	jmp    803662 <insert_sorted_with_merge_freeList+0x57a>
  80365a:	8b 45 08             	mov    0x8(%ebp),%eax
  80365d:	a3 38 51 80 00       	mov    %eax,0x805138
  803662:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803665:	8b 55 08             	mov    0x8(%ebp),%edx
  803668:	89 50 04             	mov    %edx,0x4(%eax)
  80366b:	a1 44 51 80 00       	mov    0x805144,%eax
  803670:	40                   	inc    %eax
  803671:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803676:	8b 45 08             	mov    0x8(%ebp),%eax
  803679:	8b 50 0c             	mov    0xc(%eax),%edx
  80367c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80367f:	8b 40 0c             	mov    0xc(%eax),%eax
  803682:	01 c2                	add    %eax,%edx
  803684:	8b 45 08             	mov    0x8(%ebp),%eax
  803687:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80368a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80368e:	75 17                	jne    8036a7 <insert_sorted_with_merge_freeList+0x5bf>
  803690:	83 ec 04             	sub    $0x4,%esp
  803693:	68 e4 46 80 00       	push   $0x8046e4
  803698:	68 6b 01 00 00       	push   $0x16b
  80369d:	68 3b 46 80 00       	push   $0x80463b
  8036a2:	e8 28 d0 ff ff       	call   8006cf <_panic>
  8036a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036aa:	8b 00                	mov    (%eax),%eax
  8036ac:	85 c0                	test   %eax,%eax
  8036ae:	74 10                	je     8036c0 <insert_sorted_with_merge_freeList+0x5d8>
  8036b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036b3:	8b 00                	mov    (%eax),%eax
  8036b5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8036b8:	8b 52 04             	mov    0x4(%edx),%edx
  8036bb:	89 50 04             	mov    %edx,0x4(%eax)
  8036be:	eb 0b                	jmp    8036cb <insert_sorted_with_merge_freeList+0x5e3>
  8036c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036c3:	8b 40 04             	mov    0x4(%eax),%eax
  8036c6:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8036cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036ce:	8b 40 04             	mov    0x4(%eax),%eax
  8036d1:	85 c0                	test   %eax,%eax
  8036d3:	74 0f                	je     8036e4 <insert_sorted_with_merge_freeList+0x5fc>
  8036d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036d8:	8b 40 04             	mov    0x4(%eax),%eax
  8036db:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8036de:	8b 12                	mov    (%edx),%edx
  8036e0:	89 10                	mov    %edx,(%eax)
  8036e2:	eb 0a                	jmp    8036ee <insert_sorted_with_merge_freeList+0x606>
  8036e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036e7:	8b 00                	mov    (%eax),%eax
  8036e9:	a3 38 51 80 00       	mov    %eax,0x805138
  8036ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036f1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036fa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803701:	a1 44 51 80 00       	mov    0x805144,%eax
  803706:	48                   	dec    %eax
  803707:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  80370c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80370f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803716:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803719:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803720:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803724:	75 17                	jne    80373d <insert_sorted_with_merge_freeList+0x655>
  803726:	83 ec 04             	sub    $0x4,%esp
  803729:	68 18 46 80 00       	push   $0x804618
  80372e:	68 6e 01 00 00       	push   $0x16e
  803733:	68 3b 46 80 00       	push   $0x80463b
  803738:	e8 92 cf ff ff       	call   8006cf <_panic>
  80373d:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803743:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803746:	89 10                	mov    %edx,(%eax)
  803748:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80374b:	8b 00                	mov    (%eax),%eax
  80374d:	85 c0                	test   %eax,%eax
  80374f:	74 0d                	je     80375e <insert_sorted_with_merge_freeList+0x676>
  803751:	a1 48 51 80 00       	mov    0x805148,%eax
  803756:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803759:	89 50 04             	mov    %edx,0x4(%eax)
  80375c:	eb 08                	jmp    803766 <insert_sorted_with_merge_freeList+0x67e>
  80375e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803761:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803766:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803769:	a3 48 51 80 00       	mov    %eax,0x805148
  80376e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803771:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803778:	a1 54 51 80 00       	mov    0x805154,%eax
  80377d:	40                   	inc    %eax
  80377e:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803783:	e9 a9 00 00 00       	jmp    803831 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803788:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80378c:	74 06                	je     803794 <insert_sorted_with_merge_freeList+0x6ac>
  80378e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803792:	75 17                	jne    8037ab <insert_sorted_with_merge_freeList+0x6c3>
  803794:	83 ec 04             	sub    $0x4,%esp
  803797:	68 b0 46 80 00       	push   $0x8046b0
  80379c:	68 73 01 00 00       	push   $0x173
  8037a1:	68 3b 46 80 00       	push   $0x80463b
  8037a6:	e8 24 cf ff ff       	call   8006cf <_panic>
  8037ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037ae:	8b 10                	mov    (%eax),%edx
  8037b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8037b3:	89 10                	mov    %edx,(%eax)
  8037b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8037b8:	8b 00                	mov    (%eax),%eax
  8037ba:	85 c0                	test   %eax,%eax
  8037bc:	74 0b                	je     8037c9 <insert_sorted_with_merge_freeList+0x6e1>
  8037be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037c1:	8b 00                	mov    (%eax),%eax
  8037c3:	8b 55 08             	mov    0x8(%ebp),%edx
  8037c6:	89 50 04             	mov    %edx,0x4(%eax)
  8037c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037cc:	8b 55 08             	mov    0x8(%ebp),%edx
  8037cf:	89 10                	mov    %edx,(%eax)
  8037d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8037d4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8037d7:	89 50 04             	mov    %edx,0x4(%eax)
  8037da:	8b 45 08             	mov    0x8(%ebp),%eax
  8037dd:	8b 00                	mov    (%eax),%eax
  8037df:	85 c0                	test   %eax,%eax
  8037e1:	75 08                	jne    8037eb <insert_sorted_with_merge_freeList+0x703>
  8037e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8037e6:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8037eb:	a1 44 51 80 00       	mov    0x805144,%eax
  8037f0:	40                   	inc    %eax
  8037f1:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  8037f6:	eb 39                	jmp    803831 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8037f8:	a1 40 51 80 00       	mov    0x805140,%eax
  8037fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803800:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803804:	74 07                	je     80380d <insert_sorted_with_merge_freeList+0x725>
  803806:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803809:	8b 00                	mov    (%eax),%eax
  80380b:	eb 05                	jmp    803812 <insert_sorted_with_merge_freeList+0x72a>
  80380d:	b8 00 00 00 00       	mov    $0x0,%eax
  803812:	a3 40 51 80 00       	mov    %eax,0x805140
  803817:	a1 40 51 80 00       	mov    0x805140,%eax
  80381c:	85 c0                	test   %eax,%eax
  80381e:	0f 85 c7 fb ff ff    	jne    8033eb <insert_sorted_with_merge_freeList+0x303>
  803824:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803828:	0f 85 bd fb ff ff    	jne    8033eb <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80382e:	eb 01                	jmp    803831 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803830:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803831:	90                   	nop
  803832:	c9                   	leave  
  803833:	c3                   	ret    

00803834 <__udivdi3>:
  803834:	55                   	push   %ebp
  803835:	57                   	push   %edi
  803836:	56                   	push   %esi
  803837:	53                   	push   %ebx
  803838:	83 ec 1c             	sub    $0x1c,%esp
  80383b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80383f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803843:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803847:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80384b:	89 ca                	mov    %ecx,%edx
  80384d:	89 f8                	mov    %edi,%eax
  80384f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803853:	85 f6                	test   %esi,%esi
  803855:	75 2d                	jne    803884 <__udivdi3+0x50>
  803857:	39 cf                	cmp    %ecx,%edi
  803859:	77 65                	ja     8038c0 <__udivdi3+0x8c>
  80385b:	89 fd                	mov    %edi,%ebp
  80385d:	85 ff                	test   %edi,%edi
  80385f:	75 0b                	jne    80386c <__udivdi3+0x38>
  803861:	b8 01 00 00 00       	mov    $0x1,%eax
  803866:	31 d2                	xor    %edx,%edx
  803868:	f7 f7                	div    %edi
  80386a:	89 c5                	mov    %eax,%ebp
  80386c:	31 d2                	xor    %edx,%edx
  80386e:	89 c8                	mov    %ecx,%eax
  803870:	f7 f5                	div    %ebp
  803872:	89 c1                	mov    %eax,%ecx
  803874:	89 d8                	mov    %ebx,%eax
  803876:	f7 f5                	div    %ebp
  803878:	89 cf                	mov    %ecx,%edi
  80387a:	89 fa                	mov    %edi,%edx
  80387c:	83 c4 1c             	add    $0x1c,%esp
  80387f:	5b                   	pop    %ebx
  803880:	5e                   	pop    %esi
  803881:	5f                   	pop    %edi
  803882:	5d                   	pop    %ebp
  803883:	c3                   	ret    
  803884:	39 ce                	cmp    %ecx,%esi
  803886:	77 28                	ja     8038b0 <__udivdi3+0x7c>
  803888:	0f bd fe             	bsr    %esi,%edi
  80388b:	83 f7 1f             	xor    $0x1f,%edi
  80388e:	75 40                	jne    8038d0 <__udivdi3+0x9c>
  803890:	39 ce                	cmp    %ecx,%esi
  803892:	72 0a                	jb     80389e <__udivdi3+0x6a>
  803894:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803898:	0f 87 9e 00 00 00    	ja     80393c <__udivdi3+0x108>
  80389e:	b8 01 00 00 00       	mov    $0x1,%eax
  8038a3:	89 fa                	mov    %edi,%edx
  8038a5:	83 c4 1c             	add    $0x1c,%esp
  8038a8:	5b                   	pop    %ebx
  8038a9:	5e                   	pop    %esi
  8038aa:	5f                   	pop    %edi
  8038ab:	5d                   	pop    %ebp
  8038ac:	c3                   	ret    
  8038ad:	8d 76 00             	lea    0x0(%esi),%esi
  8038b0:	31 ff                	xor    %edi,%edi
  8038b2:	31 c0                	xor    %eax,%eax
  8038b4:	89 fa                	mov    %edi,%edx
  8038b6:	83 c4 1c             	add    $0x1c,%esp
  8038b9:	5b                   	pop    %ebx
  8038ba:	5e                   	pop    %esi
  8038bb:	5f                   	pop    %edi
  8038bc:	5d                   	pop    %ebp
  8038bd:	c3                   	ret    
  8038be:	66 90                	xchg   %ax,%ax
  8038c0:	89 d8                	mov    %ebx,%eax
  8038c2:	f7 f7                	div    %edi
  8038c4:	31 ff                	xor    %edi,%edi
  8038c6:	89 fa                	mov    %edi,%edx
  8038c8:	83 c4 1c             	add    $0x1c,%esp
  8038cb:	5b                   	pop    %ebx
  8038cc:	5e                   	pop    %esi
  8038cd:	5f                   	pop    %edi
  8038ce:	5d                   	pop    %ebp
  8038cf:	c3                   	ret    
  8038d0:	bd 20 00 00 00       	mov    $0x20,%ebp
  8038d5:	89 eb                	mov    %ebp,%ebx
  8038d7:	29 fb                	sub    %edi,%ebx
  8038d9:	89 f9                	mov    %edi,%ecx
  8038db:	d3 e6                	shl    %cl,%esi
  8038dd:	89 c5                	mov    %eax,%ebp
  8038df:	88 d9                	mov    %bl,%cl
  8038e1:	d3 ed                	shr    %cl,%ebp
  8038e3:	89 e9                	mov    %ebp,%ecx
  8038e5:	09 f1                	or     %esi,%ecx
  8038e7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8038eb:	89 f9                	mov    %edi,%ecx
  8038ed:	d3 e0                	shl    %cl,%eax
  8038ef:	89 c5                	mov    %eax,%ebp
  8038f1:	89 d6                	mov    %edx,%esi
  8038f3:	88 d9                	mov    %bl,%cl
  8038f5:	d3 ee                	shr    %cl,%esi
  8038f7:	89 f9                	mov    %edi,%ecx
  8038f9:	d3 e2                	shl    %cl,%edx
  8038fb:	8b 44 24 08          	mov    0x8(%esp),%eax
  8038ff:	88 d9                	mov    %bl,%cl
  803901:	d3 e8                	shr    %cl,%eax
  803903:	09 c2                	or     %eax,%edx
  803905:	89 d0                	mov    %edx,%eax
  803907:	89 f2                	mov    %esi,%edx
  803909:	f7 74 24 0c          	divl   0xc(%esp)
  80390d:	89 d6                	mov    %edx,%esi
  80390f:	89 c3                	mov    %eax,%ebx
  803911:	f7 e5                	mul    %ebp
  803913:	39 d6                	cmp    %edx,%esi
  803915:	72 19                	jb     803930 <__udivdi3+0xfc>
  803917:	74 0b                	je     803924 <__udivdi3+0xf0>
  803919:	89 d8                	mov    %ebx,%eax
  80391b:	31 ff                	xor    %edi,%edi
  80391d:	e9 58 ff ff ff       	jmp    80387a <__udivdi3+0x46>
  803922:	66 90                	xchg   %ax,%ax
  803924:	8b 54 24 08          	mov    0x8(%esp),%edx
  803928:	89 f9                	mov    %edi,%ecx
  80392a:	d3 e2                	shl    %cl,%edx
  80392c:	39 c2                	cmp    %eax,%edx
  80392e:	73 e9                	jae    803919 <__udivdi3+0xe5>
  803930:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803933:	31 ff                	xor    %edi,%edi
  803935:	e9 40 ff ff ff       	jmp    80387a <__udivdi3+0x46>
  80393a:	66 90                	xchg   %ax,%ax
  80393c:	31 c0                	xor    %eax,%eax
  80393e:	e9 37 ff ff ff       	jmp    80387a <__udivdi3+0x46>
  803943:	90                   	nop

00803944 <__umoddi3>:
  803944:	55                   	push   %ebp
  803945:	57                   	push   %edi
  803946:	56                   	push   %esi
  803947:	53                   	push   %ebx
  803948:	83 ec 1c             	sub    $0x1c,%esp
  80394b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80394f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803953:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803957:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80395b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80395f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803963:	89 f3                	mov    %esi,%ebx
  803965:	89 fa                	mov    %edi,%edx
  803967:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80396b:	89 34 24             	mov    %esi,(%esp)
  80396e:	85 c0                	test   %eax,%eax
  803970:	75 1a                	jne    80398c <__umoddi3+0x48>
  803972:	39 f7                	cmp    %esi,%edi
  803974:	0f 86 a2 00 00 00    	jbe    803a1c <__umoddi3+0xd8>
  80397a:	89 c8                	mov    %ecx,%eax
  80397c:	89 f2                	mov    %esi,%edx
  80397e:	f7 f7                	div    %edi
  803980:	89 d0                	mov    %edx,%eax
  803982:	31 d2                	xor    %edx,%edx
  803984:	83 c4 1c             	add    $0x1c,%esp
  803987:	5b                   	pop    %ebx
  803988:	5e                   	pop    %esi
  803989:	5f                   	pop    %edi
  80398a:	5d                   	pop    %ebp
  80398b:	c3                   	ret    
  80398c:	39 f0                	cmp    %esi,%eax
  80398e:	0f 87 ac 00 00 00    	ja     803a40 <__umoddi3+0xfc>
  803994:	0f bd e8             	bsr    %eax,%ebp
  803997:	83 f5 1f             	xor    $0x1f,%ebp
  80399a:	0f 84 ac 00 00 00    	je     803a4c <__umoddi3+0x108>
  8039a0:	bf 20 00 00 00       	mov    $0x20,%edi
  8039a5:	29 ef                	sub    %ebp,%edi
  8039a7:	89 fe                	mov    %edi,%esi
  8039a9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8039ad:	89 e9                	mov    %ebp,%ecx
  8039af:	d3 e0                	shl    %cl,%eax
  8039b1:	89 d7                	mov    %edx,%edi
  8039b3:	89 f1                	mov    %esi,%ecx
  8039b5:	d3 ef                	shr    %cl,%edi
  8039b7:	09 c7                	or     %eax,%edi
  8039b9:	89 e9                	mov    %ebp,%ecx
  8039bb:	d3 e2                	shl    %cl,%edx
  8039bd:	89 14 24             	mov    %edx,(%esp)
  8039c0:	89 d8                	mov    %ebx,%eax
  8039c2:	d3 e0                	shl    %cl,%eax
  8039c4:	89 c2                	mov    %eax,%edx
  8039c6:	8b 44 24 08          	mov    0x8(%esp),%eax
  8039ca:	d3 e0                	shl    %cl,%eax
  8039cc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8039d0:	8b 44 24 08          	mov    0x8(%esp),%eax
  8039d4:	89 f1                	mov    %esi,%ecx
  8039d6:	d3 e8                	shr    %cl,%eax
  8039d8:	09 d0                	or     %edx,%eax
  8039da:	d3 eb                	shr    %cl,%ebx
  8039dc:	89 da                	mov    %ebx,%edx
  8039de:	f7 f7                	div    %edi
  8039e0:	89 d3                	mov    %edx,%ebx
  8039e2:	f7 24 24             	mull   (%esp)
  8039e5:	89 c6                	mov    %eax,%esi
  8039e7:	89 d1                	mov    %edx,%ecx
  8039e9:	39 d3                	cmp    %edx,%ebx
  8039eb:	0f 82 87 00 00 00    	jb     803a78 <__umoddi3+0x134>
  8039f1:	0f 84 91 00 00 00    	je     803a88 <__umoddi3+0x144>
  8039f7:	8b 54 24 04          	mov    0x4(%esp),%edx
  8039fb:	29 f2                	sub    %esi,%edx
  8039fd:	19 cb                	sbb    %ecx,%ebx
  8039ff:	89 d8                	mov    %ebx,%eax
  803a01:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803a05:	d3 e0                	shl    %cl,%eax
  803a07:	89 e9                	mov    %ebp,%ecx
  803a09:	d3 ea                	shr    %cl,%edx
  803a0b:	09 d0                	or     %edx,%eax
  803a0d:	89 e9                	mov    %ebp,%ecx
  803a0f:	d3 eb                	shr    %cl,%ebx
  803a11:	89 da                	mov    %ebx,%edx
  803a13:	83 c4 1c             	add    $0x1c,%esp
  803a16:	5b                   	pop    %ebx
  803a17:	5e                   	pop    %esi
  803a18:	5f                   	pop    %edi
  803a19:	5d                   	pop    %ebp
  803a1a:	c3                   	ret    
  803a1b:	90                   	nop
  803a1c:	89 fd                	mov    %edi,%ebp
  803a1e:	85 ff                	test   %edi,%edi
  803a20:	75 0b                	jne    803a2d <__umoddi3+0xe9>
  803a22:	b8 01 00 00 00       	mov    $0x1,%eax
  803a27:	31 d2                	xor    %edx,%edx
  803a29:	f7 f7                	div    %edi
  803a2b:	89 c5                	mov    %eax,%ebp
  803a2d:	89 f0                	mov    %esi,%eax
  803a2f:	31 d2                	xor    %edx,%edx
  803a31:	f7 f5                	div    %ebp
  803a33:	89 c8                	mov    %ecx,%eax
  803a35:	f7 f5                	div    %ebp
  803a37:	89 d0                	mov    %edx,%eax
  803a39:	e9 44 ff ff ff       	jmp    803982 <__umoddi3+0x3e>
  803a3e:	66 90                	xchg   %ax,%ax
  803a40:	89 c8                	mov    %ecx,%eax
  803a42:	89 f2                	mov    %esi,%edx
  803a44:	83 c4 1c             	add    $0x1c,%esp
  803a47:	5b                   	pop    %ebx
  803a48:	5e                   	pop    %esi
  803a49:	5f                   	pop    %edi
  803a4a:	5d                   	pop    %ebp
  803a4b:	c3                   	ret    
  803a4c:	3b 04 24             	cmp    (%esp),%eax
  803a4f:	72 06                	jb     803a57 <__umoddi3+0x113>
  803a51:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803a55:	77 0f                	ja     803a66 <__umoddi3+0x122>
  803a57:	89 f2                	mov    %esi,%edx
  803a59:	29 f9                	sub    %edi,%ecx
  803a5b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803a5f:	89 14 24             	mov    %edx,(%esp)
  803a62:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803a66:	8b 44 24 04          	mov    0x4(%esp),%eax
  803a6a:	8b 14 24             	mov    (%esp),%edx
  803a6d:	83 c4 1c             	add    $0x1c,%esp
  803a70:	5b                   	pop    %ebx
  803a71:	5e                   	pop    %esi
  803a72:	5f                   	pop    %edi
  803a73:	5d                   	pop    %ebp
  803a74:	c3                   	ret    
  803a75:	8d 76 00             	lea    0x0(%esi),%esi
  803a78:	2b 04 24             	sub    (%esp),%eax
  803a7b:	19 fa                	sbb    %edi,%edx
  803a7d:	89 d1                	mov    %edx,%ecx
  803a7f:	89 c6                	mov    %eax,%esi
  803a81:	e9 71 ff ff ff       	jmp    8039f7 <__umoddi3+0xb3>
  803a86:	66 90                	xchg   %ax,%ax
  803a88:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803a8c:	72 ea                	jb     803a78 <__umoddi3+0x134>
  803a8e:	89 d9                	mov    %ebx,%ecx
  803a90:	e9 62 ff ff ff       	jmp    8039f7 <__umoddi3+0xb3>
