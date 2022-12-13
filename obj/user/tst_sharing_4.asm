
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
  80008d:	68 e0 39 80 00       	push   $0x8039e0
  800092:	6a 12                	push   $0x12
  800094:	68 fc 39 80 00       	push   $0x8039fc
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
  8000ae:	68 14 3a 80 00       	push   $0x803a14
  8000b3:	e8 af 08 00 00       	call   800967 <cprintf>
  8000b8:	83 c4 10             	add    $0x10,%esp
	cprintf("MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  8000bb:	83 ec 0c             	sub    $0xc,%esp
  8000be:	68 48 3a 80 00       	push   $0x803a48
  8000c3:	e8 9f 08 00 00       	call   800967 <cprintf>
  8000c8:	83 c4 10             	add    $0x10,%esp
	cprintf("************************************************\n\n\n");
  8000cb:	83 ec 0c             	sub    $0xc,%esp
  8000ce:	68 a4 3a 80 00       	push   $0x803aa4
  8000d3:	e8 8f 08 00 00       	call   800967 <cprintf>
  8000d8:	83 c4 10             	add    $0x10,%esp

	int Mega = 1024*1024;
  8000db:	c7 45 ec 00 00 10 00 	movl   $0x100000,-0x14(%ebp)
	int kilo = 1024;
  8000e2:	c7 45 e8 00 04 00 00 	movl   $0x400,-0x18(%ebp)
	int envID = sys_getenvid();
  8000e9:	e8 75 1d 00 00       	call   801e63 <sys_getenvid>
  8000ee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	cprintf("STEP A: checking free of a shared object ... \n");
  8000f1:	83 ec 0c             	sub    $0xc,%esp
  8000f4:	68 d8 3a 80 00       	push   $0x803ad8
  8000f9:	e8 69 08 00 00       	call   800967 <cprintf>
  8000fe:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x;
		int freeFrames = sys_calculate_free_frames() ;
  800101:	e8 96 1a 00 00       	call   801b9c <sys_calculate_free_frames>
  800106:	89 45 e0             	mov    %eax,-0x20(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  800109:	83 ec 04             	sub    $0x4,%esp
  80010c:	6a 01                	push   $0x1
  80010e:	68 00 10 00 00       	push   $0x1000
  800113:	68 07 3b 80 00       	push   $0x803b07
  800118:	e8 1a 18 00 00       	call   801937 <smalloc>
  80011d:	83 c4 10             	add    $0x10,%esp
  800120:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (x != (uint32*)USER_HEAP_START) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  800123:	81 7d dc 00 00 00 80 	cmpl   $0x80000000,-0x24(%ebp)
  80012a:	74 14                	je     800140 <_main+0x108>
  80012c:	83 ec 04             	sub    $0x4,%esp
  80012f:	68 0c 3b 80 00       	push   $0x803b0c
  800134:	6a 24                	push   $0x24
  800136:	68 fc 39 80 00       	push   $0x8039fc
  80013b:	e8 73 05 00 00       	call   8006b3 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800140:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800143:	e8 54 1a 00 00       	call   801b9c <sys_calculate_free_frames>
  800148:	29 c3                	sub    %eax,%ebx
  80014a:	89 d8                	mov    %ebx,%eax
  80014c:	83 f8 04             	cmp    $0x4,%eax
  80014f:	74 14                	je     800165 <_main+0x12d>
  800151:	83 ec 04             	sub    $0x4,%esp
  800154:	68 78 3b 80 00       	push   $0x803b78
  800159:	6a 25                	push   $0x25
  80015b:	68 fc 39 80 00       	push   $0x8039fc
  800160:	e8 4e 05 00 00       	call   8006b3 <_panic>

		sfree(x);
  800165:	83 ec 0c             	sub    $0xc,%esp
  800168:	ff 75 dc             	pushl  -0x24(%ebp)
  80016b:	e8 cc 18 00 00       	call   801a3c <sfree>
  800170:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) ==  0+0+2) panic("Wrong free: make sure that you free the shared object by calling free_share_object()");
  800173:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800176:	e8 21 1a 00 00       	call   801b9c <sys_calculate_free_frames>
  80017b:	29 c3                	sub    %eax,%ebx
  80017d:	89 d8                	mov    %ebx,%eax
  80017f:	83 f8 02             	cmp    $0x2,%eax
  800182:	75 14                	jne    800198 <_main+0x160>
  800184:	83 ec 04             	sub    $0x4,%esp
  800187:	68 f8 3b 80 00       	push   $0x803bf8
  80018c:	6a 28                	push   $0x28
  80018e:	68 fc 39 80 00       	push   $0x8039fc
  800193:	e8 1b 05 00 00       	call   8006b3 <_panic>
		else if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong free: revise your freeSharedObject logic");
  800198:	e8 ff 19 00 00       	call   801b9c <sys_calculate_free_frames>
  80019d:	89 c2                	mov    %eax,%edx
  80019f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001a2:	39 c2                	cmp    %eax,%edx
  8001a4:	74 14                	je     8001ba <_main+0x182>
  8001a6:	83 ec 04             	sub    $0x4,%esp
  8001a9:	68 50 3c 80 00       	push   $0x803c50
  8001ae:	6a 29                	push   $0x29
  8001b0:	68 fc 39 80 00       	push   $0x8039fc
  8001b5:	e8 f9 04 00 00       	call   8006b3 <_panic>
	}
	cprintf("Step A completed successfully!!\n\n\n");
  8001ba:	83 ec 0c             	sub    $0xc,%esp
  8001bd:	68 80 3c 80 00       	push   $0x803c80
  8001c2:	e8 a0 07 00 00       	call   800967 <cprintf>
  8001c7:	83 c4 10             	add    $0x10,%esp


	cprintf("STEP B: checking free of 2 shared objects ... \n");
  8001ca:	83 ec 0c             	sub    $0xc,%esp
  8001cd:	68 a4 3c 80 00       	push   $0x803ca4
  8001d2:	e8 90 07 00 00       	call   800967 <cprintf>
  8001d7:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x, *z ;
		int freeFrames = sys_calculate_free_frames() ;
  8001da:	e8 bd 19 00 00       	call   801b9c <sys_calculate_free_frames>
  8001df:	89 45 d8             	mov    %eax,-0x28(%ebp)
		z = smalloc("z", PAGE_SIZE, 1);
  8001e2:	83 ec 04             	sub    $0x4,%esp
  8001e5:	6a 01                	push   $0x1
  8001e7:	68 00 10 00 00       	push   $0x1000
  8001ec:	68 d4 3c 80 00       	push   $0x803cd4
  8001f1:	e8 41 17 00 00       	call   801937 <smalloc>
  8001f6:	83 c4 10             	add    $0x10,%esp
  8001f9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8001fc:	83 ec 04             	sub    $0x4,%esp
  8001ff:	6a 01                	push   $0x1
  800201:	68 00 10 00 00       	push   $0x1000
  800206:	68 07 3b 80 00       	push   $0x803b07
  80020b:	e8 27 17 00 00       	call   801937 <smalloc>
  800210:	83 c4 10             	add    $0x10,%esp
  800213:	89 45 d0             	mov    %eax,-0x30(%ebp)

		if(x == NULL) panic("Wrong free: make sure that you free the shared object by calling free_share_object()");
  800216:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80021a:	75 14                	jne    800230 <_main+0x1f8>
  80021c:	83 ec 04             	sub    $0x4,%esp
  80021f:	68 f8 3b 80 00       	push   $0x803bf8
  800224:	6a 35                	push   $0x35
  800226:	68 fc 39 80 00       	push   $0x8039fc
  80022b:	e8 83 04 00 00       	call   8006b3 <_panic>

		if ((freeFrames - sys_calculate_free_frames()) !=  2+1+4) panic("Wrong previous free: make sure that you correctly free shared object before (Step A)");
  800230:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800233:	e8 64 19 00 00       	call   801b9c <sys_calculate_free_frames>
  800238:	29 c3                	sub    %eax,%ebx
  80023a:	89 d8                	mov    %ebx,%eax
  80023c:	83 f8 07             	cmp    $0x7,%eax
  80023f:	74 14                	je     800255 <_main+0x21d>
  800241:	83 ec 04             	sub    $0x4,%esp
  800244:	68 d8 3c 80 00       	push   $0x803cd8
  800249:	6a 37                	push   $0x37
  80024b:	68 fc 39 80 00       	push   $0x8039fc
  800250:	e8 5e 04 00 00       	call   8006b3 <_panic>

		sfree(z);
  800255:	83 ec 0c             	sub    $0xc,%esp
  800258:	ff 75 d4             	pushl  -0x2c(%ebp)
  80025b:	e8 dc 17 00 00       	call   801a3c <sfree>
  800260:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong free: check your logic");
  800263:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800266:	e8 31 19 00 00       	call   801b9c <sys_calculate_free_frames>
  80026b:	29 c3                	sub    %eax,%ebx
  80026d:	89 d8                	mov    %ebx,%eax
  80026f:	83 f8 04             	cmp    $0x4,%eax
  800272:	74 14                	je     800288 <_main+0x250>
  800274:	83 ec 04             	sub    $0x4,%esp
  800277:	68 2d 3d 80 00       	push   $0x803d2d
  80027c:	6a 3a                	push   $0x3a
  80027e:	68 fc 39 80 00       	push   $0x8039fc
  800283:	e8 2b 04 00 00       	call   8006b3 <_panic>

		sfree(x);
  800288:	83 ec 0c             	sub    $0xc,%esp
  80028b:	ff 75 d0             	pushl  -0x30(%ebp)
  80028e:	e8 a9 17 00 00       	call   801a3c <sfree>
  800293:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong free: check your logic");
  800296:	e8 01 19 00 00       	call   801b9c <sys_calculate_free_frames>
  80029b:	89 c2                	mov    %eax,%edx
  80029d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8002a0:	39 c2                	cmp    %eax,%edx
  8002a2:	74 14                	je     8002b8 <_main+0x280>
  8002a4:	83 ec 04             	sub    $0x4,%esp
  8002a7:	68 2d 3d 80 00       	push   $0x803d2d
  8002ac:	6a 3d                	push   $0x3d
  8002ae:	68 fc 39 80 00       	push   $0x8039fc
  8002b3:	e8 fb 03 00 00       	call   8006b3 <_panic>

	}
	cprintf("Step B completed successfully!!\n\n\n");
  8002b8:	83 ec 0c             	sub    $0xc,%esp
  8002bb:	68 4c 3d 80 00       	push   $0x803d4c
  8002c0:	e8 a2 06 00 00       	call   800967 <cprintf>
  8002c5:	83 c4 10             	add    $0x10,%esp

	cprintf("STEP C: checking range of loop during free... \n");
  8002c8:	83 ec 0c             	sub    $0xc,%esp
  8002cb:	68 70 3d 80 00       	push   $0x803d70
  8002d0:	e8 92 06 00 00       	call   800967 <cprintf>
  8002d5:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *w, *u;
		int freeFrames = sys_calculate_free_frames() ;
  8002d8:	e8 bf 18 00 00       	call   801b9c <sys_calculate_free_frames>
  8002dd:	89 45 cc             	mov    %eax,-0x34(%ebp)
		w = smalloc("w", 3 * PAGE_SIZE+1, 1);
  8002e0:	83 ec 04             	sub    $0x4,%esp
  8002e3:	6a 01                	push   $0x1
  8002e5:	68 01 30 00 00       	push   $0x3001
  8002ea:	68 a0 3d 80 00       	push   $0x803da0
  8002ef:	e8 43 16 00 00       	call   801937 <smalloc>
  8002f4:	83 c4 10             	add    $0x10,%esp
  8002f7:	89 45 c8             	mov    %eax,-0x38(%ebp)
		u = smalloc("u", PAGE_SIZE, 1);
  8002fa:	83 ec 04             	sub    $0x4,%esp
  8002fd:	6a 01                	push   $0x1
  8002ff:	68 00 10 00 00       	push   $0x1000
  800304:	68 a2 3d 80 00       	push   $0x803da2
  800309:	e8 29 16 00 00       	call   801937 <smalloc>
  80030e:	83 c4 10             	add    $0x10,%esp
  800311:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		if ((freeFrames - sys_calculate_free_frames()) != 5+1+4) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800314:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800317:	e8 80 18 00 00       	call   801b9c <sys_calculate_free_frames>
  80031c:	29 c3                	sub    %eax,%ebx
  80031e:	89 d8                	mov    %ebx,%eax
  800320:	83 f8 0a             	cmp    $0xa,%eax
  800323:	74 14                	je     800339 <_main+0x301>
  800325:	83 ec 04             	sub    $0x4,%esp
  800328:	68 78 3b 80 00       	push   $0x803b78
  80032d:	6a 48                	push   $0x48
  80032f:	68 fc 39 80 00       	push   $0x8039fc
  800334:	e8 7a 03 00 00       	call   8006b3 <_panic>

		sfree(w);
  800339:	83 ec 0c             	sub    $0xc,%esp
  80033c:	ff 75 c8             	pushl  -0x38(%ebp)
  80033f:	e8 f8 16 00 00       	call   801a3c <sfree>
  800344:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong free: check your logic");
  800347:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  80034a:	e8 4d 18 00 00       	call   801b9c <sys_calculate_free_frames>
  80034f:	29 c3                	sub    %eax,%ebx
  800351:	89 d8                	mov    %ebx,%eax
  800353:	83 f8 04             	cmp    $0x4,%eax
  800356:	74 14                	je     80036c <_main+0x334>
  800358:	83 ec 04             	sub    $0x4,%esp
  80035b:	68 2d 3d 80 00       	push   $0x803d2d
  800360:	6a 4b                	push   $0x4b
  800362:	68 fc 39 80 00       	push   $0x8039fc
  800367:	e8 47 03 00 00       	call   8006b3 <_panic>

		uint32 *o;

		o = smalloc("o", 2 * PAGE_SIZE-1,1);
  80036c:	83 ec 04             	sub    $0x4,%esp
  80036f:	6a 01                	push   $0x1
  800371:	68 ff 1f 00 00       	push   $0x1fff
  800376:	68 a4 3d 80 00       	push   $0x803da4
  80037b:	e8 b7 15 00 00       	call   801937 <smalloc>
  800380:	83 c4 10             	add    $0x10,%esp
  800383:	89 45 c0             	mov    %eax,-0x40(%ebp)

		cprintf("2\n");
  800386:	83 ec 0c             	sub    $0xc,%esp
  800389:	68 a6 3d 80 00       	push   $0x803da6
  80038e:	e8 d4 05 00 00       	call   800967 <cprintf>
  800393:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) != 3+1+4) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800396:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800399:	e8 fe 17 00 00       	call   801b9c <sys_calculate_free_frames>
  80039e:	29 c3                	sub    %eax,%ebx
  8003a0:	89 d8                	mov    %ebx,%eax
  8003a2:	83 f8 08             	cmp    $0x8,%eax
  8003a5:	74 14                	je     8003bb <_main+0x383>
  8003a7:	83 ec 04             	sub    $0x4,%esp
  8003aa:	68 78 3b 80 00       	push   $0x803b78
  8003af:	6a 52                	push   $0x52
  8003b1:	68 fc 39 80 00       	push   $0x8039fc
  8003b6:	e8 f8 02 00 00       	call   8006b3 <_panic>

		sfree(o);
  8003bb:	83 ec 0c             	sub    $0xc,%esp
  8003be:	ff 75 c0             	pushl  -0x40(%ebp)
  8003c1:	e8 76 16 00 00       	call   801a3c <sfree>
  8003c6:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong free: check your logic");
  8003c9:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8003cc:	e8 cb 17 00 00       	call   801b9c <sys_calculate_free_frames>
  8003d1:	29 c3                	sub    %eax,%ebx
  8003d3:	89 d8                	mov    %ebx,%eax
  8003d5:	83 f8 04             	cmp    $0x4,%eax
  8003d8:	74 14                	je     8003ee <_main+0x3b6>
  8003da:	83 ec 04             	sub    $0x4,%esp
  8003dd:	68 2d 3d 80 00       	push   $0x803d2d
  8003e2:	6a 55                	push   $0x55
  8003e4:	68 fc 39 80 00       	push   $0x8039fc
  8003e9:	e8 c5 02 00 00       	call   8006b3 <_panic>

		sfree(u);
  8003ee:	83 ec 0c             	sub    $0xc,%esp
  8003f1:	ff 75 c4             	pushl  -0x3c(%ebp)
  8003f4:	e8 43 16 00 00       	call   801a3c <sfree>
  8003f9:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong free: check your logic");
  8003fc:	e8 9b 17 00 00       	call   801b9c <sys_calculate_free_frames>
  800401:	89 c2                	mov    %eax,%edx
  800403:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800406:	39 c2                	cmp    %eax,%edx
  800408:	74 14                	je     80041e <_main+0x3e6>
  80040a:	83 ec 04             	sub    $0x4,%esp
  80040d:	68 2d 3d 80 00       	push   $0x803d2d
  800412:	6a 58                	push   $0x58
  800414:	68 fc 39 80 00       	push   $0x8039fc
  800419:	e8 95 02 00 00       	call   8006b3 <_panic>


		//Checking boundaries of page tables
		freeFrames = sys_calculate_free_frames() ;
  80041e:	e8 79 17 00 00       	call   801b9c <sys_calculate_free_frames>
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
  800438:	68 a0 3d 80 00       	push   $0x803da0
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
  80045e:	68 a2 3d 80 00       	push   $0x803da2
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
  800480:	68 a4 3d 80 00       	push   $0x803da4
  800485:	e8 ad 14 00 00       	call   801937 <smalloc>
  80048a:	83 c4 10             	add    $0x10,%esp
  80048d:	89 45 c0             	mov    %eax,-0x40(%ebp)

		if ((freeFrames - sys_calculate_free_frames()) != 3073+4+7) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800490:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800493:	e8 04 17 00 00       	call   801b9c <sys_calculate_free_frames>
  800498:	29 c3                	sub    %eax,%ebx
  80049a:	89 d8                	mov    %ebx,%eax
  80049c:	3d 0c 0c 00 00       	cmp    $0xc0c,%eax
  8004a1:	74 14                	je     8004b7 <_main+0x47f>
  8004a3:	83 ec 04             	sub    $0x4,%esp
  8004a6:	68 78 3b 80 00       	push   $0x803b78
  8004ab:	6a 61                	push   $0x61
  8004ad:	68 fc 39 80 00       	push   $0x8039fc
  8004b2:	e8 fc 01 00 00       	call   8006b3 <_panic>

		sfree(o);
  8004b7:	83 ec 0c             	sub    $0xc,%esp
  8004ba:	ff 75 c0             	pushl  -0x40(%ebp)
  8004bd:	e8 7a 15 00 00       	call   801a3c <sfree>
  8004c2:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  2560+3+5) panic("Wrong free: check your logic");
  8004c5:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8004c8:	e8 cf 16 00 00       	call   801b9c <sys_calculate_free_frames>
  8004cd:	29 c3                	sub    %eax,%ebx
  8004cf:	89 d8                	mov    %ebx,%eax
  8004d1:	3d 08 0a 00 00       	cmp    $0xa08,%eax
  8004d6:	74 14                	je     8004ec <_main+0x4b4>
  8004d8:	83 ec 04             	sub    $0x4,%esp
  8004db:	68 2d 3d 80 00       	push   $0x803d2d
  8004e0:	6a 64                	push   $0x64
  8004e2:	68 fc 39 80 00       	push   $0x8039fc
  8004e7:	e8 c7 01 00 00       	call   8006b3 <_panic>

		sfree(w);
  8004ec:	83 ec 0c             	sub    $0xc,%esp
  8004ef:	ff 75 c8             	pushl  -0x38(%ebp)
  8004f2:	e8 45 15 00 00       	call   801a3c <sfree>
  8004f7:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  1792+3+3) panic("Wrong free: check your logic");
  8004fa:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8004fd:	e8 9a 16 00 00       	call   801b9c <sys_calculate_free_frames>
  800502:	29 c3                	sub    %eax,%ebx
  800504:	89 d8                	mov    %ebx,%eax
  800506:	3d 06 07 00 00       	cmp    $0x706,%eax
  80050b:	74 14                	je     800521 <_main+0x4e9>
  80050d:	83 ec 04             	sub    $0x4,%esp
  800510:	68 2d 3d 80 00       	push   $0x803d2d
  800515:	6a 67                	push   $0x67
  800517:	68 fc 39 80 00       	push   $0x8039fc
  80051c:	e8 92 01 00 00       	call   8006b3 <_panic>

		sfree(u);
  800521:	83 ec 0c             	sub    $0xc,%esp
  800524:	ff 75 c4             	pushl  -0x3c(%ebp)
  800527:	e8 10 15 00 00       	call   801a3c <sfree>
  80052c:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong free: check your logic");
  80052f:	e8 68 16 00 00       	call   801b9c <sys_calculate_free_frames>
  800534:	89 c2                	mov    %eax,%edx
  800536:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800539:	39 c2                	cmp    %eax,%edx
  80053b:	74 14                	je     800551 <_main+0x519>
  80053d:	83 ec 04             	sub    $0x4,%esp
  800540:	68 2d 3d 80 00       	push   $0x803d2d
  800545:	6a 6a                	push   $0x6a
  800547:	68 fc 39 80 00       	push   $0x8039fc
  80054c:	e8 62 01 00 00       	call   8006b3 <_panic>
	}
	cprintf("Step C completed successfully!!\n\n\n");
  800551:	83 ec 0c             	sub    $0xc,%esp
  800554:	68 ac 3d 80 00       	push   $0x803dac
  800559:	e8 09 04 00 00       	call   800967 <cprintf>
  80055e:	83 c4 10             	add    $0x10,%esp

	cprintf("Congratulations!! Test of freeSharedObjects [4] completed successfully!!\n\n\n");
  800561:	83 ec 0c             	sub    $0xc,%esp
  800564:	68 d0 3d 80 00       	push   $0x803dd0
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
  80057d:	e8 fa 18 00 00       	call   801e7c <sys_getenvindex>
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
  8005e8:	e8 9c 16 00 00       	call   801c89 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8005ed:	83 ec 0c             	sub    $0xc,%esp
  8005f0:	68 34 3e 80 00       	push   $0x803e34
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
  800618:	68 5c 3e 80 00       	push   $0x803e5c
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
  800649:	68 84 3e 80 00       	push   $0x803e84
  80064e:	e8 14 03 00 00       	call   800967 <cprintf>
  800653:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800656:	a1 20 50 80 00       	mov    0x805020,%eax
  80065b:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800661:	83 ec 08             	sub    $0x8,%esp
  800664:	50                   	push   %eax
  800665:	68 dc 3e 80 00       	push   $0x803edc
  80066a:	e8 f8 02 00 00       	call   800967 <cprintf>
  80066f:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800672:	83 ec 0c             	sub    $0xc,%esp
  800675:	68 34 3e 80 00       	push   $0x803e34
  80067a:	e8 e8 02 00 00       	call   800967 <cprintf>
  80067f:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800682:	e8 1c 16 00 00       	call   801ca3 <sys_enable_interrupt>

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
  80069a:	e8 a9 17 00 00       	call   801e48 <sys_destroy_env>
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
  8006ab:	e8 fe 17 00 00       	call   801eae <sys_exit_env>
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
  8006d4:	68 f0 3e 80 00       	push   $0x803ef0
  8006d9:	e8 89 02 00 00       	call   800967 <cprintf>
  8006de:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8006e1:	a1 00 50 80 00       	mov    0x805000,%eax
  8006e6:	ff 75 0c             	pushl  0xc(%ebp)
  8006e9:	ff 75 08             	pushl  0x8(%ebp)
  8006ec:	50                   	push   %eax
  8006ed:	68 f5 3e 80 00       	push   $0x803ef5
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
  800711:	68 11 3f 80 00       	push   $0x803f11
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
  80073d:	68 14 3f 80 00       	push   $0x803f14
  800742:	6a 26                	push   $0x26
  800744:	68 60 3f 80 00       	push   $0x803f60
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
  80080f:	68 6c 3f 80 00       	push   $0x803f6c
  800814:	6a 3a                	push   $0x3a
  800816:	68 60 3f 80 00       	push   $0x803f60
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
  80087f:	68 c0 3f 80 00       	push   $0x803fc0
  800884:	6a 44                	push   $0x44
  800886:	68 60 3f 80 00       	push   $0x803f60
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
  8008d9:	e8 fd 11 00 00       	call   801adb <sys_cputs>
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
  800950:	e8 86 11 00 00       	call   801adb <sys_cputs>
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
  80099a:	e8 ea 12 00 00       	call   801c89 <sys_disable_interrupt>
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
  8009ba:	e8 e4 12 00 00       	call   801ca3 <sys_enable_interrupt>
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
  800a04:	e8 57 2d 00 00       	call   803760 <__udivdi3>
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
  800a54:	e8 17 2e 00 00       	call   803870 <__umoddi3>
  800a59:	83 c4 10             	add    $0x10,%esp
  800a5c:	05 34 42 80 00       	add    $0x804234,%eax
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
  800baf:	8b 04 85 58 42 80 00 	mov    0x804258(,%eax,4),%eax
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
  800c90:	8b 34 9d a0 40 80 00 	mov    0x8040a0(,%ebx,4),%esi
  800c97:	85 f6                	test   %esi,%esi
  800c99:	75 19                	jne    800cb4 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800c9b:	53                   	push   %ebx
  800c9c:	68 45 42 80 00       	push   $0x804245
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
  800cb5:	68 4e 42 80 00       	push   $0x80424e
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
  800ce2:	be 51 42 80 00       	mov    $0x804251,%esi
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
  801708:	68 b0 43 80 00       	push   $0x8043b0
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
  8017d8:	e8 42 04 00 00       	call   801c1f <sys_allocate_chunk>
  8017dd:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8017e0:	a1 20 51 80 00       	mov    0x805120,%eax
  8017e5:	83 ec 0c             	sub    $0xc,%esp
  8017e8:	50                   	push   %eax
  8017e9:	e8 b7 0a 00 00       	call   8022a5 <initialize_MemBlocksList>
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
  801816:	68 d5 43 80 00       	push   $0x8043d5
  80181b:	6a 33                	push   $0x33
  80181d:	68 f3 43 80 00       	push   $0x8043f3
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
  801895:	68 00 44 80 00       	push   $0x804400
  80189a:	6a 34                	push   $0x34
  80189c:	68 f3 43 80 00       	push   $0x8043f3
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
  80190a:	68 24 44 80 00       	push   $0x804424
  80190f:	6a 46                	push   $0x46
  801911:	68 f3 43 80 00       	push   $0x8043f3
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
  801926:	68 4c 44 80 00       	push   $0x80444c
  80192b:	6a 61                	push   $0x61
  80192d:	68 f3 43 80 00       	push   $0x8043f3
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
  80194c:	75 0a                	jne    801958 <smalloc+0x21>
  80194e:	b8 00 00 00 00       	mov    $0x0,%eax
  801953:	e9 9e 00 00 00       	jmp    8019f6 <smalloc+0xbf>
	//3-If the Kernel successfully creates the shared variable, return its virtual address
	//4-Else, return NULL



	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801958:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80195f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801962:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801965:	01 d0                	add    %edx,%eax
  801967:	48                   	dec    %eax
  801968:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80196b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80196e:	ba 00 00 00 00       	mov    $0x0,%edx
  801973:	f7 75 f0             	divl   -0x10(%ebp)
  801976:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801979:	29 d0                	sub    %edx,%eax
  80197b:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  80197e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801985:	e8 63 06 00 00       	call   801fed <sys_isUHeapPlacementStrategyFIRSTFIT>
  80198a:	85 c0                	test   %eax,%eax
  80198c:	74 11                	je     80199f <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  80198e:	83 ec 0c             	sub    $0xc,%esp
  801991:	ff 75 e8             	pushl  -0x18(%ebp)
  801994:	e8 ce 0c 00 00       	call   802667 <alloc_block_FF>
  801999:	83 c4 10             	add    $0x10,%esp
  80199c:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  80199f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8019a3:	74 4c                	je     8019f1 <smalloc+0xba>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  8019a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019a8:	8b 40 08             	mov    0x8(%eax),%eax
  8019ab:	89 c2                	mov    %eax,%edx
  8019ad:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8019b1:	52                   	push   %edx
  8019b2:	50                   	push   %eax
  8019b3:	ff 75 0c             	pushl  0xc(%ebp)
  8019b6:	ff 75 08             	pushl  0x8(%ebp)
  8019b9:	e8 b4 03 00 00       	call   801d72 <sys_createSharedObject>
  8019be:	83 c4 10             	add    $0x10,%esp
  8019c1:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cprintf("Output is :  %d \n" , result);
  8019c4:	83 ec 08             	sub    $0x8,%esp
  8019c7:	ff 75 e0             	pushl  -0x20(%ebp)
  8019ca:	68 6f 44 80 00       	push   $0x80446f
  8019cf:	e8 93 ef ff ff       	call   800967 <cprintf>
  8019d4:	83 c4 10             	add    $0x10,%esp
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  8019d7:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  8019db:	74 14                	je     8019f1 <smalloc+0xba>
  8019dd:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  8019e1:	74 0e                	je     8019f1 <smalloc+0xba>
  8019e3:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  8019e7:	74 08                	je     8019f1 <smalloc+0xba>
			return (void*) mem_block->sva;
  8019e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019ec:	8b 40 08             	mov    0x8(%eax),%eax
  8019ef:	eb 05                	jmp    8019f6 <smalloc+0xbf>
	}
	return NULL;
  8019f1:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8019f6:	c9                   	leave  
  8019f7:	c3                   	ret    

