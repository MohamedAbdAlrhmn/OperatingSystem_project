
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
  80008d:	68 60 3b 80 00       	push   $0x803b60
  800092:	6a 12                	push   $0x12
  800094:	68 7c 3b 80 00       	push   $0x803b7c
  800099:	e8 31 06 00 00       	call   8006cf <_panic>
	}

	cprintf("************************************************\n");
  80009e:	83 ec 0c             	sub    $0xc,%esp
  8000a1:	68 94 3b 80 00       	push   $0x803b94
  8000a6:	e8 d8 08 00 00       	call   800983 <cprintf>
  8000ab:	83 c4 10             	add    $0x10,%esp
	cprintf("MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  8000ae:	83 ec 0c             	sub    $0xc,%esp
  8000b1:	68 c8 3b 80 00       	push   $0x803bc8
  8000b6:	e8 c8 08 00 00       	call   800983 <cprintf>
  8000bb:	83 c4 10             	add    $0x10,%esp
	cprintf("************************************************\n\n\n");
  8000be:	83 ec 0c             	sub    $0xc,%esp
  8000c1:	68 24 3c 80 00       	push   $0x803c24
  8000c6:	e8 b8 08 00 00       	call   800983 <cprintf>
  8000cb:	83 c4 10             	add    $0x10,%esp

	int Mega = 1024*1024;
  8000ce:	c7 45 ec 00 00 10 00 	movl   $0x100000,-0x14(%ebp)
	int kilo = 1024;
  8000d5:	c7 45 e8 00 04 00 00 	movl   $0x400,-0x18(%ebp)
	int envID = sys_getenvid();
  8000dc:	e8 0e 1f 00 00       	call   801fef <sys_getenvid>
  8000e1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	cprintf("STEP A: checking free of a shared object ... \n");
  8000e4:	83 ec 0c             	sub    $0xc,%esp
  8000e7:	68 58 3c 80 00       	push   $0x803c58
  8000ec:	e8 92 08 00 00       	call   800983 <cprintf>
  8000f1:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x;
		int freeFrames = sys_calculate_free_frames() ;
  8000f4:	e8 2f 1c 00 00       	call   801d28 <sys_calculate_free_frames>
  8000f9:	89 45 e0             	mov    %eax,-0x20(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8000fc:	83 ec 04             	sub    $0x4,%esp
  8000ff:	6a 01                	push   $0x1
  800101:	68 00 10 00 00       	push   $0x1000
  800106:	68 87 3c 80 00       	push   $0x803c87
  80010b:	e8 46 19 00 00       	call   801a56 <smalloc>
  800110:	83 c4 10             	add    $0x10,%esp
  800113:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (x != (uint32*)USER_HEAP_START) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  800116:	81 7d dc 00 00 00 80 	cmpl   $0x80000000,-0x24(%ebp)
  80011d:	74 14                	je     800133 <_main+0xfb>
  80011f:	83 ec 04             	sub    $0x4,%esp
  800122:	68 8c 3c 80 00       	push   $0x803c8c
  800127:	6a 21                	push   $0x21
  800129:	68 7c 3b 80 00       	push   $0x803b7c
  80012e:	e8 9c 05 00 00       	call   8006cf <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800133:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800136:	e8 ed 1b 00 00       	call   801d28 <sys_calculate_free_frames>
  80013b:	29 c3                	sub    %eax,%ebx
  80013d:	89 d8                	mov    %ebx,%eax
  80013f:	83 f8 04             	cmp    $0x4,%eax
  800142:	74 14                	je     800158 <_main+0x120>
  800144:	83 ec 04             	sub    $0x4,%esp
  800147:	68 f8 3c 80 00       	push   $0x803cf8
  80014c:	6a 22                	push   $0x22
  80014e:	68 7c 3b 80 00       	push   $0x803b7c
  800153:	e8 77 05 00 00       	call   8006cf <_panic>

		sfree(x);
  800158:	83 ec 0c             	sub    $0xc,%esp
  80015b:	ff 75 dc             	pushl  -0x24(%ebp)
  80015e:	e8 65 1a 00 00       	call   801bc8 <sfree>
  800163:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) ==  0+0+2) panic("Wrong free: make sure that you free the shared object by calling free_share_object()");
  800166:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800169:	e8 ba 1b 00 00       	call   801d28 <sys_calculate_free_frames>
  80016e:	29 c3                	sub    %eax,%ebx
  800170:	89 d8                	mov    %ebx,%eax
  800172:	83 f8 02             	cmp    $0x2,%eax
  800175:	75 14                	jne    80018b <_main+0x153>
  800177:	83 ec 04             	sub    $0x4,%esp
  80017a:	68 78 3d 80 00       	push   $0x803d78
  80017f:	6a 25                	push   $0x25
  800181:	68 7c 3b 80 00       	push   $0x803b7c
  800186:	e8 44 05 00 00       	call   8006cf <_panic>
		else if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong free: revise your freeSharedObject logic");
  80018b:	e8 98 1b 00 00       	call   801d28 <sys_calculate_free_frames>
  800190:	89 c2                	mov    %eax,%edx
  800192:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800195:	39 c2                	cmp    %eax,%edx
  800197:	74 14                	je     8001ad <_main+0x175>
  800199:	83 ec 04             	sub    $0x4,%esp
  80019c:	68 d0 3d 80 00       	push   $0x803dd0
  8001a1:	6a 26                	push   $0x26
  8001a3:	68 7c 3b 80 00       	push   $0x803b7c
  8001a8:	e8 22 05 00 00       	call   8006cf <_panic>
	}
	cprintf("Step A completed successfully!!\n\n\n");
  8001ad:	83 ec 0c             	sub    $0xc,%esp
  8001b0:	68 00 3e 80 00       	push   $0x803e00
  8001b5:	e8 c9 07 00 00       	call   800983 <cprintf>
  8001ba:	83 c4 10             	add    $0x10,%esp


	cprintf("STEP B: checking free of 2 shared objects ... \n");
  8001bd:	83 ec 0c             	sub    $0xc,%esp
  8001c0:	68 24 3e 80 00       	push   $0x803e24
  8001c5:	e8 b9 07 00 00       	call   800983 <cprintf>
  8001ca:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x, *z ;
		int freeFrames = sys_calculate_free_frames() ;
  8001cd:	e8 56 1b 00 00       	call   801d28 <sys_calculate_free_frames>
  8001d2:	89 45 d8             	mov    %eax,-0x28(%ebp)
		z = smalloc("z", PAGE_SIZE, 1);
  8001d5:	83 ec 04             	sub    $0x4,%esp
  8001d8:	6a 01                	push   $0x1
  8001da:	68 00 10 00 00       	push   $0x1000
  8001df:	68 54 3e 80 00       	push   $0x803e54
  8001e4:	e8 6d 18 00 00       	call   801a56 <smalloc>
  8001e9:	83 c4 10             	add    $0x10,%esp
  8001ec:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8001ef:	83 ec 04             	sub    $0x4,%esp
  8001f2:	6a 01                	push   $0x1
  8001f4:	68 00 10 00 00       	push   $0x1000
  8001f9:	68 87 3c 80 00       	push   $0x803c87
  8001fe:	e8 53 18 00 00       	call   801a56 <smalloc>
  800203:	83 c4 10             	add    $0x10,%esp
  800206:	89 45 d0             	mov    %eax,-0x30(%ebp)

		if(x == NULL) panic("Wrong free: make sure that you free the shared object by calling free_share_object()");
  800209:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80020d:	75 14                	jne    800223 <_main+0x1eb>
  80020f:	83 ec 04             	sub    $0x4,%esp
  800212:	68 78 3d 80 00       	push   $0x803d78
  800217:	6a 32                	push   $0x32
  800219:	68 7c 3b 80 00       	push   $0x803b7c
  80021e:	e8 ac 04 00 00       	call   8006cf <_panic>

		if ((freeFrames - sys_calculate_free_frames()) !=  2+1+4) panic("Wrong previous free: make sure that you correctly free shared object before (Step A)");
  800223:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800226:	e8 fd 1a 00 00       	call   801d28 <sys_calculate_free_frames>
  80022b:	29 c3                	sub    %eax,%ebx
  80022d:	89 d8                	mov    %ebx,%eax
  80022f:	83 f8 07             	cmp    $0x7,%eax
  800232:	74 14                	je     800248 <_main+0x210>
  800234:	83 ec 04             	sub    $0x4,%esp
  800237:	68 58 3e 80 00       	push   $0x803e58
  80023c:	6a 34                	push   $0x34
  80023e:	68 7c 3b 80 00       	push   $0x803b7c
  800243:	e8 87 04 00 00       	call   8006cf <_panic>

		sfree(z);
  800248:	83 ec 0c             	sub    $0xc,%esp
  80024b:	ff 75 d4             	pushl  -0x2c(%ebp)
  80024e:	e8 75 19 00 00       	call   801bc8 <sfree>
  800253:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong free: check your logic");
  800256:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800259:	e8 ca 1a 00 00       	call   801d28 <sys_calculate_free_frames>
  80025e:	29 c3                	sub    %eax,%ebx
  800260:	89 d8                	mov    %ebx,%eax
  800262:	83 f8 04             	cmp    $0x4,%eax
  800265:	74 14                	je     80027b <_main+0x243>
  800267:	83 ec 04             	sub    $0x4,%esp
  80026a:	68 ad 3e 80 00       	push   $0x803ead
  80026f:	6a 37                	push   $0x37
  800271:	68 7c 3b 80 00       	push   $0x803b7c
  800276:	e8 54 04 00 00       	call   8006cf <_panic>

		sfree(x);
  80027b:	83 ec 0c             	sub    $0xc,%esp
  80027e:	ff 75 d0             	pushl  -0x30(%ebp)
  800281:	e8 42 19 00 00       	call   801bc8 <sfree>
  800286:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong free: check your logic");
  800289:	e8 9a 1a 00 00       	call   801d28 <sys_calculate_free_frames>
  80028e:	89 c2                	mov    %eax,%edx
  800290:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800293:	39 c2                	cmp    %eax,%edx
  800295:	74 14                	je     8002ab <_main+0x273>
  800297:	83 ec 04             	sub    $0x4,%esp
  80029a:	68 ad 3e 80 00       	push   $0x803ead
  80029f:	6a 3a                	push   $0x3a
  8002a1:	68 7c 3b 80 00       	push   $0x803b7c
  8002a6:	e8 24 04 00 00       	call   8006cf <_panic>

	}
	cprintf("Step B completed successfully!!\n\n\n");
  8002ab:	83 ec 0c             	sub    $0xc,%esp
  8002ae:	68 cc 3e 80 00       	push   $0x803ecc
  8002b3:	e8 cb 06 00 00       	call   800983 <cprintf>
  8002b8:	83 c4 10             	add    $0x10,%esp

	cprintf("STEP C: checking range of loop during free... \n");
  8002bb:	83 ec 0c             	sub    $0xc,%esp
  8002be:	68 f0 3e 80 00       	push   $0x803ef0
  8002c3:	e8 bb 06 00 00       	call   800983 <cprintf>
  8002c8:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *w, *u;
		int freeFrames = sys_calculate_free_frames() ;
  8002cb:	e8 58 1a 00 00       	call   801d28 <sys_calculate_free_frames>
  8002d0:	89 45 cc             	mov    %eax,-0x34(%ebp)
		w = smalloc("w", 3 * PAGE_SIZE+1, 1);
  8002d3:	83 ec 04             	sub    $0x4,%esp
  8002d6:	6a 01                	push   $0x1
  8002d8:	68 01 30 00 00       	push   $0x3001
  8002dd:	68 20 3f 80 00       	push   $0x803f20
  8002e2:	e8 6f 17 00 00       	call   801a56 <smalloc>
  8002e7:	83 c4 10             	add    $0x10,%esp
  8002ea:	89 45 c8             	mov    %eax,-0x38(%ebp)
		u = smalloc("u", PAGE_SIZE, 1);
  8002ed:	83 ec 04             	sub    $0x4,%esp
  8002f0:	6a 01                	push   $0x1
  8002f2:	68 00 10 00 00       	push   $0x1000
  8002f7:	68 22 3f 80 00       	push   $0x803f22
  8002fc:	e8 55 17 00 00       	call   801a56 <smalloc>
  800301:	83 c4 10             	add    $0x10,%esp
  800304:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		if ((freeFrames - sys_calculate_free_frames()) != 5+1+4) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800307:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  80030a:	e8 19 1a 00 00       	call   801d28 <sys_calculate_free_frames>
  80030f:	29 c3                	sub    %eax,%ebx
  800311:	89 d8                	mov    %ebx,%eax
  800313:	83 f8 0a             	cmp    $0xa,%eax
  800316:	74 14                	je     80032c <_main+0x2f4>
  800318:	83 ec 04             	sub    $0x4,%esp
  80031b:	68 f8 3c 80 00       	push   $0x803cf8
  800320:	6a 46                	push   $0x46
  800322:	68 7c 3b 80 00       	push   $0x803b7c
  800327:	e8 a3 03 00 00       	call   8006cf <_panic>

		sfree(w);
  80032c:	83 ec 0c             	sub    $0xc,%esp
  80032f:	ff 75 c8             	pushl  -0x38(%ebp)
  800332:	e8 91 18 00 00       	call   801bc8 <sfree>
  800337:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong free: check your logic");
  80033a:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  80033d:	e8 e6 19 00 00       	call   801d28 <sys_calculate_free_frames>
  800342:	29 c3                	sub    %eax,%ebx
  800344:	89 d8                	mov    %ebx,%eax
  800346:	83 f8 04             	cmp    $0x4,%eax
  800349:	74 14                	je     80035f <_main+0x327>
  80034b:	83 ec 04             	sub    $0x4,%esp
  80034e:	68 ad 3e 80 00       	push   $0x803ead
  800353:	6a 49                	push   $0x49
  800355:	68 7c 3b 80 00       	push   $0x803b7c
  80035a:	e8 70 03 00 00       	call   8006cf <_panic>

		uint32 *o;
		o = smalloc("o", 2 * PAGE_SIZE-1,1);
  80035f:	83 ec 04             	sub    $0x4,%esp
  800362:	6a 01                	push   $0x1
  800364:	68 ff 1f 00 00       	push   $0x1fff
  800369:	68 24 3f 80 00       	push   $0x803f24
  80036e:	e8 e3 16 00 00       	call   801a56 <smalloc>
  800373:	83 c4 10             	add    $0x10,%esp
  800376:	89 45 c0             	mov    %eax,-0x40(%ebp)

		if ((freeFrames - sys_calculate_free_frames()) != 3+1+4) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800379:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  80037c:	e8 a7 19 00 00       	call   801d28 <sys_calculate_free_frames>
  800381:	29 c3                	sub    %eax,%ebx
  800383:	89 d8                	mov    %ebx,%eax
  800385:	83 f8 08             	cmp    $0x8,%eax
  800388:	74 14                	je     80039e <_main+0x366>
  80038a:	83 ec 04             	sub    $0x4,%esp
  80038d:	68 f8 3c 80 00       	push   $0x803cf8
  800392:	6a 4e                	push   $0x4e
  800394:	68 7c 3b 80 00       	push   $0x803b7c
  800399:	e8 31 03 00 00       	call   8006cf <_panic>

		sfree(o);
  80039e:	83 ec 0c             	sub    $0xc,%esp
  8003a1:	ff 75 c0             	pushl  -0x40(%ebp)
  8003a4:	e8 1f 18 00 00       	call   801bc8 <sfree>
  8003a9:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong free: check your logic");
  8003ac:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8003af:	e8 74 19 00 00       	call   801d28 <sys_calculate_free_frames>
  8003b4:	29 c3                	sub    %eax,%ebx
  8003b6:	89 d8                	mov    %ebx,%eax
  8003b8:	83 f8 04             	cmp    $0x4,%eax
  8003bb:	74 14                	je     8003d1 <_main+0x399>
  8003bd:	83 ec 04             	sub    $0x4,%esp
  8003c0:	68 ad 3e 80 00       	push   $0x803ead
  8003c5:	6a 51                	push   $0x51
  8003c7:	68 7c 3b 80 00       	push   $0x803b7c
  8003cc:	e8 fe 02 00 00       	call   8006cf <_panic>

		sfree(u);
  8003d1:	83 ec 0c             	sub    $0xc,%esp
  8003d4:	ff 75 c4             	pushl  -0x3c(%ebp)
  8003d7:	e8 ec 17 00 00       	call   801bc8 <sfree>
  8003dc:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong free: check your logic");
  8003df:	e8 44 19 00 00       	call   801d28 <sys_calculate_free_frames>
  8003e4:	89 c2                	mov    %eax,%edx
  8003e6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8003e9:	39 c2                	cmp    %eax,%edx
  8003eb:	74 14                	je     800401 <_main+0x3c9>
  8003ed:	83 ec 04             	sub    $0x4,%esp
  8003f0:	68 ad 3e 80 00       	push   $0x803ead
  8003f5:	6a 54                	push   $0x54
  8003f7:	68 7c 3b 80 00       	push   $0x803b7c
  8003fc:	e8 ce 02 00 00       	call   8006cf <_panic>


		//Checking boundaries of page tables
		freeFrames = sys_calculate_free_frames() ;
  800401:	e8 22 19 00 00       	call   801d28 <sys_calculate_free_frames>
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
  80041b:	68 20 3f 80 00       	push   $0x803f20
  800420:	e8 31 16 00 00       	call   801a56 <smalloc>
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
  800441:	68 22 3f 80 00       	push   $0x803f22
  800446:	e8 0b 16 00 00       	call   801a56 <smalloc>
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
  800463:	68 24 3f 80 00       	push   $0x803f24
  800468:	e8 e9 15 00 00       	call   801a56 <smalloc>
  80046d:	83 c4 10             	add    $0x10,%esp
  800470:	89 45 c0             	mov    %eax,-0x40(%ebp)

		if ((freeFrames - sys_calculate_free_frames()) != 3073+4+7) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800473:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800476:	e8 ad 18 00 00       	call   801d28 <sys_calculate_free_frames>
  80047b:	29 c3                	sub    %eax,%ebx
  80047d:	89 d8                	mov    %ebx,%eax
  80047f:	3d 0c 0c 00 00       	cmp    $0xc0c,%eax
  800484:	74 14                	je     80049a <_main+0x462>
  800486:	83 ec 04             	sub    $0x4,%esp
  800489:	68 f8 3c 80 00       	push   $0x803cf8
  80048e:	6a 5d                	push   $0x5d
  800490:	68 7c 3b 80 00       	push   $0x803b7c
  800495:	e8 35 02 00 00       	call   8006cf <_panic>

		sfree(o);
  80049a:	83 ec 0c             	sub    $0xc,%esp
  80049d:	ff 75 c0             	pushl  -0x40(%ebp)
  8004a0:	e8 23 17 00 00       	call   801bc8 <sfree>
  8004a5:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  2560+3+5) panic("Wrong free: check your logic");
  8004a8:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8004ab:	e8 78 18 00 00       	call   801d28 <sys_calculate_free_frames>
  8004b0:	29 c3                	sub    %eax,%ebx
  8004b2:	89 d8                	mov    %ebx,%eax
  8004b4:	3d 08 0a 00 00       	cmp    $0xa08,%eax
  8004b9:	74 14                	je     8004cf <_main+0x497>
  8004bb:	83 ec 04             	sub    $0x4,%esp
  8004be:	68 ad 3e 80 00       	push   $0x803ead
  8004c3:	6a 60                	push   $0x60
  8004c5:	68 7c 3b 80 00       	push   $0x803b7c
  8004ca:	e8 00 02 00 00       	call   8006cf <_panic>

		sfree(w);
  8004cf:	83 ec 0c             	sub    $0xc,%esp
  8004d2:	ff 75 c8             	pushl  -0x38(%ebp)
  8004d5:	e8 ee 16 00 00       	call   801bc8 <sfree>
  8004da:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  1792+3+3) panic("Wrong free: check your logic");
  8004dd:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8004e0:	e8 43 18 00 00       	call   801d28 <sys_calculate_free_frames>
  8004e5:	29 c3                	sub    %eax,%ebx
  8004e7:	89 d8                	mov    %ebx,%eax
  8004e9:	3d 06 07 00 00       	cmp    $0x706,%eax
  8004ee:	74 14                	je     800504 <_main+0x4cc>
  8004f0:	83 ec 04             	sub    $0x4,%esp
  8004f3:	68 ad 3e 80 00       	push   $0x803ead
  8004f8:	6a 63                	push   $0x63
  8004fa:	68 7c 3b 80 00       	push   $0x803b7c
  8004ff:	e8 cb 01 00 00       	call   8006cf <_panic>

		sfree(u);
  800504:	83 ec 0c             	sub    $0xc,%esp
  800507:	ff 75 c4             	pushl  -0x3c(%ebp)
  80050a:	e8 b9 16 00 00       	call   801bc8 <sfree>
  80050f:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong free: check your logic");
  800512:	e8 11 18 00 00       	call   801d28 <sys_calculate_free_frames>
  800517:	89 c2                	mov    %eax,%edx
  800519:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80051c:	39 c2                	cmp    %eax,%edx
  80051e:	74 14                	je     800534 <_main+0x4fc>
  800520:	83 ec 04             	sub    $0x4,%esp
  800523:	68 ad 3e 80 00       	push   $0x803ead
  800528:	6a 66                	push   $0x66
  80052a:	68 7c 3b 80 00       	push   $0x803b7c
  80052f:	e8 9b 01 00 00       	call   8006cf <_panic>
	}
	cprintf("Step C completed successfully!!\n\n\n");
  800534:	83 ec 0c             	sub    $0xc,%esp
  800537:	68 28 3f 80 00       	push   $0x803f28
  80053c:	e8 42 04 00 00       	call   800983 <cprintf>
  800541:	83 c4 10             	add    $0x10,%esp

	cprintf("Congratulations!! Test of freeSharedObjects [4] completed successfully!!\n\n\n");
  800544:	83 ec 0c             	sub    $0xc,%esp
  800547:	68 4c 3f 80 00       	push   $0x803f4c
  80054c:	e8 32 04 00 00       	call   800983 <cprintf>
  800551:	83 c4 10             	add    $0x10,%esp

	int32 parentenvID = sys_getparentenvid();
  800554:	e8 c8 1a 00 00       	call   802021 <sys_getparentenvid>
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
  80056c:	68 98 3f 80 00       	push   $0x803f98
  800571:	ff 75 bc             	pushl  -0x44(%ebp)
  800574:	e8 8b 15 00 00       	call   801b04 <sget>
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
  800599:	e8 6a 1a 00 00       	call   802008 <sys_getenvindex>
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
  800604:	e8 0c 18 00 00       	call   801e15 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800609:	83 ec 0c             	sub    $0xc,%esp
  80060c:	68 c0 3f 80 00       	push   $0x803fc0
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
  800634:	68 e8 3f 80 00       	push   $0x803fe8
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
  800665:	68 10 40 80 00       	push   $0x804010
  80066a:	e8 14 03 00 00       	call   800983 <cprintf>
  80066f:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800672:	a1 20 50 80 00       	mov    0x805020,%eax
  800677:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80067d:	83 ec 08             	sub    $0x8,%esp
  800680:	50                   	push   %eax
  800681:	68 68 40 80 00       	push   $0x804068
  800686:	e8 f8 02 00 00       	call   800983 <cprintf>
  80068b:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80068e:	83 ec 0c             	sub    $0xc,%esp
  800691:	68 c0 3f 80 00       	push   $0x803fc0
  800696:	e8 e8 02 00 00       	call   800983 <cprintf>
  80069b:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80069e:	e8 8c 17 00 00       	call   801e2f <sys_enable_interrupt>

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
  8006b6:	e8 19 19 00 00       	call   801fd4 <sys_destroy_env>
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
  8006c7:	e8 6e 19 00 00       	call   80203a <sys_exit_env>
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
  8006f0:	68 7c 40 80 00       	push   $0x80407c
  8006f5:	e8 89 02 00 00       	call   800983 <cprintf>
  8006fa:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8006fd:	a1 00 50 80 00       	mov    0x805000,%eax
  800702:	ff 75 0c             	pushl  0xc(%ebp)
  800705:	ff 75 08             	pushl  0x8(%ebp)
  800708:	50                   	push   %eax
  800709:	68 81 40 80 00       	push   $0x804081
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
  80072d:	68 9d 40 80 00       	push   $0x80409d
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
  800759:	68 a0 40 80 00       	push   $0x8040a0
  80075e:	6a 26                	push   $0x26
  800760:	68 ec 40 80 00       	push   $0x8040ec
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
  80082b:	68 f8 40 80 00       	push   $0x8040f8
  800830:	6a 3a                	push   $0x3a
  800832:	68 ec 40 80 00       	push   $0x8040ec
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
  80089b:	68 4c 41 80 00       	push   $0x80414c
  8008a0:	6a 44                	push   $0x44
  8008a2:	68 ec 40 80 00       	push   $0x8040ec
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
  8008f5:	e8 6d 13 00 00       	call   801c67 <sys_cputs>
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
  80096c:	e8 f6 12 00 00       	call   801c67 <sys_cputs>
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
  8009b6:	e8 5a 14 00 00       	call   801e15 <sys_disable_interrupt>
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
  8009d6:	e8 54 14 00 00       	call   801e2f <sys_enable_interrupt>
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
  800a20:	e8 c7 2e 00 00       	call   8038ec <__udivdi3>
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
  800a70:	e8 87 2f 00 00       	call   8039fc <__umoddi3>
  800a75:	83 c4 10             	add    $0x10,%esp
  800a78:	05 b4 43 80 00       	add    $0x8043b4,%eax
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
  800bcb:	8b 04 85 d8 43 80 00 	mov    0x8043d8(,%eax,4),%eax
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
  800cac:	8b 34 9d 20 42 80 00 	mov    0x804220(,%ebx,4),%esi
  800cb3:	85 f6                	test   %esi,%esi
  800cb5:	75 19                	jne    800cd0 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800cb7:	53                   	push   %ebx
  800cb8:	68 c5 43 80 00       	push   $0x8043c5
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
  800cd1:	68 ce 43 80 00       	push   $0x8043ce
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
  800cfe:	be d1 43 80 00       	mov    $0x8043d1,%esi
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
  801724:	68 30 45 80 00       	push   $0x804530
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
  8017f4:	e8 b2 05 00 00       	call   801dab <sys_allocate_chunk>
  8017f9:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8017fc:	a1 20 51 80 00       	mov    0x805120,%eax
  801801:	83 ec 0c             	sub    $0xc,%esp
  801804:	50                   	push   %eax
  801805:	e8 27 0c 00 00       	call   802431 <initialize_MemBlocksList>
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
  801832:	68 55 45 80 00       	push   $0x804555
  801837:	6a 33                	push   $0x33
  801839:	68 73 45 80 00       	push   $0x804573
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
  8018b1:	68 80 45 80 00       	push   $0x804580
  8018b6:	6a 34                	push   $0x34
  8018b8:	68 73 45 80 00       	push   $0x804573
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
  801949:	e8 2b 08 00 00       	call   802179 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80194e:	85 c0                	test   %eax,%eax
  801950:	74 11                	je     801963 <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  801952:	83 ec 0c             	sub    $0xc,%esp
  801955:	ff 75 e8             	pushl  -0x18(%ebp)
  801958:	e8 96 0e 00 00       	call   8027f3 <alloc_block_FF>
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
  80196f:	e8 f2 0b 00 00       	call   802566 <insert_sorted_allocList>
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
  801989:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	struct MemBlock * free_block=find_block(&AllocMemBlocksList,(uint32)virtual_address);
  80198c:	8b 45 08             	mov    0x8(%ebp),%eax
  80198f:	83 ec 08             	sub    $0x8,%esp
  801992:	50                   	push   %eax
  801993:	68 40 50 80 00       	push   $0x805040
  801998:	e8 71 0b 00 00       	call   80250e <find_block>
  80199d:	83 c4 10             	add    $0x10,%esp
  8019a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(free_block!=NULL)
  8019a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8019a7:	0f 84 a6 00 00 00    	je     801a53 <free+0xcd>
	{
		sys_free_user_mem(free_block->sva,free_block->size);
  8019ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019b0:	8b 50 0c             	mov    0xc(%eax),%edx
  8019b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019b6:	8b 40 08             	mov    0x8(%eax),%eax
  8019b9:	83 ec 08             	sub    $0x8,%esp
  8019bc:	52                   	push   %edx
  8019bd:	50                   	push   %eax
  8019be:	e8 b0 03 00 00       	call   801d73 <sys_free_user_mem>
  8019c3:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,free_block);
  8019c6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8019ca:	75 14                	jne    8019e0 <free+0x5a>
  8019cc:	83 ec 04             	sub    $0x4,%esp
  8019cf:	68 55 45 80 00       	push   $0x804555
  8019d4:	6a 74                	push   $0x74
  8019d6:	68 73 45 80 00       	push   $0x804573
  8019db:	e8 ef ec ff ff       	call   8006cf <_panic>
  8019e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019e3:	8b 00                	mov    (%eax),%eax
  8019e5:	85 c0                	test   %eax,%eax
  8019e7:	74 10                	je     8019f9 <free+0x73>
  8019e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019ec:	8b 00                	mov    (%eax),%eax
  8019ee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019f1:	8b 52 04             	mov    0x4(%edx),%edx
  8019f4:	89 50 04             	mov    %edx,0x4(%eax)
  8019f7:	eb 0b                	jmp    801a04 <free+0x7e>
  8019f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019fc:	8b 40 04             	mov    0x4(%eax),%eax
  8019ff:	a3 44 50 80 00       	mov    %eax,0x805044
  801a04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a07:	8b 40 04             	mov    0x4(%eax),%eax
  801a0a:	85 c0                	test   %eax,%eax
  801a0c:	74 0f                	je     801a1d <free+0x97>
  801a0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a11:	8b 40 04             	mov    0x4(%eax),%eax
  801a14:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a17:	8b 12                	mov    (%edx),%edx
  801a19:	89 10                	mov    %edx,(%eax)
  801a1b:	eb 0a                	jmp    801a27 <free+0xa1>
  801a1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a20:	8b 00                	mov    (%eax),%eax
  801a22:	a3 40 50 80 00       	mov    %eax,0x805040
  801a27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a2a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801a30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a33:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801a3a:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801a3f:	48                   	dec    %eax
  801a40:	a3 4c 50 80 00       	mov    %eax,0x80504c
		insert_sorted_with_merge_freeList(free_block);
  801a45:	83 ec 0c             	sub    $0xc,%esp
  801a48:	ff 75 f4             	pushl  -0xc(%ebp)
  801a4b:	e8 4e 17 00 00       	call   80319e <insert_sorted_with_merge_freeList>
  801a50:	83 c4 10             	add    $0x10,%esp
	}

	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  801a53:	90                   	nop
  801a54:	c9                   	leave  
  801a55:	c3                   	ret    

