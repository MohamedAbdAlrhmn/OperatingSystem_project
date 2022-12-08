
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
  80008d:	68 60 39 80 00       	push   $0x803960
  800092:	6a 12                	push   $0x12
  800094:	68 7c 39 80 00       	push   $0x80397c
  800099:	e8 31 06 00 00       	call   8006cf <_panic>
	}

	cprintf("************************************************\n");
  80009e:	83 ec 0c             	sub    $0xc,%esp
  8000a1:	68 94 39 80 00       	push   $0x803994
  8000a6:	e8 d8 08 00 00       	call   800983 <cprintf>
  8000ab:	83 c4 10             	add    $0x10,%esp
	cprintf("MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  8000ae:	83 ec 0c             	sub    $0xc,%esp
  8000b1:	68 c8 39 80 00       	push   $0x8039c8
  8000b6:	e8 c8 08 00 00       	call   800983 <cprintf>
  8000bb:	83 c4 10             	add    $0x10,%esp
	cprintf("************************************************\n\n\n");
  8000be:	83 ec 0c             	sub    $0xc,%esp
  8000c1:	68 24 3a 80 00       	push   $0x803a24
  8000c6:	e8 b8 08 00 00       	call   800983 <cprintf>
  8000cb:	83 c4 10             	add    $0x10,%esp

	int Mega = 1024*1024;
  8000ce:	c7 45 ec 00 00 10 00 	movl   $0x100000,-0x14(%ebp)
	int kilo = 1024;
  8000d5:	c7 45 e8 00 04 00 00 	movl   $0x400,-0x18(%ebp)
	int envID = sys_getenvid();
  8000dc:	e8 11 1d 00 00       	call   801df2 <sys_getenvid>
  8000e1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	cprintf("STEP A: checking free of a shared object ... \n");
  8000e4:	83 ec 0c             	sub    $0xc,%esp
  8000e7:	68 58 3a 80 00       	push   $0x803a58
  8000ec:	e8 92 08 00 00       	call   800983 <cprintf>
  8000f1:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x;
		int freeFrames = sys_calculate_free_frames() ;
  8000f4:	e8 32 1a 00 00       	call   801b2b <sys_calculate_free_frames>
  8000f9:	89 45 e0             	mov    %eax,-0x20(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8000fc:	83 ec 04             	sub    $0x4,%esp
  8000ff:	6a 01                	push   $0x1
  800101:	68 00 10 00 00       	push   $0x1000
  800106:	68 87 3a 80 00       	push   $0x803a87
  80010b:	e8 43 18 00 00       	call   801953 <smalloc>
  800110:	83 c4 10             	add    $0x10,%esp
  800113:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (x != (uint32*)USER_HEAP_START) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  800116:	81 7d dc 00 00 00 80 	cmpl   $0x80000000,-0x24(%ebp)
  80011d:	74 14                	je     800133 <_main+0xfb>
  80011f:	83 ec 04             	sub    $0x4,%esp
  800122:	68 8c 3a 80 00       	push   $0x803a8c
  800127:	6a 21                	push   $0x21
  800129:	68 7c 39 80 00       	push   $0x80397c
  80012e:	e8 9c 05 00 00       	call   8006cf <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800133:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800136:	e8 f0 19 00 00       	call   801b2b <sys_calculate_free_frames>
  80013b:	29 c3                	sub    %eax,%ebx
  80013d:	89 d8                	mov    %ebx,%eax
  80013f:	83 f8 04             	cmp    $0x4,%eax
  800142:	74 14                	je     800158 <_main+0x120>
  800144:	83 ec 04             	sub    $0x4,%esp
  800147:	68 f8 3a 80 00       	push   $0x803af8
  80014c:	6a 22                	push   $0x22
  80014e:	68 7c 39 80 00       	push   $0x80397c
  800153:	e8 77 05 00 00       	call   8006cf <_panic>

		sfree(x);
  800158:	83 ec 0c             	sub    $0xc,%esp
  80015b:	ff 75 dc             	pushl  -0x24(%ebp)
  80015e:	e8 68 18 00 00       	call   8019cb <sfree>
  800163:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) ==  0+0+2) panic("Wrong free: make sure that you free the shared object by calling free_share_object()");
  800166:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800169:	e8 bd 19 00 00       	call   801b2b <sys_calculate_free_frames>
  80016e:	29 c3                	sub    %eax,%ebx
  800170:	89 d8                	mov    %ebx,%eax
  800172:	83 f8 02             	cmp    $0x2,%eax
  800175:	75 14                	jne    80018b <_main+0x153>
  800177:	83 ec 04             	sub    $0x4,%esp
  80017a:	68 78 3b 80 00       	push   $0x803b78
  80017f:	6a 25                	push   $0x25
  800181:	68 7c 39 80 00       	push   $0x80397c
  800186:	e8 44 05 00 00       	call   8006cf <_panic>
		else if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong free: revise your freeSharedObject logic");
  80018b:	e8 9b 19 00 00       	call   801b2b <sys_calculate_free_frames>
  800190:	89 c2                	mov    %eax,%edx
  800192:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800195:	39 c2                	cmp    %eax,%edx
  800197:	74 14                	je     8001ad <_main+0x175>
  800199:	83 ec 04             	sub    $0x4,%esp
  80019c:	68 d0 3b 80 00       	push   $0x803bd0
  8001a1:	6a 26                	push   $0x26
  8001a3:	68 7c 39 80 00       	push   $0x80397c
  8001a8:	e8 22 05 00 00       	call   8006cf <_panic>
	}
	cprintf("Step A completed successfully!!\n\n\n");
  8001ad:	83 ec 0c             	sub    $0xc,%esp
  8001b0:	68 00 3c 80 00       	push   $0x803c00
  8001b5:	e8 c9 07 00 00       	call   800983 <cprintf>
  8001ba:	83 c4 10             	add    $0x10,%esp


	cprintf("STEP B: checking free of 2 shared objects ... \n");
  8001bd:	83 ec 0c             	sub    $0xc,%esp
  8001c0:	68 24 3c 80 00       	push   $0x803c24
  8001c5:	e8 b9 07 00 00       	call   800983 <cprintf>
  8001ca:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x, *z ;
		int freeFrames = sys_calculate_free_frames() ;
  8001cd:	e8 59 19 00 00       	call   801b2b <sys_calculate_free_frames>
  8001d2:	89 45 d8             	mov    %eax,-0x28(%ebp)
		z = smalloc("z", PAGE_SIZE, 1);
  8001d5:	83 ec 04             	sub    $0x4,%esp
  8001d8:	6a 01                	push   $0x1
  8001da:	68 00 10 00 00       	push   $0x1000
  8001df:	68 54 3c 80 00       	push   $0x803c54
  8001e4:	e8 6a 17 00 00       	call   801953 <smalloc>
  8001e9:	83 c4 10             	add    $0x10,%esp
  8001ec:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8001ef:	83 ec 04             	sub    $0x4,%esp
  8001f2:	6a 01                	push   $0x1
  8001f4:	68 00 10 00 00       	push   $0x1000
  8001f9:	68 87 3a 80 00       	push   $0x803a87
  8001fe:	e8 50 17 00 00       	call   801953 <smalloc>
  800203:	83 c4 10             	add    $0x10,%esp
  800206:	89 45 d0             	mov    %eax,-0x30(%ebp)

		if(x == NULL) panic("Wrong free: make sure that you free the shared object by calling free_share_object()");
  800209:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80020d:	75 14                	jne    800223 <_main+0x1eb>
  80020f:	83 ec 04             	sub    $0x4,%esp
  800212:	68 78 3b 80 00       	push   $0x803b78
  800217:	6a 32                	push   $0x32
  800219:	68 7c 39 80 00       	push   $0x80397c
  80021e:	e8 ac 04 00 00       	call   8006cf <_panic>

		if ((freeFrames - sys_calculate_free_frames()) !=  2+1+4) panic("Wrong previous free: make sure that you correctly free shared object before (Step A)");
  800223:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800226:	e8 00 19 00 00       	call   801b2b <sys_calculate_free_frames>
  80022b:	29 c3                	sub    %eax,%ebx
  80022d:	89 d8                	mov    %ebx,%eax
  80022f:	83 f8 07             	cmp    $0x7,%eax
  800232:	74 14                	je     800248 <_main+0x210>
  800234:	83 ec 04             	sub    $0x4,%esp
  800237:	68 58 3c 80 00       	push   $0x803c58
  80023c:	6a 34                	push   $0x34
  80023e:	68 7c 39 80 00       	push   $0x80397c
  800243:	e8 87 04 00 00       	call   8006cf <_panic>

		sfree(z);
  800248:	83 ec 0c             	sub    $0xc,%esp
  80024b:	ff 75 d4             	pushl  -0x2c(%ebp)
  80024e:	e8 78 17 00 00       	call   8019cb <sfree>
  800253:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong free: check your logic");
  800256:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800259:	e8 cd 18 00 00       	call   801b2b <sys_calculate_free_frames>
  80025e:	29 c3                	sub    %eax,%ebx
  800260:	89 d8                	mov    %ebx,%eax
  800262:	83 f8 04             	cmp    $0x4,%eax
  800265:	74 14                	je     80027b <_main+0x243>
  800267:	83 ec 04             	sub    $0x4,%esp
  80026a:	68 ad 3c 80 00       	push   $0x803cad
  80026f:	6a 37                	push   $0x37
  800271:	68 7c 39 80 00       	push   $0x80397c
  800276:	e8 54 04 00 00       	call   8006cf <_panic>

		sfree(x);
  80027b:	83 ec 0c             	sub    $0xc,%esp
  80027e:	ff 75 d0             	pushl  -0x30(%ebp)
  800281:	e8 45 17 00 00       	call   8019cb <sfree>
  800286:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong free: check your logic");
  800289:	e8 9d 18 00 00       	call   801b2b <sys_calculate_free_frames>
  80028e:	89 c2                	mov    %eax,%edx
  800290:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800293:	39 c2                	cmp    %eax,%edx
  800295:	74 14                	je     8002ab <_main+0x273>
  800297:	83 ec 04             	sub    $0x4,%esp
  80029a:	68 ad 3c 80 00       	push   $0x803cad
  80029f:	6a 3a                	push   $0x3a
  8002a1:	68 7c 39 80 00       	push   $0x80397c
  8002a6:	e8 24 04 00 00       	call   8006cf <_panic>

	}
	cprintf("Step B completed successfully!!\n\n\n");
  8002ab:	83 ec 0c             	sub    $0xc,%esp
  8002ae:	68 cc 3c 80 00       	push   $0x803ccc
  8002b3:	e8 cb 06 00 00       	call   800983 <cprintf>
  8002b8:	83 c4 10             	add    $0x10,%esp

	cprintf("STEP C: checking range of loop during free... \n");
  8002bb:	83 ec 0c             	sub    $0xc,%esp
  8002be:	68 f0 3c 80 00       	push   $0x803cf0
  8002c3:	e8 bb 06 00 00       	call   800983 <cprintf>
  8002c8:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *w, *u;
		int freeFrames = sys_calculate_free_frames() ;
  8002cb:	e8 5b 18 00 00       	call   801b2b <sys_calculate_free_frames>
  8002d0:	89 45 cc             	mov    %eax,-0x34(%ebp)
		w = smalloc("w", 3 * PAGE_SIZE+1, 1);
  8002d3:	83 ec 04             	sub    $0x4,%esp
  8002d6:	6a 01                	push   $0x1
  8002d8:	68 01 30 00 00       	push   $0x3001
  8002dd:	68 20 3d 80 00       	push   $0x803d20
  8002e2:	e8 6c 16 00 00       	call   801953 <smalloc>
  8002e7:	83 c4 10             	add    $0x10,%esp
  8002ea:	89 45 c8             	mov    %eax,-0x38(%ebp)
		u = smalloc("u", PAGE_SIZE, 1);
  8002ed:	83 ec 04             	sub    $0x4,%esp
  8002f0:	6a 01                	push   $0x1
  8002f2:	68 00 10 00 00       	push   $0x1000
  8002f7:	68 22 3d 80 00       	push   $0x803d22
  8002fc:	e8 52 16 00 00       	call   801953 <smalloc>
  800301:	83 c4 10             	add    $0x10,%esp
  800304:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		if ((freeFrames - sys_calculate_free_frames()) != 5+1+4) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800307:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  80030a:	e8 1c 18 00 00       	call   801b2b <sys_calculate_free_frames>
  80030f:	29 c3                	sub    %eax,%ebx
  800311:	89 d8                	mov    %ebx,%eax
  800313:	83 f8 0a             	cmp    $0xa,%eax
  800316:	74 14                	je     80032c <_main+0x2f4>
  800318:	83 ec 04             	sub    $0x4,%esp
  80031b:	68 f8 3a 80 00       	push   $0x803af8
  800320:	6a 46                	push   $0x46
  800322:	68 7c 39 80 00       	push   $0x80397c
  800327:	e8 a3 03 00 00       	call   8006cf <_panic>

		sfree(w);
  80032c:	83 ec 0c             	sub    $0xc,%esp
  80032f:	ff 75 c8             	pushl  -0x38(%ebp)
  800332:	e8 94 16 00 00       	call   8019cb <sfree>
  800337:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong free: check your logic");
  80033a:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  80033d:	e8 e9 17 00 00       	call   801b2b <sys_calculate_free_frames>
  800342:	29 c3                	sub    %eax,%ebx
  800344:	89 d8                	mov    %ebx,%eax
  800346:	83 f8 04             	cmp    $0x4,%eax
  800349:	74 14                	je     80035f <_main+0x327>
  80034b:	83 ec 04             	sub    $0x4,%esp
  80034e:	68 ad 3c 80 00       	push   $0x803cad
  800353:	6a 49                	push   $0x49
  800355:	68 7c 39 80 00       	push   $0x80397c
  80035a:	e8 70 03 00 00       	call   8006cf <_panic>

		uint32 *o;
		o = smalloc("o", 2 * PAGE_SIZE-1,1);
  80035f:	83 ec 04             	sub    $0x4,%esp
  800362:	6a 01                	push   $0x1
  800364:	68 ff 1f 00 00       	push   $0x1fff
  800369:	68 24 3d 80 00       	push   $0x803d24
  80036e:	e8 e0 15 00 00       	call   801953 <smalloc>
  800373:	83 c4 10             	add    $0x10,%esp
  800376:	89 45 c0             	mov    %eax,-0x40(%ebp)

		if ((freeFrames - sys_calculate_free_frames()) != 3+1+4) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800379:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  80037c:	e8 aa 17 00 00       	call   801b2b <sys_calculate_free_frames>
  800381:	29 c3                	sub    %eax,%ebx
  800383:	89 d8                	mov    %ebx,%eax
  800385:	83 f8 08             	cmp    $0x8,%eax
  800388:	74 14                	je     80039e <_main+0x366>
  80038a:	83 ec 04             	sub    $0x4,%esp
  80038d:	68 f8 3a 80 00       	push   $0x803af8
  800392:	6a 4e                	push   $0x4e
  800394:	68 7c 39 80 00       	push   $0x80397c
  800399:	e8 31 03 00 00       	call   8006cf <_panic>

		sfree(o);
  80039e:	83 ec 0c             	sub    $0xc,%esp
  8003a1:	ff 75 c0             	pushl  -0x40(%ebp)
  8003a4:	e8 22 16 00 00       	call   8019cb <sfree>
  8003a9:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong free: check your logic");
  8003ac:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8003af:	e8 77 17 00 00       	call   801b2b <sys_calculate_free_frames>
  8003b4:	29 c3                	sub    %eax,%ebx
  8003b6:	89 d8                	mov    %ebx,%eax
  8003b8:	83 f8 04             	cmp    $0x4,%eax
  8003bb:	74 14                	je     8003d1 <_main+0x399>
  8003bd:	83 ec 04             	sub    $0x4,%esp
  8003c0:	68 ad 3c 80 00       	push   $0x803cad
  8003c5:	6a 51                	push   $0x51
  8003c7:	68 7c 39 80 00       	push   $0x80397c
  8003cc:	e8 fe 02 00 00       	call   8006cf <_panic>

		sfree(u);
  8003d1:	83 ec 0c             	sub    $0xc,%esp
  8003d4:	ff 75 c4             	pushl  -0x3c(%ebp)
  8003d7:	e8 ef 15 00 00       	call   8019cb <sfree>
  8003dc:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong free: check your logic");
  8003df:	e8 47 17 00 00       	call   801b2b <sys_calculate_free_frames>
  8003e4:	89 c2                	mov    %eax,%edx
  8003e6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8003e9:	39 c2                	cmp    %eax,%edx
  8003eb:	74 14                	je     800401 <_main+0x3c9>
  8003ed:	83 ec 04             	sub    $0x4,%esp
  8003f0:	68 ad 3c 80 00       	push   $0x803cad
  8003f5:	6a 54                	push   $0x54
  8003f7:	68 7c 39 80 00       	push   $0x80397c
  8003fc:	e8 ce 02 00 00       	call   8006cf <_panic>


		//Checking boundaries of page tables
		freeFrames = sys_calculate_free_frames() ;
  800401:	e8 25 17 00 00       	call   801b2b <sys_calculate_free_frames>
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
  80041b:	68 20 3d 80 00       	push   $0x803d20
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
  800441:	68 22 3d 80 00       	push   $0x803d22
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
  800463:	68 24 3d 80 00       	push   $0x803d24
  800468:	e8 e6 14 00 00       	call   801953 <smalloc>
  80046d:	83 c4 10             	add    $0x10,%esp
  800470:	89 45 c0             	mov    %eax,-0x40(%ebp)

		if ((freeFrames - sys_calculate_free_frames()) != 3073+4+7) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800473:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800476:	e8 b0 16 00 00       	call   801b2b <sys_calculate_free_frames>
  80047b:	29 c3                	sub    %eax,%ebx
  80047d:	89 d8                	mov    %ebx,%eax
  80047f:	3d 0c 0c 00 00       	cmp    $0xc0c,%eax
  800484:	74 14                	je     80049a <_main+0x462>
  800486:	83 ec 04             	sub    $0x4,%esp
  800489:	68 f8 3a 80 00       	push   $0x803af8
  80048e:	6a 5d                	push   $0x5d
  800490:	68 7c 39 80 00       	push   $0x80397c
  800495:	e8 35 02 00 00       	call   8006cf <_panic>

		sfree(o);
  80049a:	83 ec 0c             	sub    $0xc,%esp
  80049d:	ff 75 c0             	pushl  -0x40(%ebp)
  8004a0:	e8 26 15 00 00       	call   8019cb <sfree>
  8004a5:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  2560+3+5) panic("Wrong free: check your logic");
  8004a8:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8004ab:	e8 7b 16 00 00       	call   801b2b <sys_calculate_free_frames>
  8004b0:	29 c3                	sub    %eax,%ebx
  8004b2:	89 d8                	mov    %ebx,%eax
  8004b4:	3d 08 0a 00 00       	cmp    $0xa08,%eax
  8004b9:	74 14                	je     8004cf <_main+0x497>
  8004bb:	83 ec 04             	sub    $0x4,%esp
  8004be:	68 ad 3c 80 00       	push   $0x803cad
  8004c3:	6a 60                	push   $0x60
  8004c5:	68 7c 39 80 00       	push   $0x80397c
  8004ca:	e8 00 02 00 00       	call   8006cf <_panic>

		sfree(w);
  8004cf:	83 ec 0c             	sub    $0xc,%esp
  8004d2:	ff 75 c8             	pushl  -0x38(%ebp)
  8004d5:	e8 f1 14 00 00       	call   8019cb <sfree>
  8004da:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  1792+3+3) panic("Wrong free: check your logic");
  8004dd:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8004e0:	e8 46 16 00 00       	call   801b2b <sys_calculate_free_frames>
  8004e5:	29 c3                	sub    %eax,%ebx
  8004e7:	89 d8                	mov    %ebx,%eax
  8004e9:	3d 06 07 00 00       	cmp    $0x706,%eax
  8004ee:	74 14                	je     800504 <_main+0x4cc>
  8004f0:	83 ec 04             	sub    $0x4,%esp
  8004f3:	68 ad 3c 80 00       	push   $0x803cad
  8004f8:	6a 63                	push   $0x63
  8004fa:	68 7c 39 80 00       	push   $0x80397c
  8004ff:	e8 cb 01 00 00       	call   8006cf <_panic>

		sfree(u);
  800504:	83 ec 0c             	sub    $0xc,%esp
  800507:	ff 75 c4             	pushl  -0x3c(%ebp)
  80050a:	e8 bc 14 00 00       	call   8019cb <sfree>
  80050f:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong free: check your logic");
  800512:	e8 14 16 00 00       	call   801b2b <sys_calculate_free_frames>
  800517:	89 c2                	mov    %eax,%edx
  800519:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80051c:	39 c2                	cmp    %eax,%edx
  80051e:	74 14                	je     800534 <_main+0x4fc>
  800520:	83 ec 04             	sub    $0x4,%esp
  800523:	68 ad 3c 80 00       	push   $0x803cad
  800528:	6a 66                	push   $0x66
  80052a:	68 7c 39 80 00       	push   $0x80397c
  80052f:	e8 9b 01 00 00       	call   8006cf <_panic>
	}
	cprintf("Step C completed successfully!!\n\n\n");
  800534:	83 ec 0c             	sub    $0xc,%esp
  800537:	68 28 3d 80 00       	push   $0x803d28
  80053c:	e8 42 04 00 00       	call   800983 <cprintf>
  800541:	83 c4 10             	add    $0x10,%esp

	cprintf("Congratulations!! Test of freeSharedObjects [4] completed successfully!!\n\n\n");
  800544:	83 ec 0c             	sub    $0xc,%esp
  800547:	68 4c 3d 80 00       	push   $0x803d4c
  80054c:	e8 32 04 00 00       	call   800983 <cprintf>
  800551:	83 c4 10             	add    $0x10,%esp

	int32 parentenvID = sys_getparentenvid();
  800554:	e8 cb 18 00 00       	call   801e24 <sys_getparentenvid>
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
  80056c:	68 98 3d 80 00       	push   $0x803d98
  800571:	ff 75 bc             	pushl  -0x44(%ebp)
  800574:	e8 0e 14 00 00       	call   801987 <sget>
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
  800599:	e8 6d 18 00 00       	call   801e0b <sys_getenvindex>
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
  800604:	e8 0f 16 00 00       	call   801c18 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800609:	83 ec 0c             	sub    $0xc,%esp
  80060c:	68 c0 3d 80 00       	push   $0x803dc0
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
  800634:	68 e8 3d 80 00       	push   $0x803de8
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
  800665:	68 10 3e 80 00       	push   $0x803e10
  80066a:	e8 14 03 00 00       	call   800983 <cprintf>
  80066f:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800672:	a1 20 50 80 00       	mov    0x805020,%eax
  800677:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80067d:	83 ec 08             	sub    $0x8,%esp
  800680:	50                   	push   %eax
  800681:	68 68 3e 80 00       	push   $0x803e68
  800686:	e8 f8 02 00 00       	call   800983 <cprintf>
  80068b:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80068e:	83 ec 0c             	sub    $0xc,%esp
  800691:	68 c0 3d 80 00       	push   $0x803dc0
  800696:	e8 e8 02 00 00       	call   800983 <cprintf>
  80069b:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80069e:	e8 8f 15 00 00       	call   801c32 <sys_enable_interrupt>

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
  8006b6:	e8 1c 17 00 00       	call   801dd7 <sys_destroy_env>
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
  8006c7:	e8 71 17 00 00       	call   801e3d <sys_exit_env>
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
  8006f0:	68 7c 3e 80 00       	push   $0x803e7c
  8006f5:	e8 89 02 00 00       	call   800983 <cprintf>
  8006fa:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8006fd:	a1 00 50 80 00       	mov    0x805000,%eax
  800702:	ff 75 0c             	pushl  0xc(%ebp)
  800705:	ff 75 08             	pushl  0x8(%ebp)
  800708:	50                   	push   %eax
  800709:	68 81 3e 80 00       	push   $0x803e81
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
  80072d:	68 9d 3e 80 00       	push   $0x803e9d
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
  800759:	68 a0 3e 80 00       	push   $0x803ea0
  80075e:	6a 26                	push   $0x26
  800760:	68 ec 3e 80 00       	push   $0x803eec
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
  80082b:	68 f8 3e 80 00       	push   $0x803ef8
  800830:	6a 3a                	push   $0x3a
  800832:	68 ec 3e 80 00       	push   $0x803eec
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
  80089b:	68 4c 3f 80 00       	push   $0x803f4c
  8008a0:	6a 44                	push   $0x44
  8008a2:	68 ec 3e 80 00       	push   $0x803eec
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
  8008f5:	e8 70 11 00 00       	call   801a6a <sys_cputs>
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
  80096c:	e8 f9 10 00 00       	call   801a6a <sys_cputs>
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
  8009b6:	e8 5d 12 00 00       	call   801c18 <sys_disable_interrupt>
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
  8009d6:	e8 57 12 00 00       	call   801c32 <sys_enable_interrupt>
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
  800a20:	e8 cb 2c 00 00       	call   8036f0 <__udivdi3>
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
  800a70:	e8 8b 2d 00 00       	call   803800 <__umoddi3>
  800a75:	83 c4 10             	add    $0x10,%esp
  800a78:	05 b4 41 80 00       	add    $0x8041b4,%eax
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
  800bcb:	8b 04 85 d8 41 80 00 	mov    0x8041d8(,%eax,4),%eax
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
  800cac:	8b 34 9d 20 40 80 00 	mov    0x804020(,%ebx,4),%esi
  800cb3:	85 f6                	test   %esi,%esi
  800cb5:	75 19                	jne    800cd0 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800cb7:	53                   	push   %ebx
  800cb8:	68 c5 41 80 00       	push   $0x8041c5
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
  800cd1:	68 ce 41 80 00       	push   $0x8041ce
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
  800cfe:	be d1 41 80 00       	mov    $0x8041d1,%esi
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
  801724:	68 30 43 80 00       	push   $0x804330
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
  8017f4:	e8 b5 03 00 00       	call   801bae <sys_allocate_chunk>
  8017f9:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8017fc:	a1 20 51 80 00       	mov    0x805120,%eax
  801801:	83 ec 0c             	sub    $0xc,%esp
  801804:	50                   	push   %eax
  801805:	e8 2a 0a 00 00       	call   802234 <initialize_MemBlocksList>
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
  801832:	68 55 43 80 00       	push   $0x804355
  801837:	6a 33                	push   $0x33
  801839:	68 73 43 80 00       	push   $0x804373
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
  8018b1:	68 80 43 80 00       	push   $0x804380
  8018b6:	6a 34                	push   $0x34
  8018b8:	68 73 43 80 00       	push   $0x804373
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
  801926:	68 a4 43 80 00       	push   $0x8043a4
  80192b:	6a 46                	push   $0x46
  80192d:	68 73 43 80 00       	push   $0x804373
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
  801942:	68 cc 43 80 00       	push   $0x8043cc
  801947:	6a 61                	push   $0x61
  801949:	68 73 43 80 00       	push   $0x804373
  80194e:	e8 7c ed ff ff       	call   8006cf <_panic>