008019f8 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8019f8:	55                   	push   %ebp
  8019f9:	89 e5                	mov    %esp,%ebp
  8019fb:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8019fe:	e8 ee fc ff ff       	call   8016f1 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801a03:	83 ec 04             	sub    $0x4,%esp
  801a06:	68 84 44 80 00       	push   $0x804484
  801a0b:	68 ab 00 00 00       	push   $0xab
  801a10:	68 f3 43 80 00       	push   $0x8043f3
  801a15:	e8 99 ec ff ff       	call   8006b3 <_panic>

00801a1a <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801a1a:	55                   	push   %ebp
  801a1b:	89 e5                	mov    %esp,%ebp
  801a1d:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801a20:	e8 cc fc ff ff       	call   8016f1 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801a25:	83 ec 04             	sub    $0x4,%esp
  801a28:	68 a8 44 80 00       	push   $0x8044a8
  801a2d:	68 ef 00 00 00       	push   $0xef
  801a32:	68 f3 43 80 00       	push   $0x8043f3
  801a37:	e8 77 ec ff ff       	call   8006b3 <_panic>

00801a3c <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801a3c:	55                   	push   %ebp
  801a3d:	89 e5                	mov    %esp,%ebp
  801a3f:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801a42:	83 ec 04             	sub    $0x4,%esp
  801a45:	68 d0 44 80 00       	push   $0x8044d0
  801a4a:	68 03 01 00 00       	push   $0x103
  801a4f:	68 f3 43 80 00       	push   $0x8043f3
  801a54:	e8 5a ec ff ff       	call   8006b3 <_panic>

00801a59 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801a59:	55                   	push   %ebp
  801a5a:	89 e5                	mov    %esp,%ebp
  801a5c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a5f:	83 ec 04             	sub    $0x4,%esp
  801a62:	68 f4 44 80 00       	push   $0x8044f4
  801a67:	68 0e 01 00 00       	push   $0x10e
  801a6c:	68 f3 43 80 00       	push   $0x8043f3
  801a71:	e8 3d ec ff ff       	call   8006b3 <_panic>

00801a76 <shrink>:

}
void shrink(uint32 newSize)
{
  801a76:	55                   	push   %ebp
  801a77:	89 e5                	mov    %esp,%ebp
  801a79:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a7c:	83 ec 04             	sub    $0x4,%esp
  801a7f:	68 f4 44 80 00       	push   $0x8044f4
  801a84:	68 13 01 00 00       	push   $0x113
  801a89:	68 f3 43 80 00       	push   $0x8043f3
  801a8e:	e8 20 ec ff ff       	call   8006b3 <_panic>

00801a93 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801a93:	55                   	push   %ebp
  801a94:	89 e5                	mov    %esp,%ebp
  801a96:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a99:	83 ec 04             	sub    $0x4,%esp
  801a9c:	68 f4 44 80 00       	push   $0x8044f4
  801aa1:	68 18 01 00 00       	push   $0x118
  801aa6:	68 f3 43 80 00       	push   $0x8043f3
  801aab:	e8 03 ec ff ff       	call   8006b3 <_panic>

00801ab0 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801ab0:	55                   	push   %ebp
  801ab1:	89 e5                	mov    %esp,%ebp
  801ab3:	57                   	push   %edi
  801ab4:	56                   	push   %esi
  801ab5:	53                   	push   %ebx
  801ab6:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801ab9:	8b 45 08             	mov    0x8(%ebp),%eax
  801abc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801abf:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ac2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ac5:	8b 7d 18             	mov    0x18(%ebp),%edi
  801ac8:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801acb:	cd 30                	int    $0x30
  801acd:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801ad0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801ad3:	83 c4 10             	add    $0x10,%esp
  801ad6:	5b                   	pop    %ebx
  801ad7:	5e                   	pop    %esi
  801ad8:	5f                   	pop    %edi
  801ad9:	5d                   	pop    %ebp
  801ada:	c3                   	ret    

00801adb <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801adb:	55                   	push   %ebp
  801adc:	89 e5                	mov    %esp,%ebp
  801ade:	83 ec 04             	sub    $0x4,%esp
  801ae1:	8b 45 10             	mov    0x10(%ebp),%eax
  801ae4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801ae7:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801aeb:	8b 45 08             	mov    0x8(%ebp),%eax
  801aee:	6a 00                	push   $0x0
  801af0:	6a 00                	push   $0x0
  801af2:	52                   	push   %edx
  801af3:	ff 75 0c             	pushl  0xc(%ebp)
  801af6:	50                   	push   %eax
  801af7:	6a 00                	push   $0x0
  801af9:	e8 b2 ff ff ff       	call   801ab0 <syscall>
  801afe:	83 c4 18             	add    $0x18,%esp
}
  801b01:	90                   	nop
  801b02:	c9                   	leave  
  801b03:	c3                   	ret    

00801b04 <sys_cgetc>:

int
sys_cgetc(void)
{
  801b04:	55                   	push   %ebp
  801b05:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801b07:	6a 00                	push   $0x0
  801b09:	6a 00                	push   $0x0
  801b0b:	6a 00                	push   $0x0
  801b0d:	6a 00                	push   $0x0
  801b0f:	6a 00                	push   $0x0
  801b11:	6a 01                	push   $0x1
  801b13:	e8 98 ff ff ff       	call   801ab0 <syscall>
  801b18:	83 c4 18             	add    $0x18,%esp
}
  801b1b:	c9                   	leave  
  801b1c:	c3                   	ret    

00801b1d <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801b1d:	55                   	push   %ebp
  801b1e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801b20:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b23:	8b 45 08             	mov    0x8(%ebp),%eax
  801b26:	6a 00                	push   $0x0
  801b28:	6a 00                	push   $0x0
  801b2a:	6a 00                	push   $0x0
  801b2c:	52                   	push   %edx
  801b2d:	50                   	push   %eax
  801b2e:	6a 05                	push   $0x5
  801b30:	e8 7b ff ff ff       	call   801ab0 <syscall>
  801b35:	83 c4 18             	add    $0x18,%esp
}
  801b38:	c9                   	leave  
  801b39:	c3                   	ret    

00801b3a <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801b3a:	55                   	push   %ebp
  801b3b:	89 e5                	mov    %esp,%ebp
  801b3d:	56                   	push   %esi
  801b3e:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801b3f:	8b 75 18             	mov    0x18(%ebp),%esi
  801b42:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b45:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b48:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4e:	56                   	push   %esi
  801b4f:	53                   	push   %ebx
  801b50:	51                   	push   %ecx
  801b51:	52                   	push   %edx
  801b52:	50                   	push   %eax
  801b53:	6a 06                	push   $0x6
  801b55:	e8 56 ff ff ff       	call   801ab0 <syscall>
  801b5a:	83 c4 18             	add    $0x18,%esp
}
  801b5d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b60:	5b                   	pop    %ebx
  801b61:	5e                   	pop    %esi
  801b62:	5d                   	pop    %ebp
  801b63:	c3                   	ret    

00801b64 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801b64:	55                   	push   %ebp
  801b65:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801b67:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6d:	6a 00                	push   $0x0
  801b6f:	6a 00                	push   $0x0
  801b71:	6a 00                	push   $0x0
  801b73:	52                   	push   %edx
  801b74:	50                   	push   %eax
  801b75:	6a 07                	push   $0x7
  801b77:	e8 34 ff ff ff       	call   801ab0 <syscall>
  801b7c:	83 c4 18             	add    $0x18,%esp
}
  801b7f:	c9                   	leave  
  801b80:	c3                   	ret    

00801b81 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801b81:	55                   	push   %ebp
  801b82:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801b84:	6a 00                	push   $0x0
  801b86:	6a 00                	push   $0x0
  801b88:	6a 00                	push   $0x0
  801b8a:	ff 75 0c             	pushl  0xc(%ebp)
  801b8d:	ff 75 08             	pushl  0x8(%ebp)
  801b90:	6a 08                	push   $0x8
  801b92:	e8 19 ff ff ff       	call   801ab0 <syscall>
  801b97:	83 c4 18             	add    $0x18,%esp
}
  801b9a:	c9                   	leave  
  801b9b:	c3                   	ret    

00801b9c <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801b9c:	55                   	push   %ebp
  801b9d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801b9f:	6a 00                	push   $0x0
  801ba1:	6a 00                	push   $0x0
  801ba3:	6a 00                	push   $0x0
  801ba5:	6a 00                	push   $0x0
  801ba7:	6a 00                	push   $0x0
  801ba9:	6a 09                	push   $0x9
  801bab:	e8 00 ff ff ff       	call   801ab0 <syscall>
  801bb0:	83 c4 18             	add    $0x18,%esp
}
  801bb3:	c9                   	leave  
  801bb4:	c3                   	ret    

00801bb5 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801bb5:	55                   	push   %ebp
  801bb6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801bb8:	6a 00                	push   $0x0
  801bba:	6a 00                	push   $0x0
  801bbc:	6a 00                	push   $0x0
  801bbe:	6a 00                	push   $0x0
  801bc0:	6a 00                	push   $0x0
  801bc2:	6a 0a                	push   $0xa
  801bc4:	e8 e7 fe ff ff       	call   801ab0 <syscall>
  801bc9:	83 c4 18             	add    $0x18,%esp
}
  801bcc:	c9                   	leave  
  801bcd:	c3                   	ret    

00801bce <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801bce:	55                   	push   %ebp
  801bcf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801bd1:	6a 00                	push   $0x0
  801bd3:	6a 00                	push   $0x0
  801bd5:	6a 00                	push   $0x0
  801bd7:	6a 00                	push   $0x0
  801bd9:	6a 00                	push   $0x0
  801bdb:	6a 0b                	push   $0xb
  801bdd:	e8 ce fe ff ff       	call   801ab0 <syscall>
  801be2:	83 c4 18             	add    $0x18,%esp
}
  801be5:	c9                   	leave  
  801be6:	c3                   	ret    

00801be7 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801be7:	55                   	push   %ebp
  801be8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801bea:	6a 00                	push   $0x0
  801bec:	6a 00                	push   $0x0
  801bee:	6a 00                	push   $0x0
  801bf0:	ff 75 0c             	pushl  0xc(%ebp)
  801bf3:	ff 75 08             	pushl  0x8(%ebp)
  801bf6:	6a 0f                	push   $0xf
  801bf8:	e8 b3 fe ff ff       	call   801ab0 <syscall>
  801bfd:	83 c4 18             	add    $0x18,%esp
	return;
  801c00:	90                   	nop
}
  801c01:	c9                   	leave  
  801c02:	c3                   	ret    

00801c03 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801c03:	55                   	push   %ebp
  801c04:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801c06:	6a 00                	push   $0x0
  801c08:	6a 00                	push   $0x0
  801c0a:	6a 00                	push   $0x0
  801c0c:	ff 75 0c             	pushl  0xc(%ebp)
  801c0f:	ff 75 08             	pushl  0x8(%ebp)
  801c12:	6a 10                	push   $0x10
  801c14:	e8 97 fe ff ff       	call   801ab0 <syscall>
  801c19:	83 c4 18             	add    $0x18,%esp
	return ;
  801c1c:	90                   	nop
}
  801c1d:	c9                   	leave  
  801c1e:	c3                   	ret    