00801a56 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801a56:	55                   	push   %ebp
  801a57:	89 e5                	mov    %esp,%ebp
  801a59:	83 ec 38             	sub    $0x38,%esp
  801a5c:	8b 45 10             	mov    0x10(%ebp),%eax
  801a5f:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801a62:	e8 a6 fc ff ff       	call   80170d <InitializeUHeap>
	if (size == 0) return NULL ;
  801a67:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801a6b:	75 0a                	jne    801a77 <smalloc+0x21>
  801a6d:	b8 00 00 00 00       	mov    $0x0,%eax
  801a72:	e9 8b 00 00 00       	jmp    801b02 <smalloc+0xac>
	//	   Else, return NULL

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801a77:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801a7e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a81:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a84:	01 d0                	add    %edx,%eax
  801a86:	48                   	dec    %eax
  801a87:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801a8a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a8d:	ba 00 00 00 00       	mov    $0x0,%edx
  801a92:	f7 75 f0             	divl   -0x10(%ebp)
  801a95:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a98:	29 d0                	sub    %edx,%eax
  801a9a:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801a9d:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801aa4:	e8 d0 06 00 00       	call   802179 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801aa9:	85 c0                	test   %eax,%eax
  801aab:	74 11                	je     801abe <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  801aad:	83 ec 0c             	sub    $0xc,%esp
  801ab0:	ff 75 e8             	pushl  -0x18(%ebp)
  801ab3:	e8 3b 0d 00 00       	call   8027f3 <alloc_block_FF>
  801ab8:	83 c4 10             	add    $0x10,%esp
  801abb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(mem_block != NULL)
  801abe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ac2:	74 39                	je     801afd <smalloc+0xa7>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801ac4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ac7:	8b 40 08             	mov    0x8(%eax),%eax
  801aca:	89 c2                	mov    %eax,%edx
  801acc:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801ad0:	52                   	push   %edx
  801ad1:	50                   	push   %eax
  801ad2:	ff 75 0c             	pushl  0xc(%ebp)
  801ad5:	ff 75 08             	pushl  0x8(%ebp)
  801ad8:	e8 21 04 00 00       	call   801efe <sys_createSharedObject>
  801add:	83 c4 10             	add    $0x10,%esp
  801ae0:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  801ae3:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  801ae7:	74 14                	je     801afd <smalloc+0xa7>
  801ae9:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  801aed:	74 0e                	je     801afd <smalloc+0xa7>
  801aef:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  801af3:	74 08                	je     801afd <smalloc+0xa7>
			return (void*) mem_block->sva;
  801af5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801af8:	8b 40 08             	mov    0x8(%eax),%eax
  801afb:	eb 05                	jmp    801b02 <smalloc+0xac>
	}
	return NULL;
  801afd:	b8 00 00 00 00       	mov    $0x0,%eax

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801b02:	c9                   	leave  
  801b03:	c3                   	ret    

00801b04 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801b04:	55                   	push   %ebp
  801b05:	89 e5                	mov    %esp,%ebp
  801b07:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801b0a:	e8 fe fb ff ff       	call   80170d <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801b0f:	83 ec 08             	sub    $0x8,%esp
  801b12:	ff 75 0c             	pushl  0xc(%ebp)
  801b15:	ff 75 08             	pushl  0x8(%ebp)
  801b18:	e8 0b 04 00 00       	call   801f28 <sys_getSizeOfSharedObject>
  801b1d:	83 c4 10             	add    $0x10,%esp
  801b20:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size != E_SHARED_MEM_NOT_EXISTS)
  801b23:	83 7d f0 f0          	cmpl   $0xfffffff0,-0x10(%ebp)
  801b27:	74 76                	je     801b9f <sget+0x9b>
	{
		uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801b29:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801b30:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b33:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b36:	01 d0                	add    %edx,%eax
  801b38:	48                   	dec    %eax
  801b39:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801b3c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b3f:	ba 00 00 00 00       	mov    $0x0,%edx
  801b44:	f7 75 ec             	divl   -0x14(%ebp)
  801b47:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b4a:	29 d0                	sub    %edx,%eax
  801b4c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		struct MemBlock * mem_block = NULL;
  801b4f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801b56:	e8 1e 06 00 00       	call   802179 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801b5b:	85 c0                	test   %eax,%eax
  801b5d:	74 11                	je     801b70 <sget+0x6c>
			mem_block = alloc_block_FF(allocate_space);
  801b5f:	83 ec 0c             	sub    $0xc,%esp
  801b62:	ff 75 e4             	pushl  -0x1c(%ebp)
  801b65:	e8 89 0c 00 00       	call   8027f3 <alloc_block_FF>
  801b6a:	83 c4 10             	add    $0x10,%esp
  801b6d:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(mem_block != NULL)
  801b70:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801b74:	74 29                	je     801b9f <sget+0x9b>
		{
			uint32 shared_object_id = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)mem_block->sva);
  801b76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b79:	8b 40 08             	mov    0x8(%eax),%eax
  801b7c:	83 ec 04             	sub    $0x4,%esp
  801b7f:	50                   	push   %eax
  801b80:	ff 75 0c             	pushl  0xc(%ebp)
  801b83:	ff 75 08             	pushl  0x8(%ebp)
  801b86:	e8 ba 03 00 00       	call   801f45 <sys_getSharedObject>
  801b8b:	83 c4 10             	add    $0x10,%esp
  801b8e:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (shared_object_id != E_SHARED_MEM_NOT_EXISTS)
  801b91:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%ebp)
  801b95:	74 08                	je     801b9f <sget+0x9b>
				return (void *)mem_block->sva;
  801b97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b9a:	8b 40 08             	mov    0x8(%eax),%eax
  801b9d:	eb 05                	jmp    801ba4 <sget+0xa0>
		}
	}
	return NULL;
  801b9f:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801ba4:	c9                   	leave  
  801ba5:	c3                   	ret    

00801ba6 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801ba6:	55                   	push   %ebp
  801ba7:	89 e5                	mov    %esp,%ebp
  801ba9:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801bac:	e8 5c fb ff ff       	call   80170d <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801bb1:	83 ec 04             	sub    $0x4,%esp
  801bb4:	68 a4 45 80 00       	push   $0x8045a4
  801bb9:	68 f7 00 00 00       	push   $0xf7
  801bbe:	68 73 45 80 00       	push   $0x804573
  801bc3:	e8 07 eb ff ff       	call   8006cf <_panic>

00801bc8 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801bc8:	55                   	push   %ebp
  801bc9:	89 e5                	mov    %esp,%ebp
  801bcb:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801bce:	83 ec 04             	sub    $0x4,%esp
  801bd1:	68 cc 45 80 00       	push   $0x8045cc
  801bd6:	68 0b 01 00 00       	push   $0x10b
  801bdb:	68 73 45 80 00       	push   $0x804573
  801be0:	e8 ea ea ff ff       	call   8006cf <_panic>

00801be5 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801be5:	55                   	push   %ebp
  801be6:	89 e5                	mov    %esp,%ebp
  801be8:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801beb:	83 ec 04             	sub    $0x4,%esp
  801bee:	68 f0 45 80 00       	push   $0x8045f0
  801bf3:	68 16 01 00 00       	push   $0x116
  801bf8:	68 73 45 80 00       	push   $0x804573
  801bfd:	e8 cd ea ff ff       	call   8006cf <_panic>

00801c02 <shrink>:

}
void shrink(uint32 newSize)
{
  801c02:	55                   	push   %ebp
  801c03:	89 e5                	mov    %esp,%ebp
  801c05:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801c08:	83 ec 04             	sub    $0x4,%esp
  801c0b:	68 f0 45 80 00       	push   $0x8045f0
  801c10:	68 1b 01 00 00       	push   $0x11b
  801c15:	68 73 45 80 00       	push   $0x804573
  801c1a:	e8 b0 ea ff ff       	call   8006cf <_panic>

00801c1f <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801c1f:	55                   	push   %ebp
  801c20:	89 e5                	mov    %esp,%ebp
  801c22:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801c25:	83 ec 04             	sub    $0x4,%esp
  801c28:	68 f0 45 80 00       	push   $0x8045f0
  801c2d:	68 20 01 00 00       	push   $0x120
  801c32:	68 73 45 80 00       	push   $0x804573
  801c37:	e8 93 ea ff ff       	call   8006cf <_panic>

00801c3c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801c3c:	55                   	push   %ebp
  801c3d:	89 e5                	mov    %esp,%ebp
  801c3f:	57                   	push   %edi
  801c40:	56                   	push   %esi
  801c41:	53                   	push   %ebx
  801c42:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801c45:	8b 45 08             	mov    0x8(%ebp),%eax
  801c48:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c4b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c4e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c51:	8b 7d 18             	mov    0x18(%ebp),%edi
  801c54:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801c57:	cd 30                	int    $0x30
  801c59:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801c5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801c5f:	83 c4 10             	add    $0x10,%esp
  801c62:	5b                   	pop    %ebx
  801c63:	5e                   	pop    %esi
  801c64:	5f                   	pop    %edi
  801c65:	5d                   	pop    %ebp
  801c66:	c3                   	ret    

00801c67 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801c67:	55                   	push   %ebp
  801c68:	89 e5                	mov    %esp,%ebp
  801c6a:	83 ec 04             	sub    $0x4,%esp
  801c6d:	8b 45 10             	mov    0x10(%ebp),%eax
  801c70:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801c73:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801c77:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7a:	6a 00                	push   $0x0
  801c7c:	6a 00                	push   $0x0
  801c7e:	52                   	push   %edx
  801c7f:	ff 75 0c             	pushl  0xc(%ebp)
  801c82:	50                   	push   %eax
  801c83:	6a 00                	push   $0x0
  801c85:	e8 b2 ff ff ff       	call   801c3c <syscall>
  801c8a:	83 c4 18             	add    $0x18,%esp
}
  801c8d:	90                   	nop
  801c8e:	c9                   	leave  
  801c8f:	c3                   	ret    

00801c90 <sys_cgetc>:

int
sys_cgetc(void)
{
  801c90:	55                   	push   %ebp
  801c91:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801c93:	6a 00                	push   $0x0
  801c95:	6a 00                	push   $0x0
  801c97:	6a 00                	push   $0x0
  801c99:	6a 00                	push   $0x0
  801c9b:	6a 00                	push   $0x0
  801c9d:	6a 01                	push   $0x1
  801c9f:	e8 98 ff ff ff       	call   801c3c <syscall>
  801ca4:	83 c4 18             	add    $0x18,%esp
}
  801ca7:	c9                   	leave  
  801ca8:	c3                   	ret    

00801ca9 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801ca9:	55                   	push   %ebp
  801caa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801cac:	8b 55 0c             	mov    0xc(%ebp),%edx
  801caf:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb2:	6a 00                	push   $0x0
  801cb4:	6a 00                	push   $0x0
  801cb6:	6a 00                	push   $0x0
  801cb8:	52                   	push   %edx
  801cb9:	50                   	push   %eax
  801cba:	6a 05                	push   $0x5
  801cbc:	e8 7b ff ff ff       	call   801c3c <syscall>
  801cc1:	83 c4 18             	add    $0x18,%esp
}
  801cc4:	c9                   	leave  
  801cc5:	c3                   	ret    

