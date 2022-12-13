
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
  800031:	e8 41 05 00 00       	call   800577 <libmain>
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
  80008d:	68 00 3a 80 00       	push   $0x803a00
  800092:	6a 12                	push   $0x12
  800094:	68 1c 3a 80 00       	push   $0x803a1c
  800099:	e8 15 06 00 00       	call   8006b3 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  80009e:	83 ec 0c             	sub    $0xc,%esp
  8000a1:	6a 00                	push   $0x0
  8000a3:	e8 47 18 00 00       	call   8018ef <malloc>
  8000a8:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/

	cprintf("************************************************\n");
  8000ab:	83 ec 0c             	sub    $0xc,%esp
  8000ae:	68 34 3a 80 00       	push   $0x803a34
  8000b3:	e8 af 08 00 00       	call   800967 <cprintf>
  8000b8:	83 c4 10             	add    $0x10,%esp
	cprintf("MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  8000bb:	83 ec 0c             	sub    $0xc,%esp
  8000be:	68 68 3a 80 00       	push   $0x803a68
  8000c3:	e8 9f 08 00 00       	call   800967 <cprintf>
  8000c8:	83 c4 10             	add    $0x10,%esp
	cprintf("************************************************\n\n\n");
  8000cb:	83 ec 0c             	sub    $0xc,%esp
  8000ce:	68 c4 3a 80 00       	push   $0x803ac4
  8000d3:	e8 8f 08 00 00       	call   800967 <cprintf>
  8000d8:	83 c4 10             	add    $0x10,%esp

	int Mega = 1024*1024;
  8000db:	c7 45 ec 00 00 10 00 	movl   $0x100000,-0x14(%ebp)
	int kilo = 1024;
  8000e2:	c7 45 e8 00 04 00 00 	movl   $0x400,-0x18(%ebp)
	int envID = sys_getenvid();
  8000e9:	e8 9d 1d 00 00       	call   801e8b <sys_getenvid>
  8000ee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	cprintf("STEP A: checking free of a shared object ... \n");
  8000f1:	83 ec 0c             	sub    $0xc,%esp
  8000f4:	68 f8 3a 80 00       	push   $0x803af8
  8000f9:	e8 69 08 00 00       	call   800967 <cprintf>
  8000fe:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x;
		int freeFrames = sys_calculate_free_frames() ;
  800101:	e8 be 1a 00 00       	call   801bc4 <sys_calculate_free_frames>
  800106:	89 45 e0             	mov    %eax,-0x20(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  800109:	83 ec 04             	sub    $0x4,%esp
  80010c:	6a 01                	push   $0x1
  80010e:	68 00 10 00 00       	push   $0x1000
  800113:	68 27 3b 80 00       	push   $0x803b27
  800118:	e8 67 18 00 00       	call   801984 <smalloc>
  80011d:	83 c4 10             	add    $0x10,%esp
  800120:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (x != (uint32*)USER_HEAP_START) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  800123:	81 7d dc 00 00 00 80 	cmpl   $0x80000000,-0x24(%ebp)
  80012a:	74 14                	je     800140 <_main+0x108>
  80012c:	83 ec 04             	sub    $0x4,%esp
  80012f:	68 2c 3b 80 00       	push   $0x803b2c
  800134:	6a 24                	push   $0x24
  800136:	68 1c 3a 80 00       	push   $0x803a1c
  80013b:	e8 73 05 00 00       	call   8006b3 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800140:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800143:	e8 7c 1a 00 00       	call   801bc4 <sys_calculate_free_frames>
  800148:	29 c3                	sub    %eax,%ebx
  80014a:	89 d8                	mov    %ebx,%eax
  80014c:	83 f8 04             	cmp    $0x4,%eax
  80014f:	74 14                	je     800165 <_main+0x12d>
  800151:	83 ec 04             	sub    $0x4,%esp
  800154:	68 98 3b 80 00       	push   $0x803b98
  800159:	6a 25                	push   $0x25
  80015b:	68 1c 3a 80 00       	push   $0x803a1c
  800160:	e8 4e 05 00 00       	call   8006b3 <_panic>

		sfree(x);
  800165:	83 ec 0c             	sub    $0xc,%esp
  800168:	ff 75 dc             	pushl  -0x24(%ebp)
  80016b:	e8 f4 18 00 00       	call   801a64 <sfree>
  800170:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) ==  0+0+2) panic("Wrong free: make sure that you free the shared object by calling free_share_object()");
  800173:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800176:	e8 49 1a 00 00       	call   801bc4 <sys_calculate_free_frames>
  80017b:	29 c3                	sub    %eax,%ebx
  80017d:	89 d8                	mov    %ebx,%eax
  80017f:	83 f8 02             	cmp    $0x2,%eax
  800182:	75 14                	jne    800198 <_main+0x160>
  800184:	83 ec 04             	sub    $0x4,%esp
  800187:	68 18 3c 80 00       	push   $0x803c18
  80018c:	6a 28                	push   $0x28
  80018e:	68 1c 3a 80 00       	push   $0x803a1c
  800193:	e8 1b 05 00 00       	call   8006b3 <_panic>
		else if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong free: revise your freeSharedObject logic");
  800198:	e8 27 1a 00 00       	call   801bc4 <sys_calculate_free_frames>
  80019d:	89 c2                	mov    %eax,%edx
  80019f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001a2:	39 c2                	cmp    %eax,%edx
  8001a4:	74 14                	je     8001ba <_main+0x182>
  8001a6:	83 ec 04             	sub    $0x4,%esp
  8001a9:	68 70 3c 80 00       	push   $0x803c70
  8001ae:	6a 29                	push   $0x29
  8001b0:	68 1c 3a 80 00       	push   $0x803a1c
  8001b5:	e8 f9 04 00 00       	call   8006b3 <_panic>
	}
	cprintf("Step A completed successfully!!\n\n\n");
  8001ba:	83 ec 0c             	sub    $0xc,%esp
  8001bd:	68 a0 3c 80 00       	push   $0x803ca0
  8001c2:	e8 a0 07 00 00       	call   800967 <cprintf>
  8001c7:	83 c4 10             	add    $0x10,%esp


	cprintf("STEP B: checking free of 2 shared objects ... \n");
  8001ca:	83 ec 0c             	sub    $0xc,%esp
  8001cd:	68 c4 3c 80 00       	push   $0x803cc4
  8001d2:	e8 90 07 00 00       	call   800967 <cprintf>
  8001d7:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x, *z ;
		int freeFrames = sys_calculate_free_frames() ;
  8001da:	e8 e5 19 00 00       	call   801bc4 <sys_calculate_free_frames>
  8001df:	89 45 d8             	mov    %eax,-0x28(%ebp)
		z = smalloc("z", PAGE_SIZE, 1);
  8001e2:	83 ec 04             	sub    $0x4,%esp
  8001e5:	6a 01                	push   $0x1
  8001e7:	68 00 10 00 00       	push   $0x1000
  8001ec:	68 f4 3c 80 00       	push   $0x803cf4
  8001f1:	e8 8e 17 00 00       	call   801984 <smalloc>
  8001f6:	83 c4 10             	add    $0x10,%esp
  8001f9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8001fc:	83 ec 04             	sub    $0x4,%esp
  8001ff:	6a 01                	push   $0x1
  800201:	68 00 10 00 00       	push   $0x1000
  800206:	68 27 3b 80 00       	push   $0x803b27
  80020b:	e8 74 17 00 00       	call   801984 <smalloc>
  800210:	83 c4 10             	add    $0x10,%esp
  800213:	89 45 d0             	mov    %eax,-0x30(%ebp)

		if(x == NULL) panic("Wrong free: make sure that you free the shared object by calling free_share_object()");
  800216:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80021a:	75 14                	jne    800230 <_main+0x1f8>
  80021c:	83 ec 04             	sub    $0x4,%esp
  80021f:	68 18 3c 80 00       	push   $0x803c18
  800224:	6a 35                	push   $0x35
  800226:	68 1c 3a 80 00       	push   $0x803a1c
  80022b:	e8 83 04 00 00       	call   8006b3 <_panic>

		if ((freeFrames - sys_calculate_free_frames()) !=  2+1+4) panic("Wrong previous free: make sure that you correctly free shared object before (Step A)");
  800230:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800233:	e8 8c 19 00 00       	call   801bc4 <sys_calculate_free_frames>
  800238:	29 c3                	sub    %eax,%ebx
  80023a:	89 d8                	mov    %ebx,%eax
  80023c:	83 f8 07             	cmp    $0x7,%eax
  80023f:	74 14                	je     800255 <_main+0x21d>
  800241:	83 ec 04             	sub    $0x4,%esp
  800244:	68 f8 3c 80 00       	push   $0x803cf8
  800249:	6a 37                	push   $0x37
  80024b:	68 1c 3a 80 00       	push   $0x803a1c
  800250:	e8 5e 04 00 00       	call   8006b3 <_panic>

		sfree(z);
  800255:	83 ec 0c             	sub    $0xc,%esp
  800258:	ff 75 d4             	pushl  -0x2c(%ebp)
  80025b:	e8 04 18 00 00       	call   801a64 <sfree>
  800260:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong free: check your logic");
  800263:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800266:	e8 59 19 00 00       	call   801bc4 <sys_calculate_free_frames>
  80026b:	29 c3                	sub    %eax,%ebx
  80026d:	89 d8                	mov    %ebx,%eax
  80026f:	83 f8 04             	cmp    $0x4,%eax
  800272:	74 14                	je     800288 <_main+0x250>
  800274:	83 ec 04             	sub    $0x4,%esp
  800277:	68 4d 3d 80 00       	push   $0x803d4d
  80027c:	6a 3a                	push   $0x3a
  80027e:	68 1c 3a 80 00       	push   $0x803a1c
  800283:	e8 2b 04 00 00       	call   8006b3 <_panic>

		sfree(x);
  800288:	83 ec 0c             	sub    $0xc,%esp
  80028b:	ff 75 d0             	pushl  -0x30(%ebp)
  80028e:	e8 d1 17 00 00       	call   801a64 <sfree>
  800293:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong free: check your logic");
  800296:	e8 29 19 00 00       	call   801bc4 <sys_calculate_free_frames>
  80029b:	89 c2                	mov    %eax,%edx
  80029d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8002a0:	39 c2                	cmp    %eax,%edx
  8002a2:	74 14                	je     8002b8 <_main+0x280>
  8002a4:	83 ec 04             	sub    $0x4,%esp
  8002a7:	68 4d 3d 80 00       	push   $0x803d4d
  8002ac:	6a 3d                	push   $0x3d
  8002ae:	68 1c 3a 80 00       	push   $0x803a1c
  8002b3:	e8 fb 03 00 00       	call   8006b3 <_panic>

	}
	cprintf("Step B completed successfully!!\n\n\n");
  8002b8:	83 ec 0c             	sub    $0xc,%esp
  8002bb:	68 6c 3d 80 00       	push   $0x803d6c
  8002c0:	e8 a2 06 00 00       	call   800967 <cprintf>
  8002c5:	83 c4 10             	add    $0x10,%esp

	cprintf("STEP C: checking range of loop during free... \n");
  8002c8:	83 ec 0c             	sub    $0xc,%esp
  8002cb:	68 90 3d 80 00       	push   $0x803d90
  8002d0:	e8 92 06 00 00       	call   800967 <cprintf>
  8002d5:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *w, *u;
		int freeFrames = sys_calculate_free_frames() ;
  8002d8:	e8 e7 18 00 00       	call   801bc4 <sys_calculate_free_frames>
  8002dd:	89 45 cc             	mov    %eax,-0x34(%ebp)
		w = smalloc("w", 3 * PAGE_SIZE+1, 1);
  8002e0:	83 ec 04             	sub    $0x4,%esp
  8002e3:	6a 01                	push   $0x1
  8002e5:	68 01 30 00 00       	push   $0x3001
  8002ea:	68 c0 3d 80 00       	push   $0x803dc0
  8002ef:	e8 90 16 00 00       	call   801984 <smalloc>
  8002f4:	83 c4 10             	add    $0x10,%esp
  8002f7:	89 45 c8             	mov    %eax,-0x38(%ebp)
		u = smalloc("u", PAGE_SIZE, 1);
  8002fa:	83 ec 04             	sub    $0x4,%esp
  8002fd:	6a 01                	push   $0x1
  8002ff:	68 00 10 00 00       	push   $0x1000
  800304:	68 c2 3d 80 00       	push   $0x803dc2
  800309:	e8 76 16 00 00       	call   801984 <smalloc>
  80030e:	83 c4 10             	add    $0x10,%esp
  800311:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		if ((freeFrames - sys_calculate_free_frames()) != 5+1+4) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800314:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800317:	e8 a8 18 00 00       	call   801bc4 <sys_calculate_free_frames>
  80031c:	29 c3                	sub    %eax,%ebx
  80031e:	89 d8                	mov    %ebx,%eax
  800320:	83 f8 0a             	cmp    $0xa,%eax
  800323:	74 14                	je     800339 <_main+0x301>
  800325:	83 ec 04             	sub    $0x4,%esp
  800328:	68 98 3b 80 00       	push   $0x803b98
  80032d:	6a 48                	push   $0x48
  80032f:	68 1c 3a 80 00       	push   $0x803a1c
  800334:	e8 7a 03 00 00       	call   8006b3 <_panic>

		sfree(w);
  800339:	83 ec 0c             	sub    $0xc,%esp
  80033c:	ff 75 c8             	pushl  -0x38(%ebp)
  80033f:	e8 20 17 00 00       	call   801a64 <sfree>
  800344:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong free: check your logic");
  800347:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  80034a:	e8 75 18 00 00       	call   801bc4 <sys_calculate_free_frames>
  80034f:	29 c3                	sub    %eax,%ebx
  800351:	89 d8                	mov    %ebx,%eax
  800353:	83 f8 04             	cmp    $0x4,%eax
  800356:	74 14                	je     80036c <_main+0x334>
  800358:	83 ec 04             	sub    $0x4,%esp
  80035b:	68 4d 3d 80 00       	push   $0x803d4d
  800360:	6a 4b                	push   $0x4b
  800362:	68 1c 3a 80 00       	push   $0x803a1c
  800367:	e8 47 03 00 00       	call   8006b3 <_panic>

		uint32 *o;

		o = smalloc("o", 2 * PAGE_SIZE-1,1);
  80036c:	83 ec 04             	sub    $0x4,%esp
  80036f:	6a 01                	push   $0x1
  800371:	68 ff 1f 00 00       	push   $0x1fff
  800376:	68 c4 3d 80 00       	push   $0x803dc4
  80037b:	e8 04 16 00 00       	call   801984 <smalloc>
  800380:	83 c4 10             	add    $0x10,%esp
  800383:	89 45 c0             	mov    %eax,-0x40(%ebp)

		cprintf("2\n");
  800386:	83 ec 0c             	sub    $0xc,%esp
  800389:	68 c6 3d 80 00       	push   $0x803dc6
  80038e:	e8 d4 05 00 00       	call   800967 <cprintf>
  800393:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) != 3+1+4) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800396:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800399:	e8 26 18 00 00       	call   801bc4 <sys_calculate_free_frames>
  80039e:	29 c3                	sub    %eax,%ebx
  8003a0:	89 d8                	mov    %ebx,%eax
  8003a2:	83 f8 08             	cmp    $0x8,%eax
  8003a5:	74 14                	je     8003bb <_main+0x383>
  8003a7:	83 ec 04             	sub    $0x4,%esp
  8003aa:	68 98 3b 80 00       	push   $0x803b98
  8003af:	6a 52                	push   $0x52
  8003b1:	68 1c 3a 80 00       	push   $0x803a1c
  8003b6:	e8 f8 02 00 00       	call   8006b3 <_panic>

		sfree(o);
  8003bb:	83 ec 0c             	sub    $0xc,%esp
  8003be:	ff 75 c0             	pushl  -0x40(%ebp)
  8003c1:	e8 9e 16 00 00       	call   801a64 <sfree>
  8003c6:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong free: check your logic");
  8003c9:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8003cc:	e8 f3 17 00 00       	call   801bc4 <sys_calculate_free_frames>
  8003d1:	29 c3                	sub    %eax,%ebx
  8003d3:	89 d8                	mov    %ebx,%eax
  8003d5:	83 f8 04             	cmp    $0x4,%eax
  8003d8:	74 14                	je     8003ee <_main+0x3b6>
  8003da:	83 ec 04             	sub    $0x4,%esp
  8003dd:	68 4d 3d 80 00       	push   $0x803d4d
  8003e2:	6a 55                	push   $0x55
  8003e4:	68 1c 3a 80 00       	push   $0x803a1c
  8003e9:	e8 c5 02 00 00       	call   8006b3 <_panic>

		sfree(u);
  8003ee:	83 ec 0c             	sub    $0xc,%esp
  8003f1:	ff 75 c4             	pushl  -0x3c(%ebp)
  8003f4:	e8 6b 16 00 00       	call   801a64 <sfree>
  8003f9:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong free: check your logic");
  8003fc:	e8 c3 17 00 00       	call   801bc4 <sys_calculate_free_frames>
  800401:	89 c2                	mov    %eax,%edx
  800403:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800406:	39 c2                	cmp    %eax,%edx
  800408:	74 14                	je     80041e <_main+0x3e6>
  80040a:	83 ec 04             	sub    $0x4,%esp
  80040d:	68 4d 3d 80 00       	push   $0x803d4d
  800412:	6a 58                	push   $0x58
  800414:	68 1c 3a 80 00       	push   $0x803a1c
  800419:	e8 95 02 00 00       	call   8006b3 <_panic>


		//Checking boundaries of page tables
		freeFrames = sys_calculate_free_frames() ;
  80041e:	e8 a1 17 00 00       	call   801bc4 <sys_calculate_free_frames>
  800423:	89 45 cc             	mov    %eax,-0x34(%ebp)
		w = smalloc("w", 3 * Mega - 1*kilo, 1);
  800426:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800429:	89 c2                	mov    %eax,%edx
  80042b:	01 d2                	add    %edx,%edx
  80042d:	01 d0                	add    %edx,%eax
  80042f:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800432:	83 ec 04             	sub    $0x4,%esp
  800435:	6a 01                	push   $0x1
  800437:	50                   	push   %eax
  800438:	68 c0 3d 80 00       	push   $0x803dc0
  80043d:	e8 42 15 00 00       	call   801984 <smalloc>
  800442:	83 c4 10             	add    $0x10,%esp
  800445:	89 45 c8             	mov    %eax,-0x38(%ebp)
		u = smalloc("u", 7 * Mega - 1*kilo, 1);
  800448:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80044b:	89 d0                	mov    %edx,%eax
  80044d:	01 c0                	add    %eax,%eax
  80044f:	01 d0                	add    %edx,%eax
  800451:	01 c0                	add    %eax,%eax
  800453:	01 d0                	add    %edx,%eax
  800455:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800458:	83 ec 04             	sub    $0x4,%esp
  80045b:	6a 01                	push   $0x1
  80045d:	50                   	push   %eax
  80045e:	68 c2 3d 80 00       	push   $0x803dc2
  800463:	e8 1c 15 00 00       	call   801984 <smalloc>
  800468:	83 c4 10             	add    $0x10,%esp
  80046b:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		o = smalloc("o", 2 * Mega + 1*kilo, 1);
  80046e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800471:	01 c0                	add    %eax,%eax
  800473:	89 c2                	mov    %eax,%edx
  800475:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800478:	01 d0                	add    %edx,%eax
  80047a:	83 ec 04             	sub    $0x4,%esp
  80047d:	6a 01                	push   $0x1
  80047f:	50                   	push   %eax
  800480:	68 c4 3d 80 00       	push   $0x803dc4
  800485:	e8 fa 14 00 00       	call   801984 <smalloc>
  80048a:	83 c4 10             	add    $0x10,%esp
  80048d:	89 45 c0             	mov    %eax,-0x40(%ebp)

		if ((freeFrames - sys_calculate_free_frames()) != 3073+4+7) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800490:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800493:	e8 2c 17 00 00       	call   801bc4 <sys_calculate_free_frames>
  800498:	29 c3                	sub    %eax,%ebx
  80049a:	89 d8                	mov    %ebx,%eax
  80049c:	3d 0c 0c 00 00       	cmp    $0xc0c,%eax
  8004a1:	74 14                	je     8004b7 <_main+0x47f>
  8004a3:	83 ec 04             	sub    $0x4,%esp
  8004a6:	68 98 3b 80 00       	push   $0x803b98
  8004ab:	6a 61                	push   $0x61
  8004ad:	68 1c 3a 80 00       	push   $0x803a1c
  8004b2:	e8 fc 01 00 00       	call   8006b3 <_panic>

		sfree(o);
  8004b7:	83 ec 0c             	sub    $0xc,%esp
  8004ba:	ff 75 c0             	pushl  -0x40(%ebp)
  8004bd:	e8 a2 15 00 00       	call   801a64 <sfree>
  8004c2:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  2560+3+5) panic("Wrong free: check your logic");
  8004c5:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8004c8:	e8 f7 16 00 00       	call   801bc4 <sys_calculate_free_frames>
  8004cd:	29 c3                	sub    %eax,%ebx
  8004cf:	89 d8                	mov    %ebx,%eax
  8004d1:	3d 08 0a 00 00       	cmp    $0xa08,%eax
  8004d6:	74 14                	je     8004ec <_main+0x4b4>
  8004d8:	83 ec 04             	sub    $0x4,%esp
  8004db:	68 4d 3d 80 00       	push   $0x803d4d
  8004e0:	6a 64                	push   $0x64
  8004e2:	68 1c 3a 80 00       	push   $0x803a1c
  8004e7:	e8 c7 01 00 00       	call   8006b3 <_panic>

		sfree(w);
  8004ec:	83 ec 0c             	sub    $0xc,%esp
  8004ef:	ff 75 c8             	pushl  -0x38(%ebp)
  8004f2:	e8 6d 15 00 00       	call   801a64 <sfree>
  8004f7:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  1792+3+3) panic("Wrong free: check your logic");
  8004fa:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8004fd:	e8 c2 16 00 00       	call   801bc4 <sys_calculate_free_frames>
  800502:	29 c3                	sub    %eax,%ebx
  800504:	89 d8                	mov    %ebx,%eax
  800506:	3d 06 07 00 00       	cmp    $0x706,%eax
  80050b:	74 14                	je     800521 <_main+0x4e9>
  80050d:	83 ec 04             	sub    $0x4,%esp
  800510:	68 4d 3d 80 00       	push   $0x803d4d
  800515:	6a 67                	push   $0x67
  800517:	68 1c 3a 80 00       	push   $0x803a1c
  80051c:	e8 92 01 00 00       	call   8006b3 <_panic>

		sfree(u);
  800521:	83 ec 0c             	sub    $0xc,%esp
  800524:	ff 75 c4             	pushl  -0x3c(%ebp)
  800527:	e8 38 15 00 00       	call   801a64 <sfree>
  80052c:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong free: check your logic");
  80052f:	e8 90 16 00 00       	call   801bc4 <sys_calculate_free_frames>
  800534:	89 c2                	mov    %eax,%edx
  800536:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800539:	39 c2                	cmp    %eax,%edx
  80053b:	74 14                	je     800551 <_main+0x519>
  80053d:	83 ec 04             	sub    $0x4,%esp
  800540:	68 4d 3d 80 00       	push   $0x803d4d
  800545:	6a 6a                	push   $0x6a
  800547:	68 1c 3a 80 00       	push   $0x803a1c
  80054c:	e8 62 01 00 00       	call   8006b3 <_panic>
	}
	cprintf("Step C completed successfully!!\n\n\n");
  800551:	83 ec 0c             	sub    $0xc,%esp
  800554:	68 cc 3d 80 00       	push   $0x803dcc
  800559:	e8 09 04 00 00       	call   800967 <cprintf>
  80055e:	83 c4 10             	add    $0x10,%esp

	cprintf("Congratulations!! Test of freeSharedObjects [4] completed successfully!!\n\n\n");
  800561:	83 ec 0c             	sub    $0xc,%esp
  800564:	68 f0 3d 80 00       	push   $0x803df0
  800569:	e8 f9 03 00 00       	call   800967 <cprintf>
  80056e:	83 c4 10             	add    $0x10,%esp

	return;
  800571:	90                   	nop
}
  800572:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800575:	c9                   	leave  
  800576:	c3                   	ret    

00800577 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800577:	55                   	push   %ebp
  800578:	89 e5                	mov    %esp,%ebp
  80057a:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80057d:	e8 22 19 00 00       	call   801ea4 <sys_getenvindex>
  800582:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800585:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800588:	89 d0                	mov    %edx,%eax
  80058a:	c1 e0 03             	shl    $0x3,%eax
  80058d:	01 d0                	add    %edx,%eax
  80058f:	01 c0                	add    %eax,%eax
  800591:	01 d0                	add    %edx,%eax
  800593:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80059a:	01 d0                	add    %edx,%eax
  80059c:	c1 e0 04             	shl    $0x4,%eax
  80059f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8005a4:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8005a9:	a1 20 50 80 00       	mov    0x805020,%eax
  8005ae:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8005b4:	84 c0                	test   %al,%al
  8005b6:	74 0f                	je     8005c7 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8005b8:	a1 20 50 80 00       	mov    0x805020,%eax
  8005bd:	05 5c 05 00 00       	add    $0x55c,%eax
  8005c2:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8005c7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8005cb:	7e 0a                	jle    8005d7 <libmain+0x60>
		binaryname = argv[0];
  8005cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005d0:	8b 00                	mov    (%eax),%eax
  8005d2:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8005d7:	83 ec 08             	sub    $0x8,%esp
  8005da:	ff 75 0c             	pushl  0xc(%ebp)
  8005dd:	ff 75 08             	pushl  0x8(%ebp)
  8005e0:	e8 53 fa ff ff       	call   800038 <_main>
  8005e5:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8005e8:	e8 c4 16 00 00       	call   801cb1 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8005ed:	83 ec 0c             	sub    $0xc,%esp
  8005f0:	68 54 3e 80 00       	push   $0x803e54
  8005f5:	e8 6d 03 00 00       	call   800967 <cprintf>
  8005fa:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8005fd:	a1 20 50 80 00       	mov    0x805020,%eax
  800602:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800608:	a1 20 50 80 00       	mov    0x805020,%eax
  80060d:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800613:	83 ec 04             	sub    $0x4,%esp
  800616:	52                   	push   %edx
  800617:	50                   	push   %eax
  800618:	68 7c 3e 80 00       	push   $0x803e7c
  80061d:	e8 45 03 00 00       	call   800967 <cprintf>
  800622:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800625:	a1 20 50 80 00       	mov    0x805020,%eax
  80062a:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800630:	a1 20 50 80 00       	mov    0x805020,%eax
  800635:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  80063b:	a1 20 50 80 00       	mov    0x805020,%eax
  800640:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800646:	51                   	push   %ecx
  800647:	52                   	push   %edx
  800648:	50                   	push   %eax
  800649:	68 a4 3e 80 00       	push   $0x803ea4
  80064e:	e8 14 03 00 00       	call   800967 <cprintf>
  800653:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800656:	a1 20 50 80 00       	mov    0x805020,%eax
  80065b:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800661:	83 ec 08             	sub    $0x8,%esp
  800664:	50                   	push   %eax
  800665:	68 fc 3e 80 00       	push   $0x803efc
  80066a:	e8 f8 02 00 00       	call   800967 <cprintf>
  80066f:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800672:	83 ec 0c             	sub    $0xc,%esp
  800675:	68 54 3e 80 00       	push   $0x803e54
  80067a:	e8 e8 02 00 00       	call   800967 <cprintf>
  80067f:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800682:	e8 44 16 00 00       	call   801ccb <sys_enable_interrupt>

	// exit gracefully
	exit();
  800687:	e8 19 00 00 00       	call   8006a5 <exit>
}
  80068c:	90                   	nop
  80068d:	c9                   	leave  
  80068e:	c3                   	ret    

0080068f <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80068f:	55                   	push   %ebp
  800690:	89 e5                	mov    %esp,%ebp
  800692:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800695:	83 ec 0c             	sub    $0xc,%esp
  800698:	6a 00                	push   $0x0
  80069a:	e8 d1 17 00 00       	call   801e70 <sys_destroy_env>
  80069f:	83 c4 10             	add    $0x10,%esp
}
  8006a2:	90                   	nop
  8006a3:	c9                   	leave  
  8006a4:	c3                   	ret    

008006a5 <exit>:

void
exit(void)
{
  8006a5:	55                   	push   %ebp
  8006a6:	89 e5                	mov    %esp,%ebp
  8006a8:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8006ab:	e8 26 18 00 00       	call   801ed6 <sys_exit_env>
}
  8006b0:	90                   	nop
  8006b1:	c9                   	leave  
  8006b2:	c3                   	ret    

008006b3 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8006b3:	55                   	push   %ebp
  8006b4:	89 e5                	mov    %esp,%ebp
  8006b6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8006b9:	8d 45 10             	lea    0x10(%ebp),%eax
  8006bc:	83 c0 04             	add    $0x4,%eax
  8006bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8006c2:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8006c7:	85 c0                	test   %eax,%eax
  8006c9:	74 16                	je     8006e1 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8006cb:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8006d0:	83 ec 08             	sub    $0x8,%esp
  8006d3:	50                   	push   %eax
  8006d4:	68 10 3f 80 00       	push   $0x803f10
  8006d9:	e8 89 02 00 00       	call   800967 <cprintf>
  8006de:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8006e1:	a1 00 50 80 00       	mov    0x805000,%eax
  8006e6:	ff 75 0c             	pushl  0xc(%ebp)
  8006e9:	ff 75 08             	pushl  0x8(%ebp)
  8006ec:	50                   	push   %eax
  8006ed:	68 15 3f 80 00       	push   $0x803f15
  8006f2:	e8 70 02 00 00       	call   800967 <cprintf>
  8006f7:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8006fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8006fd:	83 ec 08             	sub    $0x8,%esp
  800700:	ff 75 f4             	pushl  -0xc(%ebp)
  800703:	50                   	push   %eax
  800704:	e8 f3 01 00 00       	call   8008fc <vcprintf>
  800709:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80070c:	83 ec 08             	sub    $0x8,%esp
  80070f:	6a 00                	push   $0x0
  800711:	68 31 3f 80 00       	push   $0x803f31
  800716:	e8 e1 01 00 00       	call   8008fc <vcprintf>
  80071b:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80071e:	e8 82 ff ff ff       	call   8006a5 <exit>

	// should not return here
	while (1) ;
  800723:	eb fe                	jmp    800723 <_panic+0x70>

