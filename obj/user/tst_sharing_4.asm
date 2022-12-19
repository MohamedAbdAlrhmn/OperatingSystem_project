
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
  80008d:	68 40 3b 80 00       	push   $0x803b40
  800092:	6a 12                	push   $0x12
  800094:	68 5c 3b 80 00       	push   $0x803b5c
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
  8000ae:	68 74 3b 80 00       	push   $0x803b74
  8000b3:	e8 af 08 00 00       	call   800967 <cprintf>
  8000b8:	83 c4 10             	add    $0x10,%esp
	cprintf("MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  8000bb:	83 ec 0c             	sub    $0xc,%esp
  8000be:	68 a8 3b 80 00       	push   $0x803ba8
  8000c3:	e8 9f 08 00 00       	call   800967 <cprintf>
  8000c8:	83 c4 10             	add    $0x10,%esp
	cprintf("************************************************\n\n\n");
  8000cb:	83 ec 0c             	sub    $0xc,%esp
  8000ce:	68 04 3c 80 00       	push   $0x803c04
  8000d3:	e8 8f 08 00 00       	call   800967 <cprintf>
  8000d8:	83 c4 10             	add    $0x10,%esp

	int Mega = 1024*1024;
  8000db:	c7 45 ec 00 00 10 00 	movl   $0x100000,-0x14(%ebp)
	int kilo = 1024;
  8000e2:	c7 45 e8 00 04 00 00 	movl   $0x400,-0x18(%ebp)
	int envID = sys_getenvid();
  8000e9:	e8 e5 1e 00 00       	call   801fd3 <sys_getenvid>
  8000ee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	cprintf("STEP A: checking free of a shared object ... \n");
  8000f1:	83 ec 0c             	sub    $0xc,%esp
  8000f4:	68 38 3c 80 00       	push   $0x803c38
  8000f9:	e8 69 08 00 00       	call   800967 <cprintf>
  8000fe:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x;
		int freeFrames = sys_calculate_free_frames() ;
  800101:	e8 06 1c 00 00       	call   801d0c <sys_calculate_free_frames>
  800106:	89 45 e0             	mov    %eax,-0x20(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  800109:	83 ec 04             	sub    $0x4,%esp
  80010c:	6a 01                	push   $0x1
  80010e:	68 00 10 00 00       	push   $0x1000
  800113:	68 67 3c 80 00       	push   $0x803c67
  800118:	e8 1d 19 00 00       	call   801a3a <smalloc>
  80011d:	83 c4 10             	add    $0x10,%esp
  800120:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (x != (uint32*)USER_HEAP_START) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  800123:	81 7d dc 00 00 00 80 	cmpl   $0x80000000,-0x24(%ebp)
  80012a:	74 14                	je     800140 <_main+0x108>
  80012c:	83 ec 04             	sub    $0x4,%esp
  80012f:	68 6c 3c 80 00       	push   $0x803c6c
  800134:	6a 24                	push   $0x24
  800136:	68 5c 3b 80 00       	push   $0x803b5c
  80013b:	e8 73 05 00 00       	call   8006b3 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800140:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800143:	e8 c4 1b 00 00       	call   801d0c <sys_calculate_free_frames>
  800148:	29 c3                	sub    %eax,%ebx
  80014a:	89 d8                	mov    %ebx,%eax
  80014c:	83 f8 04             	cmp    $0x4,%eax
  80014f:	74 14                	je     800165 <_main+0x12d>
  800151:	83 ec 04             	sub    $0x4,%esp
  800154:	68 d8 3c 80 00       	push   $0x803cd8
  800159:	6a 25                	push   $0x25
  80015b:	68 5c 3b 80 00       	push   $0x803b5c
  800160:	e8 4e 05 00 00       	call   8006b3 <_panic>

		sfree(x);
  800165:	83 ec 0c             	sub    $0xc,%esp
  800168:	ff 75 dc             	pushl  -0x24(%ebp)
  80016b:	e8 3c 1a 00 00       	call   801bac <sfree>
  800170:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) ==  0+0+2) panic("Wrong free: make sure that you free the shared object by calling free_share_object()");
  800173:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800176:	e8 91 1b 00 00       	call   801d0c <sys_calculate_free_frames>
  80017b:	29 c3                	sub    %eax,%ebx
  80017d:	89 d8                	mov    %ebx,%eax
  80017f:	83 f8 02             	cmp    $0x2,%eax
  800182:	75 14                	jne    800198 <_main+0x160>
  800184:	83 ec 04             	sub    $0x4,%esp
  800187:	68 58 3d 80 00       	push   $0x803d58
  80018c:	6a 28                	push   $0x28
  80018e:	68 5c 3b 80 00       	push   $0x803b5c
  800193:	e8 1b 05 00 00       	call   8006b3 <_panic>
		else if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong free: revise your freeSharedObject logic");
  800198:	e8 6f 1b 00 00       	call   801d0c <sys_calculate_free_frames>
  80019d:	89 c2                	mov    %eax,%edx
  80019f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001a2:	39 c2                	cmp    %eax,%edx
  8001a4:	74 14                	je     8001ba <_main+0x182>
  8001a6:	83 ec 04             	sub    $0x4,%esp
  8001a9:	68 b0 3d 80 00       	push   $0x803db0
  8001ae:	6a 29                	push   $0x29
  8001b0:	68 5c 3b 80 00       	push   $0x803b5c
  8001b5:	e8 f9 04 00 00       	call   8006b3 <_panic>
	}
	cprintf("Step A completed successfully!!\n\n\n");
  8001ba:	83 ec 0c             	sub    $0xc,%esp
  8001bd:	68 e0 3d 80 00       	push   $0x803de0
  8001c2:	e8 a0 07 00 00       	call   800967 <cprintf>
  8001c7:	83 c4 10             	add    $0x10,%esp


	cprintf("STEP B: checking free of 2 shared objects ... \n");
  8001ca:	83 ec 0c             	sub    $0xc,%esp
  8001cd:	68 04 3e 80 00       	push   $0x803e04
  8001d2:	e8 90 07 00 00       	call   800967 <cprintf>
  8001d7:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x, *z ;
		int freeFrames = sys_calculate_free_frames() ;
  8001da:	e8 2d 1b 00 00       	call   801d0c <sys_calculate_free_frames>
  8001df:	89 45 d8             	mov    %eax,-0x28(%ebp)
		z = smalloc("z", PAGE_SIZE, 1);
  8001e2:	83 ec 04             	sub    $0x4,%esp
  8001e5:	6a 01                	push   $0x1
  8001e7:	68 00 10 00 00       	push   $0x1000
  8001ec:	68 34 3e 80 00       	push   $0x803e34
  8001f1:	e8 44 18 00 00       	call   801a3a <smalloc>
  8001f6:	83 c4 10             	add    $0x10,%esp
  8001f9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8001fc:	83 ec 04             	sub    $0x4,%esp
  8001ff:	6a 01                	push   $0x1
  800201:	68 00 10 00 00       	push   $0x1000
  800206:	68 67 3c 80 00       	push   $0x803c67
  80020b:	e8 2a 18 00 00       	call   801a3a <smalloc>
  800210:	83 c4 10             	add    $0x10,%esp
  800213:	89 45 d0             	mov    %eax,-0x30(%ebp)

		if(x == NULL) panic("Wrong free: make sure that you free the shared object by calling free_share_object()");
  800216:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80021a:	75 14                	jne    800230 <_main+0x1f8>
  80021c:	83 ec 04             	sub    $0x4,%esp
  80021f:	68 58 3d 80 00       	push   $0x803d58
  800224:	6a 35                	push   $0x35
  800226:	68 5c 3b 80 00       	push   $0x803b5c
  80022b:	e8 83 04 00 00       	call   8006b3 <_panic>

		if ((freeFrames - sys_calculate_free_frames()) !=  2+1+4) panic("Wrong previous free: make sure that you correctly free shared object before (Step A)");
  800230:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800233:	e8 d4 1a 00 00       	call   801d0c <sys_calculate_free_frames>
  800238:	29 c3                	sub    %eax,%ebx
  80023a:	89 d8                	mov    %ebx,%eax
  80023c:	83 f8 07             	cmp    $0x7,%eax
  80023f:	74 14                	je     800255 <_main+0x21d>
  800241:	83 ec 04             	sub    $0x4,%esp
  800244:	68 38 3e 80 00       	push   $0x803e38
  800249:	6a 37                	push   $0x37
  80024b:	68 5c 3b 80 00       	push   $0x803b5c
  800250:	e8 5e 04 00 00       	call   8006b3 <_panic>

		sfree(z);
  800255:	83 ec 0c             	sub    $0xc,%esp
  800258:	ff 75 d4             	pushl  -0x2c(%ebp)
  80025b:	e8 4c 19 00 00       	call   801bac <sfree>
  800260:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong free: check your logic");
  800263:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800266:	e8 a1 1a 00 00       	call   801d0c <sys_calculate_free_frames>
  80026b:	29 c3                	sub    %eax,%ebx
  80026d:	89 d8                	mov    %ebx,%eax
  80026f:	83 f8 04             	cmp    $0x4,%eax
  800272:	74 14                	je     800288 <_main+0x250>
  800274:	83 ec 04             	sub    $0x4,%esp
  800277:	68 8d 3e 80 00       	push   $0x803e8d
  80027c:	6a 3a                	push   $0x3a
  80027e:	68 5c 3b 80 00       	push   $0x803b5c
  800283:	e8 2b 04 00 00       	call   8006b3 <_panic>

		sfree(x);
  800288:	83 ec 0c             	sub    $0xc,%esp
  80028b:	ff 75 d0             	pushl  -0x30(%ebp)
  80028e:	e8 19 19 00 00       	call   801bac <sfree>
  800293:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong free: check your logic");
  800296:	e8 71 1a 00 00       	call   801d0c <sys_calculate_free_frames>
  80029b:	89 c2                	mov    %eax,%edx
  80029d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8002a0:	39 c2                	cmp    %eax,%edx
  8002a2:	74 14                	je     8002b8 <_main+0x280>
  8002a4:	83 ec 04             	sub    $0x4,%esp
  8002a7:	68 8d 3e 80 00       	push   $0x803e8d
  8002ac:	6a 3d                	push   $0x3d
  8002ae:	68 5c 3b 80 00       	push   $0x803b5c
  8002b3:	e8 fb 03 00 00       	call   8006b3 <_panic>

	}
	cprintf("Step B completed successfully!!\n\n\n");
  8002b8:	83 ec 0c             	sub    $0xc,%esp
  8002bb:	68 ac 3e 80 00       	push   $0x803eac
  8002c0:	e8 a2 06 00 00       	call   800967 <cprintf>
  8002c5:	83 c4 10             	add    $0x10,%esp

	cprintf("STEP C: checking range of loop during free... \n");
  8002c8:	83 ec 0c             	sub    $0xc,%esp
  8002cb:	68 d0 3e 80 00       	push   $0x803ed0
  8002d0:	e8 92 06 00 00       	call   800967 <cprintf>
  8002d5:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *w, *u;
		int freeFrames = sys_calculate_free_frames() ;
  8002d8:	e8 2f 1a 00 00       	call   801d0c <sys_calculate_free_frames>
  8002dd:	89 45 cc             	mov    %eax,-0x34(%ebp)
		w = smalloc("w", 3 * PAGE_SIZE+1, 1);
  8002e0:	83 ec 04             	sub    $0x4,%esp
  8002e3:	6a 01                	push   $0x1
  8002e5:	68 01 30 00 00       	push   $0x3001
  8002ea:	68 00 3f 80 00       	push   $0x803f00
  8002ef:	e8 46 17 00 00       	call   801a3a <smalloc>
  8002f4:	83 c4 10             	add    $0x10,%esp
  8002f7:	89 45 c8             	mov    %eax,-0x38(%ebp)
		u = smalloc("u", PAGE_SIZE, 1);
  8002fa:	83 ec 04             	sub    $0x4,%esp
  8002fd:	6a 01                	push   $0x1
  8002ff:	68 00 10 00 00       	push   $0x1000
  800304:	68 02 3f 80 00       	push   $0x803f02
  800309:	e8 2c 17 00 00       	call   801a3a <smalloc>
  80030e:	83 c4 10             	add    $0x10,%esp
  800311:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		if ((freeFrames - sys_calculate_free_frames()) != 5+1+4) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800314:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800317:	e8 f0 19 00 00       	call   801d0c <sys_calculate_free_frames>
  80031c:	29 c3                	sub    %eax,%ebx
  80031e:	89 d8                	mov    %ebx,%eax
  800320:	83 f8 0a             	cmp    $0xa,%eax
  800323:	74 14                	je     800339 <_main+0x301>
  800325:	83 ec 04             	sub    $0x4,%esp
  800328:	68 d8 3c 80 00       	push   $0x803cd8
  80032d:	6a 48                	push   $0x48
  80032f:	68 5c 3b 80 00       	push   $0x803b5c
  800334:	e8 7a 03 00 00       	call   8006b3 <_panic>

		sfree(w);
  800339:	83 ec 0c             	sub    $0xc,%esp
  80033c:	ff 75 c8             	pushl  -0x38(%ebp)
  80033f:	e8 68 18 00 00       	call   801bac <sfree>
  800344:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong free: check your logic");
  800347:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  80034a:	e8 bd 19 00 00       	call   801d0c <sys_calculate_free_frames>
  80034f:	29 c3                	sub    %eax,%ebx
  800351:	89 d8                	mov    %ebx,%eax
  800353:	83 f8 04             	cmp    $0x4,%eax
  800356:	74 14                	je     80036c <_main+0x334>
  800358:	83 ec 04             	sub    $0x4,%esp
  80035b:	68 8d 3e 80 00       	push   $0x803e8d
  800360:	6a 4b                	push   $0x4b
  800362:	68 5c 3b 80 00       	push   $0x803b5c
  800367:	e8 47 03 00 00       	call   8006b3 <_panic>

		uint32 *o;

		o = smalloc("o", 2 * PAGE_SIZE-1,1);
  80036c:	83 ec 04             	sub    $0x4,%esp
  80036f:	6a 01                	push   $0x1
  800371:	68 ff 1f 00 00       	push   $0x1fff
  800376:	68 04 3f 80 00       	push   $0x803f04
  80037b:	e8 ba 16 00 00       	call   801a3a <smalloc>
  800380:	83 c4 10             	add    $0x10,%esp
  800383:	89 45 c0             	mov    %eax,-0x40(%ebp)

		cprintf("2\n");
  800386:	83 ec 0c             	sub    $0xc,%esp
  800389:	68 06 3f 80 00       	push   $0x803f06
  80038e:	e8 d4 05 00 00       	call   800967 <cprintf>
  800393:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) != 3+1+4) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800396:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800399:	e8 6e 19 00 00       	call   801d0c <sys_calculate_free_frames>
  80039e:	29 c3                	sub    %eax,%ebx
  8003a0:	89 d8                	mov    %ebx,%eax
  8003a2:	83 f8 08             	cmp    $0x8,%eax
  8003a5:	74 14                	je     8003bb <_main+0x383>
  8003a7:	83 ec 04             	sub    $0x4,%esp
  8003aa:	68 d8 3c 80 00       	push   $0x803cd8
  8003af:	6a 52                	push   $0x52
  8003b1:	68 5c 3b 80 00       	push   $0x803b5c
  8003b6:	e8 f8 02 00 00       	call   8006b3 <_panic>

		sfree(o);
  8003bb:	83 ec 0c             	sub    $0xc,%esp
  8003be:	ff 75 c0             	pushl  -0x40(%ebp)
  8003c1:	e8 e6 17 00 00       	call   801bac <sfree>
  8003c6:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong free: check your logic");
  8003c9:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8003cc:	e8 3b 19 00 00       	call   801d0c <sys_calculate_free_frames>
  8003d1:	29 c3                	sub    %eax,%ebx
  8003d3:	89 d8                	mov    %ebx,%eax
  8003d5:	83 f8 04             	cmp    $0x4,%eax
  8003d8:	74 14                	je     8003ee <_main+0x3b6>
  8003da:	83 ec 04             	sub    $0x4,%esp
  8003dd:	68 8d 3e 80 00       	push   $0x803e8d
  8003e2:	6a 55                	push   $0x55
  8003e4:	68 5c 3b 80 00       	push   $0x803b5c
  8003e9:	e8 c5 02 00 00       	call   8006b3 <_panic>

		sfree(u);
  8003ee:	83 ec 0c             	sub    $0xc,%esp
  8003f1:	ff 75 c4             	pushl  -0x3c(%ebp)
  8003f4:	e8 b3 17 00 00       	call   801bac <sfree>
  8003f9:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong free: check your logic");
  8003fc:	e8 0b 19 00 00       	call   801d0c <sys_calculate_free_frames>
  800401:	89 c2                	mov    %eax,%edx
  800403:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800406:	39 c2                	cmp    %eax,%edx
  800408:	74 14                	je     80041e <_main+0x3e6>
  80040a:	83 ec 04             	sub    $0x4,%esp
  80040d:	68 8d 3e 80 00       	push   $0x803e8d
  800412:	6a 58                	push   $0x58
  800414:	68 5c 3b 80 00       	push   $0x803b5c
  800419:	e8 95 02 00 00       	call   8006b3 <_panic>


		//Checking boundaries of page tables
		freeFrames = sys_calculate_free_frames() ;
  80041e:	e8 e9 18 00 00       	call   801d0c <sys_calculate_free_frames>
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
  800438:	68 00 3f 80 00       	push   $0x803f00
  80043d:	e8 f8 15 00 00       	call   801a3a <smalloc>
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
  80045e:	68 02 3f 80 00       	push   $0x803f02
  800463:	e8 d2 15 00 00       	call   801a3a <smalloc>
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
  800480:	68 04 3f 80 00       	push   $0x803f04
  800485:	e8 b0 15 00 00       	call   801a3a <smalloc>
  80048a:	83 c4 10             	add    $0x10,%esp
  80048d:	89 45 c0             	mov    %eax,-0x40(%ebp)

		if ((freeFrames - sys_calculate_free_frames()) != 3073+4+7) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800490:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800493:	e8 74 18 00 00       	call   801d0c <sys_calculate_free_frames>
  800498:	29 c3                	sub    %eax,%ebx
  80049a:	89 d8                	mov    %ebx,%eax
  80049c:	3d 0c 0c 00 00       	cmp    $0xc0c,%eax
  8004a1:	74 14                	je     8004b7 <_main+0x47f>
  8004a3:	83 ec 04             	sub    $0x4,%esp
  8004a6:	68 d8 3c 80 00       	push   $0x803cd8
  8004ab:	6a 61                	push   $0x61
  8004ad:	68 5c 3b 80 00       	push   $0x803b5c
  8004b2:	e8 fc 01 00 00       	call   8006b3 <_panic>

		sfree(o);
  8004b7:	83 ec 0c             	sub    $0xc,%esp
  8004ba:	ff 75 c0             	pushl  -0x40(%ebp)
  8004bd:	e8 ea 16 00 00       	call   801bac <sfree>
  8004c2:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  2560+3+5) panic("Wrong free: check your logic");
  8004c5:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8004c8:	e8 3f 18 00 00       	call   801d0c <sys_calculate_free_frames>
  8004cd:	29 c3                	sub    %eax,%ebx
  8004cf:	89 d8                	mov    %ebx,%eax
  8004d1:	3d 08 0a 00 00       	cmp    $0xa08,%eax
  8004d6:	74 14                	je     8004ec <_main+0x4b4>
  8004d8:	83 ec 04             	sub    $0x4,%esp
  8004db:	68 8d 3e 80 00       	push   $0x803e8d
  8004e0:	6a 64                	push   $0x64
  8004e2:	68 5c 3b 80 00       	push   $0x803b5c
  8004e7:	e8 c7 01 00 00       	call   8006b3 <_panic>

		sfree(w);
  8004ec:	83 ec 0c             	sub    $0xc,%esp
  8004ef:	ff 75 c8             	pushl  -0x38(%ebp)
  8004f2:	e8 b5 16 00 00       	call   801bac <sfree>
  8004f7:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  1792+3+3) panic("Wrong free: check your logic");
  8004fa:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8004fd:	e8 0a 18 00 00       	call   801d0c <sys_calculate_free_frames>
  800502:	29 c3                	sub    %eax,%ebx
  800504:	89 d8                	mov    %ebx,%eax
  800506:	3d 06 07 00 00       	cmp    $0x706,%eax
  80050b:	74 14                	je     800521 <_main+0x4e9>
  80050d:	83 ec 04             	sub    $0x4,%esp
  800510:	68 8d 3e 80 00       	push   $0x803e8d
  800515:	6a 67                	push   $0x67
  800517:	68 5c 3b 80 00       	push   $0x803b5c
  80051c:	e8 92 01 00 00       	call   8006b3 <_panic>

		sfree(u);
  800521:	83 ec 0c             	sub    $0xc,%esp
  800524:	ff 75 c4             	pushl  -0x3c(%ebp)
  800527:	e8 80 16 00 00       	call   801bac <sfree>
  80052c:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong free: check your logic");
  80052f:	e8 d8 17 00 00       	call   801d0c <sys_calculate_free_frames>
  800534:	89 c2                	mov    %eax,%edx
  800536:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800539:	39 c2                	cmp    %eax,%edx
  80053b:	74 14                	je     800551 <_main+0x519>
  80053d:	83 ec 04             	sub    $0x4,%esp
  800540:	68 8d 3e 80 00       	push   $0x803e8d
  800545:	6a 6a                	push   $0x6a
  800547:	68 5c 3b 80 00       	push   $0x803b5c
  80054c:	e8 62 01 00 00       	call   8006b3 <_panic>
	}
	cprintf("Step C completed successfully!!\n\n\n");
  800551:	83 ec 0c             	sub    $0xc,%esp
  800554:	68 0c 3f 80 00       	push   $0x803f0c
  800559:	e8 09 04 00 00       	call   800967 <cprintf>
  80055e:	83 c4 10             	add    $0x10,%esp

	cprintf("Congratulations!! Test of freeSharedObjects [4] completed successfully!!\n\n\n");
  800561:	83 ec 0c             	sub    $0xc,%esp
  800564:	68 30 3f 80 00       	push   $0x803f30
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
  80057d:	e8 6a 1a 00 00       	call   801fec <sys_getenvindex>
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
  8005e8:	e8 0c 18 00 00       	call   801df9 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8005ed:	83 ec 0c             	sub    $0xc,%esp
  8005f0:	68 94 3f 80 00       	push   $0x803f94
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
  800618:	68 bc 3f 80 00       	push   $0x803fbc
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
  800649:	68 e4 3f 80 00       	push   $0x803fe4
  80064e:	e8 14 03 00 00       	call   800967 <cprintf>
  800653:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800656:	a1 20 50 80 00       	mov    0x805020,%eax
  80065b:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800661:	83 ec 08             	sub    $0x8,%esp
  800664:	50                   	push   %eax
  800665:	68 3c 40 80 00       	push   $0x80403c
  80066a:	e8 f8 02 00 00       	call   800967 <cprintf>
  80066f:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800672:	83 ec 0c             	sub    $0xc,%esp
  800675:	68 94 3f 80 00       	push   $0x803f94
  80067a:	e8 e8 02 00 00       	call   800967 <cprintf>
  80067f:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800682:	e8 8c 17 00 00       	call   801e13 <sys_enable_interrupt>

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
  80069a:	e8 19 19 00 00       	call   801fb8 <sys_destroy_env>
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
  8006ab:	e8 6e 19 00 00       	call   80201e <sys_exit_env>
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
  8006d4:	68 50 40 80 00       	push   $0x804050
  8006d9:	e8 89 02 00 00       	call   800967 <cprintf>
  8006de:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8006e1:	a1 00 50 80 00       	mov    0x805000,%eax
  8006e6:	ff 75 0c             	pushl  0xc(%ebp)
  8006e9:	ff 75 08             	pushl  0x8(%ebp)
  8006ec:	50                   	push   %eax
  8006ed:	68 55 40 80 00       	push   $0x804055
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
  800711:	68 71 40 80 00       	push   $0x804071
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
  80073d:	68 74 40 80 00       	push   $0x804074
  800742:	6a 26                	push   $0x26
  800744:	68 c0 40 80 00       	push   $0x8040c0
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
  80080f:	68 cc 40 80 00       	push   $0x8040cc
  800814:	6a 3a                	push   $0x3a
  800816:	68 c0 40 80 00       	push   $0x8040c0
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
  80087f:	68 20 41 80 00       	push   $0x804120
  800884:	6a 44                	push   $0x44
  800886:	68 c0 40 80 00       	push   $0x8040c0
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
  8008d9:	e8 6d 13 00 00       	call   801c4b <sys_cputs>
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
  800950:	e8 f6 12 00 00       	call   801c4b <sys_cputs>
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
  80099a:	e8 5a 14 00 00       	call   801df9 <sys_disable_interrupt>
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
  8009ba:	e8 54 14 00 00       	call   801e13 <sys_enable_interrupt>
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
  800a04:	e8 c7 2e 00 00       	call   8038d0 <__udivdi3>
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
  800a54:	e8 87 2f 00 00       	call   8039e0 <__umoddi3>
  800a59:	83 c4 10             	add    $0x10,%esp
  800a5c:	05 94 43 80 00       	add    $0x804394,%eax
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
  800baf:	8b 04 85 b8 43 80 00 	mov    0x8043b8(,%eax,4),%eax
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
  800c90:	8b 34 9d 00 42 80 00 	mov    0x804200(,%ebx,4),%esi
  800c97:	85 f6                	test   %esi,%esi
  800c99:	75 19                	jne    800cb4 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800c9b:	53                   	push   %ebx
  800c9c:	68 a5 43 80 00       	push   $0x8043a5
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
  800cb5:	68 ae 43 80 00       	push   $0x8043ae
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
  800ce2:	be b1 43 80 00       	mov    $0x8043b1,%esi
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
  801708:	68 10 45 80 00       	push   $0x804510
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
  8017d8:	e8 b2 05 00 00       	call   801d8f <sys_allocate_chunk>
  8017dd:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8017e0:	a1 20 51 80 00       	mov    0x805120,%eax
  8017e5:	83 ec 0c             	sub    $0xc,%esp
  8017e8:	50                   	push   %eax
  8017e9:	e8 27 0c 00 00       	call   802415 <initialize_MemBlocksList>
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
  801816:	68 35 45 80 00       	push   $0x804535
  80181b:	6a 33                	push   $0x33
  80181d:	68 53 45 80 00       	push   $0x804553
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
  801895:	68 60 45 80 00       	push   $0x804560
  80189a:	6a 34                	push   $0x34
  80189c:	68 53 45 80 00       	push   $0x804553
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
  80192d:	e8 2b 08 00 00       	call   80215d <sys_isUHeapPlacementStrategyFIRSTFIT>
  801932:	85 c0                	test   %eax,%eax
  801934:	74 11                	je     801947 <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  801936:	83 ec 0c             	sub    $0xc,%esp
  801939:	ff 75 e8             	pushl  -0x18(%ebp)
  80193c:	e8 96 0e 00 00       	call   8027d7 <alloc_block_FF>
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
  801953:	e8 f2 0b 00 00       	call   80254a <insert_sorted_allocList>
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
  80196d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	struct MemBlock * free_block=find_block(&AllocMemBlocksList,(uint32)virtual_address);
  801970:	8b 45 08             	mov    0x8(%ebp),%eax
  801973:	83 ec 08             	sub    $0x8,%esp
  801976:	50                   	push   %eax
  801977:	68 40 50 80 00       	push   $0x805040
  80197c:	e8 71 0b 00 00       	call   8024f2 <find_block>
  801981:	83 c4 10             	add    $0x10,%esp
  801984:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(free_block!=NULL)
  801987:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80198b:	0f 84 a6 00 00 00    	je     801a37 <free+0xcd>
	{
		sys_free_user_mem(free_block->sva,free_block->size);
  801991:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801994:	8b 50 0c             	mov    0xc(%eax),%edx
  801997:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80199a:	8b 40 08             	mov    0x8(%eax),%eax
  80199d:	83 ec 08             	sub    $0x8,%esp
  8019a0:	52                   	push   %edx
  8019a1:	50                   	push   %eax
  8019a2:	e8 b0 03 00 00       	call   801d57 <sys_free_user_mem>
  8019a7:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,free_block);
  8019aa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8019ae:	75 14                	jne    8019c4 <free+0x5a>
  8019b0:	83 ec 04             	sub    $0x4,%esp
  8019b3:	68 35 45 80 00       	push   $0x804535
  8019b8:	6a 74                	push   $0x74
  8019ba:	68 53 45 80 00       	push   $0x804553
  8019bf:	e8 ef ec ff ff       	call   8006b3 <_panic>
  8019c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019c7:	8b 00                	mov    (%eax),%eax
  8019c9:	85 c0                	test   %eax,%eax
  8019cb:	74 10                	je     8019dd <free+0x73>
  8019cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019d0:	8b 00                	mov    (%eax),%eax
  8019d2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019d5:	8b 52 04             	mov    0x4(%edx),%edx
  8019d8:	89 50 04             	mov    %edx,0x4(%eax)
  8019db:	eb 0b                	jmp    8019e8 <free+0x7e>
  8019dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019e0:	8b 40 04             	mov    0x4(%eax),%eax
  8019e3:	a3 44 50 80 00       	mov    %eax,0x805044
  8019e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019eb:	8b 40 04             	mov    0x4(%eax),%eax
  8019ee:	85 c0                	test   %eax,%eax
  8019f0:	74 0f                	je     801a01 <free+0x97>
  8019f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019f5:	8b 40 04             	mov    0x4(%eax),%eax
  8019f8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019fb:	8b 12                	mov    (%edx),%edx
  8019fd:	89 10                	mov    %edx,(%eax)
  8019ff:	eb 0a                	jmp    801a0b <free+0xa1>
  801a01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a04:	8b 00                	mov    (%eax),%eax
  801a06:	a3 40 50 80 00       	mov    %eax,0x805040
  801a0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a0e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801a14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a17:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801a1e:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801a23:	48                   	dec    %eax
  801a24:	a3 4c 50 80 00       	mov    %eax,0x80504c
		insert_sorted_with_merge_freeList(free_block);
  801a29:	83 ec 0c             	sub    $0xc,%esp
  801a2c:	ff 75 f4             	pushl  -0xc(%ebp)
  801a2f:	e8 4e 17 00 00       	call   803182 <insert_sorted_with_merge_freeList>
  801a34:	83 c4 10             	add    $0x10,%esp
	}

	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  801a37:	90                   	nop
  801a38:	c9                   	leave  
  801a39:	c3                   	ret    

