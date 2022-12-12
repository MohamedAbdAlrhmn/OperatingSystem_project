
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
  80008d:	68 c0 39 80 00       	push   $0x8039c0
  800092:	6a 12                	push   $0x12
  800094:	68 dc 39 80 00       	push   $0x8039dc
  800099:	e8 31 06 00 00       	call   8006cf <_panic>
	}

	cprintf("************************************************\n");
  80009e:	83 ec 0c             	sub    $0xc,%esp
  8000a1:	68 f4 39 80 00       	push   $0x8039f4
  8000a6:	e8 d8 08 00 00       	call   800983 <cprintf>
  8000ab:	83 c4 10             	add    $0x10,%esp
	cprintf("MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  8000ae:	83 ec 0c             	sub    $0xc,%esp
  8000b1:	68 28 3a 80 00       	push   $0x803a28
  8000b6:	e8 c8 08 00 00       	call   800983 <cprintf>
  8000bb:	83 c4 10             	add    $0x10,%esp
	cprintf("************************************************\n\n\n");
  8000be:	83 ec 0c             	sub    $0xc,%esp
  8000c1:	68 84 3a 80 00       	push   $0x803a84
  8000c6:	e8 b8 08 00 00       	call   800983 <cprintf>
  8000cb:	83 c4 10             	add    $0x10,%esp

	int Mega = 1024*1024;
  8000ce:	c7 45 ec 00 00 10 00 	movl   $0x100000,-0x14(%ebp)
	int kilo = 1024;
  8000d5:	c7 45 e8 00 04 00 00 	movl   $0x400,-0x18(%ebp)
	int envID = sys_getenvid();
  8000dc:	e8 79 1d 00 00       	call   801e5a <sys_getenvid>
  8000e1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	cprintf("STEP A: checking free of a shared object ... \n");
  8000e4:	83 ec 0c             	sub    $0xc,%esp
  8000e7:	68 b8 3a 80 00       	push   $0x803ab8
  8000ec:	e8 92 08 00 00       	call   800983 <cprintf>
  8000f1:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x;
		int freeFrames = sys_calculate_free_frames() ;
  8000f4:	e8 9a 1a 00 00       	call   801b93 <sys_calculate_free_frames>
  8000f9:	89 45 e0             	mov    %eax,-0x20(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8000fc:	83 ec 04             	sub    $0x4,%esp
  8000ff:	6a 01                	push   $0x1
  800101:	68 00 10 00 00       	push   $0x1000
  800106:	68 e7 3a 80 00       	push   $0x803ae7
  80010b:	e8 43 18 00 00       	call   801953 <smalloc>
  800110:	83 c4 10             	add    $0x10,%esp
  800113:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (x != (uint32*)USER_HEAP_START) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  800116:	81 7d dc 00 00 00 80 	cmpl   $0x80000000,-0x24(%ebp)
  80011d:	74 14                	je     800133 <_main+0xfb>
  80011f:	83 ec 04             	sub    $0x4,%esp
  800122:	68 ec 3a 80 00       	push   $0x803aec
  800127:	6a 21                	push   $0x21
  800129:	68 dc 39 80 00       	push   $0x8039dc
  80012e:	e8 9c 05 00 00       	call   8006cf <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800133:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800136:	e8 58 1a 00 00       	call   801b93 <sys_calculate_free_frames>
  80013b:	29 c3                	sub    %eax,%ebx
  80013d:	89 d8                	mov    %ebx,%eax
  80013f:	83 f8 04             	cmp    $0x4,%eax
  800142:	74 14                	je     800158 <_main+0x120>
  800144:	83 ec 04             	sub    $0x4,%esp
  800147:	68 58 3b 80 00       	push   $0x803b58
  80014c:	6a 22                	push   $0x22
  80014e:	68 dc 39 80 00       	push   $0x8039dc
  800153:	e8 77 05 00 00       	call   8006cf <_panic>

		sfree(x);
  800158:	83 ec 0c             	sub    $0xc,%esp
  80015b:	ff 75 dc             	pushl  -0x24(%ebp)
  80015e:	e8 d0 18 00 00       	call   801a33 <sfree>
  800163:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) ==  0+0+2) panic("Wrong free: make sure that you free the shared object by calling free_share_object()");
  800166:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800169:	e8 25 1a 00 00       	call   801b93 <sys_calculate_free_frames>
  80016e:	29 c3                	sub    %eax,%ebx
  800170:	89 d8                	mov    %ebx,%eax
  800172:	83 f8 02             	cmp    $0x2,%eax
  800175:	75 14                	jne    80018b <_main+0x153>
  800177:	83 ec 04             	sub    $0x4,%esp
  80017a:	68 d8 3b 80 00       	push   $0x803bd8
  80017f:	6a 25                	push   $0x25
  800181:	68 dc 39 80 00       	push   $0x8039dc
  800186:	e8 44 05 00 00       	call   8006cf <_panic>
		else if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong free: revise your freeSharedObject logic");
  80018b:	e8 03 1a 00 00       	call   801b93 <sys_calculate_free_frames>
  800190:	89 c2                	mov    %eax,%edx
  800192:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800195:	39 c2                	cmp    %eax,%edx
  800197:	74 14                	je     8001ad <_main+0x175>
  800199:	83 ec 04             	sub    $0x4,%esp
  80019c:	68 30 3c 80 00       	push   $0x803c30
  8001a1:	6a 26                	push   $0x26
  8001a3:	68 dc 39 80 00       	push   $0x8039dc
  8001a8:	e8 22 05 00 00       	call   8006cf <_panic>
	}
	cprintf("Step A completed successfully!!\n\n\n");
  8001ad:	83 ec 0c             	sub    $0xc,%esp
  8001b0:	68 60 3c 80 00       	push   $0x803c60
  8001b5:	e8 c9 07 00 00       	call   800983 <cprintf>
  8001ba:	83 c4 10             	add    $0x10,%esp


	cprintf("STEP B: checking free of 2 shared objects ... \n");
  8001bd:	83 ec 0c             	sub    $0xc,%esp
  8001c0:	68 84 3c 80 00       	push   $0x803c84
  8001c5:	e8 b9 07 00 00       	call   800983 <cprintf>
  8001ca:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x, *z ;
		int freeFrames = sys_calculate_free_frames() ;
  8001cd:	e8 c1 19 00 00       	call   801b93 <sys_calculate_free_frames>
  8001d2:	89 45 d8             	mov    %eax,-0x28(%ebp)
		z = smalloc("z", PAGE_SIZE, 1);
  8001d5:	83 ec 04             	sub    $0x4,%esp
  8001d8:	6a 01                	push   $0x1
  8001da:	68 00 10 00 00       	push   $0x1000
  8001df:	68 b4 3c 80 00       	push   $0x803cb4
  8001e4:	e8 6a 17 00 00       	call   801953 <smalloc>
  8001e9:	83 c4 10             	add    $0x10,%esp
  8001ec:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8001ef:	83 ec 04             	sub    $0x4,%esp
  8001f2:	6a 01                	push   $0x1
  8001f4:	68 00 10 00 00       	push   $0x1000
  8001f9:	68 e7 3a 80 00       	push   $0x803ae7
  8001fe:	e8 50 17 00 00       	call   801953 <smalloc>
  800203:	83 c4 10             	add    $0x10,%esp
  800206:	89 45 d0             	mov    %eax,-0x30(%ebp)

		if(x == NULL) panic("Wrong free: make sure that you free the shared object by calling free_share_object()");
  800209:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80020d:	75 14                	jne    800223 <_main+0x1eb>
  80020f:	83 ec 04             	sub    $0x4,%esp
  800212:	68 d8 3b 80 00       	push   $0x803bd8
  800217:	6a 32                	push   $0x32
  800219:	68 dc 39 80 00       	push   $0x8039dc
  80021e:	e8 ac 04 00 00       	call   8006cf <_panic>

		if ((freeFrames - sys_calculate_free_frames()) !=  2+1+4) panic("Wrong previous free: make sure that you correctly free shared object before (Step A)");
  800223:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800226:	e8 68 19 00 00       	call   801b93 <sys_calculate_free_frames>
  80022b:	29 c3                	sub    %eax,%ebx
  80022d:	89 d8                	mov    %ebx,%eax
  80022f:	83 f8 07             	cmp    $0x7,%eax
  800232:	74 14                	je     800248 <_main+0x210>
  800234:	83 ec 04             	sub    $0x4,%esp
  800237:	68 b8 3c 80 00       	push   $0x803cb8
  80023c:	6a 34                	push   $0x34
  80023e:	68 dc 39 80 00       	push   $0x8039dc
  800243:	e8 87 04 00 00       	call   8006cf <_panic>

		sfree(z);
  800248:	83 ec 0c             	sub    $0xc,%esp
  80024b:	ff 75 d4             	pushl  -0x2c(%ebp)
  80024e:	e8 e0 17 00 00       	call   801a33 <sfree>
  800253:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong free: check your logic");
  800256:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800259:	e8 35 19 00 00       	call   801b93 <sys_calculate_free_frames>
  80025e:	29 c3                	sub    %eax,%ebx
  800260:	89 d8                	mov    %ebx,%eax
  800262:	83 f8 04             	cmp    $0x4,%eax
  800265:	74 14                	je     80027b <_main+0x243>
  800267:	83 ec 04             	sub    $0x4,%esp
  80026a:	68 0d 3d 80 00       	push   $0x803d0d
  80026f:	6a 37                	push   $0x37
  800271:	68 dc 39 80 00       	push   $0x8039dc
  800276:	e8 54 04 00 00       	call   8006cf <_panic>

		sfree(x);
  80027b:	83 ec 0c             	sub    $0xc,%esp
  80027e:	ff 75 d0             	pushl  -0x30(%ebp)
  800281:	e8 ad 17 00 00       	call   801a33 <sfree>
  800286:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong free: check your logic");
  800289:	e8 05 19 00 00       	call   801b93 <sys_calculate_free_frames>
  80028e:	89 c2                	mov    %eax,%edx
  800290:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800293:	39 c2                	cmp    %eax,%edx
  800295:	74 14                	je     8002ab <_main+0x273>
  800297:	83 ec 04             	sub    $0x4,%esp
  80029a:	68 0d 3d 80 00       	push   $0x803d0d
  80029f:	6a 3a                	push   $0x3a
  8002a1:	68 dc 39 80 00       	push   $0x8039dc
  8002a6:	e8 24 04 00 00       	call   8006cf <_panic>

	}
	cprintf("Step B completed successfully!!\n\n\n");
  8002ab:	83 ec 0c             	sub    $0xc,%esp
  8002ae:	68 2c 3d 80 00       	push   $0x803d2c
  8002b3:	e8 cb 06 00 00       	call   800983 <cprintf>
  8002b8:	83 c4 10             	add    $0x10,%esp

	cprintf("STEP C: checking range of loop during free... \n");
  8002bb:	83 ec 0c             	sub    $0xc,%esp
  8002be:	68 50 3d 80 00       	push   $0x803d50
  8002c3:	e8 bb 06 00 00       	call   800983 <cprintf>
  8002c8:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *w, *u;
		int freeFrames = sys_calculate_free_frames() ;
  8002cb:	e8 c3 18 00 00       	call   801b93 <sys_calculate_free_frames>
  8002d0:	89 45 cc             	mov    %eax,-0x34(%ebp)
		w = smalloc("w", 3 * PAGE_SIZE+1, 1);
  8002d3:	83 ec 04             	sub    $0x4,%esp
  8002d6:	6a 01                	push   $0x1
  8002d8:	68 01 30 00 00       	push   $0x3001
  8002dd:	68 80 3d 80 00       	push   $0x803d80
  8002e2:	e8 6c 16 00 00       	call   801953 <smalloc>
  8002e7:	83 c4 10             	add    $0x10,%esp
  8002ea:	89 45 c8             	mov    %eax,-0x38(%ebp)
		u = smalloc("u", PAGE_SIZE, 1);
  8002ed:	83 ec 04             	sub    $0x4,%esp
  8002f0:	6a 01                	push   $0x1
  8002f2:	68 00 10 00 00       	push   $0x1000
  8002f7:	68 82 3d 80 00       	push   $0x803d82
  8002fc:	e8 52 16 00 00       	call   801953 <smalloc>
  800301:	83 c4 10             	add    $0x10,%esp
  800304:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		if ((freeFrames - sys_calculate_free_frames()) != 5+1+4) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800307:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  80030a:	e8 84 18 00 00       	call   801b93 <sys_calculate_free_frames>
  80030f:	29 c3                	sub    %eax,%ebx
  800311:	89 d8                	mov    %ebx,%eax
  800313:	83 f8 0a             	cmp    $0xa,%eax
  800316:	74 14                	je     80032c <_main+0x2f4>
  800318:	83 ec 04             	sub    $0x4,%esp
  80031b:	68 58 3b 80 00       	push   $0x803b58
  800320:	6a 46                	push   $0x46
  800322:	68 dc 39 80 00       	push   $0x8039dc
  800327:	e8 a3 03 00 00       	call   8006cf <_panic>

		sfree(w);
  80032c:	83 ec 0c             	sub    $0xc,%esp
  80032f:	ff 75 c8             	pushl  -0x38(%ebp)
  800332:	e8 fc 16 00 00       	call   801a33 <sfree>
  800337:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong free: check your logic");
  80033a:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  80033d:	e8 51 18 00 00       	call   801b93 <sys_calculate_free_frames>
  800342:	29 c3                	sub    %eax,%ebx
  800344:	89 d8                	mov    %ebx,%eax
  800346:	83 f8 04             	cmp    $0x4,%eax
  800349:	74 14                	je     80035f <_main+0x327>
  80034b:	83 ec 04             	sub    $0x4,%esp
  80034e:	68 0d 3d 80 00       	push   $0x803d0d
  800353:	6a 49                	push   $0x49
  800355:	68 dc 39 80 00       	push   $0x8039dc
  80035a:	e8 70 03 00 00       	call   8006cf <_panic>

		uint32 *o;
		o = smalloc("o", 2 * PAGE_SIZE-1,1);
  80035f:	83 ec 04             	sub    $0x4,%esp
  800362:	6a 01                	push   $0x1
  800364:	68 ff 1f 00 00       	push   $0x1fff
  800369:	68 84 3d 80 00       	push   $0x803d84
  80036e:	e8 e0 15 00 00       	call   801953 <smalloc>
  800373:	83 c4 10             	add    $0x10,%esp
  800376:	89 45 c0             	mov    %eax,-0x40(%ebp)

		if ((freeFrames - sys_calculate_free_frames()) != 3+1+4) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800379:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  80037c:	e8 12 18 00 00       	call   801b93 <sys_calculate_free_frames>
  800381:	29 c3                	sub    %eax,%ebx
  800383:	89 d8                	mov    %ebx,%eax
  800385:	83 f8 08             	cmp    $0x8,%eax
  800388:	74 14                	je     80039e <_main+0x366>
  80038a:	83 ec 04             	sub    $0x4,%esp
  80038d:	68 58 3b 80 00       	push   $0x803b58
  800392:	6a 4e                	push   $0x4e
  800394:	68 dc 39 80 00       	push   $0x8039dc
  800399:	e8 31 03 00 00       	call   8006cf <_panic>

		sfree(o);
  80039e:	83 ec 0c             	sub    $0xc,%esp
  8003a1:	ff 75 c0             	pushl  -0x40(%ebp)
  8003a4:	e8 8a 16 00 00       	call   801a33 <sfree>
  8003a9:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong free: check your logic");
  8003ac:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8003af:	e8 df 17 00 00       	call   801b93 <sys_calculate_free_frames>
  8003b4:	29 c3                	sub    %eax,%ebx
  8003b6:	89 d8                	mov    %ebx,%eax
  8003b8:	83 f8 04             	cmp    $0x4,%eax
  8003bb:	74 14                	je     8003d1 <_main+0x399>
  8003bd:	83 ec 04             	sub    $0x4,%esp
  8003c0:	68 0d 3d 80 00       	push   $0x803d0d
  8003c5:	6a 51                	push   $0x51
  8003c7:	68 dc 39 80 00       	push   $0x8039dc
  8003cc:	e8 fe 02 00 00       	call   8006cf <_panic>

		sfree(u);
  8003d1:	83 ec 0c             	sub    $0xc,%esp
  8003d4:	ff 75 c4             	pushl  -0x3c(%ebp)
  8003d7:	e8 57 16 00 00       	call   801a33 <sfree>
  8003dc:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong free: check your logic");
  8003df:	e8 af 17 00 00       	call   801b93 <sys_calculate_free_frames>
  8003e4:	89 c2                	mov    %eax,%edx
  8003e6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8003e9:	39 c2                	cmp    %eax,%edx
  8003eb:	74 14                	je     800401 <_main+0x3c9>
  8003ed:	83 ec 04             	sub    $0x4,%esp
  8003f0:	68 0d 3d 80 00       	push   $0x803d0d
  8003f5:	6a 54                	push   $0x54
  8003f7:	68 dc 39 80 00       	push   $0x8039dc
  8003fc:	e8 ce 02 00 00       	call   8006cf <_panic>


		//Checking boundaries of page tables
		freeFrames = sys_calculate_free_frames() ;
  800401:	e8 8d 17 00 00       	call   801b93 <sys_calculate_free_frames>
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
  80041b:	68 80 3d 80 00       	push   $0x803d80
  800420:	e8 2e 15 00 00       	call   801953 <smalloc>
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
  800441:	68 82 3d 80 00       	push   $0x803d82
  800446:	e8 08 15 00 00       	call   801953 <smalloc>
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
  800463:	68 84 3d 80 00       	push   $0x803d84
  800468:	e8 e6 14 00 00       	call   801953 <smalloc>
  80046d:	83 c4 10             	add    $0x10,%esp
  800470:	89 45 c0             	mov    %eax,-0x40(%ebp)

		if ((freeFrames - sys_calculate_free_frames()) != 3073+4+7) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800473:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800476:	e8 18 17 00 00       	call   801b93 <sys_calculate_free_frames>
  80047b:	29 c3                	sub    %eax,%ebx
  80047d:	89 d8                	mov    %ebx,%eax
  80047f:	3d 0c 0c 00 00       	cmp    $0xc0c,%eax
  800484:	74 14                	je     80049a <_main+0x462>
  800486:	83 ec 04             	sub    $0x4,%esp
  800489:	68 58 3b 80 00       	push   $0x803b58
  80048e:	6a 5d                	push   $0x5d
  800490:	68 dc 39 80 00       	push   $0x8039dc
  800495:	e8 35 02 00 00       	call   8006cf <_panic>

		sfree(o);
  80049a:	83 ec 0c             	sub    $0xc,%esp
  80049d:	ff 75 c0             	pushl  -0x40(%ebp)
  8004a0:	e8 8e 15 00 00       	call   801a33 <sfree>
  8004a5:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  2560+3+5) panic("Wrong free: check your logic");
  8004a8:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8004ab:	e8 e3 16 00 00       	call   801b93 <sys_calculate_free_frames>
  8004b0:	29 c3                	sub    %eax,%ebx
  8004b2:	89 d8                	mov    %ebx,%eax
  8004b4:	3d 08 0a 00 00       	cmp    $0xa08,%eax
  8004b9:	74 14                	je     8004cf <_main+0x497>
  8004bb:	83 ec 04             	sub    $0x4,%esp
  8004be:	68 0d 3d 80 00       	push   $0x803d0d
  8004c3:	6a 60                	push   $0x60
  8004c5:	68 dc 39 80 00       	push   $0x8039dc
  8004ca:	e8 00 02 00 00       	call   8006cf <_panic>

		sfree(w);
  8004cf:	83 ec 0c             	sub    $0xc,%esp
  8004d2:	ff 75 c8             	pushl  -0x38(%ebp)
  8004d5:	e8 59 15 00 00       	call   801a33 <sfree>
  8004da:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  1792+3+3) panic("Wrong free: check your logic");
  8004dd:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8004e0:	e8 ae 16 00 00       	call   801b93 <sys_calculate_free_frames>
  8004e5:	29 c3                	sub    %eax,%ebx
  8004e7:	89 d8                	mov    %ebx,%eax
  8004e9:	3d 06 07 00 00       	cmp    $0x706,%eax
  8004ee:	74 14                	je     800504 <_main+0x4cc>
  8004f0:	83 ec 04             	sub    $0x4,%esp
  8004f3:	68 0d 3d 80 00       	push   $0x803d0d
  8004f8:	6a 63                	push   $0x63
  8004fa:	68 dc 39 80 00       	push   $0x8039dc
  8004ff:	e8 cb 01 00 00       	call   8006cf <_panic>

		sfree(u);
  800504:	83 ec 0c             	sub    $0xc,%esp
  800507:	ff 75 c4             	pushl  -0x3c(%ebp)
  80050a:	e8 24 15 00 00       	call   801a33 <sfree>
  80050f:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong free: check your logic");
  800512:	e8 7c 16 00 00       	call   801b93 <sys_calculate_free_frames>
  800517:	89 c2                	mov    %eax,%edx
  800519:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80051c:	39 c2                	cmp    %eax,%edx
  80051e:	74 14                	je     800534 <_main+0x4fc>
  800520:	83 ec 04             	sub    $0x4,%esp
  800523:	68 0d 3d 80 00       	push   $0x803d0d
  800528:	6a 66                	push   $0x66
  80052a:	68 dc 39 80 00       	push   $0x8039dc
  80052f:	e8 9b 01 00 00       	call   8006cf <_panic>
	}
	cprintf("Step C completed successfully!!\n\n\n");
  800534:	83 ec 0c             	sub    $0xc,%esp
  800537:	68 88 3d 80 00       	push   $0x803d88
  80053c:	e8 42 04 00 00       	call   800983 <cprintf>
  800541:	83 c4 10             	add    $0x10,%esp

	cprintf("Congratulations!! Test of freeSharedObjects [4] completed successfully!!\n\n\n");
  800544:	83 ec 0c             	sub    $0xc,%esp
  800547:	68 ac 3d 80 00       	push   $0x803dac
  80054c:	e8 32 04 00 00       	call   800983 <cprintf>
  800551:	83 c4 10             	add    $0x10,%esp

	int32 parentenvID = sys_getparentenvid();
  800554:	e8 33 19 00 00       	call   801e8c <sys_getparentenvid>
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
  80056c:	68 f8 3d 80 00       	push   $0x803df8
  800571:	ff 75 bc             	pushl  -0x44(%ebp)
  800574:	e8 76 14 00 00       	call   8019ef <sget>
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
  800599:	e8 d5 18 00 00       	call   801e73 <sys_getenvindex>
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
  800604:	e8 77 16 00 00       	call   801c80 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800609:	83 ec 0c             	sub    $0xc,%esp
  80060c:	68 20 3e 80 00       	push   $0x803e20
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
  800634:	68 48 3e 80 00       	push   $0x803e48
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
  800665:	68 70 3e 80 00       	push   $0x803e70
  80066a:	e8 14 03 00 00       	call   800983 <cprintf>
  80066f:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800672:	a1 20 50 80 00       	mov    0x805020,%eax
  800677:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80067d:	83 ec 08             	sub    $0x8,%esp
  800680:	50                   	push   %eax
  800681:	68 c8 3e 80 00       	push   $0x803ec8
  800686:	e8 f8 02 00 00       	call   800983 <cprintf>
  80068b:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80068e:	83 ec 0c             	sub    $0xc,%esp
  800691:	68 20 3e 80 00       	push   $0x803e20
  800696:	e8 e8 02 00 00       	call   800983 <cprintf>
  80069b:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80069e:	e8 f7 15 00 00       	call   801c9a <sys_enable_interrupt>

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
  8006b6:	e8 84 17 00 00       	call   801e3f <sys_destroy_env>
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
  8006c7:	e8 d9 17 00 00       	call   801ea5 <sys_exit_env>
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
  8006f0:	68 dc 3e 80 00       	push   $0x803edc
  8006f5:	e8 89 02 00 00       	call   800983 <cprintf>
  8006fa:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8006fd:	a1 00 50 80 00       	mov    0x805000,%eax
  800702:	ff 75 0c             	pushl  0xc(%ebp)
  800705:	ff 75 08             	pushl  0x8(%ebp)
  800708:	50                   	push   %eax
  800709:	68 e1 3e 80 00       	push   $0x803ee1
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
  80072d:	68 fd 3e 80 00       	push   $0x803efd
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
  800759:	68 00 3f 80 00       	push   $0x803f00
  80075e:	6a 26                	push   $0x26
  800760:	68 4c 3f 80 00       	push   $0x803f4c
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
  80082b:	68 58 3f 80 00       	push   $0x803f58
  800830:	6a 3a                	push   $0x3a
  800832:	68 4c 3f 80 00       	push   $0x803f4c
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
  80089b:	68 ac 3f 80 00       	push   $0x803fac
  8008a0:	6a 44                	push   $0x44
  8008a2:	68 4c 3f 80 00       	push   $0x803f4c
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
  8008f5:	e8 d8 11 00 00       	call   801ad2 <sys_cputs>
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
  80096c:	e8 61 11 00 00       	call   801ad2 <sys_cputs>
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
  8009b6:	e8 c5 12 00 00       	call   801c80 <sys_disable_interrupt>
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
  8009d6:	e8 bf 12 00 00       	call   801c9a <sys_enable_interrupt>
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
  800a20:	e8 33 2d 00 00       	call   803758 <__udivdi3>
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
  800a70:	e8 f3 2d 00 00       	call   803868 <__umoddi3>
  800a75:	83 c4 10             	add    $0x10,%esp
  800a78:	05 14 42 80 00       	add    $0x804214,%eax
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
  800bcb:	8b 04 85 38 42 80 00 	mov    0x804238(,%eax,4),%eax
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
  800cac:	8b 34 9d 80 40 80 00 	mov    0x804080(,%ebx,4),%esi
  800cb3:	85 f6                	test   %esi,%esi
  800cb5:	75 19                	jne    800cd0 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800cb7:	53                   	push   %ebx
  800cb8:	68 25 42 80 00       	push   $0x804225
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
  800cd1:	68 2e 42 80 00       	push   $0x80422e
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
  800cfe:	be 31 42 80 00       	mov    $0x804231,%esi
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
  801724:	68 90 43 80 00       	push   $0x804390
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
  8017f4:	e8 1d 04 00 00       	call   801c16 <sys_allocate_chunk>
  8017f9:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8017fc:	a1 20 51 80 00       	mov    0x805120,%eax
  801801:	83 ec 0c             	sub    $0xc,%esp
  801804:	50                   	push   %eax
  801805:	e8 92 0a 00 00       	call   80229c <initialize_MemBlocksList>
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
  801832:	68 b5 43 80 00       	push   $0x8043b5
  801837:	6a 33                	push   $0x33
  801839:	68 d3 43 80 00       	push   $0x8043d3
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
  8018b1:	68 e0 43 80 00       	push   $0x8043e0
  8018b6:	6a 34                	push   $0x34
  8018b8:	68 d3 43 80 00       	push   $0x8043d3
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
  80190e:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801911:	e8 f7 fd ff ff       	call   80170d <InitializeUHeap>
	if (size == 0) return NULL ;
  801916:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80191a:	75 07                	jne    801923 <malloc+0x18>
  80191c:	b8 00 00 00 00       	mov    $0x0,%eax
  801921:	eb 14                	jmp    801937 <malloc+0x2c>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  801923:	83 ec 04             	sub    $0x4,%esp
  801926:	68 04 44 80 00       	push   $0x804404
  80192b:	6a 46                	push   $0x46
  80192d:	68 d3 43 80 00       	push   $0x8043d3
  801932:	e8 98 ed ff ff       	call   8006cf <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801937:	c9                   	leave  
  801938:	c3                   	ret    

