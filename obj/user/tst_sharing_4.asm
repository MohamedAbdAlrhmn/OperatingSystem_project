
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
  80008d:	68 a0 39 80 00       	push   $0x8039a0
  800092:	6a 12                	push   $0x12
  800094:	68 bc 39 80 00       	push   $0x8039bc
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
  8000ae:	68 d4 39 80 00       	push   $0x8039d4
  8000b3:	e8 af 08 00 00       	call   800967 <cprintf>
  8000b8:	83 c4 10             	add    $0x10,%esp
	cprintf("MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  8000bb:	83 ec 0c             	sub    $0xc,%esp
  8000be:	68 08 3a 80 00       	push   $0x803a08
  8000c3:	e8 9f 08 00 00       	call   800967 <cprintf>
  8000c8:	83 c4 10             	add    $0x10,%esp
	cprintf("************************************************\n\n\n");
  8000cb:	83 ec 0c             	sub    $0xc,%esp
  8000ce:	68 64 3a 80 00       	push   $0x803a64
  8000d3:	e8 8f 08 00 00       	call   800967 <cprintf>
  8000d8:	83 c4 10             	add    $0x10,%esp

	int Mega = 1024*1024;
  8000db:	c7 45 ec 00 00 10 00 	movl   $0x100000,-0x14(%ebp)
	int kilo = 1024;
  8000e2:	c7 45 e8 00 04 00 00 	movl   $0x400,-0x18(%ebp)
	int envID = sys_getenvid();
  8000e9:	e8 50 1d 00 00       	call   801e3e <sys_getenvid>
  8000ee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	cprintf("STEP A: checking free of a shared object ... \n");
  8000f1:	83 ec 0c             	sub    $0xc,%esp
  8000f4:	68 98 3a 80 00       	push   $0x803a98
  8000f9:	e8 69 08 00 00       	call   800967 <cprintf>
  8000fe:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x;
		int freeFrames = sys_calculate_free_frames() ;
  800101:	e8 71 1a 00 00       	call   801b77 <sys_calculate_free_frames>
  800106:	89 45 e0             	mov    %eax,-0x20(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  800109:	83 ec 04             	sub    $0x4,%esp
  80010c:	6a 01                	push   $0x1
  80010e:	68 00 10 00 00       	push   $0x1000
  800113:	68 c7 3a 80 00       	push   $0x803ac7
  800118:	e8 1a 18 00 00       	call   801937 <smalloc>
  80011d:	83 c4 10             	add    $0x10,%esp
  800120:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (x != (uint32*)USER_HEAP_START) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  800123:	81 7d dc 00 00 00 80 	cmpl   $0x80000000,-0x24(%ebp)
  80012a:	74 14                	je     800140 <_main+0x108>
  80012c:	83 ec 04             	sub    $0x4,%esp
  80012f:	68 cc 3a 80 00       	push   $0x803acc
  800134:	6a 24                	push   $0x24
  800136:	68 bc 39 80 00       	push   $0x8039bc
  80013b:	e8 73 05 00 00       	call   8006b3 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800140:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800143:	e8 2f 1a 00 00       	call   801b77 <sys_calculate_free_frames>
  800148:	29 c3                	sub    %eax,%ebx
  80014a:	89 d8                	mov    %ebx,%eax
  80014c:	83 f8 04             	cmp    $0x4,%eax
  80014f:	74 14                	je     800165 <_main+0x12d>
  800151:	83 ec 04             	sub    $0x4,%esp
  800154:	68 38 3b 80 00       	push   $0x803b38
  800159:	6a 25                	push   $0x25
  80015b:	68 bc 39 80 00       	push   $0x8039bc
  800160:	e8 4e 05 00 00       	call   8006b3 <_panic>

		sfree(x);
  800165:	83 ec 0c             	sub    $0xc,%esp
  800168:	ff 75 dc             	pushl  -0x24(%ebp)
  80016b:	e8 a7 18 00 00       	call   801a17 <sfree>
  800170:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) ==  0+0+2) panic("Wrong free: make sure that you free the shared object by calling free_share_object()");
  800173:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800176:	e8 fc 19 00 00       	call   801b77 <sys_calculate_free_frames>
  80017b:	29 c3                	sub    %eax,%ebx
  80017d:	89 d8                	mov    %ebx,%eax
  80017f:	83 f8 02             	cmp    $0x2,%eax
  800182:	75 14                	jne    800198 <_main+0x160>
  800184:	83 ec 04             	sub    $0x4,%esp
  800187:	68 b8 3b 80 00       	push   $0x803bb8
  80018c:	6a 28                	push   $0x28
  80018e:	68 bc 39 80 00       	push   $0x8039bc
  800193:	e8 1b 05 00 00       	call   8006b3 <_panic>
		else if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong free: revise your freeSharedObject logic");
  800198:	e8 da 19 00 00       	call   801b77 <sys_calculate_free_frames>
  80019d:	89 c2                	mov    %eax,%edx
  80019f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001a2:	39 c2                	cmp    %eax,%edx
  8001a4:	74 14                	je     8001ba <_main+0x182>
  8001a6:	83 ec 04             	sub    $0x4,%esp
  8001a9:	68 10 3c 80 00       	push   $0x803c10
  8001ae:	6a 29                	push   $0x29
  8001b0:	68 bc 39 80 00       	push   $0x8039bc
  8001b5:	e8 f9 04 00 00       	call   8006b3 <_panic>
	}
	cprintf("Step A completed successfully!!\n\n\n");
  8001ba:	83 ec 0c             	sub    $0xc,%esp
  8001bd:	68 40 3c 80 00       	push   $0x803c40
  8001c2:	e8 a0 07 00 00       	call   800967 <cprintf>
  8001c7:	83 c4 10             	add    $0x10,%esp


	cprintf("STEP B: checking free of 2 shared objects ... \n");
  8001ca:	83 ec 0c             	sub    $0xc,%esp
  8001cd:	68 64 3c 80 00       	push   $0x803c64
  8001d2:	e8 90 07 00 00       	call   800967 <cprintf>
  8001d7:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x, *z ;
		int freeFrames = sys_calculate_free_frames() ;
  8001da:	e8 98 19 00 00       	call   801b77 <sys_calculate_free_frames>
  8001df:	89 45 d8             	mov    %eax,-0x28(%ebp)
		z = smalloc("z", PAGE_SIZE, 1);
  8001e2:	83 ec 04             	sub    $0x4,%esp
  8001e5:	6a 01                	push   $0x1
  8001e7:	68 00 10 00 00       	push   $0x1000
  8001ec:	68 94 3c 80 00       	push   $0x803c94
  8001f1:	e8 41 17 00 00       	call   801937 <smalloc>
  8001f6:	83 c4 10             	add    $0x10,%esp
  8001f9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8001fc:	83 ec 04             	sub    $0x4,%esp
  8001ff:	6a 01                	push   $0x1
  800201:	68 00 10 00 00       	push   $0x1000
  800206:	68 c7 3a 80 00       	push   $0x803ac7
  80020b:	e8 27 17 00 00       	call   801937 <smalloc>
  800210:	83 c4 10             	add    $0x10,%esp
  800213:	89 45 d0             	mov    %eax,-0x30(%ebp)

		if(x == NULL) panic("Wrong free: make sure that you free the shared object by calling free_share_object()");
  800216:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80021a:	75 14                	jne    800230 <_main+0x1f8>
  80021c:	83 ec 04             	sub    $0x4,%esp
  80021f:	68 b8 3b 80 00       	push   $0x803bb8
  800224:	6a 35                	push   $0x35
  800226:	68 bc 39 80 00       	push   $0x8039bc
  80022b:	e8 83 04 00 00       	call   8006b3 <_panic>

		if ((freeFrames - sys_calculate_free_frames()) !=  2+1+4) panic("Wrong previous free: make sure that you correctly free shared object before (Step A)");
  800230:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800233:	e8 3f 19 00 00       	call   801b77 <sys_calculate_free_frames>
  800238:	29 c3                	sub    %eax,%ebx
  80023a:	89 d8                	mov    %ebx,%eax
  80023c:	83 f8 07             	cmp    $0x7,%eax
  80023f:	74 14                	je     800255 <_main+0x21d>
  800241:	83 ec 04             	sub    $0x4,%esp
  800244:	68 98 3c 80 00       	push   $0x803c98
  800249:	6a 37                	push   $0x37
  80024b:	68 bc 39 80 00       	push   $0x8039bc
  800250:	e8 5e 04 00 00       	call   8006b3 <_panic>

		sfree(z);
  800255:	83 ec 0c             	sub    $0xc,%esp
  800258:	ff 75 d4             	pushl  -0x2c(%ebp)
  80025b:	e8 b7 17 00 00       	call   801a17 <sfree>
  800260:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong free: check your logic");
  800263:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800266:	e8 0c 19 00 00       	call   801b77 <sys_calculate_free_frames>
  80026b:	29 c3                	sub    %eax,%ebx
  80026d:	89 d8                	mov    %ebx,%eax
  80026f:	83 f8 04             	cmp    $0x4,%eax
  800272:	74 14                	je     800288 <_main+0x250>
  800274:	83 ec 04             	sub    $0x4,%esp
  800277:	68 ed 3c 80 00       	push   $0x803ced
  80027c:	6a 3a                	push   $0x3a
  80027e:	68 bc 39 80 00       	push   $0x8039bc
  800283:	e8 2b 04 00 00       	call   8006b3 <_panic>

		sfree(x);
  800288:	83 ec 0c             	sub    $0xc,%esp
  80028b:	ff 75 d0             	pushl  -0x30(%ebp)
  80028e:	e8 84 17 00 00       	call   801a17 <sfree>
  800293:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong free: check your logic");
  800296:	e8 dc 18 00 00       	call   801b77 <sys_calculate_free_frames>
  80029b:	89 c2                	mov    %eax,%edx
  80029d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8002a0:	39 c2                	cmp    %eax,%edx
  8002a2:	74 14                	je     8002b8 <_main+0x280>
  8002a4:	83 ec 04             	sub    $0x4,%esp
  8002a7:	68 ed 3c 80 00       	push   $0x803ced
  8002ac:	6a 3d                	push   $0x3d
  8002ae:	68 bc 39 80 00       	push   $0x8039bc
  8002b3:	e8 fb 03 00 00       	call   8006b3 <_panic>

	}
	cprintf("Step B completed successfully!!\n\n\n");
  8002b8:	83 ec 0c             	sub    $0xc,%esp
  8002bb:	68 0c 3d 80 00       	push   $0x803d0c
  8002c0:	e8 a2 06 00 00       	call   800967 <cprintf>
  8002c5:	83 c4 10             	add    $0x10,%esp

	cprintf("STEP C: checking range of loop during free... \n");
  8002c8:	83 ec 0c             	sub    $0xc,%esp
  8002cb:	68 30 3d 80 00       	push   $0x803d30
  8002d0:	e8 92 06 00 00       	call   800967 <cprintf>
  8002d5:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *w, *u;
		int freeFrames = sys_calculate_free_frames() ;
  8002d8:	e8 9a 18 00 00       	call   801b77 <sys_calculate_free_frames>
  8002dd:	89 45 cc             	mov    %eax,-0x34(%ebp)
		w = smalloc("w", 3 * PAGE_SIZE+1, 1);
  8002e0:	83 ec 04             	sub    $0x4,%esp
  8002e3:	6a 01                	push   $0x1
  8002e5:	68 01 30 00 00       	push   $0x3001
  8002ea:	68 60 3d 80 00       	push   $0x803d60
  8002ef:	e8 43 16 00 00       	call   801937 <smalloc>
  8002f4:	83 c4 10             	add    $0x10,%esp
  8002f7:	89 45 c8             	mov    %eax,-0x38(%ebp)
		u = smalloc("u", PAGE_SIZE, 1);
  8002fa:	83 ec 04             	sub    $0x4,%esp
  8002fd:	6a 01                	push   $0x1
  8002ff:	68 00 10 00 00       	push   $0x1000
  800304:	68 62 3d 80 00       	push   $0x803d62
  800309:	e8 29 16 00 00       	call   801937 <smalloc>
  80030e:	83 c4 10             	add    $0x10,%esp
  800311:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		if ((freeFrames - sys_calculate_free_frames()) != 5+1+4) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800314:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800317:	e8 5b 18 00 00       	call   801b77 <sys_calculate_free_frames>
  80031c:	29 c3                	sub    %eax,%ebx
  80031e:	89 d8                	mov    %ebx,%eax
  800320:	83 f8 0a             	cmp    $0xa,%eax
  800323:	74 14                	je     800339 <_main+0x301>
  800325:	83 ec 04             	sub    $0x4,%esp
  800328:	68 38 3b 80 00       	push   $0x803b38
  80032d:	6a 48                	push   $0x48
  80032f:	68 bc 39 80 00       	push   $0x8039bc
  800334:	e8 7a 03 00 00       	call   8006b3 <_panic>

		sfree(w);
  800339:	83 ec 0c             	sub    $0xc,%esp
  80033c:	ff 75 c8             	pushl  -0x38(%ebp)
  80033f:	e8 d3 16 00 00       	call   801a17 <sfree>
  800344:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong free: check your logic");
  800347:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  80034a:	e8 28 18 00 00       	call   801b77 <sys_calculate_free_frames>
  80034f:	29 c3                	sub    %eax,%ebx
  800351:	89 d8                	mov    %ebx,%eax
  800353:	83 f8 04             	cmp    $0x4,%eax
  800356:	74 14                	je     80036c <_main+0x334>
  800358:	83 ec 04             	sub    $0x4,%esp
  80035b:	68 ed 3c 80 00       	push   $0x803ced
  800360:	6a 4b                	push   $0x4b
  800362:	68 bc 39 80 00       	push   $0x8039bc
  800367:	e8 47 03 00 00       	call   8006b3 <_panic>

		uint32 *o;

		o = smalloc("o", 2 * PAGE_SIZE-1,1);
  80036c:	83 ec 04             	sub    $0x4,%esp
  80036f:	6a 01                	push   $0x1
  800371:	68 ff 1f 00 00       	push   $0x1fff
  800376:	68 64 3d 80 00       	push   $0x803d64
  80037b:	e8 b7 15 00 00       	call   801937 <smalloc>
  800380:	83 c4 10             	add    $0x10,%esp
  800383:	89 45 c0             	mov    %eax,-0x40(%ebp)

		cprintf("2\n");
  800386:	83 ec 0c             	sub    $0xc,%esp
  800389:	68 66 3d 80 00       	push   $0x803d66
  80038e:	e8 d4 05 00 00       	call   800967 <cprintf>
  800393:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) != 3+1+4) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800396:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800399:	e8 d9 17 00 00       	call   801b77 <sys_calculate_free_frames>
  80039e:	29 c3                	sub    %eax,%ebx
  8003a0:	89 d8                	mov    %ebx,%eax
  8003a2:	83 f8 08             	cmp    $0x8,%eax
  8003a5:	74 14                	je     8003bb <_main+0x383>
  8003a7:	83 ec 04             	sub    $0x4,%esp
  8003aa:	68 38 3b 80 00       	push   $0x803b38
  8003af:	6a 52                	push   $0x52
  8003b1:	68 bc 39 80 00       	push   $0x8039bc
  8003b6:	e8 f8 02 00 00       	call   8006b3 <_panic>

		sfree(o);
  8003bb:	83 ec 0c             	sub    $0xc,%esp
  8003be:	ff 75 c0             	pushl  -0x40(%ebp)
  8003c1:	e8 51 16 00 00       	call   801a17 <sfree>
  8003c6:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong free: check your logic");
  8003c9:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8003cc:	e8 a6 17 00 00       	call   801b77 <sys_calculate_free_frames>
  8003d1:	29 c3                	sub    %eax,%ebx
  8003d3:	89 d8                	mov    %ebx,%eax
  8003d5:	83 f8 04             	cmp    $0x4,%eax
  8003d8:	74 14                	je     8003ee <_main+0x3b6>
  8003da:	83 ec 04             	sub    $0x4,%esp
  8003dd:	68 ed 3c 80 00       	push   $0x803ced
  8003e2:	6a 55                	push   $0x55
  8003e4:	68 bc 39 80 00       	push   $0x8039bc
  8003e9:	e8 c5 02 00 00       	call   8006b3 <_panic>

		sfree(u);
  8003ee:	83 ec 0c             	sub    $0xc,%esp
  8003f1:	ff 75 c4             	pushl  -0x3c(%ebp)
  8003f4:	e8 1e 16 00 00       	call   801a17 <sfree>
  8003f9:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong free: check your logic");
  8003fc:	e8 76 17 00 00       	call   801b77 <sys_calculate_free_frames>
  800401:	89 c2                	mov    %eax,%edx
  800403:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800406:	39 c2                	cmp    %eax,%edx
  800408:	74 14                	je     80041e <_main+0x3e6>
  80040a:	83 ec 04             	sub    $0x4,%esp
  80040d:	68 ed 3c 80 00       	push   $0x803ced
  800412:	6a 58                	push   $0x58
  800414:	68 bc 39 80 00       	push   $0x8039bc
  800419:	e8 95 02 00 00       	call   8006b3 <_panic>


		//Checking boundaries of page tables
		freeFrames = sys_calculate_free_frames() ;
  80041e:	e8 54 17 00 00       	call   801b77 <sys_calculate_free_frames>
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
  800438:	68 60 3d 80 00       	push   $0x803d60
  80043d:	e8 f5 14 00 00       	call   801937 <smalloc>
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
  80045e:	68 62 3d 80 00       	push   $0x803d62
  800463:	e8 cf 14 00 00       	call   801937 <smalloc>
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
  800480:	68 64 3d 80 00       	push   $0x803d64
  800485:	e8 ad 14 00 00       	call   801937 <smalloc>
  80048a:	83 c4 10             	add    $0x10,%esp
  80048d:	89 45 c0             	mov    %eax,-0x40(%ebp)

		if ((freeFrames - sys_calculate_free_frames()) != 3073+4+7) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800490:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800493:	e8 df 16 00 00       	call   801b77 <sys_calculate_free_frames>
  800498:	29 c3                	sub    %eax,%ebx
  80049a:	89 d8                	mov    %ebx,%eax
  80049c:	3d 0c 0c 00 00       	cmp    $0xc0c,%eax
  8004a1:	74 14                	je     8004b7 <_main+0x47f>
  8004a3:	83 ec 04             	sub    $0x4,%esp
  8004a6:	68 38 3b 80 00       	push   $0x803b38
  8004ab:	6a 61                	push   $0x61
  8004ad:	68 bc 39 80 00       	push   $0x8039bc
  8004b2:	e8 fc 01 00 00       	call   8006b3 <_panic>

		sfree(o);
  8004b7:	83 ec 0c             	sub    $0xc,%esp
  8004ba:	ff 75 c0             	pushl  -0x40(%ebp)
  8004bd:	e8 55 15 00 00       	call   801a17 <sfree>
  8004c2:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  2560+3+5) panic("Wrong free: check your logic");
  8004c5:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8004c8:	e8 aa 16 00 00       	call   801b77 <sys_calculate_free_frames>
  8004cd:	29 c3                	sub    %eax,%ebx
  8004cf:	89 d8                	mov    %ebx,%eax
  8004d1:	3d 08 0a 00 00       	cmp    $0xa08,%eax
  8004d6:	74 14                	je     8004ec <_main+0x4b4>
  8004d8:	83 ec 04             	sub    $0x4,%esp
  8004db:	68 ed 3c 80 00       	push   $0x803ced
  8004e0:	6a 64                	push   $0x64
  8004e2:	68 bc 39 80 00       	push   $0x8039bc
  8004e7:	e8 c7 01 00 00       	call   8006b3 <_panic>

		sfree(w);
  8004ec:	83 ec 0c             	sub    $0xc,%esp
  8004ef:	ff 75 c8             	pushl  -0x38(%ebp)
  8004f2:	e8 20 15 00 00       	call   801a17 <sfree>
  8004f7:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  1792+3+3) panic("Wrong free: check your logic");
  8004fa:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8004fd:	e8 75 16 00 00       	call   801b77 <sys_calculate_free_frames>
  800502:	29 c3                	sub    %eax,%ebx
  800504:	89 d8                	mov    %ebx,%eax
  800506:	3d 06 07 00 00       	cmp    $0x706,%eax
  80050b:	74 14                	je     800521 <_main+0x4e9>
  80050d:	83 ec 04             	sub    $0x4,%esp
  800510:	68 ed 3c 80 00       	push   $0x803ced
  800515:	6a 67                	push   $0x67
  800517:	68 bc 39 80 00       	push   $0x8039bc
  80051c:	e8 92 01 00 00       	call   8006b3 <_panic>

		sfree(u);
  800521:	83 ec 0c             	sub    $0xc,%esp
  800524:	ff 75 c4             	pushl  -0x3c(%ebp)
  800527:	e8 eb 14 00 00       	call   801a17 <sfree>
  80052c:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong free: check your logic");
  80052f:	e8 43 16 00 00       	call   801b77 <sys_calculate_free_frames>
  800534:	89 c2                	mov    %eax,%edx
  800536:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800539:	39 c2                	cmp    %eax,%edx
  80053b:	74 14                	je     800551 <_main+0x519>
  80053d:	83 ec 04             	sub    $0x4,%esp
  800540:	68 ed 3c 80 00       	push   $0x803ced
  800545:	6a 6a                	push   $0x6a
  800547:	68 bc 39 80 00       	push   $0x8039bc
  80054c:	e8 62 01 00 00       	call   8006b3 <_panic>
	}
	cprintf("Step C completed successfully!!\n\n\n");
  800551:	83 ec 0c             	sub    $0xc,%esp
  800554:	68 6c 3d 80 00       	push   $0x803d6c
  800559:	e8 09 04 00 00       	call   800967 <cprintf>
  80055e:	83 c4 10             	add    $0x10,%esp

	cprintf("Congratulations!! Test of freeSharedObjects [4] completed successfully!!\n\n\n");
  800561:	83 ec 0c             	sub    $0xc,%esp
  800564:	68 90 3d 80 00       	push   $0x803d90
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
  80057d:	e8 d5 18 00 00       	call   801e57 <sys_getenvindex>
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
  8005e8:	e8 77 16 00 00       	call   801c64 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8005ed:	83 ec 0c             	sub    $0xc,%esp
  8005f0:	68 f4 3d 80 00       	push   $0x803df4
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
  800618:	68 1c 3e 80 00       	push   $0x803e1c
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
  800649:	68 44 3e 80 00       	push   $0x803e44
  80064e:	e8 14 03 00 00       	call   800967 <cprintf>
  800653:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800656:	a1 20 50 80 00       	mov    0x805020,%eax
  80065b:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800661:	83 ec 08             	sub    $0x8,%esp
  800664:	50                   	push   %eax
  800665:	68 9c 3e 80 00       	push   $0x803e9c
  80066a:	e8 f8 02 00 00       	call   800967 <cprintf>
  80066f:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800672:	83 ec 0c             	sub    $0xc,%esp
  800675:	68 f4 3d 80 00       	push   $0x803df4
  80067a:	e8 e8 02 00 00       	call   800967 <cprintf>
  80067f:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800682:	e8 f7 15 00 00       	call   801c7e <sys_enable_interrupt>

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
  80069a:	e8 84 17 00 00       	call   801e23 <sys_destroy_env>
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
  8006ab:	e8 d9 17 00 00       	call   801e89 <sys_exit_env>
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
  8006d4:	68 b0 3e 80 00       	push   $0x803eb0
  8006d9:	e8 89 02 00 00       	call   800967 <cprintf>
  8006de:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8006e1:	a1 00 50 80 00       	mov    0x805000,%eax
  8006e6:	ff 75 0c             	pushl  0xc(%ebp)
  8006e9:	ff 75 08             	pushl  0x8(%ebp)
  8006ec:	50                   	push   %eax
  8006ed:	68 b5 3e 80 00       	push   $0x803eb5
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
  800711:	68 d1 3e 80 00       	push   $0x803ed1
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
  80073d:	68 d4 3e 80 00       	push   $0x803ed4
  800742:	6a 26                	push   $0x26
  800744:	68 20 3f 80 00       	push   $0x803f20
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
  80080f:	68 2c 3f 80 00       	push   $0x803f2c
  800814:	6a 3a                	push   $0x3a
  800816:	68 20 3f 80 00       	push   $0x803f20
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
  80087f:	68 80 3f 80 00       	push   $0x803f80
  800884:	6a 44                	push   $0x44
  800886:	68 20 3f 80 00       	push   $0x803f20
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
  8008d9:	e8 d8 11 00 00       	call   801ab6 <sys_cputs>
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
  800950:	e8 61 11 00 00       	call   801ab6 <sys_cputs>
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
  80099a:	e8 c5 12 00 00       	call   801c64 <sys_disable_interrupt>
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
  8009ba:	e8 bf 12 00 00       	call   801c7e <sys_enable_interrupt>
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
  800a04:	e8 33 2d 00 00       	call   80373c <__udivdi3>
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
  800a54:	e8 f3 2d 00 00       	call   80384c <__umoddi3>
  800a59:	83 c4 10             	add    $0x10,%esp
  800a5c:	05 f4 41 80 00       	add    $0x8041f4,%eax
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
  800baf:	8b 04 85 18 42 80 00 	mov    0x804218(,%eax,4),%eax
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
  800c90:	8b 34 9d 60 40 80 00 	mov    0x804060(,%ebx,4),%esi
  800c97:	85 f6                	test   %esi,%esi
  800c99:	75 19                	jne    800cb4 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800c9b:	53                   	push   %ebx
  800c9c:	68 05 42 80 00       	push   $0x804205
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
  800cb5:	68 0e 42 80 00       	push   $0x80420e
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
  800ce2:	be 11 42 80 00       	mov    $0x804211,%esi
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
  801708:	68 70 43 80 00       	push   $0x804370
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
  8017d8:	e8 1d 04 00 00       	call   801bfa <sys_allocate_chunk>
  8017dd:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8017e0:	a1 20 51 80 00       	mov    0x805120,%eax
  8017e5:	83 ec 0c             	sub    $0xc,%esp
  8017e8:	50                   	push   %eax
  8017e9:	e8 92 0a 00 00       	call   802280 <initialize_MemBlocksList>
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
  801816:	68 95 43 80 00       	push   $0x804395
  80181b:	6a 33                	push   $0x33
  80181d:	68 b3 43 80 00       	push   $0x8043b3
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
  801895:	68 c0 43 80 00       	push   $0x8043c0
  80189a:	6a 34                	push   $0x34
  80189c:	68 b3 43 80 00       	push   $0x8043b3
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
  8018f2:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8018f5:	e8 f7 fd ff ff       	call   8016f1 <InitializeUHeap>
	if (size == 0) return NULL ;
  8018fa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8018fe:	75 07                	jne    801907 <malloc+0x18>
  801900:	b8 00 00 00 00       	mov    $0x0,%eax
  801905:	eb 14                	jmp    80191b <malloc+0x2c>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  801907:	83 ec 04             	sub    $0x4,%esp
  80190a:	68 e4 43 80 00       	push   $0x8043e4
  80190f:	6a 46                	push   $0x46
  801911:	68 b3 43 80 00       	push   $0x8043b3
  801916:	e8 98 ed ff ff       	call   8006b3 <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  80191b:	c9                   	leave  
  80191c:	c3                   	ret    