00801cc6 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801cc6:	55                   	push   %ebp
  801cc7:	89 e5                	mov    %esp,%ebp
  801cc9:	56                   	push   %esi
  801cca:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801ccb:	8b 75 18             	mov    0x18(%ebp),%esi
  801cce:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801cd1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801cd4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cd7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cda:	56                   	push   %esi
  801cdb:	53                   	push   %ebx
  801cdc:	51                   	push   %ecx
  801cdd:	52                   	push   %edx
  801cde:	50                   	push   %eax
  801cdf:	6a 06                	push   $0x6
  801ce1:	e8 56 ff ff ff       	call   801c3c <syscall>
  801ce6:	83 c4 18             	add    $0x18,%esp
}
  801ce9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cec:	5b                   	pop    %ebx
  801ced:	5e                   	pop    %esi
  801cee:	5d                   	pop    %ebp
  801cef:	c3                   	ret    

00801cf0 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801cf0:	55                   	push   %ebp
  801cf1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801cf3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cf6:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf9:	6a 00                	push   $0x0
  801cfb:	6a 00                	push   $0x0
  801cfd:	6a 00                	push   $0x0
  801cff:	52                   	push   %edx
  801d00:	50                   	push   %eax
  801d01:	6a 07                	push   $0x7
  801d03:	e8 34 ff ff ff       	call   801c3c <syscall>
  801d08:	83 c4 18             	add    $0x18,%esp
}
  801d0b:	c9                   	leave  
  801d0c:	c3                   	ret    

00801d0d <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801d0d:	55                   	push   %ebp
  801d0e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801d10:	6a 00                	push   $0x0
  801d12:	6a 00                	push   $0x0
  801d14:	6a 00                	push   $0x0
  801d16:	ff 75 0c             	pushl  0xc(%ebp)
  801d19:	ff 75 08             	pushl  0x8(%ebp)
  801d1c:	6a 08                	push   $0x8
  801d1e:	e8 19 ff ff ff       	call   801c3c <syscall>
  801d23:	83 c4 18             	add    $0x18,%esp
}
  801d26:	c9                   	leave  
  801d27:	c3                   	ret    

00801d28 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801d28:	55                   	push   %ebp
  801d29:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801d2b:	6a 00                	push   $0x0
  801d2d:	6a 00                	push   $0x0
  801d2f:	6a 00                	push   $0x0
  801d31:	6a 00                	push   $0x0
  801d33:	6a 00                	push   $0x0
  801d35:	6a 09                	push   $0x9
  801d37:	e8 00 ff ff ff       	call   801c3c <syscall>
  801d3c:	83 c4 18             	add    $0x18,%esp
}
  801d3f:	c9                   	leave  
  801d40:	c3                   	ret    

00801d41 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801d41:	55                   	push   %ebp
  801d42:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801d44:	6a 00                	push   $0x0
  801d46:	6a 00                	push   $0x0
  801d48:	6a 00                	push   $0x0
  801d4a:	6a 00                	push   $0x0
  801d4c:	6a 00                	push   $0x0
  801d4e:	6a 0a                	push   $0xa
  801d50:	e8 e7 fe ff ff       	call   801c3c <syscall>
  801d55:	83 c4 18             	add    $0x18,%esp
}
  801d58:	c9                   	leave  
  801d59:	c3                   	ret    

00801d5a <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801d5a:	55                   	push   %ebp
  801d5b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801d5d:	6a 00                	push   $0x0
  801d5f:	6a 00                	push   $0x0
  801d61:	6a 00                	push   $0x0
  801d63:	6a 00                	push   $0x0
  801d65:	6a 00                	push   $0x0
  801d67:	6a 0b                	push   $0xb
  801d69:	e8 ce fe ff ff       	call   801c3c <syscall>
  801d6e:	83 c4 18             	add    $0x18,%esp
}
  801d71:	c9                   	leave  
  801d72:	c3                   	ret    

00801d73 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801d73:	55                   	push   %ebp
  801d74:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801d76:	6a 00                	push   $0x0
  801d78:	6a 00                	push   $0x0
  801d7a:	6a 00                	push   $0x0
  801d7c:	ff 75 0c             	pushl  0xc(%ebp)
  801d7f:	ff 75 08             	pushl  0x8(%ebp)
  801d82:	6a 0f                	push   $0xf
  801d84:	e8 b3 fe ff ff       	call   801c3c <syscall>
  801d89:	83 c4 18             	add    $0x18,%esp
	return;
  801d8c:	90                   	nop
}
  801d8d:	c9                   	leave  
  801d8e:	c3                   	ret    

00801d8f <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801d8f:	55                   	push   %ebp
  801d90:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801d92:	6a 00                	push   $0x0
  801d94:	6a 00                	push   $0x0
  801d96:	6a 00                	push   $0x0
  801d98:	ff 75 0c             	pushl  0xc(%ebp)
  801d9b:	ff 75 08             	pushl  0x8(%ebp)
  801d9e:	6a 10                	push   $0x10
  801da0:	e8 97 fe ff ff       	call   801c3c <syscall>
  801da5:	83 c4 18             	add    $0x18,%esp
	return ;
  801da8:	90                   	nop
}
  801da9:	c9                   	leave  
  801daa:	c3                   	ret    

00801dab <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801dab:	55                   	push   %ebp
  801dac:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801dae:	6a 00                	push   $0x0
  801db0:	6a 00                	push   $0x0
  801db2:	ff 75 10             	pushl  0x10(%ebp)
  801db5:	ff 75 0c             	pushl  0xc(%ebp)
  801db8:	ff 75 08             	pushl  0x8(%ebp)
  801dbb:	6a 11                	push   $0x11
  801dbd:	e8 7a fe ff ff       	call   801c3c <syscall>
  801dc2:	83 c4 18             	add    $0x18,%esp
	return ;
  801dc5:	90                   	nop
}
  801dc6:	c9                   	leave  
  801dc7:	c3                   	ret    

00801dc8 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801dc8:	55                   	push   %ebp
  801dc9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801dcb:	6a 00                	push   $0x0
  801dcd:	6a 00                	push   $0x0
  801dcf:	6a 00                	push   $0x0
  801dd1:	6a 00                	push   $0x0
  801dd3:	6a 00                	push   $0x0
  801dd5:	6a 0c                	push   $0xc
  801dd7:	e8 60 fe ff ff       	call   801c3c <syscall>
  801ddc:	83 c4 18             	add    $0x18,%esp
}
  801ddf:	c9                   	leave  
  801de0:	c3                   	ret    

00801de1 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801de1:	55                   	push   %ebp
  801de2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801de4:	6a 00                	push   $0x0
  801de6:	6a 00                	push   $0x0
  801de8:	6a 00                	push   $0x0
  801dea:	6a 00                	push   $0x0
  801dec:	ff 75 08             	pushl  0x8(%ebp)
  801def:	6a 0d                	push   $0xd
  801df1:	e8 46 fe ff ff       	call   801c3c <syscall>
  801df6:	83 c4 18             	add    $0x18,%esp
}
  801df9:	c9                   	leave  
  801dfa:	c3                   	ret    

00801dfb <sys_scarce_memory>:

void sys_scarce_memory()
{
  801dfb:	55                   	push   %ebp
  801dfc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801dfe:	6a 00                	push   $0x0
  801e00:	6a 00                	push   $0x0
  801e02:	6a 00                	push   $0x0
  801e04:	6a 00                	push   $0x0
  801e06:	6a 00                	push   $0x0
  801e08:	6a 0e                	push   $0xe
  801e0a:	e8 2d fe ff ff       	call   801c3c <syscall>
  801e0f:	83 c4 18             	add    $0x18,%esp
}
  801e12:	90                   	nop
  801e13:	c9                   	leave  
  801e14:	c3                   	ret    

00801e15 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801e15:	55                   	push   %ebp
  801e16:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801e18:	6a 00                	push   $0x0
  801e1a:	6a 00                	push   $0x0
  801e1c:	6a 00                	push   $0x0
  801e1e:	6a 00                	push   $0x0
  801e20:	6a 00                	push   $0x0
  801e22:	6a 13                	push   $0x13
  801e24:	e8 13 fe ff ff       	call   801c3c <syscall>
  801e29:	83 c4 18             	add    $0x18,%esp
}
  801e2c:	90                   	nop
  801e2d:	c9                   	leave  
  801e2e:	c3                   	ret    

00801e2f <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801e2f:	55                   	push   %ebp
  801e30:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801e32:	6a 00                	push   $0x0
  801e34:	6a 00                	push   $0x0
  801e36:	6a 00                	push   $0x0
  801e38:	6a 00                	push   $0x0
  801e3a:	6a 00                	push   $0x0
  801e3c:	6a 14                	push   $0x14
  801e3e:	e8 f9 fd ff ff       	call   801c3c <syscall>
  801e43:	83 c4 18             	add    $0x18,%esp
}
  801e46:	90                   	nop
  801e47:	c9                   	leave  
  801e48:	c3                   	ret    

00801e49 <sys_cputc>:


void
sys_cputc(const char c)
{
  801e49:	55                   	push   %ebp
  801e4a:	89 e5                	mov    %esp,%ebp
  801e4c:	83 ec 04             	sub    $0x4,%esp
  801e4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e52:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801e55:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801e59:	6a 00                	push   $0x0
  801e5b:	6a 00                	push   $0x0
  801e5d:	6a 00                	push   $0x0
  801e5f:	6a 00                	push   $0x0
  801e61:	50                   	push   %eax
  801e62:	6a 15                	push   $0x15
  801e64:	e8 d3 fd ff ff       	call   801c3c <syscall>
  801e69:	83 c4 18             	add    $0x18,%esp
}
  801e6c:	90                   	nop
  801e6d:	c9                   	leave  
  801e6e:	c3                   	ret    

00801e6f <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801e6f:	55                   	push   %ebp
  801e70:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801e72:	6a 00                	push   $0x0
  801e74:	6a 00                	push   $0x0
  801e76:	6a 00                	push   $0x0
  801e78:	6a 00                	push   $0x0
  801e7a:	6a 00                	push   $0x0
  801e7c:	6a 16                	push   $0x16
  801e7e:	e8 b9 fd ff ff       	call   801c3c <syscall>
  801e83:	83 c4 18             	add    $0x18,%esp
}
  801e86:	90                   	nop
  801e87:	c9                   	leave  
  801e88:	c3                   	ret    

00801e89 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801e89:	55                   	push   %ebp
  801e8a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801e8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e8f:	6a 00                	push   $0x0
  801e91:	6a 00                	push   $0x0
  801e93:	6a 00                	push   $0x0
  801e95:	ff 75 0c             	pushl  0xc(%ebp)
  801e98:	50                   	push   %eax
  801e99:	6a 17                	push   $0x17
  801e9b:	e8 9c fd ff ff       	call   801c3c <syscall>
  801ea0:	83 c4 18             	add    $0x18,%esp
}
  801ea3:	c9                   	leave  
  801ea4:	c3                   	ret    

00801ea5 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801ea5:	55                   	push   %ebp
  801ea6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ea8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eab:	8b 45 08             	mov    0x8(%ebp),%eax
  801eae:	6a 00                	push   $0x0
  801eb0:	6a 00                	push   $0x0
  801eb2:	6a 00                	push   $0x0
  801eb4:	52                   	push   %edx
  801eb5:	50                   	push   %eax
  801eb6:	6a 1a                	push   $0x1a
  801eb8:	e8 7f fd ff ff       	call   801c3c <syscall>
  801ebd:	83 c4 18             	add    $0x18,%esp
}
  801ec0:	c9                   	leave  
  801ec1:	c3                   	ret    

00801ec2 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801ec2:	55                   	push   %ebp
  801ec3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ec5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ec8:	8b 45 08             	mov    0x8(%ebp),%eax
  801ecb:	6a 00                	push   $0x0
  801ecd:	6a 00                	push   $0x0
  801ecf:	6a 00                	push   $0x0
  801ed1:	52                   	push   %edx
  801ed2:	50                   	push   %eax
  801ed3:	6a 18                	push   $0x18
  801ed5:	e8 62 fd ff ff       	call   801c3c <syscall>
  801eda:	83 c4 18             	add    $0x18,%esp
}
  801edd:	90                   	nop
  801ede:	c9                   	leave  
  801edf:	c3                   	ret    

00801ee0 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801ee0:	55                   	push   %ebp
  801ee1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ee3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ee6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee9:	6a 00                	push   $0x0
  801eeb:	6a 00                	push   $0x0
  801eed:	6a 00                	push   $0x0
  801eef:	52                   	push   %edx
  801ef0:	50                   	push   %eax
  801ef1:	6a 19                	push   $0x19
  801ef3:	e8 44 fd ff ff       	call   801c3c <syscall>
  801ef8:	83 c4 18             	add    $0x18,%esp
}
  801efb:	90                   	nop
  801efc:	c9                   	leave  
  801efd:	c3                   	ret    

00801efe <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801efe:	55                   	push   %ebp
  801eff:	89 e5                	mov    %esp,%ebp
  801f01:	83 ec 04             	sub    $0x4,%esp
  801f04:	8b 45 10             	mov    0x10(%ebp),%eax
  801f07:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801f0a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801f0d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801f11:	8b 45 08             	mov    0x8(%ebp),%eax
  801f14:	6a 00                	push   $0x0
  801f16:	51                   	push   %ecx
  801f17:	52                   	push   %edx
  801f18:	ff 75 0c             	pushl  0xc(%ebp)
  801f1b:	50                   	push   %eax
  801f1c:	6a 1b                	push   $0x1b
  801f1e:	e8 19 fd ff ff       	call   801c3c <syscall>
  801f23:	83 c4 18             	add    $0x18,%esp
}
  801f26:	c9                   	leave  
  801f27:	c3                   	ret    

00801f28 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801f28:	55                   	push   %ebp
  801f29:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801f2b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f2e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f31:	6a 00                	push   $0x0
  801f33:	6a 00                	push   $0x0
  801f35:	6a 00                	push   $0x0
  801f37:	52                   	push   %edx
  801f38:	50                   	push   %eax
  801f39:	6a 1c                	push   $0x1c
  801f3b:	e8 fc fc ff ff       	call   801c3c <syscall>
  801f40:	83 c4 18             	add    $0x18,%esp
}
  801f43:	c9                   	leave  
  801f44:	c3                   	ret    

00801f45 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801f45:	55                   	push   %ebp
  801f46:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801f48:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f4b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f4e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f51:	6a 00                	push   $0x0
  801f53:	6a 00                	push   $0x0
  801f55:	51                   	push   %ecx
  801f56:	52                   	push   %edx
  801f57:	50                   	push   %eax
  801f58:	6a 1d                	push   $0x1d
  801f5a:	e8 dd fc ff ff       	call   801c3c <syscall>
  801f5f:	83 c4 18             	add    $0x18,%esp
}
  801f62:	c9                   	leave  
  801f63:	c3                   	ret    

00801f64 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801f64:	55                   	push   %ebp
  801f65:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801f67:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f6d:	6a 00                	push   $0x0
  801f6f:	6a 00                	push   $0x0
  801f71:	6a 00                	push   $0x0
  801f73:	52                   	push   %edx
  801f74:	50                   	push   %eax
  801f75:	6a 1e                	push   $0x1e
  801f77:	e8 c0 fc ff ff       	call   801c3c <syscall>
  801f7c:	83 c4 18             	add    $0x18,%esp
}
  801f7f:	c9                   	leave  
  801f80:	c3                   	ret    

00801f81 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801f81:	55                   	push   %ebp
  801f82:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801f84:	6a 00                	push   $0x0
  801f86:	6a 00                	push   $0x0
  801f88:	6a 00                	push   $0x0
  801f8a:	6a 00                	push   $0x0
  801f8c:	6a 00                	push   $0x0
  801f8e:	6a 1f                	push   $0x1f
  801f90:	e8 a7 fc ff ff       	call   801c3c <syscall>
  801f95:	83 c4 18             	add    $0x18,%esp
}
  801f98:	c9                   	leave  
  801f99:	c3                   	ret    

00801f9a <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801f9a:	55                   	push   %ebp
  801f9b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801f9d:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa0:	6a 00                	push   $0x0
  801fa2:	ff 75 14             	pushl  0x14(%ebp)
  801fa5:	ff 75 10             	pushl  0x10(%ebp)
  801fa8:	ff 75 0c             	pushl  0xc(%ebp)
  801fab:	50                   	push   %eax
  801fac:	6a 20                	push   $0x20
  801fae:	e8 89 fc ff ff       	call   801c3c <syscall>
  801fb3:	83 c4 18             	add    $0x18,%esp
}
  801fb6:	c9                   	leave  
  801fb7:	c3                   	ret    

00801fb8 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801fb8:	55                   	push   %ebp
  801fb9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801fbb:	8b 45 08             	mov    0x8(%ebp),%eax
  801fbe:	6a 00                	push   $0x0
  801fc0:	6a 00                	push   $0x0
  801fc2:	6a 00                	push   $0x0
  801fc4:	6a 00                	push   $0x0
  801fc6:	50                   	push   %eax
  801fc7:	6a 21                	push   $0x21
  801fc9:	e8 6e fc ff ff       	call   801c3c <syscall>
  801fce:	83 c4 18             	add    $0x18,%esp
}
  801fd1:	90                   	nop
  801fd2:	c9                   	leave  
  801fd3:	c3                   	ret    

00801fd4 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801fd4:	55                   	push   %ebp
  801fd5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801fd7:	8b 45 08             	mov    0x8(%ebp),%eax
  801fda:	6a 00                	push   $0x0
  801fdc:	6a 00                	push   $0x0
  801fde:	6a 00                	push   $0x0
  801fe0:	6a 00                	push   $0x0
  801fe2:	50                   	push   %eax
  801fe3:	6a 22                	push   $0x22
  801fe5:	e8 52 fc ff ff       	call   801c3c <syscall>
  801fea:	83 c4 18             	add    $0x18,%esp
}
  801fed:	c9                   	leave  
  801fee:	c3                   	ret    

00801fef <sys_getenvid>:

int32 sys_getenvid(void)
{
  801fef:	55                   	push   %ebp
  801ff0:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801ff2:	6a 00                	push   $0x0
  801ff4:	6a 00                	push   $0x0
  801ff6:	6a 00                	push   $0x0
  801ff8:	6a 00                	push   $0x0
  801ffa:	6a 00                	push   $0x0
  801ffc:	6a 02                	push   $0x2
  801ffe:	e8 39 fc ff ff       	call   801c3c <syscall>
  802003:	83 c4 18             	add    $0x18,%esp
}
  802006:	c9                   	leave  
  802007:	c3                   	ret    

00802008 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802008:	55                   	push   %ebp
  802009:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80200b:	6a 00                	push   $0x0
  80200d:	6a 00                	push   $0x0
  80200f:	6a 00                	push   $0x0
  802011:	6a 00                	push   $0x0
  802013:	6a 00                	push   $0x0
  802015:	6a 03                	push   $0x3
  802017:	e8 20 fc ff ff       	call   801c3c <syscall>
  80201c:	83 c4 18             	add    $0x18,%esp
}
  80201f:	c9                   	leave  
  802020:	c3                   	ret    

00802021 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802021:	55                   	push   %ebp
  802022:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802024:	6a 00                	push   $0x0
  802026:	6a 00                	push   $0x0
  802028:	6a 00                	push   $0x0
  80202a:	6a 00                	push   $0x0
  80202c:	6a 00                	push   $0x0
  80202e:	6a 04                	push   $0x4
  802030:	e8 07 fc ff ff       	call   801c3c <syscall>
  802035:	83 c4 18             	add    $0x18,%esp
}
  802038:	c9                   	leave  
  802039:	c3                   	ret    

0080203a <sys_exit_env>:


void sys_exit_env(void)
{
  80203a:	55                   	push   %ebp
  80203b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80203d:	6a 00                	push   $0x0
  80203f:	6a 00                	push   $0x0
  802041:	6a 00                	push   $0x0
  802043:	6a 00                	push   $0x0
  802045:	6a 00                	push   $0x0
  802047:	6a 23                	push   $0x23
  802049:	e8 ee fb ff ff       	call   801c3c <syscall>
  80204e:	83 c4 18             	add    $0x18,%esp
}
  802051:	90                   	nop
  802052:	c9                   	leave  
  802053:	c3                   	ret    

00802054 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802054:	55                   	push   %ebp
  802055:	89 e5                	mov    %esp,%ebp
  802057:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80205a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80205d:	8d 50 04             	lea    0x4(%eax),%edx
  802060:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802063:	6a 00                	push   $0x0
  802065:	6a 00                	push   $0x0
  802067:	6a 00                	push   $0x0
  802069:	52                   	push   %edx
  80206a:	50                   	push   %eax
  80206b:	6a 24                	push   $0x24
  80206d:	e8 ca fb ff ff       	call   801c3c <syscall>
  802072:	83 c4 18             	add    $0x18,%esp
	return result;
  802075:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802078:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80207b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80207e:	89 01                	mov    %eax,(%ecx)
  802080:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802083:	8b 45 08             	mov    0x8(%ebp),%eax
  802086:	c9                   	leave  
  802087:	c2 04 00             	ret    $0x4

0080208a <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80208a:	55                   	push   %ebp
  80208b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80208d:	6a 00                	push   $0x0
  80208f:	6a 00                	push   $0x0
  802091:	ff 75 10             	pushl  0x10(%ebp)
  802094:	ff 75 0c             	pushl  0xc(%ebp)
  802097:	ff 75 08             	pushl  0x8(%ebp)
  80209a:	6a 12                	push   $0x12
  80209c:	e8 9b fb ff ff       	call   801c3c <syscall>
  8020a1:	83 c4 18             	add    $0x18,%esp
	return ;
  8020a4:	90                   	nop
}
  8020a5:	c9                   	leave  
  8020a6:	c3                   	ret    

