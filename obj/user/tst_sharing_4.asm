
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
  80008d:	68 40 39 80 00       	push   $0x803940
  800092:	6a 12                	push   $0x12
  800094:	68 5c 39 80 00       	push   $0x80395c
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
  8000ae:	68 74 39 80 00       	push   $0x803974
  8000b3:	e8 af 08 00 00       	call   800967 <cprintf>
  8000b8:	83 c4 10             	add    $0x10,%esp
	cprintf("MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  8000bb:	83 ec 0c             	sub    $0xc,%esp
  8000be:	68 a8 39 80 00       	push   $0x8039a8
  8000c3:	e8 9f 08 00 00       	call   800967 <cprintf>
  8000c8:	83 c4 10             	add    $0x10,%esp
	cprintf("************************************************\n\n\n");
  8000cb:	83 ec 0c             	sub    $0xc,%esp
  8000ce:	68 04 3a 80 00       	push   $0x803a04
  8000d3:	e8 8f 08 00 00       	call   800967 <cprintf>
  8000d8:	83 c4 10             	add    $0x10,%esp

	int Mega = 1024*1024;
  8000db:	c7 45 ec 00 00 10 00 	movl   $0x100000,-0x14(%ebp)
	int kilo = 1024;
  8000e2:	c7 45 e8 00 04 00 00 	movl   $0x400,-0x18(%ebp)
	int envID = sys_getenvid();
  8000e9:	e8 e8 1c 00 00       	call   801dd6 <sys_getenvid>
  8000ee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	cprintf("STEP A: checking free of a shared object ... \n");
  8000f1:	83 ec 0c             	sub    $0xc,%esp
  8000f4:	68 38 3a 80 00       	push   $0x803a38
  8000f9:	e8 69 08 00 00       	call   800967 <cprintf>
  8000fe:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x;
		int freeFrames = sys_calculate_free_frames() ;
  800101:	e8 09 1a 00 00       	call   801b0f <sys_calculate_free_frames>
  800106:	89 45 e0             	mov    %eax,-0x20(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  800109:	83 ec 04             	sub    $0x4,%esp
  80010c:	6a 01                	push   $0x1
  80010e:	68 00 10 00 00       	push   $0x1000
  800113:	68 67 3a 80 00       	push   $0x803a67
  800118:	e8 1a 18 00 00       	call   801937 <smalloc>
  80011d:	83 c4 10             	add    $0x10,%esp
  800120:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (x != (uint32*)USER_HEAP_START) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  800123:	81 7d dc 00 00 00 80 	cmpl   $0x80000000,-0x24(%ebp)
  80012a:	74 14                	je     800140 <_main+0x108>
  80012c:	83 ec 04             	sub    $0x4,%esp
  80012f:	68 6c 3a 80 00       	push   $0x803a6c
  800134:	6a 24                	push   $0x24
  800136:	68 5c 39 80 00       	push   $0x80395c
  80013b:	e8 73 05 00 00       	call   8006b3 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800140:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800143:	e8 c7 19 00 00       	call   801b0f <sys_calculate_free_frames>
  800148:	29 c3                	sub    %eax,%ebx
  80014a:	89 d8                	mov    %ebx,%eax
  80014c:	83 f8 04             	cmp    $0x4,%eax
  80014f:	74 14                	je     800165 <_main+0x12d>
  800151:	83 ec 04             	sub    $0x4,%esp
  800154:	68 d8 3a 80 00       	push   $0x803ad8
  800159:	6a 25                	push   $0x25
  80015b:	68 5c 39 80 00       	push   $0x80395c
  800160:	e8 4e 05 00 00       	call   8006b3 <_panic>

		sfree(x);
  800165:	83 ec 0c             	sub    $0xc,%esp
  800168:	ff 75 dc             	pushl  -0x24(%ebp)
  80016b:	e8 3f 18 00 00       	call   8019af <sfree>
  800170:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) ==  0+0+2) panic("Wrong free: make sure that you free the shared object by calling free_share_object()");
  800173:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800176:	e8 94 19 00 00       	call   801b0f <sys_calculate_free_frames>
  80017b:	29 c3                	sub    %eax,%ebx
  80017d:	89 d8                	mov    %ebx,%eax
  80017f:	83 f8 02             	cmp    $0x2,%eax
  800182:	75 14                	jne    800198 <_main+0x160>
  800184:	83 ec 04             	sub    $0x4,%esp
  800187:	68 58 3b 80 00       	push   $0x803b58
  80018c:	6a 28                	push   $0x28
  80018e:	68 5c 39 80 00       	push   $0x80395c
  800193:	e8 1b 05 00 00       	call   8006b3 <_panic>
		else if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong free: revise your freeSharedObject logic");
  800198:	e8 72 19 00 00       	call   801b0f <sys_calculate_free_frames>
  80019d:	89 c2                	mov    %eax,%edx
  80019f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001a2:	39 c2                	cmp    %eax,%edx
  8001a4:	74 14                	je     8001ba <_main+0x182>
  8001a6:	83 ec 04             	sub    $0x4,%esp
  8001a9:	68 b0 3b 80 00       	push   $0x803bb0
  8001ae:	6a 29                	push   $0x29
  8001b0:	68 5c 39 80 00       	push   $0x80395c
  8001b5:	e8 f9 04 00 00       	call   8006b3 <_panic>
	}
	cprintf("Step A completed successfully!!\n\n\n");
  8001ba:	83 ec 0c             	sub    $0xc,%esp
  8001bd:	68 e0 3b 80 00       	push   $0x803be0
  8001c2:	e8 a0 07 00 00       	call   800967 <cprintf>
  8001c7:	83 c4 10             	add    $0x10,%esp


	cprintf("STEP B: checking free of 2 shared objects ... \n");
  8001ca:	83 ec 0c             	sub    $0xc,%esp
  8001cd:	68 04 3c 80 00       	push   $0x803c04
  8001d2:	e8 90 07 00 00       	call   800967 <cprintf>
  8001d7:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x, *z ;
		int freeFrames = sys_calculate_free_frames() ;
  8001da:	e8 30 19 00 00       	call   801b0f <sys_calculate_free_frames>
  8001df:	89 45 d8             	mov    %eax,-0x28(%ebp)
		z = smalloc("z", PAGE_SIZE, 1);
  8001e2:	83 ec 04             	sub    $0x4,%esp
  8001e5:	6a 01                	push   $0x1
  8001e7:	68 00 10 00 00       	push   $0x1000
  8001ec:	68 34 3c 80 00       	push   $0x803c34
  8001f1:	e8 41 17 00 00       	call   801937 <smalloc>
  8001f6:	83 c4 10             	add    $0x10,%esp
  8001f9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8001fc:	83 ec 04             	sub    $0x4,%esp
  8001ff:	6a 01                	push   $0x1
  800201:	68 00 10 00 00       	push   $0x1000
  800206:	68 67 3a 80 00       	push   $0x803a67
  80020b:	e8 27 17 00 00       	call   801937 <smalloc>
  800210:	83 c4 10             	add    $0x10,%esp
  800213:	89 45 d0             	mov    %eax,-0x30(%ebp)

		if(x == NULL) panic("Wrong free: make sure that you free the shared object by calling free_share_object()");
  800216:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80021a:	75 14                	jne    800230 <_main+0x1f8>
  80021c:	83 ec 04             	sub    $0x4,%esp
  80021f:	68 58 3b 80 00       	push   $0x803b58
  800224:	6a 35                	push   $0x35
  800226:	68 5c 39 80 00       	push   $0x80395c
  80022b:	e8 83 04 00 00       	call   8006b3 <_panic>

		if ((freeFrames - sys_calculate_free_frames()) !=  2+1+4) panic("Wrong previous free: make sure that you correctly free shared object before (Step A)");
  800230:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800233:	e8 d7 18 00 00       	call   801b0f <sys_calculate_free_frames>
  800238:	29 c3                	sub    %eax,%ebx
  80023a:	89 d8                	mov    %ebx,%eax
  80023c:	83 f8 07             	cmp    $0x7,%eax
  80023f:	74 14                	je     800255 <_main+0x21d>
  800241:	83 ec 04             	sub    $0x4,%esp
  800244:	68 38 3c 80 00       	push   $0x803c38
  800249:	6a 37                	push   $0x37
  80024b:	68 5c 39 80 00       	push   $0x80395c
  800250:	e8 5e 04 00 00       	call   8006b3 <_panic>

		sfree(z);
  800255:	83 ec 0c             	sub    $0xc,%esp
  800258:	ff 75 d4             	pushl  -0x2c(%ebp)
  80025b:	e8 4f 17 00 00       	call   8019af <sfree>
  800260:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong free: check your logic");
  800263:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800266:	e8 a4 18 00 00       	call   801b0f <sys_calculate_free_frames>
  80026b:	29 c3                	sub    %eax,%ebx
  80026d:	89 d8                	mov    %ebx,%eax
  80026f:	83 f8 04             	cmp    $0x4,%eax
  800272:	74 14                	je     800288 <_main+0x250>
  800274:	83 ec 04             	sub    $0x4,%esp
  800277:	68 8d 3c 80 00       	push   $0x803c8d
  80027c:	6a 3a                	push   $0x3a
  80027e:	68 5c 39 80 00       	push   $0x80395c
  800283:	e8 2b 04 00 00       	call   8006b3 <_panic>

		sfree(x);
  800288:	83 ec 0c             	sub    $0xc,%esp
  80028b:	ff 75 d0             	pushl  -0x30(%ebp)
  80028e:	e8 1c 17 00 00       	call   8019af <sfree>
  800293:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong free: check your logic");
  800296:	e8 74 18 00 00       	call   801b0f <sys_calculate_free_frames>
  80029b:	89 c2                	mov    %eax,%edx
  80029d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8002a0:	39 c2                	cmp    %eax,%edx
  8002a2:	74 14                	je     8002b8 <_main+0x280>
  8002a4:	83 ec 04             	sub    $0x4,%esp
  8002a7:	68 8d 3c 80 00       	push   $0x803c8d
  8002ac:	6a 3d                	push   $0x3d
  8002ae:	68 5c 39 80 00       	push   $0x80395c
  8002b3:	e8 fb 03 00 00       	call   8006b3 <_panic>

	}
	cprintf("Step B completed successfully!!\n\n\n");
  8002b8:	83 ec 0c             	sub    $0xc,%esp
  8002bb:	68 ac 3c 80 00       	push   $0x803cac
  8002c0:	e8 a2 06 00 00       	call   800967 <cprintf>
  8002c5:	83 c4 10             	add    $0x10,%esp

	cprintf("STEP C: checking range of loop during free... \n");
  8002c8:	83 ec 0c             	sub    $0xc,%esp
  8002cb:	68 d0 3c 80 00       	push   $0x803cd0
  8002d0:	e8 92 06 00 00       	call   800967 <cprintf>
  8002d5:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *w, *u;
		int freeFrames = sys_calculate_free_frames() ;
  8002d8:	e8 32 18 00 00       	call   801b0f <sys_calculate_free_frames>
  8002dd:	89 45 cc             	mov    %eax,-0x34(%ebp)
		w = smalloc("w", 3 * PAGE_SIZE+1, 1);
  8002e0:	83 ec 04             	sub    $0x4,%esp
  8002e3:	6a 01                	push   $0x1
  8002e5:	68 01 30 00 00       	push   $0x3001
  8002ea:	68 00 3d 80 00       	push   $0x803d00
  8002ef:	e8 43 16 00 00       	call   801937 <smalloc>
  8002f4:	83 c4 10             	add    $0x10,%esp
  8002f7:	89 45 c8             	mov    %eax,-0x38(%ebp)
		u = smalloc("u", PAGE_SIZE, 1);
  8002fa:	83 ec 04             	sub    $0x4,%esp
  8002fd:	6a 01                	push   $0x1
  8002ff:	68 00 10 00 00       	push   $0x1000
  800304:	68 02 3d 80 00       	push   $0x803d02
  800309:	e8 29 16 00 00       	call   801937 <smalloc>
  80030e:	83 c4 10             	add    $0x10,%esp
  800311:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		if ((freeFrames - sys_calculate_free_frames()) != 5+1+4) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800314:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800317:	e8 f3 17 00 00       	call   801b0f <sys_calculate_free_frames>
  80031c:	29 c3                	sub    %eax,%ebx
  80031e:	89 d8                	mov    %ebx,%eax
  800320:	83 f8 0a             	cmp    $0xa,%eax
  800323:	74 14                	je     800339 <_main+0x301>
  800325:	83 ec 04             	sub    $0x4,%esp
  800328:	68 d8 3a 80 00       	push   $0x803ad8
  80032d:	6a 48                	push   $0x48
  80032f:	68 5c 39 80 00       	push   $0x80395c
  800334:	e8 7a 03 00 00       	call   8006b3 <_panic>

		sfree(w);
  800339:	83 ec 0c             	sub    $0xc,%esp
  80033c:	ff 75 c8             	pushl  -0x38(%ebp)
  80033f:	e8 6b 16 00 00       	call   8019af <sfree>
  800344:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong free: check your logic");
  800347:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  80034a:	e8 c0 17 00 00       	call   801b0f <sys_calculate_free_frames>
  80034f:	29 c3                	sub    %eax,%ebx
  800351:	89 d8                	mov    %ebx,%eax
  800353:	83 f8 04             	cmp    $0x4,%eax
  800356:	74 14                	je     80036c <_main+0x334>
  800358:	83 ec 04             	sub    $0x4,%esp
  80035b:	68 8d 3c 80 00       	push   $0x803c8d
  800360:	6a 4b                	push   $0x4b
  800362:	68 5c 39 80 00       	push   $0x80395c
  800367:	e8 47 03 00 00       	call   8006b3 <_panic>

		uint32 *o;

		o = smalloc("o", 2 * PAGE_SIZE-1,1);
  80036c:	83 ec 04             	sub    $0x4,%esp
  80036f:	6a 01                	push   $0x1
  800371:	68 ff 1f 00 00       	push   $0x1fff
  800376:	68 04 3d 80 00       	push   $0x803d04
  80037b:	e8 b7 15 00 00       	call   801937 <smalloc>
  800380:	83 c4 10             	add    $0x10,%esp
  800383:	89 45 c0             	mov    %eax,-0x40(%ebp)

		cprintf("2\n");
  800386:	83 ec 0c             	sub    $0xc,%esp
  800389:	68 06 3d 80 00       	push   $0x803d06
  80038e:	e8 d4 05 00 00       	call   800967 <cprintf>
  800393:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) != 3+1+4) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800396:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800399:	e8 71 17 00 00       	call   801b0f <sys_calculate_free_frames>
  80039e:	29 c3                	sub    %eax,%ebx
  8003a0:	89 d8                	mov    %ebx,%eax
  8003a2:	83 f8 08             	cmp    $0x8,%eax
  8003a5:	74 14                	je     8003bb <_main+0x383>
  8003a7:	83 ec 04             	sub    $0x4,%esp
  8003aa:	68 d8 3a 80 00       	push   $0x803ad8
  8003af:	6a 52                	push   $0x52
  8003b1:	68 5c 39 80 00       	push   $0x80395c
  8003b6:	e8 f8 02 00 00       	call   8006b3 <_panic>

		sfree(o);
  8003bb:	83 ec 0c             	sub    $0xc,%esp
  8003be:	ff 75 c0             	pushl  -0x40(%ebp)
  8003c1:	e8 e9 15 00 00       	call   8019af <sfree>
  8003c6:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong free: check your logic");
  8003c9:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8003cc:	e8 3e 17 00 00       	call   801b0f <sys_calculate_free_frames>
  8003d1:	29 c3                	sub    %eax,%ebx
  8003d3:	89 d8                	mov    %ebx,%eax
  8003d5:	83 f8 04             	cmp    $0x4,%eax
  8003d8:	74 14                	je     8003ee <_main+0x3b6>
  8003da:	83 ec 04             	sub    $0x4,%esp
  8003dd:	68 8d 3c 80 00       	push   $0x803c8d
  8003e2:	6a 55                	push   $0x55
  8003e4:	68 5c 39 80 00       	push   $0x80395c
  8003e9:	e8 c5 02 00 00       	call   8006b3 <_panic>

		sfree(u);
  8003ee:	83 ec 0c             	sub    $0xc,%esp
  8003f1:	ff 75 c4             	pushl  -0x3c(%ebp)
  8003f4:	e8 b6 15 00 00       	call   8019af <sfree>
  8003f9:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong free: check your logic");
  8003fc:	e8 0e 17 00 00       	call   801b0f <sys_calculate_free_frames>
  800401:	89 c2                	mov    %eax,%edx
  800403:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800406:	39 c2                	cmp    %eax,%edx
  800408:	74 14                	je     80041e <_main+0x3e6>
  80040a:	83 ec 04             	sub    $0x4,%esp
  80040d:	68 8d 3c 80 00       	push   $0x803c8d
  800412:	6a 58                	push   $0x58
  800414:	68 5c 39 80 00       	push   $0x80395c
  800419:	e8 95 02 00 00       	call   8006b3 <_panic>


		//Checking boundaries of page tables
		freeFrames = sys_calculate_free_frames() ;
  80041e:	e8 ec 16 00 00       	call   801b0f <sys_calculate_free_frames>
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
  800438:	68 00 3d 80 00       	push   $0x803d00
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
  80045e:	68 02 3d 80 00       	push   $0x803d02
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
  800480:	68 04 3d 80 00       	push   $0x803d04
  800485:	e8 ad 14 00 00       	call   801937 <smalloc>
  80048a:	83 c4 10             	add    $0x10,%esp
  80048d:	89 45 c0             	mov    %eax,-0x40(%ebp)

		if ((freeFrames - sys_calculate_free_frames()) != 3073+4+7) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800490:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800493:	e8 77 16 00 00       	call   801b0f <sys_calculate_free_frames>
  800498:	29 c3                	sub    %eax,%ebx
  80049a:	89 d8                	mov    %ebx,%eax
  80049c:	3d 0c 0c 00 00       	cmp    $0xc0c,%eax
  8004a1:	74 14                	je     8004b7 <_main+0x47f>
  8004a3:	83 ec 04             	sub    $0x4,%esp
  8004a6:	68 d8 3a 80 00       	push   $0x803ad8
  8004ab:	6a 61                	push   $0x61
  8004ad:	68 5c 39 80 00       	push   $0x80395c
  8004b2:	e8 fc 01 00 00       	call   8006b3 <_panic>

		sfree(o);
  8004b7:	83 ec 0c             	sub    $0xc,%esp
  8004ba:	ff 75 c0             	pushl  -0x40(%ebp)
  8004bd:	e8 ed 14 00 00       	call   8019af <sfree>
  8004c2:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  2560+3+5) panic("Wrong free: check your logic");
  8004c5:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8004c8:	e8 42 16 00 00       	call   801b0f <sys_calculate_free_frames>
  8004cd:	29 c3                	sub    %eax,%ebx
  8004cf:	89 d8                	mov    %ebx,%eax
  8004d1:	3d 08 0a 00 00       	cmp    $0xa08,%eax
  8004d6:	74 14                	je     8004ec <_main+0x4b4>
  8004d8:	83 ec 04             	sub    $0x4,%esp
  8004db:	68 8d 3c 80 00       	push   $0x803c8d
  8004e0:	6a 64                	push   $0x64
  8004e2:	68 5c 39 80 00       	push   $0x80395c
  8004e7:	e8 c7 01 00 00       	call   8006b3 <_panic>

		sfree(w);
  8004ec:	83 ec 0c             	sub    $0xc,%esp
  8004ef:	ff 75 c8             	pushl  -0x38(%ebp)
  8004f2:	e8 b8 14 00 00       	call   8019af <sfree>
  8004f7:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  1792+3+3) panic("Wrong free: check your logic");
  8004fa:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8004fd:	e8 0d 16 00 00       	call   801b0f <sys_calculate_free_frames>
  800502:	29 c3                	sub    %eax,%ebx
  800504:	89 d8                	mov    %ebx,%eax
  800506:	3d 06 07 00 00       	cmp    $0x706,%eax
  80050b:	74 14                	je     800521 <_main+0x4e9>
  80050d:	83 ec 04             	sub    $0x4,%esp
  800510:	68 8d 3c 80 00       	push   $0x803c8d
  800515:	6a 67                	push   $0x67
  800517:	68 5c 39 80 00       	push   $0x80395c
  80051c:	e8 92 01 00 00       	call   8006b3 <_panic>

		sfree(u);
  800521:	83 ec 0c             	sub    $0xc,%esp
  800524:	ff 75 c4             	pushl  -0x3c(%ebp)
  800527:	e8 83 14 00 00       	call   8019af <sfree>
  80052c:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong free: check your logic");
  80052f:	e8 db 15 00 00       	call   801b0f <sys_calculate_free_frames>
  800534:	89 c2                	mov    %eax,%edx
  800536:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800539:	39 c2                	cmp    %eax,%edx
  80053b:	74 14                	je     800551 <_main+0x519>
  80053d:	83 ec 04             	sub    $0x4,%esp
  800540:	68 8d 3c 80 00       	push   $0x803c8d
  800545:	6a 6a                	push   $0x6a
  800547:	68 5c 39 80 00       	push   $0x80395c
  80054c:	e8 62 01 00 00       	call   8006b3 <_panic>
	}
	cprintf("Step C completed successfully!!\n\n\n");
  800551:	83 ec 0c             	sub    $0xc,%esp
  800554:	68 0c 3d 80 00       	push   $0x803d0c
  800559:	e8 09 04 00 00       	call   800967 <cprintf>
  80055e:	83 c4 10             	add    $0x10,%esp

	cprintf("Congratulations!! Test of freeSharedObjects [4] completed successfully!!\n\n\n");
  800561:	83 ec 0c             	sub    $0xc,%esp
  800564:	68 30 3d 80 00       	push   $0x803d30
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
  80057d:	e8 6d 18 00 00       	call   801def <sys_getenvindex>
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
  8005e8:	e8 0f 16 00 00       	call   801bfc <sys_disable_interrupt>
	cprintf("**************************************\n");
  8005ed:	83 ec 0c             	sub    $0xc,%esp
  8005f0:	68 94 3d 80 00       	push   $0x803d94
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
  800618:	68 bc 3d 80 00       	push   $0x803dbc
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
  800649:	68 e4 3d 80 00       	push   $0x803de4
  80064e:	e8 14 03 00 00       	call   800967 <cprintf>
  800653:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800656:	a1 20 50 80 00       	mov    0x805020,%eax
  80065b:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800661:	83 ec 08             	sub    $0x8,%esp
  800664:	50                   	push   %eax
  800665:	68 3c 3e 80 00       	push   $0x803e3c
  80066a:	e8 f8 02 00 00       	call   800967 <cprintf>
  80066f:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800672:	83 ec 0c             	sub    $0xc,%esp
  800675:	68 94 3d 80 00       	push   $0x803d94
  80067a:	e8 e8 02 00 00       	call   800967 <cprintf>
  80067f:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800682:	e8 8f 15 00 00       	call   801c16 <sys_enable_interrupt>

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
  80069a:	e8 1c 17 00 00       	call   801dbb <sys_destroy_env>
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
  8006ab:	e8 71 17 00 00       	call   801e21 <sys_exit_env>
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
  8006d4:	68 50 3e 80 00       	push   $0x803e50
  8006d9:	e8 89 02 00 00       	call   800967 <cprintf>
  8006de:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8006e1:	a1 00 50 80 00       	mov    0x805000,%eax
  8006e6:	ff 75 0c             	pushl  0xc(%ebp)
  8006e9:	ff 75 08             	pushl  0x8(%ebp)
  8006ec:	50                   	push   %eax
  8006ed:	68 55 3e 80 00       	push   $0x803e55
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
  800711:	68 71 3e 80 00       	push   $0x803e71
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
  80073d:	68 74 3e 80 00       	push   $0x803e74
  800742:	6a 26                	push   $0x26
  800744:	68 c0 3e 80 00       	push   $0x803ec0
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
  80080f:	68 cc 3e 80 00       	push   $0x803ecc
  800814:	6a 3a                	push   $0x3a
  800816:	68 c0 3e 80 00       	push   $0x803ec0
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
  80087f:	68 20 3f 80 00       	push   $0x803f20
  800884:	6a 44                	push   $0x44
  800886:	68 c0 3e 80 00       	push   $0x803ec0
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
  8008d9:	e8 70 11 00 00       	call   801a4e <sys_cputs>
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
  800950:	e8 f9 10 00 00       	call   801a4e <sys_cputs>
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
  80099a:	e8 5d 12 00 00       	call   801bfc <sys_disable_interrupt>
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
  8009ba:	e8 57 12 00 00       	call   801c16 <sys_enable_interrupt>
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
  800a04:	e8 cb 2c 00 00       	call   8036d4 <__udivdi3>
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
  800a54:	e8 8b 2d 00 00       	call   8037e4 <__umoddi3>
  800a59:	83 c4 10             	add    $0x10,%esp
  800a5c:	05 94 41 80 00       	add    $0x804194,%eax
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
  800baf:	8b 04 85 b8 41 80 00 	mov    0x8041b8(,%eax,4),%eax
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
  800c90:	8b 34 9d 00 40 80 00 	mov    0x804000(,%ebx,4),%esi
  800c97:	85 f6                	test   %esi,%esi
  800c99:	75 19                	jne    800cb4 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800c9b:	53                   	push   %ebx
  800c9c:	68 a5 41 80 00       	push   $0x8041a5
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
  800cb5:	68 ae 41 80 00       	push   $0x8041ae
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
  800ce2:	be b1 41 80 00       	mov    $0x8041b1,%esi
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
  801708:	68 10 43 80 00       	push   $0x804310
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
  8017d8:	e8 b5 03 00 00       	call   801b92 <sys_allocate_chunk>
  8017dd:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8017e0:	a1 20 51 80 00       	mov    0x805120,%eax
  8017e5:	83 ec 0c             	sub    $0xc,%esp
  8017e8:	50                   	push   %eax
  8017e9:	e8 2a 0a 00 00       	call   802218 <initialize_MemBlocksList>
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
  801816:	68 35 43 80 00       	push   $0x804335
  80181b:	6a 33                	push   $0x33
  80181d:	68 53 43 80 00       	push   $0x804353
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
  801895:	68 60 43 80 00       	push   $0x804360
  80189a:	6a 34                	push   $0x34
  80189c:	68 53 43 80 00       	push   $0x804353
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
  80190a:	68 84 43 80 00       	push   $0x804384
  80190f:	6a 46                	push   $0x46
  801911:	68 53 43 80 00       	push   $0x804353
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
  801926:	68 ac 43 80 00       	push   $0x8043ac
  80192b:	6a 61                	push   $0x61
  80192d:	68 53 43 80 00       	push   $0x804353
  801932:	e8 7c ed ff ff       	call   8006b3 <_panic>