00801939 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801939:	55                   	push   %ebp
  80193a:	89 e5                	mov    %esp,%ebp
  80193c:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  80193f:	83 ec 04             	sub    $0x4,%esp
  801942:	68 2c 44 80 00       	push   $0x80442c
  801947:	6a 61                	push   $0x61
  801949:	68 d3 43 80 00       	push   $0x8043d3
  80194e:	e8 7c ed ff ff       	call   8006cf <_panic>

00801953 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801953:	55                   	push   %ebp
  801954:	89 e5                	mov    %esp,%ebp
  801956:	83 ec 38             	sub    $0x38,%esp
  801959:	8b 45 10             	mov    0x10(%ebp),%eax
  80195c:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80195f:	e8 a9 fd ff ff       	call   80170d <InitializeUHeap>
	if (size == 0) return NULL ;
  801964:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801968:	75 07                	jne    801971 <smalloc+0x1e>
  80196a:	b8 00 00 00 00       	mov    $0x0,%eax
  80196f:	eb 7c                	jmp    8019ed <smalloc+0x9a>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801971:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801978:	8b 55 0c             	mov    0xc(%ebp),%edx
  80197b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80197e:	01 d0                	add    %edx,%eax
  801980:	48                   	dec    %eax
  801981:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801984:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801987:	ba 00 00 00 00       	mov    $0x0,%edx
  80198c:	f7 75 f0             	divl   -0x10(%ebp)
  80198f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801992:	29 d0                	sub    %edx,%eax
  801994:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801997:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  80199e:	e8 41 06 00 00       	call   801fe4 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8019a3:	85 c0                	test   %eax,%eax
  8019a5:	74 11                	je     8019b8 <smalloc+0x65>
		mem_block = alloc_block_FF(allocate_space);
  8019a7:	83 ec 0c             	sub    $0xc,%esp
  8019aa:	ff 75 e8             	pushl  -0x18(%ebp)
  8019ad:	e8 ac 0c 00 00       	call   80265e <alloc_block_FF>
  8019b2:	83 c4 10             	add    $0x10,%esp
  8019b5:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  8019b8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8019bc:	74 2a                	je     8019e8 <smalloc+0x95>
	{
		virtual_address = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  8019be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019c1:	8b 40 08             	mov    0x8(%eax),%eax
  8019c4:	89 c2                	mov    %eax,%edx
  8019c6:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8019ca:	52                   	push   %edx
  8019cb:	50                   	push   %eax
  8019cc:	ff 75 0c             	pushl  0xc(%ebp)
  8019cf:	ff 75 08             	pushl  0x8(%ebp)
  8019d2:	e8 92 03 00 00       	call   801d69 <sys_createSharedObject>
  8019d7:	83 c4 10             	add    $0x10,%esp
  8019da:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (virtual_address != -1)
  8019dd:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  8019e1:	74 05                	je     8019e8 <smalloc+0x95>
			return (void*)virtual_address;
  8019e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8019e6:	eb 05                	jmp    8019ed <smalloc+0x9a>
	}
	return NULL;
  8019e8:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8019ed:	c9                   	leave  
  8019ee:	c3                   	ret    

008019ef <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8019ef:	55                   	push   %ebp
  8019f0:	89 e5                	mov    %esp,%ebp
  8019f2:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8019f5:	e8 13 fd ff ff       	call   80170d <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8019fa:	83 ec 04             	sub    $0x4,%esp
  8019fd:	68 50 44 80 00       	push   $0x804450
  801a02:	68 a2 00 00 00       	push   $0xa2
  801a07:	68 d3 43 80 00       	push   $0x8043d3
  801a0c:	e8 be ec ff ff       	call   8006cf <_panic>

00801a11 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801a11:	55                   	push   %ebp
  801a12:	89 e5                	mov    %esp,%ebp
  801a14:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801a17:	e8 f1 fc ff ff       	call   80170d <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801a1c:	83 ec 04             	sub    $0x4,%esp
  801a1f:	68 74 44 80 00       	push   $0x804474
  801a24:	68 e6 00 00 00       	push   $0xe6
  801a29:	68 d3 43 80 00       	push   $0x8043d3
  801a2e:	e8 9c ec ff ff       	call   8006cf <_panic>

00801a33 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801a33:	55                   	push   %ebp
  801a34:	89 e5                	mov    %esp,%ebp
  801a36:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801a39:	83 ec 04             	sub    $0x4,%esp
  801a3c:	68 9c 44 80 00       	push   $0x80449c
  801a41:	68 fa 00 00 00       	push   $0xfa
  801a46:	68 d3 43 80 00       	push   $0x8043d3
  801a4b:	e8 7f ec ff ff       	call   8006cf <_panic>

00801a50 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801a50:	55                   	push   %ebp
  801a51:	89 e5                	mov    %esp,%ebp
  801a53:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a56:	83 ec 04             	sub    $0x4,%esp
  801a59:	68 c0 44 80 00       	push   $0x8044c0
  801a5e:	68 05 01 00 00       	push   $0x105
  801a63:	68 d3 43 80 00       	push   $0x8043d3
  801a68:	e8 62 ec ff ff       	call   8006cf <_panic>

00801a6d <shrink>:

}
void shrink(uint32 newSize)
{
  801a6d:	55                   	push   %ebp
  801a6e:	89 e5                	mov    %esp,%ebp
  801a70:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a73:	83 ec 04             	sub    $0x4,%esp
  801a76:	68 c0 44 80 00       	push   $0x8044c0
  801a7b:	68 0a 01 00 00       	push   $0x10a
  801a80:	68 d3 43 80 00       	push   $0x8043d3
  801a85:	e8 45 ec ff ff       	call   8006cf <_panic>

00801a8a <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801a8a:	55                   	push   %ebp
  801a8b:	89 e5                	mov    %esp,%ebp
  801a8d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a90:	83 ec 04             	sub    $0x4,%esp
  801a93:	68 c0 44 80 00       	push   $0x8044c0
  801a98:	68 0f 01 00 00       	push   $0x10f
  801a9d:	68 d3 43 80 00       	push   $0x8043d3
  801aa2:	e8 28 ec ff ff       	call   8006cf <_panic>

00801aa7 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801aa7:	55                   	push   %ebp
  801aa8:	89 e5                	mov    %esp,%ebp
  801aaa:	57                   	push   %edi
  801aab:	56                   	push   %esi
  801aac:	53                   	push   %ebx
  801aad:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801ab0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ab6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ab9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801abc:	8b 7d 18             	mov    0x18(%ebp),%edi
  801abf:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801ac2:	cd 30                	int    $0x30
  801ac4:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801ac7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801aca:	83 c4 10             	add    $0x10,%esp
  801acd:	5b                   	pop    %ebx
  801ace:	5e                   	pop    %esi
  801acf:	5f                   	pop    %edi
  801ad0:	5d                   	pop    %ebp
  801ad1:	c3                   	ret    

00801ad2 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801ad2:	55                   	push   %ebp
  801ad3:	89 e5                	mov    %esp,%ebp
  801ad5:	83 ec 04             	sub    $0x4,%esp
  801ad8:	8b 45 10             	mov    0x10(%ebp),%eax
  801adb:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801ade:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ae2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae5:	6a 00                	push   $0x0
  801ae7:	6a 00                	push   $0x0
  801ae9:	52                   	push   %edx
  801aea:	ff 75 0c             	pushl  0xc(%ebp)
  801aed:	50                   	push   %eax
  801aee:	6a 00                	push   $0x0
  801af0:	e8 b2 ff ff ff       	call   801aa7 <syscall>
  801af5:	83 c4 18             	add    $0x18,%esp
}
  801af8:	90                   	nop
  801af9:	c9                   	leave  
  801afa:	c3                   	ret    

00801afb <sys_cgetc>:

int
sys_cgetc(void)
{
  801afb:	55                   	push   %ebp
  801afc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801afe:	6a 00                	push   $0x0
  801b00:	6a 00                	push   $0x0
  801b02:	6a 00                	push   $0x0
  801b04:	6a 00                	push   $0x0
  801b06:	6a 00                	push   $0x0
  801b08:	6a 01                	push   $0x1
  801b0a:	e8 98 ff ff ff       	call   801aa7 <syscall>
  801b0f:	83 c4 18             	add    $0x18,%esp
}
  801b12:	c9                   	leave  
  801b13:	c3                   	ret    

00801b14 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801b14:	55                   	push   %ebp
  801b15:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801b17:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b1d:	6a 00                	push   $0x0
  801b1f:	6a 00                	push   $0x0
  801b21:	6a 00                	push   $0x0
  801b23:	52                   	push   %edx
  801b24:	50                   	push   %eax
  801b25:	6a 05                	push   $0x5
  801b27:	e8 7b ff ff ff       	call   801aa7 <syscall>
  801b2c:	83 c4 18             	add    $0x18,%esp
}
  801b2f:	c9                   	leave  
  801b30:	c3                   	ret    

00801b31 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801b31:	55                   	push   %ebp
  801b32:	89 e5                	mov    %esp,%ebp
  801b34:	56                   	push   %esi
  801b35:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801b36:	8b 75 18             	mov    0x18(%ebp),%esi
  801b39:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b3c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b3f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b42:	8b 45 08             	mov    0x8(%ebp),%eax
  801b45:	56                   	push   %esi
  801b46:	53                   	push   %ebx
  801b47:	51                   	push   %ecx
  801b48:	52                   	push   %edx
  801b49:	50                   	push   %eax
  801b4a:	6a 06                	push   $0x6
  801b4c:	e8 56 ff ff ff       	call   801aa7 <syscall>
  801b51:	83 c4 18             	add    $0x18,%esp
}
  801b54:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b57:	5b                   	pop    %ebx
  801b58:	5e                   	pop    %esi
  801b59:	5d                   	pop    %ebp
  801b5a:	c3                   	ret    

00801b5b <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801b5b:	55                   	push   %ebp
  801b5c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801b5e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b61:	8b 45 08             	mov    0x8(%ebp),%eax
  801b64:	6a 00                	push   $0x0
  801b66:	6a 00                	push   $0x0
  801b68:	6a 00                	push   $0x0
  801b6a:	52                   	push   %edx
  801b6b:	50                   	push   %eax
  801b6c:	6a 07                	push   $0x7
  801b6e:	e8 34 ff ff ff       	call   801aa7 <syscall>
  801b73:	83 c4 18             	add    $0x18,%esp
}
  801b76:	c9                   	leave  
  801b77:	c3                   	ret    

00801b78 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801b78:	55                   	push   %ebp
  801b79:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801b7b:	6a 00                	push   $0x0
  801b7d:	6a 00                	push   $0x0
  801b7f:	6a 00                	push   $0x0
  801b81:	ff 75 0c             	pushl  0xc(%ebp)
  801b84:	ff 75 08             	pushl  0x8(%ebp)
  801b87:	6a 08                	push   $0x8
  801b89:	e8 19 ff ff ff       	call   801aa7 <syscall>
  801b8e:	83 c4 18             	add    $0x18,%esp
}
  801b91:	c9                   	leave  
  801b92:	c3                   	ret    

00801b93 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801b93:	55                   	push   %ebp
  801b94:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801b96:	6a 00                	push   $0x0
  801b98:	6a 00                	push   $0x0
  801b9a:	6a 00                	push   $0x0
  801b9c:	6a 00                	push   $0x0
  801b9e:	6a 00                	push   $0x0
  801ba0:	6a 09                	push   $0x9
  801ba2:	e8 00 ff ff ff       	call   801aa7 <syscall>
  801ba7:	83 c4 18             	add    $0x18,%esp
}
  801baa:	c9                   	leave  
  801bab:	c3                   	ret    

00801bac <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801bac:	55                   	push   %ebp
  801bad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801baf:	6a 00                	push   $0x0
  801bb1:	6a 00                	push   $0x0
  801bb3:	6a 00                	push   $0x0
  801bb5:	6a 00                	push   $0x0
  801bb7:	6a 00                	push   $0x0
  801bb9:	6a 0a                	push   $0xa
  801bbb:	e8 e7 fe ff ff       	call   801aa7 <syscall>
  801bc0:	83 c4 18             	add    $0x18,%esp
}
  801bc3:	c9                   	leave  
  801bc4:	c3                   	ret    

00801bc5 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801bc5:	55                   	push   %ebp
  801bc6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801bc8:	6a 00                	push   $0x0
  801bca:	6a 00                	push   $0x0
  801bcc:	6a 00                	push   $0x0
  801bce:	6a 00                	push   $0x0
  801bd0:	6a 00                	push   $0x0
  801bd2:	6a 0b                	push   $0xb
  801bd4:	e8 ce fe ff ff       	call   801aa7 <syscall>
  801bd9:	83 c4 18             	add    $0x18,%esp
}
  801bdc:	c9                   	leave  
  801bdd:	c3                   	ret    

00801bde <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801bde:	55                   	push   %ebp
  801bdf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801be1:	6a 00                	push   $0x0
  801be3:	6a 00                	push   $0x0
  801be5:	6a 00                	push   $0x0
  801be7:	ff 75 0c             	pushl  0xc(%ebp)
  801bea:	ff 75 08             	pushl  0x8(%ebp)
  801bed:	6a 0f                	push   $0xf
  801bef:	e8 b3 fe ff ff       	call   801aa7 <syscall>
  801bf4:	83 c4 18             	add    $0x18,%esp
	return;
  801bf7:	90                   	nop
}
  801bf8:	c9                   	leave  
  801bf9:	c3                   	ret    