008020a7 <sys_rcr2>:
uint32 sys_rcr2()
{
  8020a7:	55                   	push   %ebp
  8020a8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8020aa:	6a 00                	push   $0x0
  8020ac:	6a 00                	push   $0x0
  8020ae:	6a 00                	push   $0x0
  8020b0:	6a 00                	push   $0x0
  8020b2:	6a 00                	push   $0x0
  8020b4:	6a 25                	push   $0x25
  8020b6:	e8 81 fb ff ff       	call   801c3c <syscall>
  8020bb:	83 c4 18             	add    $0x18,%esp
}
  8020be:	c9                   	leave  
  8020bf:	c3                   	ret    

008020c0 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8020c0:	55                   	push   %ebp
  8020c1:	89 e5                	mov    %esp,%ebp
  8020c3:	83 ec 04             	sub    $0x4,%esp
  8020c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8020cc:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8020d0:	6a 00                	push   $0x0
  8020d2:	6a 00                	push   $0x0
  8020d4:	6a 00                	push   $0x0
  8020d6:	6a 00                	push   $0x0
  8020d8:	50                   	push   %eax
  8020d9:	6a 26                	push   $0x26
  8020db:	e8 5c fb ff ff       	call   801c3c <syscall>
  8020e0:	83 c4 18             	add    $0x18,%esp
	return ;
  8020e3:	90                   	nop
}
  8020e4:	c9                   	leave  
  8020e5:	c3                   	ret    

008020e6 <rsttst>:
void rsttst()
{
  8020e6:	55                   	push   %ebp
  8020e7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8020e9:	6a 00                	push   $0x0
  8020eb:	6a 00                	push   $0x0
  8020ed:	6a 00                	push   $0x0
  8020ef:	6a 00                	push   $0x0
  8020f1:	6a 00                	push   $0x0
  8020f3:	6a 28                	push   $0x28
  8020f5:	e8 42 fb ff ff       	call   801c3c <syscall>
  8020fa:	83 c4 18             	add    $0x18,%esp
	return ;
  8020fd:	90                   	nop
}
  8020fe:	c9                   	leave  
  8020ff:	c3                   	ret    

00802100 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802100:	55                   	push   %ebp
  802101:	89 e5                	mov    %esp,%ebp
  802103:	83 ec 04             	sub    $0x4,%esp
  802106:	8b 45 14             	mov    0x14(%ebp),%eax
  802109:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80210c:	8b 55 18             	mov    0x18(%ebp),%edx
  80210f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802113:	52                   	push   %edx
  802114:	50                   	push   %eax
  802115:	ff 75 10             	pushl  0x10(%ebp)
  802118:	ff 75 0c             	pushl  0xc(%ebp)
  80211b:	ff 75 08             	pushl  0x8(%ebp)
  80211e:	6a 27                	push   $0x27
  802120:	e8 17 fb ff ff       	call   801c3c <syscall>
  802125:	83 c4 18             	add    $0x18,%esp
	return ;
  802128:	90                   	nop
}
  802129:	c9                   	leave  
  80212a:	c3                   	ret    

0080212b <chktst>:
void chktst(uint32 n)
{
  80212b:	55                   	push   %ebp
  80212c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80212e:	6a 00                	push   $0x0
  802130:	6a 00                	push   $0x0
  802132:	6a 00                	push   $0x0
  802134:	6a 00                	push   $0x0
  802136:	ff 75 08             	pushl  0x8(%ebp)
  802139:	6a 29                	push   $0x29
  80213b:	e8 fc fa ff ff       	call   801c3c <syscall>
  802140:	83 c4 18             	add    $0x18,%esp
	return ;
  802143:	90                   	nop
}
  802144:	c9                   	leave  
  802145:	c3                   	ret    

00802146 <inctst>:

void inctst()
{
  802146:	55                   	push   %ebp
  802147:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802149:	6a 00                	push   $0x0
  80214b:	6a 00                	push   $0x0
  80214d:	6a 00                	push   $0x0
  80214f:	6a 00                	push   $0x0
  802151:	6a 00                	push   $0x0
  802153:	6a 2a                	push   $0x2a
  802155:	e8 e2 fa ff ff       	call   801c3c <syscall>
  80215a:	83 c4 18             	add    $0x18,%esp
	return ;
  80215d:	90                   	nop
}
  80215e:	c9                   	leave  
  80215f:	c3                   	ret    

00802160 <gettst>:
uint32 gettst()
{
  802160:	55                   	push   %ebp
  802161:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802163:	6a 00                	push   $0x0
  802165:	6a 00                	push   $0x0
  802167:	6a 00                	push   $0x0
  802169:	6a 00                	push   $0x0
  80216b:	6a 00                	push   $0x0
  80216d:	6a 2b                	push   $0x2b
  80216f:	e8 c8 fa ff ff       	call   801c3c <syscall>
  802174:	83 c4 18             	add    $0x18,%esp
}
  802177:	c9                   	leave  
  802178:	c3                   	ret    

00802179 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802179:	55                   	push   %ebp
  80217a:	89 e5                	mov    %esp,%ebp
  80217c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80217f:	6a 00                	push   $0x0
  802181:	6a 00                	push   $0x0
  802183:	6a 00                	push   $0x0
  802185:	6a 00                	push   $0x0
  802187:	6a 00                	push   $0x0
  802189:	6a 2c                	push   $0x2c
  80218b:	e8 ac fa ff ff       	call   801c3c <syscall>
  802190:	83 c4 18             	add    $0x18,%esp
  802193:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802196:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80219a:	75 07                	jne    8021a3 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80219c:	b8 01 00 00 00       	mov    $0x1,%eax
  8021a1:	eb 05                	jmp    8021a8 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8021a3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021a8:	c9                   	leave  
  8021a9:	c3                   	ret    

008021aa <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8021aa:	55                   	push   %ebp
  8021ab:	89 e5                	mov    %esp,%ebp
  8021ad:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8021b0:	6a 00                	push   $0x0
  8021b2:	6a 00                	push   $0x0
  8021b4:	6a 00                	push   $0x0
  8021b6:	6a 00                	push   $0x0
  8021b8:	6a 00                	push   $0x0
  8021ba:	6a 2c                	push   $0x2c
  8021bc:	e8 7b fa ff ff       	call   801c3c <syscall>
  8021c1:	83 c4 18             	add    $0x18,%esp
  8021c4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8021c7:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8021cb:	75 07                	jne    8021d4 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8021cd:	b8 01 00 00 00       	mov    $0x1,%eax
  8021d2:	eb 05                	jmp    8021d9 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8021d4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021d9:	c9                   	leave  
  8021da:	c3                   	ret    

008021db <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8021db:	55                   	push   %ebp
  8021dc:	89 e5                	mov    %esp,%ebp
  8021de:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8021e1:	6a 00                	push   $0x0
  8021e3:	6a 00                	push   $0x0
  8021e5:	6a 00                	push   $0x0
  8021e7:	6a 00                	push   $0x0
  8021e9:	6a 00                	push   $0x0
  8021eb:	6a 2c                	push   $0x2c
  8021ed:	e8 4a fa ff ff       	call   801c3c <syscall>
  8021f2:	83 c4 18             	add    $0x18,%esp
  8021f5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8021f8:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8021fc:	75 07                	jne    802205 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8021fe:	b8 01 00 00 00       	mov    $0x1,%eax
  802203:	eb 05                	jmp    80220a <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802205:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80220a:	c9                   	leave  
  80220b:	c3                   	ret    

0080220c <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80220c:	55                   	push   %ebp
  80220d:	89 e5                	mov    %esp,%ebp
  80220f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802212:	6a 00                	push   $0x0
  802214:	6a 00                	push   $0x0
  802216:	6a 00                	push   $0x0
  802218:	6a 00                	push   $0x0
  80221a:	6a 00                	push   $0x0
  80221c:	6a 2c                	push   $0x2c
  80221e:	e8 19 fa ff ff       	call   801c3c <syscall>
  802223:	83 c4 18             	add    $0x18,%esp
  802226:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802229:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80222d:	75 07                	jne    802236 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80222f:	b8 01 00 00 00       	mov    $0x1,%eax
  802234:	eb 05                	jmp    80223b <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802236:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80223b:	c9                   	leave  
  80223c:	c3                   	ret    

0080223d <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80223d:	55                   	push   %ebp
  80223e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802240:	6a 00                	push   $0x0
  802242:	6a 00                	push   $0x0
  802244:	6a 00                	push   $0x0
  802246:	6a 00                	push   $0x0
  802248:	ff 75 08             	pushl  0x8(%ebp)
  80224b:	6a 2d                	push   $0x2d
  80224d:	e8 ea f9 ff ff       	call   801c3c <syscall>
  802252:	83 c4 18             	add    $0x18,%esp
	return ;
  802255:	90                   	nop
}
  802256:	c9                   	leave  
  802257:	c3                   	ret    

00802258 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802258:	55                   	push   %ebp
  802259:	89 e5                	mov    %esp,%ebp
  80225b:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80225c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80225f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802262:	8b 55 0c             	mov    0xc(%ebp),%edx
  802265:	8b 45 08             	mov    0x8(%ebp),%eax
  802268:	6a 00                	push   $0x0
  80226a:	53                   	push   %ebx
  80226b:	51                   	push   %ecx
  80226c:	52                   	push   %edx
  80226d:	50                   	push   %eax
  80226e:	6a 2e                	push   $0x2e
  802270:	e8 c7 f9 ff ff       	call   801c3c <syscall>
  802275:	83 c4 18             	add    $0x18,%esp
}
  802278:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80227b:	c9                   	leave  
  80227c:	c3                   	ret    

0080227d <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80227d:	55                   	push   %ebp
  80227e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802280:	8b 55 0c             	mov    0xc(%ebp),%edx
  802283:	8b 45 08             	mov    0x8(%ebp),%eax
  802286:	6a 00                	push   $0x0
  802288:	6a 00                	push   $0x0
  80228a:	6a 00                	push   $0x0
  80228c:	52                   	push   %edx
  80228d:	50                   	push   %eax
  80228e:	6a 2f                	push   $0x2f
  802290:	e8 a7 f9 ff ff       	call   801c3c <syscall>
  802295:	83 c4 18             	add    $0x18,%esp
}
  802298:	c9                   	leave  
  802299:	c3                   	ret    

0080229a <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  80229a:	55                   	push   %ebp
  80229b:	89 e5                	mov    %esp,%ebp
  80229d:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  8022a0:	83 ec 0c             	sub    $0xc,%esp
  8022a3:	68 00 46 80 00       	push   $0x804600
  8022a8:	e8 d6 e6 ff ff       	call   800983 <cprintf>
  8022ad:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  8022b0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8022b7:	83 ec 0c             	sub    $0xc,%esp
  8022ba:	68 2c 46 80 00       	push   $0x80462c
  8022bf:	e8 bf e6 ff ff       	call   800983 <cprintf>
  8022c4:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8022c7:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8022cb:	a1 38 51 80 00       	mov    0x805138,%eax
  8022d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022d3:	eb 56                	jmp    80232b <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8022d5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8022d9:	74 1c                	je     8022f7 <print_mem_block_lists+0x5d>
  8022db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022de:	8b 50 08             	mov    0x8(%eax),%edx
  8022e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022e4:	8b 48 08             	mov    0x8(%eax),%ecx
  8022e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022ea:	8b 40 0c             	mov    0xc(%eax),%eax
  8022ed:	01 c8                	add    %ecx,%eax
  8022ef:	39 c2                	cmp    %eax,%edx
  8022f1:	73 04                	jae    8022f7 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8022f3:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8022f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022fa:	8b 50 08             	mov    0x8(%eax),%edx
  8022fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802300:	8b 40 0c             	mov    0xc(%eax),%eax
  802303:	01 c2                	add    %eax,%edx
  802305:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802308:	8b 40 08             	mov    0x8(%eax),%eax
  80230b:	83 ec 04             	sub    $0x4,%esp
  80230e:	52                   	push   %edx
  80230f:	50                   	push   %eax
  802310:	68 41 46 80 00       	push   $0x804641
  802315:	e8 69 e6 ff ff       	call   800983 <cprintf>
  80231a:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80231d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802320:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802323:	a1 40 51 80 00       	mov    0x805140,%eax
  802328:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80232b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80232f:	74 07                	je     802338 <print_mem_block_lists+0x9e>
  802331:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802334:	8b 00                	mov    (%eax),%eax
  802336:	eb 05                	jmp    80233d <print_mem_block_lists+0xa3>
  802338:	b8 00 00 00 00       	mov    $0x0,%eax
  80233d:	a3 40 51 80 00       	mov    %eax,0x805140
  802342:	a1 40 51 80 00       	mov    0x805140,%eax
  802347:	85 c0                	test   %eax,%eax
  802349:	75 8a                	jne    8022d5 <print_mem_block_lists+0x3b>
  80234b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80234f:	75 84                	jne    8022d5 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802351:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802355:	75 10                	jne    802367 <print_mem_block_lists+0xcd>
  802357:	83 ec 0c             	sub    $0xc,%esp
  80235a:	68 50 46 80 00       	push   $0x804650
  80235f:	e8 1f e6 ff ff       	call   800983 <cprintf>
  802364:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802367:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  80236e:	83 ec 0c             	sub    $0xc,%esp
  802371:	68 74 46 80 00       	push   $0x804674
  802376:	e8 08 e6 ff ff       	call   800983 <cprintf>
  80237b:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  80237e:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802382:	a1 40 50 80 00       	mov    0x805040,%eax
  802387:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80238a:	eb 56                	jmp    8023e2 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80238c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802390:	74 1c                	je     8023ae <print_mem_block_lists+0x114>
  802392:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802395:	8b 50 08             	mov    0x8(%eax),%edx
  802398:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80239b:	8b 48 08             	mov    0x8(%eax),%ecx
  80239e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023a1:	8b 40 0c             	mov    0xc(%eax),%eax
  8023a4:	01 c8                	add    %ecx,%eax
  8023a6:	39 c2                	cmp    %eax,%edx
  8023a8:	73 04                	jae    8023ae <print_mem_block_lists+0x114>
			sorted = 0 ;
  8023aa:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8023ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b1:	8b 50 08             	mov    0x8(%eax),%edx
  8023b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b7:	8b 40 0c             	mov    0xc(%eax),%eax
  8023ba:	01 c2                	add    %eax,%edx
  8023bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023bf:	8b 40 08             	mov    0x8(%eax),%eax
  8023c2:	83 ec 04             	sub    $0x4,%esp
  8023c5:	52                   	push   %edx
  8023c6:	50                   	push   %eax
  8023c7:	68 41 46 80 00       	push   $0x804641
  8023cc:	e8 b2 e5 ff ff       	call   800983 <cprintf>
  8023d1:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8023d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8023da:	a1 48 50 80 00       	mov    0x805048,%eax
  8023df:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023e6:	74 07                	je     8023ef <print_mem_block_lists+0x155>
  8023e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023eb:	8b 00                	mov    (%eax),%eax
  8023ed:	eb 05                	jmp    8023f4 <print_mem_block_lists+0x15a>
  8023ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8023f4:	a3 48 50 80 00       	mov    %eax,0x805048
  8023f9:	a1 48 50 80 00       	mov    0x805048,%eax
  8023fe:	85 c0                	test   %eax,%eax
  802400:	75 8a                	jne    80238c <print_mem_block_lists+0xf2>
  802402:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802406:	75 84                	jne    80238c <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802408:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80240c:	75 10                	jne    80241e <print_mem_block_lists+0x184>
  80240e:	83 ec 0c             	sub    $0xc,%esp
  802411:	68 8c 46 80 00       	push   $0x80468c
  802416:	e8 68 e5 ff ff       	call   800983 <cprintf>
  80241b:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  80241e:	83 ec 0c             	sub    $0xc,%esp
  802421:	68 00 46 80 00       	push   $0x804600
  802426:	e8 58 e5 ff ff       	call   800983 <cprintf>
  80242b:	83 c4 10             	add    $0x10,%esp

}
  80242e:	90                   	nop
  80242f:	c9                   	leave  
  802430:	c3                   	ret    

00802431 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802431:	55                   	push   %ebp
  802432:	89 e5                	mov    %esp,%ebp
  802434:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  802437:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  80243e:	00 00 00 
  802441:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802448:	00 00 00 
  80244b:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802452:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  802455:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80245c:	e9 9e 00 00 00       	jmp    8024ff <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  802461:	a1 50 50 80 00       	mov    0x805050,%eax
  802466:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802469:	c1 e2 04             	shl    $0x4,%edx
  80246c:	01 d0                	add    %edx,%eax
  80246e:	85 c0                	test   %eax,%eax
  802470:	75 14                	jne    802486 <initialize_MemBlocksList+0x55>
  802472:	83 ec 04             	sub    $0x4,%esp
  802475:	68 b4 46 80 00       	push   $0x8046b4
  80247a:	6a 46                	push   $0x46
  80247c:	68 d7 46 80 00       	push   $0x8046d7
  802481:	e8 49 e2 ff ff       	call   8006cf <_panic>
  802486:	a1 50 50 80 00       	mov    0x805050,%eax
  80248b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80248e:	c1 e2 04             	shl    $0x4,%edx
  802491:	01 d0                	add    %edx,%eax
  802493:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802499:	89 10                	mov    %edx,(%eax)
  80249b:	8b 00                	mov    (%eax),%eax
  80249d:	85 c0                	test   %eax,%eax
  80249f:	74 18                	je     8024b9 <initialize_MemBlocksList+0x88>
  8024a1:	a1 48 51 80 00       	mov    0x805148,%eax
  8024a6:	8b 15 50 50 80 00    	mov    0x805050,%edx
  8024ac:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8024af:	c1 e1 04             	shl    $0x4,%ecx
  8024b2:	01 ca                	add    %ecx,%edx
  8024b4:	89 50 04             	mov    %edx,0x4(%eax)
  8024b7:	eb 12                	jmp    8024cb <initialize_MemBlocksList+0x9a>
  8024b9:	a1 50 50 80 00       	mov    0x805050,%eax
  8024be:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024c1:	c1 e2 04             	shl    $0x4,%edx
  8024c4:	01 d0                	add    %edx,%eax
  8024c6:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8024cb:	a1 50 50 80 00       	mov    0x805050,%eax
  8024d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024d3:	c1 e2 04             	shl    $0x4,%edx
  8024d6:	01 d0                	add    %edx,%eax
  8024d8:	a3 48 51 80 00       	mov    %eax,0x805148
  8024dd:	a1 50 50 80 00       	mov    0x805050,%eax
  8024e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024e5:	c1 e2 04             	shl    $0x4,%edx
  8024e8:	01 d0                	add    %edx,%eax
  8024ea:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024f1:	a1 54 51 80 00       	mov    0x805154,%eax
  8024f6:	40                   	inc    %eax
  8024f7:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  8024fc:	ff 45 f4             	incl   -0xc(%ebp)
  8024ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802502:	3b 45 08             	cmp    0x8(%ebp),%eax
  802505:	0f 82 56 ff ff ff    	jb     802461 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  80250b:	90                   	nop
  80250c:	c9                   	leave  
  80250d:	c3                   	ret    