00801937 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801937:	55                   	push   %ebp
  801938:	89 e5                	mov    %esp,%ebp
  80193a:	83 ec 18             	sub    $0x18,%esp
  80193d:	8b 45 10             	mov    0x10(%ebp),%eax
  801940:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801943:	e8 a9 fd ff ff       	call   8016f1 <InitializeUHeap>
	if (size == 0) return NULL ;
  801948:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80194c:	75 07                	jne    801955 <smalloc+0x1e>
  80194e:	b8 00 00 00 00       	mov    $0x0,%eax
  801953:	eb 14                	jmp    801969 <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  801955:	83 ec 04             	sub    $0x4,%esp
  801958:	68 d0 43 80 00       	push   $0x8043d0
  80195d:	6a 76                	push   $0x76
  80195f:	68 53 43 80 00       	push   $0x804353
  801964:	e8 4a ed ff ff       	call   8006b3 <_panic>

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801969:	c9                   	leave  
  80196a:	c3                   	ret    

0080196b <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80196b:	55                   	push   %ebp
  80196c:	89 e5                	mov    %esp,%ebp
  80196e:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801971:	e8 7b fd ff ff       	call   8016f1 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801976:	83 ec 04             	sub    $0x4,%esp
  801979:	68 f8 43 80 00       	push   $0x8043f8
  80197e:	68 93 00 00 00       	push   $0x93
  801983:	68 53 43 80 00       	push   $0x804353
  801988:	e8 26 ed ff ff       	call   8006b3 <_panic>

0080198d <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80198d:	55                   	push   %ebp
  80198e:	89 e5                	mov    %esp,%ebp
  801990:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801993:	e8 59 fd ff ff       	call   8016f1 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801998:	83 ec 04             	sub    $0x4,%esp
  80199b:	68 1c 44 80 00       	push   $0x80441c
  8019a0:	68 c5 00 00 00       	push   $0xc5
  8019a5:	68 53 43 80 00       	push   $0x804353
  8019aa:	e8 04 ed ff ff       	call   8006b3 <_panic>

008019af <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8019af:	55                   	push   %ebp
  8019b0:	89 e5                	mov    %esp,%ebp
  8019b2:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8019b5:	83 ec 04             	sub    $0x4,%esp
  8019b8:	68 44 44 80 00       	push   $0x804444
  8019bd:	68 d9 00 00 00       	push   $0xd9
  8019c2:	68 53 43 80 00       	push   $0x804353
  8019c7:	e8 e7 ec ff ff       	call   8006b3 <_panic>

008019cc <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8019cc:	55                   	push   %ebp
  8019cd:	89 e5                	mov    %esp,%ebp
  8019cf:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8019d2:	83 ec 04             	sub    $0x4,%esp
  8019d5:	68 68 44 80 00       	push   $0x804468
  8019da:	68 e4 00 00 00       	push   $0xe4
  8019df:	68 53 43 80 00       	push   $0x804353
  8019e4:	e8 ca ec ff ff       	call   8006b3 <_panic>

008019e9 <shrink>:

}
void shrink(uint32 newSize)
{
  8019e9:	55                   	push   %ebp
  8019ea:	89 e5                	mov    %esp,%ebp
  8019ec:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8019ef:	83 ec 04             	sub    $0x4,%esp
  8019f2:	68 68 44 80 00       	push   $0x804468
  8019f7:	68 e9 00 00 00       	push   $0xe9
  8019fc:	68 53 43 80 00       	push   $0x804353
  801a01:	e8 ad ec ff ff       	call   8006b3 <_panic>

00801a06 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801a06:	55                   	push   %ebp
  801a07:	89 e5                	mov    %esp,%ebp
  801a09:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a0c:	83 ec 04             	sub    $0x4,%esp
  801a0f:	68 68 44 80 00       	push   $0x804468
  801a14:	68 ee 00 00 00       	push   $0xee
  801a19:	68 53 43 80 00       	push   $0x804353
  801a1e:	e8 90 ec ff ff       	call   8006b3 <_panic>

00801a23 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801a23:	55                   	push   %ebp
  801a24:	89 e5                	mov    %esp,%ebp
  801a26:	57                   	push   %edi
  801a27:	56                   	push   %esi
  801a28:	53                   	push   %ebx
  801a29:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801a2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a32:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a35:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a38:	8b 7d 18             	mov    0x18(%ebp),%edi
  801a3b:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801a3e:	cd 30                	int    $0x30
  801a40:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801a43:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801a46:	83 c4 10             	add    $0x10,%esp
  801a49:	5b                   	pop    %ebx
  801a4a:	5e                   	pop    %esi
  801a4b:	5f                   	pop    %edi
  801a4c:	5d                   	pop    %ebp
  801a4d:	c3                   	ret    

00801a4e <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801a4e:	55                   	push   %ebp
  801a4f:	89 e5                	mov    %esp,%ebp
  801a51:	83 ec 04             	sub    $0x4,%esp
  801a54:	8b 45 10             	mov    0x10(%ebp),%eax
  801a57:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801a5a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a5e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a61:	6a 00                	push   $0x0
  801a63:	6a 00                	push   $0x0
  801a65:	52                   	push   %edx
  801a66:	ff 75 0c             	pushl  0xc(%ebp)
  801a69:	50                   	push   %eax
  801a6a:	6a 00                	push   $0x0
  801a6c:	e8 b2 ff ff ff       	call   801a23 <syscall>
  801a71:	83 c4 18             	add    $0x18,%esp
}
  801a74:	90                   	nop
  801a75:	c9                   	leave  
  801a76:	c3                   	ret    

00801a77 <sys_cgetc>:

int
sys_cgetc(void)
{
  801a77:	55                   	push   %ebp
  801a78:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801a7a:	6a 00                	push   $0x0
  801a7c:	6a 00                	push   $0x0
  801a7e:	6a 00                	push   $0x0
  801a80:	6a 00                	push   $0x0
  801a82:	6a 00                	push   $0x0
  801a84:	6a 01                	push   $0x1
  801a86:	e8 98 ff ff ff       	call   801a23 <syscall>
  801a8b:	83 c4 18             	add    $0x18,%esp
}
  801a8e:	c9                   	leave  
  801a8f:	c3                   	ret    

00801a90 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801a90:	55                   	push   %ebp
  801a91:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801a93:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a96:	8b 45 08             	mov    0x8(%ebp),%eax
  801a99:	6a 00                	push   $0x0
  801a9b:	6a 00                	push   $0x0
  801a9d:	6a 00                	push   $0x0
  801a9f:	52                   	push   %edx
  801aa0:	50                   	push   %eax
  801aa1:	6a 05                	push   $0x5
  801aa3:	e8 7b ff ff ff       	call   801a23 <syscall>
  801aa8:	83 c4 18             	add    $0x18,%esp
}
  801aab:	c9                   	leave  
  801aac:	c3                   	ret    

00801aad <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801aad:	55                   	push   %ebp
  801aae:	89 e5                	mov    %esp,%ebp
  801ab0:	56                   	push   %esi
  801ab1:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801ab2:	8b 75 18             	mov    0x18(%ebp),%esi
  801ab5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ab8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801abb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801abe:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac1:	56                   	push   %esi
  801ac2:	53                   	push   %ebx
  801ac3:	51                   	push   %ecx
  801ac4:	52                   	push   %edx
  801ac5:	50                   	push   %eax
  801ac6:	6a 06                	push   $0x6
  801ac8:	e8 56 ff ff ff       	call   801a23 <syscall>
  801acd:	83 c4 18             	add    $0x18,%esp
}
  801ad0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ad3:	5b                   	pop    %ebx
  801ad4:	5e                   	pop    %esi
  801ad5:	5d                   	pop    %ebp
  801ad6:	c3                   	ret    

00801ad7 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801ad7:	55                   	push   %ebp
  801ad8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801ada:	8b 55 0c             	mov    0xc(%ebp),%edx
  801add:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae0:	6a 00                	push   $0x0
  801ae2:	6a 00                	push   $0x0
  801ae4:	6a 00                	push   $0x0
  801ae6:	52                   	push   %edx
  801ae7:	50                   	push   %eax
  801ae8:	6a 07                	push   $0x7
  801aea:	e8 34 ff ff ff       	call   801a23 <syscall>
  801aef:	83 c4 18             	add    $0x18,%esp
}
  801af2:	c9                   	leave  
  801af3:	c3                   	ret    

00801af4 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801af4:	55                   	push   %ebp
  801af5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801af7:	6a 00                	push   $0x0
  801af9:	6a 00                	push   $0x0
  801afb:	6a 00                	push   $0x0
  801afd:	ff 75 0c             	pushl  0xc(%ebp)
  801b00:	ff 75 08             	pushl  0x8(%ebp)
  801b03:	6a 08                	push   $0x8
  801b05:	e8 19 ff ff ff       	call   801a23 <syscall>
  801b0a:	83 c4 18             	add    $0x18,%esp
}
  801b0d:	c9                   	leave  
  801b0e:	c3                   	ret    

00801b0f <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801b0f:	55                   	push   %ebp
  801b10:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801b12:	6a 00                	push   $0x0
  801b14:	6a 00                	push   $0x0
  801b16:	6a 00                	push   $0x0
  801b18:	6a 00                	push   $0x0
  801b1a:	6a 00                	push   $0x0
  801b1c:	6a 09                	push   $0x9
  801b1e:	e8 00 ff ff ff       	call   801a23 <syscall>
  801b23:	83 c4 18             	add    $0x18,%esp
}
  801b26:	c9                   	leave  
  801b27:	c3                   	ret    

00801b28 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801b28:	55                   	push   %ebp
  801b29:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801b2b:	6a 00                	push   $0x0
  801b2d:	6a 00                	push   $0x0
  801b2f:	6a 00                	push   $0x0
  801b31:	6a 00                	push   $0x0
  801b33:	6a 00                	push   $0x0
  801b35:	6a 0a                	push   $0xa
  801b37:	e8 e7 fe ff ff       	call   801a23 <syscall>
  801b3c:	83 c4 18             	add    $0x18,%esp
}
  801b3f:	c9                   	leave  
  801b40:	c3                   	ret    

00801b41 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801b41:	55                   	push   %ebp
  801b42:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801b44:	6a 00                	push   $0x0
  801b46:	6a 00                	push   $0x0
  801b48:	6a 00                	push   $0x0
  801b4a:	6a 00                	push   $0x0
  801b4c:	6a 00                	push   $0x0
  801b4e:	6a 0b                	push   $0xb
  801b50:	e8 ce fe ff ff       	call   801a23 <syscall>
  801b55:	83 c4 18             	add    $0x18,%esp
}
  801b58:	c9                   	leave  
  801b59:	c3                   	ret    

00801b5a <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801b5a:	55                   	push   %ebp
  801b5b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801b5d:	6a 00                	push   $0x0
  801b5f:	6a 00                	push   $0x0
  801b61:	6a 00                	push   $0x0
  801b63:	ff 75 0c             	pushl  0xc(%ebp)
  801b66:	ff 75 08             	pushl  0x8(%ebp)
  801b69:	6a 0f                	push   $0xf
  801b6b:	e8 b3 fe ff ff       	call   801a23 <syscall>
  801b70:	83 c4 18             	add    $0x18,%esp
	return;
  801b73:	90                   	nop
}
  801b74:	c9                   	leave  
  801b75:	c3                   	ret    

00801b76 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801b76:	55                   	push   %ebp
  801b77:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801b79:	6a 00                	push   $0x0
  801b7b:	6a 00                	push   $0x0
  801b7d:	6a 00                	push   $0x0
  801b7f:	ff 75 0c             	pushl  0xc(%ebp)
  801b82:	ff 75 08             	pushl  0x8(%ebp)
  801b85:	6a 10                	push   $0x10
  801b87:	e8 97 fe ff ff       	call   801a23 <syscall>
  801b8c:	83 c4 18             	add    $0x18,%esp
	return ;
  801b8f:	90                   	nop
}
  801b90:	c9                   	leave  
  801b91:	c3                   	ret    

00801b92 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801b92:	55                   	push   %ebp
  801b93:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801b95:	6a 00                	push   $0x0
  801b97:	6a 00                	push   $0x0
  801b99:	ff 75 10             	pushl  0x10(%ebp)
  801b9c:	ff 75 0c             	pushl  0xc(%ebp)
  801b9f:	ff 75 08             	pushl  0x8(%ebp)
  801ba2:	6a 11                	push   $0x11
  801ba4:	e8 7a fe ff ff       	call   801a23 <syscall>
  801ba9:	83 c4 18             	add    $0x18,%esp
	return ;
  801bac:	90                   	nop
}
  801bad:	c9                   	leave  
  801bae:	c3                   	ret    

00801baf <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801baf:	55                   	push   %ebp
  801bb0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801bb2:	6a 00                	push   $0x0
  801bb4:	6a 00                	push   $0x0
  801bb6:	6a 00                	push   $0x0
  801bb8:	6a 00                	push   $0x0
  801bba:	6a 00                	push   $0x0
  801bbc:	6a 0c                	push   $0xc
  801bbe:	e8 60 fe ff ff       	call   801a23 <syscall>
  801bc3:	83 c4 18             	add    $0x18,%esp
}
  801bc6:	c9                   	leave  
  801bc7:	c3                   	ret    