00801bfa <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801bfa:	55                   	push   %ebp
  801bfb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801bfd:	6a 00                	push   $0x0
  801bff:	6a 00                	push   $0x0
  801c01:	6a 00                	push   $0x0
  801c03:	ff 75 0c             	pushl  0xc(%ebp)
  801c06:	ff 75 08             	pushl  0x8(%ebp)
  801c09:	6a 10                	push   $0x10
  801c0b:	e8 97 fe ff ff       	call   801aa7 <syscall>
  801c10:	83 c4 18             	add    $0x18,%esp
	return ;
  801c13:	90                   	nop
}
  801c14:	c9                   	leave  
  801c15:	c3                   	ret    

00801c16 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801c16:	55                   	push   %ebp
  801c17:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801c19:	6a 00                	push   $0x0
  801c1b:	6a 00                	push   $0x0
  801c1d:	ff 75 10             	pushl  0x10(%ebp)
  801c20:	ff 75 0c             	pushl  0xc(%ebp)
  801c23:	ff 75 08             	pushl  0x8(%ebp)
  801c26:	6a 11                	push   $0x11
  801c28:	e8 7a fe ff ff       	call   801aa7 <syscall>
  801c2d:	83 c4 18             	add    $0x18,%esp
	return ;
  801c30:	90                   	nop
}
  801c31:	c9                   	leave  
  801c32:	c3                   	ret    

00801c33 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801c33:	55                   	push   %ebp
  801c34:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801c36:	6a 00                	push   $0x0
  801c38:	6a 00                	push   $0x0
  801c3a:	6a 00                	push   $0x0
  801c3c:	6a 00                	push   $0x0
  801c3e:	6a 00                	push   $0x0
  801c40:	6a 0c                	push   $0xc
  801c42:	e8 60 fe ff ff       	call   801aa7 <syscall>
  801c47:	83 c4 18             	add    $0x18,%esp
}
  801c4a:	c9                   	leave  
  801c4b:	c3                   	ret    

00801c4c <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801c4c:	55                   	push   %ebp
  801c4d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801c4f:	6a 00                	push   $0x0
  801c51:	6a 00                	push   $0x0
  801c53:	6a 00                	push   $0x0
  801c55:	6a 00                	push   $0x0
  801c57:	ff 75 08             	pushl  0x8(%ebp)
  801c5a:	6a 0d                	push   $0xd
  801c5c:	e8 46 fe ff ff       	call   801aa7 <syscall>
  801c61:	83 c4 18             	add    $0x18,%esp
}
  801c64:	c9                   	leave  
  801c65:	c3                   	ret    

00801c66 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801c66:	55                   	push   %ebp
  801c67:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801c69:	6a 00                	push   $0x0
  801c6b:	6a 00                	push   $0x0
  801c6d:	6a 00                	push   $0x0
  801c6f:	6a 00                	push   $0x0
  801c71:	6a 00                	push   $0x0
  801c73:	6a 0e                	push   $0xe
  801c75:	e8 2d fe ff ff       	call   801aa7 <syscall>
  801c7a:	83 c4 18             	add    $0x18,%esp
}
  801c7d:	90                   	nop
  801c7e:	c9                   	leave  
  801c7f:	c3                   	ret    

00801c80 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801c80:	55                   	push   %ebp
  801c81:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801c83:	6a 00                	push   $0x0
  801c85:	6a 00                	push   $0x0
  801c87:	6a 00                	push   $0x0
  801c89:	6a 00                	push   $0x0
  801c8b:	6a 00                	push   $0x0
  801c8d:	6a 13                	push   $0x13
  801c8f:	e8 13 fe ff ff       	call   801aa7 <syscall>
  801c94:	83 c4 18             	add    $0x18,%esp
}
  801c97:	90                   	nop
  801c98:	c9                   	leave  
  801c99:	c3                   	ret    

00801c9a <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801c9a:	55                   	push   %ebp
  801c9b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801c9d:	6a 00                	push   $0x0
  801c9f:	6a 00                	push   $0x0
  801ca1:	6a 00                	push   $0x0
  801ca3:	6a 00                	push   $0x0
  801ca5:	6a 00                	push   $0x0
  801ca7:	6a 14                	push   $0x14
  801ca9:	e8 f9 fd ff ff       	call   801aa7 <syscall>
  801cae:	83 c4 18             	add    $0x18,%esp
}
  801cb1:	90                   	nop
  801cb2:	c9                   	leave  
  801cb3:	c3                   	ret    

00801cb4 <sys_cputc>:


void
sys_cputc(const char c)
{
  801cb4:	55                   	push   %ebp
  801cb5:	89 e5                	mov    %esp,%ebp
  801cb7:	83 ec 04             	sub    $0x4,%esp
  801cba:	8b 45 08             	mov    0x8(%ebp),%eax
  801cbd:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801cc0:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801cc4:	6a 00                	push   $0x0
  801cc6:	6a 00                	push   $0x0
  801cc8:	6a 00                	push   $0x0
  801cca:	6a 00                	push   $0x0
  801ccc:	50                   	push   %eax
  801ccd:	6a 15                	push   $0x15
  801ccf:	e8 d3 fd ff ff       	call   801aa7 <syscall>
  801cd4:	83 c4 18             	add    $0x18,%esp
}
  801cd7:	90                   	nop
  801cd8:	c9                   	leave  
  801cd9:	c3                   	ret    

00801cda <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801cda:	55                   	push   %ebp
  801cdb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801cdd:	6a 00                	push   $0x0
  801cdf:	6a 00                	push   $0x0
  801ce1:	6a 00                	push   $0x0
  801ce3:	6a 00                	push   $0x0
  801ce5:	6a 00                	push   $0x0
  801ce7:	6a 16                	push   $0x16
  801ce9:	e8 b9 fd ff ff       	call   801aa7 <syscall>
  801cee:	83 c4 18             	add    $0x18,%esp
}
  801cf1:	90                   	nop
  801cf2:	c9                   	leave  
  801cf3:	c3                   	ret    

00801cf4 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801cf4:	55                   	push   %ebp
  801cf5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801cf7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cfa:	6a 00                	push   $0x0
  801cfc:	6a 00                	push   $0x0
  801cfe:	6a 00                	push   $0x0
  801d00:	ff 75 0c             	pushl  0xc(%ebp)
  801d03:	50                   	push   %eax
  801d04:	6a 17                	push   $0x17
  801d06:	e8 9c fd ff ff       	call   801aa7 <syscall>
  801d0b:	83 c4 18             	add    $0x18,%esp
}
  801d0e:	c9                   	leave  
  801d0f:	c3                   	ret    

00801d10 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801d10:	55                   	push   %ebp
  801d11:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d13:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d16:	8b 45 08             	mov    0x8(%ebp),%eax
  801d19:	6a 00                	push   $0x0
  801d1b:	6a 00                	push   $0x0
  801d1d:	6a 00                	push   $0x0
  801d1f:	52                   	push   %edx
  801d20:	50                   	push   %eax
  801d21:	6a 1a                	push   $0x1a
  801d23:	e8 7f fd ff ff       	call   801aa7 <syscall>
  801d28:	83 c4 18             	add    $0x18,%esp
}
  801d2b:	c9                   	leave  
  801d2c:	c3                   	ret    

00801d2d <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801d2d:	55                   	push   %ebp
  801d2e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d30:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d33:	8b 45 08             	mov    0x8(%ebp),%eax
  801d36:	6a 00                	push   $0x0
  801d38:	6a 00                	push   $0x0
  801d3a:	6a 00                	push   $0x0
  801d3c:	52                   	push   %edx
  801d3d:	50                   	push   %eax
  801d3e:	6a 18                	push   $0x18
  801d40:	e8 62 fd ff ff       	call   801aa7 <syscall>
  801d45:	83 c4 18             	add    $0x18,%esp
}
  801d48:	90                   	nop
  801d49:	c9                   	leave  
  801d4a:	c3                   	ret    

00801d4b <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801d4b:	55                   	push   %ebp
  801d4c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d4e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d51:	8b 45 08             	mov    0x8(%ebp),%eax
  801d54:	6a 00                	push   $0x0
  801d56:	6a 00                	push   $0x0
  801d58:	6a 00                	push   $0x0
  801d5a:	52                   	push   %edx
  801d5b:	50                   	push   %eax
  801d5c:	6a 19                	push   $0x19
  801d5e:	e8 44 fd ff ff       	call   801aa7 <syscall>
  801d63:	83 c4 18             	add    $0x18,%esp
}
  801d66:	90                   	nop
  801d67:	c9                   	leave  
  801d68:	c3                   	ret    

00801d69 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801d69:	55                   	push   %ebp
  801d6a:	89 e5                	mov    %esp,%ebp
  801d6c:	83 ec 04             	sub    $0x4,%esp
  801d6f:	8b 45 10             	mov    0x10(%ebp),%eax
  801d72:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801d75:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801d78:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801d7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d7f:	6a 00                	push   $0x0
  801d81:	51                   	push   %ecx
  801d82:	52                   	push   %edx
  801d83:	ff 75 0c             	pushl  0xc(%ebp)
  801d86:	50                   	push   %eax
  801d87:	6a 1b                	push   $0x1b
  801d89:	e8 19 fd ff ff       	call   801aa7 <syscall>
  801d8e:	83 c4 18             	add    $0x18,%esp
}
  801d91:	c9                   	leave  
  801d92:	c3                   	ret    

00801d93 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801d93:	55                   	push   %ebp
  801d94:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801d96:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d99:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9c:	6a 00                	push   $0x0
  801d9e:	6a 00                	push   $0x0
  801da0:	6a 00                	push   $0x0
  801da2:	52                   	push   %edx
  801da3:	50                   	push   %eax
  801da4:	6a 1c                	push   $0x1c
  801da6:	e8 fc fc ff ff       	call   801aa7 <syscall>
  801dab:	83 c4 18             	add    $0x18,%esp
}
  801dae:	c9                   	leave  
  801daf:	c3                   	ret    

00801db0 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801db0:	55                   	push   %ebp
  801db1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801db3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801db6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801db9:	8b 45 08             	mov    0x8(%ebp),%eax
  801dbc:	6a 00                	push   $0x0
  801dbe:	6a 00                	push   $0x0
  801dc0:	51                   	push   %ecx
  801dc1:	52                   	push   %edx
  801dc2:	50                   	push   %eax
  801dc3:	6a 1d                	push   $0x1d
  801dc5:	e8 dd fc ff ff       	call   801aa7 <syscall>
  801dca:	83 c4 18             	add    $0x18,%esp
}
  801dcd:	c9                   	leave  
  801dce:	c3                   	ret    

00801dcf <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801dcf:	55                   	push   %ebp
  801dd0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801dd2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dd5:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd8:	6a 00                	push   $0x0
  801dda:	6a 00                	push   $0x0
  801ddc:	6a 00                	push   $0x0
  801dde:	52                   	push   %edx
  801ddf:	50                   	push   %eax
  801de0:	6a 1e                	push   $0x1e
  801de2:	e8 c0 fc ff ff       	call   801aa7 <syscall>
  801de7:	83 c4 18             	add    $0x18,%esp
}
  801dea:	c9                   	leave  
  801deb:	c3                   	ret    

00801dec <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801dec:	55                   	push   %ebp
  801ded:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801def:	6a 00                	push   $0x0
  801df1:	6a 00                	push   $0x0
  801df3:	6a 00                	push   $0x0
  801df5:	6a 00                	push   $0x0
  801df7:	6a 00                	push   $0x0
  801df9:	6a 1f                	push   $0x1f
  801dfb:	e8 a7 fc ff ff       	call   801aa7 <syscall>
  801e00:	83 c4 18             	add    $0x18,%esp
}
  801e03:	c9                   	leave  
  801e04:	c3                   	ret    

00801e05 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801e05:	55                   	push   %ebp
  801e06:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801e08:	8b 45 08             	mov    0x8(%ebp),%eax
  801e0b:	6a 00                	push   $0x0
  801e0d:	ff 75 14             	pushl  0x14(%ebp)
  801e10:	ff 75 10             	pushl  0x10(%ebp)
  801e13:	ff 75 0c             	pushl  0xc(%ebp)
  801e16:	50                   	push   %eax
  801e17:	6a 20                	push   $0x20
  801e19:	e8 89 fc ff ff       	call   801aa7 <syscall>
  801e1e:	83 c4 18             	add    $0x18,%esp
}
  801e21:	c9                   	leave  
  801e22:	c3                   	ret    

00801e23 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801e23:	55                   	push   %ebp
  801e24:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801e26:	8b 45 08             	mov    0x8(%ebp),%eax
  801e29:	6a 00                	push   $0x0
  801e2b:	6a 00                	push   $0x0
  801e2d:	6a 00                	push   $0x0
  801e2f:	6a 00                	push   $0x0
  801e31:	50                   	push   %eax
  801e32:	6a 21                	push   $0x21
  801e34:	e8 6e fc ff ff       	call   801aa7 <syscall>
  801e39:	83 c4 18             	add    $0x18,%esp
}
  801e3c:	90                   	nop
  801e3d:	c9                   	leave  
  801e3e:	c3                   	ret    

00801e3f <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801e3f:	55                   	push   %ebp
  801e40:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801e42:	8b 45 08             	mov    0x8(%ebp),%eax
  801e45:	6a 00                	push   $0x0
  801e47:	6a 00                	push   $0x0
  801e49:	6a 00                	push   $0x0
  801e4b:	6a 00                	push   $0x0
  801e4d:	50                   	push   %eax
  801e4e:	6a 22                	push   $0x22
  801e50:	e8 52 fc ff ff       	call   801aa7 <syscall>
  801e55:	83 c4 18             	add    $0x18,%esp
}
  801e58:	c9                   	leave  
  801e59:	c3                   	ret    

00801e5a <sys_getenvid>:

int32 sys_getenvid(void)
{
  801e5a:	55                   	push   %ebp
  801e5b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801e5d:	6a 00                	push   $0x0
  801e5f:	6a 00                	push   $0x0
  801e61:	6a 00                	push   $0x0
  801e63:	6a 00                	push   $0x0
  801e65:	6a 00                	push   $0x0
  801e67:	6a 02                	push   $0x2
  801e69:	e8 39 fc ff ff       	call   801aa7 <syscall>
  801e6e:	83 c4 18             	add    $0x18,%esp
}
  801e71:	c9                   	leave  
  801e72:	c3                   	ret    

00801e73 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801e73:	55                   	push   %ebp
  801e74:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801e76:	6a 00                	push   $0x0
  801e78:	6a 00                	push   $0x0
  801e7a:	6a 00                	push   $0x0
  801e7c:	6a 00                	push   $0x0
  801e7e:	6a 00                	push   $0x0
  801e80:	6a 03                	push   $0x3
  801e82:	e8 20 fc ff ff       	call   801aa7 <syscall>
  801e87:	83 c4 18             	add    $0x18,%esp
}
  801e8a:	c9                   	leave  
  801e8b:	c3                   	ret    

00801e8c <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801e8c:	55                   	push   %ebp
  801e8d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801e8f:	6a 00                	push   $0x0
  801e91:	6a 00                	push   $0x0
  801e93:	6a 00                	push   $0x0
  801e95:	6a 00                	push   $0x0
  801e97:	6a 00                	push   $0x0
  801e99:	6a 04                	push   $0x4
  801e9b:	e8 07 fc ff ff       	call   801aa7 <syscall>
  801ea0:	83 c4 18             	add    $0x18,%esp
}
  801ea3:	c9                   	leave  
  801ea4:	c3                   	ret    

00801ea5 <sys_exit_env>:


void sys_exit_env(void)
{
  801ea5:	55                   	push   %ebp
  801ea6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801ea8:	6a 00                	push   $0x0
  801eaa:	6a 00                	push   $0x0
  801eac:	6a 00                	push   $0x0
  801eae:	6a 00                	push   $0x0
  801eb0:	6a 00                	push   $0x0
  801eb2:	6a 23                	push   $0x23
  801eb4:	e8 ee fb ff ff       	call   801aa7 <syscall>
  801eb9:	83 c4 18             	add    $0x18,%esp
}
  801ebc:	90                   	nop
  801ebd:	c9                   	leave  
  801ebe:	c3                   	ret    

00801ebf <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801ebf:	55                   	push   %ebp
  801ec0:	89 e5                	mov    %esp,%ebp
  801ec2:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801ec5:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ec8:	8d 50 04             	lea    0x4(%eax),%edx
  801ecb:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ece:	6a 00                	push   $0x0
  801ed0:	6a 00                	push   $0x0
  801ed2:	6a 00                	push   $0x0
  801ed4:	52                   	push   %edx
  801ed5:	50                   	push   %eax
  801ed6:	6a 24                	push   $0x24
  801ed8:	e8 ca fb ff ff       	call   801aa7 <syscall>
  801edd:	83 c4 18             	add    $0x18,%esp
	return result;
  801ee0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ee3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ee6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ee9:	89 01                	mov    %eax,(%ecx)
  801eeb:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801eee:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef1:	c9                   	leave  
  801ef2:	c2 04 00             	ret    $0x4

00801ef5 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801ef5:	55                   	push   %ebp
  801ef6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801ef8:	6a 00                	push   $0x0
  801efa:	6a 00                	push   $0x0
  801efc:	ff 75 10             	pushl  0x10(%ebp)
  801eff:	ff 75 0c             	pushl  0xc(%ebp)
  801f02:	ff 75 08             	pushl  0x8(%ebp)
  801f05:	6a 12                	push   $0x12
  801f07:	e8 9b fb ff ff       	call   801aa7 <syscall>
  801f0c:	83 c4 18             	add    $0x18,%esp
	return ;
  801f0f:	90                   	nop
}
  801f10:	c9                   	leave  
  801f11:	c3                   	ret    

00801f12 <sys_rcr2>:
uint32 sys_rcr2()
{
  801f12:	55                   	push   %ebp
  801f13:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801f15:	6a 00                	push   $0x0
  801f17:	6a 00                	push   $0x0
  801f19:	6a 00                	push   $0x0
  801f1b:	6a 00                	push   $0x0
  801f1d:	6a 00                	push   $0x0
  801f1f:	6a 25                	push   $0x25
  801f21:	e8 81 fb ff ff       	call   801aa7 <syscall>
  801f26:	83 c4 18             	add    $0x18,%esp
}
  801f29:	c9                   	leave  
  801f2a:	c3                   	ret    

00801f2b <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801f2b:	55                   	push   %ebp
  801f2c:	89 e5                	mov    %esp,%ebp
  801f2e:	83 ec 04             	sub    $0x4,%esp
  801f31:	8b 45 08             	mov    0x8(%ebp),%eax
  801f34:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801f37:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801f3b:	6a 00                	push   $0x0
  801f3d:	6a 00                	push   $0x0
  801f3f:	6a 00                	push   $0x0
  801f41:	6a 00                	push   $0x0
  801f43:	50                   	push   %eax
  801f44:	6a 26                	push   $0x26
  801f46:	e8 5c fb ff ff       	call   801aa7 <syscall>
  801f4b:	83 c4 18             	add    $0x18,%esp
	return ;
  801f4e:	90                   	nop
}
  801f4f:	c9                   	leave  
  801f50:	c3                   	ret    

00801f51 <rsttst>:
void rsttst()
{
  801f51:	55                   	push   %ebp
  801f52:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801f54:	6a 00                	push   $0x0
  801f56:	6a 00                	push   $0x0
  801f58:	6a 00                	push   $0x0
  801f5a:	6a 00                	push   $0x0
  801f5c:	6a 00                	push   $0x0
  801f5e:	6a 28                	push   $0x28
  801f60:	e8 42 fb ff ff       	call   801aa7 <syscall>
  801f65:	83 c4 18             	add    $0x18,%esp
	return ;
  801f68:	90                   	nop
}
  801f69:	c9                   	leave  
  801f6a:	c3                   	ret    