00800725 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800725:	55                   	push   %ebp
  800726:	89 e5                	mov    %esp,%ebp
  800728:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80072b:	a1 20 50 80 00       	mov    0x805020,%eax
  800730:	8b 50 74             	mov    0x74(%eax),%edx
  800733:	8b 45 0c             	mov    0xc(%ebp),%eax
  800736:	39 c2                	cmp    %eax,%edx
  800738:	74 14                	je     80074e <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80073a:	83 ec 04             	sub    $0x4,%esp
  80073d:	68 34 3f 80 00       	push   $0x803f34
  800742:	6a 26                	push   $0x26
  800744:	68 80 3f 80 00       	push   $0x803f80
  800749:	e8 65 ff ff ff       	call   8006b3 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80074e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800755:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80075c:	e9 c2 00 00 00       	jmp    800823 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800761:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800764:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80076b:	8b 45 08             	mov    0x8(%ebp),%eax
  80076e:	01 d0                	add    %edx,%eax
  800770:	8b 00                	mov    (%eax),%eax
  800772:	85 c0                	test   %eax,%eax
  800774:	75 08                	jne    80077e <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800776:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800779:	e9 a2 00 00 00       	jmp    800820 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80077e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800785:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80078c:	eb 69                	jmp    8007f7 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80078e:	a1 20 50 80 00       	mov    0x805020,%eax
  800793:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800799:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80079c:	89 d0                	mov    %edx,%eax
  80079e:	01 c0                	add    %eax,%eax
  8007a0:	01 d0                	add    %edx,%eax
  8007a2:	c1 e0 03             	shl    $0x3,%eax
  8007a5:	01 c8                	add    %ecx,%eax
  8007a7:	8a 40 04             	mov    0x4(%eax),%al
  8007aa:	84 c0                	test   %al,%al
  8007ac:	75 46                	jne    8007f4 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8007ae:	a1 20 50 80 00       	mov    0x805020,%eax
  8007b3:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8007b9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8007bc:	89 d0                	mov    %edx,%eax
  8007be:	01 c0                	add    %eax,%eax
  8007c0:	01 d0                	add    %edx,%eax
  8007c2:	c1 e0 03             	shl    $0x3,%eax
  8007c5:	01 c8                	add    %ecx,%eax
  8007c7:	8b 00                	mov    (%eax),%eax
  8007c9:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8007cc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8007cf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8007d4:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8007d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007d9:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8007e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e3:	01 c8                	add    %ecx,%eax
  8007e5:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8007e7:	39 c2                	cmp    %eax,%edx
  8007e9:	75 09                	jne    8007f4 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8007eb:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8007f2:	eb 12                	jmp    800806 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8007f4:	ff 45 e8             	incl   -0x18(%ebp)
  8007f7:	a1 20 50 80 00       	mov    0x805020,%eax
  8007fc:	8b 50 74             	mov    0x74(%eax),%edx
  8007ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800802:	39 c2                	cmp    %eax,%edx
  800804:	77 88                	ja     80078e <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800806:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80080a:	75 14                	jne    800820 <CheckWSWithoutLastIndex+0xfb>
			panic(
  80080c:	83 ec 04             	sub    $0x4,%esp
  80080f:	68 8c 3f 80 00       	push   $0x803f8c
  800814:	6a 3a                	push   $0x3a
  800816:	68 80 3f 80 00       	push   $0x803f80
  80081b:	e8 93 fe ff ff       	call   8006b3 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800820:	ff 45 f0             	incl   -0x10(%ebp)
  800823:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800826:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800829:	0f 8c 32 ff ff ff    	jl     800761 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80082f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800836:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80083d:	eb 26                	jmp    800865 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80083f:	a1 20 50 80 00       	mov    0x805020,%eax
  800844:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80084a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80084d:	89 d0                	mov    %edx,%eax
  80084f:	01 c0                	add    %eax,%eax
  800851:	01 d0                	add    %edx,%eax
  800853:	c1 e0 03             	shl    $0x3,%eax
  800856:	01 c8                	add    %ecx,%eax
  800858:	8a 40 04             	mov    0x4(%eax),%al
  80085b:	3c 01                	cmp    $0x1,%al
  80085d:	75 03                	jne    800862 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80085f:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800862:	ff 45 e0             	incl   -0x20(%ebp)
  800865:	a1 20 50 80 00       	mov    0x805020,%eax
  80086a:	8b 50 74             	mov    0x74(%eax),%edx
  80086d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800870:	39 c2                	cmp    %eax,%edx
  800872:	77 cb                	ja     80083f <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800874:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800877:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80087a:	74 14                	je     800890 <CheckWSWithoutLastIndex+0x16b>
		panic(
  80087c:	83 ec 04             	sub    $0x4,%esp
  80087f:	68 e0 3f 80 00       	push   $0x803fe0
  800884:	6a 44                	push   $0x44
  800886:	68 80 3f 80 00       	push   $0x803f80
  80088b:	e8 23 fe ff ff       	call   8006b3 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800890:	90                   	nop
  800891:	c9                   	leave  
  800892:	c3                   	ret    

00800893 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800893:	55                   	push   %ebp
  800894:	89 e5                	mov    %esp,%ebp
  800896:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800899:	8b 45 0c             	mov    0xc(%ebp),%eax
  80089c:	8b 00                	mov    (%eax),%eax
  80089e:	8d 48 01             	lea    0x1(%eax),%ecx
  8008a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008a4:	89 0a                	mov    %ecx,(%edx)
  8008a6:	8b 55 08             	mov    0x8(%ebp),%edx
  8008a9:	88 d1                	mov    %dl,%cl
  8008ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008ae:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8008b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008b5:	8b 00                	mov    (%eax),%eax
  8008b7:	3d ff 00 00 00       	cmp    $0xff,%eax
  8008bc:	75 2c                	jne    8008ea <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8008be:	a0 24 50 80 00       	mov    0x805024,%al
  8008c3:	0f b6 c0             	movzbl %al,%eax
  8008c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008c9:	8b 12                	mov    (%edx),%edx
  8008cb:	89 d1                	mov    %edx,%ecx
  8008cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008d0:	83 c2 08             	add    $0x8,%edx
  8008d3:	83 ec 04             	sub    $0x4,%esp
  8008d6:	50                   	push   %eax
  8008d7:	51                   	push   %ecx
  8008d8:	52                   	push   %edx
  8008d9:	e8 25 12 00 00       	call   801b03 <sys_cputs>
  8008de:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8008e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008e4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8008ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008ed:	8b 40 04             	mov    0x4(%eax),%eax
  8008f0:	8d 50 01             	lea    0x1(%eax),%edx
  8008f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008f6:	89 50 04             	mov    %edx,0x4(%eax)
}
  8008f9:	90                   	nop
  8008fa:	c9                   	leave  
  8008fb:	c3                   	ret    

008008fc <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8008fc:	55                   	push   %ebp
  8008fd:	89 e5                	mov    %esp,%ebp
  8008ff:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800905:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80090c:	00 00 00 
	b.cnt = 0;
  80090f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800916:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800919:	ff 75 0c             	pushl  0xc(%ebp)
  80091c:	ff 75 08             	pushl  0x8(%ebp)
  80091f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800925:	50                   	push   %eax
  800926:	68 93 08 80 00       	push   $0x800893
  80092b:	e8 11 02 00 00       	call   800b41 <vprintfmt>
  800930:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800933:	a0 24 50 80 00       	mov    0x805024,%al
  800938:	0f b6 c0             	movzbl %al,%eax
  80093b:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800941:	83 ec 04             	sub    $0x4,%esp
  800944:	50                   	push   %eax
  800945:	52                   	push   %edx
  800946:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80094c:	83 c0 08             	add    $0x8,%eax
  80094f:	50                   	push   %eax
  800950:	e8 ae 11 00 00       	call   801b03 <sys_cputs>
  800955:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800958:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  80095f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800965:	c9                   	leave  
  800966:	c3                   	ret    

00800967 <cprintf>:

int cprintf(const char *fmt, ...) {
  800967:	55                   	push   %ebp
  800968:	89 e5                	mov    %esp,%ebp
  80096a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80096d:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  800974:	8d 45 0c             	lea    0xc(%ebp),%eax
  800977:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80097a:	8b 45 08             	mov    0x8(%ebp),%eax
  80097d:	83 ec 08             	sub    $0x8,%esp
  800980:	ff 75 f4             	pushl  -0xc(%ebp)
  800983:	50                   	push   %eax
  800984:	e8 73 ff ff ff       	call   8008fc <vcprintf>
  800989:	83 c4 10             	add    $0x10,%esp
  80098c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80098f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800992:	c9                   	leave  
  800993:	c3                   	ret    

00800994 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800994:	55                   	push   %ebp
  800995:	89 e5                	mov    %esp,%ebp
  800997:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80099a:	e8 12 13 00 00       	call   801cb1 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80099f:	8d 45 0c             	lea    0xc(%ebp),%eax
  8009a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8009a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a8:	83 ec 08             	sub    $0x8,%esp
  8009ab:	ff 75 f4             	pushl  -0xc(%ebp)
  8009ae:	50                   	push   %eax
  8009af:	e8 48 ff ff ff       	call   8008fc <vcprintf>
  8009b4:	83 c4 10             	add    $0x10,%esp
  8009b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8009ba:	e8 0c 13 00 00       	call   801ccb <sys_enable_interrupt>
	return cnt;
  8009bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009c2:	c9                   	leave  
  8009c3:	c3                   	ret    

008009c4 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8009c4:	55                   	push   %ebp
  8009c5:	89 e5                	mov    %esp,%ebp
  8009c7:	53                   	push   %ebx
  8009c8:	83 ec 14             	sub    $0x14,%esp
  8009cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8009ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8009d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8009d7:	8b 45 18             	mov    0x18(%ebp),%eax
  8009da:	ba 00 00 00 00       	mov    $0x0,%edx
  8009df:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8009e2:	77 55                	ja     800a39 <printnum+0x75>
  8009e4:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8009e7:	72 05                	jb     8009ee <printnum+0x2a>
  8009e9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8009ec:	77 4b                	ja     800a39 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8009ee:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8009f1:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8009f4:	8b 45 18             	mov    0x18(%ebp),%eax
  8009f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8009fc:	52                   	push   %edx
  8009fd:	50                   	push   %eax
  8009fe:	ff 75 f4             	pushl  -0xc(%ebp)
  800a01:	ff 75 f0             	pushl  -0x10(%ebp)
  800a04:	e8 7f 2d 00 00       	call   803788 <__udivdi3>
  800a09:	83 c4 10             	add    $0x10,%esp
  800a0c:	83 ec 04             	sub    $0x4,%esp
  800a0f:	ff 75 20             	pushl  0x20(%ebp)
  800a12:	53                   	push   %ebx
  800a13:	ff 75 18             	pushl  0x18(%ebp)
  800a16:	52                   	push   %edx
  800a17:	50                   	push   %eax
  800a18:	ff 75 0c             	pushl  0xc(%ebp)
  800a1b:	ff 75 08             	pushl  0x8(%ebp)
  800a1e:	e8 a1 ff ff ff       	call   8009c4 <printnum>
  800a23:	83 c4 20             	add    $0x20,%esp
  800a26:	eb 1a                	jmp    800a42 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800a28:	83 ec 08             	sub    $0x8,%esp
  800a2b:	ff 75 0c             	pushl  0xc(%ebp)
  800a2e:	ff 75 20             	pushl  0x20(%ebp)
  800a31:	8b 45 08             	mov    0x8(%ebp),%eax
  800a34:	ff d0                	call   *%eax
  800a36:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800a39:	ff 4d 1c             	decl   0x1c(%ebp)
  800a3c:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800a40:	7f e6                	jg     800a28 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800a42:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800a45:	bb 00 00 00 00       	mov    $0x0,%ebx
  800a4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a4d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a50:	53                   	push   %ebx
  800a51:	51                   	push   %ecx
  800a52:	52                   	push   %edx
  800a53:	50                   	push   %eax
  800a54:	e8 3f 2e 00 00       	call   803898 <__umoddi3>
  800a59:	83 c4 10             	add    $0x10,%esp
  800a5c:	05 54 42 80 00       	add    $0x804254,%eax
  800a61:	8a 00                	mov    (%eax),%al
  800a63:	0f be c0             	movsbl %al,%eax
  800a66:	83 ec 08             	sub    $0x8,%esp
  800a69:	ff 75 0c             	pushl  0xc(%ebp)
  800a6c:	50                   	push   %eax
  800a6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a70:	ff d0                	call   *%eax
  800a72:	83 c4 10             	add    $0x10,%esp
}
  800a75:	90                   	nop
  800a76:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a79:	c9                   	leave  
  800a7a:	c3                   	ret    

00800a7b <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800a7b:	55                   	push   %ebp
  800a7c:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800a7e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800a82:	7e 1c                	jle    800aa0 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800a84:	8b 45 08             	mov    0x8(%ebp),%eax
  800a87:	8b 00                	mov    (%eax),%eax
  800a89:	8d 50 08             	lea    0x8(%eax),%edx
  800a8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8f:	89 10                	mov    %edx,(%eax)
  800a91:	8b 45 08             	mov    0x8(%ebp),%eax
  800a94:	8b 00                	mov    (%eax),%eax
  800a96:	83 e8 08             	sub    $0x8,%eax
  800a99:	8b 50 04             	mov    0x4(%eax),%edx
  800a9c:	8b 00                	mov    (%eax),%eax
  800a9e:	eb 40                	jmp    800ae0 <getuint+0x65>
	else if (lflag)
  800aa0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800aa4:	74 1e                	je     800ac4 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa9:	8b 00                	mov    (%eax),%eax
  800aab:	8d 50 04             	lea    0x4(%eax),%edx
  800aae:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab1:	89 10                	mov    %edx,(%eax)
  800ab3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab6:	8b 00                	mov    (%eax),%eax
  800ab8:	83 e8 04             	sub    $0x4,%eax
  800abb:	8b 00                	mov    (%eax),%eax
  800abd:	ba 00 00 00 00       	mov    $0x0,%edx
  800ac2:	eb 1c                	jmp    800ae0 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800ac4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac7:	8b 00                	mov    (%eax),%eax
  800ac9:	8d 50 04             	lea    0x4(%eax),%edx
  800acc:	8b 45 08             	mov    0x8(%ebp),%eax
  800acf:	89 10                	mov    %edx,(%eax)
  800ad1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad4:	8b 00                	mov    (%eax),%eax
  800ad6:	83 e8 04             	sub    $0x4,%eax
  800ad9:	8b 00                	mov    (%eax),%eax
  800adb:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800ae0:	5d                   	pop    %ebp
  800ae1:	c3                   	ret    

00800ae2 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800ae2:	55                   	push   %ebp
  800ae3:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800ae5:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800ae9:	7e 1c                	jle    800b07 <getint+0x25>
		return va_arg(*ap, long long);
  800aeb:	8b 45 08             	mov    0x8(%ebp),%eax
  800aee:	8b 00                	mov    (%eax),%eax
  800af0:	8d 50 08             	lea    0x8(%eax),%edx
  800af3:	8b 45 08             	mov    0x8(%ebp),%eax
  800af6:	89 10                	mov    %edx,(%eax)
  800af8:	8b 45 08             	mov    0x8(%ebp),%eax
  800afb:	8b 00                	mov    (%eax),%eax
  800afd:	83 e8 08             	sub    $0x8,%eax
  800b00:	8b 50 04             	mov    0x4(%eax),%edx
  800b03:	8b 00                	mov    (%eax),%eax
  800b05:	eb 38                	jmp    800b3f <getint+0x5d>
	else if (lflag)
  800b07:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b0b:	74 1a                	je     800b27 <getint+0x45>
		return va_arg(*ap, long);
  800b0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b10:	8b 00                	mov    (%eax),%eax
  800b12:	8d 50 04             	lea    0x4(%eax),%edx
  800b15:	8b 45 08             	mov    0x8(%ebp),%eax
  800b18:	89 10                	mov    %edx,(%eax)
  800b1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1d:	8b 00                	mov    (%eax),%eax
  800b1f:	83 e8 04             	sub    $0x4,%eax
  800b22:	8b 00                	mov    (%eax),%eax
  800b24:	99                   	cltd   
  800b25:	eb 18                	jmp    800b3f <getint+0x5d>
	else
		return va_arg(*ap, int);
  800b27:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2a:	8b 00                	mov    (%eax),%eax
  800b2c:	8d 50 04             	lea    0x4(%eax),%edx
  800b2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b32:	89 10                	mov    %edx,(%eax)
  800b34:	8b 45 08             	mov    0x8(%ebp),%eax
  800b37:	8b 00                	mov    (%eax),%eax
  800b39:	83 e8 04             	sub    $0x4,%eax
  800b3c:	8b 00                	mov    (%eax),%eax
  800b3e:	99                   	cltd   
}
  800b3f:	5d                   	pop    %ebp
  800b40:	c3                   	ret    

00800b41 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800b41:	55                   	push   %ebp
  800b42:	89 e5                	mov    %esp,%ebp
  800b44:	56                   	push   %esi
  800b45:	53                   	push   %ebx
  800b46:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b49:	eb 17                	jmp    800b62 <vprintfmt+0x21>
			if (ch == '\0')
  800b4b:	85 db                	test   %ebx,%ebx
  800b4d:	0f 84 af 03 00 00    	je     800f02 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800b53:	83 ec 08             	sub    $0x8,%esp
  800b56:	ff 75 0c             	pushl  0xc(%ebp)
  800b59:	53                   	push   %ebx
  800b5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5d:	ff d0                	call   *%eax
  800b5f:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b62:	8b 45 10             	mov    0x10(%ebp),%eax
  800b65:	8d 50 01             	lea    0x1(%eax),%edx
  800b68:	89 55 10             	mov    %edx,0x10(%ebp)
  800b6b:	8a 00                	mov    (%eax),%al
  800b6d:	0f b6 d8             	movzbl %al,%ebx
  800b70:	83 fb 25             	cmp    $0x25,%ebx
  800b73:	75 d6                	jne    800b4b <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800b75:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800b79:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800b80:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800b87:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800b8e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800b95:	8b 45 10             	mov    0x10(%ebp),%eax
  800b98:	8d 50 01             	lea    0x1(%eax),%edx
  800b9b:	89 55 10             	mov    %edx,0x10(%ebp)
  800b9e:	8a 00                	mov    (%eax),%al
  800ba0:	0f b6 d8             	movzbl %al,%ebx
  800ba3:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800ba6:	83 f8 55             	cmp    $0x55,%eax
  800ba9:	0f 87 2b 03 00 00    	ja     800eda <vprintfmt+0x399>
  800baf:	8b 04 85 78 42 80 00 	mov    0x804278(,%eax,4),%eax
  800bb6:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800bb8:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800bbc:	eb d7                	jmp    800b95 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800bbe:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800bc2:	eb d1                	jmp    800b95 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800bc4:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800bcb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800bce:	89 d0                	mov    %edx,%eax
  800bd0:	c1 e0 02             	shl    $0x2,%eax
  800bd3:	01 d0                	add    %edx,%eax
  800bd5:	01 c0                	add    %eax,%eax
  800bd7:	01 d8                	add    %ebx,%eax
  800bd9:	83 e8 30             	sub    $0x30,%eax
  800bdc:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800bdf:	8b 45 10             	mov    0x10(%ebp),%eax
  800be2:	8a 00                	mov    (%eax),%al
  800be4:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800be7:	83 fb 2f             	cmp    $0x2f,%ebx
  800bea:	7e 3e                	jle    800c2a <vprintfmt+0xe9>
  800bec:	83 fb 39             	cmp    $0x39,%ebx
  800bef:	7f 39                	jg     800c2a <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800bf1:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800bf4:	eb d5                	jmp    800bcb <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800bf6:	8b 45 14             	mov    0x14(%ebp),%eax
  800bf9:	83 c0 04             	add    $0x4,%eax
  800bfc:	89 45 14             	mov    %eax,0x14(%ebp)
  800bff:	8b 45 14             	mov    0x14(%ebp),%eax
  800c02:	83 e8 04             	sub    $0x4,%eax
  800c05:	8b 00                	mov    (%eax),%eax
  800c07:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800c0a:	eb 1f                	jmp    800c2b <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800c0c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c10:	79 83                	jns    800b95 <vprintfmt+0x54>
				width = 0;
  800c12:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800c19:	e9 77 ff ff ff       	jmp    800b95 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800c1e:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800c25:	e9 6b ff ff ff       	jmp    800b95 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800c2a:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800c2b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c2f:	0f 89 60 ff ff ff    	jns    800b95 <vprintfmt+0x54>
				width = precision, precision = -1;
  800c35:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c38:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800c3b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800c42:	e9 4e ff ff ff       	jmp    800b95 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800c47:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800c4a:	e9 46 ff ff ff       	jmp    800b95 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800c4f:	8b 45 14             	mov    0x14(%ebp),%eax
  800c52:	83 c0 04             	add    $0x4,%eax
  800c55:	89 45 14             	mov    %eax,0x14(%ebp)
  800c58:	8b 45 14             	mov    0x14(%ebp),%eax
  800c5b:	83 e8 04             	sub    $0x4,%eax
  800c5e:	8b 00                	mov    (%eax),%eax
  800c60:	83 ec 08             	sub    $0x8,%esp
  800c63:	ff 75 0c             	pushl  0xc(%ebp)
  800c66:	50                   	push   %eax
  800c67:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6a:	ff d0                	call   *%eax
  800c6c:	83 c4 10             	add    $0x10,%esp
			break;
  800c6f:	e9 89 02 00 00       	jmp    800efd <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800c74:	8b 45 14             	mov    0x14(%ebp),%eax
  800c77:	83 c0 04             	add    $0x4,%eax
  800c7a:	89 45 14             	mov    %eax,0x14(%ebp)
  800c7d:	8b 45 14             	mov    0x14(%ebp),%eax
  800c80:	83 e8 04             	sub    $0x4,%eax
  800c83:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800c85:	85 db                	test   %ebx,%ebx
  800c87:	79 02                	jns    800c8b <vprintfmt+0x14a>
				err = -err;
  800c89:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800c8b:	83 fb 64             	cmp    $0x64,%ebx
  800c8e:	7f 0b                	jg     800c9b <vprintfmt+0x15a>
  800c90:	8b 34 9d c0 40 80 00 	mov    0x8040c0(,%ebx,4),%esi
  800c97:	85 f6                	test   %esi,%esi
  800c99:	75 19                	jne    800cb4 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800c9b:	53                   	push   %ebx
  800c9c:	68 65 42 80 00       	push   $0x804265
  800ca1:	ff 75 0c             	pushl  0xc(%ebp)
  800ca4:	ff 75 08             	pushl  0x8(%ebp)
  800ca7:	e8 5e 02 00 00       	call   800f0a <printfmt>
  800cac:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800caf:	e9 49 02 00 00       	jmp    800efd <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800cb4:	56                   	push   %esi
  800cb5:	68 6e 42 80 00       	push   $0x80426e
  800cba:	ff 75 0c             	pushl  0xc(%ebp)
  800cbd:	ff 75 08             	pushl  0x8(%ebp)
  800cc0:	e8 45 02 00 00       	call   800f0a <printfmt>
  800cc5:	83 c4 10             	add    $0x10,%esp
			break;
  800cc8:	e9 30 02 00 00       	jmp    800efd <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800ccd:	8b 45 14             	mov    0x14(%ebp),%eax
  800cd0:	83 c0 04             	add    $0x4,%eax
  800cd3:	89 45 14             	mov    %eax,0x14(%ebp)
  800cd6:	8b 45 14             	mov    0x14(%ebp),%eax
  800cd9:	83 e8 04             	sub    $0x4,%eax
  800cdc:	8b 30                	mov    (%eax),%esi
  800cde:	85 f6                	test   %esi,%esi
  800ce0:	75 05                	jne    800ce7 <vprintfmt+0x1a6>
				p = "(null)";
  800ce2:	be 71 42 80 00       	mov    $0x804271,%esi
			if (width > 0 && padc != '-')
  800ce7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ceb:	7e 6d                	jle    800d5a <vprintfmt+0x219>
  800ced:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800cf1:	74 67                	je     800d5a <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800cf3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800cf6:	83 ec 08             	sub    $0x8,%esp
  800cf9:	50                   	push   %eax
  800cfa:	56                   	push   %esi
  800cfb:	e8 0c 03 00 00       	call   80100c <strnlen>
  800d00:	83 c4 10             	add    $0x10,%esp
  800d03:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800d06:	eb 16                	jmp    800d1e <vprintfmt+0x1dd>
					putch(padc, putdat);
  800d08:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800d0c:	83 ec 08             	sub    $0x8,%esp
  800d0f:	ff 75 0c             	pushl  0xc(%ebp)
  800d12:	50                   	push   %eax
  800d13:	8b 45 08             	mov    0x8(%ebp),%eax
  800d16:	ff d0                	call   *%eax
  800d18:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800d1b:	ff 4d e4             	decl   -0x1c(%ebp)
  800d1e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d22:	7f e4                	jg     800d08 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d24:	eb 34                	jmp    800d5a <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800d26:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800d2a:	74 1c                	je     800d48 <vprintfmt+0x207>
  800d2c:	83 fb 1f             	cmp    $0x1f,%ebx
  800d2f:	7e 05                	jle    800d36 <vprintfmt+0x1f5>
  800d31:	83 fb 7e             	cmp    $0x7e,%ebx
  800d34:	7e 12                	jle    800d48 <vprintfmt+0x207>
					putch('?', putdat);
  800d36:	83 ec 08             	sub    $0x8,%esp
  800d39:	ff 75 0c             	pushl  0xc(%ebp)
  800d3c:	6a 3f                	push   $0x3f
  800d3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d41:	ff d0                	call   *%eax
  800d43:	83 c4 10             	add    $0x10,%esp
  800d46:	eb 0f                	jmp    800d57 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800d48:	83 ec 08             	sub    $0x8,%esp
  800d4b:	ff 75 0c             	pushl  0xc(%ebp)
  800d4e:	53                   	push   %ebx
  800d4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d52:	ff d0                	call   *%eax
  800d54:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d57:	ff 4d e4             	decl   -0x1c(%ebp)
  800d5a:	89 f0                	mov    %esi,%eax
  800d5c:	8d 70 01             	lea    0x1(%eax),%esi
  800d5f:	8a 00                	mov    (%eax),%al
  800d61:	0f be d8             	movsbl %al,%ebx
  800d64:	85 db                	test   %ebx,%ebx
  800d66:	74 24                	je     800d8c <vprintfmt+0x24b>
  800d68:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800d6c:	78 b8                	js     800d26 <vprintfmt+0x1e5>
  800d6e:	ff 4d e0             	decl   -0x20(%ebp)
  800d71:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800d75:	79 af                	jns    800d26 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d77:	eb 13                	jmp    800d8c <vprintfmt+0x24b>
				putch(' ', putdat);
  800d79:	83 ec 08             	sub    $0x8,%esp
  800d7c:	ff 75 0c             	pushl  0xc(%ebp)
  800d7f:	6a 20                	push   $0x20
  800d81:	8b 45 08             	mov    0x8(%ebp),%eax
  800d84:	ff d0                	call   *%eax
  800d86:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d89:	ff 4d e4             	decl   -0x1c(%ebp)
  800d8c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d90:	7f e7                	jg     800d79 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800d92:	e9 66 01 00 00       	jmp    800efd <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800d97:	83 ec 08             	sub    $0x8,%esp
  800d9a:	ff 75 e8             	pushl  -0x18(%ebp)
  800d9d:	8d 45 14             	lea    0x14(%ebp),%eax
  800da0:	50                   	push   %eax
  800da1:	e8 3c fd ff ff       	call   800ae2 <getint>
  800da6:	83 c4 10             	add    $0x10,%esp
  800da9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dac:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800daf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800db2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800db5:	85 d2                	test   %edx,%edx
  800db7:	79 23                	jns    800ddc <vprintfmt+0x29b>
				putch('-', putdat);
  800db9:	83 ec 08             	sub    $0x8,%esp
  800dbc:	ff 75 0c             	pushl  0xc(%ebp)
  800dbf:	6a 2d                	push   $0x2d
  800dc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc4:	ff d0                	call   *%eax
  800dc6:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800dc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dcc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800dcf:	f7 d8                	neg    %eax
  800dd1:	83 d2 00             	adc    $0x0,%edx
  800dd4:	f7 da                	neg    %edx
  800dd6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dd9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800ddc:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800de3:	e9 bc 00 00 00       	jmp    800ea4 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800de8:	83 ec 08             	sub    $0x8,%esp
  800deb:	ff 75 e8             	pushl  -0x18(%ebp)
  800dee:	8d 45 14             	lea    0x14(%ebp),%eax
  800df1:	50                   	push   %eax
  800df2:	e8 84 fc ff ff       	call   800a7b <getuint>
  800df7:	83 c4 10             	add    $0x10,%esp
  800dfa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dfd:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800e00:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e07:	e9 98 00 00 00       	jmp    800ea4 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800e0c:	83 ec 08             	sub    $0x8,%esp
  800e0f:	ff 75 0c             	pushl  0xc(%ebp)
  800e12:	6a 58                	push   $0x58
  800e14:	8b 45 08             	mov    0x8(%ebp),%eax
  800e17:	ff d0                	call   *%eax
  800e19:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e1c:	83 ec 08             	sub    $0x8,%esp
  800e1f:	ff 75 0c             	pushl  0xc(%ebp)
  800e22:	6a 58                	push   $0x58
  800e24:	8b 45 08             	mov    0x8(%ebp),%eax
  800e27:	ff d0                	call   *%eax
  800e29:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e2c:	83 ec 08             	sub    $0x8,%esp
  800e2f:	ff 75 0c             	pushl  0xc(%ebp)
  800e32:	6a 58                	push   $0x58
  800e34:	8b 45 08             	mov    0x8(%ebp),%eax
  800e37:	ff d0                	call   *%eax
  800e39:	83 c4 10             	add    $0x10,%esp
			break;
  800e3c:	e9 bc 00 00 00       	jmp    800efd <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800e41:	83 ec 08             	sub    $0x8,%esp
  800e44:	ff 75 0c             	pushl  0xc(%ebp)
  800e47:	6a 30                	push   $0x30
  800e49:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4c:	ff d0                	call   *%eax
  800e4e:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800e51:	83 ec 08             	sub    $0x8,%esp
  800e54:	ff 75 0c             	pushl  0xc(%ebp)
  800e57:	6a 78                	push   $0x78
  800e59:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5c:	ff d0                	call   *%eax
  800e5e:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800e61:	8b 45 14             	mov    0x14(%ebp),%eax
  800e64:	83 c0 04             	add    $0x4,%eax
  800e67:	89 45 14             	mov    %eax,0x14(%ebp)
  800e6a:	8b 45 14             	mov    0x14(%ebp),%eax
  800e6d:	83 e8 04             	sub    $0x4,%eax
  800e70:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e72:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e75:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800e7c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800e83:	eb 1f                	jmp    800ea4 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800e85:	83 ec 08             	sub    $0x8,%esp
  800e88:	ff 75 e8             	pushl  -0x18(%ebp)
  800e8b:	8d 45 14             	lea    0x14(%ebp),%eax
  800e8e:	50                   	push   %eax
  800e8f:	e8 e7 fb ff ff       	call   800a7b <getuint>
  800e94:	83 c4 10             	add    $0x10,%esp
  800e97:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e9a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800e9d:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ea4:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800ea8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800eab:	83 ec 04             	sub    $0x4,%esp
  800eae:	52                   	push   %edx
  800eaf:	ff 75 e4             	pushl  -0x1c(%ebp)
  800eb2:	50                   	push   %eax
  800eb3:	ff 75 f4             	pushl  -0xc(%ebp)
  800eb6:	ff 75 f0             	pushl  -0x10(%ebp)
  800eb9:	ff 75 0c             	pushl  0xc(%ebp)
  800ebc:	ff 75 08             	pushl  0x8(%ebp)
  800ebf:	e8 00 fb ff ff       	call   8009c4 <printnum>
  800ec4:	83 c4 20             	add    $0x20,%esp
			break;
  800ec7:	eb 34                	jmp    800efd <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ec9:	83 ec 08             	sub    $0x8,%esp
  800ecc:	ff 75 0c             	pushl  0xc(%ebp)
  800ecf:	53                   	push   %ebx
  800ed0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed3:	ff d0                	call   *%eax
  800ed5:	83 c4 10             	add    $0x10,%esp
			break;
  800ed8:	eb 23                	jmp    800efd <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800eda:	83 ec 08             	sub    $0x8,%esp
  800edd:	ff 75 0c             	pushl  0xc(%ebp)
  800ee0:	6a 25                	push   $0x25
  800ee2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee5:	ff d0                	call   *%eax
  800ee7:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800eea:	ff 4d 10             	decl   0x10(%ebp)
  800eed:	eb 03                	jmp    800ef2 <vprintfmt+0x3b1>
  800eef:	ff 4d 10             	decl   0x10(%ebp)
  800ef2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ef5:	48                   	dec    %eax
  800ef6:	8a 00                	mov    (%eax),%al
  800ef8:	3c 25                	cmp    $0x25,%al
  800efa:	75 f3                	jne    800eef <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800efc:	90                   	nop
		}
	}
  800efd:	e9 47 fc ff ff       	jmp    800b49 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800f02:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800f03:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f06:	5b                   	pop    %ebx
  800f07:	5e                   	pop    %esi
  800f08:	5d                   	pop    %ebp
  800f09:	c3                   	ret    