00801a3a <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801a3a:	55                   	push   %ebp
  801a3b:	89 e5                	mov    %esp,%ebp
  801a3d:	83 ec 38             	sub    $0x38,%esp
  801a40:	8b 45 10             	mov    0x10(%ebp),%eax
  801a43:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801a46:	e8 a6 fc ff ff       	call   8016f1 <InitializeUHeap>
	if (size == 0) return NULL ;
  801a4b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801a4f:	75 0a                	jne    801a5b <smalloc+0x21>
  801a51:	b8 00 00 00 00       	mov    $0x0,%eax
  801a56:	e9 8b 00 00 00       	jmp    801ae6 <smalloc+0xac>
	//	   Else, return NULL

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801a5b:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801a62:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a65:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a68:	01 d0                	add    %edx,%eax
  801a6a:	48                   	dec    %eax
  801a6b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801a6e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a71:	ba 00 00 00 00       	mov    $0x0,%edx
  801a76:	f7 75 f0             	divl   -0x10(%ebp)
  801a79:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a7c:	29 d0                	sub    %edx,%eax
  801a7e:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801a81:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801a88:	e8 d0 06 00 00       	call   80215d <sys_isUHeapPlacementStrategyFIRSTFIT>
  801a8d:	85 c0                	test   %eax,%eax
  801a8f:	74 11                	je     801aa2 <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  801a91:	83 ec 0c             	sub    $0xc,%esp
  801a94:	ff 75 e8             	pushl  -0x18(%ebp)
  801a97:	e8 3b 0d 00 00       	call   8027d7 <alloc_block_FF>
  801a9c:	83 c4 10             	add    $0x10,%esp
  801a9f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(mem_block != NULL)
  801aa2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801aa6:	74 39                	je     801ae1 <smalloc+0xa7>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801aa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801aab:	8b 40 08             	mov    0x8(%eax),%eax
  801aae:	89 c2                	mov    %eax,%edx
  801ab0:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801ab4:	52                   	push   %edx
  801ab5:	50                   	push   %eax
  801ab6:	ff 75 0c             	pushl  0xc(%ebp)
  801ab9:	ff 75 08             	pushl  0x8(%ebp)
  801abc:	e8 21 04 00 00       	call   801ee2 <sys_createSharedObject>
  801ac1:	83 c4 10             	add    $0x10,%esp
  801ac4:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  801ac7:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  801acb:	74 14                	je     801ae1 <smalloc+0xa7>
  801acd:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  801ad1:	74 0e                	je     801ae1 <smalloc+0xa7>
  801ad3:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  801ad7:	74 08                	je     801ae1 <smalloc+0xa7>
			return (void*) mem_block->sva;
  801ad9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801adc:	8b 40 08             	mov    0x8(%eax),%eax
  801adf:	eb 05                	jmp    801ae6 <smalloc+0xac>
	}
	return NULL;
  801ae1:	b8 00 00 00 00       	mov    $0x0,%eax

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801ae6:	c9                   	leave  
  801ae7:	c3                   	ret    

00801ae8 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801ae8:	55                   	push   %ebp
  801ae9:	89 e5                	mov    %esp,%ebp
  801aeb:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801aee:	e8 fe fb ff ff       	call   8016f1 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801af3:	83 ec 08             	sub    $0x8,%esp
  801af6:	ff 75 0c             	pushl  0xc(%ebp)
  801af9:	ff 75 08             	pushl  0x8(%ebp)
  801afc:	e8 0b 04 00 00       	call   801f0c <sys_getSizeOfSharedObject>
  801b01:	83 c4 10             	add    $0x10,%esp
  801b04:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size != E_SHARED_MEM_NOT_EXISTS)
  801b07:	83 7d f0 f0          	cmpl   $0xfffffff0,-0x10(%ebp)
  801b0b:	74 76                	je     801b83 <sget+0x9b>
	{
		uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801b0d:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801b14:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b17:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b1a:	01 d0                	add    %edx,%eax
  801b1c:	48                   	dec    %eax
  801b1d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801b20:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b23:	ba 00 00 00 00       	mov    $0x0,%edx
  801b28:	f7 75 ec             	divl   -0x14(%ebp)
  801b2b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b2e:	29 d0                	sub    %edx,%eax
  801b30:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		struct MemBlock * mem_block = NULL;
  801b33:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801b3a:	e8 1e 06 00 00       	call   80215d <sys_isUHeapPlacementStrategyFIRSTFIT>
  801b3f:	85 c0                	test   %eax,%eax
  801b41:	74 11                	je     801b54 <sget+0x6c>
			mem_block = alloc_block_FF(allocate_space);
  801b43:	83 ec 0c             	sub    $0xc,%esp
  801b46:	ff 75 e4             	pushl  -0x1c(%ebp)
  801b49:	e8 89 0c 00 00       	call   8027d7 <alloc_block_FF>
  801b4e:	83 c4 10             	add    $0x10,%esp
  801b51:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(mem_block != NULL)
  801b54:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801b58:	74 29                	je     801b83 <sget+0x9b>
		{
			uint32 shared_object_id = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)mem_block->sva);
  801b5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b5d:	8b 40 08             	mov    0x8(%eax),%eax
  801b60:	83 ec 04             	sub    $0x4,%esp
  801b63:	50                   	push   %eax
  801b64:	ff 75 0c             	pushl  0xc(%ebp)
  801b67:	ff 75 08             	pushl  0x8(%ebp)
  801b6a:	e8 ba 03 00 00       	call   801f29 <sys_getSharedObject>
  801b6f:	83 c4 10             	add    $0x10,%esp
  801b72:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (shared_object_id != E_SHARED_MEM_NOT_EXISTS)
  801b75:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%ebp)
  801b79:	74 08                	je     801b83 <sget+0x9b>
				return (void *)mem_block->sva;
  801b7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b7e:	8b 40 08             	mov    0x8(%eax),%eax
  801b81:	eb 05                	jmp    801b88 <sget+0xa0>
		}
	}
	return NULL;
  801b83:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801b88:	c9                   	leave  
  801b89:	c3                   	ret    

00801b8a <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801b8a:	55                   	push   %ebp
  801b8b:	89 e5                	mov    %esp,%ebp
  801b8d:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801b90:	e8 5c fb ff ff       	call   8016f1 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801b95:	83 ec 04             	sub    $0x4,%esp
  801b98:	68 84 45 80 00       	push   $0x804584
  801b9d:	68 f7 00 00 00       	push   $0xf7
  801ba2:	68 53 45 80 00       	push   $0x804553
  801ba7:	e8 07 eb ff ff       	call   8006b3 <_panic>

00801bac <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801bac:	55                   	push   %ebp
  801bad:	89 e5                	mov    %esp,%ebp
  801baf:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801bb2:	83 ec 04             	sub    $0x4,%esp
  801bb5:	68 ac 45 80 00       	push   $0x8045ac
  801bba:	68 0b 01 00 00       	push   $0x10b
  801bbf:	68 53 45 80 00       	push   $0x804553
  801bc4:	e8 ea ea ff ff       	call   8006b3 <_panic>

00801bc9 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801bc9:	55                   	push   %ebp
  801bca:	89 e5                	mov    %esp,%ebp
  801bcc:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801bcf:	83 ec 04             	sub    $0x4,%esp
  801bd2:	68 d0 45 80 00       	push   $0x8045d0
  801bd7:	68 16 01 00 00       	push   $0x116
  801bdc:	68 53 45 80 00       	push   $0x804553
  801be1:	e8 cd ea ff ff       	call   8006b3 <_panic>

00801be6 <shrink>:

}
void shrink(uint32 newSize)
{
  801be6:	55                   	push   %ebp
  801be7:	89 e5                	mov    %esp,%ebp
  801be9:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801bec:	83 ec 04             	sub    $0x4,%esp
  801bef:	68 d0 45 80 00       	push   $0x8045d0
  801bf4:	68 1b 01 00 00       	push   $0x11b
  801bf9:	68 53 45 80 00       	push   $0x804553
  801bfe:	e8 b0 ea ff ff       	call   8006b3 <_panic>

00801c03 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801c03:	55                   	push   %ebp
  801c04:	89 e5                	mov    %esp,%ebp
  801c06:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801c09:	83 ec 04             	sub    $0x4,%esp
  801c0c:	68 d0 45 80 00       	push   $0x8045d0
  801c11:	68 20 01 00 00       	push   $0x120
  801c16:	68 53 45 80 00       	push   $0x804553
  801c1b:	e8 93 ea ff ff       	call   8006b3 <_panic>

00801c20 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801c20:	55                   	push   %ebp
  801c21:	89 e5                	mov    %esp,%ebp
  801c23:	57                   	push   %edi
  801c24:	56                   	push   %esi
  801c25:	53                   	push   %ebx
  801c26:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801c29:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c2f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c32:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c35:	8b 7d 18             	mov    0x18(%ebp),%edi
  801c38:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801c3b:	cd 30                	int    $0x30
  801c3d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801c40:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801c43:	83 c4 10             	add    $0x10,%esp
  801c46:	5b                   	pop    %ebx
  801c47:	5e                   	pop    %esi
  801c48:	5f                   	pop    %edi
  801c49:	5d                   	pop    %ebp
  801c4a:	c3                   	ret    

00801c4b <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801c4b:	55                   	push   %ebp
  801c4c:	89 e5                	mov    %esp,%ebp
  801c4e:	83 ec 04             	sub    $0x4,%esp
  801c51:	8b 45 10             	mov    0x10(%ebp),%eax
  801c54:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801c57:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801c5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5e:	6a 00                	push   $0x0
  801c60:	6a 00                	push   $0x0
  801c62:	52                   	push   %edx
  801c63:	ff 75 0c             	pushl  0xc(%ebp)
  801c66:	50                   	push   %eax
  801c67:	6a 00                	push   $0x0
  801c69:	e8 b2 ff ff ff       	call   801c20 <syscall>
  801c6e:	83 c4 18             	add    $0x18,%esp
}
  801c71:	90                   	nop
  801c72:	c9                   	leave  
  801c73:	c3                   	ret    

00801c74 <sys_cgetc>:

int
sys_cgetc(void)
{
  801c74:	55                   	push   %ebp
  801c75:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801c77:	6a 00                	push   $0x0
  801c79:	6a 00                	push   $0x0
  801c7b:	6a 00                	push   $0x0
  801c7d:	6a 00                	push   $0x0
  801c7f:	6a 00                	push   $0x0
  801c81:	6a 01                	push   $0x1
  801c83:	e8 98 ff ff ff       	call   801c20 <syscall>
  801c88:	83 c4 18             	add    $0x18,%esp
}
  801c8b:	c9                   	leave  
  801c8c:	c3                   	ret    

00801c8d <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801c8d:	55                   	push   %ebp
  801c8e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801c90:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c93:	8b 45 08             	mov    0x8(%ebp),%eax
  801c96:	6a 00                	push   $0x0
  801c98:	6a 00                	push   $0x0
  801c9a:	6a 00                	push   $0x0
  801c9c:	52                   	push   %edx
  801c9d:	50                   	push   %eax
  801c9e:	6a 05                	push   $0x5
  801ca0:	e8 7b ff ff ff       	call   801c20 <syscall>
  801ca5:	83 c4 18             	add    $0x18,%esp
}
  801ca8:	c9                   	leave  
  801ca9:	c3                   	ret    