00801953 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801953:	55                   	push   %ebp
  801954:	89 e5                	mov    %esp,%ebp
  801956:	83 ec 18             	sub    $0x18,%esp
  801959:	8b 45 10             	mov    0x10(%ebp),%eax
  80195c:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80195f:	e8 a9 fd ff ff       	call   80170d <InitializeUHeap>
	if (size == 0) return NULL ;
  801964:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801968:	75 07                	jne    801971 <smalloc+0x1e>
  80196a:	b8 00 00 00 00       	mov    $0x0,%eax
  80196f:	eb 14                	jmp    801985 <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  801971:	83 ec 04             	sub    $0x4,%esp
  801974:	68 f0 43 80 00       	push   $0x8043f0
  801979:	6a 76                	push   $0x76
  80197b:	68 73 43 80 00       	push   $0x804373
  801980:	e8 4a ed ff ff       	call   8006cf <_panic>

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801985:	c9                   	leave  
  801986:	c3                   	ret    

00801987 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801987:	55                   	push   %ebp
  801988:	89 e5                	mov    %esp,%ebp
  80198a:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80198d:	e8 7b fd ff ff       	call   80170d <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801992:	83 ec 04             	sub    $0x4,%esp
  801995:	68 18 44 80 00       	push   $0x804418
  80199a:	68 93 00 00 00       	push   $0x93
  80199f:	68 73 43 80 00       	push   $0x804373
  8019a4:	e8 26 ed ff ff       	call   8006cf <_panic>

008019a9 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8019a9:	55                   	push   %ebp
  8019aa:	89 e5                	mov    %esp,%ebp
  8019ac:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8019af:	e8 59 fd ff ff       	call   80170d <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8019b4:	83 ec 04             	sub    $0x4,%esp
  8019b7:	68 3c 44 80 00       	push   $0x80443c
  8019bc:	68 c5 00 00 00       	push   $0xc5
  8019c1:	68 73 43 80 00       	push   $0x804373
  8019c6:	e8 04 ed ff ff       	call   8006cf <_panic>

008019cb <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8019cb:	55                   	push   %ebp
  8019cc:	89 e5                	mov    %esp,%ebp
  8019ce:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8019d1:	83 ec 04             	sub    $0x4,%esp
  8019d4:	68 64 44 80 00       	push   $0x804464
  8019d9:	68 d9 00 00 00       	push   $0xd9
  8019de:	68 73 43 80 00       	push   $0x804373
  8019e3:	e8 e7 ec ff ff       	call   8006cf <_panic>

008019e8 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8019e8:	55                   	push   %ebp
  8019e9:	89 e5                	mov    %esp,%ebp
  8019eb:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8019ee:	83 ec 04             	sub    $0x4,%esp
  8019f1:	68 88 44 80 00       	push   $0x804488
  8019f6:	68 e4 00 00 00       	push   $0xe4
  8019fb:	68 73 43 80 00       	push   $0x804373
  801a00:	e8 ca ec ff ff       	call   8006cf <_panic>

00801a05 <shrink>:

}
void shrink(uint32 newSize)
{
  801a05:	55                   	push   %ebp
  801a06:	89 e5                	mov    %esp,%ebp
  801a08:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a0b:	83 ec 04             	sub    $0x4,%esp
  801a0e:	68 88 44 80 00       	push   $0x804488
  801a13:	68 e9 00 00 00       	push   $0xe9
  801a18:	68 73 43 80 00       	push   $0x804373
  801a1d:	e8 ad ec ff ff       	call   8006cf <_panic>

00801a22 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801a22:	55                   	push   %ebp
  801a23:	89 e5                	mov    %esp,%ebp
  801a25:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a28:	83 ec 04             	sub    $0x4,%esp
  801a2b:	68 88 44 80 00       	push   $0x804488
  801a30:	68 ee 00 00 00       	push   $0xee
  801a35:	68 73 43 80 00       	push   $0x804373
  801a3a:	e8 90 ec ff ff       	call   8006cf <_panic>

00801a3f <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801a3f:	55                   	push   %ebp
  801a40:	89 e5                	mov    %esp,%ebp
  801a42:	57                   	push   %edi
  801a43:	56                   	push   %esi
  801a44:	53                   	push   %ebx
  801a45:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801a48:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a4e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a51:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a54:	8b 7d 18             	mov    0x18(%ebp),%edi
  801a57:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801a5a:	cd 30                	int    $0x30
  801a5c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801a5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801a62:	83 c4 10             	add    $0x10,%esp
  801a65:	5b                   	pop    %ebx
  801a66:	5e                   	pop    %esi
  801a67:	5f                   	pop    %edi
  801a68:	5d                   	pop    %ebp
  801a69:	c3                   	ret    

00801a6a <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801a6a:	55                   	push   %ebp
  801a6b:	89 e5                	mov    %esp,%ebp
  801a6d:	83 ec 04             	sub    $0x4,%esp
  801a70:	8b 45 10             	mov    0x10(%ebp),%eax
  801a73:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801a76:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a7a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7d:	6a 00                	push   $0x0
  801a7f:	6a 00                	push   $0x0
  801a81:	52                   	push   %edx
  801a82:	ff 75 0c             	pushl  0xc(%ebp)
  801a85:	50                   	push   %eax
  801a86:	6a 00                	push   $0x0
  801a88:	e8 b2 ff ff ff       	call   801a3f <syscall>
  801a8d:	83 c4 18             	add    $0x18,%esp
}
  801a90:	90                   	nop
  801a91:	c9                   	leave  
  801a92:	c3                   	ret    

00801a93 <sys_cgetc>:

int
sys_cgetc(void)
{
  801a93:	55                   	push   %ebp
  801a94:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801a96:	6a 00                	push   $0x0
  801a98:	6a 00                	push   $0x0
  801a9a:	6a 00                	push   $0x0
  801a9c:	6a 00                	push   $0x0
  801a9e:	6a 00                	push   $0x0
  801aa0:	6a 01                	push   $0x1
  801aa2:	e8 98 ff ff ff       	call   801a3f <syscall>
  801aa7:	83 c4 18             	add    $0x18,%esp
}
  801aaa:	c9                   	leave  
  801aab:	c3                   	ret    

00801aac <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801aac:	55                   	push   %ebp
  801aad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801aaf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ab2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab5:	6a 00                	push   $0x0
  801ab7:	6a 00                	push   $0x0
  801ab9:	6a 00                	push   $0x0
  801abb:	52                   	push   %edx
  801abc:	50                   	push   %eax
  801abd:	6a 05                	push   $0x5
  801abf:	e8 7b ff ff ff       	call   801a3f <syscall>
  801ac4:	83 c4 18             	add    $0x18,%esp
}
  801ac7:	c9                   	leave  
  801ac8:	c3                   	ret    

00801ac9 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801ac9:	55                   	push   %ebp
  801aca:	89 e5                	mov    %esp,%ebp
  801acc:	56                   	push   %esi
  801acd:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801ace:	8b 75 18             	mov    0x18(%ebp),%esi
  801ad1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ad4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ad7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ada:	8b 45 08             	mov    0x8(%ebp),%eax
  801add:	56                   	push   %esi
  801ade:	53                   	push   %ebx
  801adf:	51                   	push   %ecx
  801ae0:	52                   	push   %edx
  801ae1:	50                   	push   %eax
  801ae2:	6a 06                	push   $0x6
  801ae4:	e8 56 ff ff ff       	call   801a3f <syscall>
  801ae9:	83 c4 18             	add    $0x18,%esp
}
  801aec:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801aef:	5b                   	pop    %ebx
  801af0:	5e                   	pop    %esi
  801af1:	5d                   	pop    %ebp
  801af2:	c3                   	ret    

00801af3 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801af3:	55                   	push   %ebp
  801af4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801af6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801af9:	8b 45 08             	mov    0x8(%ebp),%eax
  801afc:	6a 00                	push   $0x0
  801afe:	6a 00                	push   $0x0
  801b00:	6a 00                	push   $0x0
  801b02:	52                   	push   %edx
  801b03:	50                   	push   %eax
  801b04:	6a 07                	push   $0x7
  801b06:	e8 34 ff ff ff       	call   801a3f <syscall>
  801b0b:	83 c4 18             	add    $0x18,%esp
}
  801b0e:	c9                   	leave  
  801b0f:	c3                   	ret    

00801b10 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801b10:	55                   	push   %ebp
  801b11:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801b13:	6a 00                	push   $0x0
  801b15:	6a 00                	push   $0x0
  801b17:	6a 00                	push   $0x0
  801b19:	ff 75 0c             	pushl  0xc(%ebp)
  801b1c:	ff 75 08             	pushl  0x8(%ebp)
  801b1f:	6a 08                	push   $0x8
  801b21:	e8 19 ff ff ff       	call   801a3f <syscall>
  801b26:	83 c4 18             	add    $0x18,%esp
}
  801b29:	c9                   	leave  
  801b2a:	c3                   	ret    

00801b2b <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801b2b:	55                   	push   %ebp
  801b2c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801b2e:	6a 00                	push   $0x0
  801b30:	6a 00                	push   $0x0
  801b32:	6a 00                	push   $0x0
  801b34:	6a 00                	push   $0x0
  801b36:	6a 00                	push   $0x0
  801b38:	6a 09                	push   $0x9
  801b3a:	e8 00 ff ff ff       	call   801a3f <syscall>
  801b3f:	83 c4 18             	add    $0x18,%esp
}
  801b42:	c9                   	leave  
  801b43:	c3                   	ret    

00801b44 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801b44:	55                   	push   %ebp
  801b45:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801b47:	6a 00                	push   $0x0
  801b49:	6a 00                	push   $0x0
  801b4b:	6a 00                	push   $0x0
  801b4d:	6a 00                	push   $0x0
  801b4f:	6a 00                	push   $0x0
  801b51:	6a 0a                	push   $0xa
  801b53:	e8 e7 fe ff ff       	call   801a3f <syscall>
  801b58:	83 c4 18             	add    $0x18,%esp
}
  801b5b:	c9                   	leave  
  801b5c:	c3                   	ret    

00801b5d <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801b5d:	55                   	push   %ebp
  801b5e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801b60:	6a 00                	push   $0x0
  801b62:	6a 00                	push   $0x0
  801b64:	6a 00                	push   $0x0
  801b66:	6a 00                	push   $0x0
  801b68:	6a 00                	push   $0x0
  801b6a:	6a 0b                	push   $0xb
  801b6c:	e8 ce fe ff ff       	call   801a3f <syscall>
  801b71:	83 c4 18             	add    $0x18,%esp
}
  801b74:	c9                   	leave  
  801b75:	c3                   	ret    

00801b76 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801b76:	55                   	push   %ebp
  801b77:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801b79:	6a 00                	push   $0x0
  801b7b:	6a 00                	push   $0x0
  801b7d:	6a 00                	push   $0x0
  801b7f:	ff 75 0c             	pushl  0xc(%ebp)
  801b82:	ff 75 08             	pushl  0x8(%ebp)
  801b85:	6a 0f                	push   $0xf
  801b87:	e8 b3 fe ff ff       	call   801a3f <syscall>
  801b8c:	83 c4 18             	add    $0x18,%esp
	return;
  801b8f:	90                   	nop
}
  801b90:	c9                   	leave  
  801b91:	c3                   	ret    

00801b92 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801b92:	55                   	push   %ebp
  801b93:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801b95:	6a 00                	push   $0x0
  801b97:	6a 00                	push   $0x0
  801b99:	6a 00                	push   $0x0
  801b9b:	ff 75 0c             	pushl  0xc(%ebp)
  801b9e:	ff 75 08             	pushl  0x8(%ebp)
  801ba1:	6a 10                	push   $0x10
  801ba3:	e8 97 fe ff ff       	call   801a3f <syscall>
  801ba8:	83 c4 18             	add    $0x18,%esp
	return ;
  801bab:	90                   	nop
}
  801bac:	c9                   	leave  
  801bad:	c3                   	ret    

00801bae <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801bae:	55                   	push   %ebp
  801baf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801bb1:	6a 00                	push   $0x0
  801bb3:	6a 00                	push   $0x0
  801bb5:	ff 75 10             	pushl  0x10(%ebp)
  801bb8:	ff 75 0c             	pushl  0xc(%ebp)
  801bbb:	ff 75 08             	pushl  0x8(%ebp)
  801bbe:	6a 11                	push   $0x11
  801bc0:	e8 7a fe ff ff       	call   801a3f <syscall>
  801bc5:	83 c4 18             	add    $0x18,%esp
	return ;
  801bc8:	90                   	nop
}
  801bc9:	c9                   	leave  
  801bca:	c3                   	ret    

00801bcb <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801bcb:	55                   	push   %ebp
  801bcc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801bce:	6a 00                	push   $0x0
  801bd0:	6a 00                	push   $0x0
  801bd2:	6a 00                	push   $0x0
  801bd4:	6a 00                	push   $0x0
  801bd6:	6a 00                	push   $0x0
  801bd8:	6a 0c                	push   $0xc
  801bda:	e8 60 fe ff ff       	call   801a3f <syscall>
  801bdf:	83 c4 18             	add    $0x18,%esp
}
  801be2:	c9                   	leave  
  801be3:	c3                   	ret    