00800f0a <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800f0a:	55                   	push   %ebp
  800f0b:	89 e5                	mov    %esp,%ebp
  800f0d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800f10:	8d 45 10             	lea    0x10(%ebp),%eax
  800f13:	83 c0 04             	add    $0x4,%eax
  800f16:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800f19:	8b 45 10             	mov    0x10(%ebp),%eax
  800f1c:	ff 75 f4             	pushl  -0xc(%ebp)
  800f1f:	50                   	push   %eax
  800f20:	ff 75 0c             	pushl  0xc(%ebp)
  800f23:	ff 75 08             	pushl  0x8(%ebp)
  800f26:	e8 16 fc ff ff       	call   800b41 <vprintfmt>
  800f2b:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800f2e:	90                   	nop
  800f2f:	c9                   	leave  
  800f30:	c3                   	ret    

00800f31 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800f31:	55                   	push   %ebp
  800f32:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800f34:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f37:	8b 40 08             	mov    0x8(%eax),%eax
  800f3a:	8d 50 01             	lea    0x1(%eax),%edx
  800f3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f40:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800f43:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f46:	8b 10                	mov    (%eax),%edx
  800f48:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f4b:	8b 40 04             	mov    0x4(%eax),%eax
  800f4e:	39 c2                	cmp    %eax,%edx
  800f50:	73 12                	jae    800f64 <sprintputch+0x33>
		*b->buf++ = ch;
  800f52:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f55:	8b 00                	mov    (%eax),%eax
  800f57:	8d 48 01             	lea    0x1(%eax),%ecx
  800f5a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f5d:	89 0a                	mov    %ecx,(%edx)
  800f5f:	8b 55 08             	mov    0x8(%ebp),%edx
  800f62:	88 10                	mov    %dl,(%eax)
}
  800f64:	90                   	nop
  800f65:	5d                   	pop    %ebp
  800f66:	c3                   	ret    

00800f67 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800f67:	55                   	push   %ebp
  800f68:	89 e5                	mov    %esp,%ebp
  800f6a:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800f6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f70:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800f73:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f76:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f79:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7c:	01 d0                	add    %edx,%eax
  800f7e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f81:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800f88:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800f8c:	74 06                	je     800f94 <vsnprintf+0x2d>
  800f8e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f92:	7f 07                	jg     800f9b <vsnprintf+0x34>
		return -E_INVAL;
  800f94:	b8 03 00 00 00       	mov    $0x3,%eax
  800f99:	eb 20                	jmp    800fbb <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800f9b:	ff 75 14             	pushl  0x14(%ebp)
  800f9e:	ff 75 10             	pushl  0x10(%ebp)
  800fa1:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800fa4:	50                   	push   %eax
  800fa5:	68 31 0f 80 00       	push   $0x800f31
  800faa:	e8 92 fb ff ff       	call   800b41 <vprintfmt>
  800faf:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800fb2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800fb5:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800fb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800fbb:	c9                   	leave  
  800fbc:	c3                   	ret    

00800fbd <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800fbd:	55                   	push   %ebp
  800fbe:	89 e5                	mov    %esp,%ebp
  800fc0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800fc3:	8d 45 10             	lea    0x10(%ebp),%eax
  800fc6:	83 c0 04             	add    $0x4,%eax
  800fc9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800fcc:	8b 45 10             	mov    0x10(%ebp),%eax
  800fcf:	ff 75 f4             	pushl  -0xc(%ebp)
  800fd2:	50                   	push   %eax
  800fd3:	ff 75 0c             	pushl  0xc(%ebp)
  800fd6:	ff 75 08             	pushl  0x8(%ebp)
  800fd9:	e8 89 ff ff ff       	call   800f67 <vsnprintf>
  800fde:	83 c4 10             	add    $0x10,%esp
  800fe1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800fe4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800fe7:	c9                   	leave  
  800fe8:	c3                   	ret    

00800fe9 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800fe9:	55                   	push   %ebp
  800fea:	89 e5                	mov    %esp,%ebp
  800fec:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800fef:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ff6:	eb 06                	jmp    800ffe <strlen+0x15>
		n++;
  800ff8:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800ffb:	ff 45 08             	incl   0x8(%ebp)
  800ffe:	8b 45 08             	mov    0x8(%ebp),%eax
  801001:	8a 00                	mov    (%eax),%al
  801003:	84 c0                	test   %al,%al
  801005:	75 f1                	jne    800ff8 <strlen+0xf>
		n++;
	return n;
  801007:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80100a:	c9                   	leave  
  80100b:	c3                   	ret    

0080100c <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80100c:	55                   	push   %ebp
  80100d:	89 e5                	mov    %esp,%ebp
  80100f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801012:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801019:	eb 09                	jmp    801024 <strnlen+0x18>
		n++;
  80101b:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80101e:	ff 45 08             	incl   0x8(%ebp)
  801021:	ff 4d 0c             	decl   0xc(%ebp)
  801024:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801028:	74 09                	je     801033 <strnlen+0x27>
  80102a:	8b 45 08             	mov    0x8(%ebp),%eax
  80102d:	8a 00                	mov    (%eax),%al
  80102f:	84 c0                	test   %al,%al
  801031:	75 e8                	jne    80101b <strnlen+0xf>
		n++;
	return n;
  801033:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801036:	c9                   	leave  
  801037:	c3                   	ret    

00801038 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801038:	55                   	push   %ebp
  801039:	89 e5                	mov    %esp,%ebp
  80103b:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80103e:	8b 45 08             	mov    0x8(%ebp),%eax
  801041:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801044:	90                   	nop
  801045:	8b 45 08             	mov    0x8(%ebp),%eax
  801048:	8d 50 01             	lea    0x1(%eax),%edx
  80104b:	89 55 08             	mov    %edx,0x8(%ebp)
  80104e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801051:	8d 4a 01             	lea    0x1(%edx),%ecx
  801054:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801057:	8a 12                	mov    (%edx),%dl
  801059:	88 10                	mov    %dl,(%eax)
  80105b:	8a 00                	mov    (%eax),%al
  80105d:	84 c0                	test   %al,%al
  80105f:	75 e4                	jne    801045 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801061:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801064:	c9                   	leave  
  801065:	c3                   	ret    

00801066 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801066:	55                   	push   %ebp
  801067:	89 e5                	mov    %esp,%ebp
  801069:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80106c:	8b 45 08             	mov    0x8(%ebp),%eax
  80106f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801072:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801079:	eb 1f                	jmp    80109a <strncpy+0x34>
		*dst++ = *src;
  80107b:	8b 45 08             	mov    0x8(%ebp),%eax
  80107e:	8d 50 01             	lea    0x1(%eax),%edx
  801081:	89 55 08             	mov    %edx,0x8(%ebp)
  801084:	8b 55 0c             	mov    0xc(%ebp),%edx
  801087:	8a 12                	mov    (%edx),%dl
  801089:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80108b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80108e:	8a 00                	mov    (%eax),%al
  801090:	84 c0                	test   %al,%al
  801092:	74 03                	je     801097 <strncpy+0x31>
			src++;
  801094:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801097:	ff 45 fc             	incl   -0x4(%ebp)
  80109a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80109d:	3b 45 10             	cmp    0x10(%ebp),%eax
  8010a0:	72 d9                	jb     80107b <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8010a2:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8010a5:	c9                   	leave  
  8010a6:	c3                   	ret    

008010a7 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8010a7:	55                   	push   %ebp
  8010a8:	89 e5                	mov    %esp,%ebp
  8010aa:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8010ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8010b3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010b7:	74 30                	je     8010e9 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8010b9:	eb 16                	jmp    8010d1 <strlcpy+0x2a>
			*dst++ = *src++;
  8010bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010be:	8d 50 01             	lea    0x1(%eax),%edx
  8010c1:	89 55 08             	mov    %edx,0x8(%ebp)
  8010c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010c7:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010ca:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8010cd:	8a 12                	mov    (%edx),%dl
  8010cf:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8010d1:	ff 4d 10             	decl   0x10(%ebp)
  8010d4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010d8:	74 09                	je     8010e3 <strlcpy+0x3c>
  8010da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010dd:	8a 00                	mov    (%eax),%al
  8010df:	84 c0                	test   %al,%al
  8010e1:	75 d8                	jne    8010bb <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8010e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e6:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8010e9:	8b 55 08             	mov    0x8(%ebp),%edx
  8010ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010ef:	29 c2                	sub    %eax,%edx
  8010f1:	89 d0                	mov    %edx,%eax
}
  8010f3:	c9                   	leave  
  8010f4:	c3                   	ret    

008010f5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8010f5:	55                   	push   %ebp
  8010f6:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8010f8:	eb 06                	jmp    801100 <strcmp+0xb>
		p++, q++;
  8010fa:	ff 45 08             	incl   0x8(%ebp)
  8010fd:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801100:	8b 45 08             	mov    0x8(%ebp),%eax
  801103:	8a 00                	mov    (%eax),%al
  801105:	84 c0                	test   %al,%al
  801107:	74 0e                	je     801117 <strcmp+0x22>
  801109:	8b 45 08             	mov    0x8(%ebp),%eax
  80110c:	8a 10                	mov    (%eax),%dl
  80110e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801111:	8a 00                	mov    (%eax),%al
  801113:	38 c2                	cmp    %al,%dl
  801115:	74 e3                	je     8010fa <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801117:	8b 45 08             	mov    0x8(%ebp),%eax
  80111a:	8a 00                	mov    (%eax),%al
  80111c:	0f b6 d0             	movzbl %al,%edx
  80111f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801122:	8a 00                	mov    (%eax),%al
  801124:	0f b6 c0             	movzbl %al,%eax
  801127:	29 c2                	sub    %eax,%edx
  801129:	89 d0                	mov    %edx,%eax
}
  80112b:	5d                   	pop    %ebp
  80112c:	c3                   	ret    

0080112d <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80112d:	55                   	push   %ebp
  80112e:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801130:	eb 09                	jmp    80113b <strncmp+0xe>
		n--, p++, q++;
  801132:	ff 4d 10             	decl   0x10(%ebp)
  801135:	ff 45 08             	incl   0x8(%ebp)
  801138:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80113b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80113f:	74 17                	je     801158 <strncmp+0x2b>
  801141:	8b 45 08             	mov    0x8(%ebp),%eax
  801144:	8a 00                	mov    (%eax),%al
  801146:	84 c0                	test   %al,%al
  801148:	74 0e                	je     801158 <strncmp+0x2b>
  80114a:	8b 45 08             	mov    0x8(%ebp),%eax
  80114d:	8a 10                	mov    (%eax),%dl
  80114f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801152:	8a 00                	mov    (%eax),%al
  801154:	38 c2                	cmp    %al,%dl
  801156:	74 da                	je     801132 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801158:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80115c:	75 07                	jne    801165 <strncmp+0x38>
		return 0;
  80115e:	b8 00 00 00 00       	mov    $0x0,%eax
  801163:	eb 14                	jmp    801179 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801165:	8b 45 08             	mov    0x8(%ebp),%eax
  801168:	8a 00                	mov    (%eax),%al
  80116a:	0f b6 d0             	movzbl %al,%edx
  80116d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801170:	8a 00                	mov    (%eax),%al
  801172:	0f b6 c0             	movzbl %al,%eax
  801175:	29 c2                	sub    %eax,%edx
  801177:	89 d0                	mov    %edx,%eax
}
  801179:	5d                   	pop    %ebp
  80117a:	c3                   	ret    

0080117b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80117b:	55                   	push   %ebp
  80117c:	89 e5                	mov    %esp,%ebp
  80117e:	83 ec 04             	sub    $0x4,%esp
  801181:	8b 45 0c             	mov    0xc(%ebp),%eax
  801184:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801187:	eb 12                	jmp    80119b <strchr+0x20>
		if (*s == c)
  801189:	8b 45 08             	mov    0x8(%ebp),%eax
  80118c:	8a 00                	mov    (%eax),%al
  80118e:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801191:	75 05                	jne    801198 <strchr+0x1d>
			return (char *) s;
  801193:	8b 45 08             	mov    0x8(%ebp),%eax
  801196:	eb 11                	jmp    8011a9 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801198:	ff 45 08             	incl   0x8(%ebp)
  80119b:	8b 45 08             	mov    0x8(%ebp),%eax
  80119e:	8a 00                	mov    (%eax),%al
  8011a0:	84 c0                	test   %al,%al
  8011a2:	75 e5                	jne    801189 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8011a4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011a9:	c9                   	leave  
  8011aa:	c3                   	ret    

008011ab <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8011ab:	55                   	push   %ebp
  8011ac:	89 e5                	mov    %esp,%ebp
  8011ae:	83 ec 04             	sub    $0x4,%esp
  8011b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b4:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8011b7:	eb 0d                	jmp    8011c6 <strfind+0x1b>
		if (*s == c)
  8011b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011bc:	8a 00                	mov    (%eax),%al
  8011be:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8011c1:	74 0e                	je     8011d1 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8011c3:	ff 45 08             	incl   0x8(%ebp)
  8011c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c9:	8a 00                	mov    (%eax),%al
  8011cb:	84 c0                	test   %al,%al
  8011cd:	75 ea                	jne    8011b9 <strfind+0xe>
  8011cf:	eb 01                	jmp    8011d2 <strfind+0x27>
		if (*s == c)
			break;
  8011d1:	90                   	nop
	return (char *) s;
  8011d2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011d5:	c9                   	leave  
  8011d6:	c3                   	ret    

008011d7 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8011d7:	55                   	push   %ebp
  8011d8:	89 e5                	mov    %esp,%ebp
  8011da:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8011dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8011e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8011e6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8011e9:	eb 0e                	jmp    8011f9 <memset+0x22>
		*p++ = c;
  8011eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011ee:	8d 50 01             	lea    0x1(%eax),%edx
  8011f1:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011f7:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8011f9:	ff 4d f8             	decl   -0x8(%ebp)
  8011fc:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801200:	79 e9                	jns    8011eb <memset+0x14>
		*p++ = c;

	return v;
  801202:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801205:	c9                   	leave  
  801206:	c3                   	ret    

00801207 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801207:	55                   	push   %ebp
  801208:	89 e5                	mov    %esp,%ebp
  80120a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80120d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801210:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801213:	8b 45 08             	mov    0x8(%ebp),%eax
  801216:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801219:	eb 16                	jmp    801231 <memcpy+0x2a>
		*d++ = *s++;
  80121b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80121e:	8d 50 01             	lea    0x1(%eax),%edx
  801221:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801224:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801227:	8d 4a 01             	lea    0x1(%edx),%ecx
  80122a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80122d:	8a 12                	mov    (%edx),%dl
  80122f:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801231:	8b 45 10             	mov    0x10(%ebp),%eax
  801234:	8d 50 ff             	lea    -0x1(%eax),%edx
  801237:	89 55 10             	mov    %edx,0x10(%ebp)
  80123a:	85 c0                	test   %eax,%eax
  80123c:	75 dd                	jne    80121b <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80123e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801241:	c9                   	leave  
  801242:	c3                   	ret    

00801243 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801243:	55                   	push   %ebp
  801244:	89 e5                	mov    %esp,%ebp
  801246:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801249:	8b 45 0c             	mov    0xc(%ebp),%eax
  80124c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80124f:	8b 45 08             	mov    0x8(%ebp),%eax
  801252:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801255:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801258:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80125b:	73 50                	jae    8012ad <memmove+0x6a>
  80125d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801260:	8b 45 10             	mov    0x10(%ebp),%eax
  801263:	01 d0                	add    %edx,%eax
  801265:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801268:	76 43                	jbe    8012ad <memmove+0x6a>
		s += n;
  80126a:	8b 45 10             	mov    0x10(%ebp),%eax
  80126d:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801270:	8b 45 10             	mov    0x10(%ebp),%eax
  801273:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801276:	eb 10                	jmp    801288 <memmove+0x45>
			*--d = *--s;
  801278:	ff 4d f8             	decl   -0x8(%ebp)
  80127b:	ff 4d fc             	decl   -0x4(%ebp)
  80127e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801281:	8a 10                	mov    (%eax),%dl
  801283:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801286:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801288:	8b 45 10             	mov    0x10(%ebp),%eax
  80128b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80128e:	89 55 10             	mov    %edx,0x10(%ebp)
  801291:	85 c0                	test   %eax,%eax
  801293:	75 e3                	jne    801278 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801295:	eb 23                	jmp    8012ba <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801297:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80129a:	8d 50 01             	lea    0x1(%eax),%edx
  80129d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012a0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012a3:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012a6:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8012a9:	8a 12                	mov    (%edx),%dl
  8012ab:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8012ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8012b0:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012b3:	89 55 10             	mov    %edx,0x10(%ebp)
  8012b6:	85 c0                	test   %eax,%eax
  8012b8:	75 dd                	jne    801297 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8012ba:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012bd:	c9                   	leave  
  8012be:	c3                   	ret    

008012bf <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8012bf:	55                   	push   %ebp
  8012c0:	89 e5                	mov    %esp,%ebp
  8012c2:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8012c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8012cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ce:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8012d1:	eb 2a                	jmp    8012fd <memcmp+0x3e>
		if (*s1 != *s2)
  8012d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012d6:	8a 10                	mov    (%eax),%dl
  8012d8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012db:	8a 00                	mov    (%eax),%al
  8012dd:	38 c2                	cmp    %al,%dl
  8012df:	74 16                	je     8012f7 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8012e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012e4:	8a 00                	mov    (%eax),%al
  8012e6:	0f b6 d0             	movzbl %al,%edx
  8012e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012ec:	8a 00                	mov    (%eax),%al
  8012ee:	0f b6 c0             	movzbl %al,%eax
  8012f1:	29 c2                	sub    %eax,%edx
  8012f3:	89 d0                	mov    %edx,%eax
  8012f5:	eb 18                	jmp    80130f <memcmp+0x50>
		s1++, s2++;
  8012f7:	ff 45 fc             	incl   -0x4(%ebp)
  8012fa:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8012fd:	8b 45 10             	mov    0x10(%ebp),%eax
  801300:	8d 50 ff             	lea    -0x1(%eax),%edx
  801303:	89 55 10             	mov    %edx,0x10(%ebp)
  801306:	85 c0                	test   %eax,%eax
  801308:	75 c9                	jne    8012d3 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80130a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80130f:	c9                   	leave  
  801310:	c3                   	ret    

00801311 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801311:	55                   	push   %ebp
  801312:	89 e5                	mov    %esp,%ebp
  801314:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801317:	8b 55 08             	mov    0x8(%ebp),%edx
  80131a:	8b 45 10             	mov    0x10(%ebp),%eax
  80131d:	01 d0                	add    %edx,%eax
  80131f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801322:	eb 15                	jmp    801339 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801324:	8b 45 08             	mov    0x8(%ebp),%eax
  801327:	8a 00                	mov    (%eax),%al
  801329:	0f b6 d0             	movzbl %al,%edx
  80132c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80132f:	0f b6 c0             	movzbl %al,%eax
  801332:	39 c2                	cmp    %eax,%edx
  801334:	74 0d                	je     801343 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801336:	ff 45 08             	incl   0x8(%ebp)
  801339:	8b 45 08             	mov    0x8(%ebp),%eax
  80133c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80133f:	72 e3                	jb     801324 <memfind+0x13>
  801341:	eb 01                	jmp    801344 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801343:	90                   	nop
	return (void *) s;
  801344:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801347:	c9                   	leave  
  801348:	c3                   	ret    

00801349 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801349:	55                   	push   %ebp
  80134a:	89 e5                	mov    %esp,%ebp
  80134c:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80134f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801356:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80135d:	eb 03                	jmp    801362 <strtol+0x19>
		s++;
  80135f:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801362:	8b 45 08             	mov    0x8(%ebp),%eax
  801365:	8a 00                	mov    (%eax),%al
  801367:	3c 20                	cmp    $0x20,%al
  801369:	74 f4                	je     80135f <strtol+0x16>
  80136b:	8b 45 08             	mov    0x8(%ebp),%eax
  80136e:	8a 00                	mov    (%eax),%al
  801370:	3c 09                	cmp    $0x9,%al
  801372:	74 eb                	je     80135f <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801374:	8b 45 08             	mov    0x8(%ebp),%eax
  801377:	8a 00                	mov    (%eax),%al
  801379:	3c 2b                	cmp    $0x2b,%al
  80137b:	75 05                	jne    801382 <strtol+0x39>
		s++;
  80137d:	ff 45 08             	incl   0x8(%ebp)
  801380:	eb 13                	jmp    801395 <strtol+0x4c>
	else if (*s == '-')
  801382:	8b 45 08             	mov    0x8(%ebp),%eax
  801385:	8a 00                	mov    (%eax),%al
  801387:	3c 2d                	cmp    $0x2d,%al
  801389:	75 0a                	jne    801395 <strtol+0x4c>
		s++, neg = 1;
  80138b:	ff 45 08             	incl   0x8(%ebp)
  80138e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801395:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801399:	74 06                	je     8013a1 <strtol+0x58>
  80139b:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80139f:	75 20                	jne    8013c1 <strtol+0x78>
  8013a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a4:	8a 00                	mov    (%eax),%al
  8013a6:	3c 30                	cmp    $0x30,%al
  8013a8:	75 17                	jne    8013c1 <strtol+0x78>
  8013aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ad:	40                   	inc    %eax
  8013ae:	8a 00                	mov    (%eax),%al
  8013b0:	3c 78                	cmp    $0x78,%al
  8013b2:	75 0d                	jne    8013c1 <strtol+0x78>
		s += 2, base = 16;
  8013b4:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8013b8:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8013bf:	eb 28                	jmp    8013e9 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8013c1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013c5:	75 15                	jne    8013dc <strtol+0x93>
  8013c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ca:	8a 00                	mov    (%eax),%al
  8013cc:	3c 30                	cmp    $0x30,%al
  8013ce:	75 0c                	jne    8013dc <strtol+0x93>
		s++, base = 8;
  8013d0:	ff 45 08             	incl   0x8(%ebp)
  8013d3:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8013da:	eb 0d                	jmp    8013e9 <strtol+0xa0>
	else if (base == 0)
  8013dc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013e0:	75 07                	jne    8013e9 <strtol+0xa0>
		base = 10;
  8013e2:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8013e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ec:	8a 00                	mov    (%eax),%al
  8013ee:	3c 2f                	cmp    $0x2f,%al
  8013f0:	7e 19                	jle    80140b <strtol+0xc2>
  8013f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f5:	8a 00                	mov    (%eax),%al
  8013f7:	3c 39                	cmp    $0x39,%al
  8013f9:	7f 10                	jg     80140b <strtol+0xc2>
			dig = *s - '0';
  8013fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8013fe:	8a 00                	mov    (%eax),%al
  801400:	0f be c0             	movsbl %al,%eax
  801403:	83 e8 30             	sub    $0x30,%eax
  801406:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801409:	eb 42                	jmp    80144d <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80140b:	8b 45 08             	mov    0x8(%ebp),%eax
  80140e:	8a 00                	mov    (%eax),%al
  801410:	3c 60                	cmp    $0x60,%al
  801412:	7e 19                	jle    80142d <strtol+0xe4>
  801414:	8b 45 08             	mov    0x8(%ebp),%eax
  801417:	8a 00                	mov    (%eax),%al
  801419:	3c 7a                	cmp    $0x7a,%al
  80141b:	7f 10                	jg     80142d <strtol+0xe4>
			dig = *s - 'a' + 10;
  80141d:	8b 45 08             	mov    0x8(%ebp),%eax
  801420:	8a 00                	mov    (%eax),%al
  801422:	0f be c0             	movsbl %al,%eax
  801425:	83 e8 57             	sub    $0x57,%eax
  801428:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80142b:	eb 20                	jmp    80144d <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80142d:	8b 45 08             	mov    0x8(%ebp),%eax
  801430:	8a 00                	mov    (%eax),%al
  801432:	3c 40                	cmp    $0x40,%al
  801434:	7e 39                	jle    80146f <strtol+0x126>
  801436:	8b 45 08             	mov    0x8(%ebp),%eax
  801439:	8a 00                	mov    (%eax),%al
  80143b:	3c 5a                	cmp    $0x5a,%al
  80143d:	7f 30                	jg     80146f <strtol+0x126>
			dig = *s - 'A' + 10;
  80143f:	8b 45 08             	mov    0x8(%ebp),%eax
  801442:	8a 00                	mov    (%eax),%al
  801444:	0f be c0             	movsbl %al,%eax
  801447:	83 e8 37             	sub    $0x37,%eax
  80144a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80144d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801450:	3b 45 10             	cmp    0x10(%ebp),%eax
  801453:	7d 19                	jge    80146e <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801455:	ff 45 08             	incl   0x8(%ebp)
  801458:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80145b:	0f af 45 10          	imul   0x10(%ebp),%eax
  80145f:	89 c2                	mov    %eax,%edx
  801461:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801464:	01 d0                	add    %edx,%eax
  801466:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801469:	e9 7b ff ff ff       	jmp    8013e9 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80146e:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80146f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801473:	74 08                	je     80147d <strtol+0x134>
		*endptr = (char *) s;
  801475:	8b 45 0c             	mov    0xc(%ebp),%eax
  801478:	8b 55 08             	mov    0x8(%ebp),%edx
  80147b:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80147d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801481:	74 07                	je     80148a <strtol+0x141>
  801483:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801486:	f7 d8                	neg    %eax
  801488:	eb 03                	jmp    80148d <strtol+0x144>
  80148a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80148d:	c9                   	leave  
  80148e:	c3                   	ret    

0080148f <ltostr>:

void
ltostr(long value, char *str)
{
  80148f:	55                   	push   %ebp
  801490:	89 e5                	mov    %esp,%ebp
  801492:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801495:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80149c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8014a3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014a7:	79 13                	jns    8014bc <ltostr+0x2d>
	{
		neg = 1;
  8014a9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8014b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014b3:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8014b6:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8014b9:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8014bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8014bf:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8014c4:	99                   	cltd   
  8014c5:	f7 f9                	idiv   %ecx
  8014c7:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8014ca:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014cd:	8d 50 01             	lea    0x1(%eax),%edx
  8014d0:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8014d3:	89 c2                	mov    %eax,%edx
  8014d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014d8:	01 d0                	add    %edx,%eax
  8014da:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8014dd:	83 c2 30             	add    $0x30,%edx
  8014e0:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8014e2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8014e5:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8014ea:	f7 e9                	imul   %ecx
  8014ec:	c1 fa 02             	sar    $0x2,%edx
  8014ef:	89 c8                	mov    %ecx,%eax
  8014f1:	c1 f8 1f             	sar    $0x1f,%eax
  8014f4:	29 c2                	sub    %eax,%edx
  8014f6:	89 d0                	mov    %edx,%eax
  8014f8:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8014fb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8014fe:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801503:	f7 e9                	imul   %ecx
  801505:	c1 fa 02             	sar    $0x2,%edx
  801508:	89 c8                	mov    %ecx,%eax
  80150a:	c1 f8 1f             	sar    $0x1f,%eax
  80150d:	29 c2                	sub    %eax,%edx
  80150f:	89 d0                	mov    %edx,%eax
  801511:	c1 e0 02             	shl    $0x2,%eax
  801514:	01 d0                	add    %edx,%eax
  801516:	01 c0                	add    %eax,%eax
  801518:	29 c1                	sub    %eax,%ecx
  80151a:	89 ca                	mov    %ecx,%edx
  80151c:	85 d2                	test   %edx,%edx
  80151e:	75 9c                	jne    8014bc <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801520:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801527:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80152a:	48                   	dec    %eax
  80152b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80152e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801532:	74 3d                	je     801571 <ltostr+0xe2>
		start = 1 ;
  801534:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80153b:	eb 34                	jmp    801571 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80153d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801540:	8b 45 0c             	mov    0xc(%ebp),%eax
  801543:	01 d0                	add    %edx,%eax
  801545:	8a 00                	mov    (%eax),%al
  801547:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80154a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80154d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801550:	01 c2                	add    %eax,%edx
  801552:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801555:	8b 45 0c             	mov    0xc(%ebp),%eax
  801558:	01 c8                	add    %ecx,%eax
  80155a:	8a 00                	mov    (%eax),%al
  80155c:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80155e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801561:	8b 45 0c             	mov    0xc(%ebp),%eax
  801564:	01 c2                	add    %eax,%edx
  801566:	8a 45 eb             	mov    -0x15(%ebp),%al
  801569:	88 02                	mov    %al,(%edx)
		start++ ;
  80156b:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80156e:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801571:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801574:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801577:	7c c4                	jl     80153d <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801579:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80157c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80157f:	01 d0                	add    %edx,%eax
  801581:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801584:	90                   	nop
  801585:	c9                   	leave  
  801586:	c3                   	ret    

00801587 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801587:	55                   	push   %ebp
  801588:	89 e5                	mov    %esp,%ebp
  80158a:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80158d:	ff 75 08             	pushl  0x8(%ebp)
  801590:	e8 54 fa ff ff       	call   800fe9 <strlen>
  801595:	83 c4 04             	add    $0x4,%esp
  801598:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80159b:	ff 75 0c             	pushl  0xc(%ebp)
  80159e:	e8 46 fa ff ff       	call   800fe9 <strlen>
  8015a3:	83 c4 04             	add    $0x4,%esp
  8015a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8015a9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8015b0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015b7:	eb 17                	jmp    8015d0 <strcconcat+0x49>
		final[s] = str1[s] ;
  8015b9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8015bf:	01 c2                	add    %eax,%edx
  8015c1:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8015c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c7:	01 c8                	add    %ecx,%eax
  8015c9:	8a 00                	mov    (%eax),%al
  8015cb:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8015cd:	ff 45 fc             	incl   -0x4(%ebp)
  8015d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015d3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8015d6:	7c e1                	jl     8015b9 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8015d8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8015df:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8015e6:	eb 1f                	jmp    801607 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8015e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015eb:	8d 50 01             	lea    0x1(%eax),%edx
  8015ee:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8015f1:	89 c2                	mov    %eax,%edx
  8015f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8015f6:	01 c2                	add    %eax,%edx
  8015f8:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8015fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015fe:	01 c8                	add    %ecx,%eax
  801600:	8a 00                	mov    (%eax),%al
  801602:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801604:	ff 45 f8             	incl   -0x8(%ebp)
  801607:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80160a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80160d:	7c d9                	jl     8015e8 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80160f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801612:	8b 45 10             	mov    0x10(%ebp),%eax
  801615:	01 d0                	add    %edx,%eax
  801617:	c6 00 00             	movb   $0x0,(%eax)
}
  80161a:	90                   	nop
  80161b:	c9                   	leave  
  80161c:	c3                   	ret    

0080161d <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80161d:	55                   	push   %ebp
  80161e:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801620:	8b 45 14             	mov    0x14(%ebp),%eax
  801623:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801629:	8b 45 14             	mov    0x14(%ebp),%eax
  80162c:	8b 00                	mov    (%eax),%eax
  80162e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801635:	8b 45 10             	mov    0x10(%ebp),%eax
  801638:	01 d0                	add    %edx,%eax
  80163a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801640:	eb 0c                	jmp    80164e <strsplit+0x31>
			*string++ = 0;
  801642:	8b 45 08             	mov    0x8(%ebp),%eax
  801645:	8d 50 01             	lea    0x1(%eax),%edx
  801648:	89 55 08             	mov    %edx,0x8(%ebp)
  80164b:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80164e:	8b 45 08             	mov    0x8(%ebp),%eax
  801651:	8a 00                	mov    (%eax),%al
  801653:	84 c0                	test   %al,%al
  801655:	74 18                	je     80166f <strsplit+0x52>
  801657:	8b 45 08             	mov    0x8(%ebp),%eax
  80165a:	8a 00                	mov    (%eax),%al
  80165c:	0f be c0             	movsbl %al,%eax
  80165f:	50                   	push   %eax
  801660:	ff 75 0c             	pushl  0xc(%ebp)
  801663:	e8 13 fb ff ff       	call   80117b <strchr>
  801668:	83 c4 08             	add    $0x8,%esp
  80166b:	85 c0                	test   %eax,%eax
  80166d:	75 d3                	jne    801642 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80166f:	8b 45 08             	mov    0x8(%ebp),%eax
  801672:	8a 00                	mov    (%eax),%al
  801674:	84 c0                	test   %al,%al
  801676:	74 5a                	je     8016d2 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801678:	8b 45 14             	mov    0x14(%ebp),%eax
  80167b:	8b 00                	mov    (%eax),%eax
  80167d:	83 f8 0f             	cmp    $0xf,%eax
  801680:	75 07                	jne    801689 <strsplit+0x6c>
		{
			return 0;
  801682:	b8 00 00 00 00       	mov    $0x0,%eax
  801687:	eb 66                	jmp    8016ef <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801689:	8b 45 14             	mov    0x14(%ebp),%eax
  80168c:	8b 00                	mov    (%eax),%eax
  80168e:	8d 48 01             	lea    0x1(%eax),%ecx
  801691:	8b 55 14             	mov    0x14(%ebp),%edx
  801694:	89 0a                	mov    %ecx,(%edx)
  801696:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80169d:	8b 45 10             	mov    0x10(%ebp),%eax
  8016a0:	01 c2                	add    %eax,%edx
  8016a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a5:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8016a7:	eb 03                	jmp    8016ac <strsplit+0x8f>
			string++;
  8016a9:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8016ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8016af:	8a 00                	mov    (%eax),%al
  8016b1:	84 c0                	test   %al,%al
  8016b3:	74 8b                	je     801640 <strsplit+0x23>
  8016b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b8:	8a 00                	mov    (%eax),%al
  8016ba:	0f be c0             	movsbl %al,%eax
  8016bd:	50                   	push   %eax
  8016be:	ff 75 0c             	pushl  0xc(%ebp)
  8016c1:	e8 b5 fa ff ff       	call   80117b <strchr>
  8016c6:	83 c4 08             	add    $0x8,%esp
  8016c9:	85 c0                	test   %eax,%eax
  8016cb:	74 dc                	je     8016a9 <strsplit+0x8c>
			string++;
	}
  8016cd:	e9 6e ff ff ff       	jmp    801640 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8016d2:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8016d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8016d6:	8b 00                	mov    (%eax),%eax
  8016d8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016df:	8b 45 10             	mov    0x10(%ebp),%eax
  8016e2:	01 d0                	add    %edx,%eax
  8016e4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8016ea:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8016ef:	c9                   	leave  
  8016f0:	c3                   	ret    

008016f1 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8016f1:	55                   	push   %ebp
  8016f2:	89 e5                	mov    %esp,%ebp
  8016f4:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8016f7:	a1 04 50 80 00       	mov    0x805004,%eax
  8016fc:	85 c0                	test   %eax,%eax
  8016fe:	74 1f                	je     80171f <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801700:	e8 1d 00 00 00       	call   801722 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801705:	83 ec 0c             	sub    $0xc,%esp
  801708:	68 d0 43 80 00       	push   $0x8043d0
  80170d:	e8 55 f2 ff ff       	call   800967 <cprintf>
  801712:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801715:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  80171c:	00 00 00 
	}
}
  80171f:	90                   	nop
  801720:	c9                   	leave  
  801721:	c3                   	ret    

00801722 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801722:	55                   	push   %ebp
  801723:	89 e5                	mov    %esp,%ebp
  801725:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	LIST_INIT(&AllocMemBlocksList);
  801728:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  80172f:	00 00 00 
  801732:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801739:	00 00 00 
  80173c:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801743:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801746:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  80174d:	00 00 00 
  801750:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801757:	00 00 00 
  80175a:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801761:	00 00 00 
	uint32 arr_size = 0;
  801764:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	MemBlockNodes  =(struct MemBlock*) USER_DYN_BLKS_ARRAY;
  80176b:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  801772:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801775:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80177a:	2d 00 10 00 00       	sub    $0x1000,%eax
  80177f:	a3 50 50 80 00       	mov    %eax,0x805050
	MAX_MEM_BLOCK_CNT = (USER_HEAP_MAX-USER_HEAP_START)/PAGE_SIZE;
  801784:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  80178b:	00 02 00 
	arr_size =  ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock), PAGE_SIZE);
  80178e:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801795:	a1 20 51 80 00       	mov    0x805120,%eax
  80179a:	c1 e0 04             	shl    $0x4,%eax
  80179d:	89 c2                	mov    %eax,%edx
  80179f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017a2:	01 d0                	add    %edx,%eax
  8017a4:	48                   	dec    %eax
  8017a5:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8017a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017ab:	ba 00 00 00 00       	mov    $0x0,%edx
  8017b0:	f7 75 ec             	divl   -0x14(%ebp)
  8017b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017b6:	29 d0                	sub    %edx,%eax
  8017b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY , arr_size , PERM_WRITEABLE | PERM_USER);
  8017bb:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  8017c2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017c5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8017ca:	2d 00 10 00 00       	sub    $0x1000,%eax
  8017cf:	83 ec 04             	sub    $0x4,%esp
  8017d2:	6a 06                	push   $0x6
  8017d4:	ff 75 f4             	pushl  -0xc(%ebp)
  8017d7:	50                   	push   %eax
  8017d8:	e8 6a 04 00 00       	call   801c47 <sys_allocate_chunk>
  8017dd:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8017e0:	a1 20 51 80 00       	mov    0x805120,%eax
  8017e5:	83 ec 0c             	sub    $0xc,%esp
  8017e8:	50                   	push   %eax
  8017e9:	e8 df 0a 00 00       	call   8022cd <initialize_MemBlocksList>
  8017ee:	83 c4 10             	add    $0x10,%esp
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	struct MemBlock * NewBlock = LIST_FIRST(&AvailableMemBlocksList);
  8017f1:	a1 48 51 80 00       	mov    0x805148,%eax
  8017f6:	89 45 e0             	mov    %eax,-0x20(%ebp)
	NewBlock->sva = USER_HEAP_START;
  8017f9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8017fc:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	NewBlock->size = (USER_HEAP_MAX-USER_HEAP_START);
  801803:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801806:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	LIST_REMOVE(&AvailableMemBlocksList,NewBlock);
  80180d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801811:	75 14                	jne    801827 <initialize_dyn_block_system+0x105>
  801813:	83 ec 04             	sub    $0x4,%esp
  801816:	68 f5 43 80 00       	push   $0x8043f5
  80181b:	6a 33                	push   $0x33
  80181d:	68 13 44 80 00       	push   $0x804413
  801822:	e8 8c ee ff ff       	call   8006b3 <_panic>
  801827:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80182a:	8b 00                	mov    (%eax),%eax
  80182c:	85 c0                	test   %eax,%eax
  80182e:	74 10                	je     801840 <initialize_dyn_block_system+0x11e>
  801830:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801833:	8b 00                	mov    (%eax),%eax
  801835:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801838:	8b 52 04             	mov    0x4(%edx),%edx
  80183b:	89 50 04             	mov    %edx,0x4(%eax)
  80183e:	eb 0b                	jmp    80184b <initialize_dyn_block_system+0x129>
  801840:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801843:	8b 40 04             	mov    0x4(%eax),%eax
  801846:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80184b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80184e:	8b 40 04             	mov    0x4(%eax),%eax
  801851:	85 c0                	test   %eax,%eax
  801853:	74 0f                	je     801864 <initialize_dyn_block_system+0x142>
  801855:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801858:	8b 40 04             	mov    0x4(%eax),%eax
  80185b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80185e:	8b 12                	mov    (%edx),%edx
  801860:	89 10                	mov    %edx,(%eax)
  801862:	eb 0a                	jmp    80186e <initialize_dyn_block_system+0x14c>
  801864:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801867:	8b 00                	mov    (%eax),%eax
  801869:	a3 48 51 80 00       	mov    %eax,0x805148
  80186e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801871:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801877:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80187a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801881:	a1 54 51 80 00       	mov    0x805154,%eax
  801886:	48                   	dec    %eax
  801887:	a3 54 51 80 00       	mov    %eax,0x805154
	LIST_INSERT_HEAD(&FreeMemBlocksList, NewBlock);
  80188c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801890:	75 14                	jne    8018a6 <initialize_dyn_block_system+0x184>
  801892:	83 ec 04             	sub    $0x4,%esp
  801895:	68 20 44 80 00       	push   $0x804420
  80189a:	6a 34                	push   $0x34
  80189c:	68 13 44 80 00       	push   $0x804413
  8018a1:	e8 0d ee ff ff       	call   8006b3 <_panic>
  8018a6:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8018ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018af:	89 10                	mov    %edx,(%eax)
  8018b1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018b4:	8b 00                	mov    (%eax),%eax
  8018b6:	85 c0                	test   %eax,%eax
  8018b8:	74 0d                	je     8018c7 <initialize_dyn_block_system+0x1a5>
  8018ba:	a1 38 51 80 00       	mov    0x805138,%eax
  8018bf:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8018c2:	89 50 04             	mov    %edx,0x4(%eax)
  8018c5:	eb 08                	jmp    8018cf <initialize_dyn_block_system+0x1ad>
  8018c7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018ca:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8018cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018d2:	a3 38 51 80 00       	mov    %eax,0x805138
  8018d7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018da:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8018e1:	a1 44 51 80 00       	mov    0x805144,%eax
  8018e6:	40                   	inc    %eax
  8018e7:	a3 44 51 80 00       	mov    %eax,0x805144
}
  8018ec:	90                   	nop
  8018ed:	c9                   	leave  
  8018ee:	c3                   	ret    

008018ef <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8018ef:	55                   	push   %ebp
  8018f0:	89 e5                	mov    %esp,%ebp
  8018f2:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8018f5:	e8 f7 fd ff ff       	call   8016f1 <InitializeUHeap>
	if (size == 0) return NULL ;
  8018fa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8018fe:	75 07                	jne    801907 <malloc+0x18>
  801900:	b8 00 00 00 00       	mov    $0x0,%eax
  801905:	eb 61                	jmp    801968 <malloc+0x79>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
	uint32 malloc_allocsize=ROUNDUP(size,PAGE_SIZE);
  801907:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80190e:	8b 55 08             	mov    0x8(%ebp),%edx
  801911:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801914:	01 d0                	add    %edx,%eax
  801916:	48                   	dec    %eax
  801917:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80191a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80191d:	ba 00 00 00 00       	mov    $0x0,%edx
  801922:	f7 75 f0             	divl   -0x10(%ebp)
  801925:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801928:	29 d0                	sub    %edx,%eax
  80192a:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 //int ret=0;
	struct MemBlock * user_block;
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  80192d:	e8 e3 06 00 00       	call   802015 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801932:	85 c0                	test   %eax,%eax
  801934:	74 11                	je     801947 <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  801936:	83 ec 0c             	sub    $0xc,%esp
  801939:	ff 75 e8             	pushl  -0x18(%ebp)
  80193c:	e8 4e 0d 00 00       	call   80268f <alloc_block_FF>
  801941:	83 c4 10             	add    $0x10,%esp
  801944:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(user_block!=NULL)
  801947:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80194b:	74 16                	je     801963 <malloc+0x74>
	{
		//sys_allocate_chunk(user_block->sva,malloc_allocsize,PERM_WRITEABLE| PERM_PRESENT);
		insert_sorted_allocList(user_block);
  80194d:	83 ec 0c             	sub    $0xc,%esp
  801950:	ff 75 f4             	pushl  -0xc(%ebp)
  801953:	e8 aa 0a 00 00       	call   802402 <insert_sorted_allocList>
  801958:	83 c4 10             	add    $0x10,%esp
		return (uint32 *)user_block->sva;
  80195b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80195e:	8b 40 08             	mov    0x8(%eax),%eax
  801961:	eb 05                	jmp    801968 <malloc+0x79>
	}

    return NULL;
  801963:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801968:	c9                   	leave  
  801969:	c3                   	ret    

0080196a <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  80196a:	55                   	push   %ebp
  80196b:	89 e5                	mov    %esp,%ebp
  80196d:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801970:	83 ec 04             	sub    $0x4,%esp
  801973:	68 44 44 80 00       	push   $0x804444
  801978:	6a 6f                	push   $0x6f
  80197a:	68 13 44 80 00       	push   $0x804413
  80197f:	e8 2f ed ff ff       	call   8006b3 <_panic>

00801984 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801984:	55                   	push   %ebp
  801985:	89 e5                	mov    %esp,%ebp
  801987:	83 ec 38             	sub    $0x38,%esp
  80198a:	8b 45 10             	mov    0x10(%ebp),%eax
  80198d:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801990:	e8 5c fd ff ff       	call   8016f1 <InitializeUHeap>
	if (size == 0) return NULL ;
  801995:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801999:	75 07                	jne    8019a2 <smalloc+0x1e>
  80199b:	b8 00 00 00 00       	mov    $0x0,%eax
  8019a0:	eb 7c                	jmp    801a1e <smalloc+0x9a>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  8019a2:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8019a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019af:	01 d0                	add    %edx,%eax
  8019b1:	48                   	dec    %eax
  8019b2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8019b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019b8:	ba 00 00 00 00       	mov    $0x0,%edx
  8019bd:	f7 75 f0             	divl   -0x10(%ebp)
  8019c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019c3:	29 d0                	sub    %edx,%eax
  8019c5:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  8019c8:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  8019cf:	e8 41 06 00 00       	call   802015 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8019d4:	85 c0                	test   %eax,%eax
  8019d6:	74 11                	je     8019e9 <smalloc+0x65>
		mem_block = alloc_block_FF(allocate_space);
  8019d8:	83 ec 0c             	sub    $0xc,%esp
  8019db:	ff 75 e8             	pushl  -0x18(%ebp)
  8019de:	e8 ac 0c 00 00       	call   80268f <alloc_block_FF>
  8019e3:	83 c4 10             	add    $0x10,%esp
  8019e6:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  8019e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8019ed:	74 2a                	je     801a19 <smalloc+0x95>
	{
		virtual_address = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  8019ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019f2:	8b 40 08             	mov    0x8(%eax),%eax
  8019f5:	89 c2                	mov    %eax,%edx
  8019f7:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8019fb:	52                   	push   %edx
  8019fc:	50                   	push   %eax
  8019fd:	ff 75 0c             	pushl  0xc(%ebp)
  801a00:	ff 75 08             	pushl  0x8(%ebp)
  801a03:	e8 92 03 00 00       	call   801d9a <sys_createSharedObject>
  801a08:	83 c4 10             	add    $0x10,%esp
  801a0b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (virtual_address != -1)
  801a0e:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  801a12:	74 05                	je     801a19 <smalloc+0x95>
			return (void*)virtual_address;
  801a14:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a17:	eb 05                	jmp    801a1e <smalloc+0x9a>
	}
	return NULL;
  801a19:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801a1e:	c9                   	leave  
  801a1f:	c3                   	ret    

00801a20 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801a20:	55                   	push   %ebp
  801a21:	89 e5                	mov    %esp,%ebp
  801a23:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801a26:	e8 c6 fc ff ff       	call   8016f1 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801a2b:	83 ec 04             	sub    $0x4,%esp
  801a2e:	68 68 44 80 00       	push   $0x804468
  801a33:	68 b0 00 00 00       	push   $0xb0
  801a38:	68 13 44 80 00       	push   $0x804413
  801a3d:	e8 71 ec ff ff       	call   8006b3 <_panic>

00801a42 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801a42:	55                   	push   %ebp
  801a43:	89 e5                	mov    %esp,%ebp
  801a45:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801a48:	e8 a4 fc ff ff       	call   8016f1 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801a4d:	83 ec 04             	sub    $0x4,%esp
  801a50:	68 8c 44 80 00       	push   $0x80448c
  801a55:	68 f4 00 00 00       	push   $0xf4
  801a5a:	68 13 44 80 00       	push   $0x804413
  801a5f:	e8 4f ec ff ff       	call   8006b3 <_panic>

00801a64 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801a64:	55                   	push   %ebp
  801a65:	89 e5                	mov    %esp,%ebp
  801a67:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801a6a:	83 ec 04             	sub    $0x4,%esp
  801a6d:	68 b4 44 80 00       	push   $0x8044b4
  801a72:	68 08 01 00 00       	push   $0x108
  801a77:	68 13 44 80 00       	push   $0x804413
  801a7c:	e8 32 ec ff ff       	call   8006b3 <_panic>

00801a81 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801a81:	55                   	push   %ebp
  801a82:	89 e5                	mov    %esp,%ebp
  801a84:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a87:	83 ec 04             	sub    $0x4,%esp
  801a8a:	68 d8 44 80 00       	push   $0x8044d8
  801a8f:	68 13 01 00 00       	push   $0x113
  801a94:	68 13 44 80 00       	push   $0x804413
  801a99:	e8 15 ec ff ff       	call   8006b3 <_panic>

00801a9e <shrink>:

}
void shrink(uint32 newSize)
{
  801a9e:	55                   	push   %ebp
  801a9f:	89 e5                	mov    %esp,%ebp
  801aa1:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801aa4:	83 ec 04             	sub    $0x4,%esp
  801aa7:	68 d8 44 80 00       	push   $0x8044d8
  801aac:	68 18 01 00 00       	push   $0x118
  801ab1:	68 13 44 80 00       	push   $0x804413
  801ab6:	e8 f8 eb ff ff       	call   8006b3 <_panic>

00801abb <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801abb:	55                   	push   %ebp
  801abc:	89 e5                	mov    %esp,%ebp
  801abe:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ac1:	83 ec 04             	sub    $0x4,%esp
  801ac4:	68 d8 44 80 00       	push   $0x8044d8
  801ac9:	68 1d 01 00 00       	push   $0x11d
  801ace:	68 13 44 80 00       	push   $0x804413
  801ad3:	e8 db eb ff ff       	call   8006b3 <_panic>

00801ad8 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801ad8:	55                   	push   %ebp
  801ad9:	89 e5                	mov    %esp,%ebp
  801adb:	57                   	push   %edi
  801adc:	56                   	push   %esi
  801add:	53                   	push   %ebx
  801ade:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801ae1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ae7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801aea:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801aed:	8b 7d 18             	mov    0x18(%ebp),%edi
  801af0:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801af3:	cd 30                	int    $0x30
  801af5:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801af8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801afb:	83 c4 10             	add    $0x10,%esp
  801afe:	5b                   	pop    %ebx
  801aff:	5e                   	pop    %esi
  801b00:	5f                   	pop    %edi
  801b01:	5d                   	pop    %ebp
  801b02:	c3                   	ret    

00801b03 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801b03:	55                   	push   %ebp
  801b04:	89 e5                	mov    %esp,%ebp
  801b06:	83 ec 04             	sub    $0x4,%esp
  801b09:	8b 45 10             	mov    0x10(%ebp),%eax
  801b0c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801b0f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b13:	8b 45 08             	mov    0x8(%ebp),%eax
  801b16:	6a 00                	push   $0x0
  801b18:	6a 00                	push   $0x0
  801b1a:	52                   	push   %edx
  801b1b:	ff 75 0c             	pushl  0xc(%ebp)
  801b1e:	50                   	push   %eax
  801b1f:	6a 00                	push   $0x0
  801b21:	e8 b2 ff ff ff       	call   801ad8 <syscall>
  801b26:	83 c4 18             	add    $0x18,%esp
}
  801b29:	90                   	nop
  801b2a:	c9                   	leave  
  801b2b:	c3                   	ret    

00801b2c <sys_cgetc>:

int
sys_cgetc(void)
{
  801b2c:	55                   	push   %ebp
  801b2d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801b2f:	6a 00                	push   $0x0
  801b31:	6a 00                	push   $0x0
  801b33:	6a 00                	push   $0x0
  801b35:	6a 00                	push   $0x0
  801b37:	6a 00                	push   $0x0
  801b39:	6a 01                	push   $0x1
  801b3b:	e8 98 ff ff ff       	call   801ad8 <syscall>
  801b40:	83 c4 18             	add    $0x18,%esp
}
  801b43:	c9                   	leave  
  801b44:	c3                   	ret    

00801b45 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801b45:	55                   	push   %ebp
  801b46:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801b48:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4e:	6a 00                	push   $0x0
  801b50:	6a 00                	push   $0x0
  801b52:	6a 00                	push   $0x0
  801b54:	52                   	push   %edx
  801b55:	50                   	push   %eax
  801b56:	6a 05                	push   $0x5
  801b58:	e8 7b ff ff ff       	call   801ad8 <syscall>
  801b5d:	83 c4 18             	add    $0x18,%esp
}
  801b60:	c9                   	leave  
  801b61:	c3                   	ret    

00801b62 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801b62:	55                   	push   %ebp
  801b63:	89 e5                	mov    %esp,%ebp
  801b65:	56                   	push   %esi
  801b66:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801b67:	8b 75 18             	mov    0x18(%ebp),%esi
  801b6a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b6d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b70:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b73:	8b 45 08             	mov    0x8(%ebp),%eax
  801b76:	56                   	push   %esi
  801b77:	53                   	push   %ebx
  801b78:	51                   	push   %ecx
  801b79:	52                   	push   %edx
  801b7a:	50                   	push   %eax
  801b7b:	6a 06                	push   $0x6
  801b7d:	e8 56 ff ff ff       	call   801ad8 <syscall>
  801b82:	83 c4 18             	add    $0x18,%esp
}
  801b85:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b88:	5b                   	pop    %ebx
  801b89:	5e                   	pop    %esi
  801b8a:	5d                   	pop    %ebp
  801b8b:	c3                   	ret    

00801b8c <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801b8c:	55                   	push   %ebp
  801b8d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801b8f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b92:	8b 45 08             	mov    0x8(%ebp),%eax
  801b95:	6a 00                	push   $0x0
  801b97:	6a 00                	push   $0x0
  801b99:	6a 00                	push   $0x0
  801b9b:	52                   	push   %edx
  801b9c:	50                   	push   %eax
  801b9d:	6a 07                	push   $0x7
  801b9f:	e8 34 ff ff ff       	call   801ad8 <syscall>
  801ba4:	83 c4 18             	add    $0x18,%esp
}
  801ba7:	c9                   	leave  
  801ba8:	c3                   	ret    

00801ba9 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801ba9:	55                   	push   %ebp
  801baa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801bac:	6a 00                	push   $0x0
  801bae:	6a 00                	push   $0x0
  801bb0:	6a 00                	push   $0x0
  801bb2:	ff 75 0c             	pushl  0xc(%ebp)
  801bb5:	ff 75 08             	pushl  0x8(%ebp)
  801bb8:	6a 08                	push   $0x8
  801bba:	e8 19 ff ff ff       	call   801ad8 <syscall>
  801bbf:	83 c4 18             	add    $0x18,%esp
}
  801bc2:	c9                   	leave  
  801bc3:	c3                   	ret    

00801bc4 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801bc4:	55                   	push   %ebp
  801bc5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801bc7:	6a 00                	push   $0x0
  801bc9:	6a 00                	push   $0x0
  801bcb:	6a 00                	push   $0x0
  801bcd:	6a 00                	push   $0x0
  801bcf:	6a 00                	push   $0x0
  801bd1:	6a 09                	push   $0x9
  801bd3:	e8 00 ff ff ff       	call   801ad8 <syscall>
  801bd8:	83 c4 18             	add    $0x18,%esp
}
  801bdb:	c9                   	leave  
  801bdc:	c3                   	ret    

00801bdd <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801bdd:	55                   	push   %ebp
  801bde:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801be0:	6a 00                	push   $0x0
  801be2:	6a 00                	push   $0x0
  801be4:	6a 00                	push   $0x0
  801be6:	6a 00                	push   $0x0
  801be8:	6a 00                	push   $0x0
  801bea:	6a 0a                	push   $0xa
  801bec:	e8 e7 fe ff ff       	call   801ad8 <syscall>
  801bf1:	83 c4 18             	add    $0x18,%esp
}
  801bf4:	c9                   	leave  
  801bf5:	c3                   	ret    

00801bf6 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801bf6:	55                   	push   %ebp
  801bf7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801bf9:	6a 00                	push   $0x0
  801bfb:	6a 00                	push   $0x0
  801bfd:	6a 00                	push   $0x0
  801bff:	6a 00                	push   $0x0
  801c01:	6a 00                	push   $0x0
  801c03:	6a 0b                	push   $0xb
  801c05:	e8 ce fe ff ff       	call   801ad8 <syscall>
  801c0a:	83 c4 18             	add    $0x18,%esp
}
  801c0d:	c9                   	leave  
  801c0e:	c3                   	ret    

00801c0f <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801c0f:	55                   	push   %ebp
  801c10:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801c12:	6a 00                	push   $0x0
  801c14:	6a 00                	push   $0x0
  801c16:	6a 00                	push   $0x0
  801c18:	ff 75 0c             	pushl  0xc(%ebp)
  801c1b:	ff 75 08             	pushl  0x8(%ebp)
  801c1e:	6a 0f                	push   $0xf
  801c20:	e8 b3 fe ff ff       	call   801ad8 <syscall>
  801c25:	83 c4 18             	add    $0x18,%esp
	return;
  801c28:	90                   	nop
}
  801c29:	c9                   	leave  
  801c2a:	c3                   	ret    

00801c2b <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801c2b:	55                   	push   %ebp
  801c2c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801c2e:	6a 00                	push   $0x0
  801c30:	6a 00                	push   $0x0
  801c32:	6a 00                	push   $0x0
  801c34:	ff 75 0c             	pushl  0xc(%ebp)
  801c37:	ff 75 08             	pushl  0x8(%ebp)
  801c3a:	6a 10                	push   $0x10
  801c3c:	e8 97 fe ff ff       	call   801ad8 <syscall>
  801c41:	83 c4 18             	add    $0x18,%esp
	return ;
  801c44:	90                   	nop
}
  801c45:	c9                   	leave  
  801c46:	c3                   	ret    