00801c1f <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801c1f:	55                   	push   %ebp
  801c20:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801c22:	6a 00                	push   $0x0
  801c24:	6a 00                	push   $0x0
  801c26:	ff 75 10             	pushl  0x10(%ebp)
  801c29:	ff 75 0c             	pushl  0xc(%ebp)
  801c2c:	ff 75 08             	pushl  0x8(%ebp)
  801c2f:	6a 11                	push   $0x11
  801c31:	e8 7a fe ff ff       	call   801ab0 <syscall>
  801c36:	83 c4 18             	add    $0x18,%esp
	return ;
  801c39:	90                   	nop
}
  801c3a:	c9                   	leave  
  801c3b:	c3                   	ret    

00801c3c <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801c3c:	55                   	push   %ebp
  801c3d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801c3f:	6a 00                	push   $0x0
  801c41:	6a 00                	push   $0x0
  801c43:	6a 00                	push   $0x0
  801c45:	6a 00                	push   $0x0
  801c47:	6a 00                	push   $0x0
  801c49:	6a 0c                	push   $0xc
  801c4b:	e8 60 fe ff ff       	call   801ab0 <syscall>
  801c50:	83 c4 18             	add    $0x18,%esp
}
  801c53:	c9                   	leave  
  801c54:	c3                   	ret    

00801c55 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801c55:	55                   	push   %ebp
  801c56:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801c58:	6a 00                	push   $0x0
  801c5a:	6a 00                	push   $0x0
  801c5c:	6a 00                	push   $0x0
  801c5e:	6a 00                	push   $0x0
  801c60:	ff 75 08             	pushl  0x8(%ebp)
  801c63:	6a 0d                	push   $0xd
  801c65:	e8 46 fe ff ff       	call   801ab0 <syscall>
  801c6a:	83 c4 18             	add    $0x18,%esp
}
  801c6d:	c9                   	leave  
  801c6e:	c3                   	ret    

00801c6f <sys_scarce_memory>:

void sys_scarce_memory()
{
  801c6f:	55                   	push   %ebp
  801c70:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801c72:	6a 00                	push   $0x0
  801c74:	6a 00                	push   $0x0
  801c76:	6a 00                	push   $0x0
  801c78:	6a 00                	push   $0x0
  801c7a:	6a 00                	push   $0x0
  801c7c:	6a 0e                	push   $0xe
  801c7e:	e8 2d fe ff ff       	call   801ab0 <syscall>
  801c83:	83 c4 18             	add    $0x18,%esp
}
  801c86:	90                   	nop
  801c87:	c9                   	leave  
  801c88:	c3                   	ret    

00801c89 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801c89:	55                   	push   %ebp
  801c8a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801c8c:	6a 00                	push   $0x0
  801c8e:	6a 00                	push   $0x0
  801c90:	6a 00                	push   $0x0
  801c92:	6a 00                	push   $0x0
  801c94:	6a 00                	push   $0x0
  801c96:	6a 13                	push   $0x13
  801c98:	e8 13 fe ff ff       	call   801ab0 <syscall>
  801c9d:	83 c4 18             	add    $0x18,%esp
}
  801ca0:	90                   	nop
  801ca1:	c9                   	leave  
  801ca2:	c3                   	ret    

00801ca3 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801ca3:	55                   	push   %ebp
  801ca4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801ca6:	6a 00                	push   $0x0
  801ca8:	6a 00                	push   $0x0
  801caa:	6a 00                	push   $0x0
  801cac:	6a 00                	push   $0x0
  801cae:	6a 00                	push   $0x0
  801cb0:	6a 14                	push   $0x14
  801cb2:	e8 f9 fd ff ff       	call   801ab0 <syscall>
  801cb7:	83 c4 18             	add    $0x18,%esp
}
  801cba:	90                   	nop
  801cbb:	c9                   	leave  
  801cbc:	c3                   	ret    

00801cbd <sys_cputc>:


void
sys_cputc(const char c)
{
  801cbd:	55                   	push   %ebp
  801cbe:	89 e5                	mov    %esp,%ebp
  801cc0:	83 ec 04             	sub    $0x4,%esp
  801cc3:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801cc9:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ccd:	6a 00                	push   $0x0
  801ccf:	6a 00                	push   $0x0
  801cd1:	6a 00                	push   $0x0
  801cd3:	6a 00                	push   $0x0
  801cd5:	50                   	push   %eax
  801cd6:	6a 15                	push   $0x15
  801cd8:	e8 d3 fd ff ff       	call   801ab0 <syscall>
  801cdd:	83 c4 18             	add    $0x18,%esp
}
  801ce0:	90                   	nop
  801ce1:	c9                   	leave  
  801ce2:	c3                   	ret    

00801ce3 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801ce3:	55                   	push   %ebp
  801ce4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801ce6:	6a 00                	push   $0x0
  801ce8:	6a 00                	push   $0x0
  801cea:	6a 00                	push   $0x0
  801cec:	6a 00                	push   $0x0
  801cee:	6a 00                	push   $0x0
  801cf0:	6a 16                	push   $0x16
  801cf2:	e8 b9 fd ff ff       	call   801ab0 <syscall>
  801cf7:	83 c4 18             	add    $0x18,%esp
}
  801cfa:	90                   	nop
  801cfb:	c9                   	leave  
  801cfc:	c3                   	ret    

00801cfd <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801cfd:	55                   	push   %ebp
  801cfe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801d00:	8b 45 08             	mov    0x8(%ebp),%eax
  801d03:	6a 00                	push   $0x0
  801d05:	6a 00                	push   $0x0
  801d07:	6a 00                	push   $0x0
  801d09:	ff 75 0c             	pushl  0xc(%ebp)
  801d0c:	50                   	push   %eax
  801d0d:	6a 17                	push   $0x17
  801d0f:	e8 9c fd ff ff       	call   801ab0 <syscall>
  801d14:	83 c4 18             	add    $0x18,%esp
}
  801d17:	c9                   	leave  
  801d18:	c3                   	ret    

00801d19 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801d19:	55                   	push   %ebp
  801d1a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d1c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d1f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d22:	6a 00                	push   $0x0
  801d24:	6a 00                	push   $0x0
  801d26:	6a 00                	push   $0x0
  801d28:	52                   	push   %edx
  801d29:	50                   	push   %eax
  801d2a:	6a 1a                	push   $0x1a
  801d2c:	e8 7f fd ff ff       	call   801ab0 <syscall>
  801d31:	83 c4 18             	add    $0x18,%esp
}
  801d34:	c9                   	leave  
  801d35:	c3                   	ret    

00801d36 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801d36:	55                   	push   %ebp
  801d37:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d39:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3f:	6a 00                	push   $0x0
  801d41:	6a 00                	push   $0x0
  801d43:	6a 00                	push   $0x0
  801d45:	52                   	push   %edx
  801d46:	50                   	push   %eax
  801d47:	6a 18                	push   $0x18
  801d49:	e8 62 fd ff ff       	call   801ab0 <syscall>
  801d4e:	83 c4 18             	add    $0x18,%esp
}
  801d51:	90                   	nop
  801d52:	c9                   	leave  
  801d53:	c3                   	ret    

00801d54 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801d54:	55                   	push   %ebp
  801d55:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d57:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d5a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5d:	6a 00                	push   $0x0
  801d5f:	6a 00                	push   $0x0
  801d61:	6a 00                	push   $0x0
  801d63:	52                   	push   %edx
  801d64:	50                   	push   %eax
  801d65:	6a 19                	push   $0x19
  801d67:	e8 44 fd ff ff       	call   801ab0 <syscall>
  801d6c:	83 c4 18             	add    $0x18,%esp
}
  801d6f:	90                   	nop
  801d70:	c9                   	leave  
  801d71:	c3                   	ret    

00801d72 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801d72:	55                   	push   %ebp
  801d73:	89 e5                	mov    %esp,%ebp
  801d75:	83 ec 04             	sub    $0x4,%esp
  801d78:	8b 45 10             	mov    0x10(%ebp),%eax
  801d7b:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801d7e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801d81:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801d85:	8b 45 08             	mov    0x8(%ebp),%eax
  801d88:	6a 00                	push   $0x0
  801d8a:	51                   	push   %ecx
  801d8b:	52                   	push   %edx
  801d8c:	ff 75 0c             	pushl  0xc(%ebp)
  801d8f:	50                   	push   %eax
  801d90:	6a 1b                	push   $0x1b
  801d92:	e8 19 fd ff ff       	call   801ab0 <syscall>
  801d97:	83 c4 18             	add    $0x18,%esp
}
  801d9a:	c9                   	leave  
  801d9b:	c3                   	ret    

00801d9c <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801d9c:	55                   	push   %ebp
  801d9d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801d9f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801da2:	8b 45 08             	mov    0x8(%ebp),%eax
  801da5:	6a 00                	push   $0x0
  801da7:	6a 00                	push   $0x0
  801da9:	6a 00                	push   $0x0
  801dab:	52                   	push   %edx
  801dac:	50                   	push   %eax
  801dad:	6a 1c                	push   $0x1c
  801daf:	e8 fc fc ff ff       	call   801ab0 <syscall>
  801db4:	83 c4 18             	add    $0x18,%esp
}
  801db7:	c9                   	leave  
  801db8:	c3                   	ret    

00801db9 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801db9:	55                   	push   %ebp
  801dba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801dbc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801dbf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dc2:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc5:	6a 00                	push   $0x0
  801dc7:	6a 00                	push   $0x0
  801dc9:	51                   	push   %ecx
  801dca:	52                   	push   %edx
  801dcb:	50                   	push   %eax
  801dcc:	6a 1d                	push   $0x1d
  801dce:	e8 dd fc ff ff       	call   801ab0 <syscall>
  801dd3:	83 c4 18             	add    $0x18,%esp
}
  801dd6:	c9                   	leave  
  801dd7:	c3                   	ret    

00801dd8 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801dd8:	55                   	push   %ebp
  801dd9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801ddb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dde:	8b 45 08             	mov    0x8(%ebp),%eax
  801de1:	6a 00                	push   $0x0
  801de3:	6a 00                	push   $0x0
  801de5:	6a 00                	push   $0x0
  801de7:	52                   	push   %edx
  801de8:	50                   	push   %eax
  801de9:	6a 1e                	push   $0x1e
  801deb:	e8 c0 fc ff ff       	call   801ab0 <syscall>
  801df0:	83 c4 18             	add    $0x18,%esp
}
  801df3:	c9                   	leave  
  801df4:	c3                   	ret    

00801df5 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801df5:	55                   	push   %ebp
  801df6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801df8:	6a 00                	push   $0x0
  801dfa:	6a 00                	push   $0x0
  801dfc:	6a 00                	push   $0x0
  801dfe:	6a 00                	push   $0x0
  801e00:	6a 00                	push   $0x0
  801e02:	6a 1f                	push   $0x1f
  801e04:	e8 a7 fc ff ff       	call   801ab0 <syscall>
  801e09:	83 c4 18             	add    $0x18,%esp
}
  801e0c:	c9                   	leave  
  801e0d:	c3                   	ret    

00801e0e <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801e0e:	55                   	push   %ebp
  801e0f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801e11:	8b 45 08             	mov    0x8(%ebp),%eax
  801e14:	6a 00                	push   $0x0
  801e16:	ff 75 14             	pushl  0x14(%ebp)
  801e19:	ff 75 10             	pushl  0x10(%ebp)
  801e1c:	ff 75 0c             	pushl  0xc(%ebp)
  801e1f:	50                   	push   %eax
  801e20:	6a 20                	push   $0x20
  801e22:	e8 89 fc ff ff       	call   801ab0 <syscall>
  801e27:	83 c4 18             	add    $0x18,%esp
}
  801e2a:	c9                   	leave  
  801e2b:	c3                   	ret    

00801e2c <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801e2c:	55                   	push   %ebp
  801e2d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801e2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e32:	6a 00                	push   $0x0
  801e34:	6a 00                	push   $0x0
  801e36:	6a 00                	push   $0x0
  801e38:	6a 00                	push   $0x0
  801e3a:	50                   	push   %eax
  801e3b:	6a 21                	push   $0x21
  801e3d:	e8 6e fc ff ff       	call   801ab0 <syscall>
  801e42:	83 c4 18             	add    $0x18,%esp
}
  801e45:	90                   	nop
  801e46:	c9                   	leave  
  801e47:	c3                   	ret    

00801e48 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801e48:	55                   	push   %ebp
  801e49:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801e4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e4e:	6a 00                	push   $0x0
  801e50:	6a 00                	push   $0x0
  801e52:	6a 00                	push   $0x0
  801e54:	6a 00                	push   $0x0
  801e56:	50                   	push   %eax
  801e57:	6a 22                	push   $0x22
  801e59:	e8 52 fc ff ff       	call   801ab0 <syscall>
  801e5e:	83 c4 18             	add    $0x18,%esp
}
  801e61:	c9                   	leave  
  801e62:	c3                   	ret    

00801e63 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801e63:	55                   	push   %ebp
  801e64:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801e66:	6a 00                	push   $0x0
  801e68:	6a 00                	push   $0x0
  801e6a:	6a 00                	push   $0x0
  801e6c:	6a 00                	push   $0x0
  801e6e:	6a 00                	push   $0x0
  801e70:	6a 02                	push   $0x2
  801e72:	e8 39 fc ff ff       	call   801ab0 <syscall>
  801e77:	83 c4 18             	add    $0x18,%esp
}
  801e7a:	c9                   	leave  
  801e7b:	c3                   	ret    

00801e7c <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801e7c:	55                   	push   %ebp
  801e7d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801e7f:	6a 00                	push   $0x0
  801e81:	6a 00                	push   $0x0
  801e83:	6a 00                	push   $0x0
  801e85:	6a 00                	push   $0x0
  801e87:	6a 00                	push   $0x0
  801e89:	6a 03                	push   $0x3
  801e8b:	e8 20 fc ff ff       	call   801ab0 <syscall>
  801e90:	83 c4 18             	add    $0x18,%esp
}
  801e93:	c9                   	leave  
  801e94:	c3                   	ret    

00801e95 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801e95:	55                   	push   %ebp
  801e96:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801e98:	6a 00                	push   $0x0
  801e9a:	6a 00                	push   $0x0
  801e9c:	6a 00                	push   $0x0
  801e9e:	6a 00                	push   $0x0
  801ea0:	6a 00                	push   $0x0
  801ea2:	6a 04                	push   $0x4
  801ea4:	e8 07 fc ff ff       	call   801ab0 <syscall>
  801ea9:	83 c4 18             	add    $0x18,%esp
}
  801eac:	c9                   	leave  
  801ead:	c3                   	ret    

00801eae <sys_exit_env>:


void sys_exit_env(void)
{
  801eae:	55                   	push   %ebp
  801eaf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801eb1:	6a 00                	push   $0x0
  801eb3:	6a 00                	push   $0x0
  801eb5:	6a 00                	push   $0x0
  801eb7:	6a 00                	push   $0x0
  801eb9:	6a 00                	push   $0x0
  801ebb:	6a 23                	push   $0x23
  801ebd:	e8 ee fb ff ff       	call   801ab0 <syscall>
  801ec2:	83 c4 18             	add    $0x18,%esp
}
  801ec5:	90                   	nop
  801ec6:	c9                   	leave  
  801ec7:	c3                   	ret    

00801ec8 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801ec8:	55                   	push   %ebp
  801ec9:	89 e5                	mov    %esp,%ebp
  801ecb:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801ece:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ed1:	8d 50 04             	lea    0x4(%eax),%edx
  801ed4:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ed7:	6a 00                	push   $0x0
  801ed9:	6a 00                	push   $0x0
  801edb:	6a 00                	push   $0x0
  801edd:	52                   	push   %edx
  801ede:	50                   	push   %eax
  801edf:	6a 24                	push   $0x24
  801ee1:	e8 ca fb ff ff       	call   801ab0 <syscall>
  801ee6:	83 c4 18             	add    $0x18,%esp
	return result;
  801ee9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801eec:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801eef:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ef2:	89 01                	mov    %eax,(%ecx)
  801ef4:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801ef7:	8b 45 08             	mov    0x8(%ebp),%eax
  801efa:	c9                   	leave  
  801efb:	c2 04 00             	ret    $0x4

00801efe <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801efe:	55                   	push   %ebp
  801eff:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801f01:	6a 00                	push   $0x0
  801f03:	6a 00                	push   $0x0
  801f05:	ff 75 10             	pushl  0x10(%ebp)
  801f08:	ff 75 0c             	pushl  0xc(%ebp)
  801f0b:	ff 75 08             	pushl  0x8(%ebp)
  801f0e:	6a 12                	push   $0x12
  801f10:	e8 9b fb ff ff       	call   801ab0 <syscall>
  801f15:	83 c4 18             	add    $0x18,%esp
	return ;
  801f18:	90                   	nop
}
  801f19:	c9                   	leave  
  801f1a:	c3                   	ret    

00801f1b <sys_rcr2>:
uint32 sys_rcr2()
{
  801f1b:	55                   	push   %ebp
  801f1c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801f1e:	6a 00                	push   $0x0
  801f20:	6a 00                	push   $0x0
  801f22:	6a 00                	push   $0x0
  801f24:	6a 00                	push   $0x0
  801f26:	6a 00                	push   $0x0
  801f28:	6a 25                	push   $0x25
  801f2a:	e8 81 fb ff ff       	call   801ab0 <syscall>
  801f2f:	83 c4 18             	add    $0x18,%esp
}
  801f32:	c9                   	leave  
  801f33:	c3                   	ret    

00801f34 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801f34:	55                   	push   %ebp
  801f35:	89 e5                	mov    %esp,%ebp
  801f37:	83 ec 04             	sub    $0x4,%esp
  801f3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f3d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801f40:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801f44:	6a 00                	push   $0x0
  801f46:	6a 00                	push   $0x0
  801f48:	6a 00                	push   $0x0
  801f4a:	6a 00                	push   $0x0
  801f4c:	50                   	push   %eax
  801f4d:	6a 26                	push   $0x26
  801f4f:	e8 5c fb ff ff       	call   801ab0 <syscall>
  801f54:	83 c4 18             	add    $0x18,%esp
	return ;
  801f57:	90                   	nop
}
  801f58:	c9                   	leave  
  801f59:	c3                   	ret    

00801f5a <rsttst>:
void rsttst()
{
  801f5a:	55                   	push   %ebp
  801f5b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801f5d:	6a 00                	push   $0x0
  801f5f:	6a 00                	push   $0x0
  801f61:	6a 00                	push   $0x0
  801f63:	6a 00                	push   $0x0
  801f65:	6a 00                	push   $0x0
  801f67:	6a 28                	push   $0x28
  801f69:	e8 42 fb ff ff       	call   801ab0 <syscall>
  801f6e:	83 c4 18             	add    $0x18,%esp
	return ;
  801f71:	90                   	nop
}
  801f72:	c9                   	leave  
  801f73:	c3                   	ret    

00801f74 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801f74:	55                   	push   %ebp
  801f75:	89 e5                	mov    %esp,%ebp
  801f77:	83 ec 04             	sub    $0x4,%esp
  801f7a:	8b 45 14             	mov    0x14(%ebp),%eax
  801f7d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801f80:	8b 55 18             	mov    0x18(%ebp),%edx
  801f83:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801f87:	52                   	push   %edx
  801f88:	50                   	push   %eax
  801f89:	ff 75 10             	pushl  0x10(%ebp)
  801f8c:	ff 75 0c             	pushl  0xc(%ebp)
  801f8f:	ff 75 08             	pushl  0x8(%ebp)
  801f92:	6a 27                	push   $0x27
  801f94:	e8 17 fb ff ff       	call   801ab0 <syscall>
  801f99:	83 c4 18             	add    $0x18,%esp
	return ;
  801f9c:	90                   	nop
}
  801f9d:	c9                   	leave  
  801f9e:	c3                   	ret    