0080250e <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80250e:	55                   	push   %ebp
  80250f:	89 e5                	mov    %esp,%ebp
  802511:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802514:	8b 45 08             	mov    0x8(%ebp),%eax
  802517:	8b 00                	mov    (%eax),%eax
  802519:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80251c:	eb 19                	jmp    802537 <find_block+0x29>
	{
		if(va==point->sva)
  80251e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802521:	8b 40 08             	mov    0x8(%eax),%eax
  802524:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802527:	75 05                	jne    80252e <find_block+0x20>
		   return point;
  802529:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80252c:	eb 36                	jmp    802564 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  80252e:	8b 45 08             	mov    0x8(%ebp),%eax
  802531:	8b 40 08             	mov    0x8(%eax),%eax
  802534:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802537:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80253b:	74 07                	je     802544 <find_block+0x36>
  80253d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802540:	8b 00                	mov    (%eax),%eax
  802542:	eb 05                	jmp    802549 <find_block+0x3b>
  802544:	b8 00 00 00 00       	mov    $0x0,%eax
  802549:	8b 55 08             	mov    0x8(%ebp),%edx
  80254c:	89 42 08             	mov    %eax,0x8(%edx)
  80254f:	8b 45 08             	mov    0x8(%ebp),%eax
  802552:	8b 40 08             	mov    0x8(%eax),%eax
  802555:	85 c0                	test   %eax,%eax
  802557:	75 c5                	jne    80251e <find_block+0x10>
  802559:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80255d:	75 bf                	jne    80251e <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  80255f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802564:	c9                   	leave  
  802565:	c3                   	ret    

00802566 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802566:	55                   	push   %ebp
  802567:	89 e5                	mov    %esp,%ebp
  802569:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  80256c:	a1 40 50 80 00       	mov    0x805040,%eax
  802571:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802574:	a1 44 50 80 00       	mov    0x805044,%eax
  802579:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  80257c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80257f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802582:	74 24                	je     8025a8 <insert_sorted_allocList+0x42>
  802584:	8b 45 08             	mov    0x8(%ebp),%eax
  802587:	8b 50 08             	mov    0x8(%eax),%edx
  80258a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80258d:	8b 40 08             	mov    0x8(%eax),%eax
  802590:	39 c2                	cmp    %eax,%edx
  802592:	76 14                	jbe    8025a8 <insert_sorted_allocList+0x42>
  802594:	8b 45 08             	mov    0x8(%ebp),%eax
  802597:	8b 50 08             	mov    0x8(%eax),%edx
  80259a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80259d:	8b 40 08             	mov    0x8(%eax),%eax
  8025a0:	39 c2                	cmp    %eax,%edx
  8025a2:	0f 82 60 01 00 00    	jb     802708 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  8025a8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8025ac:	75 65                	jne    802613 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  8025ae:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8025b2:	75 14                	jne    8025c8 <insert_sorted_allocList+0x62>
  8025b4:	83 ec 04             	sub    $0x4,%esp
  8025b7:	68 b4 46 80 00       	push   $0x8046b4
  8025bc:	6a 6b                	push   $0x6b
  8025be:	68 d7 46 80 00       	push   $0x8046d7
  8025c3:	e8 07 e1 ff ff       	call   8006cf <_panic>
  8025c8:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8025ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8025d1:	89 10                	mov    %edx,(%eax)
  8025d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8025d6:	8b 00                	mov    (%eax),%eax
  8025d8:	85 c0                	test   %eax,%eax
  8025da:	74 0d                	je     8025e9 <insert_sorted_allocList+0x83>
  8025dc:	a1 40 50 80 00       	mov    0x805040,%eax
  8025e1:	8b 55 08             	mov    0x8(%ebp),%edx
  8025e4:	89 50 04             	mov    %edx,0x4(%eax)
  8025e7:	eb 08                	jmp    8025f1 <insert_sorted_allocList+0x8b>
  8025e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ec:	a3 44 50 80 00       	mov    %eax,0x805044
  8025f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8025f4:	a3 40 50 80 00       	mov    %eax,0x805040
  8025f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8025fc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802603:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802608:	40                   	inc    %eax
  802609:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80260e:	e9 dc 01 00 00       	jmp    8027ef <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802613:	8b 45 08             	mov    0x8(%ebp),%eax
  802616:	8b 50 08             	mov    0x8(%eax),%edx
  802619:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80261c:	8b 40 08             	mov    0x8(%eax),%eax
  80261f:	39 c2                	cmp    %eax,%edx
  802621:	77 6c                	ja     80268f <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802623:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802627:	74 06                	je     80262f <insert_sorted_allocList+0xc9>
  802629:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80262d:	75 14                	jne    802643 <insert_sorted_allocList+0xdd>
  80262f:	83 ec 04             	sub    $0x4,%esp
  802632:	68 f0 46 80 00       	push   $0x8046f0
  802637:	6a 6f                	push   $0x6f
  802639:	68 d7 46 80 00       	push   $0x8046d7
  80263e:	e8 8c e0 ff ff       	call   8006cf <_panic>
  802643:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802646:	8b 50 04             	mov    0x4(%eax),%edx
  802649:	8b 45 08             	mov    0x8(%ebp),%eax
  80264c:	89 50 04             	mov    %edx,0x4(%eax)
  80264f:	8b 45 08             	mov    0x8(%ebp),%eax
  802652:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802655:	89 10                	mov    %edx,(%eax)
  802657:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80265a:	8b 40 04             	mov    0x4(%eax),%eax
  80265d:	85 c0                	test   %eax,%eax
  80265f:	74 0d                	je     80266e <insert_sorted_allocList+0x108>
  802661:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802664:	8b 40 04             	mov    0x4(%eax),%eax
  802667:	8b 55 08             	mov    0x8(%ebp),%edx
  80266a:	89 10                	mov    %edx,(%eax)
  80266c:	eb 08                	jmp    802676 <insert_sorted_allocList+0x110>
  80266e:	8b 45 08             	mov    0x8(%ebp),%eax
  802671:	a3 40 50 80 00       	mov    %eax,0x805040
  802676:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802679:	8b 55 08             	mov    0x8(%ebp),%edx
  80267c:	89 50 04             	mov    %edx,0x4(%eax)
  80267f:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802684:	40                   	inc    %eax
  802685:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80268a:	e9 60 01 00 00       	jmp    8027ef <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  80268f:	8b 45 08             	mov    0x8(%ebp),%eax
  802692:	8b 50 08             	mov    0x8(%eax),%edx
  802695:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802698:	8b 40 08             	mov    0x8(%eax),%eax
  80269b:	39 c2                	cmp    %eax,%edx
  80269d:	0f 82 4c 01 00 00    	jb     8027ef <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8026a3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8026a7:	75 14                	jne    8026bd <insert_sorted_allocList+0x157>
  8026a9:	83 ec 04             	sub    $0x4,%esp
  8026ac:	68 28 47 80 00       	push   $0x804728
  8026b1:	6a 73                	push   $0x73
  8026b3:	68 d7 46 80 00       	push   $0x8046d7
  8026b8:	e8 12 e0 ff ff       	call   8006cf <_panic>
  8026bd:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8026c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c6:	89 50 04             	mov    %edx,0x4(%eax)
  8026c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8026cc:	8b 40 04             	mov    0x4(%eax),%eax
  8026cf:	85 c0                	test   %eax,%eax
  8026d1:	74 0c                	je     8026df <insert_sorted_allocList+0x179>
  8026d3:	a1 44 50 80 00       	mov    0x805044,%eax
  8026d8:	8b 55 08             	mov    0x8(%ebp),%edx
  8026db:	89 10                	mov    %edx,(%eax)
  8026dd:	eb 08                	jmp    8026e7 <insert_sorted_allocList+0x181>
  8026df:	8b 45 08             	mov    0x8(%ebp),%eax
  8026e2:	a3 40 50 80 00       	mov    %eax,0x805040
  8026e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ea:	a3 44 50 80 00       	mov    %eax,0x805044
  8026ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026f8:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8026fd:	40                   	inc    %eax
  8026fe:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802703:	e9 e7 00 00 00       	jmp    8027ef <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802708:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80270b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  80270e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802715:	a1 40 50 80 00       	mov    0x805040,%eax
  80271a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80271d:	e9 9d 00 00 00       	jmp    8027bf <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802722:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802725:	8b 00                	mov    (%eax),%eax
  802727:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  80272a:	8b 45 08             	mov    0x8(%ebp),%eax
  80272d:	8b 50 08             	mov    0x8(%eax),%edx
  802730:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802733:	8b 40 08             	mov    0x8(%eax),%eax
  802736:	39 c2                	cmp    %eax,%edx
  802738:	76 7d                	jbe    8027b7 <insert_sorted_allocList+0x251>
  80273a:	8b 45 08             	mov    0x8(%ebp),%eax
  80273d:	8b 50 08             	mov    0x8(%eax),%edx
  802740:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802743:	8b 40 08             	mov    0x8(%eax),%eax
  802746:	39 c2                	cmp    %eax,%edx
  802748:	73 6d                	jae    8027b7 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  80274a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80274e:	74 06                	je     802756 <insert_sorted_allocList+0x1f0>
  802750:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802754:	75 14                	jne    80276a <insert_sorted_allocList+0x204>
  802756:	83 ec 04             	sub    $0x4,%esp
  802759:	68 4c 47 80 00       	push   $0x80474c
  80275e:	6a 7f                	push   $0x7f
  802760:	68 d7 46 80 00       	push   $0x8046d7
  802765:	e8 65 df ff ff       	call   8006cf <_panic>
  80276a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276d:	8b 10                	mov    (%eax),%edx
  80276f:	8b 45 08             	mov    0x8(%ebp),%eax
  802772:	89 10                	mov    %edx,(%eax)
  802774:	8b 45 08             	mov    0x8(%ebp),%eax
  802777:	8b 00                	mov    (%eax),%eax
  802779:	85 c0                	test   %eax,%eax
  80277b:	74 0b                	je     802788 <insert_sorted_allocList+0x222>
  80277d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802780:	8b 00                	mov    (%eax),%eax
  802782:	8b 55 08             	mov    0x8(%ebp),%edx
  802785:	89 50 04             	mov    %edx,0x4(%eax)
  802788:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278b:	8b 55 08             	mov    0x8(%ebp),%edx
  80278e:	89 10                	mov    %edx,(%eax)
  802790:	8b 45 08             	mov    0x8(%ebp),%eax
  802793:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802796:	89 50 04             	mov    %edx,0x4(%eax)
  802799:	8b 45 08             	mov    0x8(%ebp),%eax
  80279c:	8b 00                	mov    (%eax),%eax
  80279e:	85 c0                	test   %eax,%eax
  8027a0:	75 08                	jne    8027aa <insert_sorted_allocList+0x244>
  8027a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a5:	a3 44 50 80 00       	mov    %eax,0x805044
  8027aa:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8027af:	40                   	inc    %eax
  8027b0:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  8027b5:	eb 39                	jmp    8027f0 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8027b7:	a1 48 50 80 00       	mov    0x805048,%eax
  8027bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027bf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027c3:	74 07                	je     8027cc <insert_sorted_allocList+0x266>
  8027c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c8:	8b 00                	mov    (%eax),%eax
  8027ca:	eb 05                	jmp    8027d1 <insert_sorted_allocList+0x26b>
  8027cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8027d1:	a3 48 50 80 00       	mov    %eax,0x805048
  8027d6:	a1 48 50 80 00       	mov    0x805048,%eax
  8027db:	85 c0                	test   %eax,%eax
  8027dd:	0f 85 3f ff ff ff    	jne    802722 <insert_sorted_allocList+0x1bc>
  8027e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027e7:	0f 85 35 ff ff ff    	jne    802722 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8027ed:	eb 01                	jmp    8027f0 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8027ef:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8027f0:	90                   	nop
  8027f1:	c9                   	leave  
  8027f2:	c3                   	ret    

008027f3 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8027f3:	55                   	push   %ebp
  8027f4:	89 e5                	mov    %esp,%ebp
  8027f6:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8027f9:	a1 38 51 80 00       	mov    0x805138,%eax
  8027fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802801:	e9 85 01 00 00       	jmp    80298b <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802806:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802809:	8b 40 0c             	mov    0xc(%eax),%eax
  80280c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80280f:	0f 82 6e 01 00 00    	jb     802983 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802815:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802818:	8b 40 0c             	mov    0xc(%eax),%eax
  80281b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80281e:	0f 85 8a 00 00 00    	jne    8028ae <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802824:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802828:	75 17                	jne    802841 <alloc_block_FF+0x4e>
  80282a:	83 ec 04             	sub    $0x4,%esp
  80282d:	68 80 47 80 00       	push   $0x804780
  802832:	68 93 00 00 00       	push   $0x93
  802837:	68 d7 46 80 00       	push   $0x8046d7
  80283c:	e8 8e de ff ff       	call   8006cf <_panic>
  802841:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802844:	8b 00                	mov    (%eax),%eax
  802846:	85 c0                	test   %eax,%eax
  802848:	74 10                	je     80285a <alloc_block_FF+0x67>
  80284a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284d:	8b 00                	mov    (%eax),%eax
  80284f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802852:	8b 52 04             	mov    0x4(%edx),%edx
  802855:	89 50 04             	mov    %edx,0x4(%eax)
  802858:	eb 0b                	jmp    802865 <alloc_block_FF+0x72>
  80285a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285d:	8b 40 04             	mov    0x4(%eax),%eax
  802860:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802865:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802868:	8b 40 04             	mov    0x4(%eax),%eax
  80286b:	85 c0                	test   %eax,%eax
  80286d:	74 0f                	je     80287e <alloc_block_FF+0x8b>
  80286f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802872:	8b 40 04             	mov    0x4(%eax),%eax
  802875:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802878:	8b 12                	mov    (%edx),%edx
  80287a:	89 10                	mov    %edx,(%eax)
  80287c:	eb 0a                	jmp    802888 <alloc_block_FF+0x95>
  80287e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802881:	8b 00                	mov    (%eax),%eax
  802883:	a3 38 51 80 00       	mov    %eax,0x805138
  802888:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802891:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802894:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80289b:	a1 44 51 80 00       	mov    0x805144,%eax
  8028a0:	48                   	dec    %eax
  8028a1:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  8028a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a9:	e9 10 01 00 00       	jmp    8029be <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  8028ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b1:	8b 40 0c             	mov    0xc(%eax),%eax
  8028b4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028b7:	0f 86 c6 00 00 00    	jbe    802983 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8028bd:	a1 48 51 80 00       	mov    0x805148,%eax
  8028c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  8028c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c8:	8b 50 08             	mov    0x8(%eax),%edx
  8028cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028ce:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  8028d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028d4:	8b 55 08             	mov    0x8(%ebp),%edx
  8028d7:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8028da:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8028de:	75 17                	jne    8028f7 <alloc_block_FF+0x104>
  8028e0:	83 ec 04             	sub    $0x4,%esp
  8028e3:	68 80 47 80 00       	push   $0x804780
  8028e8:	68 9b 00 00 00       	push   $0x9b
  8028ed:	68 d7 46 80 00       	push   $0x8046d7
  8028f2:	e8 d8 dd ff ff       	call   8006cf <_panic>
  8028f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028fa:	8b 00                	mov    (%eax),%eax
  8028fc:	85 c0                	test   %eax,%eax
  8028fe:	74 10                	je     802910 <alloc_block_FF+0x11d>
  802900:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802903:	8b 00                	mov    (%eax),%eax
  802905:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802908:	8b 52 04             	mov    0x4(%edx),%edx
  80290b:	89 50 04             	mov    %edx,0x4(%eax)
  80290e:	eb 0b                	jmp    80291b <alloc_block_FF+0x128>
  802910:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802913:	8b 40 04             	mov    0x4(%eax),%eax
  802916:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80291b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80291e:	8b 40 04             	mov    0x4(%eax),%eax
  802921:	85 c0                	test   %eax,%eax
  802923:	74 0f                	je     802934 <alloc_block_FF+0x141>
  802925:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802928:	8b 40 04             	mov    0x4(%eax),%eax
  80292b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80292e:	8b 12                	mov    (%edx),%edx
  802930:	89 10                	mov    %edx,(%eax)
  802932:	eb 0a                	jmp    80293e <alloc_block_FF+0x14b>
  802934:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802937:	8b 00                	mov    (%eax),%eax
  802939:	a3 48 51 80 00       	mov    %eax,0x805148
  80293e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802941:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802947:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80294a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802951:	a1 54 51 80 00       	mov    0x805154,%eax
  802956:	48                   	dec    %eax
  802957:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  80295c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295f:	8b 50 08             	mov    0x8(%eax),%edx
  802962:	8b 45 08             	mov    0x8(%ebp),%eax
  802965:	01 c2                	add    %eax,%edx
  802967:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296a:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  80296d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802970:	8b 40 0c             	mov    0xc(%eax),%eax
  802973:	2b 45 08             	sub    0x8(%ebp),%eax
  802976:	89 c2                	mov    %eax,%edx
  802978:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297b:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  80297e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802981:	eb 3b                	jmp    8029be <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802983:	a1 40 51 80 00       	mov    0x805140,%eax
  802988:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80298b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80298f:	74 07                	je     802998 <alloc_block_FF+0x1a5>
  802991:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802994:	8b 00                	mov    (%eax),%eax
  802996:	eb 05                	jmp    80299d <alloc_block_FF+0x1aa>
  802998:	b8 00 00 00 00       	mov    $0x0,%eax
  80299d:	a3 40 51 80 00       	mov    %eax,0x805140
  8029a2:	a1 40 51 80 00       	mov    0x805140,%eax
  8029a7:	85 c0                	test   %eax,%eax
  8029a9:	0f 85 57 fe ff ff    	jne    802806 <alloc_block_FF+0x13>
  8029af:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029b3:	0f 85 4d fe ff ff    	jne    802806 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  8029b9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029be:	c9                   	leave  
  8029bf:	c3                   	ret    

008029c0 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8029c0:	55                   	push   %ebp
  8029c1:	89 e5                	mov    %esp,%ebp
  8029c3:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  8029c6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8029cd:	a1 38 51 80 00       	mov    0x805138,%eax
  8029d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029d5:	e9 df 00 00 00       	jmp    802ab9 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  8029da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029dd:	8b 40 0c             	mov    0xc(%eax),%eax
  8029e0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029e3:	0f 82 c8 00 00 00    	jb     802ab1 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  8029e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ec:	8b 40 0c             	mov    0xc(%eax),%eax
  8029ef:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029f2:	0f 85 8a 00 00 00    	jne    802a82 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  8029f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029fc:	75 17                	jne    802a15 <alloc_block_BF+0x55>
  8029fe:	83 ec 04             	sub    $0x4,%esp
  802a01:	68 80 47 80 00       	push   $0x804780
  802a06:	68 b7 00 00 00       	push   $0xb7
  802a0b:	68 d7 46 80 00       	push   $0x8046d7
  802a10:	e8 ba dc ff ff       	call   8006cf <_panic>
  802a15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a18:	8b 00                	mov    (%eax),%eax
  802a1a:	85 c0                	test   %eax,%eax
  802a1c:	74 10                	je     802a2e <alloc_block_BF+0x6e>
  802a1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a21:	8b 00                	mov    (%eax),%eax
  802a23:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a26:	8b 52 04             	mov    0x4(%edx),%edx
  802a29:	89 50 04             	mov    %edx,0x4(%eax)
  802a2c:	eb 0b                	jmp    802a39 <alloc_block_BF+0x79>
  802a2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a31:	8b 40 04             	mov    0x4(%eax),%eax
  802a34:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802a39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3c:	8b 40 04             	mov    0x4(%eax),%eax
  802a3f:	85 c0                	test   %eax,%eax
  802a41:	74 0f                	je     802a52 <alloc_block_BF+0x92>
  802a43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a46:	8b 40 04             	mov    0x4(%eax),%eax
  802a49:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a4c:	8b 12                	mov    (%edx),%edx
  802a4e:	89 10                	mov    %edx,(%eax)
  802a50:	eb 0a                	jmp    802a5c <alloc_block_BF+0x9c>
  802a52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a55:	8b 00                	mov    (%eax),%eax
  802a57:	a3 38 51 80 00       	mov    %eax,0x805138
  802a5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a68:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a6f:	a1 44 51 80 00       	mov    0x805144,%eax
  802a74:	48                   	dec    %eax
  802a75:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802a7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7d:	e9 4d 01 00 00       	jmp    802bcf <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802a82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a85:	8b 40 0c             	mov    0xc(%eax),%eax
  802a88:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a8b:	76 24                	jbe    802ab1 <alloc_block_BF+0xf1>
  802a8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a90:	8b 40 0c             	mov    0xc(%eax),%eax
  802a93:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802a96:	73 19                	jae    802ab1 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802a98:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802a9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa2:	8b 40 0c             	mov    0xc(%eax),%eax
  802aa5:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802aa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aab:	8b 40 08             	mov    0x8(%eax),%eax
  802aae:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802ab1:	a1 40 51 80 00       	mov    0x805140,%eax
  802ab6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ab9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802abd:	74 07                	je     802ac6 <alloc_block_BF+0x106>
  802abf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac2:	8b 00                	mov    (%eax),%eax
  802ac4:	eb 05                	jmp    802acb <alloc_block_BF+0x10b>
  802ac6:	b8 00 00 00 00       	mov    $0x0,%eax
  802acb:	a3 40 51 80 00       	mov    %eax,0x805140
  802ad0:	a1 40 51 80 00       	mov    0x805140,%eax
  802ad5:	85 c0                	test   %eax,%eax
  802ad7:	0f 85 fd fe ff ff    	jne    8029da <alloc_block_BF+0x1a>
  802add:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ae1:	0f 85 f3 fe ff ff    	jne    8029da <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802ae7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802aeb:	0f 84 d9 00 00 00    	je     802bca <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802af1:	a1 48 51 80 00       	mov    0x805148,%eax
  802af6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802af9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802afc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802aff:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802b02:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b05:	8b 55 08             	mov    0x8(%ebp),%edx
  802b08:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802b0b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802b0f:	75 17                	jne    802b28 <alloc_block_BF+0x168>
  802b11:	83 ec 04             	sub    $0x4,%esp
  802b14:	68 80 47 80 00       	push   $0x804780
  802b19:	68 c7 00 00 00       	push   $0xc7
  802b1e:	68 d7 46 80 00       	push   $0x8046d7
  802b23:	e8 a7 db ff ff       	call   8006cf <_panic>
  802b28:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b2b:	8b 00                	mov    (%eax),%eax
  802b2d:	85 c0                	test   %eax,%eax
  802b2f:	74 10                	je     802b41 <alloc_block_BF+0x181>
  802b31:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b34:	8b 00                	mov    (%eax),%eax
  802b36:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802b39:	8b 52 04             	mov    0x4(%edx),%edx
  802b3c:	89 50 04             	mov    %edx,0x4(%eax)
  802b3f:	eb 0b                	jmp    802b4c <alloc_block_BF+0x18c>
  802b41:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b44:	8b 40 04             	mov    0x4(%eax),%eax
  802b47:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b4c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b4f:	8b 40 04             	mov    0x4(%eax),%eax
  802b52:	85 c0                	test   %eax,%eax
  802b54:	74 0f                	je     802b65 <alloc_block_BF+0x1a5>
  802b56:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b59:	8b 40 04             	mov    0x4(%eax),%eax
  802b5c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802b5f:	8b 12                	mov    (%edx),%edx
  802b61:	89 10                	mov    %edx,(%eax)
  802b63:	eb 0a                	jmp    802b6f <alloc_block_BF+0x1af>
  802b65:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b68:	8b 00                	mov    (%eax),%eax
  802b6a:	a3 48 51 80 00       	mov    %eax,0x805148
  802b6f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b72:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b78:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b7b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b82:	a1 54 51 80 00       	mov    0x805154,%eax
  802b87:	48                   	dec    %eax
  802b88:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802b8d:	83 ec 08             	sub    $0x8,%esp
  802b90:	ff 75 ec             	pushl  -0x14(%ebp)
  802b93:	68 38 51 80 00       	push   $0x805138
  802b98:	e8 71 f9 ff ff       	call   80250e <find_block>
  802b9d:	83 c4 10             	add    $0x10,%esp
  802ba0:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802ba3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ba6:	8b 50 08             	mov    0x8(%eax),%edx
  802ba9:	8b 45 08             	mov    0x8(%ebp),%eax
  802bac:	01 c2                	add    %eax,%edx
  802bae:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bb1:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802bb4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bb7:	8b 40 0c             	mov    0xc(%eax),%eax
  802bba:	2b 45 08             	sub    0x8(%ebp),%eax
  802bbd:	89 c2                	mov    %eax,%edx
  802bbf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bc2:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802bc5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bc8:	eb 05                	jmp    802bcf <alloc_block_BF+0x20f>
	}
	return NULL;
  802bca:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802bcf:	c9                   	leave  
  802bd0:	c3                   	ret    