00801be4 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801be4:	55                   	push   %ebp
  801be5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801be7:	6a 00                	push   $0x0
  801be9:	6a 00                	push   $0x0
  801beb:	6a 00                	push   $0x0
  801bed:	6a 00                	push   $0x0
  801bef:	ff 75 08             	pushl  0x8(%ebp)
  801bf2:	6a 0d                	push   $0xd
  801bf4:	e8 46 fe ff ff       	call   801a3f <syscall>
  801bf9:	83 c4 18             	add    $0x18,%esp
}
  801bfc:	c9                   	leave  
  801bfd:	c3                   	ret    

00801bfe <sys_scarce_memory>:

void sys_scarce_memory()
{
  801bfe:	55                   	push   %ebp
  801bff:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801c01:	6a 00                	push   $0x0
  801c03:	6a 00                	push   $0x0
  801c05:	6a 00                	push   $0x0
  801c07:	6a 00                	push   $0x0
  801c09:	6a 00                	push   $0x0
  801c0b:	6a 0e                	push   $0xe
  801c0d:	e8 2d fe ff ff       	call   801a3f <syscall>
  801c12:	83 c4 18             	add    $0x18,%esp
}
  801c15:	90                   	nop
  801c16:	c9                   	leave  
  801c17:	c3                   	ret    

00801c18 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801c18:	55                   	push   %ebp
  801c19:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801c1b:	6a 00                	push   $0x0
  801c1d:	6a 00                	push   $0x0
  801c1f:	6a 00                	push   $0x0
  801c21:	6a 00                	push   $0x0
  801c23:	6a 00                	push   $0x0
  801c25:	6a 13                	push   $0x13
  801c27:	e8 13 fe ff ff       	call   801a3f <syscall>
  801c2c:	83 c4 18             	add    $0x18,%esp
}
  801c2f:	90                   	nop
  801c30:	c9                   	leave  
  801c31:	c3                   	ret    

00801c32 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801c32:	55                   	push   %ebp
  801c33:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801c35:	6a 00                	push   $0x0
  801c37:	6a 00                	push   $0x0
  801c39:	6a 00                	push   $0x0
  801c3b:	6a 00                	push   $0x0
  801c3d:	6a 00                	push   $0x0
  801c3f:	6a 14                	push   $0x14
  801c41:	e8 f9 fd ff ff       	call   801a3f <syscall>
  801c46:	83 c4 18             	add    $0x18,%esp
}
  801c49:	90                   	nop
  801c4a:	c9                   	leave  
  801c4b:	c3                   	ret    

00801c4c <sys_cputc>:


void
sys_cputc(const char c)
{
  801c4c:	55                   	push   %ebp
  801c4d:	89 e5                	mov    %esp,%ebp
  801c4f:	83 ec 04             	sub    $0x4,%esp
  801c52:	8b 45 08             	mov    0x8(%ebp),%eax
  801c55:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801c58:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c5c:	6a 00                	push   $0x0
  801c5e:	6a 00                	push   $0x0
  801c60:	6a 00                	push   $0x0
  801c62:	6a 00                	push   $0x0
  801c64:	50                   	push   %eax
  801c65:	6a 15                	push   $0x15
  801c67:	e8 d3 fd ff ff       	call   801a3f <syscall>
  801c6c:	83 c4 18             	add    $0x18,%esp
}
  801c6f:	90                   	nop
  801c70:	c9                   	leave  
  801c71:	c3                   	ret    

00801c72 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801c72:	55                   	push   %ebp
  801c73:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801c75:	6a 00                	push   $0x0
  801c77:	6a 00                	push   $0x0
  801c79:	6a 00                	push   $0x0
  801c7b:	6a 00                	push   $0x0
  801c7d:	6a 00                	push   $0x0
  801c7f:	6a 16                	push   $0x16
  801c81:	e8 b9 fd ff ff       	call   801a3f <syscall>
  801c86:	83 c4 18             	add    $0x18,%esp
}
  801c89:	90                   	nop
  801c8a:	c9                   	leave  
  801c8b:	c3                   	ret    

00801c8c <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801c8c:	55                   	push   %ebp
  801c8d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801c8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c92:	6a 00                	push   $0x0
  801c94:	6a 00                	push   $0x0
  801c96:	6a 00                	push   $0x0
  801c98:	ff 75 0c             	pushl  0xc(%ebp)
  801c9b:	50                   	push   %eax
  801c9c:	6a 17                	push   $0x17
  801c9e:	e8 9c fd ff ff       	call   801a3f <syscall>
  801ca3:	83 c4 18             	add    $0x18,%esp
}
  801ca6:	c9                   	leave  
  801ca7:	c3                   	ret    

00801ca8 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801ca8:	55                   	push   %ebp
  801ca9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801cab:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cae:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb1:	6a 00                	push   $0x0
  801cb3:	6a 00                	push   $0x0
  801cb5:	6a 00                	push   $0x0
  801cb7:	52                   	push   %edx
  801cb8:	50                   	push   %eax
  801cb9:	6a 1a                	push   $0x1a
  801cbb:	e8 7f fd ff ff       	call   801a3f <syscall>
  801cc0:	83 c4 18             	add    $0x18,%esp
}
  801cc3:	c9                   	leave  
  801cc4:	c3                   	ret    

00801cc5 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801cc5:	55                   	push   %ebp
  801cc6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801cc8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ccb:	8b 45 08             	mov    0x8(%ebp),%eax
  801cce:	6a 00                	push   $0x0
  801cd0:	6a 00                	push   $0x0
  801cd2:	6a 00                	push   $0x0
  801cd4:	52                   	push   %edx
  801cd5:	50                   	push   %eax
  801cd6:	6a 18                	push   $0x18
  801cd8:	e8 62 fd ff ff       	call   801a3f <syscall>
  801cdd:	83 c4 18             	add    $0x18,%esp
}
  801ce0:	90                   	nop
  801ce1:	c9                   	leave  
  801ce2:	c3                   	ret    

00801ce3 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801ce3:	55                   	push   %ebp
  801ce4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ce6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ce9:	8b 45 08             	mov    0x8(%ebp),%eax
  801cec:	6a 00                	push   $0x0
  801cee:	6a 00                	push   $0x0
  801cf0:	6a 00                	push   $0x0
  801cf2:	52                   	push   %edx
  801cf3:	50                   	push   %eax
  801cf4:	6a 19                	push   $0x19
  801cf6:	e8 44 fd ff ff       	call   801a3f <syscall>
  801cfb:	83 c4 18             	add    $0x18,%esp
}
  801cfe:	90                   	nop
  801cff:	c9                   	leave  
  801d00:	c3                   	ret    

00801d01 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801d01:	55                   	push   %ebp
  801d02:	89 e5                	mov    %esp,%ebp
  801d04:	83 ec 04             	sub    $0x4,%esp
  801d07:	8b 45 10             	mov    0x10(%ebp),%eax
  801d0a:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801d0d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801d10:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801d14:	8b 45 08             	mov    0x8(%ebp),%eax
  801d17:	6a 00                	push   $0x0
  801d19:	51                   	push   %ecx
  801d1a:	52                   	push   %edx
  801d1b:	ff 75 0c             	pushl  0xc(%ebp)
  801d1e:	50                   	push   %eax
  801d1f:	6a 1b                	push   $0x1b
  801d21:	e8 19 fd ff ff       	call   801a3f <syscall>
  801d26:	83 c4 18             	add    $0x18,%esp
}
  801d29:	c9                   	leave  
  801d2a:	c3                   	ret    

00801d2b <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801d2b:	55                   	push   %ebp
  801d2c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801d2e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d31:	8b 45 08             	mov    0x8(%ebp),%eax
  801d34:	6a 00                	push   $0x0
  801d36:	6a 00                	push   $0x0
  801d38:	6a 00                	push   $0x0
  801d3a:	52                   	push   %edx
  801d3b:	50                   	push   %eax
  801d3c:	6a 1c                	push   $0x1c
  801d3e:	e8 fc fc ff ff       	call   801a3f <syscall>
  801d43:	83 c4 18             	add    $0x18,%esp
}
  801d46:	c9                   	leave  
  801d47:	c3                   	ret    

00801d48 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801d48:	55                   	push   %ebp
  801d49:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801d4b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d4e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d51:	8b 45 08             	mov    0x8(%ebp),%eax
  801d54:	6a 00                	push   $0x0
  801d56:	6a 00                	push   $0x0
  801d58:	51                   	push   %ecx
  801d59:	52                   	push   %edx
  801d5a:	50                   	push   %eax
  801d5b:	6a 1d                	push   $0x1d
  801d5d:	e8 dd fc ff ff       	call   801a3f <syscall>
  801d62:	83 c4 18             	add    $0x18,%esp
}
  801d65:	c9                   	leave  
  801d66:	c3                   	ret    

00801d67 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801d67:	55                   	push   %ebp
  801d68:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801d6a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d70:	6a 00                	push   $0x0
  801d72:	6a 00                	push   $0x0
  801d74:	6a 00                	push   $0x0
  801d76:	52                   	push   %edx
  801d77:	50                   	push   %eax
  801d78:	6a 1e                	push   $0x1e
  801d7a:	e8 c0 fc ff ff       	call   801a3f <syscall>
  801d7f:	83 c4 18             	add    $0x18,%esp
}
  801d82:	c9                   	leave  
  801d83:	c3                   	ret    

00801d84 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801d84:	55                   	push   %ebp
  801d85:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801d87:	6a 00                	push   $0x0
  801d89:	6a 00                	push   $0x0
  801d8b:	6a 00                	push   $0x0
  801d8d:	6a 00                	push   $0x0
  801d8f:	6a 00                	push   $0x0
  801d91:	6a 1f                	push   $0x1f
  801d93:	e8 a7 fc ff ff       	call   801a3f <syscall>
  801d98:	83 c4 18             	add    $0x18,%esp
}
  801d9b:	c9                   	leave  
  801d9c:	c3                   	ret    

00801d9d <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801d9d:	55                   	push   %ebp
  801d9e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801da0:	8b 45 08             	mov    0x8(%ebp),%eax
  801da3:	6a 00                	push   $0x0
  801da5:	ff 75 14             	pushl  0x14(%ebp)
  801da8:	ff 75 10             	pushl  0x10(%ebp)
  801dab:	ff 75 0c             	pushl  0xc(%ebp)
  801dae:	50                   	push   %eax
  801daf:	6a 20                	push   $0x20
  801db1:	e8 89 fc ff ff       	call   801a3f <syscall>
  801db6:	83 c4 18             	add    $0x18,%esp
}
  801db9:	c9                   	leave  
  801dba:	c3                   	ret    

00801dbb <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801dbb:	55                   	push   %ebp
  801dbc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801dbe:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc1:	6a 00                	push   $0x0
  801dc3:	6a 00                	push   $0x0
  801dc5:	6a 00                	push   $0x0
  801dc7:	6a 00                	push   $0x0
  801dc9:	50                   	push   %eax
  801dca:	6a 21                	push   $0x21
  801dcc:	e8 6e fc ff ff       	call   801a3f <syscall>
  801dd1:	83 c4 18             	add    $0x18,%esp
}
  801dd4:	90                   	nop
  801dd5:	c9                   	leave  
  801dd6:	c3                   	ret    

00801dd7 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801dd7:	55                   	push   %ebp
  801dd8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801dda:	8b 45 08             	mov    0x8(%ebp),%eax
  801ddd:	6a 00                	push   $0x0
  801ddf:	6a 00                	push   $0x0
  801de1:	6a 00                	push   $0x0
  801de3:	6a 00                	push   $0x0
  801de5:	50                   	push   %eax
  801de6:	6a 22                	push   $0x22
  801de8:	e8 52 fc ff ff       	call   801a3f <syscall>
  801ded:	83 c4 18             	add    $0x18,%esp
}
  801df0:	c9                   	leave  
  801df1:	c3                   	ret    

00801df2 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801df2:	55                   	push   %ebp
  801df3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801df5:	6a 00                	push   $0x0
  801df7:	6a 00                	push   $0x0
  801df9:	6a 00                	push   $0x0
  801dfb:	6a 00                	push   $0x0
  801dfd:	6a 00                	push   $0x0
  801dff:	6a 02                	push   $0x2
  801e01:	e8 39 fc ff ff       	call   801a3f <syscall>
  801e06:	83 c4 18             	add    $0x18,%esp
}
  801e09:	c9                   	leave  
  801e0a:	c3                   	ret    

00801e0b <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801e0b:	55                   	push   %ebp
  801e0c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801e0e:	6a 00                	push   $0x0
  801e10:	6a 00                	push   $0x0
  801e12:	6a 00                	push   $0x0
  801e14:	6a 00                	push   $0x0
  801e16:	6a 00                	push   $0x0
  801e18:	6a 03                	push   $0x3
  801e1a:	e8 20 fc ff ff       	call   801a3f <syscall>
  801e1f:	83 c4 18             	add    $0x18,%esp
}
  801e22:	c9                   	leave  
  801e23:	c3                   	ret    

00801e24 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801e24:	55                   	push   %ebp
  801e25:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801e27:	6a 00                	push   $0x0
  801e29:	6a 00                	push   $0x0
  801e2b:	6a 00                	push   $0x0
  801e2d:	6a 00                	push   $0x0
  801e2f:	6a 00                	push   $0x0
  801e31:	6a 04                	push   $0x4
  801e33:	e8 07 fc ff ff       	call   801a3f <syscall>
  801e38:	83 c4 18             	add    $0x18,%esp
}
  801e3b:	c9                   	leave  
  801e3c:	c3                   	ret    

00801e3d <sys_exit_env>:


void sys_exit_env(void)
{
  801e3d:	55                   	push   %ebp
  801e3e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801e40:	6a 00                	push   $0x0
  801e42:	6a 00                	push   $0x0
  801e44:	6a 00                	push   $0x0
  801e46:	6a 00                	push   $0x0
  801e48:	6a 00                	push   $0x0
  801e4a:	6a 23                	push   $0x23
  801e4c:	e8 ee fb ff ff       	call   801a3f <syscall>
  801e51:	83 c4 18             	add    $0x18,%esp
}
  801e54:	90                   	nop
  801e55:	c9                   	leave  
  801e56:	c3                   	ret    

00801e57 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801e57:	55                   	push   %ebp
  801e58:	89 e5                	mov    %esp,%ebp
  801e5a:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801e5d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e60:	8d 50 04             	lea    0x4(%eax),%edx
  801e63:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e66:	6a 00                	push   $0x0
  801e68:	6a 00                	push   $0x0
  801e6a:	6a 00                	push   $0x0
  801e6c:	52                   	push   %edx
  801e6d:	50                   	push   %eax
  801e6e:	6a 24                	push   $0x24
  801e70:	e8 ca fb ff ff       	call   801a3f <syscall>
  801e75:	83 c4 18             	add    $0x18,%esp
	return result;
  801e78:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e7b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e7e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e81:	89 01                	mov    %eax,(%ecx)
  801e83:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801e86:	8b 45 08             	mov    0x8(%ebp),%eax
  801e89:	c9                   	leave  
  801e8a:	c2 04 00             	ret    $0x4

00801e8d <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801e8d:	55                   	push   %ebp
  801e8e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801e90:	6a 00                	push   $0x0
  801e92:	6a 00                	push   $0x0
  801e94:	ff 75 10             	pushl  0x10(%ebp)
  801e97:	ff 75 0c             	pushl  0xc(%ebp)
  801e9a:	ff 75 08             	pushl  0x8(%ebp)
  801e9d:	6a 12                	push   $0x12
  801e9f:	e8 9b fb ff ff       	call   801a3f <syscall>
  801ea4:	83 c4 18             	add    $0x18,%esp
	return ;
  801ea7:	90                   	nop
}
  801ea8:	c9                   	leave  
  801ea9:	c3                   	ret    

00801eaa <sys_rcr2>:
uint32 sys_rcr2()
{
  801eaa:	55                   	push   %ebp
  801eab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801ead:	6a 00                	push   $0x0
  801eaf:	6a 00                	push   $0x0
  801eb1:	6a 00                	push   $0x0
  801eb3:	6a 00                	push   $0x0
  801eb5:	6a 00                	push   $0x0
  801eb7:	6a 25                	push   $0x25
  801eb9:	e8 81 fb ff ff       	call   801a3f <syscall>
  801ebe:	83 c4 18             	add    $0x18,%esp
}
  801ec1:	c9                   	leave  
  801ec2:	c3                   	ret    

00801ec3 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801ec3:	55                   	push   %ebp
  801ec4:	89 e5                	mov    %esp,%ebp
  801ec6:	83 ec 04             	sub    $0x4,%esp
  801ec9:	8b 45 08             	mov    0x8(%ebp),%eax
  801ecc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801ecf:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801ed3:	6a 00                	push   $0x0
  801ed5:	6a 00                	push   $0x0
  801ed7:	6a 00                	push   $0x0
  801ed9:	6a 00                	push   $0x0
  801edb:	50                   	push   %eax
  801edc:	6a 26                	push   $0x26
  801ede:	e8 5c fb ff ff       	call   801a3f <syscall>
  801ee3:	83 c4 18             	add    $0x18,%esp
	return ;
  801ee6:	90                   	nop
}
  801ee7:	c9                   	leave  
  801ee8:	c3                   	ret    

00801ee9 <rsttst>:
void rsttst()
{
  801ee9:	55                   	push   %ebp
  801eea:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801eec:	6a 00                	push   $0x0
  801eee:	6a 00                	push   $0x0
  801ef0:	6a 00                	push   $0x0
  801ef2:	6a 00                	push   $0x0
  801ef4:	6a 00                	push   $0x0
  801ef6:	6a 28                	push   $0x28
  801ef8:	e8 42 fb ff ff       	call   801a3f <syscall>
  801efd:	83 c4 18             	add    $0x18,%esp
	return ;
  801f00:	90                   	nop
}
  801f01:	c9                   	leave  
  801f02:	c3                   	ret    

00801f03 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801f03:	55                   	push   %ebp
  801f04:	89 e5                	mov    %esp,%ebp
  801f06:	83 ec 04             	sub    $0x4,%esp
  801f09:	8b 45 14             	mov    0x14(%ebp),%eax
  801f0c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801f0f:	8b 55 18             	mov    0x18(%ebp),%edx
  801f12:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801f16:	52                   	push   %edx
  801f17:	50                   	push   %eax
  801f18:	ff 75 10             	pushl  0x10(%ebp)
  801f1b:	ff 75 0c             	pushl  0xc(%ebp)
  801f1e:	ff 75 08             	pushl  0x8(%ebp)
  801f21:	6a 27                	push   $0x27
  801f23:	e8 17 fb ff ff       	call   801a3f <syscall>
  801f28:	83 c4 18             	add    $0x18,%esp
	return ;
  801f2b:	90                   	nop
}
  801f2c:	c9                   	leave  
  801f2d:	c3                   	ret    

00801f2e <chktst>:
void chktst(uint32 n)
{
  801f2e:	55                   	push   %ebp
  801f2f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801f31:	6a 00                	push   $0x0
  801f33:	6a 00                	push   $0x0
  801f35:	6a 00                	push   $0x0
  801f37:	6a 00                	push   $0x0
  801f39:	ff 75 08             	pushl  0x8(%ebp)
  801f3c:	6a 29                	push   $0x29
  801f3e:	e8 fc fa ff ff       	call   801a3f <syscall>
  801f43:	83 c4 18             	add    $0x18,%esp
	return ;
  801f46:	90                   	nop
}
  801f47:	c9                   	leave  
  801f48:	c3                   	ret    

00801f49 <inctst>:

void inctst()
{
  801f49:	55                   	push   %ebp
  801f4a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801f4c:	6a 00                	push   $0x0
  801f4e:	6a 00                	push   $0x0
  801f50:	6a 00                	push   $0x0
  801f52:	6a 00                	push   $0x0
  801f54:	6a 00                	push   $0x0
  801f56:	6a 2a                	push   $0x2a
  801f58:	e8 e2 fa ff ff       	call   801a3f <syscall>
  801f5d:	83 c4 18             	add    $0x18,%esp
	return ;
  801f60:	90                   	nop
}
  801f61:	c9                   	leave  
  801f62:	c3                   	ret    