0080191d <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  80191d:	55                   	push   %ebp
  80191e:	89 e5                	mov    %esp,%ebp
  801920:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801923:	83 ec 04             	sub    $0x4,%esp
  801926:	68 0c 44 80 00       	push   $0x80440c
  80192b:	6a 61                	push   $0x61
  80192d:	68 b3 43 80 00       	push   $0x8043b3
  801932:	e8 7c ed ff ff       	call   8006b3 <_panic>

00801937 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801937:	55                   	push   %ebp
  801938:	89 e5                	mov    %esp,%ebp
  80193a:	83 ec 38             	sub    $0x38,%esp
  80193d:	8b 45 10             	mov    0x10(%ebp),%eax
  801940:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801943:	e8 a9 fd ff ff       	call   8016f1 <InitializeUHeap>
	if (size == 0) return NULL ;
  801948:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80194c:	75 07                	jne    801955 <smalloc+0x1e>
  80194e:	b8 00 00 00 00       	mov    $0x0,%eax
  801953:	eb 7c                	jmp    8019d1 <smalloc+0x9a>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801955:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80195c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80195f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801962:	01 d0                	add    %edx,%eax
  801964:	48                   	dec    %eax
  801965:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801968:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80196b:	ba 00 00 00 00       	mov    $0x0,%edx
  801970:	f7 75 f0             	divl   -0x10(%ebp)
  801973:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801976:	29 d0                	sub    %edx,%eax
  801978:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  80197b:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801982:	e8 41 06 00 00       	call   801fc8 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801987:	85 c0                	test   %eax,%eax
  801989:	74 11                	je     80199c <smalloc+0x65>
		mem_block = alloc_block_FF(allocate_space);
  80198b:	83 ec 0c             	sub    $0xc,%esp
  80198e:	ff 75 e8             	pushl  -0x18(%ebp)
  801991:	e8 ac 0c 00 00       	call   802642 <alloc_block_FF>
  801996:	83 c4 10             	add    $0x10,%esp
  801999:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  80199c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8019a0:	74 2a                	je     8019cc <smalloc+0x95>
	{
		virtual_address = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  8019a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019a5:	8b 40 08             	mov    0x8(%eax),%eax
  8019a8:	89 c2                	mov    %eax,%edx
  8019aa:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8019ae:	52                   	push   %edx
  8019af:	50                   	push   %eax
  8019b0:	ff 75 0c             	pushl  0xc(%ebp)
  8019b3:	ff 75 08             	pushl  0x8(%ebp)
  8019b6:	e8 92 03 00 00       	call   801d4d <sys_createSharedObject>
  8019bb:	83 c4 10             	add    $0x10,%esp
  8019be:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (virtual_address != -1)
  8019c1:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  8019c5:	74 05                	je     8019cc <smalloc+0x95>
			return (void*)virtual_address;
  8019c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8019ca:	eb 05                	jmp    8019d1 <smalloc+0x9a>
	}
	return NULL;
  8019cc:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8019d1:	c9                   	leave  
  8019d2:	c3                   	ret    

008019d3 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8019d3:	55                   	push   %ebp
  8019d4:	89 e5                	mov    %esp,%ebp
  8019d6:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8019d9:	e8 13 fd ff ff       	call   8016f1 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8019de:	83 ec 04             	sub    $0x4,%esp
  8019e1:	68 30 44 80 00       	push   $0x804430
  8019e6:	68 a2 00 00 00       	push   $0xa2
  8019eb:	68 b3 43 80 00       	push   $0x8043b3
  8019f0:	e8 be ec ff ff       	call   8006b3 <_panic>

008019f5 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8019f5:	55                   	push   %ebp
  8019f6:	89 e5                	mov    %esp,%ebp
  8019f8:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8019fb:	e8 f1 fc ff ff       	call   8016f1 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801a00:	83 ec 04             	sub    $0x4,%esp
  801a03:	68 54 44 80 00       	push   $0x804454
  801a08:	68 e6 00 00 00       	push   $0xe6
  801a0d:	68 b3 43 80 00       	push   $0x8043b3
  801a12:	e8 9c ec ff ff       	call   8006b3 <_panic>

00801a17 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801a17:	55                   	push   %ebp
  801a18:	89 e5                	mov    %esp,%ebp
  801a1a:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801a1d:	83 ec 04             	sub    $0x4,%esp
  801a20:	68 7c 44 80 00       	push   $0x80447c
  801a25:	68 fa 00 00 00       	push   $0xfa
  801a2a:	68 b3 43 80 00       	push   $0x8043b3
  801a2f:	e8 7f ec ff ff       	call   8006b3 <_panic>

00801a34 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801a34:	55                   	push   %ebp
  801a35:	89 e5                	mov    %esp,%ebp
  801a37:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a3a:	83 ec 04             	sub    $0x4,%esp
  801a3d:	68 a0 44 80 00       	push   $0x8044a0
  801a42:	68 05 01 00 00       	push   $0x105
  801a47:	68 b3 43 80 00       	push   $0x8043b3
  801a4c:	e8 62 ec ff ff       	call   8006b3 <_panic>

00801a51 <shrink>:

}
void shrink(uint32 newSize)
{
  801a51:	55                   	push   %ebp
  801a52:	89 e5                	mov    %esp,%ebp
  801a54:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a57:	83 ec 04             	sub    $0x4,%esp
  801a5a:	68 a0 44 80 00       	push   $0x8044a0
  801a5f:	68 0a 01 00 00       	push   $0x10a
  801a64:	68 b3 43 80 00       	push   $0x8043b3
  801a69:	e8 45 ec ff ff       	call   8006b3 <_panic>

00801a6e <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801a6e:	55                   	push   %ebp
  801a6f:	89 e5                	mov    %esp,%ebp
  801a71:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a74:	83 ec 04             	sub    $0x4,%esp
  801a77:	68 a0 44 80 00       	push   $0x8044a0
  801a7c:	68 0f 01 00 00       	push   $0x10f
  801a81:	68 b3 43 80 00       	push   $0x8043b3
  801a86:	e8 28 ec ff ff       	call   8006b3 <_panic>

00801a8b <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801a8b:	55                   	push   %ebp
  801a8c:	89 e5                	mov    %esp,%ebp
  801a8e:	57                   	push   %edi
  801a8f:	56                   	push   %esi
  801a90:	53                   	push   %ebx
  801a91:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801a94:	8b 45 08             	mov    0x8(%ebp),%eax
  801a97:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a9a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a9d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801aa0:	8b 7d 18             	mov    0x18(%ebp),%edi
  801aa3:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801aa6:	cd 30                	int    $0x30
  801aa8:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801aab:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801aae:	83 c4 10             	add    $0x10,%esp
  801ab1:	5b                   	pop    %ebx
  801ab2:	5e                   	pop    %esi
  801ab3:	5f                   	pop    %edi
  801ab4:	5d                   	pop    %ebp
  801ab5:	c3                   	ret    

00801ab6 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801ab6:	55                   	push   %ebp
  801ab7:	89 e5                	mov    %esp,%ebp
  801ab9:	83 ec 04             	sub    $0x4,%esp
  801abc:	8b 45 10             	mov    0x10(%ebp),%eax
  801abf:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801ac2:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ac6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac9:	6a 00                	push   $0x0
  801acb:	6a 00                	push   $0x0
  801acd:	52                   	push   %edx
  801ace:	ff 75 0c             	pushl  0xc(%ebp)
  801ad1:	50                   	push   %eax
  801ad2:	6a 00                	push   $0x0
  801ad4:	e8 b2 ff ff ff       	call   801a8b <syscall>
  801ad9:	83 c4 18             	add    $0x18,%esp
}
  801adc:	90                   	nop
  801add:	c9                   	leave  
  801ade:	c3                   	ret    

00801adf <sys_cgetc>:

int
sys_cgetc(void)
{
  801adf:	55                   	push   %ebp
  801ae0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801ae2:	6a 00                	push   $0x0
  801ae4:	6a 00                	push   $0x0
  801ae6:	6a 00                	push   $0x0
  801ae8:	6a 00                	push   $0x0
  801aea:	6a 00                	push   $0x0
  801aec:	6a 01                	push   $0x1
  801aee:	e8 98 ff ff ff       	call   801a8b <syscall>
  801af3:	83 c4 18             	add    $0x18,%esp
}
  801af6:	c9                   	leave  
  801af7:	c3                   	ret    

00801af8 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801af8:	55                   	push   %ebp
  801af9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801afb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801afe:	8b 45 08             	mov    0x8(%ebp),%eax
  801b01:	6a 00                	push   $0x0
  801b03:	6a 00                	push   $0x0
  801b05:	6a 00                	push   $0x0
  801b07:	52                   	push   %edx
  801b08:	50                   	push   %eax
  801b09:	6a 05                	push   $0x5
  801b0b:	e8 7b ff ff ff       	call   801a8b <syscall>
  801b10:	83 c4 18             	add    $0x18,%esp
}
  801b13:	c9                   	leave  
  801b14:	c3                   	ret    

00801b15 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801b15:	55                   	push   %ebp
  801b16:	89 e5                	mov    %esp,%ebp
  801b18:	56                   	push   %esi
  801b19:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801b1a:	8b 75 18             	mov    0x18(%ebp),%esi
  801b1d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b20:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b23:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b26:	8b 45 08             	mov    0x8(%ebp),%eax
  801b29:	56                   	push   %esi
  801b2a:	53                   	push   %ebx
  801b2b:	51                   	push   %ecx
  801b2c:	52                   	push   %edx
  801b2d:	50                   	push   %eax
  801b2e:	6a 06                	push   $0x6
  801b30:	e8 56 ff ff ff       	call   801a8b <syscall>
  801b35:	83 c4 18             	add    $0x18,%esp
}
  801b38:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b3b:	5b                   	pop    %ebx
  801b3c:	5e                   	pop    %esi
  801b3d:	5d                   	pop    %ebp
  801b3e:	c3                   	ret    

00801b3f <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801b3f:	55                   	push   %ebp
  801b40:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801b42:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b45:	8b 45 08             	mov    0x8(%ebp),%eax
  801b48:	6a 00                	push   $0x0
  801b4a:	6a 00                	push   $0x0
  801b4c:	6a 00                	push   $0x0
  801b4e:	52                   	push   %edx
  801b4f:	50                   	push   %eax
  801b50:	6a 07                	push   $0x7
  801b52:	e8 34 ff ff ff       	call   801a8b <syscall>
  801b57:	83 c4 18             	add    $0x18,%esp
}
  801b5a:	c9                   	leave  
  801b5b:	c3                   	ret    

00801b5c <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801b5c:	55                   	push   %ebp
  801b5d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801b5f:	6a 00                	push   $0x0
  801b61:	6a 00                	push   $0x0
  801b63:	6a 00                	push   $0x0
  801b65:	ff 75 0c             	pushl  0xc(%ebp)
  801b68:	ff 75 08             	pushl  0x8(%ebp)
  801b6b:	6a 08                	push   $0x8
  801b6d:	e8 19 ff ff ff       	call   801a8b <syscall>
  801b72:	83 c4 18             	add    $0x18,%esp
}
  801b75:	c9                   	leave  
  801b76:	c3                   	ret    

00801b77 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801b77:	55                   	push   %ebp
  801b78:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801b7a:	6a 00                	push   $0x0
  801b7c:	6a 00                	push   $0x0
  801b7e:	6a 00                	push   $0x0
  801b80:	6a 00                	push   $0x0
  801b82:	6a 00                	push   $0x0
  801b84:	6a 09                	push   $0x9
  801b86:	e8 00 ff ff ff       	call   801a8b <syscall>
  801b8b:	83 c4 18             	add    $0x18,%esp
}
  801b8e:	c9                   	leave  
  801b8f:	c3                   	ret    

00801b90 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801b90:	55                   	push   %ebp
  801b91:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801b93:	6a 00                	push   $0x0
  801b95:	6a 00                	push   $0x0
  801b97:	6a 00                	push   $0x0
  801b99:	6a 00                	push   $0x0
  801b9b:	6a 00                	push   $0x0
  801b9d:	6a 0a                	push   $0xa
  801b9f:	e8 e7 fe ff ff       	call   801a8b <syscall>
  801ba4:	83 c4 18             	add    $0x18,%esp
}
  801ba7:	c9                   	leave  
  801ba8:	c3                   	ret    

00801ba9 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801ba9:	55                   	push   %ebp
  801baa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801bac:	6a 00                	push   $0x0
  801bae:	6a 00                	push   $0x0
  801bb0:	6a 00                	push   $0x0
  801bb2:	6a 00                	push   $0x0
  801bb4:	6a 00                	push   $0x0
  801bb6:	6a 0b                	push   $0xb
  801bb8:	e8 ce fe ff ff       	call   801a8b <syscall>
  801bbd:	83 c4 18             	add    $0x18,%esp
}
  801bc0:	c9                   	leave  
  801bc1:	c3                   	ret    

00801bc2 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801bc2:	55                   	push   %ebp
  801bc3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801bc5:	6a 00                	push   $0x0
  801bc7:	6a 00                	push   $0x0
  801bc9:	6a 00                	push   $0x0
  801bcb:	ff 75 0c             	pushl  0xc(%ebp)
  801bce:	ff 75 08             	pushl  0x8(%ebp)
  801bd1:	6a 0f                	push   $0xf
  801bd3:	e8 b3 fe ff ff       	call   801a8b <syscall>
  801bd8:	83 c4 18             	add    $0x18,%esp
	return;
  801bdb:	90                   	nop
}
  801bdc:	c9                   	leave  
  801bdd:	c3                   	ret    