00801c47 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801c47:	55                   	push   %ebp
  801c48:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801c4a:	6a 00                	push   $0x0
  801c4c:	6a 00                	push   $0x0
  801c4e:	ff 75 10             	pushl  0x10(%ebp)
  801c51:	ff 75 0c             	pushl  0xc(%ebp)
  801c54:	ff 75 08             	pushl  0x8(%ebp)
  801c57:	6a 11                	push   $0x11
  801c59:	e8 7a fe ff ff       	call   801ad8 <syscall>
  801c5e:	83 c4 18             	add    $0x18,%esp
	return ;
  801c61:	90                   	nop
}
  801c62:	c9                   	leave  
  801c63:	c3                   	ret    

00801c64 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801c64:	55                   	push   %ebp
  801c65:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801c67:	6a 00                	push   $0x0
  801c69:	6a 00                	push   $0x0
  801c6b:	6a 00                	push   $0x0
  801c6d:	6a 00                	push   $0x0
  801c6f:	6a 00                	push   $0x0
  801c71:	6a 0c                	push   $0xc
  801c73:	e8 60 fe ff ff       	call   801ad8 <syscall>
  801c78:	83 c4 18             	add    $0x18,%esp
}
  801c7b:	c9                   	leave  
  801c7c:	c3                   	ret    

00801c7d <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801c7d:	55                   	push   %ebp
  801c7e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801c80:	6a 00                	push   $0x0
  801c82:	6a 00                	push   $0x0
  801c84:	6a 00                	push   $0x0
  801c86:	6a 00                	push   $0x0
  801c88:	ff 75 08             	pushl  0x8(%ebp)
  801c8b:	6a 0d                	push   $0xd
  801c8d:	e8 46 fe ff ff       	call   801ad8 <syscall>
  801c92:	83 c4 18             	add    $0x18,%esp
}
  801c95:	c9                   	leave  
  801c96:	c3                   	ret    

00801c97 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801c97:	55                   	push   %ebp
  801c98:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801c9a:	6a 00                	push   $0x0
  801c9c:	6a 00                	push   $0x0
  801c9e:	6a 00                	push   $0x0
  801ca0:	6a 00                	push   $0x0
  801ca2:	6a 00                	push   $0x0
  801ca4:	6a 0e                	push   $0xe
  801ca6:	e8 2d fe ff ff       	call   801ad8 <syscall>
  801cab:	83 c4 18             	add    $0x18,%esp
}
  801cae:	90                   	nop
  801caf:	c9                   	leave  
  801cb0:	c3                   	ret    

00801cb1 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801cb1:	55                   	push   %ebp
  801cb2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801cb4:	6a 00                	push   $0x0
  801cb6:	6a 00                	push   $0x0
  801cb8:	6a 00                	push   $0x0
  801cba:	6a 00                	push   $0x0
  801cbc:	6a 00                	push   $0x0
  801cbe:	6a 13                	push   $0x13
  801cc0:	e8 13 fe ff ff       	call   801ad8 <syscall>
  801cc5:	83 c4 18             	add    $0x18,%esp
}
  801cc8:	90                   	nop
  801cc9:	c9                   	leave  
  801cca:	c3                   	ret    

00801ccb <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801ccb:	55                   	push   %ebp
  801ccc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801cce:	6a 00                	push   $0x0
  801cd0:	6a 00                	push   $0x0
  801cd2:	6a 00                	push   $0x0
  801cd4:	6a 00                	push   $0x0
  801cd6:	6a 00                	push   $0x0
  801cd8:	6a 14                	push   $0x14
  801cda:	e8 f9 fd ff ff       	call   801ad8 <syscall>
  801cdf:	83 c4 18             	add    $0x18,%esp
}
  801ce2:	90                   	nop
  801ce3:	c9                   	leave  
  801ce4:	c3                   	ret    

00801ce5 <sys_cputc>:


void
sys_cputc(const char c)
{
  801ce5:	55                   	push   %ebp
  801ce6:	89 e5                	mov    %esp,%ebp
  801ce8:	83 ec 04             	sub    $0x4,%esp
  801ceb:	8b 45 08             	mov    0x8(%ebp),%eax
  801cee:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801cf1:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801cf5:	6a 00                	push   $0x0
  801cf7:	6a 00                	push   $0x0
  801cf9:	6a 00                	push   $0x0
  801cfb:	6a 00                	push   $0x0
  801cfd:	50                   	push   %eax
  801cfe:	6a 15                	push   $0x15
  801d00:	e8 d3 fd ff ff       	call   801ad8 <syscall>
  801d05:	83 c4 18             	add    $0x18,%esp
}
  801d08:	90                   	nop
  801d09:	c9                   	leave  
  801d0a:	c3                   	ret    

00801d0b <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801d0b:	55                   	push   %ebp
  801d0c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801d0e:	6a 00                	push   $0x0
  801d10:	6a 00                	push   $0x0
  801d12:	6a 00                	push   $0x0
  801d14:	6a 00                	push   $0x0
  801d16:	6a 00                	push   $0x0
  801d18:	6a 16                	push   $0x16
  801d1a:	e8 b9 fd ff ff       	call   801ad8 <syscall>
  801d1f:	83 c4 18             	add    $0x18,%esp
}
  801d22:	90                   	nop
  801d23:	c9                   	leave  
  801d24:	c3                   	ret    

00801d25 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801d25:	55                   	push   %ebp
  801d26:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801d28:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2b:	6a 00                	push   $0x0
  801d2d:	6a 00                	push   $0x0
  801d2f:	6a 00                	push   $0x0
  801d31:	ff 75 0c             	pushl  0xc(%ebp)
  801d34:	50                   	push   %eax
  801d35:	6a 17                	push   $0x17
  801d37:	e8 9c fd ff ff       	call   801ad8 <syscall>
  801d3c:	83 c4 18             	add    $0x18,%esp
}
  801d3f:	c9                   	leave  
  801d40:	c3                   	ret    

00801d41 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801d41:	55                   	push   %ebp
  801d42:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d44:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d47:	8b 45 08             	mov    0x8(%ebp),%eax
  801d4a:	6a 00                	push   $0x0
  801d4c:	6a 00                	push   $0x0
  801d4e:	6a 00                	push   $0x0
  801d50:	52                   	push   %edx
  801d51:	50                   	push   %eax
  801d52:	6a 1a                	push   $0x1a
  801d54:	e8 7f fd ff ff       	call   801ad8 <syscall>
  801d59:	83 c4 18             	add    $0x18,%esp
}
  801d5c:	c9                   	leave  
  801d5d:	c3                   	ret    

00801d5e <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801d5e:	55                   	push   %ebp
  801d5f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d61:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d64:	8b 45 08             	mov    0x8(%ebp),%eax
  801d67:	6a 00                	push   $0x0
  801d69:	6a 00                	push   $0x0
  801d6b:	6a 00                	push   $0x0
  801d6d:	52                   	push   %edx
  801d6e:	50                   	push   %eax
  801d6f:	6a 18                	push   $0x18
  801d71:	e8 62 fd ff ff       	call   801ad8 <syscall>
  801d76:	83 c4 18             	add    $0x18,%esp
}
  801d79:	90                   	nop
  801d7a:	c9                   	leave  
  801d7b:	c3                   	ret    

00801d7c <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801d7c:	55                   	push   %ebp
  801d7d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d7f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d82:	8b 45 08             	mov    0x8(%ebp),%eax
  801d85:	6a 00                	push   $0x0
  801d87:	6a 00                	push   $0x0
  801d89:	6a 00                	push   $0x0
  801d8b:	52                   	push   %edx
  801d8c:	50                   	push   %eax
  801d8d:	6a 19                	push   $0x19
  801d8f:	e8 44 fd ff ff       	call   801ad8 <syscall>
  801d94:	83 c4 18             	add    $0x18,%esp
}
  801d97:	90                   	nop
  801d98:	c9                   	leave  
  801d99:	c3                   	ret    

00801d9a <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801d9a:	55                   	push   %ebp
  801d9b:	89 e5                	mov    %esp,%ebp
  801d9d:	83 ec 04             	sub    $0x4,%esp
  801da0:	8b 45 10             	mov    0x10(%ebp),%eax
  801da3:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801da6:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801da9:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801dad:	8b 45 08             	mov    0x8(%ebp),%eax
  801db0:	6a 00                	push   $0x0
  801db2:	51                   	push   %ecx
  801db3:	52                   	push   %edx
  801db4:	ff 75 0c             	pushl  0xc(%ebp)
  801db7:	50                   	push   %eax
  801db8:	6a 1b                	push   $0x1b
  801dba:	e8 19 fd ff ff       	call   801ad8 <syscall>
  801dbf:	83 c4 18             	add    $0x18,%esp
}
  801dc2:	c9                   	leave  
  801dc3:	c3                   	ret    

00801dc4 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801dc4:	55                   	push   %ebp
  801dc5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801dc7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dca:	8b 45 08             	mov    0x8(%ebp),%eax
  801dcd:	6a 00                	push   $0x0
  801dcf:	6a 00                	push   $0x0
  801dd1:	6a 00                	push   $0x0
  801dd3:	52                   	push   %edx
  801dd4:	50                   	push   %eax
  801dd5:	6a 1c                	push   $0x1c
  801dd7:	e8 fc fc ff ff       	call   801ad8 <syscall>
  801ddc:	83 c4 18             	add    $0x18,%esp
}
  801ddf:	c9                   	leave  
  801de0:	c3                   	ret    

00801de1 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801de1:	55                   	push   %ebp
  801de2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801de4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801de7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dea:	8b 45 08             	mov    0x8(%ebp),%eax
  801ded:	6a 00                	push   $0x0
  801def:	6a 00                	push   $0x0
  801df1:	51                   	push   %ecx
  801df2:	52                   	push   %edx
  801df3:	50                   	push   %eax
  801df4:	6a 1d                	push   $0x1d
  801df6:	e8 dd fc ff ff       	call   801ad8 <syscall>
  801dfb:	83 c4 18             	add    $0x18,%esp
}
  801dfe:	c9                   	leave  
  801dff:	c3                   	ret    

00801e00 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801e00:	55                   	push   %ebp
  801e01:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801e03:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e06:	8b 45 08             	mov    0x8(%ebp),%eax
  801e09:	6a 00                	push   $0x0
  801e0b:	6a 00                	push   $0x0
  801e0d:	6a 00                	push   $0x0
  801e0f:	52                   	push   %edx
  801e10:	50                   	push   %eax
  801e11:	6a 1e                	push   $0x1e
  801e13:	e8 c0 fc ff ff       	call   801ad8 <syscall>
  801e18:	83 c4 18             	add    $0x18,%esp
}
  801e1b:	c9                   	leave  
  801e1c:	c3                   	ret    

00801e1d <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801e1d:	55                   	push   %ebp
  801e1e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801e20:	6a 00                	push   $0x0
  801e22:	6a 00                	push   $0x0
  801e24:	6a 00                	push   $0x0
  801e26:	6a 00                	push   $0x0
  801e28:	6a 00                	push   $0x0
  801e2a:	6a 1f                	push   $0x1f
  801e2c:	e8 a7 fc ff ff       	call   801ad8 <syscall>
  801e31:	83 c4 18             	add    $0x18,%esp
}
  801e34:	c9                   	leave  
  801e35:	c3                   	ret    

00801e36 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801e36:	55                   	push   %ebp
  801e37:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801e39:	8b 45 08             	mov    0x8(%ebp),%eax
  801e3c:	6a 00                	push   $0x0
  801e3e:	ff 75 14             	pushl  0x14(%ebp)
  801e41:	ff 75 10             	pushl  0x10(%ebp)
  801e44:	ff 75 0c             	pushl  0xc(%ebp)
  801e47:	50                   	push   %eax
  801e48:	6a 20                	push   $0x20
  801e4a:	e8 89 fc ff ff       	call   801ad8 <syscall>
  801e4f:	83 c4 18             	add    $0x18,%esp
}
  801e52:	c9                   	leave  
  801e53:	c3                   	ret    

00801e54 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801e54:	55                   	push   %ebp
  801e55:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801e57:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5a:	6a 00                	push   $0x0
  801e5c:	6a 00                	push   $0x0
  801e5e:	6a 00                	push   $0x0
  801e60:	6a 00                	push   $0x0
  801e62:	50                   	push   %eax
  801e63:	6a 21                	push   $0x21
  801e65:	e8 6e fc ff ff       	call   801ad8 <syscall>
  801e6a:	83 c4 18             	add    $0x18,%esp
}
  801e6d:	90                   	nop
  801e6e:	c9                   	leave  
  801e6f:	c3                   	ret    

00801e70 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801e70:	55                   	push   %ebp
  801e71:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801e73:	8b 45 08             	mov    0x8(%ebp),%eax
  801e76:	6a 00                	push   $0x0
  801e78:	6a 00                	push   $0x0
  801e7a:	6a 00                	push   $0x0
  801e7c:	6a 00                	push   $0x0
  801e7e:	50                   	push   %eax
  801e7f:	6a 22                	push   $0x22
  801e81:	e8 52 fc ff ff       	call   801ad8 <syscall>
  801e86:	83 c4 18             	add    $0x18,%esp
}
  801e89:	c9                   	leave  
  801e8a:	c3                   	ret    

00801e8b <sys_getenvid>:

int32 sys_getenvid(void)
{
  801e8b:	55                   	push   %ebp
  801e8c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801e8e:	6a 00                	push   $0x0
  801e90:	6a 00                	push   $0x0
  801e92:	6a 00                	push   $0x0
  801e94:	6a 00                	push   $0x0
  801e96:	6a 00                	push   $0x0
  801e98:	6a 02                	push   $0x2
  801e9a:	e8 39 fc ff ff       	call   801ad8 <syscall>
  801e9f:	83 c4 18             	add    $0x18,%esp
}
  801ea2:	c9                   	leave  
  801ea3:	c3                   	ret    

00801ea4 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801ea4:	55                   	push   %ebp
  801ea5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801ea7:	6a 00                	push   $0x0
  801ea9:	6a 00                	push   $0x0
  801eab:	6a 00                	push   $0x0
  801ead:	6a 00                	push   $0x0
  801eaf:	6a 00                	push   $0x0
  801eb1:	6a 03                	push   $0x3
  801eb3:	e8 20 fc ff ff       	call   801ad8 <syscall>
  801eb8:	83 c4 18             	add    $0x18,%esp
}
  801ebb:	c9                   	leave  
  801ebc:	c3                   	ret    

00801ebd <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801ebd:	55                   	push   %ebp
  801ebe:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801ec0:	6a 00                	push   $0x0
  801ec2:	6a 00                	push   $0x0
  801ec4:	6a 00                	push   $0x0
  801ec6:	6a 00                	push   $0x0
  801ec8:	6a 00                	push   $0x0
  801eca:	6a 04                	push   $0x4
  801ecc:	e8 07 fc ff ff       	call   801ad8 <syscall>
  801ed1:	83 c4 18             	add    $0x18,%esp
}
  801ed4:	c9                   	leave  
  801ed5:	c3                   	ret    

00801ed6 <sys_exit_env>:


void sys_exit_env(void)
{
  801ed6:	55                   	push   %ebp
  801ed7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801ed9:	6a 00                	push   $0x0
  801edb:	6a 00                	push   $0x0
  801edd:	6a 00                	push   $0x0
  801edf:	6a 00                	push   $0x0
  801ee1:	6a 00                	push   $0x0
  801ee3:	6a 23                	push   $0x23
  801ee5:	e8 ee fb ff ff       	call   801ad8 <syscall>
  801eea:	83 c4 18             	add    $0x18,%esp
}
  801eed:	90                   	nop
  801eee:	c9                   	leave  
  801eef:	c3                   	ret    

00801ef0 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801ef0:	55                   	push   %ebp
  801ef1:	89 e5                	mov    %esp,%ebp
  801ef3:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801ef6:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ef9:	8d 50 04             	lea    0x4(%eax),%edx
  801efc:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801eff:	6a 00                	push   $0x0
  801f01:	6a 00                	push   $0x0
  801f03:	6a 00                	push   $0x0
  801f05:	52                   	push   %edx
  801f06:	50                   	push   %eax
  801f07:	6a 24                	push   $0x24
  801f09:	e8 ca fb ff ff       	call   801ad8 <syscall>
  801f0e:	83 c4 18             	add    $0x18,%esp
	return result;
  801f11:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f14:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801f17:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801f1a:	89 01                	mov    %eax,(%ecx)
  801f1c:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801f1f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f22:	c9                   	leave  
  801f23:	c2 04 00             	ret    $0x4

00801f26 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801f26:	55                   	push   %ebp
  801f27:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801f29:	6a 00                	push   $0x0
  801f2b:	6a 00                	push   $0x0
  801f2d:	ff 75 10             	pushl  0x10(%ebp)
  801f30:	ff 75 0c             	pushl  0xc(%ebp)
  801f33:	ff 75 08             	pushl  0x8(%ebp)
  801f36:	6a 12                	push   $0x12
  801f38:	e8 9b fb ff ff       	call   801ad8 <syscall>
  801f3d:	83 c4 18             	add    $0x18,%esp
	return ;
  801f40:	90                   	nop
}
  801f41:	c9                   	leave  
  801f42:	c3                   	ret    

00801f43 <sys_rcr2>:
uint32 sys_rcr2()
{
  801f43:	55                   	push   %ebp
  801f44:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801f46:	6a 00                	push   $0x0
  801f48:	6a 00                	push   $0x0
  801f4a:	6a 00                	push   $0x0
  801f4c:	6a 00                	push   $0x0
  801f4e:	6a 00                	push   $0x0
  801f50:	6a 25                	push   $0x25
  801f52:	e8 81 fb ff ff       	call   801ad8 <syscall>
  801f57:	83 c4 18             	add    $0x18,%esp
}
  801f5a:	c9                   	leave  
  801f5b:	c3                   	ret    

00801f5c <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801f5c:	55                   	push   %ebp
  801f5d:	89 e5                	mov    %esp,%ebp
  801f5f:	83 ec 04             	sub    $0x4,%esp
  801f62:	8b 45 08             	mov    0x8(%ebp),%eax
  801f65:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801f68:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801f6c:	6a 00                	push   $0x0
  801f6e:	6a 00                	push   $0x0
  801f70:	6a 00                	push   $0x0
  801f72:	6a 00                	push   $0x0
  801f74:	50                   	push   %eax
  801f75:	6a 26                	push   $0x26
  801f77:	e8 5c fb ff ff       	call   801ad8 <syscall>
  801f7c:	83 c4 18             	add    $0x18,%esp
	return ;
  801f7f:	90                   	nop
}
  801f80:	c9                   	leave  
  801f81:	c3                   	ret    

00801f82 <rsttst>:
void rsttst()
{
  801f82:	55                   	push   %ebp
  801f83:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801f85:	6a 00                	push   $0x0
  801f87:	6a 00                	push   $0x0
  801f89:	6a 00                	push   $0x0
  801f8b:	6a 00                	push   $0x0
  801f8d:	6a 00                	push   $0x0
  801f8f:	6a 28                	push   $0x28
  801f91:	e8 42 fb ff ff       	call   801ad8 <syscall>
  801f96:	83 c4 18             	add    $0x18,%esp
	return ;
  801f99:	90                   	nop
}
  801f9a:	c9                   	leave  
  801f9b:	c3                   	ret    

00801f9c <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801f9c:	55                   	push   %ebp
  801f9d:	89 e5                	mov    %esp,%ebp
  801f9f:	83 ec 04             	sub    $0x4,%esp
  801fa2:	8b 45 14             	mov    0x14(%ebp),%eax
  801fa5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801fa8:	8b 55 18             	mov    0x18(%ebp),%edx
  801fab:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801faf:	52                   	push   %edx
  801fb0:	50                   	push   %eax
  801fb1:	ff 75 10             	pushl  0x10(%ebp)
  801fb4:	ff 75 0c             	pushl  0xc(%ebp)
  801fb7:	ff 75 08             	pushl  0x8(%ebp)
  801fba:	6a 27                	push   $0x27
  801fbc:	e8 17 fb ff ff       	call   801ad8 <syscall>
  801fc1:	83 c4 18             	add    $0x18,%esp
	return ;
  801fc4:	90                   	nop
}
  801fc5:	c9                   	leave  
  801fc6:	c3                   	ret    

00801fc7 <chktst>:
void chktst(uint32 n)
{
  801fc7:	55                   	push   %ebp
  801fc8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801fca:	6a 00                	push   $0x0
  801fcc:	6a 00                	push   $0x0
  801fce:	6a 00                	push   $0x0
  801fd0:	6a 00                	push   $0x0
  801fd2:	ff 75 08             	pushl  0x8(%ebp)
  801fd5:	6a 29                	push   $0x29
  801fd7:	e8 fc fa ff ff       	call   801ad8 <syscall>
  801fdc:	83 c4 18             	add    $0x18,%esp
	return ;
  801fdf:	90                   	nop
}
  801fe0:	c9                   	leave  
  801fe1:	c3                   	ret    

00801fe2 <inctst>:

void inctst()
{
  801fe2:	55                   	push   %ebp
  801fe3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801fe5:	6a 00                	push   $0x0
  801fe7:	6a 00                	push   $0x0
  801fe9:	6a 00                	push   $0x0
  801feb:	6a 00                	push   $0x0
  801fed:	6a 00                	push   $0x0
  801fef:	6a 2a                	push   $0x2a
  801ff1:	e8 e2 fa ff ff       	call   801ad8 <syscall>
  801ff6:	83 c4 18             	add    $0x18,%esp
	return ;
  801ff9:	90                   	nop
}
  801ffa:	c9                   	leave  
  801ffb:	c3                   	ret    

00801ffc <gettst>:
uint32 gettst()
{
  801ffc:	55                   	push   %ebp
  801ffd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801fff:	6a 00                	push   $0x0
  802001:	6a 00                	push   $0x0
  802003:	6a 00                	push   $0x0
  802005:	6a 00                	push   $0x0
  802007:	6a 00                	push   $0x0
  802009:	6a 2b                	push   $0x2b
  80200b:	e8 c8 fa ff ff       	call   801ad8 <syscall>
  802010:	83 c4 18             	add    $0x18,%esp
}
  802013:	c9                   	leave  
  802014:	c3                   	ret    

00802015 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
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
  802027:	e8 ac fa ff ff       	call   801ad8 <syscall>
  80202c:	83 c4 18             	add    $0x18,%esp
  80202f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802032:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802036:	75 07                	jne    80203f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802038:	b8 01 00 00 00       	mov    $0x1,%eax
  80203d:	eb 05                	jmp    802044 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80203f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802044:	c9                   	leave  
  802045:	c3                   	ret    

00802046 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
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
  802058:	e8 7b fa ff ff       	call   801ad8 <syscall>
  80205d:	83 c4 18             	add    $0x18,%esp
  802060:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802063:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802067:	75 07                	jne    802070 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802069:	b8 01 00 00 00       	mov    $0x1,%eax
  80206e:	eb 05                	jmp    802075 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802070:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802075:	c9                   	leave  
  802076:	c3                   	ret    

00802077 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
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
  802089:	e8 4a fa ff ff       	call   801ad8 <syscall>
  80208e:	83 c4 18             	add    $0x18,%esp
  802091:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802094:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802098:	75 07                	jne    8020a1 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80209a:	b8 01 00 00 00       	mov    $0x1,%eax
  80209f:	eb 05                	jmp    8020a6 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8020a1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020a6:	c9                   	leave  
  8020a7:	c3                   	ret    

008020a8 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8020a8:	55                   	push   %ebp
  8020a9:	89 e5                	mov    %esp,%ebp
  8020ab:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8020ae:	6a 00                	push   $0x0
  8020b0:	6a 00                	push   $0x0
  8020b2:	6a 00                	push   $0x0
  8020b4:	6a 00                	push   $0x0
  8020b6:	6a 00                	push   $0x0
  8020b8:	6a 2c                	push   $0x2c
  8020ba:	e8 19 fa ff ff       	call   801ad8 <syscall>
  8020bf:	83 c4 18             	add    $0x18,%esp
  8020c2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8020c5:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8020c9:	75 07                	jne    8020d2 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8020cb:	b8 01 00 00 00       	mov    $0x1,%eax
  8020d0:	eb 05                	jmp    8020d7 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8020d2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020d7:	c9                   	leave  
  8020d8:	c3                   	ret    

008020d9 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8020d9:	55                   	push   %ebp
  8020da:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8020dc:	6a 00                	push   $0x0
  8020de:	6a 00                	push   $0x0
  8020e0:	6a 00                	push   $0x0
  8020e2:	6a 00                	push   $0x0
  8020e4:	ff 75 08             	pushl  0x8(%ebp)
  8020e7:	6a 2d                	push   $0x2d
  8020e9:	e8 ea f9 ff ff       	call   801ad8 <syscall>
  8020ee:	83 c4 18             	add    $0x18,%esp
	return ;
  8020f1:	90                   	nop
}
  8020f2:	c9                   	leave  
  8020f3:	c3                   	ret    

008020f4 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8020f4:	55                   	push   %ebp
  8020f5:	89 e5                	mov    %esp,%ebp
  8020f7:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8020f8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8020fb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8020fe:	8b 55 0c             	mov    0xc(%ebp),%edx
  802101:	8b 45 08             	mov    0x8(%ebp),%eax
  802104:	6a 00                	push   $0x0
  802106:	53                   	push   %ebx
  802107:	51                   	push   %ecx
  802108:	52                   	push   %edx
  802109:	50                   	push   %eax
  80210a:	6a 2e                	push   $0x2e
  80210c:	e8 c7 f9 ff ff       	call   801ad8 <syscall>
  802111:	83 c4 18             	add    $0x18,%esp
}
  802114:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802117:	c9                   	leave  
  802118:	c3                   	ret    

00802119 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802119:	55                   	push   %ebp
  80211a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80211c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80211f:	8b 45 08             	mov    0x8(%ebp),%eax
  802122:	6a 00                	push   $0x0
  802124:	6a 00                	push   $0x0
  802126:	6a 00                	push   $0x0
  802128:	52                   	push   %edx
  802129:	50                   	push   %eax
  80212a:	6a 2f                	push   $0x2f
  80212c:	e8 a7 f9 ff ff       	call   801ad8 <syscall>
  802131:	83 c4 18             	add    $0x18,%esp
}
  802134:	c9                   	leave  
  802135:	c3                   	ret    

00802136 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802136:	55                   	push   %ebp
  802137:	89 e5                	mov    %esp,%ebp
  802139:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  80213c:	83 ec 0c             	sub    $0xc,%esp
  80213f:	68 e8 44 80 00       	push   $0x8044e8
  802144:	e8 1e e8 ff ff       	call   800967 <cprintf>
  802149:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  80214c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802153:	83 ec 0c             	sub    $0xc,%esp
  802156:	68 14 45 80 00       	push   $0x804514
  80215b:	e8 07 e8 ff ff       	call   800967 <cprintf>
  802160:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802163:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802167:	a1 38 51 80 00       	mov    0x805138,%eax
  80216c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80216f:	eb 56                	jmp    8021c7 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802171:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802175:	74 1c                	je     802193 <print_mem_block_lists+0x5d>
  802177:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80217a:	8b 50 08             	mov    0x8(%eax),%edx
  80217d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802180:	8b 48 08             	mov    0x8(%eax),%ecx
  802183:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802186:	8b 40 0c             	mov    0xc(%eax),%eax
  802189:	01 c8                	add    %ecx,%eax
  80218b:	39 c2                	cmp    %eax,%edx
  80218d:	73 04                	jae    802193 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  80218f:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802193:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802196:	8b 50 08             	mov    0x8(%eax),%edx
  802199:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80219c:	8b 40 0c             	mov    0xc(%eax),%eax
  80219f:	01 c2                	add    %eax,%edx
  8021a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a4:	8b 40 08             	mov    0x8(%eax),%eax
  8021a7:	83 ec 04             	sub    $0x4,%esp
  8021aa:	52                   	push   %edx
  8021ab:	50                   	push   %eax
  8021ac:	68 29 45 80 00       	push   $0x804529
  8021b1:	e8 b1 e7 ff ff       	call   800967 <cprintf>
  8021b6:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8021b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8021bf:	a1 40 51 80 00       	mov    0x805140,%eax
  8021c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021cb:	74 07                	je     8021d4 <print_mem_block_lists+0x9e>
  8021cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d0:	8b 00                	mov    (%eax),%eax
  8021d2:	eb 05                	jmp    8021d9 <print_mem_block_lists+0xa3>
  8021d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8021d9:	a3 40 51 80 00       	mov    %eax,0x805140
  8021de:	a1 40 51 80 00       	mov    0x805140,%eax
  8021e3:	85 c0                	test   %eax,%eax
  8021e5:	75 8a                	jne    802171 <print_mem_block_lists+0x3b>
  8021e7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021eb:	75 84                	jne    802171 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8021ed:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8021f1:	75 10                	jne    802203 <print_mem_block_lists+0xcd>
  8021f3:	83 ec 0c             	sub    $0xc,%esp
  8021f6:	68 38 45 80 00       	push   $0x804538
  8021fb:	e8 67 e7 ff ff       	call   800967 <cprintf>
  802200:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802203:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  80220a:	83 ec 0c             	sub    $0xc,%esp
  80220d:	68 5c 45 80 00       	push   $0x80455c
  802212:	e8 50 e7 ff ff       	call   800967 <cprintf>
  802217:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  80221a:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80221e:	a1 40 50 80 00       	mov    0x805040,%eax
  802223:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802226:	eb 56                	jmp    80227e <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802228:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80222c:	74 1c                	je     80224a <print_mem_block_lists+0x114>
  80222e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802231:	8b 50 08             	mov    0x8(%eax),%edx
  802234:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802237:	8b 48 08             	mov    0x8(%eax),%ecx
  80223a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80223d:	8b 40 0c             	mov    0xc(%eax),%eax
  802240:	01 c8                	add    %ecx,%eax
  802242:	39 c2                	cmp    %eax,%edx
  802244:	73 04                	jae    80224a <print_mem_block_lists+0x114>
			sorted = 0 ;
  802246:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80224a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80224d:	8b 50 08             	mov    0x8(%eax),%edx
  802250:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802253:	8b 40 0c             	mov    0xc(%eax),%eax
  802256:	01 c2                	add    %eax,%edx
  802258:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80225b:	8b 40 08             	mov    0x8(%eax),%eax
  80225e:	83 ec 04             	sub    $0x4,%esp
  802261:	52                   	push   %edx
  802262:	50                   	push   %eax
  802263:	68 29 45 80 00       	push   $0x804529
  802268:	e8 fa e6 ff ff       	call   800967 <cprintf>
  80226d:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802270:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802273:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802276:	a1 48 50 80 00       	mov    0x805048,%eax
  80227b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80227e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802282:	74 07                	je     80228b <print_mem_block_lists+0x155>
  802284:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802287:	8b 00                	mov    (%eax),%eax
  802289:	eb 05                	jmp    802290 <print_mem_block_lists+0x15a>
  80228b:	b8 00 00 00 00       	mov    $0x0,%eax
  802290:	a3 48 50 80 00       	mov    %eax,0x805048
  802295:	a1 48 50 80 00       	mov    0x805048,%eax
  80229a:	85 c0                	test   %eax,%eax
  80229c:	75 8a                	jne    802228 <print_mem_block_lists+0xf2>
  80229e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022a2:	75 84                	jne    802228 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8022a4:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8022a8:	75 10                	jne    8022ba <print_mem_block_lists+0x184>
  8022aa:	83 ec 0c             	sub    $0xc,%esp
  8022ad:	68 74 45 80 00       	push   $0x804574
  8022b2:	e8 b0 e6 ff ff       	call   800967 <cprintf>
  8022b7:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8022ba:	83 ec 0c             	sub    $0xc,%esp
  8022bd:	68 e8 44 80 00       	push   $0x8044e8
  8022c2:	e8 a0 e6 ff ff       	call   800967 <cprintf>
  8022c7:	83 c4 10             	add    $0x10,%esp

}
  8022ca:	90                   	nop
  8022cb:	c9                   	leave  
  8022cc:	c3                   	ret    