00801f63 <gettst>:
uint32 gettst()
{
  801f63:	55                   	push   %ebp
  801f64:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801f66:	6a 00                	push   $0x0
  801f68:	6a 00                	push   $0x0
  801f6a:	6a 00                	push   $0x0
  801f6c:	6a 00                	push   $0x0
  801f6e:	6a 00                	push   $0x0
  801f70:	6a 2b                	push   $0x2b
  801f72:	e8 c8 fa ff ff       	call   801a3f <syscall>
  801f77:	83 c4 18             	add    $0x18,%esp
}
  801f7a:	c9                   	leave  
  801f7b:	c3                   	ret    

00801f7c <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801f7c:	55                   	push   %ebp
  801f7d:	89 e5                	mov    %esp,%ebp
  801f7f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f82:	6a 00                	push   $0x0
  801f84:	6a 00                	push   $0x0
  801f86:	6a 00                	push   $0x0
  801f88:	6a 00                	push   $0x0
  801f8a:	6a 00                	push   $0x0
  801f8c:	6a 2c                	push   $0x2c
  801f8e:	e8 ac fa ff ff       	call   801a3f <syscall>
  801f93:	83 c4 18             	add    $0x18,%esp
  801f96:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801f99:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801f9d:	75 07                	jne    801fa6 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801f9f:	b8 01 00 00 00       	mov    $0x1,%eax
  801fa4:	eb 05                	jmp    801fab <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801fa6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fab:	c9                   	leave  
  801fac:	c3                   	ret    

00801fad <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801fad:	55                   	push   %ebp
  801fae:	89 e5                	mov    %esp,%ebp
  801fb0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fb3:	6a 00                	push   $0x0
  801fb5:	6a 00                	push   $0x0
  801fb7:	6a 00                	push   $0x0
  801fb9:	6a 00                	push   $0x0
  801fbb:	6a 00                	push   $0x0
  801fbd:	6a 2c                	push   $0x2c
  801fbf:	e8 7b fa ff ff       	call   801a3f <syscall>
  801fc4:	83 c4 18             	add    $0x18,%esp
  801fc7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801fca:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801fce:	75 07                	jne    801fd7 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801fd0:	b8 01 00 00 00       	mov    $0x1,%eax
  801fd5:	eb 05                	jmp    801fdc <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801fd7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fdc:	c9                   	leave  
  801fdd:	c3                   	ret    

00801fde <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801fde:	55                   	push   %ebp
  801fdf:	89 e5                	mov    %esp,%ebp
  801fe1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fe4:	6a 00                	push   $0x0
  801fe6:	6a 00                	push   $0x0
  801fe8:	6a 00                	push   $0x0
  801fea:	6a 00                	push   $0x0
  801fec:	6a 00                	push   $0x0
  801fee:	6a 2c                	push   $0x2c
  801ff0:	e8 4a fa ff ff       	call   801a3f <syscall>
  801ff5:	83 c4 18             	add    $0x18,%esp
  801ff8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801ffb:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801fff:	75 07                	jne    802008 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802001:	b8 01 00 00 00       	mov    $0x1,%eax
  802006:	eb 05                	jmp    80200d <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802008:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80200d:	c9                   	leave  
  80200e:	c3                   	ret    

0080200f <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80200f:	55                   	push   %ebp
  802010:	89 e5                	mov    %esp,%ebp
  802012:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802015:	6a 00                	push   $0x0
  802017:	6a 00                	push   $0x0
  802019:	6a 00                	push   $0x0
  80201b:	6a 00                	push   $0x0
  80201d:	6a 00                	push   $0x0
  80201f:	6a 2c                	push   $0x2c
  802021:	e8 19 fa ff ff       	call   801a3f <syscall>
  802026:	83 c4 18             	add    $0x18,%esp
  802029:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80202c:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802030:	75 07                	jne    802039 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802032:	b8 01 00 00 00       	mov    $0x1,%eax
  802037:	eb 05                	jmp    80203e <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802039:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80203e:	c9                   	leave  
  80203f:	c3                   	ret    

00802040 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802040:	55                   	push   %ebp
  802041:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802043:	6a 00                	push   $0x0
  802045:	6a 00                	push   $0x0
  802047:	6a 00                	push   $0x0
  802049:	6a 00                	push   $0x0
  80204b:	ff 75 08             	pushl  0x8(%ebp)
  80204e:	6a 2d                	push   $0x2d
  802050:	e8 ea f9 ff ff       	call   801a3f <syscall>
  802055:	83 c4 18             	add    $0x18,%esp
	return ;
  802058:	90                   	nop
}
  802059:	c9                   	leave  
  80205a:	c3                   	ret    

0080205b <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80205b:	55                   	push   %ebp
  80205c:	89 e5                	mov    %esp,%ebp
  80205e:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80205f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802062:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802065:	8b 55 0c             	mov    0xc(%ebp),%edx
  802068:	8b 45 08             	mov    0x8(%ebp),%eax
  80206b:	6a 00                	push   $0x0
  80206d:	53                   	push   %ebx
  80206e:	51                   	push   %ecx
  80206f:	52                   	push   %edx
  802070:	50                   	push   %eax
  802071:	6a 2e                	push   $0x2e
  802073:	e8 c7 f9 ff ff       	call   801a3f <syscall>
  802078:	83 c4 18             	add    $0x18,%esp
}
  80207b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80207e:	c9                   	leave  
  80207f:	c3                   	ret    

00802080 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802080:	55                   	push   %ebp
  802081:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802083:	8b 55 0c             	mov    0xc(%ebp),%edx
  802086:	8b 45 08             	mov    0x8(%ebp),%eax
  802089:	6a 00                	push   $0x0
  80208b:	6a 00                	push   $0x0
  80208d:	6a 00                	push   $0x0
  80208f:	52                   	push   %edx
  802090:	50                   	push   %eax
  802091:	6a 2f                	push   $0x2f
  802093:	e8 a7 f9 ff ff       	call   801a3f <syscall>
  802098:	83 c4 18             	add    $0x18,%esp
}
  80209b:	c9                   	leave  
  80209c:	c3                   	ret    

0080209d <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  80209d:	55                   	push   %ebp
  80209e:	89 e5                	mov    %esp,%ebp
  8020a0:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  8020a3:	83 ec 0c             	sub    $0xc,%esp
  8020a6:	68 98 44 80 00       	push   $0x804498
  8020ab:	e8 d3 e8 ff ff       	call   800983 <cprintf>
  8020b0:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  8020b3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8020ba:	83 ec 0c             	sub    $0xc,%esp
  8020bd:	68 c4 44 80 00       	push   $0x8044c4
  8020c2:	e8 bc e8 ff ff       	call   800983 <cprintf>
  8020c7:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8020ca:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8020ce:	a1 38 51 80 00       	mov    0x805138,%eax
  8020d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020d6:	eb 56                	jmp    80212e <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8020d8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8020dc:	74 1c                	je     8020fa <print_mem_block_lists+0x5d>
  8020de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e1:	8b 50 08             	mov    0x8(%eax),%edx
  8020e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020e7:	8b 48 08             	mov    0x8(%eax),%ecx
  8020ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020ed:	8b 40 0c             	mov    0xc(%eax),%eax
  8020f0:	01 c8                	add    %ecx,%eax
  8020f2:	39 c2                	cmp    %eax,%edx
  8020f4:	73 04                	jae    8020fa <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8020f6:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8020fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020fd:	8b 50 08             	mov    0x8(%eax),%edx
  802100:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802103:	8b 40 0c             	mov    0xc(%eax),%eax
  802106:	01 c2                	add    %eax,%edx
  802108:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80210b:	8b 40 08             	mov    0x8(%eax),%eax
  80210e:	83 ec 04             	sub    $0x4,%esp
  802111:	52                   	push   %edx
  802112:	50                   	push   %eax
  802113:	68 d9 44 80 00       	push   $0x8044d9
  802118:	e8 66 e8 ff ff       	call   800983 <cprintf>
  80211d:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802120:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802123:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802126:	a1 40 51 80 00       	mov    0x805140,%eax
  80212b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80212e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802132:	74 07                	je     80213b <print_mem_block_lists+0x9e>
  802134:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802137:	8b 00                	mov    (%eax),%eax
  802139:	eb 05                	jmp    802140 <print_mem_block_lists+0xa3>
  80213b:	b8 00 00 00 00       	mov    $0x0,%eax
  802140:	a3 40 51 80 00       	mov    %eax,0x805140
  802145:	a1 40 51 80 00       	mov    0x805140,%eax
  80214a:	85 c0                	test   %eax,%eax
  80214c:	75 8a                	jne    8020d8 <print_mem_block_lists+0x3b>
  80214e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802152:	75 84                	jne    8020d8 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802154:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802158:	75 10                	jne    80216a <print_mem_block_lists+0xcd>
  80215a:	83 ec 0c             	sub    $0xc,%esp
  80215d:	68 e8 44 80 00       	push   $0x8044e8
  802162:	e8 1c e8 ff ff       	call   800983 <cprintf>
  802167:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  80216a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802171:	83 ec 0c             	sub    $0xc,%esp
  802174:	68 0c 45 80 00       	push   $0x80450c
  802179:	e8 05 e8 ff ff       	call   800983 <cprintf>
  80217e:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802181:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802185:	a1 40 50 80 00       	mov    0x805040,%eax
  80218a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80218d:	eb 56                	jmp    8021e5 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80218f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802193:	74 1c                	je     8021b1 <print_mem_block_lists+0x114>
  802195:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802198:	8b 50 08             	mov    0x8(%eax),%edx
  80219b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80219e:	8b 48 08             	mov    0x8(%eax),%ecx
  8021a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021a4:	8b 40 0c             	mov    0xc(%eax),%eax
  8021a7:	01 c8                	add    %ecx,%eax
  8021a9:	39 c2                	cmp    %eax,%edx
  8021ab:	73 04                	jae    8021b1 <print_mem_block_lists+0x114>
			sorted = 0 ;
  8021ad:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8021b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b4:	8b 50 08             	mov    0x8(%eax),%edx
  8021b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ba:	8b 40 0c             	mov    0xc(%eax),%eax
  8021bd:	01 c2                	add    %eax,%edx
  8021bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c2:	8b 40 08             	mov    0x8(%eax),%eax
  8021c5:	83 ec 04             	sub    $0x4,%esp
  8021c8:	52                   	push   %edx
  8021c9:	50                   	push   %eax
  8021ca:	68 d9 44 80 00       	push   $0x8044d9
  8021cf:	e8 af e7 ff ff       	call   800983 <cprintf>
  8021d4:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8021d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021da:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8021dd:	a1 48 50 80 00       	mov    0x805048,%eax
  8021e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021e5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021e9:	74 07                	je     8021f2 <print_mem_block_lists+0x155>
  8021eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ee:	8b 00                	mov    (%eax),%eax
  8021f0:	eb 05                	jmp    8021f7 <print_mem_block_lists+0x15a>
  8021f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8021f7:	a3 48 50 80 00       	mov    %eax,0x805048
  8021fc:	a1 48 50 80 00       	mov    0x805048,%eax
  802201:	85 c0                	test   %eax,%eax
  802203:	75 8a                	jne    80218f <print_mem_block_lists+0xf2>
  802205:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802209:	75 84                	jne    80218f <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  80220b:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80220f:	75 10                	jne    802221 <print_mem_block_lists+0x184>
  802211:	83 ec 0c             	sub    $0xc,%esp
  802214:	68 24 45 80 00       	push   $0x804524
  802219:	e8 65 e7 ff ff       	call   800983 <cprintf>
  80221e:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802221:	83 ec 0c             	sub    $0xc,%esp
  802224:	68 98 44 80 00       	push   $0x804498
  802229:	e8 55 e7 ff ff       	call   800983 <cprintf>
  80222e:	83 c4 10             	add    $0x10,%esp

}
  802231:	90                   	nop
  802232:	c9                   	leave  
  802233:	c3                   	ret    

00802234 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802234:	55                   	push   %ebp
  802235:	89 e5                	mov    %esp,%ebp
  802237:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  80223a:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802241:	00 00 00 
  802244:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  80224b:	00 00 00 
  80224e:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802255:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  802258:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80225f:	e9 9e 00 00 00       	jmp    802302 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  802264:	a1 50 50 80 00       	mov    0x805050,%eax
  802269:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80226c:	c1 e2 04             	shl    $0x4,%edx
  80226f:	01 d0                	add    %edx,%eax
  802271:	85 c0                	test   %eax,%eax
  802273:	75 14                	jne    802289 <initialize_MemBlocksList+0x55>
  802275:	83 ec 04             	sub    $0x4,%esp
  802278:	68 4c 45 80 00       	push   $0x80454c
  80227d:	6a 46                	push   $0x46
  80227f:	68 6f 45 80 00       	push   $0x80456f
  802284:	e8 46 e4 ff ff       	call   8006cf <_panic>
  802289:	a1 50 50 80 00       	mov    0x805050,%eax
  80228e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802291:	c1 e2 04             	shl    $0x4,%edx
  802294:	01 d0                	add    %edx,%eax
  802296:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80229c:	89 10                	mov    %edx,(%eax)
  80229e:	8b 00                	mov    (%eax),%eax
  8022a0:	85 c0                	test   %eax,%eax
  8022a2:	74 18                	je     8022bc <initialize_MemBlocksList+0x88>
  8022a4:	a1 48 51 80 00       	mov    0x805148,%eax
  8022a9:	8b 15 50 50 80 00    	mov    0x805050,%edx
  8022af:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8022b2:	c1 e1 04             	shl    $0x4,%ecx
  8022b5:	01 ca                	add    %ecx,%edx
  8022b7:	89 50 04             	mov    %edx,0x4(%eax)
  8022ba:	eb 12                	jmp    8022ce <initialize_MemBlocksList+0x9a>
  8022bc:	a1 50 50 80 00       	mov    0x805050,%eax
  8022c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022c4:	c1 e2 04             	shl    $0x4,%edx
  8022c7:	01 d0                	add    %edx,%eax
  8022c9:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8022ce:	a1 50 50 80 00       	mov    0x805050,%eax
  8022d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022d6:	c1 e2 04             	shl    $0x4,%edx
  8022d9:	01 d0                	add    %edx,%eax
  8022db:	a3 48 51 80 00       	mov    %eax,0x805148
  8022e0:	a1 50 50 80 00       	mov    0x805050,%eax
  8022e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022e8:	c1 e2 04             	shl    $0x4,%edx
  8022eb:	01 d0                	add    %edx,%eax
  8022ed:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022f4:	a1 54 51 80 00       	mov    0x805154,%eax
  8022f9:	40                   	inc    %eax
  8022fa:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  8022ff:	ff 45 f4             	incl   -0xc(%ebp)
  802302:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802305:	3b 45 08             	cmp    0x8(%ebp),%eax
  802308:	0f 82 56 ff ff ff    	jb     802264 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  80230e:	90                   	nop
  80230f:	c9                   	leave  
  802310:	c3                   	ret    