00801bde <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801bde:	55                   	push   %ebp
  801bdf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801be1:	6a 00                	push   $0x0
  801be3:	6a 00                	push   $0x0
  801be5:	6a 00                	push   $0x0
  801be7:	ff 75 0c             	pushl  0xc(%ebp)
  801bea:	ff 75 08             	pushl  0x8(%ebp)
  801bed:	6a 10                	push   $0x10
  801bef:	e8 97 fe ff ff       	call   801a8b <syscall>
  801bf4:	83 c4 18             	add    $0x18,%esp
	return ;
  801bf7:	90                   	nop
}
  801bf8:	c9                   	leave  
  801bf9:	c3                   	ret    

00801bfa <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801bfa:	55                   	push   %ebp
  801bfb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801bfd:	6a 00                	push   $0x0
  801bff:	6a 00                	push   $0x0
  801c01:	ff 75 10             	pushl  0x10(%ebp)
  801c04:	ff 75 0c             	pushl  0xc(%ebp)
  801c07:	ff 75 08             	pushl  0x8(%ebp)
  801c0a:	6a 11                	push   $0x11
  801c0c:	e8 7a fe ff ff       	call   801a8b <syscall>
  801c11:	83 c4 18             	add    $0x18,%esp
	return ;
  801c14:	90                   	nop
}
  801c15:	c9                   	leave  
  801c16:	c3                   	ret    

00801c17 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801c17:	55                   	push   %ebp
  801c18:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801c1a:	6a 00                	push   $0x0
  801c1c:	6a 00                	push   $0x0
  801c1e:	6a 00                	push   $0x0
  801c20:	6a 00                	push   $0x0
  801c22:	6a 00                	push   $0x0
  801c24:	6a 0c                	push   $0xc
  801c26:	e8 60 fe ff ff       	call   801a8b <syscall>
  801c2b:	83 c4 18             	add    $0x18,%esp
}
  801c2e:	c9                   	leave  
  801c2f:	c3                   	ret    

00801c30 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801c30:	55                   	push   %ebp
  801c31:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801c33:	6a 00                	push   $0x0
  801c35:	6a 00                	push   $0x0
  801c37:	6a 00                	push   $0x0
  801c39:	6a 00                	push   $0x0
  801c3b:	ff 75 08             	pushl  0x8(%ebp)
  801c3e:	6a 0d                	push   $0xd
  801c40:	e8 46 fe ff ff       	call   801a8b <syscall>
  801c45:	83 c4 18             	add    $0x18,%esp
}
  801c48:	c9                   	leave  
  801c49:	c3                   	ret    

00801c4a <sys_scarce_memory>:

void sys_scarce_memory()
{
  801c4a:	55                   	push   %ebp
  801c4b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801c4d:	6a 00                	push   $0x0
  801c4f:	6a 00                	push   $0x0
  801c51:	6a 00                	push   $0x0
  801c53:	6a 00                	push   $0x0
  801c55:	6a 00                	push   $0x0
  801c57:	6a 0e                	push   $0xe
  801c59:	e8 2d fe ff ff       	call   801a8b <syscall>
  801c5e:	83 c4 18             	add    $0x18,%esp
}
  801c61:	90                   	nop
  801c62:	c9                   	leave  
  801c63:	c3                   	ret    

00801c64 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801c64:	55                   	push   %ebp
  801c65:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801c67:	6a 00                	push   $0x0
  801c69:	6a 00                	push   $0x0
  801c6b:	6a 00                	push   $0x0
  801c6d:	6a 00                	push   $0x0
  801c6f:	6a 00                	push   $0x0
  801c71:	6a 13                	push   $0x13
  801c73:	e8 13 fe ff ff       	call   801a8b <syscall>
  801c78:	83 c4 18             	add    $0x18,%esp
}
  801c7b:	90                   	nop
  801c7c:	c9                   	leave  
  801c7d:	c3                   	ret    

00801c7e <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801c7e:	55                   	push   %ebp
  801c7f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801c81:	6a 00                	push   $0x0
  801c83:	6a 00                	push   $0x0
  801c85:	6a 00                	push   $0x0
  801c87:	6a 00                	push   $0x0
  801c89:	6a 00                	push   $0x0
  801c8b:	6a 14                	push   $0x14
  801c8d:	e8 f9 fd ff ff       	call   801a8b <syscall>
  801c92:	83 c4 18             	add    $0x18,%esp
}
  801c95:	90                   	nop
  801c96:	c9                   	leave  
  801c97:	c3                   	ret    

00801c98 <sys_cputc>:


void
sys_cputc(const char c)
{
  801c98:	55                   	push   %ebp
  801c99:	89 e5                	mov    %esp,%ebp
  801c9b:	83 ec 04             	sub    $0x4,%esp
  801c9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801ca4:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ca8:	6a 00                	push   $0x0
  801caa:	6a 00                	push   $0x0
  801cac:	6a 00                	push   $0x0
  801cae:	6a 00                	push   $0x0
  801cb0:	50                   	push   %eax
  801cb1:	6a 15                	push   $0x15
  801cb3:	e8 d3 fd ff ff       	call   801a8b <syscall>
  801cb8:	83 c4 18             	add    $0x18,%esp
}
  801cbb:	90                   	nop
  801cbc:	c9                   	leave  
  801cbd:	c3                   	ret    

00801cbe <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801cbe:	55                   	push   %ebp
  801cbf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801cc1:	6a 00                	push   $0x0
  801cc3:	6a 00                	push   $0x0
  801cc5:	6a 00                	push   $0x0
  801cc7:	6a 00                	push   $0x0
  801cc9:	6a 00                	push   $0x0
  801ccb:	6a 16                	push   $0x16
  801ccd:	e8 b9 fd ff ff       	call   801a8b <syscall>
  801cd2:	83 c4 18             	add    $0x18,%esp
}
  801cd5:	90                   	nop
  801cd6:	c9                   	leave  
  801cd7:	c3                   	ret    

00801cd8 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801cd8:	55                   	push   %ebp
  801cd9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801cdb:	8b 45 08             	mov    0x8(%ebp),%eax
  801cde:	6a 00                	push   $0x0
  801ce0:	6a 00                	push   $0x0
  801ce2:	6a 00                	push   $0x0
  801ce4:	ff 75 0c             	pushl  0xc(%ebp)
  801ce7:	50                   	push   %eax
  801ce8:	6a 17                	push   $0x17
  801cea:	e8 9c fd ff ff       	call   801a8b <syscall>
  801cef:	83 c4 18             	add    $0x18,%esp
}
  801cf2:	c9                   	leave  
  801cf3:	c3                   	ret    

00801cf4 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801cf4:	55                   	push   %ebp
  801cf5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801cf7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cfa:	8b 45 08             	mov    0x8(%ebp),%eax
  801cfd:	6a 00                	push   $0x0
  801cff:	6a 00                	push   $0x0
  801d01:	6a 00                	push   $0x0
  801d03:	52                   	push   %edx
  801d04:	50                   	push   %eax
  801d05:	6a 1a                	push   $0x1a
  801d07:	e8 7f fd ff ff       	call   801a8b <syscall>
  801d0c:	83 c4 18             	add    $0x18,%esp
}
  801d0f:	c9                   	leave  
  801d10:	c3                   	ret    

00801d11 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801d11:	55                   	push   %ebp
  801d12:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d14:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d17:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1a:	6a 00                	push   $0x0
  801d1c:	6a 00                	push   $0x0
  801d1e:	6a 00                	push   $0x0
  801d20:	52                   	push   %edx
  801d21:	50                   	push   %eax
  801d22:	6a 18                	push   $0x18
  801d24:	e8 62 fd ff ff       	call   801a8b <syscall>
  801d29:	83 c4 18             	add    $0x18,%esp
}
  801d2c:	90                   	nop
  801d2d:	c9                   	leave  
  801d2e:	c3                   	ret    

00801d2f <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801d2f:	55                   	push   %ebp
  801d30:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d32:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d35:	8b 45 08             	mov    0x8(%ebp),%eax
  801d38:	6a 00                	push   $0x0
  801d3a:	6a 00                	push   $0x0
  801d3c:	6a 00                	push   $0x0
  801d3e:	52                   	push   %edx
  801d3f:	50                   	push   %eax
  801d40:	6a 19                	push   $0x19
  801d42:	e8 44 fd ff ff       	call   801a8b <syscall>
  801d47:	83 c4 18             	add    $0x18,%esp
}
  801d4a:	90                   	nop
  801d4b:	c9                   	leave  
  801d4c:	c3                   	ret    

00801d4d <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801d4d:	55                   	push   %ebp
  801d4e:	89 e5                	mov    %esp,%ebp
  801d50:	83 ec 04             	sub    $0x4,%esp
  801d53:	8b 45 10             	mov    0x10(%ebp),%eax
  801d56:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801d59:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801d5c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801d60:	8b 45 08             	mov    0x8(%ebp),%eax
  801d63:	6a 00                	push   $0x0
  801d65:	51                   	push   %ecx
  801d66:	52                   	push   %edx
  801d67:	ff 75 0c             	pushl  0xc(%ebp)
  801d6a:	50                   	push   %eax
  801d6b:	6a 1b                	push   $0x1b
  801d6d:	e8 19 fd ff ff       	call   801a8b <syscall>
  801d72:	83 c4 18             	add    $0x18,%esp
}
  801d75:	c9                   	leave  
  801d76:	c3                   	ret    

00801d77 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801d77:	55                   	push   %ebp
  801d78:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801d7a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d7d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d80:	6a 00                	push   $0x0
  801d82:	6a 00                	push   $0x0
  801d84:	6a 00                	push   $0x0
  801d86:	52                   	push   %edx
  801d87:	50                   	push   %eax
  801d88:	6a 1c                	push   $0x1c
  801d8a:	e8 fc fc ff ff       	call   801a8b <syscall>
  801d8f:	83 c4 18             	add    $0x18,%esp
}
  801d92:	c9                   	leave  
  801d93:	c3                   	ret    

00801d94 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801d94:	55                   	push   %ebp
  801d95:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801d97:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d9a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d9d:	8b 45 08             	mov    0x8(%ebp),%eax
  801da0:	6a 00                	push   $0x0
  801da2:	6a 00                	push   $0x0
  801da4:	51                   	push   %ecx
  801da5:	52                   	push   %edx
  801da6:	50                   	push   %eax
  801da7:	6a 1d                	push   $0x1d
  801da9:	e8 dd fc ff ff       	call   801a8b <syscall>
  801dae:	83 c4 18             	add    $0x18,%esp
}
  801db1:	c9                   	leave  
  801db2:	c3                   	ret    

00801db3 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801db3:	55                   	push   %ebp
  801db4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801db6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801db9:	8b 45 08             	mov    0x8(%ebp),%eax
  801dbc:	6a 00                	push   $0x0
  801dbe:	6a 00                	push   $0x0
  801dc0:	6a 00                	push   $0x0
  801dc2:	52                   	push   %edx
  801dc3:	50                   	push   %eax
  801dc4:	6a 1e                	push   $0x1e
  801dc6:	e8 c0 fc ff ff       	call   801a8b <syscall>
  801dcb:	83 c4 18             	add    $0x18,%esp
}
  801dce:	c9                   	leave  
  801dcf:	c3                   	ret    

00801dd0 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801dd0:	55                   	push   %ebp
  801dd1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801dd3:	6a 00                	push   $0x0
  801dd5:	6a 00                	push   $0x0
  801dd7:	6a 00                	push   $0x0
  801dd9:	6a 00                	push   $0x0
  801ddb:	6a 00                	push   $0x0
  801ddd:	6a 1f                	push   $0x1f
  801ddf:	e8 a7 fc ff ff       	call   801a8b <syscall>
  801de4:	83 c4 18             	add    $0x18,%esp
}
  801de7:	c9                   	leave  
  801de8:	c3                   	ret    

00801de9 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801de9:	55                   	push   %ebp
  801dea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801dec:	8b 45 08             	mov    0x8(%ebp),%eax
  801def:	6a 00                	push   $0x0
  801df1:	ff 75 14             	pushl  0x14(%ebp)
  801df4:	ff 75 10             	pushl  0x10(%ebp)
  801df7:	ff 75 0c             	pushl  0xc(%ebp)
  801dfa:	50                   	push   %eax
  801dfb:	6a 20                	push   $0x20
  801dfd:	e8 89 fc ff ff       	call   801a8b <syscall>
  801e02:	83 c4 18             	add    $0x18,%esp
}
  801e05:	c9                   	leave  
  801e06:	c3                   	ret    

00801e07 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801e07:	55                   	push   %ebp
  801e08:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801e0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e0d:	6a 00                	push   $0x0
  801e0f:	6a 00                	push   $0x0
  801e11:	6a 00                	push   $0x0
  801e13:	6a 00                	push   $0x0
  801e15:	50                   	push   %eax
  801e16:	6a 21                	push   $0x21
  801e18:	e8 6e fc ff ff       	call   801a8b <syscall>
  801e1d:	83 c4 18             	add    $0x18,%esp
}
  801e20:	90                   	nop
  801e21:	c9                   	leave  
  801e22:	c3                   	ret    

00801e23 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801e23:	55                   	push   %ebp
  801e24:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801e26:	8b 45 08             	mov    0x8(%ebp),%eax
  801e29:	6a 00                	push   $0x0
  801e2b:	6a 00                	push   $0x0
  801e2d:	6a 00                	push   $0x0
  801e2f:	6a 00                	push   $0x0
  801e31:	50                   	push   %eax
  801e32:	6a 22                	push   $0x22
  801e34:	e8 52 fc ff ff       	call   801a8b <syscall>
  801e39:	83 c4 18             	add    $0x18,%esp
}
  801e3c:	c9                   	leave  
  801e3d:	c3                   	ret    

00801e3e <sys_getenvid>:

int32 sys_getenvid(void)
{
  801e3e:	55                   	push   %ebp
  801e3f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801e41:	6a 00                	push   $0x0
  801e43:	6a 00                	push   $0x0
  801e45:	6a 00                	push   $0x0
  801e47:	6a 00                	push   $0x0
  801e49:	6a 00                	push   $0x0
  801e4b:	6a 02                	push   $0x2
  801e4d:	e8 39 fc ff ff       	call   801a8b <syscall>
  801e52:	83 c4 18             	add    $0x18,%esp
}
  801e55:	c9                   	leave  
  801e56:	c3                   	ret    

00801e57 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801e57:	55                   	push   %ebp
  801e58:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801e5a:	6a 00                	push   $0x0
  801e5c:	6a 00                	push   $0x0
  801e5e:	6a 00                	push   $0x0
  801e60:	6a 00                	push   $0x0
  801e62:	6a 00                	push   $0x0
  801e64:	6a 03                	push   $0x3
  801e66:	e8 20 fc ff ff       	call   801a8b <syscall>
  801e6b:	83 c4 18             	add    $0x18,%esp
}
  801e6e:	c9                   	leave  
  801e6f:	c3                   	ret    

00801e70 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801e70:	55                   	push   %ebp
  801e71:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801e73:	6a 00                	push   $0x0
  801e75:	6a 00                	push   $0x0
  801e77:	6a 00                	push   $0x0
  801e79:	6a 00                	push   $0x0
  801e7b:	6a 00                	push   $0x0
  801e7d:	6a 04                	push   $0x4
  801e7f:	e8 07 fc ff ff       	call   801a8b <syscall>
  801e84:	83 c4 18             	add    $0x18,%esp
}
  801e87:	c9                   	leave  
  801e88:	c3                   	ret    

00801e89 <sys_exit_env>:


void sys_exit_env(void)
{
  801e89:	55                   	push   %ebp
  801e8a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801e8c:	6a 00                	push   $0x0
  801e8e:	6a 00                	push   $0x0
  801e90:	6a 00                	push   $0x0
  801e92:	6a 00                	push   $0x0
  801e94:	6a 00                	push   $0x0
  801e96:	6a 23                	push   $0x23
  801e98:	e8 ee fb ff ff       	call   801a8b <syscall>
  801e9d:	83 c4 18             	add    $0x18,%esp
}
  801ea0:	90                   	nop
  801ea1:	c9                   	leave  
  801ea2:	c3                   	ret    

00801ea3 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801ea3:	55                   	push   %ebp
  801ea4:	89 e5                	mov    %esp,%ebp
  801ea6:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801ea9:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801eac:	8d 50 04             	lea    0x4(%eax),%edx
  801eaf:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801eb2:	6a 00                	push   $0x0
  801eb4:	6a 00                	push   $0x0
  801eb6:	6a 00                	push   $0x0
  801eb8:	52                   	push   %edx
  801eb9:	50                   	push   %eax
  801eba:	6a 24                	push   $0x24
  801ebc:	e8 ca fb ff ff       	call   801a8b <syscall>
  801ec1:	83 c4 18             	add    $0x18,%esp
	return result;
  801ec4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ec7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801eca:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ecd:	89 01                	mov    %eax,(%ecx)
  801ecf:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801ed2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed5:	c9                   	leave  
  801ed6:	c2 04 00             	ret    $0x4

00801ed9 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801ed9:	55                   	push   %ebp
  801eda:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801edc:	6a 00                	push   $0x0
  801ede:	6a 00                	push   $0x0
  801ee0:	ff 75 10             	pushl  0x10(%ebp)
  801ee3:	ff 75 0c             	pushl  0xc(%ebp)
  801ee6:	ff 75 08             	pushl  0x8(%ebp)
  801ee9:	6a 12                	push   $0x12
  801eeb:	e8 9b fb ff ff       	call   801a8b <syscall>
  801ef0:	83 c4 18             	add    $0x18,%esp
	return ;
  801ef3:	90                   	nop
}
  801ef4:	c9                   	leave  
  801ef5:	c3                   	ret    

00801ef6 <sys_rcr2>:
uint32 sys_rcr2()
{
  801ef6:	55                   	push   %ebp
  801ef7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801ef9:	6a 00                	push   $0x0
  801efb:	6a 00                	push   $0x0
  801efd:	6a 00                	push   $0x0
  801eff:	6a 00                	push   $0x0
  801f01:	6a 00                	push   $0x0
  801f03:	6a 25                	push   $0x25
  801f05:	e8 81 fb ff ff       	call   801a8b <syscall>
  801f0a:	83 c4 18             	add    $0x18,%esp
}
  801f0d:	c9                   	leave  
  801f0e:	c3                   	ret    

00801f0f <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801f0f:	55                   	push   %ebp
  801f10:	89 e5                	mov    %esp,%ebp
  801f12:	83 ec 04             	sub    $0x4,%esp
  801f15:	8b 45 08             	mov    0x8(%ebp),%eax
  801f18:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801f1b:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801f1f:	6a 00                	push   $0x0
  801f21:	6a 00                	push   $0x0
  801f23:	6a 00                	push   $0x0
  801f25:	6a 00                	push   $0x0
  801f27:	50                   	push   %eax
  801f28:	6a 26                	push   $0x26
  801f2a:	e8 5c fb ff ff       	call   801a8b <syscall>
  801f2f:	83 c4 18             	add    $0x18,%esp
	return ;
  801f32:	90                   	nop
}
  801f33:	c9                   	leave  
  801f34:	c3                   	ret    

00801f35 <rsttst>:
void rsttst()
{
  801f35:	55                   	push   %ebp
  801f36:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801f38:	6a 00                	push   $0x0
  801f3a:	6a 00                	push   $0x0
  801f3c:	6a 00                	push   $0x0
  801f3e:	6a 00                	push   $0x0
  801f40:	6a 00                	push   $0x0
  801f42:	6a 28                	push   $0x28
  801f44:	e8 42 fb ff ff       	call   801a8b <syscall>
  801f49:	83 c4 18             	add    $0x18,%esp
	return ;
  801f4c:	90                   	nop
}
  801f4d:	c9                   	leave  
  801f4e:	c3                   	ret    

00801f4f <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801f4f:	55                   	push   %ebp
  801f50:	89 e5                	mov    %esp,%ebp
  801f52:	83 ec 04             	sub    $0x4,%esp
  801f55:	8b 45 14             	mov    0x14(%ebp),%eax
  801f58:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801f5b:	8b 55 18             	mov    0x18(%ebp),%edx
  801f5e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801f62:	52                   	push   %edx
  801f63:	50                   	push   %eax
  801f64:	ff 75 10             	pushl  0x10(%ebp)
  801f67:	ff 75 0c             	pushl  0xc(%ebp)
  801f6a:	ff 75 08             	pushl  0x8(%ebp)
  801f6d:	6a 27                	push   $0x27
  801f6f:	e8 17 fb ff ff       	call   801a8b <syscall>
  801f74:	83 c4 18             	add    $0x18,%esp
	return ;
  801f77:	90                   	nop
}
  801f78:	c9                   	leave  
  801f79:	c3                   	ret    