00801bc8 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801bc8:	55                   	push   %ebp
  801bc9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801bcb:	6a 00                	push   $0x0
  801bcd:	6a 00                	push   $0x0
  801bcf:	6a 00                	push   $0x0
  801bd1:	6a 00                	push   $0x0
  801bd3:	ff 75 08             	pushl  0x8(%ebp)
  801bd6:	6a 0d                	push   $0xd
  801bd8:	e8 46 fe ff ff       	call   801a23 <syscall>
  801bdd:	83 c4 18             	add    $0x18,%esp
}
  801be0:	c9                   	leave  
  801be1:	c3                   	ret    

00801be2 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801be2:	55                   	push   %ebp
  801be3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801be5:	6a 00                	push   $0x0
  801be7:	6a 00                	push   $0x0
  801be9:	6a 00                	push   $0x0
  801beb:	6a 00                	push   $0x0
  801bed:	6a 00                	push   $0x0
  801bef:	6a 0e                	push   $0xe
  801bf1:	e8 2d fe ff ff       	call   801a23 <syscall>
  801bf6:	83 c4 18             	add    $0x18,%esp
}
  801bf9:	90                   	nop
  801bfa:	c9                   	leave  
  801bfb:	c3                   	ret    

00801bfc <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801bfc:	55                   	push   %ebp
  801bfd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801bff:	6a 00                	push   $0x0
  801c01:	6a 00                	push   $0x0
  801c03:	6a 00                	push   $0x0
  801c05:	6a 00                	push   $0x0
  801c07:	6a 00                	push   $0x0
  801c09:	6a 13                	push   $0x13
  801c0b:	e8 13 fe ff ff       	call   801a23 <syscall>
  801c10:	83 c4 18             	add    $0x18,%esp
}
  801c13:	90                   	nop
  801c14:	c9                   	leave  
  801c15:	c3                   	ret    

00801c16 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801c16:	55                   	push   %ebp
  801c17:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801c19:	6a 00                	push   $0x0
  801c1b:	6a 00                	push   $0x0
  801c1d:	6a 00                	push   $0x0
  801c1f:	6a 00                	push   $0x0
  801c21:	6a 00                	push   $0x0
  801c23:	6a 14                	push   $0x14
  801c25:	e8 f9 fd ff ff       	call   801a23 <syscall>
  801c2a:	83 c4 18             	add    $0x18,%esp
}
  801c2d:	90                   	nop
  801c2e:	c9                   	leave  
  801c2f:	c3                   	ret    

00801c30 <sys_cputc>:


void
sys_cputc(const char c)
{
  801c30:	55                   	push   %ebp
  801c31:	89 e5                	mov    %esp,%ebp
  801c33:	83 ec 04             	sub    $0x4,%esp
  801c36:	8b 45 08             	mov    0x8(%ebp),%eax
  801c39:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801c3c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c40:	6a 00                	push   $0x0
  801c42:	6a 00                	push   $0x0
  801c44:	6a 00                	push   $0x0
  801c46:	6a 00                	push   $0x0
  801c48:	50                   	push   %eax
  801c49:	6a 15                	push   $0x15
  801c4b:	e8 d3 fd ff ff       	call   801a23 <syscall>
  801c50:	83 c4 18             	add    $0x18,%esp
}
  801c53:	90                   	nop
  801c54:	c9                   	leave  
  801c55:	c3                   	ret    

00801c56 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801c56:	55                   	push   %ebp
  801c57:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801c59:	6a 00                	push   $0x0
  801c5b:	6a 00                	push   $0x0
  801c5d:	6a 00                	push   $0x0
  801c5f:	6a 00                	push   $0x0
  801c61:	6a 00                	push   $0x0
  801c63:	6a 16                	push   $0x16
  801c65:	e8 b9 fd ff ff       	call   801a23 <syscall>
  801c6a:	83 c4 18             	add    $0x18,%esp
}
  801c6d:	90                   	nop
  801c6e:	c9                   	leave  
  801c6f:	c3                   	ret    

00801c70 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801c70:	55                   	push   %ebp
  801c71:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801c73:	8b 45 08             	mov    0x8(%ebp),%eax
  801c76:	6a 00                	push   $0x0
  801c78:	6a 00                	push   $0x0
  801c7a:	6a 00                	push   $0x0
  801c7c:	ff 75 0c             	pushl  0xc(%ebp)
  801c7f:	50                   	push   %eax
  801c80:	6a 17                	push   $0x17
  801c82:	e8 9c fd ff ff       	call   801a23 <syscall>
  801c87:	83 c4 18             	add    $0x18,%esp
}
  801c8a:	c9                   	leave  
  801c8b:	c3                   	ret    

00801c8c <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801c8c:	55                   	push   %ebp
  801c8d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801c8f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c92:	8b 45 08             	mov    0x8(%ebp),%eax
  801c95:	6a 00                	push   $0x0
  801c97:	6a 00                	push   $0x0
  801c99:	6a 00                	push   $0x0
  801c9b:	52                   	push   %edx
  801c9c:	50                   	push   %eax
  801c9d:	6a 1a                	push   $0x1a
  801c9f:	e8 7f fd ff ff       	call   801a23 <syscall>
  801ca4:	83 c4 18             	add    $0x18,%esp
}
  801ca7:	c9                   	leave  
  801ca8:	c3                   	ret    

00801ca9 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801ca9:	55                   	push   %ebp
  801caa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801cac:	8b 55 0c             	mov    0xc(%ebp),%edx
  801caf:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb2:	6a 00                	push   $0x0
  801cb4:	6a 00                	push   $0x0
  801cb6:	6a 00                	push   $0x0
  801cb8:	52                   	push   %edx
  801cb9:	50                   	push   %eax
  801cba:	6a 18                	push   $0x18
  801cbc:	e8 62 fd ff ff       	call   801a23 <syscall>
  801cc1:	83 c4 18             	add    $0x18,%esp
}
  801cc4:	90                   	nop
  801cc5:	c9                   	leave  
  801cc6:	c3                   	ret    

00801cc7 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801cc7:	55                   	push   %ebp
  801cc8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801cca:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ccd:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd0:	6a 00                	push   $0x0
  801cd2:	6a 00                	push   $0x0
  801cd4:	6a 00                	push   $0x0
  801cd6:	52                   	push   %edx
  801cd7:	50                   	push   %eax
  801cd8:	6a 19                	push   $0x19
  801cda:	e8 44 fd ff ff       	call   801a23 <syscall>
  801cdf:	83 c4 18             	add    $0x18,%esp
}
  801ce2:	90                   	nop
  801ce3:	c9                   	leave  
  801ce4:	c3                   	ret    

00801ce5 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801ce5:	55                   	push   %ebp
  801ce6:	89 e5                	mov    %esp,%ebp
  801ce8:	83 ec 04             	sub    $0x4,%esp
  801ceb:	8b 45 10             	mov    0x10(%ebp),%eax
  801cee:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801cf1:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801cf4:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801cf8:	8b 45 08             	mov    0x8(%ebp),%eax
  801cfb:	6a 00                	push   $0x0
  801cfd:	51                   	push   %ecx
  801cfe:	52                   	push   %edx
  801cff:	ff 75 0c             	pushl  0xc(%ebp)
  801d02:	50                   	push   %eax
  801d03:	6a 1b                	push   $0x1b
  801d05:	e8 19 fd ff ff       	call   801a23 <syscall>
  801d0a:	83 c4 18             	add    $0x18,%esp
}
  801d0d:	c9                   	leave  
  801d0e:	c3                   	ret    

00801d0f <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801d0f:	55                   	push   %ebp
  801d10:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801d12:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d15:	8b 45 08             	mov    0x8(%ebp),%eax
  801d18:	6a 00                	push   $0x0
  801d1a:	6a 00                	push   $0x0
  801d1c:	6a 00                	push   $0x0
  801d1e:	52                   	push   %edx
  801d1f:	50                   	push   %eax
  801d20:	6a 1c                	push   $0x1c
  801d22:	e8 fc fc ff ff       	call   801a23 <syscall>
  801d27:	83 c4 18             	add    $0x18,%esp
}
  801d2a:	c9                   	leave  
  801d2b:	c3                   	ret    

00801d2c <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801d2c:	55                   	push   %ebp
  801d2d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801d2f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d32:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d35:	8b 45 08             	mov    0x8(%ebp),%eax
  801d38:	6a 00                	push   $0x0
  801d3a:	6a 00                	push   $0x0
  801d3c:	51                   	push   %ecx
  801d3d:	52                   	push   %edx
  801d3e:	50                   	push   %eax
  801d3f:	6a 1d                	push   $0x1d
  801d41:	e8 dd fc ff ff       	call   801a23 <syscall>
  801d46:	83 c4 18             	add    $0x18,%esp
}
  801d49:	c9                   	leave  
  801d4a:	c3                   	ret    

00801d4b <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801d4b:	55                   	push   %ebp
  801d4c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801d4e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d51:	8b 45 08             	mov    0x8(%ebp),%eax
  801d54:	6a 00                	push   $0x0
  801d56:	6a 00                	push   $0x0
  801d58:	6a 00                	push   $0x0
  801d5a:	52                   	push   %edx
  801d5b:	50                   	push   %eax
  801d5c:	6a 1e                	push   $0x1e
  801d5e:	e8 c0 fc ff ff       	call   801a23 <syscall>
  801d63:	83 c4 18             	add    $0x18,%esp
}
  801d66:	c9                   	leave  
  801d67:	c3                   	ret    

00801d68 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801d68:	55                   	push   %ebp
  801d69:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801d6b:	6a 00                	push   $0x0
  801d6d:	6a 00                	push   $0x0
  801d6f:	6a 00                	push   $0x0
  801d71:	6a 00                	push   $0x0
  801d73:	6a 00                	push   $0x0
  801d75:	6a 1f                	push   $0x1f
  801d77:	e8 a7 fc ff ff       	call   801a23 <syscall>
  801d7c:	83 c4 18             	add    $0x18,%esp
}
  801d7f:	c9                   	leave  
  801d80:	c3                   	ret    

00801d81 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801d81:	55                   	push   %ebp
  801d82:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801d84:	8b 45 08             	mov    0x8(%ebp),%eax
  801d87:	6a 00                	push   $0x0
  801d89:	ff 75 14             	pushl  0x14(%ebp)
  801d8c:	ff 75 10             	pushl  0x10(%ebp)
  801d8f:	ff 75 0c             	pushl  0xc(%ebp)
  801d92:	50                   	push   %eax
  801d93:	6a 20                	push   $0x20
  801d95:	e8 89 fc ff ff       	call   801a23 <syscall>
  801d9a:	83 c4 18             	add    $0x18,%esp
}
  801d9d:	c9                   	leave  
  801d9e:	c3                   	ret    

00801d9f <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801d9f:	55                   	push   %ebp
  801da0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801da2:	8b 45 08             	mov    0x8(%ebp),%eax
  801da5:	6a 00                	push   $0x0
  801da7:	6a 00                	push   $0x0
  801da9:	6a 00                	push   $0x0
  801dab:	6a 00                	push   $0x0
  801dad:	50                   	push   %eax
  801dae:	6a 21                	push   $0x21
  801db0:	e8 6e fc ff ff       	call   801a23 <syscall>
  801db5:	83 c4 18             	add    $0x18,%esp
}
  801db8:	90                   	nop
  801db9:	c9                   	leave  
  801dba:	c3                   	ret    

00801dbb <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801dbb:	55                   	push   %ebp
  801dbc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801dbe:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc1:	6a 00                	push   $0x0
  801dc3:	6a 00                	push   $0x0
  801dc5:	6a 00                	push   $0x0
  801dc7:	6a 00                	push   $0x0
  801dc9:	50                   	push   %eax
  801dca:	6a 22                	push   $0x22
  801dcc:	e8 52 fc ff ff       	call   801a23 <syscall>
  801dd1:	83 c4 18             	add    $0x18,%esp
}
  801dd4:	c9                   	leave  
  801dd5:	c3                   	ret    

00801dd6 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801dd6:	55                   	push   %ebp
  801dd7:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801dd9:	6a 00                	push   $0x0
  801ddb:	6a 00                	push   $0x0
  801ddd:	6a 00                	push   $0x0
  801ddf:	6a 00                	push   $0x0
  801de1:	6a 00                	push   $0x0
  801de3:	6a 02                	push   $0x2
  801de5:	e8 39 fc ff ff       	call   801a23 <syscall>
  801dea:	83 c4 18             	add    $0x18,%esp
}
  801ded:	c9                   	leave  
  801dee:	c3                   	ret    

00801def <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801def:	55                   	push   %ebp
  801df0:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801df2:	6a 00                	push   $0x0
  801df4:	6a 00                	push   $0x0
  801df6:	6a 00                	push   $0x0
  801df8:	6a 00                	push   $0x0
  801dfa:	6a 00                	push   $0x0
  801dfc:	6a 03                	push   $0x3
  801dfe:	e8 20 fc ff ff       	call   801a23 <syscall>
  801e03:	83 c4 18             	add    $0x18,%esp
}
  801e06:	c9                   	leave  
  801e07:	c3                   	ret    

00801e08 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801e08:	55                   	push   %ebp
  801e09:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801e0b:	6a 00                	push   $0x0
  801e0d:	6a 00                	push   $0x0
  801e0f:	6a 00                	push   $0x0
  801e11:	6a 00                	push   $0x0
  801e13:	6a 00                	push   $0x0
  801e15:	6a 04                	push   $0x4
  801e17:	e8 07 fc ff ff       	call   801a23 <syscall>
  801e1c:	83 c4 18             	add    $0x18,%esp
}
  801e1f:	c9                   	leave  
  801e20:	c3                   	ret    

00801e21 <sys_exit_env>:


void sys_exit_env(void)
{
  801e21:	55                   	push   %ebp
  801e22:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801e24:	6a 00                	push   $0x0
  801e26:	6a 00                	push   $0x0
  801e28:	6a 00                	push   $0x0
  801e2a:	6a 00                	push   $0x0
  801e2c:	6a 00                	push   $0x0
  801e2e:	6a 23                	push   $0x23
  801e30:	e8 ee fb ff ff       	call   801a23 <syscall>
  801e35:	83 c4 18             	add    $0x18,%esp
}
  801e38:	90                   	nop
  801e39:	c9                   	leave  
  801e3a:	c3                   	ret    

00801e3b <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801e3b:	55                   	push   %ebp
  801e3c:	89 e5                	mov    %esp,%ebp
  801e3e:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801e41:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e44:	8d 50 04             	lea    0x4(%eax),%edx
  801e47:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e4a:	6a 00                	push   $0x0
  801e4c:	6a 00                	push   $0x0
  801e4e:	6a 00                	push   $0x0
  801e50:	52                   	push   %edx
  801e51:	50                   	push   %eax
  801e52:	6a 24                	push   $0x24
  801e54:	e8 ca fb ff ff       	call   801a23 <syscall>
  801e59:	83 c4 18             	add    $0x18,%esp
	return result;
  801e5c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e5f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e62:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e65:	89 01                	mov    %eax,(%ecx)
  801e67:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801e6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e6d:	c9                   	leave  
  801e6e:	c2 04 00             	ret    $0x4

00801e71 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801e71:	55                   	push   %ebp
  801e72:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801e74:	6a 00                	push   $0x0
  801e76:	6a 00                	push   $0x0
  801e78:	ff 75 10             	pushl  0x10(%ebp)
  801e7b:	ff 75 0c             	pushl  0xc(%ebp)
  801e7e:	ff 75 08             	pushl  0x8(%ebp)
  801e81:	6a 12                	push   $0x12
  801e83:	e8 9b fb ff ff       	call   801a23 <syscall>
  801e88:	83 c4 18             	add    $0x18,%esp
	return ;
  801e8b:	90                   	nop
}
  801e8c:	c9                   	leave  
  801e8d:	c3                   	ret    

00801e8e <sys_rcr2>:
uint32 sys_rcr2()
{
  801e8e:	55                   	push   %ebp
  801e8f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801e91:	6a 00                	push   $0x0
  801e93:	6a 00                	push   $0x0
  801e95:	6a 00                	push   $0x0
  801e97:	6a 00                	push   $0x0
  801e99:	6a 00                	push   $0x0
  801e9b:	6a 25                	push   $0x25
  801e9d:	e8 81 fb ff ff       	call   801a23 <syscall>
  801ea2:	83 c4 18             	add    $0x18,%esp
}
  801ea5:	c9                   	leave  
  801ea6:	c3                   	ret    

00801ea7 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801ea7:	55                   	push   %ebp
  801ea8:	89 e5                	mov    %esp,%ebp
  801eaa:	83 ec 04             	sub    $0x4,%esp
  801ead:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801eb3:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801eb7:	6a 00                	push   $0x0
  801eb9:	6a 00                	push   $0x0
  801ebb:	6a 00                	push   $0x0
  801ebd:	6a 00                	push   $0x0
  801ebf:	50                   	push   %eax
  801ec0:	6a 26                	push   $0x26
  801ec2:	e8 5c fb ff ff       	call   801a23 <syscall>
  801ec7:	83 c4 18             	add    $0x18,%esp
	return ;
  801eca:	90                   	nop
}
  801ecb:	c9                   	leave  
  801ecc:	c3                   	ret    

00801ecd <rsttst>:
void rsttst()
{
  801ecd:	55                   	push   %ebp
  801ece:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801ed0:	6a 00                	push   $0x0
  801ed2:	6a 00                	push   $0x0
  801ed4:	6a 00                	push   $0x0
  801ed6:	6a 00                	push   $0x0
  801ed8:	6a 00                	push   $0x0
  801eda:	6a 28                	push   $0x28
  801edc:	e8 42 fb ff ff       	call   801a23 <syscall>
  801ee1:	83 c4 18             	add    $0x18,%esp
	return ;
  801ee4:	90                   	nop
}
  801ee5:	c9                   	leave  
  801ee6:	c3                   	ret    

00801ee7 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801ee7:	55                   	push   %ebp
  801ee8:	89 e5                	mov    %esp,%ebp
  801eea:	83 ec 04             	sub    $0x4,%esp
  801eed:	8b 45 14             	mov    0x14(%ebp),%eax
  801ef0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801ef3:	8b 55 18             	mov    0x18(%ebp),%edx
  801ef6:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801efa:	52                   	push   %edx
  801efb:	50                   	push   %eax
  801efc:	ff 75 10             	pushl  0x10(%ebp)
  801eff:	ff 75 0c             	pushl  0xc(%ebp)
  801f02:	ff 75 08             	pushl  0x8(%ebp)
  801f05:	6a 27                	push   $0x27
  801f07:	e8 17 fb ff ff       	call   801a23 <syscall>
  801f0c:	83 c4 18             	add    $0x18,%esp
	return ;
  801f0f:	90                   	nop
}
  801f10:	c9                   	leave  
  801f11:	c3                   	ret    

00801f12 <chktst>:
void chktst(uint32 n)
{
  801f12:	55                   	push   %ebp
  801f13:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801f15:	6a 00                	push   $0x0
  801f17:	6a 00                	push   $0x0
  801f19:	6a 00                	push   $0x0
  801f1b:	6a 00                	push   $0x0
  801f1d:	ff 75 08             	pushl  0x8(%ebp)
  801f20:	6a 29                	push   $0x29
  801f22:	e8 fc fa ff ff       	call   801a23 <syscall>
  801f27:	83 c4 18             	add    $0x18,%esp
	return ;
  801f2a:	90                   	nop
}
  801f2b:	c9                   	leave  
  801f2c:	c3                   	ret    

00801f2d <inctst>:

void inctst()
{
  801f2d:	55                   	push   %ebp
  801f2e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801f30:	6a 00                	push   $0x0
  801f32:	6a 00                	push   $0x0
  801f34:	6a 00                	push   $0x0
  801f36:	6a 00                	push   $0x0
  801f38:	6a 00                	push   $0x0
  801f3a:	6a 2a                	push   $0x2a
  801f3c:	e8 e2 fa ff ff       	call   801a23 <syscall>
  801f41:	83 c4 18             	add    $0x18,%esp
	return ;
  801f44:	90                   	nop
}
  801f45:	c9                   	leave  
  801f46:	c3                   	ret    