00801f9f <chktst>:
void chktst(uint32 n)
{
  801f9f:	55                   	push   %ebp
  801fa0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801fa2:	6a 00                	push   $0x0
  801fa4:	6a 00                	push   $0x0
  801fa6:	6a 00                	push   $0x0
  801fa8:	6a 00                	push   $0x0
  801faa:	ff 75 08             	pushl  0x8(%ebp)
  801fad:	6a 29                	push   $0x29
  801faf:	e8 fc fa ff ff       	call   801ab0 <syscall>
  801fb4:	83 c4 18             	add    $0x18,%esp
	return ;
  801fb7:	90                   	nop
}
  801fb8:	c9                   	leave  
  801fb9:	c3                   	ret    

00801fba <inctst>:

void inctst()
{
  801fba:	55                   	push   %ebp
  801fbb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801fbd:	6a 00                	push   $0x0
  801fbf:	6a 00                	push   $0x0
  801fc1:	6a 00                	push   $0x0
  801fc3:	6a 00                	push   $0x0
  801fc5:	6a 00                	push   $0x0
  801fc7:	6a 2a                	push   $0x2a
  801fc9:	e8 e2 fa ff ff       	call   801ab0 <syscall>
  801fce:	83 c4 18             	add    $0x18,%esp
	return ;
  801fd1:	90                   	nop
}
  801fd2:	c9                   	leave  
  801fd3:	c3                   	ret    

00801fd4 <gettst>:
uint32 gettst()
{
  801fd4:	55                   	push   %ebp
  801fd5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801fd7:	6a 00                	push   $0x0
  801fd9:	6a 00                	push   $0x0
  801fdb:	6a 00                	push   $0x0
  801fdd:	6a 00                	push   $0x0
  801fdf:	6a 00                	push   $0x0
  801fe1:	6a 2b                	push   $0x2b
  801fe3:	e8 c8 fa ff ff       	call   801ab0 <syscall>
  801fe8:	83 c4 18             	add    $0x18,%esp
}
  801feb:	c9                   	leave  
  801fec:	c3                   	ret    

00801fed <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801fed:	55                   	push   %ebp
  801fee:	89 e5                	mov    %esp,%ebp
  801ff0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ff3:	6a 00                	push   $0x0
  801ff5:	6a 00                	push   $0x0
  801ff7:	6a 00                	push   $0x0
  801ff9:	6a 00                	push   $0x0
  801ffb:	6a 00                	push   $0x0
  801ffd:	6a 2c                	push   $0x2c
  801fff:	e8 ac fa ff ff       	call   801ab0 <syscall>
  802004:	83 c4 18             	add    $0x18,%esp
  802007:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80200a:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80200e:	75 07                	jne    802017 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802010:	b8 01 00 00 00       	mov    $0x1,%eax
  802015:	eb 05                	jmp    80201c <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802017:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80201c:	c9                   	leave  
  80201d:	c3                   	ret    

0080201e <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80201e:	55                   	push   %ebp
  80201f:	89 e5                	mov    %esp,%ebp
  802021:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802024:	6a 00                	push   $0x0
  802026:	6a 00                	push   $0x0
  802028:	6a 00                	push   $0x0
  80202a:	6a 00                	push   $0x0
  80202c:	6a 00                	push   $0x0
  80202e:	6a 2c                	push   $0x2c
  802030:	e8 7b fa ff ff       	call   801ab0 <syscall>
  802035:	83 c4 18             	add    $0x18,%esp
  802038:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80203b:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80203f:	75 07                	jne    802048 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802041:	b8 01 00 00 00       	mov    $0x1,%eax
  802046:	eb 05                	jmp    80204d <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802048:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80204d:	c9                   	leave  
  80204e:	c3                   	ret    

0080204f <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80204f:	55                   	push   %ebp
  802050:	89 e5                	mov    %esp,%ebp
  802052:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802055:	6a 00                	push   $0x0
  802057:	6a 00                	push   $0x0
  802059:	6a 00                	push   $0x0
  80205b:	6a 00                	push   $0x0
  80205d:	6a 00                	push   $0x0
  80205f:	6a 2c                	push   $0x2c
  802061:	e8 4a fa ff ff       	call   801ab0 <syscall>
  802066:	83 c4 18             	add    $0x18,%esp
  802069:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80206c:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802070:	75 07                	jne    802079 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802072:	b8 01 00 00 00       	mov    $0x1,%eax
  802077:	eb 05                	jmp    80207e <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802079:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80207e:	c9                   	leave  
  80207f:	c3                   	ret    

00802080 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802080:	55                   	push   %ebp
  802081:	89 e5                	mov    %esp,%ebp
  802083:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802086:	6a 00                	push   $0x0
  802088:	6a 00                	push   $0x0
  80208a:	6a 00                	push   $0x0
  80208c:	6a 00                	push   $0x0
  80208e:	6a 00                	push   $0x0
  802090:	6a 2c                	push   $0x2c
  802092:	e8 19 fa ff ff       	call   801ab0 <syscall>
  802097:	83 c4 18             	add    $0x18,%esp
  80209a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80209d:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8020a1:	75 07                	jne    8020aa <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8020a3:	b8 01 00 00 00       	mov    $0x1,%eax
  8020a8:	eb 05                	jmp    8020af <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8020aa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020af:	c9                   	leave  
  8020b0:	c3                   	ret    

008020b1 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8020b1:	55                   	push   %ebp
  8020b2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8020b4:	6a 00                	push   $0x0
  8020b6:	6a 00                	push   $0x0
  8020b8:	6a 00                	push   $0x0
  8020ba:	6a 00                	push   $0x0
  8020bc:	ff 75 08             	pushl  0x8(%ebp)
  8020bf:	6a 2d                	push   $0x2d
  8020c1:	e8 ea f9 ff ff       	call   801ab0 <syscall>
  8020c6:	83 c4 18             	add    $0x18,%esp
	return ;
  8020c9:	90                   	nop
}
  8020ca:	c9                   	leave  
  8020cb:	c3                   	ret    

008020cc <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8020cc:	55                   	push   %ebp
  8020cd:	89 e5                	mov    %esp,%ebp
  8020cf:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8020d0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8020d3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8020d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020dc:	6a 00                	push   $0x0
  8020de:	53                   	push   %ebx
  8020df:	51                   	push   %ecx
  8020e0:	52                   	push   %edx
  8020e1:	50                   	push   %eax
  8020e2:	6a 2e                	push   $0x2e
  8020e4:	e8 c7 f9 ff ff       	call   801ab0 <syscall>
  8020e9:	83 c4 18             	add    $0x18,%esp
}
  8020ec:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020ef:	c9                   	leave  
  8020f0:	c3                   	ret    

008020f1 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8020f1:	55                   	push   %ebp
  8020f2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8020f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8020fa:	6a 00                	push   $0x0
  8020fc:	6a 00                	push   $0x0
  8020fe:	6a 00                	push   $0x0
  802100:	52                   	push   %edx
  802101:	50                   	push   %eax
  802102:	6a 2f                	push   $0x2f
  802104:	e8 a7 f9 ff ff       	call   801ab0 <syscall>
  802109:	83 c4 18             	add    $0x18,%esp
}
  80210c:	c9                   	leave  
  80210d:	c3                   	ret    

0080210e <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  80210e:	55                   	push   %ebp
  80210f:	89 e5                	mov    %esp,%ebp
  802111:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802114:	83 ec 0c             	sub    $0xc,%esp
  802117:	68 04 45 80 00       	push   $0x804504
  80211c:	e8 46 e8 ff ff       	call   800967 <cprintf>
  802121:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802124:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  80212b:	83 ec 0c             	sub    $0xc,%esp
  80212e:	68 30 45 80 00       	push   $0x804530
  802133:	e8 2f e8 ff ff       	call   800967 <cprintf>
  802138:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  80213b:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80213f:	a1 38 51 80 00       	mov    0x805138,%eax
  802144:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802147:	eb 56                	jmp    80219f <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802149:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80214d:	74 1c                	je     80216b <print_mem_block_lists+0x5d>
  80214f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802152:	8b 50 08             	mov    0x8(%eax),%edx
  802155:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802158:	8b 48 08             	mov    0x8(%eax),%ecx
  80215b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80215e:	8b 40 0c             	mov    0xc(%eax),%eax
  802161:	01 c8                	add    %ecx,%eax
  802163:	39 c2                	cmp    %eax,%edx
  802165:	73 04                	jae    80216b <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802167:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80216b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80216e:	8b 50 08             	mov    0x8(%eax),%edx
  802171:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802174:	8b 40 0c             	mov    0xc(%eax),%eax
  802177:	01 c2                	add    %eax,%edx
  802179:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80217c:	8b 40 08             	mov    0x8(%eax),%eax
  80217f:	83 ec 04             	sub    $0x4,%esp
  802182:	52                   	push   %edx
  802183:	50                   	push   %eax
  802184:	68 45 45 80 00       	push   $0x804545
  802189:	e8 d9 e7 ff ff       	call   800967 <cprintf>
  80218e:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802191:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802194:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802197:	a1 40 51 80 00       	mov    0x805140,%eax
  80219c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80219f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021a3:	74 07                	je     8021ac <print_mem_block_lists+0x9e>
  8021a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a8:	8b 00                	mov    (%eax),%eax
  8021aa:	eb 05                	jmp    8021b1 <print_mem_block_lists+0xa3>
  8021ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8021b1:	a3 40 51 80 00       	mov    %eax,0x805140
  8021b6:	a1 40 51 80 00       	mov    0x805140,%eax
  8021bb:	85 c0                	test   %eax,%eax
  8021bd:	75 8a                	jne    802149 <print_mem_block_lists+0x3b>
  8021bf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021c3:	75 84                	jne    802149 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8021c5:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8021c9:	75 10                	jne    8021db <print_mem_block_lists+0xcd>
  8021cb:	83 ec 0c             	sub    $0xc,%esp
  8021ce:	68 54 45 80 00       	push   $0x804554
  8021d3:	e8 8f e7 ff ff       	call   800967 <cprintf>
  8021d8:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8021db:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8021e2:	83 ec 0c             	sub    $0xc,%esp
  8021e5:	68 78 45 80 00       	push   $0x804578
  8021ea:	e8 78 e7 ff ff       	call   800967 <cprintf>
  8021ef:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8021f2:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8021f6:	a1 40 50 80 00       	mov    0x805040,%eax
  8021fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021fe:	eb 56                	jmp    802256 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802200:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802204:	74 1c                	je     802222 <print_mem_block_lists+0x114>
  802206:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802209:	8b 50 08             	mov    0x8(%eax),%edx
  80220c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80220f:	8b 48 08             	mov    0x8(%eax),%ecx
  802212:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802215:	8b 40 0c             	mov    0xc(%eax),%eax
  802218:	01 c8                	add    %ecx,%eax
  80221a:	39 c2                	cmp    %eax,%edx
  80221c:	73 04                	jae    802222 <print_mem_block_lists+0x114>
			sorted = 0 ;
  80221e:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802222:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802225:	8b 50 08             	mov    0x8(%eax),%edx
  802228:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80222b:	8b 40 0c             	mov    0xc(%eax),%eax
  80222e:	01 c2                	add    %eax,%edx
  802230:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802233:	8b 40 08             	mov    0x8(%eax),%eax
  802236:	83 ec 04             	sub    $0x4,%esp
  802239:	52                   	push   %edx
  80223a:	50                   	push   %eax
  80223b:	68 45 45 80 00       	push   $0x804545
  802240:	e8 22 e7 ff ff       	call   800967 <cprintf>
  802245:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802248:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80224b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80224e:	a1 48 50 80 00       	mov    0x805048,%eax
  802253:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802256:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80225a:	74 07                	je     802263 <print_mem_block_lists+0x155>
  80225c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80225f:	8b 00                	mov    (%eax),%eax
  802261:	eb 05                	jmp    802268 <print_mem_block_lists+0x15a>
  802263:	b8 00 00 00 00       	mov    $0x0,%eax
  802268:	a3 48 50 80 00       	mov    %eax,0x805048
  80226d:	a1 48 50 80 00       	mov    0x805048,%eax
  802272:	85 c0                	test   %eax,%eax
  802274:	75 8a                	jne    802200 <print_mem_block_lists+0xf2>
  802276:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80227a:	75 84                	jne    802200 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  80227c:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802280:	75 10                	jne    802292 <print_mem_block_lists+0x184>
  802282:	83 ec 0c             	sub    $0xc,%esp
  802285:	68 90 45 80 00       	push   $0x804590
  80228a:	e8 d8 e6 ff ff       	call   800967 <cprintf>
  80228f:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802292:	83 ec 0c             	sub    $0xc,%esp
  802295:	68 04 45 80 00       	push   $0x804504
  80229a:	e8 c8 e6 ff ff       	call   800967 <cprintf>
  80229f:	83 c4 10             	add    $0x10,%esp

}
  8022a2:	90                   	nop
  8022a3:	c9                   	leave  
  8022a4:	c3                   	ret    

008022a5 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8022a5:	55                   	push   %ebp
  8022a6:	89 e5                	mov    %esp,%ebp
  8022a8:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  8022ab:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  8022b2:	00 00 00 
  8022b5:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  8022bc:	00 00 00 
  8022bf:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  8022c6:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  8022c9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8022d0:	e9 9e 00 00 00       	jmp    802373 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  8022d5:	a1 50 50 80 00       	mov    0x805050,%eax
  8022da:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022dd:	c1 e2 04             	shl    $0x4,%edx
  8022e0:	01 d0                	add    %edx,%eax
  8022e2:	85 c0                	test   %eax,%eax
  8022e4:	75 14                	jne    8022fa <initialize_MemBlocksList+0x55>
  8022e6:	83 ec 04             	sub    $0x4,%esp
  8022e9:	68 b8 45 80 00       	push   $0x8045b8
  8022ee:	6a 46                	push   $0x46
  8022f0:	68 db 45 80 00       	push   $0x8045db
  8022f5:	e8 b9 e3 ff ff       	call   8006b3 <_panic>
  8022fa:	a1 50 50 80 00       	mov    0x805050,%eax
  8022ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802302:	c1 e2 04             	shl    $0x4,%edx
  802305:	01 d0                	add    %edx,%eax
  802307:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80230d:	89 10                	mov    %edx,(%eax)
  80230f:	8b 00                	mov    (%eax),%eax
  802311:	85 c0                	test   %eax,%eax
  802313:	74 18                	je     80232d <initialize_MemBlocksList+0x88>
  802315:	a1 48 51 80 00       	mov    0x805148,%eax
  80231a:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802320:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802323:	c1 e1 04             	shl    $0x4,%ecx
  802326:	01 ca                	add    %ecx,%edx
  802328:	89 50 04             	mov    %edx,0x4(%eax)
  80232b:	eb 12                	jmp    80233f <initialize_MemBlocksList+0x9a>
  80232d:	a1 50 50 80 00       	mov    0x805050,%eax
  802332:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802335:	c1 e2 04             	shl    $0x4,%edx
  802338:	01 d0                	add    %edx,%eax
  80233a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80233f:	a1 50 50 80 00       	mov    0x805050,%eax
  802344:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802347:	c1 e2 04             	shl    $0x4,%edx
  80234a:	01 d0                	add    %edx,%eax
  80234c:	a3 48 51 80 00       	mov    %eax,0x805148
  802351:	a1 50 50 80 00       	mov    0x805050,%eax
  802356:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802359:	c1 e2 04             	shl    $0x4,%edx
  80235c:	01 d0                	add    %edx,%eax
  80235e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802365:	a1 54 51 80 00       	mov    0x805154,%eax
  80236a:	40                   	inc    %eax
  80236b:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  802370:	ff 45 f4             	incl   -0xc(%ebp)
  802373:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802376:	3b 45 08             	cmp    0x8(%ebp),%eax
  802379:	0f 82 56 ff ff ff    	jb     8022d5 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  80237f:	90                   	nop
  802380:	c9                   	leave  
  802381:	c3                   	ret    