00801f7a <chktst>:
void chktst(uint32 n)
{
  801f7a:	55                   	push   %ebp
  801f7b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801f7d:	6a 00                	push   $0x0
  801f7f:	6a 00                	push   $0x0
  801f81:	6a 00                	push   $0x0
  801f83:	6a 00                	push   $0x0
  801f85:	ff 75 08             	pushl  0x8(%ebp)
  801f88:	6a 29                	push   $0x29
  801f8a:	e8 fc fa ff ff       	call   801a8b <syscall>
  801f8f:	83 c4 18             	add    $0x18,%esp
	return ;
  801f92:	90                   	nop
}
  801f93:	c9                   	leave  
  801f94:	c3                   	ret    

00801f95 <inctst>:

void inctst()
{
  801f95:	55                   	push   %ebp
  801f96:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801f98:	6a 00                	push   $0x0
  801f9a:	6a 00                	push   $0x0
  801f9c:	6a 00                	push   $0x0
  801f9e:	6a 00                	push   $0x0
  801fa0:	6a 00                	push   $0x0
  801fa2:	6a 2a                	push   $0x2a
  801fa4:	e8 e2 fa ff ff       	call   801a8b <syscall>
  801fa9:	83 c4 18             	add    $0x18,%esp
	return ;
  801fac:	90                   	nop
}
  801fad:	c9                   	leave  
  801fae:	c3                   	ret    

00801faf <gettst>:
uint32 gettst()
{
  801faf:	55                   	push   %ebp
  801fb0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801fb2:	6a 00                	push   $0x0
  801fb4:	6a 00                	push   $0x0
  801fb6:	6a 00                	push   $0x0
  801fb8:	6a 00                	push   $0x0
  801fba:	6a 00                	push   $0x0
  801fbc:	6a 2b                	push   $0x2b
  801fbe:	e8 c8 fa ff ff       	call   801a8b <syscall>
  801fc3:	83 c4 18             	add    $0x18,%esp
}
  801fc6:	c9                   	leave  
  801fc7:	c3                   	ret    

00801fc8 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801fc8:	55                   	push   %ebp
  801fc9:	89 e5                	mov    %esp,%ebp
  801fcb:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fce:	6a 00                	push   $0x0
  801fd0:	6a 00                	push   $0x0
  801fd2:	6a 00                	push   $0x0
  801fd4:	6a 00                	push   $0x0
  801fd6:	6a 00                	push   $0x0
  801fd8:	6a 2c                	push   $0x2c
  801fda:	e8 ac fa ff ff       	call   801a8b <syscall>
  801fdf:	83 c4 18             	add    $0x18,%esp
  801fe2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801fe5:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801fe9:	75 07                	jne    801ff2 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801feb:	b8 01 00 00 00       	mov    $0x1,%eax
  801ff0:	eb 05                	jmp    801ff7 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801ff2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ff7:	c9                   	leave  
  801ff8:	c3                   	ret    

00801ff9 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801ff9:	55                   	push   %ebp
  801ffa:	89 e5                	mov    %esp,%ebp
  801ffc:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fff:	6a 00                	push   $0x0
  802001:	6a 00                	push   $0x0
  802003:	6a 00                	push   $0x0
  802005:	6a 00                	push   $0x0
  802007:	6a 00                	push   $0x0
  802009:	6a 2c                	push   $0x2c
  80200b:	e8 7b fa ff ff       	call   801a8b <syscall>
  802010:	83 c4 18             	add    $0x18,%esp
  802013:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802016:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80201a:	75 07                	jne    802023 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80201c:	b8 01 00 00 00       	mov    $0x1,%eax
  802021:	eb 05                	jmp    802028 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802023:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802028:	c9                   	leave  
  802029:	c3                   	ret    

0080202a <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80202a:	55                   	push   %ebp
  80202b:	89 e5                	mov    %esp,%ebp
  80202d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802030:	6a 00                	push   $0x0
  802032:	6a 00                	push   $0x0
  802034:	6a 00                	push   $0x0
  802036:	6a 00                	push   $0x0
  802038:	6a 00                	push   $0x0
  80203a:	6a 2c                	push   $0x2c
  80203c:	e8 4a fa ff ff       	call   801a8b <syscall>
  802041:	83 c4 18             	add    $0x18,%esp
  802044:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802047:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80204b:	75 07                	jne    802054 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80204d:	b8 01 00 00 00       	mov    $0x1,%eax
  802052:	eb 05                	jmp    802059 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802054:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802059:	c9                   	leave  
  80205a:	c3                   	ret    

0080205b <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80205b:	55                   	push   %ebp
  80205c:	89 e5                	mov    %esp,%ebp
  80205e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802061:	6a 00                	push   $0x0
  802063:	6a 00                	push   $0x0
  802065:	6a 00                	push   $0x0
  802067:	6a 00                	push   $0x0
  802069:	6a 00                	push   $0x0
  80206b:	6a 2c                	push   $0x2c
  80206d:	e8 19 fa ff ff       	call   801a8b <syscall>
  802072:	83 c4 18             	add    $0x18,%esp
  802075:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802078:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80207c:	75 07                	jne    802085 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80207e:	b8 01 00 00 00       	mov    $0x1,%eax
  802083:	eb 05                	jmp    80208a <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802085:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80208a:	c9                   	leave  
  80208b:	c3                   	ret    

0080208c <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80208c:	55                   	push   %ebp
  80208d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80208f:	6a 00                	push   $0x0
  802091:	6a 00                	push   $0x0
  802093:	6a 00                	push   $0x0
  802095:	6a 00                	push   $0x0
  802097:	ff 75 08             	pushl  0x8(%ebp)
  80209a:	6a 2d                	push   $0x2d
  80209c:	e8 ea f9 ff ff       	call   801a8b <syscall>
  8020a1:	83 c4 18             	add    $0x18,%esp
	return ;
  8020a4:	90                   	nop
}
  8020a5:	c9                   	leave  
  8020a6:	c3                   	ret    

008020a7 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8020a7:	55                   	push   %ebp
  8020a8:	89 e5                	mov    %esp,%ebp
  8020aa:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8020ab:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8020ae:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8020b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b7:	6a 00                	push   $0x0
  8020b9:	53                   	push   %ebx
  8020ba:	51                   	push   %ecx
  8020bb:	52                   	push   %edx
  8020bc:	50                   	push   %eax
  8020bd:	6a 2e                	push   $0x2e
  8020bf:	e8 c7 f9 ff ff       	call   801a8b <syscall>
  8020c4:	83 c4 18             	add    $0x18,%esp
}
  8020c7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020ca:	c9                   	leave  
  8020cb:	c3                   	ret    

008020cc <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8020cc:	55                   	push   %ebp
  8020cd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8020cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d5:	6a 00                	push   $0x0
  8020d7:	6a 00                	push   $0x0
  8020d9:	6a 00                	push   $0x0
  8020db:	52                   	push   %edx
  8020dc:	50                   	push   %eax
  8020dd:	6a 2f                	push   $0x2f
  8020df:	e8 a7 f9 ff ff       	call   801a8b <syscall>
  8020e4:	83 c4 18             	add    $0x18,%esp
}
  8020e7:	c9                   	leave  
  8020e8:	c3                   	ret    

008020e9 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  8020e9:	55                   	push   %ebp
  8020ea:	89 e5                	mov    %esp,%ebp
  8020ec:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  8020ef:	83 ec 0c             	sub    $0xc,%esp
  8020f2:	68 b0 44 80 00       	push   $0x8044b0
  8020f7:	e8 6b e8 ff ff       	call   800967 <cprintf>
  8020fc:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  8020ff:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802106:	83 ec 0c             	sub    $0xc,%esp
  802109:	68 dc 44 80 00       	push   $0x8044dc
  80210e:	e8 54 e8 ff ff       	call   800967 <cprintf>
  802113:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802116:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80211a:	a1 38 51 80 00       	mov    0x805138,%eax
  80211f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802122:	eb 56                	jmp    80217a <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802124:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802128:	74 1c                	je     802146 <print_mem_block_lists+0x5d>
  80212a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80212d:	8b 50 08             	mov    0x8(%eax),%edx
  802130:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802133:	8b 48 08             	mov    0x8(%eax),%ecx
  802136:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802139:	8b 40 0c             	mov    0xc(%eax),%eax
  80213c:	01 c8                	add    %ecx,%eax
  80213e:	39 c2                	cmp    %eax,%edx
  802140:	73 04                	jae    802146 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802142:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802146:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802149:	8b 50 08             	mov    0x8(%eax),%edx
  80214c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80214f:	8b 40 0c             	mov    0xc(%eax),%eax
  802152:	01 c2                	add    %eax,%edx
  802154:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802157:	8b 40 08             	mov    0x8(%eax),%eax
  80215a:	83 ec 04             	sub    $0x4,%esp
  80215d:	52                   	push   %edx
  80215e:	50                   	push   %eax
  80215f:	68 f1 44 80 00       	push   $0x8044f1
  802164:	e8 fe e7 ff ff       	call   800967 <cprintf>
  802169:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80216c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80216f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802172:	a1 40 51 80 00       	mov    0x805140,%eax
  802177:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80217a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80217e:	74 07                	je     802187 <print_mem_block_lists+0x9e>
  802180:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802183:	8b 00                	mov    (%eax),%eax
  802185:	eb 05                	jmp    80218c <print_mem_block_lists+0xa3>
  802187:	b8 00 00 00 00       	mov    $0x0,%eax
  80218c:	a3 40 51 80 00       	mov    %eax,0x805140
  802191:	a1 40 51 80 00       	mov    0x805140,%eax
  802196:	85 c0                	test   %eax,%eax
  802198:	75 8a                	jne    802124 <print_mem_block_lists+0x3b>
  80219a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80219e:	75 84                	jne    802124 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8021a0:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8021a4:	75 10                	jne    8021b6 <print_mem_block_lists+0xcd>
  8021a6:	83 ec 0c             	sub    $0xc,%esp
  8021a9:	68 00 45 80 00       	push   $0x804500
  8021ae:	e8 b4 e7 ff ff       	call   800967 <cprintf>
  8021b3:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8021b6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8021bd:	83 ec 0c             	sub    $0xc,%esp
  8021c0:	68 24 45 80 00       	push   $0x804524
  8021c5:	e8 9d e7 ff ff       	call   800967 <cprintf>
  8021ca:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8021cd:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8021d1:	a1 40 50 80 00       	mov    0x805040,%eax
  8021d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021d9:	eb 56                	jmp    802231 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8021db:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8021df:	74 1c                	je     8021fd <print_mem_block_lists+0x114>
  8021e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e4:	8b 50 08             	mov    0x8(%eax),%edx
  8021e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021ea:	8b 48 08             	mov    0x8(%eax),%ecx
  8021ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021f0:	8b 40 0c             	mov    0xc(%eax),%eax
  8021f3:	01 c8                	add    %ecx,%eax
  8021f5:	39 c2                	cmp    %eax,%edx
  8021f7:	73 04                	jae    8021fd <print_mem_block_lists+0x114>
			sorted = 0 ;
  8021f9:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8021fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802200:	8b 50 08             	mov    0x8(%eax),%edx
  802203:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802206:	8b 40 0c             	mov    0xc(%eax),%eax
  802209:	01 c2                	add    %eax,%edx
  80220b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80220e:	8b 40 08             	mov    0x8(%eax),%eax
  802211:	83 ec 04             	sub    $0x4,%esp
  802214:	52                   	push   %edx
  802215:	50                   	push   %eax
  802216:	68 f1 44 80 00       	push   $0x8044f1
  80221b:	e8 47 e7 ff ff       	call   800967 <cprintf>
  802220:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802223:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802226:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802229:	a1 48 50 80 00       	mov    0x805048,%eax
  80222e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802231:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802235:	74 07                	je     80223e <print_mem_block_lists+0x155>
  802237:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80223a:	8b 00                	mov    (%eax),%eax
  80223c:	eb 05                	jmp    802243 <print_mem_block_lists+0x15a>
  80223e:	b8 00 00 00 00       	mov    $0x0,%eax
  802243:	a3 48 50 80 00       	mov    %eax,0x805048
  802248:	a1 48 50 80 00       	mov    0x805048,%eax
  80224d:	85 c0                	test   %eax,%eax
  80224f:	75 8a                	jne    8021db <print_mem_block_lists+0xf2>
  802251:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802255:	75 84                	jne    8021db <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802257:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80225b:	75 10                	jne    80226d <print_mem_block_lists+0x184>
  80225d:	83 ec 0c             	sub    $0xc,%esp
  802260:	68 3c 45 80 00       	push   $0x80453c
  802265:	e8 fd e6 ff ff       	call   800967 <cprintf>
  80226a:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  80226d:	83 ec 0c             	sub    $0xc,%esp
  802270:	68 b0 44 80 00       	push   $0x8044b0
  802275:	e8 ed e6 ff ff       	call   800967 <cprintf>
  80227a:	83 c4 10             	add    $0x10,%esp

}
  80227d:	90                   	nop
  80227e:	c9                   	leave  
  80227f:	c3                   	ret    

00802280 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802280:	55                   	push   %ebp
  802281:	89 e5                	mov    %esp,%ebp
  802283:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  802286:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  80228d:	00 00 00 
  802290:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802297:	00 00 00 
  80229a:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  8022a1:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  8022a4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8022ab:	e9 9e 00 00 00       	jmp    80234e <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  8022b0:	a1 50 50 80 00       	mov    0x805050,%eax
  8022b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022b8:	c1 e2 04             	shl    $0x4,%edx
  8022bb:	01 d0                	add    %edx,%eax
  8022bd:	85 c0                	test   %eax,%eax
  8022bf:	75 14                	jne    8022d5 <initialize_MemBlocksList+0x55>
  8022c1:	83 ec 04             	sub    $0x4,%esp
  8022c4:	68 64 45 80 00       	push   $0x804564
  8022c9:	6a 46                	push   $0x46
  8022cb:	68 87 45 80 00       	push   $0x804587
  8022d0:	e8 de e3 ff ff       	call   8006b3 <_panic>
  8022d5:	a1 50 50 80 00       	mov    0x805050,%eax
  8022da:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022dd:	c1 e2 04             	shl    $0x4,%edx
  8022e0:	01 d0                	add    %edx,%eax
  8022e2:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8022e8:	89 10                	mov    %edx,(%eax)
  8022ea:	8b 00                	mov    (%eax),%eax
  8022ec:	85 c0                	test   %eax,%eax
  8022ee:	74 18                	je     802308 <initialize_MemBlocksList+0x88>
  8022f0:	a1 48 51 80 00       	mov    0x805148,%eax
  8022f5:	8b 15 50 50 80 00    	mov    0x805050,%edx
  8022fb:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8022fe:	c1 e1 04             	shl    $0x4,%ecx
  802301:	01 ca                	add    %ecx,%edx
  802303:	89 50 04             	mov    %edx,0x4(%eax)
  802306:	eb 12                	jmp    80231a <initialize_MemBlocksList+0x9a>
  802308:	a1 50 50 80 00       	mov    0x805050,%eax
  80230d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802310:	c1 e2 04             	shl    $0x4,%edx
  802313:	01 d0                	add    %edx,%eax
  802315:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80231a:	a1 50 50 80 00       	mov    0x805050,%eax
  80231f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802322:	c1 e2 04             	shl    $0x4,%edx
  802325:	01 d0                	add    %edx,%eax
  802327:	a3 48 51 80 00       	mov    %eax,0x805148
  80232c:	a1 50 50 80 00       	mov    0x805050,%eax
  802331:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802334:	c1 e2 04             	shl    $0x4,%edx
  802337:	01 d0                	add    %edx,%eax
  802339:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802340:	a1 54 51 80 00       	mov    0x805154,%eax
  802345:	40                   	inc    %eax
  802346:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  80234b:	ff 45 f4             	incl   -0xc(%ebp)
  80234e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802351:	3b 45 08             	cmp    0x8(%ebp),%eax
  802354:	0f 82 56 ff ff ff    	jb     8022b0 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  80235a:	90                   	nop
  80235b:	c9                   	leave  
  80235c:	c3                   	ret    