00801f47 <gettst>:
uint32 gettst()
{
  801f47:	55                   	push   %ebp
  801f48:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801f4a:	6a 00                	push   $0x0
  801f4c:	6a 00                	push   $0x0
  801f4e:	6a 00                	push   $0x0
  801f50:	6a 00                	push   $0x0
  801f52:	6a 00                	push   $0x0
  801f54:	6a 2b                	push   $0x2b
  801f56:	e8 c8 fa ff ff       	call   801a23 <syscall>
  801f5b:	83 c4 18             	add    $0x18,%esp
}
  801f5e:	c9                   	leave  
  801f5f:	c3                   	ret    

00801f60 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801f60:	55                   	push   %ebp
  801f61:	89 e5                	mov    %esp,%ebp
  801f63:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f66:	6a 00                	push   $0x0
  801f68:	6a 00                	push   $0x0
  801f6a:	6a 00                	push   $0x0
  801f6c:	6a 00                	push   $0x0
  801f6e:	6a 00                	push   $0x0
  801f70:	6a 2c                	push   $0x2c
  801f72:	e8 ac fa ff ff       	call   801a23 <syscall>
  801f77:	83 c4 18             	add    $0x18,%esp
  801f7a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801f7d:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801f81:	75 07                	jne    801f8a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801f83:	b8 01 00 00 00       	mov    $0x1,%eax
  801f88:	eb 05                	jmp    801f8f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801f8a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f8f:	c9                   	leave  
  801f90:	c3                   	ret    

00801f91 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801f91:	55                   	push   %ebp
  801f92:	89 e5                	mov    %esp,%ebp
  801f94:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f97:	6a 00                	push   $0x0
  801f99:	6a 00                	push   $0x0
  801f9b:	6a 00                	push   $0x0
  801f9d:	6a 00                	push   $0x0
  801f9f:	6a 00                	push   $0x0
  801fa1:	6a 2c                	push   $0x2c
  801fa3:	e8 7b fa ff ff       	call   801a23 <syscall>
  801fa8:	83 c4 18             	add    $0x18,%esp
  801fab:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801fae:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801fb2:	75 07                	jne    801fbb <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801fb4:	b8 01 00 00 00       	mov    $0x1,%eax
  801fb9:	eb 05                	jmp    801fc0 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801fbb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fc0:	c9                   	leave  
  801fc1:	c3                   	ret    

00801fc2 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801fc2:	55                   	push   %ebp
  801fc3:	89 e5                	mov    %esp,%ebp
  801fc5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fc8:	6a 00                	push   $0x0
  801fca:	6a 00                	push   $0x0
  801fcc:	6a 00                	push   $0x0
  801fce:	6a 00                	push   $0x0
  801fd0:	6a 00                	push   $0x0
  801fd2:	6a 2c                	push   $0x2c
  801fd4:	e8 4a fa ff ff       	call   801a23 <syscall>
  801fd9:	83 c4 18             	add    $0x18,%esp
  801fdc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801fdf:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801fe3:	75 07                	jne    801fec <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801fe5:	b8 01 00 00 00       	mov    $0x1,%eax
  801fea:	eb 05                	jmp    801ff1 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801fec:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ff1:	c9                   	leave  
  801ff2:	c3                   	ret    

00801ff3 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801ff3:	55                   	push   %ebp
  801ff4:	89 e5                	mov    %esp,%ebp
  801ff6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ff9:	6a 00                	push   $0x0
  801ffb:	6a 00                	push   $0x0
  801ffd:	6a 00                	push   $0x0
  801fff:	6a 00                	push   $0x0
  802001:	6a 00                	push   $0x0
  802003:	6a 2c                	push   $0x2c
  802005:	e8 19 fa ff ff       	call   801a23 <syscall>
  80200a:	83 c4 18             	add    $0x18,%esp
  80200d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802010:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802014:	75 07                	jne    80201d <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802016:	b8 01 00 00 00       	mov    $0x1,%eax
  80201b:	eb 05                	jmp    802022 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80201d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802022:	c9                   	leave  
  802023:	c3                   	ret    

00802024 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802024:	55                   	push   %ebp
  802025:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802027:	6a 00                	push   $0x0
  802029:	6a 00                	push   $0x0
  80202b:	6a 00                	push   $0x0
  80202d:	6a 00                	push   $0x0
  80202f:	ff 75 08             	pushl  0x8(%ebp)
  802032:	6a 2d                	push   $0x2d
  802034:	e8 ea f9 ff ff       	call   801a23 <syscall>
  802039:	83 c4 18             	add    $0x18,%esp
	return ;
  80203c:	90                   	nop
}
  80203d:	c9                   	leave  
  80203e:	c3                   	ret    

0080203f <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80203f:	55                   	push   %ebp
  802040:	89 e5                	mov    %esp,%ebp
  802042:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802043:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802046:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802049:	8b 55 0c             	mov    0xc(%ebp),%edx
  80204c:	8b 45 08             	mov    0x8(%ebp),%eax
  80204f:	6a 00                	push   $0x0
  802051:	53                   	push   %ebx
  802052:	51                   	push   %ecx
  802053:	52                   	push   %edx
  802054:	50                   	push   %eax
  802055:	6a 2e                	push   $0x2e
  802057:	e8 c7 f9 ff ff       	call   801a23 <syscall>
  80205c:	83 c4 18             	add    $0x18,%esp
}
  80205f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802062:	c9                   	leave  
  802063:	c3                   	ret    

00802064 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802064:	55                   	push   %ebp
  802065:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802067:	8b 55 0c             	mov    0xc(%ebp),%edx
  80206a:	8b 45 08             	mov    0x8(%ebp),%eax
  80206d:	6a 00                	push   $0x0
  80206f:	6a 00                	push   $0x0
  802071:	6a 00                	push   $0x0
  802073:	52                   	push   %edx
  802074:	50                   	push   %eax
  802075:	6a 2f                	push   $0x2f
  802077:	e8 a7 f9 ff ff       	call   801a23 <syscall>
  80207c:	83 c4 18             	add    $0x18,%esp
}
  80207f:	c9                   	leave  
  802080:	c3                   	ret    

00802081 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802081:	55                   	push   %ebp
  802082:	89 e5                	mov    %esp,%ebp
  802084:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802087:	83 ec 0c             	sub    $0xc,%esp
  80208a:	68 78 44 80 00       	push   $0x804478
  80208f:	e8 d3 e8 ff ff       	call   800967 <cprintf>
  802094:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802097:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  80209e:	83 ec 0c             	sub    $0xc,%esp
  8020a1:	68 a4 44 80 00       	push   $0x8044a4
  8020a6:	e8 bc e8 ff ff       	call   800967 <cprintf>
  8020ab:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8020ae:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8020b2:	a1 38 51 80 00       	mov    0x805138,%eax
  8020b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020ba:	eb 56                	jmp    802112 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8020bc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8020c0:	74 1c                	je     8020de <print_mem_block_lists+0x5d>
  8020c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c5:	8b 50 08             	mov    0x8(%eax),%edx
  8020c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020cb:	8b 48 08             	mov    0x8(%eax),%ecx
  8020ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020d1:	8b 40 0c             	mov    0xc(%eax),%eax
  8020d4:	01 c8                	add    %ecx,%eax
  8020d6:	39 c2                	cmp    %eax,%edx
  8020d8:	73 04                	jae    8020de <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8020da:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8020de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e1:	8b 50 08             	mov    0x8(%eax),%edx
  8020e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e7:	8b 40 0c             	mov    0xc(%eax),%eax
  8020ea:	01 c2                	add    %eax,%edx
  8020ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ef:	8b 40 08             	mov    0x8(%eax),%eax
  8020f2:	83 ec 04             	sub    $0x4,%esp
  8020f5:	52                   	push   %edx
  8020f6:	50                   	push   %eax
  8020f7:	68 b9 44 80 00       	push   $0x8044b9
  8020fc:	e8 66 e8 ff ff       	call   800967 <cprintf>
  802101:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802104:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802107:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80210a:	a1 40 51 80 00       	mov    0x805140,%eax
  80210f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802112:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802116:	74 07                	je     80211f <print_mem_block_lists+0x9e>
  802118:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80211b:	8b 00                	mov    (%eax),%eax
  80211d:	eb 05                	jmp    802124 <print_mem_block_lists+0xa3>
  80211f:	b8 00 00 00 00       	mov    $0x0,%eax
  802124:	a3 40 51 80 00       	mov    %eax,0x805140
  802129:	a1 40 51 80 00       	mov    0x805140,%eax
  80212e:	85 c0                	test   %eax,%eax
  802130:	75 8a                	jne    8020bc <print_mem_block_lists+0x3b>
  802132:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802136:	75 84                	jne    8020bc <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802138:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80213c:	75 10                	jne    80214e <print_mem_block_lists+0xcd>
  80213e:	83 ec 0c             	sub    $0xc,%esp
  802141:	68 c8 44 80 00       	push   $0x8044c8
  802146:	e8 1c e8 ff ff       	call   800967 <cprintf>
  80214b:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  80214e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802155:	83 ec 0c             	sub    $0xc,%esp
  802158:	68 ec 44 80 00       	push   $0x8044ec
  80215d:	e8 05 e8 ff ff       	call   800967 <cprintf>
  802162:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802165:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802169:	a1 40 50 80 00       	mov    0x805040,%eax
  80216e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802171:	eb 56                	jmp    8021c9 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802173:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802177:	74 1c                	je     802195 <print_mem_block_lists+0x114>
  802179:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80217c:	8b 50 08             	mov    0x8(%eax),%edx
  80217f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802182:	8b 48 08             	mov    0x8(%eax),%ecx
  802185:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802188:	8b 40 0c             	mov    0xc(%eax),%eax
  80218b:	01 c8                	add    %ecx,%eax
  80218d:	39 c2                	cmp    %eax,%edx
  80218f:	73 04                	jae    802195 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802191:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802195:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802198:	8b 50 08             	mov    0x8(%eax),%edx
  80219b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80219e:	8b 40 0c             	mov    0xc(%eax),%eax
  8021a1:	01 c2                	add    %eax,%edx
  8021a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a6:	8b 40 08             	mov    0x8(%eax),%eax
  8021a9:	83 ec 04             	sub    $0x4,%esp
  8021ac:	52                   	push   %edx
  8021ad:	50                   	push   %eax
  8021ae:	68 b9 44 80 00       	push   $0x8044b9
  8021b3:	e8 af e7 ff ff       	call   800967 <cprintf>
  8021b8:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8021bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021be:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8021c1:	a1 48 50 80 00       	mov    0x805048,%eax
  8021c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021c9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021cd:	74 07                	je     8021d6 <print_mem_block_lists+0x155>
  8021cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d2:	8b 00                	mov    (%eax),%eax
  8021d4:	eb 05                	jmp    8021db <print_mem_block_lists+0x15a>
  8021d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8021db:	a3 48 50 80 00       	mov    %eax,0x805048
  8021e0:	a1 48 50 80 00       	mov    0x805048,%eax
  8021e5:	85 c0                	test   %eax,%eax
  8021e7:	75 8a                	jne    802173 <print_mem_block_lists+0xf2>
  8021e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021ed:	75 84                	jne    802173 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8021ef:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8021f3:	75 10                	jne    802205 <print_mem_block_lists+0x184>
  8021f5:	83 ec 0c             	sub    $0xc,%esp
  8021f8:	68 04 45 80 00       	push   $0x804504
  8021fd:	e8 65 e7 ff ff       	call   800967 <cprintf>
  802202:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802205:	83 ec 0c             	sub    $0xc,%esp
  802208:	68 78 44 80 00       	push   $0x804478
  80220d:	e8 55 e7 ff ff       	call   800967 <cprintf>
  802212:	83 c4 10             	add    $0x10,%esp

}
  802215:	90                   	nop
  802216:	c9                   	leave  
  802217:	c3                   	ret    

00802218 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802218:	55                   	push   %ebp
  802219:	89 e5                	mov    %esp,%ebp
  80221b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  80221e:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802225:	00 00 00 
  802228:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  80222f:	00 00 00 
  802232:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802239:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  80223c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802243:	e9 9e 00 00 00       	jmp    8022e6 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  802248:	a1 50 50 80 00       	mov    0x805050,%eax
  80224d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802250:	c1 e2 04             	shl    $0x4,%edx
  802253:	01 d0                	add    %edx,%eax
  802255:	85 c0                	test   %eax,%eax
  802257:	75 14                	jne    80226d <initialize_MemBlocksList+0x55>
  802259:	83 ec 04             	sub    $0x4,%esp
  80225c:	68 2c 45 80 00       	push   $0x80452c
  802261:	6a 46                	push   $0x46
  802263:	68 4f 45 80 00       	push   $0x80454f
  802268:	e8 46 e4 ff ff       	call   8006b3 <_panic>
  80226d:	a1 50 50 80 00       	mov    0x805050,%eax
  802272:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802275:	c1 e2 04             	shl    $0x4,%edx
  802278:	01 d0                	add    %edx,%eax
  80227a:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802280:	89 10                	mov    %edx,(%eax)
  802282:	8b 00                	mov    (%eax),%eax
  802284:	85 c0                	test   %eax,%eax
  802286:	74 18                	je     8022a0 <initialize_MemBlocksList+0x88>
  802288:	a1 48 51 80 00       	mov    0x805148,%eax
  80228d:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802293:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802296:	c1 e1 04             	shl    $0x4,%ecx
  802299:	01 ca                	add    %ecx,%edx
  80229b:	89 50 04             	mov    %edx,0x4(%eax)
  80229e:	eb 12                	jmp    8022b2 <initialize_MemBlocksList+0x9a>
  8022a0:	a1 50 50 80 00       	mov    0x805050,%eax
  8022a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022a8:	c1 e2 04             	shl    $0x4,%edx
  8022ab:	01 d0                	add    %edx,%eax
  8022ad:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8022b2:	a1 50 50 80 00       	mov    0x805050,%eax
  8022b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022ba:	c1 e2 04             	shl    $0x4,%edx
  8022bd:	01 d0                	add    %edx,%eax
  8022bf:	a3 48 51 80 00       	mov    %eax,0x805148
  8022c4:	a1 50 50 80 00       	mov    0x805050,%eax
  8022c9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022cc:	c1 e2 04             	shl    $0x4,%edx
  8022cf:	01 d0                	add    %edx,%eax
  8022d1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022d8:	a1 54 51 80 00       	mov    0x805154,%eax
  8022dd:	40                   	inc    %eax
  8022de:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  8022e3:	ff 45 f4             	incl   -0xc(%ebp)
  8022e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8022ec:	0f 82 56 ff ff ff    	jb     802248 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  8022f2:	90                   	nop
  8022f3:	c9                   	leave  
  8022f4:	c3                   	ret    