00801caa <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801caa:	55                   	push   %ebp
  801cab:	89 e5                	mov    %esp,%ebp
  801cad:	56                   	push   %esi
  801cae:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801caf:	8b 75 18             	mov    0x18(%ebp),%esi
  801cb2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801cb5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801cb8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cbb:	8b 45 08             	mov    0x8(%ebp),%eax
  801cbe:	56                   	push   %esi
  801cbf:	53                   	push   %ebx
  801cc0:	51                   	push   %ecx
  801cc1:	52                   	push   %edx
  801cc2:	50                   	push   %eax
  801cc3:	6a 06                	push   $0x6
  801cc5:	e8 56 ff ff ff       	call   801c20 <syscall>
  801cca:	83 c4 18             	add    $0x18,%esp
}
  801ccd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cd0:	5b                   	pop    %ebx
  801cd1:	5e                   	pop    %esi
  801cd2:	5d                   	pop    %ebp
  801cd3:	c3                   	ret    

00801cd4 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801cd4:	55                   	push   %ebp
  801cd5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801cd7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cda:	8b 45 08             	mov    0x8(%ebp),%eax
  801cdd:	6a 00                	push   $0x0
  801cdf:	6a 00                	push   $0x0
  801ce1:	6a 00                	push   $0x0
  801ce3:	52                   	push   %edx
  801ce4:	50                   	push   %eax
  801ce5:	6a 07                	push   $0x7
  801ce7:	e8 34 ff ff ff       	call   801c20 <syscall>
  801cec:	83 c4 18             	add    $0x18,%esp
}
  801cef:	c9                   	leave  
  801cf0:	c3                   	ret    

00801cf1 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801cf1:	55                   	push   %ebp
  801cf2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801cf4:	6a 00                	push   $0x0
  801cf6:	6a 00                	push   $0x0
  801cf8:	6a 00                	push   $0x0
  801cfa:	ff 75 0c             	pushl  0xc(%ebp)
  801cfd:	ff 75 08             	pushl  0x8(%ebp)
  801d00:	6a 08                	push   $0x8
  801d02:	e8 19 ff ff ff       	call   801c20 <syscall>
  801d07:	83 c4 18             	add    $0x18,%esp
}
  801d0a:	c9                   	leave  
  801d0b:	c3                   	ret    

00801d0c <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801d0c:	55                   	push   %ebp
  801d0d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801d0f:	6a 00                	push   $0x0
  801d11:	6a 00                	push   $0x0
  801d13:	6a 00                	push   $0x0
  801d15:	6a 00                	push   $0x0
  801d17:	6a 00                	push   $0x0
  801d19:	6a 09                	push   $0x9
  801d1b:	e8 00 ff ff ff       	call   801c20 <syscall>
  801d20:	83 c4 18             	add    $0x18,%esp
}
  801d23:	c9                   	leave  
  801d24:	c3                   	ret    

00801d25 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801d25:	55                   	push   %ebp
  801d26:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801d28:	6a 00                	push   $0x0
  801d2a:	6a 00                	push   $0x0
  801d2c:	6a 00                	push   $0x0
  801d2e:	6a 00                	push   $0x0
  801d30:	6a 00                	push   $0x0
  801d32:	6a 0a                	push   $0xa
  801d34:	e8 e7 fe ff ff       	call   801c20 <syscall>
  801d39:	83 c4 18             	add    $0x18,%esp
}
  801d3c:	c9                   	leave  
  801d3d:	c3                   	ret    

00801d3e <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801d3e:	55                   	push   %ebp
  801d3f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801d41:	6a 00                	push   $0x0
  801d43:	6a 00                	push   $0x0
  801d45:	6a 00                	push   $0x0
  801d47:	6a 00                	push   $0x0
  801d49:	6a 00                	push   $0x0
  801d4b:	6a 0b                	push   $0xb
  801d4d:	e8 ce fe ff ff       	call   801c20 <syscall>
  801d52:	83 c4 18             	add    $0x18,%esp
}
  801d55:	c9                   	leave  
  801d56:	c3                   	ret    

00801d57 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801d57:	55                   	push   %ebp
  801d58:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801d5a:	6a 00                	push   $0x0
  801d5c:	6a 00                	push   $0x0
  801d5e:	6a 00                	push   $0x0
  801d60:	ff 75 0c             	pushl  0xc(%ebp)
  801d63:	ff 75 08             	pushl  0x8(%ebp)
  801d66:	6a 0f                	push   $0xf
  801d68:	e8 b3 fe ff ff       	call   801c20 <syscall>
  801d6d:	83 c4 18             	add    $0x18,%esp
	return;
  801d70:	90                   	nop
}
  801d71:	c9                   	leave  
  801d72:	c3                   	ret    

00801d73 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801d73:	55                   	push   %ebp
  801d74:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801d76:	6a 00                	push   $0x0
  801d78:	6a 00                	push   $0x0
  801d7a:	6a 00                	push   $0x0
  801d7c:	ff 75 0c             	pushl  0xc(%ebp)
  801d7f:	ff 75 08             	pushl  0x8(%ebp)
  801d82:	6a 10                	push   $0x10
  801d84:	e8 97 fe ff ff       	call   801c20 <syscall>
  801d89:	83 c4 18             	add    $0x18,%esp
	return ;
  801d8c:	90                   	nop
}
  801d8d:	c9                   	leave  
  801d8e:	c3                   	ret    

00801d8f <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801d8f:	55                   	push   %ebp
  801d90:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801d92:	6a 00                	push   $0x0
  801d94:	6a 00                	push   $0x0
  801d96:	ff 75 10             	pushl  0x10(%ebp)
  801d99:	ff 75 0c             	pushl  0xc(%ebp)
  801d9c:	ff 75 08             	pushl  0x8(%ebp)
  801d9f:	6a 11                	push   $0x11
  801da1:	e8 7a fe ff ff       	call   801c20 <syscall>
  801da6:	83 c4 18             	add    $0x18,%esp
	return ;
  801da9:	90                   	nop
}
  801daa:	c9                   	leave  
  801dab:	c3                   	ret    

00801dac <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801dac:	55                   	push   %ebp
  801dad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801daf:	6a 00                	push   $0x0
  801db1:	6a 00                	push   $0x0
  801db3:	6a 00                	push   $0x0
  801db5:	6a 00                	push   $0x0
  801db7:	6a 00                	push   $0x0
  801db9:	6a 0c                	push   $0xc
  801dbb:	e8 60 fe ff ff       	call   801c20 <syscall>
  801dc0:	83 c4 18             	add    $0x18,%esp
}
  801dc3:	c9                   	leave  
  801dc4:	c3                   	ret    

00801dc5 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801dc5:	55                   	push   %ebp
  801dc6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801dc8:	6a 00                	push   $0x0
  801dca:	6a 00                	push   $0x0
  801dcc:	6a 00                	push   $0x0
  801dce:	6a 00                	push   $0x0
  801dd0:	ff 75 08             	pushl  0x8(%ebp)
  801dd3:	6a 0d                	push   $0xd
  801dd5:	e8 46 fe ff ff       	call   801c20 <syscall>
  801dda:	83 c4 18             	add    $0x18,%esp
}
  801ddd:	c9                   	leave  
  801dde:	c3                   	ret    

00801ddf <sys_scarce_memory>:

void sys_scarce_memory()
{
  801ddf:	55                   	push   %ebp
  801de0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801de2:	6a 00                	push   $0x0
  801de4:	6a 00                	push   $0x0
  801de6:	6a 00                	push   $0x0
  801de8:	6a 00                	push   $0x0
  801dea:	6a 00                	push   $0x0
  801dec:	6a 0e                	push   $0xe
  801dee:	e8 2d fe ff ff       	call   801c20 <syscall>
  801df3:	83 c4 18             	add    $0x18,%esp
}
  801df6:	90                   	nop
  801df7:	c9                   	leave  
  801df8:	c3                   	ret    

00801df9 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801df9:	55                   	push   %ebp
  801dfa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801dfc:	6a 00                	push   $0x0
  801dfe:	6a 00                	push   $0x0
  801e00:	6a 00                	push   $0x0
  801e02:	6a 00                	push   $0x0
  801e04:	6a 00                	push   $0x0
  801e06:	6a 13                	push   $0x13
  801e08:	e8 13 fe ff ff       	call   801c20 <syscall>
  801e0d:	83 c4 18             	add    $0x18,%esp
}
  801e10:	90                   	nop
  801e11:	c9                   	leave  
  801e12:	c3                   	ret    

00801e13 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801e13:	55                   	push   %ebp
  801e14:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801e16:	6a 00                	push   $0x0
  801e18:	6a 00                	push   $0x0
  801e1a:	6a 00                	push   $0x0
  801e1c:	6a 00                	push   $0x0
  801e1e:	6a 00                	push   $0x0
  801e20:	6a 14                	push   $0x14
  801e22:	e8 f9 fd ff ff       	call   801c20 <syscall>
  801e27:	83 c4 18             	add    $0x18,%esp
}
  801e2a:	90                   	nop
  801e2b:	c9                   	leave  
  801e2c:	c3                   	ret    

00801e2d <sys_cputc>:


void
sys_cputc(const char c)
{
  801e2d:	55                   	push   %ebp
  801e2e:	89 e5                	mov    %esp,%ebp
  801e30:	83 ec 04             	sub    $0x4,%esp
  801e33:	8b 45 08             	mov    0x8(%ebp),%eax
  801e36:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801e39:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801e3d:	6a 00                	push   $0x0
  801e3f:	6a 00                	push   $0x0
  801e41:	6a 00                	push   $0x0
  801e43:	6a 00                	push   $0x0
  801e45:	50                   	push   %eax
  801e46:	6a 15                	push   $0x15
  801e48:	e8 d3 fd ff ff       	call   801c20 <syscall>
  801e4d:	83 c4 18             	add    $0x18,%esp
}
  801e50:	90                   	nop
  801e51:	c9                   	leave  
  801e52:	c3                   	ret    

00801e53 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801e53:	55                   	push   %ebp
  801e54:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801e56:	6a 00                	push   $0x0
  801e58:	6a 00                	push   $0x0
  801e5a:	6a 00                	push   $0x0
  801e5c:	6a 00                	push   $0x0
  801e5e:	6a 00                	push   $0x0
  801e60:	6a 16                	push   $0x16
  801e62:	e8 b9 fd ff ff       	call   801c20 <syscall>
  801e67:	83 c4 18             	add    $0x18,%esp
}
  801e6a:	90                   	nop
  801e6b:	c9                   	leave  
  801e6c:	c3                   	ret    

00801e6d <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801e6d:	55                   	push   %ebp
  801e6e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801e70:	8b 45 08             	mov    0x8(%ebp),%eax
  801e73:	6a 00                	push   $0x0
  801e75:	6a 00                	push   $0x0
  801e77:	6a 00                	push   $0x0
  801e79:	ff 75 0c             	pushl  0xc(%ebp)
  801e7c:	50                   	push   %eax
  801e7d:	6a 17                	push   $0x17
  801e7f:	e8 9c fd ff ff       	call   801c20 <syscall>
  801e84:	83 c4 18             	add    $0x18,%esp
}
  801e87:	c9                   	leave  
  801e88:	c3                   	ret    

00801e89 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801e89:	55                   	push   %ebp
  801e8a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801e8c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e92:	6a 00                	push   $0x0
  801e94:	6a 00                	push   $0x0
  801e96:	6a 00                	push   $0x0
  801e98:	52                   	push   %edx
  801e99:	50                   	push   %eax
  801e9a:	6a 1a                	push   $0x1a
  801e9c:	e8 7f fd ff ff       	call   801c20 <syscall>
  801ea1:	83 c4 18             	add    $0x18,%esp
}
  801ea4:	c9                   	leave  
  801ea5:	c3                   	ret    

00801ea6 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801ea6:	55                   	push   %ebp
  801ea7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ea9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eac:	8b 45 08             	mov    0x8(%ebp),%eax
  801eaf:	6a 00                	push   $0x0
  801eb1:	6a 00                	push   $0x0
  801eb3:	6a 00                	push   $0x0
  801eb5:	52                   	push   %edx
  801eb6:	50                   	push   %eax
  801eb7:	6a 18                	push   $0x18
  801eb9:	e8 62 fd ff ff       	call   801c20 <syscall>
  801ebe:	83 c4 18             	add    $0x18,%esp
}
  801ec1:	90                   	nop
  801ec2:	c9                   	leave  
  801ec3:	c3                   	ret    

00801ec4 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801ec4:	55                   	push   %ebp
  801ec5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ec7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eca:	8b 45 08             	mov    0x8(%ebp),%eax
  801ecd:	6a 00                	push   $0x0
  801ecf:	6a 00                	push   $0x0
  801ed1:	6a 00                	push   $0x0
  801ed3:	52                   	push   %edx
  801ed4:	50                   	push   %eax
  801ed5:	6a 19                	push   $0x19
  801ed7:	e8 44 fd ff ff       	call   801c20 <syscall>
  801edc:	83 c4 18             	add    $0x18,%esp
}
  801edf:	90                   	nop
  801ee0:	c9                   	leave  
  801ee1:	c3                   	ret    

00801ee2 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801ee2:	55                   	push   %ebp
  801ee3:	89 e5                	mov    %esp,%ebp
  801ee5:	83 ec 04             	sub    $0x4,%esp
  801ee8:	8b 45 10             	mov    0x10(%ebp),%eax
  801eeb:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801eee:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801ef1:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ef5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef8:	6a 00                	push   $0x0
  801efa:	51                   	push   %ecx
  801efb:	52                   	push   %edx
  801efc:	ff 75 0c             	pushl  0xc(%ebp)
  801eff:	50                   	push   %eax
  801f00:	6a 1b                	push   $0x1b
  801f02:	e8 19 fd ff ff       	call   801c20 <syscall>
  801f07:	83 c4 18             	add    $0x18,%esp
}
  801f0a:	c9                   	leave  
  801f0b:	c3                   	ret    

00801f0c <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801f0c:	55                   	push   %ebp
  801f0d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801f0f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f12:	8b 45 08             	mov    0x8(%ebp),%eax
  801f15:	6a 00                	push   $0x0
  801f17:	6a 00                	push   $0x0
  801f19:	6a 00                	push   $0x0
  801f1b:	52                   	push   %edx
  801f1c:	50                   	push   %eax
  801f1d:	6a 1c                	push   $0x1c
  801f1f:	e8 fc fc ff ff       	call   801c20 <syscall>
  801f24:	83 c4 18             	add    $0x18,%esp
}
  801f27:	c9                   	leave  
  801f28:	c3                   	ret    

00801f29 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801f29:	55                   	push   %ebp
  801f2a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801f2c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f2f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f32:	8b 45 08             	mov    0x8(%ebp),%eax
  801f35:	6a 00                	push   $0x0
  801f37:	6a 00                	push   $0x0
  801f39:	51                   	push   %ecx
  801f3a:	52                   	push   %edx
  801f3b:	50                   	push   %eax
  801f3c:	6a 1d                	push   $0x1d
  801f3e:	e8 dd fc ff ff       	call   801c20 <syscall>
  801f43:	83 c4 18             	add    $0x18,%esp
}
  801f46:	c9                   	leave  
  801f47:	c3                   	ret    

00801f48 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801f48:	55                   	push   %ebp
  801f49:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801f4b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f4e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f51:	6a 00                	push   $0x0
  801f53:	6a 00                	push   $0x0
  801f55:	6a 00                	push   $0x0
  801f57:	52                   	push   %edx
  801f58:	50                   	push   %eax
  801f59:	6a 1e                	push   $0x1e
  801f5b:	e8 c0 fc ff ff       	call   801c20 <syscall>
  801f60:	83 c4 18             	add    $0x18,%esp
}
  801f63:	c9                   	leave  
  801f64:	c3                   	ret    

00801f65 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801f65:	55                   	push   %ebp
  801f66:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801f68:	6a 00                	push   $0x0
  801f6a:	6a 00                	push   $0x0
  801f6c:	6a 00                	push   $0x0
  801f6e:	6a 00                	push   $0x0
  801f70:	6a 00                	push   $0x0
  801f72:	6a 1f                	push   $0x1f
  801f74:	e8 a7 fc ff ff       	call   801c20 <syscall>
  801f79:	83 c4 18             	add    $0x18,%esp
}
  801f7c:	c9                   	leave  
  801f7d:	c3                   	ret    

00801f7e <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801f7e:	55                   	push   %ebp
  801f7f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801f81:	8b 45 08             	mov    0x8(%ebp),%eax
  801f84:	6a 00                	push   $0x0
  801f86:	ff 75 14             	pushl  0x14(%ebp)
  801f89:	ff 75 10             	pushl  0x10(%ebp)
  801f8c:	ff 75 0c             	pushl  0xc(%ebp)
  801f8f:	50                   	push   %eax
  801f90:	6a 20                	push   $0x20
  801f92:	e8 89 fc ff ff       	call   801c20 <syscall>
  801f97:	83 c4 18             	add    $0x18,%esp
}
  801f9a:	c9                   	leave  
  801f9b:	c3                   	ret    

00801f9c <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801f9c:	55                   	push   %ebp
  801f9d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801f9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa2:	6a 00                	push   $0x0
  801fa4:	6a 00                	push   $0x0
  801fa6:	6a 00                	push   $0x0
  801fa8:	6a 00                	push   $0x0
  801faa:	50                   	push   %eax
  801fab:	6a 21                	push   $0x21
  801fad:	e8 6e fc ff ff       	call   801c20 <syscall>
  801fb2:	83 c4 18             	add    $0x18,%esp
}
  801fb5:	90                   	nop
  801fb6:	c9                   	leave  
  801fb7:	c3                   	ret    

00801fb8 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801fb8:	55                   	push   %ebp
  801fb9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801fbb:	8b 45 08             	mov    0x8(%ebp),%eax
  801fbe:	6a 00                	push   $0x0
  801fc0:	6a 00                	push   $0x0
  801fc2:	6a 00                	push   $0x0
  801fc4:	6a 00                	push   $0x0
  801fc6:	50                   	push   %eax
  801fc7:	6a 22                	push   $0x22
  801fc9:	e8 52 fc ff ff       	call   801c20 <syscall>
  801fce:	83 c4 18             	add    $0x18,%esp
}
  801fd1:	c9                   	leave  
  801fd2:	c3                   	ret    

00801fd3 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801fd3:	55                   	push   %ebp
  801fd4:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801fd6:	6a 00                	push   $0x0
  801fd8:	6a 00                	push   $0x0
  801fda:	6a 00                	push   $0x0
  801fdc:	6a 00                	push   $0x0
  801fde:	6a 00                	push   $0x0
  801fe0:	6a 02                	push   $0x2
  801fe2:	e8 39 fc ff ff       	call   801c20 <syscall>
  801fe7:	83 c4 18             	add    $0x18,%esp
}
  801fea:	c9                   	leave  
  801feb:	c3                   	ret    

00801fec <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801fec:	55                   	push   %ebp
  801fed:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801fef:	6a 00                	push   $0x0
  801ff1:	6a 00                	push   $0x0
  801ff3:	6a 00                	push   $0x0
  801ff5:	6a 00                	push   $0x0
  801ff7:	6a 00                	push   $0x0
  801ff9:	6a 03                	push   $0x3
  801ffb:	e8 20 fc ff ff       	call   801c20 <syscall>
  802000:	83 c4 18             	add    $0x18,%esp
}
  802003:	c9                   	leave  
  802004:	c3                   	ret    

00802005 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802005:	55                   	push   %ebp
  802006:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802008:	6a 00                	push   $0x0
  80200a:	6a 00                	push   $0x0
  80200c:	6a 00                	push   $0x0
  80200e:	6a 00                	push   $0x0
  802010:	6a 00                	push   $0x0
  802012:	6a 04                	push   $0x4
  802014:	e8 07 fc ff ff       	call   801c20 <syscall>
  802019:	83 c4 18             	add    $0x18,%esp
}
  80201c:	c9                   	leave  
  80201d:	c3                   	ret    

0080201e <sys_exit_env>:


void sys_exit_env(void)
{
  80201e:	55                   	push   %ebp
  80201f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802021:	6a 00                	push   $0x0
  802023:	6a 00                	push   $0x0
  802025:	6a 00                	push   $0x0
  802027:	6a 00                	push   $0x0
  802029:	6a 00                	push   $0x0
  80202b:	6a 23                	push   $0x23
  80202d:	e8 ee fb ff ff       	call   801c20 <syscall>
  802032:	83 c4 18             	add    $0x18,%esp
}
  802035:	90                   	nop
  802036:	c9                   	leave  
  802037:	c3                   	ret    

00802038 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802038:	55                   	push   %ebp
  802039:	89 e5                	mov    %esp,%ebp
  80203b:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80203e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802041:	8d 50 04             	lea    0x4(%eax),%edx
  802044:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802047:	6a 00                	push   $0x0
  802049:	6a 00                	push   $0x0
  80204b:	6a 00                	push   $0x0
  80204d:	52                   	push   %edx
  80204e:	50                   	push   %eax
  80204f:	6a 24                	push   $0x24
  802051:	e8 ca fb ff ff       	call   801c20 <syscall>
  802056:	83 c4 18             	add    $0x18,%esp
	return result;
  802059:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80205c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80205f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802062:	89 01                	mov    %eax,(%ecx)
  802064:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802067:	8b 45 08             	mov    0x8(%ebp),%eax
  80206a:	c9                   	leave  
  80206b:	c2 04 00             	ret    $0x4