0080235d <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80235d:	55                   	push   %ebp
  80235e:	89 e5                	mov    %esp,%ebp
  802360:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802363:	8b 45 08             	mov    0x8(%ebp),%eax
  802366:	8b 00                	mov    (%eax),%eax
  802368:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80236b:	eb 19                	jmp    802386 <find_block+0x29>
	{
		if(va==point->sva)
  80236d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802370:	8b 40 08             	mov    0x8(%eax),%eax
  802373:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802376:	75 05                	jne    80237d <find_block+0x20>
		   return point;
  802378:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80237b:	eb 36                	jmp    8023b3 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  80237d:	8b 45 08             	mov    0x8(%ebp),%eax
  802380:	8b 40 08             	mov    0x8(%eax),%eax
  802383:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802386:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80238a:	74 07                	je     802393 <find_block+0x36>
  80238c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80238f:	8b 00                	mov    (%eax),%eax
  802391:	eb 05                	jmp    802398 <find_block+0x3b>
  802393:	b8 00 00 00 00       	mov    $0x0,%eax
  802398:	8b 55 08             	mov    0x8(%ebp),%edx
  80239b:	89 42 08             	mov    %eax,0x8(%edx)
  80239e:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a1:	8b 40 08             	mov    0x8(%eax),%eax
  8023a4:	85 c0                	test   %eax,%eax
  8023a6:	75 c5                	jne    80236d <find_block+0x10>
  8023a8:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8023ac:	75 bf                	jne    80236d <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  8023ae:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023b3:	c9                   	leave  
  8023b4:	c3                   	ret    

008023b5 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8023b5:	55                   	push   %ebp
  8023b6:	89 e5                	mov    %esp,%ebp
  8023b8:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  8023bb:	a1 40 50 80 00       	mov    0x805040,%eax
  8023c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  8023c3:	a1 44 50 80 00       	mov    0x805044,%eax
  8023c8:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  8023cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023ce:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8023d1:	74 24                	je     8023f7 <insert_sorted_allocList+0x42>
  8023d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d6:	8b 50 08             	mov    0x8(%eax),%edx
  8023d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023dc:	8b 40 08             	mov    0x8(%eax),%eax
  8023df:	39 c2                	cmp    %eax,%edx
  8023e1:	76 14                	jbe    8023f7 <insert_sorted_allocList+0x42>
  8023e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e6:	8b 50 08             	mov    0x8(%eax),%edx
  8023e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023ec:	8b 40 08             	mov    0x8(%eax),%eax
  8023ef:	39 c2                	cmp    %eax,%edx
  8023f1:	0f 82 60 01 00 00    	jb     802557 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  8023f7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8023fb:	75 65                	jne    802462 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  8023fd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802401:	75 14                	jne    802417 <insert_sorted_allocList+0x62>
  802403:	83 ec 04             	sub    $0x4,%esp
  802406:	68 64 45 80 00       	push   $0x804564
  80240b:	6a 6b                	push   $0x6b
  80240d:	68 87 45 80 00       	push   $0x804587
  802412:	e8 9c e2 ff ff       	call   8006b3 <_panic>
  802417:	8b 15 40 50 80 00    	mov    0x805040,%edx
  80241d:	8b 45 08             	mov    0x8(%ebp),%eax
  802420:	89 10                	mov    %edx,(%eax)
  802422:	8b 45 08             	mov    0x8(%ebp),%eax
  802425:	8b 00                	mov    (%eax),%eax
  802427:	85 c0                	test   %eax,%eax
  802429:	74 0d                	je     802438 <insert_sorted_allocList+0x83>
  80242b:	a1 40 50 80 00       	mov    0x805040,%eax
  802430:	8b 55 08             	mov    0x8(%ebp),%edx
  802433:	89 50 04             	mov    %edx,0x4(%eax)
  802436:	eb 08                	jmp    802440 <insert_sorted_allocList+0x8b>
  802438:	8b 45 08             	mov    0x8(%ebp),%eax
  80243b:	a3 44 50 80 00       	mov    %eax,0x805044
  802440:	8b 45 08             	mov    0x8(%ebp),%eax
  802443:	a3 40 50 80 00       	mov    %eax,0x805040
  802448:	8b 45 08             	mov    0x8(%ebp),%eax
  80244b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802452:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802457:	40                   	inc    %eax
  802458:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80245d:	e9 dc 01 00 00       	jmp    80263e <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802462:	8b 45 08             	mov    0x8(%ebp),%eax
  802465:	8b 50 08             	mov    0x8(%eax),%edx
  802468:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80246b:	8b 40 08             	mov    0x8(%eax),%eax
  80246e:	39 c2                	cmp    %eax,%edx
  802470:	77 6c                	ja     8024de <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802472:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802476:	74 06                	je     80247e <insert_sorted_allocList+0xc9>
  802478:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80247c:	75 14                	jne    802492 <insert_sorted_allocList+0xdd>
  80247e:	83 ec 04             	sub    $0x4,%esp
  802481:	68 a0 45 80 00       	push   $0x8045a0
  802486:	6a 6f                	push   $0x6f
  802488:	68 87 45 80 00       	push   $0x804587
  80248d:	e8 21 e2 ff ff       	call   8006b3 <_panic>
  802492:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802495:	8b 50 04             	mov    0x4(%eax),%edx
  802498:	8b 45 08             	mov    0x8(%ebp),%eax
  80249b:	89 50 04             	mov    %edx,0x4(%eax)
  80249e:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024a4:	89 10                	mov    %edx,(%eax)
  8024a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024a9:	8b 40 04             	mov    0x4(%eax),%eax
  8024ac:	85 c0                	test   %eax,%eax
  8024ae:	74 0d                	je     8024bd <insert_sorted_allocList+0x108>
  8024b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024b3:	8b 40 04             	mov    0x4(%eax),%eax
  8024b6:	8b 55 08             	mov    0x8(%ebp),%edx
  8024b9:	89 10                	mov    %edx,(%eax)
  8024bb:	eb 08                	jmp    8024c5 <insert_sorted_allocList+0x110>
  8024bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c0:	a3 40 50 80 00       	mov    %eax,0x805040
  8024c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024c8:	8b 55 08             	mov    0x8(%ebp),%edx
  8024cb:	89 50 04             	mov    %edx,0x4(%eax)
  8024ce:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8024d3:	40                   	inc    %eax
  8024d4:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8024d9:	e9 60 01 00 00       	jmp    80263e <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  8024de:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e1:	8b 50 08             	mov    0x8(%eax),%edx
  8024e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024e7:	8b 40 08             	mov    0x8(%eax),%eax
  8024ea:	39 c2                	cmp    %eax,%edx
  8024ec:	0f 82 4c 01 00 00    	jb     80263e <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8024f2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8024f6:	75 14                	jne    80250c <insert_sorted_allocList+0x157>
  8024f8:	83 ec 04             	sub    $0x4,%esp
  8024fb:	68 d8 45 80 00       	push   $0x8045d8
  802500:	6a 73                	push   $0x73
  802502:	68 87 45 80 00       	push   $0x804587
  802507:	e8 a7 e1 ff ff       	call   8006b3 <_panic>
  80250c:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802512:	8b 45 08             	mov    0x8(%ebp),%eax
  802515:	89 50 04             	mov    %edx,0x4(%eax)
  802518:	8b 45 08             	mov    0x8(%ebp),%eax
  80251b:	8b 40 04             	mov    0x4(%eax),%eax
  80251e:	85 c0                	test   %eax,%eax
  802520:	74 0c                	je     80252e <insert_sorted_allocList+0x179>
  802522:	a1 44 50 80 00       	mov    0x805044,%eax
  802527:	8b 55 08             	mov    0x8(%ebp),%edx
  80252a:	89 10                	mov    %edx,(%eax)
  80252c:	eb 08                	jmp    802536 <insert_sorted_allocList+0x181>
  80252e:	8b 45 08             	mov    0x8(%ebp),%eax
  802531:	a3 40 50 80 00       	mov    %eax,0x805040
  802536:	8b 45 08             	mov    0x8(%ebp),%eax
  802539:	a3 44 50 80 00       	mov    %eax,0x805044
  80253e:	8b 45 08             	mov    0x8(%ebp),%eax
  802541:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802547:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80254c:	40                   	inc    %eax
  80254d:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802552:	e9 e7 00 00 00       	jmp    80263e <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802557:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80255a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  80255d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802564:	a1 40 50 80 00       	mov    0x805040,%eax
  802569:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80256c:	e9 9d 00 00 00       	jmp    80260e <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802571:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802574:	8b 00                	mov    (%eax),%eax
  802576:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802579:	8b 45 08             	mov    0x8(%ebp),%eax
  80257c:	8b 50 08             	mov    0x8(%eax),%edx
  80257f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802582:	8b 40 08             	mov    0x8(%eax),%eax
  802585:	39 c2                	cmp    %eax,%edx
  802587:	76 7d                	jbe    802606 <insert_sorted_allocList+0x251>
  802589:	8b 45 08             	mov    0x8(%ebp),%eax
  80258c:	8b 50 08             	mov    0x8(%eax),%edx
  80258f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802592:	8b 40 08             	mov    0x8(%eax),%eax
  802595:	39 c2                	cmp    %eax,%edx
  802597:	73 6d                	jae    802606 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802599:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80259d:	74 06                	je     8025a5 <insert_sorted_allocList+0x1f0>
  80259f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8025a3:	75 14                	jne    8025b9 <insert_sorted_allocList+0x204>
  8025a5:	83 ec 04             	sub    $0x4,%esp
  8025a8:	68 fc 45 80 00       	push   $0x8045fc
  8025ad:	6a 7f                	push   $0x7f
  8025af:	68 87 45 80 00       	push   $0x804587
  8025b4:	e8 fa e0 ff ff       	call   8006b3 <_panic>
  8025b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025bc:	8b 10                	mov    (%eax),%edx
  8025be:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c1:	89 10                	mov    %edx,(%eax)
  8025c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c6:	8b 00                	mov    (%eax),%eax
  8025c8:	85 c0                	test   %eax,%eax
  8025ca:	74 0b                	je     8025d7 <insert_sorted_allocList+0x222>
  8025cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025cf:	8b 00                	mov    (%eax),%eax
  8025d1:	8b 55 08             	mov    0x8(%ebp),%edx
  8025d4:	89 50 04             	mov    %edx,0x4(%eax)
  8025d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025da:	8b 55 08             	mov    0x8(%ebp),%edx
  8025dd:	89 10                	mov    %edx,(%eax)
  8025df:	8b 45 08             	mov    0x8(%ebp),%eax
  8025e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025e5:	89 50 04             	mov    %edx,0x4(%eax)
  8025e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8025eb:	8b 00                	mov    (%eax),%eax
  8025ed:	85 c0                	test   %eax,%eax
  8025ef:	75 08                	jne    8025f9 <insert_sorted_allocList+0x244>
  8025f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8025f4:	a3 44 50 80 00       	mov    %eax,0x805044
  8025f9:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8025fe:	40                   	inc    %eax
  8025ff:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802604:	eb 39                	jmp    80263f <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802606:	a1 48 50 80 00       	mov    0x805048,%eax
  80260b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80260e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802612:	74 07                	je     80261b <insert_sorted_allocList+0x266>
  802614:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802617:	8b 00                	mov    (%eax),%eax
  802619:	eb 05                	jmp    802620 <insert_sorted_allocList+0x26b>
  80261b:	b8 00 00 00 00       	mov    $0x0,%eax
  802620:	a3 48 50 80 00       	mov    %eax,0x805048
  802625:	a1 48 50 80 00       	mov    0x805048,%eax
  80262a:	85 c0                	test   %eax,%eax
  80262c:	0f 85 3f ff ff ff    	jne    802571 <insert_sorted_allocList+0x1bc>
  802632:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802636:	0f 85 35 ff ff ff    	jne    802571 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80263c:	eb 01                	jmp    80263f <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80263e:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80263f:	90                   	nop
  802640:	c9                   	leave  
  802641:	c3                   	ret    

00802642 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802642:	55                   	push   %ebp
  802643:	89 e5                	mov    %esp,%ebp
  802645:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802648:	a1 38 51 80 00       	mov    0x805138,%eax
  80264d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802650:	e9 85 01 00 00       	jmp    8027da <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802655:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802658:	8b 40 0c             	mov    0xc(%eax),%eax
  80265b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80265e:	0f 82 6e 01 00 00    	jb     8027d2 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802664:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802667:	8b 40 0c             	mov    0xc(%eax),%eax
  80266a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80266d:	0f 85 8a 00 00 00    	jne    8026fd <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802673:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802677:	75 17                	jne    802690 <alloc_block_FF+0x4e>
  802679:	83 ec 04             	sub    $0x4,%esp
  80267c:	68 30 46 80 00       	push   $0x804630
  802681:	68 93 00 00 00       	push   $0x93
  802686:	68 87 45 80 00       	push   $0x804587
  80268b:	e8 23 e0 ff ff       	call   8006b3 <_panic>
  802690:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802693:	8b 00                	mov    (%eax),%eax
  802695:	85 c0                	test   %eax,%eax
  802697:	74 10                	je     8026a9 <alloc_block_FF+0x67>
  802699:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269c:	8b 00                	mov    (%eax),%eax
  80269e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026a1:	8b 52 04             	mov    0x4(%edx),%edx
  8026a4:	89 50 04             	mov    %edx,0x4(%eax)
  8026a7:	eb 0b                	jmp    8026b4 <alloc_block_FF+0x72>
  8026a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ac:	8b 40 04             	mov    0x4(%eax),%eax
  8026af:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8026b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b7:	8b 40 04             	mov    0x4(%eax),%eax
  8026ba:	85 c0                	test   %eax,%eax
  8026bc:	74 0f                	je     8026cd <alloc_block_FF+0x8b>
  8026be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c1:	8b 40 04             	mov    0x4(%eax),%eax
  8026c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026c7:	8b 12                	mov    (%edx),%edx
  8026c9:	89 10                	mov    %edx,(%eax)
  8026cb:	eb 0a                	jmp    8026d7 <alloc_block_FF+0x95>
  8026cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d0:	8b 00                	mov    (%eax),%eax
  8026d2:	a3 38 51 80 00       	mov    %eax,0x805138
  8026d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026da:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026ea:	a1 44 51 80 00       	mov    0x805144,%eax
  8026ef:	48                   	dec    %eax
  8026f0:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  8026f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f8:	e9 10 01 00 00       	jmp    80280d <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  8026fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802700:	8b 40 0c             	mov    0xc(%eax),%eax
  802703:	3b 45 08             	cmp    0x8(%ebp),%eax
  802706:	0f 86 c6 00 00 00    	jbe    8027d2 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80270c:	a1 48 51 80 00       	mov    0x805148,%eax
  802711:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802714:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802717:	8b 50 08             	mov    0x8(%eax),%edx
  80271a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80271d:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802720:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802723:	8b 55 08             	mov    0x8(%ebp),%edx
  802726:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802729:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80272d:	75 17                	jne    802746 <alloc_block_FF+0x104>
  80272f:	83 ec 04             	sub    $0x4,%esp
  802732:	68 30 46 80 00       	push   $0x804630
  802737:	68 9b 00 00 00       	push   $0x9b
  80273c:	68 87 45 80 00       	push   $0x804587
  802741:	e8 6d df ff ff       	call   8006b3 <_panic>
  802746:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802749:	8b 00                	mov    (%eax),%eax
  80274b:	85 c0                	test   %eax,%eax
  80274d:	74 10                	je     80275f <alloc_block_FF+0x11d>
  80274f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802752:	8b 00                	mov    (%eax),%eax
  802754:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802757:	8b 52 04             	mov    0x4(%edx),%edx
  80275a:	89 50 04             	mov    %edx,0x4(%eax)
  80275d:	eb 0b                	jmp    80276a <alloc_block_FF+0x128>
  80275f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802762:	8b 40 04             	mov    0x4(%eax),%eax
  802765:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80276a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80276d:	8b 40 04             	mov    0x4(%eax),%eax
  802770:	85 c0                	test   %eax,%eax
  802772:	74 0f                	je     802783 <alloc_block_FF+0x141>
  802774:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802777:	8b 40 04             	mov    0x4(%eax),%eax
  80277a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80277d:	8b 12                	mov    (%edx),%edx
  80277f:	89 10                	mov    %edx,(%eax)
  802781:	eb 0a                	jmp    80278d <alloc_block_FF+0x14b>
  802783:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802786:	8b 00                	mov    (%eax),%eax
  802788:	a3 48 51 80 00       	mov    %eax,0x805148
  80278d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802790:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802796:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802799:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027a0:	a1 54 51 80 00       	mov    0x805154,%eax
  8027a5:	48                   	dec    %eax
  8027a6:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  8027ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ae:	8b 50 08             	mov    0x8(%eax),%edx
  8027b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8027b4:	01 c2                	add    %eax,%edx
  8027b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b9:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  8027bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027bf:	8b 40 0c             	mov    0xc(%eax),%eax
  8027c2:	2b 45 08             	sub    0x8(%ebp),%eax
  8027c5:	89 c2                	mov    %eax,%edx
  8027c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ca:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  8027cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027d0:	eb 3b                	jmp    80280d <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8027d2:	a1 40 51 80 00       	mov    0x805140,%eax
  8027d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027da:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027de:	74 07                	je     8027e7 <alloc_block_FF+0x1a5>
  8027e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e3:	8b 00                	mov    (%eax),%eax
  8027e5:	eb 05                	jmp    8027ec <alloc_block_FF+0x1aa>
  8027e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8027ec:	a3 40 51 80 00       	mov    %eax,0x805140
  8027f1:	a1 40 51 80 00       	mov    0x805140,%eax
  8027f6:	85 c0                	test   %eax,%eax
  8027f8:	0f 85 57 fe ff ff    	jne    802655 <alloc_block_FF+0x13>
  8027fe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802802:	0f 85 4d fe ff ff    	jne    802655 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802808:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80280d:	c9                   	leave  
  80280e:	c3                   	ret    

0080280f <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  80280f:	55                   	push   %ebp
  802810:	89 e5                	mov    %esp,%ebp
  802812:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802815:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  80281c:	a1 38 51 80 00       	mov    0x805138,%eax
  802821:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802824:	e9 df 00 00 00       	jmp    802908 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802829:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282c:	8b 40 0c             	mov    0xc(%eax),%eax
  80282f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802832:	0f 82 c8 00 00 00    	jb     802900 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802838:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283b:	8b 40 0c             	mov    0xc(%eax),%eax
  80283e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802841:	0f 85 8a 00 00 00    	jne    8028d1 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802847:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80284b:	75 17                	jne    802864 <alloc_block_BF+0x55>
  80284d:	83 ec 04             	sub    $0x4,%esp
  802850:	68 30 46 80 00       	push   $0x804630
  802855:	68 b7 00 00 00       	push   $0xb7
  80285a:	68 87 45 80 00       	push   $0x804587
  80285f:	e8 4f de ff ff       	call   8006b3 <_panic>
  802864:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802867:	8b 00                	mov    (%eax),%eax
  802869:	85 c0                	test   %eax,%eax
  80286b:	74 10                	je     80287d <alloc_block_BF+0x6e>
  80286d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802870:	8b 00                	mov    (%eax),%eax
  802872:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802875:	8b 52 04             	mov    0x4(%edx),%edx
  802878:	89 50 04             	mov    %edx,0x4(%eax)
  80287b:	eb 0b                	jmp    802888 <alloc_block_BF+0x79>
  80287d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802880:	8b 40 04             	mov    0x4(%eax),%eax
  802883:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802888:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288b:	8b 40 04             	mov    0x4(%eax),%eax
  80288e:	85 c0                	test   %eax,%eax
  802890:	74 0f                	je     8028a1 <alloc_block_BF+0x92>
  802892:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802895:	8b 40 04             	mov    0x4(%eax),%eax
  802898:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80289b:	8b 12                	mov    (%edx),%edx
  80289d:	89 10                	mov    %edx,(%eax)
  80289f:	eb 0a                	jmp    8028ab <alloc_block_BF+0x9c>
  8028a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a4:	8b 00                	mov    (%eax),%eax
  8028a6:	a3 38 51 80 00       	mov    %eax,0x805138
  8028ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ae:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028be:	a1 44 51 80 00       	mov    0x805144,%eax
  8028c3:	48                   	dec    %eax
  8028c4:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  8028c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028cc:	e9 4d 01 00 00       	jmp    802a1e <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  8028d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d4:	8b 40 0c             	mov    0xc(%eax),%eax
  8028d7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028da:	76 24                	jbe    802900 <alloc_block_BF+0xf1>
  8028dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028df:	8b 40 0c             	mov    0xc(%eax),%eax
  8028e2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8028e5:	73 19                	jae    802900 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  8028e7:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  8028ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f1:	8b 40 0c             	mov    0xc(%eax),%eax
  8028f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  8028f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028fa:	8b 40 08             	mov    0x8(%eax),%eax
  8028fd:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802900:	a1 40 51 80 00       	mov    0x805140,%eax
  802905:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802908:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80290c:	74 07                	je     802915 <alloc_block_BF+0x106>
  80290e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802911:	8b 00                	mov    (%eax),%eax
  802913:	eb 05                	jmp    80291a <alloc_block_BF+0x10b>
  802915:	b8 00 00 00 00       	mov    $0x0,%eax
  80291a:	a3 40 51 80 00       	mov    %eax,0x805140
  80291f:	a1 40 51 80 00       	mov    0x805140,%eax
  802924:	85 c0                	test   %eax,%eax
  802926:	0f 85 fd fe ff ff    	jne    802829 <alloc_block_BF+0x1a>
  80292c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802930:	0f 85 f3 fe ff ff    	jne    802829 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802936:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80293a:	0f 84 d9 00 00 00    	je     802a19 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802940:	a1 48 51 80 00       	mov    0x805148,%eax
  802945:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802948:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80294b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80294e:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802951:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802954:	8b 55 08             	mov    0x8(%ebp),%edx
  802957:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  80295a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80295e:	75 17                	jne    802977 <alloc_block_BF+0x168>
  802960:	83 ec 04             	sub    $0x4,%esp
  802963:	68 30 46 80 00       	push   $0x804630
  802968:	68 c7 00 00 00       	push   $0xc7
  80296d:	68 87 45 80 00       	push   $0x804587
  802972:	e8 3c dd ff ff       	call   8006b3 <_panic>
  802977:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80297a:	8b 00                	mov    (%eax),%eax
  80297c:	85 c0                	test   %eax,%eax
  80297e:	74 10                	je     802990 <alloc_block_BF+0x181>
  802980:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802983:	8b 00                	mov    (%eax),%eax
  802985:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802988:	8b 52 04             	mov    0x4(%edx),%edx
  80298b:	89 50 04             	mov    %edx,0x4(%eax)
  80298e:	eb 0b                	jmp    80299b <alloc_block_BF+0x18c>
  802990:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802993:	8b 40 04             	mov    0x4(%eax),%eax
  802996:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80299b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80299e:	8b 40 04             	mov    0x4(%eax),%eax
  8029a1:	85 c0                	test   %eax,%eax
  8029a3:	74 0f                	je     8029b4 <alloc_block_BF+0x1a5>
  8029a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029a8:	8b 40 04             	mov    0x4(%eax),%eax
  8029ab:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8029ae:	8b 12                	mov    (%edx),%edx
  8029b0:	89 10                	mov    %edx,(%eax)
  8029b2:	eb 0a                	jmp    8029be <alloc_block_BF+0x1af>
  8029b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029b7:	8b 00                	mov    (%eax),%eax
  8029b9:	a3 48 51 80 00       	mov    %eax,0x805148
  8029be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029c1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029ca:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029d1:	a1 54 51 80 00       	mov    0x805154,%eax
  8029d6:	48                   	dec    %eax
  8029d7:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  8029dc:	83 ec 08             	sub    $0x8,%esp
  8029df:	ff 75 ec             	pushl  -0x14(%ebp)
  8029e2:	68 38 51 80 00       	push   $0x805138
  8029e7:	e8 71 f9 ff ff       	call   80235d <find_block>
  8029ec:	83 c4 10             	add    $0x10,%esp
  8029ef:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  8029f2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029f5:	8b 50 08             	mov    0x8(%eax),%edx
  8029f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8029fb:	01 c2                	add    %eax,%edx
  8029fd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a00:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802a03:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a06:	8b 40 0c             	mov    0xc(%eax),%eax
  802a09:	2b 45 08             	sub    0x8(%ebp),%eax
  802a0c:	89 c2                	mov    %eax,%edx
  802a0e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a11:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802a14:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a17:	eb 05                	jmp    802a1e <alloc_block_BF+0x20f>
	}
	return NULL;
  802a19:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a1e:	c9                   	leave  
  802a1f:	c3                   	ret    