00802382 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802382:	55                   	push   %ebp
  802383:	89 e5                	mov    %esp,%ebp
  802385:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802388:	8b 45 08             	mov    0x8(%ebp),%eax
  80238b:	8b 00                	mov    (%eax),%eax
  80238d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802390:	eb 19                	jmp    8023ab <find_block+0x29>
	{
		if(va==point->sva)
  802392:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802395:	8b 40 08             	mov    0x8(%eax),%eax
  802398:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80239b:	75 05                	jne    8023a2 <find_block+0x20>
		   return point;
  80239d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8023a0:	eb 36                	jmp    8023d8 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8023a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a5:	8b 40 08             	mov    0x8(%eax),%eax
  8023a8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8023ab:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8023af:	74 07                	je     8023b8 <find_block+0x36>
  8023b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8023b4:	8b 00                	mov    (%eax),%eax
  8023b6:	eb 05                	jmp    8023bd <find_block+0x3b>
  8023b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8023bd:	8b 55 08             	mov    0x8(%ebp),%edx
  8023c0:	89 42 08             	mov    %eax,0x8(%edx)
  8023c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c6:	8b 40 08             	mov    0x8(%eax),%eax
  8023c9:	85 c0                	test   %eax,%eax
  8023cb:	75 c5                	jne    802392 <find_block+0x10>
  8023cd:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8023d1:	75 bf                	jne    802392 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  8023d3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023d8:	c9                   	leave  
  8023d9:	c3                   	ret    

008023da <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8023da:	55                   	push   %ebp
  8023db:	89 e5                	mov    %esp,%ebp
  8023dd:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  8023e0:	a1 40 50 80 00       	mov    0x805040,%eax
  8023e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  8023e8:	a1 44 50 80 00       	mov    0x805044,%eax
  8023ed:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  8023f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023f3:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8023f6:	74 24                	je     80241c <insert_sorted_allocList+0x42>
  8023f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023fb:	8b 50 08             	mov    0x8(%eax),%edx
  8023fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802401:	8b 40 08             	mov    0x8(%eax),%eax
  802404:	39 c2                	cmp    %eax,%edx
  802406:	76 14                	jbe    80241c <insert_sorted_allocList+0x42>
  802408:	8b 45 08             	mov    0x8(%ebp),%eax
  80240b:	8b 50 08             	mov    0x8(%eax),%edx
  80240e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802411:	8b 40 08             	mov    0x8(%eax),%eax
  802414:	39 c2                	cmp    %eax,%edx
  802416:	0f 82 60 01 00 00    	jb     80257c <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  80241c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802420:	75 65                	jne    802487 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802422:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802426:	75 14                	jne    80243c <insert_sorted_allocList+0x62>
  802428:	83 ec 04             	sub    $0x4,%esp
  80242b:	68 b8 45 80 00       	push   $0x8045b8
  802430:	6a 6b                	push   $0x6b
  802432:	68 db 45 80 00       	push   $0x8045db
  802437:	e8 77 e2 ff ff       	call   8006b3 <_panic>
  80243c:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802442:	8b 45 08             	mov    0x8(%ebp),%eax
  802445:	89 10                	mov    %edx,(%eax)
  802447:	8b 45 08             	mov    0x8(%ebp),%eax
  80244a:	8b 00                	mov    (%eax),%eax
  80244c:	85 c0                	test   %eax,%eax
  80244e:	74 0d                	je     80245d <insert_sorted_allocList+0x83>
  802450:	a1 40 50 80 00       	mov    0x805040,%eax
  802455:	8b 55 08             	mov    0x8(%ebp),%edx
  802458:	89 50 04             	mov    %edx,0x4(%eax)
  80245b:	eb 08                	jmp    802465 <insert_sorted_allocList+0x8b>
  80245d:	8b 45 08             	mov    0x8(%ebp),%eax
  802460:	a3 44 50 80 00       	mov    %eax,0x805044
  802465:	8b 45 08             	mov    0x8(%ebp),%eax
  802468:	a3 40 50 80 00       	mov    %eax,0x805040
  80246d:	8b 45 08             	mov    0x8(%ebp),%eax
  802470:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802477:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80247c:	40                   	inc    %eax
  80247d:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802482:	e9 dc 01 00 00       	jmp    802663 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802487:	8b 45 08             	mov    0x8(%ebp),%eax
  80248a:	8b 50 08             	mov    0x8(%eax),%edx
  80248d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802490:	8b 40 08             	mov    0x8(%eax),%eax
  802493:	39 c2                	cmp    %eax,%edx
  802495:	77 6c                	ja     802503 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802497:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80249b:	74 06                	je     8024a3 <insert_sorted_allocList+0xc9>
  80249d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8024a1:	75 14                	jne    8024b7 <insert_sorted_allocList+0xdd>
  8024a3:	83 ec 04             	sub    $0x4,%esp
  8024a6:	68 f4 45 80 00       	push   $0x8045f4
  8024ab:	6a 6f                	push   $0x6f
  8024ad:	68 db 45 80 00       	push   $0x8045db
  8024b2:	e8 fc e1 ff ff       	call   8006b3 <_panic>
  8024b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024ba:	8b 50 04             	mov    0x4(%eax),%edx
  8024bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c0:	89 50 04             	mov    %edx,0x4(%eax)
  8024c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024c9:	89 10                	mov    %edx,(%eax)
  8024cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024ce:	8b 40 04             	mov    0x4(%eax),%eax
  8024d1:	85 c0                	test   %eax,%eax
  8024d3:	74 0d                	je     8024e2 <insert_sorted_allocList+0x108>
  8024d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024d8:	8b 40 04             	mov    0x4(%eax),%eax
  8024db:	8b 55 08             	mov    0x8(%ebp),%edx
  8024de:	89 10                	mov    %edx,(%eax)
  8024e0:	eb 08                	jmp    8024ea <insert_sorted_allocList+0x110>
  8024e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e5:	a3 40 50 80 00       	mov    %eax,0x805040
  8024ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024ed:	8b 55 08             	mov    0x8(%ebp),%edx
  8024f0:	89 50 04             	mov    %edx,0x4(%eax)
  8024f3:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8024f8:	40                   	inc    %eax
  8024f9:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8024fe:	e9 60 01 00 00       	jmp    802663 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802503:	8b 45 08             	mov    0x8(%ebp),%eax
  802506:	8b 50 08             	mov    0x8(%eax),%edx
  802509:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80250c:	8b 40 08             	mov    0x8(%eax),%eax
  80250f:	39 c2                	cmp    %eax,%edx
  802511:	0f 82 4c 01 00 00    	jb     802663 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802517:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80251b:	75 14                	jne    802531 <insert_sorted_allocList+0x157>
  80251d:	83 ec 04             	sub    $0x4,%esp
  802520:	68 2c 46 80 00       	push   $0x80462c
  802525:	6a 73                	push   $0x73
  802527:	68 db 45 80 00       	push   $0x8045db
  80252c:	e8 82 e1 ff ff       	call   8006b3 <_panic>
  802531:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802537:	8b 45 08             	mov    0x8(%ebp),%eax
  80253a:	89 50 04             	mov    %edx,0x4(%eax)
  80253d:	8b 45 08             	mov    0x8(%ebp),%eax
  802540:	8b 40 04             	mov    0x4(%eax),%eax
  802543:	85 c0                	test   %eax,%eax
  802545:	74 0c                	je     802553 <insert_sorted_allocList+0x179>
  802547:	a1 44 50 80 00       	mov    0x805044,%eax
  80254c:	8b 55 08             	mov    0x8(%ebp),%edx
  80254f:	89 10                	mov    %edx,(%eax)
  802551:	eb 08                	jmp    80255b <insert_sorted_allocList+0x181>
  802553:	8b 45 08             	mov    0x8(%ebp),%eax
  802556:	a3 40 50 80 00       	mov    %eax,0x805040
  80255b:	8b 45 08             	mov    0x8(%ebp),%eax
  80255e:	a3 44 50 80 00       	mov    %eax,0x805044
  802563:	8b 45 08             	mov    0x8(%ebp),%eax
  802566:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80256c:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802571:	40                   	inc    %eax
  802572:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802577:	e9 e7 00 00 00       	jmp    802663 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  80257c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80257f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802582:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802589:	a1 40 50 80 00       	mov    0x805040,%eax
  80258e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802591:	e9 9d 00 00 00       	jmp    802633 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802596:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802599:	8b 00                	mov    (%eax),%eax
  80259b:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  80259e:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a1:	8b 50 08             	mov    0x8(%eax),%edx
  8025a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a7:	8b 40 08             	mov    0x8(%eax),%eax
  8025aa:	39 c2                	cmp    %eax,%edx
  8025ac:	76 7d                	jbe    80262b <insert_sorted_allocList+0x251>
  8025ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b1:	8b 50 08             	mov    0x8(%eax),%edx
  8025b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8025b7:	8b 40 08             	mov    0x8(%eax),%eax
  8025ba:	39 c2                	cmp    %eax,%edx
  8025bc:	73 6d                	jae    80262b <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  8025be:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025c2:	74 06                	je     8025ca <insert_sorted_allocList+0x1f0>
  8025c4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8025c8:	75 14                	jne    8025de <insert_sorted_allocList+0x204>
  8025ca:	83 ec 04             	sub    $0x4,%esp
  8025cd:	68 50 46 80 00       	push   $0x804650
  8025d2:	6a 7f                	push   $0x7f
  8025d4:	68 db 45 80 00       	push   $0x8045db
  8025d9:	e8 d5 e0 ff ff       	call   8006b3 <_panic>
  8025de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e1:	8b 10                	mov    (%eax),%edx
  8025e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8025e6:	89 10                	mov    %edx,(%eax)
  8025e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8025eb:	8b 00                	mov    (%eax),%eax
  8025ed:	85 c0                	test   %eax,%eax
  8025ef:	74 0b                	je     8025fc <insert_sorted_allocList+0x222>
  8025f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f4:	8b 00                	mov    (%eax),%eax
  8025f6:	8b 55 08             	mov    0x8(%ebp),%edx
  8025f9:	89 50 04             	mov    %edx,0x4(%eax)
  8025fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ff:	8b 55 08             	mov    0x8(%ebp),%edx
  802602:	89 10                	mov    %edx,(%eax)
  802604:	8b 45 08             	mov    0x8(%ebp),%eax
  802607:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80260a:	89 50 04             	mov    %edx,0x4(%eax)
  80260d:	8b 45 08             	mov    0x8(%ebp),%eax
  802610:	8b 00                	mov    (%eax),%eax
  802612:	85 c0                	test   %eax,%eax
  802614:	75 08                	jne    80261e <insert_sorted_allocList+0x244>
  802616:	8b 45 08             	mov    0x8(%ebp),%eax
  802619:	a3 44 50 80 00       	mov    %eax,0x805044
  80261e:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802623:	40                   	inc    %eax
  802624:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802629:	eb 39                	jmp    802664 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80262b:	a1 48 50 80 00       	mov    0x805048,%eax
  802630:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802633:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802637:	74 07                	je     802640 <insert_sorted_allocList+0x266>
  802639:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263c:	8b 00                	mov    (%eax),%eax
  80263e:	eb 05                	jmp    802645 <insert_sorted_allocList+0x26b>
  802640:	b8 00 00 00 00       	mov    $0x0,%eax
  802645:	a3 48 50 80 00       	mov    %eax,0x805048
  80264a:	a1 48 50 80 00       	mov    0x805048,%eax
  80264f:	85 c0                	test   %eax,%eax
  802651:	0f 85 3f ff ff ff    	jne    802596 <insert_sorted_allocList+0x1bc>
  802657:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80265b:	0f 85 35 ff ff ff    	jne    802596 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802661:	eb 01                	jmp    802664 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802663:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802664:	90                   	nop
  802665:	c9                   	leave  
  802666:	c3                   	ret    

00802667 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802667:	55                   	push   %ebp
  802668:	89 e5                	mov    %esp,%ebp
  80266a:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  80266d:	a1 38 51 80 00       	mov    0x805138,%eax
  802672:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802675:	e9 85 01 00 00       	jmp    8027ff <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  80267a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267d:	8b 40 0c             	mov    0xc(%eax),%eax
  802680:	3b 45 08             	cmp    0x8(%ebp),%eax
  802683:	0f 82 6e 01 00 00    	jb     8027f7 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802689:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268c:	8b 40 0c             	mov    0xc(%eax),%eax
  80268f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802692:	0f 85 8a 00 00 00    	jne    802722 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802698:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80269c:	75 17                	jne    8026b5 <alloc_block_FF+0x4e>
  80269e:	83 ec 04             	sub    $0x4,%esp
  8026a1:	68 84 46 80 00       	push   $0x804684
  8026a6:	68 93 00 00 00       	push   $0x93
  8026ab:	68 db 45 80 00       	push   $0x8045db
  8026b0:	e8 fe df ff ff       	call   8006b3 <_panic>
  8026b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b8:	8b 00                	mov    (%eax),%eax
  8026ba:	85 c0                	test   %eax,%eax
  8026bc:	74 10                	je     8026ce <alloc_block_FF+0x67>
  8026be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c1:	8b 00                	mov    (%eax),%eax
  8026c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026c6:	8b 52 04             	mov    0x4(%edx),%edx
  8026c9:	89 50 04             	mov    %edx,0x4(%eax)
  8026cc:	eb 0b                	jmp    8026d9 <alloc_block_FF+0x72>
  8026ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d1:	8b 40 04             	mov    0x4(%eax),%eax
  8026d4:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8026d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026dc:	8b 40 04             	mov    0x4(%eax),%eax
  8026df:	85 c0                	test   %eax,%eax
  8026e1:	74 0f                	je     8026f2 <alloc_block_FF+0x8b>
  8026e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e6:	8b 40 04             	mov    0x4(%eax),%eax
  8026e9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026ec:	8b 12                	mov    (%edx),%edx
  8026ee:	89 10                	mov    %edx,(%eax)
  8026f0:	eb 0a                	jmp    8026fc <alloc_block_FF+0x95>
  8026f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f5:	8b 00                	mov    (%eax),%eax
  8026f7:	a3 38 51 80 00       	mov    %eax,0x805138
  8026fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ff:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802705:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802708:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80270f:	a1 44 51 80 00       	mov    0x805144,%eax
  802714:	48                   	dec    %eax
  802715:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  80271a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271d:	e9 10 01 00 00       	jmp    802832 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802722:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802725:	8b 40 0c             	mov    0xc(%eax),%eax
  802728:	3b 45 08             	cmp    0x8(%ebp),%eax
  80272b:	0f 86 c6 00 00 00    	jbe    8027f7 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802731:	a1 48 51 80 00       	mov    0x805148,%eax
  802736:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802739:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273c:	8b 50 08             	mov    0x8(%eax),%edx
  80273f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802742:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802745:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802748:	8b 55 08             	mov    0x8(%ebp),%edx
  80274b:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80274e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802752:	75 17                	jne    80276b <alloc_block_FF+0x104>
  802754:	83 ec 04             	sub    $0x4,%esp
  802757:	68 84 46 80 00       	push   $0x804684
  80275c:	68 9b 00 00 00       	push   $0x9b
  802761:	68 db 45 80 00       	push   $0x8045db
  802766:	e8 48 df ff ff       	call   8006b3 <_panic>
  80276b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80276e:	8b 00                	mov    (%eax),%eax
  802770:	85 c0                	test   %eax,%eax
  802772:	74 10                	je     802784 <alloc_block_FF+0x11d>
  802774:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802777:	8b 00                	mov    (%eax),%eax
  802779:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80277c:	8b 52 04             	mov    0x4(%edx),%edx
  80277f:	89 50 04             	mov    %edx,0x4(%eax)
  802782:	eb 0b                	jmp    80278f <alloc_block_FF+0x128>
  802784:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802787:	8b 40 04             	mov    0x4(%eax),%eax
  80278a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80278f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802792:	8b 40 04             	mov    0x4(%eax),%eax
  802795:	85 c0                	test   %eax,%eax
  802797:	74 0f                	je     8027a8 <alloc_block_FF+0x141>
  802799:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80279c:	8b 40 04             	mov    0x4(%eax),%eax
  80279f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027a2:	8b 12                	mov    (%edx),%edx
  8027a4:	89 10                	mov    %edx,(%eax)
  8027a6:	eb 0a                	jmp    8027b2 <alloc_block_FF+0x14b>
  8027a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027ab:	8b 00                	mov    (%eax),%eax
  8027ad:	a3 48 51 80 00       	mov    %eax,0x805148
  8027b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027b5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027be:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027c5:	a1 54 51 80 00       	mov    0x805154,%eax
  8027ca:	48                   	dec    %eax
  8027cb:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  8027d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d3:	8b 50 08             	mov    0x8(%eax),%edx
  8027d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8027d9:	01 c2                	add    %eax,%edx
  8027db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027de:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  8027e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e4:	8b 40 0c             	mov    0xc(%eax),%eax
  8027e7:	2b 45 08             	sub    0x8(%ebp),%eax
  8027ea:	89 c2                	mov    %eax,%edx
  8027ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ef:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  8027f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027f5:	eb 3b                	jmp    802832 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8027f7:	a1 40 51 80 00       	mov    0x805140,%eax
  8027fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802803:	74 07                	je     80280c <alloc_block_FF+0x1a5>
  802805:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802808:	8b 00                	mov    (%eax),%eax
  80280a:	eb 05                	jmp    802811 <alloc_block_FF+0x1aa>
  80280c:	b8 00 00 00 00       	mov    $0x0,%eax
  802811:	a3 40 51 80 00       	mov    %eax,0x805140
  802816:	a1 40 51 80 00       	mov    0x805140,%eax
  80281b:	85 c0                	test   %eax,%eax
  80281d:	0f 85 57 fe ff ff    	jne    80267a <alloc_block_FF+0x13>
  802823:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802827:	0f 85 4d fe ff ff    	jne    80267a <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  80282d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802832:	c9                   	leave  
  802833:	c3                   	ret    

00802834 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802834:	55                   	push   %ebp
  802835:	89 e5                	mov    %esp,%ebp
  802837:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  80283a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802841:	a1 38 51 80 00       	mov    0x805138,%eax
  802846:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802849:	e9 df 00 00 00       	jmp    80292d <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  80284e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802851:	8b 40 0c             	mov    0xc(%eax),%eax
  802854:	3b 45 08             	cmp    0x8(%ebp),%eax
  802857:	0f 82 c8 00 00 00    	jb     802925 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  80285d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802860:	8b 40 0c             	mov    0xc(%eax),%eax
  802863:	3b 45 08             	cmp    0x8(%ebp),%eax
  802866:	0f 85 8a 00 00 00    	jne    8028f6 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  80286c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802870:	75 17                	jne    802889 <alloc_block_BF+0x55>
  802872:	83 ec 04             	sub    $0x4,%esp
  802875:	68 84 46 80 00       	push   $0x804684
  80287a:	68 b7 00 00 00       	push   $0xb7
  80287f:	68 db 45 80 00       	push   $0x8045db
  802884:	e8 2a de ff ff       	call   8006b3 <_panic>
  802889:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288c:	8b 00                	mov    (%eax),%eax
  80288e:	85 c0                	test   %eax,%eax
  802890:	74 10                	je     8028a2 <alloc_block_BF+0x6e>
  802892:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802895:	8b 00                	mov    (%eax),%eax
  802897:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80289a:	8b 52 04             	mov    0x4(%edx),%edx
  80289d:	89 50 04             	mov    %edx,0x4(%eax)
  8028a0:	eb 0b                	jmp    8028ad <alloc_block_BF+0x79>
  8028a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a5:	8b 40 04             	mov    0x4(%eax),%eax
  8028a8:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8028ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b0:	8b 40 04             	mov    0x4(%eax),%eax
  8028b3:	85 c0                	test   %eax,%eax
  8028b5:	74 0f                	je     8028c6 <alloc_block_BF+0x92>
  8028b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ba:	8b 40 04             	mov    0x4(%eax),%eax
  8028bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028c0:	8b 12                	mov    (%edx),%edx
  8028c2:	89 10                	mov    %edx,(%eax)
  8028c4:	eb 0a                	jmp    8028d0 <alloc_block_BF+0x9c>
  8028c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c9:	8b 00                	mov    (%eax),%eax
  8028cb:	a3 38 51 80 00       	mov    %eax,0x805138
  8028d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028dc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028e3:	a1 44 51 80 00       	mov    0x805144,%eax
  8028e8:	48                   	dec    %eax
  8028e9:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  8028ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f1:	e9 4d 01 00 00       	jmp    802a43 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  8028f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f9:	8b 40 0c             	mov    0xc(%eax),%eax
  8028fc:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028ff:	76 24                	jbe    802925 <alloc_block_BF+0xf1>
  802901:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802904:	8b 40 0c             	mov    0xc(%eax),%eax
  802907:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80290a:	73 19                	jae    802925 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  80290c:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802913:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802916:	8b 40 0c             	mov    0xc(%eax),%eax
  802919:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  80291c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291f:	8b 40 08             	mov    0x8(%eax),%eax
  802922:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802925:	a1 40 51 80 00       	mov    0x805140,%eax
  80292a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80292d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802931:	74 07                	je     80293a <alloc_block_BF+0x106>
  802933:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802936:	8b 00                	mov    (%eax),%eax
  802938:	eb 05                	jmp    80293f <alloc_block_BF+0x10b>
  80293a:	b8 00 00 00 00       	mov    $0x0,%eax
  80293f:	a3 40 51 80 00       	mov    %eax,0x805140
  802944:	a1 40 51 80 00       	mov    0x805140,%eax
  802949:	85 c0                	test   %eax,%eax
  80294b:	0f 85 fd fe ff ff    	jne    80284e <alloc_block_BF+0x1a>
  802951:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802955:	0f 85 f3 fe ff ff    	jne    80284e <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  80295b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80295f:	0f 84 d9 00 00 00    	je     802a3e <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802965:	a1 48 51 80 00       	mov    0x805148,%eax
  80296a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  80296d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802970:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802973:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802976:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802979:	8b 55 08             	mov    0x8(%ebp),%edx
  80297c:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  80297f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802983:	75 17                	jne    80299c <alloc_block_BF+0x168>
  802985:	83 ec 04             	sub    $0x4,%esp
  802988:	68 84 46 80 00       	push   $0x804684
  80298d:	68 c7 00 00 00       	push   $0xc7
  802992:	68 db 45 80 00       	push   $0x8045db
  802997:	e8 17 dd ff ff       	call   8006b3 <_panic>
  80299c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80299f:	8b 00                	mov    (%eax),%eax
  8029a1:	85 c0                	test   %eax,%eax
  8029a3:	74 10                	je     8029b5 <alloc_block_BF+0x181>
  8029a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029a8:	8b 00                	mov    (%eax),%eax
  8029aa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8029ad:	8b 52 04             	mov    0x4(%edx),%edx
  8029b0:	89 50 04             	mov    %edx,0x4(%eax)
  8029b3:	eb 0b                	jmp    8029c0 <alloc_block_BF+0x18c>
  8029b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029b8:	8b 40 04             	mov    0x4(%eax),%eax
  8029bb:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8029c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029c3:	8b 40 04             	mov    0x4(%eax),%eax
  8029c6:	85 c0                	test   %eax,%eax
  8029c8:	74 0f                	je     8029d9 <alloc_block_BF+0x1a5>
  8029ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029cd:	8b 40 04             	mov    0x4(%eax),%eax
  8029d0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8029d3:	8b 12                	mov    (%edx),%edx
  8029d5:	89 10                	mov    %edx,(%eax)
  8029d7:	eb 0a                	jmp    8029e3 <alloc_block_BF+0x1af>
  8029d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029dc:	8b 00                	mov    (%eax),%eax
  8029de:	a3 48 51 80 00       	mov    %eax,0x805148
  8029e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029e6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029ef:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029f6:	a1 54 51 80 00       	mov    0x805154,%eax
  8029fb:	48                   	dec    %eax
  8029fc:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802a01:	83 ec 08             	sub    $0x8,%esp
  802a04:	ff 75 ec             	pushl  -0x14(%ebp)
  802a07:	68 38 51 80 00       	push   $0x805138
  802a0c:	e8 71 f9 ff ff       	call   802382 <find_block>
  802a11:	83 c4 10             	add    $0x10,%esp
  802a14:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802a17:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a1a:	8b 50 08             	mov    0x8(%eax),%edx
  802a1d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a20:	01 c2                	add    %eax,%edx
  802a22:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a25:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802a28:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a2b:	8b 40 0c             	mov    0xc(%eax),%eax
  802a2e:	2b 45 08             	sub    0x8(%ebp),%eax
  802a31:	89 c2                	mov    %eax,%edx
  802a33:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a36:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802a39:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a3c:	eb 05                	jmp    802a43 <alloc_block_BF+0x20f>
	}
	return NULL;
  802a3e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a43:	c9                   	leave  
  802a44:	c3                   	ret    