00802bd1 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802bd1:	55                   	push   %ebp
  802bd2:	89 e5                	mov    %esp,%ebp
  802bd4:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802bd7:	a1 28 50 80 00       	mov    0x805028,%eax
  802bdc:	85 c0                	test   %eax,%eax
  802bde:	0f 85 de 01 00 00    	jne    802dc2 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802be4:	a1 38 51 80 00       	mov    0x805138,%eax
  802be9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bec:	e9 9e 01 00 00       	jmp    802d8f <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802bf1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf4:	8b 40 0c             	mov    0xc(%eax),%eax
  802bf7:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bfa:	0f 82 87 01 00 00    	jb     802d87 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802c00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c03:	8b 40 0c             	mov    0xc(%eax),%eax
  802c06:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c09:	0f 85 95 00 00 00    	jne    802ca4 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802c0f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c13:	75 17                	jne    802c2c <alloc_block_NF+0x5b>
  802c15:	83 ec 04             	sub    $0x4,%esp
  802c18:	68 80 47 80 00       	push   $0x804780
  802c1d:	68 e0 00 00 00       	push   $0xe0
  802c22:	68 d7 46 80 00       	push   $0x8046d7
  802c27:	e8 a3 da ff ff       	call   8006cf <_panic>
  802c2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c2f:	8b 00                	mov    (%eax),%eax
  802c31:	85 c0                	test   %eax,%eax
  802c33:	74 10                	je     802c45 <alloc_block_NF+0x74>
  802c35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c38:	8b 00                	mov    (%eax),%eax
  802c3a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c3d:	8b 52 04             	mov    0x4(%edx),%edx
  802c40:	89 50 04             	mov    %edx,0x4(%eax)
  802c43:	eb 0b                	jmp    802c50 <alloc_block_NF+0x7f>
  802c45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c48:	8b 40 04             	mov    0x4(%eax),%eax
  802c4b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c53:	8b 40 04             	mov    0x4(%eax),%eax
  802c56:	85 c0                	test   %eax,%eax
  802c58:	74 0f                	je     802c69 <alloc_block_NF+0x98>
  802c5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c5d:	8b 40 04             	mov    0x4(%eax),%eax
  802c60:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c63:	8b 12                	mov    (%edx),%edx
  802c65:	89 10                	mov    %edx,(%eax)
  802c67:	eb 0a                	jmp    802c73 <alloc_block_NF+0xa2>
  802c69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c6c:	8b 00                	mov    (%eax),%eax
  802c6e:	a3 38 51 80 00       	mov    %eax,0x805138
  802c73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c76:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c7f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c86:	a1 44 51 80 00       	mov    0x805144,%eax
  802c8b:	48                   	dec    %eax
  802c8c:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802c91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c94:	8b 40 08             	mov    0x8(%eax),%eax
  802c97:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  802c9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9f:	e9 f8 04 00 00       	jmp    80319c <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802ca4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca7:	8b 40 0c             	mov    0xc(%eax),%eax
  802caa:	3b 45 08             	cmp    0x8(%ebp),%eax
  802cad:	0f 86 d4 00 00 00    	jbe    802d87 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802cb3:	a1 48 51 80 00       	mov    0x805148,%eax
  802cb8:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802cbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cbe:	8b 50 08             	mov    0x8(%eax),%edx
  802cc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cc4:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802cc7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cca:	8b 55 08             	mov    0x8(%ebp),%edx
  802ccd:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802cd0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802cd4:	75 17                	jne    802ced <alloc_block_NF+0x11c>
  802cd6:	83 ec 04             	sub    $0x4,%esp
  802cd9:	68 80 47 80 00       	push   $0x804780
  802cde:	68 e9 00 00 00       	push   $0xe9
  802ce3:	68 d7 46 80 00       	push   $0x8046d7
  802ce8:	e8 e2 d9 ff ff       	call   8006cf <_panic>
  802ced:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cf0:	8b 00                	mov    (%eax),%eax
  802cf2:	85 c0                	test   %eax,%eax
  802cf4:	74 10                	je     802d06 <alloc_block_NF+0x135>
  802cf6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cf9:	8b 00                	mov    (%eax),%eax
  802cfb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802cfe:	8b 52 04             	mov    0x4(%edx),%edx
  802d01:	89 50 04             	mov    %edx,0x4(%eax)
  802d04:	eb 0b                	jmp    802d11 <alloc_block_NF+0x140>
  802d06:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d09:	8b 40 04             	mov    0x4(%eax),%eax
  802d0c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d11:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d14:	8b 40 04             	mov    0x4(%eax),%eax
  802d17:	85 c0                	test   %eax,%eax
  802d19:	74 0f                	je     802d2a <alloc_block_NF+0x159>
  802d1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d1e:	8b 40 04             	mov    0x4(%eax),%eax
  802d21:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d24:	8b 12                	mov    (%edx),%edx
  802d26:	89 10                	mov    %edx,(%eax)
  802d28:	eb 0a                	jmp    802d34 <alloc_block_NF+0x163>
  802d2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d2d:	8b 00                	mov    (%eax),%eax
  802d2f:	a3 48 51 80 00       	mov    %eax,0x805148
  802d34:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d37:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d40:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d47:	a1 54 51 80 00       	mov    0x805154,%eax
  802d4c:	48                   	dec    %eax
  802d4d:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802d52:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d55:	8b 40 08             	mov    0x8(%eax),%eax
  802d58:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802d5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d60:	8b 50 08             	mov    0x8(%eax),%edx
  802d63:	8b 45 08             	mov    0x8(%ebp),%eax
  802d66:	01 c2                	add    %eax,%edx
  802d68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d6b:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802d6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d71:	8b 40 0c             	mov    0xc(%eax),%eax
  802d74:	2b 45 08             	sub    0x8(%ebp),%eax
  802d77:	89 c2                	mov    %eax,%edx
  802d79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d7c:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802d7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d82:	e9 15 04 00 00       	jmp    80319c <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802d87:	a1 40 51 80 00       	mov    0x805140,%eax
  802d8c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d8f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d93:	74 07                	je     802d9c <alloc_block_NF+0x1cb>
  802d95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d98:	8b 00                	mov    (%eax),%eax
  802d9a:	eb 05                	jmp    802da1 <alloc_block_NF+0x1d0>
  802d9c:	b8 00 00 00 00       	mov    $0x0,%eax
  802da1:	a3 40 51 80 00       	mov    %eax,0x805140
  802da6:	a1 40 51 80 00       	mov    0x805140,%eax
  802dab:	85 c0                	test   %eax,%eax
  802dad:	0f 85 3e fe ff ff    	jne    802bf1 <alloc_block_NF+0x20>
  802db3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802db7:	0f 85 34 fe ff ff    	jne    802bf1 <alloc_block_NF+0x20>
  802dbd:	e9 d5 03 00 00       	jmp    803197 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802dc2:	a1 38 51 80 00       	mov    0x805138,%eax
  802dc7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802dca:	e9 b1 01 00 00       	jmp    802f80 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802dcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd2:	8b 50 08             	mov    0x8(%eax),%edx
  802dd5:	a1 28 50 80 00       	mov    0x805028,%eax
  802dda:	39 c2                	cmp    %eax,%edx
  802ddc:	0f 82 96 01 00 00    	jb     802f78 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802de2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de5:	8b 40 0c             	mov    0xc(%eax),%eax
  802de8:	3b 45 08             	cmp    0x8(%ebp),%eax
  802deb:	0f 82 87 01 00 00    	jb     802f78 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802df1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df4:	8b 40 0c             	mov    0xc(%eax),%eax
  802df7:	3b 45 08             	cmp    0x8(%ebp),%eax
  802dfa:	0f 85 95 00 00 00    	jne    802e95 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802e00:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e04:	75 17                	jne    802e1d <alloc_block_NF+0x24c>
  802e06:	83 ec 04             	sub    $0x4,%esp
  802e09:	68 80 47 80 00       	push   $0x804780
  802e0e:	68 fc 00 00 00       	push   $0xfc
  802e13:	68 d7 46 80 00       	push   $0x8046d7
  802e18:	e8 b2 d8 ff ff       	call   8006cf <_panic>
  802e1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e20:	8b 00                	mov    (%eax),%eax
  802e22:	85 c0                	test   %eax,%eax
  802e24:	74 10                	je     802e36 <alloc_block_NF+0x265>
  802e26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e29:	8b 00                	mov    (%eax),%eax
  802e2b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e2e:	8b 52 04             	mov    0x4(%edx),%edx
  802e31:	89 50 04             	mov    %edx,0x4(%eax)
  802e34:	eb 0b                	jmp    802e41 <alloc_block_NF+0x270>
  802e36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e39:	8b 40 04             	mov    0x4(%eax),%eax
  802e3c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e44:	8b 40 04             	mov    0x4(%eax),%eax
  802e47:	85 c0                	test   %eax,%eax
  802e49:	74 0f                	je     802e5a <alloc_block_NF+0x289>
  802e4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e4e:	8b 40 04             	mov    0x4(%eax),%eax
  802e51:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e54:	8b 12                	mov    (%edx),%edx
  802e56:	89 10                	mov    %edx,(%eax)
  802e58:	eb 0a                	jmp    802e64 <alloc_block_NF+0x293>
  802e5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e5d:	8b 00                	mov    (%eax),%eax
  802e5f:	a3 38 51 80 00       	mov    %eax,0x805138
  802e64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e67:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e70:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e77:	a1 44 51 80 00       	mov    0x805144,%eax
  802e7c:	48                   	dec    %eax
  802e7d:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802e82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e85:	8b 40 08             	mov    0x8(%eax),%eax
  802e88:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802e8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e90:	e9 07 03 00 00       	jmp    80319c <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802e95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e98:	8b 40 0c             	mov    0xc(%eax),%eax
  802e9b:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e9e:	0f 86 d4 00 00 00    	jbe    802f78 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802ea4:	a1 48 51 80 00       	mov    0x805148,%eax
  802ea9:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802eac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eaf:	8b 50 08             	mov    0x8(%eax),%edx
  802eb2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802eb5:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802eb8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ebb:	8b 55 08             	mov    0x8(%ebp),%edx
  802ebe:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802ec1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802ec5:	75 17                	jne    802ede <alloc_block_NF+0x30d>
  802ec7:	83 ec 04             	sub    $0x4,%esp
  802eca:	68 80 47 80 00       	push   $0x804780
  802ecf:	68 04 01 00 00       	push   $0x104
  802ed4:	68 d7 46 80 00       	push   $0x8046d7
  802ed9:	e8 f1 d7 ff ff       	call   8006cf <_panic>
  802ede:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ee1:	8b 00                	mov    (%eax),%eax
  802ee3:	85 c0                	test   %eax,%eax
  802ee5:	74 10                	je     802ef7 <alloc_block_NF+0x326>
  802ee7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802eea:	8b 00                	mov    (%eax),%eax
  802eec:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802eef:	8b 52 04             	mov    0x4(%edx),%edx
  802ef2:	89 50 04             	mov    %edx,0x4(%eax)
  802ef5:	eb 0b                	jmp    802f02 <alloc_block_NF+0x331>
  802ef7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802efa:	8b 40 04             	mov    0x4(%eax),%eax
  802efd:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f02:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f05:	8b 40 04             	mov    0x4(%eax),%eax
  802f08:	85 c0                	test   %eax,%eax
  802f0a:	74 0f                	je     802f1b <alloc_block_NF+0x34a>
  802f0c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f0f:	8b 40 04             	mov    0x4(%eax),%eax
  802f12:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f15:	8b 12                	mov    (%edx),%edx
  802f17:	89 10                	mov    %edx,(%eax)
  802f19:	eb 0a                	jmp    802f25 <alloc_block_NF+0x354>
  802f1b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f1e:	8b 00                	mov    (%eax),%eax
  802f20:	a3 48 51 80 00       	mov    %eax,0x805148
  802f25:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f28:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f2e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f31:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f38:	a1 54 51 80 00       	mov    0x805154,%eax
  802f3d:	48                   	dec    %eax
  802f3e:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802f43:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f46:	8b 40 08             	mov    0x8(%eax),%eax
  802f49:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802f4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f51:	8b 50 08             	mov    0x8(%eax),%edx
  802f54:	8b 45 08             	mov    0x8(%ebp),%eax
  802f57:	01 c2                	add    %eax,%edx
  802f59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f5c:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802f5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f62:	8b 40 0c             	mov    0xc(%eax),%eax
  802f65:	2b 45 08             	sub    0x8(%ebp),%eax
  802f68:	89 c2                	mov    %eax,%edx
  802f6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f6d:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802f70:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f73:	e9 24 02 00 00       	jmp    80319c <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802f78:	a1 40 51 80 00       	mov    0x805140,%eax
  802f7d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f80:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f84:	74 07                	je     802f8d <alloc_block_NF+0x3bc>
  802f86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f89:	8b 00                	mov    (%eax),%eax
  802f8b:	eb 05                	jmp    802f92 <alloc_block_NF+0x3c1>
  802f8d:	b8 00 00 00 00       	mov    $0x0,%eax
  802f92:	a3 40 51 80 00       	mov    %eax,0x805140
  802f97:	a1 40 51 80 00       	mov    0x805140,%eax
  802f9c:	85 c0                	test   %eax,%eax
  802f9e:	0f 85 2b fe ff ff    	jne    802dcf <alloc_block_NF+0x1fe>
  802fa4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fa8:	0f 85 21 fe ff ff    	jne    802dcf <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802fae:	a1 38 51 80 00       	mov    0x805138,%eax
  802fb3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fb6:	e9 ae 01 00 00       	jmp    803169 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802fbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fbe:	8b 50 08             	mov    0x8(%eax),%edx
  802fc1:	a1 28 50 80 00       	mov    0x805028,%eax
  802fc6:	39 c2                	cmp    %eax,%edx
  802fc8:	0f 83 93 01 00 00    	jae    803161 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802fce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd1:	8b 40 0c             	mov    0xc(%eax),%eax
  802fd4:	3b 45 08             	cmp    0x8(%ebp),%eax
  802fd7:	0f 82 84 01 00 00    	jb     803161 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802fdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe0:	8b 40 0c             	mov    0xc(%eax),%eax
  802fe3:	3b 45 08             	cmp    0x8(%ebp),%eax
  802fe6:	0f 85 95 00 00 00    	jne    803081 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802fec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ff0:	75 17                	jne    803009 <alloc_block_NF+0x438>
  802ff2:	83 ec 04             	sub    $0x4,%esp
  802ff5:	68 80 47 80 00       	push   $0x804780
  802ffa:	68 14 01 00 00       	push   $0x114
  802fff:	68 d7 46 80 00       	push   $0x8046d7
  803004:	e8 c6 d6 ff ff       	call   8006cf <_panic>
  803009:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80300c:	8b 00                	mov    (%eax),%eax
  80300e:	85 c0                	test   %eax,%eax
  803010:	74 10                	je     803022 <alloc_block_NF+0x451>
  803012:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803015:	8b 00                	mov    (%eax),%eax
  803017:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80301a:	8b 52 04             	mov    0x4(%edx),%edx
  80301d:	89 50 04             	mov    %edx,0x4(%eax)
  803020:	eb 0b                	jmp    80302d <alloc_block_NF+0x45c>
  803022:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803025:	8b 40 04             	mov    0x4(%eax),%eax
  803028:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80302d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803030:	8b 40 04             	mov    0x4(%eax),%eax
  803033:	85 c0                	test   %eax,%eax
  803035:	74 0f                	je     803046 <alloc_block_NF+0x475>
  803037:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80303a:	8b 40 04             	mov    0x4(%eax),%eax
  80303d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803040:	8b 12                	mov    (%edx),%edx
  803042:	89 10                	mov    %edx,(%eax)
  803044:	eb 0a                	jmp    803050 <alloc_block_NF+0x47f>
  803046:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803049:	8b 00                	mov    (%eax),%eax
  80304b:	a3 38 51 80 00       	mov    %eax,0x805138
  803050:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803053:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803059:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80305c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803063:	a1 44 51 80 00       	mov    0x805144,%eax
  803068:	48                   	dec    %eax
  803069:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  80306e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803071:	8b 40 08             	mov    0x8(%eax),%eax
  803074:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  803079:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80307c:	e9 1b 01 00 00       	jmp    80319c <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  803081:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803084:	8b 40 0c             	mov    0xc(%eax),%eax
  803087:	3b 45 08             	cmp    0x8(%ebp),%eax
  80308a:	0f 86 d1 00 00 00    	jbe    803161 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  803090:	a1 48 51 80 00       	mov    0x805148,%eax
  803095:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  803098:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80309b:	8b 50 08             	mov    0x8(%eax),%edx
  80309e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030a1:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8030a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030a7:	8b 55 08             	mov    0x8(%ebp),%edx
  8030aa:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8030ad:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8030b1:	75 17                	jne    8030ca <alloc_block_NF+0x4f9>
  8030b3:	83 ec 04             	sub    $0x4,%esp
  8030b6:	68 80 47 80 00       	push   $0x804780
  8030bb:	68 1c 01 00 00       	push   $0x11c
  8030c0:	68 d7 46 80 00       	push   $0x8046d7
  8030c5:	e8 05 d6 ff ff       	call   8006cf <_panic>
  8030ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030cd:	8b 00                	mov    (%eax),%eax
  8030cf:	85 c0                	test   %eax,%eax
  8030d1:	74 10                	je     8030e3 <alloc_block_NF+0x512>
  8030d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030d6:	8b 00                	mov    (%eax),%eax
  8030d8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8030db:	8b 52 04             	mov    0x4(%edx),%edx
  8030de:	89 50 04             	mov    %edx,0x4(%eax)
  8030e1:	eb 0b                	jmp    8030ee <alloc_block_NF+0x51d>
  8030e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030e6:	8b 40 04             	mov    0x4(%eax),%eax
  8030e9:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8030ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030f1:	8b 40 04             	mov    0x4(%eax),%eax
  8030f4:	85 c0                	test   %eax,%eax
  8030f6:	74 0f                	je     803107 <alloc_block_NF+0x536>
  8030f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030fb:	8b 40 04             	mov    0x4(%eax),%eax
  8030fe:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803101:	8b 12                	mov    (%edx),%edx
  803103:	89 10                	mov    %edx,(%eax)
  803105:	eb 0a                	jmp    803111 <alloc_block_NF+0x540>
  803107:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80310a:	8b 00                	mov    (%eax),%eax
  80310c:	a3 48 51 80 00       	mov    %eax,0x805148
  803111:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803114:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80311a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80311d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803124:	a1 54 51 80 00       	mov    0x805154,%eax
  803129:	48                   	dec    %eax
  80312a:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  80312f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803132:	8b 40 08             	mov    0x8(%eax),%eax
  803135:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  80313a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80313d:	8b 50 08             	mov    0x8(%eax),%edx
  803140:	8b 45 08             	mov    0x8(%ebp),%eax
  803143:	01 c2                	add    %eax,%edx
  803145:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803148:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  80314b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80314e:	8b 40 0c             	mov    0xc(%eax),%eax
  803151:	2b 45 08             	sub    0x8(%ebp),%eax
  803154:	89 c2                	mov    %eax,%edx
  803156:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803159:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  80315c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80315f:	eb 3b                	jmp    80319c <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  803161:	a1 40 51 80 00       	mov    0x805140,%eax
  803166:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803169:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80316d:	74 07                	je     803176 <alloc_block_NF+0x5a5>
  80316f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803172:	8b 00                	mov    (%eax),%eax
  803174:	eb 05                	jmp    80317b <alloc_block_NF+0x5aa>
  803176:	b8 00 00 00 00       	mov    $0x0,%eax
  80317b:	a3 40 51 80 00       	mov    %eax,0x805140
  803180:	a1 40 51 80 00       	mov    0x805140,%eax
  803185:	85 c0                	test   %eax,%eax
  803187:	0f 85 2e fe ff ff    	jne    802fbb <alloc_block_NF+0x3ea>
  80318d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803191:	0f 85 24 fe ff ff    	jne    802fbb <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  803197:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80319c:	c9                   	leave  
  80319d:	c3                   	ret    