00802a20 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802a20:	55                   	push   %ebp
  802a21:	89 e5                	mov    %esp,%ebp
  802a23:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802a26:	a1 28 50 80 00       	mov    0x805028,%eax
  802a2b:	85 c0                	test   %eax,%eax
  802a2d:	0f 85 de 01 00 00    	jne    802c11 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802a33:	a1 38 51 80 00       	mov    0x805138,%eax
  802a38:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a3b:	e9 9e 01 00 00       	jmp    802bde <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802a40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a43:	8b 40 0c             	mov    0xc(%eax),%eax
  802a46:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a49:	0f 82 87 01 00 00    	jb     802bd6 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802a4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a52:	8b 40 0c             	mov    0xc(%eax),%eax
  802a55:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a58:	0f 85 95 00 00 00    	jne    802af3 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802a5e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a62:	75 17                	jne    802a7b <alloc_block_NF+0x5b>
  802a64:	83 ec 04             	sub    $0x4,%esp
  802a67:	68 30 46 80 00       	push   $0x804630
  802a6c:	68 e0 00 00 00       	push   $0xe0
  802a71:	68 87 45 80 00       	push   $0x804587
  802a76:	e8 38 dc ff ff       	call   8006b3 <_panic>
  802a7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7e:	8b 00                	mov    (%eax),%eax
  802a80:	85 c0                	test   %eax,%eax
  802a82:	74 10                	je     802a94 <alloc_block_NF+0x74>
  802a84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a87:	8b 00                	mov    (%eax),%eax
  802a89:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a8c:	8b 52 04             	mov    0x4(%edx),%edx
  802a8f:	89 50 04             	mov    %edx,0x4(%eax)
  802a92:	eb 0b                	jmp    802a9f <alloc_block_NF+0x7f>
  802a94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a97:	8b 40 04             	mov    0x4(%eax),%eax
  802a9a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802a9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa2:	8b 40 04             	mov    0x4(%eax),%eax
  802aa5:	85 c0                	test   %eax,%eax
  802aa7:	74 0f                	je     802ab8 <alloc_block_NF+0x98>
  802aa9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aac:	8b 40 04             	mov    0x4(%eax),%eax
  802aaf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ab2:	8b 12                	mov    (%edx),%edx
  802ab4:	89 10                	mov    %edx,(%eax)
  802ab6:	eb 0a                	jmp    802ac2 <alloc_block_NF+0xa2>
  802ab8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802abb:	8b 00                	mov    (%eax),%eax
  802abd:	a3 38 51 80 00       	mov    %eax,0x805138
  802ac2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802acb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ace:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ad5:	a1 44 51 80 00       	mov    0x805144,%eax
  802ada:	48                   	dec    %eax
  802adb:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802ae0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae3:	8b 40 08             	mov    0x8(%eax),%eax
  802ae6:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  802aeb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aee:	e9 f8 04 00 00       	jmp    802feb <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802af3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af6:	8b 40 0c             	mov    0xc(%eax),%eax
  802af9:	3b 45 08             	cmp    0x8(%ebp),%eax
  802afc:	0f 86 d4 00 00 00    	jbe    802bd6 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802b02:	a1 48 51 80 00       	mov    0x805148,%eax
  802b07:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802b0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0d:	8b 50 08             	mov    0x8(%eax),%edx
  802b10:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b13:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802b16:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b19:	8b 55 08             	mov    0x8(%ebp),%edx
  802b1c:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802b1f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b23:	75 17                	jne    802b3c <alloc_block_NF+0x11c>
  802b25:	83 ec 04             	sub    $0x4,%esp
  802b28:	68 30 46 80 00       	push   $0x804630
  802b2d:	68 e9 00 00 00       	push   $0xe9
  802b32:	68 87 45 80 00       	push   $0x804587
  802b37:	e8 77 db ff ff       	call   8006b3 <_panic>
  802b3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b3f:	8b 00                	mov    (%eax),%eax
  802b41:	85 c0                	test   %eax,%eax
  802b43:	74 10                	je     802b55 <alloc_block_NF+0x135>
  802b45:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b48:	8b 00                	mov    (%eax),%eax
  802b4a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b4d:	8b 52 04             	mov    0x4(%edx),%edx
  802b50:	89 50 04             	mov    %edx,0x4(%eax)
  802b53:	eb 0b                	jmp    802b60 <alloc_block_NF+0x140>
  802b55:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b58:	8b 40 04             	mov    0x4(%eax),%eax
  802b5b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b60:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b63:	8b 40 04             	mov    0x4(%eax),%eax
  802b66:	85 c0                	test   %eax,%eax
  802b68:	74 0f                	je     802b79 <alloc_block_NF+0x159>
  802b6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b6d:	8b 40 04             	mov    0x4(%eax),%eax
  802b70:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b73:	8b 12                	mov    (%edx),%edx
  802b75:	89 10                	mov    %edx,(%eax)
  802b77:	eb 0a                	jmp    802b83 <alloc_block_NF+0x163>
  802b79:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b7c:	8b 00                	mov    (%eax),%eax
  802b7e:	a3 48 51 80 00       	mov    %eax,0x805148
  802b83:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b86:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b8f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b96:	a1 54 51 80 00       	mov    0x805154,%eax
  802b9b:	48                   	dec    %eax
  802b9c:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802ba1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ba4:	8b 40 08             	mov    0x8(%eax),%eax
  802ba7:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802bac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802baf:	8b 50 08             	mov    0x8(%eax),%edx
  802bb2:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb5:	01 c2                	add    %eax,%edx
  802bb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bba:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802bbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc0:	8b 40 0c             	mov    0xc(%eax),%eax
  802bc3:	2b 45 08             	sub    0x8(%ebp),%eax
  802bc6:	89 c2                	mov    %eax,%edx
  802bc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bcb:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802bce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bd1:	e9 15 04 00 00       	jmp    802feb <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802bd6:	a1 40 51 80 00       	mov    0x805140,%eax
  802bdb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bde:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802be2:	74 07                	je     802beb <alloc_block_NF+0x1cb>
  802be4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be7:	8b 00                	mov    (%eax),%eax
  802be9:	eb 05                	jmp    802bf0 <alloc_block_NF+0x1d0>
  802beb:	b8 00 00 00 00       	mov    $0x0,%eax
  802bf0:	a3 40 51 80 00       	mov    %eax,0x805140
  802bf5:	a1 40 51 80 00       	mov    0x805140,%eax
  802bfa:	85 c0                	test   %eax,%eax
  802bfc:	0f 85 3e fe ff ff    	jne    802a40 <alloc_block_NF+0x20>
  802c02:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c06:	0f 85 34 fe ff ff    	jne    802a40 <alloc_block_NF+0x20>
  802c0c:	e9 d5 03 00 00       	jmp    802fe6 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802c11:	a1 38 51 80 00       	mov    0x805138,%eax
  802c16:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c19:	e9 b1 01 00 00       	jmp    802dcf <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802c1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c21:	8b 50 08             	mov    0x8(%eax),%edx
  802c24:	a1 28 50 80 00       	mov    0x805028,%eax
  802c29:	39 c2                	cmp    %eax,%edx
  802c2b:	0f 82 96 01 00 00    	jb     802dc7 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802c31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c34:	8b 40 0c             	mov    0xc(%eax),%eax
  802c37:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c3a:	0f 82 87 01 00 00    	jb     802dc7 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802c40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c43:	8b 40 0c             	mov    0xc(%eax),%eax
  802c46:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c49:	0f 85 95 00 00 00    	jne    802ce4 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802c4f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c53:	75 17                	jne    802c6c <alloc_block_NF+0x24c>
  802c55:	83 ec 04             	sub    $0x4,%esp
  802c58:	68 30 46 80 00       	push   $0x804630
  802c5d:	68 fc 00 00 00       	push   $0xfc
  802c62:	68 87 45 80 00       	push   $0x804587
  802c67:	e8 47 da ff ff       	call   8006b3 <_panic>
  802c6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c6f:	8b 00                	mov    (%eax),%eax
  802c71:	85 c0                	test   %eax,%eax
  802c73:	74 10                	je     802c85 <alloc_block_NF+0x265>
  802c75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c78:	8b 00                	mov    (%eax),%eax
  802c7a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c7d:	8b 52 04             	mov    0x4(%edx),%edx
  802c80:	89 50 04             	mov    %edx,0x4(%eax)
  802c83:	eb 0b                	jmp    802c90 <alloc_block_NF+0x270>
  802c85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c88:	8b 40 04             	mov    0x4(%eax),%eax
  802c8b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c93:	8b 40 04             	mov    0x4(%eax),%eax
  802c96:	85 c0                	test   %eax,%eax
  802c98:	74 0f                	je     802ca9 <alloc_block_NF+0x289>
  802c9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9d:	8b 40 04             	mov    0x4(%eax),%eax
  802ca0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ca3:	8b 12                	mov    (%edx),%edx
  802ca5:	89 10                	mov    %edx,(%eax)
  802ca7:	eb 0a                	jmp    802cb3 <alloc_block_NF+0x293>
  802ca9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cac:	8b 00                	mov    (%eax),%eax
  802cae:	a3 38 51 80 00       	mov    %eax,0x805138
  802cb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cbf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cc6:	a1 44 51 80 00       	mov    0x805144,%eax
  802ccb:	48                   	dec    %eax
  802ccc:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802cd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd4:	8b 40 08             	mov    0x8(%eax),%eax
  802cd7:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802cdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cdf:	e9 07 03 00 00       	jmp    802feb <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802ce4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce7:	8b 40 0c             	mov    0xc(%eax),%eax
  802cea:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ced:	0f 86 d4 00 00 00    	jbe    802dc7 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802cf3:	a1 48 51 80 00       	mov    0x805148,%eax
  802cf8:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802cfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cfe:	8b 50 08             	mov    0x8(%eax),%edx
  802d01:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d04:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802d07:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d0a:	8b 55 08             	mov    0x8(%ebp),%edx
  802d0d:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802d10:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802d14:	75 17                	jne    802d2d <alloc_block_NF+0x30d>
  802d16:	83 ec 04             	sub    $0x4,%esp
  802d19:	68 30 46 80 00       	push   $0x804630
  802d1e:	68 04 01 00 00       	push   $0x104
  802d23:	68 87 45 80 00       	push   $0x804587
  802d28:	e8 86 d9 ff ff       	call   8006b3 <_panic>
  802d2d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d30:	8b 00                	mov    (%eax),%eax
  802d32:	85 c0                	test   %eax,%eax
  802d34:	74 10                	je     802d46 <alloc_block_NF+0x326>
  802d36:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d39:	8b 00                	mov    (%eax),%eax
  802d3b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d3e:	8b 52 04             	mov    0x4(%edx),%edx
  802d41:	89 50 04             	mov    %edx,0x4(%eax)
  802d44:	eb 0b                	jmp    802d51 <alloc_block_NF+0x331>
  802d46:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d49:	8b 40 04             	mov    0x4(%eax),%eax
  802d4c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d51:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d54:	8b 40 04             	mov    0x4(%eax),%eax
  802d57:	85 c0                	test   %eax,%eax
  802d59:	74 0f                	je     802d6a <alloc_block_NF+0x34a>
  802d5b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d5e:	8b 40 04             	mov    0x4(%eax),%eax
  802d61:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d64:	8b 12                	mov    (%edx),%edx
  802d66:	89 10                	mov    %edx,(%eax)
  802d68:	eb 0a                	jmp    802d74 <alloc_block_NF+0x354>
  802d6a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d6d:	8b 00                	mov    (%eax),%eax
  802d6f:	a3 48 51 80 00       	mov    %eax,0x805148
  802d74:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d77:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d7d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d80:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d87:	a1 54 51 80 00       	mov    0x805154,%eax
  802d8c:	48                   	dec    %eax
  802d8d:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802d92:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d95:	8b 40 08             	mov    0x8(%eax),%eax
  802d98:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802d9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da0:	8b 50 08             	mov    0x8(%eax),%edx
  802da3:	8b 45 08             	mov    0x8(%ebp),%eax
  802da6:	01 c2                	add    %eax,%edx
  802da8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dab:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802dae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db1:	8b 40 0c             	mov    0xc(%eax),%eax
  802db4:	2b 45 08             	sub    0x8(%ebp),%eax
  802db7:	89 c2                	mov    %eax,%edx
  802db9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dbc:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802dbf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dc2:	e9 24 02 00 00       	jmp    802feb <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802dc7:	a1 40 51 80 00       	mov    0x805140,%eax
  802dcc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802dcf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dd3:	74 07                	je     802ddc <alloc_block_NF+0x3bc>
  802dd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd8:	8b 00                	mov    (%eax),%eax
  802dda:	eb 05                	jmp    802de1 <alloc_block_NF+0x3c1>
  802ddc:	b8 00 00 00 00       	mov    $0x0,%eax
  802de1:	a3 40 51 80 00       	mov    %eax,0x805140
  802de6:	a1 40 51 80 00       	mov    0x805140,%eax
  802deb:	85 c0                	test   %eax,%eax
  802ded:	0f 85 2b fe ff ff    	jne    802c1e <alloc_block_NF+0x1fe>
  802df3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802df7:	0f 85 21 fe ff ff    	jne    802c1e <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802dfd:	a1 38 51 80 00       	mov    0x805138,%eax
  802e02:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e05:	e9 ae 01 00 00       	jmp    802fb8 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802e0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e0d:	8b 50 08             	mov    0x8(%eax),%edx
  802e10:	a1 28 50 80 00       	mov    0x805028,%eax
  802e15:	39 c2                	cmp    %eax,%edx
  802e17:	0f 83 93 01 00 00    	jae    802fb0 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802e1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e20:	8b 40 0c             	mov    0xc(%eax),%eax
  802e23:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e26:	0f 82 84 01 00 00    	jb     802fb0 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802e2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e2f:	8b 40 0c             	mov    0xc(%eax),%eax
  802e32:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e35:	0f 85 95 00 00 00    	jne    802ed0 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802e3b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e3f:	75 17                	jne    802e58 <alloc_block_NF+0x438>
  802e41:	83 ec 04             	sub    $0x4,%esp
  802e44:	68 30 46 80 00       	push   $0x804630
  802e49:	68 14 01 00 00       	push   $0x114
  802e4e:	68 87 45 80 00       	push   $0x804587
  802e53:	e8 5b d8 ff ff       	call   8006b3 <_panic>
  802e58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e5b:	8b 00                	mov    (%eax),%eax
  802e5d:	85 c0                	test   %eax,%eax
  802e5f:	74 10                	je     802e71 <alloc_block_NF+0x451>
  802e61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e64:	8b 00                	mov    (%eax),%eax
  802e66:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e69:	8b 52 04             	mov    0x4(%edx),%edx
  802e6c:	89 50 04             	mov    %edx,0x4(%eax)
  802e6f:	eb 0b                	jmp    802e7c <alloc_block_NF+0x45c>
  802e71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e74:	8b 40 04             	mov    0x4(%eax),%eax
  802e77:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e7f:	8b 40 04             	mov    0x4(%eax),%eax
  802e82:	85 c0                	test   %eax,%eax
  802e84:	74 0f                	je     802e95 <alloc_block_NF+0x475>
  802e86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e89:	8b 40 04             	mov    0x4(%eax),%eax
  802e8c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e8f:	8b 12                	mov    (%edx),%edx
  802e91:	89 10                	mov    %edx,(%eax)
  802e93:	eb 0a                	jmp    802e9f <alloc_block_NF+0x47f>
  802e95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e98:	8b 00                	mov    (%eax),%eax
  802e9a:	a3 38 51 80 00       	mov    %eax,0x805138
  802e9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ea8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eab:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802eb2:	a1 44 51 80 00       	mov    0x805144,%eax
  802eb7:	48                   	dec    %eax
  802eb8:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802ebd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec0:	8b 40 08             	mov    0x8(%eax),%eax
  802ec3:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802ec8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ecb:	e9 1b 01 00 00       	jmp    802feb <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802ed0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed3:	8b 40 0c             	mov    0xc(%eax),%eax
  802ed6:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ed9:	0f 86 d1 00 00 00    	jbe    802fb0 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802edf:	a1 48 51 80 00       	mov    0x805148,%eax
  802ee4:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802ee7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eea:	8b 50 08             	mov    0x8(%eax),%edx
  802eed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ef0:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802ef3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ef6:	8b 55 08             	mov    0x8(%ebp),%edx
  802ef9:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802efc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802f00:	75 17                	jne    802f19 <alloc_block_NF+0x4f9>
  802f02:	83 ec 04             	sub    $0x4,%esp
  802f05:	68 30 46 80 00       	push   $0x804630
  802f0a:	68 1c 01 00 00       	push   $0x11c
  802f0f:	68 87 45 80 00       	push   $0x804587
  802f14:	e8 9a d7 ff ff       	call   8006b3 <_panic>
  802f19:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f1c:	8b 00                	mov    (%eax),%eax
  802f1e:	85 c0                	test   %eax,%eax
  802f20:	74 10                	je     802f32 <alloc_block_NF+0x512>
  802f22:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f25:	8b 00                	mov    (%eax),%eax
  802f27:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802f2a:	8b 52 04             	mov    0x4(%edx),%edx
  802f2d:	89 50 04             	mov    %edx,0x4(%eax)
  802f30:	eb 0b                	jmp    802f3d <alloc_block_NF+0x51d>
  802f32:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f35:	8b 40 04             	mov    0x4(%eax),%eax
  802f38:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f3d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f40:	8b 40 04             	mov    0x4(%eax),%eax
  802f43:	85 c0                	test   %eax,%eax
  802f45:	74 0f                	je     802f56 <alloc_block_NF+0x536>
  802f47:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f4a:	8b 40 04             	mov    0x4(%eax),%eax
  802f4d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802f50:	8b 12                	mov    (%edx),%edx
  802f52:	89 10                	mov    %edx,(%eax)
  802f54:	eb 0a                	jmp    802f60 <alloc_block_NF+0x540>
  802f56:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f59:	8b 00                	mov    (%eax),%eax
  802f5b:	a3 48 51 80 00       	mov    %eax,0x805148
  802f60:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f63:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f69:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f6c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f73:	a1 54 51 80 00       	mov    0x805154,%eax
  802f78:	48                   	dec    %eax
  802f79:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802f7e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f81:	8b 40 08             	mov    0x8(%eax),%eax
  802f84:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802f89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f8c:	8b 50 08             	mov    0x8(%eax),%edx
  802f8f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f92:	01 c2                	add    %eax,%edx
  802f94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f97:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802f9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f9d:	8b 40 0c             	mov    0xc(%eax),%eax
  802fa0:	2b 45 08             	sub    0x8(%ebp),%eax
  802fa3:	89 c2                	mov    %eax,%edx
  802fa5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa8:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802fab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fae:	eb 3b                	jmp    802feb <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802fb0:	a1 40 51 80 00       	mov    0x805140,%eax
  802fb5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fb8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fbc:	74 07                	je     802fc5 <alloc_block_NF+0x5a5>
  802fbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc1:	8b 00                	mov    (%eax),%eax
  802fc3:	eb 05                	jmp    802fca <alloc_block_NF+0x5aa>
  802fc5:	b8 00 00 00 00       	mov    $0x0,%eax
  802fca:	a3 40 51 80 00       	mov    %eax,0x805140
  802fcf:	a1 40 51 80 00       	mov    0x805140,%eax
  802fd4:	85 c0                	test   %eax,%eax
  802fd6:	0f 85 2e fe ff ff    	jne    802e0a <alloc_block_NF+0x3ea>
  802fdc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fe0:	0f 85 24 fe ff ff    	jne    802e0a <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802fe6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802feb:	c9                   	leave  
  802fec:	c3                   	ret    