00802a45 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802a45:	55                   	push   %ebp
  802a46:	89 e5                	mov    %esp,%ebp
  802a48:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802a4b:	a1 28 50 80 00       	mov    0x805028,%eax
  802a50:	85 c0                	test   %eax,%eax
  802a52:	0f 85 de 01 00 00    	jne    802c36 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802a58:	a1 38 51 80 00       	mov    0x805138,%eax
  802a5d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a60:	e9 9e 01 00 00       	jmp    802c03 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802a65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a68:	8b 40 0c             	mov    0xc(%eax),%eax
  802a6b:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a6e:	0f 82 87 01 00 00    	jb     802bfb <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802a74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a77:	8b 40 0c             	mov    0xc(%eax),%eax
  802a7a:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a7d:	0f 85 95 00 00 00    	jne    802b18 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802a83:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a87:	75 17                	jne    802aa0 <alloc_block_NF+0x5b>
  802a89:	83 ec 04             	sub    $0x4,%esp
  802a8c:	68 84 46 80 00       	push   $0x804684
  802a91:	68 e0 00 00 00       	push   $0xe0
  802a96:	68 db 45 80 00       	push   $0x8045db
  802a9b:	e8 13 dc ff ff       	call   8006b3 <_panic>
  802aa0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa3:	8b 00                	mov    (%eax),%eax
  802aa5:	85 c0                	test   %eax,%eax
  802aa7:	74 10                	je     802ab9 <alloc_block_NF+0x74>
  802aa9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aac:	8b 00                	mov    (%eax),%eax
  802aae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ab1:	8b 52 04             	mov    0x4(%edx),%edx
  802ab4:	89 50 04             	mov    %edx,0x4(%eax)
  802ab7:	eb 0b                	jmp    802ac4 <alloc_block_NF+0x7f>
  802ab9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802abc:	8b 40 04             	mov    0x4(%eax),%eax
  802abf:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ac4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac7:	8b 40 04             	mov    0x4(%eax),%eax
  802aca:	85 c0                	test   %eax,%eax
  802acc:	74 0f                	je     802add <alloc_block_NF+0x98>
  802ace:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad1:	8b 40 04             	mov    0x4(%eax),%eax
  802ad4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ad7:	8b 12                	mov    (%edx),%edx
  802ad9:	89 10                	mov    %edx,(%eax)
  802adb:	eb 0a                	jmp    802ae7 <alloc_block_NF+0xa2>
  802add:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae0:	8b 00                	mov    (%eax),%eax
  802ae2:	a3 38 51 80 00       	mov    %eax,0x805138
  802ae7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aea:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802af0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802afa:	a1 44 51 80 00       	mov    0x805144,%eax
  802aff:	48                   	dec    %eax
  802b00:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802b05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b08:	8b 40 08             	mov    0x8(%eax),%eax
  802b0b:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  802b10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b13:	e9 f8 04 00 00       	jmp    803010 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802b18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1b:	8b 40 0c             	mov    0xc(%eax),%eax
  802b1e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b21:	0f 86 d4 00 00 00    	jbe    802bfb <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802b27:	a1 48 51 80 00       	mov    0x805148,%eax
  802b2c:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802b2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b32:	8b 50 08             	mov    0x8(%eax),%edx
  802b35:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b38:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802b3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b3e:	8b 55 08             	mov    0x8(%ebp),%edx
  802b41:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802b44:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b48:	75 17                	jne    802b61 <alloc_block_NF+0x11c>
  802b4a:	83 ec 04             	sub    $0x4,%esp
  802b4d:	68 84 46 80 00       	push   $0x804684
  802b52:	68 e9 00 00 00       	push   $0xe9
  802b57:	68 db 45 80 00       	push   $0x8045db
  802b5c:	e8 52 db ff ff       	call   8006b3 <_panic>
  802b61:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b64:	8b 00                	mov    (%eax),%eax
  802b66:	85 c0                	test   %eax,%eax
  802b68:	74 10                	je     802b7a <alloc_block_NF+0x135>
  802b6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b6d:	8b 00                	mov    (%eax),%eax
  802b6f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b72:	8b 52 04             	mov    0x4(%edx),%edx
  802b75:	89 50 04             	mov    %edx,0x4(%eax)
  802b78:	eb 0b                	jmp    802b85 <alloc_block_NF+0x140>
  802b7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b7d:	8b 40 04             	mov    0x4(%eax),%eax
  802b80:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b88:	8b 40 04             	mov    0x4(%eax),%eax
  802b8b:	85 c0                	test   %eax,%eax
  802b8d:	74 0f                	je     802b9e <alloc_block_NF+0x159>
  802b8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b92:	8b 40 04             	mov    0x4(%eax),%eax
  802b95:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b98:	8b 12                	mov    (%edx),%edx
  802b9a:	89 10                	mov    %edx,(%eax)
  802b9c:	eb 0a                	jmp    802ba8 <alloc_block_NF+0x163>
  802b9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ba1:	8b 00                	mov    (%eax),%eax
  802ba3:	a3 48 51 80 00       	mov    %eax,0x805148
  802ba8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bab:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bb1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bb4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bbb:	a1 54 51 80 00       	mov    0x805154,%eax
  802bc0:	48                   	dec    %eax
  802bc1:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802bc6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bc9:	8b 40 08             	mov    0x8(%eax),%eax
  802bcc:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802bd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd4:	8b 50 08             	mov    0x8(%eax),%edx
  802bd7:	8b 45 08             	mov    0x8(%ebp),%eax
  802bda:	01 c2                	add    %eax,%edx
  802bdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bdf:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802be2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be5:	8b 40 0c             	mov    0xc(%eax),%eax
  802be8:	2b 45 08             	sub    0x8(%ebp),%eax
  802beb:	89 c2                	mov    %eax,%edx
  802bed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf0:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802bf3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bf6:	e9 15 04 00 00       	jmp    803010 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802bfb:	a1 40 51 80 00       	mov    0x805140,%eax
  802c00:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c03:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c07:	74 07                	je     802c10 <alloc_block_NF+0x1cb>
  802c09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0c:	8b 00                	mov    (%eax),%eax
  802c0e:	eb 05                	jmp    802c15 <alloc_block_NF+0x1d0>
  802c10:	b8 00 00 00 00       	mov    $0x0,%eax
  802c15:	a3 40 51 80 00       	mov    %eax,0x805140
  802c1a:	a1 40 51 80 00       	mov    0x805140,%eax
  802c1f:	85 c0                	test   %eax,%eax
  802c21:	0f 85 3e fe ff ff    	jne    802a65 <alloc_block_NF+0x20>
  802c27:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c2b:	0f 85 34 fe ff ff    	jne    802a65 <alloc_block_NF+0x20>
  802c31:	e9 d5 03 00 00       	jmp    80300b <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802c36:	a1 38 51 80 00       	mov    0x805138,%eax
  802c3b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c3e:	e9 b1 01 00 00       	jmp    802df4 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802c43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c46:	8b 50 08             	mov    0x8(%eax),%edx
  802c49:	a1 28 50 80 00       	mov    0x805028,%eax
  802c4e:	39 c2                	cmp    %eax,%edx
  802c50:	0f 82 96 01 00 00    	jb     802dec <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802c56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c59:	8b 40 0c             	mov    0xc(%eax),%eax
  802c5c:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c5f:	0f 82 87 01 00 00    	jb     802dec <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802c65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c68:	8b 40 0c             	mov    0xc(%eax),%eax
  802c6b:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c6e:	0f 85 95 00 00 00    	jne    802d09 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802c74:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c78:	75 17                	jne    802c91 <alloc_block_NF+0x24c>
  802c7a:	83 ec 04             	sub    $0x4,%esp
  802c7d:	68 84 46 80 00       	push   $0x804684
  802c82:	68 fc 00 00 00       	push   $0xfc
  802c87:	68 db 45 80 00       	push   $0x8045db
  802c8c:	e8 22 da ff ff       	call   8006b3 <_panic>
  802c91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c94:	8b 00                	mov    (%eax),%eax
  802c96:	85 c0                	test   %eax,%eax
  802c98:	74 10                	je     802caa <alloc_block_NF+0x265>
  802c9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9d:	8b 00                	mov    (%eax),%eax
  802c9f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ca2:	8b 52 04             	mov    0x4(%edx),%edx
  802ca5:	89 50 04             	mov    %edx,0x4(%eax)
  802ca8:	eb 0b                	jmp    802cb5 <alloc_block_NF+0x270>
  802caa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cad:	8b 40 04             	mov    0x4(%eax),%eax
  802cb0:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802cb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb8:	8b 40 04             	mov    0x4(%eax),%eax
  802cbb:	85 c0                	test   %eax,%eax
  802cbd:	74 0f                	je     802cce <alloc_block_NF+0x289>
  802cbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc2:	8b 40 04             	mov    0x4(%eax),%eax
  802cc5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cc8:	8b 12                	mov    (%edx),%edx
  802cca:	89 10                	mov    %edx,(%eax)
  802ccc:	eb 0a                	jmp    802cd8 <alloc_block_NF+0x293>
  802cce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd1:	8b 00                	mov    (%eax),%eax
  802cd3:	a3 38 51 80 00       	mov    %eax,0x805138
  802cd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cdb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ce1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ceb:	a1 44 51 80 00       	mov    0x805144,%eax
  802cf0:	48                   	dec    %eax
  802cf1:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802cf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf9:	8b 40 08             	mov    0x8(%eax),%eax
  802cfc:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802d01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d04:	e9 07 03 00 00       	jmp    803010 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802d09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0c:	8b 40 0c             	mov    0xc(%eax),%eax
  802d0f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d12:	0f 86 d4 00 00 00    	jbe    802dec <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802d18:	a1 48 51 80 00       	mov    0x805148,%eax
  802d1d:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802d20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d23:	8b 50 08             	mov    0x8(%eax),%edx
  802d26:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d29:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802d2c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d2f:	8b 55 08             	mov    0x8(%ebp),%edx
  802d32:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802d35:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802d39:	75 17                	jne    802d52 <alloc_block_NF+0x30d>
  802d3b:	83 ec 04             	sub    $0x4,%esp
  802d3e:	68 84 46 80 00       	push   $0x804684
  802d43:	68 04 01 00 00       	push   $0x104
  802d48:	68 db 45 80 00       	push   $0x8045db
  802d4d:	e8 61 d9 ff ff       	call   8006b3 <_panic>
  802d52:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d55:	8b 00                	mov    (%eax),%eax
  802d57:	85 c0                	test   %eax,%eax
  802d59:	74 10                	je     802d6b <alloc_block_NF+0x326>
  802d5b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d5e:	8b 00                	mov    (%eax),%eax
  802d60:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d63:	8b 52 04             	mov    0x4(%edx),%edx
  802d66:	89 50 04             	mov    %edx,0x4(%eax)
  802d69:	eb 0b                	jmp    802d76 <alloc_block_NF+0x331>
  802d6b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d6e:	8b 40 04             	mov    0x4(%eax),%eax
  802d71:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d76:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d79:	8b 40 04             	mov    0x4(%eax),%eax
  802d7c:	85 c0                	test   %eax,%eax
  802d7e:	74 0f                	je     802d8f <alloc_block_NF+0x34a>
  802d80:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d83:	8b 40 04             	mov    0x4(%eax),%eax
  802d86:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d89:	8b 12                	mov    (%edx),%edx
  802d8b:	89 10                	mov    %edx,(%eax)
  802d8d:	eb 0a                	jmp    802d99 <alloc_block_NF+0x354>
  802d8f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d92:	8b 00                	mov    (%eax),%eax
  802d94:	a3 48 51 80 00       	mov    %eax,0x805148
  802d99:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d9c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802da2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802da5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dac:	a1 54 51 80 00       	mov    0x805154,%eax
  802db1:	48                   	dec    %eax
  802db2:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802db7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dba:	8b 40 08             	mov    0x8(%eax),%eax
  802dbd:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802dc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc5:	8b 50 08             	mov    0x8(%eax),%edx
  802dc8:	8b 45 08             	mov    0x8(%ebp),%eax
  802dcb:	01 c2                	add    %eax,%edx
  802dcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd0:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802dd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd6:	8b 40 0c             	mov    0xc(%eax),%eax
  802dd9:	2b 45 08             	sub    0x8(%ebp),%eax
  802ddc:	89 c2                	mov    %eax,%edx
  802dde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de1:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802de4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802de7:	e9 24 02 00 00       	jmp    803010 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802dec:	a1 40 51 80 00       	mov    0x805140,%eax
  802df1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802df4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802df8:	74 07                	je     802e01 <alloc_block_NF+0x3bc>
  802dfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dfd:	8b 00                	mov    (%eax),%eax
  802dff:	eb 05                	jmp    802e06 <alloc_block_NF+0x3c1>
  802e01:	b8 00 00 00 00       	mov    $0x0,%eax
  802e06:	a3 40 51 80 00       	mov    %eax,0x805140
  802e0b:	a1 40 51 80 00       	mov    0x805140,%eax
  802e10:	85 c0                	test   %eax,%eax
  802e12:	0f 85 2b fe ff ff    	jne    802c43 <alloc_block_NF+0x1fe>
  802e18:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e1c:	0f 85 21 fe ff ff    	jne    802c43 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802e22:	a1 38 51 80 00       	mov    0x805138,%eax
  802e27:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e2a:	e9 ae 01 00 00       	jmp    802fdd <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802e2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e32:	8b 50 08             	mov    0x8(%eax),%edx
  802e35:	a1 28 50 80 00       	mov    0x805028,%eax
  802e3a:	39 c2                	cmp    %eax,%edx
  802e3c:	0f 83 93 01 00 00    	jae    802fd5 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802e42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e45:	8b 40 0c             	mov    0xc(%eax),%eax
  802e48:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e4b:	0f 82 84 01 00 00    	jb     802fd5 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802e51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e54:	8b 40 0c             	mov    0xc(%eax),%eax
  802e57:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e5a:	0f 85 95 00 00 00    	jne    802ef5 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802e60:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e64:	75 17                	jne    802e7d <alloc_block_NF+0x438>
  802e66:	83 ec 04             	sub    $0x4,%esp
  802e69:	68 84 46 80 00       	push   $0x804684
  802e6e:	68 14 01 00 00       	push   $0x114
  802e73:	68 db 45 80 00       	push   $0x8045db
  802e78:	e8 36 d8 ff ff       	call   8006b3 <_panic>
  802e7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e80:	8b 00                	mov    (%eax),%eax
  802e82:	85 c0                	test   %eax,%eax
  802e84:	74 10                	je     802e96 <alloc_block_NF+0x451>
  802e86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e89:	8b 00                	mov    (%eax),%eax
  802e8b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e8e:	8b 52 04             	mov    0x4(%edx),%edx
  802e91:	89 50 04             	mov    %edx,0x4(%eax)
  802e94:	eb 0b                	jmp    802ea1 <alloc_block_NF+0x45c>
  802e96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e99:	8b 40 04             	mov    0x4(%eax),%eax
  802e9c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ea1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea4:	8b 40 04             	mov    0x4(%eax),%eax
  802ea7:	85 c0                	test   %eax,%eax
  802ea9:	74 0f                	je     802eba <alloc_block_NF+0x475>
  802eab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eae:	8b 40 04             	mov    0x4(%eax),%eax
  802eb1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802eb4:	8b 12                	mov    (%edx),%edx
  802eb6:	89 10                	mov    %edx,(%eax)
  802eb8:	eb 0a                	jmp    802ec4 <alloc_block_NF+0x47f>
  802eba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ebd:	8b 00                	mov    (%eax),%eax
  802ebf:	a3 38 51 80 00       	mov    %eax,0x805138
  802ec4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ecd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ed7:	a1 44 51 80 00       	mov    0x805144,%eax
  802edc:	48                   	dec    %eax
  802edd:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802ee2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee5:	8b 40 08             	mov    0x8(%eax),%eax
  802ee8:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802eed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef0:	e9 1b 01 00 00       	jmp    803010 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802ef5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef8:	8b 40 0c             	mov    0xc(%eax),%eax
  802efb:	3b 45 08             	cmp    0x8(%ebp),%eax
  802efe:	0f 86 d1 00 00 00    	jbe    802fd5 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802f04:	a1 48 51 80 00       	mov    0x805148,%eax
  802f09:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802f0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f0f:	8b 50 08             	mov    0x8(%eax),%edx
  802f12:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f15:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802f18:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f1b:	8b 55 08             	mov    0x8(%ebp),%edx
  802f1e:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802f21:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802f25:	75 17                	jne    802f3e <alloc_block_NF+0x4f9>
  802f27:	83 ec 04             	sub    $0x4,%esp
  802f2a:	68 84 46 80 00       	push   $0x804684
  802f2f:	68 1c 01 00 00       	push   $0x11c
  802f34:	68 db 45 80 00       	push   $0x8045db
  802f39:	e8 75 d7 ff ff       	call   8006b3 <_panic>
  802f3e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f41:	8b 00                	mov    (%eax),%eax
  802f43:	85 c0                	test   %eax,%eax
  802f45:	74 10                	je     802f57 <alloc_block_NF+0x512>
  802f47:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f4a:	8b 00                	mov    (%eax),%eax
  802f4c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802f4f:	8b 52 04             	mov    0x4(%edx),%edx
  802f52:	89 50 04             	mov    %edx,0x4(%eax)
  802f55:	eb 0b                	jmp    802f62 <alloc_block_NF+0x51d>
  802f57:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f5a:	8b 40 04             	mov    0x4(%eax),%eax
  802f5d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f62:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f65:	8b 40 04             	mov    0x4(%eax),%eax
  802f68:	85 c0                	test   %eax,%eax
  802f6a:	74 0f                	je     802f7b <alloc_block_NF+0x536>
  802f6c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f6f:	8b 40 04             	mov    0x4(%eax),%eax
  802f72:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802f75:	8b 12                	mov    (%edx),%edx
  802f77:	89 10                	mov    %edx,(%eax)
  802f79:	eb 0a                	jmp    802f85 <alloc_block_NF+0x540>
  802f7b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f7e:	8b 00                	mov    (%eax),%eax
  802f80:	a3 48 51 80 00       	mov    %eax,0x805148
  802f85:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f88:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f8e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f91:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f98:	a1 54 51 80 00       	mov    0x805154,%eax
  802f9d:	48                   	dec    %eax
  802f9e:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802fa3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fa6:	8b 40 08             	mov    0x8(%eax),%eax
  802fa9:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802fae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb1:	8b 50 08             	mov    0x8(%eax),%edx
  802fb4:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb7:	01 c2                	add    %eax,%edx
  802fb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fbc:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802fbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc2:	8b 40 0c             	mov    0xc(%eax),%eax
  802fc5:	2b 45 08             	sub    0x8(%ebp),%eax
  802fc8:	89 c2                	mov    %eax,%edx
  802fca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fcd:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802fd0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fd3:	eb 3b                	jmp    803010 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802fd5:	a1 40 51 80 00       	mov    0x805140,%eax
  802fda:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fdd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fe1:	74 07                	je     802fea <alloc_block_NF+0x5a5>
  802fe3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe6:	8b 00                	mov    (%eax),%eax
  802fe8:	eb 05                	jmp    802fef <alloc_block_NF+0x5aa>
  802fea:	b8 00 00 00 00       	mov    $0x0,%eax
  802fef:	a3 40 51 80 00       	mov    %eax,0x805140
  802ff4:	a1 40 51 80 00       	mov    0x805140,%eax
  802ff9:	85 c0                	test   %eax,%eax
  802ffb:	0f 85 2e fe ff ff    	jne    802e2f <alloc_block_NF+0x3ea>
  803001:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803005:	0f 85 24 fe ff ff    	jne    802e2f <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  80300b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803010:	c9                   	leave  
  803011:	c3                   	ret    