008022f5 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8022f5:	55                   	push   %ebp
  8022f6:	89 e5                	mov    %esp,%ebp
  8022f8:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8022fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fe:	8b 00                	mov    (%eax),%eax
  802300:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802303:	eb 19                	jmp    80231e <find_block+0x29>
	{
		if(va==point->sva)
  802305:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802308:	8b 40 08             	mov    0x8(%eax),%eax
  80230b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80230e:	75 05                	jne    802315 <find_block+0x20>
		   return point;
  802310:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802313:	eb 36                	jmp    80234b <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802315:	8b 45 08             	mov    0x8(%ebp),%eax
  802318:	8b 40 08             	mov    0x8(%eax),%eax
  80231b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80231e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802322:	74 07                	je     80232b <find_block+0x36>
  802324:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802327:	8b 00                	mov    (%eax),%eax
  802329:	eb 05                	jmp    802330 <find_block+0x3b>
  80232b:	b8 00 00 00 00       	mov    $0x0,%eax
  802330:	8b 55 08             	mov    0x8(%ebp),%edx
  802333:	89 42 08             	mov    %eax,0x8(%edx)
  802336:	8b 45 08             	mov    0x8(%ebp),%eax
  802339:	8b 40 08             	mov    0x8(%eax),%eax
  80233c:	85 c0                	test   %eax,%eax
  80233e:	75 c5                	jne    802305 <find_block+0x10>
  802340:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802344:	75 bf                	jne    802305 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802346:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80234b:	c9                   	leave  
  80234c:	c3                   	ret    

0080234d <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80234d:	55                   	push   %ebp
  80234e:	89 e5                	mov    %esp,%ebp
  802350:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  802353:	a1 40 50 80 00       	mov    0x805040,%eax
  802358:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  80235b:	a1 44 50 80 00       	mov    0x805044,%eax
  802360:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  802363:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802366:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802369:	74 24                	je     80238f <insert_sorted_allocList+0x42>
  80236b:	8b 45 08             	mov    0x8(%ebp),%eax
  80236e:	8b 50 08             	mov    0x8(%eax),%edx
  802371:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802374:	8b 40 08             	mov    0x8(%eax),%eax
  802377:	39 c2                	cmp    %eax,%edx
  802379:	76 14                	jbe    80238f <insert_sorted_allocList+0x42>
  80237b:	8b 45 08             	mov    0x8(%ebp),%eax
  80237e:	8b 50 08             	mov    0x8(%eax),%edx
  802381:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802384:	8b 40 08             	mov    0x8(%eax),%eax
  802387:	39 c2                	cmp    %eax,%edx
  802389:	0f 82 60 01 00 00    	jb     8024ef <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  80238f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802393:	75 65                	jne    8023fa <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802395:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802399:	75 14                	jne    8023af <insert_sorted_allocList+0x62>
  80239b:	83 ec 04             	sub    $0x4,%esp
  80239e:	68 2c 45 80 00       	push   $0x80452c
  8023a3:	6a 6b                	push   $0x6b
  8023a5:	68 4f 45 80 00       	push   $0x80454f
  8023aa:	e8 04 e3 ff ff       	call   8006b3 <_panic>
  8023af:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8023b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b8:	89 10                	mov    %edx,(%eax)
  8023ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8023bd:	8b 00                	mov    (%eax),%eax
  8023bf:	85 c0                	test   %eax,%eax
  8023c1:	74 0d                	je     8023d0 <insert_sorted_allocList+0x83>
  8023c3:	a1 40 50 80 00       	mov    0x805040,%eax
  8023c8:	8b 55 08             	mov    0x8(%ebp),%edx
  8023cb:	89 50 04             	mov    %edx,0x4(%eax)
  8023ce:	eb 08                	jmp    8023d8 <insert_sorted_allocList+0x8b>
  8023d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d3:	a3 44 50 80 00       	mov    %eax,0x805044
  8023d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023db:	a3 40 50 80 00       	mov    %eax,0x805040
  8023e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023ea:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8023ef:	40                   	inc    %eax
  8023f0:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8023f5:	e9 dc 01 00 00       	jmp    8025d6 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  8023fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8023fd:	8b 50 08             	mov    0x8(%eax),%edx
  802400:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802403:	8b 40 08             	mov    0x8(%eax),%eax
  802406:	39 c2                	cmp    %eax,%edx
  802408:	77 6c                	ja     802476 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  80240a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80240e:	74 06                	je     802416 <insert_sorted_allocList+0xc9>
  802410:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802414:	75 14                	jne    80242a <insert_sorted_allocList+0xdd>
  802416:	83 ec 04             	sub    $0x4,%esp
  802419:	68 68 45 80 00       	push   $0x804568
  80241e:	6a 6f                	push   $0x6f
  802420:	68 4f 45 80 00       	push   $0x80454f
  802425:	e8 89 e2 ff ff       	call   8006b3 <_panic>
  80242a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80242d:	8b 50 04             	mov    0x4(%eax),%edx
  802430:	8b 45 08             	mov    0x8(%ebp),%eax
  802433:	89 50 04             	mov    %edx,0x4(%eax)
  802436:	8b 45 08             	mov    0x8(%ebp),%eax
  802439:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80243c:	89 10                	mov    %edx,(%eax)
  80243e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802441:	8b 40 04             	mov    0x4(%eax),%eax
  802444:	85 c0                	test   %eax,%eax
  802446:	74 0d                	je     802455 <insert_sorted_allocList+0x108>
  802448:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80244b:	8b 40 04             	mov    0x4(%eax),%eax
  80244e:	8b 55 08             	mov    0x8(%ebp),%edx
  802451:	89 10                	mov    %edx,(%eax)
  802453:	eb 08                	jmp    80245d <insert_sorted_allocList+0x110>
  802455:	8b 45 08             	mov    0x8(%ebp),%eax
  802458:	a3 40 50 80 00       	mov    %eax,0x805040
  80245d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802460:	8b 55 08             	mov    0x8(%ebp),%edx
  802463:	89 50 04             	mov    %edx,0x4(%eax)
  802466:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80246b:	40                   	inc    %eax
  80246c:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802471:	e9 60 01 00 00       	jmp    8025d6 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802476:	8b 45 08             	mov    0x8(%ebp),%eax
  802479:	8b 50 08             	mov    0x8(%eax),%edx
  80247c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80247f:	8b 40 08             	mov    0x8(%eax),%eax
  802482:	39 c2                	cmp    %eax,%edx
  802484:	0f 82 4c 01 00 00    	jb     8025d6 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  80248a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80248e:	75 14                	jne    8024a4 <insert_sorted_allocList+0x157>
  802490:	83 ec 04             	sub    $0x4,%esp
  802493:	68 a0 45 80 00       	push   $0x8045a0
  802498:	6a 73                	push   $0x73
  80249a:	68 4f 45 80 00       	push   $0x80454f
  80249f:	e8 0f e2 ff ff       	call   8006b3 <_panic>
  8024a4:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8024aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ad:	89 50 04             	mov    %edx,0x4(%eax)
  8024b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b3:	8b 40 04             	mov    0x4(%eax),%eax
  8024b6:	85 c0                	test   %eax,%eax
  8024b8:	74 0c                	je     8024c6 <insert_sorted_allocList+0x179>
  8024ba:	a1 44 50 80 00       	mov    0x805044,%eax
  8024bf:	8b 55 08             	mov    0x8(%ebp),%edx
  8024c2:	89 10                	mov    %edx,(%eax)
  8024c4:	eb 08                	jmp    8024ce <insert_sorted_allocList+0x181>
  8024c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c9:	a3 40 50 80 00       	mov    %eax,0x805040
  8024ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d1:	a3 44 50 80 00       	mov    %eax,0x805044
  8024d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024df:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8024e4:	40                   	inc    %eax
  8024e5:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8024ea:	e9 e7 00 00 00       	jmp    8025d6 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  8024ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  8024f5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8024fc:	a1 40 50 80 00       	mov    0x805040,%eax
  802501:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802504:	e9 9d 00 00 00       	jmp    8025a6 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802509:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250c:	8b 00                	mov    (%eax),%eax
  80250e:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802511:	8b 45 08             	mov    0x8(%ebp),%eax
  802514:	8b 50 08             	mov    0x8(%eax),%edx
  802517:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251a:	8b 40 08             	mov    0x8(%eax),%eax
  80251d:	39 c2                	cmp    %eax,%edx
  80251f:	76 7d                	jbe    80259e <insert_sorted_allocList+0x251>
  802521:	8b 45 08             	mov    0x8(%ebp),%eax
  802524:	8b 50 08             	mov    0x8(%eax),%edx
  802527:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80252a:	8b 40 08             	mov    0x8(%eax),%eax
  80252d:	39 c2                	cmp    %eax,%edx
  80252f:	73 6d                	jae    80259e <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802531:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802535:	74 06                	je     80253d <insert_sorted_allocList+0x1f0>
  802537:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80253b:	75 14                	jne    802551 <insert_sorted_allocList+0x204>
  80253d:	83 ec 04             	sub    $0x4,%esp
  802540:	68 c4 45 80 00       	push   $0x8045c4
  802545:	6a 7f                	push   $0x7f
  802547:	68 4f 45 80 00       	push   $0x80454f
  80254c:	e8 62 e1 ff ff       	call   8006b3 <_panic>
  802551:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802554:	8b 10                	mov    (%eax),%edx
  802556:	8b 45 08             	mov    0x8(%ebp),%eax
  802559:	89 10                	mov    %edx,(%eax)
  80255b:	8b 45 08             	mov    0x8(%ebp),%eax
  80255e:	8b 00                	mov    (%eax),%eax
  802560:	85 c0                	test   %eax,%eax
  802562:	74 0b                	je     80256f <insert_sorted_allocList+0x222>
  802564:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802567:	8b 00                	mov    (%eax),%eax
  802569:	8b 55 08             	mov    0x8(%ebp),%edx
  80256c:	89 50 04             	mov    %edx,0x4(%eax)
  80256f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802572:	8b 55 08             	mov    0x8(%ebp),%edx
  802575:	89 10                	mov    %edx,(%eax)
  802577:	8b 45 08             	mov    0x8(%ebp),%eax
  80257a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80257d:	89 50 04             	mov    %edx,0x4(%eax)
  802580:	8b 45 08             	mov    0x8(%ebp),%eax
  802583:	8b 00                	mov    (%eax),%eax
  802585:	85 c0                	test   %eax,%eax
  802587:	75 08                	jne    802591 <insert_sorted_allocList+0x244>
  802589:	8b 45 08             	mov    0x8(%ebp),%eax
  80258c:	a3 44 50 80 00       	mov    %eax,0x805044
  802591:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802596:	40                   	inc    %eax
  802597:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  80259c:	eb 39                	jmp    8025d7 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80259e:	a1 48 50 80 00       	mov    0x805048,%eax
  8025a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025a6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025aa:	74 07                	je     8025b3 <insert_sorted_allocList+0x266>
  8025ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025af:	8b 00                	mov    (%eax),%eax
  8025b1:	eb 05                	jmp    8025b8 <insert_sorted_allocList+0x26b>
  8025b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8025b8:	a3 48 50 80 00       	mov    %eax,0x805048
  8025bd:	a1 48 50 80 00       	mov    0x805048,%eax
  8025c2:	85 c0                	test   %eax,%eax
  8025c4:	0f 85 3f ff ff ff    	jne    802509 <insert_sorted_allocList+0x1bc>
  8025ca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025ce:	0f 85 35 ff ff ff    	jne    802509 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8025d4:	eb 01                	jmp    8025d7 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8025d6:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8025d7:	90                   	nop
  8025d8:	c9                   	leave  
  8025d9:	c3                   	ret    

008025da <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8025da:	55                   	push   %ebp
  8025db:	89 e5                	mov    %esp,%ebp
  8025dd:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8025e0:	a1 38 51 80 00       	mov    0x805138,%eax
  8025e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025e8:	e9 85 01 00 00       	jmp    802772 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  8025ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f0:	8b 40 0c             	mov    0xc(%eax),%eax
  8025f3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025f6:	0f 82 6e 01 00 00    	jb     80276a <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  8025fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ff:	8b 40 0c             	mov    0xc(%eax),%eax
  802602:	3b 45 08             	cmp    0x8(%ebp),%eax
  802605:	0f 85 8a 00 00 00    	jne    802695 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  80260b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80260f:	75 17                	jne    802628 <alloc_block_FF+0x4e>
  802611:	83 ec 04             	sub    $0x4,%esp
  802614:	68 f8 45 80 00       	push   $0x8045f8
  802619:	68 93 00 00 00       	push   $0x93
  80261e:	68 4f 45 80 00       	push   $0x80454f
  802623:	e8 8b e0 ff ff       	call   8006b3 <_panic>
  802628:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262b:	8b 00                	mov    (%eax),%eax
  80262d:	85 c0                	test   %eax,%eax
  80262f:	74 10                	je     802641 <alloc_block_FF+0x67>
  802631:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802634:	8b 00                	mov    (%eax),%eax
  802636:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802639:	8b 52 04             	mov    0x4(%edx),%edx
  80263c:	89 50 04             	mov    %edx,0x4(%eax)
  80263f:	eb 0b                	jmp    80264c <alloc_block_FF+0x72>
  802641:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802644:	8b 40 04             	mov    0x4(%eax),%eax
  802647:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80264c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264f:	8b 40 04             	mov    0x4(%eax),%eax
  802652:	85 c0                	test   %eax,%eax
  802654:	74 0f                	je     802665 <alloc_block_FF+0x8b>
  802656:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802659:	8b 40 04             	mov    0x4(%eax),%eax
  80265c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80265f:	8b 12                	mov    (%edx),%edx
  802661:	89 10                	mov    %edx,(%eax)
  802663:	eb 0a                	jmp    80266f <alloc_block_FF+0x95>
  802665:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802668:	8b 00                	mov    (%eax),%eax
  80266a:	a3 38 51 80 00       	mov    %eax,0x805138
  80266f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802672:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802678:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802682:	a1 44 51 80 00       	mov    0x805144,%eax
  802687:	48                   	dec    %eax
  802688:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  80268d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802690:	e9 10 01 00 00       	jmp    8027a5 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802695:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802698:	8b 40 0c             	mov    0xc(%eax),%eax
  80269b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80269e:	0f 86 c6 00 00 00    	jbe    80276a <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8026a4:	a1 48 51 80 00       	mov    0x805148,%eax
  8026a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  8026ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026af:	8b 50 08             	mov    0x8(%eax),%edx
  8026b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026b5:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  8026b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026bb:	8b 55 08             	mov    0x8(%ebp),%edx
  8026be:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8026c1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8026c5:	75 17                	jne    8026de <alloc_block_FF+0x104>
  8026c7:	83 ec 04             	sub    $0x4,%esp
  8026ca:	68 f8 45 80 00       	push   $0x8045f8
  8026cf:	68 9b 00 00 00       	push   $0x9b
  8026d4:	68 4f 45 80 00       	push   $0x80454f
  8026d9:	e8 d5 df ff ff       	call   8006b3 <_panic>
  8026de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026e1:	8b 00                	mov    (%eax),%eax
  8026e3:	85 c0                	test   %eax,%eax
  8026e5:	74 10                	je     8026f7 <alloc_block_FF+0x11d>
  8026e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026ea:	8b 00                	mov    (%eax),%eax
  8026ec:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8026ef:	8b 52 04             	mov    0x4(%edx),%edx
  8026f2:	89 50 04             	mov    %edx,0x4(%eax)
  8026f5:	eb 0b                	jmp    802702 <alloc_block_FF+0x128>
  8026f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026fa:	8b 40 04             	mov    0x4(%eax),%eax
  8026fd:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802702:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802705:	8b 40 04             	mov    0x4(%eax),%eax
  802708:	85 c0                	test   %eax,%eax
  80270a:	74 0f                	je     80271b <alloc_block_FF+0x141>
  80270c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80270f:	8b 40 04             	mov    0x4(%eax),%eax
  802712:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802715:	8b 12                	mov    (%edx),%edx
  802717:	89 10                	mov    %edx,(%eax)
  802719:	eb 0a                	jmp    802725 <alloc_block_FF+0x14b>
  80271b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80271e:	8b 00                	mov    (%eax),%eax
  802720:	a3 48 51 80 00       	mov    %eax,0x805148
  802725:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802728:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80272e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802731:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802738:	a1 54 51 80 00       	mov    0x805154,%eax
  80273d:	48                   	dec    %eax
  80273e:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802743:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802746:	8b 50 08             	mov    0x8(%eax),%edx
  802749:	8b 45 08             	mov    0x8(%ebp),%eax
  80274c:	01 c2                	add    %eax,%edx
  80274e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802751:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802754:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802757:	8b 40 0c             	mov    0xc(%eax),%eax
  80275a:	2b 45 08             	sub    0x8(%ebp),%eax
  80275d:	89 c2                	mov    %eax,%edx
  80275f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802762:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802765:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802768:	eb 3b                	jmp    8027a5 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  80276a:	a1 40 51 80 00       	mov    0x805140,%eax
  80276f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802772:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802776:	74 07                	je     80277f <alloc_block_FF+0x1a5>
  802778:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277b:	8b 00                	mov    (%eax),%eax
  80277d:	eb 05                	jmp    802784 <alloc_block_FF+0x1aa>
  80277f:	b8 00 00 00 00       	mov    $0x0,%eax
  802784:	a3 40 51 80 00       	mov    %eax,0x805140
  802789:	a1 40 51 80 00       	mov    0x805140,%eax
  80278e:	85 c0                	test   %eax,%eax
  802790:	0f 85 57 fe ff ff    	jne    8025ed <alloc_block_FF+0x13>
  802796:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80279a:	0f 85 4d fe ff ff    	jne    8025ed <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  8027a0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027a5:	c9                   	leave  
  8027a6:	c3                   	ret    

008027a7 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8027a7:	55                   	push   %ebp
  8027a8:	89 e5                	mov    %esp,%ebp
  8027aa:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  8027ad:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8027b4:	a1 38 51 80 00       	mov    0x805138,%eax
  8027b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027bc:	e9 df 00 00 00       	jmp    8028a0 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  8027c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c4:	8b 40 0c             	mov    0xc(%eax),%eax
  8027c7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027ca:	0f 82 c8 00 00 00    	jb     802898 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  8027d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d3:	8b 40 0c             	mov    0xc(%eax),%eax
  8027d6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027d9:	0f 85 8a 00 00 00    	jne    802869 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  8027df:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027e3:	75 17                	jne    8027fc <alloc_block_BF+0x55>
  8027e5:	83 ec 04             	sub    $0x4,%esp
  8027e8:	68 f8 45 80 00       	push   $0x8045f8
  8027ed:	68 b7 00 00 00       	push   $0xb7
  8027f2:	68 4f 45 80 00       	push   $0x80454f
  8027f7:	e8 b7 de ff ff       	call   8006b3 <_panic>
  8027fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ff:	8b 00                	mov    (%eax),%eax
  802801:	85 c0                	test   %eax,%eax
  802803:	74 10                	je     802815 <alloc_block_BF+0x6e>
  802805:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802808:	8b 00                	mov    (%eax),%eax
  80280a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80280d:	8b 52 04             	mov    0x4(%edx),%edx
  802810:	89 50 04             	mov    %edx,0x4(%eax)
  802813:	eb 0b                	jmp    802820 <alloc_block_BF+0x79>
  802815:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802818:	8b 40 04             	mov    0x4(%eax),%eax
  80281b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802820:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802823:	8b 40 04             	mov    0x4(%eax),%eax
  802826:	85 c0                	test   %eax,%eax
  802828:	74 0f                	je     802839 <alloc_block_BF+0x92>
  80282a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282d:	8b 40 04             	mov    0x4(%eax),%eax
  802830:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802833:	8b 12                	mov    (%edx),%edx
  802835:	89 10                	mov    %edx,(%eax)
  802837:	eb 0a                	jmp    802843 <alloc_block_BF+0x9c>
  802839:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283c:	8b 00                	mov    (%eax),%eax
  80283e:	a3 38 51 80 00       	mov    %eax,0x805138
  802843:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802846:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80284c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802856:	a1 44 51 80 00       	mov    0x805144,%eax
  80285b:	48                   	dec    %eax
  80285c:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802861:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802864:	e9 4d 01 00 00       	jmp    8029b6 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802869:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286c:	8b 40 0c             	mov    0xc(%eax),%eax
  80286f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802872:	76 24                	jbe    802898 <alloc_block_BF+0xf1>
  802874:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802877:	8b 40 0c             	mov    0xc(%eax),%eax
  80287a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80287d:	73 19                	jae    802898 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  80287f:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802886:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802889:	8b 40 0c             	mov    0xc(%eax),%eax
  80288c:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  80288f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802892:	8b 40 08             	mov    0x8(%eax),%eax
  802895:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802898:	a1 40 51 80 00       	mov    0x805140,%eax
  80289d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028a0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028a4:	74 07                	je     8028ad <alloc_block_BF+0x106>
  8028a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a9:	8b 00                	mov    (%eax),%eax
  8028ab:	eb 05                	jmp    8028b2 <alloc_block_BF+0x10b>
  8028ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8028b2:	a3 40 51 80 00       	mov    %eax,0x805140
  8028b7:	a1 40 51 80 00       	mov    0x805140,%eax
  8028bc:	85 c0                	test   %eax,%eax
  8028be:	0f 85 fd fe ff ff    	jne    8027c1 <alloc_block_BF+0x1a>
  8028c4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028c8:	0f 85 f3 fe ff ff    	jne    8027c1 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  8028ce:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8028d2:	0f 84 d9 00 00 00    	je     8029b1 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  8028d8:	a1 48 51 80 00       	mov    0x805148,%eax
  8028dd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  8028e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028e3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8028e6:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  8028e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028ec:	8b 55 08             	mov    0x8(%ebp),%edx
  8028ef:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  8028f2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8028f6:	75 17                	jne    80290f <alloc_block_BF+0x168>
  8028f8:	83 ec 04             	sub    $0x4,%esp
  8028fb:	68 f8 45 80 00       	push   $0x8045f8
  802900:	68 c7 00 00 00       	push   $0xc7
  802905:	68 4f 45 80 00       	push   $0x80454f
  80290a:	e8 a4 dd ff ff       	call   8006b3 <_panic>
  80290f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802912:	8b 00                	mov    (%eax),%eax
  802914:	85 c0                	test   %eax,%eax
  802916:	74 10                	je     802928 <alloc_block_BF+0x181>
  802918:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80291b:	8b 00                	mov    (%eax),%eax
  80291d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802920:	8b 52 04             	mov    0x4(%edx),%edx
  802923:	89 50 04             	mov    %edx,0x4(%eax)
  802926:	eb 0b                	jmp    802933 <alloc_block_BF+0x18c>
  802928:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80292b:	8b 40 04             	mov    0x4(%eax),%eax
  80292e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802933:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802936:	8b 40 04             	mov    0x4(%eax),%eax
  802939:	85 c0                	test   %eax,%eax
  80293b:	74 0f                	je     80294c <alloc_block_BF+0x1a5>
  80293d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802940:	8b 40 04             	mov    0x4(%eax),%eax
  802943:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802946:	8b 12                	mov    (%edx),%edx
  802948:	89 10                	mov    %edx,(%eax)
  80294a:	eb 0a                	jmp    802956 <alloc_block_BF+0x1af>
  80294c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80294f:	8b 00                	mov    (%eax),%eax
  802951:	a3 48 51 80 00       	mov    %eax,0x805148
  802956:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802959:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80295f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802962:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802969:	a1 54 51 80 00       	mov    0x805154,%eax
  80296e:	48                   	dec    %eax
  80296f:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802974:	83 ec 08             	sub    $0x8,%esp
  802977:	ff 75 ec             	pushl  -0x14(%ebp)
  80297a:	68 38 51 80 00       	push   $0x805138
  80297f:	e8 71 f9 ff ff       	call   8022f5 <find_block>
  802984:	83 c4 10             	add    $0x10,%esp
  802987:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  80298a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80298d:	8b 50 08             	mov    0x8(%eax),%edx
  802990:	8b 45 08             	mov    0x8(%ebp),%eax
  802993:	01 c2                	add    %eax,%edx
  802995:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802998:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  80299b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80299e:	8b 40 0c             	mov    0xc(%eax),%eax
  8029a1:	2b 45 08             	sub    0x8(%ebp),%eax
  8029a4:	89 c2                	mov    %eax,%edx
  8029a6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029a9:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  8029ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029af:	eb 05                	jmp    8029b6 <alloc_block_BF+0x20f>
	}
	return NULL;
  8029b1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029b6:	c9                   	leave  
  8029b7:	c3                   	ret    