00801f6b <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801f6b:	55                   	push   %ebp
  801f6c:	89 e5                	mov    %esp,%ebp
  801f6e:	83 ec 04             	sub    $0x4,%esp
  801f71:	8b 45 14             	mov    0x14(%ebp),%eax
  801f74:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801f77:	8b 55 18             	mov    0x18(%ebp),%edx
  801f7a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801f7e:	52                   	push   %edx
  801f7f:	50                   	push   %eax
  801f80:	ff 75 10             	pushl  0x10(%ebp)
  801f83:	ff 75 0c             	pushl  0xc(%ebp)
  801f86:	ff 75 08             	pushl  0x8(%ebp)
  801f89:	6a 27                	push   $0x27
  801f8b:	e8 17 fb ff ff       	call   801aa7 <syscall>
  801f90:	83 c4 18             	add    $0x18,%esp
	return ;
  801f93:	90                   	nop
}
  801f94:	c9                   	leave  
  801f95:	c3                   	ret    

00801f96 <chktst>:
void chktst(uint32 n)
{
  801f96:	55                   	push   %ebp
  801f97:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801f99:	6a 00                	push   $0x0
  801f9b:	6a 00                	push   $0x0
  801f9d:	6a 00                	push   $0x0
  801f9f:	6a 00                	push   $0x0
  801fa1:	ff 75 08             	pushl  0x8(%ebp)
  801fa4:	6a 29                	push   $0x29
  801fa6:	e8 fc fa ff ff       	call   801aa7 <syscall>
  801fab:	83 c4 18             	add    $0x18,%esp
	return ;
  801fae:	90                   	nop
}
  801faf:	c9                   	leave  
  801fb0:	c3                   	ret    

00801fb1 <inctst>:

void inctst()
{
  801fb1:	55                   	push   %ebp
  801fb2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801fb4:	6a 00                	push   $0x0
  801fb6:	6a 00                	push   $0x0
  801fb8:	6a 00                	push   $0x0
  801fba:	6a 00                	push   $0x0
  801fbc:	6a 00                	push   $0x0
  801fbe:	6a 2a                	push   $0x2a
  801fc0:	e8 e2 fa ff ff       	call   801aa7 <syscall>
  801fc5:	83 c4 18             	add    $0x18,%esp
	return ;
  801fc8:	90                   	nop
}
  801fc9:	c9                   	leave  
  801fca:	c3                   	ret    

00801fcb <gettst>:
uint32 gettst()
{
  801fcb:	55                   	push   %ebp
  801fcc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801fce:	6a 00                	push   $0x0
  801fd0:	6a 00                	push   $0x0
  801fd2:	6a 00                	push   $0x0
  801fd4:	6a 00                	push   $0x0
  801fd6:	6a 00                	push   $0x0
  801fd8:	6a 2b                	push   $0x2b
  801fda:	e8 c8 fa ff ff       	call   801aa7 <syscall>
  801fdf:	83 c4 18             	add    $0x18,%esp
}
  801fe2:	c9                   	leave  
  801fe3:	c3                   	ret    

00801fe4 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801fe4:	55                   	push   %ebp
  801fe5:	89 e5                	mov    %esp,%ebp
  801fe7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fea:	6a 00                	push   $0x0
  801fec:	6a 00                	push   $0x0
  801fee:	6a 00                	push   $0x0
  801ff0:	6a 00                	push   $0x0
  801ff2:	6a 00                	push   $0x0
  801ff4:	6a 2c                	push   $0x2c
  801ff6:	e8 ac fa ff ff       	call   801aa7 <syscall>
  801ffb:	83 c4 18             	add    $0x18,%esp
  801ffe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802001:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802005:	75 07                	jne    80200e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802007:	b8 01 00 00 00       	mov    $0x1,%eax
  80200c:	eb 05                	jmp    802013 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80200e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802013:	c9                   	leave  
  802014:	c3                   	ret    

00802015 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802015:	55                   	push   %ebp
  802016:	89 e5                	mov    %esp,%ebp
  802018:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80201b:	6a 00                	push   $0x0
  80201d:	6a 00                	push   $0x0
  80201f:	6a 00                	push   $0x0
  802021:	6a 00                	push   $0x0
  802023:	6a 00                	push   $0x0
  802025:	6a 2c                	push   $0x2c
  802027:	e8 7b fa ff ff       	call   801aa7 <syscall>
  80202c:	83 c4 18             	add    $0x18,%esp
  80202f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802032:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802036:	75 07                	jne    80203f <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802038:	b8 01 00 00 00       	mov    $0x1,%eax
  80203d:	eb 05                	jmp    802044 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80203f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802044:	c9                   	leave  
  802045:	c3                   	ret    

00802046 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802046:	55                   	push   %ebp
  802047:	89 e5                	mov    %esp,%ebp
  802049:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80204c:	6a 00                	push   $0x0
  80204e:	6a 00                	push   $0x0
  802050:	6a 00                	push   $0x0
  802052:	6a 00                	push   $0x0
  802054:	6a 00                	push   $0x0
  802056:	6a 2c                	push   $0x2c
  802058:	e8 4a fa ff ff       	call   801aa7 <syscall>
  80205d:	83 c4 18             	add    $0x18,%esp
  802060:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802063:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802067:	75 07                	jne    802070 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802069:	b8 01 00 00 00       	mov    $0x1,%eax
  80206e:	eb 05                	jmp    802075 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802070:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802075:	c9                   	leave  
  802076:	c3                   	ret    

00802077 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802077:	55                   	push   %ebp
  802078:	89 e5                	mov    %esp,%ebp
  80207a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80207d:	6a 00                	push   $0x0
  80207f:	6a 00                	push   $0x0
  802081:	6a 00                	push   $0x0
  802083:	6a 00                	push   $0x0
  802085:	6a 00                	push   $0x0
  802087:	6a 2c                	push   $0x2c
  802089:	e8 19 fa ff ff       	call   801aa7 <syscall>
  80208e:	83 c4 18             	add    $0x18,%esp
  802091:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802094:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802098:	75 07                	jne    8020a1 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80209a:	b8 01 00 00 00       	mov    $0x1,%eax
  80209f:	eb 05                	jmp    8020a6 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8020a1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020a6:	c9                   	leave  
  8020a7:	c3                   	ret    

008020a8 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8020a8:	55                   	push   %ebp
  8020a9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8020ab:	6a 00                	push   $0x0
  8020ad:	6a 00                	push   $0x0
  8020af:	6a 00                	push   $0x0
  8020b1:	6a 00                	push   $0x0
  8020b3:	ff 75 08             	pushl  0x8(%ebp)
  8020b6:	6a 2d                	push   $0x2d
  8020b8:	e8 ea f9 ff ff       	call   801aa7 <syscall>
  8020bd:	83 c4 18             	add    $0x18,%esp
	return ;
  8020c0:	90                   	nop
}
  8020c1:	c9                   	leave  
  8020c2:	c3                   	ret    

008020c3 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8020c3:	55                   	push   %ebp
  8020c4:	89 e5                	mov    %esp,%ebp
  8020c6:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8020c7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8020ca:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8020cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d3:	6a 00                	push   $0x0
  8020d5:	53                   	push   %ebx
  8020d6:	51                   	push   %ecx
  8020d7:	52                   	push   %edx
  8020d8:	50                   	push   %eax
  8020d9:	6a 2e                	push   $0x2e
  8020db:	e8 c7 f9 ff ff       	call   801aa7 <syscall>
  8020e0:	83 c4 18             	add    $0x18,%esp
}
  8020e3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020e6:	c9                   	leave  
  8020e7:	c3                   	ret    

008020e8 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8020e8:	55                   	push   %ebp
  8020e9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8020eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f1:	6a 00                	push   $0x0
  8020f3:	6a 00                	push   $0x0
  8020f5:	6a 00                	push   $0x0
  8020f7:	52                   	push   %edx
  8020f8:	50                   	push   %eax
  8020f9:	6a 2f                	push   $0x2f
  8020fb:	e8 a7 f9 ff ff       	call   801aa7 <syscall>
  802100:	83 c4 18             	add    $0x18,%esp
}
  802103:	c9                   	leave  
  802104:	c3                   	ret    

00802105 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802105:	55                   	push   %ebp
  802106:	89 e5                	mov    %esp,%ebp
  802108:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  80210b:	83 ec 0c             	sub    $0xc,%esp
  80210e:	68 d0 44 80 00       	push   $0x8044d0
  802113:	e8 6b e8 ff ff       	call   800983 <cprintf>
  802118:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  80211b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802122:	83 ec 0c             	sub    $0xc,%esp
  802125:	68 fc 44 80 00       	push   $0x8044fc
  80212a:	e8 54 e8 ff ff       	call   800983 <cprintf>
  80212f:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802132:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802136:	a1 38 51 80 00       	mov    0x805138,%eax
  80213b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80213e:	eb 56                	jmp    802196 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802140:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802144:	74 1c                	je     802162 <print_mem_block_lists+0x5d>
  802146:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802149:	8b 50 08             	mov    0x8(%eax),%edx
  80214c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80214f:	8b 48 08             	mov    0x8(%eax),%ecx
  802152:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802155:	8b 40 0c             	mov    0xc(%eax),%eax
  802158:	01 c8                	add    %ecx,%eax
  80215a:	39 c2                	cmp    %eax,%edx
  80215c:	73 04                	jae    802162 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  80215e:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802162:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802165:	8b 50 08             	mov    0x8(%eax),%edx
  802168:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80216b:	8b 40 0c             	mov    0xc(%eax),%eax
  80216e:	01 c2                	add    %eax,%edx
  802170:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802173:	8b 40 08             	mov    0x8(%eax),%eax
  802176:	83 ec 04             	sub    $0x4,%esp
  802179:	52                   	push   %edx
  80217a:	50                   	push   %eax
  80217b:	68 11 45 80 00       	push   $0x804511
  802180:	e8 fe e7 ff ff       	call   800983 <cprintf>
  802185:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802188:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80218b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80218e:	a1 40 51 80 00       	mov    0x805140,%eax
  802193:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802196:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80219a:	74 07                	je     8021a3 <print_mem_block_lists+0x9e>
  80219c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80219f:	8b 00                	mov    (%eax),%eax
  8021a1:	eb 05                	jmp    8021a8 <print_mem_block_lists+0xa3>
  8021a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8021a8:	a3 40 51 80 00       	mov    %eax,0x805140
  8021ad:	a1 40 51 80 00       	mov    0x805140,%eax
  8021b2:	85 c0                	test   %eax,%eax
  8021b4:	75 8a                	jne    802140 <print_mem_block_lists+0x3b>
  8021b6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021ba:	75 84                	jne    802140 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8021bc:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8021c0:	75 10                	jne    8021d2 <print_mem_block_lists+0xcd>
  8021c2:	83 ec 0c             	sub    $0xc,%esp
  8021c5:	68 20 45 80 00       	push   $0x804520
  8021ca:	e8 b4 e7 ff ff       	call   800983 <cprintf>
  8021cf:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8021d2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8021d9:	83 ec 0c             	sub    $0xc,%esp
  8021dc:	68 44 45 80 00       	push   $0x804544
  8021e1:	e8 9d e7 ff ff       	call   800983 <cprintf>
  8021e6:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8021e9:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8021ed:	a1 40 50 80 00       	mov    0x805040,%eax
  8021f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021f5:	eb 56                	jmp    80224d <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8021f7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8021fb:	74 1c                	je     802219 <print_mem_block_lists+0x114>
  8021fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802200:	8b 50 08             	mov    0x8(%eax),%edx
  802203:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802206:	8b 48 08             	mov    0x8(%eax),%ecx
  802209:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80220c:	8b 40 0c             	mov    0xc(%eax),%eax
  80220f:	01 c8                	add    %ecx,%eax
  802211:	39 c2                	cmp    %eax,%edx
  802213:	73 04                	jae    802219 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802215:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802219:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80221c:	8b 50 08             	mov    0x8(%eax),%edx
  80221f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802222:	8b 40 0c             	mov    0xc(%eax),%eax
  802225:	01 c2                	add    %eax,%edx
  802227:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80222a:	8b 40 08             	mov    0x8(%eax),%eax
  80222d:	83 ec 04             	sub    $0x4,%esp
  802230:	52                   	push   %edx
  802231:	50                   	push   %eax
  802232:	68 11 45 80 00       	push   $0x804511
  802237:	e8 47 e7 ff ff       	call   800983 <cprintf>
  80223c:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80223f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802242:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802245:	a1 48 50 80 00       	mov    0x805048,%eax
  80224a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80224d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802251:	74 07                	je     80225a <print_mem_block_lists+0x155>
  802253:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802256:	8b 00                	mov    (%eax),%eax
  802258:	eb 05                	jmp    80225f <print_mem_block_lists+0x15a>
  80225a:	b8 00 00 00 00       	mov    $0x0,%eax
  80225f:	a3 48 50 80 00       	mov    %eax,0x805048
  802264:	a1 48 50 80 00       	mov    0x805048,%eax
  802269:	85 c0                	test   %eax,%eax
  80226b:	75 8a                	jne    8021f7 <print_mem_block_lists+0xf2>
  80226d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802271:	75 84                	jne    8021f7 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802273:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802277:	75 10                	jne    802289 <print_mem_block_lists+0x184>
  802279:	83 ec 0c             	sub    $0xc,%esp
  80227c:	68 5c 45 80 00       	push   $0x80455c
  802281:	e8 fd e6 ff ff       	call   800983 <cprintf>
  802286:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802289:	83 ec 0c             	sub    $0xc,%esp
  80228c:	68 d0 44 80 00       	push   $0x8044d0
  802291:	e8 ed e6 ff ff       	call   800983 <cprintf>
  802296:	83 c4 10             	add    $0x10,%esp

}
  802299:	90                   	nop
  80229a:	c9                   	leave  
  80229b:	c3                   	ret    

0080229c <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  80229c:	55                   	push   %ebp
  80229d:	89 e5                	mov    %esp,%ebp
  80229f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  8022a2:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  8022a9:	00 00 00 
  8022ac:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  8022b3:	00 00 00 
  8022b6:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  8022bd:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  8022c0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8022c7:	e9 9e 00 00 00       	jmp    80236a <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  8022cc:	a1 50 50 80 00       	mov    0x805050,%eax
  8022d1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022d4:	c1 e2 04             	shl    $0x4,%edx
  8022d7:	01 d0                	add    %edx,%eax
  8022d9:	85 c0                	test   %eax,%eax
  8022db:	75 14                	jne    8022f1 <initialize_MemBlocksList+0x55>
  8022dd:	83 ec 04             	sub    $0x4,%esp
  8022e0:	68 84 45 80 00       	push   $0x804584
  8022e5:	6a 46                	push   $0x46
  8022e7:	68 a7 45 80 00       	push   $0x8045a7
  8022ec:	e8 de e3 ff ff       	call   8006cf <_panic>
  8022f1:	a1 50 50 80 00       	mov    0x805050,%eax
  8022f6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022f9:	c1 e2 04             	shl    $0x4,%edx
  8022fc:	01 d0                	add    %edx,%eax
  8022fe:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802304:	89 10                	mov    %edx,(%eax)
  802306:	8b 00                	mov    (%eax),%eax
  802308:	85 c0                	test   %eax,%eax
  80230a:	74 18                	je     802324 <initialize_MemBlocksList+0x88>
  80230c:	a1 48 51 80 00       	mov    0x805148,%eax
  802311:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802317:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80231a:	c1 e1 04             	shl    $0x4,%ecx
  80231d:	01 ca                	add    %ecx,%edx
  80231f:	89 50 04             	mov    %edx,0x4(%eax)
  802322:	eb 12                	jmp    802336 <initialize_MemBlocksList+0x9a>
  802324:	a1 50 50 80 00       	mov    0x805050,%eax
  802329:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80232c:	c1 e2 04             	shl    $0x4,%edx
  80232f:	01 d0                	add    %edx,%eax
  802331:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802336:	a1 50 50 80 00       	mov    0x805050,%eax
  80233b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80233e:	c1 e2 04             	shl    $0x4,%edx
  802341:	01 d0                	add    %edx,%eax
  802343:	a3 48 51 80 00       	mov    %eax,0x805148
  802348:	a1 50 50 80 00       	mov    0x805050,%eax
  80234d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802350:	c1 e2 04             	shl    $0x4,%edx
  802353:	01 d0                	add    %edx,%eax
  802355:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80235c:	a1 54 51 80 00       	mov    0x805154,%eax
  802361:	40                   	inc    %eax
  802362:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  802367:	ff 45 f4             	incl   -0xc(%ebp)
  80236a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802370:	0f 82 56 ff ff ff    	jb     8022cc <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  802376:	90                   	nop
  802377:	c9                   	leave  
  802378:	c3                   	ret    