00802311 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802311:	55                   	push   %ebp
  802312:	89 e5                	mov    %esp,%ebp
  802314:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802317:	8b 45 08             	mov    0x8(%ebp),%eax
  80231a:	8b 00                	mov    (%eax),%eax
  80231c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80231f:	eb 19                	jmp    80233a <find_block+0x29>
	{
		if(va==point->sva)
  802321:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802324:	8b 40 08             	mov    0x8(%eax),%eax
  802327:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80232a:	75 05                	jne    802331 <find_block+0x20>
		   return point;
  80232c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80232f:	eb 36                	jmp    802367 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802331:	8b 45 08             	mov    0x8(%ebp),%eax
  802334:	8b 40 08             	mov    0x8(%eax),%eax
  802337:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80233a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80233e:	74 07                	je     802347 <find_block+0x36>
  802340:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802343:	8b 00                	mov    (%eax),%eax
  802345:	eb 05                	jmp    80234c <find_block+0x3b>
  802347:	b8 00 00 00 00       	mov    $0x0,%eax
  80234c:	8b 55 08             	mov    0x8(%ebp),%edx
  80234f:	89 42 08             	mov    %eax,0x8(%edx)
  802352:	8b 45 08             	mov    0x8(%ebp),%eax
  802355:	8b 40 08             	mov    0x8(%eax),%eax
  802358:	85 c0                	test   %eax,%eax
  80235a:	75 c5                	jne    802321 <find_block+0x10>
  80235c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802360:	75 bf                	jne    802321 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802362:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802367:	c9                   	leave  
  802368:	c3                   	ret    

00802369 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802369:	55                   	push   %ebp
  80236a:	89 e5                	mov    %esp,%ebp
  80236c:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  80236f:	a1 40 50 80 00       	mov    0x805040,%eax
  802374:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802377:	a1 44 50 80 00       	mov    0x805044,%eax
  80237c:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  80237f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802382:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802385:	74 24                	je     8023ab <insert_sorted_allocList+0x42>
  802387:	8b 45 08             	mov    0x8(%ebp),%eax
  80238a:	8b 50 08             	mov    0x8(%eax),%edx
  80238d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802390:	8b 40 08             	mov    0x8(%eax),%eax
  802393:	39 c2                	cmp    %eax,%edx
  802395:	76 14                	jbe    8023ab <insert_sorted_allocList+0x42>
  802397:	8b 45 08             	mov    0x8(%ebp),%eax
  80239a:	8b 50 08             	mov    0x8(%eax),%edx
  80239d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023a0:	8b 40 08             	mov    0x8(%eax),%eax
  8023a3:	39 c2                	cmp    %eax,%edx
  8023a5:	0f 82 60 01 00 00    	jb     80250b <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  8023ab:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8023af:	75 65                	jne    802416 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  8023b1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023b5:	75 14                	jne    8023cb <insert_sorted_allocList+0x62>
  8023b7:	83 ec 04             	sub    $0x4,%esp
  8023ba:	68 4c 45 80 00       	push   $0x80454c
  8023bf:	6a 6b                	push   $0x6b
  8023c1:	68 6f 45 80 00       	push   $0x80456f
  8023c6:	e8 04 e3 ff ff       	call   8006cf <_panic>
  8023cb:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8023d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d4:	89 10                	mov    %edx,(%eax)
  8023d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d9:	8b 00                	mov    (%eax),%eax
  8023db:	85 c0                	test   %eax,%eax
  8023dd:	74 0d                	je     8023ec <insert_sorted_allocList+0x83>
  8023df:	a1 40 50 80 00       	mov    0x805040,%eax
  8023e4:	8b 55 08             	mov    0x8(%ebp),%edx
  8023e7:	89 50 04             	mov    %edx,0x4(%eax)
  8023ea:	eb 08                	jmp    8023f4 <insert_sorted_allocList+0x8b>
  8023ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ef:	a3 44 50 80 00       	mov    %eax,0x805044
  8023f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f7:	a3 40 50 80 00       	mov    %eax,0x805040
  8023fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ff:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802406:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80240b:	40                   	inc    %eax
  80240c:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802411:	e9 dc 01 00 00       	jmp    8025f2 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802416:	8b 45 08             	mov    0x8(%ebp),%eax
  802419:	8b 50 08             	mov    0x8(%eax),%edx
  80241c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80241f:	8b 40 08             	mov    0x8(%eax),%eax
  802422:	39 c2                	cmp    %eax,%edx
  802424:	77 6c                	ja     802492 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802426:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80242a:	74 06                	je     802432 <insert_sorted_allocList+0xc9>
  80242c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802430:	75 14                	jne    802446 <insert_sorted_allocList+0xdd>
  802432:	83 ec 04             	sub    $0x4,%esp
  802435:	68 88 45 80 00       	push   $0x804588
  80243a:	6a 6f                	push   $0x6f
  80243c:	68 6f 45 80 00       	push   $0x80456f
  802441:	e8 89 e2 ff ff       	call   8006cf <_panic>
  802446:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802449:	8b 50 04             	mov    0x4(%eax),%edx
  80244c:	8b 45 08             	mov    0x8(%ebp),%eax
  80244f:	89 50 04             	mov    %edx,0x4(%eax)
  802452:	8b 45 08             	mov    0x8(%ebp),%eax
  802455:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802458:	89 10                	mov    %edx,(%eax)
  80245a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80245d:	8b 40 04             	mov    0x4(%eax),%eax
  802460:	85 c0                	test   %eax,%eax
  802462:	74 0d                	je     802471 <insert_sorted_allocList+0x108>
  802464:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802467:	8b 40 04             	mov    0x4(%eax),%eax
  80246a:	8b 55 08             	mov    0x8(%ebp),%edx
  80246d:	89 10                	mov    %edx,(%eax)
  80246f:	eb 08                	jmp    802479 <insert_sorted_allocList+0x110>
  802471:	8b 45 08             	mov    0x8(%ebp),%eax
  802474:	a3 40 50 80 00       	mov    %eax,0x805040
  802479:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80247c:	8b 55 08             	mov    0x8(%ebp),%edx
  80247f:	89 50 04             	mov    %edx,0x4(%eax)
  802482:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802487:	40                   	inc    %eax
  802488:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80248d:	e9 60 01 00 00       	jmp    8025f2 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802492:	8b 45 08             	mov    0x8(%ebp),%eax
  802495:	8b 50 08             	mov    0x8(%eax),%edx
  802498:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80249b:	8b 40 08             	mov    0x8(%eax),%eax
  80249e:	39 c2                	cmp    %eax,%edx
  8024a0:	0f 82 4c 01 00 00    	jb     8025f2 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8024a6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8024aa:	75 14                	jne    8024c0 <insert_sorted_allocList+0x157>
  8024ac:	83 ec 04             	sub    $0x4,%esp
  8024af:	68 c0 45 80 00       	push   $0x8045c0
  8024b4:	6a 73                	push   $0x73
  8024b6:	68 6f 45 80 00       	push   $0x80456f
  8024bb:	e8 0f e2 ff ff       	call   8006cf <_panic>
  8024c0:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8024c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c9:	89 50 04             	mov    %edx,0x4(%eax)
  8024cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8024cf:	8b 40 04             	mov    0x4(%eax),%eax
  8024d2:	85 c0                	test   %eax,%eax
  8024d4:	74 0c                	je     8024e2 <insert_sorted_allocList+0x179>
  8024d6:	a1 44 50 80 00       	mov    0x805044,%eax
  8024db:	8b 55 08             	mov    0x8(%ebp),%edx
  8024de:	89 10                	mov    %edx,(%eax)
  8024e0:	eb 08                	jmp    8024ea <insert_sorted_allocList+0x181>
  8024e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e5:	a3 40 50 80 00       	mov    %eax,0x805040
  8024ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ed:	a3 44 50 80 00       	mov    %eax,0x805044
  8024f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024fb:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802500:	40                   	inc    %eax
  802501:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802506:	e9 e7 00 00 00       	jmp    8025f2 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  80250b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80250e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802511:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802518:	a1 40 50 80 00       	mov    0x805040,%eax
  80251d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802520:	e9 9d 00 00 00       	jmp    8025c2 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802525:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802528:	8b 00                	mov    (%eax),%eax
  80252a:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  80252d:	8b 45 08             	mov    0x8(%ebp),%eax
  802530:	8b 50 08             	mov    0x8(%eax),%edx
  802533:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802536:	8b 40 08             	mov    0x8(%eax),%eax
  802539:	39 c2                	cmp    %eax,%edx
  80253b:	76 7d                	jbe    8025ba <insert_sorted_allocList+0x251>
  80253d:	8b 45 08             	mov    0x8(%ebp),%eax
  802540:	8b 50 08             	mov    0x8(%eax),%edx
  802543:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802546:	8b 40 08             	mov    0x8(%eax),%eax
  802549:	39 c2                	cmp    %eax,%edx
  80254b:	73 6d                	jae    8025ba <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  80254d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802551:	74 06                	je     802559 <insert_sorted_allocList+0x1f0>
  802553:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802557:	75 14                	jne    80256d <insert_sorted_allocList+0x204>
  802559:	83 ec 04             	sub    $0x4,%esp
  80255c:	68 e4 45 80 00       	push   $0x8045e4
  802561:	6a 7f                	push   $0x7f
  802563:	68 6f 45 80 00       	push   $0x80456f
  802568:	e8 62 e1 ff ff       	call   8006cf <_panic>
  80256d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802570:	8b 10                	mov    (%eax),%edx
  802572:	8b 45 08             	mov    0x8(%ebp),%eax
  802575:	89 10                	mov    %edx,(%eax)
  802577:	8b 45 08             	mov    0x8(%ebp),%eax
  80257a:	8b 00                	mov    (%eax),%eax
  80257c:	85 c0                	test   %eax,%eax
  80257e:	74 0b                	je     80258b <insert_sorted_allocList+0x222>
  802580:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802583:	8b 00                	mov    (%eax),%eax
  802585:	8b 55 08             	mov    0x8(%ebp),%edx
  802588:	89 50 04             	mov    %edx,0x4(%eax)
  80258b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258e:	8b 55 08             	mov    0x8(%ebp),%edx
  802591:	89 10                	mov    %edx,(%eax)
  802593:	8b 45 08             	mov    0x8(%ebp),%eax
  802596:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802599:	89 50 04             	mov    %edx,0x4(%eax)
  80259c:	8b 45 08             	mov    0x8(%ebp),%eax
  80259f:	8b 00                	mov    (%eax),%eax
  8025a1:	85 c0                	test   %eax,%eax
  8025a3:	75 08                	jne    8025ad <insert_sorted_allocList+0x244>
  8025a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a8:	a3 44 50 80 00       	mov    %eax,0x805044
  8025ad:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8025b2:	40                   	inc    %eax
  8025b3:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  8025b8:	eb 39                	jmp    8025f3 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8025ba:	a1 48 50 80 00       	mov    0x805048,%eax
  8025bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025c2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025c6:	74 07                	je     8025cf <insert_sorted_allocList+0x266>
  8025c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025cb:	8b 00                	mov    (%eax),%eax
  8025cd:	eb 05                	jmp    8025d4 <insert_sorted_allocList+0x26b>
  8025cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8025d4:	a3 48 50 80 00       	mov    %eax,0x805048
  8025d9:	a1 48 50 80 00       	mov    0x805048,%eax
  8025de:	85 c0                	test   %eax,%eax
  8025e0:	0f 85 3f ff ff ff    	jne    802525 <insert_sorted_allocList+0x1bc>
  8025e6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025ea:	0f 85 35 ff ff ff    	jne    802525 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8025f0:	eb 01                	jmp    8025f3 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8025f2:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8025f3:	90                   	nop
  8025f4:	c9                   	leave  
  8025f5:	c3                   	ret    

008025f6 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8025f6:	55                   	push   %ebp
  8025f7:	89 e5                	mov    %esp,%ebp
  8025f9:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8025fc:	a1 38 51 80 00       	mov    0x805138,%eax
  802601:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802604:	e9 85 01 00 00       	jmp    80278e <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802609:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80260c:	8b 40 0c             	mov    0xc(%eax),%eax
  80260f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802612:	0f 82 6e 01 00 00    	jb     802786 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802618:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261b:	8b 40 0c             	mov    0xc(%eax),%eax
  80261e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802621:	0f 85 8a 00 00 00    	jne    8026b1 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802627:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80262b:	75 17                	jne    802644 <alloc_block_FF+0x4e>
  80262d:	83 ec 04             	sub    $0x4,%esp
  802630:	68 18 46 80 00       	push   $0x804618
  802635:	68 93 00 00 00       	push   $0x93
  80263a:	68 6f 45 80 00       	push   $0x80456f
  80263f:	e8 8b e0 ff ff       	call   8006cf <_panic>
  802644:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802647:	8b 00                	mov    (%eax),%eax
  802649:	85 c0                	test   %eax,%eax
  80264b:	74 10                	je     80265d <alloc_block_FF+0x67>
  80264d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802650:	8b 00                	mov    (%eax),%eax
  802652:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802655:	8b 52 04             	mov    0x4(%edx),%edx
  802658:	89 50 04             	mov    %edx,0x4(%eax)
  80265b:	eb 0b                	jmp    802668 <alloc_block_FF+0x72>
  80265d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802660:	8b 40 04             	mov    0x4(%eax),%eax
  802663:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802668:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266b:	8b 40 04             	mov    0x4(%eax),%eax
  80266e:	85 c0                	test   %eax,%eax
  802670:	74 0f                	je     802681 <alloc_block_FF+0x8b>
  802672:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802675:	8b 40 04             	mov    0x4(%eax),%eax
  802678:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80267b:	8b 12                	mov    (%edx),%edx
  80267d:	89 10                	mov    %edx,(%eax)
  80267f:	eb 0a                	jmp    80268b <alloc_block_FF+0x95>
  802681:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802684:	8b 00                	mov    (%eax),%eax
  802686:	a3 38 51 80 00       	mov    %eax,0x805138
  80268b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802694:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802697:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80269e:	a1 44 51 80 00       	mov    0x805144,%eax
  8026a3:	48                   	dec    %eax
  8026a4:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  8026a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ac:	e9 10 01 00 00       	jmp    8027c1 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  8026b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b4:	8b 40 0c             	mov    0xc(%eax),%eax
  8026b7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026ba:	0f 86 c6 00 00 00    	jbe    802786 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8026c0:	a1 48 51 80 00       	mov    0x805148,%eax
  8026c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  8026c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026cb:	8b 50 08             	mov    0x8(%eax),%edx
  8026ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026d1:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  8026d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026d7:	8b 55 08             	mov    0x8(%ebp),%edx
  8026da:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8026dd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8026e1:	75 17                	jne    8026fa <alloc_block_FF+0x104>
  8026e3:	83 ec 04             	sub    $0x4,%esp
  8026e6:	68 18 46 80 00       	push   $0x804618
  8026eb:	68 9b 00 00 00       	push   $0x9b
  8026f0:	68 6f 45 80 00       	push   $0x80456f
  8026f5:	e8 d5 df ff ff       	call   8006cf <_panic>
  8026fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026fd:	8b 00                	mov    (%eax),%eax
  8026ff:	85 c0                	test   %eax,%eax
  802701:	74 10                	je     802713 <alloc_block_FF+0x11d>
  802703:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802706:	8b 00                	mov    (%eax),%eax
  802708:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80270b:	8b 52 04             	mov    0x4(%edx),%edx
  80270e:	89 50 04             	mov    %edx,0x4(%eax)
  802711:	eb 0b                	jmp    80271e <alloc_block_FF+0x128>
  802713:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802716:	8b 40 04             	mov    0x4(%eax),%eax
  802719:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80271e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802721:	8b 40 04             	mov    0x4(%eax),%eax
  802724:	85 c0                	test   %eax,%eax
  802726:	74 0f                	je     802737 <alloc_block_FF+0x141>
  802728:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80272b:	8b 40 04             	mov    0x4(%eax),%eax
  80272e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802731:	8b 12                	mov    (%edx),%edx
  802733:	89 10                	mov    %edx,(%eax)
  802735:	eb 0a                	jmp    802741 <alloc_block_FF+0x14b>
  802737:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80273a:	8b 00                	mov    (%eax),%eax
  80273c:	a3 48 51 80 00       	mov    %eax,0x805148
  802741:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802744:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80274a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80274d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802754:	a1 54 51 80 00       	mov    0x805154,%eax
  802759:	48                   	dec    %eax
  80275a:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  80275f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802762:	8b 50 08             	mov    0x8(%eax),%edx
  802765:	8b 45 08             	mov    0x8(%ebp),%eax
  802768:	01 c2                	add    %eax,%edx
  80276a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276d:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802770:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802773:	8b 40 0c             	mov    0xc(%eax),%eax
  802776:	2b 45 08             	sub    0x8(%ebp),%eax
  802779:	89 c2                	mov    %eax,%edx
  80277b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277e:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802781:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802784:	eb 3b                	jmp    8027c1 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802786:	a1 40 51 80 00       	mov    0x805140,%eax
  80278b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80278e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802792:	74 07                	je     80279b <alloc_block_FF+0x1a5>
  802794:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802797:	8b 00                	mov    (%eax),%eax
  802799:	eb 05                	jmp    8027a0 <alloc_block_FF+0x1aa>
  80279b:	b8 00 00 00 00       	mov    $0x0,%eax
  8027a0:	a3 40 51 80 00       	mov    %eax,0x805140
  8027a5:	a1 40 51 80 00       	mov    0x805140,%eax
  8027aa:	85 c0                	test   %eax,%eax
  8027ac:	0f 85 57 fe ff ff    	jne    802609 <alloc_block_FF+0x13>
  8027b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027b6:	0f 85 4d fe ff ff    	jne    802609 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  8027bc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027c1:	c9                   	leave  
  8027c2:	c3                   	ret    

008027c3 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8027c3:	55                   	push   %ebp
  8027c4:	89 e5                	mov    %esp,%ebp
  8027c6:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  8027c9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8027d0:	a1 38 51 80 00       	mov    0x805138,%eax
  8027d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027d8:	e9 df 00 00 00       	jmp    8028bc <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  8027dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e0:	8b 40 0c             	mov    0xc(%eax),%eax
  8027e3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027e6:	0f 82 c8 00 00 00    	jb     8028b4 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  8027ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ef:	8b 40 0c             	mov    0xc(%eax),%eax
  8027f2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027f5:	0f 85 8a 00 00 00    	jne    802885 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  8027fb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027ff:	75 17                	jne    802818 <alloc_block_BF+0x55>
  802801:	83 ec 04             	sub    $0x4,%esp
  802804:	68 18 46 80 00       	push   $0x804618
  802809:	68 b7 00 00 00       	push   $0xb7
  80280e:	68 6f 45 80 00       	push   $0x80456f
  802813:	e8 b7 de ff ff       	call   8006cf <_panic>
  802818:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281b:	8b 00                	mov    (%eax),%eax
  80281d:	85 c0                	test   %eax,%eax
  80281f:	74 10                	je     802831 <alloc_block_BF+0x6e>
  802821:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802824:	8b 00                	mov    (%eax),%eax
  802826:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802829:	8b 52 04             	mov    0x4(%edx),%edx
  80282c:	89 50 04             	mov    %edx,0x4(%eax)
  80282f:	eb 0b                	jmp    80283c <alloc_block_BF+0x79>
  802831:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802834:	8b 40 04             	mov    0x4(%eax),%eax
  802837:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80283c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283f:	8b 40 04             	mov    0x4(%eax),%eax
  802842:	85 c0                	test   %eax,%eax
  802844:	74 0f                	je     802855 <alloc_block_BF+0x92>
  802846:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802849:	8b 40 04             	mov    0x4(%eax),%eax
  80284c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80284f:	8b 12                	mov    (%edx),%edx
  802851:	89 10                	mov    %edx,(%eax)
  802853:	eb 0a                	jmp    80285f <alloc_block_BF+0x9c>
  802855:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802858:	8b 00                	mov    (%eax),%eax
  80285a:	a3 38 51 80 00       	mov    %eax,0x805138
  80285f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802862:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802868:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802872:	a1 44 51 80 00       	mov    0x805144,%eax
  802877:	48                   	dec    %eax
  802878:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  80287d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802880:	e9 4d 01 00 00       	jmp    8029d2 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802885:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802888:	8b 40 0c             	mov    0xc(%eax),%eax
  80288b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80288e:	76 24                	jbe    8028b4 <alloc_block_BF+0xf1>
  802890:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802893:	8b 40 0c             	mov    0xc(%eax),%eax
  802896:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802899:	73 19                	jae    8028b4 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  80289b:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  8028a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a5:	8b 40 0c             	mov    0xc(%eax),%eax
  8028a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  8028ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ae:	8b 40 08             	mov    0x8(%eax),%eax
  8028b1:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8028b4:	a1 40 51 80 00       	mov    0x805140,%eax
  8028b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028bc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028c0:	74 07                	je     8028c9 <alloc_block_BF+0x106>
  8028c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c5:	8b 00                	mov    (%eax),%eax
  8028c7:	eb 05                	jmp    8028ce <alloc_block_BF+0x10b>
  8028c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8028ce:	a3 40 51 80 00       	mov    %eax,0x805140
  8028d3:	a1 40 51 80 00       	mov    0x805140,%eax
  8028d8:	85 c0                	test   %eax,%eax
  8028da:	0f 85 fd fe ff ff    	jne    8027dd <alloc_block_BF+0x1a>
  8028e0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028e4:	0f 85 f3 fe ff ff    	jne    8027dd <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  8028ea:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8028ee:	0f 84 d9 00 00 00    	je     8029cd <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  8028f4:	a1 48 51 80 00       	mov    0x805148,%eax
  8028f9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  8028fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028ff:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802902:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802905:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802908:	8b 55 08             	mov    0x8(%ebp),%edx
  80290b:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  80290e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802912:	75 17                	jne    80292b <alloc_block_BF+0x168>
  802914:	83 ec 04             	sub    $0x4,%esp
  802917:	68 18 46 80 00       	push   $0x804618
  80291c:	68 c7 00 00 00       	push   $0xc7
  802921:	68 6f 45 80 00       	push   $0x80456f
  802926:	e8 a4 dd ff ff       	call   8006cf <_panic>
  80292b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80292e:	8b 00                	mov    (%eax),%eax
  802930:	85 c0                	test   %eax,%eax
  802932:	74 10                	je     802944 <alloc_block_BF+0x181>
  802934:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802937:	8b 00                	mov    (%eax),%eax
  802939:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80293c:	8b 52 04             	mov    0x4(%edx),%edx
  80293f:	89 50 04             	mov    %edx,0x4(%eax)
  802942:	eb 0b                	jmp    80294f <alloc_block_BF+0x18c>
  802944:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802947:	8b 40 04             	mov    0x4(%eax),%eax
  80294a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80294f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802952:	8b 40 04             	mov    0x4(%eax),%eax
  802955:	85 c0                	test   %eax,%eax
  802957:	74 0f                	je     802968 <alloc_block_BF+0x1a5>
  802959:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80295c:	8b 40 04             	mov    0x4(%eax),%eax
  80295f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802962:	8b 12                	mov    (%edx),%edx
  802964:	89 10                	mov    %edx,(%eax)
  802966:	eb 0a                	jmp    802972 <alloc_block_BF+0x1af>
  802968:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80296b:	8b 00                	mov    (%eax),%eax
  80296d:	a3 48 51 80 00       	mov    %eax,0x805148
  802972:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802975:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80297b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80297e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802985:	a1 54 51 80 00       	mov    0x805154,%eax
  80298a:	48                   	dec    %eax
  80298b:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802990:	83 ec 08             	sub    $0x8,%esp
  802993:	ff 75 ec             	pushl  -0x14(%ebp)
  802996:	68 38 51 80 00       	push   $0x805138
  80299b:	e8 71 f9 ff ff       	call   802311 <find_block>
  8029a0:	83 c4 10             	add    $0x10,%esp
  8029a3:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  8029a6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029a9:	8b 50 08             	mov    0x8(%eax),%edx
  8029ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8029af:	01 c2                	add    %eax,%edx
  8029b1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029b4:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  8029b7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029ba:	8b 40 0c             	mov    0xc(%eax),%eax
  8029bd:	2b 45 08             	sub    0x8(%ebp),%eax
  8029c0:	89 c2                	mov    %eax,%edx
  8029c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029c5:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  8029c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029cb:	eb 05                	jmp    8029d2 <alloc_block_BF+0x20f>
	}
	return NULL;
  8029cd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029d2:	c9                   	leave  
  8029d3:	c3                   	ret    