00803012 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  803012:	55                   	push   %ebp
  803013:	89 e5                	mov    %esp,%ebp
  803015:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  803018:	a1 38 51 80 00       	mov    0x805138,%eax
  80301d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  803020:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803025:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  803028:	a1 38 51 80 00       	mov    0x805138,%eax
  80302d:	85 c0                	test   %eax,%eax
  80302f:	74 14                	je     803045 <insert_sorted_with_merge_freeList+0x33>
  803031:	8b 45 08             	mov    0x8(%ebp),%eax
  803034:	8b 50 08             	mov    0x8(%eax),%edx
  803037:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80303a:	8b 40 08             	mov    0x8(%eax),%eax
  80303d:	39 c2                	cmp    %eax,%edx
  80303f:	0f 87 9b 01 00 00    	ja     8031e0 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  803045:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803049:	75 17                	jne    803062 <insert_sorted_with_merge_freeList+0x50>
  80304b:	83 ec 04             	sub    $0x4,%esp
  80304e:	68 b8 45 80 00       	push   $0x8045b8
  803053:	68 38 01 00 00       	push   $0x138
  803058:	68 db 45 80 00       	push   $0x8045db
  80305d:	e8 51 d6 ff ff       	call   8006b3 <_panic>
  803062:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803068:	8b 45 08             	mov    0x8(%ebp),%eax
  80306b:	89 10                	mov    %edx,(%eax)
  80306d:	8b 45 08             	mov    0x8(%ebp),%eax
  803070:	8b 00                	mov    (%eax),%eax
  803072:	85 c0                	test   %eax,%eax
  803074:	74 0d                	je     803083 <insert_sorted_with_merge_freeList+0x71>
  803076:	a1 38 51 80 00       	mov    0x805138,%eax
  80307b:	8b 55 08             	mov    0x8(%ebp),%edx
  80307e:	89 50 04             	mov    %edx,0x4(%eax)
  803081:	eb 08                	jmp    80308b <insert_sorted_with_merge_freeList+0x79>
  803083:	8b 45 08             	mov    0x8(%ebp),%eax
  803086:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80308b:	8b 45 08             	mov    0x8(%ebp),%eax
  80308e:	a3 38 51 80 00       	mov    %eax,0x805138
  803093:	8b 45 08             	mov    0x8(%ebp),%eax
  803096:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80309d:	a1 44 51 80 00       	mov    0x805144,%eax
  8030a2:	40                   	inc    %eax
  8030a3:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8030a8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8030ac:	0f 84 a8 06 00 00    	je     80375a <insert_sorted_with_merge_freeList+0x748>
  8030b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b5:	8b 50 08             	mov    0x8(%eax),%edx
  8030b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8030bb:	8b 40 0c             	mov    0xc(%eax),%eax
  8030be:	01 c2                	add    %eax,%edx
  8030c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030c3:	8b 40 08             	mov    0x8(%eax),%eax
  8030c6:	39 c2                	cmp    %eax,%edx
  8030c8:	0f 85 8c 06 00 00    	jne    80375a <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  8030ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d1:	8b 50 0c             	mov    0xc(%eax),%edx
  8030d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030d7:	8b 40 0c             	mov    0xc(%eax),%eax
  8030da:	01 c2                	add    %eax,%edx
  8030dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8030df:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  8030e2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8030e6:	75 17                	jne    8030ff <insert_sorted_with_merge_freeList+0xed>
  8030e8:	83 ec 04             	sub    $0x4,%esp
  8030eb:	68 84 46 80 00       	push   $0x804684
  8030f0:	68 3c 01 00 00       	push   $0x13c
  8030f5:	68 db 45 80 00       	push   $0x8045db
  8030fa:	e8 b4 d5 ff ff       	call   8006b3 <_panic>
  8030ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803102:	8b 00                	mov    (%eax),%eax
  803104:	85 c0                	test   %eax,%eax
  803106:	74 10                	je     803118 <insert_sorted_with_merge_freeList+0x106>
  803108:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80310b:	8b 00                	mov    (%eax),%eax
  80310d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803110:	8b 52 04             	mov    0x4(%edx),%edx
  803113:	89 50 04             	mov    %edx,0x4(%eax)
  803116:	eb 0b                	jmp    803123 <insert_sorted_with_merge_freeList+0x111>
  803118:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80311b:	8b 40 04             	mov    0x4(%eax),%eax
  80311e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803123:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803126:	8b 40 04             	mov    0x4(%eax),%eax
  803129:	85 c0                	test   %eax,%eax
  80312b:	74 0f                	je     80313c <insert_sorted_with_merge_freeList+0x12a>
  80312d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803130:	8b 40 04             	mov    0x4(%eax),%eax
  803133:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803136:	8b 12                	mov    (%edx),%edx
  803138:	89 10                	mov    %edx,(%eax)
  80313a:	eb 0a                	jmp    803146 <insert_sorted_with_merge_freeList+0x134>
  80313c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80313f:	8b 00                	mov    (%eax),%eax
  803141:	a3 38 51 80 00       	mov    %eax,0x805138
  803146:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803149:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80314f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803152:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803159:	a1 44 51 80 00       	mov    0x805144,%eax
  80315e:	48                   	dec    %eax
  80315f:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  803164:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803167:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  80316e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803171:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  803178:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80317c:	75 17                	jne    803195 <insert_sorted_with_merge_freeList+0x183>
  80317e:	83 ec 04             	sub    $0x4,%esp
  803181:	68 b8 45 80 00       	push   $0x8045b8
  803186:	68 3f 01 00 00       	push   $0x13f
  80318b:	68 db 45 80 00       	push   $0x8045db
  803190:	e8 1e d5 ff ff       	call   8006b3 <_panic>
  803195:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80319b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80319e:	89 10                	mov    %edx,(%eax)
  8031a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031a3:	8b 00                	mov    (%eax),%eax
  8031a5:	85 c0                	test   %eax,%eax
  8031a7:	74 0d                	je     8031b6 <insert_sorted_with_merge_freeList+0x1a4>
  8031a9:	a1 48 51 80 00       	mov    0x805148,%eax
  8031ae:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031b1:	89 50 04             	mov    %edx,0x4(%eax)
  8031b4:	eb 08                	jmp    8031be <insert_sorted_with_merge_freeList+0x1ac>
  8031b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031b9:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8031be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031c1:	a3 48 51 80 00       	mov    %eax,0x805148
  8031c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031c9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031d0:	a1 54 51 80 00       	mov    0x805154,%eax
  8031d5:	40                   	inc    %eax
  8031d6:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8031db:	e9 7a 05 00 00       	jmp    80375a <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  8031e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e3:	8b 50 08             	mov    0x8(%eax),%edx
  8031e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031e9:	8b 40 08             	mov    0x8(%eax),%eax
  8031ec:	39 c2                	cmp    %eax,%edx
  8031ee:	0f 82 14 01 00 00    	jb     803308 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  8031f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031f7:	8b 50 08             	mov    0x8(%eax),%edx
  8031fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031fd:	8b 40 0c             	mov    0xc(%eax),%eax
  803200:	01 c2                	add    %eax,%edx
  803202:	8b 45 08             	mov    0x8(%ebp),%eax
  803205:	8b 40 08             	mov    0x8(%eax),%eax
  803208:	39 c2                	cmp    %eax,%edx
  80320a:	0f 85 90 00 00 00    	jne    8032a0 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  803210:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803213:	8b 50 0c             	mov    0xc(%eax),%edx
  803216:	8b 45 08             	mov    0x8(%ebp),%eax
  803219:	8b 40 0c             	mov    0xc(%eax),%eax
  80321c:	01 c2                	add    %eax,%edx
  80321e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803221:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  803224:	8b 45 08             	mov    0x8(%ebp),%eax
  803227:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  80322e:	8b 45 08             	mov    0x8(%ebp),%eax
  803231:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803238:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80323c:	75 17                	jne    803255 <insert_sorted_with_merge_freeList+0x243>
  80323e:	83 ec 04             	sub    $0x4,%esp
  803241:	68 b8 45 80 00       	push   $0x8045b8
  803246:	68 49 01 00 00       	push   $0x149
  80324b:	68 db 45 80 00       	push   $0x8045db
  803250:	e8 5e d4 ff ff       	call   8006b3 <_panic>
  803255:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80325b:	8b 45 08             	mov    0x8(%ebp),%eax
  80325e:	89 10                	mov    %edx,(%eax)
  803260:	8b 45 08             	mov    0x8(%ebp),%eax
  803263:	8b 00                	mov    (%eax),%eax
  803265:	85 c0                	test   %eax,%eax
  803267:	74 0d                	je     803276 <insert_sorted_with_merge_freeList+0x264>
  803269:	a1 48 51 80 00       	mov    0x805148,%eax
  80326e:	8b 55 08             	mov    0x8(%ebp),%edx
  803271:	89 50 04             	mov    %edx,0x4(%eax)
  803274:	eb 08                	jmp    80327e <insert_sorted_with_merge_freeList+0x26c>
  803276:	8b 45 08             	mov    0x8(%ebp),%eax
  803279:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80327e:	8b 45 08             	mov    0x8(%ebp),%eax
  803281:	a3 48 51 80 00       	mov    %eax,0x805148
  803286:	8b 45 08             	mov    0x8(%ebp),%eax
  803289:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803290:	a1 54 51 80 00       	mov    0x805154,%eax
  803295:	40                   	inc    %eax
  803296:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80329b:	e9 bb 04 00 00       	jmp    80375b <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  8032a0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032a4:	75 17                	jne    8032bd <insert_sorted_with_merge_freeList+0x2ab>
  8032a6:	83 ec 04             	sub    $0x4,%esp
  8032a9:	68 2c 46 80 00       	push   $0x80462c
  8032ae:	68 4c 01 00 00       	push   $0x14c
  8032b3:	68 db 45 80 00       	push   $0x8045db
  8032b8:	e8 f6 d3 ff ff       	call   8006b3 <_panic>
  8032bd:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  8032c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c6:	89 50 04             	mov    %edx,0x4(%eax)
  8032c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8032cc:	8b 40 04             	mov    0x4(%eax),%eax
  8032cf:	85 c0                	test   %eax,%eax
  8032d1:	74 0c                	je     8032df <insert_sorted_with_merge_freeList+0x2cd>
  8032d3:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8032d8:	8b 55 08             	mov    0x8(%ebp),%edx
  8032db:	89 10                	mov    %edx,(%eax)
  8032dd:	eb 08                	jmp    8032e7 <insert_sorted_with_merge_freeList+0x2d5>
  8032df:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e2:	a3 38 51 80 00       	mov    %eax,0x805138
  8032e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ea:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8032ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032f8:	a1 44 51 80 00       	mov    0x805144,%eax
  8032fd:	40                   	inc    %eax
  8032fe:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803303:	e9 53 04 00 00       	jmp    80375b <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803308:	a1 38 51 80 00       	mov    0x805138,%eax
  80330d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803310:	e9 15 04 00 00       	jmp    80372a <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  803315:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803318:	8b 00                	mov    (%eax),%eax
  80331a:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  80331d:	8b 45 08             	mov    0x8(%ebp),%eax
  803320:	8b 50 08             	mov    0x8(%eax),%edx
  803323:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803326:	8b 40 08             	mov    0x8(%eax),%eax
  803329:	39 c2                	cmp    %eax,%edx
  80332b:	0f 86 f1 03 00 00    	jbe    803722 <insert_sorted_with_merge_freeList+0x710>
  803331:	8b 45 08             	mov    0x8(%ebp),%eax
  803334:	8b 50 08             	mov    0x8(%eax),%edx
  803337:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80333a:	8b 40 08             	mov    0x8(%eax),%eax
  80333d:	39 c2                	cmp    %eax,%edx
  80333f:	0f 83 dd 03 00 00    	jae    803722 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  803345:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803348:	8b 50 08             	mov    0x8(%eax),%edx
  80334b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80334e:	8b 40 0c             	mov    0xc(%eax),%eax
  803351:	01 c2                	add    %eax,%edx
  803353:	8b 45 08             	mov    0x8(%ebp),%eax
  803356:	8b 40 08             	mov    0x8(%eax),%eax
  803359:	39 c2                	cmp    %eax,%edx
  80335b:	0f 85 b9 01 00 00    	jne    80351a <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803361:	8b 45 08             	mov    0x8(%ebp),%eax
  803364:	8b 50 08             	mov    0x8(%eax),%edx
  803367:	8b 45 08             	mov    0x8(%ebp),%eax
  80336a:	8b 40 0c             	mov    0xc(%eax),%eax
  80336d:	01 c2                	add    %eax,%edx
  80336f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803372:	8b 40 08             	mov    0x8(%eax),%eax
  803375:	39 c2                	cmp    %eax,%edx
  803377:	0f 85 0d 01 00 00    	jne    80348a <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  80337d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803380:	8b 50 0c             	mov    0xc(%eax),%edx
  803383:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803386:	8b 40 0c             	mov    0xc(%eax),%eax
  803389:	01 c2                	add    %eax,%edx
  80338b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80338e:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803391:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803395:	75 17                	jne    8033ae <insert_sorted_with_merge_freeList+0x39c>
  803397:	83 ec 04             	sub    $0x4,%esp
  80339a:	68 84 46 80 00       	push   $0x804684
  80339f:	68 5c 01 00 00       	push   $0x15c
  8033a4:	68 db 45 80 00       	push   $0x8045db
  8033a9:	e8 05 d3 ff ff       	call   8006b3 <_panic>
  8033ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033b1:	8b 00                	mov    (%eax),%eax
  8033b3:	85 c0                	test   %eax,%eax
  8033b5:	74 10                	je     8033c7 <insert_sorted_with_merge_freeList+0x3b5>
  8033b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033ba:	8b 00                	mov    (%eax),%eax
  8033bc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8033bf:	8b 52 04             	mov    0x4(%edx),%edx
  8033c2:	89 50 04             	mov    %edx,0x4(%eax)
  8033c5:	eb 0b                	jmp    8033d2 <insert_sorted_with_merge_freeList+0x3c0>
  8033c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033ca:	8b 40 04             	mov    0x4(%eax),%eax
  8033cd:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8033d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033d5:	8b 40 04             	mov    0x4(%eax),%eax
  8033d8:	85 c0                	test   %eax,%eax
  8033da:	74 0f                	je     8033eb <insert_sorted_with_merge_freeList+0x3d9>
  8033dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033df:	8b 40 04             	mov    0x4(%eax),%eax
  8033e2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8033e5:	8b 12                	mov    (%edx),%edx
  8033e7:	89 10                	mov    %edx,(%eax)
  8033e9:	eb 0a                	jmp    8033f5 <insert_sorted_with_merge_freeList+0x3e3>
  8033eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033ee:	8b 00                	mov    (%eax),%eax
  8033f0:	a3 38 51 80 00       	mov    %eax,0x805138
  8033f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033f8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803401:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803408:	a1 44 51 80 00       	mov    0x805144,%eax
  80340d:	48                   	dec    %eax
  80340e:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  803413:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803416:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  80341d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803420:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803427:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80342b:	75 17                	jne    803444 <insert_sorted_with_merge_freeList+0x432>
  80342d:	83 ec 04             	sub    $0x4,%esp
  803430:	68 b8 45 80 00       	push   $0x8045b8
  803435:	68 5f 01 00 00       	push   $0x15f
  80343a:	68 db 45 80 00       	push   $0x8045db
  80343f:	e8 6f d2 ff ff       	call   8006b3 <_panic>
  803444:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80344a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80344d:	89 10                	mov    %edx,(%eax)
  80344f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803452:	8b 00                	mov    (%eax),%eax
  803454:	85 c0                	test   %eax,%eax
  803456:	74 0d                	je     803465 <insert_sorted_with_merge_freeList+0x453>
  803458:	a1 48 51 80 00       	mov    0x805148,%eax
  80345d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803460:	89 50 04             	mov    %edx,0x4(%eax)
  803463:	eb 08                	jmp    80346d <insert_sorted_with_merge_freeList+0x45b>
  803465:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803468:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80346d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803470:	a3 48 51 80 00       	mov    %eax,0x805148
  803475:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803478:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80347f:	a1 54 51 80 00       	mov    0x805154,%eax
  803484:	40                   	inc    %eax
  803485:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  80348a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80348d:	8b 50 0c             	mov    0xc(%eax),%edx
  803490:	8b 45 08             	mov    0x8(%ebp),%eax
  803493:	8b 40 0c             	mov    0xc(%eax),%eax
  803496:	01 c2                	add    %eax,%edx
  803498:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80349b:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  80349e:	8b 45 08             	mov    0x8(%ebp),%eax
  8034a1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  8034a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ab:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8034b2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034b6:	75 17                	jne    8034cf <insert_sorted_with_merge_freeList+0x4bd>
  8034b8:	83 ec 04             	sub    $0x4,%esp
  8034bb:	68 b8 45 80 00       	push   $0x8045b8
  8034c0:	68 64 01 00 00       	push   $0x164
  8034c5:	68 db 45 80 00       	push   $0x8045db
  8034ca:	e8 e4 d1 ff ff       	call   8006b3 <_panic>
  8034cf:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8034d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8034d8:	89 10                	mov    %edx,(%eax)
  8034da:	8b 45 08             	mov    0x8(%ebp),%eax
  8034dd:	8b 00                	mov    (%eax),%eax
  8034df:	85 c0                	test   %eax,%eax
  8034e1:	74 0d                	je     8034f0 <insert_sorted_with_merge_freeList+0x4de>
  8034e3:	a1 48 51 80 00       	mov    0x805148,%eax
  8034e8:	8b 55 08             	mov    0x8(%ebp),%edx
  8034eb:	89 50 04             	mov    %edx,0x4(%eax)
  8034ee:	eb 08                	jmp    8034f8 <insert_sorted_with_merge_freeList+0x4e6>
  8034f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8034f3:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8034f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8034fb:	a3 48 51 80 00       	mov    %eax,0x805148
  803500:	8b 45 08             	mov    0x8(%ebp),%eax
  803503:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80350a:	a1 54 51 80 00       	mov    0x805154,%eax
  80350f:	40                   	inc    %eax
  803510:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803515:	e9 41 02 00 00       	jmp    80375b <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  80351a:	8b 45 08             	mov    0x8(%ebp),%eax
  80351d:	8b 50 08             	mov    0x8(%eax),%edx
  803520:	8b 45 08             	mov    0x8(%ebp),%eax
  803523:	8b 40 0c             	mov    0xc(%eax),%eax
  803526:	01 c2                	add    %eax,%edx
  803528:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80352b:	8b 40 08             	mov    0x8(%eax),%eax
  80352e:	39 c2                	cmp    %eax,%edx
  803530:	0f 85 7c 01 00 00    	jne    8036b2 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803536:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80353a:	74 06                	je     803542 <insert_sorted_with_merge_freeList+0x530>
  80353c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803540:	75 17                	jne    803559 <insert_sorted_with_merge_freeList+0x547>
  803542:	83 ec 04             	sub    $0x4,%esp
  803545:	68 f4 45 80 00       	push   $0x8045f4
  80354a:	68 69 01 00 00       	push   $0x169
  80354f:	68 db 45 80 00       	push   $0x8045db
  803554:	e8 5a d1 ff ff       	call   8006b3 <_panic>
  803559:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80355c:	8b 50 04             	mov    0x4(%eax),%edx
  80355f:	8b 45 08             	mov    0x8(%ebp),%eax
  803562:	89 50 04             	mov    %edx,0x4(%eax)
  803565:	8b 45 08             	mov    0x8(%ebp),%eax
  803568:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80356b:	89 10                	mov    %edx,(%eax)
  80356d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803570:	8b 40 04             	mov    0x4(%eax),%eax
  803573:	85 c0                	test   %eax,%eax
  803575:	74 0d                	je     803584 <insert_sorted_with_merge_freeList+0x572>
  803577:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80357a:	8b 40 04             	mov    0x4(%eax),%eax
  80357d:	8b 55 08             	mov    0x8(%ebp),%edx
  803580:	89 10                	mov    %edx,(%eax)
  803582:	eb 08                	jmp    80358c <insert_sorted_with_merge_freeList+0x57a>
  803584:	8b 45 08             	mov    0x8(%ebp),%eax
  803587:	a3 38 51 80 00       	mov    %eax,0x805138
  80358c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80358f:	8b 55 08             	mov    0x8(%ebp),%edx
  803592:	89 50 04             	mov    %edx,0x4(%eax)
  803595:	a1 44 51 80 00       	mov    0x805144,%eax
  80359a:	40                   	inc    %eax
  80359b:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  8035a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8035a3:	8b 50 0c             	mov    0xc(%eax),%edx
  8035a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035a9:	8b 40 0c             	mov    0xc(%eax),%eax
  8035ac:	01 c2                	add    %eax,%edx
  8035ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8035b1:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8035b4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8035b8:	75 17                	jne    8035d1 <insert_sorted_with_merge_freeList+0x5bf>
  8035ba:	83 ec 04             	sub    $0x4,%esp
  8035bd:	68 84 46 80 00       	push   $0x804684
  8035c2:	68 6b 01 00 00       	push   $0x16b
  8035c7:	68 db 45 80 00       	push   $0x8045db
  8035cc:	e8 e2 d0 ff ff       	call   8006b3 <_panic>
  8035d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035d4:	8b 00                	mov    (%eax),%eax
  8035d6:	85 c0                	test   %eax,%eax
  8035d8:	74 10                	je     8035ea <insert_sorted_with_merge_freeList+0x5d8>
  8035da:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035dd:	8b 00                	mov    (%eax),%eax
  8035df:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8035e2:	8b 52 04             	mov    0x4(%edx),%edx
  8035e5:	89 50 04             	mov    %edx,0x4(%eax)
  8035e8:	eb 0b                	jmp    8035f5 <insert_sorted_with_merge_freeList+0x5e3>
  8035ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035ed:	8b 40 04             	mov    0x4(%eax),%eax
  8035f0:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8035f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035f8:	8b 40 04             	mov    0x4(%eax),%eax
  8035fb:	85 c0                	test   %eax,%eax
  8035fd:	74 0f                	je     80360e <insert_sorted_with_merge_freeList+0x5fc>
  8035ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803602:	8b 40 04             	mov    0x4(%eax),%eax
  803605:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803608:	8b 12                	mov    (%edx),%edx
  80360a:	89 10                	mov    %edx,(%eax)
  80360c:	eb 0a                	jmp    803618 <insert_sorted_with_merge_freeList+0x606>
  80360e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803611:	8b 00                	mov    (%eax),%eax
  803613:	a3 38 51 80 00       	mov    %eax,0x805138
  803618:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80361b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803621:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803624:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80362b:	a1 44 51 80 00       	mov    0x805144,%eax
  803630:	48                   	dec    %eax
  803631:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803636:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803639:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803640:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803643:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80364a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80364e:	75 17                	jne    803667 <insert_sorted_with_merge_freeList+0x655>
  803650:	83 ec 04             	sub    $0x4,%esp
  803653:	68 b8 45 80 00       	push   $0x8045b8
  803658:	68 6e 01 00 00       	push   $0x16e
  80365d:	68 db 45 80 00       	push   $0x8045db
  803662:	e8 4c d0 ff ff       	call   8006b3 <_panic>
  803667:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80366d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803670:	89 10                	mov    %edx,(%eax)
  803672:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803675:	8b 00                	mov    (%eax),%eax
  803677:	85 c0                	test   %eax,%eax
  803679:	74 0d                	je     803688 <insert_sorted_with_merge_freeList+0x676>
  80367b:	a1 48 51 80 00       	mov    0x805148,%eax
  803680:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803683:	89 50 04             	mov    %edx,0x4(%eax)
  803686:	eb 08                	jmp    803690 <insert_sorted_with_merge_freeList+0x67e>
  803688:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80368b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803690:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803693:	a3 48 51 80 00       	mov    %eax,0x805148
  803698:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80369b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036a2:	a1 54 51 80 00       	mov    0x805154,%eax
  8036a7:	40                   	inc    %eax
  8036a8:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8036ad:	e9 a9 00 00 00       	jmp    80375b <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  8036b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036b6:	74 06                	je     8036be <insert_sorted_with_merge_freeList+0x6ac>
  8036b8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8036bc:	75 17                	jne    8036d5 <insert_sorted_with_merge_freeList+0x6c3>
  8036be:	83 ec 04             	sub    $0x4,%esp
  8036c1:	68 50 46 80 00       	push   $0x804650
  8036c6:	68 73 01 00 00       	push   $0x173
  8036cb:	68 db 45 80 00       	push   $0x8045db
  8036d0:	e8 de cf ff ff       	call   8006b3 <_panic>
  8036d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036d8:	8b 10                	mov    (%eax),%edx
  8036da:	8b 45 08             	mov    0x8(%ebp),%eax
  8036dd:	89 10                	mov    %edx,(%eax)
  8036df:	8b 45 08             	mov    0x8(%ebp),%eax
  8036e2:	8b 00                	mov    (%eax),%eax
  8036e4:	85 c0                	test   %eax,%eax
  8036e6:	74 0b                	je     8036f3 <insert_sorted_with_merge_freeList+0x6e1>
  8036e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036eb:	8b 00                	mov    (%eax),%eax
  8036ed:	8b 55 08             	mov    0x8(%ebp),%edx
  8036f0:	89 50 04             	mov    %edx,0x4(%eax)
  8036f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036f6:	8b 55 08             	mov    0x8(%ebp),%edx
  8036f9:	89 10                	mov    %edx,(%eax)
  8036fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8036fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803701:	89 50 04             	mov    %edx,0x4(%eax)
  803704:	8b 45 08             	mov    0x8(%ebp),%eax
  803707:	8b 00                	mov    (%eax),%eax
  803709:	85 c0                	test   %eax,%eax
  80370b:	75 08                	jne    803715 <insert_sorted_with_merge_freeList+0x703>
  80370d:	8b 45 08             	mov    0x8(%ebp),%eax
  803710:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803715:	a1 44 51 80 00       	mov    0x805144,%eax
  80371a:	40                   	inc    %eax
  80371b:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803720:	eb 39                	jmp    80375b <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803722:	a1 40 51 80 00       	mov    0x805140,%eax
  803727:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80372a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80372e:	74 07                	je     803737 <insert_sorted_with_merge_freeList+0x725>
  803730:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803733:	8b 00                	mov    (%eax),%eax
  803735:	eb 05                	jmp    80373c <insert_sorted_with_merge_freeList+0x72a>
  803737:	b8 00 00 00 00       	mov    $0x0,%eax
  80373c:	a3 40 51 80 00       	mov    %eax,0x805140
  803741:	a1 40 51 80 00       	mov    0x805140,%eax
  803746:	85 c0                	test   %eax,%eax
  803748:	0f 85 c7 fb ff ff    	jne    803315 <insert_sorted_with_merge_freeList+0x303>
  80374e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803752:	0f 85 bd fb ff ff    	jne    803315 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803758:	eb 01                	jmp    80375b <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80375a:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80375b:	90                   	nop
  80375c:	c9                   	leave  
  80375d:	c3                   	ret    
  80375e:	66 90                	xchg   %ax,%ax