00802379 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802379:	55                   	push   %ebp
  80237a:	89 e5                	mov    %esp,%ebp
  80237c:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  80237f:	8b 45 08             	mov    0x8(%ebp),%eax
  802382:	8b 00                	mov    (%eax),%eax
  802384:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802387:	eb 19                	jmp    8023a2 <find_block+0x29>
	{
		if(va==point->sva)
  802389:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80238c:	8b 40 08             	mov    0x8(%eax),%eax
  80238f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802392:	75 05                	jne    802399 <find_block+0x20>
		   return point;
  802394:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802397:	eb 36                	jmp    8023cf <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802399:	8b 45 08             	mov    0x8(%ebp),%eax
  80239c:	8b 40 08             	mov    0x8(%eax),%eax
  80239f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8023a2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8023a6:	74 07                	je     8023af <find_block+0x36>
  8023a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8023ab:	8b 00                	mov    (%eax),%eax
  8023ad:	eb 05                	jmp    8023b4 <find_block+0x3b>
  8023af:	b8 00 00 00 00       	mov    $0x0,%eax
  8023b4:	8b 55 08             	mov    0x8(%ebp),%edx
  8023b7:	89 42 08             	mov    %eax,0x8(%edx)
  8023ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8023bd:	8b 40 08             	mov    0x8(%eax),%eax
  8023c0:	85 c0                	test   %eax,%eax
  8023c2:	75 c5                	jne    802389 <find_block+0x10>
  8023c4:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8023c8:	75 bf                	jne    802389 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  8023ca:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023cf:	c9                   	leave  
  8023d0:	c3                   	ret    

008023d1 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8023d1:	55                   	push   %ebp
  8023d2:	89 e5                	mov    %esp,%ebp
  8023d4:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  8023d7:	a1 40 50 80 00       	mov    0x805040,%eax
  8023dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  8023df:	a1 44 50 80 00       	mov    0x805044,%eax
  8023e4:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  8023e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023ea:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8023ed:	74 24                	je     802413 <insert_sorted_allocList+0x42>
  8023ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f2:	8b 50 08             	mov    0x8(%eax),%edx
  8023f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023f8:	8b 40 08             	mov    0x8(%eax),%eax
  8023fb:	39 c2                	cmp    %eax,%edx
  8023fd:	76 14                	jbe    802413 <insert_sorted_allocList+0x42>
  8023ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802402:	8b 50 08             	mov    0x8(%eax),%edx
  802405:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802408:	8b 40 08             	mov    0x8(%eax),%eax
  80240b:	39 c2                	cmp    %eax,%edx
  80240d:	0f 82 60 01 00 00    	jb     802573 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802413:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802417:	75 65                	jne    80247e <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802419:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80241d:	75 14                	jne    802433 <insert_sorted_allocList+0x62>
  80241f:	83 ec 04             	sub    $0x4,%esp
  802422:	68 84 45 80 00       	push   $0x804584
  802427:	6a 6b                	push   $0x6b
  802429:	68 a7 45 80 00       	push   $0x8045a7
  80242e:	e8 9c e2 ff ff       	call   8006cf <_panic>
  802433:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802439:	8b 45 08             	mov    0x8(%ebp),%eax
  80243c:	89 10                	mov    %edx,(%eax)
  80243e:	8b 45 08             	mov    0x8(%ebp),%eax
  802441:	8b 00                	mov    (%eax),%eax
  802443:	85 c0                	test   %eax,%eax
  802445:	74 0d                	je     802454 <insert_sorted_allocList+0x83>
  802447:	a1 40 50 80 00       	mov    0x805040,%eax
  80244c:	8b 55 08             	mov    0x8(%ebp),%edx
  80244f:	89 50 04             	mov    %edx,0x4(%eax)
  802452:	eb 08                	jmp    80245c <insert_sorted_allocList+0x8b>
  802454:	8b 45 08             	mov    0x8(%ebp),%eax
  802457:	a3 44 50 80 00       	mov    %eax,0x805044
  80245c:	8b 45 08             	mov    0x8(%ebp),%eax
  80245f:	a3 40 50 80 00       	mov    %eax,0x805040
  802464:	8b 45 08             	mov    0x8(%ebp),%eax
  802467:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80246e:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802473:	40                   	inc    %eax
  802474:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802479:	e9 dc 01 00 00       	jmp    80265a <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  80247e:	8b 45 08             	mov    0x8(%ebp),%eax
  802481:	8b 50 08             	mov    0x8(%eax),%edx
  802484:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802487:	8b 40 08             	mov    0x8(%eax),%eax
  80248a:	39 c2                	cmp    %eax,%edx
  80248c:	77 6c                	ja     8024fa <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  80248e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802492:	74 06                	je     80249a <insert_sorted_allocList+0xc9>
  802494:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802498:	75 14                	jne    8024ae <insert_sorted_allocList+0xdd>
  80249a:	83 ec 04             	sub    $0x4,%esp
  80249d:	68 c0 45 80 00       	push   $0x8045c0
  8024a2:	6a 6f                	push   $0x6f
  8024a4:	68 a7 45 80 00       	push   $0x8045a7
  8024a9:	e8 21 e2 ff ff       	call   8006cf <_panic>
  8024ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024b1:	8b 50 04             	mov    0x4(%eax),%edx
  8024b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b7:	89 50 04             	mov    %edx,0x4(%eax)
  8024ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8024bd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024c0:	89 10                	mov    %edx,(%eax)
  8024c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024c5:	8b 40 04             	mov    0x4(%eax),%eax
  8024c8:	85 c0                	test   %eax,%eax
  8024ca:	74 0d                	je     8024d9 <insert_sorted_allocList+0x108>
  8024cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024cf:	8b 40 04             	mov    0x4(%eax),%eax
  8024d2:	8b 55 08             	mov    0x8(%ebp),%edx
  8024d5:	89 10                	mov    %edx,(%eax)
  8024d7:	eb 08                	jmp    8024e1 <insert_sorted_allocList+0x110>
  8024d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8024dc:	a3 40 50 80 00       	mov    %eax,0x805040
  8024e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024e4:	8b 55 08             	mov    0x8(%ebp),%edx
  8024e7:	89 50 04             	mov    %edx,0x4(%eax)
  8024ea:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8024ef:	40                   	inc    %eax
  8024f0:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8024f5:	e9 60 01 00 00       	jmp    80265a <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  8024fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8024fd:	8b 50 08             	mov    0x8(%eax),%edx
  802500:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802503:	8b 40 08             	mov    0x8(%eax),%eax
  802506:	39 c2                	cmp    %eax,%edx
  802508:	0f 82 4c 01 00 00    	jb     80265a <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  80250e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802512:	75 14                	jne    802528 <insert_sorted_allocList+0x157>
  802514:	83 ec 04             	sub    $0x4,%esp
  802517:	68 f8 45 80 00       	push   $0x8045f8
  80251c:	6a 73                	push   $0x73
  80251e:	68 a7 45 80 00       	push   $0x8045a7
  802523:	e8 a7 e1 ff ff       	call   8006cf <_panic>
  802528:	8b 15 44 50 80 00    	mov    0x805044,%edx
  80252e:	8b 45 08             	mov    0x8(%ebp),%eax
  802531:	89 50 04             	mov    %edx,0x4(%eax)
  802534:	8b 45 08             	mov    0x8(%ebp),%eax
  802537:	8b 40 04             	mov    0x4(%eax),%eax
  80253a:	85 c0                	test   %eax,%eax
  80253c:	74 0c                	je     80254a <insert_sorted_allocList+0x179>
  80253e:	a1 44 50 80 00       	mov    0x805044,%eax
  802543:	8b 55 08             	mov    0x8(%ebp),%edx
  802546:	89 10                	mov    %edx,(%eax)
  802548:	eb 08                	jmp    802552 <insert_sorted_allocList+0x181>
  80254a:	8b 45 08             	mov    0x8(%ebp),%eax
  80254d:	a3 40 50 80 00       	mov    %eax,0x805040
  802552:	8b 45 08             	mov    0x8(%ebp),%eax
  802555:	a3 44 50 80 00       	mov    %eax,0x805044
  80255a:	8b 45 08             	mov    0x8(%ebp),%eax
  80255d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802563:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802568:	40                   	inc    %eax
  802569:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80256e:	e9 e7 00 00 00       	jmp    80265a <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802573:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802576:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802579:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802580:	a1 40 50 80 00       	mov    0x805040,%eax
  802585:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802588:	e9 9d 00 00 00       	jmp    80262a <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  80258d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802590:	8b 00                	mov    (%eax),%eax
  802592:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802595:	8b 45 08             	mov    0x8(%ebp),%eax
  802598:	8b 50 08             	mov    0x8(%eax),%edx
  80259b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259e:	8b 40 08             	mov    0x8(%eax),%eax
  8025a1:	39 c2                	cmp    %eax,%edx
  8025a3:	76 7d                	jbe    802622 <insert_sorted_allocList+0x251>
  8025a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a8:	8b 50 08             	mov    0x8(%eax),%edx
  8025ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8025ae:	8b 40 08             	mov    0x8(%eax),%eax
  8025b1:	39 c2                	cmp    %eax,%edx
  8025b3:	73 6d                	jae    802622 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  8025b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025b9:	74 06                	je     8025c1 <insert_sorted_allocList+0x1f0>
  8025bb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8025bf:	75 14                	jne    8025d5 <insert_sorted_allocList+0x204>
  8025c1:	83 ec 04             	sub    $0x4,%esp
  8025c4:	68 1c 46 80 00       	push   $0x80461c
  8025c9:	6a 7f                	push   $0x7f
  8025cb:	68 a7 45 80 00       	push   $0x8045a7
  8025d0:	e8 fa e0 ff ff       	call   8006cf <_panic>
  8025d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d8:	8b 10                	mov    (%eax),%edx
  8025da:	8b 45 08             	mov    0x8(%ebp),%eax
  8025dd:	89 10                	mov    %edx,(%eax)
  8025df:	8b 45 08             	mov    0x8(%ebp),%eax
  8025e2:	8b 00                	mov    (%eax),%eax
  8025e4:	85 c0                	test   %eax,%eax
  8025e6:	74 0b                	je     8025f3 <insert_sorted_allocList+0x222>
  8025e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025eb:	8b 00                	mov    (%eax),%eax
  8025ed:	8b 55 08             	mov    0x8(%ebp),%edx
  8025f0:	89 50 04             	mov    %edx,0x4(%eax)
  8025f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f6:	8b 55 08             	mov    0x8(%ebp),%edx
  8025f9:	89 10                	mov    %edx,(%eax)
  8025fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8025fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802601:	89 50 04             	mov    %edx,0x4(%eax)
  802604:	8b 45 08             	mov    0x8(%ebp),%eax
  802607:	8b 00                	mov    (%eax),%eax
  802609:	85 c0                	test   %eax,%eax
  80260b:	75 08                	jne    802615 <insert_sorted_allocList+0x244>
  80260d:	8b 45 08             	mov    0x8(%ebp),%eax
  802610:	a3 44 50 80 00       	mov    %eax,0x805044
  802615:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80261a:	40                   	inc    %eax
  80261b:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802620:	eb 39                	jmp    80265b <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802622:	a1 48 50 80 00       	mov    0x805048,%eax
  802627:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80262a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80262e:	74 07                	je     802637 <insert_sorted_allocList+0x266>
  802630:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802633:	8b 00                	mov    (%eax),%eax
  802635:	eb 05                	jmp    80263c <insert_sorted_allocList+0x26b>
  802637:	b8 00 00 00 00       	mov    $0x0,%eax
  80263c:	a3 48 50 80 00       	mov    %eax,0x805048
  802641:	a1 48 50 80 00       	mov    0x805048,%eax
  802646:	85 c0                	test   %eax,%eax
  802648:	0f 85 3f ff ff ff    	jne    80258d <insert_sorted_allocList+0x1bc>
  80264e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802652:	0f 85 35 ff ff ff    	jne    80258d <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802658:	eb 01                	jmp    80265b <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80265a:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80265b:	90                   	nop
  80265c:	c9                   	leave  
  80265d:	c3                   	ret    

0080265e <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80265e:	55                   	push   %ebp
  80265f:	89 e5                	mov    %esp,%ebp
  802661:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802664:	a1 38 51 80 00       	mov    0x805138,%eax
  802669:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80266c:	e9 85 01 00 00       	jmp    8027f6 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802671:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802674:	8b 40 0c             	mov    0xc(%eax),%eax
  802677:	3b 45 08             	cmp    0x8(%ebp),%eax
  80267a:	0f 82 6e 01 00 00    	jb     8027ee <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802680:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802683:	8b 40 0c             	mov    0xc(%eax),%eax
  802686:	3b 45 08             	cmp    0x8(%ebp),%eax
  802689:	0f 85 8a 00 00 00    	jne    802719 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  80268f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802693:	75 17                	jne    8026ac <alloc_block_FF+0x4e>
  802695:	83 ec 04             	sub    $0x4,%esp
  802698:	68 50 46 80 00       	push   $0x804650
  80269d:	68 93 00 00 00       	push   $0x93
  8026a2:	68 a7 45 80 00       	push   $0x8045a7
  8026a7:	e8 23 e0 ff ff       	call   8006cf <_panic>
  8026ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026af:	8b 00                	mov    (%eax),%eax
  8026b1:	85 c0                	test   %eax,%eax
  8026b3:	74 10                	je     8026c5 <alloc_block_FF+0x67>
  8026b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b8:	8b 00                	mov    (%eax),%eax
  8026ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026bd:	8b 52 04             	mov    0x4(%edx),%edx
  8026c0:	89 50 04             	mov    %edx,0x4(%eax)
  8026c3:	eb 0b                	jmp    8026d0 <alloc_block_FF+0x72>
  8026c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c8:	8b 40 04             	mov    0x4(%eax),%eax
  8026cb:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8026d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d3:	8b 40 04             	mov    0x4(%eax),%eax
  8026d6:	85 c0                	test   %eax,%eax
  8026d8:	74 0f                	je     8026e9 <alloc_block_FF+0x8b>
  8026da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026dd:	8b 40 04             	mov    0x4(%eax),%eax
  8026e0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026e3:	8b 12                	mov    (%edx),%edx
  8026e5:	89 10                	mov    %edx,(%eax)
  8026e7:	eb 0a                	jmp    8026f3 <alloc_block_FF+0x95>
  8026e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ec:	8b 00                	mov    (%eax),%eax
  8026ee:	a3 38 51 80 00       	mov    %eax,0x805138
  8026f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ff:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802706:	a1 44 51 80 00       	mov    0x805144,%eax
  80270b:	48                   	dec    %eax
  80270c:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802711:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802714:	e9 10 01 00 00       	jmp    802829 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802719:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271c:	8b 40 0c             	mov    0xc(%eax),%eax
  80271f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802722:	0f 86 c6 00 00 00    	jbe    8027ee <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802728:	a1 48 51 80 00       	mov    0x805148,%eax
  80272d:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802730:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802733:	8b 50 08             	mov    0x8(%eax),%edx
  802736:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802739:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  80273c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80273f:	8b 55 08             	mov    0x8(%ebp),%edx
  802742:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802745:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802749:	75 17                	jne    802762 <alloc_block_FF+0x104>
  80274b:	83 ec 04             	sub    $0x4,%esp
  80274e:	68 50 46 80 00       	push   $0x804650
  802753:	68 9b 00 00 00       	push   $0x9b
  802758:	68 a7 45 80 00       	push   $0x8045a7
  80275d:	e8 6d df ff ff       	call   8006cf <_panic>
  802762:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802765:	8b 00                	mov    (%eax),%eax
  802767:	85 c0                	test   %eax,%eax
  802769:	74 10                	je     80277b <alloc_block_FF+0x11d>
  80276b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80276e:	8b 00                	mov    (%eax),%eax
  802770:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802773:	8b 52 04             	mov    0x4(%edx),%edx
  802776:	89 50 04             	mov    %edx,0x4(%eax)
  802779:	eb 0b                	jmp    802786 <alloc_block_FF+0x128>
  80277b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80277e:	8b 40 04             	mov    0x4(%eax),%eax
  802781:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802786:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802789:	8b 40 04             	mov    0x4(%eax),%eax
  80278c:	85 c0                	test   %eax,%eax
  80278e:	74 0f                	je     80279f <alloc_block_FF+0x141>
  802790:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802793:	8b 40 04             	mov    0x4(%eax),%eax
  802796:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802799:	8b 12                	mov    (%edx),%edx
  80279b:	89 10                	mov    %edx,(%eax)
  80279d:	eb 0a                	jmp    8027a9 <alloc_block_FF+0x14b>
  80279f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027a2:	8b 00                	mov    (%eax),%eax
  8027a4:	a3 48 51 80 00       	mov    %eax,0x805148
  8027a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027ac:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027b5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027bc:	a1 54 51 80 00       	mov    0x805154,%eax
  8027c1:	48                   	dec    %eax
  8027c2:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  8027c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ca:	8b 50 08             	mov    0x8(%eax),%edx
  8027cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8027d0:	01 c2                	add    %eax,%edx
  8027d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d5:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  8027d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027db:	8b 40 0c             	mov    0xc(%eax),%eax
  8027de:	2b 45 08             	sub    0x8(%ebp),%eax
  8027e1:	89 c2                	mov    %eax,%edx
  8027e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e6:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  8027e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027ec:	eb 3b                	jmp    802829 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8027ee:	a1 40 51 80 00       	mov    0x805140,%eax
  8027f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027f6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027fa:	74 07                	je     802803 <alloc_block_FF+0x1a5>
  8027fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ff:	8b 00                	mov    (%eax),%eax
  802801:	eb 05                	jmp    802808 <alloc_block_FF+0x1aa>
  802803:	b8 00 00 00 00       	mov    $0x0,%eax
  802808:	a3 40 51 80 00       	mov    %eax,0x805140
  80280d:	a1 40 51 80 00       	mov    0x805140,%eax
  802812:	85 c0                	test   %eax,%eax
  802814:	0f 85 57 fe ff ff    	jne    802671 <alloc_block_FF+0x13>
  80281a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80281e:	0f 85 4d fe ff ff    	jne    802671 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802824:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802829:	c9                   	leave  
  80282a:	c3                   	ret    

0080282b <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  80282b:	55                   	push   %ebp
  80282c:	89 e5                	mov    %esp,%ebp
  80282e:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802831:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802838:	a1 38 51 80 00       	mov    0x805138,%eax
  80283d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802840:	e9 df 00 00 00       	jmp    802924 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802845:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802848:	8b 40 0c             	mov    0xc(%eax),%eax
  80284b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80284e:	0f 82 c8 00 00 00    	jb     80291c <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802854:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802857:	8b 40 0c             	mov    0xc(%eax),%eax
  80285a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80285d:	0f 85 8a 00 00 00    	jne    8028ed <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802863:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802867:	75 17                	jne    802880 <alloc_block_BF+0x55>
  802869:	83 ec 04             	sub    $0x4,%esp
  80286c:	68 50 46 80 00       	push   $0x804650
  802871:	68 b7 00 00 00       	push   $0xb7
  802876:	68 a7 45 80 00       	push   $0x8045a7
  80287b:	e8 4f de ff ff       	call   8006cf <_panic>
  802880:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802883:	8b 00                	mov    (%eax),%eax
  802885:	85 c0                	test   %eax,%eax
  802887:	74 10                	je     802899 <alloc_block_BF+0x6e>
  802889:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288c:	8b 00                	mov    (%eax),%eax
  80288e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802891:	8b 52 04             	mov    0x4(%edx),%edx
  802894:	89 50 04             	mov    %edx,0x4(%eax)
  802897:	eb 0b                	jmp    8028a4 <alloc_block_BF+0x79>
  802899:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289c:	8b 40 04             	mov    0x4(%eax),%eax
  80289f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8028a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a7:	8b 40 04             	mov    0x4(%eax),%eax
  8028aa:	85 c0                	test   %eax,%eax
  8028ac:	74 0f                	je     8028bd <alloc_block_BF+0x92>
  8028ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b1:	8b 40 04             	mov    0x4(%eax),%eax
  8028b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028b7:	8b 12                	mov    (%edx),%edx
  8028b9:	89 10                	mov    %edx,(%eax)
  8028bb:	eb 0a                	jmp    8028c7 <alloc_block_BF+0x9c>
  8028bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c0:	8b 00                	mov    (%eax),%eax
  8028c2:	a3 38 51 80 00       	mov    %eax,0x805138
  8028c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ca:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028da:	a1 44 51 80 00       	mov    0x805144,%eax
  8028df:	48                   	dec    %eax
  8028e0:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  8028e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e8:	e9 4d 01 00 00       	jmp    802a3a <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  8028ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f0:	8b 40 0c             	mov    0xc(%eax),%eax
  8028f3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028f6:	76 24                	jbe    80291c <alloc_block_BF+0xf1>
  8028f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028fb:	8b 40 0c             	mov    0xc(%eax),%eax
  8028fe:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802901:	73 19                	jae    80291c <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802903:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  80290a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290d:	8b 40 0c             	mov    0xc(%eax),%eax
  802910:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802913:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802916:	8b 40 08             	mov    0x8(%eax),%eax
  802919:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  80291c:	a1 40 51 80 00       	mov    0x805140,%eax
  802921:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802924:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802928:	74 07                	je     802931 <alloc_block_BF+0x106>
  80292a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292d:	8b 00                	mov    (%eax),%eax
  80292f:	eb 05                	jmp    802936 <alloc_block_BF+0x10b>
  802931:	b8 00 00 00 00       	mov    $0x0,%eax
  802936:	a3 40 51 80 00       	mov    %eax,0x805140
  80293b:	a1 40 51 80 00       	mov    0x805140,%eax
  802940:	85 c0                	test   %eax,%eax
  802942:	0f 85 fd fe ff ff    	jne    802845 <alloc_block_BF+0x1a>
  802948:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80294c:	0f 85 f3 fe ff ff    	jne    802845 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802952:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802956:	0f 84 d9 00 00 00    	je     802a35 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  80295c:	a1 48 51 80 00       	mov    0x805148,%eax
  802961:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802964:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802967:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80296a:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  80296d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802970:	8b 55 08             	mov    0x8(%ebp),%edx
  802973:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802976:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80297a:	75 17                	jne    802993 <alloc_block_BF+0x168>
  80297c:	83 ec 04             	sub    $0x4,%esp
  80297f:	68 50 46 80 00       	push   $0x804650
  802984:	68 c7 00 00 00       	push   $0xc7
  802989:	68 a7 45 80 00       	push   $0x8045a7
  80298e:	e8 3c dd ff ff       	call   8006cf <_panic>
  802993:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802996:	8b 00                	mov    (%eax),%eax
  802998:	85 c0                	test   %eax,%eax
  80299a:	74 10                	je     8029ac <alloc_block_BF+0x181>
  80299c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80299f:	8b 00                	mov    (%eax),%eax
  8029a1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8029a4:	8b 52 04             	mov    0x4(%edx),%edx
  8029a7:	89 50 04             	mov    %edx,0x4(%eax)
  8029aa:	eb 0b                	jmp    8029b7 <alloc_block_BF+0x18c>
  8029ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029af:	8b 40 04             	mov    0x4(%eax),%eax
  8029b2:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8029b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029ba:	8b 40 04             	mov    0x4(%eax),%eax
  8029bd:	85 c0                	test   %eax,%eax
  8029bf:	74 0f                	je     8029d0 <alloc_block_BF+0x1a5>
  8029c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029c4:	8b 40 04             	mov    0x4(%eax),%eax
  8029c7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8029ca:	8b 12                	mov    (%edx),%edx
  8029cc:	89 10                	mov    %edx,(%eax)
  8029ce:	eb 0a                	jmp    8029da <alloc_block_BF+0x1af>
  8029d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029d3:	8b 00                	mov    (%eax),%eax
  8029d5:	a3 48 51 80 00       	mov    %eax,0x805148
  8029da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029dd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029e6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029ed:	a1 54 51 80 00       	mov    0x805154,%eax
  8029f2:	48                   	dec    %eax
  8029f3:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  8029f8:	83 ec 08             	sub    $0x8,%esp
  8029fb:	ff 75 ec             	pushl  -0x14(%ebp)
  8029fe:	68 38 51 80 00       	push   $0x805138
  802a03:	e8 71 f9 ff ff       	call   802379 <find_block>
  802a08:	83 c4 10             	add    $0x10,%esp
  802a0b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802a0e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a11:	8b 50 08             	mov    0x8(%eax),%edx
  802a14:	8b 45 08             	mov    0x8(%ebp),%eax
  802a17:	01 c2                	add    %eax,%edx
  802a19:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a1c:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802a1f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a22:	8b 40 0c             	mov    0xc(%eax),%eax
  802a25:	2b 45 08             	sub    0x8(%ebp),%eax
  802a28:	89 c2                	mov    %eax,%edx
  802a2a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a2d:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802a30:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a33:	eb 05                	jmp    802a3a <alloc_block_BF+0x20f>
	}
	return NULL;
  802a35:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a3a:	c9                   	leave  
  802a3b:	c3                   	ret    