008029d4 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  8029d4:	55                   	push   %ebp
  8029d5:	89 e5                	mov    %esp,%ebp
  8029d7:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  8029da:	a1 28 50 80 00       	mov    0x805028,%eax
  8029df:	85 c0                	test   %eax,%eax
  8029e1:	0f 85 de 01 00 00    	jne    802bc5 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8029e7:	a1 38 51 80 00       	mov    0x805138,%eax
  8029ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029ef:	e9 9e 01 00 00       	jmp    802b92 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  8029f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f7:	8b 40 0c             	mov    0xc(%eax),%eax
  8029fa:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029fd:	0f 82 87 01 00 00    	jb     802b8a <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802a03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a06:	8b 40 0c             	mov    0xc(%eax),%eax
  802a09:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a0c:	0f 85 95 00 00 00    	jne    802aa7 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802a12:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a16:	75 17                	jne    802a2f <alloc_block_NF+0x5b>
  802a18:	83 ec 04             	sub    $0x4,%esp
  802a1b:	68 18 46 80 00       	push   $0x804618
  802a20:	68 e0 00 00 00       	push   $0xe0
  802a25:	68 6f 45 80 00       	push   $0x80456f
  802a2a:	e8 a0 dc ff ff       	call   8006cf <_panic>
  802a2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a32:	8b 00                	mov    (%eax),%eax
  802a34:	85 c0                	test   %eax,%eax
  802a36:	74 10                	je     802a48 <alloc_block_NF+0x74>
  802a38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3b:	8b 00                	mov    (%eax),%eax
  802a3d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a40:	8b 52 04             	mov    0x4(%edx),%edx
  802a43:	89 50 04             	mov    %edx,0x4(%eax)
  802a46:	eb 0b                	jmp    802a53 <alloc_block_NF+0x7f>
  802a48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4b:	8b 40 04             	mov    0x4(%eax),%eax
  802a4e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802a53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a56:	8b 40 04             	mov    0x4(%eax),%eax
  802a59:	85 c0                	test   %eax,%eax
  802a5b:	74 0f                	je     802a6c <alloc_block_NF+0x98>
  802a5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a60:	8b 40 04             	mov    0x4(%eax),%eax
  802a63:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a66:	8b 12                	mov    (%edx),%edx
  802a68:	89 10                	mov    %edx,(%eax)
  802a6a:	eb 0a                	jmp    802a76 <alloc_block_NF+0xa2>
  802a6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6f:	8b 00                	mov    (%eax),%eax
  802a71:	a3 38 51 80 00       	mov    %eax,0x805138
  802a76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a79:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a82:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a89:	a1 44 51 80 00       	mov    0x805144,%eax
  802a8e:	48                   	dec    %eax
  802a8f:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802a94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a97:	8b 40 08             	mov    0x8(%eax),%eax
  802a9a:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  802a9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa2:	e9 f8 04 00 00       	jmp    802f9f <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802aa7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aaa:	8b 40 0c             	mov    0xc(%eax),%eax
  802aad:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ab0:	0f 86 d4 00 00 00    	jbe    802b8a <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802ab6:	a1 48 51 80 00       	mov    0x805148,%eax
  802abb:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802abe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac1:	8b 50 08             	mov    0x8(%eax),%edx
  802ac4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ac7:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802aca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802acd:	8b 55 08             	mov    0x8(%ebp),%edx
  802ad0:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802ad3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ad7:	75 17                	jne    802af0 <alloc_block_NF+0x11c>
  802ad9:	83 ec 04             	sub    $0x4,%esp
  802adc:	68 18 46 80 00       	push   $0x804618
  802ae1:	68 e9 00 00 00       	push   $0xe9
  802ae6:	68 6f 45 80 00       	push   $0x80456f
  802aeb:	e8 df db ff ff       	call   8006cf <_panic>
  802af0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802af3:	8b 00                	mov    (%eax),%eax
  802af5:	85 c0                	test   %eax,%eax
  802af7:	74 10                	je     802b09 <alloc_block_NF+0x135>
  802af9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802afc:	8b 00                	mov    (%eax),%eax
  802afe:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b01:	8b 52 04             	mov    0x4(%edx),%edx
  802b04:	89 50 04             	mov    %edx,0x4(%eax)
  802b07:	eb 0b                	jmp    802b14 <alloc_block_NF+0x140>
  802b09:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b0c:	8b 40 04             	mov    0x4(%eax),%eax
  802b0f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b14:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b17:	8b 40 04             	mov    0x4(%eax),%eax
  802b1a:	85 c0                	test   %eax,%eax
  802b1c:	74 0f                	je     802b2d <alloc_block_NF+0x159>
  802b1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b21:	8b 40 04             	mov    0x4(%eax),%eax
  802b24:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b27:	8b 12                	mov    (%edx),%edx
  802b29:	89 10                	mov    %edx,(%eax)
  802b2b:	eb 0a                	jmp    802b37 <alloc_block_NF+0x163>
  802b2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b30:	8b 00                	mov    (%eax),%eax
  802b32:	a3 48 51 80 00       	mov    %eax,0x805148
  802b37:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b3a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b40:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b43:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b4a:	a1 54 51 80 00       	mov    0x805154,%eax
  802b4f:	48                   	dec    %eax
  802b50:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802b55:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b58:	8b 40 08             	mov    0x8(%eax),%eax
  802b5b:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802b60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b63:	8b 50 08             	mov    0x8(%eax),%edx
  802b66:	8b 45 08             	mov    0x8(%ebp),%eax
  802b69:	01 c2                	add    %eax,%edx
  802b6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6e:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802b71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b74:	8b 40 0c             	mov    0xc(%eax),%eax
  802b77:	2b 45 08             	sub    0x8(%ebp),%eax
  802b7a:	89 c2                	mov    %eax,%edx
  802b7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b7f:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802b82:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b85:	e9 15 04 00 00       	jmp    802f9f <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802b8a:	a1 40 51 80 00       	mov    0x805140,%eax
  802b8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b92:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b96:	74 07                	je     802b9f <alloc_block_NF+0x1cb>
  802b98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9b:	8b 00                	mov    (%eax),%eax
  802b9d:	eb 05                	jmp    802ba4 <alloc_block_NF+0x1d0>
  802b9f:	b8 00 00 00 00       	mov    $0x0,%eax
  802ba4:	a3 40 51 80 00       	mov    %eax,0x805140
  802ba9:	a1 40 51 80 00       	mov    0x805140,%eax
  802bae:	85 c0                	test   %eax,%eax
  802bb0:	0f 85 3e fe ff ff    	jne    8029f4 <alloc_block_NF+0x20>
  802bb6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bba:	0f 85 34 fe ff ff    	jne    8029f4 <alloc_block_NF+0x20>
  802bc0:	e9 d5 03 00 00       	jmp    802f9a <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802bc5:	a1 38 51 80 00       	mov    0x805138,%eax
  802bca:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bcd:	e9 b1 01 00 00       	jmp    802d83 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802bd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd5:	8b 50 08             	mov    0x8(%eax),%edx
  802bd8:	a1 28 50 80 00       	mov    0x805028,%eax
  802bdd:	39 c2                	cmp    %eax,%edx
  802bdf:	0f 82 96 01 00 00    	jb     802d7b <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802be5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be8:	8b 40 0c             	mov    0xc(%eax),%eax
  802beb:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bee:	0f 82 87 01 00 00    	jb     802d7b <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802bf4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf7:	8b 40 0c             	mov    0xc(%eax),%eax
  802bfa:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bfd:	0f 85 95 00 00 00    	jne    802c98 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802c03:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c07:	75 17                	jne    802c20 <alloc_block_NF+0x24c>
  802c09:	83 ec 04             	sub    $0x4,%esp
  802c0c:	68 18 46 80 00       	push   $0x804618
  802c11:	68 fc 00 00 00       	push   $0xfc
  802c16:	68 6f 45 80 00       	push   $0x80456f
  802c1b:	e8 af da ff ff       	call   8006cf <_panic>
  802c20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c23:	8b 00                	mov    (%eax),%eax
  802c25:	85 c0                	test   %eax,%eax
  802c27:	74 10                	je     802c39 <alloc_block_NF+0x265>
  802c29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c2c:	8b 00                	mov    (%eax),%eax
  802c2e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c31:	8b 52 04             	mov    0x4(%edx),%edx
  802c34:	89 50 04             	mov    %edx,0x4(%eax)
  802c37:	eb 0b                	jmp    802c44 <alloc_block_NF+0x270>
  802c39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c3c:	8b 40 04             	mov    0x4(%eax),%eax
  802c3f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c47:	8b 40 04             	mov    0x4(%eax),%eax
  802c4a:	85 c0                	test   %eax,%eax
  802c4c:	74 0f                	je     802c5d <alloc_block_NF+0x289>
  802c4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c51:	8b 40 04             	mov    0x4(%eax),%eax
  802c54:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c57:	8b 12                	mov    (%edx),%edx
  802c59:	89 10                	mov    %edx,(%eax)
  802c5b:	eb 0a                	jmp    802c67 <alloc_block_NF+0x293>
  802c5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c60:	8b 00                	mov    (%eax),%eax
  802c62:	a3 38 51 80 00       	mov    %eax,0x805138
  802c67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c6a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c73:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c7a:	a1 44 51 80 00       	mov    0x805144,%eax
  802c7f:	48                   	dec    %eax
  802c80:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802c85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c88:	8b 40 08             	mov    0x8(%eax),%eax
  802c8b:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802c90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c93:	e9 07 03 00 00       	jmp    802f9f <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802c98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9b:	8b 40 0c             	mov    0xc(%eax),%eax
  802c9e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ca1:	0f 86 d4 00 00 00    	jbe    802d7b <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802ca7:	a1 48 51 80 00       	mov    0x805148,%eax
  802cac:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802caf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb2:	8b 50 08             	mov    0x8(%eax),%edx
  802cb5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cb8:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802cbb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cbe:	8b 55 08             	mov    0x8(%ebp),%edx
  802cc1:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802cc4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802cc8:	75 17                	jne    802ce1 <alloc_block_NF+0x30d>
  802cca:	83 ec 04             	sub    $0x4,%esp
  802ccd:	68 18 46 80 00       	push   $0x804618
  802cd2:	68 04 01 00 00       	push   $0x104
  802cd7:	68 6f 45 80 00       	push   $0x80456f
  802cdc:	e8 ee d9 ff ff       	call   8006cf <_panic>
  802ce1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ce4:	8b 00                	mov    (%eax),%eax
  802ce6:	85 c0                	test   %eax,%eax
  802ce8:	74 10                	je     802cfa <alloc_block_NF+0x326>
  802cea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ced:	8b 00                	mov    (%eax),%eax
  802cef:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802cf2:	8b 52 04             	mov    0x4(%edx),%edx
  802cf5:	89 50 04             	mov    %edx,0x4(%eax)
  802cf8:	eb 0b                	jmp    802d05 <alloc_block_NF+0x331>
  802cfa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cfd:	8b 40 04             	mov    0x4(%eax),%eax
  802d00:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d05:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d08:	8b 40 04             	mov    0x4(%eax),%eax
  802d0b:	85 c0                	test   %eax,%eax
  802d0d:	74 0f                	je     802d1e <alloc_block_NF+0x34a>
  802d0f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d12:	8b 40 04             	mov    0x4(%eax),%eax
  802d15:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d18:	8b 12                	mov    (%edx),%edx
  802d1a:	89 10                	mov    %edx,(%eax)
  802d1c:	eb 0a                	jmp    802d28 <alloc_block_NF+0x354>
  802d1e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d21:	8b 00                	mov    (%eax),%eax
  802d23:	a3 48 51 80 00       	mov    %eax,0x805148
  802d28:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d2b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d31:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d34:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d3b:	a1 54 51 80 00       	mov    0x805154,%eax
  802d40:	48                   	dec    %eax
  802d41:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802d46:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d49:	8b 40 08             	mov    0x8(%eax),%eax
  802d4c:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802d51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d54:	8b 50 08             	mov    0x8(%eax),%edx
  802d57:	8b 45 08             	mov    0x8(%ebp),%eax
  802d5a:	01 c2                	add    %eax,%edx
  802d5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d5f:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802d62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d65:	8b 40 0c             	mov    0xc(%eax),%eax
  802d68:	2b 45 08             	sub    0x8(%ebp),%eax
  802d6b:	89 c2                	mov    %eax,%edx
  802d6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d70:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802d73:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d76:	e9 24 02 00 00       	jmp    802f9f <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802d7b:	a1 40 51 80 00       	mov    0x805140,%eax
  802d80:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d83:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d87:	74 07                	je     802d90 <alloc_block_NF+0x3bc>
  802d89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d8c:	8b 00                	mov    (%eax),%eax
  802d8e:	eb 05                	jmp    802d95 <alloc_block_NF+0x3c1>
  802d90:	b8 00 00 00 00       	mov    $0x0,%eax
  802d95:	a3 40 51 80 00       	mov    %eax,0x805140
  802d9a:	a1 40 51 80 00       	mov    0x805140,%eax
  802d9f:	85 c0                	test   %eax,%eax
  802da1:	0f 85 2b fe ff ff    	jne    802bd2 <alloc_block_NF+0x1fe>
  802da7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dab:	0f 85 21 fe ff ff    	jne    802bd2 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802db1:	a1 38 51 80 00       	mov    0x805138,%eax
  802db6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802db9:	e9 ae 01 00 00       	jmp    802f6c <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802dbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc1:	8b 50 08             	mov    0x8(%eax),%edx
  802dc4:	a1 28 50 80 00       	mov    0x805028,%eax
  802dc9:	39 c2                	cmp    %eax,%edx
  802dcb:	0f 83 93 01 00 00    	jae    802f64 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802dd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd4:	8b 40 0c             	mov    0xc(%eax),%eax
  802dd7:	3b 45 08             	cmp    0x8(%ebp),%eax
  802dda:	0f 82 84 01 00 00    	jb     802f64 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802de0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de3:	8b 40 0c             	mov    0xc(%eax),%eax
  802de6:	3b 45 08             	cmp    0x8(%ebp),%eax
  802de9:	0f 85 95 00 00 00    	jne    802e84 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802def:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802df3:	75 17                	jne    802e0c <alloc_block_NF+0x438>
  802df5:	83 ec 04             	sub    $0x4,%esp
  802df8:	68 18 46 80 00       	push   $0x804618
  802dfd:	68 14 01 00 00       	push   $0x114
  802e02:	68 6f 45 80 00       	push   $0x80456f
  802e07:	e8 c3 d8 ff ff       	call   8006cf <_panic>
  802e0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e0f:	8b 00                	mov    (%eax),%eax
  802e11:	85 c0                	test   %eax,%eax
  802e13:	74 10                	je     802e25 <alloc_block_NF+0x451>
  802e15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e18:	8b 00                	mov    (%eax),%eax
  802e1a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e1d:	8b 52 04             	mov    0x4(%edx),%edx
  802e20:	89 50 04             	mov    %edx,0x4(%eax)
  802e23:	eb 0b                	jmp    802e30 <alloc_block_NF+0x45c>
  802e25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e28:	8b 40 04             	mov    0x4(%eax),%eax
  802e2b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e33:	8b 40 04             	mov    0x4(%eax),%eax
  802e36:	85 c0                	test   %eax,%eax
  802e38:	74 0f                	je     802e49 <alloc_block_NF+0x475>
  802e3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e3d:	8b 40 04             	mov    0x4(%eax),%eax
  802e40:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e43:	8b 12                	mov    (%edx),%edx
  802e45:	89 10                	mov    %edx,(%eax)
  802e47:	eb 0a                	jmp    802e53 <alloc_block_NF+0x47f>
  802e49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e4c:	8b 00                	mov    (%eax),%eax
  802e4e:	a3 38 51 80 00       	mov    %eax,0x805138
  802e53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e56:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e5f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e66:	a1 44 51 80 00       	mov    0x805144,%eax
  802e6b:	48                   	dec    %eax
  802e6c:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802e71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e74:	8b 40 08             	mov    0x8(%eax),%eax
  802e77:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802e7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e7f:	e9 1b 01 00 00       	jmp    802f9f <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802e84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e87:	8b 40 0c             	mov    0xc(%eax),%eax
  802e8a:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e8d:	0f 86 d1 00 00 00    	jbe    802f64 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802e93:	a1 48 51 80 00       	mov    0x805148,%eax
  802e98:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802e9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e9e:	8b 50 08             	mov    0x8(%eax),%edx
  802ea1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ea4:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802ea7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802eaa:	8b 55 08             	mov    0x8(%ebp),%edx
  802ead:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802eb0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802eb4:	75 17                	jne    802ecd <alloc_block_NF+0x4f9>
  802eb6:	83 ec 04             	sub    $0x4,%esp
  802eb9:	68 18 46 80 00       	push   $0x804618
  802ebe:	68 1c 01 00 00       	push   $0x11c
  802ec3:	68 6f 45 80 00       	push   $0x80456f
  802ec8:	e8 02 d8 ff ff       	call   8006cf <_panic>
  802ecd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ed0:	8b 00                	mov    (%eax),%eax
  802ed2:	85 c0                	test   %eax,%eax
  802ed4:	74 10                	je     802ee6 <alloc_block_NF+0x512>
  802ed6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ed9:	8b 00                	mov    (%eax),%eax
  802edb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ede:	8b 52 04             	mov    0x4(%edx),%edx
  802ee1:	89 50 04             	mov    %edx,0x4(%eax)
  802ee4:	eb 0b                	jmp    802ef1 <alloc_block_NF+0x51d>
  802ee6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ee9:	8b 40 04             	mov    0x4(%eax),%eax
  802eec:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ef1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ef4:	8b 40 04             	mov    0x4(%eax),%eax
  802ef7:	85 c0                	test   %eax,%eax
  802ef9:	74 0f                	je     802f0a <alloc_block_NF+0x536>
  802efb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802efe:	8b 40 04             	mov    0x4(%eax),%eax
  802f01:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802f04:	8b 12                	mov    (%edx),%edx
  802f06:	89 10                	mov    %edx,(%eax)
  802f08:	eb 0a                	jmp    802f14 <alloc_block_NF+0x540>
  802f0a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f0d:	8b 00                	mov    (%eax),%eax
  802f0f:	a3 48 51 80 00       	mov    %eax,0x805148
  802f14:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f17:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f1d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f20:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f27:	a1 54 51 80 00       	mov    0x805154,%eax
  802f2c:	48                   	dec    %eax
  802f2d:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802f32:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f35:	8b 40 08             	mov    0x8(%eax),%eax
  802f38:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802f3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f40:	8b 50 08             	mov    0x8(%eax),%edx
  802f43:	8b 45 08             	mov    0x8(%ebp),%eax
  802f46:	01 c2                	add    %eax,%edx
  802f48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f4b:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802f4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f51:	8b 40 0c             	mov    0xc(%eax),%eax
  802f54:	2b 45 08             	sub    0x8(%ebp),%eax
  802f57:	89 c2                	mov    %eax,%edx
  802f59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f5c:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802f5f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f62:	eb 3b                	jmp    802f9f <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802f64:	a1 40 51 80 00       	mov    0x805140,%eax
  802f69:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f6c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f70:	74 07                	je     802f79 <alloc_block_NF+0x5a5>
  802f72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f75:	8b 00                	mov    (%eax),%eax
  802f77:	eb 05                	jmp    802f7e <alloc_block_NF+0x5aa>
  802f79:	b8 00 00 00 00       	mov    $0x0,%eax
  802f7e:	a3 40 51 80 00       	mov    %eax,0x805140
  802f83:	a1 40 51 80 00       	mov    0x805140,%eax
  802f88:	85 c0                	test   %eax,%eax
  802f8a:	0f 85 2e fe ff ff    	jne    802dbe <alloc_block_NF+0x3ea>
  802f90:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f94:	0f 85 24 fe ff ff    	jne    802dbe <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802f9a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f9f:	c9                   	leave  
  802fa0:	c3                   	ret    