0080319e <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  80319e:	55                   	push   %ebp
  80319f:	89 e5                	mov    %esp,%ebp
  8031a1:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  8031a4:	a1 38 51 80 00       	mov    0x805138,%eax
  8031a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  8031ac:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8031b1:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  8031b4:	a1 38 51 80 00       	mov    0x805138,%eax
  8031b9:	85 c0                	test   %eax,%eax
  8031bb:	74 14                	je     8031d1 <insert_sorted_with_merge_freeList+0x33>
  8031bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c0:	8b 50 08             	mov    0x8(%eax),%edx
  8031c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031c6:	8b 40 08             	mov    0x8(%eax),%eax
  8031c9:	39 c2                	cmp    %eax,%edx
  8031cb:	0f 87 9b 01 00 00    	ja     80336c <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  8031d1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031d5:	75 17                	jne    8031ee <insert_sorted_with_merge_freeList+0x50>
  8031d7:	83 ec 04             	sub    $0x4,%esp
  8031da:	68 b4 46 80 00       	push   $0x8046b4
  8031df:	68 38 01 00 00       	push   $0x138
  8031e4:	68 d7 46 80 00       	push   $0x8046d7
  8031e9:	e8 e1 d4 ff ff       	call   8006cf <_panic>
  8031ee:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8031f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f7:	89 10                	mov    %edx,(%eax)
  8031f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8031fc:	8b 00                	mov    (%eax),%eax
  8031fe:	85 c0                	test   %eax,%eax
  803200:	74 0d                	je     80320f <insert_sorted_with_merge_freeList+0x71>
  803202:	a1 38 51 80 00       	mov    0x805138,%eax
  803207:	8b 55 08             	mov    0x8(%ebp),%edx
  80320a:	89 50 04             	mov    %edx,0x4(%eax)
  80320d:	eb 08                	jmp    803217 <insert_sorted_with_merge_freeList+0x79>
  80320f:	8b 45 08             	mov    0x8(%ebp),%eax
  803212:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803217:	8b 45 08             	mov    0x8(%ebp),%eax
  80321a:	a3 38 51 80 00       	mov    %eax,0x805138
  80321f:	8b 45 08             	mov    0x8(%ebp),%eax
  803222:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803229:	a1 44 51 80 00       	mov    0x805144,%eax
  80322e:	40                   	inc    %eax
  80322f:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803234:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803238:	0f 84 a8 06 00 00    	je     8038e6 <insert_sorted_with_merge_freeList+0x748>
  80323e:	8b 45 08             	mov    0x8(%ebp),%eax
  803241:	8b 50 08             	mov    0x8(%eax),%edx
  803244:	8b 45 08             	mov    0x8(%ebp),%eax
  803247:	8b 40 0c             	mov    0xc(%eax),%eax
  80324a:	01 c2                	add    %eax,%edx
  80324c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80324f:	8b 40 08             	mov    0x8(%eax),%eax
  803252:	39 c2                	cmp    %eax,%edx
  803254:	0f 85 8c 06 00 00    	jne    8038e6 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  80325a:	8b 45 08             	mov    0x8(%ebp),%eax
  80325d:	8b 50 0c             	mov    0xc(%eax),%edx
  803260:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803263:	8b 40 0c             	mov    0xc(%eax),%eax
  803266:	01 c2                	add    %eax,%edx
  803268:	8b 45 08             	mov    0x8(%ebp),%eax
  80326b:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  80326e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803272:	75 17                	jne    80328b <insert_sorted_with_merge_freeList+0xed>
  803274:	83 ec 04             	sub    $0x4,%esp
  803277:	68 80 47 80 00       	push   $0x804780
  80327c:	68 3c 01 00 00       	push   $0x13c
  803281:	68 d7 46 80 00       	push   $0x8046d7
  803286:	e8 44 d4 ff ff       	call   8006cf <_panic>
  80328b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80328e:	8b 00                	mov    (%eax),%eax
  803290:	85 c0                	test   %eax,%eax
  803292:	74 10                	je     8032a4 <insert_sorted_with_merge_freeList+0x106>
  803294:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803297:	8b 00                	mov    (%eax),%eax
  803299:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80329c:	8b 52 04             	mov    0x4(%edx),%edx
  80329f:	89 50 04             	mov    %edx,0x4(%eax)
  8032a2:	eb 0b                	jmp    8032af <insert_sorted_with_merge_freeList+0x111>
  8032a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032a7:	8b 40 04             	mov    0x4(%eax),%eax
  8032aa:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8032af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032b2:	8b 40 04             	mov    0x4(%eax),%eax
  8032b5:	85 c0                	test   %eax,%eax
  8032b7:	74 0f                	je     8032c8 <insert_sorted_with_merge_freeList+0x12a>
  8032b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032bc:	8b 40 04             	mov    0x4(%eax),%eax
  8032bf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8032c2:	8b 12                	mov    (%edx),%edx
  8032c4:	89 10                	mov    %edx,(%eax)
  8032c6:	eb 0a                	jmp    8032d2 <insert_sorted_with_merge_freeList+0x134>
  8032c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032cb:	8b 00                	mov    (%eax),%eax
  8032cd:	a3 38 51 80 00       	mov    %eax,0x805138
  8032d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032d5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032de:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032e5:	a1 44 51 80 00       	mov    0x805144,%eax
  8032ea:	48                   	dec    %eax
  8032eb:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  8032f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032f3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  8032fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032fd:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  803304:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803308:	75 17                	jne    803321 <insert_sorted_with_merge_freeList+0x183>
  80330a:	83 ec 04             	sub    $0x4,%esp
  80330d:	68 b4 46 80 00       	push   $0x8046b4
  803312:	68 3f 01 00 00       	push   $0x13f
  803317:	68 d7 46 80 00       	push   $0x8046d7
  80331c:	e8 ae d3 ff ff       	call   8006cf <_panic>
  803321:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803327:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80332a:	89 10                	mov    %edx,(%eax)
  80332c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80332f:	8b 00                	mov    (%eax),%eax
  803331:	85 c0                	test   %eax,%eax
  803333:	74 0d                	je     803342 <insert_sorted_with_merge_freeList+0x1a4>
  803335:	a1 48 51 80 00       	mov    0x805148,%eax
  80333a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80333d:	89 50 04             	mov    %edx,0x4(%eax)
  803340:	eb 08                	jmp    80334a <insert_sorted_with_merge_freeList+0x1ac>
  803342:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803345:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80334a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80334d:	a3 48 51 80 00       	mov    %eax,0x805148
  803352:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803355:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80335c:	a1 54 51 80 00       	mov    0x805154,%eax
  803361:	40                   	inc    %eax
  803362:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803367:	e9 7a 05 00 00       	jmp    8038e6 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  80336c:	8b 45 08             	mov    0x8(%ebp),%eax
  80336f:	8b 50 08             	mov    0x8(%eax),%edx
  803372:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803375:	8b 40 08             	mov    0x8(%eax),%eax
  803378:	39 c2                	cmp    %eax,%edx
  80337a:	0f 82 14 01 00 00    	jb     803494 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  803380:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803383:	8b 50 08             	mov    0x8(%eax),%edx
  803386:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803389:	8b 40 0c             	mov    0xc(%eax),%eax
  80338c:	01 c2                	add    %eax,%edx
  80338e:	8b 45 08             	mov    0x8(%ebp),%eax
  803391:	8b 40 08             	mov    0x8(%eax),%eax
  803394:	39 c2                	cmp    %eax,%edx
  803396:	0f 85 90 00 00 00    	jne    80342c <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  80339c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80339f:	8b 50 0c             	mov    0xc(%eax),%edx
  8033a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a5:	8b 40 0c             	mov    0xc(%eax),%eax
  8033a8:	01 c2                	add    %eax,%edx
  8033aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033ad:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  8033b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  8033ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8033bd:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8033c4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033c8:	75 17                	jne    8033e1 <insert_sorted_with_merge_freeList+0x243>
  8033ca:	83 ec 04             	sub    $0x4,%esp
  8033cd:	68 b4 46 80 00       	push   $0x8046b4
  8033d2:	68 49 01 00 00       	push   $0x149
  8033d7:	68 d7 46 80 00       	push   $0x8046d7
  8033dc:	e8 ee d2 ff ff       	call   8006cf <_panic>
  8033e1:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8033e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ea:	89 10                	mov    %edx,(%eax)
  8033ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ef:	8b 00                	mov    (%eax),%eax
  8033f1:	85 c0                	test   %eax,%eax
  8033f3:	74 0d                	je     803402 <insert_sorted_with_merge_freeList+0x264>
  8033f5:	a1 48 51 80 00       	mov    0x805148,%eax
  8033fa:	8b 55 08             	mov    0x8(%ebp),%edx
  8033fd:	89 50 04             	mov    %edx,0x4(%eax)
  803400:	eb 08                	jmp    80340a <insert_sorted_with_merge_freeList+0x26c>
  803402:	8b 45 08             	mov    0x8(%ebp),%eax
  803405:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80340a:	8b 45 08             	mov    0x8(%ebp),%eax
  80340d:	a3 48 51 80 00       	mov    %eax,0x805148
  803412:	8b 45 08             	mov    0x8(%ebp),%eax
  803415:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80341c:	a1 54 51 80 00       	mov    0x805154,%eax
  803421:	40                   	inc    %eax
  803422:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803427:	e9 bb 04 00 00       	jmp    8038e7 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  80342c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803430:	75 17                	jne    803449 <insert_sorted_with_merge_freeList+0x2ab>
  803432:	83 ec 04             	sub    $0x4,%esp
  803435:	68 28 47 80 00       	push   $0x804728
  80343a:	68 4c 01 00 00       	push   $0x14c
  80343f:	68 d7 46 80 00       	push   $0x8046d7
  803444:	e8 86 d2 ff ff       	call   8006cf <_panic>
  803449:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  80344f:	8b 45 08             	mov    0x8(%ebp),%eax
  803452:	89 50 04             	mov    %edx,0x4(%eax)
  803455:	8b 45 08             	mov    0x8(%ebp),%eax
  803458:	8b 40 04             	mov    0x4(%eax),%eax
  80345b:	85 c0                	test   %eax,%eax
  80345d:	74 0c                	je     80346b <insert_sorted_with_merge_freeList+0x2cd>
  80345f:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803464:	8b 55 08             	mov    0x8(%ebp),%edx
  803467:	89 10                	mov    %edx,(%eax)
  803469:	eb 08                	jmp    803473 <insert_sorted_with_merge_freeList+0x2d5>
  80346b:	8b 45 08             	mov    0x8(%ebp),%eax
  80346e:	a3 38 51 80 00       	mov    %eax,0x805138
  803473:	8b 45 08             	mov    0x8(%ebp),%eax
  803476:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80347b:	8b 45 08             	mov    0x8(%ebp),%eax
  80347e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803484:	a1 44 51 80 00       	mov    0x805144,%eax
  803489:	40                   	inc    %eax
  80348a:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80348f:	e9 53 04 00 00       	jmp    8038e7 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803494:	a1 38 51 80 00       	mov    0x805138,%eax
  803499:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80349c:	e9 15 04 00 00       	jmp    8038b6 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  8034a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034a4:	8b 00                	mov    (%eax),%eax
  8034a6:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  8034a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ac:	8b 50 08             	mov    0x8(%eax),%edx
  8034af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034b2:	8b 40 08             	mov    0x8(%eax),%eax
  8034b5:	39 c2                	cmp    %eax,%edx
  8034b7:	0f 86 f1 03 00 00    	jbe    8038ae <insert_sorted_with_merge_freeList+0x710>
  8034bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8034c0:	8b 50 08             	mov    0x8(%eax),%edx
  8034c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034c6:	8b 40 08             	mov    0x8(%eax),%eax
  8034c9:	39 c2                	cmp    %eax,%edx
  8034cb:	0f 83 dd 03 00 00    	jae    8038ae <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  8034d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034d4:	8b 50 08             	mov    0x8(%eax),%edx
  8034d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034da:	8b 40 0c             	mov    0xc(%eax),%eax
  8034dd:	01 c2                	add    %eax,%edx
  8034df:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e2:	8b 40 08             	mov    0x8(%eax),%eax
  8034e5:	39 c2                	cmp    %eax,%edx
  8034e7:	0f 85 b9 01 00 00    	jne    8036a6 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8034ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8034f0:	8b 50 08             	mov    0x8(%eax),%edx
  8034f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8034f6:	8b 40 0c             	mov    0xc(%eax),%eax
  8034f9:	01 c2                	add    %eax,%edx
  8034fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034fe:	8b 40 08             	mov    0x8(%eax),%eax
  803501:	39 c2                	cmp    %eax,%edx
  803503:	0f 85 0d 01 00 00    	jne    803616 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  803509:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80350c:	8b 50 0c             	mov    0xc(%eax),%edx
  80350f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803512:	8b 40 0c             	mov    0xc(%eax),%eax
  803515:	01 c2                	add    %eax,%edx
  803517:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80351a:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80351d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803521:	75 17                	jne    80353a <insert_sorted_with_merge_freeList+0x39c>
  803523:	83 ec 04             	sub    $0x4,%esp
  803526:	68 80 47 80 00       	push   $0x804780
  80352b:	68 5c 01 00 00       	push   $0x15c
  803530:	68 d7 46 80 00       	push   $0x8046d7
  803535:	e8 95 d1 ff ff       	call   8006cf <_panic>
  80353a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80353d:	8b 00                	mov    (%eax),%eax
  80353f:	85 c0                	test   %eax,%eax
  803541:	74 10                	je     803553 <insert_sorted_with_merge_freeList+0x3b5>
  803543:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803546:	8b 00                	mov    (%eax),%eax
  803548:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80354b:	8b 52 04             	mov    0x4(%edx),%edx
  80354e:	89 50 04             	mov    %edx,0x4(%eax)
  803551:	eb 0b                	jmp    80355e <insert_sorted_with_merge_freeList+0x3c0>
  803553:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803556:	8b 40 04             	mov    0x4(%eax),%eax
  803559:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80355e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803561:	8b 40 04             	mov    0x4(%eax),%eax
  803564:	85 c0                	test   %eax,%eax
  803566:	74 0f                	je     803577 <insert_sorted_with_merge_freeList+0x3d9>
  803568:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80356b:	8b 40 04             	mov    0x4(%eax),%eax
  80356e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803571:	8b 12                	mov    (%edx),%edx
  803573:	89 10                	mov    %edx,(%eax)
  803575:	eb 0a                	jmp    803581 <insert_sorted_with_merge_freeList+0x3e3>
  803577:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80357a:	8b 00                	mov    (%eax),%eax
  80357c:	a3 38 51 80 00       	mov    %eax,0x805138
  803581:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803584:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80358a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80358d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803594:	a1 44 51 80 00       	mov    0x805144,%eax
  803599:	48                   	dec    %eax
  80359a:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  80359f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035a2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  8035a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035ac:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8035b3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8035b7:	75 17                	jne    8035d0 <insert_sorted_with_merge_freeList+0x432>
  8035b9:	83 ec 04             	sub    $0x4,%esp
  8035bc:	68 b4 46 80 00       	push   $0x8046b4
  8035c1:	68 5f 01 00 00       	push   $0x15f
  8035c6:	68 d7 46 80 00       	push   $0x8046d7
  8035cb:	e8 ff d0 ff ff       	call   8006cf <_panic>
  8035d0:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8035d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035d9:	89 10                	mov    %edx,(%eax)
  8035db:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035de:	8b 00                	mov    (%eax),%eax
  8035e0:	85 c0                	test   %eax,%eax
  8035e2:	74 0d                	je     8035f1 <insert_sorted_with_merge_freeList+0x453>
  8035e4:	a1 48 51 80 00       	mov    0x805148,%eax
  8035e9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8035ec:	89 50 04             	mov    %edx,0x4(%eax)
  8035ef:	eb 08                	jmp    8035f9 <insert_sorted_with_merge_freeList+0x45b>
  8035f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035f4:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8035f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035fc:	a3 48 51 80 00       	mov    %eax,0x805148
  803601:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803604:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80360b:	a1 54 51 80 00       	mov    0x805154,%eax
  803610:	40                   	inc    %eax
  803611:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803616:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803619:	8b 50 0c             	mov    0xc(%eax),%edx
  80361c:	8b 45 08             	mov    0x8(%ebp),%eax
  80361f:	8b 40 0c             	mov    0xc(%eax),%eax
  803622:	01 c2                	add    %eax,%edx
  803624:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803627:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  80362a:	8b 45 08             	mov    0x8(%ebp),%eax
  80362d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803634:	8b 45 08             	mov    0x8(%ebp),%eax
  803637:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80363e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803642:	75 17                	jne    80365b <insert_sorted_with_merge_freeList+0x4bd>
  803644:	83 ec 04             	sub    $0x4,%esp
  803647:	68 b4 46 80 00       	push   $0x8046b4
  80364c:	68 64 01 00 00       	push   $0x164
  803651:	68 d7 46 80 00       	push   $0x8046d7
  803656:	e8 74 d0 ff ff       	call   8006cf <_panic>
  80365b:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803661:	8b 45 08             	mov    0x8(%ebp),%eax
  803664:	89 10                	mov    %edx,(%eax)
  803666:	8b 45 08             	mov    0x8(%ebp),%eax
  803669:	8b 00                	mov    (%eax),%eax
  80366b:	85 c0                	test   %eax,%eax
  80366d:	74 0d                	je     80367c <insert_sorted_with_merge_freeList+0x4de>
  80366f:	a1 48 51 80 00       	mov    0x805148,%eax
  803674:	8b 55 08             	mov    0x8(%ebp),%edx
  803677:	89 50 04             	mov    %edx,0x4(%eax)
  80367a:	eb 08                	jmp    803684 <insert_sorted_with_merge_freeList+0x4e6>
  80367c:	8b 45 08             	mov    0x8(%ebp),%eax
  80367f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803684:	8b 45 08             	mov    0x8(%ebp),%eax
  803687:	a3 48 51 80 00       	mov    %eax,0x805148
  80368c:	8b 45 08             	mov    0x8(%ebp),%eax
  80368f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803696:	a1 54 51 80 00       	mov    0x805154,%eax
  80369b:	40                   	inc    %eax
  80369c:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8036a1:	e9 41 02 00 00       	jmp    8038e7 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8036a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8036a9:	8b 50 08             	mov    0x8(%eax),%edx
  8036ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8036af:	8b 40 0c             	mov    0xc(%eax),%eax
  8036b2:	01 c2                	add    %eax,%edx
  8036b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036b7:	8b 40 08             	mov    0x8(%eax),%eax
  8036ba:	39 c2                	cmp    %eax,%edx
  8036bc:	0f 85 7c 01 00 00    	jne    80383e <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  8036c2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8036c6:	74 06                	je     8036ce <insert_sorted_with_merge_freeList+0x530>
  8036c8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8036cc:	75 17                	jne    8036e5 <insert_sorted_with_merge_freeList+0x547>
  8036ce:	83 ec 04             	sub    $0x4,%esp
  8036d1:	68 f0 46 80 00       	push   $0x8046f0
  8036d6:	68 69 01 00 00       	push   $0x169
  8036db:	68 d7 46 80 00       	push   $0x8046d7
  8036e0:	e8 ea cf ff ff       	call   8006cf <_panic>
  8036e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036e8:	8b 50 04             	mov    0x4(%eax),%edx
  8036eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8036ee:	89 50 04             	mov    %edx,0x4(%eax)
  8036f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8036f4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8036f7:	89 10                	mov    %edx,(%eax)
  8036f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036fc:	8b 40 04             	mov    0x4(%eax),%eax
  8036ff:	85 c0                	test   %eax,%eax
  803701:	74 0d                	je     803710 <insert_sorted_with_merge_freeList+0x572>
  803703:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803706:	8b 40 04             	mov    0x4(%eax),%eax
  803709:	8b 55 08             	mov    0x8(%ebp),%edx
  80370c:	89 10                	mov    %edx,(%eax)
  80370e:	eb 08                	jmp    803718 <insert_sorted_with_merge_freeList+0x57a>
  803710:	8b 45 08             	mov    0x8(%ebp),%eax
  803713:	a3 38 51 80 00       	mov    %eax,0x805138
  803718:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80371b:	8b 55 08             	mov    0x8(%ebp),%edx
  80371e:	89 50 04             	mov    %edx,0x4(%eax)
  803721:	a1 44 51 80 00       	mov    0x805144,%eax
  803726:	40                   	inc    %eax
  803727:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  80372c:	8b 45 08             	mov    0x8(%ebp),%eax
  80372f:	8b 50 0c             	mov    0xc(%eax),%edx
  803732:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803735:	8b 40 0c             	mov    0xc(%eax),%eax
  803738:	01 c2                	add    %eax,%edx
  80373a:	8b 45 08             	mov    0x8(%ebp),%eax
  80373d:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803740:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803744:	75 17                	jne    80375d <insert_sorted_with_merge_freeList+0x5bf>
  803746:	83 ec 04             	sub    $0x4,%esp
  803749:	68 80 47 80 00       	push   $0x804780
  80374e:	68 6b 01 00 00       	push   $0x16b
  803753:	68 d7 46 80 00       	push   $0x8046d7
  803758:	e8 72 cf ff ff       	call   8006cf <_panic>
  80375d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803760:	8b 00                	mov    (%eax),%eax
  803762:	85 c0                	test   %eax,%eax
  803764:	74 10                	je     803776 <insert_sorted_with_merge_freeList+0x5d8>
  803766:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803769:	8b 00                	mov    (%eax),%eax
  80376b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80376e:	8b 52 04             	mov    0x4(%edx),%edx
  803771:	89 50 04             	mov    %edx,0x4(%eax)
  803774:	eb 0b                	jmp    803781 <insert_sorted_with_merge_freeList+0x5e3>
  803776:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803779:	8b 40 04             	mov    0x4(%eax),%eax
  80377c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803781:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803784:	8b 40 04             	mov    0x4(%eax),%eax
  803787:	85 c0                	test   %eax,%eax
  803789:	74 0f                	je     80379a <insert_sorted_with_merge_freeList+0x5fc>
  80378b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80378e:	8b 40 04             	mov    0x4(%eax),%eax
  803791:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803794:	8b 12                	mov    (%edx),%edx
  803796:	89 10                	mov    %edx,(%eax)
  803798:	eb 0a                	jmp    8037a4 <insert_sorted_with_merge_freeList+0x606>
  80379a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80379d:	8b 00                	mov    (%eax),%eax
  80379f:	a3 38 51 80 00       	mov    %eax,0x805138
  8037a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037a7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037b0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037b7:	a1 44 51 80 00       	mov    0x805144,%eax
  8037bc:	48                   	dec    %eax
  8037bd:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  8037c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037c5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  8037cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037cf:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8037d6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8037da:	75 17                	jne    8037f3 <insert_sorted_with_merge_freeList+0x655>
  8037dc:	83 ec 04             	sub    $0x4,%esp
  8037df:	68 b4 46 80 00       	push   $0x8046b4
  8037e4:	68 6e 01 00 00       	push   $0x16e
  8037e9:	68 d7 46 80 00       	push   $0x8046d7
  8037ee:	e8 dc ce ff ff       	call   8006cf <_panic>
  8037f3:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8037f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037fc:	89 10                	mov    %edx,(%eax)
  8037fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803801:	8b 00                	mov    (%eax),%eax
  803803:	85 c0                	test   %eax,%eax
  803805:	74 0d                	je     803814 <insert_sorted_with_merge_freeList+0x676>
  803807:	a1 48 51 80 00       	mov    0x805148,%eax
  80380c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80380f:	89 50 04             	mov    %edx,0x4(%eax)
  803812:	eb 08                	jmp    80381c <insert_sorted_with_merge_freeList+0x67e>
  803814:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803817:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80381c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80381f:	a3 48 51 80 00       	mov    %eax,0x805148
  803824:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803827:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80382e:	a1 54 51 80 00       	mov    0x805154,%eax
  803833:	40                   	inc    %eax
  803834:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803839:	e9 a9 00 00 00       	jmp    8038e7 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  80383e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803842:	74 06                	je     80384a <insert_sorted_with_merge_freeList+0x6ac>
  803844:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803848:	75 17                	jne    803861 <insert_sorted_with_merge_freeList+0x6c3>
  80384a:	83 ec 04             	sub    $0x4,%esp
  80384d:	68 4c 47 80 00       	push   $0x80474c
  803852:	68 73 01 00 00       	push   $0x173
  803857:	68 d7 46 80 00       	push   $0x8046d7
  80385c:	e8 6e ce ff ff       	call   8006cf <_panic>
  803861:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803864:	8b 10                	mov    (%eax),%edx
  803866:	8b 45 08             	mov    0x8(%ebp),%eax
  803869:	89 10                	mov    %edx,(%eax)
  80386b:	8b 45 08             	mov    0x8(%ebp),%eax
  80386e:	8b 00                	mov    (%eax),%eax
  803870:	85 c0                	test   %eax,%eax
  803872:	74 0b                	je     80387f <insert_sorted_with_merge_freeList+0x6e1>
  803874:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803877:	8b 00                	mov    (%eax),%eax
  803879:	8b 55 08             	mov    0x8(%ebp),%edx
  80387c:	89 50 04             	mov    %edx,0x4(%eax)
  80387f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803882:	8b 55 08             	mov    0x8(%ebp),%edx
  803885:	89 10                	mov    %edx,(%eax)
  803887:	8b 45 08             	mov    0x8(%ebp),%eax
  80388a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80388d:	89 50 04             	mov    %edx,0x4(%eax)
  803890:	8b 45 08             	mov    0x8(%ebp),%eax
  803893:	8b 00                	mov    (%eax),%eax
  803895:	85 c0                	test   %eax,%eax
  803897:	75 08                	jne    8038a1 <insert_sorted_with_merge_freeList+0x703>
  803899:	8b 45 08             	mov    0x8(%ebp),%eax
  80389c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8038a1:	a1 44 51 80 00       	mov    0x805144,%eax
  8038a6:	40                   	inc    %eax
  8038a7:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  8038ac:	eb 39                	jmp    8038e7 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8038ae:	a1 40 51 80 00       	mov    0x805140,%eax
  8038b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8038b6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8038ba:	74 07                	je     8038c3 <insert_sorted_with_merge_freeList+0x725>
  8038bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038bf:	8b 00                	mov    (%eax),%eax
  8038c1:	eb 05                	jmp    8038c8 <insert_sorted_with_merge_freeList+0x72a>
  8038c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8038c8:	a3 40 51 80 00       	mov    %eax,0x805140
  8038cd:	a1 40 51 80 00       	mov    0x805140,%eax
  8038d2:	85 c0                	test   %eax,%eax
  8038d4:	0f 85 c7 fb ff ff    	jne    8034a1 <insert_sorted_with_merge_freeList+0x303>
  8038da:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8038de:	0f 85 bd fb ff ff    	jne    8034a1 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8038e4:	eb 01                	jmp    8038e7 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8038e6:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8038e7:	90                   	nop
  8038e8:	c9                   	leave  
  8038e9:	c3                   	ret    
  8038ea:	66 90                	xchg   %ax,%ax