008029b8 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  8029b8:	55                   	push   %ebp
  8029b9:	89 e5                	mov    %esp,%ebp
  8029bb:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  8029be:	a1 28 50 80 00       	mov    0x805028,%eax
  8029c3:	85 c0                	test   %eax,%eax
  8029c5:	0f 85 de 01 00 00    	jne    802ba9 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8029cb:	a1 38 51 80 00       	mov    0x805138,%eax
  8029d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029d3:	e9 9e 01 00 00       	jmp    802b76 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  8029d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029db:	8b 40 0c             	mov    0xc(%eax),%eax
  8029de:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029e1:	0f 82 87 01 00 00    	jb     802b6e <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  8029e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ea:	8b 40 0c             	mov    0xc(%eax),%eax
  8029ed:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029f0:	0f 85 95 00 00 00    	jne    802a8b <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  8029f6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029fa:	75 17                	jne    802a13 <alloc_block_NF+0x5b>
  8029fc:	83 ec 04             	sub    $0x4,%esp
  8029ff:	68 f8 45 80 00       	push   $0x8045f8
  802a04:	68 e0 00 00 00       	push   $0xe0
  802a09:	68 4f 45 80 00       	push   $0x80454f
  802a0e:	e8 a0 dc ff ff       	call   8006b3 <_panic>
  802a13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a16:	8b 00                	mov    (%eax),%eax
  802a18:	85 c0                	test   %eax,%eax
  802a1a:	74 10                	je     802a2c <alloc_block_NF+0x74>
  802a1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1f:	8b 00                	mov    (%eax),%eax
  802a21:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a24:	8b 52 04             	mov    0x4(%edx),%edx
  802a27:	89 50 04             	mov    %edx,0x4(%eax)
  802a2a:	eb 0b                	jmp    802a37 <alloc_block_NF+0x7f>
  802a2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2f:	8b 40 04             	mov    0x4(%eax),%eax
  802a32:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802a37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3a:	8b 40 04             	mov    0x4(%eax),%eax
  802a3d:	85 c0                	test   %eax,%eax
  802a3f:	74 0f                	je     802a50 <alloc_block_NF+0x98>
  802a41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a44:	8b 40 04             	mov    0x4(%eax),%eax
  802a47:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a4a:	8b 12                	mov    (%edx),%edx
  802a4c:	89 10                	mov    %edx,(%eax)
  802a4e:	eb 0a                	jmp    802a5a <alloc_block_NF+0xa2>
  802a50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a53:	8b 00                	mov    (%eax),%eax
  802a55:	a3 38 51 80 00       	mov    %eax,0x805138
  802a5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a66:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a6d:	a1 44 51 80 00       	mov    0x805144,%eax
  802a72:	48                   	dec    %eax
  802a73:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802a78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7b:	8b 40 08             	mov    0x8(%eax),%eax
  802a7e:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  802a83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a86:	e9 f8 04 00 00       	jmp    802f83 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802a8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8e:	8b 40 0c             	mov    0xc(%eax),%eax
  802a91:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a94:	0f 86 d4 00 00 00    	jbe    802b6e <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802a9a:	a1 48 51 80 00       	mov    0x805148,%eax
  802a9f:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802aa2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa5:	8b 50 08             	mov    0x8(%eax),%edx
  802aa8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aab:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802aae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ab1:	8b 55 08             	mov    0x8(%ebp),%edx
  802ab4:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802ab7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802abb:	75 17                	jne    802ad4 <alloc_block_NF+0x11c>
  802abd:	83 ec 04             	sub    $0x4,%esp
  802ac0:	68 f8 45 80 00       	push   $0x8045f8
  802ac5:	68 e9 00 00 00       	push   $0xe9
  802aca:	68 4f 45 80 00       	push   $0x80454f
  802acf:	e8 df db ff ff       	call   8006b3 <_panic>
  802ad4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ad7:	8b 00                	mov    (%eax),%eax
  802ad9:	85 c0                	test   %eax,%eax
  802adb:	74 10                	je     802aed <alloc_block_NF+0x135>
  802add:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ae0:	8b 00                	mov    (%eax),%eax
  802ae2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ae5:	8b 52 04             	mov    0x4(%edx),%edx
  802ae8:	89 50 04             	mov    %edx,0x4(%eax)
  802aeb:	eb 0b                	jmp    802af8 <alloc_block_NF+0x140>
  802aed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802af0:	8b 40 04             	mov    0x4(%eax),%eax
  802af3:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802af8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802afb:	8b 40 04             	mov    0x4(%eax),%eax
  802afe:	85 c0                	test   %eax,%eax
  802b00:	74 0f                	je     802b11 <alloc_block_NF+0x159>
  802b02:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b05:	8b 40 04             	mov    0x4(%eax),%eax
  802b08:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b0b:	8b 12                	mov    (%edx),%edx
  802b0d:	89 10                	mov    %edx,(%eax)
  802b0f:	eb 0a                	jmp    802b1b <alloc_block_NF+0x163>
  802b11:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b14:	8b 00                	mov    (%eax),%eax
  802b16:	a3 48 51 80 00       	mov    %eax,0x805148
  802b1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b1e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b24:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b27:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b2e:	a1 54 51 80 00       	mov    0x805154,%eax
  802b33:	48                   	dec    %eax
  802b34:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802b39:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b3c:	8b 40 08             	mov    0x8(%eax),%eax
  802b3f:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802b44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b47:	8b 50 08             	mov    0x8(%eax),%edx
  802b4a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b4d:	01 c2                	add    %eax,%edx
  802b4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b52:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802b55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b58:	8b 40 0c             	mov    0xc(%eax),%eax
  802b5b:	2b 45 08             	sub    0x8(%ebp),%eax
  802b5e:	89 c2                	mov    %eax,%edx
  802b60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b63:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802b66:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b69:	e9 15 04 00 00       	jmp    802f83 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802b6e:	a1 40 51 80 00       	mov    0x805140,%eax
  802b73:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b76:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b7a:	74 07                	je     802b83 <alloc_block_NF+0x1cb>
  802b7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b7f:	8b 00                	mov    (%eax),%eax
  802b81:	eb 05                	jmp    802b88 <alloc_block_NF+0x1d0>
  802b83:	b8 00 00 00 00       	mov    $0x0,%eax
  802b88:	a3 40 51 80 00       	mov    %eax,0x805140
  802b8d:	a1 40 51 80 00       	mov    0x805140,%eax
  802b92:	85 c0                	test   %eax,%eax
  802b94:	0f 85 3e fe ff ff    	jne    8029d8 <alloc_block_NF+0x20>
  802b9a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b9e:	0f 85 34 fe ff ff    	jne    8029d8 <alloc_block_NF+0x20>
  802ba4:	e9 d5 03 00 00       	jmp    802f7e <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802ba9:	a1 38 51 80 00       	mov    0x805138,%eax
  802bae:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bb1:	e9 b1 01 00 00       	jmp    802d67 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802bb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb9:	8b 50 08             	mov    0x8(%eax),%edx
  802bbc:	a1 28 50 80 00       	mov    0x805028,%eax
  802bc1:	39 c2                	cmp    %eax,%edx
  802bc3:	0f 82 96 01 00 00    	jb     802d5f <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802bc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bcc:	8b 40 0c             	mov    0xc(%eax),%eax
  802bcf:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bd2:	0f 82 87 01 00 00    	jb     802d5f <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802bd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bdb:	8b 40 0c             	mov    0xc(%eax),%eax
  802bde:	3b 45 08             	cmp    0x8(%ebp),%eax
  802be1:	0f 85 95 00 00 00    	jne    802c7c <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802be7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802beb:	75 17                	jne    802c04 <alloc_block_NF+0x24c>
  802bed:	83 ec 04             	sub    $0x4,%esp
  802bf0:	68 f8 45 80 00       	push   $0x8045f8
  802bf5:	68 fc 00 00 00       	push   $0xfc
  802bfa:	68 4f 45 80 00       	push   $0x80454f
  802bff:	e8 af da ff ff       	call   8006b3 <_panic>
  802c04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c07:	8b 00                	mov    (%eax),%eax
  802c09:	85 c0                	test   %eax,%eax
  802c0b:	74 10                	je     802c1d <alloc_block_NF+0x265>
  802c0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c10:	8b 00                	mov    (%eax),%eax
  802c12:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c15:	8b 52 04             	mov    0x4(%edx),%edx
  802c18:	89 50 04             	mov    %edx,0x4(%eax)
  802c1b:	eb 0b                	jmp    802c28 <alloc_block_NF+0x270>
  802c1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c20:	8b 40 04             	mov    0x4(%eax),%eax
  802c23:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c2b:	8b 40 04             	mov    0x4(%eax),%eax
  802c2e:	85 c0                	test   %eax,%eax
  802c30:	74 0f                	je     802c41 <alloc_block_NF+0x289>
  802c32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c35:	8b 40 04             	mov    0x4(%eax),%eax
  802c38:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c3b:	8b 12                	mov    (%edx),%edx
  802c3d:	89 10                	mov    %edx,(%eax)
  802c3f:	eb 0a                	jmp    802c4b <alloc_block_NF+0x293>
  802c41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c44:	8b 00                	mov    (%eax),%eax
  802c46:	a3 38 51 80 00       	mov    %eax,0x805138
  802c4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c57:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c5e:	a1 44 51 80 00       	mov    0x805144,%eax
  802c63:	48                   	dec    %eax
  802c64:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802c69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c6c:	8b 40 08             	mov    0x8(%eax),%eax
  802c6f:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802c74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c77:	e9 07 03 00 00       	jmp    802f83 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802c7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c7f:	8b 40 0c             	mov    0xc(%eax),%eax
  802c82:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c85:	0f 86 d4 00 00 00    	jbe    802d5f <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802c8b:	a1 48 51 80 00       	mov    0x805148,%eax
  802c90:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802c93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c96:	8b 50 08             	mov    0x8(%eax),%edx
  802c99:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c9c:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802c9f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ca2:	8b 55 08             	mov    0x8(%ebp),%edx
  802ca5:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802ca8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802cac:	75 17                	jne    802cc5 <alloc_block_NF+0x30d>
  802cae:	83 ec 04             	sub    $0x4,%esp
  802cb1:	68 f8 45 80 00       	push   $0x8045f8
  802cb6:	68 04 01 00 00       	push   $0x104
  802cbb:	68 4f 45 80 00       	push   $0x80454f
  802cc0:	e8 ee d9 ff ff       	call   8006b3 <_panic>
  802cc5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cc8:	8b 00                	mov    (%eax),%eax
  802cca:	85 c0                	test   %eax,%eax
  802ccc:	74 10                	je     802cde <alloc_block_NF+0x326>
  802cce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cd1:	8b 00                	mov    (%eax),%eax
  802cd3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802cd6:	8b 52 04             	mov    0x4(%edx),%edx
  802cd9:	89 50 04             	mov    %edx,0x4(%eax)
  802cdc:	eb 0b                	jmp    802ce9 <alloc_block_NF+0x331>
  802cde:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ce1:	8b 40 04             	mov    0x4(%eax),%eax
  802ce4:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ce9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cec:	8b 40 04             	mov    0x4(%eax),%eax
  802cef:	85 c0                	test   %eax,%eax
  802cf1:	74 0f                	je     802d02 <alloc_block_NF+0x34a>
  802cf3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cf6:	8b 40 04             	mov    0x4(%eax),%eax
  802cf9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802cfc:	8b 12                	mov    (%edx),%edx
  802cfe:	89 10                	mov    %edx,(%eax)
  802d00:	eb 0a                	jmp    802d0c <alloc_block_NF+0x354>
  802d02:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d05:	8b 00                	mov    (%eax),%eax
  802d07:	a3 48 51 80 00       	mov    %eax,0x805148
  802d0c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d0f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d15:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d18:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d1f:	a1 54 51 80 00       	mov    0x805154,%eax
  802d24:	48                   	dec    %eax
  802d25:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802d2a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d2d:	8b 40 08             	mov    0x8(%eax),%eax
  802d30:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802d35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d38:	8b 50 08             	mov    0x8(%eax),%edx
  802d3b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d3e:	01 c2                	add    %eax,%edx
  802d40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d43:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802d46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d49:	8b 40 0c             	mov    0xc(%eax),%eax
  802d4c:	2b 45 08             	sub    0x8(%ebp),%eax
  802d4f:	89 c2                	mov    %eax,%edx
  802d51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d54:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802d57:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d5a:	e9 24 02 00 00       	jmp    802f83 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802d5f:	a1 40 51 80 00       	mov    0x805140,%eax
  802d64:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d67:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d6b:	74 07                	je     802d74 <alloc_block_NF+0x3bc>
  802d6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d70:	8b 00                	mov    (%eax),%eax
  802d72:	eb 05                	jmp    802d79 <alloc_block_NF+0x3c1>
  802d74:	b8 00 00 00 00       	mov    $0x0,%eax
  802d79:	a3 40 51 80 00       	mov    %eax,0x805140
  802d7e:	a1 40 51 80 00       	mov    0x805140,%eax
  802d83:	85 c0                	test   %eax,%eax
  802d85:	0f 85 2b fe ff ff    	jne    802bb6 <alloc_block_NF+0x1fe>
  802d8b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d8f:	0f 85 21 fe ff ff    	jne    802bb6 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802d95:	a1 38 51 80 00       	mov    0x805138,%eax
  802d9a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d9d:	e9 ae 01 00 00       	jmp    802f50 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802da2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da5:	8b 50 08             	mov    0x8(%eax),%edx
  802da8:	a1 28 50 80 00       	mov    0x805028,%eax
  802dad:	39 c2                	cmp    %eax,%edx
  802daf:	0f 83 93 01 00 00    	jae    802f48 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802db5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db8:	8b 40 0c             	mov    0xc(%eax),%eax
  802dbb:	3b 45 08             	cmp    0x8(%ebp),%eax
  802dbe:	0f 82 84 01 00 00    	jb     802f48 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802dc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc7:	8b 40 0c             	mov    0xc(%eax),%eax
  802dca:	3b 45 08             	cmp    0x8(%ebp),%eax
  802dcd:	0f 85 95 00 00 00    	jne    802e68 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802dd3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dd7:	75 17                	jne    802df0 <alloc_block_NF+0x438>
  802dd9:	83 ec 04             	sub    $0x4,%esp
  802ddc:	68 f8 45 80 00       	push   $0x8045f8
  802de1:	68 14 01 00 00       	push   $0x114
  802de6:	68 4f 45 80 00       	push   $0x80454f
  802deb:	e8 c3 d8 ff ff       	call   8006b3 <_panic>
  802df0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df3:	8b 00                	mov    (%eax),%eax
  802df5:	85 c0                	test   %eax,%eax
  802df7:	74 10                	je     802e09 <alloc_block_NF+0x451>
  802df9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dfc:	8b 00                	mov    (%eax),%eax
  802dfe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e01:	8b 52 04             	mov    0x4(%edx),%edx
  802e04:	89 50 04             	mov    %edx,0x4(%eax)
  802e07:	eb 0b                	jmp    802e14 <alloc_block_NF+0x45c>
  802e09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e0c:	8b 40 04             	mov    0x4(%eax),%eax
  802e0f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e17:	8b 40 04             	mov    0x4(%eax),%eax
  802e1a:	85 c0                	test   %eax,%eax
  802e1c:	74 0f                	je     802e2d <alloc_block_NF+0x475>
  802e1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e21:	8b 40 04             	mov    0x4(%eax),%eax
  802e24:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e27:	8b 12                	mov    (%edx),%edx
  802e29:	89 10                	mov    %edx,(%eax)
  802e2b:	eb 0a                	jmp    802e37 <alloc_block_NF+0x47f>
  802e2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e30:	8b 00                	mov    (%eax),%eax
  802e32:	a3 38 51 80 00       	mov    %eax,0x805138
  802e37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e3a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e43:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e4a:	a1 44 51 80 00       	mov    0x805144,%eax
  802e4f:	48                   	dec    %eax
  802e50:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802e55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e58:	8b 40 08             	mov    0x8(%eax),%eax
  802e5b:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802e60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e63:	e9 1b 01 00 00       	jmp    802f83 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802e68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e6b:	8b 40 0c             	mov    0xc(%eax),%eax
  802e6e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e71:	0f 86 d1 00 00 00    	jbe    802f48 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802e77:	a1 48 51 80 00       	mov    0x805148,%eax
  802e7c:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802e7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e82:	8b 50 08             	mov    0x8(%eax),%edx
  802e85:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e88:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802e8b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e8e:	8b 55 08             	mov    0x8(%ebp),%edx
  802e91:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802e94:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802e98:	75 17                	jne    802eb1 <alloc_block_NF+0x4f9>
  802e9a:	83 ec 04             	sub    $0x4,%esp
  802e9d:	68 f8 45 80 00       	push   $0x8045f8
  802ea2:	68 1c 01 00 00       	push   $0x11c
  802ea7:	68 4f 45 80 00       	push   $0x80454f
  802eac:	e8 02 d8 ff ff       	call   8006b3 <_panic>
  802eb1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802eb4:	8b 00                	mov    (%eax),%eax
  802eb6:	85 c0                	test   %eax,%eax
  802eb8:	74 10                	je     802eca <alloc_block_NF+0x512>
  802eba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ebd:	8b 00                	mov    (%eax),%eax
  802ebf:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ec2:	8b 52 04             	mov    0x4(%edx),%edx
  802ec5:	89 50 04             	mov    %edx,0x4(%eax)
  802ec8:	eb 0b                	jmp    802ed5 <alloc_block_NF+0x51d>
  802eca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ecd:	8b 40 04             	mov    0x4(%eax),%eax
  802ed0:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ed5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ed8:	8b 40 04             	mov    0x4(%eax),%eax
  802edb:	85 c0                	test   %eax,%eax
  802edd:	74 0f                	je     802eee <alloc_block_NF+0x536>
  802edf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ee2:	8b 40 04             	mov    0x4(%eax),%eax
  802ee5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ee8:	8b 12                	mov    (%edx),%edx
  802eea:	89 10                	mov    %edx,(%eax)
  802eec:	eb 0a                	jmp    802ef8 <alloc_block_NF+0x540>
  802eee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ef1:	8b 00                	mov    (%eax),%eax
  802ef3:	a3 48 51 80 00       	mov    %eax,0x805148
  802ef8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802efb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f01:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f04:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f0b:	a1 54 51 80 00       	mov    0x805154,%eax
  802f10:	48                   	dec    %eax
  802f11:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802f16:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f19:	8b 40 08             	mov    0x8(%eax),%eax
  802f1c:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802f21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f24:	8b 50 08             	mov    0x8(%eax),%edx
  802f27:	8b 45 08             	mov    0x8(%ebp),%eax
  802f2a:	01 c2                	add    %eax,%edx
  802f2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f2f:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802f32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f35:	8b 40 0c             	mov    0xc(%eax),%eax
  802f38:	2b 45 08             	sub    0x8(%ebp),%eax
  802f3b:	89 c2                	mov    %eax,%edx
  802f3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f40:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802f43:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f46:	eb 3b                	jmp    802f83 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802f48:	a1 40 51 80 00       	mov    0x805140,%eax
  802f4d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f50:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f54:	74 07                	je     802f5d <alloc_block_NF+0x5a5>
  802f56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f59:	8b 00                	mov    (%eax),%eax
  802f5b:	eb 05                	jmp    802f62 <alloc_block_NF+0x5aa>
  802f5d:	b8 00 00 00 00       	mov    $0x0,%eax
  802f62:	a3 40 51 80 00       	mov    %eax,0x805140
  802f67:	a1 40 51 80 00       	mov    0x805140,%eax
  802f6c:	85 c0                	test   %eax,%eax
  802f6e:	0f 85 2e fe ff ff    	jne    802da2 <alloc_block_NF+0x3ea>
  802f74:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f78:	0f 85 24 fe ff ff    	jne    802da2 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802f7e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f83:	c9                   	leave  
  802f84:	c3                   	ret    