0080206e <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80206e:	55                   	push   %ebp
  80206f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802071:	6a 00                	push   $0x0
  802073:	6a 00                	push   $0x0
  802075:	ff 75 10             	pushl  0x10(%ebp)
  802078:	ff 75 0c             	pushl  0xc(%ebp)
  80207b:	ff 75 08             	pushl  0x8(%ebp)
  80207e:	6a 12                	push   $0x12
  802080:	e8 9b fb ff ff       	call   801c20 <syscall>
  802085:	83 c4 18             	add    $0x18,%esp
	return ;
  802088:	90                   	nop
}
  802089:	c9                   	leave  
  80208a:	c3                   	ret    

0080208b <sys_rcr2>:
uint32 sys_rcr2()
{
  80208b:	55                   	push   %ebp
  80208c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80208e:	6a 00                	push   $0x0
  802090:	6a 00                	push   $0x0
  802092:	6a 00                	push   $0x0
  802094:	6a 00                	push   $0x0
  802096:	6a 00                	push   $0x0
  802098:	6a 25                	push   $0x25
  80209a:	e8 81 fb ff ff       	call   801c20 <syscall>
  80209f:	83 c4 18             	add    $0x18,%esp
}
  8020a2:	c9                   	leave  
  8020a3:	c3                   	ret    

008020a4 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8020a4:	55                   	push   %ebp
  8020a5:	89 e5                	mov    %esp,%ebp
  8020a7:	83 ec 04             	sub    $0x4,%esp
  8020aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ad:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8020b0:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8020b4:	6a 00                	push   $0x0
  8020b6:	6a 00                	push   $0x0
  8020b8:	6a 00                	push   $0x0
  8020ba:	6a 00                	push   $0x0
  8020bc:	50                   	push   %eax
  8020bd:	6a 26                	push   $0x26
  8020bf:	e8 5c fb ff ff       	call   801c20 <syscall>
  8020c4:	83 c4 18             	add    $0x18,%esp
	return ;
  8020c7:	90                   	nop
}
  8020c8:	c9                   	leave  
  8020c9:	c3                   	ret    

008020ca <rsttst>:
void rsttst()
{
  8020ca:	55                   	push   %ebp
  8020cb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8020cd:	6a 00                	push   $0x0
  8020cf:	6a 00                	push   $0x0
  8020d1:	6a 00                	push   $0x0
  8020d3:	6a 00                	push   $0x0
  8020d5:	6a 00                	push   $0x0
  8020d7:	6a 28                	push   $0x28
  8020d9:	e8 42 fb ff ff       	call   801c20 <syscall>
  8020de:	83 c4 18             	add    $0x18,%esp
	return ;
  8020e1:	90                   	nop
}
  8020e2:	c9                   	leave  
  8020e3:	c3                   	ret    

008020e4 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8020e4:	55                   	push   %ebp
  8020e5:	89 e5                	mov    %esp,%ebp
  8020e7:	83 ec 04             	sub    $0x4,%esp
  8020ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8020ed:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8020f0:	8b 55 18             	mov    0x18(%ebp),%edx
  8020f3:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8020f7:	52                   	push   %edx
  8020f8:	50                   	push   %eax
  8020f9:	ff 75 10             	pushl  0x10(%ebp)
  8020fc:	ff 75 0c             	pushl  0xc(%ebp)
  8020ff:	ff 75 08             	pushl  0x8(%ebp)
  802102:	6a 27                	push   $0x27
  802104:	e8 17 fb ff ff       	call   801c20 <syscall>
  802109:	83 c4 18             	add    $0x18,%esp
	return ;
  80210c:	90                   	nop
}
  80210d:	c9                   	leave  
  80210e:	c3                   	ret    

0080210f <chktst>:
void chktst(uint32 n)
{
  80210f:	55                   	push   %ebp
  802110:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802112:	6a 00                	push   $0x0
  802114:	6a 00                	push   $0x0
  802116:	6a 00                	push   $0x0
  802118:	6a 00                	push   $0x0
  80211a:	ff 75 08             	pushl  0x8(%ebp)
  80211d:	6a 29                	push   $0x29
  80211f:	e8 fc fa ff ff       	call   801c20 <syscall>
  802124:	83 c4 18             	add    $0x18,%esp
	return ;
  802127:	90                   	nop
}
  802128:	c9                   	leave  
  802129:	c3                   	ret    

0080212a <inctst>:

void inctst()
{
  80212a:	55                   	push   %ebp
  80212b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80212d:	6a 00                	push   $0x0
  80212f:	6a 00                	push   $0x0
  802131:	6a 00                	push   $0x0
  802133:	6a 00                	push   $0x0
  802135:	6a 00                	push   $0x0
  802137:	6a 2a                	push   $0x2a
  802139:	e8 e2 fa ff ff       	call   801c20 <syscall>
  80213e:	83 c4 18             	add    $0x18,%esp
	return ;
  802141:	90                   	nop
}
  802142:	c9                   	leave  
  802143:	c3                   	ret    

00802144 <gettst>:
uint32 gettst()
{
  802144:	55                   	push   %ebp
  802145:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802147:	6a 00                	push   $0x0
  802149:	6a 00                	push   $0x0
  80214b:	6a 00                	push   $0x0
  80214d:	6a 00                	push   $0x0
  80214f:	6a 00                	push   $0x0
  802151:	6a 2b                	push   $0x2b
  802153:	e8 c8 fa ff ff       	call   801c20 <syscall>
  802158:	83 c4 18             	add    $0x18,%esp
}
  80215b:	c9                   	leave  
  80215c:	c3                   	ret    

0080215d <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80215d:	55                   	push   %ebp
  80215e:	89 e5                	mov    %esp,%ebp
  802160:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802163:	6a 00                	push   $0x0
  802165:	6a 00                	push   $0x0
  802167:	6a 00                	push   $0x0
  802169:	6a 00                	push   $0x0
  80216b:	6a 00                	push   $0x0
  80216d:	6a 2c                	push   $0x2c
  80216f:	e8 ac fa ff ff       	call   801c20 <syscall>
  802174:	83 c4 18             	add    $0x18,%esp
  802177:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80217a:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80217e:	75 07                	jne    802187 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802180:	b8 01 00 00 00       	mov    $0x1,%eax
  802185:	eb 05                	jmp    80218c <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802187:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80218c:	c9                   	leave  
  80218d:	c3                   	ret    

0080218e <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80218e:	55                   	push   %ebp
  80218f:	89 e5                	mov    %esp,%ebp
  802191:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802194:	6a 00                	push   $0x0
  802196:	6a 00                	push   $0x0
  802198:	6a 00                	push   $0x0
  80219a:	6a 00                	push   $0x0
  80219c:	6a 00                	push   $0x0
  80219e:	6a 2c                	push   $0x2c
  8021a0:	e8 7b fa ff ff       	call   801c20 <syscall>
  8021a5:	83 c4 18             	add    $0x18,%esp
  8021a8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8021ab:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8021af:	75 07                	jne    8021b8 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8021b1:	b8 01 00 00 00       	mov    $0x1,%eax
  8021b6:	eb 05                	jmp    8021bd <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8021b8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021bd:	c9                   	leave  
  8021be:	c3                   	ret    

008021bf <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8021bf:	55                   	push   %ebp
  8021c0:	89 e5                	mov    %esp,%ebp
  8021c2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8021c5:	6a 00                	push   $0x0
  8021c7:	6a 00                	push   $0x0
  8021c9:	6a 00                	push   $0x0
  8021cb:	6a 00                	push   $0x0
  8021cd:	6a 00                	push   $0x0
  8021cf:	6a 2c                	push   $0x2c
  8021d1:	e8 4a fa ff ff       	call   801c20 <syscall>
  8021d6:	83 c4 18             	add    $0x18,%esp
  8021d9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8021dc:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8021e0:	75 07                	jne    8021e9 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8021e2:	b8 01 00 00 00       	mov    $0x1,%eax
  8021e7:	eb 05                	jmp    8021ee <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8021e9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021ee:	c9                   	leave  
  8021ef:	c3                   	ret    

008021f0 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8021f0:	55                   	push   %ebp
  8021f1:	89 e5                	mov    %esp,%ebp
  8021f3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8021f6:	6a 00                	push   $0x0
  8021f8:	6a 00                	push   $0x0
  8021fa:	6a 00                	push   $0x0
  8021fc:	6a 00                	push   $0x0
  8021fe:	6a 00                	push   $0x0
  802200:	6a 2c                	push   $0x2c
  802202:	e8 19 fa ff ff       	call   801c20 <syscall>
  802207:	83 c4 18             	add    $0x18,%esp
  80220a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80220d:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802211:	75 07                	jne    80221a <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802213:	b8 01 00 00 00       	mov    $0x1,%eax
  802218:	eb 05                	jmp    80221f <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80221a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80221f:	c9                   	leave  
  802220:	c3                   	ret    

00802221 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802221:	55                   	push   %ebp
  802222:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802224:	6a 00                	push   $0x0
  802226:	6a 00                	push   $0x0
  802228:	6a 00                	push   $0x0
  80222a:	6a 00                	push   $0x0
  80222c:	ff 75 08             	pushl  0x8(%ebp)
  80222f:	6a 2d                	push   $0x2d
  802231:	e8 ea f9 ff ff       	call   801c20 <syscall>
  802236:	83 c4 18             	add    $0x18,%esp
	return ;
  802239:	90                   	nop
}
  80223a:	c9                   	leave  
  80223b:	c3                   	ret    

0080223c <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80223c:	55                   	push   %ebp
  80223d:	89 e5                	mov    %esp,%ebp
  80223f:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802240:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802243:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802246:	8b 55 0c             	mov    0xc(%ebp),%edx
  802249:	8b 45 08             	mov    0x8(%ebp),%eax
  80224c:	6a 00                	push   $0x0
  80224e:	53                   	push   %ebx
  80224f:	51                   	push   %ecx
  802250:	52                   	push   %edx
  802251:	50                   	push   %eax
  802252:	6a 2e                	push   $0x2e
  802254:	e8 c7 f9 ff ff       	call   801c20 <syscall>
  802259:	83 c4 18             	add    $0x18,%esp
}
  80225c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80225f:	c9                   	leave  
  802260:	c3                   	ret    

00802261 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802261:	55                   	push   %ebp
  802262:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802264:	8b 55 0c             	mov    0xc(%ebp),%edx
  802267:	8b 45 08             	mov    0x8(%ebp),%eax
  80226a:	6a 00                	push   $0x0
  80226c:	6a 00                	push   $0x0
  80226e:	6a 00                	push   $0x0
  802270:	52                   	push   %edx
  802271:	50                   	push   %eax
  802272:	6a 2f                	push   $0x2f
  802274:	e8 a7 f9 ff ff       	call   801c20 <syscall>
  802279:	83 c4 18             	add    $0x18,%esp
}
  80227c:	c9                   	leave  
  80227d:	c3                   	ret    

0080227e <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  80227e:	55                   	push   %ebp
  80227f:	89 e5                	mov    %esp,%ebp
  802281:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802284:	83 ec 0c             	sub    $0xc,%esp
  802287:	68 e0 45 80 00       	push   $0x8045e0
  80228c:	e8 d6 e6 ff ff       	call   800967 <cprintf>
  802291:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802294:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  80229b:	83 ec 0c             	sub    $0xc,%esp
  80229e:	68 0c 46 80 00       	push   $0x80460c
  8022a3:	e8 bf e6 ff ff       	call   800967 <cprintf>
  8022a8:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8022ab:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8022af:	a1 38 51 80 00       	mov    0x805138,%eax
  8022b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022b7:	eb 56                	jmp    80230f <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8022b9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8022bd:	74 1c                	je     8022db <print_mem_block_lists+0x5d>
  8022bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c2:	8b 50 08             	mov    0x8(%eax),%edx
  8022c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022c8:	8b 48 08             	mov    0x8(%eax),%ecx
  8022cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022ce:	8b 40 0c             	mov    0xc(%eax),%eax
  8022d1:	01 c8                	add    %ecx,%eax
  8022d3:	39 c2                	cmp    %eax,%edx
  8022d5:	73 04                	jae    8022db <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8022d7:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8022db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022de:	8b 50 08             	mov    0x8(%eax),%edx
  8022e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e4:	8b 40 0c             	mov    0xc(%eax),%eax
  8022e7:	01 c2                	add    %eax,%edx
  8022e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ec:	8b 40 08             	mov    0x8(%eax),%eax
  8022ef:	83 ec 04             	sub    $0x4,%esp
  8022f2:	52                   	push   %edx
  8022f3:	50                   	push   %eax
  8022f4:	68 21 46 80 00       	push   $0x804621
  8022f9:	e8 69 e6 ff ff       	call   800967 <cprintf>
  8022fe:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802301:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802304:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802307:	a1 40 51 80 00       	mov    0x805140,%eax
  80230c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80230f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802313:	74 07                	je     80231c <print_mem_block_lists+0x9e>
  802315:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802318:	8b 00                	mov    (%eax),%eax
  80231a:	eb 05                	jmp    802321 <print_mem_block_lists+0xa3>
  80231c:	b8 00 00 00 00       	mov    $0x0,%eax
  802321:	a3 40 51 80 00       	mov    %eax,0x805140
  802326:	a1 40 51 80 00       	mov    0x805140,%eax
  80232b:	85 c0                	test   %eax,%eax
  80232d:	75 8a                	jne    8022b9 <print_mem_block_lists+0x3b>
  80232f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802333:	75 84                	jne    8022b9 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802335:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802339:	75 10                	jne    80234b <print_mem_block_lists+0xcd>
  80233b:	83 ec 0c             	sub    $0xc,%esp
  80233e:	68 30 46 80 00       	push   $0x804630
  802343:	e8 1f e6 ff ff       	call   800967 <cprintf>
  802348:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  80234b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802352:	83 ec 0c             	sub    $0xc,%esp
  802355:	68 54 46 80 00       	push   $0x804654
  80235a:	e8 08 e6 ff ff       	call   800967 <cprintf>
  80235f:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802362:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802366:	a1 40 50 80 00       	mov    0x805040,%eax
  80236b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80236e:	eb 56                	jmp    8023c6 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802370:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802374:	74 1c                	je     802392 <print_mem_block_lists+0x114>
  802376:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802379:	8b 50 08             	mov    0x8(%eax),%edx
  80237c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80237f:	8b 48 08             	mov    0x8(%eax),%ecx
  802382:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802385:	8b 40 0c             	mov    0xc(%eax),%eax
  802388:	01 c8                	add    %ecx,%eax
  80238a:	39 c2                	cmp    %eax,%edx
  80238c:	73 04                	jae    802392 <print_mem_block_lists+0x114>
			sorted = 0 ;
  80238e:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802392:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802395:	8b 50 08             	mov    0x8(%eax),%edx
  802398:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80239b:	8b 40 0c             	mov    0xc(%eax),%eax
  80239e:	01 c2                	add    %eax,%edx
  8023a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a3:	8b 40 08             	mov    0x8(%eax),%eax
  8023a6:	83 ec 04             	sub    $0x4,%esp
  8023a9:	52                   	push   %edx
  8023aa:	50                   	push   %eax
  8023ab:	68 21 46 80 00       	push   $0x804621
  8023b0:	e8 b2 e5 ff ff       	call   800967 <cprintf>
  8023b5:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8023b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8023be:	a1 48 50 80 00       	mov    0x805048,%eax
  8023c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023c6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023ca:	74 07                	je     8023d3 <print_mem_block_lists+0x155>
  8023cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023cf:	8b 00                	mov    (%eax),%eax
  8023d1:	eb 05                	jmp    8023d8 <print_mem_block_lists+0x15a>
  8023d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8023d8:	a3 48 50 80 00       	mov    %eax,0x805048
  8023dd:	a1 48 50 80 00       	mov    0x805048,%eax
  8023e2:	85 c0                	test   %eax,%eax
  8023e4:	75 8a                	jne    802370 <print_mem_block_lists+0xf2>
  8023e6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023ea:	75 84                	jne    802370 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8023ec:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8023f0:	75 10                	jne    802402 <print_mem_block_lists+0x184>
  8023f2:	83 ec 0c             	sub    $0xc,%esp
  8023f5:	68 6c 46 80 00       	push   $0x80466c
  8023fa:	e8 68 e5 ff ff       	call   800967 <cprintf>
  8023ff:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802402:	83 ec 0c             	sub    $0xc,%esp
  802405:	68 e0 45 80 00       	push   $0x8045e0
  80240a:	e8 58 e5 ff ff       	call   800967 <cprintf>
  80240f:	83 c4 10             	add    $0x10,%esp

}
  802412:	90                   	nop
  802413:	c9                   	leave  
  802414:	c3                   	ret    

00802415 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802415:	55                   	push   %ebp
  802416:	89 e5                	mov    %esp,%ebp
  802418:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  80241b:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802422:	00 00 00 
  802425:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  80242c:	00 00 00 
  80242f:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802436:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  802439:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802440:	e9 9e 00 00 00       	jmp    8024e3 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  802445:	a1 50 50 80 00       	mov    0x805050,%eax
  80244a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80244d:	c1 e2 04             	shl    $0x4,%edx
  802450:	01 d0                	add    %edx,%eax
  802452:	85 c0                	test   %eax,%eax
  802454:	75 14                	jne    80246a <initialize_MemBlocksList+0x55>
  802456:	83 ec 04             	sub    $0x4,%esp
  802459:	68 94 46 80 00       	push   $0x804694
  80245e:	6a 46                	push   $0x46
  802460:	68 b7 46 80 00       	push   $0x8046b7
  802465:	e8 49 e2 ff ff       	call   8006b3 <_panic>
  80246a:	a1 50 50 80 00       	mov    0x805050,%eax
  80246f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802472:	c1 e2 04             	shl    $0x4,%edx
  802475:	01 d0                	add    %edx,%eax
  802477:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80247d:	89 10                	mov    %edx,(%eax)
  80247f:	8b 00                	mov    (%eax),%eax
  802481:	85 c0                	test   %eax,%eax
  802483:	74 18                	je     80249d <initialize_MemBlocksList+0x88>
  802485:	a1 48 51 80 00       	mov    0x805148,%eax
  80248a:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802490:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802493:	c1 e1 04             	shl    $0x4,%ecx
  802496:	01 ca                	add    %ecx,%edx
  802498:	89 50 04             	mov    %edx,0x4(%eax)
  80249b:	eb 12                	jmp    8024af <initialize_MemBlocksList+0x9a>
  80249d:	a1 50 50 80 00       	mov    0x805050,%eax
  8024a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024a5:	c1 e2 04             	shl    $0x4,%edx
  8024a8:	01 d0                	add    %edx,%eax
  8024aa:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8024af:	a1 50 50 80 00       	mov    0x805050,%eax
  8024b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024b7:	c1 e2 04             	shl    $0x4,%edx
  8024ba:	01 d0                	add    %edx,%eax
  8024bc:	a3 48 51 80 00       	mov    %eax,0x805148
  8024c1:	a1 50 50 80 00       	mov    0x805050,%eax
  8024c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024c9:	c1 e2 04             	shl    $0x4,%edx
  8024cc:	01 d0                	add    %edx,%eax
  8024ce:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024d5:	a1 54 51 80 00       	mov    0x805154,%eax
  8024da:	40                   	inc    %eax
  8024db:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  8024e0:	ff 45 f4             	incl   -0xc(%ebp)
  8024e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024e9:	0f 82 56 ff ff ff    	jb     802445 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  8024ef:	90                   	nop
  8024f0:	c9                   	leave  
  8024f1:	c3                   	ret    