008022cd <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8022cd:	55                   	push   %ebp
  8022ce:	89 e5                	mov    %esp,%ebp
  8022d0:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  8022d3:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  8022da:	00 00 00 
  8022dd:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  8022e4:	00 00 00 
  8022e7:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  8022ee:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  8022f1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8022f8:	e9 9e 00 00 00       	jmp    80239b <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  8022fd:	a1 50 50 80 00       	mov    0x805050,%eax
  802302:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802305:	c1 e2 04             	shl    $0x4,%edx
  802308:	01 d0                	add    %edx,%eax
  80230a:	85 c0                	test   %eax,%eax
  80230c:	75 14                	jne    802322 <initialize_MemBlocksList+0x55>
  80230e:	83 ec 04             	sub    $0x4,%esp
  802311:	68 9c 45 80 00       	push   $0x80459c
  802316:	6a 46                	push   $0x46
  802318:	68 bf 45 80 00       	push   $0x8045bf
  80231d:	e8 91 e3 ff ff       	call   8006b3 <_panic>
  802322:	a1 50 50 80 00       	mov    0x805050,%eax
  802327:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80232a:	c1 e2 04             	shl    $0x4,%edx
  80232d:	01 d0                	add    %edx,%eax
  80232f:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802335:	89 10                	mov    %edx,(%eax)
  802337:	8b 00                	mov    (%eax),%eax
  802339:	85 c0                	test   %eax,%eax
  80233b:	74 18                	je     802355 <initialize_MemBlocksList+0x88>
  80233d:	a1 48 51 80 00       	mov    0x805148,%eax
  802342:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802348:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80234b:	c1 e1 04             	shl    $0x4,%ecx
  80234e:	01 ca                	add    %ecx,%edx
  802350:	89 50 04             	mov    %edx,0x4(%eax)
  802353:	eb 12                	jmp    802367 <initialize_MemBlocksList+0x9a>
  802355:	a1 50 50 80 00       	mov    0x805050,%eax
  80235a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80235d:	c1 e2 04             	shl    $0x4,%edx
  802360:	01 d0                	add    %edx,%eax
  802362:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802367:	a1 50 50 80 00       	mov    0x805050,%eax
  80236c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80236f:	c1 e2 04             	shl    $0x4,%edx
  802372:	01 d0                	add    %edx,%eax
  802374:	a3 48 51 80 00       	mov    %eax,0x805148
  802379:	a1 50 50 80 00       	mov    0x805050,%eax
  80237e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802381:	c1 e2 04             	shl    $0x4,%edx
  802384:	01 d0                	add    %edx,%eax
  802386:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80238d:	a1 54 51 80 00       	mov    0x805154,%eax
  802392:	40                   	inc    %eax
  802393:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  802398:	ff 45 f4             	incl   -0xc(%ebp)
  80239b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80239e:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023a1:	0f 82 56 ff ff ff    	jb     8022fd <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  8023a7:	90                   	nop
  8023a8:	c9                   	leave  
  8023a9:	c3                   	ret    

008023aa <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8023aa:	55                   	push   %ebp
  8023ab:	89 e5                	mov    %esp,%ebp
  8023ad:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8023b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b3:	8b 00                	mov    (%eax),%eax
  8023b5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8023b8:	eb 19                	jmp    8023d3 <find_block+0x29>
	{
		if(va==point->sva)
  8023ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8023bd:	8b 40 08             	mov    0x8(%eax),%eax
  8023c0:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8023c3:	75 05                	jne    8023ca <find_block+0x20>
		   return point;
  8023c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8023c8:	eb 36                	jmp    802400 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8023ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8023cd:	8b 40 08             	mov    0x8(%eax),%eax
  8023d0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8023d3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8023d7:	74 07                	je     8023e0 <find_block+0x36>
  8023d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8023dc:	8b 00                	mov    (%eax),%eax
  8023de:	eb 05                	jmp    8023e5 <find_block+0x3b>
  8023e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8023e5:	8b 55 08             	mov    0x8(%ebp),%edx
  8023e8:	89 42 08             	mov    %eax,0x8(%edx)
  8023eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ee:	8b 40 08             	mov    0x8(%eax),%eax
  8023f1:	85 c0                	test   %eax,%eax
  8023f3:	75 c5                	jne    8023ba <find_block+0x10>
  8023f5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8023f9:	75 bf                	jne    8023ba <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  8023fb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802400:	c9                   	leave  
  802401:	c3                   	ret    

00802402 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802402:	55                   	push   %ebp
  802403:	89 e5                	mov    %esp,%ebp
  802405:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  802408:	a1 40 50 80 00       	mov    0x805040,%eax
  80240d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802410:	a1 44 50 80 00       	mov    0x805044,%eax
  802415:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  802418:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80241b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80241e:	74 24                	je     802444 <insert_sorted_allocList+0x42>
  802420:	8b 45 08             	mov    0x8(%ebp),%eax
  802423:	8b 50 08             	mov    0x8(%eax),%edx
  802426:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802429:	8b 40 08             	mov    0x8(%eax),%eax
  80242c:	39 c2                	cmp    %eax,%edx
  80242e:	76 14                	jbe    802444 <insert_sorted_allocList+0x42>
  802430:	8b 45 08             	mov    0x8(%ebp),%eax
  802433:	8b 50 08             	mov    0x8(%eax),%edx
  802436:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802439:	8b 40 08             	mov    0x8(%eax),%eax
  80243c:	39 c2                	cmp    %eax,%edx
  80243e:	0f 82 60 01 00 00    	jb     8025a4 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802444:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802448:	75 65                	jne    8024af <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  80244a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80244e:	75 14                	jne    802464 <insert_sorted_allocList+0x62>
  802450:	83 ec 04             	sub    $0x4,%esp
  802453:	68 9c 45 80 00       	push   $0x80459c
  802458:	6a 6b                	push   $0x6b
  80245a:	68 bf 45 80 00       	push   $0x8045bf
  80245f:	e8 4f e2 ff ff       	call   8006b3 <_panic>
  802464:	8b 15 40 50 80 00    	mov    0x805040,%edx
  80246a:	8b 45 08             	mov    0x8(%ebp),%eax
  80246d:	89 10                	mov    %edx,(%eax)
  80246f:	8b 45 08             	mov    0x8(%ebp),%eax
  802472:	8b 00                	mov    (%eax),%eax
  802474:	85 c0                	test   %eax,%eax
  802476:	74 0d                	je     802485 <insert_sorted_allocList+0x83>
  802478:	a1 40 50 80 00       	mov    0x805040,%eax
  80247d:	8b 55 08             	mov    0x8(%ebp),%edx
  802480:	89 50 04             	mov    %edx,0x4(%eax)
  802483:	eb 08                	jmp    80248d <insert_sorted_allocList+0x8b>
  802485:	8b 45 08             	mov    0x8(%ebp),%eax
  802488:	a3 44 50 80 00       	mov    %eax,0x805044
  80248d:	8b 45 08             	mov    0x8(%ebp),%eax
  802490:	a3 40 50 80 00       	mov    %eax,0x805040
  802495:	8b 45 08             	mov    0x8(%ebp),%eax
  802498:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80249f:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8024a4:	40                   	inc    %eax
  8024a5:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8024aa:	e9 dc 01 00 00       	jmp    80268b <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  8024af:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b2:	8b 50 08             	mov    0x8(%eax),%edx
  8024b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024b8:	8b 40 08             	mov    0x8(%eax),%eax
  8024bb:	39 c2                	cmp    %eax,%edx
  8024bd:	77 6c                	ja     80252b <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  8024bf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8024c3:	74 06                	je     8024cb <insert_sorted_allocList+0xc9>
  8024c5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8024c9:	75 14                	jne    8024df <insert_sorted_allocList+0xdd>
  8024cb:	83 ec 04             	sub    $0x4,%esp
  8024ce:	68 d8 45 80 00       	push   $0x8045d8
  8024d3:	6a 6f                	push   $0x6f
  8024d5:	68 bf 45 80 00       	push   $0x8045bf
  8024da:	e8 d4 e1 ff ff       	call   8006b3 <_panic>
  8024df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024e2:	8b 50 04             	mov    0x4(%eax),%edx
  8024e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e8:	89 50 04             	mov    %edx,0x4(%eax)
  8024eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ee:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024f1:	89 10                	mov    %edx,(%eax)
  8024f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024f6:	8b 40 04             	mov    0x4(%eax),%eax
  8024f9:	85 c0                	test   %eax,%eax
  8024fb:	74 0d                	je     80250a <insert_sorted_allocList+0x108>
  8024fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802500:	8b 40 04             	mov    0x4(%eax),%eax
  802503:	8b 55 08             	mov    0x8(%ebp),%edx
  802506:	89 10                	mov    %edx,(%eax)
  802508:	eb 08                	jmp    802512 <insert_sorted_allocList+0x110>
  80250a:	8b 45 08             	mov    0x8(%ebp),%eax
  80250d:	a3 40 50 80 00       	mov    %eax,0x805040
  802512:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802515:	8b 55 08             	mov    0x8(%ebp),%edx
  802518:	89 50 04             	mov    %edx,0x4(%eax)
  80251b:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802520:	40                   	inc    %eax
  802521:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802526:	e9 60 01 00 00       	jmp    80268b <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  80252b:	8b 45 08             	mov    0x8(%ebp),%eax
  80252e:	8b 50 08             	mov    0x8(%eax),%edx
  802531:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802534:	8b 40 08             	mov    0x8(%eax),%eax
  802537:	39 c2                	cmp    %eax,%edx
  802539:	0f 82 4c 01 00 00    	jb     80268b <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  80253f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802543:	75 14                	jne    802559 <insert_sorted_allocList+0x157>
  802545:	83 ec 04             	sub    $0x4,%esp
  802548:	68 10 46 80 00       	push   $0x804610
  80254d:	6a 73                	push   $0x73
  80254f:	68 bf 45 80 00       	push   $0x8045bf
  802554:	e8 5a e1 ff ff       	call   8006b3 <_panic>
  802559:	8b 15 44 50 80 00    	mov    0x805044,%edx
  80255f:	8b 45 08             	mov    0x8(%ebp),%eax
  802562:	89 50 04             	mov    %edx,0x4(%eax)
  802565:	8b 45 08             	mov    0x8(%ebp),%eax
  802568:	8b 40 04             	mov    0x4(%eax),%eax
  80256b:	85 c0                	test   %eax,%eax
  80256d:	74 0c                	je     80257b <insert_sorted_allocList+0x179>
  80256f:	a1 44 50 80 00       	mov    0x805044,%eax
  802574:	8b 55 08             	mov    0x8(%ebp),%edx
  802577:	89 10                	mov    %edx,(%eax)
  802579:	eb 08                	jmp    802583 <insert_sorted_allocList+0x181>
  80257b:	8b 45 08             	mov    0x8(%ebp),%eax
  80257e:	a3 40 50 80 00       	mov    %eax,0x805040
  802583:	8b 45 08             	mov    0x8(%ebp),%eax
  802586:	a3 44 50 80 00       	mov    %eax,0x805044
  80258b:	8b 45 08             	mov    0x8(%ebp),%eax
  80258e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802594:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802599:	40                   	inc    %eax
  80259a:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80259f:	e9 e7 00 00 00       	jmp    80268b <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  8025a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  8025aa:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8025b1:	a1 40 50 80 00       	mov    0x805040,%eax
  8025b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025b9:	e9 9d 00 00 00       	jmp    80265b <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  8025be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c1:	8b 00                	mov    (%eax),%eax
  8025c3:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  8025c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c9:	8b 50 08             	mov    0x8(%eax),%edx
  8025cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025cf:	8b 40 08             	mov    0x8(%eax),%eax
  8025d2:	39 c2                	cmp    %eax,%edx
  8025d4:	76 7d                	jbe    802653 <insert_sorted_allocList+0x251>
  8025d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8025d9:	8b 50 08             	mov    0x8(%eax),%edx
  8025dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8025df:	8b 40 08             	mov    0x8(%eax),%eax
  8025e2:	39 c2                	cmp    %eax,%edx
  8025e4:	73 6d                	jae    802653 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  8025e6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025ea:	74 06                	je     8025f2 <insert_sorted_allocList+0x1f0>
  8025ec:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8025f0:	75 14                	jne    802606 <insert_sorted_allocList+0x204>
  8025f2:	83 ec 04             	sub    $0x4,%esp
  8025f5:	68 34 46 80 00       	push   $0x804634
  8025fa:	6a 7f                	push   $0x7f
  8025fc:	68 bf 45 80 00       	push   $0x8045bf
  802601:	e8 ad e0 ff ff       	call   8006b3 <_panic>
  802606:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802609:	8b 10                	mov    (%eax),%edx
  80260b:	8b 45 08             	mov    0x8(%ebp),%eax
  80260e:	89 10                	mov    %edx,(%eax)
  802610:	8b 45 08             	mov    0x8(%ebp),%eax
  802613:	8b 00                	mov    (%eax),%eax
  802615:	85 c0                	test   %eax,%eax
  802617:	74 0b                	je     802624 <insert_sorted_allocList+0x222>
  802619:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261c:	8b 00                	mov    (%eax),%eax
  80261e:	8b 55 08             	mov    0x8(%ebp),%edx
  802621:	89 50 04             	mov    %edx,0x4(%eax)
  802624:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802627:	8b 55 08             	mov    0x8(%ebp),%edx
  80262a:	89 10                	mov    %edx,(%eax)
  80262c:	8b 45 08             	mov    0x8(%ebp),%eax
  80262f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802632:	89 50 04             	mov    %edx,0x4(%eax)
  802635:	8b 45 08             	mov    0x8(%ebp),%eax
  802638:	8b 00                	mov    (%eax),%eax
  80263a:	85 c0                	test   %eax,%eax
  80263c:	75 08                	jne    802646 <insert_sorted_allocList+0x244>
  80263e:	8b 45 08             	mov    0x8(%ebp),%eax
  802641:	a3 44 50 80 00       	mov    %eax,0x805044
  802646:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80264b:	40                   	inc    %eax
  80264c:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802651:	eb 39                	jmp    80268c <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802653:	a1 48 50 80 00       	mov    0x805048,%eax
  802658:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80265b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80265f:	74 07                	je     802668 <insert_sorted_allocList+0x266>
  802661:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802664:	8b 00                	mov    (%eax),%eax
  802666:	eb 05                	jmp    80266d <insert_sorted_allocList+0x26b>
  802668:	b8 00 00 00 00       	mov    $0x0,%eax
  80266d:	a3 48 50 80 00       	mov    %eax,0x805048
  802672:	a1 48 50 80 00       	mov    0x805048,%eax
  802677:	85 c0                	test   %eax,%eax
  802679:	0f 85 3f ff ff ff    	jne    8025be <insert_sorted_allocList+0x1bc>
  80267f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802683:	0f 85 35 ff ff ff    	jne    8025be <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802689:	eb 01                	jmp    80268c <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80268b:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80268c:	90                   	nop
  80268d:	c9                   	leave  
  80268e:	c3                   	ret    

0080268f <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80268f:	55                   	push   %ebp
  802690:	89 e5                	mov    %esp,%ebp
  802692:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802695:	a1 38 51 80 00       	mov    0x805138,%eax
  80269a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80269d:	e9 85 01 00 00       	jmp    802827 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  8026a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a5:	8b 40 0c             	mov    0xc(%eax),%eax
  8026a8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026ab:	0f 82 6e 01 00 00    	jb     80281f <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  8026b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b4:	8b 40 0c             	mov    0xc(%eax),%eax
  8026b7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026ba:	0f 85 8a 00 00 00    	jne    80274a <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  8026c0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026c4:	75 17                	jne    8026dd <alloc_block_FF+0x4e>
  8026c6:	83 ec 04             	sub    $0x4,%esp
  8026c9:	68 68 46 80 00       	push   $0x804668
  8026ce:	68 93 00 00 00       	push   $0x93
  8026d3:	68 bf 45 80 00       	push   $0x8045bf
  8026d8:	e8 d6 df ff ff       	call   8006b3 <_panic>
  8026dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e0:	8b 00                	mov    (%eax),%eax
  8026e2:	85 c0                	test   %eax,%eax
  8026e4:	74 10                	je     8026f6 <alloc_block_FF+0x67>
  8026e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e9:	8b 00                	mov    (%eax),%eax
  8026eb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026ee:	8b 52 04             	mov    0x4(%edx),%edx
  8026f1:	89 50 04             	mov    %edx,0x4(%eax)
  8026f4:	eb 0b                	jmp    802701 <alloc_block_FF+0x72>
  8026f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f9:	8b 40 04             	mov    0x4(%eax),%eax
  8026fc:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802701:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802704:	8b 40 04             	mov    0x4(%eax),%eax
  802707:	85 c0                	test   %eax,%eax
  802709:	74 0f                	je     80271a <alloc_block_FF+0x8b>
  80270b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270e:	8b 40 04             	mov    0x4(%eax),%eax
  802711:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802714:	8b 12                	mov    (%edx),%edx
  802716:	89 10                	mov    %edx,(%eax)
  802718:	eb 0a                	jmp    802724 <alloc_block_FF+0x95>
  80271a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271d:	8b 00                	mov    (%eax),%eax
  80271f:	a3 38 51 80 00       	mov    %eax,0x805138
  802724:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802727:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80272d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802730:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802737:	a1 44 51 80 00       	mov    0x805144,%eax
  80273c:	48                   	dec    %eax
  80273d:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802742:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802745:	e9 10 01 00 00       	jmp    80285a <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  80274a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274d:	8b 40 0c             	mov    0xc(%eax),%eax
  802750:	3b 45 08             	cmp    0x8(%ebp),%eax
  802753:	0f 86 c6 00 00 00    	jbe    80281f <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802759:	a1 48 51 80 00       	mov    0x805148,%eax
  80275e:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802761:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802764:	8b 50 08             	mov    0x8(%eax),%edx
  802767:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80276a:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  80276d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802770:	8b 55 08             	mov    0x8(%ebp),%edx
  802773:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802776:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80277a:	75 17                	jne    802793 <alloc_block_FF+0x104>
  80277c:	83 ec 04             	sub    $0x4,%esp
  80277f:	68 68 46 80 00       	push   $0x804668
  802784:	68 9b 00 00 00       	push   $0x9b
  802789:	68 bf 45 80 00       	push   $0x8045bf
  80278e:	e8 20 df ff ff       	call   8006b3 <_panic>
  802793:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802796:	8b 00                	mov    (%eax),%eax
  802798:	85 c0                	test   %eax,%eax
  80279a:	74 10                	je     8027ac <alloc_block_FF+0x11d>
  80279c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80279f:	8b 00                	mov    (%eax),%eax
  8027a1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027a4:	8b 52 04             	mov    0x4(%edx),%edx
  8027a7:	89 50 04             	mov    %edx,0x4(%eax)
  8027aa:	eb 0b                	jmp    8027b7 <alloc_block_FF+0x128>
  8027ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027af:	8b 40 04             	mov    0x4(%eax),%eax
  8027b2:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8027b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027ba:	8b 40 04             	mov    0x4(%eax),%eax
  8027bd:	85 c0                	test   %eax,%eax
  8027bf:	74 0f                	je     8027d0 <alloc_block_FF+0x141>
  8027c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027c4:	8b 40 04             	mov    0x4(%eax),%eax
  8027c7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027ca:	8b 12                	mov    (%edx),%edx
  8027cc:	89 10                	mov    %edx,(%eax)
  8027ce:	eb 0a                	jmp    8027da <alloc_block_FF+0x14b>
  8027d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027d3:	8b 00                	mov    (%eax),%eax
  8027d5:	a3 48 51 80 00       	mov    %eax,0x805148
  8027da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027dd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027e6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027ed:	a1 54 51 80 00       	mov    0x805154,%eax
  8027f2:	48                   	dec    %eax
  8027f3:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  8027f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027fb:	8b 50 08             	mov    0x8(%eax),%edx
  8027fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802801:	01 c2                	add    %eax,%edx
  802803:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802806:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802809:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280c:	8b 40 0c             	mov    0xc(%eax),%eax
  80280f:	2b 45 08             	sub    0x8(%ebp),%eax
  802812:	89 c2                	mov    %eax,%edx
  802814:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802817:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  80281a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80281d:	eb 3b                	jmp    80285a <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  80281f:	a1 40 51 80 00       	mov    0x805140,%eax
  802824:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802827:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80282b:	74 07                	je     802834 <alloc_block_FF+0x1a5>
  80282d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802830:	8b 00                	mov    (%eax),%eax
  802832:	eb 05                	jmp    802839 <alloc_block_FF+0x1aa>
  802834:	b8 00 00 00 00       	mov    $0x0,%eax
  802839:	a3 40 51 80 00       	mov    %eax,0x805140
  80283e:	a1 40 51 80 00       	mov    0x805140,%eax
  802843:	85 c0                	test   %eax,%eax
  802845:	0f 85 57 fe ff ff    	jne    8026a2 <alloc_block_FF+0x13>
  80284b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80284f:	0f 85 4d fe ff ff    	jne    8026a2 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802855:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80285a:	c9                   	leave  
  80285b:	c3                   	ret    

0080285c <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  80285c:	55                   	push   %ebp
  80285d:	89 e5                	mov    %esp,%ebp
  80285f:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802862:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802869:	a1 38 51 80 00       	mov    0x805138,%eax
  80286e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802871:	e9 df 00 00 00       	jmp    802955 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802876:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802879:	8b 40 0c             	mov    0xc(%eax),%eax
  80287c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80287f:	0f 82 c8 00 00 00    	jb     80294d <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802885:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802888:	8b 40 0c             	mov    0xc(%eax),%eax
  80288b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80288e:	0f 85 8a 00 00 00    	jne    80291e <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802894:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802898:	75 17                	jne    8028b1 <alloc_block_BF+0x55>
  80289a:	83 ec 04             	sub    $0x4,%esp
  80289d:	68 68 46 80 00       	push   $0x804668
  8028a2:	68 b7 00 00 00       	push   $0xb7
  8028a7:	68 bf 45 80 00       	push   $0x8045bf
  8028ac:	e8 02 de ff ff       	call   8006b3 <_panic>
  8028b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b4:	8b 00                	mov    (%eax),%eax
  8028b6:	85 c0                	test   %eax,%eax
  8028b8:	74 10                	je     8028ca <alloc_block_BF+0x6e>
  8028ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028bd:	8b 00                	mov    (%eax),%eax
  8028bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028c2:	8b 52 04             	mov    0x4(%edx),%edx
  8028c5:	89 50 04             	mov    %edx,0x4(%eax)
  8028c8:	eb 0b                	jmp    8028d5 <alloc_block_BF+0x79>
  8028ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028cd:	8b 40 04             	mov    0x4(%eax),%eax
  8028d0:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8028d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d8:	8b 40 04             	mov    0x4(%eax),%eax
  8028db:	85 c0                	test   %eax,%eax
  8028dd:	74 0f                	je     8028ee <alloc_block_BF+0x92>
  8028df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e2:	8b 40 04             	mov    0x4(%eax),%eax
  8028e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028e8:	8b 12                	mov    (%edx),%edx
  8028ea:	89 10                	mov    %edx,(%eax)
  8028ec:	eb 0a                	jmp    8028f8 <alloc_block_BF+0x9c>
  8028ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f1:	8b 00                	mov    (%eax),%eax
  8028f3:	a3 38 51 80 00       	mov    %eax,0x805138
  8028f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028fb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802901:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802904:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80290b:	a1 44 51 80 00       	mov    0x805144,%eax
  802910:	48                   	dec    %eax
  802911:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802916:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802919:	e9 4d 01 00 00       	jmp    802a6b <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  80291e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802921:	8b 40 0c             	mov    0xc(%eax),%eax
  802924:	3b 45 08             	cmp    0x8(%ebp),%eax
  802927:	76 24                	jbe    80294d <alloc_block_BF+0xf1>
  802929:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292c:	8b 40 0c             	mov    0xc(%eax),%eax
  80292f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802932:	73 19                	jae    80294d <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802934:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  80293b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293e:	8b 40 0c             	mov    0xc(%eax),%eax
  802941:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802944:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802947:	8b 40 08             	mov    0x8(%eax),%eax
  80294a:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  80294d:	a1 40 51 80 00       	mov    0x805140,%eax
  802952:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802955:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802959:	74 07                	je     802962 <alloc_block_BF+0x106>
  80295b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295e:	8b 00                	mov    (%eax),%eax
  802960:	eb 05                	jmp    802967 <alloc_block_BF+0x10b>
  802962:	b8 00 00 00 00       	mov    $0x0,%eax
  802967:	a3 40 51 80 00       	mov    %eax,0x805140
  80296c:	a1 40 51 80 00       	mov    0x805140,%eax
  802971:	85 c0                	test   %eax,%eax
  802973:	0f 85 fd fe ff ff    	jne    802876 <alloc_block_BF+0x1a>
  802979:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80297d:	0f 85 f3 fe ff ff    	jne    802876 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802983:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802987:	0f 84 d9 00 00 00    	je     802a66 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  80298d:	a1 48 51 80 00       	mov    0x805148,%eax
  802992:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802995:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802998:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80299b:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  80299e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029a1:	8b 55 08             	mov    0x8(%ebp),%edx
  8029a4:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  8029a7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8029ab:	75 17                	jne    8029c4 <alloc_block_BF+0x168>
  8029ad:	83 ec 04             	sub    $0x4,%esp
  8029b0:	68 68 46 80 00       	push   $0x804668
  8029b5:	68 c7 00 00 00       	push   $0xc7
  8029ba:	68 bf 45 80 00       	push   $0x8045bf
  8029bf:	e8 ef dc ff ff       	call   8006b3 <_panic>
  8029c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029c7:	8b 00                	mov    (%eax),%eax
  8029c9:	85 c0                	test   %eax,%eax
  8029cb:	74 10                	je     8029dd <alloc_block_BF+0x181>
  8029cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029d0:	8b 00                	mov    (%eax),%eax
  8029d2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8029d5:	8b 52 04             	mov    0x4(%edx),%edx
  8029d8:	89 50 04             	mov    %edx,0x4(%eax)
  8029db:	eb 0b                	jmp    8029e8 <alloc_block_BF+0x18c>
  8029dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029e0:	8b 40 04             	mov    0x4(%eax),%eax
  8029e3:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8029e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029eb:	8b 40 04             	mov    0x4(%eax),%eax
  8029ee:	85 c0                	test   %eax,%eax
  8029f0:	74 0f                	je     802a01 <alloc_block_BF+0x1a5>
  8029f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029f5:	8b 40 04             	mov    0x4(%eax),%eax
  8029f8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8029fb:	8b 12                	mov    (%edx),%edx
  8029fd:	89 10                	mov    %edx,(%eax)
  8029ff:	eb 0a                	jmp    802a0b <alloc_block_BF+0x1af>
  802a01:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a04:	8b 00                	mov    (%eax),%eax
  802a06:	a3 48 51 80 00       	mov    %eax,0x805148
  802a0b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a0e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a14:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a17:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a1e:	a1 54 51 80 00       	mov    0x805154,%eax
  802a23:	48                   	dec    %eax
  802a24:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802a29:	83 ec 08             	sub    $0x8,%esp
  802a2c:	ff 75 ec             	pushl  -0x14(%ebp)
  802a2f:	68 38 51 80 00       	push   $0x805138
  802a34:	e8 71 f9 ff ff       	call   8023aa <find_block>
  802a39:	83 c4 10             	add    $0x10,%esp
  802a3c:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802a3f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a42:	8b 50 08             	mov    0x8(%eax),%edx
  802a45:	8b 45 08             	mov    0x8(%ebp),%eax
  802a48:	01 c2                	add    %eax,%edx
  802a4a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a4d:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802a50:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a53:	8b 40 0c             	mov    0xc(%eax),%eax
  802a56:	2b 45 08             	sub    0x8(%ebp),%eax
  802a59:	89 c2                	mov    %eax,%edx
  802a5b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a5e:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802a61:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a64:	eb 05                	jmp    802a6b <alloc_block_BF+0x20f>
	}
	return NULL;
  802a66:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a6b:	c9                   	leave  
  802a6c:	c3                   	ret    