00802fed <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802fed:	55                   	push   %ebp
  802fee:	89 e5                	mov    %esp,%ebp
  802ff0:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802ff3:	a1 38 51 80 00       	mov    0x805138,%eax
  802ff8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802ffb:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803000:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  803003:	a1 38 51 80 00       	mov    0x805138,%eax
  803008:	85 c0                	test   %eax,%eax
  80300a:	74 14                	je     803020 <insert_sorted_with_merge_freeList+0x33>
  80300c:	8b 45 08             	mov    0x8(%ebp),%eax
  80300f:	8b 50 08             	mov    0x8(%eax),%edx
  803012:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803015:	8b 40 08             	mov    0x8(%eax),%eax
  803018:	39 c2                	cmp    %eax,%edx
  80301a:	0f 87 9b 01 00 00    	ja     8031bb <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  803020:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803024:	75 17                	jne    80303d <insert_sorted_with_merge_freeList+0x50>
  803026:	83 ec 04             	sub    $0x4,%esp
  803029:	68 64 45 80 00       	push   $0x804564
  80302e:	68 38 01 00 00       	push   $0x138
  803033:	68 87 45 80 00       	push   $0x804587
  803038:	e8 76 d6 ff ff       	call   8006b3 <_panic>
  80303d:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803043:	8b 45 08             	mov    0x8(%ebp),%eax
  803046:	89 10                	mov    %edx,(%eax)
  803048:	8b 45 08             	mov    0x8(%ebp),%eax
  80304b:	8b 00                	mov    (%eax),%eax
  80304d:	85 c0                	test   %eax,%eax
  80304f:	74 0d                	je     80305e <insert_sorted_with_merge_freeList+0x71>
  803051:	a1 38 51 80 00       	mov    0x805138,%eax
  803056:	8b 55 08             	mov    0x8(%ebp),%edx
  803059:	89 50 04             	mov    %edx,0x4(%eax)
  80305c:	eb 08                	jmp    803066 <insert_sorted_with_merge_freeList+0x79>
  80305e:	8b 45 08             	mov    0x8(%ebp),%eax
  803061:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803066:	8b 45 08             	mov    0x8(%ebp),%eax
  803069:	a3 38 51 80 00       	mov    %eax,0x805138
  80306e:	8b 45 08             	mov    0x8(%ebp),%eax
  803071:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803078:	a1 44 51 80 00       	mov    0x805144,%eax
  80307d:	40                   	inc    %eax
  80307e:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803083:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803087:	0f 84 a8 06 00 00    	je     803735 <insert_sorted_with_merge_freeList+0x748>
  80308d:	8b 45 08             	mov    0x8(%ebp),%eax
  803090:	8b 50 08             	mov    0x8(%eax),%edx
  803093:	8b 45 08             	mov    0x8(%ebp),%eax
  803096:	8b 40 0c             	mov    0xc(%eax),%eax
  803099:	01 c2                	add    %eax,%edx
  80309b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80309e:	8b 40 08             	mov    0x8(%eax),%eax
  8030a1:	39 c2                	cmp    %eax,%edx
  8030a3:	0f 85 8c 06 00 00    	jne    803735 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  8030a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ac:	8b 50 0c             	mov    0xc(%eax),%edx
  8030af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030b2:	8b 40 0c             	mov    0xc(%eax),%eax
  8030b5:	01 c2                	add    %eax,%edx
  8030b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ba:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  8030bd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8030c1:	75 17                	jne    8030da <insert_sorted_with_merge_freeList+0xed>
  8030c3:	83 ec 04             	sub    $0x4,%esp
  8030c6:	68 30 46 80 00       	push   $0x804630
  8030cb:	68 3c 01 00 00       	push   $0x13c
  8030d0:	68 87 45 80 00       	push   $0x804587
  8030d5:	e8 d9 d5 ff ff       	call   8006b3 <_panic>
  8030da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030dd:	8b 00                	mov    (%eax),%eax
  8030df:	85 c0                	test   %eax,%eax
  8030e1:	74 10                	je     8030f3 <insert_sorted_with_merge_freeList+0x106>
  8030e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030e6:	8b 00                	mov    (%eax),%eax
  8030e8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8030eb:	8b 52 04             	mov    0x4(%edx),%edx
  8030ee:	89 50 04             	mov    %edx,0x4(%eax)
  8030f1:	eb 0b                	jmp    8030fe <insert_sorted_with_merge_freeList+0x111>
  8030f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030f6:	8b 40 04             	mov    0x4(%eax),%eax
  8030f9:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8030fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803101:	8b 40 04             	mov    0x4(%eax),%eax
  803104:	85 c0                	test   %eax,%eax
  803106:	74 0f                	je     803117 <insert_sorted_with_merge_freeList+0x12a>
  803108:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80310b:	8b 40 04             	mov    0x4(%eax),%eax
  80310e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803111:	8b 12                	mov    (%edx),%edx
  803113:	89 10                	mov    %edx,(%eax)
  803115:	eb 0a                	jmp    803121 <insert_sorted_with_merge_freeList+0x134>
  803117:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80311a:	8b 00                	mov    (%eax),%eax
  80311c:	a3 38 51 80 00       	mov    %eax,0x805138
  803121:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803124:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80312a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80312d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803134:	a1 44 51 80 00       	mov    0x805144,%eax
  803139:	48                   	dec    %eax
  80313a:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  80313f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803142:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  803149:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80314c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  803153:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803157:	75 17                	jne    803170 <insert_sorted_with_merge_freeList+0x183>
  803159:	83 ec 04             	sub    $0x4,%esp
  80315c:	68 64 45 80 00       	push   $0x804564
  803161:	68 3f 01 00 00       	push   $0x13f
  803166:	68 87 45 80 00       	push   $0x804587
  80316b:	e8 43 d5 ff ff       	call   8006b3 <_panic>
  803170:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803176:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803179:	89 10                	mov    %edx,(%eax)
  80317b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80317e:	8b 00                	mov    (%eax),%eax
  803180:	85 c0                	test   %eax,%eax
  803182:	74 0d                	je     803191 <insert_sorted_with_merge_freeList+0x1a4>
  803184:	a1 48 51 80 00       	mov    0x805148,%eax
  803189:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80318c:	89 50 04             	mov    %edx,0x4(%eax)
  80318f:	eb 08                	jmp    803199 <insert_sorted_with_merge_freeList+0x1ac>
  803191:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803194:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803199:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80319c:	a3 48 51 80 00       	mov    %eax,0x805148
  8031a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031a4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031ab:	a1 54 51 80 00       	mov    0x805154,%eax
  8031b0:	40                   	inc    %eax
  8031b1:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8031b6:	e9 7a 05 00 00       	jmp    803735 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  8031bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8031be:	8b 50 08             	mov    0x8(%eax),%edx
  8031c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031c4:	8b 40 08             	mov    0x8(%eax),%eax
  8031c7:	39 c2                	cmp    %eax,%edx
  8031c9:	0f 82 14 01 00 00    	jb     8032e3 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  8031cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031d2:	8b 50 08             	mov    0x8(%eax),%edx
  8031d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031d8:	8b 40 0c             	mov    0xc(%eax),%eax
  8031db:	01 c2                	add    %eax,%edx
  8031dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e0:	8b 40 08             	mov    0x8(%eax),%eax
  8031e3:	39 c2                	cmp    %eax,%edx
  8031e5:	0f 85 90 00 00 00    	jne    80327b <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  8031eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031ee:	8b 50 0c             	mov    0xc(%eax),%edx
  8031f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f4:	8b 40 0c             	mov    0xc(%eax),%eax
  8031f7:	01 c2                	add    %eax,%edx
  8031f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031fc:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  8031ff:	8b 45 08             	mov    0x8(%ebp),%eax
  803202:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  803209:	8b 45 08             	mov    0x8(%ebp),%eax
  80320c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803213:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803217:	75 17                	jne    803230 <insert_sorted_with_merge_freeList+0x243>
  803219:	83 ec 04             	sub    $0x4,%esp
  80321c:	68 64 45 80 00       	push   $0x804564
  803221:	68 49 01 00 00       	push   $0x149
  803226:	68 87 45 80 00       	push   $0x804587
  80322b:	e8 83 d4 ff ff       	call   8006b3 <_panic>
  803230:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803236:	8b 45 08             	mov    0x8(%ebp),%eax
  803239:	89 10                	mov    %edx,(%eax)
  80323b:	8b 45 08             	mov    0x8(%ebp),%eax
  80323e:	8b 00                	mov    (%eax),%eax
  803240:	85 c0                	test   %eax,%eax
  803242:	74 0d                	je     803251 <insert_sorted_with_merge_freeList+0x264>
  803244:	a1 48 51 80 00       	mov    0x805148,%eax
  803249:	8b 55 08             	mov    0x8(%ebp),%edx
  80324c:	89 50 04             	mov    %edx,0x4(%eax)
  80324f:	eb 08                	jmp    803259 <insert_sorted_with_merge_freeList+0x26c>
  803251:	8b 45 08             	mov    0x8(%ebp),%eax
  803254:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803259:	8b 45 08             	mov    0x8(%ebp),%eax
  80325c:	a3 48 51 80 00       	mov    %eax,0x805148
  803261:	8b 45 08             	mov    0x8(%ebp),%eax
  803264:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80326b:	a1 54 51 80 00       	mov    0x805154,%eax
  803270:	40                   	inc    %eax
  803271:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803276:	e9 bb 04 00 00       	jmp    803736 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  80327b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80327f:	75 17                	jne    803298 <insert_sorted_with_merge_freeList+0x2ab>
  803281:	83 ec 04             	sub    $0x4,%esp
  803284:	68 d8 45 80 00       	push   $0x8045d8
  803289:	68 4c 01 00 00       	push   $0x14c
  80328e:	68 87 45 80 00       	push   $0x804587
  803293:	e8 1b d4 ff ff       	call   8006b3 <_panic>
  803298:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  80329e:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a1:	89 50 04             	mov    %edx,0x4(%eax)
  8032a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a7:	8b 40 04             	mov    0x4(%eax),%eax
  8032aa:	85 c0                	test   %eax,%eax
  8032ac:	74 0c                	je     8032ba <insert_sorted_with_merge_freeList+0x2cd>
  8032ae:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8032b3:	8b 55 08             	mov    0x8(%ebp),%edx
  8032b6:	89 10                	mov    %edx,(%eax)
  8032b8:	eb 08                	jmp    8032c2 <insert_sorted_with_merge_freeList+0x2d5>
  8032ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8032bd:	a3 38 51 80 00       	mov    %eax,0x805138
  8032c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c5:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8032ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8032cd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032d3:	a1 44 51 80 00       	mov    0x805144,%eax
  8032d8:	40                   	inc    %eax
  8032d9:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8032de:	e9 53 04 00 00       	jmp    803736 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8032e3:	a1 38 51 80 00       	mov    0x805138,%eax
  8032e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8032eb:	e9 15 04 00 00       	jmp    803705 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  8032f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032f3:	8b 00                	mov    (%eax),%eax
  8032f5:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  8032f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8032fb:	8b 50 08             	mov    0x8(%eax),%edx
  8032fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803301:	8b 40 08             	mov    0x8(%eax),%eax
  803304:	39 c2                	cmp    %eax,%edx
  803306:	0f 86 f1 03 00 00    	jbe    8036fd <insert_sorted_with_merge_freeList+0x710>
  80330c:	8b 45 08             	mov    0x8(%ebp),%eax
  80330f:	8b 50 08             	mov    0x8(%eax),%edx
  803312:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803315:	8b 40 08             	mov    0x8(%eax),%eax
  803318:	39 c2                	cmp    %eax,%edx
  80331a:	0f 83 dd 03 00 00    	jae    8036fd <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  803320:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803323:	8b 50 08             	mov    0x8(%eax),%edx
  803326:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803329:	8b 40 0c             	mov    0xc(%eax),%eax
  80332c:	01 c2                	add    %eax,%edx
  80332e:	8b 45 08             	mov    0x8(%ebp),%eax
  803331:	8b 40 08             	mov    0x8(%eax),%eax
  803334:	39 c2                	cmp    %eax,%edx
  803336:	0f 85 b9 01 00 00    	jne    8034f5 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  80333c:	8b 45 08             	mov    0x8(%ebp),%eax
  80333f:	8b 50 08             	mov    0x8(%eax),%edx
  803342:	8b 45 08             	mov    0x8(%ebp),%eax
  803345:	8b 40 0c             	mov    0xc(%eax),%eax
  803348:	01 c2                	add    %eax,%edx
  80334a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80334d:	8b 40 08             	mov    0x8(%eax),%eax
  803350:	39 c2                	cmp    %eax,%edx
  803352:	0f 85 0d 01 00 00    	jne    803465 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  803358:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80335b:	8b 50 0c             	mov    0xc(%eax),%edx
  80335e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803361:	8b 40 0c             	mov    0xc(%eax),%eax
  803364:	01 c2                	add    %eax,%edx
  803366:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803369:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80336c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803370:	75 17                	jne    803389 <insert_sorted_with_merge_freeList+0x39c>
  803372:	83 ec 04             	sub    $0x4,%esp
  803375:	68 30 46 80 00       	push   $0x804630
  80337a:	68 5c 01 00 00       	push   $0x15c
  80337f:	68 87 45 80 00       	push   $0x804587
  803384:	e8 2a d3 ff ff       	call   8006b3 <_panic>
  803389:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80338c:	8b 00                	mov    (%eax),%eax
  80338e:	85 c0                	test   %eax,%eax
  803390:	74 10                	je     8033a2 <insert_sorted_with_merge_freeList+0x3b5>
  803392:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803395:	8b 00                	mov    (%eax),%eax
  803397:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80339a:	8b 52 04             	mov    0x4(%edx),%edx
  80339d:	89 50 04             	mov    %edx,0x4(%eax)
  8033a0:	eb 0b                	jmp    8033ad <insert_sorted_with_merge_freeList+0x3c0>
  8033a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033a5:	8b 40 04             	mov    0x4(%eax),%eax
  8033a8:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8033ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033b0:	8b 40 04             	mov    0x4(%eax),%eax
  8033b3:	85 c0                	test   %eax,%eax
  8033b5:	74 0f                	je     8033c6 <insert_sorted_with_merge_freeList+0x3d9>
  8033b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033ba:	8b 40 04             	mov    0x4(%eax),%eax
  8033bd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8033c0:	8b 12                	mov    (%edx),%edx
  8033c2:	89 10                	mov    %edx,(%eax)
  8033c4:	eb 0a                	jmp    8033d0 <insert_sorted_with_merge_freeList+0x3e3>
  8033c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033c9:	8b 00                	mov    (%eax),%eax
  8033cb:	a3 38 51 80 00       	mov    %eax,0x805138
  8033d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033d3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033dc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033e3:	a1 44 51 80 00       	mov    0x805144,%eax
  8033e8:	48                   	dec    %eax
  8033e9:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  8033ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033f1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  8033f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033fb:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803402:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803406:	75 17                	jne    80341f <insert_sorted_with_merge_freeList+0x432>
  803408:	83 ec 04             	sub    $0x4,%esp
  80340b:	68 64 45 80 00       	push   $0x804564
  803410:	68 5f 01 00 00       	push   $0x15f
  803415:	68 87 45 80 00       	push   $0x804587
  80341a:	e8 94 d2 ff ff       	call   8006b3 <_panic>
  80341f:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803425:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803428:	89 10                	mov    %edx,(%eax)
  80342a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80342d:	8b 00                	mov    (%eax),%eax
  80342f:	85 c0                	test   %eax,%eax
  803431:	74 0d                	je     803440 <insert_sorted_with_merge_freeList+0x453>
  803433:	a1 48 51 80 00       	mov    0x805148,%eax
  803438:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80343b:	89 50 04             	mov    %edx,0x4(%eax)
  80343e:	eb 08                	jmp    803448 <insert_sorted_with_merge_freeList+0x45b>
  803440:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803443:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803448:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80344b:	a3 48 51 80 00       	mov    %eax,0x805148
  803450:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803453:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80345a:	a1 54 51 80 00       	mov    0x805154,%eax
  80345f:	40                   	inc    %eax
  803460:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803465:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803468:	8b 50 0c             	mov    0xc(%eax),%edx
  80346b:	8b 45 08             	mov    0x8(%ebp),%eax
  80346e:	8b 40 0c             	mov    0xc(%eax),%eax
  803471:	01 c2                	add    %eax,%edx
  803473:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803476:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803479:	8b 45 08             	mov    0x8(%ebp),%eax
  80347c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803483:	8b 45 08             	mov    0x8(%ebp),%eax
  803486:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80348d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803491:	75 17                	jne    8034aa <insert_sorted_with_merge_freeList+0x4bd>
  803493:	83 ec 04             	sub    $0x4,%esp
  803496:	68 64 45 80 00       	push   $0x804564
  80349b:	68 64 01 00 00       	push   $0x164
  8034a0:	68 87 45 80 00       	push   $0x804587
  8034a5:	e8 09 d2 ff ff       	call   8006b3 <_panic>
  8034aa:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8034b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8034b3:	89 10                	mov    %edx,(%eax)
  8034b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8034b8:	8b 00                	mov    (%eax),%eax
  8034ba:	85 c0                	test   %eax,%eax
  8034bc:	74 0d                	je     8034cb <insert_sorted_with_merge_freeList+0x4de>
  8034be:	a1 48 51 80 00       	mov    0x805148,%eax
  8034c3:	8b 55 08             	mov    0x8(%ebp),%edx
  8034c6:	89 50 04             	mov    %edx,0x4(%eax)
  8034c9:	eb 08                	jmp    8034d3 <insert_sorted_with_merge_freeList+0x4e6>
  8034cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ce:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8034d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8034d6:	a3 48 51 80 00       	mov    %eax,0x805148
  8034db:	8b 45 08             	mov    0x8(%ebp),%eax
  8034de:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034e5:	a1 54 51 80 00       	mov    0x805154,%eax
  8034ea:	40                   	inc    %eax
  8034eb:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8034f0:	e9 41 02 00 00       	jmp    803736 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8034f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8034f8:	8b 50 08             	mov    0x8(%eax),%edx
  8034fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8034fe:	8b 40 0c             	mov    0xc(%eax),%eax
  803501:	01 c2                	add    %eax,%edx
  803503:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803506:	8b 40 08             	mov    0x8(%eax),%eax
  803509:	39 c2                	cmp    %eax,%edx
  80350b:	0f 85 7c 01 00 00    	jne    80368d <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803511:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803515:	74 06                	je     80351d <insert_sorted_with_merge_freeList+0x530>
  803517:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80351b:	75 17                	jne    803534 <insert_sorted_with_merge_freeList+0x547>
  80351d:	83 ec 04             	sub    $0x4,%esp
  803520:	68 a0 45 80 00       	push   $0x8045a0
  803525:	68 69 01 00 00       	push   $0x169
  80352a:	68 87 45 80 00       	push   $0x804587
  80352f:	e8 7f d1 ff ff       	call   8006b3 <_panic>
  803534:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803537:	8b 50 04             	mov    0x4(%eax),%edx
  80353a:	8b 45 08             	mov    0x8(%ebp),%eax
  80353d:	89 50 04             	mov    %edx,0x4(%eax)
  803540:	8b 45 08             	mov    0x8(%ebp),%eax
  803543:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803546:	89 10                	mov    %edx,(%eax)
  803548:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80354b:	8b 40 04             	mov    0x4(%eax),%eax
  80354e:	85 c0                	test   %eax,%eax
  803550:	74 0d                	je     80355f <insert_sorted_with_merge_freeList+0x572>
  803552:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803555:	8b 40 04             	mov    0x4(%eax),%eax
  803558:	8b 55 08             	mov    0x8(%ebp),%edx
  80355b:	89 10                	mov    %edx,(%eax)
  80355d:	eb 08                	jmp    803567 <insert_sorted_with_merge_freeList+0x57a>
  80355f:	8b 45 08             	mov    0x8(%ebp),%eax
  803562:	a3 38 51 80 00       	mov    %eax,0x805138
  803567:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80356a:	8b 55 08             	mov    0x8(%ebp),%edx
  80356d:	89 50 04             	mov    %edx,0x4(%eax)
  803570:	a1 44 51 80 00       	mov    0x805144,%eax
  803575:	40                   	inc    %eax
  803576:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  80357b:	8b 45 08             	mov    0x8(%ebp),%eax
  80357e:	8b 50 0c             	mov    0xc(%eax),%edx
  803581:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803584:	8b 40 0c             	mov    0xc(%eax),%eax
  803587:	01 c2                	add    %eax,%edx
  803589:	8b 45 08             	mov    0x8(%ebp),%eax
  80358c:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80358f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803593:	75 17                	jne    8035ac <insert_sorted_with_merge_freeList+0x5bf>
  803595:	83 ec 04             	sub    $0x4,%esp
  803598:	68 30 46 80 00       	push   $0x804630
  80359d:	68 6b 01 00 00       	push   $0x16b
  8035a2:	68 87 45 80 00       	push   $0x804587
  8035a7:	e8 07 d1 ff ff       	call   8006b3 <_panic>
  8035ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035af:	8b 00                	mov    (%eax),%eax
  8035b1:	85 c0                	test   %eax,%eax
  8035b3:	74 10                	je     8035c5 <insert_sorted_with_merge_freeList+0x5d8>
  8035b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035b8:	8b 00                	mov    (%eax),%eax
  8035ba:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8035bd:	8b 52 04             	mov    0x4(%edx),%edx
  8035c0:	89 50 04             	mov    %edx,0x4(%eax)
  8035c3:	eb 0b                	jmp    8035d0 <insert_sorted_with_merge_freeList+0x5e3>
  8035c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035c8:	8b 40 04             	mov    0x4(%eax),%eax
  8035cb:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8035d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035d3:	8b 40 04             	mov    0x4(%eax),%eax
  8035d6:	85 c0                	test   %eax,%eax
  8035d8:	74 0f                	je     8035e9 <insert_sorted_with_merge_freeList+0x5fc>
  8035da:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035dd:	8b 40 04             	mov    0x4(%eax),%eax
  8035e0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8035e3:	8b 12                	mov    (%edx),%edx
  8035e5:	89 10                	mov    %edx,(%eax)
  8035e7:	eb 0a                	jmp    8035f3 <insert_sorted_with_merge_freeList+0x606>
  8035e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035ec:	8b 00                	mov    (%eax),%eax
  8035ee:	a3 38 51 80 00       	mov    %eax,0x805138
  8035f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035f6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035ff:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803606:	a1 44 51 80 00       	mov    0x805144,%eax
  80360b:	48                   	dec    %eax
  80360c:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803611:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803614:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  80361b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80361e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803625:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803629:	75 17                	jne    803642 <insert_sorted_with_merge_freeList+0x655>
  80362b:	83 ec 04             	sub    $0x4,%esp
  80362e:	68 64 45 80 00       	push   $0x804564
  803633:	68 6e 01 00 00       	push   $0x16e
  803638:	68 87 45 80 00       	push   $0x804587
  80363d:	e8 71 d0 ff ff       	call   8006b3 <_panic>
  803642:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803648:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80364b:	89 10                	mov    %edx,(%eax)
  80364d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803650:	8b 00                	mov    (%eax),%eax
  803652:	85 c0                	test   %eax,%eax
  803654:	74 0d                	je     803663 <insert_sorted_with_merge_freeList+0x676>
  803656:	a1 48 51 80 00       	mov    0x805148,%eax
  80365b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80365e:	89 50 04             	mov    %edx,0x4(%eax)
  803661:	eb 08                	jmp    80366b <insert_sorted_with_merge_freeList+0x67e>
  803663:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803666:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80366b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80366e:	a3 48 51 80 00       	mov    %eax,0x805148
  803673:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803676:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80367d:	a1 54 51 80 00       	mov    0x805154,%eax
  803682:	40                   	inc    %eax
  803683:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803688:	e9 a9 00 00 00       	jmp    803736 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  80368d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803691:	74 06                	je     803699 <insert_sorted_with_merge_freeList+0x6ac>
  803693:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803697:	75 17                	jne    8036b0 <insert_sorted_with_merge_freeList+0x6c3>
  803699:	83 ec 04             	sub    $0x4,%esp
  80369c:	68 fc 45 80 00       	push   $0x8045fc
  8036a1:	68 73 01 00 00       	push   $0x173
  8036a6:	68 87 45 80 00       	push   $0x804587
  8036ab:	e8 03 d0 ff ff       	call   8006b3 <_panic>
  8036b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036b3:	8b 10                	mov    (%eax),%edx
  8036b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8036b8:	89 10                	mov    %edx,(%eax)
  8036ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8036bd:	8b 00                	mov    (%eax),%eax
  8036bf:	85 c0                	test   %eax,%eax
  8036c1:	74 0b                	je     8036ce <insert_sorted_with_merge_freeList+0x6e1>
  8036c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036c6:	8b 00                	mov    (%eax),%eax
  8036c8:	8b 55 08             	mov    0x8(%ebp),%edx
  8036cb:	89 50 04             	mov    %edx,0x4(%eax)
  8036ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036d1:	8b 55 08             	mov    0x8(%ebp),%edx
  8036d4:	89 10                	mov    %edx,(%eax)
  8036d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8036d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8036dc:	89 50 04             	mov    %edx,0x4(%eax)
  8036df:	8b 45 08             	mov    0x8(%ebp),%eax
  8036e2:	8b 00                	mov    (%eax),%eax
  8036e4:	85 c0                	test   %eax,%eax
  8036e6:	75 08                	jne    8036f0 <insert_sorted_with_merge_freeList+0x703>
  8036e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8036eb:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8036f0:	a1 44 51 80 00       	mov    0x805144,%eax
  8036f5:	40                   	inc    %eax
  8036f6:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  8036fb:	eb 39                	jmp    803736 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8036fd:	a1 40 51 80 00       	mov    0x805140,%eax
  803702:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803705:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803709:	74 07                	je     803712 <insert_sorted_with_merge_freeList+0x725>
  80370b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80370e:	8b 00                	mov    (%eax),%eax
  803710:	eb 05                	jmp    803717 <insert_sorted_with_merge_freeList+0x72a>
  803712:	b8 00 00 00 00       	mov    $0x0,%eax
  803717:	a3 40 51 80 00       	mov    %eax,0x805140
  80371c:	a1 40 51 80 00       	mov    0x805140,%eax
  803721:	85 c0                	test   %eax,%eax
  803723:	0f 85 c7 fb ff ff    	jne    8032f0 <insert_sorted_with_merge_freeList+0x303>
  803729:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80372d:	0f 85 bd fb ff ff    	jne    8032f0 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803733:	eb 01                	jmp    803736 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803735:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803736:	90                   	nop
  803737:	c9                   	leave  
  803738:	c3                   	ret    
  803739:	66 90                	xchg   %ax,%ax
  80373b:	90                   	nop