00802fa1 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802fa1:	55                   	push   %ebp
  802fa2:	89 e5                	mov    %esp,%ebp
  802fa4:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802fa7:	a1 38 51 80 00       	mov    0x805138,%eax
  802fac:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802faf:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802fb4:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802fb7:	a1 38 51 80 00       	mov    0x805138,%eax
  802fbc:	85 c0                	test   %eax,%eax
  802fbe:	74 14                	je     802fd4 <insert_sorted_with_merge_freeList+0x33>
  802fc0:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc3:	8b 50 08             	mov    0x8(%eax),%edx
  802fc6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fc9:	8b 40 08             	mov    0x8(%eax),%eax
  802fcc:	39 c2                	cmp    %eax,%edx
  802fce:	0f 87 9b 01 00 00    	ja     80316f <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802fd4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fd8:	75 17                	jne    802ff1 <insert_sorted_with_merge_freeList+0x50>
  802fda:	83 ec 04             	sub    $0x4,%esp
  802fdd:	68 4c 45 80 00       	push   $0x80454c
  802fe2:	68 38 01 00 00       	push   $0x138
  802fe7:	68 6f 45 80 00       	push   $0x80456f
  802fec:	e8 de d6 ff ff       	call   8006cf <_panic>
  802ff1:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802ff7:	8b 45 08             	mov    0x8(%ebp),%eax
  802ffa:	89 10                	mov    %edx,(%eax)
  802ffc:	8b 45 08             	mov    0x8(%ebp),%eax
  802fff:	8b 00                	mov    (%eax),%eax
  803001:	85 c0                	test   %eax,%eax
  803003:	74 0d                	je     803012 <insert_sorted_with_merge_freeList+0x71>
  803005:	a1 38 51 80 00       	mov    0x805138,%eax
  80300a:	8b 55 08             	mov    0x8(%ebp),%edx
  80300d:	89 50 04             	mov    %edx,0x4(%eax)
  803010:	eb 08                	jmp    80301a <insert_sorted_with_merge_freeList+0x79>
  803012:	8b 45 08             	mov    0x8(%ebp),%eax
  803015:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80301a:	8b 45 08             	mov    0x8(%ebp),%eax
  80301d:	a3 38 51 80 00       	mov    %eax,0x805138
  803022:	8b 45 08             	mov    0x8(%ebp),%eax
  803025:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80302c:	a1 44 51 80 00       	mov    0x805144,%eax
  803031:	40                   	inc    %eax
  803032:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803037:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80303b:	0f 84 a8 06 00 00    	je     8036e9 <insert_sorted_with_merge_freeList+0x748>
  803041:	8b 45 08             	mov    0x8(%ebp),%eax
  803044:	8b 50 08             	mov    0x8(%eax),%edx
  803047:	8b 45 08             	mov    0x8(%ebp),%eax
  80304a:	8b 40 0c             	mov    0xc(%eax),%eax
  80304d:	01 c2                	add    %eax,%edx
  80304f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803052:	8b 40 08             	mov    0x8(%eax),%eax
  803055:	39 c2                	cmp    %eax,%edx
  803057:	0f 85 8c 06 00 00    	jne    8036e9 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  80305d:	8b 45 08             	mov    0x8(%ebp),%eax
  803060:	8b 50 0c             	mov    0xc(%eax),%edx
  803063:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803066:	8b 40 0c             	mov    0xc(%eax),%eax
  803069:	01 c2                	add    %eax,%edx
  80306b:	8b 45 08             	mov    0x8(%ebp),%eax
  80306e:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  803071:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803075:	75 17                	jne    80308e <insert_sorted_with_merge_freeList+0xed>
  803077:	83 ec 04             	sub    $0x4,%esp
  80307a:	68 18 46 80 00       	push   $0x804618
  80307f:	68 3c 01 00 00       	push   $0x13c
  803084:	68 6f 45 80 00       	push   $0x80456f
  803089:	e8 41 d6 ff ff       	call   8006cf <_panic>
  80308e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803091:	8b 00                	mov    (%eax),%eax
  803093:	85 c0                	test   %eax,%eax
  803095:	74 10                	je     8030a7 <insert_sorted_with_merge_freeList+0x106>
  803097:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80309a:	8b 00                	mov    (%eax),%eax
  80309c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80309f:	8b 52 04             	mov    0x4(%edx),%edx
  8030a2:	89 50 04             	mov    %edx,0x4(%eax)
  8030a5:	eb 0b                	jmp    8030b2 <insert_sorted_with_merge_freeList+0x111>
  8030a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030aa:	8b 40 04             	mov    0x4(%eax),%eax
  8030ad:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8030b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030b5:	8b 40 04             	mov    0x4(%eax),%eax
  8030b8:	85 c0                	test   %eax,%eax
  8030ba:	74 0f                	je     8030cb <insert_sorted_with_merge_freeList+0x12a>
  8030bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030bf:	8b 40 04             	mov    0x4(%eax),%eax
  8030c2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8030c5:	8b 12                	mov    (%edx),%edx
  8030c7:	89 10                	mov    %edx,(%eax)
  8030c9:	eb 0a                	jmp    8030d5 <insert_sorted_with_merge_freeList+0x134>
  8030cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030ce:	8b 00                	mov    (%eax),%eax
  8030d0:	a3 38 51 80 00       	mov    %eax,0x805138
  8030d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030d8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030e1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030e8:	a1 44 51 80 00       	mov    0x805144,%eax
  8030ed:	48                   	dec    %eax
  8030ee:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  8030f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030f6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  8030fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803100:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  803107:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80310b:	75 17                	jne    803124 <insert_sorted_with_merge_freeList+0x183>
  80310d:	83 ec 04             	sub    $0x4,%esp
  803110:	68 4c 45 80 00       	push   $0x80454c
  803115:	68 3f 01 00 00       	push   $0x13f
  80311a:	68 6f 45 80 00       	push   $0x80456f
  80311f:	e8 ab d5 ff ff       	call   8006cf <_panic>
  803124:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80312a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80312d:	89 10                	mov    %edx,(%eax)
  80312f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803132:	8b 00                	mov    (%eax),%eax
  803134:	85 c0                	test   %eax,%eax
  803136:	74 0d                	je     803145 <insert_sorted_with_merge_freeList+0x1a4>
  803138:	a1 48 51 80 00       	mov    0x805148,%eax
  80313d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803140:	89 50 04             	mov    %edx,0x4(%eax)
  803143:	eb 08                	jmp    80314d <insert_sorted_with_merge_freeList+0x1ac>
  803145:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803148:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80314d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803150:	a3 48 51 80 00       	mov    %eax,0x805148
  803155:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803158:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80315f:	a1 54 51 80 00       	mov    0x805154,%eax
  803164:	40                   	inc    %eax
  803165:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80316a:	e9 7a 05 00 00       	jmp    8036e9 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  80316f:	8b 45 08             	mov    0x8(%ebp),%eax
  803172:	8b 50 08             	mov    0x8(%eax),%edx
  803175:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803178:	8b 40 08             	mov    0x8(%eax),%eax
  80317b:	39 c2                	cmp    %eax,%edx
  80317d:	0f 82 14 01 00 00    	jb     803297 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  803183:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803186:	8b 50 08             	mov    0x8(%eax),%edx
  803189:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80318c:	8b 40 0c             	mov    0xc(%eax),%eax
  80318f:	01 c2                	add    %eax,%edx
  803191:	8b 45 08             	mov    0x8(%ebp),%eax
  803194:	8b 40 08             	mov    0x8(%eax),%eax
  803197:	39 c2                	cmp    %eax,%edx
  803199:	0f 85 90 00 00 00    	jne    80322f <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  80319f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031a2:	8b 50 0c             	mov    0xc(%eax),%edx
  8031a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a8:	8b 40 0c             	mov    0xc(%eax),%eax
  8031ab:	01 c2                	add    %eax,%edx
  8031ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031b0:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  8031b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  8031bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8031c7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031cb:	75 17                	jne    8031e4 <insert_sorted_with_merge_freeList+0x243>
  8031cd:	83 ec 04             	sub    $0x4,%esp
  8031d0:	68 4c 45 80 00       	push   $0x80454c
  8031d5:	68 49 01 00 00       	push   $0x149
  8031da:	68 6f 45 80 00       	push   $0x80456f
  8031df:	e8 eb d4 ff ff       	call   8006cf <_panic>
  8031e4:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8031ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ed:	89 10                	mov    %edx,(%eax)
  8031ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f2:	8b 00                	mov    (%eax),%eax
  8031f4:	85 c0                	test   %eax,%eax
  8031f6:	74 0d                	je     803205 <insert_sorted_with_merge_freeList+0x264>
  8031f8:	a1 48 51 80 00       	mov    0x805148,%eax
  8031fd:	8b 55 08             	mov    0x8(%ebp),%edx
  803200:	89 50 04             	mov    %edx,0x4(%eax)
  803203:	eb 08                	jmp    80320d <insert_sorted_with_merge_freeList+0x26c>
  803205:	8b 45 08             	mov    0x8(%ebp),%eax
  803208:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80320d:	8b 45 08             	mov    0x8(%ebp),%eax
  803210:	a3 48 51 80 00       	mov    %eax,0x805148
  803215:	8b 45 08             	mov    0x8(%ebp),%eax
  803218:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80321f:	a1 54 51 80 00       	mov    0x805154,%eax
  803224:	40                   	inc    %eax
  803225:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80322a:	e9 bb 04 00 00       	jmp    8036ea <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  80322f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803233:	75 17                	jne    80324c <insert_sorted_with_merge_freeList+0x2ab>
  803235:	83 ec 04             	sub    $0x4,%esp
  803238:	68 c0 45 80 00       	push   $0x8045c0
  80323d:	68 4c 01 00 00       	push   $0x14c
  803242:	68 6f 45 80 00       	push   $0x80456f
  803247:	e8 83 d4 ff ff       	call   8006cf <_panic>
  80324c:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803252:	8b 45 08             	mov    0x8(%ebp),%eax
  803255:	89 50 04             	mov    %edx,0x4(%eax)
  803258:	8b 45 08             	mov    0x8(%ebp),%eax
  80325b:	8b 40 04             	mov    0x4(%eax),%eax
  80325e:	85 c0                	test   %eax,%eax
  803260:	74 0c                	je     80326e <insert_sorted_with_merge_freeList+0x2cd>
  803262:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803267:	8b 55 08             	mov    0x8(%ebp),%edx
  80326a:	89 10                	mov    %edx,(%eax)
  80326c:	eb 08                	jmp    803276 <insert_sorted_with_merge_freeList+0x2d5>
  80326e:	8b 45 08             	mov    0x8(%ebp),%eax
  803271:	a3 38 51 80 00       	mov    %eax,0x805138
  803276:	8b 45 08             	mov    0x8(%ebp),%eax
  803279:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80327e:	8b 45 08             	mov    0x8(%ebp),%eax
  803281:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803287:	a1 44 51 80 00       	mov    0x805144,%eax
  80328c:	40                   	inc    %eax
  80328d:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803292:	e9 53 04 00 00       	jmp    8036ea <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803297:	a1 38 51 80 00       	mov    0x805138,%eax
  80329c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80329f:	e9 15 04 00 00       	jmp    8036b9 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  8032a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032a7:	8b 00                	mov    (%eax),%eax
  8032a9:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  8032ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8032af:	8b 50 08             	mov    0x8(%eax),%edx
  8032b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032b5:	8b 40 08             	mov    0x8(%eax),%eax
  8032b8:	39 c2                	cmp    %eax,%edx
  8032ba:	0f 86 f1 03 00 00    	jbe    8036b1 <insert_sorted_with_merge_freeList+0x710>
  8032c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c3:	8b 50 08             	mov    0x8(%eax),%edx
  8032c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032c9:	8b 40 08             	mov    0x8(%eax),%eax
  8032cc:	39 c2                	cmp    %eax,%edx
  8032ce:	0f 83 dd 03 00 00    	jae    8036b1 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  8032d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032d7:	8b 50 08             	mov    0x8(%eax),%edx
  8032da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032dd:	8b 40 0c             	mov    0xc(%eax),%eax
  8032e0:	01 c2                	add    %eax,%edx
  8032e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e5:	8b 40 08             	mov    0x8(%eax),%eax
  8032e8:	39 c2                	cmp    %eax,%edx
  8032ea:	0f 85 b9 01 00 00    	jne    8034a9 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8032f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f3:	8b 50 08             	mov    0x8(%eax),%edx
  8032f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f9:	8b 40 0c             	mov    0xc(%eax),%eax
  8032fc:	01 c2                	add    %eax,%edx
  8032fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803301:	8b 40 08             	mov    0x8(%eax),%eax
  803304:	39 c2                	cmp    %eax,%edx
  803306:	0f 85 0d 01 00 00    	jne    803419 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  80330c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80330f:	8b 50 0c             	mov    0xc(%eax),%edx
  803312:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803315:	8b 40 0c             	mov    0xc(%eax),%eax
  803318:	01 c2                	add    %eax,%edx
  80331a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80331d:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803320:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803324:	75 17                	jne    80333d <insert_sorted_with_merge_freeList+0x39c>
  803326:	83 ec 04             	sub    $0x4,%esp
  803329:	68 18 46 80 00       	push   $0x804618
  80332e:	68 5c 01 00 00       	push   $0x15c
  803333:	68 6f 45 80 00       	push   $0x80456f
  803338:	e8 92 d3 ff ff       	call   8006cf <_panic>
  80333d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803340:	8b 00                	mov    (%eax),%eax
  803342:	85 c0                	test   %eax,%eax
  803344:	74 10                	je     803356 <insert_sorted_with_merge_freeList+0x3b5>
  803346:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803349:	8b 00                	mov    (%eax),%eax
  80334b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80334e:	8b 52 04             	mov    0x4(%edx),%edx
  803351:	89 50 04             	mov    %edx,0x4(%eax)
  803354:	eb 0b                	jmp    803361 <insert_sorted_with_merge_freeList+0x3c0>
  803356:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803359:	8b 40 04             	mov    0x4(%eax),%eax
  80335c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803361:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803364:	8b 40 04             	mov    0x4(%eax),%eax
  803367:	85 c0                	test   %eax,%eax
  803369:	74 0f                	je     80337a <insert_sorted_with_merge_freeList+0x3d9>
  80336b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80336e:	8b 40 04             	mov    0x4(%eax),%eax
  803371:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803374:	8b 12                	mov    (%edx),%edx
  803376:	89 10                	mov    %edx,(%eax)
  803378:	eb 0a                	jmp    803384 <insert_sorted_with_merge_freeList+0x3e3>
  80337a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80337d:	8b 00                	mov    (%eax),%eax
  80337f:	a3 38 51 80 00       	mov    %eax,0x805138
  803384:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803387:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80338d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803390:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803397:	a1 44 51 80 00       	mov    0x805144,%eax
  80339c:	48                   	dec    %eax
  80339d:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  8033a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033a5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  8033ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033af:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8033b6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8033ba:	75 17                	jne    8033d3 <insert_sorted_with_merge_freeList+0x432>
  8033bc:	83 ec 04             	sub    $0x4,%esp
  8033bf:	68 4c 45 80 00       	push   $0x80454c
  8033c4:	68 5f 01 00 00       	push   $0x15f
  8033c9:	68 6f 45 80 00       	push   $0x80456f
  8033ce:	e8 fc d2 ff ff       	call   8006cf <_panic>
  8033d3:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8033d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033dc:	89 10                	mov    %edx,(%eax)
  8033de:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033e1:	8b 00                	mov    (%eax),%eax
  8033e3:	85 c0                	test   %eax,%eax
  8033e5:	74 0d                	je     8033f4 <insert_sorted_with_merge_freeList+0x453>
  8033e7:	a1 48 51 80 00       	mov    0x805148,%eax
  8033ec:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8033ef:	89 50 04             	mov    %edx,0x4(%eax)
  8033f2:	eb 08                	jmp    8033fc <insert_sorted_with_merge_freeList+0x45b>
  8033f4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033f7:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8033fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033ff:	a3 48 51 80 00       	mov    %eax,0x805148
  803404:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803407:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80340e:	a1 54 51 80 00       	mov    0x805154,%eax
  803413:	40                   	inc    %eax
  803414:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803419:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80341c:	8b 50 0c             	mov    0xc(%eax),%edx
  80341f:	8b 45 08             	mov    0x8(%ebp),%eax
  803422:	8b 40 0c             	mov    0xc(%eax),%eax
  803425:	01 c2                	add    %eax,%edx
  803427:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80342a:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  80342d:	8b 45 08             	mov    0x8(%ebp),%eax
  803430:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803437:	8b 45 08             	mov    0x8(%ebp),%eax
  80343a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803441:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803445:	75 17                	jne    80345e <insert_sorted_with_merge_freeList+0x4bd>
  803447:	83 ec 04             	sub    $0x4,%esp
  80344a:	68 4c 45 80 00       	push   $0x80454c
  80344f:	68 64 01 00 00       	push   $0x164
  803454:	68 6f 45 80 00       	push   $0x80456f
  803459:	e8 71 d2 ff ff       	call   8006cf <_panic>
  80345e:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803464:	8b 45 08             	mov    0x8(%ebp),%eax
  803467:	89 10                	mov    %edx,(%eax)
  803469:	8b 45 08             	mov    0x8(%ebp),%eax
  80346c:	8b 00                	mov    (%eax),%eax
  80346e:	85 c0                	test   %eax,%eax
  803470:	74 0d                	je     80347f <insert_sorted_with_merge_freeList+0x4de>
  803472:	a1 48 51 80 00       	mov    0x805148,%eax
  803477:	8b 55 08             	mov    0x8(%ebp),%edx
  80347a:	89 50 04             	mov    %edx,0x4(%eax)
  80347d:	eb 08                	jmp    803487 <insert_sorted_with_merge_freeList+0x4e6>
  80347f:	8b 45 08             	mov    0x8(%ebp),%eax
  803482:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803487:	8b 45 08             	mov    0x8(%ebp),%eax
  80348a:	a3 48 51 80 00       	mov    %eax,0x805148
  80348f:	8b 45 08             	mov    0x8(%ebp),%eax
  803492:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803499:	a1 54 51 80 00       	mov    0x805154,%eax
  80349e:	40                   	inc    %eax
  80349f:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8034a4:	e9 41 02 00 00       	jmp    8036ea <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8034a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ac:	8b 50 08             	mov    0x8(%eax),%edx
  8034af:	8b 45 08             	mov    0x8(%ebp),%eax
  8034b2:	8b 40 0c             	mov    0xc(%eax),%eax
  8034b5:	01 c2                	add    %eax,%edx
  8034b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034ba:	8b 40 08             	mov    0x8(%eax),%eax
  8034bd:	39 c2                	cmp    %eax,%edx
  8034bf:	0f 85 7c 01 00 00    	jne    803641 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  8034c5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8034c9:	74 06                	je     8034d1 <insert_sorted_with_merge_freeList+0x530>
  8034cb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034cf:	75 17                	jne    8034e8 <insert_sorted_with_merge_freeList+0x547>
  8034d1:	83 ec 04             	sub    $0x4,%esp
  8034d4:	68 88 45 80 00       	push   $0x804588
  8034d9:	68 69 01 00 00       	push   $0x169
  8034de:	68 6f 45 80 00       	push   $0x80456f
  8034e3:	e8 e7 d1 ff ff       	call   8006cf <_panic>
  8034e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034eb:	8b 50 04             	mov    0x4(%eax),%edx
  8034ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8034f1:	89 50 04             	mov    %edx,0x4(%eax)
  8034f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8034f7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8034fa:	89 10                	mov    %edx,(%eax)
  8034fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034ff:	8b 40 04             	mov    0x4(%eax),%eax
  803502:	85 c0                	test   %eax,%eax
  803504:	74 0d                	je     803513 <insert_sorted_with_merge_freeList+0x572>
  803506:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803509:	8b 40 04             	mov    0x4(%eax),%eax
  80350c:	8b 55 08             	mov    0x8(%ebp),%edx
  80350f:	89 10                	mov    %edx,(%eax)
  803511:	eb 08                	jmp    80351b <insert_sorted_with_merge_freeList+0x57a>
  803513:	8b 45 08             	mov    0x8(%ebp),%eax
  803516:	a3 38 51 80 00       	mov    %eax,0x805138
  80351b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80351e:	8b 55 08             	mov    0x8(%ebp),%edx
  803521:	89 50 04             	mov    %edx,0x4(%eax)
  803524:	a1 44 51 80 00       	mov    0x805144,%eax
  803529:	40                   	inc    %eax
  80352a:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  80352f:	8b 45 08             	mov    0x8(%ebp),%eax
  803532:	8b 50 0c             	mov    0xc(%eax),%edx
  803535:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803538:	8b 40 0c             	mov    0xc(%eax),%eax
  80353b:	01 c2                	add    %eax,%edx
  80353d:	8b 45 08             	mov    0x8(%ebp),%eax
  803540:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803543:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803547:	75 17                	jne    803560 <insert_sorted_with_merge_freeList+0x5bf>
  803549:	83 ec 04             	sub    $0x4,%esp
  80354c:	68 18 46 80 00       	push   $0x804618
  803551:	68 6b 01 00 00       	push   $0x16b
  803556:	68 6f 45 80 00       	push   $0x80456f
  80355b:	e8 6f d1 ff ff       	call   8006cf <_panic>
  803560:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803563:	8b 00                	mov    (%eax),%eax
  803565:	85 c0                	test   %eax,%eax
  803567:	74 10                	je     803579 <insert_sorted_with_merge_freeList+0x5d8>
  803569:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80356c:	8b 00                	mov    (%eax),%eax
  80356e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803571:	8b 52 04             	mov    0x4(%edx),%edx
  803574:	89 50 04             	mov    %edx,0x4(%eax)
  803577:	eb 0b                	jmp    803584 <insert_sorted_with_merge_freeList+0x5e3>
  803579:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80357c:	8b 40 04             	mov    0x4(%eax),%eax
  80357f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803584:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803587:	8b 40 04             	mov    0x4(%eax),%eax
  80358a:	85 c0                	test   %eax,%eax
  80358c:	74 0f                	je     80359d <insert_sorted_with_merge_freeList+0x5fc>
  80358e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803591:	8b 40 04             	mov    0x4(%eax),%eax
  803594:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803597:	8b 12                	mov    (%edx),%edx
  803599:	89 10                	mov    %edx,(%eax)
  80359b:	eb 0a                	jmp    8035a7 <insert_sorted_with_merge_freeList+0x606>
  80359d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035a0:	8b 00                	mov    (%eax),%eax
  8035a2:	a3 38 51 80 00       	mov    %eax,0x805138
  8035a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035aa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035b3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035ba:	a1 44 51 80 00       	mov    0x805144,%eax
  8035bf:	48                   	dec    %eax
  8035c0:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  8035c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035c8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  8035cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035d2:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8035d9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8035dd:	75 17                	jne    8035f6 <insert_sorted_with_merge_freeList+0x655>
  8035df:	83 ec 04             	sub    $0x4,%esp
  8035e2:	68 4c 45 80 00       	push   $0x80454c
  8035e7:	68 6e 01 00 00       	push   $0x16e
  8035ec:	68 6f 45 80 00       	push   $0x80456f
  8035f1:	e8 d9 d0 ff ff       	call   8006cf <_panic>
  8035f6:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8035fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035ff:	89 10                	mov    %edx,(%eax)
  803601:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803604:	8b 00                	mov    (%eax),%eax
  803606:	85 c0                	test   %eax,%eax
  803608:	74 0d                	je     803617 <insert_sorted_with_merge_freeList+0x676>
  80360a:	a1 48 51 80 00       	mov    0x805148,%eax
  80360f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803612:	89 50 04             	mov    %edx,0x4(%eax)
  803615:	eb 08                	jmp    80361f <insert_sorted_with_merge_freeList+0x67e>
  803617:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80361a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80361f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803622:	a3 48 51 80 00       	mov    %eax,0x805148
  803627:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80362a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803631:	a1 54 51 80 00       	mov    0x805154,%eax
  803636:	40                   	inc    %eax
  803637:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  80363c:	e9 a9 00 00 00       	jmp    8036ea <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803641:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803645:	74 06                	je     80364d <insert_sorted_with_merge_freeList+0x6ac>
  803647:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80364b:	75 17                	jne    803664 <insert_sorted_with_merge_freeList+0x6c3>
  80364d:	83 ec 04             	sub    $0x4,%esp
  803650:	68 e4 45 80 00       	push   $0x8045e4
  803655:	68 73 01 00 00       	push   $0x173
  80365a:	68 6f 45 80 00       	push   $0x80456f
  80365f:	e8 6b d0 ff ff       	call   8006cf <_panic>
  803664:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803667:	8b 10                	mov    (%eax),%edx
  803669:	8b 45 08             	mov    0x8(%ebp),%eax
  80366c:	89 10                	mov    %edx,(%eax)
  80366e:	8b 45 08             	mov    0x8(%ebp),%eax
  803671:	8b 00                	mov    (%eax),%eax
  803673:	85 c0                	test   %eax,%eax
  803675:	74 0b                	je     803682 <insert_sorted_with_merge_freeList+0x6e1>
  803677:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80367a:	8b 00                	mov    (%eax),%eax
  80367c:	8b 55 08             	mov    0x8(%ebp),%edx
  80367f:	89 50 04             	mov    %edx,0x4(%eax)
  803682:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803685:	8b 55 08             	mov    0x8(%ebp),%edx
  803688:	89 10                	mov    %edx,(%eax)
  80368a:	8b 45 08             	mov    0x8(%ebp),%eax
  80368d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803690:	89 50 04             	mov    %edx,0x4(%eax)
  803693:	8b 45 08             	mov    0x8(%ebp),%eax
  803696:	8b 00                	mov    (%eax),%eax
  803698:	85 c0                	test   %eax,%eax
  80369a:	75 08                	jne    8036a4 <insert_sorted_with_merge_freeList+0x703>
  80369c:	8b 45 08             	mov    0x8(%ebp),%eax
  80369f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8036a4:	a1 44 51 80 00       	mov    0x805144,%eax
  8036a9:	40                   	inc    %eax
  8036aa:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  8036af:	eb 39                	jmp    8036ea <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8036b1:	a1 40 51 80 00       	mov    0x805140,%eax
  8036b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8036b9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036bd:	74 07                	je     8036c6 <insert_sorted_with_merge_freeList+0x725>
  8036bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036c2:	8b 00                	mov    (%eax),%eax
  8036c4:	eb 05                	jmp    8036cb <insert_sorted_with_merge_freeList+0x72a>
  8036c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8036cb:	a3 40 51 80 00       	mov    %eax,0x805140
  8036d0:	a1 40 51 80 00       	mov    0x805140,%eax
  8036d5:	85 c0                	test   %eax,%eax
  8036d7:	0f 85 c7 fb ff ff    	jne    8032a4 <insert_sorted_with_merge_freeList+0x303>
  8036dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036e1:	0f 85 bd fb ff ff    	jne    8032a4 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8036e7:	eb 01                	jmp    8036ea <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8036e9:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8036ea:	90                   	nop
  8036eb:	c9                   	leave  
  8036ec:	c3                   	ret    
  8036ed:	66 90                	xchg   %ax,%ax
  8036ef:	90                   	nop