00802a6d <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802a6d:	55                   	push   %ebp
  802a6e:	89 e5                	mov    %esp,%ebp
  802a70:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802a73:	a1 28 50 80 00       	mov    0x805028,%eax
  802a78:	85 c0                	test   %eax,%eax
  802a7a:	0f 85 de 01 00 00    	jne    802c5e <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802a80:	a1 38 51 80 00       	mov    0x805138,%eax
  802a85:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a88:	e9 9e 01 00 00       	jmp    802c2b <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802a8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a90:	8b 40 0c             	mov    0xc(%eax),%eax
  802a93:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a96:	0f 82 87 01 00 00    	jb     802c23 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802a9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9f:	8b 40 0c             	mov    0xc(%eax),%eax
  802aa2:	3b 45 08             	cmp    0x8(%ebp),%eax
  802aa5:	0f 85 95 00 00 00    	jne    802b40 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802aab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802aaf:	75 17                	jne    802ac8 <alloc_block_NF+0x5b>
  802ab1:	83 ec 04             	sub    $0x4,%esp
  802ab4:	68 68 46 80 00       	push   $0x804668
  802ab9:	68 e0 00 00 00       	push   $0xe0
  802abe:	68 bf 45 80 00       	push   $0x8045bf
  802ac3:	e8 eb db ff ff       	call   8006b3 <_panic>
  802ac8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802acb:	8b 00                	mov    (%eax),%eax
  802acd:	85 c0                	test   %eax,%eax
  802acf:	74 10                	je     802ae1 <alloc_block_NF+0x74>
  802ad1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad4:	8b 00                	mov    (%eax),%eax
  802ad6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ad9:	8b 52 04             	mov    0x4(%edx),%edx
  802adc:	89 50 04             	mov    %edx,0x4(%eax)
  802adf:	eb 0b                	jmp    802aec <alloc_block_NF+0x7f>
  802ae1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae4:	8b 40 04             	mov    0x4(%eax),%eax
  802ae7:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802aec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aef:	8b 40 04             	mov    0x4(%eax),%eax
  802af2:	85 c0                	test   %eax,%eax
  802af4:	74 0f                	je     802b05 <alloc_block_NF+0x98>
  802af6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af9:	8b 40 04             	mov    0x4(%eax),%eax
  802afc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802aff:	8b 12                	mov    (%edx),%edx
  802b01:	89 10                	mov    %edx,(%eax)
  802b03:	eb 0a                	jmp    802b0f <alloc_block_NF+0xa2>
  802b05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b08:	8b 00                	mov    (%eax),%eax
  802b0a:	a3 38 51 80 00       	mov    %eax,0x805138
  802b0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b12:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b22:	a1 44 51 80 00       	mov    0x805144,%eax
  802b27:	48                   	dec    %eax
  802b28:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802b2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b30:	8b 40 08             	mov    0x8(%eax),%eax
  802b33:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  802b38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b3b:	e9 f8 04 00 00       	jmp    803038 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802b40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b43:	8b 40 0c             	mov    0xc(%eax),%eax
  802b46:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b49:	0f 86 d4 00 00 00    	jbe    802c23 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802b4f:	a1 48 51 80 00       	mov    0x805148,%eax
  802b54:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802b57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5a:	8b 50 08             	mov    0x8(%eax),%edx
  802b5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b60:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802b63:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b66:	8b 55 08             	mov    0x8(%ebp),%edx
  802b69:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802b6c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b70:	75 17                	jne    802b89 <alloc_block_NF+0x11c>
  802b72:	83 ec 04             	sub    $0x4,%esp
  802b75:	68 68 46 80 00       	push   $0x804668
  802b7a:	68 e9 00 00 00       	push   $0xe9
  802b7f:	68 bf 45 80 00       	push   $0x8045bf
  802b84:	e8 2a db ff ff       	call   8006b3 <_panic>
  802b89:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b8c:	8b 00                	mov    (%eax),%eax
  802b8e:	85 c0                	test   %eax,%eax
  802b90:	74 10                	je     802ba2 <alloc_block_NF+0x135>
  802b92:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b95:	8b 00                	mov    (%eax),%eax
  802b97:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b9a:	8b 52 04             	mov    0x4(%edx),%edx
  802b9d:	89 50 04             	mov    %edx,0x4(%eax)
  802ba0:	eb 0b                	jmp    802bad <alloc_block_NF+0x140>
  802ba2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ba5:	8b 40 04             	mov    0x4(%eax),%eax
  802ba8:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802bad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bb0:	8b 40 04             	mov    0x4(%eax),%eax
  802bb3:	85 c0                	test   %eax,%eax
  802bb5:	74 0f                	je     802bc6 <alloc_block_NF+0x159>
  802bb7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bba:	8b 40 04             	mov    0x4(%eax),%eax
  802bbd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bc0:	8b 12                	mov    (%edx),%edx
  802bc2:	89 10                	mov    %edx,(%eax)
  802bc4:	eb 0a                	jmp    802bd0 <alloc_block_NF+0x163>
  802bc6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bc9:	8b 00                	mov    (%eax),%eax
  802bcb:	a3 48 51 80 00       	mov    %eax,0x805148
  802bd0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bd3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bd9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bdc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802be3:	a1 54 51 80 00       	mov    0x805154,%eax
  802be8:	48                   	dec    %eax
  802be9:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802bee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bf1:	8b 40 08             	mov    0x8(%eax),%eax
  802bf4:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802bf9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bfc:	8b 50 08             	mov    0x8(%eax),%edx
  802bff:	8b 45 08             	mov    0x8(%ebp),%eax
  802c02:	01 c2                	add    %eax,%edx
  802c04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c07:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802c0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0d:	8b 40 0c             	mov    0xc(%eax),%eax
  802c10:	2b 45 08             	sub    0x8(%ebp),%eax
  802c13:	89 c2                	mov    %eax,%edx
  802c15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c18:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802c1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c1e:	e9 15 04 00 00       	jmp    803038 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802c23:	a1 40 51 80 00       	mov    0x805140,%eax
  802c28:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c2b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c2f:	74 07                	je     802c38 <alloc_block_NF+0x1cb>
  802c31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c34:	8b 00                	mov    (%eax),%eax
  802c36:	eb 05                	jmp    802c3d <alloc_block_NF+0x1d0>
  802c38:	b8 00 00 00 00       	mov    $0x0,%eax
  802c3d:	a3 40 51 80 00       	mov    %eax,0x805140
  802c42:	a1 40 51 80 00       	mov    0x805140,%eax
  802c47:	85 c0                	test   %eax,%eax
  802c49:	0f 85 3e fe ff ff    	jne    802a8d <alloc_block_NF+0x20>
  802c4f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c53:	0f 85 34 fe ff ff    	jne    802a8d <alloc_block_NF+0x20>
  802c59:	e9 d5 03 00 00       	jmp    803033 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802c5e:	a1 38 51 80 00       	mov    0x805138,%eax
  802c63:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c66:	e9 b1 01 00 00       	jmp    802e1c <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802c6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c6e:	8b 50 08             	mov    0x8(%eax),%edx
  802c71:	a1 28 50 80 00       	mov    0x805028,%eax
  802c76:	39 c2                	cmp    %eax,%edx
  802c78:	0f 82 96 01 00 00    	jb     802e14 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802c7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c81:	8b 40 0c             	mov    0xc(%eax),%eax
  802c84:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c87:	0f 82 87 01 00 00    	jb     802e14 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802c8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c90:	8b 40 0c             	mov    0xc(%eax),%eax
  802c93:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c96:	0f 85 95 00 00 00    	jne    802d31 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802c9c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ca0:	75 17                	jne    802cb9 <alloc_block_NF+0x24c>
  802ca2:	83 ec 04             	sub    $0x4,%esp
  802ca5:	68 68 46 80 00       	push   $0x804668
  802caa:	68 fc 00 00 00       	push   $0xfc
  802caf:	68 bf 45 80 00       	push   $0x8045bf
  802cb4:	e8 fa d9 ff ff       	call   8006b3 <_panic>
  802cb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cbc:	8b 00                	mov    (%eax),%eax
  802cbe:	85 c0                	test   %eax,%eax
  802cc0:	74 10                	je     802cd2 <alloc_block_NF+0x265>
  802cc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc5:	8b 00                	mov    (%eax),%eax
  802cc7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cca:	8b 52 04             	mov    0x4(%edx),%edx
  802ccd:	89 50 04             	mov    %edx,0x4(%eax)
  802cd0:	eb 0b                	jmp    802cdd <alloc_block_NF+0x270>
  802cd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd5:	8b 40 04             	mov    0x4(%eax),%eax
  802cd8:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802cdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce0:	8b 40 04             	mov    0x4(%eax),%eax
  802ce3:	85 c0                	test   %eax,%eax
  802ce5:	74 0f                	je     802cf6 <alloc_block_NF+0x289>
  802ce7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cea:	8b 40 04             	mov    0x4(%eax),%eax
  802ced:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cf0:	8b 12                	mov    (%edx),%edx
  802cf2:	89 10                	mov    %edx,(%eax)
  802cf4:	eb 0a                	jmp    802d00 <alloc_block_NF+0x293>
  802cf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf9:	8b 00                	mov    (%eax),%eax
  802cfb:	a3 38 51 80 00       	mov    %eax,0x805138
  802d00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d03:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d13:	a1 44 51 80 00       	mov    0x805144,%eax
  802d18:	48                   	dec    %eax
  802d19:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802d1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d21:	8b 40 08             	mov    0x8(%eax),%eax
  802d24:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802d29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d2c:	e9 07 03 00 00       	jmp    803038 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802d31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d34:	8b 40 0c             	mov    0xc(%eax),%eax
  802d37:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d3a:	0f 86 d4 00 00 00    	jbe    802e14 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802d40:	a1 48 51 80 00       	mov    0x805148,%eax
  802d45:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802d48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d4b:	8b 50 08             	mov    0x8(%eax),%edx
  802d4e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d51:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802d54:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d57:	8b 55 08             	mov    0x8(%ebp),%edx
  802d5a:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802d5d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802d61:	75 17                	jne    802d7a <alloc_block_NF+0x30d>
  802d63:	83 ec 04             	sub    $0x4,%esp
  802d66:	68 68 46 80 00       	push   $0x804668
  802d6b:	68 04 01 00 00       	push   $0x104
  802d70:	68 bf 45 80 00       	push   $0x8045bf
  802d75:	e8 39 d9 ff ff       	call   8006b3 <_panic>
  802d7a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d7d:	8b 00                	mov    (%eax),%eax
  802d7f:	85 c0                	test   %eax,%eax
  802d81:	74 10                	je     802d93 <alloc_block_NF+0x326>
  802d83:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d86:	8b 00                	mov    (%eax),%eax
  802d88:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d8b:	8b 52 04             	mov    0x4(%edx),%edx
  802d8e:	89 50 04             	mov    %edx,0x4(%eax)
  802d91:	eb 0b                	jmp    802d9e <alloc_block_NF+0x331>
  802d93:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d96:	8b 40 04             	mov    0x4(%eax),%eax
  802d99:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d9e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802da1:	8b 40 04             	mov    0x4(%eax),%eax
  802da4:	85 c0                	test   %eax,%eax
  802da6:	74 0f                	je     802db7 <alloc_block_NF+0x34a>
  802da8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dab:	8b 40 04             	mov    0x4(%eax),%eax
  802dae:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802db1:	8b 12                	mov    (%edx),%edx
  802db3:	89 10                	mov    %edx,(%eax)
  802db5:	eb 0a                	jmp    802dc1 <alloc_block_NF+0x354>
  802db7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dba:	8b 00                	mov    (%eax),%eax
  802dbc:	a3 48 51 80 00       	mov    %eax,0x805148
  802dc1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dc4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802dca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dcd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dd4:	a1 54 51 80 00       	mov    0x805154,%eax
  802dd9:	48                   	dec    %eax
  802dda:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802ddf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802de2:	8b 40 08             	mov    0x8(%eax),%eax
  802de5:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802dea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ded:	8b 50 08             	mov    0x8(%eax),%edx
  802df0:	8b 45 08             	mov    0x8(%ebp),%eax
  802df3:	01 c2                	add    %eax,%edx
  802df5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df8:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802dfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dfe:	8b 40 0c             	mov    0xc(%eax),%eax
  802e01:	2b 45 08             	sub    0x8(%ebp),%eax
  802e04:	89 c2                	mov    %eax,%edx
  802e06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e09:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802e0c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e0f:	e9 24 02 00 00       	jmp    803038 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802e14:	a1 40 51 80 00       	mov    0x805140,%eax
  802e19:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e1c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e20:	74 07                	je     802e29 <alloc_block_NF+0x3bc>
  802e22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e25:	8b 00                	mov    (%eax),%eax
  802e27:	eb 05                	jmp    802e2e <alloc_block_NF+0x3c1>
  802e29:	b8 00 00 00 00       	mov    $0x0,%eax
  802e2e:	a3 40 51 80 00       	mov    %eax,0x805140
  802e33:	a1 40 51 80 00       	mov    0x805140,%eax
  802e38:	85 c0                	test   %eax,%eax
  802e3a:	0f 85 2b fe ff ff    	jne    802c6b <alloc_block_NF+0x1fe>
  802e40:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e44:	0f 85 21 fe ff ff    	jne    802c6b <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802e4a:	a1 38 51 80 00       	mov    0x805138,%eax
  802e4f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e52:	e9 ae 01 00 00       	jmp    803005 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802e57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e5a:	8b 50 08             	mov    0x8(%eax),%edx
  802e5d:	a1 28 50 80 00       	mov    0x805028,%eax
  802e62:	39 c2                	cmp    %eax,%edx
  802e64:	0f 83 93 01 00 00    	jae    802ffd <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802e6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e6d:	8b 40 0c             	mov    0xc(%eax),%eax
  802e70:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e73:	0f 82 84 01 00 00    	jb     802ffd <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802e79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e7c:	8b 40 0c             	mov    0xc(%eax),%eax
  802e7f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e82:	0f 85 95 00 00 00    	jne    802f1d <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802e88:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e8c:	75 17                	jne    802ea5 <alloc_block_NF+0x438>
  802e8e:	83 ec 04             	sub    $0x4,%esp
  802e91:	68 68 46 80 00       	push   $0x804668
  802e96:	68 14 01 00 00       	push   $0x114
  802e9b:	68 bf 45 80 00       	push   $0x8045bf
  802ea0:	e8 0e d8 ff ff       	call   8006b3 <_panic>
  802ea5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea8:	8b 00                	mov    (%eax),%eax
  802eaa:	85 c0                	test   %eax,%eax
  802eac:	74 10                	je     802ebe <alloc_block_NF+0x451>
  802eae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb1:	8b 00                	mov    (%eax),%eax
  802eb3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802eb6:	8b 52 04             	mov    0x4(%edx),%edx
  802eb9:	89 50 04             	mov    %edx,0x4(%eax)
  802ebc:	eb 0b                	jmp    802ec9 <alloc_block_NF+0x45c>
  802ebe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec1:	8b 40 04             	mov    0x4(%eax),%eax
  802ec4:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ec9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ecc:	8b 40 04             	mov    0x4(%eax),%eax
  802ecf:	85 c0                	test   %eax,%eax
  802ed1:	74 0f                	je     802ee2 <alloc_block_NF+0x475>
  802ed3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed6:	8b 40 04             	mov    0x4(%eax),%eax
  802ed9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802edc:	8b 12                	mov    (%edx),%edx
  802ede:	89 10                	mov    %edx,(%eax)
  802ee0:	eb 0a                	jmp    802eec <alloc_block_NF+0x47f>
  802ee2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee5:	8b 00                	mov    (%eax),%eax
  802ee7:	a3 38 51 80 00       	mov    %eax,0x805138
  802eec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ef5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802eff:	a1 44 51 80 00       	mov    0x805144,%eax
  802f04:	48                   	dec    %eax
  802f05:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802f0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f0d:	8b 40 08             	mov    0x8(%eax),%eax
  802f10:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802f15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f18:	e9 1b 01 00 00       	jmp    803038 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802f1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f20:	8b 40 0c             	mov    0xc(%eax),%eax
  802f23:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f26:	0f 86 d1 00 00 00    	jbe    802ffd <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802f2c:	a1 48 51 80 00       	mov    0x805148,%eax
  802f31:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802f34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f37:	8b 50 08             	mov    0x8(%eax),%edx
  802f3a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f3d:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802f40:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f43:	8b 55 08             	mov    0x8(%ebp),%edx
  802f46:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802f49:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802f4d:	75 17                	jne    802f66 <alloc_block_NF+0x4f9>
  802f4f:	83 ec 04             	sub    $0x4,%esp
  802f52:	68 68 46 80 00       	push   $0x804668
  802f57:	68 1c 01 00 00       	push   $0x11c
  802f5c:	68 bf 45 80 00       	push   $0x8045bf
  802f61:	e8 4d d7 ff ff       	call   8006b3 <_panic>
  802f66:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f69:	8b 00                	mov    (%eax),%eax
  802f6b:	85 c0                	test   %eax,%eax
  802f6d:	74 10                	je     802f7f <alloc_block_NF+0x512>
  802f6f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f72:	8b 00                	mov    (%eax),%eax
  802f74:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802f77:	8b 52 04             	mov    0x4(%edx),%edx
  802f7a:	89 50 04             	mov    %edx,0x4(%eax)
  802f7d:	eb 0b                	jmp    802f8a <alloc_block_NF+0x51d>
  802f7f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f82:	8b 40 04             	mov    0x4(%eax),%eax
  802f85:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f8a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f8d:	8b 40 04             	mov    0x4(%eax),%eax
  802f90:	85 c0                	test   %eax,%eax
  802f92:	74 0f                	je     802fa3 <alloc_block_NF+0x536>
  802f94:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f97:	8b 40 04             	mov    0x4(%eax),%eax
  802f9a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802f9d:	8b 12                	mov    (%edx),%edx
  802f9f:	89 10                	mov    %edx,(%eax)
  802fa1:	eb 0a                	jmp    802fad <alloc_block_NF+0x540>
  802fa3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fa6:	8b 00                	mov    (%eax),%eax
  802fa8:	a3 48 51 80 00       	mov    %eax,0x805148
  802fad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fb0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fb6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fb9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fc0:	a1 54 51 80 00       	mov    0x805154,%eax
  802fc5:	48                   	dec    %eax
  802fc6:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802fcb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fce:	8b 40 08             	mov    0x8(%eax),%eax
  802fd1:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802fd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd9:	8b 50 08             	mov    0x8(%eax),%edx
  802fdc:	8b 45 08             	mov    0x8(%ebp),%eax
  802fdf:	01 c2                	add    %eax,%edx
  802fe1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe4:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802fe7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fea:	8b 40 0c             	mov    0xc(%eax),%eax
  802fed:	2b 45 08             	sub    0x8(%ebp),%eax
  802ff0:	89 c2                	mov    %eax,%edx
  802ff2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff5:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802ff8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ffb:	eb 3b                	jmp    803038 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802ffd:	a1 40 51 80 00       	mov    0x805140,%eax
  803002:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803005:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803009:	74 07                	je     803012 <alloc_block_NF+0x5a5>
  80300b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80300e:	8b 00                	mov    (%eax),%eax
  803010:	eb 05                	jmp    803017 <alloc_block_NF+0x5aa>
  803012:	b8 00 00 00 00       	mov    $0x0,%eax
  803017:	a3 40 51 80 00       	mov    %eax,0x805140
  80301c:	a1 40 51 80 00       	mov    0x805140,%eax
  803021:	85 c0                	test   %eax,%eax
  803023:	0f 85 2e fe ff ff    	jne    802e57 <alloc_block_NF+0x3ea>
  803029:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80302d:	0f 85 24 fe ff ff    	jne    802e57 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  803033:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803038:	c9                   	leave  
  803039:	c3                   	ret    