00802a3c <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802a3c:	55                   	push   %ebp
  802a3d:	89 e5                	mov    %esp,%ebp
  802a3f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802a42:	a1 28 50 80 00       	mov    0x805028,%eax
  802a47:	85 c0                	test   %eax,%eax
  802a49:	0f 85 de 01 00 00    	jne    802c2d <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802a4f:	a1 38 51 80 00       	mov    0x805138,%eax
  802a54:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a57:	e9 9e 01 00 00       	jmp    802bfa <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802a5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5f:	8b 40 0c             	mov    0xc(%eax),%eax
  802a62:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a65:	0f 82 87 01 00 00    	jb     802bf2 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802a6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6e:	8b 40 0c             	mov    0xc(%eax),%eax
  802a71:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a74:	0f 85 95 00 00 00    	jne    802b0f <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802a7a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a7e:	75 17                	jne    802a97 <alloc_block_NF+0x5b>
  802a80:	83 ec 04             	sub    $0x4,%esp
  802a83:	68 50 46 80 00       	push   $0x804650
  802a88:	68 e0 00 00 00       	push   $0xe0
  802a8d:	68 a7 45 80 00       	push   $0x8045a7
  802a92:	e8 38 dc ff ff       	call   8006cf <_panic>
  802a97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9a:	8b 00                	mov    (%eax),%eax
  802a9c:	85 c0                	test   %eax,%eax
  802a9e:	74 10                	je     802ab0 <alloc_block_NF+0x74>
  802aa0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa3:	8b 00                	mov    (%eax),%eax
  802aa5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802aa8:	8b 52 04             	mov    0x4(%edx),%edx
  802aab:	89 50 04             	mov    %edx,0x4(%eax)
  802aae:	eb 0b                	jmp    802abb <alloc_block_NF+0x7f>
  802ab0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab3:	8b 40 04             	mov    0x4(%eax),%eax
  802ab6:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802abb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802abe:	8b 40 04             	mov    0x4(%eax),%eax
  802ac1:	85 c0                	test   %eax,%eax
  802ac3:	74 0f                	je     802ad4 <alloc_block_NF+0x98>
  802ac5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac8:	8b 40 04             	mov    0x4(%eax),%eax
  802acb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ace:	8b 12                	mov    (%edx),%edx
  802ad0:	89 10                	mov    %edx,(%eax)
  802ad2:	eb 0a                	jmp    802ade <alloc_block_NF+0xa2>
  802ad4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad7:	8b 00                	mov    (%eax),%eax
  802ad9:	a3 38 51 80 00       	mov    %eax,0x805138
  802ade:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ae7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aea:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802af1:	a1 44 51 80 00       	mov    0x805144,%eax
  802af6:	48                   	dec    %eax
  802af7:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802afc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aff:	8b 40 08             	mov    0x8(%eax),%eax
  802b02:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  802b07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0a:	e9 f8 04 00 00       	jmp    803007 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802b0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b12:	8b 40 0c             	mov    0xc(%eax),%eax
  802b15:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b18:	0f 86 d4 00 00 00    	jbe    802bf2 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802b1e:	a1 48 51 80 00       	mov    0x805148,%eax
  802b23:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802b26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b29:	8b 50 08             	mov    0x8(%eax),%edx
  802b2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b2f:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802b32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b35:	8b 55 08             	mov    0x8(%ebp),%edx
  802b38:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802b3b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b3f:	75 17                	jne    802b58 <alloc_block_NF+0x11c>
  802b41:	83 ec 04             	sub    $0x4,%esp
  802b44:	68 50 46 80 00       	push   $0x804650
  802b49:	68 e9 00 00 00       	push   $0xe9
  802b4e:	68 a7 45 80 00       	push   $0x8045a7
  802b53:	e8 77 db ff ff       	call   8006cf <_panic>
  802b58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b5b:	8b 00                	mov    (%eax),%eax
  802b5d:	85 c0                	test   %eax,%eax
  802b5f:	74 10                	je     802b71 <alloc_block_NF+0x135>
  802b61:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b64:	8b 00                	mov    (%eax),%eax
  802b66:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b69:	8b 52 04             	mov    0x4(%edx),%edx
  802b6c:	89 50 04             	mov    %edx,0x4(%eax)
  802b6f:	eb 0b                	jmp    802b7c <alloc_block_NF+0x140>
  802b71:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b74:	8b 40 04             	mov    0x4(%eax),%eax
  802b77:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b7f:	8b 40 04             	mov    0x4(%eax),%eax
  802b82:	85 c0                	test   %eax,%eax
  802b84:	74 0f                	je     802b95 <alloc_block_NF+0x159>
  802b86:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b89:	8b 40 04             	mov    0x4(%eax),%eax
  802b8c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b8f:	8b 12                	mov    (%edx),%edx
  802b91:	89 10                	mov    %edx,(%eax)
  802b93:	eb 0a                	jmp    802b9f <alloc_block_NF+0x163>
  802b95:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b98:	8b 00                	mov    (%eax),%eax
  802b9a:	a3 48 51 80 00       	mov    %eax,0x805148
  802b9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ba2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ba8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bab:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bb2:	a1 54 51 80 00       	mov    0x805154,%eax
  802bb7:	48                   	dec    %eax
  802bb8:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802bbd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bc0:	8b 40 08             	mov    0x8(%eax),%eax
  802bc3:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802bc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bcb:	8b 50 08             	mov    0x8(%eax),%edx
  802bce:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd1:	01 c2                	add    %eax,%edx
  802bd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd6:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802bd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bdc:	8b 40 0c             	mov    0xc(%eax),%eax
  802bdf:	2b 45 08             	sub    0x8(%ebp),%eax
  802be2:	89 c2                	mov    %eax,%edx
  802be4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be7:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802bea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bed:	e9 15 04 00 00       	jmp    803007 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802bf2:	a1 40 51 80 00       	mov    0x805140,%eax
  802bf7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bfa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bfe:	74 07                	je     802c07 <alloc_block_NF+0x1cb>
  802c00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c03:	8b 00                	mov    (%eax),%eax
  802c05:	eb 05                	jmp    802c0c <alloc_block_NF+0x1d0>
  802c07:	b8 00 00 00 00       	mov    $0x0,%eax
  802c0c:	a3 40 51 80 00       	mov    %eax,0x805140
  802c11:	a1 40 51 80 00       	mov    0x805140,%eax
  802c16:	85 c0                	test   %eax,%eax
  802c18:	0f 85 3e fe ff ff    	jne    802a5c <alloc_block_NF+0x20>
  802c1e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c22:	0f 85 34 fe ff ff    	jne    802a5c <alloc_block_NF+0x20>
  802c28:	e9 d5 03 00 00       	jmp    803002 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802c2d:	a1 38 51 80 00       	mov    0x805138,%eax
  802c32:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c35:	e9 b1 01 00 00       	jmp    802deb <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802c3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c3d:	8b 50 08             	mov    0x8(%eax),%edx
  802c40:	a1 28 50 80 00       	mov    0x805028,%eax
  802c45:	39 c2                	cmp    %eax,%edx
  802c47:	0f 82 96 01 00 00    	jb     802de3 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802c4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c50:	8b 40 0c             	mov    0xc(%eax),%eax
  802c53:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c56:	0f 82 87 01 00 00    	jb     802de3 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802c5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c5f:	8b 40 0c             	mov    0xc(%eax),%eax
  802c62:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c65:	0f 85 95 00 00 00    	jne    802d00 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802c6b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c6f:	75 17                	jne    802c88 <alloc_block_NF+0x24c>
  802c71:	83 ec 04             	sub    $0x4,%esp
  802c74:	68 50 46 80 00       	push   $0x804650
  802c79:	68 fc 00 00 00       	push   $0xfc
  802c7e:	68 a7 45 80 00       	push   $0x8045a7
  802c83:	e8 47 da ff ff       	call   8006cf <_panic>
  802c88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c8b:	8b 00                	mov    (%eax),%eax
  802c8d:	85 c0                	test   %eax,%eax
  802c8f:	74 10                	je     802ca1 <alloc_block_NF+0x265>
  802c91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c94:	8b 00                	mov    (%eax),%eax
  802c96:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c99:	8b 52 04             	mov    0x4(%edx),%edx
  802c9c:	89 50 04             	mov    %edx,0x4(%eax)
  802c9f:	eb 0b                	jmp    802cac <alloc_block_NF+0x270>
  802ca1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca4:	8b 40 04             	mov    0x4(%eax),%eax
  802ca7:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802cac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802caf:	8b 40 04             	mov    0x4(%eax),%eax
  802cb2:	85 c0                	test   %eax,%eax
  802cb4:	74 0f                	je     802cc5 <alloc_block_NF+0x289>
  802cb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb9:	8b 40 04             	mov    0x4(%eax),%eax
  802cbc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cbf:	8b 12                	mov    (%edx),%edx
  802cc1:	89 10                	mov    %edx,(%eax)
  802cc3:	eb 0a                	jmp    802ccf <alloc_block_NF+0x293>
  802cc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc8:	8b 00                	mov    (%eax),%eax
  802cca:	a3 38 51 80 00       	mov    %eax,0x805138
  802ccf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cdb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ce2:	a1 44 51 80 00       	mov    0x805144,%eax
  802ce7:	48                   	dec    %eax
  802ce8:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802ced:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf0:	8b 40 08             	mov    0x8(%eax),%eax
  802cf3:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802cf8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cfb:	e9 07 03 00 00       	jmp    803007 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802d00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d03:	8b 40 0c             	mov    0xc(%eax),%eax
  802d06:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d09:	0f 86 d4 00 00 00    	jbe    802de3 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802d0f:	a1 48 51 80 00       	mov    0x805148,%eax
  802d14:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802d17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d1a:	8b 50 08             	mov    0x8(%eax),%edx
  802d1d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d20:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802d23:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d26:	8b 55 08             	mov    0x8(%ebp),%edx
  802d29:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802d2c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802d30:	75 17                	jne    802d49 <alloc_block_NF+0x30d>
  802d32:	83 ec 04             	sub    $0x4,%esp
  802d35:	68 50 46 80 00       	push   $0x804650
  802d3a:	68 04 01 00 00       	push   $0x104
  802d3f:	68 a7 45 80 00       	push   $0x8045a7
  802d44:	e8 86 d9 ff ff       	call   8006cf <_panic>
  802d49:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d4c:	8b 00                	mov    (%eax),%eax
  802d4e:	85 c0                	test   %eax,%eax
  802d50:	74 10                	je     802d62 <alloc_block_NF+0x326>
  802d52:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d55:	8b 00                	mov    (%eax),%eax
  802d57:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d5a:	8b 52 04             	mov    0x4(%edx),%edx
  802d5d:	89 50 04             	mov    %edx,0x4(%eax)
  802d60:	eb 0b                	jmp    802d6d <alloc_block_NF+0x331>
  802d62:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d65:	8b 40 04             	mov    0x4(%eax),%eax
  802d68:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d6d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d70:	8b 40 04             	mov    0x4(%eax),%eax
  802d73:	85 c0                	test   %eax,%eax
  802d75:	74 0f                	je     802d86 <alloc_block_NF+0x34a>
  802d77:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d7a:	8b 40 04             	mov    0x4(%eax),%eax
  802d7d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d80:	8b 12                	mov    (%edx),%edx
  802d82:	89 10                	mov    %edx,(%eax)
  802d84:	eb 0a                	jmp    802d90 <alloc_block_NF+0x354>
  802d86:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d89:	8b 00                	mov    (%eax),%eax
  802d8b:	a3 48 51 80 00       	mov    %eax,0x805148
  802d90:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d93:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d99:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d9c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802da3:	a1 54 51 80 00       	mov    0x805154,%eax
  802da8:	48                   	dec    %eax
  802da9:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802dae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802db1:	8b 40 08             	mov    0x8(%eax),%eax
  802db4:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802db9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dbc:	8b 50 08             	mov    0x8(%eax),%edx
  802dbf:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc2:	01 c2                	add    %eax,%edx
  802dc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc7:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802dca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dcd:	8b 40 0c             	mov    0xc(%eax),%eax
  802dd0:	2b 45 08             	sub    0x8(%ebp),%eax
  802dd3:	89 c2                	mov    %eax,%edx
  802dd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd8:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802ddb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dde:	e9 24 02 00 00       	jmp    803007 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802de3:	a1 40 51 80 00       	mov    0x805140,%eax
  802de8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802deb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802def:	74 07                	je     802df8 <alloc_block_NF+0x3bc>
  802df1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df4:	8b 00                	mov    (%eax),%eax
  802df6:	eb 05                	jmp    802dfd <alloc_block_NF+0x3c1>
  802df8:	b8 00 00 00 00       	mov    $0x0,%eax
  802dfd:	a3 40 51 80 00       	mov    %eax,0x805140
  802e02:	a1 40 51 80 00       	mov    0x805140,%eax
  802e07:	85 c0                	test   %eax,%eax
  802e09:	0f 85 2b fe ff ff    	jne    802c3a <alloc_block_NF+0x1fe>
  802e0f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e13:	0f 85 21 fe ff ff    	jne    802c3a <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802e19:	a1 38 51 80 00       	mov    0x805138,%eax
  802e1e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e21:	e9 ae 01 00 00       	jmp    802fd4 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802e26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e29:	8b 50 08             	mov    0x8(%eax),%edx
  802e2c:	a1 28 50 80 00       	mov    0x805028,%eax
  802e31:	39 c2                	cmp    %eax,%edx
  802e33:	0f 83 93 01 00 00    	jae    802fcc <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802e39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e3c:	8b 40 0c             	mov    0xc(%eax),%eax
  802e3f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e42:	0f 82 84 01 00 00    	jb     802fcc <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802e48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e4b:	8b 40 0c             	mov    0xc(%eax),%eax
  802e4e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e51:	0f 85 95 00 00 00    	jne    802eec <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802e57:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e5b:	75 17                	jne    802e74 <alloc_block_NF+0x438>
  802e5d:	83 ec 04             	sub    $0x4,%esp
  802e60:	68 50 46 80 00       	push   $0x804650
  802e65:	68 14 01 00 00       	push   $0x114
  802e6a:	68 a7 45 80 00       	push   $0x8045a7
  802e6f:	e8 5b d8 ff ff       	call   8006cf <_panic>
  802e74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e77:	8b 00                	mov    (%eax),%eax
  802e79:	85 c0                	test   %eax,%eax
  802e7b:	74 10                	je     802e8d <alloc_block_NF+0x451>
  802e7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e80:	8b 00                	mov    (%eax),%eax
  802e82:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e85:	8b 52 04             	mov    0x4(%edx),%edx
  802e88:	89 50 04             	mov    %edx,0x4(%eax)
  802e8b:	eb 0b                	jmp    802e98 <alloc_block_NF+0x45c>
  802e8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e90:	8b 40 04             	mov    0x4(%eax),%eax
  802e93:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e9b:	8b 40 04             	mov    0x4(%eax),%eax
  802e9e:	85 c0                	test   %eax,%eax
  802ea0:	74 0f                	je     802eb1 <alloc_block_NF+0x475>
  802ea2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea5:	8b 40 04             	mov    0x4(%eax),%eax
  802ea8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802eab:	8b 12                	mov    (%edx),%edx
  802ead:	89 10                	mov    %edx,(%eax)
  802eaf:	eb 0a                	jmp    802ebb <alloc_block_NF+0x47f>
  802eb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb4:	8b 00                	mov    (%eax),%eax
  802eb6:	a3 38 51 80 00       	mov    %eax,0x805138
  802ebb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ebe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ec4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ece:	a1 44 51 80 00       	mov    0x805144,%eax
  802ed3:	48                   	dec    %eax
  802ed4:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802ed9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802edc:	8b 40 08             	mov    0x8(%eax),%eax
  802edf:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802ee4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee7:	e9 1b 01 00 00       	jmp    803007 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802eec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eef:	8b 40 0c             	mov    0xc(%eax),%eax
  802ef2:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ef5:	0f 86 d1 00 00 00    	jbe    802fcc <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802efb:	a1 48 51 80 00       	mov    0x805148,%eax
  802f00:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802f03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f06:	8b 50 08             	mov    0x8(%eax),%edx
  802f09:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f0c:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802f0f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f12:	8b 55 08             	mov    0x8(%ebp),%edx
  802f15:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802f18:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802f1c:	75 17                	jne    802f35 <alloc_block_NF+0x4f9>
  802f1e:	83 ec 04             	sub    $0x4,%esp
  802f21:	68 50 46 80 00       	push   $0x804650
  802f26:	68 1c 01 00 00       	push   $0x11c
  802f2b:	68 a7 45 80 00       	push   $0x8045a7
  802f30:	e8 9a d7 ff ff       	call   8006cf <_panic>
  802f35:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f38:	8b 00                	mov    (%eax),%eax
  802f3a:	85 c0                	test   %eax,%eax
  802f3c:	74 10                	je     802f4e <alloc_block_NF+0x512>
  802f3e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f41:	8b 00                	mov    (%eax),%eax
  802f43:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802f46:	8b 52 04             	mov    0x4(%edx),%edx
  802f49:	89 50 04             	mov    %edx,0x4(%eax)
  802f4c:	eb 0b                	jmp    802f59 <alloc_block_NF+0x51d>
  802f4e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f51:	8b 40 04             	mov    0x4(%eax),%eax
  802f54:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f59:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f5c:	8b 40 04             	mov    0x4(%eax),%eax
  802f5f:	85 c0                	test   %eax,%eax
  802f61:	74 0f                	je     802f72 <alloc_block_NF+0x536>
  802f63:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f66:	8b 40 04             	mov    0x4(%eax),%eax
  802f69:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802f6c:	8b 12                	mov    (%edx),%edx
  802f6e:	89 10                	mov    %edx,(%eax)
  802f70:	eb 0a                	jmp    802f7c <alloc_block_NF+0x540>
  802f72:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f75:	8b 00                	mov    (%eax),%eax
  802f77:	a3 48 51 80 00       	mov    %eax,0x805148
  802f7c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f7f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f85:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f88:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f8f:	a1 54 51 80 00       	mov    0x805154,%eax
  802f94:	48                   	dec    %eax
  802f95:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802f9a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f9d:	8b 40 08             	mov    0x8(%eax),%eax
  802fa0:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802fa5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa8:	8b 50 08             	mov    0x8(%eax),%edx
  802fab:	8b 45 08             	mov    0x8(%ebp),%eax
  802fae:	01 c2                	add    %eax,%edx
  802fb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb3:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802fb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb9:	8b 40 0c             	mov    0xc(%eax),%eax
  802fbc:	2b 45 08             	sub    0x8(%ebp),%eax
  802fbf:	89 c2                	mov    %eax,%edx
  802fc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc4:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802fc7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fca:	eb 3b                	jmp    803007 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802fcc:	a1 40 51 80 00       	mov    0x805140,%eax
  802fd1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fd4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fd8:	74 07                	je     802fe1 <alloc_block_NF+0x5a5>
  802fda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fdd:	8b 00                	mov    (%eax),%eax
  802fdf:	eb 05                	jmp    802fe6 <alloc_block_NF+0x5aa>
  802fe1:	b8 00 00 00 00       	mov    $0x0,%eax
  802fe6:	a3 40 51 80 00       	mov    %eax,0x805140
  802feb:	a1 40 51 80 00       	mov    0x805140,%eax
  802ff0:	85 c0                	test   %eax,%eax
  802ff2:	0f 85 2e fe ff ff    	jne    802e26 <alloc_block_NF+0x3ea>
  802ff8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ffc:	0f 85 24 fe ff ff    	jne    802e26 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  803002:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803007:	c9                   	leave  
  803008:	c3                   	ret    