0080373c <__udivdi3>:
  80373c:	55                   	push   %ebp
  80373d:	57                   	push   %edi
  80373e:	56                   	push   %esi
  80373f:	53                   	push   %ebx
  803740:	83 ec 1c             	sub    $0x1c,%esp
  803743:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803747:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80374b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80374f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803753:	89 ca                	mov    %ecx,%edx
  803755:	89 f8                	mov    %edi,%eax
  803757:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80375b:	85 f6                	test   %esi,%esi
  80375d:	75 2d                	jne    80378c <__udivdi3+0x50>
  80375f:	39 cf                	cmp    %ecx,%edi
  803761:	77 65                	ja     8037c8 <__udivdi3+0x8c>
  803763:	89 fd                	mov    %edi,%ebp
  803765:	85 ff                	test   %edi,%edi
  803767:	75 0b                	jne    803774 <__udivdi3+0x38>
  803769:	b8 01 00 00 00       	mov    $0x1,%eax
  80376e:	31 d2                	xor    %edx,%edx
  803770:	f7 f7                	div    %edi
  803772:	89 c5                	mov    %eax,%ebp
  803774:	31 d2                	xor    %edx,%edx
  803776:	89 c8                	mov    %ecx,%eax
  803778:	f7 f5                	div    %ebp
  80377a:	89 c1                	mov    %eax,%ecx
  80377c:	89 d8                	mov    %ebx,%eax
  80377e:	f7 f5                	div    %ebp
  803780:	89 cf                	mov    %ecx,%edi
  803782:	89 fa                	mov    %edi,%edx
  803784:	83 c4 1c             	add    $0x1c,%esp
  803787:	5b                   	pop    %ebx
  803788:	5e                   	pop    %esi
  803789:	5f                   	pop    %edi
  80378a:	5d                   	pop    %ebp
  80378b:	c3                   	ret    
  80378c:	39 ce                	cmp    %ecx,%esi
  80378e:	77 28                	ja     8037b8 <__udivdi3+0x7c>
  803790:	0f bd fe             	bsr    %esi,%edi
  803793:	83 f7 1f             	xor    $0x1f,%edi
  803796:	75 40                	jne    8037d8 <__udivdi3+0x9c>
  803798:	39 ce                	cmp    %ecx,%esi
  80379a:	72 0a                	jb     8037a6 <__udivdi3+0x6a>
  80379c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8037a0:	0f 87 9e 00 00 00    	ja     803844 <__udivdi3+0x108>
  8037a6:	b8 01 00 00 00       	mov    $0x1,%eax
  8037ab:	89 fa                	mov    %edi,%edx
  8037ad:	83 c4 1c             	add    $0x1c,%esp
  8037b0:	5b                   	pop    %ebx
  8037b1:	5e                   	pop    %esi
  8037b2:	5f                   	pop    %edi
  8037b3:	5d                   	pop    %ebp
  8037b4:	c3                   	ret    
  8037b5:	8d 76 00             	lea    0x0(%esi),%esi
  8037b8:	31 ff                	xor    %edi,%edi
  8037ba:	31 c0                	xor    %eax,%eax
  8037bc:	89 fa                	mov    %edi,%edx
  8037be:	83 c4 1c             	add    $0x1c,%esp
  8037c1:	5b                   	pop    %ebx
  8037c2:	5e                   	pop    %esi
  8037c3:	5f                   	pop    %edi
  8037c4:	5d                   	pop    %ebp
  8037c5:	c3                   	ret    
  8037c6:	66 90                	xchg   %ax,%ax
  8037c8:	89 d8                	mov    %ebx,%eax
  8037ca:	f7 f7                	div    %edi
  8037cc:	31 ff                	xor    %edi,%edi
  8037ce:	89 fa                	mov    %edi,%edx
  8037d0:	83 c4 1c             	add    $0x1c,%esp
  8037d3:	5b                   	pop    %ebx
  8037d4:	5e                   	pop    %esi
  8037d5:	5f                   	pop    %edi
  8037d6:	5d                   	pop    %ebp
  8037d7:	c3                   	ret    
  8037d8:	bd 20 00 00 00       	mov    $0x20,%ebp
  8037dd:	89 eb                	mov    %ebp,%ebx
  8037df:	29 fb                	sub    %edi,%ebx
  8037e1:	89 f9                	mov    %edi,%ecx
  8037e3:	d3 e6                	shl    %cl,%esi
  8037e5:	89 c5                	mov    %eax,%ebp
  8037e7:	88 d9                	mov    %bl,%cl
  8037e9:	d3 ed                	shr    %cl,%ebp
  8037eb:	89 e9                	mov    %ebp,%ecx
  8037ed:	09 f1                	or     %esi,%ecx
  8037ef:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8037f3:	89 f9                	mov    %edi,%ecx
  8037f5:	d3 e0                	shl    %cl,%eax
  8037f7:	89 c5                	mov    %eax,%ebp
  8037f9:	89 d6                	mov    %edx,%esi
  8037fb:	88 d9                	mov    %bl,%cl
  8037fd:	d3 ee                	shr    %cl,%esi
  8037ff:	89 f9                	mov    %edi,%ecx
  803801:	d3 e2                	shl    %cl,%edx
  803803:	8b 44 24 08          	mov    0x8(%esp),%eax
  803807:	88 d9                	mov    %bl,%cl
  803809:	d3 e8                	shr    %cl,%eax
  80380b:	09 c2                	or     %eax,%edx
  80380d:	89 d0                	mov    %edx,%eax
  80380f:	89 f2                	mov    %esi,%edx
  803811:	f7 74 24 0c          	divl   0xc(%esp)
  803815:	89 d6                	mov    %edx,%esi
  803817:	89 c3                	mov    %eax,%ebx
  803819:	f7 e5                	mul    %ebp
  80381b:	39 d6                	cmp    %edx,%esi
  80381d:	72 19                	jb     803838 <__udivdi3+0xfc>
  80381f:	74 0b                	je     80382c <__udivdi3+0xf0>
  803821:	89 d8                	mov    %ebx,%eax
  803823:	31 ff                	xor    %edi,%edi
  803825:	e9 58 ff ff ff       	jmp    803782 <__udivdi3+0x46>
  80382a:	66 90                	xchg   %ax,%ax
  80382c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803830:	89 f9                	mov    %edi,%ecx
  803832:	d3 e2                	shl    %cl,%edx
  803834:	39 c2                	cmp    %eax,%edx
  803836:	73 e9                	jae    803821 <__udivdi3+0xe5>
  803838:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80383b:	31 ff                	xor    %edi,%edi
  80383d:	e9 40 ff ff ff       	jmp    803782 <__udivdi3+0x46>
  803842:	66 90                	xchg   %ax,%ax
  803844:	31 c0                	xor    %eax,%eax
  803846:	e9 37 ff ff ff       	jmp    803782 <__udivdi3+0x46>
  80384b:	90                   	nop

0080384c <__umoddi3>:
  80384c:	55                   	push   %ebp
  80384d:	57                   	push   %edi
  80384e:	56                   	push   %esi
  80384f:	53                   	push   %ebx
  803850:	83 ec 1c             	sub    $0x1c,%esp
  803853:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803857:	8b 74 24 34          	mov    0x34(%esp),%esi
  80385b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80385f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803863:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803867:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80386b:	89 f3                	mov    %esi,%ebx
  80386d:	89 fa                	mov    %edi,%edx
  80386f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803873:	89 34 24             	mov    %esi,(%esp)
  803876:	85 c0                	test   %eax,%eax
  803878:	75 1a                	jne    803894 <__umoddi3+0x48>
  80387a:	39 f7                	cmp    %esi,%edi
  80387c:	0f 86 a2 00 00 00    	jbe    803924 <__umoddi3+0xd8>
  803882:	89 c8                	mov    %ecx,%eax
  803884:	89 f2                	mov    %esi,%edx
  803886:	f7 f7                	div    %edi
  803888:	89 d0                	mov    %edx,%eax
  80388a:	31 d2                	xor    %edx,%edx
  80388c:	83 c4 1c             	add    $0x1c,%esp
  80388f:	5b                   	pop    %ebx
  803890:	5e                   	pop    %esi
  803891:	5f                   	pop    %edi
  803892:	5d                   	pop    %ebp
  803893:	c3                   	ret    
  803894:	39 f0                	cmp    %esi,%eax
  803896:	0f 87 ac 00 00 00    	ja     803948 <__umoddi3+0xfc>
  80389c:	0f bd e8             	bsr    %eax,%ebp
  80389f:	83 f5 1f             	xor    $0x1f,%ebp
  8038a2:	0f 84 ac 00 00 00    	je     803954 <__umoddi3+0x108>
  8038a8:	bf 20 00 00 00       	mov    $0x20,%edi
  8038ad:	29 ef                	sub    %ebp,%edi
  8038af:	89 fe                	mov    %edi,%esi
  8038b1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8038b5:	89 e9                	mov    %ebp,%ecx
  8038b7:	d3 e0                	shl    %cl,%eax
  8038b9:	89 d7                	mov    %edx,%edi
  8038bb:	89 f1                	mov    %esi,%ecx
  8038bd:	d3 ef                	shr    %cl,%edi
  8038bf:	09 c7                	or     %eax,%edi
  8038c1:	89 e9                	mov    %ebp,%ecx
  8038c3:	d3 e2                	shl    %cl,%edx
  8038c5:	89 14 24             	mov    %edx,(%esp)
  8038c8:	89 d8                	mov    %ebx,%eax
  8038ca:	d3 e0                	shl    %cl,%eax
  8038cc:	89 c2                	mov    %eax,%edx
  8038ce:	8b 44 24 08          	mov    0x8(%esp),%eax
  8038d2:	d3 e0                	shl    %cl,%eax
  8038d4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8038d8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8038dc:	89 f1                	mov    %esi,%ecx
  8038de:	d3 e8                	shr    %cl,%eax
  8038e0:	09 d0                	or     %edx,%eax
  8038e2:	d3 eb                	shr    %cl,%ebx
  8038e4:	89 da                	mov    %ebx,%edx
  8038e6:	f7 f7                	div    %edi
  8038e8:	89 d3                	mov    %edx,%ebx
  8038ea:	f7 24 24             	mull   (%esp)
  8038ed:	89 c6                	mov    %eax,%esi
  8038ef:	89 d1                	mov    %edx,%ecx
  8038f1:	39 d3                	cmp    %edx,%ebx
  8038f3:	0f 82 87 00 00 00    	jb     803980 <__umoddi3+0x134>
  8038f9:	0f 84 91 00 00 00    	je     803990 <__umoddi3+0x144>
  8038ff:	8b 54 24 04          	mov    0x4(%esp),%edx
  803903:	29 f2                	sub    %esi,%edx
  803905:	19 cb                	sbb    %ecx,%ebx
  803907:	89 d8                	mov    %ebx,%eax
  803909:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80390d:	d3 e0                	shl    %cl,%eax
  80390f:	89 e9                	mov    %ebp,%ecx
  803911:	d3 ea                	shr    %cl,%edx
  803913:	09 d0                	or     %edx,%eax
  803915:	89 e9                	mov    %ebp,%ecx
  803917:	d3 eb                	shr    %cl,%ebx
  803919:	89 da                	mov    %ebx,%edx
  80391b:	83 c4 1c             	add    $0x1c,%esp
  80391e:	5b                   	pop    %ebx
  80391f:	5e                   	pop    %esi
  803920:	5f                   	pop    %edi
  803921:	5d                   	pop    %ebp
  803922:	c3                   	ret    
  803923:	90                   	nop
  803924:	89 fd                	mov    %edi,%ebp
  803926:	85 ff                	test   %edi,%edi
  803928:	75 0b                	jne    803935 <__umoddi3+0xe9>
  80392a:	b8 01 00 00 00       	mov    $0x1,%eax
  80392f:	31 d2                	xor    %edx,%edx
  803931:	f7 f7                	div    %edi
  803933:	89 c5                	mov    %eax,%ebp
  803935:	89 f0                	mov    %esi,%eax
  803937:	31 d2                	xor    %edx,%edx
  803939:	f7 f5                	div    %ebp
  80393b:	89 c8                	mov    %ecx,%eax
  80393d:	f7 f5                	div    %ebp
  80393f:	89 d0                	mov    %edx,%eax
  803941:	e9 44 ff ff ff       	jmp    80388a <__umoddi3+0x3e>
  803946:	66 90                	xchg   %ax,%ax
  803948:	89 c8                	mov    %ecx,%eax
  80394a:	89 f2                	mov    %esi,%edx
  80394c:	83 c4 1c             	add    $0x1c,%esp
  80394f:	5b                   	pop    %ebx
  803950:	5e                   	pop    %esi
  803951:	5f                   	pop    %edi
  803952:	5d                   	pop    %ebp
  803953:	c3                   	ret    
  803954:	3b 04 24             	cmp    (%esp),%eax
  803957:	72 06                	jb     80395f <__umoddi3+0x113>
  803959:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80395d:	77 0f                	ja     80396e <__umoddi3+0x122>
  80395f:	89 f2                	mov    %esi,%edx
  803961:	29 f9                	sub    %edi,%ecx
  803963:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803967:	89 14 24             	mov    %edx,(%esp)
  80396a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80396e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803972:	8b 14 24             	mov    (%esp),%edx
  803975:	83 c4 1c             	add    $0x1c,%esp
  803978:	5b                   	pop    %ebx
  803979:	5e                   	pop    %esi
  80397a:	5f                   	pop    %edi
  80397b:	5d                   	pop    %ebp
  80397c:	c3                   	ret    
  80397d:	8d 76 00             	lea    0x0(%esi),%esi
  803980:	2b 04 24             	sub    (%esp),%eax
  803983:	19 fa                	sbb    %edi,%edx
  803985:	89 d1                	mov    %edx,%ecx
  803987:	89 c6                	mov    %eax,%esi
  803989:	e9 71 ff ff ff       	jmp    8038ff <__umoddi3+0xb3>
  80398e:	66 90                	xchg   %ax,%ax
  803990:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803994:	72 ea                	jb     803980 <__umoddi3+0x134>
  803996:	89 d9                	mov    %ebx,%ecx
  803998:	e9 62 ff ff ff       	jmp    8038ff <__umoddi3+0xb3>