0080303a <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  80303a:	55                   	push   %ebp
  80303b:	89 e5                	mov    %esp,%ebp
  80303d:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  803040:	a1 38 51 80 00       	mov    0x805138,%eax
  803045:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  803048:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80304d:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  803050:	a1 38 51 80 00       	mov    0x805138,%eax
  803055:	85 c0                	test   %eax,%eax
  803057:	74 14                	je     80306d <insert_sorted_with_merge_freeList+0x33>
  803059:	8b 45 08             	mov    0x8(%ebp),%eax
  80305c:	8b 50 08             	mov    0x8(%eax),%edx
  80305f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803062:	8b 40 08             	mov    0x8(%eax),%eax
  803065:	39 c2                	cmp    %eax,%edx
  803067:	0f 87 9b 01 00 00    	ja     803208 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  80306d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803071:	75 17                	jne    80308a <insert_sorted_with_merge_freeList+0x50>
  803073:	83 ec 04             	sub    $0x4,%esp
  803076:	68 9c 45 80 00       	push   $0x80459c
  80307b:	68 38 01 00 00       	push   $0x138
  803080:	68 bf 45 80 00       	push   $0x8045bf
  803085:	e8 29 d6 ff ff       	call   8006b3 <_panic>
  80308a:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803090:	8b 45 08             	mov    0x8(%ebp),%eax
  803093:	89 10                	mov    %edx,(%eax)
  803095:	8b 45 08             	mov    0x8(%ebp),%eax
  803098:	8b 00                	mov    (%eax),%eax
  80309a:	85 c0                	test   %eax,%eax
  80309c:	74 0d                	je     8030ab <insert_sorted_with_merge_freeList+0x71>
  80309e:	a1 38 51 80 00       	mov    0x805138,%eax
  8030a3:	8b 55 08             	mov    0x8(%ebp),%edx
  8030a6:	89 50 04             	mov    %edx,0x4(%eax)
  8030a9:	eb 08                	jmp    8030b3 <insert_sorted_with_merge_freeList+0x79>
  8030ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ae:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8030b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b6:	a3 38 51 80 00       	mov    %eax,0x805138
  8030bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8030be:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030c5:	a1 44 51 80 00       	mov    0x805144,%eax
  8030ca:	40                   	inc    %eax
  8030cb:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8030d0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8030d4:	0f 84 a8 06 00 00    	je     803782 <insert_sorted_with_merge_freeList+0x748>
  8030da:	8b 45 08             	mov    0x8(%ebp),%eax
  8030dd:	8b 50 08             	mov    0x8(%eax),%edx
  8030e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e3:	8b 40 0c             	mov    0xc(%eax),%eax
  8030e6:	01 c2                	add    %eax,%edx
  8030e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030eb:	8b 40 08             	mov    0x8(%eax),%eax
  8030ee:	39 c2                	cmp    %eax,%edx
  8030f0:	0f 85 8c 06 00 00    	jne    803782 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  8030f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f9:	8b 50 0c             	mov    0xc(%eax),%edx
  8030fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030ff:	8b 40 0c             	mov    0xc(%eax),%eax
  803102:	01 c2                	add    %eax,%edx
  803104:	8b 45 08             	mov    0x8(%ebp),%eax
  803107:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  80310a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80310e:	75 17                	jne    803127 <insert_sorted_with_merge_freeList+0xed>
  803110:	83 ec 04             	sub    $0x4,%esp
  803113:	68 68 46 80 00       	push   $0x804668
  803118:	68 3c 01 00 00       	push   $0x13c
  80311d:	68 bf 45 80 00       	push   $0x8045bf
  803122:	e8 8c d5 ff ff       	call   8006b3 <_panic>
  803127:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80312a:	8b 00                	mov    (%eax),%eax
  80312c:	85 c0                	test   %eax,%eax
  80312e:	74 10                	je     803140 <insert_sorted_with_merge_freeList+0x106>
  803130:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803133:	8b 00                	mov    (%eax),%eax
  803135:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803138:	8b 52 04             	mov    0x4(%edx),%edx
  80313b:	89 50 04             	mov    %edx,0x4(%eax)
  80313e:	eb 0b                	jmp    80314b <insert_sorted_with_merge_freeList+0x111>
  803140:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803143:	8b 40 04             	mov    0x4(%eax),%eax
  803146:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80314b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80314e:	8b 40 04             	mov    0x4(%eax),%eax
  803151:	85 c0                	test   %eax,%eax
  803153:	74 0f                	je     803164 <insert_sorted_with_merge_freeList+0x12a>
  803155:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803158:	8b 40 04             	mov    0x4(%eax),%eax
  80315b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80315e:	8b 12                	mov    (%edx),%edx
  803160:	89 10                	mov    %edx,(%eax)
  803162:	eb 0a                	jmp    80316e <insert_sorted_with_merge_freeList+0x134>
  803164:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803167:	8b 00                	mov    (%eax),%eax
  803169:	a3 38 51 80 00       	mov    %eax,0x805138
  80316e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803171:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803177:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80317a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803181:	a1 44 51 80 00       	mov    0x805144,%eax
  803186:	48                   	dec    %eax
  803187:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  80318c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80318f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  803196:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803199:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  8031a0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8031a4:	75 17                	jne    8031bd <insert_sorted_with_merge_freeList+0x183>
  8031a6:	83 ec 04             	sub    $0x4,%esp
  8031a9:	68 9c 45 80 00       	push   $0x80459c
  8031ae:	68 3f 01 00 00       	push   $0x13f
  8031b3:	68 bf 45 80 00       	push   $0x8045bf
  8031b8:	e8 f6 d4 ff ff       	call   8006b3 <_panic>
  8031bd:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8031c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031c6:	89 10                	mov    %edx,(%eax)
  8031c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031cb:	8b 00                	mov    (%eax),%eax
  8031cd:	85 c0                	test   %eax,%eax
  8031cf:	74 0d                	je     8031de <insert_sorted_with_merge_freeList+0x1a4>
  8031d1:	a1 48 51 80 00       	mov    0x805148,%eax
  8031d6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031d9:	89 50 04             	mov    %edx,0x4(%eax)
  8031dc:	eb 08                	jmp    8031e6 <insert_sorted_with_merge_freeList+0x1ac>
  8031de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031e1:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8031e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031e9:	a3 48 51 80 00       	mov    %eax,0x805148
  8031ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031f1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031f8:	a1 54 51 80 00       	mov    0x805154,%eax
  8031fd:	40                   	inc    %eax
  8031fe:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803203:	e9 7a 05 00 00       	jmp    803782 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  803208:	8b 45 08             	mov    0x8(%ebp),%eax
  80320b:	8b 50 08             	mov    0x8(%eax),%edx
  80320e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803211:	8b 40 08             	mov    0x8(%eax),%eax
  803214:	39 c2                	cmp    %eax,%edx
  803216:	0f 82 14 01 00 00    	jb     803330 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  80321c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80321f:	8b 50 08             	mov    0x8(%eax),%edx
  803222:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803225:	8b 40 0c             	mov    0xc(%eax),%eax
  803228:	01 c2                	add    %eax,%edx
  80322a:	8b 45 08             	mov    0x8(%ebp),%eax
  80322d:	8b 40 08             	mov    0x8(%eax),%eax
  803230:	39 c2                	cmp    %eax,%edx
  803232:	0f 85 90 00 00 00    	jne    8032c8 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  803238:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80323b:	8b 50 0c             	mov    0xc(%eax),%edx
  80323e:	8b 45 08             	mov    0x8(%ebp),%eax
  803241:	8b 40 0c             	mov    0xc(%eax),%eax
  803244:	01 c2                	add    %eax,%edx
  803246:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803249:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  80324c:	8b 45 08             	mov    0x8(%ebp),%eax
  80324f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  803256:	8b 45 08             	mov    0x8(%ebp),%eax
  803259:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803260:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803264:	75 17                	jne    80327d <insert_sorted_with_merge_freeList+0x243>
  803266:	83 ec 04             	sub    $0x4,%esp
  803269:	68 9c 45 80 00       	push   $0x80459c
  80326e:	68 49 01 00 00       	push   $0x149
  803273:	68 bf 45 80 00       	push   $0x8045bf
  803278:	e8 36 d4 ff ff       	call   8006b3 <_panic>
  80327d:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803283:	8b 45 08             	mov    0x8(%ebp),%eax
  803286:	89 10                	mov    %edx,(%eax)
  803288:	8b 45 08             	mov    0x8(%ebp),%eax
  80328b:	8b 00                	mov    (%eax),%eax
  80328d:	85 c0                	test   %eax,%eax
  80328f:	74 0d                	je     80329e <insert_sorted_with_merge_freeList+0x264>
  803291:	a1 48 51 80 00       	mov    0x805148,%eax
  803296:	8b 55 08             	mov    0x8(%ebp),%edx
  803299:	89 50 04             	mov    %edx,0x4(%eax)
  80329c:	eb 08                	jmp    8032a6 <insert_sorted_with_merge_freeList+0x26c>
  80329e:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a1:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8032a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a9:	a3 48 51 80 00       	mov    %eax,0x805148
  8032ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032b8:	a1 54 51 80 00       	mov    0x805154,%eax
  8032bd:	40                   	inc    %eax
  8032be:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8032c3:	e9 bb 04 00 00       	jmp    803783 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  8032c8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032cc:	75 17                	jne    8032e5 <insert_sorted_with_merge_freeList+0x2ab>
  8032ce:	83 ec 04             	sub    $0x4,%esp
  8032d1:	68 10 46 80 00       	push   $0x804610
  8032d6:	68 4c 01 00 00       	push   $0x14c
  8032db:	68 bf 45 80 00       	push   $0x8045bf
  8032e0:	e8 ce d3 ff ff       	call   8006b3 <_panic>
  8032e5:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  8032eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ee:	89 50 04             	mov    %edx,0x4(%eax)
  8032f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f4:	8b 40 04             	mov    0x4(%eax),%eax
  8032f7:	85 c0                	test   %eax,%eax
  8032f9:	74 0c                	je     803307 <insert_sorted_with_merge_freeList+0x2cd>
  8032fb:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803300:	8b 55 08             	mov    0x8(%ebp),%edx
  803303:	89 10                	mov    %edx,(%eax)
  803305:	eb 08                	jmp    80330f <insert_sorted_with_merge_freeList+0x2d5>
  803307:	8b 45 08             	mov    0x8(%ebp),%eax
  80330a:	a3 38 51 80 00       	mov    %eax,0x805138
  80330f:	8b 45 08             	mov    0x8(%ebp),%eax
  803312:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803317:	8b 45 08             	mov    0x8(%ebp),%eax
  80331a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803320:	a1 44 51 80 00       	mov    0x805144,%eax
  803325:	40                   	inc    %eax
  803326:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80332b:	e9 53 04 00 00       	jmp    803783 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803330:	a1 38 51 80 00       	mov    0x805138,%eax
  803335:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803338:	e9 15 04 00 00       	jmp    803752 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  80333d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803340:	8b 00                	mov    (%eax),%eax
  803342:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  803345:	8b 45 08             	mov    0x8(%ebp),%eax
  803348:	8b 50 08             	mov    0x8(%eax),%edx
  80334b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80334e:	8b 40 08             	mov    0x8(%eax),%eax
  803351:	39 c2                	cmp    %eax,%edx
  803353:	0f 86 f1 03 00 00    	jbe    80374a <insert_sorted_with_merge_freeList+0x710>
  803359:	8b 45 08             	mov    0x8(%ebp),%eax
  80335c:	8b 50 08             	mov    0x8(%eax),%edx
  80335f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803362:	8b 40 08             	mov    0x8(%eax),%eax
  803365:	39 c2                	cmp    %eax,%edx
  803367:	0f 83 dd 03 00 00    	jae    80374a <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  80336d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803370:	8b 50 08             	mov    0x8(%eax),%edx
  803373:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803376:	8b 40 0c             	mov    0xc(%eax),%eax
  803379:	01 c2                	add    %eax,%edx
  80337b:	8b 45 08             	mov    0x8(%ebp),%eax
  80337e:	8b 40 08             	mov    0x8(%eax),%eax
  803381:	39 c2                	cmp    %eax,%edx
  803383:	0f 85 b9 01 00 00    	jne    803542 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803389:	8b 45 08             	mov    0x8(%ebp),%eax
  80338c:	8b 50 08             	mov    0x8(%eax),%edx
  80338f:	8b 45 08             	mov    0x8(%ebp),%eax
  803392:	8b 40 0c             	mov    0xc(%eax),%eax
  803395:	01 c2                	add    %eax,%edx
  803397:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80339a:	8b 40 08             	mov    0x8(%eax),%eax
  80339d:	39 c2                	cmp    %eax,%edx
  80339f:	0f 85 0d 01 00 00    	jne    8034b2 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  8033a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033a8:	8b 50 0c             	mov    0xc(%eax),%edx
  8033ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033ae:	8b 40 0c             	mov    0xc(%eax),%eax
  8033b1:	01 c2                	add    %eax,%edx
  8033b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033b6:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8033b9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8033bd:	75 17                	jne    8033d6 <insert_sorted_with_merge_freeList+0x39c>
  8033bf:	83 ec 04             	sub    $0x4,%esp
  8033c2:	68 68 46 80 00       	push   $0x804668
  8033c7:	68 5c 01 00 00       	push   $0x15c
  8033cc:	68 bf 45 80 00       	push   $0x8045bf
  8033d1:	e8 dd d2 ff ff       	call   8006b3 <_panic>
  8033d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033d9:	8b 00                	mov    (%eax),%eax
  8033db:	85 c0                	test   %eax,%eax
  8033dd:	74 10                	je     8033ef <insert_sorted_with_merge_freeList+0x3b5>
  8033df:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033e2:	8b 00                	mov    (%eax),%eax
  8033e4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8033e7:	8b 52 04             	mov    0x4(%edx),%edx
  8033ea:	89 50 04             	mov    %edx,0x4(%eax)
  8033ed:	eb 0b                	jmp    8033fa <insert_sorted_with_merge_freeList+0x3c0>
  8033ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033f2:	8b 40 04             	mov    0x4(%eax),%eax
  8033f5:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8033fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033fd:	8b 40 04             	mov    0x4(%eax),%eax
  803400:	85 c0                	test   %eax,%eax
  803402:	74 0f                	je     803413 <insert_sorted_with_merge_freeList+0x3d9>
  803404:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803407:	8b 40 04             	mov    0x4(%eax),%eax
  80340a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80340d:	8b 12                	mov    (%edx),%edx
  80340f:	89 10                	mov    %edx,(%eax)
  803411:	eb 0a                	jmp    80341d <insert_sorted_with_merge_freeList+0x3e3>
  803413:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803416:	8b 00                	mov    (%eax),%eax
  803418:	a3 38 51 80 00       	mov    %eax,0x805138
  80341d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803420:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803426:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803429:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803430:	a1 44 51 80 00       	mov    0x805144,%eax
  803435:	48                   	dec    %eax
  803436:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  80343b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80343e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803445:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803448:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80344f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803453:	75 17                	jne    80346c <insert_sorted_with_merge_freeList+0x432>
  803455:	83 ec 04             	sub    $0x4,%esp
  803458:	68 9c 45 80 00       	push   $0x80459c
  80345d:	68 5f 01 00 00       	push   $0x15f
  803462:	68 bf 45 80 00       	push   $0x8045bf
  803467:	e8 47 d2 ff ff       	call   8006b3 <_panic>
  80346c:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803472:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803475:	89 10                	mov    %edx,(%eax)
  803477:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80347a:	8b 00                	mov    (%eax),%eax
  80347c:	85 c0                	test   %eax,%eax
  80347e:	74 0d                	je     80348d <insert_sorted_with_merge_freeList+0x453>
  803480:	a1 48 51 80 00       	mov    0x805148,%eax
  803485:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803488:	89 50 04             	mov    %edx,0x4(%eax)
  80348b:	eb 08                	jmp    803495 <insert_sorted_with_merge_freeList+0x45b>
  80348d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803490:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803495:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803498:	a3 48 51 80 00       	mov    %eax,0x805148
  80349d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034a0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034a7:	a1 54 51 80 00       	mov    0x805154,%eax
  8034ac:	40                   	inc    %eax
  8034ad:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  8034b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034b5:	8b 50 0c             	mov    0xc(%eax),%edx
  8034b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8034bb:	8b 40 0c             	mov    0xc(%eax),%eax
  8034be:	01 c2                	add    %eax,%edx
  8034c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034c3:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  8034c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8034c9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  8034d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8034d3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8034da:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034de:	75 17                	jne    8034f7 <insert_sorted_with_merge_freeList+0x4bd>
  8034e0:	83 ec 04             	sub    $0x4,%esp
  8034e3:	68 9c 45 80 00       	push   $0x80459c
  8034e8:	68 64 01 00 00       	push   $0x164
  8034ed:	68 bf 45 80 00       	push   $0x8045bf
  8034f2:	e8 bc d1 ff ff       	call   8006b3 <_panic>
  8034f7:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8034fd:	8b 45 08             	mov    0x8(%ebp),%eax
  803500:	89 10                	mov    %edx,(%eax)
  803502:	8b 45 08             	mov    0x8(%ebp),%eax
  803505:	8b 00                	mov    (%eax),%eax
  803507:	85 c0                	test   %eax,%eax
  803509:	74 0d                	je     803518 <insert_sorted_with_merge_freeList+0x4de>
  80350b:	a1 48 51 80 00       	mov    0x805148,%eax
  803510:	8b 55 08             	mov    0x8(%ebp),%edx
  803513:	89 50 04             	mov    %edx,0x4(%eax)
  803516:	eb 08                	jmp    803520 <insert_sorted_with_merge_freeList+0x4e6>
  803518:	8b 45 08             	mov    0x8(%ebp),%eax
  80351b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803520:	8b 45 08             	mov    0x8(%ebp),%eax
  803523:	a3 48 51 80 00       	mov    %eax,0x805148
  803528:	8b 45 08             	mov    0x8(%ebp),%eax
  80352b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803532:	a1 54 51 80 00       	mov    0x805154,%eax
  803537:	40                   	inc    %eax
  803538:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  80353d:	e9 41 02 00 00       	jmp    803783 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803542:	8b 45 08             	mov    0x8(%ebp),%eax
  803545:	8b 50 08             	mov    0x8(%eax),%edx
  803548:	8b 45 08             	mov    0x8(%ebp),%eax
  80354b:	8b 40 0c             	mov    0xc(%eax),%eax
  80354e:	01 c2                	add    %eax,%edx
  803550:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803553:	8b 40 08             	mov    0x8(%eax),%eax
  803556:	39 c2                	cmp    %eax,%edx
  803558:	0f 85 7c 01 00 00    	jne    8036da <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  80355e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803562:	74 06                	je     80356a <insert_sorted_with_merge_freeList+0x530>
  803564:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803568:	75 17                	jne    803581 <insert_sorted_with_merge_freeList+0x547>
  80356a:	83 ec 04             	sub    $0x4,%esp
  80356d:	68 d8 45 80 00       	push   $0x8045d8
  803572:	68 69 01 00 00       	push   $0x169
  803577:	68 bf 45 80 00       	push   $0x8045bf
  80357c:	e8 32 d1 ff ff       	call   8006b3 <_panic>
  803581:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803584:	8b 50 04             	mov    0x4(%eax),%edx
  803587:	8b 45 08             	mov    0x8(%ebp),%eax
  80358a:	89 50 04             	mov    %edx,0x4(%eax)
  80358d:	8b 45 08             	mov    0x8(%ebp),%eax
  803590:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803593:	89 10                	mov    %edx,(%eax)
  803595:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803598:	8b 40 04             	mov    0x4(%eax),%eax
  80359b:	85 c0                	test   %eax,%eax
  80359d:	74 0d                	je     8035ac <insert_sorted_with_merge_freeList+0x572>
  80359f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035a2:	8b 40 04             	mov    0x4(%eax),%eax
  8035a5:	8b 55 08             	mov    0x8(%ebp),%edx
  8035a8:	89 10                	mov    %edx,(%eax)
  8035aa:	eb 08                	jmp    8035b4 <insert_sorted_with_merge_freeList+0x57a>
  8035ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8035af:	a3 38 51 80 00       	mov    %eax,0x805138
  8035b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035b7:	8b 55 08             	mov    0x8(%ebp),%edx
  8035ba:	89 50 04             	mov    %edx,0x4(%eax)
  8035bd:	a1 44 51 80 00       	mov    0x805144,%eax
  8035c2:	40                   	inc    %eax
  8035c3:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  8035c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8035cb:	8b 50 0c             	mov    0xc(%eax),%edx
  8035ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035d1:	8b 40 0c             	mov    0xc(%eax),%eax
  8035d4:	01 c2                	add    %eax,%edx
  8035d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8035d9:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8035dc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8035e0:	75 17                	jne    8035f9 <insert_sorted_with_merge_freeList+0x5bf>
  8035e2:	83 ec 04             	sub    $0x4,%esp
  8035e5:	68 68 46 80 00       	push   $0x804668
  8035ea:	68 6b 01 00 00       	push   $0x16b
  8035ef:	68 bf 45 80 00       	push   $0x8045bf
  8035f4:	e8 ba d0 ff ff       	call   8006b3 <_panic>
  8035f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035fc:	8b 00                	mov    (%eax),%eax
  8035fe:	85 c0                	test   %eax,%eax
  803600:	74 10                	je     803612 <insert_sorted_with_merge_freeList+0x5d8>
  803602:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803605:	8b 00                	mov    (%eax),%eax
  803607:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80360a:	8b 52 04             	mov    0x4(%edx),%edx
  80360d:	89 50 04             	mov    %edx,0x4(%eax)
  803610:	eb 0b                	jmp    80361d <insert_sorted_with_merge_freeList+0x5e3>
  803612:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803615:	8b 40 04             	mov    0x4(%eax),%eax
  803618:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80361d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803620:	8b 40 04             	mov    0x4(%eax),%eax
  803623:	85 c0                	test   %eax,%eax
  803625:	74 0f                	je     803636 <insert_sorted_with_merge_freeList+0x5fc>
  803627:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80362a:	8b 40 04             	mov    0x4(%eax),%eax
  80362d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803630:	8b 12                	mov    (%edx),%edx
  803632:	89 10                	mov    %edx,(%eax)
  803634:	eb 0a                	jmp    803640 <insert_sorted_with_merge_freeList+0x606>
  803636:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803639:	8b 00                	mov    (%eax),%eax
  80363b:	a3 38 51 80 00       	mov    %eax,0x805138
  803640:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803643:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803649:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80364c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803653:	a1 44 51 80 00       	mov    0x805144,%eax
  803658:	48                   	dec    %eax
  803659:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  80365e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803661:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803668:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80366b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803672:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803676:	75 17                	jne    80368f <insert_sorted_with_merge_freeList+0x655>
  803678:	83 ec 04             	sub    $0x4,%esp
  80367b:	68 9c 45 80 00       	push   $0x80459c
  803680:	68 6e 01 00 00       	push   $0x16e
  803685:	68 bf 45 80 00       	push   $0x8045bf
  80368a:	e8 24 d0 ff ff       	call   8006b3 <_panic>
  80368f:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803695:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803698:	89 10                	mov    %edx,(%eax)
  80369a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80369d:	8b 00                	mov    (%eax),%eax
  80369f:	85 c0                	test   %eax,%eax
  8036a1:	74 0d                	je     8036b0 <insert_sorted_with_merge_freeList+0x676>
  8036a3:	a1 48 51 80 00       	mov    0x805148,%eax
  8036a8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8036ab:	89 50 04             	mov    %edx,0x4(%eax)
  8036ae:	eb 08                	jmp    8036b8 <insert_sorted_with_merge_freeList+0x67e>
  8036b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036b3:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8036b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036bb:	a3 48 51 80 00       	mov    %eax,0x805148
  8036c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036c3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036ca:	a1 54 51 80 00       	mov    0x805154,%eax
  8036cf:	40                   	inc    %eax
  8036d0:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8036d5:	e9 a9 00 00 00       	jmp    803783 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  8036da:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036de:	74 06                	je     8036e6 <insert_sorted_with_merge_freeList+0x6ac>
  8036e0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8036e4:	75 17                	jne    8036fd <insert_sorted_with_merge_freeList+0x6c3>
  8036e6:	83 ec 04             	sub    $0x4,%esp
  8036e9:	68 34 46 80 00       	push   $0x804634
  8036ee:	68 73 01 00 00       	push   $0x173
  8036f3:	68 bf 45 80 00       	push   $0x8045bf
  8036f8:	e8 b6 cf ff ff       	call   8006b3 <_panic>
  8036fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803700:	8b 10                	mov    (%eax),%edx
  803702:	8b 45 08             	mov    0x8(%ebp),%eax
  803705:	89 10                	mov    %edx,(%eax)
  803707:	8b 45 08             	mov    0x8(%ebp),%eax
  80370a:	8b 00                	mov    (%eax),%eax
  80370c:	85 c0                	test   %eax,%eax
  80370e:	74 0b                	je     80371b <insert_sorted_with_merge_freeList+0x6e1>
  803710:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803713:	8b 00                	mov    (%eax),%eax
  803715:	8b 55 08             	mov    0x8(%ebp),%edx
  803718:	89 50 04             	mov    %edx,0x4(%eax)
  80371b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80371e:	8b 55 08             	mov    0x8(%ebp),%edx
  803721:	89 10                	mov    %edx,(%eax)
  803723:	8b 45 08             	mov    0x8(%ebp),%eax
  803726:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803729:	89 50 04             	mov    %edx,0x4(%eax)
  80372c:	8b 45 08             	mov    0x8(%ebp),%eax
  80372f:	8b 00                	mov    (%eax),%eax
  803731:	85 c0                	test   %eax,%eax
  803733:	75 08                	jne    80373d <insert_sorted_with_merge_freeList+0x703>
  803735:	8b 45 08             	mov    0x8(%ebp),%eax
  803738:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80373d:	a1 44 51 80 00       	mov    0x805144,%eax
  803742:	40                   	inc    %eax
  803743:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803748:	eb 39                	jmp    803783 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  80374a:	a1 40 51 80 00       	mov    0x805140,%eax
  80374f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803752:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803756:	74 07                	je     80375f <insert_sorted_with_merge_freeList+0x725>
  803758:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80375b:	8b 00                	mov    (%eax),%eax
  80375d:	eb 05                	jmp    803764 <insert_sorted_with_merge_freeList+0x72a>
  80375f:	b8 00 00 00 00       	mov    $0x0,%eax
  803764:	a3 40 51 80 00       	mov    %eax,0x805140
  803769:	a1 40 51 80 00       	mov    0x805140,%eax
  80376e:	85 c0                	test   %eax,%eax
  803770:	0f 85 c7 fb ff ff    	jne    80333d <insert_sorted_with_merge_freeList+0x303>
  803776:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80377a:	0f 85 bd fb ff ff    	jne    80333d <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803780:	eb 01                	jmp    803783 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803782:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803783:	90                   	nop
  803784:	c9                   	leave  
  803785:	c3                   	ret    
  803786:	66 90                	xchg   %ax,%ax

00803788 <__udivdi3>:
  803788:	55                   	push   %ebp
  803789:	57                   	push   %edi
  80378a:	56                   	push   %esi
  80378b:	53                   	push   %ebx
  80378c:	83 ec 1c             	sub    $0x1c,%esp
  80378f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803793:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803797:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80379b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80379f:	89 ca                	mov    %ecx,%edx
  8037a1:	89 f8                	mov    %edi,%eax
  8037a3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8037a7:	85 f6                	test   %esi,%esi
  8037a9:	75 2d                	jne    8037d8 <__udivdi3+0x50>
  8037ab:	39 cf                	cmp    %ecx,%edi
  8037ad:	77 65                	ja     803814 <__udivdi3+0x8c>
  8037af:	89 fd                	mov    %edi,%ebp
  8037b1:	85 ff                	test   %edi,%edi
  8037b3:	75 0b                	jne    8037c0 <__udivdi3+0x38>
  8037b5:	b8 01 00 00 00       	mov    $0x1,%eax
  8037ba:	31 d2                	xor    %edx,%edx
  8037bc:	f7 f7                	div    %edi
  8037be:	89 c5                	mov    %eax,%ebp
  8037c0:	31 d2                	xor    %edx,%edx
  8037c2:	89 c8                	mov    %ecx,%eax
  8037c4:	f7 f5                	div    %ebp
  8037c6:	89 c1                	mov    %eax,%ecx
  8037c8:	89 d8                	mov    %ebx,%eax
  8037ca:	f7 f5                	div    %ebp
  8037cc:	89 cf                	mov    %ecx,%edi
  8037ce:	89 fa                	mov    %edi,%edx
  8037d0:	83 c4 1c             	add    $0x1c,%esp
  8037d3:	5b                   	pop    %ebx
  8037d4:	5e                   	pop    %esi
  8037d5:	5f                   	pop    %edi
  8037d6:	5d                   	pop    %ebp
  8037d7:	c3                   	ret    
  8037d8:	39 ce                	cmp    %ecx,%esi
  8037da:	77 28                	ja     803804 <__udivdi3+0x7c>
  8037dc:	0f bd fe             	bsr    %esi,%edi
  8037df:	83 f7 1f             	xor    $0x1f,%edi
  8037e2:	75 40                	jne    803824 <__udivdi3+0x9c>
  8037e4:	39 ce                	cmp    %ecx,%esi
  8037e6:	72 0a                	jb     8037f2 <__udivdi3+0x6a>
  8037e8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8037ec:	0f 87 9e 00 00 00    	ja     803890 <__udivdi3+0x108>
  8037f2:	b8 01 00 00 00       	mov    $0x1,%eax
  8037f7:	89 fa                	mov    %edi,%edx
  8037f9:	83 c4 1c             	add    $0x1c,%esp
  8037fc:	5b                   	pop    %ebx
  8037fd:	5e                   	pop    %esi
  8037fe:	5f                   	pop    %edi
  8037ff:	5d                   	pop    %ebp
  803800:	c3                   	ret    
  803801:	8d 76 00             	lea    0x0(%esi),%esi
  803804:	31 ff                	xor    %edi,%edi
  803806:	31 c0                	xor    %eax,%eax
  803808:	89 fa                	mov    %edi,%edx
  80380a:	83 c4 1c             	add    $0x1c,%esp
  80380d:	5b                   	pop    %ebx
  80380e:	5e                   	pop    %esi
  80380f:	5f                   	pop    %edi
  803810:	5d                   	pop    %ebp
  803811:	c3                   	ret    
  803812:	66 90                	xchg   %ax,%ax
  803814:	89 d8                	mov    %ebx,%eax
  803816:	f7 f7                	div    %edi
  803818:	31 ff                	xor    %edi,%edi
  80381a:	89 fa                	mov    %edi,%edx
  80381c:	83 c4 1c             	add    $0x1c,%esp
  80381f:	5b                   	pop    %ebx
  803820:	5e                   	pop    %esi
  803821:	5f                   	pop    %edi
  803822:	5d                   	pop    %ebp
  803823:	c3                   	ret    
  803824:	bd 20 00 00 00       	mov    $0x20,%ebp
  803829:	89 eb                	mov    %ebp,%ebx
  80382b:	29 fb                	sub    %edi,%ebx
  80382d:	89 f9                	mov    %edi,%ecx
  80382f:	d3 e6                	shl    %cl,%esi
  803831:	89 c5                	mov    %eax,%ebp
  803833:	88 d9                	mov    %bl,%cl
  803835:	d3 ed                	shr    %cl,%ebp
  803837:	89 e9                	mov    %ebp,%ecx
  803839:	09 f1                	or     %esi,%ecx
  80383b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80383f:	89 f9                	mov    %edi,%ecx
  803841:	d3 e0                	shl    %cl,%eax
  803843:	89 c5                	mov    %eax,%ebp
  803845:	89 d6                	mov    %edx,%esi
  803847:	88 d9                	mov    %bl,%cl
  803849:	d3 ee                	shr    %cl,%esi
  80384b:	89 f9                	mov    %edi,%ecx
  80384d:	d3 e2                	shl    %cl,%edx
  80384f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803853:	88 d9                	mov    %bl,%cl
  803855:	d3 e8                	shr    %cl,%eax
  803857:	09 c2                	or     %eax,%edx
  803859:	89 d0                	mov    %edx,%eax
  80385b:	89 f2                	mov    %esi,%edx
  80385d:	f7 74 24 0c          	divl   0xc(%esp)
  803861:	89 d6                	mov    %edx,%esi
  803863:	89 c3                	mov    %eax,%ebx
  803865:	f7 e5                	mul    %ebp
  803867:	39 d6                	cmp    %edx,%esi
  803869:	72 19                	jb     803884 <__udivdi3+0xfc>
  80386b:	74 0b                	je     803878 <__udivdi3+0xf0>
  80386d:	89 d8                	mov    %ebx,%eax
  80386f:	31 ff                	xor    %edi,%edi
  803871:	e9 58 ff ff ff       	jmp    8037ce <__udivdi3+0x46>
  803876:	66 90                	xchg   %ax,%ax
  803878:	8b 54 24 08          	mov    0x8(%esp),%edx
  80387c:	89 f9                	mov    %edi,%ecx
  80387e:	d3 e2                	shl    %cl,%edx
  803880:	39 c2                	cmp    %eax,%edx
  803882:	73 e9                	jae    80386d <__udivdi3+0xe5>
  803884:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803887:	31 ff                	xor    %edi,%edi
  803889:	e9 40 ff ff ff       	jmp    8037ce <__udivdi3+0x46>
  80388e:	66 90                	xchg   %ax,%ax
  803890:	31 c0                	xor    %eax,%eax
  803892:	e9 37 ff ff ff       	jmp    8037ce <__udivdi3+0x46>
  803897:	90                   	nop

00803898 <__umoddi3>:
  803898:	55                   	push   %ebp
  803899:	57                   	push   %edi
  80389a:	56                   	push   %esi
  80389b:	53                   	push   %ebx
  80389c:	83 ec 1c             	sub    $0x1c,%esp
  80389f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8038a3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8038a7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8038ab:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8038af:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8038b3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8038b7:	89 f3                	mov    %esi,%ebx
  8038b9:	89 fa                	mov    %edi,%edx
  8038bb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8038bf:	89 34 24             	mov    %esi,(%esp)
  8038c2:	85 c0                	test   %eax,%eax
  8038c4:	75 1a                	jne    8038e0 <__umoddi3+0x48>
  8038c6:	39 f7                	cmp    %esi,%edi
  8038c8:	0f 86 a2 00 00 00    	jbe    803970 <__umoddi3+0xd8>
  8038ce:	89 c8                	mov    %ecx,%eax
  8038d0:	89 f2                	mov    %esi,%edx
  8038d2:	f7 f7                	div    %edi
  8038d4:	89 d0                	mov    %edx,%eax
  8038d6:	31 d2                	xor    %edx,%edx
  8038d8:	83 c4 1c             	add    $0x1c,%esp
  8038db:	5b                   	pop    %ebx
  8038dc:	5e                   	pop    %esi
  8038dd:	5f                   	pop    %edi
  8038de:	5d                   	pop    %ebp
  8038df:	c3                   	ret    
  8038e0:	39 f0                	cmp    %esi,%eax
  8038e2:	0f 87 ac 00 00 00    	ja     803994 <__umoddi3+0xfc>
  8038e8:	0f bd e8             	bsr    %eax,%ebp
  8038eb:	83 f5 1f             	xor    $0x1f,%ebp
  8038ee:	0f 84 ac 00 00 00    	je     8039a0 <__umoddi3+0x108>
  8038f4:	bf 20 00 00 00       	mov    $0x20,%edi
  8038f9:	29 ef                	sub    %ebp,%edi
  8038fb:	89 fe                	mov    %edi,%esi
  8038fd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803901:	89 e9                	mov    %ebp,%ecx
  803903:	d3 e0                	shl    %cl,%eax
  803905:	89 d7                	mov    %edx,%edi
  803907:	89 f1                	mov    %esi,%ecx
  803909:	d3 ef                	shr    %cl,%edi
  80390b:	09 c7                	or     %eax,%edi
  80390d:	89 e9                	mov    %ebp,%ecx
  80390f:	d3 e2                	shl    %cl,%edx
  803911:	89 14 24             	mov    %edx,(%esp)
  803914:	89 d8                	mov    %ebx,%eax
  803916:	d3 e0                	shl    %cl,%eax
  803918:	89 c2                	mov    %eax,%edx
  80391a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80391e:	d3 e0                	shl    %cl,%eax
  803920:	89 44 24 04          	mov    %eax,0x4(%esp)
  803924:	8b 44 24 08          	mov    0x8(%esp),%eax
  803928:	89 f1                	mov    %esi,%ecx
  80392a:	d3 e8                	shr    %cl,%eax
  80392c:	09 d0                	or     %edx,%eax
  80392e:	d3 eb                	shr    %cl,%ebx
  803930:	89 da                	mov    %ebx,%edx
  803932:	f7 f7                	div    %edi
  803934:	89 d3                	mov    %edx,%ebx
  803936:	f7 24 24             	mull   (%esp)
  803939:	89 c6                	mov    %eax,%esi
  80393b:	89 d1                	mov    %edx,%ecx
  80393d:	39 d3                	cmp    %edx,%ebx
  80393f:	0f 82 87 00 00 00    	jb     8039cc <__umoddi3+0x134>
  803945:	0f 84 91 00 00 00    	je     8039dc <__umoddi3+0x144>
  80394b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80394f:	29 f2                	sub    %esi,%edx
  803951:	19 cb                	sbb    %ecx,%ebx
  803953:	89 d8                	mov    %ebx,%eax
  803955:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803959:	d3 e0                	shl    %cl,%eax
  80395b:	89 e9                	mov    %ebp,%ecx
  80395d:	d3 ea                	shr    %cl,%edx
  80395f:	09 d0                	or     %edx,%eax
  803961:	89 e9                	mov    %ebp,%ecx
  803963:	d3 eb                	shr    %cl,%ebx
  803965:	89 da                	mov    %ebx,%edx
  803967:	83 c4 1c             	add    $0x1c,%esp
  80396a:	5b                   	pop    %ebx
  80396b:	5e                   	pop    %esi
  80396c:	5f                   	pop    %edi
  80396d:	5d                   	pop    %ebp
  80396e:	c3                   	ret    
  80396f:	90                   	nop
  803970:	89 fd                	mov    %edi,%ebp
  803972:	85 ff                	test   %edi,%edi
  803974:	75 0b                	jne    803981 <__umoddi3+0xe9>
  803976:	b8 01 00 00 00       	mov    $0x1,%eax
  80397b:	31 d2                	xor    %edx,%edx
  80397d:	f7 f7                	div    %edi
  80397f:	89 c5                	mov    %eax,%ebp
  803981:	89 f0                	mov    %esi,%eax
  803983:	31 d2                	xor    %edx,%edx
  803985:	f7 f5                	div    %ebp
  803987:	89 c8                	mov    %ecx,%eax
  803989:	f7 f5                	div    %ebp
  80398b:	89 d0                	mov    %edx,%eax
  80398d:	e9 44 ff ff ff       	jmp    8038d6 <__umoddi3+0x3e>
  803992:	66 90                	xchg   %ax,%ax
  803994:	89 c8                	mov    %ecx,%eax
  803996:	89 f2                	mov    %esi,%edx
  803998:	83 c4 1c             	add    $0x1c,%esp
  80399b:	5b                   	pop    %ebx
  80399c:	5e                   	pop    %esi
  80399d:	5f                   	pop    %edi
  80399e:	5d                   	pop    %ebp
  80399f:	c3                   	ret    
  8039a0:	3b 04 24             	cmp    (%esp),%eax
  8039a3:	72 06                	jb     8039ab <__umoddi3+0x113>
  8039a5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8039a9:	77 0f                	ja     8039ba <__umoddi3+0x122>
  8039ab:	89 f2                	mov    %esi,%edx
  8039ad:	29 f9                	sub    %edi,%ecx
  8039af:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8039b3:	89 14 24             	mov    %edx,(%esp)
  8039b6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8039ba:	8b 44 24 04          	mov    0x4(%esp),%eax
  8039be:	8b 14 24             	mov    (%esp),%edx
  8039c1:	83 c4 1c             	add    $0x1c,%esp
  8039c4:	5b                   	pop    %ebx
  8039c5:	5e                   	pop    %esi
  8039c6:	5f                   	pop    %edi
  8039c7:	5d                   	pop    %ebp
  8039c8:	c3                   	ret    
  8039c9:	8d 76 00             	lea    0x0(%esi),%esi
  8039cc:	2b 04 24             	sub    (%esp),%eax
  8039cf:	19 fa                	sbb    %edi,%edx
  8039d1:	89 d1                	mov    %edx,%ecx
  8039d3:	89 c6                	mov    %eax,%esi
  8039d5:	e9 71 ff ff ff       	jmp    80394b <__umoddi3+0xb3>
  8039da:	66 90                	xchg   %ax,%ax
  8039dc:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8039e0:	72 ea                	jb     8039cc <__umoddi3+0x134>
  8039e2:	89 d9                	mov    %ebx,%ecx
  8039e4:	e9 62 ff ff ff       	jmp    80394b <__umoddi3+0xb3>