00802f85 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802f85:	55                   	push   %ebp
  802f86:	89 e5                	mov    %esp,%ebp
  802f88:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802f8b:	a1 38 51 80 00       	mov    0x805138,%eax
  802f90:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802f93:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802f98:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802f9b:	a1 38 51 80 00       	mov    0x805138,%eax
  802fa0:	85 c0                	test   %eax,%eax
  802fa2:	74 14                	je     802fb8 <insert_sorted_with_merge_freeList+0x33>
  802fa4:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa7:	8b 50 08             	mov    0x8(%eax),%edx
  802faa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fad:	8b 40 08             	mov    0x8(%eax),%eax
  802fb0:	39 c2                	cmp    %eax,%edx
  802fb2:	0f 87 9b 01 00 00    	ja     803153 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802fb8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fbc:	75 17                	jne    802fd5 <insert_sorted_with_merge_freeList+0x50>
  802fbe:	83 ec 04             	sub    $0x4,%esp
  802fc1:	68 2c 45 80 00       	push   $0x80452c
  802fc6:	68 38 01 00 00       	push   $0x138
  802fcb:	68 4f 45 80 00       	push   $0x80454f
  802fd0:	e8 de d6 ff ff       	call   8006b3 <_panic>
  802fd5:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802fdb:	8b 45 08             	mov    0x8(%ebp),%eax
  802fde:	89 10                	mov    %edx,(%eax)
  802fe0:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe3:	8b 00                	mov    (%eax),%eax
  802fe5:	85 c0                	test   %eax,%eax
  802fe7:	74 0d                	je     802ff6 <insert_sorted_with_merge_freeList+0x71>
  802fe9:	a1 38 51 80 00       	mov    0x805138,%eax
  802fee:	8b 55 08             	mov    0x8(%ebp),%edx
  802ff1:	89 50 04             	mov    %edx,0x4(%eax)
  802ff4:	eb 08                	jmp    802ffe <insert_sorted_with_merge_freeList+0x79>
  802ff6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff9:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ffe:	8b 45 08             	mov    0x8(%ebp),%eax
  803001:	a3 38 51 80 00       	mov    %eax,0x805138
  803006:	8b 45 08             	mov    0x8(%ebp),%eax
  803009:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803010:	a1 44 51 80 00       	mov    0x805144,%eax
  803015:	40                   	inc    %eax
  803016:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80301b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80301f:	0f 84 a8 06 00 00    	je     8036cd <insert_sorted_with_merge_freeList+0x748>
  803025:	8b 45 08             	mov    0x8(%ebp),%eax
  803028:	8b 50 08             	mov    0x8(%eax),%edx
  80302b:	8b 45 08             	mov    0x8(%ebp),%eax
  80302e:	8b 40 0c             	mov    0xc(%eax),%eax
  803031:	01 c2                	add    %eax,%edx
  803033:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803036:	8b 40 08             	mov    0x8(%eax),%eax
  803039:	39 c2                	cmp    %eax,%edx
  80303b:	0f 85 8c 06 00 00    	jne    8036cd <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  803041:	8b 45 08             	mov    0x8(%ebp),%eax
  803044:	8b 50 0c             	mov    0xc(%eax),%edx
  803047:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80304a:	8b 40 0c             	mov    0xc(%eax),%eax
  80304d:	01 c2                	add    %eax,%edx
  80304f:	8b 45 08             	mov    0x8(%ebp),%eax
  803052:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  803055:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803059:	75 17                	jne    803072 <insert_sorted_with_merge_freeList+0xed>
  80305b:	83 ec 04             	sub    $0x4,%esp
  80305e:	68 f8 45 80 00       	push   $0x8045f8
  803063:	68 3c 01 00 00       	push   $0x13c
  803068:	68 4f 45 80 00       	push   $0x80454f
  80306d:	e8 41 d6 ff ff       	call   8006b3 <_panic>
  803072:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803075:	8b 00                	mov    (%eax),%eax
  803077:	85 c0                	test   %eax,%eax
  803079:	74 10                	je     80308b <insert_sorted_with_merge_freeList+0x106>
  80307b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80307e:	8b 00                	mov    (%eax),%eax
  803080:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803083:	8b 52 04             	mov    0x4(%edx),%edx
  803086:	89 50 04             	mov    %edx,0x4(%eax)
  803089:	eb 0b                	jmp    803096 <insert_sorted_with_merge_freeList+0x111>
  80308b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80308e:	8b 40 04             	mov    0x4(%eax),%eax
  803091:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803096:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803099:	8b 40 04             	mov    0x4(%eax),%eax
  80309c:	85 c0                	test   %eax,%eax
  80309e:	74 0f                	je     8030af <insert_sorted_with_merge_freeList+0x12a>
  8030a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030a3:	8b 40 04             	mov    0x4(%eax),%eax
  8030a6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8030a9:	8b 12                	mov    (%edx),%edx
  8030ab:	89 10                	mov    %edx,(%eax)
  8030ad:	eb 0a                	jmp    8030b9 <insert_sorted_with_merge_freeList+0x134>
  8030af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030b2:	8b 00                	mov    (%eax),%eax
  8030b4:	a3 38 51 80 00       	mov    %eax,0x805138
  8030b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030bc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030c5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030cc:	a1 44 51 80 00       	mov    0x805144,%eax
  8030d1:	48                   	dec    %eax
  8030d2:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  8030d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030da:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  8030e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030e4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  8030eb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8030ef:	75 17                	jne    803108 <insert_sorted_with_merge_freeList+0x183>
  8030f1:	83 ec 04             	sub    $0x4,%esp
  8030f4:	68 2c 45 80 00       	push   $0x80452c
  8030f9:	68 3f 01 00 00       	push   $0x13f
  8030fe:	68 4f 45 80 00       	push   $0x80454f
  803103:	e8 ab d5 ff ff       	call   8006b3 <_panic>
  803108:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80310e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803111:	89 10                	mov    %edx,(%eax)
  803113:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803116:	8b 00                	mov    (%eax),%eax
  803118:	85 c0                	test   %eax,%eax
  80311a:	74 0d                	je     803129 <insert_sorted_with_merge_freeList+0x1a4>
  80311c:	a1 48 51 80 00       	mov    0x805148,%eax
  803121:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803124:	89 50 04             	mov    %edx,0x4(%eax)
  803127:	eb 08                	jmp    803131 <insert_sorted_with_merge_freeList+0x1ac>
  803129:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80312c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803131:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803134:	a3 48 51 80 00       	mov    %eax,0x805148
  803139:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80313c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803143:	a1 54 51 80 00       	mov    0x805154,%eax
  803148:	40                   	inc    %eax
  803149:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80314e:	e9 7a 05 00 00       	jmp    8036cd <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  803153:	8b 45 08             	mov    0x8(%ebp),%eax
  803156:	8b 50 08             	mov    0x8(%eax),%edx
  803159:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80315c:	8b 40 08             	mov    0x8(%eax),%eax
  80315f:	39 c2                	cmp    %eax,%edx
  803161:	0f 82 14 01 00 00    	jb     80327b <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  803167:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80316a:	8b 50 08             	mov    0x8(%eax),%edx
  80316d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803170:	8b 40 0c             	mov    0xc(%eax),%eax
  803173:	01 c2                	add    %eax,%edx
  803175:	8b 45 08             	mov    0x8(%ebp),%eax
  803178:	8b 40 08             	mov    0x8(%eax),%eax
  80317b:	39 c2                	cmp    %eax,%edx
  80317d:	0f 85 90 00 00 00    	jne    803213 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  803183:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803186:	8b 50 0c             	mov    0xc(%eax),%edx
  803189:	8b 45 08             	mov    0x8(%ebp),%eax
  80318c:	8b 40 0c             	mov    0xc(%eax),%eax
  80318f:	01 c2                	add    %eax,%edx
  803191:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803194:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  803197:	8b 45 08             	mov    0x8(%ebp),%eax
  80319a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  8031a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8031ab:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031af:	75 17                	jne    8031c8 <insert_sorted_with_merge_freeList+0x243>
  8031b1:	83 ec 04             	sub    $0x4,%esp
  8031b4:	68 2c 45 80 00       	push   $0x80452c
  8031b9:	68 49 01 00 00       	push   $0x149
  8031be:	68 4f 45 80 00       	push   $0x80454f
  8031c3:	e8 eb d4 ff ff       	call   8006b3 <_panic>
  8031c8:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8031ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d1:	89 10                	mov    %edx,(%eax)
  8031d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d6:	8b 00                	mov    (%eax),%eax
  8031d8:	85 c0                	test   %eax,%eax
  8031da:	74 0d                	je     8031e9 <insert_sorted_with_merge_freeList+0x264>
  8031dc:	a1 48 51 80 00       	mov    0x805148,%eax
  8031e1:	8b 55 08             	mov    0x8(%ebp),%edx
  8031e4:	89 50 04             	mov    %edx,0x4(%eax)
  8031e7:	eb 08                	jmp    8031f1 <insert_sorted_with_merge_freeList+0x26c>
  8031e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ec:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8031f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f4:	a3 48 51 80 00       	mov    %eax,0x805148
  8031f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8031fc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803203:	a1 54 51 80 00       	mov    0x805154,%eax
  803208:	40                   	inc    %eax
  803209:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80320e:	e9 bb 04 00 00       	jmp    8036ce <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  803213:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803217:	75 17                	jne    803230 <insert_sorted_with_merge_freeList+0x2ab>
  803219:	83 ec 04             	sub    $0x4,%esp
  80321c:	68 a0 45 80 00       	push   $0x8045a0
  803221:	68 4c 01 00 00       	push   $0x14c
  803226:	68 4f 45 80 00       	push   $0x80454f
  80322b:	e8 83 d4 ff ff       	call   8006b3 <_panic>
  803230:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803236:	8b 45 08             	mov    0x8(%ebp),%eax
  803239:	89 50 04             	mov    %edx,0x4(%eax)
  80323c:	8b 45 08             	mov    0x8(%ebp),%eax
  80323f:	8b 40 04             	mov    0x4(%eax),%eax
  803242:	85 c0                	test   %eax,%eax
  803244:	74 0c                	je     803252 <insert_sorted_with_merge_freeList+0x2cd>
  803246:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80324b:	8b 55 08             	mov    0x8(%ebp),%edx
  80324e:	89 10                	mov    %edx,(%eax)
  803250:	eb 08                	jmp    80325a <insert_sorted_with_merge_freeList+0x2d5>
  803252:	8b 45 08             	mov    0x8(%ebp),%eax
  803255:	a3 38 51 80 00       	mov    %eax,0x805138
  80325a:	8b 45 08             	mov    0x8(%ebp),%eax
  80325d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803262:	8b 45 08             	mov    0x8(%ebp),%eax
  803265:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80326b:	a1 44 51 80 00       	mov    0x805144,%eax
  803270:	40                   	inc    %eax
  803271:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803276:	e9 53 04 00 00       	jmp    8036ce <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  80327b:	a1 38 51 80 00       	mov    0x805138,%eax
  803280:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803283:	e9 15 04 00 00       	jmp    80369d <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  803288:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80328b:	8b 00                	mov    (%eax),%eax
  80328d:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  803290:	8b 45 08             	mov    0x8(%ebp),%eax
  803293:	8b 50 08             	mov    0x8(%eax),%edx
  803296:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803299:	8b 40 08             	mov    0x8(%eax),%eax
  80329c:	39 c2                	cmp    %eax,%edx
  80329e:	0f 86 f1 03 00 00    	jbe    803695 <insert_sorted_with_merge_freeList+0x710>
  8032a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a7:	8b 50 08             	mov    0x8(%eax),%edx
  8032aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032ad:	8b 40 08             	mov    0x8(%eax),%eax
  8032b0:	39 c2                	cmp    %eax,%edx
  8032b2:	0f 83 dd 03 00 00    	jae    803695 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  8032b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032bb:	8b 50 08             	mov    0x8(%eax),%edx
  8032be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032c1:	8b 40 0c             	mov    0xc(%eax),%eax
  8032c4:	01 c2                	add    %eax,%edx
  8032c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c9:	8b 40 08             	mov    0x8(%eax),%eax
  8032cc:	39 c2                	cmp    %eax,%edx
  8032ce:	0f 85 b9 01 00 00    	jne    80348d <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8032d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d7:	8b 50 08             	mov    0x8(%eax),%edx
  8032da:	8b 45 08             	mov    0x8(%ebp),%eax
  8032dd:	8b 40 0c             	mov    0xc(%eax),%eax
  8032e0:	01 c2                	add    %eax,%edx
  8032e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032e5:	8b 40 08             	mov    0x8(%eax),%eax
  8032e8:	39 c2                	cmp    %eax,%edx
  8032ea:	0f 85 0d 01 00 00    	jne    8033fd <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  8032f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032f3:	8b 50 0c             	mov    0xc(%eax),%edx
  8032f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032f9:	8b 40 0c             	mov    0xc(%eax),%eax
  8032fc:	01 c2                	add    %eax,%edx
  8032fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803301:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803304:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803308:	75 17                	jne    803321 <insert_sorted_with_merge_freeList+0x39c>
  80330a:	83 ec 04             	sub    $0x4,%esp
  80330d:	68 f8 45 80 00       	push   $0x8045f8
  803312:	68 5c 01 00 00       	push   $0x15c
  803317:	68 4f 45 80 00       	push   $0x80454f
  80331c:	e8 92 d3 ff ff       	call   8006b3 <_panic>
  803321:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803324:	8b 00                	mov    (%eax),%eax
  803326:	85 c0                	test   %eax,%eax
  803328:	74 10                	je     80333a <insert_sorted_with_merge_freeList+0x3b5>
  80332a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80332d:	8b 00                	mov    (%eax),%eax
  80332f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803332:	8b 52 04             	mov    0x4(%edx),%edx
  803335:	89 50 04             	mov    %edx,0x4(%eax)
  803338:	eb 0b                	jmp    803345 <insert_sorted_with_merge_freeList+0x3c0>
  80333a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80333d:	8b 40 04             	mov    0x4(%eax),%eax
  803340:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803345:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803348:	8b 40 04             	mov    0x4(%eax),%eax
  80334b:	85 c0                	test   %eax,%eax
  80334d:	74 0f                	je     80335e <insert_sorted_with_merge_freeList+0x3d9>
  80334f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803352:	8b 40 04             	mov    0x4(%eax),%eax
  803355:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803358:	8b 12                	mov    (%edx),%edx
  80335a:	89 10                	mov    %edx,(%eax)
  80335c:	eb 0a                	jmp    803368 <insert_sorted_with_merge_freeList+0x3e3>
  80335e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803361:	8b 00                	mov    (%eax),%eax
  803363:	a3 38 51 80 00       	mov    %eax,0x805138
  803368:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80336b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803371:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803374:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80337b:	a1 44 51 80 00       	mov    0x805144,%eax
  803380:	48                   	dec    %eax
  803381:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  803386:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803389:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803390:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803393:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80339a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80339e:	75 17                	jne    8033b7 <insert_sorted_with_merge_freeList+0x432>
  8033a0:	83 ec 04             	sub    $0x4,%esp
  8033a3:	68 2c 45 80 00       	push   $0x80452c
  8033a8:	68 5f 01 00 00       	push   $0x15f
  8033ad:	68 4f 45 80 00       	push   $0x80454f
  8033b2:	e8 fc d2 ff ff       	call   8006b3 <_panic>
  8033b7:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8033bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033c0:	89 10                	mov    %edx,(%eax)
  8033c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033c5:	8b 00                	mov    (%eax),%eax
  8033c7:	85 c0                	test   %eax,%eax
  8033c9:	74 0d                	je     8033d8 <insert_sorted_with_merge_freeList+0x453>
  8033cb:	a1 48 51 80 00       	mov    0x805148,%eax
  8033d0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8033d3:	89 50 04             	mov    %edx,0x4(%eax)
  8033d6:	eb 08                	jmp    8033e0 <insert_sorted_with_merge_freeList+0x45b>
  8033d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033db:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8033e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033e3:	a3 48 51 80 00       	mov    %eax,0x805148
  8033e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033eb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033f2:	a1 54 51 80 00       	mov    0x805154,%eax
  8033f7:	40                   	inc    %eax
  8033f8:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  8033fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803400:	8b 50 0c             	mov    0xc(%eax),%edx
  803403:	8b 45 08             	mov    0x8(%ebp),%eax
  803406:	8b 40 0c             	mov    0xc(%eax),%eax
  803409:	01 c2                	add    %eax,%edx
  80340b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80340e:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803411:	8b 45 08             	mov    0x8(%ebp),%eax
  803414:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  80341b:	8b 45 08             	mov    0x8(%ebp),%eax
  80341e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803425:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803429:	75 17                	jne    803442 <insert_sorted_with_merge_freeList+0x4bd>
  80342b:	83 ec 04             	sub    $0x4,%esp
  80342e:	68 2c 45 80 00       	push   $0x80452c
  803433:	68 64 01 00 00       	push   $0x164
  803438:	68 4f 45 80 00       	push   $0x80454f
  80343d:	e8 71 d2 ff ff       	call   8006b3 <_panic>
  803442:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803448:	8b 45 08             	mov    0x8(%ebp),%eax
  80344b:	89 10                	mov    %edx,(%eax)
  80344d:	8b 45 08             	mov    0x8(%ebp),%eax
  803450:	8b 00                	mov    (%eax),%eax
  803452:	85 c0                	test   %eax,%eax
  803454:	74 0d                	je     803463 <insert_sorted_with_merge_freeList+0x4de>
  803456:	a1 48 51 80 00       	mov    0x805148,%eax
  80345b:	8b 55 08             	mov    0x8(%ebp),%edx
  80345e:	89 50 04             	mov    %edx,0x4(%eax)
  803461:	eb 08                	jmp    80346b <insert_sorted_with_merge_freeList+0x4e6>
  803463:	8b 45 08             	mov    0x8(%ebp),%eax
  803466:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80346b:	8b 45 08             	mov    0x8(%ebp),%eax
  80346e:	a3 48 51 80 00       	mov    %eax,0x805148
  803473:	8b 45 08             	mov    0x8(%ebp),%eax
  803476:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80347d:	a1 54 51 80 00       	mov    0x805154,%eax
  803482:	40                   	inc    %eax
  803483:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803488:	e9 41 02 00 00       	jmp    8036ce <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  80348d:	8b 45 08             	mov    0x8(%ebp),%eax
  803490:	8b 50 08             	mov    0x8(%eax),%edx
  803493:	8b 45 08             	mov    0x8(%ebp),%eax
  803496:	8b 40 0c             	mov    0xc(%eax),%eax
  803499:	01 c2                	add    %eax,%edx
  80349b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80349e:	8b 40 08             	mov    0x8(%eax),%eax
  8034a1:	39 c2                	cmp    %eax,%edx
  8034a3:	0f 85 7c 01 00 00    	jne    803625 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  8034a9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8034ad:	74 06                	je     8034b5 <insert_sorted_with_merge_freeList+0x530>
  8034af:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034b3:	75 17                	jne    8034cc <insert_sorted_with_merge_freeList+0x547>
  8034b5:	83 ec 04             	sub    $0x4,%esp
  8034b8:	68 68 45 80 00       	push   $0x804568
  8034bd:	68 69 01 00 00       	push   $0x169
  8034c2:	68 4f 45 80 00       	push   $0x80454f
  8034c7:	e8 e7 d1 ff ff       	call   8006b3 <_panic>
  8034cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034cf:	8b 50 04             	mov    0x4(%eax),%edx
  8034d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8034d5:	89 50 04             	mov    %edx,0x4(%eax)
  8034d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8034db:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8034de:	89 10                	mov    %edx,(%eax)
  8034e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034e3:	8b 40 04             	mov    0x4(%eax),%eax
  8034e6:	85 c0                	test   %eax,%eax
  8034e8:	74 0d                	je     8034f7 <insert_sorted_with_merge_freeList+0x572>
  8034ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034ed:	8b 40 04             	mov    0x4(%eax),%eax
  8034f0:	8b 55 08             	mov    0x8(%ebp),%edx
  8034f3:	89 10                	mov    %edx,(%eax)
  8034f5:	eb 08                	jmp    8034ff <insert_sorted_with_merge_freeList+0x57a>
  8034f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8034fa:	a3 38 51 80 00       	mov    %eax,0x805138
  8034ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803502:	8b 55 08             	mov    0x8(%ebp),%edx
  803505:	89 50 04             	mov    %edx,0x4(%eax)
  803508:	a1 44 51 80 00       	mov    0x805144,%eax
  80350d:	40                   	inc    %eax
  80350e:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803513:	8b 45 08             	mov    0x8(%ebp),%eax
  803516:	8b 50 0c             	mov    0xc(%eax),%edx
  803519:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80351c:	8b 40 0c             	mov    0xc(%eax),%eax
  80351f:	01 c2                	add    %eax,%edx
  803521:	8b 45 08             	mov    0x8(%ebp),%eax
  803524:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803527:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80352b:	75 17                	jne    803544 <insert_sorted_with_merge_freeList+0x5bf>
  80352d:	83 ec 04             	sub    $0x4,%esp
  803530:	68 f8 45 80 00       	push   $0x8045f8
  803535:	68 6b 01 00 00       	push   $0x16b
  80353a:	68 4f 45 80 00       	push   $0x80454f
  80353f:	e8 6f d1 ff ff       	call   8006b3 <_panic>
  803544:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803547:	8b 00                	mov    (%eax),%eax
  803549:	85 c0                	test   %eax,%eax
  80354b:	74 10                	je     80355d <insert_sorted_with_merge_freeList+0x5d8>
  80354d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803550:	8b 00                	mov    (%eax),%eax
  803552:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803555:	8b 52 04             	mov    0x4(%edx),%edx
  803558:	89 50 04             	mov    %edx,0x4(%eax)
  80355b:	eb 0b                	jmp    803568 <insert_sorted_with_merge_freeList+0x5e3>
  80355d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803560:	8b 40 04             	mov    0x4(%eax),%eax
  803563:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803568:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80356b:	8b 40 04             	mov    0x4(%eax),%eax
  80356e:	85 c0                	test   %eax,%eax
  803570:	74 0f                	je     803581 <insert_sorted_with_merge_freeList+0x5fc>
  803572:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803575:	8b 40 04             	mov    0x4(%eax),%eax
  803578:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80357b:	8b 12                	mov    (%edx),%edx
  80357d:	89 10                	mov    %edx,(%eax)
  80357f:	eb 0a                	jmp    80358b <insert_sorted_with_merge_freeList+0x606>
  803581:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803584:	8b 00                	mov    (%eax),%eax
  803586:	a3 38 51 80 00       	mov    %eax,0x805138
  80358b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80358e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803594:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803597:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80359e:	a1 44 51 80 00       	mov    0x805144,%eax
  8035a3:	48                   	dec    %eax
  8035a4:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  8035a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035ac:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  8035b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035b6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8035bd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8035c1:	75 17                	jne    8035da <insert_sorted_with_merge_freeList+0x655>
  8035c3:	83 ec 04             	sub    $0x4,%esp
  8035c6:	68 2c 45 80 00       	push   $0x80452c
  8035cb:	68 6e 01 00 00       	push   $0x16e
  8035d0:	68 4f 45 80 00       	push   $0x80454f
  8035d5:	e8 d9 d0 ff ff       	call   8006b3 <_panic>
  8035da:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8035e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035e3:	89 10                	mov    %edx,(%eax)
  8035e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035e8:	8b 00                	mov    (%eax),%eax
  8035ea:	85 c0                	test   %eax,%eax
  8035ec:	74 0d                	je     8035fb <insert_sorted_with_merge_freeList+0x676>
  8035ee:	a1 48 51 80 00       	mov    0x805148,%eax
  8035f3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8035f6:	89 50 04             	mov    %edx,0x4(%eax)
  8035f9:	eb 08                	jmp    803603 <insert_sorted_with_merge_freeList+0x67e>
  8035fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035fe:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803603:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803606:	a3 48 51 80 00       	mov    %eax,0x805148
  80360b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80360e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803615:	a1 54 51 80 00       	mov    0x805154,%eax
  80361a:	40                   	inc    %eax
  80361b:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803620:	e9 a9 00 00 00       	jmp    8036ce <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803625:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803629:	74 06                	je     803631 <insert_sorted_with_merge_freeList+0x6ac>
  80362b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80362f:	75 17                	jne    803648 <insert_sorted_with_merge_freeList+0x6c3>
  803631:	83 ec 04             	sub    $0x4,%esp
  803634:	68 c4 45 80 00       	push   $0x8045c4
  803639:	68 73 01 00 00       	push   $0x173
  80363e:	68 4f 45 80 00       	push   $0x80454f
  803643:	e8 6b d0 ff ff       	call   8006b3 <_panic>
  803648:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80364b:	8b 10                	mov    (%eax),%edx
  80364d:	8b 45 08             	mov    0x8(%ebp),%eax
  803650:	89 10                	mov    %edx,(%eax)
  803652:	8b 45 08             	mov    0x8(%ebp),%eax
  803655:	8b 00                	mov    (%eax),%eax
  803657:	85 c0                	test   %eax,%eax
  803659:	74 0b                	je     803666 <insert_sorted_with_merge_freeList+0x6e1>
  80365b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80365e:	8b 00                	mov    (%eax),%eax
  803660:	8b 55 08             	mov    0x8(%ebp),%edx
  803663:	89 50 04             	mov    %edx,0x4(%eax)
  803666:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803669:	8b 55 08             	mov    0x8(%ebp),%edx
  80366c:	89 10                	mov    %edx,(%eax)
  80366e:	8b 45 08             	mov    0x8(%ebp),%eax
  803671:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803674:	89 50 04             	mov    %edx,0x4(%eax)
  803677:	8b 45 08             	mov    0x8(%ebp),%eax
  80367a:	8b 00                	mov    (%eax),%eax
  80367c:	85 c0                	test   %eax,%eax
  80367e:	75 08                	jne    803688 <insert_sorted_with_merge_freeList+0x703>
  803680:	8b 45 08             	mov    0x8(%ebp),%eax
  803683:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803688:	a1 44 51 80 00       	mov    0x805144,%eax
  80368d:	40                   	inc    %eax
  80368e:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803693:	eb 39                	jmp    8036ce <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803695:	a1 40 51 80 00       	mov    0x805140,%eax
  80369a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80369d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036a1:	74 07                	je     8036aa <insert_sorted_with_merge_freeList+0x725>
  8036a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036a6:	8b 00                	mov    (%eax),%eax
  8036a8:	eb 05                	jmp    8036af <insert_sorted_with_merge_freeList+0x72a>
  8036aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8036af:	a3 40 51 80 00       	mov    %eax,0x805140
  8036b4:	a1 40 51 80 00       	mov    0x805140,%eax
  8036b9:	85 c0                	test   %eax,%eax
  8036bb:	0f 85 c7 fb ff ff    	jne    803288 <insert_sorted_with_merge_freeList+0x303>
  8036c1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036c5:	0f 85 bd fb ff ff    	jne    803288 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8036cb:	eb 01                	jmp    8036ce <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8036cd:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8036ce:	90                   	nop
  8036cf:	c9                   	leave  
  8036d0:	c3                   	ret    
  8036d1:	66 90                	xchg   %ax,%ax
  8036d3:	90                   	nop