00803009 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  803009:	55                   	push   %ebp
  80300a:	89 e5                	mov    %esp,%ebp
  80300c:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  80300f:	a1 38 51 80 00       	mov    0x805138,%eax
  803014:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  803017:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80301c:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  80301f:	a1 38 51 80 00       	mov    0x805138,%eax
  803024:	85 c0                	test   %eax,%eax
  803026:	74 14                	je     80303c <insert_sorted_with_merge_freeList+0x33>
  803028:	8b 45 08             	mov    0x8(%ebp),%eax
  80302b:	8b 50 08             	mov    0x8(%eax),%edx
  80302e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803031:	8b 40 08             	mov    0x8(%eax),%eax
  803034:	39 c2                	cmp    %eax,%edx
  803036:	0f 87 9b 01 00 00    	ja     8031d7 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  80303c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803040:	75 17                	jne    803059 <insert_sorted_with_merge_freeList+0x50>
  803042:	83 ec 04             	sub    $0x4,%esp
  803045:	68 84 45 80 00       	push   $0x804584
  80304a:	68 38 01 00 00       	push   $0x138
  80304f:	68 a7 45 80 00       	push   $0x8045a7
  803054:	e8 76 d6 ff ff       	call   8006cf <_panic>
  803059:	8b 15 38 51 80 00    	mov    0x805138,%edx
  80305f:	8b 45 08             	mov    0x8(%ebp),%eax
  803062:	89 10                	mov    %edx,(%eax)
  803064:	8b 45 08             	mov    0x8(%ebp),%eax
  803067:	8b 00                	mov    (%eax),%eax
  803069:	85 c0                	test   %eax,%eax
  80306b:	74 0d                	je     80307a <insert_sorted_with_merge_freeList+0x71>
  80306d:	a1 38 51 80 00       	mov    0x805138,%eax
  803072:	8b 55 08             	mov    0x8(%ebp),%edx
  803075:	89 50 04             	mov    %edx,0x4(%eax)
  803078:	eb 08                	jmp    803082 <insert_sorted_with_merge_freeList+0x79>
  80307a:	8b 45 08             	mov    0x8(%ebp),%eax
  80307d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803082:	8b 45 08             	mov    0x8(%ebp),%eax
  803085:	a3 38 51 80 00       	mov    %eax,0x805138
  80308a:	8b 45 08             	mov    0x8(%ebp),%eax
  80308d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803094:	a1 44 51 80 00       	mov    0x805144,%eax
  803099:	40                   	inc    %eax
  80309a:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80309f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8030a3:	0f 84 a8 06 00 00    	je     803751 <insert_sorted_with_merge_freeList+0x748>
  8030a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ac:	8b 50 08             	mov    0x8(%eax),%edx
  8030af:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b2:	8b 40 0c             	mov    0xc(%eax),%eax
  8030b5:	01 c2                	add    %eax,%edx
  8030b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030ba:	8b 40 08             	mov    0x8(%eax),%eax
  8030bd:	39 c2                	cmp    %eax,%edx
  8030bf:	0f 85 8c 06 00 00    	jne    803751 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  8030c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c8:	8b 50 0c             	mov    0xc(%eax),%edx
  8030cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030ce:	8b 40 0c             	mov    0xc(%eax),%eax
  8030d1:	01 c2                	add    %eax,%edx
  8030d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d6:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  8030d9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8030dd:	75 17                	jne    8030f6 <insert_sorted_with_merge_freeList+0xed>
  8030df:	83 ec 04             	sub    $0x4,%esp
  8030e2:	68 50 46 80 00       	push   $0x804650
  8030e7:	68 3c 01 00 00       	push   $0x13c
  8030ec:	68 a7 45 80 00       	push   $0x8045a7
  8030f1:	e8 d9 d5 ff ff       	call   8006cf <_panic>
  8030f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030f9:	8b 00                	mov    (%eax),%eax
  8030fb:	85 c0                	test   %eax,%eax
  8030fd:	74 10                	je     80310f <insert_sorted_with_merge_freeList+0x106>
  8030ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803102:	8b 00                	mov    (%eax),%eax
  803104:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803107:	8b 52 04             	mov    0x4(%edx),%edx
  80310a:	89 50 04             	mov    %edx,0x4(%eax)
  80310d:	eb 0b                	jmp    80311a <insert_sorted_with_merge_freeList+0x111>
  80310f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803112:	8b 40 04             	mov    0x4(%eax),%eax
  803115:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80311a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80311d:	8b 40 04             	mov    0x4(%eax),%eax
  803120:	85 c0                	test   %eax,%eax
  803122:	74 0f                	je     803133 <insert_sorted_with_merge_freeList+0x12a>
  803124:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803127:	8b 40 04             	mov    0x4(%eax),%eax
  80312a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80312d:	8b 12                	mov    (%edx),%edx
  80312f:	89 10                	mov    %edx,(%eax)
  803131:	eb 0a                	jmp    80313d <insert_sorted_with_merge_freeList+0x134>
  803133:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803136:	8b 00                	mov    (%eax),%eax
  803138:	a3 38 51 80 00       	mov    %eax,0x805138
  80313d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803140:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803146:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803149:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803150:	a1 44 51 80 00       	mov    0x805144,%eax
  803155:	48                   	dec    %eax
  803156:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  80315b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80315e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  803165:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803168:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  80316f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803173:	75 17                	jne    80318c <insert_sorted_with_merge_freeList+0x183>
  803175:	83 ec 04             	sub    $0x4,%esp
  803178:	68 84 45 80 00       	push   $0x804584
  80317d:	68 3f 01 00 00       	push   $0x13f
  803182:	68 a7 45 80 00       	push   $0x8045a7
  803187:	e8 43 d5 ff ff       	call   8006cf <_panic>
  80318c:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803192:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803195:	89 10                	mov    %edx,(%eax)
  803197:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80319a:	8b 00                	mov    (%eax),%eax
  80319c:	85 c0                	test   %eax,%eax
  80319e:	74 0d                	je     8031ad <insert_sorted_with_merge_freeList+0x1a4>
  8031a0:	a1 48 51 80 00       	mov    0x805148,%eax
  8031a5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031a8:	89 50 04             	mov    %edx,0x4(%eax)
  8031ab:	eb 08                	jmp    8031b5 <insert_sorted_with_merge_freeList+0x1ac>
  8031ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031b0:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8031b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031b8:	a3 48 51 80 00       	mov    %eax,0x805148
  8031bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031c0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031c7:	a1 54 51 80 00       	mov    0x805154,%eax
  8031cc:	40                   	inc    %eax
  8031cd:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8031d2:	e9 7a 05 00 00       	jmp    803751 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  8031d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8031da:	8b 50 08             	mov    0x8(%eax),%edx
  8031dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031e0:	8b 40 08             	mov    0x8(%eax),%eax
  8031e3:	39 c2                	cmp    %eax,%edx
  8031e5:	0f 82 14 01 00 00    	jb     8032ff <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  8031eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031ee:	8b 50 08             	mov    0x8(%eax),%edx
  8031f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031f4:	8b 40 0c             	mov    0xc(%eax),%eax
  8031f7:	01 c2                	add    %eax,%edx
  8031f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8031fc:	8b 40 08             	mov    0x8(%eax),%eax
  8031ff:	39 c2                	cmp    %eax,%edx
  803201:	0f 85 90 00 00 00    	jne    803297 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  803207:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80320a:	8b 50 0c             	mov    0xc(%eax),%edx
  80320d:	8b 45 08             	mov    0x8(%ebp),%eax
  803210:	8b 40 0c             	mov    0xc(%eax),%eax
  803213:	01 c2                	add    %eax,%edx
  803215:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803218:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  80321b:	8b 45 08             	mov    0x8(%ebp),%eax
  80321e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  803225:	8b 45 08             	mov    0x8(%ebp),%eax
  803228:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80322f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803233:	75 17                	jne    80324c <insert_sorted_with_merge_freeList+0x243>
  803235:	83 ec 04             	sub    $0x4,%esp
  803238:	68 84 45 80 00       	push   $0x804584
  80323d:	68 49 01 00 00       	push   $0x149
  803242:	68 a7 45 80 00       	push   $0x8045a7
  803247:	e8 83 d4 ff ff       	call   8006cf <_panic>
  80324c:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803252:	8b 45 08             	mov    0x8(%ebp),%eax
  803255:	89 10                	mov    %edx,(%eax)
  803257:	8b 45 08             	mov    0x8(%ebp),%eax
  80325a:	8b 00                	mov    (%eax),%eax
  80325c:	85 c0                	test   %eax,%eax
  80325e:	74 0d                	je     80326d <insert_sorted_with_merge_freeList+0x264>
  803260:	a1 48 51 80 00       	mov    0x805148,%eax
  803265:	8b 55 08             	mov    0x8(%ebp),%edx
  803268:	89 50 04             	mov    %edx,0x4(%eax)
  80326b:	eb 08                	jmp    803275 <insert_sorted_with_merge_freeList+0x26c>
  80326d:	8b 45 08             	mov    0x8(%ebp),%eax
  803270:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803275:	8b 45 08             	mov    0x8(%ebp),%eax
  803278:	a3 48 51 80 00       	mov    %eax,0x805148
  80327d:	8b 45 08             	mov    0x8(%ebp),%eax
  803280:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803287:	a1 54 51 80 00       	mov    0x805154,%eax
  80328c:	40                   	inc    %eax
  80328d:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803292:	e9 bb 04 00 00       	jmp    803752 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  803297:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80329b:	75 17                	jne    8032b4 <insert_sorted_with_merge_freeList+0x2ab>
  80329d:	83 ec 04             	sub    $0x4,%esp
  8032a0:	68 f8 45 80 00       	push   $0x8045f8
  8032a5:	68 4c 01 00 00       	push   $0x14c
  8032aa:	68 a7 45 80 00       	push   $0x8045a7
  8032af:	e8 1b d4 ff ff       	call   8006cf <_panic>
  8032b4:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  8032ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8032bd:	89 50 04             	mov    %edx,0x4(%eax)
  8032c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c3:	8b 40 04             	mov    0x4(%eax),%eax
  8032c6:	85 c0                	test   %eax,%eax
  8032c8:	74 0c                	je     8032d6 <insert_sorted_with_merge_freeList+0x2cd>
  8032ca:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8032cf:	8b 55 08             	mov    0x8(%ebp),%edx
  8032d2:	89 10                	mov    %edx,(%eax)
  8032d4:	eb 08                	jmp    8032de <insert_sorted_with_merge_freeList+0x2d5>
  8032d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d9:	a3 38 51 80 00       	mov    %eax,0x805138
  8032de:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e1:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8032e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032ef:	a1 44 51 80 00       	mov    0x805144,%eax
  8032f4:	40                   	inc    %eax
  8032f5:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8032fa:	e9 53 04 00 00       	jmp    803752 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8032ff:	a1 38 51 80 00       	mov    0x805138,%eax
  803304:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803307:	e9 15 04 00 00       	jmp    803721 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  80330c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80330f:	8b 00                	mov    (%eax),%eax
  803311:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  803314:	8b 45 08             	mov    0x8(%ebp),%eax
  803317:	8b 50 08             	mov    0x8(%eax),%edx
  80331a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80331d:	8b 40 08             	mov    0x8(%eax),%eax
  803320:	39 c2                	cmp    %eax,%edx
  803322:	0f 86 f1 03 00 00    	jbe    803719 <insert_sorted_with_merge_freeList+0x710>
  803328:	8b 45 08             	mov    0x8(%ebp),%eax
  80332b:	8b 50 08             	mov    0x8(%eax),%edx
  80332e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803331:	8b 40 08             	mov    0x8(%eax),%eax
  803334:	39 c2                	cmp    %eax,%edx
  803336:	0f 83 dd 03 00 00    	jae    803719 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  80333c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80333f:	8b 50 08             	mov    0x8(%eax),%edx
  803342:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803345:	8b 40 0c             	mov    0xc(%eax),%eax
  803348:	01 c2                	add    %eax,%edx
  80334a:	8b 45 08             	mov    0x8(%ebp),%eax
  80334d:	8b 40 08             	mov    0x8(%eax),%eax
  803350:	39 c2                	cmp    %eax,%edx
  803352:	0f 85 b9 01 00 00    	jne    803511 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803358:	8b 45 08             	mov    0x8(%ebp),%eax
  80335b:	8b 50 08             	mov    0x8(%eax),%edx
  80335e:	8b 45 08             	mov    0x8(%ebp),%eax
  803361:	8b 40 0c             	mov    0xc(%eax),%eax
  803364:	01 c2                	add    %eax,%edx
  803366:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803369:	8b 40 08             	mov    0x8(%eax),%eax
  80336c:	39 c2                	cmp    %eax,%edx
  80336e:	0f 85 0d 01 00 00    	jne    803481 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  803374:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803377:	8b 50 0c             	mov    0xc(%eax),%edx
  80337a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80337d:	8b 40 0c             	mov    0xc(%eax),%eax
  803380:	01 c2                	add    %eax,%edx
  803382:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803385:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803388:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80338c:	75 17                	jne    8033a5 <insert_sorted_with_merge_freeList+0x39c>
  80338e:	83 ec 04             	sub    $0x4,%esp
  803391:	68 50 46 80 00       	push   $0x804650
  803396:	68 5c 01 00 00       	push   $0x15c
  80339b:	68 a7 45 80 00       	push   $0x8045a7
  8033a0:	e8 2a d3 ff ff       	call   8006cf <_panic>
  8033a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033a8:	8b 00                	mov    (%eax),%eax
  8033aa:	85 c0                	test   %eax,%eax
  8033ac:	74 10                	je     8033be <insert_sorted_with_merge_freeList+0x3b5>
  8033ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033b1:	8b 00                	mov    (%eax),%eax
  8033b3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8033b6:	8b 52 04             	mov    0x4(%edx),%edx
  8033b9:	89 50 04             	mov    %edx,0x4(%eax)
  8033bc:	eb 0b                	jmp    8033c9 <insert_sorted_with_merge_freeList+0x3c0>
  8033be:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033c1:	8b 40 04             	mov    0x4(%eax),%eax
  8033c4:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8033c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033cc:	8b 40 04             	mov    0x4(%eax),%eax
  8033cf:	85 c0                	test   %eax,%eax
  8033d1:	74 0f                	je     8033e2 <insert_sorted_with_merge_freeList+0x3d9>
  8033d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033d6:	8b 40 04             	mov    0x4(%eax),%eax
  8033d9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8033dc:	8b 12                	mov    (%edx),%edx
  8033de:	89 10                	mov    %edx,(%eax)
  8033e0:	eb 0a                	jmp    8033ec <insert_sorted_with_merge_freeList+0x3e3>
  8033e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033e5:	8b 00                	mov    (%eax),%eax
  8033e7:	a3 38 51 80 00       	mov    %eax,0x805138
  8033ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033ef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033f8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033ff:	a1 44 51 80 00       	mov    0x805144,%eax
  803404:	48                   	dec    %eax
  803405:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  80340a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80340d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803414:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803417:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80341e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803422:	75 17                	jne    80343b <insert_sorted_with_merge_freeList+0x432>
  803424:	83 ec 04             	sub    $0x4,%esp
  803427:	68 84 45 80 00       	push   $0x804584
  80342c:	68 5f 01 00 00       	push   $0x15f
  803431:	68 a7 45 80 00       	push   $0x8045a7
  803436:	e8 94 d2 ff ff       	call   8006cf <_panic>
  80343b:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803441:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803444:	89 10                	mov    %edx,(%eax)
  803446:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803449:	8b 00                	mov    (%eax),%eax
  80344b:	85 c0                	test   %eax,%eax
  80344d:	74 0d                	je     80345c <insert_sorted_with_merge_freeList+0x453>
  80344f:	a1 48 51 80 00       	mov    0x805148,%eax
  803454:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803457:	89 50 04             	mov    %edx,0x4(%eax)
  80345a:	eb 08                	jmp    803464 <insert_sorted_with_merge_freeList+0x45b>
  80345c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80345f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803464:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803467:	a3 48 51 80 00       	mov    %eax,0x805148
  80346c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80346f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803476:	a1 54 51 80 00       	mov    0x805154,%eax
  80347b:	40                   	inc    %eax
  80347c:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803481:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803484:	8b 50 0c             	mov    0xc(%eax),%edx
  803487:	8b 45 08             	mov    0x8(%ebp),%eax
  80348a:	8b 40 0c             	mov    0xc(%eax),%eax
  80348d:	01 c2                	add    %eax,%edx
  80348f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803492:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803495:	8b 45 08             	mov    0x8(%ebp),%eax
  803498:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  80349f:	8b 45 08             	mov    0x8(%ebp),%eax
  8034a2:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8034a9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034ad:	75 17                	jne    8034c6 <insert_sorted_with_merge_freeList+0x4bd>
  8034af:	83 ec 04             	sub    $0x4,%esp
  8034b2:	68 84 45 80 00       	push   $0x804584
  8034b7:	68 64 01 00 00       	push   $0x164
  8034bc:	68 a7 45 80 00       	push   $0x8045a7
  8034c1:	e8 09 d2 ff ff       	call   8006cf <_panic>
  8034c6:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8034cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8034cf:	89 10                	mov    %edx,(%eax)
  8034d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8034d4:	8b 00                	mov    (%eax),%eax
  8034d6:	85 c0                	test   %eax,%eax
  8034d8:	74 0d                	je     8034e7 <insert_sorted_with_merge_freeList+0x4de>
  8034da:	a1 48 51 80 00       	mov    0x805148,%eax
  8034df:	8b 55 08             	mov    0x8(%ebp),%edx
  8034e2:	89 50 04             	mov    %edx,0x4(%eax)
  8034e5:	eb 08                	jmp    8034ef <insert_sorted_with_merge_freeList+0x4e6>
  8034e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ea:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8034ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8034f2:	a3 48 51 80 00       	mov    %eax,0x805148
  8034f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8034fa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803501:	a1 54 51 80 00       	mov    0x805154,%eax
  803506:	40                   	inc    %eax
  803507:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  80350c:	e9 41 02 00 00       	jmp    803752 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803511:	8b 45 08             	mov    0x8(%ebp),%eax
  803514:	8b 50 08             	mov    0x8(%eax),%edx
  803517:	8b 45 08             	mov    0x8(%ebp),%eax
  80351a:	8b 40 0c             	mov    0xc(%eax),%eax
  80351d:	01 c2                	add    %eax,%edx
  80351f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803522:	8b 40 08             	mov    0x8(%eax),%eax
  803525:	39 c2                	cmp    %eax,%edx
  803527:	0f 85 7c 01 00 00    	jne    8036a9 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  80352d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803531:	74 06                	je     803539 <insert_sorted_with_merge_freeList+0x530>
  803533:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803537:	75 17                	jne    803550 <insert_sorted_with_merge_freeList+0x547>
  803539:	83 ec 04             	sub    $0x4,%esp
  80353c:	68 c0 45 80 00       	push   $0x8045c0
  803541:	68 69 01 00 00       	push   $0x169
  803546:	68 a7 45 80 00       	push   $0x8045a7
  80354b:	e8 7f d1 ff ff       	call   8006cf <_panic>
  803550:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803553:	8b 50 04             	mov    0x4(%eax),%edx
  803556:	8b 45 08             	mov    0x8(%ebp),%eax
  803559:	89 50 04             	mov    %edx,0x4(%eax)
  80355c:	8b 45 08             	mov    0x8(%ebp),%eax
  80355f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803562:	89 10                	mov    %edx,(%eax)
  803564:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803567:	8b 40 04             	mov    0x4(%eax),%eax
  80356a:	85 c0                	test   %eax,%eax
  80356c:	74 0d                	je     80357b <insert_sorted_with_merge_freeList+0x572>
  80356e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803571:	8b 40 04             	mov    0x4(%eax),%eax
  803574:	8b 55 08             	mov    0x8(%ebp),%edx
  803577:	89 10                	mov    %edx,(%eax)
  803579:	eb 08                	jmp    803583 <insert_sorted_with_merge_freeList+0x57a>
  80357b:	8b 45 08             	mov    0x8(%ebp),%eax
  80357e:	a3 38 51 80 00       	mov    %eax,0x805138
  803583:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803586:	8b 55 08             	mov    0x8(%ebp),%edx
  803589:	89 50 04             	mov    %edx,0x4(%eax)
  80358c:	a1 44 51 80 00       	mov    0x805144,%eax
  803591:	40                   	inc    %eax
  803592:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803597:	8b 45 08             	mov    0x8(%ebp),%eax
  80359a:	8b 50 0c             	mov    0xc(%eax),%edx
  80359d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035a0:	8b 40 0c             	mov    0xc(%eax),%eax
  8035a3:	01 c2                	add    %eax,%edx
  8035a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8035a8:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8035ab:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8035af:	75 17                	jne    8035c8 <insert_sorted_with_merge_freeList+0x5bf>
  8035b1:	83 ec 04             	sub    $0x4,%esp
  8035b4:	68 50 46 80 00       	push   $0x804650
  8035b9:	68 6b 01 00 00       	push   $0x16b
  8035be:	68 a7 45 80 00       	push   $0x8045a7
  8035c3:	e8 07 d1 ff ff       	call   8006cf <_panic>
  8035c8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035cb:	8b 00                	mov    (%eax),%eax
  8035cd:	85 c0                	test   %eax,%eax
  8035cf:	74 10                	je     8035e1 <insert_sorted_with_merge_freeList+0x5d8>
  8035d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035d4:	8b 00                	mov    (%eax),%eax
  8035d6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8035d9:	8b 52 04             	mov    0x4(%edx),%edx
  8035dc:	89 50 04             	mov    %edx,0x4(%eax)
  8035df:	eb 0b                	jmp    8035ec <insert_sorted_with_merge_freeList+0x5e3>
  8035e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035e4:	8b 40 04             	mov    0x4(%eax),%eax
  8035e7:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8035ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035ef:	8b 40 04             	mov    0x4(%eax),%eax
  8035f2:	85 c0                	test   %eax,%eax
  8035f4:	74 0f                	je     803605 <insert_sorted_with_merge_freeList+0x5fc>
  8035f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035f9:	8b 40 04             	mov    0x4(%eax),%eax
  8035fc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8035ff:	8b 12                	mov    (%edx),%edx
  803601:	89 10                	mov    %edx,(%eax)
  803603:	eb 0a                	jmp    80360f <insert_sorted_with_merge_freeList+0x606>
  803605:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803608:	8b 00                	mov    (%eax),%eax
  80360a:	a3 38 51 80 00       	mov    %eax,0x805138
  80360f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803612:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803618:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80361b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803622:	a1 44 51 80 00       	mov    0x805144,%eax
  803627:	48                   	dec    %eax
  803628:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  80362d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803630:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803637:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80363a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803641:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803645:	75 17                	jne    80365e <insert_sorted_with_merge_freeList+0x655>
  803647:	83 ec 04             	sub    $0x4,%esp
  80364a:	68 84 45 80 00       	push   $0x804584
  80364f:	68 6e 01 00 00       	push   $0x16e
  803654:	68 a7 45 80 00       	push   $0x8045a7
  803659:	e8 71 d0 ff ff       	call   8006cf <_panic>
  80365e:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803664:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803667:	89 10                	mov    %edx,(%eax)
  803669:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80366c:	8b 00                	mov    (%eax),%eax
  80366e:	85 c0                	test   %eax,%eax
  803670:	74 0d                	je     80367f <insert_sorted_with_merge_freeList+0x676>
  803672:	a1 48 51 80 00       	mov    0x805148,%eax
  803677:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80367a:	89 50 04             	mov    %edx,0x4(%eax)
  80367d:	eb 08                	jmp    803687 <insert_sorted_with_merge_freeList+0x67e>
  80367f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803682:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803687:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80368a:	a3 48 51 80 00       	mov    %eax,0x805148
  80368f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803692:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803699:	a1 54 51 80 00       	mov    0x805154,%eax
  80369e:	40                   	inc    %eax
  80369f:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8036a4:	e9 a9 00 00 00       	jmp    803752 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  8036a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036ad:	74 06                	je     8036b5 <insert_sorted_with_merge_freeList+0x6ac>
  8036af:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8036b3:	75 17                	jne    8036cc <insert_sorted_with_merge_freeList+0x6c3>
  8036b5:	83 ec 04             	sub    $0x4,%esp
  8036b8:	68 1c 46 80 00       	push   $0x80461c
  8036bd:	68 73 01 00 00       	push   $0x173
  8036c2:	68 a7 45 80 00       	push   $0x8045a7
  8036c7:	e8 03 d0 ff ff       	call   8006cf <_panic>
  8036cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036cf:	8b 10                	mov    (%eax),%edx
  8036d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8036d4:	89 10                	mov    %edx,(%eax)
  8036d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8036d9:	8b 00                	mov    (%eax),%eax
  8036db:	85 c0                	test   %eax,%eax
  8036dd:	74 0b                	je     8036ea <insert_sorted_with_merge_freeList+0x6e1>
  8036df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036e2:	8b 00                	mov    (%eax),%eax
  8036e4:	8b 55 08             	mov    0x8(%ebp),%edx
  8036e7:	89 50 04             	mov    %edx,0x4(%eax)
  8036ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036ed:	8b 55 08             	mov    0x8(%ebp),%edx
  8036f0:	89 10                	mov    %edx,(%eax)
  8036f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8036f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8036f8:	89 50 04             	mov    %edx,0x4(%eax)
  8036fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8036fe:	8b 00                	mov    (%eax),%eax
  803700:	85 c0                	test   %eax,%eax
  803702:	75 08                	jne    80370c <insert_sorted_with_merge_freeList+0x703>
  803704:	8b 45 08             	mov    0x8(%ebp),%eax
  803707:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80370c:	a1 44 51 80 00       	mov    0x805144,%eax
  803711:	40                   	inc    %eax
  803712:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803717:	eb 39                	jmp    803752 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803719:	a1 40 51 80 00       	mov    0x805140,%eax
  80371e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803721:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803725:	74 07                	je     80372e <insert_sorted_with_merge_freeList+0x725>
  803727:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80372a:	8b 00                	mov    (%eax),%eax
  80372c:	eb 05                	jmp    803733 <insert_sorted_with_merge_freeList+0x72a>
  80372e:	b8 00 00 00 00       	mov    $0x0,%eax
  803733:	a3 40 51 80 00       	mov    %eax,0x805140
  803738:	a1 40 51 80 00       	mov    0x805140,%eax
  80373d:	85 c0                	test   %eax,%eax
  80373f:	0f 85 c7 fb ff ff    	jne    80330c <insert_sorted_with_merge_freeList+0x303>
  803745:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803749:	0f 85 bd fb ff ff    	jne    80330c <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80374f:	eb 01                	jmp    803752 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803751:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803752:	90                   	nop
  803753:	c9                   	leave  
  803754:	c3                   	ret    
  803755:	66 90                	xchg   %ax,%ax
  803757:	90                   	nop