00803760 <__udivdi3>:
  803760:	55                   	push   %ebp
  803761:	57                   	push   %edi
  803762:	56                   	push   %esi
  803763:	53                   	push   %ebx
  803764:	83 ec 1c             	sub    $0x1c,%esp
  803767:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80376b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80376f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803773:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803777:	89 ca                	mov    %ecx,%edx
  803779:	89 f8                	mov    %edi,%eax
  80377b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80377f:	85 f6                	test   %esi,%esi
  803781:	75 2d                	jne    8037b0 <__udivdi3+0x50>
  803783:	39 cf                	cmp    %ecx,%edi
  803785:	77 65                	ja     8037ec <__udivdi3+0x8c>
  803787:	89 fd                	mov    %edi,%ebp
  803789:	85 ff                	test   %edi,%edi
  80378b:	75 0b                	jne    803798 <__udivdi3+0x38>
  80378d:	b8 01 00 00 00       	mov    $0x1,%eax
  803792:	31 d2                	xor    %edx,%edx
  803794:	f7 f7                	div    %edi
  803796:	89 c5                	mov    %eax,%ebp
  803798:	31 d2                	xor    %edx,%edx
  80379a:	89 c8                	mov    %ecx,%eax
  80379c:	f7 f5                	div    %ebp
  80379e:	89 c1                	mov    %eax,%ecx
  8037a0:	89 d8                	mov    %ebx,%eax
  8037a2:	f7 f5                	div    %ebp
  8037a4:	89 cf                	mov    %ecx,%edi
  8037a6:	89 fa                	mov    %edi,%edx
  8037a8:	83 c4 1c             	add    $0x1c,%esp
  8037ab:	5b                   	pop    %ebx
  8037ac:	5e                   	pop    %esi
  8037ad:	5f                   	pop    %edi
  8037ae:	5d                   	pop    %ebp
  8037af:	c3                   	ret    
  8037b0:	39 ce                	cmp    %ecx,%esi
  8037b2:	77 28                	ja     8037dc <__udivdi3+0x7c>
  8037b4:	0f bd fe             	bsr    %esi,%edi
  8037b7:	83 f7 1f             	xor    $0x1f,%edi
  8037ba:	75 40                	jne    8037fc <__udivdi3+0x9c>
  8037bc:	39 ce                	cmp    %ecx,%esi
  8037be:	72 0a                	jb     8037ca <__udivdi3+0x6a>
  8037c0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8037c4:	0f 87 9e 00 00 00    	ja     803868 <__udivdi3+0x108>
  8037ca:	b8 01 00 00 00       	mov    $0x1,%eax
  8037cf:	89 fa                	mov    %edi,%edx
  8037d1:	83 c4 1c             	add    $0x1c,%esp
  8037d4:	5b                   	pop    %ebx
  8037d5:	5e                   	pop    %esi
  8037d6:	5f                   	pop    %edi
  8037d7:	5d                   	pop    %ebp
  8037d8:	c3                   	ret    
  8037d9:	8d 76 00             	lea    0x0(%esi),%esi
  8037dc:	31 ff                	xor    %edi,%edi
  8037de:	31 c0                	xor    %eax,%eax
  8037e0:	89 fa                	mov    %edi,%edx
  8037e2:	83 c4 1c             	add    $0x1c,%esp
  8037e5:	5b                   	pop    %ebx
  8037e6:	5e                   	pop    %esi
  8037e7:	5f                   	pop    %edi
  8037e8:	5d                   	pop    %ebp
  8037e9:	c3                   	ret    
  8037ea:	66 90                	xchg   %ax,%ax
  8037ec:	89 d8                	mov    %ebx,%eax
  8037ee:	f7 f7                	div    %edi
  8037f0:	31 ff                	xor    %edi,%edi
  8037f2:	89 fa                	mov    %edi,%edx
  8037f4:	83 c4 1c             	add    $0x1c,%esp
  8037f7:	5b                   	pop    %ebx
  8037f8:	5e                   	pop    %esi
  8037f9:	5f                   	pop    %edi
  8037fa:	5d                   	pop    %ebp
  8037fb:	c3                   	ret    
  8037fc:	bd 20 00 00 00       	mov    $0x20,%ebp
  803801:	89 eb                	mov    %ebp,%ebx
  803803:	29 fb                	sub    %edi,%ebx
  803805:	89 f9                	mov    %edi,%ecx
  803807:	d3 e6                	shl    %cl,%esi
  803809:	89 c5                	mov    %eax,%ebp
  80380b:	88 d9                	mov    %bl,%cl
  80380d:	d3 ed                	shr    %cl,%ebp
  80380f:	89 e9                	mov    %ebp,%ecx
  803811:	09 f1                	or     %esi,%ecx
  803813:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803817:	89 f9                	mov    %edi,%ecx
  803819:	d3 e0                	shl    %cl,%eax
  80381b:	89 c5                	mov    %eax,%ebp
  80381d:	89 d6                	mov    %edx,%esi
  80381f:	88 d9                	mov    %bl,%cl
  803821:	d3 ee                	shr    %cl,%esi
  803823:	89 f9                	mov    %edi,%ecx
  803825:	d3 e2                	shl    %cl,%edx
  803827:	8b 44 24 08          	mov    0x8(%esp),%eax
  80382b:	88 d9                	mov    %bl,%cl
  80382d:	d3 e8                	shr    %cl,%eax
  80382f:	09 c2                	or     %eax,%edx
  803831:	89 d0                	mov    %edx,%eax
  803833:	89 f2                	mov    %esi,%edx
  803835:	f7 74 24 0c          	divl   0xc(%esp)
  803839:	89 d6                	mov    %edx,%esi
  80383b:	89 c3                	mov    %eax,%ebx
  80383d:	f7 e5                	mul    %ebp
  80383f:	39 d6                	cmp    %edx,%esi
  803841:	72 19                	jb     80385c <__udivdi3+0xfc>
  803843:	74 0b                	je     803850 <__udivdi3+0xf0>
  803845:	89 d8                	mov    %ebx,%eax
  803847:	31 ff                	xor    %edi,%edi
  803849:	e9 58 ff ff ff       	jmp    8037a6 <__udivdi3+0x46>
  80384e:	66 90                	xchg   %ax,%ax
  803850:	8b 54 24 08          	mov    0x8(%esp),%edx
  803854:	89 f9                	mov    %edi,%ecx
  803856:	d3 e2                	shl    %cl,%edx
  803858:	39 c2                	cmp    %eax,%edx
  80385a:	73 e9                	jae    803845 <__udivdi3+0xe5>
  80385c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80385f:	31 ff                	xor    %edi,%edi
  803861:	e9 40 ff ff ff       	jmp    8037a6 <__udivdi3+0x46>
  803866:	66 90                	xchg   %ax,%ax
  803868:	31 c0                	xor    %eax,%eax
  80386a:	e9 37 ff ff ff       	jmp    8037a6 <__udivdi3+0x46>
  80386f:	90                   	nop

00803870 <__umoddi3>:
  803870:	55                   	push   %ebp
  803871:	57                   	push   %edi
  803872:	56                   	push   %esi
  803873:	53                   	push   %ebx
  803874:	83 ec 1c             	sub    $0x1c,%esp
  803877:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80387b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80387f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803883:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803887:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80388b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80388f:	89 f3                	mov    %esi,%ebx
  803891:	89 fa                	mov    %edi,%edx
  803893:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803897:	89 34 24             	mov    %esi,(%esp)
  80389a:	85 c0                	test   %eax,%eax
  80389c:	75 1a                	jne    8038b8 <__umoddi3+0x48>
  80389e:	39 f7                	cmp    %esi,%edi
  8038a0:	0f 86 a2 00 00 00    	jbe    803948 <__umoddi3+0xd8>
  8038a6:	89 c8                	mov    %ecx,%eax
  8038a8:	89 f2                	mov    %esi,%edx
  8038aa:	f7 f7                	div    %edi
  8038ac:	89 d0                	mov    %edx,%eax
  8038ae:	31 d2                	xor    %edx,%edx
  8038b0:	83 c4 1c             	add    $0x1c,%esp
  8038b3:	5b                   	pop    %ebx
  8038b4:	5e                   	pop    %esi
  8038b5:	5f                   	pop    %edi
  8038b6:	5d                   	pop    %ebp
  8038b7:	c3                   	ret    
  8038b8:	39 f0                	cmp    %esi,%eax
  8038ba:	0f 87 ac 00 00 00    	ja     80396c <__umoddi3+0xfc>
  8038c0:	0f bd e8             	bsr    %eax,%ebp
  8038c3:	83 f5 1f             	xor    $0x1f,%ebp
  8038c6:	0f 84 ac 00 00 00    	je     803978 <__umoddi3+0x108>
  8038cc:	bf 20 00 00 00       	mov    $0x20,%edi
  8038d1:	29 ef                	sub    %ebp,%edi
  8038d3:	89 fe                	mov    %edi,%esi
  8038d5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8038d9:	89 e9                	mov    %ebp,%ecx
  8038db:	d3 e0                	shl    %cl,%eax
  8038dd:	89 d7                	mov    %edx,%edi
  8038df:	89 f1                	mov    %esi,%ecx
  8038e1:	d3 ef                	shr    %cl,%edi
  8038e3:	09 c7                	or     %eax,%edi
  8038e5:	89 e9                	mov    %ebp,%ecx
  8038e7:	d3 e2                	shl    %cl,%edx
  8038e9:	89 14 24             	mov    %edx,(%esp)
  8038ec:	89 d8                	mov    %ebx,%eax
  8038ee:	d3 e0                	shl    %cl,%eax
  8038f0:	89 c2                	mov    %eax,%edx
  8038f2:	8b 44 24 08          	mov    0x8(%esp),%eax
  8038f6:	d3 e0                	shl    %cl,%eax
  8038f8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8038fc:	8b 44 24 08          	mov    0x8(%esp),%eax
  803900:	89 f1                	mov    %esi,%ecx
  803902:	d3 e8                	shr    %cl,%eax
  803904:	09 d0                	or     %edx,%eax
  803906:	d3 eb                	shr    %cl,%ebx
  803908:	89 da                	mov    %ebx,%edx
  80390a:	f7 f7                	div    %edi
  80390c:	89 d3                	mov    %edx,%ebx
  80390e:	f7 24 24             	mull   (%esp)
  803911:	89 c6                	mov    %eax,%esi
  803913:	89 d1                	mov    %edx,%ecx
  803915:	39 d3                	cmp    %edx,%ebx
  803917:	0f 82 87 00 00 00    	jb     8039a4 <__umoddi3+0x134>
  80391d:	0f 84 91 00 00 00    	je     8039b4 <__umoddi3+0x144>
  803923:	8b 54 24 04          	mov    0x4(%esp),%edx
  803927:	29 f2                	sub    %esi,%edx
  803929:	19 cb                	sbb    %ecx,%ebx
  80392b:	89 d8                	mov    %ebx,%eax
  80392d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803931:	d3 e0                	shl    %cl,%eax
  803933:	89 e9                	mov    %ebp,%ecx
  803935:	d3 ea                	shr    %cl,%edx
  803937:	09 d0                	or     %edx,%eax
  803939:	89 e9                	mov    %ebp,%ecx
  80393b:	d3 eb                	shr    %cl,%ebx
  80393d:	89 da                	mov    %ebx,%edx
  80393f:	83 c4 1c             	add    $0x1c,%esp
  803942:	5b                   	pop    %ebx
  803943:	5e                   	pop    %esi
  803944:	5f                   	pop    %edi
  803945:	5d                   	pop    %ebp
  803946:	c3                   	ret    
  803947:	90                   	nop
  803948:	89 fd                	mov    %edi,%ebp
  80394a:	85 ff                	test   %edi,%edi
  80394c:	75 0b                	jne    803959 <__umoddi3+0xe9>
  80394e:	b8 01 00 00 00       	mov    $0x1,%eax
  803953:	31 d2                	xor    %edx,%edx
  803955:	f7 f7                	div    %edi
  803957:	89 c5                	mov    %eax,%ebp
  803959:	89 f0                	mov    %esi,%eax
  80395b:	31 d2                	xor    %edx,%edx
  80395d:	f7 f5                	div    %ebp
  80395f:	89 c8                	mov    %ecx,%eax
  803961:	f7 f5                	div    %ebp
  803963:	89 d0                	mov    %edx,%eax
  803965:	e9 44 ff ff ff       	jmp    8038ae <__umoddi3+0x3e>
  80396a:	66 90                	xchg   %ax,%ax
  80396c:	89 c8                	mov    %ecx,%eax
  80396e:	89 f2                	mov    %esi,%edx
  803970:	83 c4 1c             	add    $0x1c,%esp
  803973:	5b                   	pop    %ebx
  803974:	5e                   	pop    %esi
  803975:	5f                   	pop    %edi
  803976:	5d                   	pop    %ebp
  803977:	c3                   	ret    
  803978:	3b 04 24             	cmp    (%esp),%eax
  80397b:	72 06                	jb     803983 <__umoddi3+0x113>
  80397d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803981:	77 0f                	ja     803992 <__umoddi3+0x122>
  803983:	89 f2                	mov    %esi,%edx
  803985:	29 f9                	sub    %edi,%ecx
  803987:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80398b:	89 14 24             	mov    %edx,(%esp)
  80398e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803992:	8b 44 24 04          	mov    0x4(%esp),%eax
  803996:	8b 14 24             	mov    (%esp),%edx
  803999:	83 c4 1c             	add    $0x1c,%esp
  80399c:	5b                   	pop    %ebx
  80399d:	5e                   	pop    %esi
  80399e:	5f                   	pop    %edi
  80399f:	5d                   	pop    %ebp
  8039a0:	c3                   	ret    
  8039a1:	8d 76 00             	lea    0x0(%esi),%esi
  8039a4:	2b 04 24             	sub    (%esp),%eax
  8039a7:	19 fa                	sbb    %edi,%edx
  8039a9:	89 d1                	mov    %edx,%ecx
  8039ab:	89 c6                	mov    %eax,%esi
  8039ad:	e9 71 ff ff ff       	jmp    803923 <__umoddi3+0xb3>
  8039b2:	66 90                	xchg   %ax,%ax
  8039b4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8039b8:	72 ea                	jb     8039a4 <__umoddi3+0x134>
  8039ba:	89 d9                	mov    %ebx,%ecx
  8039bc:	e9 62 ff ff ff       	jmp    803923 <__umoddi3+0xb3>