008036d4 <__udivdi3>:
  8036d4:	55                   	push   %ebp
  8036d5:	57                   	push   %edi
  8036d6:	56                   	push   %esi
  8036d7:	53                   	push   %ebx
  8036d8:	83 ec 1c             	sub    $0x1c,%esp
  8036db:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8036df:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8036e3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8036e7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8036eb:	89 ca                	mov    %ecx,%edx
  8036ed:	89 f8                	mov    %edi,%eax
  8036ef:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8036f3:	85 f6                	test   %esi,%esi
  8036f5:	75 2d                	jne    803724 <__udivdi3+0x50>
  8036f7:	39 cf                	cmp    %ecx,%edi
  8036f9:	77 65                	ja     803760 <__udivdi3+0x8c>
  8036fb:	89 fd                	mov    %edi,%ebp
  8036fd:	85 ff                	test   %edi,%edi
  8036ff:	75 0b                	jne    80370c <__udivdi3+0x38>
  803701:	b8 01 00 00 00       	mov    $0x1,%eax
  803706:	31 d2                	xor    %edx,%edx
  803708:	f7 f7                	div    %edi
  80370a:	89 c5                	mov    %eax,%ebp
  80370c:	31 d2                	xor    %edx,%edx
  80370e:	89 c8                	mov    %ecx,%eax
  803710:	f7 f5                	div    %ebp
  803712:	89 c1                	mov    %eax,%ecx
  803714:	89 d8                	mov    %ebx,%eax
  803716:	f7 f5                	div    %ebp
  803718:	89 cf                	mov    %ecx,%edi
  80371a:	89 fa                	mov    %edi,%edx
  80371c:	83 c4 1c             	add    $0x1c,%esp
  80371f:	5b                   	pop    %ebx
  803720:	5e                   	pop    %esi
  803721:	5f                   	pop    %edi
  803722:	5d                   	pop    %ebp
  803723:	c3                   	ret    
  803724:	39 ce                	cmp    %ecx,%esi
  803726:	77 28                	ja     803750 <__udivdi3+0x7c>
  803728:	0f bd fe             	bsr    %esi,%edi
  80372b:	83 f7 1f             	xor    $0x1f,%edi
  80372e:	75 40                	jne    803770 <__udivdi3+0x9c>
  803730:	39 ce                	cmp    %ecx,%esi
  803732:	72 0a                	jb     80373e <__udivdi3+0x6a>
  803734:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803738:	0f 87 9e 00 00 00    	ja     8037dc <__udivdi3+0x108>
  80373e:	b8 01 00 00 00       	mov    $0x1,%eax
  803743:	89 fa                	mov    %edi,%edx
  803745:	83 c4 1c             	add    $0x1c,%esp
  803748:	5b                   	pop    %ebx
  803749:	5e                   	pop    %esi
  80374a:	5f                   	pop    %edi
  80374b:	5d                   	pop    %ebp
  80374c:	c3                   	ret    
  80374d:	8d 76 00             	lea    0x0(%esi),%esi
  803750:	31 ff                	xor    %edi,%edi
  803752:	31 c0                	xor    %eax,%eax
  803754:	89 fa                	mov    %edi,%edx
  803756:	83 c4 1c             	add    $0x1c,%esp
  803759:	5b                   	pop    %ebx
  80375a:	5e                   	pop    %esi
  80375b:	5f                   	pop    %edi
  80375c:	5d                   	pop    %ebp
  80375d:	c3                   	ret    
  80375e:	66 90                	xchg   %ax,%ax
  803760:	89 d8                	mov    %ebx,%eax
  803762:	f7 f7                	div    %edi
  803764:	31 ff                	xor    %edi,%edi
  803766:	89 fa                	mov    %edi,%edx
  803768:	83 c4 1c             	add    $0x1c,%esp
  80376b:	5b                   	pop    %ebx
  80376c:	5e                   	pop    %esi
  80376d:	5f                   	pop    %edi
  80376e:	5d                   	pop    %ebp
  80376f:	c3                   	ret    
  803770:	bd 20 00 00 00       	mov    $0x20,%ebp
  803775:	89 eb                	mov    %ebp,%ebx
  803777:	29 fb                	sub    %edi,%ebx
  803779:	89 f9                	mov    %edi,%ecx
  80377b:	d3 e6                	shl    %cl,%esi
  80377d:	89 c5                	mov    %eax,%ebp
  80377f:	88 d9                	mov    %bl,%cl
  803781:	d3 ed                	shr    %cl,%ebp
  803783:	89 e9                	mov    %ebp,%ecx
  803785:	09 f1                	or     %esi,%ecx
  803787:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80378b:	89 f9                	mov    %edi,%ecx
  80378d:	d3 e0                	shl    %cl,%eax
  80378f:	89 c5                	mov    %eax,%ebp
  803791:	89 d6                	mov    %edx,%esi
  803793:	88 d9                	mov    %bl,%cl
  803795:	d3 ee                	shr    %cl,%esi
  803797:	89 f9                	mov    %edi,%ecx
  803799:	d3 e2                	shl    %cl,%edx
  80379b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80379f:	88 d9                	mov    %bl,%cl
  8037a1:	d3 e8                	shr    %cl,%eax
  8037a3:	09 c2                	or     %eax,%edx
  8037a5:	89 d0                	mov    %edx,%eax
  8037a7:	89 f2                	mov    %esi,%edx
  8037a9:	f7 74 24 0c          	divl   0xc(%esp)
  8037ad:	89 d6                	mov    %edx,%esi
  8037af:	89 c3                	mov    %eax,%ebx
  8037b1:	f7 e5                	mul    %ebp
  8037b3:	39 d6                	cmp    %edx,%esi
  8037b5:	72 19                	jb     8037d0 <__udivdi3+0xfc>
  8037b7:	74 0b                	je     8037c4 <__udivdi3+0xf0>
  8037b9:	89 d8                	mov    %ebx,%eax
  8037bb:	31 ff                	xor    %edi,%edi
  8037bd:	e9 58 ff ff ff       	jmp    80371a <__udivdi3+0x46>
  8037c2:	66 90                	xchg   %ax,%ax
  8037c4:	8b 54 24 08          	mov    0x8(%esp),%edx
  8037c8:	89 f9                	mov    %edi,%ecx
  8037ca:	d3 e2                	shl    %cl,%edx
  8037cc:	39 c2                	cmp    %eax,%edx
  8037ce:	73 e9                	jae    8037b9 <__udivdi3+0xe5>
  8037d0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8037d3:	31 ff                	xor    %edi,%edi
  8037d5:	e9 40 ff ff ff       	jmp    80371a <__udivdi3+0x46>
  8037da:	66 90                	xchg   %ax,%ax
  8037dc:	31 c0                	xor    %eax,%eax
  8037de:	e9 37 ff ff ff       	jmp    80371a <__udivdi3+0x46>
  8037e3:	90                   	nop

008037e4 <__umoddi3>:
  8037e4:	55                   	push   %ebp
  8037e5:	57                   	push   %edi
  8037e6:	56                   	push   %esi
  8037e7:	53                   	push   %ebx
  8037e8:	83 ec 1c             	sub    $0x1c,%esp
  8037eb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8037ef:	8b 74 24 34          	mov    0x34(%esp),%esi
  8037f3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8037f7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8037fb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8037ff:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803803:	89 f3                	mov    %esi,%ebx
  803805:	89 fa                	mov    %edi,%edx
  803807:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80380b:	89 34 24             	mov    %esi,(%esp)
  80380e:	85 c0                	test   %eax,%eax
  803810:	75 1a                	jne    80382c <__umoddi3+0x48>
  803812:	39 f7                	cmp    %esi,%edi
  803814:	0f 86 a2 00 00 00    	jbe    8038bc <__umoddi3+0xd8>
  80381a:	89 c8                	mov    %ecx,%eax
  80381c:	89 f2                	mov    %esi,%edx
  80381e:	f7 f7                	div    %edi
  803820:	89 d0                	mov    %edx,%eax
  803822:	31 d2                	xor    %edx,%edx
  803824:	83 c4 1c             	add    $0x1c,%esp
  803827:	5b                   	pop    %ebx
  803828:	5e                   	pop    %esi
  803829:	5f                   	pop    %edi
  80382a:	5d                   	pop    %ebp
  80382b:	c3                   	ret    
  80382c:	39 f0                	cmp    %esi,%eax
  80382e:	0f 87 ac 00 00 00    	ja     8038e0 <__umoddi3+0xfc>
  803834:	0f bd e8             	bsr    %eax,%ebp
  803837:	83 f5 1f             	xor    $0x1f,%ebp
  80383a:	0f 84 ac 00 00 00    	je     8038ec <__umoddi3+0x108>
  803840:	bf 20 00 00 00       	mov    $0x20,%edi
  803845:	29 ef                	sub    %ebp,%edi
  803847:	89 fe                	mov    %edi,%esi
  803849:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80384d:	89 e9                	mov    %ebp,%ecx
  80384f:	d3 e0                	shl    %cl,%eax
  803851:	89 d7                	mov    %edx,%edi
  803853:	89 f1                	mov    %esi,%ecx
  803855:	d3 ef                	shr    %cl,%edi
  803857:	09 c7                	or     %eax,%edi
  803859:	89 e9                	mov    %ebp,%ecx
  80385b:	d3 e2                	shl    %cl,%edx
  80385d:	89 14 24             	mov    %edx,(%esp)
  803860:	89 d8                	mov    %ebx,%eax
  803862:	d3 e0                	shl    %cl,%eax
  803864:	89 c2                	mov    %eax,%edx
  803866:	8b 44 24 08          	mov    0x8(%esp),%eax
  80386a:	d3 e0                	shl    %cl,%eax
  80386c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803870:	8b 44 24 08          	mov    0x8(%esp),%eax
  803874:	89 f1                	mov    %esi,%ecx
  803876:	d3 e8                	shr    %cl,%eax
  803878:	09 d0                	or     %edx,%eax
  80387a:	d3 eb                	shr    %cl,%ebx
  80387c:	89 da                	mov    %ebx,%edx
  80387e:	f7 f7                	div    %edi
  803880:	89 d3                	mov    %edx,%ebx
  803882:	f7 24 24             	mull   (%esp)
  803885:	89 c6                	mov    %eax,%esi
  803887:	89 d1                	mov    %edx,%ecx
  803889:	39 d3                	cmp    %edx,%ebx
  80388b:	0f 82 87 00 00 00    	jb     803918 <__umoddi3+0x134>
  803891:	0f 84 91 00 00 00    	je     803928 <__umoddi3+0x144>
  803897:	8b 54 24 04          	mov    0x4(%esp),%edx
  80389b:	29 f2                	sub    %esi,%edx
  80389d:	19 cb                	sbb    %ecx,%ebx
  80389f:	89 d8                	mov    %ebx,%eax
  8038a1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8038a5:	d3 e0                	shl    %cl,%eax
  8038a7:	89 e9                	mov    %ebp,%ecx
  8038a9:	d3 ea                	shr    %cl,%edx
  8038ab:	09 d0                	or     %edx,%eax
  8038ad:	89 e9                	mov    %ebp,%ecx
  8038af:	d3 eb                	shr    %cl,%ebx
  8038b1:	89 da                	mov    %ebx,%edx
  8038b3:	83 c4 1c             	add    $0x1c,%esp
  8038b6:	5b                   	pop    %ebx
  8038b7:	5e                   	pop    %esi
  8038b8:	5f                   	pop    %edi
  8038b9:	5d                   	pop    %ebp
  8038ba:	c3                   	ret    
  8038bb:	90                   	nop
  8038bc:	89 fd                	mov    %edi,%ebp
  8038be:	85 ff                	test   %edi,%edi
  8038c0:	75 0b                	jne    8038cd <__umoddi3+0xe9>
  8038c2:	b8 01 00 00 00       	mov    $0x1,%eax
  8038c7:	31 d2                	xor    %edx,%edx
  8038c9:	f7 f7                	div    %edi
  8038cb:	89 c5                	mov    %eax,%ebp
  8038cd:	89 f0                	mov    %esi,%eax
  8038cf:	31 d2                	xor    %edx,%edx
  8038d1:	f7 f5                	div    %ebp
  8038d3:	89 c8                	mov    %ecx,%eax
  8038d5:	f7 f5                	div    %ebp
  8038d7:	89 d0                	mov    %edx,%eax
  8038d9:	e9 44 ff ff ff       	jmp    803822 <__umoddi3+0x3e>
  8038de:	66 90                	xchg   %ax,%ax
  8038e0:	89 c8                	mov    %ecx,%eax
  8038e2:	89 f2                	mov    %esi,%edx
  8038e4:	83 c4 1c             	add    $0x1c,%esp
  8038e7:	5b                   	pop    %ebx
  8038e8:	5e                   	pop    %esi
  8038e9:	5f                   	pop    %edi
  8038ea:	5d                   	pop    %ebp
  8038eb:	c3                   	ret    
  8038ec:	3b 04 24             	cmp    (%esp),%eax
  8038ef:	72 06                	jb     8038f7 <__umoddi3+0x113>
  8038f1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8038f5:	77 0f                	ja     803906 <__umoddi3+0x122>
  8038f7:	89 f2                	mov    %esi,%edx
  8038f9:	29 f9                	sub    %edi,%ecx
  8038fb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8038ff:	89 14 24             	mov    %edx,(%esp)
  803902:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803906:	8b 44 24 04          	mov    0x4(%esp),%eax
  80390a:	8b 14 24             	mov    (%esp),%edx
  80390d:	83 c4 1c             	add    $0x1c,%esp
  803910:	5b                   	pop    %ebx
  803911:	5e                   	pop    %esi
  803912:	5f                   	pop    %edi
  803913:	5d                   	pop    %ebp
  803914:	c3                   	ret    
  803915:	8d 76 00             	lea    0x0(%esi),%esi
  803918:	2b 04 24             	sub    (%esp),%eax
  80391b:	19 fa                	sbb    %edi,%edx
  80391d:	89 d1                	mov    %edx,%ecx
  80391f:	89 c6                	mov    %eax,%esi
  803921:	e9 71 ff ff ff       	jmp    803897 <__umoddi3+0xb3>
  803926:	66 90                	xchg   %ax,%ax
  803928:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80392c:	72 ea                	jb     803918 <__umoddi3+0x134>
  80392e:	89 d9                	mov    %ebx,%ecx
  803930:	e9 62 ff ff ff       	jmp    803897 <__umoddi3+0xb3>