00803758 <__udivdi3>:
  803758:	55                   	push   %ebp
  803759:	57                   	push   %edi
  80375a:	56                   	push   %esi
  80375b:	53                   	push   %ebx
  80375c:	83 ec 1c             	sub    $0x1c,%esp
  80375f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803763:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803767:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80376b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80376f:	89 ca                	mov    %ecx,%edx
  803771:	89 f8                	mov    %edi,%eax
  803773:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803777:	85 f6                	test   %esi,%esi
  803779:	75 2d                	jne    8037a8 <__udivdi3+0x50>
  80377b:	39 cf                	cmp    %ecx,%edi
  80377d:	77 65                	ja     8037e4 <__udivdi3+0x8c>
  80377f:	89 fd                	mov    %edi,%ebp
  803781:	85 ff                	test   %edi,%edi
  803783:	75 0b                	jne    803790 <__udivdi3+0x38>
  803785:	b8 01 00 00 00       	mov    $0x1,%eax
  80378a:	31 d2                	xor    %edx,%edx
  80378c:	f7 f7                	div    %edi
  80378e:	89 c5                	mov    %eax,%ebp
  803790:	31 d2                	xor    %edx,%edx
  803792:	89 c8                	mov    %ecx,%eax
  803794:	f7 f5                	div    %ebp
  803796:	89 c1                	mov    %eax,%ecx
  803798:	89 d8                	mov    %ebx,%eax
  80379a:	f7 f5                	div    %ebp
  80379c:	89 cf                	mov    %ecx,%edi
  80379e:	89 fa                	mov    %edi,%edx
  8037a0:	83 c4 1c             	add    $0x1c,%esp
  8037a3:	5b                   	pop    %ebx
  8037a4:	5e                   	pop    %esi
  8037a5:	5f                   	pop    %edi
  8037a6:	5d                   	pop    %ebp
  8037a7:	c3                   	ret    
  8037a8:	39 ce                	cmp    %ecx,%esi
  8037aa:	77 28                	ja     8037d4 <__udivdi3+0x7c>
  8037ac:	0f bd fe             	bsr    %esi,%edi
  8037af:	83 f7 1f             	xor    $0x1f,%edi
  8037b2:	75 40                	jne    8037f4 <__udivdi3+0x9c>
  8037b4:	39 ce                	cmp    %ecx,%esi
  8037b6:	72 0a                	jb     8037c2 <__udivdi3+0x6a>
  8037b8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8037bc:	0f 87 9e 00 00 00    	ja     803860 <__udivdi3+0x108>
  8037c2:	b8 01 00 00 00       	mov    $0x1,%eax
  8037c7:	89 fa                	mov    %edi,%edx
  8037c9:	83 c4 1c             	add    $0x1c,%esp
  8037cc:	5b                   	pop    %ebx
  8037cd:	5e                   	pop    %esi
  8037ce:	5f                   	pop    %edi
  8037cf:	5d                   	pop    %ebp
  8037d0:	c3                   	ret    
  8037d1:	8d 76 00             	lea    0x0(%esi),%esi
  8037d4:	31 ff                	xor    %edi,%edi
  8037d6:	31 c0                	xor    %eax,%eax
  8037d8:	89 fa                	mov    %edi,%edx
  8037da:	83 c4 1c             	add    $0x1c,%esp
  8037dd:	5b                   	pop    %ebx
  8037de:	5e                   	pop    %esi
  8037df:	5f                   	pop    %edi
  8037e0:	5d                   	pop    %ebp
  8037e1:	c3                   	ret    
  8037e2:	66 90                	xchg   %ax,%ax
  8037e4:	89 d8                	mov    %ebx,%eax
  8037e6:	f7 f7                	div    %edi
  8037e8:	31 ff                	xor    %edi,%edi
  8037ea:	89 fa                	mov    %edi,%edx
  8037ec:	83 c4 1c             	add    $0x1c,%esp
  8037ef:	5b                   	pop    %ebx
  8037f0:	5e                   	pop    %esi
  8037f1:	5f                   	pop    %edi
  8037f2:	5d                   	pop    %ebp
  8037f3:	c3                   	ret    
  8037f4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8037f9:	89 eb                	mov    %ebp,%ebx
  8037fb:	29 fb                	sub    %edi,%ebx
  8037fd:	89 f9                	mov    %edi,%ecx
  8037ff:	d3 e6                	shl    %cl,%esi
  803801:	89 c5                	mov    %eax,%ebp
  803803:	88 d9                	mov    %bl,%cl
  803805:	d3 ed                	shr    %cl,%ebp
  803807:	89 e9                	mov    %ebp,%ecx
  803809:	09 f1                	or     %esi,%ecx
  80380b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80380f:	89 f9                	mov    %edi,%ecx
  803811:	d3 e0                	shl    %cl,%eax
  803813:	89 c5                	mov    %eax,%ebp
  803815:	89 d6                	mov    %edx,%esi
  803817:	88 d9                	mov    %bl,%cl
  803819:	d3 ee                	shr    %cl,%esi
  80381b:	89 f9                	mov    %edi,%ecx
  80381d:	d3 e2                	shl    %cl,%edx
  80381f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803823:	88 d9                	mov    %bl,%cl
  803825:	d3 e8                	shr    %cl,%eax
  803827:	09 c2                	or     %eax,%edx
  803829:	89 d0                	mov    %edx,%eax
  80382b:	89 f2                	mov    %esi,%edx
  80382d:	f7 74 24 0c          	divl   0xc(%esp)
  803831:	89 d6                	mov    %edx,%esi
  803833:	89 c3                	mov    %eax,%ebx
  803835:	f7 e5                	mul    %ebp
  803837:	39 d6                	cmp    %edx,%esi
  803839:	72 19                	jb     803854 <__udivdi3+0xfc>
  80383b:	74 0b                	je     803848 <__udivdi3+0xf0>
  80383d:	89 d8                	mov    %ebx,%eax
  80383f:	31 ff                	xor    %edi,%edi
  803841:	e9 58 ff ff ff       	jmp    80379e <__udivdi3+0x46>
  803846:	66 90                	xchg   %ax,%ax
  803848:	8b 54 24 08          	mov    0x8(%esp),%edx
  80384c:	89 f9                	mov    %edi,%ecx
  80384e:	d3 e2                	shl    %cl,%edx
  803850:	39 c2                	cmp    %eax,%edx
  803852:	73 e9                	jae    80383d <__udivdi3+0xe5>
  803854:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803857:	31 ff                	xor    %edi,%edi
  803859:	e9 40 ff ff ff       	jmp    80379e <__udivdi3+0x46>
  80385e:	66 90                	xchg   %ax,%ax
  803860:	31 c0                	xor    %eax,%eax
  803862:	e9 37 ff ff ff       	jmp    80379e <__udivdi3+0x46>
  803867:	90                   	nop

00803868 <__umoddi3>:
  803868:	55                   	push   %ebp
  803869:	57                   	push   %edi
  80386a:	56                   	push   %esi
  80386b:	53                   	push   %ebx
  80386c:	83 ec 1c             	sub    $0x1c,%esp
  80386f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803873:	8b 74 24 34          	mov    0x34(%esp),%esi
  803877:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80387b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80387f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803883:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803887:	89 f3                	mov    %esi,%ebx
  803889:	89 fa                	mov    %edi,%edx
  80388b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80388f:	89 34 24             	mov    %esi,(%esp)
  803892:	85 c0                	test   %eax,%eax
  803894:	75 1a                	jne    8038b0 <__umoddi3+0x48>
  803896:	39 f7                	cmp    %esi,%edi
  803898:	0f 86 a2 00 00 00    	jbe    803940 <__umoddi3+0xd8>
  80389e:	89 c8                	mov    %ecx,%eax
  8038a0:	89 f2                	mov    %esi,%edx
  8038a2:	f7 f7                	div    %edi
  8038a4:	89 d0                	mov    %edx,%eax
  8038a6:	31 d2                	xor    %edx,%edx
  8038a8:	83 c4 1c             	add    $0x1c,%esp
  8038ab:	5b                   	pop    %ebx
  8038ac:	5e                   	pop    %esi
  8038ad:	5f                   	pop    %edi
  8038ae:	5d                   	pop    %ebp
  8038af:	c3                   	ret    
  8038b0:	39 f0                	cmp    %esi,%eax
  8038b2:	0f 87 ac 00 00 00    	ja     803964 <__umoddi3+0xfc>
  8038b8:	0f bd e8             	bsr    %eax,%ebp
  8038bb:	83 f5 1f             	xor    $0x1f,%ebp
  8038be:	0f 84 ac 00 00 00    	je     803970 <__umoddi3+0x108>
  8038c4:	bf 20 00 00 00       	mov    $0x20,%edi
  8038c9:	29 ef                	sub    %ebp,%edi
  8038cb:	89 fe                	mov    %edi,%esi
  8038cd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8038d1:	89 e9                	mov    %ebp,%ecx
  8038d3:	d3 e0                	shl    %cl,%eax
  8038d5:	89 d7                	mov    %edx,%edi
  8038d7:	89 f1                	mov    %esi,%ecx
  8038d9:	d3 ef                	shr    %cl,%edi
  8038db:	09 c7                	or     %eax,%edi
  8038dd:	89 e9                	mov    %ebp,%ecx
  8038df:	d3 e2                	shl    %cl,%edx
  8038e1:	89 14 24             	mov    %edx,(%esp)
  8038e4:	89 d8                	mov    %ebx,%eax
  8038e6:	d3 e0                	shl    %cl,%eax
  8038e8:	89 c2                	mov    %eax,%edx
  8038ea:	8b 44 24 08          	mov    0x8(%esp),%eax
  8038ee:	d3 e0                	shl    %cl,%eax
  8038f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8038f4:	8b 44 24 08          	mov    0x8(%esp),%eax
  8038f8:	89 f1                	mov    %esi,%ecx
  8038fa:	d3 e8                	shr    %cl,%eax
  8038fc:	09 d0                	or     %edx,%eax
  8038fe:	d3 eb                	shr    %cl,%ebx
  803900:	89 da                	mov    %ebx,%edx
  803902:	f7 f7                	div    %edi
  803904:	89 d3                	mov    %edx,%ebx
  803906:	f7 24 24             	mull   (%esp)
  803909:	89 c6                	mov    %eax,%esi
  80390b:	89 d1                	mov    %edx,%ecx
  80390d:	39 d3                	cmp    %edx,%ebx
  80390f:	0f 82 87 00 00 00    	jb     80399c <__umoddi3+0x134>
  803915:	0f 84 91 00 00 00    	je     8039ac <__umoddi3+0x144>
  80391b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80391f:	29 f2                	sub    %esi,%edx
  803921:	19 cb                	sbb    %ecx,%ebx
  803923:	89 d8                	mov    %ebx,%eax
  803925:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803929:	d3 e0                	shl    %cl,%eax
  80392b:	89 e9                	mov    %ebp,%ecx
  80392d:	d3 ea                	shr    %cl,%edx
  80392f:	09 d0                	or     %edx,%eax
  803931:	89 e9                	mov    %ebp,%ecx
  803933:	d3 eb                	shr    %cl,%ebx
  803935:	89 da                	mov    %ebx,%edx
  803937:	83 c4 1c             	add    $0x1c,%esp
  80393a:	5b                   	pop    %ebx
  80393b:	5e                   	pop    %esi
  80393c:	5f                   	pop    %edi
  80393d:	5d                   	pop    %ebp
  80393e:	c3                   	ret    
  80393f:	90                   	nop
  803940:	89 fd                	mov    %edi,%ebp
  803942:	85 ff                	test   %edi,%edi
  803944:	75 0b                	jne    803951 <__umoddi3+0xe9>
  803946:	b8 01 00 00 00       	mov    $0x1,%eax
  80394b:	31 d2                	xor    %edx,%edx
  80394d:	f7 f7                	div    %edi
  80394f:	89 c5                	mov    %eax,%ebp
  803951:	89 f0                	mov    %esi,%eax
  803953:	31 d2                	xor    %edx,%edx
  803955:	f7 f5                	div    %ebp
  803957:	89 c8                	mov    %ecx,%eax
  803959:	f7 f5                	div    %ebp
  80395b:	89 d0                	mov    %edx,%eax
  80395d:	e9 44 ff ff ff       	jmp    8038a6 <__umoddi3+0x3e>
  803962:	66 90                	xchg   %ax,%ax
  803964:	89 c8                	mov    %ecx,%eax
  803966:	89 f2                	mov    %esi,%edx
  803968:	83 c4 1c             	add    $0x1c,%esp
  80396b:	5b                   	pop    %ebx
  80396c:	5e                   	pop    %esi
  80396d:	5f                   	pop    %edi
  80396e:	5d                   	pop    %ebp
  80396f:	c3                   	ret    
  803970:	3b 04 24             	cmp    (%esp),%eax
  803973:	72 06                	jb     80397b <__umoddi3+0x113>
  803975:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803979:	77 0f                	ja     80398a <__umoddi3+0x122>
  80397b:	89 f2                	mov    %esi,%edx
  80397d:	29 f9                	sub    %edi,%ecx
  80397f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803983:	89 14 24             	mov    %edx,(%esp)
  803986:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80398a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80398e:	8b 14 24             	mov    (%esp),%edx
  803991:	83 c4 1c             	add    $0x1c,%esp
  803994:	5b                   	pop    %ebx
  803995:	5e                   	pop    %esi
  803996:	5f                   	pop    %edi
  803997:	5d                   	pop    %ebp
  803998:	c3                   	ret    
  803999:	8d 76 00             	lea    0x0(%esi),%esi
  80399c:	2b 04 24             	sub    (%esp),%eax
  80399f:	19 fa                	sbb    %edi,%edx
  8039a1:	89 d1                	mov    %edx,%ecx
  8039a3:	89 c6                	mov    %eax,%esi
  8039a5:	e9 71 ff ff ff       	jmp    80391b <__umoddi3+0xb3>
  8039aa:	66 90                	xchg   %ax,%ax
  8039ac:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8039b0:	72 ea                	jb     80399c <__umoddi3+0x134>
  8039b2:	89 d9                	mov    %ebx,%ecx
  8039b4:	e9 62 ff ff ff       	jmp    80391b <__umoddi3+0xb3>