008024f2 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8024f2:	55                   	push   %ebp
  8024f3:	89 e5                	mov    %esp,%ebp
  8024f5:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8024f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8024fb:	8b 00                	mov    (%eax),%eax
  8024fd:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802500:	eb 19                	jmp    80251b <find_block+0x29>
	{
		if(va==point->sva)
  802502:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802505:	8b 40 08             	mov    0x8(%eax),%eax
  802508:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80250b:	75 05                	jne    802512 <find_block+0x20>
		   return point;
  80250d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802510:	eb 36                	jmp    802548 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802512:	8b 45 08             	mov    0x8(%ebp),%eax
  802515:	8b 40 08             	mov    0x8(%eax),%eax
  802518:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80251b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80251f:	74 07                	je     802528 <find_block+0x36>
  802521:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802524:	8b 00                	mov    (%eax),%eax
  802526:	eb 05                	jmp    80252d <find_block+0x3b>
  802528:	b8 00 00 00 00       	mov    $0x0,%eax
  80252d:	8b 55 08             	mov    0x8(%ebp),%edx
  802530:	89 42 08             	mov    %eax,0x8(%edx)
  802533:	8b 45 08             	mov    0x8(%ebp),%eax
  802536:	8b 40 08             	mov    0x8(%eax),%eax
  802539:	85 c0                	test   %eax,%eax
  80253b:	75 c5                	jne    802502 <find_block+0x10>
  80253d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802541:	75 bf                	jne    802502 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802543:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802548:	c9                   	leave  
  802549:	c3                   	ret    

0080254a <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80254a:	55                   	push   %ebp
  80254b:	89 e5                	mov    %esp,%ebp
  80254d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  802550:	a1 40 50 80 00       	mov    0x805040,%eax
  802555:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802558:	a1 44 50 80 00       	mov    0x805044,%eax
  80255d:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  802560:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802563:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802566:	74 24                	je     80258c <insert_sorted_allocList+0x42>
  802568:	8b 45 08             	mov    0x8(%ebp),%eax
  80256b:	8b 50 08             	mov    0x8(%eax),%edx
  80256e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802571:	8b 40 08             	mov    0x8(%eax),%eax
  802574:	39 c2                	cmp    %eax,%edx
  802576:	76 14                	jbe    80258c <insert_sorted_allocList+0x42>
  802578:	8b 45 08             	mov    0x8(%ebp),%eax
  80257b:	8b 50 08             	mov    0x8(%eax),%edx
  80257e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802581:	8b 40 08             	mov    0x8(%eax),%eax
  802584:	39 c2                	cmp    %eax,%edx
  802586:	0f 82 60 01 00 00    	jb     8026ec <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  80258c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802590:	75 65                	jne    8025f7 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802592:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802596:	75 14                	jne    8025ac <insert_sorted_allocList+0x62>
  802598:	83 ec 04             	sub    $0x4,%esp
  80259b:	68 94 46 80 00       	push   $0x804694
  8025a0:	6a 6b                	push   $0x6b
  8025a2:	68 b7 46 80 00       	push   $0x8046b7
  8025a7:	e8 07 e1 ff ff       	call   8006b3 <_panic>
  8025ac:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8025b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b5:	89 10                	mov    %edx,(%eax)
  8025b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ba:	8b 00                	mov    (%eax),%eax
  8025bc:	85 c0                	test   %eax,%eax
  8025be:	74 0d                	je     8025cd <insert_sorted_allocList+0x83>
  8025c0:	a1 40 50 80 00       	mov    0x805040,%eax
  8025c5:	8b 55 08             	mov    0x8(%ebp),%edx
  8025c8:	89 50 04             	mov    %edx,0x4(%eax)
  8025cb:	eb 08                	jmp    8025d5 <insert_sorted_allocList+0x8b>
  8025cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8025d0:	a3 44 50 80 00       	mov    %eax,0x805044
  8025d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8025d8:	a3 40 50 80 00       	mov    %eax,0x805040
  8025dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8025e0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025e7:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8025ec:	40                   	inc    %eax
  8025ed:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8025f2:	e9 dc 01 00 00       	jmp    8027d3 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  8025f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8025fa:	8b 50 08             	mov    0x8(%eax),%edx
  8025fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802600:	8b 40 08             	mov    0x8(%eax),%eax
  802603:	39 c2                	cmp    %eax,%edx
  802605:	77 6c                	ja     802673 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802607:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80260b:	74 06                	je     802613 <insert_sorted_allocList+0xc9>
  80260d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802611:	75 14                	jne    802627 <insert_sorted_allocList+0xdd>
  802613:	83 ec 04             	sub    $0x4,%esp
  802616:	68 d0 46 80 00       	push   $0x8046d0
  80261b:	6a 6f                	push   $0x6f
  80261d:	68 b7 46 80 00       	push   $0x8046b7
  802622:	e8 8c e0 ff ff       	call   8006b3 <_panic>
  802627:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80262a:	8b 50 04             	mov    0x4(%eax),%edx
  80262d:	8b 45 08             	mov    0x8(%ebp),%eax
  802630:	89 50 04             	mov    %edx,0x4(%eax)
  802633:	8b 45 08             	mov    0x8(%ebp),%eax
  802636:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802639:	89 10                	mov    %edx,(%eax)
  80263b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80263e:	8b 40 04             	mov    0x4(%eax),%eax
  802641:	85 c0                	test   %eax,%eax
  802643:	74 0d                	je     802652 <insert_sorted_allocList+0x108>
  802645:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802648:	8b 40 04             	mov    0x4(%eax),%eax
  80264b:	8b 55 08             	mov    0x8(%ebp),%edx
  80264e:	89 10                	mov    %edx,(%eax)
  802650:	eb 08                	jmp    80265a <insert_sorted_allocList+0x110>
  802652:	8b 45 08             	mov    0x8(%ebp),%eax
  802655:	a3 40 50 80 00       	mov    %eax,0x805040
  80265a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80265d:	8b 55 08             	mov    0x8(%ebp),%edx
  802660:	89 50 04             	mov    %edx,0x4(%eax)
  802663:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802668:	40                   	inc    %eax
  802669:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80266e:	e9 60 01 00 00       	jmp    8027d3 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802673:	8b 45 08             	mov    0x8(%ebp),%eax
  802676:	8b 50 08             	mov    0x8(%eax),%edx
  802679:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80267c:	8b 40 08             	mov    0x8(%eax),%eax
  80267f:	39 c2                	cmp    %eax,%edx
  802681:	0f 82 4c 01 00 00    	jb     8027d3 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802687:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80268b:	75 14                	jne    8026a1 <insert_sorted_allocList+0x157>
  80268d:	83 ec 04             	sub    $0x4,%esp
  802690:	68 08 47 80 00       	push   $0x804708
  802695:	6a 73                	push   $0x73
  802697:	68 b7 46 80 00       	push   $0x8046b7
  80269c:	e8 12 e0 ff ff       	call   8006b3 <_panic>
  8026a1:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8026a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8026aa:	89 50 04             	mov    %edx,0x4(%eax)
  8026ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b0:	8b 40 04             	mov    0x4(%eax),%eax
  8026b3:	85 c0                	test   %eax,%eax
  8026b5:	74 0c                	je     8026c3 <insert_sorted_allocList+0x179>
  8026b7:	a1 44 50 80 00       	mov    0x805044,%eax
  8026bc:	8b 55 08             	mov    0x8(%ebp),%edx
  8026bf:	89 10                	mov    %edx,(%eax)
  8026c1:	eb 08                	jmp    8026cb <insert_sorted_allocList+0x181>
  8026c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c6:	a3 40 50 80 00       	mov    %eax,0x805040
  8026cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ce:	a3 44 50 80 00       	mov    %eax,0x805044
  8026d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8026d6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026dc:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8026e1:	40                   	inc    %eax
  8026e2:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8026e7:	e9 e7 00 00 00       	jmp    8027d3 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  8026ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  8026f2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8026f9:	a1 40 50 80 00       	mov    0x805040,%eax
  8026fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802701:	e9 9d 00 00 00       	jmp    8027a3 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802706:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802709:	8b 00                	mov    (%eax),%eax
  80270b:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  80270e:	8b 45 08             	mov    0x8(%ebp),%eax
  802711:	8b 50 08             	mov    0x8(%eax),%edx
  802714:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802717:	8b 40 08             	mov    0x8(%eax),%eax
  80271a:	39 c2                	cmp    %eax,%edx
  80271c:	76 7d                	jbe    80279b <insert_sorted_allocList+0x251>
  80271e:	8b 45 08             	mov    0x8(%ebp),%eax
  802721:	8b 50 08             	mov    0x8(%eax),%edx
  802724:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802727:	8b 40 08             	mov    0x8(%eax),%eax
  80272a:	39 c2                	cmp    %eax,%edx
  80272c:	73 6d                	jae    80279b <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  80272e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802732:	74 06                	je     80273a <insert_sorted_allocList+0x1f0>
  802734:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802738:	75 14                	jne    80274e <insert_sorted_allocList+0x204>
  80273a:	83 ec 04             	sub    $0x4,%esp
  80273d:	68 2c 47 80 00       	push   $0x80472c
  802742:	6a 7f                	push   $0x7f
  802744:	68 b7 46 80 00       	push   $0x8046b7
  802749:	e8 65 df ff ff       	call   8006b3 <_panic>
  80274e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802751:	8b 10                	mov    (%eax),%edx
  802753:	8b 45 08             	mov    0x8(%ebp),%eax
  802756:	89 10                	mov    %edx,(%eax)
  802758:	8b 45 08             	mov    0x8(%ebp),%eax
  80275b:	8b 00                	mov    (%eax),%eax
  80275d:	85 c0                	test   %eax,%eax
  80275f:	74 0b                	je     80276c <insert_sorted_allocList+0x222>
  802761:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802764:	8b 00                	mov    (%eax),%eax
  802766:	8b 55 08             	mov    0x8(%ebp),%edx
  802769:	89 50 04             	mov    %edx,0x4(%eax)
  80276c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276f:	8b 55 08             	mov    0x8(%ebp),%edx
  802772:	89 10                	mov    %edx,(%eax)
  802774:	8b 45 08             	mov    0x8(%ebp),%eax
  802777:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80277a:	89 50 04             	mov    %edx,0x4(%eax)
  80277d:	8b 45 08             	mov    0x8(%ebp),%eax
  802780:	8b 00                	mov    (%eax),%eax
  802782:	85 c0                	test   %eax,%eax
  802784:	75 08                	jne    80278e <insert_sorted_allocList+0x244>
  802786:	8b 45 08             	mov    0x8(%ebp),%eax
  802789:	a3 44 50 80 00       	mov    %eax,0x805044
  80278e:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802793:	40                   	inc    %eax
  802794:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802799:	eb 39                	jmp    8027d4 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80279b:	a1 48 50 80 00       	mov    0x805048,%eax
  8027a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027a7:	74 07                	je     8027b0 <insert_sorted_allocList+0x266>
  8027a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ac:	8b 00                	mov    (%eax),%eax
  8027ae:	eb 05                	jmp    8027b5 <insert_sorted_allocList+0x26b>
  8027b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8027b5:	a3 48 50 80 00       	mov    %eax,0x805048
  8027ba:	a1 48 50 80 00       	mov    0x805048,%eax
  8027bf:	85 c0                	test   %eax,%eax
  8027c1:	0f 85 3f ff ff ff    	jne    802706 <insert_sorted_allocList+0x1bc>
  8027c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027cb:	0f 85 35 ff ff ff    	jne    802706 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8027d1:	eb 01                	jmp    8027d4 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8027d3:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8027d4:	90                   	nop
  8027d5:	c9                   	leave  
  8027d6:	c3                   	ret    

008027d7 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8027d7:	55                   	push   %ebp
  8027d8:	89 e5                	mov    %esp,%ebp
  8027da:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8027dd:	a1 38 51 80 00       	mov    0x805138,%eax
  8027e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027e5:	e9 85 01 00 00       	jmp    80296f <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  8027ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ed:	8b 40 0c             	mov    0xc(%eax),%eax
  8027f0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027f3:	0f 82 6e 01 00 00    	jb     802967 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  8027f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027fc:	8b 40 0c             	mov    0xc(%eax),%eax
  8027ff:	3b 45 08             	cmp    0x8(%ebp),%eax
  802802:	0f 85 8a 00 00 00    	jne    802892 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802808:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80280c:	75 17                	jne    802825 <alloc_block_FF+0x4e>
  80280e:	83 ec 04             	sub    $0x4,%esp
  802811:	68 60 47 80 00       	push   $0x804760
  802816:	68 93 00 00 00       	push   $0x93
  80281b:	68 b7 46 80 00       	push   $0x8046b7
  802820:	e8 8e de ff ff       	call   8006b3 <_panic>
  802825:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802828:	8b 00                	mov    (%eax),%eax
  80282a:	85 c0                	test   %eax,%eax
  80282c:	74 10                	je     80283e <alloc_block_FF+0x67>
  80282e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802831:	8b 00                	mov    (%eax),%eax
  802833:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802836:	8b 52 04             	mov    0x4(%edx),%edx
  802839:	89 50 04             	mov    %edx,0x4(%eax)
  80283c:	eb 0b                	jmp    802849 <alloc_block_FF+0x72>
  80283e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802841:	8b 40 04             	mov    0x4(%eax),%eax
  802844:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802849:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284c:	8b 40 04             	mov    0x4(%eax),%eax
  80284f:	85 c0                	test   %eax,%eax
  802851:	74 0f                	je     802862 <alloc_block_FF+0x8b>
  802853:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802856:	8b 40 04             	mov    0x4(%eax),%eax
  802859:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80285c:	8b 12                	mov    (%edx),%edx
  80285e:	89 10                	mov    %edx,(%eax)
  802860:	eb 0a                	jmp    80286c <alloc_block_FF+0x95>
  802862:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802865:	8b 00                	mov    (%eax),%eax
  802867:	a3 38 51 80 00       	mov    %eax,0x805138
  80286c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802875:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802878:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80287f:	a1 44 51 80 00       	mov    0x805144,%eax
  802884:	48                   	dec    %eax
  802885:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  80288a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288d:	e9 10 01 00 00       	jmp    8029a2 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802892:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802895:	8b 40 0c             	mov    0xc(%eax),%eax
  802898:	3b 45 08             	cmp    0x8(%ebp),%eax
  80289b:	0f 86 c6 00 00 00    	jbe    802967 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8028a1:	a1 48 51 80 00       	mov    0x805148,%eax
  8028a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  8028a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ac:	8b 50 08             	mov    0x8(%eax),%edx
  8028af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028b2:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  8028b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028b8:	8b 55 08             	mov    0x8(%ebp),%edx
  8028bb:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8028be:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8028c2:	75 17                	jne    8028db <alloc_block_FF+0x104>
  8028c4:	83 ec 04             	sub    $0x4,%esp
  8028c7:	68 60 47 80 00       	push   $0x804760
  8028cc:	68 9b 00 00 00       	push   $0x9b
  8028d1:	68 b7 46 80 00       	push   $0x8046b7
  8028d6:	e8 d8 dd ff ff       	call   8006b3 <_panic>
  8028db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028de:	8b 00                	mov    (%eax),%eax
  8028e0:	85 c0                	test   %eax,%eax
  8028e2:	74 10                	je     8028f4 <alloc_block_FF+0x11d>
  8028e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028e7:	8b 00                	mov    (%eax),%eax
  8028e9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028ec:	8b 52 04             	mov    0x4(%edx),%edx
  8028ef:	89 50 04             	mov    %edx,0x4(%eax)
  8028f2:	eb 0b                	jmp    8028ff <alloc_block_FF+0x128>
  8028f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028f7:	8b 40 04             	mov    0x4(%eax),%eax
  8028fa:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8028ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802902:	8b 40 04             	mov    0x4(%eax),%eax
  802905:	85 c0                	test   %eax,%eax
  802907:	74 0f                	je     802918 <alloc_block_FF+0x141>
  802909:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80290c:	8b 40 04             	mov    0x4(%eax),%eax
  80290f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802912:	8b 12                	mov    (%edx),%edx
  802914:	89 10                	mov    %edx,(%eax)
  802916:	eb 0a                	jmp    802922 <alloc_block_FF+0x14b>
  802918:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80291b:	8b 00                	mov    (%eax),%eax
  80291d:	a3 48 51 80 00       	mov    %eax,0x805148
  802922:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802925:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80292b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80292e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802935:	a1 54 51 80 00       	mov    0x805154,%eax
  80293a:	48                   	dec    %eax
  80293b:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802940:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802943:	8b 50 08             	mov    0x8(%eax),%edx
  802946:	8b 45 08             	mov    0x8(%ebp),%eax
  802949:	01 c2                	add    %eax,%edx
  80294b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294e:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802951:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802954:	8b 40 0c             	mov    0xc(%eax),%eax
  802957:	2b 45 08             	sub    0x8(%ebp),%eax
  80295a:	89 c2                	mov    %eax,%edx
  80295c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295f:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802962:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802965:	eb 3b                	jmp    8029a2 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802967:	a1 40 51 80 00       	mov    0x805140,%eax
  80296c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80296f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802973:	74 07                	je     80297c <alloc_block_FF+0x1a5>
  802975:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802978:	8b 00                	mov    (%eax),%eax
  80297a:	eb 05                	jmp    802981 <alloc_block_FF+0x1aa>
  80297c:	b8 00 00 00 00       	mov    $0x0,%eax
  802981:	a3 40 51 80 00       	mov    %eax,0x805140
  802986:	a1 40 51 80 00       	mov    0x805140,%eax
  80298b:	85 c0                	test   %eax,%eax
  80298d:	0f 85 57 fe ff ff    	jne    8027ea <alloc_block_FF+0x13>
  802993:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802997:	0f 85 4d fe ff ff    	jne    8027ea <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  80299d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029a2:	c9                   	leave  
  8029a3:	c3                   	ret    

008029a4 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8029a4:	55                   	push   %ebp
  8029a5:	89 e5                	mov    %esp,%ebp
  8029a7:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  8029aa:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8029b1:	a1 38 51 80 00       	mov    0x805138,%eax
  8029b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029b9:	e9 df 00 00 00       	jmp    802a9d <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  8029be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c1:	8b 40 0c             	mov    0xc(%eax),%eax
  8029c4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029c7:	0f 82 c8 00 00 00    	jb     802a95 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  8029cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d0:	8b 40 0c             	mov    0xc(%eax),%eax
  8029d3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029d6:	0f 85 8a 00 00 00    	jne    802a66 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  8029dc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029e0:	75 17                	jne    8029f9 <alloc_block_BF+0x55>
  8029e2:	83 ec 04             	sub    $0x4,%esp
  8029e5:	68 60 47 80 00       	push   $0x804760
  8029ea:	68 b7 00 00 00       	push   $0xb7
  8029ef:	68 b7 46 80 00       	push   $0x8046b7
  8029f4:	e8 ba dc ff ff       	call   8006b3 <_panic>
  8029f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029fc:	8b 00                	mov    (%eax),%eax
  8029fe:	85 c0                	test   %eax,%eax
  802a00:	74 10                	je     802a12 <alloc_block_BF+0x6e>
  802a02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a05:	8b 00                	mov    (%eax),%eax
  802a07:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a0a:	8b 52 04             	mov    0x4(%edx),%edx
  802a0d:	89 50 04             	mov    %edx,0x4(%eax)
  802a10:	eb 0b                	jmp    802a1d <alloc_block_BF+0x79>
  802a12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a15:	8b 40 04             	mov    0x4(%eax),%eax
  802a18:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802a1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a20:	8b 40 04             	mov    0x4(%eax),%eax
  802a23:	85 c0                	test   %eax,%eax
  802a25:	74 0f                	je     802a36 <alloc_block_BF+0x92>
  802a27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2a:	8b 40 04             	mov    0x4(%eax),%eax
  802a2d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a30:	8b 12                	mov    (%edx),%edx
  802a32:	89 10                	mov    %edx,(%eax)
  802a34:	eb 0a                	jmp    802a40 <alloc_block_BF+0x9c>
  802a36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a39:	8b 00                	mov    (%eax),%eax
  802a3b:	a3 38 51 80 00       	mov    %eax,0x805138
  802a40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a43:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a53:	a1 44 51 80 00       	mov    0x805144,%eax
  802a58:	48                   	dec    %eax
  802a59:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802a5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a61:	e9 4d 01 00 00       	jmp    802bb3 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802a66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a69:	8b 40 0c             	mov    0xc(%eax),%eax
  802a6c:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a6f:	76 24                	jbe    802a95 <alloc_block_BF+0xf1>
  802a71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a74:	8b 40 0c             	mov    0xc(%eax),%eax
  802a77:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802a7a:	73 19                	jae    802a95 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802a7c:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802a83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a86:	8b 40 0c             	mov    0xc(%eax),%eax
  802a89:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802a8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8f:	8b 40 08             	mov    0x8(%eax),%eax
  802a92:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802a95:	a1 40 51 80 00       	mov    0x805140,%eax
  802a9a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a9d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802aa1:	74 07                	je     802aaa <alloc_block_BF+0x106>
  802aa3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa6:	8b 00                	mov    (%eax),%eax
  802aa8:	eb 05                	jmp    802aaf <alloc_block_BF+0x10b>
  802aaa:	b8 00 00 00 00       	mov    $0x0,%eax
  802aaf:	a3 40 51 80 00       	mov    %eax,0x805140
  802ab4:	a1 40 51 80 00       	mov    0x805140,%eax
  802ab9:	85 c0                	test   %eax,%eax
  802abb:	0f 85 fd fe ff ff    	jne    8029be <alloc_block_BF+0x1a>
  802ac1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ac5:	0f 85 f3 fe ff ff    	jne    8029be <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802acb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802acf:	0f 84 d9 00 00 00    	je     802bae <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802ad5:	a1 48 51 80 00       	mov    0x805148,%eax
  802ada:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802add:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ae0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ae3:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802ae6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ae9:	8b 55 08             	mov    0x8(%ebp),%edx
  802aec:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802aef:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802af3:	75 17                	jne    802b0c <alloc_block_BF+0x168>
  802af5:	83 ec 04             	sub    $0x4,%esp
  802af8:	68 60 47 80 00       	push   $0x804760
  802afd:	68 c7 00 00 00       	push   $0xc7
  802b02:	68 b7 46 80 00       	push   $0x8046b7
  802b07:	e8 a7 db ff ff       	call   8006b3 <_panic>
  802b0c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b0f:	8b 00                	mov    (%eax),%eax
  802b11:	85 c0                	test   %eax,%eax
  802b13:	74 10                	je     802b25 <alloc_block_BF+0x181>
  802b15:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b18:	8b 00                	mov    (%eax),%eax
  802b1a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802b1d:	8b 52 04             	mov    0x4(%edx),%edx
  802b20:	89 50 04             	mov    %edx,0x4(%eax)
  802b23:	eb 0b                	jmp    802b30 <alloc_block_BF+0x18c>
  802b25:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b28:	8b 40 04             	mov    0x4(%eax),%eax
  802b2b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b30:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b33:	8b 40 04             	mov    0x4(%eax),%eax
  802b36:	85 c0                	test   %eax,%eax
  802b38:	74 0f                	je     802b49 <alloc_block_BF+0x1a5>
  802b3a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b3d:	8b 40 04             	mov    0x4(%eax),%eax
  802b40:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802b43:	8b 12                	mov    (%edx),%edx
  802b45:	89 10                	mov    %edx,(%eax)
  802b47:	eb 0a                	jmp    802b53 <alloc_block_BF+0x1af>
  802b49:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b4c:	8b 00                	mov    (%eax),%eax
  802b4e:	a3 48 51 80 00       	mov    %eax,0x805148
  802b53:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b56:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b5c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b5f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b66:	a1 54 51 80 00       	mov    0x805154,%eax
  802b6b:	48                   	dec    %eax
  802b6c:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802b71:	83 ec 08             	sub    $0x8,%esp
  802b74:	ff 75 ec             	pushl  -0x14(%ebp)
  802b77:	68 38 51 80 00       	push   $0x805138
  802b7c:	e8 71 f9 ff ff       	call   8024f2 <find_block>
  802b81:	83 c4 10             	add    $0x10,%esp
  802b84:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802b87:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b8a:	8b 50 08             	mov    0x8(%eax),%edx
  802b8d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b90:	01 c2                	add    %eax,%edx
  802b92:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b95:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802b98:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b9b:	8b 40 0c             	mov    0xc(%eax),%eax
  802b9e:	2b 45 08             	sub    0x8(%ebp),%eax
  802ba1:	89 c2                	mov    %eax,%edx
  802ba3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ba6:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802ba9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bac:	eb 05                	jmp    802bb3 <alloc_block_BF+0x20f>
	}
	return NULL;
  802bae:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802bb3:	c9                   	leave  
  802bb4:	c3                   	ret    