008036f0 <__udivdi3>:
  8036f0:	55                   	push   %ebp
  8036f1:	57                   	push   %edi
  8036f2:	56                   	push   %esi
  8036f3:	53                   	push   %ebx
  8036f4:	83 ec 1c             	sub    $0x1c,%esp
  8036f7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8036fb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8036ff:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803703:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803707:	89 ca                	mov    %ecx,%edx
  803709:	89 f8                	mov    %edi,%eax
  80370b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80370f:	85 f6                	test   %esi,%esi
  803711:	75 2d                	jne    803740 <__udivdi3+0x50>
  803713:	39 cf                	cmp    %ecx,%edi
  803715:	77 65                	ja     80377c <__udivdi3+0x8c>
  803717:	89 fd                	mov    %edi,%ebp
  803719:	85 ff                	test   %edi,%edi
  80371b:	75 0b                	jne    803728 <__udivdi3+0x38>
  80371d:	b8 01 00 00 00       	mov    $0x1,%eax
  803722:	31 d2                	xor    %edx,%edx
  803724:	f7 f7                	div    %edi
  803726:	89 c5                	mov    %eax,%ebp
  803728:	31 d2                	xor    %edx,%edx
  80372a:	89 c8                	mov    %ecx,%eax
  80372c:	f7 f5                	div    %ebp
  80372e:	89 c1                	mov    %eax,%ecx
  803730:	89 d8                	mov    %ebx,%eax
  803732:	f7 f5                	div    %ebp
  803734:	89 cf                	mov    %ecx,%edi
  803736:	89 fa                	mov    %edi,%edx
  803738:	83 c4 1c             	add    $0x1c,%esp
  80373b:	5b                   	pop    %ebx
  80373c:	5e                   	pop    %esi
  80373d:	5f                   	pop    %edi
  80373e:	5d                   	pop    %ebp
  80373f:	c3                   	ret    
  803740:	39 ce                	cmp    %ecx,%esi
  803742:	77 28                	ja     80376c <__udivdi3+0x7c>
  803744:	0f bd fe             	bsr    %esi,%edi
  803747:	83 f7 1f             	xor    $0x1f,%edi
  80374a:	75 40                	jne    80378c <__udivdi3+0x9c>
  80374c:	39 ce                	cmp    %ecx,%esi
  80374e:	72 0a                	jb     80375a <__udivdi3+0x6a>
  803750:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803754:	0f 87 9e 00 00 00    	ja     8037f8 <__udivdi3+0x108>
  80375a:	b8 01 00 00 00       	mov    $0x1,%eax
  80375f:	89 fa                	mov    %edi,%edx
  803761:	83 c4 1c             	add    $0x1c,%esp
  803764:	5b                   	pop    %ebx
  803765:	5e                   	pop    %esi
  803766:	5f                   	pop    %edi
  803767:	5d                   	pop    %ebp
  803768:	c3                   	ret    
  803769:	8d 76 00             	lea    0x0(%esi),%esi
  80376c:	31 ff                	xor    %edi,%edi
  80376e:	31 c0                	xor    %eax,%eax
  803770:	89 fa                	mov    %edi,%edx
  803772:	83 c4 1c             	add    $0x1c,%esp
  803775:	5b                   	pop    %ebx
  803776:	5e                   	pop    %esi
  803777:	5f                   	pop    %edi
  803778:	5d                   	pop    %ebp
  803779:	c3                   	ret    
  80377a:	66 90                	xchg   %ax,%ax
  80377c:	89 d8                	mov    %ebx,%eax
  80377e:	f7 f7                	div    %edi
  803780:	31 ff                	xor    %edi,%edi
  803782:	89 fa                	mov    %edi,%edx
  803784:	83 c4 1c             	add    $0x1c,%esp
  803787:	5b                   	pop    %ebx
  803788:	5e                   	pop    %esi
  803789:	5f                   	pop    %edi
  80378a:	5d                   	pop    %ebp
  80378b:	c3                   	ret    
  80378c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803791:	89 eb                	mov    %ebp,%ebx
  803793:	29 fb                	sub    %edi,%ebx
  803795:	89 f9                	mov    %edi,%ecx
  803797:	d3 e6                	shl    %cl,%esi
  803799:	89 c5                	mov    %eax,%ebp
  80379b:	88 d9                	mov    %bl,%cl
  80379d:	d3 ed                	shr    %cl,%ebp
  80379f:	89 e9                	mov    %ebp,%ecx
  8037a1:	09 f1                	or     %esi,%ecx
  8037a3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8037a7:	89 f9                	mov    %edi,%ecx
  8037a9:	d3 e0                	shl    %cl,%eax
  8037ab:	89 c5                	mov    %eax,%ebp
  8037ad:	89 d6                	mov    %edx,%esi
  8037af:	88 d9                	mov    %bl,%cl
  8037b1:	d3 ee                	shr    %cl,%esi
  8037b3:	89 f9                	mov    %edi,%ecx
  8037b5:	d3 e2                	shl    %cl,%edx
  8037b7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8037bb:	88 d9                	mov    %bl,%cl
  8037bd:	d3 e8                	shr    %cl,%eax
  8037bf:	09 c2                	or     %eax,%edx
  8037c1:	89 d0                	mov    %edx,%eax
  8037c3:	89 f2                	mov    %esi,%edx
  8037c5:	f7 74 24 0c          	divl   0xc(%esp)
  8037c9:	89 d6                	mov    %edx,%esi
  8037cb:	89 c3                	mov    %eax,%ebx
  8037cd:	f7 e5                	mul    %ebp
  8037cf:	39 d6                	cmp    %edx,%esi
  8037d1:	72 19                	jb     8037ec <__udivdi3+0xfc>
  8037d3:	74 0b                	je     8037e0 <__udivdi3+0xf0>
  8037d5:	89 d8                	mov    %ebx,%eax
  8037d7:	31 ff                	xor    %edi,%edi
  8037d9:	e9 58 ff ff ff       	jmp    803736 <__udivdi3+0x46>
  8037de:	66 90                	xchg   %ax,%ax
  8037e0:	8b 54 24 08          	mov    0x8(%esp),%edx
  8037e4:	89 f9                	mov    %edi,%ecx
  8037e6:	d3 e2                	shl    %cl,%edx
  8037e8:	39 c2                	cmp    %eax,%edx
  8037ea:	73 e9                	jae    8037d5 <__udivdi3+0xe5>
  8037ec:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8037ef:	31 ff                	xor    %edi,%edi
  8037f1:	e9 40 ff ff ff       	jmp    803736 <__udivdi3+0x46>
  8037f6:	66 90                	xchg   %ax,%ax
  8037f8:	31 c0                	xor    %eax,%eax
  8037fa:	e9 37 ff ff ff       	jmp    803736 <__udivdi3+0x46>
  8037ff:	90                   	nop

00803800 <__umoddi3>:
  803800:	55                   	push   %ebp
  803801:	57                   	push   %edi
  803802:	56                   	push   %esi
  803803:	53                   	push   %ebx
  803804:	83 ec 1c             	sub    $0x1c,%esp
  803807:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80380b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80380f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803813:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803817:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80381b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80381f:	89 f3                	mov    %esi,%ebx
  803821:	89 fa                	mov    %edi,%edx
  803823:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803827:	89 34 24             	mov    %esi,(%esp)
  80382a:	85 c0                	test   %eax,%eax
  80382c:	75 1a                	jne    803848 <__umoddi3+0x48>
  80382e:	39 f7                	cmp    %esi,%edi
  803830:	0f 86 a2 00 00 00    	jbe    8038d8 <__umoddi3+0xd8>
  803836:	89 c8                	mov    %ecx,%eax
  803838:	89 f2                	mov    %esi,%edx
  80383a:	f7 f7                	div    %edi
  80383c:	89 d0                	mov    %edx,%eax
  80383e:	31 d2                	xor    %edx,%edx
  803840:	83 c4 1c             	add    $0x1c,%esp
  803843:	5b                   	pop    %ebx
  803844:	5e                   	pop    %esi
  803845:	5f                   	pop    %edi
  803846:	5d                   	pop    %ebp
  803847:	c3                   	ret    
  803848:	39 f0                	cmp    %esi,%eax
  80384a:	0f 87 ac 00 00 00    	ja     8038fc <__umoddi3+0xfc>
  803850:	0f bd e8             	bsr    %eax,%ebp
  803853:	83 f5 1f             	xor    $0x1f,%ebp
  803856:	0f 84 ac 00 00 00    	je     803908 <__umoddi3+0x108>
  80385c:	bf 20 00 00 00       	mov    $0x20,%edi
  803861:	29 ef                	sub    %ebp,%edi
  803863:	89 fe                	mov    %edi,%esi
  803865:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803869:	89 e9                	mov    %ebp,%ecx
  80386b:	d3 e0                	shl    %cl,%eax
  80386d:	89 d7                	mov    %edx,%edi
  80386f:	89 f1                	mov    %esi,%ecx
  803871:	d3 ef                	shr    %cl,%edi
  803873:	09 c7                	or     %eax,%edi
  803875:	89 e9                	mov    %ebp,%ecx
  803877:	d3 e2                	shl    %cl,%edx
  803879:	89 14 24             	mov    %edx,(%esp)
  80387c:	89 d8                	mov    %ebx,%eax
  80387e:	d3 e0                	shl    %cl,%eax
  803880:	89 c2                	mov    %eax,%edx
  803882:	8b 44 24 08          	mov    0x8(%esp),%eax
  803886:	d3 e0                	shl    %cl,%eax
  803888:	89 44 24 04          	mov    %eax,0x4(%esp)
  80388c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803890:	89 f1                	mov    %esi,%ecx
  803892:	d3 e8                	shr    %cl,%eax
  803894:	09 d0                	or     %edx,%eax
  803896:	d3 eb                	shr    %cl,%ebx
  803898:	89 da                	mov    %ebx,%edx
  80389a:	f7 f7                	div    %edi
  80389c:	89 d3                	mov    %edx,%ebx
  80389e:	f7 24 24             	mull   (%esp)
  8038a1:	89 c6                	mov    %eax,%esi
  8038a3:	89 d1                	mov    %edx,%ecx
  8038a5:	39 d3                	cmp    %edx,%ebx
  8038a7:	0f 82 87 00 00 00    	jb     803934 <__umoddi3+0x134>
  8038ad:	0f 84 91 00 00 00    	je     803944 <__umoddi3+0x144>
  8038b3:	8b 54 24 04          	mov    0x4(%esp),%edx
  8038b7:	29 f2                	sub    %esi,%edx
  8038b9:	19 cb                	sbb    %ecx,%ebx
  8038bb:	89 d8                	mov    %ebx,%eax
  8038bd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8038c1:	d3 e0                	shl    %cl,%eax
  8038c3:	89 e9                	mov    %ebp,%ecx
  8038c5:	d3 ea                	shr    %cl,%edx
  8038c7:	09 d0                	or     %edx,%eax
  8038c9:	89 e9                	mov    %ebp,%ecx
  8038cb:	d3 eb                	shr    %cl,%ebx
  8038cd:	89 da                	mov    %ebx,%edx
  8038cf:	83 c4 1c             	add    $0x1c,%esp
  8038d2:	5b                   	pop    %ebx
  8038d3:	5e                   	pop    %esi
  8038d4:	5f                   	pop    %edi
  8038d5:	5d                   	pop    %ebp
  8038d6:	c3                   	ret    
  8038d7:	90                   	nop
  8038d8:	89 fd                	mov    %edi,%ebp
  8038da:	85 ff                	test   %edi,%edi
  8038dc:	75 0b                	jne    8038e9 <__umoddi3+0xe9>
  8038de:	b8 01 00 00 00       	mov    $0x1,%eax
  8038e3:	31 d2                	xor    %edx,%edx
  8038e5:	f7 f7                	div    %edi
  8038e7:	89 c5                	mov    %eax,%ebp
  8038e9:	89 f0                	mov    %esi,%eax
  8038eb:	31 d2                	xor    %edx,%edx
  8038ed:	f7 f5                	div    %ebp
  8038ef:	89 c8                	mov    %ecx,%eax
  8038f1:	f7 f5                	div    %ebp
  8038f3:	89 d0                	mov    %edx,%eax
  8038f5:	e9 44 ff ff ff       	jmp    80383e <__umoddi3+0x3e>
  8038fa:	66 90                	xchg   %ax,%ax
  8038fc:	89 c8                	mov    %ecx,%eax
  8038fe:	89 f2                	mov    %esi,%edx
  803900:	83 c4 1c             	add    $0x1c,%esp
  803903:	5b                   	pop    %ebx
  803904:	5e                   	pop    %esi
  803905:	5f                   	pop    %edi
  803906:	5d                   	pop    %ebp
  803907:	c3                   	ret    
  803908:	3b 04 24             	cmp    (%esp),%eax
  80390b:	72 06                	jb     803913 <__umoddi3+0x113>
  80390d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803911:	77 0f                	ja     803922 <__umoddi3+0x122>
  803913:	89 f2                	mov    %esi,%edx
  803915:	29 f9                	sub    %edi,%ecx
  803917:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80391b:	89 14 24             	mov    %edx,(%esp)
  80391e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803922:	8b 44 24 04          	mov    0x4(%esp),%eax
  803926:	8b 14 24             	mov    (%esp),%edx
  803929:	83 c4 1c             	add    $0x1c,%esp
  80392c:	5b                   	pop    %ebx
  80392d:	5e                   	pop    %esi
  80392e:	5f                   	pop    %edi
  80392f:	5d                   	pop    %ebp
  803930:	c3                   	ret    
  803931:	8d 76 00             	lea    0x0(%esi),%esi
  803934:	2b 04 24             	sub    (%esp),%eax
  803937:	19 fa                	sbb    %edi,%edx
  803939:	89 d1                	mov    %edx,%ecx
  80393b:	89 c6                	mov    %eax,%esi
  80393d:	e9 71 ff ff ff       	jmp    8038b3 <__umoddi3+0xb3>
  803942:	66 90                	xchg   %ax,%ax
  803944:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803948:	72 ea                	jb     803934 <__umoddi3+0x134>
  80394a:	89 d9                	mov    %ebx,%ecx
  80394c:	e9 62 ff ff ff       	jmp    8038b3 <__umoddi3+0xb3>