008038ec <__udivdi3>:
  8038ec:	55                   	push   %ebp
  8038ed:	57                   	push   %edi
  8038ee:	56                   	push   %esi
  8038ef:	53                   	push   %ebx
  8038f0:	83 ec 1c             	sub    $0x1c,%esp
  8038f3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8038f7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8038fb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8038ff:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803903:	89 ca                	mov    %ecx,%edx
  803905:	89 f8                	mov    %edi,%eax
  803907:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80390b:	85 f6                	test   %esi,%esi
  80390d:	75 2d                	jne    80393c <__udivdi3+0x50>
  80390f:	39 cf                	cmp    %ecx,%edi
  803911:	77 65                	ja     803978 <__udivdi3+0x8c>
  803913:	89 fd                	mov    %edi,%ebp
  803915:	85 ff                	test   %edi,%edi
  803917:	75 0b                	jne    803924 <__udivdi3+0x38>
  803919:	b8 01 00 00 00       	mov    $0x1,%eax
  80391e:	31 d2                	xor    %edx,%edx
  803920:	f7 f7                	div    %edi
  803922:	89 c5                	mov    %eax,%ebp
  803924:	31 d2                	xor    %edx,%edx
  803926:	89 c8                	mov    %ecx,%eax
  803928:	f7 f5                	div    %ebp
  80392a:	89 c1                	mov    %eax,%ecx
  80392c:	89 d8                	mov    %ebx,%eax
  80392e:	f7 f5                	div    %ebp
  803930:	89 cf                	mov    %ecx,%edi
  803932:	89 fa                	mov    %edi,%edx
  803934:	83 c4 1c             	add    $0x1c,%esp
  803937:	5b                   	pop    %ebx
  803938:	5e                   	pop    %esi
  803939:	5f                   	pop    %edi
  80393a:	5d                   	pop    %ebp
  80393b:	c3                   	ret    
  80393c:	39 ce                	cmp    %ecx,%esi
  80393e:	77 28                	ja     803968 <__udivdi3+0x7c>
  803940:	0f bd fe             	bsr    %esi,%edi
  803943:	83 f7 1f             	xor    $0x1f,%edi
  803946:	75 40                	jne    803988 <__udivdi3+0x9c>
  803948:	39 ce                	cmp    %ecx,%esi
  80394a:	72 0a                	jb     803956 <__udivdi3+0x6a>
  80394c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803950:	0f 87 9e 00 00 00    	ja     8039f4 <__udivdi3+0x108>
  803956:	b8 01 00 00 00       	mov    $0x1,%eax
  80395b:	89 fa                	mov    %edi,%edx
  80395d:	83 c4 1c             	add    $0x1c,%esp
  803960:	5b                   	pop    %ebx
  803961:	5e                   	pop    %esi
  803962:	5f                   	pop    %edi
  803963:	5d                   	pop    %ebp
  803964:	c3                   	ret    
  803965:	8d 76 00             	lea    0x0(%esi),%esi
  803968:	31 ff                	xor    %edi,%edi
  80396a:	31 c0                	xor    %eax,%eax
  80396c:	89 fa                	mov    %edi,%edx
  80396e:	83 c4 1c             	add    $0x1c,%esp
  803971:	5b                   	pop    %ebx
  803972:	5e                   	pop    %esi
  803973:	5f                   	pop    %edi
  803974:	5d                   	pop    %ebp
  803975:	c3                   	ret    
  803976:	66 90                	xchg   %ax,%ax
  803978:	89 d8                	mov    %ebx,%eax
  80397a:	f7 f7                	div    %edi
  80397c:	31 ff                	xor    %edi,%edi
  80397e:	89 fa                	mov    %edi,%edx
  803980:	83 c4 1c             	add    $0x1c,%esp
  803983:	5b                   	pop    %ebx
  803984:	5e                   	pop    %esi
  803985:	5f                   	pop    %edi
  803986:	5d                   	pop    %ebp
  803987:	c3                   	ret    
  803988:	bd 20 00 00 00       	mov    $0x20,%ebp
  80398d:	89 eb                	mov    %ebp,%ebx
  80398f:	29 fb                	sub    %edi,%ebx
  803991:	89 f9                	mov    %edi,%ecx
  803993:	d3 e6                	shl    %cl,%esi
  803995:	89 c5                	mov    %eax,%ebp
  803997:	88 d9                	mov    %bl,%cl
  803999:	d3 ed                	shr    %cl,%ebp
  80399b:	89 e9                	mov    %ebp,%ecx
  80399d:	09 f1                	or     %esi,%ecx
  80399f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8039a3:	89 f9                	mov    %edi,%ecx
  8039a5:	d3 e0                	shl    %cl,%eax
  8039a7:	89 c5                	mov    %eax,%ebp
  8039a9:	89 d6                	mov    %edx,%esi
  8039ab:	88 d9                	mov    %bl,%cl
  8039ad:	d3 ee                	shr    %cl,%esi
  8039af:	89 f9                	mov    %edi,%ecx
  8039b1:	d3 e2                	shl    %cl,%edx
  8039b3:	8b 44 24 08          	mov    0x8(%esp),%eax
  8039b7:	88 d9                	mov    %bl,%cl
  8039b9:	d3 e8                	shr    %cl,%eax
  8039bb:	09 c2                	or     %eax,%edx
  8039bd:	89 d0                	mov    %edx,%eax
  8039bf:	89 f2                	mov    %esi,%edx
  8039c1:	f7 74 24 0c          	divl   0xc(%esp)
  8039c5:	89 d6                	mov    %edx,%esi
  8039c7:	89 c3                	mov    %eax,%ebx
  8039c9:	f7 e5                	mul    %ebp
  8039cb:	39 d6                	cmp    %edx,%esi
  8039cd:	72 19                	jb     8039e8 <__udivdi3+0xfc>
  8039cf:	74 0b                	je     8039dc <__udivdi3+0xf0>
  8039d1:	89 d8                	mov    %ebx,%eax
  8039d3:	31 ff                	xor    %edi,%edi
  8039d5:	e9 58 ff ff ff       	jmp    803932 <__udivdi3+0x46>
  8039da:	66 90                	xchg   %ax,%ax
  8039dc:	8b 54 24 08          	mov    0x8(%esp),%edx
  8039e0:	89 f9                	mov    %edi,%ecx
  8039e2:	d3 e2                	shl    %cl,%edx
  8039e4:	39 c2                	cmp    %eax,%edx
  8039e6:	73 e9                	jae    8039d1 <__udivdi3+0xe5>
  8039e8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8039eb:	31 ff                	xor    %edi,%edi
  8039ed:	e9 40 ff ff ff       	jmp    803932 <__udivdi3+0x46>
  8039f2:	66 90                	xchg   %ax,%ax
  8039f4:	31 c0                	xor    %eax,%eax
  8039f6:	e9 37 ff ff ff       	jmp    803932 <__udivdi3+0x46>
  8039fb:	90                   	nop

008039fc <__umoddi3>:
  8039fc:	55                   	push   %ebp
  8039fd:	57                   	push   %edi
  8039fe:	56                   	push   %esi
  8039ff:	53                   	push   %ebx
  803a00:	83 ec 1c             	sub    $0x1c,%esp
  803a03:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803a07:	8b 74 24 34          	mov    0x34(%esp),%esi
  803a0b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803a0f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803a13:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803a17:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803a1b:	89 f3                	mov    %esi,%ebx
  803a1d:	89 fa                	mov    %edi,%edx
  803a1f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803a23:	89 34 24             	mov    %esi,(%esp)
  803a26:	85 c0                	test   %eax,%eax
  803a28:	75 1a                	jne    803a44 <__umoddi3+0x48>
  803a2a:	39 f7                	cmp    %esi,%edi
  803a2c:	0f 86 a2 00 00 00    	jbe    803ad4 <__umoddi3+0xd8>
  803a32:	89 c8                	mov    %ecx,%eax
  803a34:	89 f2                	mov    %esi,%edx
  803a36:	f7 f7                	div    %edi
  803a38:	89 d0                	mov    %edx,%eax
  803a3a:	31 d2                	xor    %edx,%edx
  803a3c:	83 c4 1c             	add    $0x1c,%esp
  803a3f:	5b                   	pop    %ebx
  803a40:	5e                   	pop    %esi
  803a41:	5f                   	pop    %edi
  803a42:	5d                   	pop    %ebp
  803a43:	c3                   	ret    
  803a44:	39 f0                	cmp    %esi,%eax
  803a46:	0f 87 ac 00 00 00    	ja     803af8 <__umoddi3+0xfc>
  803a4c:	0f bd e8             	bsr    %eax,%ebp
  803a4f:	83 f5 1f             	xor    $0x1f,%ebp
  803a52:	0f 84 ac 00 00 00    	je     803b04 <__umoddi3+0x108>
  803a58:	bf 20 00 00 00       	mov    $0x20,%edi
  803a5d:	29 ef                	sub    %ebp,%edi
  803a5f:	89 fe                	mov    %edi,%esi
  803a61:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803a65:	89 e9                	mov    %ebp,%ecx
  803a67:	d3 e0                	shl    %cl,%eax
  803a69:	89 d7                	mov    %edx,%edi
  803a6b:	89 f1                	mov    %esi,%ecx
  803a6d:	d3 ef                	shr    %cl,%edi
  803a6f:	09 c7                	or     %eax,%edi
  803a71:	89 e9                	mov    %ebp,%ecx
  803a73:	d3 e2                	shl    %cl,%edx
  803a75:	89 14 24             	mov    %edx,(%esp)
  803a78:	89 d8                	mov    %ebx,%eax
  803a7a:	d3 e0                	shl    %cl,%eax
  803a7c:	89 c2                	mov    %eax,%edx
  803a7e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803a82:	d3 e0                	shl    %cl,%eax
  803a84:	89 44 24 04          	mov    %eax,0x4(%esp)
  803a88:	8b 44 24 08          	mov    0x8(%esp),%eax
  803a8c:	89 f1                	mov    %esi,%ecx
  803a8e:	d3 e8                	shr    %cl,%eax
  803a90:	09 d0                	or     %edx,%eax
  803a92:	d3 eb                	shr    %cl,%ebx
  803a94:	89 da                	mov    %ebx,%edx
  803a96:	f7 f7                	div    %edi
  803a98:	89 d3                	mov    %edx,%ebx
  803a9a:	f7 24 24             	mull   (%esp)
  803a9d:	89 c6                	mov    %eax,%esi
  803a9f:	89 d1                	mov    %edx,%ecx
  803aa1:	39 d3                	cmp    %edx,%ebx
  803aa3:	0f 82 87 00 00 00    	jb     803b30 <__umoddi3+0x134>
  803aa9:	0f 84 91 00 00 00    	je     803b40 <__umoddi3+0x144>
  803aaf:	8b 54 24 04          	mov    0x4(%esp),%edx
  803ab3:	29 f2                	sub    %esi,%edx
  803ab5:	19 cb                	sbb    %ecx,%ebx
  803ab7:	89 d8                	mov    %ebx,%eax
  803ab9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803abd:	d3 e0                	shl    %cl,%eax
  803abf:	89 e9                	mov    %ebp,%ecx
  803ac1:	d3 ea                	shr    %cl,%edx
  803ac3:	09 d0                	or     %edx,%eax
  803ac5:	89 e9                	mov    %ebp,%ecx
  803ac7:	d3 eb                	shr    %cl,%ebx
  803ac9:	89 da                	mov    %ebx,%edx
  803acb:	83 c4 1c             	add    $0x1c,%esp
  803ace:	5b                   	pop    %ebx
  803acf:	5e                   	pop    %esi
  803ad0:	5f                   	pop    %edi
  803ad1:	5d                   	pop    %ebp
  803ad2:	c3                   	ret    
  803ad3:	90                   	nop
  803ad4:	89 fd                	mov    %edi,%ebp
  803ad6:	85 ff                	test   %edi,%edi
  803ad8:	75 0b                	jne    803ae5 <__umoddi3+0xe9>
  803ada:	b8 01 00 00 00       	mov    $0x1,%eax
  803adf:	31 d2                	xor    %edx,%edx
  803ae1:	f7 f7                	div    %edi
  803ae3:	89 c5                	mov    %eax,%ebp
  803ae5:	89 f0                	mov    %esi,%eax
  803ae7:	31 d2                	xor    %edx,%edx
  803ae9:	f7 f5                	div    %ebp
  803aeb:	89 c8                	mov    %ecx,%eax
  803aed:	f7 f5                	div    %ebp
  803aef:	89 d0                	mov    %edx,%eax
  803af1:	e9 44 ff ff ff       	jmp    803a3a <__umoddi3+0x3e>
  803af6:	66 90                	xchg   %ax,%ax
  803af8:	89 c8                	mov    %ecx,%eax
  803afa:	89 f2                	mov    %esi,%edx
  803afc:	83 c4 1c             	add    $0x1c,%esp
  803aff:	5b                   	pop    %ebx
  803b00:	5e                   	pop    %esi
  803b01:	5f                   	pop    %edi
  803b02:	5d                   	pop    %ebp
  803b03:	c3                   	ret    
  803b04:	3b 04 24             	cmp    (%esp),%eax
  803b07:	72 06                	jb     803b0f <__umoddi3+0x113>
  803b09:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803b0d:	77 0f                	ja     803b1e <__umoddi3+0x122>
  803b0f:	89 f2                	mov    %esi,%edx
  803b11:	29 f9                	sub    %edi,%ecx
  803b13:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803b17:	89 14 24             	mov    %edx,(%esp)
  803b1a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803b1e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803b22:	8b 14 24             	mov    (%esp),%edx
  803b25:	83 c4 1c             	add    $0x1c,%esp
  803b28:	5b                   	pop    %ebx
  803b29:	5e                   	pop    %esi
  803b2a:	5f                   	pop    %edi
  803b2b:	5d                   	pop    %ebp
  803b2c:	c3                   	ret    
  803b2d:	8d 76 00             	lea    0x0(%esi),%esi
  803b30:	2b 04 24             	sub    (%esp),%eax
  803b33:	19 fa                	sbb    %edi,%edx
  803b35:	89 d1                	mov    %edx,%ecx
  803b37:	89 c6                	mov    %eax,%esi
  803b39:	e9 71 ff ff ff       	jmp    803aaf <__umoddi3+0xb3>
  803b3e:	66 90                	xchg   %ax,%ax
  803b40:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803b44:	72 ea                	jb     803b30 <__umoddi3+0x134>
  803b46:	89 d9                	mov    %ebx,%ecx
  803b48:	e9 62 ff ff ff       	jmp    803aaf <__umoddi3+0xb3>