00802bb5 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802bb5:	55                   	push   %ebp
  802bb6:	89 e5                	mov    %esp,%ebp
  802bb8:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802bbb:	a1 28 50 80 00       	mov    0x805028,%eax
  802bc0:	85 c0                	test   %eax,%eax
  802bc2:	0f 85 de 01 00 00    	jne    802da6 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802bc8:	a1 38 51 80 00       	mov    0x805138,%eax
  802bcd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bd0:	e9 9e 01 00 00       	jmp    802d73 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802bd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd8:	8b 40 0c             	mov    0xc(%eax),%eax
  802bdb:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bde:	0f 82 87 01 00 00    	jb     802d6b <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802be4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be7:	8b 40 0c             	mov    0xc(%eax),%eax
  802bea:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bed:	0f 85 95 00 00 00    	jne    802c88 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802bf3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bf7:	75 17                	jne    802c10 <alloc_block_NF+0x5b>
  802bf9:	83 ec 04             	sub    $0x4,%esp
  802bfc:	68 60 47 80 00       	push   $0x804760
  802c01:	68 e0 00 00 00       	push   $0xe0
  802c06:	68 b7 46 80 00       	push   $0x8046b7
  802c0b:	e8 a3 da ff ff       	call   8006b3 <_panic>
  802c10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c13:	8b 00                	mov    (%eax),%eax
  802c15:	85 c0                	test   %eax,%eax
  802c17:	74 10                	je     802c29 <alloc_block_NF+0x74>
  802c19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1c:	8b 00                	mov    (%eax),%eax
  802c1e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c21:	8b 52 04             	mov    0x4(%edx),%edx
  802c24:	89 50 04             	mov    %edx,0x4(%eax)
  802c27:	eb 0b                	jmp    802c34 <alloc_block_NF+0x7f>
  802c29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c2c:	8b 40 04             	mov    0x4(%eax),%eax
  802c2f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c37:	8b 40 04             	mov    0x4(%eax),%eax
  802c3a:	85 c0                	test   %eax,%eax
  802c3c:	74 0f                	je     802c4d <alloc_block_NF+0x98>
  802c3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c41:	8b 40 04             	mov    0x4(%eax),%eax
  802c44:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c47:	8b 12                	mov    (%edx),%edx
  802c49:	89 10                	mov    %edx,(%eax)
  802c4b:	eb 0a                	jmp    802c57 <alloc_block_NF+0xa2>
  802c4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c50:	8b 00                	mov    (%eax),%eax
  802c52:	a3 38 51 80 00       	mov    %eax,0x805138
  802c57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c5a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c63:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c6a:	a1 44 51 80 00       	mov    0x805144,%eax
  802c6f:	48                   	dec    %eax
  802c70:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802c75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c78:	8b 40 08             	mov    0x8(%eax),%eax
  802c7b:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  802c80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c83:	e9 f8 04 00 00       	jmp    803180 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802c88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c8b:	8b 40 0c             	mov    0xc(%eax),%eax
  802c8e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c91:	0f 86 d4 00 00 00    	jbe    802d6b <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802c97:	a1 48 51 80 00       	mov    0x805148,%eax
  802c9c:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802c9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca2:	8b 50 08             	mov    0x8(%eax),%edx
  802ca5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ca8:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802cab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cae:	8b 55 08             	mov    0x8(%ebp),%edx
  802cb1:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802cb4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802cb8:	75 17                	jne    802cd1 <alloc_block_NF+0x11c>
  802cba:	83 ec 04             	sub    $0x4,%esp
  802cbd:	68 60 47 80 00       	push   $0x804760
  802cc2:	68 e9 00 00 00       	push   $0xe9
  802cc7:	68 b7 46 80 00       	push   $0x8046b7
  802ccc:	e8 e2 d9 ff ff       	call   8006b3 <_panic>
  802cd1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cd4:	8b 00                	mov    (%eax),%eax
  802cd6:	85 c0                	test   %eax,%eax
  802cd8:	74 10                	je     802cea <alloc_block_NF+0x135>
  802cda:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cdd:	8b 00                	mov    (%eax),%eax
  802cdf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ce2:	8b 52 04             	mov    0x4(%edx),%edx
  802ce5:	89 50 04             	mov    %edx,0x4(%eax)
  802ce8:	eb 0b                	jmp    802cf5 <alloc_block_NF+0x140>
  802cea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ced:	8b 40 04             	mov    0x4(%eax),%eax
  802cf0:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802cf5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cf8:	8b 40 04             	mov    0x4(%eax),%eax
  802cfb:	85 c0                	test   %eax,%eax
  802cfd:	74 0f                	je     802d0e <alloc_block_NF+0x159>
  802cff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d02:	8b 40 04             	mov    0x4(%eax),%eax
  802d05:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d08:	8b 12                	mov    (%edx),%edx
  802d0a:	89 10                	mov    %edx,(%eax)
  802d0c:	eb 0a                	jmp    802d18 <alloc_block_NF+0x163>
  802d0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d11:	8b 00                	mov    (%eax),%eax
  802d13:	a3 48 51 80 00       	mov    %eax,0x805148
  802d18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d1b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d21:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d24:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d2b:	a1 54 51 80 00       	mov    0x805154,%eax
  802d30:	48                   	dec    %eax
  802d31:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802d36:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d39:	8b 40 08             	mov    0x8(%eax),%eax
  802d3c:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802d41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d44:	8b 50 08             	mov    0x8(%eax),%edx
  802d47:	8b 45 08             	mov    0x8(%ebp),%eax
  802d4a:	01 c2                	add    %eax,%edx
  802d4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d4f:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802d52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d55:	8b 40 0c             	mov    0xc(%eax),%eax
  802d58:	2b 45 08             	sub    0x8(%ebp),%eax
  802d5b:	89 c2                	mov    %eax,%edx
  802d5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d60:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802d63:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d66:	e9 15 04 00 00       	jmp    803180 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802d6b:	a1 40 51 80 00       	mov    0x805140,%eax
  802d70:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d73:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d77:	74 07                	je     802d80 <alloc_block_NF+0x1cb>
  802d79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d7c:	8b 00                	mov    (%eax),%eax
  802d7e:	eb 05                	jmp    802d85 <alloc_block_NF+0x1d0>
  802d80:	b8 00 00 00 00       	mov    $0x0,%eax
  802d85:	a3 40 51 80 00       	mov    %eax,0x805140
  802d8a:	a1 40 51 80 00       	mov    0x805140,%eax
  802d8f:	85 c0                	test   %eax,%eax
  802d91:	0f 85 3e fe ff ff    	jne    802bd5 <alloc_block_NF+0x20>
  802d97:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d9b:	0f 85 34 fe ff ff    	jne    802bd5 <alloc_block_NF+0x20>
  802da1:	e9 d5 03 00 00       	jmp    80317b <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802da6:	a1 38 51 80 00       	mov    0x805138,%eax
  802dab:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802dae:	e9 b1 01 00 00       	jmp    802f64 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802db3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db6:	8b 50 08             	mov    0x8(%eax),%edx
  802db9:	a1 28 50 80 00       	mov    0x805028,%eax
  802dbe:	39 c2                	cmp    %eax,%edx
  802dc0:	0f 82 96 01 00 00    	jb     802f5c <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802dc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc9:	8b 40 0c             	mov    0xc(%eax),%eax
  802dcc:	3b 45 08             	cmp    0x8(%ebp),%eax
  802dcf:	0f 82 87 01 00 00    	jb     802f5c <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802dd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd8:	8b 40 0c             	mov    0xc(%eax),%eax
  802ddb:	3b 45 08             	cmp    0x8(%ebp),%eax
  802dde:	0f 85 95 00 00 00    	jne    802e79 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802de4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802de8:	75 17                	jne    802e01 <alloc_block_NF+0x24c>
  802dea:	83 ec 04             	sub    $0x4,%esp
  802ded:	68 60 47 80 00       	push   $0x804760
  802df2:	68 fc 00 00 00       	push   $0xfc
  802df7:	68 b7 46 80 00       	push   $0x8046b7
  802dfc:	e8 b2 d8 ff ff       	call   8006b3 <_panic>
  802e01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e04:	8b 00                	mov    (%eax),%eax
  802e06:	85 c0                	test   %eax,%eax
  802e08:	74 10                	je     802e1a <alloc_block_NF+0x265>
  802e0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e0d:	8b 00                	mov    (%eax),%eax
  802e0f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e12:	8b 52 04             	mov    0x4(%edx),%edx
  802e15:	89 50 04             	mov    %edx,0x4(%eax)
  802e18:	eb 0b                	jmp    802e25 <alloc_block_NF+0x270>
  802e1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e1d:	8b 40 04             	mov    0x4(%eax),%eax
  802e20:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e28:	8b 40 04             	mov    0x4(%eax),%eax
  802e2b:	85 c0                	test   %eax,%eax
  802e2d:	74 0f                	je     802e3e <alloc_block_NF+0x289>
  802e2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e32:	8b 40 04             	mov    0x4(%eax),%eax
  802e35:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e38:	8b 12                	mov    (%edx),%edx
  802e3a:	89 10                	mov    %edx,(%eax)
  802e3c:	eb 0a                	jmp    802e48 <alloc_block_NF+0x293>
  802e3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e41:	8b 00                	mov    (%eax),%eax
  802e43:	a3 38 51 80 00       	mov    %eax,0x805138
  802e48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e4b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e54:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e5b:	a1 44 51 80 00       	mov    0x805144,%eax
  802e60:	48                   	dec    %eax
  802e61:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802e66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e69:	8b 40 08             	mov    0x8(%eax),%eax
  802e6c:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802e71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e74:	e9 07 03 00 00       	jmp    803180 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802e79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e7c:	8b 40 0c             	mov    0xc(%eax),%eax
  802e7f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e82:	0f 86 d4 00 00 00    	jbe    802f5c <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802e88:	a1 48 51 80 00       	mov    0x805148,%eax
  802e8d:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802e90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e93:	8b 50 08             	mov    0x8(%eax),%edx
  802e96:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e99:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802e9c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e9f:	8b 55 08             	mov    0x8(%ebp),%edx
  802ea2:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802ea5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802ea9:	75 17                	jne    802ec2 <alloc_block_NF+0x30d>
  802eab:	83 ec 04             	sub    $0x4,%esp
  802eae:	68 60 47 80 00       	push   $0x804760
  802eb3:	68 04 01 00 00       	push   $0x104
  802eb8:	68 b7 46 80 00       	push   $0x8046b7
  802ebd:	e8 f1 d7 ff ff       	call   8006b3 <_panic>
  802ec2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ec5:	8b 00                	mov    (%eax),%eax
  802ec7:	85 c0                	test   %eax,%eax
  802ec9:	74 10                	je     802edb <alloc_block_NF+0x326>
  802ecb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ece:	8b 00                	mov    (%eax),%eax
  802ed0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ed3:	8b 52 04             	mov    0x4(%edx),%edx
  802ed6:	89 50 04             	mov    %edx,0x4(%eax)
  802ed9:	eb 0b                	jmp    802ee6 <alloc_block_NF+0x331>
  802edb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ede:	8b 40 04             	mov    0x4(%eax),%eax
  802ee1:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ee6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ee9:	8b 40 04             	mov    0x4(%eax),%eax
  802eec:	85 c0                	test   %eax,%eax
  802eee:	74 0f                	je     802eff <alloc_block_NF+0x34a>
  802ef0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ef3:	8b 40 04             	mov    0x4(%eax),%eax
  802ef6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ef9:	8b 12                	mov    (%edx),%edx
  802efb:	89 10                	mov    %edx,(%eax)
  802efd:	eb 0a                	jmp    802f09 <alloc_block_NF+0x354>
  802eff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f02:	8b 00                	mov    (%eax),%eax
  802f04:	a3 48 51 80 00       	mov    %eax,0x805148
  802f09:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f0c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f12:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f15:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f1c:	a1 54 51 80 00       	mov    0x805154,%eax
  802f21:	48                   	dec    %eax
  802f22:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802f27:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f2a:	8b 40 08             	mov    0x8(%eax),%eax
  802f2d:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802f32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f35:	8b 50 08             	mov    0x8(%eax),%edx
  802f38:	8b 45 08             	mov    0x8(%ebp),%eax
  802f3b:	01 c2                	add    %eax,%edx
  802f3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f40:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802f43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f46:	8b 40 0c             	mov    0xc(%eax),%eax
  802f49:	2b 45 08             	sub    0x8(%ebp),%eax
  802f4c:	89 c2                	mov    %eax,%edx
  802f4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f51:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802f54:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f57:	e9 24 02 00 00       	jmp    803180 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802f5c:	a1 40 51 80 00       	mov    0x805140,%eax
  802f61:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f64:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f68:	74 07                	je     802f71 <alloc_block_NF+0x3bc>
  802f6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f6d:	8b 00                	mov    (%eax),%eax
  802f6f:	eb 05                	jmp    802f76 <alloc_block_NF+0x3c1>
  802f71:	b8 00 00 00 00       	mov    $0x0,%eax
  802f76:	a3 40 51 80 00       	mov    %eax,0x805140
  802f7b:	a1 40 51 80 00       	mov    0x805140,%eax
  802f80:	85 c0                	test   %eax,%eax
  802f82:	0f 85 2b fe ff ff    	jne    802db3 <alloc_block_NF+0x1fe>
  802f88:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f8c:	0f 85 21 fe ff ff    	jne    802db3 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802f92:	a1 38 51 80 00       	mov    0x805138,%eax
  802f97:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f9a:	e9 ae 01 00 00       	jmp    80314d <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802f9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa2:	8b 50 08             	mov    0x8(%eax),%edx
  802fa5:	a1 28 50 80 00       	mov    0x805028,%eax
  802faa:	39 c2                	cmp    %eax,%edx
  802fac:	0f 83 93 01 00 00    	jae    803145 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802fb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb5:	8b 40 0c             	mov    0xc(%eax),%eax
  802fb8:	3b 45 08             	cmp    0x8(%ebp),%eax
  802fbb:	0f 82 84 01 00 00    	jb     803145 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802fc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc4:	8b 40 0c             	mov    0xc(%eax),%eax
  802fc7:	3b 45 08             	cmp    0x8(%ebp),%eax
  802fca:	0f 85 95 00 00 00    	jne    803065 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802fd0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fd4:	75 17                	jne    802fed <alloc_block_NF+0x438>
  802fd6:	83 ec 04             	sub    $0x4,%esp
  802fd9:	68 60 47 80 00       	push   $0x804760
  802fde:	68 14 01 00 00       	push   $0x114
  802fe3:	68 b7 46 80 00       	push   $0x8046b7
  802fe8:	e8 c6 d6 ff ff       	call   8006b3 <_panic>
  802fed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff0:	8b 00                	mov    (%eax),%eax
  802ff2:	85 c0                	test   %eax,%eax
  802ff4:	74 10                	je     803006 <alloc_block_NF+0x451>
  802ff6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff9:	8b 00                	mov    (%eax),%eax
  802ffb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ffe:	8b 52 04             	mov    0x4(%edx),%edx
  803001:	89 50 04             	mov    %edx,0x4(%eax)
  803004:	eb 0b                	jmp    803011 <alloc_block_NF+0x45c>
  803006:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803009:	8b 40 04             	mov    0x4(%eax),%eax
  80300c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803011:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803014:	8b 40 04             	mov    0x4(%eax),%eax
  803017:	85 c0                	test   %eax,%eax
  803019:	74 0f                	je     80302a <alloc_block_NF+0x475>
  80301b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80301e:	8b 40 04             	mov    0x4(%eax),%eax
  803021:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803024:	8b 12                	mov    (%edx),%edx
  803026:	89 10                	mov    %edx,(%eax)
  803028:	eb 0a                	jmp    803034 <alloc_block_NF+0x47f>
  80302a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80302d:	8b 00                	mov    (%eax),%eax
  80302f:	a3 38 51 80 00       	mov    %eax,0x805138
  803034:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803037:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80303d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803040:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803047:	a1 44 51 80 00       	mov    0x805144,%eax
  80304c:	48                   	dec    %eax
  80304d:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  803052:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803055:	8b 40 08             	mov    0x8(%eax),%eax
  803058:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  80305d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803060:	e9 1b 01 00 00       	jmp    803180 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  803065:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803068:	8b 40 0c             	mov    0xc(%eax),%eax
  80306b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80306e:	0f 86 d1 00 00 00    	jbe    803145 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  803074:	a1 48 51 80 00       	mov    0x805148,%eax
  803079:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  80307c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80307f:	8b 50 08             	mov    0x8(%eax),%edx
  803082:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803085:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  803088:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80308b:	8b 55 08             	mov    0x8(%ebp),%edx
  80308e:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  803091:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803095:	75 17                	jne    8030ae <alloc_block_NF+0x4f9>
  803097:	83 ec 04             	sub    $0x4,%esp
  80309a:	68 60 47 80 00       	push   $0x804760
  80309f:	68 1c 01 00 00       	push   $0x11c
  8030a4:	68 b7 46 80 00       	push   $0x8046b7
  8030a9:	e8 05 d6 ff ff       	call   8006b3 <_panic>
  8030ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030b1:	8b 00                	mov    (%eax),%eax
  8030b3:	85 c0                	test   %eax,%eax
  8030b5:	74 10                	je     8030c7 <alloc_block_NF+0x512>
  8030b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030ba:	8b 00                	mov    (%eax),%eax
  8030bc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8030bf:	8b 52 04             	mov    0x4(%edx),%edx
  8030c2:	89 50 04             	mov    %edx,0x4(%eax)
  8030c5:	eb 0b                	jmp    8030d2 <alloc_block_NF+0x51d>
  8030c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030ca:	8b 40 04             	mov    0x4(%eax),%eax
  8030cd:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8030d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030d5:	8b 40 04             	mov    0x4(%eax),%eax
  8030d8:	85 c0                	test   %eax,%eax
  8030da:	74 0f                	je     8030eb <alloc_block_NF+0x536>
  8030dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030df:	8b 40 04             	mov    0x4(%eax),%eax
  8030e2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8030e5:	8b 12                	mov    (%edx),%edx
  8030e7:	89 10                	mov    %edx,(%eax)
  8030e9:	eb 0a                	jmp    8030f5 <alloc_block_NF+0x540>
  8030eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030ee:	8b 00                	mov    (%eax),%eax
  8030f0:	a3 48 51 80 00       	mov    %eax,0x805148
  8030f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030f8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803101:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803108:	a1 54 51 80 00       	mov    0x805154,%eax
  80310d:	48                   	dec    %eax
  80310e:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  803113:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803116:	8b 40 08             	mov    0x8(%eax),%eax
  803119:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  80311e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803121:	8b 50 08             	mov    0x8(%eax),%edx
  803124:	8b 45 08             	mov    0x8(%ebp),%eax
  803127:	01 c2                	add    %eax,%edx
  803129:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80312c:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  80312f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803132:	8b 40 0c             	mov    0xc(%eax),%eax
  803135:	2b 45 08             	sub    0x8(%ebp),%eax
  803138:	89 c2                	mov    %eax,%edx
  80313a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80313d:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  803140:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803143:	eb 3b                	jmp    803180 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  803145:	a1 40 51 80 00       	mov    0x805140,%eax
  80314a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80314d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803151:	74 07                	je     80315a <alloc_block_NF+0x5a5>
  803153:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803156:	8b 00                	mov    (%eax),%eax
  803158:	eb 05                	jmp    80315f <alloc_block_NF+0x5aa>
  80315a:	b8 00 00 00 00       	mov    $0x0,%eax
  80315f:	a3 40 51 80 00       	mov    %eax,0x805140
  803164:	a1 40 51 80 00       	mov    0x805140,%eax
  803169:	85 c0                	test   %eax,%eax
  80316b:	0f 85 2e fe ff ff    	jne    802f9f <alloc_block_NF+0x3ea>
  803171:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803175:	0f 85 24 fe ff ff    	jne    802f9f <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  80317b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803180:	c9                   	leave  
  803181:	c3                   	ret    

00803182 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  803182:	55                   	push   %ebp
  803183:	89 e5                	mov    %esp,%ebp
  803185:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  803188:	a1 38 51 80 00       	mov    0x805138,%eax
  80318d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  803190:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803195:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  803198:	a1 38 51 80 00       	mov    0x805138,%eax
  80319d:	85 c0                	test   %eax,%eax
  80319f:	74 14                	je     8031b5 <insert_sorted_with_merge_freeList+0x33>
  8031a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a4:	8b 50 08             	mov    0x8(%eax),%edx
  8031a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031aa:	8b 40 08             	mov    0x8(%eax),%eax
  8031ad:	39 c2                	cmp    %eax,%edx
  8031af:	0f 87 9b 01 00 00    	ja     803350 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  8031b5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031b9:	75 17                	jne    8031d2 <insert_sorted_with_merge_freeList+0x50>
  8031bb:	83 ec 04             	sub    $0x4,%esp
  8031be:	68 94 46 80 00       	push   $0x804694
  8031c3:	68 38 01 00 00       	push   $0x138
  8031c8:	68 b7 46 80 00       	push   $0x8046b7
  8031cd:	e8 e1 d4 ff ff       	call   8006b3 <_panic>
  8031d2:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8031d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8031db:	89 10                	mov    %edx,(%eax)
  8031dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e0:	8b 00                	mov    (%eax),%eax
  8031e2:	85 c0                	test   %eax,%eax
  8031e4:	74 0d                	je     8031f3 <insert_sorted_with_merge_freeList+0x71>
  8031e6:	a1 38 51 80 00       	mov    0x805138,%eax
  8031eb:	8b 55 08             	mov    0x8(%ebp),%edx
  8031ee:	89 50 04             	mov    %edx,0x4(%eax)
  8031f1:	eb 08                	jmp    8031fb <insert_sorted_with_merge_freeList+0x79>
  8031f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f6:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8031fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8031fe:	a3 38 51 80 00       	mov    %eax,0x805138
  803203:	8b 45 08             	mov    0x8(%ebp),%eax
  803206:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80320d:	a1 44 51 80 00       	mov    0x805144,%eax
  803212:	40                   	inc    %eax
  803213:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803218:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80321c:	0f 84 a8 06 00 00    	je     8038ca <insert_sorted_with_merge_freeList+0x748>
  803222:	8b 45 08             	mov    0x8(%ebp),%eax
  803225:	8b 50 08             	mov    0x8(%eax),%edx
  803228:	8b 45 08             	mov    0x8(%ebp),%eax
  80322b:	8b 40 0c             	mov    0xc(%eax),%eax
  80322e:	01 c2                	add    %eax,%edx
  803230:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803233:	8b 40 08             	mov    0x8(%eax),%eax
  803236:	39 c2                	cmp    %eax,%edx
  803238:	0f 85 8c 06 00 00    	jne    8038ca <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  80323e:	8b 45 08             	mov    0x8(%ebp),%eax
  803241:	8b 50 0c             	mov    0xc(%eax),%edx
  803244:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803247:	8b 40 0c             	mov    0xc(%eax),%eax
  80324a:	01 c2                	add    %eax,%edx
  80324c:	8b 45 08             	mov    0x8(%ebp),%eax
  80324f:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  803252:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803256:	75 17                	jne    80326f <insert_sorted_with_merge_freeList+0xed>
  803258:	83 ec 04             	sub    $0x4,%esp
  80325b:	68 60 47 80 00       	push   $0x804760
  803260:	68 3c 01 00 00       	push   $0x13c
  803265:	68 b7 46 80 00       	push   $0x8046b7
  80326a:	e8 44 d4 ff ff       	call   8006b3 <_panic>
  80326f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803272:	8b 00                	mov    (%eax),%eax
  803274:	85 c0                	test   %eax,%eax
  803276:	74 10                	je     803288 <insert_sorted_with_merge_freeList+0x106>
  803278:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80327b:	8b 00                	mov    (%eax),%eax
  80327d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803280:	8b 52 04             	mov    0x4(%edx),%edx
  803283:	89 50 04             	mov    %edx,0x4(%eax)
  803286:	eb 0b                	jmp    803293 <insert_sorted_with_merge_freeList+0x111>
  803288:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80328b:	8b 40 04             	mov    0x4(%eax),%eax
  80328e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803293:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803296:	8b 40 04             	mov    0x4(%eax),%eax
  803299:	85 c0                	test   %eax,%eax
  80329b:	74 0f                	je     8032ac <insert_sorted_with_merge_freeList+0x12a>
  80329d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032a0:	8b 40 04             	mov    0x4(%eax),%eax
  8032a3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8032a6:	8b 12                	mov    (%edx),%edx
  8032a8:	89 10                	mov    %edx,(%eax)
  8032aa:	eb 0a                	jmp    8032b6 <insert_sorted_with_merge_freeList+0x134>
  8032ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032af:	8b 00                	mov    (%eax),%eax
  8032b1:	a3 38 51 80 00       	mov    %eax,0x805138
  8032b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032b9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032c2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032c9:	a1 44 51 80 00       	mov    0x805144,%eax
  8032ce:	48                   	dec    %eax
  8032cf:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  8032d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032d7:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  8032de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032e1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  8032e8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8032ec:	75 17                	jne    803305 <insert_sorted_with_merge_freeList+0x183>
  8032ee:	83 ec 04             	sub    $0x4,%esp
  8032f1:	68 94 46 80 00       	push   $0x804694
  8032f6:	68 3f 01 00 00       	push   $0x13f
  8032fb:	68 b7 46 80 00       	push   $0x8046b7
  803300:	e8 ae d3 ff ff       	call   8006b3 <_panic>
  803305:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80330b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80330e:	89 10                	mov    %edx,(%eax)
  803310:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803313:	8b 00                	mov    (%eax),%eax
  803315:	85 c0                	test   %eax,%eax
  803317:	74 0d                	je     803326 <insert_sorted_with_merge_freeList+0x1a4>
  803319:	a1 48 51 80 00       	mov    0x805148,%eax
  80331e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803321:	89 50 04             	mov    %edx,0x4(%eax)
  803324:	eb 08                	jmp    80332e <insert_sorted_with_merge_freeList+0x1ac>
  803326:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803329:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80332e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803331:	a3 48 51 80 00       	mov    %eax,0x805148
  803336:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803339:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803340:	a1 54 51 80 00       	mov    0x805154,%eax
  803345:	40                   	inc    %eax
  803346:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80334b:	e9 7a 05 00 00       	jmp    8038ca <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  803350:	8b 45 08             	mov    0x8(%ebp),%eax
  803353:	8b 50 08             	mov    0x8(%eax),%edx
  803356:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803359:	8b 40 08             	mov    0x8(%eax),%eax
  80335c:	39 c2                	cmp    %eax,%edx
  80335e:	0f 82 14 01 00 00    	jb     803478 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  803364:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803367:	8b 50 08             	mov    0x8(%eax),%edx
  80336a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80336d:	8b 40 0c             	mov    0xc(%eax),%eax
  803370:	01 c2                	add    %eax,%edx
  803372:	8b 45 08             	mov    0x8(%ebp),%eax
  803375:	8b 40 08             	mov    0x8(%eax),%eax
  803378:	39 c2                	cmp    %eax,%edx
  80337a:	0f 85 90 00 00 00    	jne    803410 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  803380:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803383:	8b 50 0c             	mov    0xc(%eax),%edx
  803386:	8b 45 08             	mov    0x8(%ebp),%eax
  803389:	8b 40 0c             	mov    0xc(%eax),%eax
  80338c:	01 c2                	add    %eax,%edx
  80338e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803391:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  803394:	8b 45 08             	mov    0x8(%ebp),%eax
  803397:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  80339e:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8033a8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033ac:	75 17                	jne    8033c5 <insert_sorted_with_merge_freeList+0x243>
  8033ae:	83 ec 04             	sub    $0x4,%esp
  8033b1:	68 94 46 80 00       	push   $0x804694
  8033b6:	68 49 01 00 00       	push   $0x149
  8033bb:	68 b7 46 80 00       	push   $0x8046b7
  8033c0:	e8 ee d2 ff ff       	call   8006b3 <_panic>
  8033c5:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8033cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ce:	89 10                	mov    %edx,(%eax)
  8033d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d3:	8b 00                	mov    (%eax),%eax
  8033d5:	85 c0                	test   %eax,%eax
  8033d7:	74 0d                	je     8033e6 <insert_sorted_with_merge_freeList+0x264>
  8033d9:	a1 48 51 80 00       	mov    0x805148,%eax
  8033de:	8b 55 08             	mov    0x8(%ebp),%edx
  8033e1:	89 50 04             	mov    %edx,0x4(%eax)
  8033e4:	eb 08                	jmp    8033ee <insert_sorted_with_merge_freeList+0x26c>
  8033e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e9:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8033ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f1:	a3 48 51 80 00       	mov    %eax,0x805148
  8033f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803400:	a1 54 51 80 00       	mov    0x805154,%eax
  803405:	40                   	inc    %eax
  803406:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80340b:	e9 bb 04 00 00       	jmp    8038cb <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  803410:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803414:	75 17                	jne    80342d <insert_sorted_with_merge_freeList+0x2ab>
  803416:	83 ec 04             	sub    $0x4,%esp
  803419:	68 08 47 80 00       	push   $0x804708
  80341e:	68 4c 01 00 00       	push   $0x14c
  803423:	68 b7 46 80 00       	push   $0x8046b7
  803428:	e8 86 d2 ff ff       	call   8006b3 <_panic>
  80342d:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803433:	8b 45 08             	mov    0x8(%ebp),%eax
  803436:	89 50 04             	mov    %edx,0x4(%eax)
  803439:	8b 45 08             	mov    0x8(%ebp),%eax
  80343c:	8b 40 04             	mov    0x4(%eax),%eax
  80343f:	85 c0                	test   %eax,%eax
  803441:	74 0c                	je     80344f <insert_sorted_with_merge_freeList+0x2cd>
  803443:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803448:	8b 55 08             	mov    0x8(%ebp),%edx
  80344b:	89 10                	mov    %edx,(%eax)
  80344d:	eb 08                	jmp    803457 <insert_sorted_with_merge_freeList+0x2d5>
  80344f:	8b 45 08             	mov    0x8(%ebp),%eax
  803452:	a3 38 51 80 00       	mov    %eax,0x805138
  803457:	8b 45 08             	mov    0x8(%ebp),%eax
  80345a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80345f:	8b 45 08             	mov    0x8(%ebp),%eax
  803462:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803468:	a1 44 51 80 00       	mov    0x805144,%eax
  80346d:	40                   	inc    %eax
  80346e:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803473:	e9 53 04 00 00       	jmp    8038cb <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803478:	a1 38 51 80 00       	mov    0x805138,%eax
  80347d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803480:	e9 15 04 00 00       	jmp    80389a <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  803485:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803488:	8b 00                	mov    (%eax),%eax
  80348a:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  80348d:	8b 45 08             	mov    0x8(%ebp),%eax
  803490:	8b 50 08             	mov    0x8(%eax),%edx
  803493:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803496:	8b 40 08             	mov    0x8(%eax),%eax
  803499:	39 c2                	cmp    %eax,%edx
  80349b:	0f 86 f1 03 00 00    	jbe    803892 <insert_sorted_with_merge_freeList+0x710>
  8034a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8034a4:	8b 50 08             	mov    0x8(%eax),%edx
  8034a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034aa:	8b 40 08             	mov    0x8(%eax),%eax
  8034ad:	39 c2                	cmp    %eax,%edx
  8034af:	0f 83 dd 03 00 00    	jae    803892 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  8034b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034b8:	8b 50 08             	mov    0x8(%eax),%edx
  8034bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034be:	8b 40 0c             	mov    0xc(%eax),%eax
  8034c1:	01 c2                	add    %eax,%edx
  8034c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8034c6:	8b 40 08             	mov    0x8(%eax),%eax
  8034c9:	39 c2                	cmp    %eax,%edx
  8034cb:	0f 85 b9 01 00 00    	jne    80368a <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8034d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8034d4:	8b 50 08             	mov    0x8(%eax),%edx
  8034d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8034da:	8b 40 0c             	mov    0xc(%eax),%eax
  8034dd:	01 c2                	add    %eax,%edx
  8034df:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034e2:	8b 40 08             	mov    0x8(%eax),%eax
  8034e5:	39 c2                	cmp    %eax,%edx
  8034e7:	0f 85 0d 01 00 00    	jne    8035fa <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  8034ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034f0:	8b 50 0c             	mov    0xc(%eax),%edx
  8034f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034f6:	8b 40 0c             	mov    0xc(%eax),%eax
  8034f9:	01 c2                	add    %eax,%edx
  8034fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034fe:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803501:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803505:	75 17                	jne    80351e <insert_sorted_with_merge_freeList+0x39c>
  803507:	83 ec 04             	sub    $0x4,%esp
  80350a:	68 60 47 80 00       	push   $0x804760
  80350f:	68 5c 01 00 00       	push   $0x15c
  803514:	68 b7 46 80 00       	push   $0x8046b7
  803519:	e8 95 d1 ff ff       	call   8006b3 <_panic>
  80351e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803521:	8b 00                	mov    (%eax),%eax
  803523:	85 c0                	test   %eax,%eax
  803525:	74 10                	je     803537 <insert_sorted_with_merge_freeList+0x3b5>
  803527:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80352a:	8b 00                	mov    (%eax),%eax
  80352c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80352f:	8b 52 04             	mov    0x4(%edx),%edx
  803532:	89 50 04             	mov    %edx,0x4(%eax)
  803535:	eb 0b                	jmp    803542 <insert_sorted_with_merge_freeList+0x3c0>
  803537:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80353a:	8b 40 04             	mov    0x4(%eax),%eax
  80353d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803542:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803545:	8b 40 04             	mov    0x4(%eax),%eax
  803548:	85 c0                	test   %eax,%eax
  80354a:	74 0f                	je     80355b <insert_sorted_with_merge_freeList+0x3d9>
  80354c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80354f:	8b 40 04             	mov    0x4(%eax),%eax
  803552:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803555:	8b 12                	mov    (%edx),%edx
  803557:	89 10                	mov    %edx,(%eax)
  803559:	eb 0a                	jmp    803565 <insert_sorted_with_merge_freeList+0x3e3>
  80355b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80355e:	8b 00                	mov    (%eax),%eax
  803560:	a3 38 51 80 00       	mov    %eax,0x805138
  803565:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803568:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80356e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803571:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803578:	a1 44 51 80 00       	mov    0x805144,%eax
  80357d:	48                   	dec    %eax
  80357e:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  803583:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803586:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  80358d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803590:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803597:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80359b:	75 17                	jne    8035b4 <insert_sorted_with_merge_freeList+0x432>
  80359d:	83 ec 04             	sub    $0x4,%esp
  8035a0:	68 94 46 80 00       	push   $0x804694
  8035a5:	68 5f 01 00 00       	push   $0x15f
  8035aa:	68 b7 46 80 00       	push   $0x8046b7
  8035af:	e8 ff d0 ff ff       	call   8006b3 <_panic>
  8035b4:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8035ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035bd:	89 10                	mov    %edx,(%eax)
  8035bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035c2:	8b 00                	mov    (%eax),%eax
  8035c4:	85 c0                	test   %eax,%eax
  8035c6:	74 0d                	je     8035d5 <insert_sorted_with_merge_freeList+0x453>
  8035c8:	a1 48 51 80 00       	mov    0x805148,%eax
  8035cd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8035d0:	89 50 04             	mov    %edx,0x4(%eax)
  8035d3:	eb 08                	jmp    8035dd <insert_sorted_with_merge_freeList+0x45b>
  8035d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035d8:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8035dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035e0:	a3 48 51 80 00       	mov    %eax,0x805148
  8035e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035e8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035ef:	a1 54 51 80 00       	mov    0x805154,%eax
  8035f4:	40                   	inc    %eax
  8035f5:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  8035fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035fd:	8b 50 0c             	mov    0xc(%eax),%edx
  803600:	8b 45 08             	mov    0x8(%ebp),%eax
  803603:	8b 40 0c             	mov    0xc(%eax),%eax
  803606:	01 c2                	add    %eax,%edx
  803608:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80360b:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  80360e:	8b 45 08             	mov    0x8(%ebp),%eax
  803611:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803618:	8b 45 08             	mov    0x8(%ebp),%eax
  80361b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803622:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803626:	75 17                	jne    80363f <insert_sorted_with_merge_freeList+0x4bd>
  803628:	83 ec 04             	sub    $0x4,%esp
  80362b:	68 94 46 80 00       	push   $0x804694
  803630:	68 64 01 00 00       	push   $0x164
  803635:	68 b7 46 80 00       	push   $0x8046b7
  80363a:	e8 74 d0 ff ff       	call   8006b3 <_panic>
  80363f:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803645:	8b 45 08             	mov    0x8(%ebp),%eax
  803648:	89 10                	mov    %edx,(%eax)
  80364a:	8b 45 08             	mov    0x8(%ebp),%eax
  80364d:	8b 00                	mov    (%eax),%eax
  80364f:	85 c0                	test   %eax,%eax
  803651:	74 0d                	je     803660 <insert_sorted_with_merge_freeList+0x4de>
  803653:	a1 48 51 80 00       	mov    0x805148,%eax
  803658:	8b 55 08             	mov    0x8(%ebp),%edx
  80365b:	89 50 04             	mov    %edx,0x4(%eax)
  80365e:	eb 08                	jmp    803668 <insert_sorted_with_merge_freeList+0x4e6>
  803660:	8b 45 08             	mov    0x8(%ebp),%eax
  803663:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803668:	8b 45 08             	mov    0x8(%ebp),%eax
  80366b:	a3 48 51 80 00       	mov    %eax,0x805148
  803670:	8b 45 08             	mov    0x8(%ebp),%eax
  803673:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80367a:	a1 54 51 80 00       	mov    0x805154,%eax
  80367f:	40                   	inc    %eax
  803680:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803685:	e9 41 02 00 00       	jmp    8038cb <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  80368a:	8b 45 08             	mov    0x8(%ebp),%eax
  80368d:	8b 50 08             	mov    0x8(%eax),%edx
  803690:	8b 45 08             	mov    0x8(%ebp),%eax
  803693:	8b 40 0c             	mov    0xc(%eax),%eax
  803696:	01 c2                	add    %eax,%edx
  803698:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80369b:	8b 40 08             	mov    0x8(%eax),%eax
  80369e:	39 c2                	cmp    %eax,%edx
  8036a0:	0f 85 7c 01 00 00    	jne    803822 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  8036a6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8036aa:	74 06                	je     8036b2 <insert_sorted_with_merge_freeList+0x530>
  8036ac:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8036b0:	75 17                	jne    8036c9 <insert_sorted_with_merge_freeList+0x547>
  8036b2:	83 ec 04             	sub    $0x4,%esp
  8036b5:	68 d0 46 80 00       	push   $0x8046d0
  8036ba:	68 69 01 00 00       	push   $0x169
  8036bf:	68 b7 46 80 00       	push   $0x8046b7
  8036c4:	e8 ea cf ff ff       	call   8006b3 <_panic>
  8036c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036cc:	8b 50 04             	mov    0x4(%eax),%edx
  8036cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8036d2:	89 50 04             	mov    %edx,0x4(%eax)
  8036d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8036d8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8036db:	89 10                	mov    %edx,(%eax)
  8036dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036e0:	8b 40 04             	mov    0x4(%eax),%eax
  8036e3:	85 c0                	test   %eax,%eax
  8036e5:	74 0d                	je     8036f4 <insert_sorted_with_merge_freeList+0x572>
  8036e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036ea:	8b 40 04             	mov    0x4(%eax),%eax
  8036ed:	8b 55 08             	mov    0x8(%ebp),%edx
  8036f0:	89 10                	mov    %edx,(%eax)
  8036f2:	eb 08                	jmp    8036fc <insert_sorted_with_merge_freeList+0x57a>
  8036f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8036f7:	a3 38 51 80 00       	mov    %eax,0x805138
  8036fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036ff:	8b 55 08             	mov    0x8(%ebp),%edx
  803702:	89 50 04             	mov    %edx,0x4(%eax)
  803705:	a1 44 51 80 00       	mov    0x805144,%eax
  80370a:	40                   	inc    %eax
  80370b:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803710:	8b 45 08             	mov    0x8(%ebp),%eax
  803713:	8b 50 0c             	mov    0xc(%eax),%edx
  803716:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803719:	8b 40 0c             	mov    0xc(%eax),%eax
  80371c:	01 c2                	add    %eax,%edx
  80371e:	8b 45 08             	mov    0x8(%ebp),%eax
  803721:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803724:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803728:	75 17                	jne    803741 <insert_sorted_with_merge_freeList+0x5bf>
  80372a:	83 ec 04             	sub    $0x4,%esp
  80372d:	68 60 47 80 00       	push   $0x804760
  803732:	68 6b 01 00 00       	push   $0x16b
  803737:	68 b7 46 80 00       	push   $0x8046b7
  80373c:	e8 72 cf ff ff       	call   8006b3 <_panic>
  803741:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803744:	8b 00                	mov    (%eax),%eax
  803746:	85 c0                	test   %eax,%eax
  803748:	74 10                	je     80375a <insert_sorted_with_merge_freeList+0x5d8>
  80374a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80374d:	8b 00                	mov    (%eax),%eax
  80374f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803752:	8b 52 04             	mov    0x4(%edx),%edx
  803755:	89 50 04             	mov    %edx,0x4(%eax)
  803758:	eb 0b                	jmp    803765 <insert_sorted_with_merge_freeList+0x5e3>
  80375a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80375d:	8b 40 04             	mov    0x4(%eax),%eax
  803760:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803765:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803768:	8b 40 04             	mov    0x4(%eax),%eax
  80376b:	85 c0                	test   %eax,%eax
  80376d:	74 0f                	je     80377e <insert_sorted_with_merge_freeList+0x5fc>
  80376f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803772:	8b 40 04             	mov    0x4(%eax),%eax
  803775:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803778:	8b 12                	mov    (%edx),%edx
  80377a:	89 10                	mov    %edx,(%eax)
  80377c:	eb 0a                	jmp    803788 <insert_sorted_with_merge_freeList+0x606>
  80377e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803781:	8b 00                	mov    (%eax),%eax
  803783:	a3 38 51 80 00       	mov    %eax,0x805138
  803788:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80378b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803791:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803794:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80379b:	a1 44 51 80 00       	mov    0x805144,%eax
  8037a0:	48                   	dec    %eax
  8037a1:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  8037a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037a9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  8037b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037b3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8037ba:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8037be:	75 17                	jne    8037d7 <insert_sorted_with_merge_freeList+0x655>
  8037c0:	83 ec 04             	sub    $0x4,%esp
  8037c3:	68 94 46 80 00       	push   $0x804694
  8037c8:	68 6e 01 00 00       	push   $0x16e
  8037cd:	68 b7 46 80 00       	push   $0x8046b7
  8037d2:	e8 dc ce ff ff       	call   8006b3 <_panic>
  8037d7:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8037dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037e0:	89 10                	mov    %edx,(%eax)
  8037e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037e5:	8b 00                	mov    (%eax),%eax
  8037e7:	85 c0                	test   %eax,%eax
  8037e9:	74 0d                	je     8037f8 <insert_sorted_with_merge_freeList+0x676>
  8037eb:	a1 48 51 80 00       	mov    0x805148,%eax
  8037f0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8037f3:	89 50 04             	mov    %edx,0x4(%eax)
  8037f6:	eb 08                	jmp    803800 <insert_sorted_with_merge_freeList+0x67e>
  8037f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037fb:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803800:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803803:	a3 48 51 80 00       	mov    %eax,0x805148
  803808:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80380b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803812:	a1 54 51 80 00       	mov    0x805154,%eax
  803817:	40                   	inc    %eax
  803818:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  80381d:	e9 a9 00 00 00       	jmp    8038cb <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803822:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803826:	74 06                	je     80382e <insert_sorted_with_merge_freeList+0x6ac>
  803828:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80382c:	75 17                	jne    803845 <insert_sorted_with_merge_freeList+0x6c3>
  80382e:	83 ec 04             	sub    $0x4,%esp
  803831:	68 2c 47 80 00       	push   $0x80472c
  803836:	68 73 01 00 00       	push   $0x173
  80383b:	68 b7 46 80 00       	push   $0x8046b7
  803840:	e8 6e ce ff ff       	call   8006b3 <_panic>
  803845:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803848:	8b 10                	mov    (%eax),%edx
  80384a:	8b 45 08             	mov    0x8(%ebp),%eax
  80384d:	89 10                	mov    %edx,(%eax)
  80384f:	8b 45 08             	mov    0x8(%ebp),%eax
  803852:	8b 00                	mov    (%eax),%eax
  803854:	85 c0                	test   %eax,%eax
  803856:	74 0b                	je     803863 <insert_sorted_with_merge_freeList+0x6e1>
  803858:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80385b:	8b 00                	mov    (%eax),%eax
  80385d:	8b 55 08             	mov    0x8(%ebp),%edx
  803860:	89 50 04             	mov    %edx,0x4(%eax)
  803863:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803866:	8b 55 08             	mov    0x8(%ebp),%edx
  803869:	89 10                	mov    %edx,(%eax)
  80386b:	8b 45 08             	mov    0x8(%ebp),%eax
  80386e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803871:	89 50 04             	mov    %edx,0x4(%eax)
  803874:	8b 45 08             	mov    0x8(%ebp),%eax
  803877:	8b 00                	mov    (%eax),%eax
  803879:	85 c0                	test   %eax,%eax
  80387b:	75 08                	jne    803885 <insert_sorted_with_merge_freeList+0x703>
  80387d:	8b 45 08             	mov    0x8(%ebp),%eax
  803880:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803885:	a1 44 51 80 00       	mov    0x805144,%eax
  80388a:	40                   	inc    %eax
  80388b:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803890:	eb 39                	jmp    8038cb <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803892:	a1 40 51 80 00       	mov    0x805140,%eax
  803897:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80389a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80389e:	74 07                	je     8038a7 <insert_sorted_with_merge_freeList+0x725>
  8038a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038a3:	8b 00                	mov    (%eax),%eax
  8038a5:	eb 05                	jmp    8038ac <insert_sorted_with_merge_freeList+0x72a>
  8038a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8038ac:	a3 40 51 80 00       	mov    %eax,0x805140
  8038b1:	a1 40 51 80 00       	mov    0x805140,%eax
  8038b6:	85 c0                	test   %eax,%eax
  8038b8:	0f 85 c7 fb ff ff    	jne    803485 <insert_sorted_with_merge_freeList+0x303>
  8038be:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8038c2:	0f 85 bd fb ff ff    	jne    803485 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8038c8:	eb 01                	jmp    8038cb <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8038ca:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8038cb:	90                   	nop
  8038cc:	c9                   	leave  
  8038cd:	c3                   	ret    
  8038ce:	66 90                	xchg   %ax,%ax

008038d0 <__udivdi3>:
  8038d0:	55                   	push   %ebp
  8038d1:	57                   	push   %edi
  8038d2:	56                   	push   %esi
  8038d3:	53                   	push   %ebx
  8038d4:	83 ec 1c             	sub    $0x1c,%esp
  8038d7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8038db:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8038df:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8038e3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8038e7:	89 ca                	mov    %ecx,%edx
  8038e9:	89 f8                	mov    %edi,%eax
  8038eb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8038ef:	85 f6                	test   %esi,%esi
  8038f1:	75 2d                	jne    803920 <__udivdi3+0x50>
  8038f3:	39 cf                	cmp    %ecx,%edi
  8038f5:	77 65                	ja     80395c <__udivdi3+0x8c>
  8038f7:	89 fd                	mov    %edi,%ebp
  8038f9:	85 ff                	test   %edi,%edi
  8038fb:	75 0b                	jne    803908 <__udivdi3+0x38>
  8038fd:	b8 01 00 00 00       	mov    $0x1,%eax
  803902:	31 d2                	xor    %edx,%edx
  803904:	f7 f7                	div    %edi
  803906:	89 c5                	mov    %eax,%ebp
  803908:	31 d2                	xor    %edx,%edx
  80390a:	89 c8                	mov    %ecx,%eax
  80390c:	f7 f5                	div    %ebp
  80390e:	89 c1                	mov    %eax,%ecx
  803910:	89 d8                	mov    %ebx,%eax
  803912:	f7 f5                	div    %ebp
  803914:	89 cf                	mov    %ecx,%edi
  803916:	89 fa                	mov    %edi,%edx
  803918:	83 c4 1c             	add    $0x1c,%esp
  80391b:	5b                   	pop    %ebx
  80391c:	5e                   	pop    %esi
  80391d:	5f                   	pop    %edi
  80391e:	5d                   	pop    %ebp
  80391f:	c3                   	ret    
  803920:	39 ce                	cmp    %ecx,%esi
  803922:	77 28                	ja     80394c <__udivdi3+0x7c>
  803924:	0f bd fe             	bsr    %esi,%edi
  803927:	83 f7 1f             	xor    $0x1f,%edi
  80392a:	75 40                	jne    80396c <__udivdi3+0x9c>
  80392c:	39 ce                	cmp    %ecx,%esi
  80392e:	72 0a                	jb     80393a <__udivdi3+0x6a>
  803930:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803934:	0f 87 9e 00 00 00    	ja     8039d8 <__udivdi3+0x108>
  80393a:	b8 01 00 00 00       	mov    $0x1,%eax
  80393f:	89 fa                	mov    %edi,%edx
  803941:	83 c4 1c             	add    $0x1c,%esp
  803944:	5b                   	pop    %ebx
  803945:	5e                   	pop    %esi
  803946:	5f                   	pop    %edi
  803947:	5d                   	pop    %ebp
  803948:	c3                   	ret    
  803949:	8d 76 00             	lea    0x0(%esi),%esi
  80394c:	31 ff                	xor    %edi,%edi
  80394e:	31 c0                	xor    %eax,%eax
  803950:	89 fa                	mov    %edi,%edx
  803952:	83 c4 1c             	add    $0x1c,%esp
  803955:	5b                   	pop    %ebx
  803956:	5e                   	pop    %esi
  803957:	5f                   	pop    %edi
  803958:	5d                   	pop    %ebp
  803959:	c3                   	ret    
  80395a:	66 90                	xchg   %ax,%ax
  80395c:	89 d8                	mov    %ebx,%eax
  80395e:	f7 f7                	div    %edi
  803960:	31 ff                	xor    %edi,%edi
  803962:	89 fa                	mov    %edi,%edx
  803964:	83 c4 1c             	add    $0x1c,%esp
  803967:	5b                   	pop    %ebx
  803968:	5e                   	pop    %esi
  803969:	5f                   	pop    %edi
  80396a:	5d                   	pop    %ebp
  80396b:	c3                   	ret    
  80396c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803971:	89 eb                	mov    %ebp,%ebx
  803973:	29 fb                	sub    %edi,%ebx
  803975:	89 f9                	mov    %edi,%ecx
  803977:	d3 e6                	shl    %cl,%esi
  803979:	89 c5                	mov    %eax,%ebp
  80397b:	88 d9                	mov    %bl,%cl
  80397d:	d3 ed                	shr    %cl,%ebp
  80397f:	89 e9                	mov    %ebp,%ecx
  803981:	09 f1                	or     %esi,%ecx
  803983:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803987:	89 f9                	mov    %edi,%ecx
  803989:	d3 e0                	shl    %cl,%eax
  80398b:	89 c5                	mov    %eax,%ebp
  80398d:	89 d6                	mov    %edx,%esi
  80398f:	88 d9                	mov    %bl,%cl
  803991:	d3 ee                	shr    %cl,%esi
  803993:	89 f9                	mov    %edi,%ecx
  803995:	d3 e2                	shl    %cl,%edx
  803997:	8b 44 24 08          	mov    0x8(%esp),%eax
  80399b:	88 d9                	mov    %bl,%cl
  80399d:	d3 e8                	shr    %cl,%eax
  80399f:	09 c2                	or     %eax,%edx
  8039a1:	89 d0                	mov    %edx,%eax
  8039a3:	89 f2                	mov    %esi,%edx
  8039a5:	f7 74 24 0c          	divl   0xc(%esp)
  8039a9:	89 d6                	mov    %edx,%esi
  8039ab:	89 c3                	mov    %eax,%ebx
  8039ad:	f7 e5                	mul    %ebp
  8039af:	39 d6                	cmp    %edx,%esi
  8039b1:	72 19                	jb     8039cc <__udivdi3+0xfc>
  8039b3:	74 0b                	je     8039c0 <__udivdi3+0xf0>
  8039b5:	89 d8                	mov    %ebx,%eax
  8039b7:	31 ff                	xor    %edi,%edi
  8039b9:	e9 58 ff ff ff       	jmp    803916 <__udivdi3+0x46>
  8039be:	66 90                	xchg   %ax,%ax
  8039c0:	8b 54 24 08          	mov    0x8(%esp),%edx
  8039c4:	89 f9                	mov    %edi,%ecx
  8039c6:	d3 e2                	shl    %cl,%edx
  8039c8:	39 c2                	cmp    %eax,%edx
  8039ca:	73 e9                	jae    8039b5 <__udivdi3+0xe5>
  8039cc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8039cf:	31 ff                	xor    %edi,%edi
  8039d1:	e9 40 ff ff ff       	jmp    803916 <__udivdi3+0x46>
  8039d6:	66 90                	xchg   %ax,%ax
  8039d8:	31 c0                	xor    %eax,%eax
  8039da:	e9 37 ff ff ff       	jmp    803916 <__udivdi3+0x46>
  8039df:	90                   	nop

008039e0 <__umoddi3>:
  8039e0:	55                   	push   %ebp
  8039e1:	57                   	push   %edi
  8039e2:	56                   	push   %esi
  8039e3:	53                   	push   %ebx
  8039e4:	83 ec 1c             	sub    $0x1c,%esp
  8039e7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8039eb:	8b 74 24 34          	mov    0x34(%esp),%esi
  8039ef:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8039f3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8039f7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8039fb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8039ff:	89 f3                	mov    %esi,%ebx
  803a01:	89 fa                	mov    %edi,%edx
  803a03:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803a07:	89 34 24             	mov    %esi,(%esp)
  803a0a:	85 c0                	test   %eax,%eax
  803a0c:	75 1a                	jne    803a28 <__umoddi3+0x48>
  803a0e:	39 f7                	cmp    %esi,%edi
  803a10:	0f 86 a2 00 00 00    	jbe    803ab8 <__umoddi3+0xd8>
  803a16:	89 c8                	mov    %ecx,%eax
  803a18:	89 f2                	mov    %esi,%edx
  803a1a:	f7 f7                	div    %edi
  803a1c:	89 d0                	mov    %edx,%eax
  803a1e:	31 d2                	xor    %edx,%edx
  803a20:	83 c4 1c             	add    $0x1c,%esp
  803a23:	5b                   	pop    %ebx
  803a24:	5e                   	pop    %esi
  803a25:	5f                   	pop    %edi
  803a26:	5d                   	pop    %ebp
  803a27:	c3                   	ret    
  803a28:	39 f0                	cmp    %esi,%eax
  803a2a:	0f 87 ac 00 00 00    	ja     803adc <__umoddi3+0xfc>
  803a30:	0f bd e8             	bsr    %eax,%ebp
  803a33:	83 f5 1f             	xor    $0x1f,%ebp
  803a36:	0f 84 ac 00 00 00    	je     803ae8 <__umoddi3+0x108>
  803a3c:	bf 20 00 00 00       	mov    $0x20,%edi
  803a41:	29 ef                	sub    %ebp,%edi
  803a43:	89 fe                	mov    %edi,%esi
  803a45:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803a49:	89 e9                	mov    %ebp,%ecx
  803a4b:	d3 e0                	shl    %cl,%eax
  803a4d:	89 d7                	mov    %edx,%edi
  803a4f:	89 f1                	mov    %esi,%ecx
  803a51:	d3 ef                	shr    %cl,%edi
  803a53:	09 c7                	or     %eax,%edi
  803a55:	89 e9                	mov    %ebp,%ecx
  803a57:	d3 e2                	shl    %cl,%edx
  803a59:	89 14 24             	mov    %edx,(%esp)
  803a5c:	89 d8                	mov    %ebx,%eax
  803a5e:	d3 e0                	shl    %cl,%eax
  803a60:	89 c2                	mov    %eax,%edx
  803a62:	8b 44 24 08          	mov    0x8(%esp),%eax
  803a66:	d3 e0                	shl    %cl,%eax
  803a68:	89 44 24 04          	mov    %eax,0x4(%esp)
  803a6c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803a70:	89 f1                	mov    %esi,%ecx
  803a72:	d3 e8                	shr    %cl,%eax
  803a74:	09 d0                	or     %edx,%eax
  803a76:	d3 eb                	shr    %cl,%ebx
  803a78:	89 da                	mov    %ebx,%edx
  803a7a:	f7 f7                	div    %edi
  803a7c:	89 d3                	mov    %edx,%ebx
  803a7e:	f7 24 24             	mull   (%esp)
  803a81:	89 c6                	mov    %eax,%esi
  803a83:	89 d1                	mov    %edx,%ecx
  803a85:	39 d3                	cmp    %edx,%ebx
  803a87:	0f 82 87 00 00 00    	jb     803b14 <__umoddi3+0x134>
  803a8d:	0f 84 91 00 00 00    	je     803b24 <__umoddi3+0x144>
  803a93:	8b 54 24 04          	mov    0x4(%esp),%edx
  803a97:	29 f2                	sub    %esi,%edx
  803a99:	19 cb                	sbb    %ecx,%ebx
  803a9b:	89 d8                	mov    %ebx,%eax
  803a9d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803aa1:	d3 e0                	shl    %cl,%eax
  803aa3:	89 e9                	mov    %ebp,%ecx
  803aa5:	d3 ea                	shr    %cl,%edx
  803aa7:	09 d0                	or     %edx,%eax
  803aa9:	89 e9                	mov    %ebp,%ecx
  803aab:	d3 eb                	shr    %cl,%ebx
  803aad:	89 da                	mov    %ebx,%edx
  803aaf:	83 c4 1c             	add    $0x1c,%esp
  803ab2:	5b                   	pop    %ebx
  803ab3:	5e                   	pop    %esi
  803ab4:	5f                   	pop    %edi
  803ab5:	5d                   	pop    %ebp
  803ab6:	c3                   	ret    
  803ab7:	90                   	nop
  803ab8:	89 fd                	mov    %edi,%ebp
  803aba:	85 ff                	test   %edi,%edi
  803abc:	75 0b                	jne    803ac9 <__umoddi3+0xe9>
  803abe:	b8 01 00 00 00       	mov    $0x1,%eax
  803ac3:	31 d2                	xor    %edx,%edx
  803ac5:	f7 f7                	div    %edi
  803ac7:	89 c5                	mov    %eax,%ebp
  803ac9:	89 f0                	mov    %esi,%eax
  803acb:	31 d2                	xor    %edx,%edx
  803acd:	f7 f5                	div    %ebp
  803acf:	89 c8                	mov    %ecx,%eax
  803ad1:	f7 f5                	div    %ebp
  803ad3:	89 d0                	mov    %edx,%eax
  803ad5:	e9 44 ff ff ff       	jmp    803a1e <__umoddi3+0x3e>
  803ada:	66 90                	xchg   %ax,%ax
  803adc:	89 c8                	mov    %ecx,%eax
  803ade:	89 f2                	mov    %esi,%edx
  803ae0:	83 c4 1c             	add    $0x1c,%esp
  803ae3:	5b                   	pop    %ebx
  803ae4:	5e                   	pop    %esi
  803ae5:	5f                   	pop    %edi
  803ae6:	5d                   	pop    %ebp
  803ae7:	c3                   	ret    
  803ae8:	3b 04 24             	cmp    (%esp),%eax
  803aeb:	72 06                	jb     803af3 <__umoddi3+0x113>
  803aed:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803af1:	77 0f                	ja     803b02 <__umoddi3+0x122>
  803af3:	89 f2                	mov    %esi,%edx
  803af5:	29 f9                	sub    %edi,%ecx
  803af7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803afb:	89 14 24             	mov    %edx,(%esp)
  803afe:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803b02:	8b 44 24 04          	mov    0x4(%esp),%eax
  803b06:	8b 14 24             	mov    (%esp),%edx
  803b09:	83 c4 1c             	add    $0x1c,%esp
  803b0c:	5b                   	pop    %ebx
  803b0d:	5e                   	pop    %esi
  803b0e:	5f                   	pop    %edi
  803b0f:	5d                   	pop    %ebp
  803b10:	c3                   	ret    
  803b11:	8d 76 00             	lea    0x0(%esi),%esi
  803b14:	2b 04 24             	sub    (%esp),%eax
  803b17:	19 fa                	sbb    %edi,%edx
  803b19:	89 d1                	mov    %edx,%ecx
  803b1b:	89 c6                	mov    %eax,%esi
  803b1d:	e9 71 ff ff ff       	jmp    803a93 <__umoddi3+0xb3>
  803b22:	66 90                	xchg   %ax,%ax
  803b24:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803b28:	72 ea                	jb     803b14 <__umoddi3+0x134>
  803b2a:	89 d9                	mov    %ebx,%ecx
  803b2c:	e9 62 ff ff ff       	jmp    803a93 <__umoddi3+0xb3>
