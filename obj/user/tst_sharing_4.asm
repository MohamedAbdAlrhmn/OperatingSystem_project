
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
  80008d:	68 80 3a 80 00       	push   $0x803a80
  800092:	6a 12                	push   $0x12
  800094:	68 9c 3a 80 00       	push   $0x803a9c
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
  8000ae:	68 b4 3a 80 00       	push   $0x803ab4
  8000b3:	e8 af 08 00 00       	call   800967 <cprintf>
  8000b8:	83 c4 10             	add    $0x10,%esp
	cprintf("MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  8000bb:	83 ec 0c             	sub    $0xc,%esp
  8000be:	68 e8 3a 80 00       	push   $0x803ae8
  8000c3:	e8 9f 08 00 00       	call   800967 <cprintf>
  8000c8:	83 c4 10             	add    $0x10,%esp
	cprintf("************************************************\n\n\n");
  8000cb:	83 ec 0c             	sub    $0xc,%esp
  8000ce:	68 44 3b 80 00       	push   $0x803b44
  8000d3:	e8 8f 08 00 00       	call   800967 <cprintf>
  8000d8:	83 c4 10             	add    $0x10,%esp

	int Mega = 1024*1024;
  8000db:	c7 45 ec 00 00 10 00 	movl   $0x100000,-0x14(%ebp)
	int kilo = 1024;
  8000e2:	c7 45 e8 00 04 00 00 	movl   $0x400,-0x18(%ebp)
	int envID = sys_getenvid();
  8000e9:	e8 2f 1e 00 00       	call   801f1d <sys_getenvid>
  8000ee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	cprintf("STEP A: checking free of a shared object ... \n");
  8000f1:	83 ec 0c             	sub    $0xc,%esp
  8000f4:	68 78 3b 80 00       	push   $0x803b78
  8000f9:	e8 69 08 00 00       	call   800967 <cprintf>
  8000fe:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x;
		int freeFrames = sys_calculate_free_frames() ;
  800101:	e8 50 1b 00 00       	call   801c56 <sys_calculate_free_frames>
  800106:	89 45 e0             	mov    %eax,-0x20(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  800109:	83 ec 04             	sub    $0x4,%esp
  80010c:	6a 01                	push   $0x1
  80010e:	68 00 10 00 00       	push   $0x1000
  800113:	68 a7 3b 80 00       	push   $0x803ba7
  800118:	e8 67 18 00 00       	call   801984 <smalloc>
  80011d:	83 c4 10             	add    $0x10,%esp
  800120:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (x != (uint32*)USER_HEAP_START) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  800123:	81 7d dc 00 00 00 80 	cmpl   $0x80000000,-0x24(%ebp)
  80012a:	74 14                	je     800140 <_main+0x108>
  80012c:	83 ec 04             	sub    $0x4,%esp
  80012f:	68 ac 3b 80 00       	push   $0x803bac
  800134:	6a 24                	push   $0x24
  800136:	68 9c 3a 80 00       	push   $0x803a9c
  80013b:	e8 73 05 00 00       	call   8006b3 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800140:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800143:	e8 0e 1b 00 00       	call   801c56 <sys_calculate_free_frames>
  800148:	29 c3                	sub    %eax,%ebx
  80014a:	89 d8                	mov    %ebx,%eax
  80014c:	83 f8 04             	cmp    $0x4,%eax
  80014f:	74 14                	je     800165 <_main+0x12d>
  800151:	83 ec 04             	sub    $0x4,%esp
  800154:	68 18 3c 80 00       	push   $0x803c18
  800159:	6a 25                	push   $0x25
  80015b:	68 9c 3a 80 00       	push   $0x803a9c
  800160:	e8 4e 05 00 00       	call   8006b3 <_panic>

		sfree(x);
  800165:	83 ec 0c             	sub    $0xc,%esp
  800168:	ff 75 dc             	pushl  -0x24(%ebp)
  80016b:	e8 86 19 00 00       	call   801af6 <sfree>
  800170:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) ==  0+0+2) panic("Wrong free: make sure that you free the shared object by calling free_share_object()");
  800173:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800176:	e8 db 1a 00 00       	call   801c56 <sys_calculate_free_frames>
  80017b:	29 c3                	sub    %eax,%ebx
  80017d:	89 d8                	mov    %ebx,%eax
  80017f:	83 f8 02             	cmp    $0x2,%eax
  800182:	75 14                	jne    800198 <_main+0x160>
  800184:	83 ec 04             	sub    $0x4,%esp
  800187:	68 98 3c 80 00       	push   $0x803c98
  80018c:	6a 28                	push   $0x28
  80018e:	68 9c 3a 80 00       	push   $0x803a9c
  800193:	e8 1b 05 00 00       	call   8006b3 <_panic>
		else if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong free: revise your freeSharedObject logic");
  800198:	e8 b9 1a 00 00       	call   801c56 <sys_calculate_free_frames>
  80019d:	89 c2                	mov    %eax,%edx
  80019f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001a2:	39 c2                	cmp    %eax,%edx
  8001a4:	74 14                	je     8001ba <_main+0x182>
  8001a6:	83 ec 04             	sub    $0x4,%esp
  8001a9:	68 f0 3c 80 00       	push   $0x803cf0
  8001ae:	6a 29                	push   $0x29
  8001b0:	68 9c 3a 80 00       	push   $0x803a9c
  8001b5:	e8 f9 04 00 00       	call   8006b3 <_panic>
	}
	cprintf("Step A completed successfully!!\n\n\n");
  8001ba:	83 ec 0c             	sub    $0xc,%esp
  8001bd:	68 20 3d 80 00       	push   $0x803d20
  8001c2:	e8 a0 07 00 00       	call   800967 <cprintf>
  8001c7:	83 c4 10             	add    $0x10,%esp


	cprintf("STEP B: checking free of 2 shared objects ... \n");
  8001ca:	83 ec 0c             	sub    $0xc,%esp
  8001cd:	68 44 3d 80 00       	push   $0x803d44
  8001d2:	e8 90 07 00 00       	call   800967 <cprintf>
  8001d7:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x, *z ;
		int freeFrames = sys_calculate_free_frames() ;
  8001da:	e8 77 1a 00 00       	call   801c56 <sys_calculate_free_frames>
  8001df:	89 45 d8             	mov    %eax,-0x28(%ebp)
		z = smalloc("z", PAGE_SIZE, 1);
  8001e2:	83 ec 04             	sub    $0x4,%esp
  8001e5:	6a 01                	push   $0x1
  8001e7:	68 00 10 00 00       	push   $0x1000
  8001ec:	68 74 3d 80 00       	push   $0x803d74
  8001f1:	e8 8e 17 00 00       	call   801984 <smalloc>
  8001f6:	83 c4 10             	add    $0x10,%esp
  8001f9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8001fc:	83 ec 04             	sub    $0x4,%esp
  8001ff:	6a 01                	push   $0x1
  800201:	68 00 10 00 00       	push   $0x1000
  800206:	68 a7 3b 80 00       	push   $0x803ba7
  80020b:	e8 74 17 00 00       	call   801984 <smalloc>
  800210:	83 c4 10             	add    $0x10,%esp
  800213:	89 45 d0             	mov    %eax,-0x30(%ebp)

		if(x == NULL) panic("Wrong free: make sure that you free the shared object by calling free_share_object()");
  800216:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80021a:	75 14                	jne    800230 <_main+0x1f8>
  80021c:	83 ec 04             	sub    $0x4,%esp
  80021f:	68 98 3c 80 00       	push   $0x803c98
  800224:	6a 35                	push   $0x35
  800226:	68 9c 3a 80 00       	push   $0x803a9c
  80022b:	e8 83 04 00 00       	call   8006b3 <_panic>

		if ((freeFrames - sys_calculate_free_frames()) !=  2+1+4) panic("Wrong previous free: make sure that you correctly free shared object before (Step A)");
  800230:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800233:	e8 1e 1a 00 00       	call   801c56 <sys_calculate_free_frames>
  800238:	29 c3                	sub    %eax,%ebx
  80023a:	89 d8                	mov    %ebx,%eax
  80023c:	83 f8 07             	cmp    $0x7,%eax
  80023f:	74 14                	je     800255 <_main+0x21d>
  800241:	83 ec 04             	sub    $0x4,%esp
  800244:	68 78 3d 80 00       	push   $0x803d78
  800249:	6a 37                	push   $0x37
  80024b:	68 9c 3a 80 00       	push   $0x803a9c
  800250:	e8 5e 04 00 00       	call   8006b3 <_panic>

		sfree(z);
  800255:	83 ec 0c             	sub    $0xc,%esp
  800258:	ff 75 d4             	pushl  -0x2c(%ebp)
  80025b:	e8 96 18 00 00       	call   801af6 <sfree>
  800260:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong free: check your logic");
  800263:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800266:	e8 eb 19 00 00       	call   801c56 <sys_calculate_free_frames>
  80026b:	29 c3                	sub    %eax,%ebx
  80026d:	89 d8                	mov    %ebx,%eax
  80026f:	83 f8 04             	cmp    $0x4,%eax
  800272:	74 14                	je     800288 <_main+0x250>
  800274:	83 ec 04             	sub    $0x4,%esp
  800277:	68 cd 3d 80 00       	push   $0x803dcd
  80027c:	6a 3a                	push   $0x3a
  80027e:	68 9c 3a 80 00       	push   $0x803a9c
  800283:	e8 2b 04 00 00       	call   8006b3 <_panic>

		sfree(x);
  800288:	83 ec 0c             	sub    $0xc,%esp
  80028b:	ff 75 d0             	pushl  -0x30(%ebp)
  80028e:	e8 63 18 00 00       	call   801af6 <sfree>
  800293:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong free: check your logic");
  800296:	e8 bb 19 00 00       	call   801c56 <sys_calculate_free_frames>
  80029b:	89 c2                	mov    %eax,%edx
  80029d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8002a0:	39 c2                	cmp    %eax,%edx
  8002a2:	74 14                	je     8002b8 <_main+0x280>
  8002a4:	83 ec 04             	sub    $0x4,%esp
  8002a7:	68 cd 3d 80 00       	push   $0x803dcd
  8002ac:	6a 3d                	push   $0x3d
  8002ae:	68 9c 3a 80 00       	push   $0x803a9c
  8002b3:	e8 fb 03 00 00       	call   8006b3 <_panic>

	}
	cprintf("Step B completed successfully!!\n\n\n");
  8002b8:	83 ec 0c             	sub    $0xc,%esp
  8002bb:	68 ec 3d 80 00       	push   $0x803dec
  8002c0:	e8 a2 06 00 00       	call   800967 <cprintf>
  8002c5:	83 c4 10             	add    $0x10,%esp

	cprintf("STEP C: checking range of loop during free... \n");
  8002c8:	83 ec 0c             	sub    $0xc,%esp
  8002cb:	68 10 3e 80 00       	push   $0x803e10
  8002d0:	e8 92 06 00 00       	call   800967 <cprintf>
  8002d5:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *w, *u;
		int freeFrames = sys_calculate_free_frames() ;
  8002d8:	e8 79 19 00 00       	call   801c56 <sys_calculate_free_frames>
  8002dd:	89 45 cc             	mov    %eax,-0x34(%ebp)
		w = smalloc("w", 3 * PAGE_SIZE+1, 1);
  8002e0:	83 ec 04             	sub    $0x4,%esp
  8002e3:	6a 01                	push   $0x1
  8002e5:	68 01 30 00 00       	push   $0x3001
  8002ea:	68 40 3e 80 00       	push   $0x803e40
  8002ef:	e8 90 16 00 00       	call   801984 <smalloc>
  8002f4:	83 c4 10             	add    $0x10,%esp
  8002f7:	89 45 c8             	mov    %eax,-0x38(%ebp)
		u = smalloc("u", PAGE_SIZE, 1);
  8002fa:	83 ec 04             	sub    $0x4,%esp
  8002fd:	6a 01                	push   $0x1
  8002ff:	68 00 10 00 00       	push   $0x1000
  800304:	68 42 3e 80 00       	push   $0x803e42
  800309:	e8 76 16 00 00       	call   801984 <smalloc>
  80030e:	83 c4 10             	add    $0x10,%esp
  800311:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		if ((freeFrames - sys_calculate_free_frames()) != 5+1+4) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800314:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800317:	e8 3a 19 00 00       	call   801c56 <sys_calculate_free_frames>
  80031c:	29 c3                	sub    %eax,%ebx
  80031e:	89 d8                	mov    %ebx,%eax
  800320:	83 f8 0a             	cmp    $0xa,%eax
  800323:	74 14                	je     800339 <_main+0x301>
  800325:	83 ec 04             	sub    $0x4,%esp
  800328:	68 18 3c 80 00       	push   $0x803c18
  80032d:	6a 48                	push   $0x48
  80032f:	68 9c 3a 80 00       	push   $0x803a9c
  800334:	e8 7a 03 00 00       	call   8006b3 <_panic>

		sfree(w);
  800339:	83 ec 0c             	sub    $0xc,%esp
  80033c:	ff 75 c8             	pushl  -0x38(%ebp)
  80033f:	e8 b2 17 00 00       	call   801af6 <sfree>
  800344:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong free: check your logic");
  800347:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  80034a:	e8 07 19 00 00       	call   801c56 <sys_calculate_free_frames>
  80034f:	29 c3                	sub    %eax,%ebx
  800351:	89 d8                	mov    %ebx,%eax
  800353:	83 f8 04             	cmp    $0x4,%eax
  800356:	74 14                	je     80036c <_main+0x334>
  800358:	83 ec 04             	sub    $0x4,%esp
  80035b:	68 cd 3d 80 00       	push   $0x803dcd
  800360:	6a 4b                	push   $0x4b
  800362:	68 9c 3a 80 00       	push   $0x803a9c
  800367:	e8 47 03 00 00       	call   8006b3 <_panic>

		uint32 *o;

		o = smalloc("o", 2 * PAGE_SIZE-1,1);
  80036c:	83 ec 04             	sub    $0x4,%esp
  80036f:	6a 01                	push   $0x1
  800371:	68 ff 1f 00 00       	push   $0x1fff
  800376:	68 44 3e 80 00       	push   $0x803e44
  80037b:	e8 04 16 00 00       	call   801984 <smalloc>
  800380:	83 c4 10             	add    $0x10,%esp
  800383:	89 45 c0             	mov    %eax,-0x40(%ebp)

		cprintf("2\n");
  800386:	83 ec 0c             	sub    $0xc,%esp
  800389:	68 46 3e 80 00       	push   $0x803e46
  80038e:	e8 d4 05 00 00       	call   800967 <cprintf>
  800393:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) != 3+1+4) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800396:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800399:	e8 b8 18 00 00       	call   801c56 <sys_calculate_free_frames>
  80039e:	29 c3                	sub    %eax,%ebx
  8003a0:	89 d8                	mov    %ebx,%eax
  8003a2:	83 f8 08             	cmp    $0x8,%eax
  8003a5:	74 14                	je     8003bb <_main+0x383>
  8003a7:	83 ec 04             	sub    $0x4,%esp
  8003aa:	68 18 3c 80 00       	push   $0x803c18
  8003af:	6a 52                	push   $0x52
  8003b1:	68 9c 3a 80 00       	push   $0x803a9c
  8003b6:	e8 f8 02 00 00       	call   8006b3 <_panic>

		sfree(o);
  8003bb:	83 ec 0c             	sub    $0xc,%esp
  8003be:	ff 75 c0             	pushl  -0x40(%ebp)
  8003c1:	e8 30 17 00 00       	call   801af6 <sfree>
  8003c6:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong free: check your logic");
  8003c9:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8003cc:	e8 85 18 00 00       	call   801c56 <sys_calculate_free_frames>
  8003d1:	29 c3                	sub    %eax,%ebx
  8003d3:	89 d8                	mov    %ebx,%eax
  8003d5:	83 f8 04             	cmp    $0x4,%eax
  8003d8:	74 14                	je     8003ee <_main+0x3b6>
  8003da:	83 ec 04             	sub    $0x4,%esp
  8003dd:	68 cd 3d 80 00       	push   $0x803dcd
  8003e2:	6a 55                	push   $0x55
  8003e4:	68 9c 3a 80 00       	push   $0x803a9c
  8003e9:	e8 c5 02 00 00       	call   8006b3 <_panic>

		sfree(u);
  8003ee:	83 ec 0c             	sub    $0xc,%esp
  8003f1:	ff 75 c4             	pushl  -0x3c(%ebp)
  8003f4:	e8 fd 16 00 00       	call   801af6 <sfree>
  8003f9:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong free: check your logic");
  8003fc:	e8 55 18 00 00       	call   801c56 <sys_calculate_free_frames>
  800401:	89 c2                	mov    %eax,%edx
  800403:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800406:	39 c2                	cmp    %eax,%edx
  800408:	74 14                	je     80041e <_main+0x3e6>
  80040a:	83 ec 04             	sub    $0x4,%esp
  80040d:	68 cd 3d 80 00       	push   $0x803dcd
  800412:	6a 58                	push   $0x58
  800414:	68 9c 3a 80 00       	push   $0x803a9c
  800419:	e8 95 02 00 00       	call   8006b3 <_panic>


		//Checking boundaries of page tables
		freeFrames = sys_calculate_free_frames() ;
  80041e:	e8 33 18 00 00       	call   801c56 <sys_calculate_free_frames>
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
  800438:	68 40 3e 80 00       	push   $0x803e40
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
  80045e:	68 42 3e 80 00       	push   $0x803e42
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
  800480:	68 44 3e 80 00       	push   $0x803e44
  800485:	e8 fa 14 00 00       	call   801984 <smalloc>
  80048a:	83 c4 10             	add    $0x10,%esp
  80048d:	89 45 c0             	mov    %eax,-0x40(%ebp)

		if ((freeFrames - sys_calculate_free_frames()) != 3073+4+7) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800490:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800493:	e8 be 17 00 00       	call   801c56 <sys_calculate_free_frames>
  800498:	29 c3                	sub    %eax,%ebx
  80049a:	89 d8                	mov    %ebx,%eax
  80049c:	3d 0c 0c 00 00       	cmp    $0xc0c,%eax
  8004a1:	74 14                	je     8004b7 <_main+0x47f>
  8004a3:	83 ec 04             	sub    $0x4,%esp
  8004a6:	68 18 3c 80 00       	push   $0x803c18
  8004ab:	6a 61                	push   $0x61
  8004ad:	68 9c 3a 80 00       	push   $0x803a9c
  8004b2:	e8 fc 01 00 00       	call   8006b3 <_panic>

		sfree(o);
  8004b7:	83 ec 0c             	sub    $0xc,%esp
  8004ba:	ff 75 c0             	pushl  -0x40(%ebp)
  8004bd:	e8 34 16 00 00       	call   801af6 <sfree>
  8004c2:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  2560+3+5) panic("Wrong free: check your logic");
  8004c5:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8004c8:	e8 89 17 00 00       	call   801c56 <sys_calculate_free_frames>
  8004cd:	29 c3                	sub    %eax,%ebx
  8004cf:	89 d8                	mov    %ebx,%eax
  8004d1:	3d 08 0a 00 00       	cmp    $0xa08,%eax
  8004d6:	74 14                	je     8004ec <_main+0x4b4>
  8004d8:	83 ec 04             	sub    $0x4,%esp
  8004db:	68 cd 3d 80 00       	push   $0x803dcd
  8004e0:	6a 64                	push   $0x64
  8004e2:	68 9c 3a 80 00       	push   $0x803a9c
  8004e7:	e8 c7 01 00 00       	call   8006b3 <_panic>

		sfree(w);
  8004ec:	83 ec 0c             	sub    $0xc,%esp
  8004ef:	ff 75 c8             	pushl  -0x38(%ebp)
  8004f2:	e8 ff 15 00 00       	call   801af6 <sfree>
  8004f7:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  1792+3+3) panic("Wrong free: check your logic");
  8004fa:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8004fd:	e8 54 17 00 00       	call   801c56 <sys_calculate_free_frames>
  800502:	29 c3                	sub    %eax,%ebx
  800504:	89 d8                	mov    %ebx,%eax
  800506:	3d 06 07 00 00       	cmp    $0x706,%eax
  80050b:	74 14                	je     800521 <_main+0x4e9>
  80050d:	83 ec 04             	sub    $0x4,%esp
  800510:	68 cd 3d 80 00       	push   $0x803dcd
  800515:	6a 67                	push   $0x67
  800517:	68 9c 3a 80 00       	push   $0x803a9c
  80051c:	e8 92 01 00 00       	call   8006b3 <_panic>

		sfree(u);
  800521:	83 ec 0c             	sub    $0xc,%esp
  800524:	ff 75 c4             	pushl  -0x3c(%ebp)
  800527:	e8 ca 15 00 00       	call   801af6 <sfree>
  80052c:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong free: check your logic");
  80052f:	e8 22 17 00 00       	call   801c56 <sys_calculate_free_frames>
  800534:	89 c2                	mov    %eax,%edx
  800536:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800539:	39 c2                	cmp    %eax,%edx
  80053b:	74 14                	je     800551 <_main+0x519>
  80053d:	83 ec 04             	sub    $0x4,%esp
  800540:	68 cd 3d 80 00       	push   $0x803dcd
  800545:	6a 6a                	push   $0x6a
  800547:	68 9c 3a 80 00       	push   $0x803a9c
  80054c:	e8 62 01 00 00       	call   8006b3 <_panic>
	}
	cprintf("Step C completed successfully!!\n\n\n");
  800551:	83 ec 0c             	sub    $0xc,%esp
  800554:	68 4c 3e 80 00       	push   $0x803e4c
  800559:	e8 09 04 00 00       	call   800967 <cprintf>
  80055e:	83 c4 10             	add    $0x10,%esp

	cprintf("Congratulations!! Test of freeSharedObjects [4] completed successfully!!\n\n\n");
  800561:	83 ec 0c             	sub    $0xc,%esp
  800564:	68 70 3e 80 00       	push   $0x803e70
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
  80057d:	e8 b4 19 00 00       	call   801f36 <sys_getenvindex>
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
  8005e8:	e8 56 17 00 00       	call   801d43 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8005ed:	83 ec 0c             	sub    $0xc,%esp
  8005f0:	68 d4 3e 80 00       	push   $0x803ed4
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
  800618:	68 fc 3e 80 00       	push   $0x803efc
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
  800649:	68 24 3f 80 00       	push   $0x803f24
  80064e:	e8 14 03 00 00       	call   800967 <cprintf>
  800653:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800656:	a1 20 50 80 00       	mov    0x805020,%eax
  80065b:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800661:	83 ec 08             	sub    $0x8,%esp
  800664:	50                   	push   %eax
  800665:	68 7c 3f 80 00       	push   $0x803f7c
  80066a:	e8 f8 02 00 00       	call   800967 <cprintf>
  80066f:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800672:	83 ec 0c             	sub    $0xc,%esp
  800675:	68 d4 3e 80 00       	push   $0x803ed4
  80067a:	e8 e8 02 00 00       	call   800967 <cprintf>
  80067f:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800682:	e8 d6 16 00 00       	call   801d5d <sys_enable_interrupt>

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
  80069a:	e8 63 18 00 00       	call   801f02 <sys_destroy_env>
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
  8006ab:	e8 b8 18 00 00       	call   801f68 <sys_exit_env>
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
  8006d4:	68 90 3f 80 00       	push   $0x803f90
  8006d9:	e8 89 02 00 00       	call   800967 <cprintf>
  8006de:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8006e1:	a1 00 50 80 00       	mov    0x805000,%eax
  8006e6:	ff 75 0c             	pushl  0xc(%ebp)
  8006e9:	ff 75 08             	pushl  0x8(%ebp)
  8006ec:	50                   	push   %eax
  8006ed:	68 95 3f 80 00       	push   $0x803f95
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
  800711:	68 b1 3f 80 00       	push   $0x803fb1
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
  80073d:	68 b4 3f 80 00       	push   $0x803fb4
  800742:	6a 26                	push   $0x26
  800744:	68 00 40 80 00       	push   $0x804000
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
  80080f:	68 0c 40 80 00       	push   $0x80400c
  800814:	6a 3a                	push   $0x3a
  800816:	68 00 40 80 00       	push   $0x804000
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
  80087f:	68 60 40 80 00       	push   $0x804060
  800884:	6a 44                	push   $0x44
  800886:	68 00 40 80 00       	push   $0x804000
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
  8008d9:	e8 b7 12 00 00       	call   801b95 <sys_cputs>
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
  800950:	e8 40 12 00 00       	call   801b95 <sys_cputs>
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
  80099a:	e8 a4 13 00 00       	call   801d43 <sys_disable_interrupt>
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
  8009ba:	e8 9e 13 00 00       	call   801d5d <sys_enable_interrupt>
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
  800a04:	e8 0f 2e 00 00       	call   803818 <__udivdi3>
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
  800a54:	e8 cf 2e 00 00       	call   803928 <__umoddi3>
  800a59:	83 c4 10             	add    $0x10,%esp
  800a5c:	05 d4 42 80 00       	add    $0x8042d4,%eax
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
  800baf:	8b 04 85 f8 42 80 00 	mov    0x8042f8(,%eax,4),%eax
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
  800c90:	8b 34 9d 40 41 80 00 	mov    0x804140(,%ebx,4),%esi
  800c97:	85 f6                	test   %esi,%esi
  800c99:	75 19                	jne    800cb4 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800c9b:	53                   	push   %ebx
  800c9c:	68 e5 42 80 00       	push   $0x8042e5
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
  800cb5:	68 ee 42 80 00       	push   $0x8042ee
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
  800ce2:	be f1 42 80 00       	mov    $0x8042f1,%esi
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
  801708:	68 50 44 80 00       	push   $0x804450
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
  8017d8:	e8 fc 04 00 00       	call   801cd9 <sys_allocate_chunk>
  8017dd:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8017e0:	a1 20 51 80 00       	mov    0x805120,%eax
  8017e5:	83 ec 0c             	sub    $0xc,%esp
  8017e8:	50                   	push   %eax
  8017e9:	e8 71 0b 00 00       	call   80235f <initialize_MemBlocksList>
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
  801816:	68 75 44 80 00       	push   $0x804475
  80181b:	6a 33                	push   $0x33
  80181d:	68 93 44 80 00       	push   $0x804493
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
  801895:	68 a0 44 80 00       	push   $0x8044a0
  80189a:	6a 34                	push   $0x34
  80189c:	68 93 44 80 00       	push   $0x804493
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
  80192d:	e8 75 07 00 00       	call   8020a7 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801932:	85 c0                	test   %eax,%eax
  801934:	74 11                	je     801947 <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  801936:	83 ec 0c             	sub    $0xc,%esp
  801939:	ff 75 e8             	pushl  -0x18(%ebp)
  80193c:	e8 e0 0d 00 00       	call   802721 <alloc_block_FF>
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
  801953:	e8 3c 0b 00 00       	call   802494 <insert_sorted_allocList>
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
  801973:	68 c4 44 80 00       	push   $0x8044c4
  801978:	6a 6f                	push   $0x6f
  80197a:	68 93 44 80 00       	push   $0x804493
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
  801999:	75 0a                	jne    8019a5 <smalloc+0x21>
  80199b:	b8 00 00 00 00       	mov    $0x0,%eax
  8019a0:	e9 8b 00 00 00       	jmp    801a30 <smalloc+0xac>
	//	   Else, return NULL

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  8019a5:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8019ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019b2:	01 d0                	add    %edx,%eax
  8019b4:	48                   	dec    %eax
  8019b5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8019b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019bb:	ba 00 00 00 00       	mov    $0x0,%edx
  8019c0:	f7 75 f0             	divl   -0x10(%ebp)
  8019c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019c6:	29 d0                	sub    %edx,%eax
  8019c8:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  8019cb:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  8019d2:	e8 d0 06 00 00       	call   8020a7 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8019d7:	85 c0                	test   %eax,%eax
  8019d9:	74 11                	je     8019ec <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  8019db:	83 ec 0c             	sub    $0xc,%esp
  8019de:	ff 75 e8             	pushl  -0x18(%ebp)
  8019e1:	e8 3b 0d 00 00       	call   802721 <alloc_block_FF>
  8019e6:	83 c4 10             	add    $0x10,%esp
  8019e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(mem_block != NULL)
  8019ec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8019f0:	74 39                	je     801a2b <smalloc+0xa7>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  8019f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019f5:	8b 40 08             	mov    0x8(%eax),%eax
  8019f8:	89 c2                	mov    %eax,%edx
  8019fa:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8019fe:	52                   	push   %edx
  8019ff:	50                   	push   %eax
  801a00:	ff 75 0c             	pushl  0xc(%ebp)
  801a03:	ff 75 08             	pushl  0x8(%ebp)
  801a06:	e8 21 04 00 00       	call   801e2c <sys_createSharedObject>
  801a0b:	83 c4 10             	add    $0x10,%esp
  801a0e:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  801a11:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  801a15:	74 14                	je     801a2b <smalloc+0xa7>
  801a17:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  801a1b:	74 0e                	je     801a2b <smalloc+0xa7>
  801a1d:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  801a21:	74 08                	je     801a2b <smalloc+0xa7>
			return (void*) mem_block->sva;
  801a23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a26:	8b 40 08             	mov    0x8(%eax),%eax
  801a29:	eb 05                	jmp    801a30 <smalloc+0xac>
	}
	return NULL;
  801a2b:	b8 00 00 00 00       	mov    $0x0,%eax

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801a30:	c9                   	leave  
  801a31:	c3                   	ret    

00801a32 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801a32:	55                   	push   %ebp
  801a33:	89 e5                	mov    %esp,%ebp
  801a35:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801a38:	e8 b4 fc ff ff       	call   8016f1 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801a3d:	83 ec 08             	sub    $0x8,%esp
  801a40:	ff 75 0c             	pushl  0xc(%ebp)
  801a43:	ff 75 08             	pushl  0x8(%ebp)
  801a46:	e8 0b 04 00 00       	call   801e56 <sys_getSizeOfSharedObject>
  801a4b:	83 c4 10             	add    $0x10,%esp
  801a4e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size != E_SHARED_MEM_NOT_EXISTS)
  801a51:	83 7d f0 f0          	cmpl   $0xfffffff0,-0x10(%ebp)
  801a55:	74 76                	je     801acd <sget+0x9b>
	{
		uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801a57:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801a5e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a61:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a64:	01 d0                	add    %edx,%eax
  801a66:	48                   	dec    %eax
  801a67:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801a6a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a6d:	ba 00 00 00 00       	mov    $0x0,%edx
  801a72:	f7 75 ec             	divl   -0x14(%ebp)
  801a75:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a78:	29 d0                	sub    %edx,%eax
  801a7a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		struct MemBlock * mem_block = NULL;
  801a7d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801a84:	e8 1e 06 00 00       	call   8020a7 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801a89:	85 c0                	test   %eax,%eax
  801a8b:	74 11                	je     801a9e <sget+0x6c>
			mem_block = alloc_block_FF(allocate_space);
  801a8d:	83 ec 0c             	sub    $0xc,%esp
  801a90:	ff 75 e4             	pushl  -0x1c(%ebp)
  801a93:	e8 89 0c 00 00       	call   802721 <alloc_block_FF>
  801a98:	83 c4 10             	add    $0x10,%esp
  801a9b:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(mem_block != NULL)
  801a9e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801aa2:	74 29                	je     801acd <sget+0x9b>
		{
			uint32 shared_object_id = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)mem_block->sva);
  801aa4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801aa7:	8b 40 08             	mov    0x8(%eax),%eax
  801aaa:	83 ec 04             	sub    $0x4,%esp
  801aad:	50                   	push   %eax
  801aae:	ff 75 0c             	pushl  0xc(%ebp)
  801ab1:	ff 75 08             	pushl  0x8(%ebp)
  801ab4:	e8 ba 03 00 00       	call   801e73 <sys_getSharedObject>
  801ab9:	83 c4 10             	add    $0x10,%esp
  801abc:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (shared_object_id != E_SHARED_MEM_NOT_EXISTS)
  801abf:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%ebp)
  801ac3:	74 08                	je     801acd <sget+0x9b>
				return (void *)mem_block->sva;
  801ac5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ac8:	8b 40 08             	mov    0x8(%eax),%eax
  801acb:	eb 05                	jmp    801ad2 <sget+0xa0>
		}
	}
	return NULL;
  801acd:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801ad2:	c9                   	leave  
  801ad3:	c3                   	ret    

00801ad4 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801ad4:	55                   	push   %ebp
  801ad5:	89 e5                	mov    %esp,%ebp
  801ad7:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801ada:	e8 12 fc ff ff       	call   8016f1 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801adf:	83 ec 04             	sub    $0x4,%esp
  801ae2:	68 e8 44 80 00       	push   $0x8044e8
  801ae7:	68 f1 00 00 00       	push   $0xf1
  801aec:	68 93 44 80 00       	push   $0x804493
  801af1:	e8 bd eb ff ff       	call   8006b3 <_panic>

00801af6 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801af6:	55                   	push   %ebp
  801af7:	89 e5                	mov    %esp,%ebp
  801af9:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801afc:	83 ec 04             	sub    $0x4,%esp
  801aff:	68 10 45 80 00       	push   $0x804510
  801b04:	68 05 01 00 00       	push   $0x105
  801b09:	68 93 44 80 00       	push   $0x804493
  801b0e:	e8 a0 eb ff ff       	call   8006b3 <_panic>

00801b13 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801b13:	55                   	push   %ebp
  801b14:	89 e5                	mov    %esp,%ebp
  801b16:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801b19:	83 ec 04             	sub    $0x4,%esp
  801b1c:	68 34 45 80 00       	push   $0x804534
  801b21:	68 10 01 00 00       	push   $0x110
  801b26:	68 93 44 80 00       	push   $0x804493
  801b2b:	e8 83 eb ff ff       	call   8006b3 <_panic>

00801b30 <shrink>:

}
void shrink(uint32 newSize)
{
  801b30:	55                   	push   %ebp
  801b31:	89 e5                	mov    %esp,%ebp
  801b33:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801b36:	83 ec 04             	sub    $0x4,%esp
  801b39:	68 34 45 80 00       	push   $0x804534
  801b3e:	68 15 01 00 00       	push   $0x115
  801b43:	68 93 44 80 00       	push   $0x804493
  801b48:	e8 66 eb ff ff       	call   8006b3 <_panic>

00801b4d <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801b4d:	55                   	push   %ebp
  801b4e:	89 e5                	mov    %esp,%ebp
  801b50:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801b53:	83 ec 04             	sub    $0x4,%esp
  801b56:	68 34 45 80 00       	push   $0x804534
  801b5b:	68 1a 01 00 00       	push   $0x11a
  801b60:	68 93 44 80 00       	push   $0x804493
  801b65:	e8 49 eb ff ff       	call   8006b3 <_panic>

00801b6a <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801b6a:	55                   	push   %ebp
  801b6b:	89 e5                	mov    %esp,%ebp
  801b6d:	57                   	push   %edi
  801b6e:	56                   	push   %esi
  801b6f:	53                   	push   %ebx
  801b70:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801b73:	8b 45 08             	mov    0x8(%ebp),%eax
  801b76:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b79:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b7c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b7f:	8b 7d 18             	mov    0x18(%ebp),%edi
  801b82:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801b85:	cd 30                	int    $0x30
  801b87:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801b8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801b8d:	83 c4 10             	add    $0x10,%esp
  801b90:	5b                   	pop    %ebx
  801b91:	5e                   	pop    %esi
  801b92:	5f                   	pop    %edi
  801b93:	5d                   	pop    %ebp
  801b94:	c3                   	ret    

00801b95 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801b95:	55                   	push   %ebp
  801b96:	89 e5                	mov    %esp,%ebp
  801b98:	83 ec 04             	sub    $0x4,%esp
  801b9b:	8b 45 10             	mov    0x10(%ebp),%eax
  801b9e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801ba1:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ba5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba8:	6a 00                	push   $0x0
  801baa:	6a 00                	push   $0x0
  801bac:	52                   	push   %edx
  801bad:	ff 75 0c             	pushl  0xc(%ebp)
  801bb0:	50                   	push   %eax
  801bb1:	6a 00                	push   $0x0
  801bb3:	e8 b2 ff ff ff       	call   801b6a <syscall>
  801bb8:	83 c4 18             	add    $0x18,%esp
}
  801bbb:	90                   	nop
  801bbc:	c9                   	leave  
  801bbd:	c3                   	ret    

00801bbe <sys_cgetc>:

int
sys_cgetc(void)
{
  801bbe:	55                   	push   %ebp
  801bbf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801bc1:	6a 00                	push   $0x0
  801bc3:	6a 00                	push   $0x0
  801bc5:	6a 00                	push   $0x0
  801bc7:	6a 00                	push   $0x0
  801bc9:	6a 00                	push   $0x0
  801bcb:	6a 01                	push   $0x1
  801bcd:	e8 98 ff ff ff       	call   801b6a <syscall>
  801bd2:	83 c4 18             	add    $0x18,%esp
}
  801bd5:	c9                   	leave  
  801bd6:	c3                   	ret    

00801bd7 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801bd7:	55                   	push   %ebp
  801bd8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801bda:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bdd:	8b 45 08             	mov    0x8(%ebp),%eax
  801be0:	6a 00                	push   $0x0
  801be2:	6a 00                	push   $0x0
  801be4:	6a 00                	push   $0x0
  801be6:	52                   	push   %edx
  801be7:	50                   	push   %eax
  801be8:	6a 05                	push   $0x5
  801bea:	e8 7b ff ff ff       	call   801b6a <syscall>
  801bef:	83 c4 18             	add    $0x18,%esp
}
  801bf2:	c9                   	leave  
  801bf3:	c3                   	ret    

00801bf4 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801bf4:	55                   	push   %ebp
  801bf5:	89 e5                	mov    %esp,%ebp
  801bf7:	56                   	push   %esi
  801bf8:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801bf9:	8b 75 18             	mov    0x18(%ebp),%esi
  801bfc:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801bff:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c02:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c05:	8b 45 08             	mov    0x8(%ebp),%eax
  801c08:	56                   	push   %esi
  801c09:	53                   	push   %ebx
  801c0a:	51                   	push   %ecx
  801c0b:	52                   	push   %edx
  801c0c:	50                   	push   %eax
  801c0d:	6a 06                	push   $0x6
  801c0f:	e8 56 ff ff ff       	call   801b6a <syscall>
  801c14:	83 c4 18             	add    $0x18,%esp
}
  801c17:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c1a:	5b                   	pop    %ebx
  801c1b:	5e                   	pop    %esi
  801c1c:	5d                   	pop    %ebp
  801c1d:	c3                   	ret    

00801c1e <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801c1e:	55                   	push   %ebp
  801c1f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801c21:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c24:	8b 45 08             	mov    0x8(%ebp),%eax
  801c27:	6a 00                	push   $0x0
  801c29:	6a 00                	push   $0x0
  801c2b:	6a 00                	push   $0x0
  801c2d:	52                   	push   %edx
  801c2e:	50                   	push   %eax
  801c2f:	6a 07                	push   $0x7
  801c31:	e8 34 ff ff ff       	call   801b6a <syscall>
  801c36:	83 c4 18             	add    $0x18,%esp
}
  801c39:	c9                   	leave  
  801c3a:	c3                   	ret    

00801c3b <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801c3b:	55                   	push   %ebp
  801c3c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801c3e:	6a 00                	push   $0x0
  801c40:	6a 00                	push   $0x0
  801c42:	6a 00                	push   $0x0
  801c44:	ff 75 0c             	pushl  0xc(%ebp)
  801c47:	ff 75 08             	pushl  0x8(%ebp)
  801c4a:	6a 08                	push   $0x8
  801c4c:	e8 19 ff ff ff       	call   801b6a <syscall>
  801c51:	83 c4 18             	add    $0x18,%esp
}
  801c54:	c9                   	leave  
  801c55:	c3                   	ret    

00801c56 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801c56:	55                   	push   %ebp
  801c57:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801c59:	6a 00                	push   $0x0
  801c5b:	6a 00                	push   $0x0
  801c5d:	6a 00                	push   $0x0
  801c5f:	6a 00                	push   $0x0
  801c61:	6a 00                	push   $0x0
  801c63:	6a 09                	push   $0x9
  801c65:	e8 00 ff ff ff       	call   801b6a <syscall>
  801c6a:	83 c4 18             	add    $0x18,%esp
}
  801c6d:	c9                   	leave  
  801c6e:	c3                   	ret    

00801c6f <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801c6f:	55                   	push   %ebp
  801c70:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801c72:	6a 00                	push   $0x0
  801c74:	6a 00                	push   $0x0
  801c76:	6a 00                	push   $0x0
  801c78:	6a 00                	push   $0x0
  801c7a:	6a 00                	push   $0x0
  801c7c:	6a 0a                	push   $0xa
  801c7e:	e8 e7 fe ff ff       	call   801b6a <syscall>
  801c83:	83 c4 18             	add    $0x18,%esp
}
  801c86:	c9                   	leave  
  801c87:	c3                   	ret    

00801c88 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801c88:	55                   	push   %ebp
  801c89:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801c8b:	6a 00                	push   $0x0
  801c8d:	6a 00                	push   $0x0
  801c8f:	6a 00                	push   $0x0
  801c91:	6a 00                	push   $0x0
  801c93:	6a 00                	push   $0x0
  801c95:	6a 0b                	push   $0xb
  801c97:	e8 ce fe ff ff       	call   801b6a <syscall>
  801c9c:	83 c4 18             	add    $0x18,%esp
}
  801c9f:	c9                   	leave  
  801ca0:	c3                   	ret    

00801ca1 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801ca1:	55                   	push   %ebp
  801ca2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801ca4:	6a 00                	push   $0x0
  801ca6:	6a 00                	push   $0x0
  801ca8:	6a 00                	push   $0x0
  801caa:	ff 75 0c             	pushl  0xc(%ebp)
  801cad:	ff 75 08             	pushl  0x8(%ebp)
  801cb0:	6a 0f                	push   $0xf
  801cb2:	e8 b3 fe ff ff       	call   801b6a <syscall>
  801cb7:	83 c4 18             	add    $0x18,%esp
	return;
  801cba:	90                   	nop
}
  801cbb:	c9                   	leave  
  801cbc:	c3                   	ret    

00801cbd <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801cbd:	55                   	push   %ebp
  801cbe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801cc0:	6a 00                	push   $0x0
  801cc2:	6a 00                	push   $0x0
  801cc4:	6a 00                	push   $0x0
  801cc6:	ff 75 0c             	pushl  0xc(%ebp)
  801cc9:	ff 75 08             	pushl  0x8(%ebp)
  801ccc:	6a 10                	push   $0x10
  801cce:	e8 97 fe ff ff       	call   801b6a <syscall>
  801cd3:	83 c4 18             	add    $0x18,%esp
	return ;
  801cd6:	90                   	nop
}
  801cd7:	c9                   	leave  
  801cd8:	c3                   	ret    

00801cd9 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801cd9:	55                   	push   %ebp
  801cda:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801cdc:	6a 00                	push   $0x0
  801cde:	6a 00                	push   $0x0
  801ce0:	ff 75 10             	pushl  0x10(%ebp)
  801ce3:	ff 75 0c             	pushl  0xc(%ebp)
  801ce6:	ff 75 08             	pushl  0x8(%ebp)
  801ce9:	6a 11                	push   $0x11
  801ceb:	e8 7a fe ff ff       	call   801b6a <syscall>
  801cf0:	83 c4 18             	add    $0x18,%esp
	return ;
  801cf3:	90                   	nop
}
  801cf4:	c9                   	leave  
  801cf5:	c3                   	ret    

00801cf6 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801cf6:	55                   	push   %ebp
  801cf7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801cf9:	6a 00                	push   $0x0
  801cfb:	6a 00                	push   $0x0
  801cfd:	6a 00                	push   $0x0
  801cff:	6a 00                	push   $0x0
  801d01:	6a 00                	push   $0x0
  801d03:	6a 0c                	push   $0xc
  801d05:	e8 60 fe ff ff       	call   801b6a <syscall>
  801d0a:	83 c4 18             	add    $0x18,%esp
}
  801d0d:	c9                   	leave  
  801d0e:	c3                   	ret    

00801d0f <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801d0f:	55                   	push   %ebp
  801d10:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801d12:	6a 00                	push   $0x0
  801d14:	6a 00                	push   $0x0
  801d16:	6a 00                	push   $0x0
  801d18:	6a 00                	push   $0x0
  801d1a:	ff 75 08             	pushl  0x8(%ebp)
  801d1d:	6a 0d                	push   $0xd
  801d1f:	e8 46 fe ff ff       	call   801b6a <syscall>
  801d24:	83 c4 18             	add    $0x18,%esp
}
  801d27:	c9                   	leave  
  801d28:	c3                   	ret    

00801d29 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801d29:	55                   	push   %ebp
  801d2a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801d2c:	6a 00                	push   $0x0
  801d2e:	6a 00                	push   $0x0
  801d30:	6a 00                	push   $0x0
  801d32:	6a 00                	push   $0x0
  801d34:	6a 00                	push   $0x0
  801d36:	6a 0e                	push   $0xe
  801d38:	e8 2d fe ff ff       	call   801b6a <syscall>
  801d3d:	83 c4 18             	add    $0x18,%esp
}
  801d40:	90                   	nop
  801d41:	c9                   	leave  
  801d42:	c3                   	ret    

00801d43 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801d43:	55                   	push   %ebp
  801d44:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801d46:	6a 00                	push   $0x0
  801d48:	6a 00                	push   $0x0
  801d4a:	6a 00                	push   $0x0
  801d4c:	6a 00                	push   $0x0
  801d4e:	6a 00                	push   $0x0
  801d50:	6a 13                	push   $0x13
  801d52:	e8 13 fe ff ff       	call   801b6a <syscall>
  801d57:	83 c4 18             	add    $0x18,%esp
}
  801d5a:	90                   	nop
  801d5b:	c9                   	leave  
  801d5c:	c3                   	ret    

00801d5d <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801d5d:	55                   	push   %ebp
  801d5e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801d60:	6a 00                	push   $0x0
  801d62:	6a 00                	push   $0x0
  801d64:	6a 00                	push   $0x0
  801d66:	6a 00                	push   $0x0
  801d68:	6a 00                	push   $0x0
  801d6a:	6a 14                	push   $0x14
  801d6c:	e8 f9 fd ff ff       	call   801b6a <syscall>
  801d71:	83 c4 18             	add    $0x18,%esp
}
  801d74:	90                   	nop
  801d75:	c9                   	leave  
  801d76:	c3                   	ret    

00801d77 <sys_cputc>:


void
sys_cputc(const char c)
{
  801d77:	55                   	push   %ebp
  801d78:	89 e5                	mov    %esp,%ebp
  801d7a:	83 ec 04             	sub    $0x4,%esp
  801d7d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d80:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801d83:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d87:	6a 00                	push   $0x0
  801d89:	6a 00                	push   $0x0
  801d8b:	6a 00                	push   $0x0
  801d8d:	6a 00                	push   $0x0
  801d8f:	50                   	push   %eax
  801d90:	6a 15                	push   $0x15
  801d92:	e8 d3 fd ff ff       	call   801b6a <syscall>
  801d97:	83 c4 18             	add    $0x18,%esp
}
  801d9a:	90                   	nop
  801d9b:	c9                   	leave  
  801d9c:	c3                   	ret    

00801d9d <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801d9d:	55                   	push   %ebp
  801d9e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801da0:	6a 00                	push   $0x0
  801da2:	6a 00                	push   $0x0
  801da4:	6a 00                	push   $0x0
  801da6:	6a 00                	push   $0x0
  801da8:	6a 00                	push   $0x0
  801daa:	6a 16                	push   $0x16
  801dac:	e8 b9 fd ff ff       	call   801b6a <syscall>
  801db1:	83 c4 18             	add    $0x18,%esp
}
  801db4:	90                   	nop
  801db5:	c9                   	leave  
  801db6:	c3                   	ret    

00801db7 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801db7:	55                   	push   %ebp
  801db8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801dba:	8b 45 08             	mov    0x8(%ebp),%eax
  801dbd:	6a 00                	push   $0x0
  801dbf:	6a 00                	push   $0x0
  801dc1:	6a 00                	push   $0x0
  801dc3:	ff 75 0c             	pushl  0xc(%ebp)
  801dc6:	50                   	push   %eax
  801dc7:	6a 17                	push   $0x17
  801dc9:	e8 9c fd ff ff       	call   801b6a <syscall>
  801dce:	83 c4 18             	add    $0x18,%esp
}
  801dd1:	c9                   	leave  
  801dd2:	c3                   	ret    

00801dd3 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801dd3:	55                   	push   %ebp
  801dd4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801dd6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dd9:	8b 45 08             	mov    0x8(%ebp),%eax
  801ddc:	6a 00                	push   $0x0
  801dde:	6a 00                	push   $0x0
  801de0:	6a 00                	push   $0x0
  801de2:	52                   	push   %edx
  801de3:	50                   	push   %eax
  801de4:	6a 1a                	push   $0x1a
  801de6:	e8 7f fd ff ff       	call   801b6a <syscall>
  801deb:	83 c4 18             	add    $0x18,%esp
}
  801dee:	c9                   	leave  
  801def:	c3                   	ret    

00801df0 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801df0:	55                   	push   %ebp
  801df1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801df3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801df6:	8b 45 08             	mov    0x8(%ebp),%eax
  801df9:	6a 00                	push   $0x0
  801dfb:	6a 00                	push   $0x0
  801dfd:	6a 00                	push   $0x0
  801dff:	52                   	push   %edx
  801e00:	50                   	push   %eax
  801e01:	6a 18                	push   $0x18
  801e03:	e8 62 fd ff ff       	call   801b6a <syscall>
  801e08:	83 c4 18             	add    $0x18,%esp
}
  801e0b:	90                   	nop
  801e0c:	c9                   	leave  
  801e0d:	c3                   	ret    

00801e0e <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801e0e:	55                   	push   %ebp
  801e0f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801e11:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e14:	8b 45 08             	mov    0x8(%ebp),%eax
  801e17:	6a 00                	push   $0x0
  801e19:	6a 00                	push   $0x0
  801e1b:	6a 00                	push   $0x0
  801e1d:	52                   	push   %edx
  801e1e:	50                   	push   %eax
  801e1f:	6a 19                	push   $0x19
  801e21:	e8 44 fd ff ff       	call   801b6a <syscall>
  801e26:	83 c4 18             	add    $0x18,%esp
}
  801e29:	90                   	nop
  801e2a:	c9                   	leave  
  801e2b:	c3                   	ret    

00801e2c <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801e2c:	55                   	push   %ebp
  801e2d:	89 e5                	mov    %esp,%ebp
  801e2f:	83 ec 04             	sub    $0x4,%esp
  801e32:	8b 45 10             	mov    0x10(%ebp),%eax
  801e35:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801e38:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801e3b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801e3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e42:	6a 00                	push   $0x0
  801e44:	51                   	push   %ecx
  801e45:	52                   	push   %edx
  801e46:	ff 75 0c             	pushl  0xc(%ebp)
  801e49:	50                   	push   %eax
  801e4a:	6a 1b                	push   $0x1b
  801e4c:	e8 19 fd ff ff       	call   801b6a <syscall>
  801e51:	83 c4 18             	add    $0x18,%esp
}
  801e54:	c9                   	leave  
  801e55:	c3                   	ret    

00801e56 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801e56:	55                   	push   %ebp
  801e57:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801e59:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5f:	6a 00                	push   $0x0
  801e61:	6a 00                	push   $0x0
  801e63:	6a 00                	push   $0x0
  801e65:	52                   	push   %edx
  801e66:	50                   	push   %eax
  801e67:	6a 1c                	push   $0x1c
  801e69:	e8 fc fc ff ff       	call   801b6a <syscall>
  801e6e:	83 c4 18             	add    $0x18,%esp
}
  801e71:	c9                   	leave  
  801e72:	c3                   	ret    

00801e73 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801e73:	55                   	push   %ebp
  801e74:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801e76:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e79:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e7f:	6a 00                	push   $0x0
  801e81:	6a 00                	push   $0x0
  801e83:	51                   	push   %ecx
  801e84:	52                   	push   %edx
  801e85:	50                   	push   %eax
  801e86:	6a 1d                	push   $0x1d
  801e88:	e8 dd fc ff ff       	call   801b6a <syscall>
  801e8d:	83 c4 18             	add    $0x18,%esp
}
  801e90:	c9                   	leave  
  801e91:	c3                   	ret    

00801e92 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801e92:	55                   	push   %ebp
  801e93:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801e95:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e98:	8b 45 08             	mov    0x8(%ebp),%eax
  801e9b:	6a 00                	push   $0x0
  801e9d:	6a 00                	push   $0x0
  801e9f:	6a 00                	push   $0x0
  801ea1:	52                   	push   %edx
  801ea2:	50                   	push   %eax
  801ea3:	6a 1e                	push   $0x1e
  801ea5:	e8 c0 fc ff ff       	call   801b6a <syscall>
  801eaa:	83 c4 18             	add    $0x18,%esp
}
  801ead:	c9                   	leave  
  801eae:	c3                   	ret    

00801eaf <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801eaf:	55                   	push   %ebp
  801eb0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801eb2:	6a 00                	push   $0x0
  801eb4:	6a 00                	push   $0x0
  801eb6:	6a 00                	push   $0x0
  801eb8:	6a 00                	push   $0x0
  801eba:	6a 00                	push   $0x0
  801ebc:	6a 1f                	push   $0x1f
  801ebe:	e8 a7 fc ff ff       	call   801b6a <syscall>
  801ec3:	83 c4 18             	add    $0x18,%esp
}
  801ec6:	c9                   	leave  
  801ec7:	c3                   	ret    

00801ec8 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801ec8:	55                   	push   %ebp
  801ec9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801ecb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ece:	6a 00                	push   $0x0
  801ed0:	ff 75 14             	pushl  0x14(%ebp)
  801ed3:	ff 75 10             	pushl  0x10(%ebp)
  801ed6:	ff 75 0c             	pushl  0xc(%ebp)
  801ed9:	50                   	push   %eax
  801eda:	6a 20                	push   $0x20
  801edc:	e8 89 fc ff ff       	call   801b6a <syscall>
  801ee1:	83 c4 18             	add    $0x18,%esp
}
  801ee4:	c9                   	leave  
  801ee5:	c3                   	ret    

00801ee6 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801ee6:	55                   	push   %ebp
  801ee7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801ee9:	8b 45 08             	mov    0x8(%ebp),%eax
  801eec:	6a 00                	push   $0x0
  801eee:	6a 00                	push   $0x0
  801ef0:	6a 00                	push   $0x0
  801ef2:	6a 00                	push   $0x0
  801ef4:	50                   	push   %eax
  801ef5:	6a 21                	push   $0x21
  801ef7:	e8 6e fc ff ff       	call   801b6a <syscall>
  801efc:	83 c4 18             	add    $0x18,%esp
}
  801eff:	90                   	nop
  801f00:	c9                   	leave  
  801f01:	c3                   	ret    

00801f02 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801f02:	55                   	push   %ebp
  801f03:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801f05:	8b 45 08             	mov    0x8(%ebp),%eax
  801f08:	6a 00                	push   $0x0
  801f0a:	6a 00                	push   $0x0
  801f0c:	6a 00                	push   $0x0
  801f0e:	6a 00                	push   $0x0
  801f10:	50                   	push   %eax
  801f11:	6a 22                	push   $0x22
  801f13:	e8 52 fc ff ff       	call   801b6a <syscall>
  801f18:	83 c4 18             	add    $0x18,%esp
}
  801f1b:	c9                   	leave  
  801f1c:	c3                   	ret    

00801f1d <sys_getenvid>:

int32 sys_getenvid(void)
{
  801f1d:	55                   	push   %ebp
  801f1e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801f20:	6a 00                	push   $0x0
  801f22:	6a 00                	push   $0x0
  801f24:	6a 00                	push   $0x0
  801f26:	6a 00                	push   $0x0
  801f28:	6a 00                	push   $0x0
  801f2a:	6a 02                	push   $0x2
  801f2c:	e8 39 fc ff ff       	call   801b6a <syscall>
  801f31:	83 c4 18             	add    $0x18,%esp
}
  801f34:	c9                   	leave  
  801f35:	c3                   	ret    

00801f36 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801f36:	55                   	push   %ebp
  801f37:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801f39:	6a 00                	push   $0x0
  801f3b:	6a 00                	push   $0x0
  801f3d:	6a 00                	push   $0x0
  801f3f:	6a 00                	push   $0x0
  801f41:	6a 00                	push   $0x0
  801f43:	6a 03                	push   $0x3
  801f45:	e8 20 fc ff ff       	call   801b6a <syscall>
  801f4a:	83 c4 18             	add    $0x18,%esp
}
  801f4d:	c9                   	leave  
  801f4e:	c3                   	ret    

00801f4f <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801f4f:	55                   	push   %ebp
  801f50:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801f52:	6a 00                	push   $0x0
  801f54:	6a 00                	push   $0x0
  801f56:	6a 00                	push   $0x0
  801f58:	6a 00                	push   $0x0
  801f5a:	6a 00                	push   $0x0
  801f5c:	6a 04                	push   $0x4
  801f5e:	e8 07 fc ff ff       	call   801b6a <syscall>
  801f63:	83 c4 18             	add    $0x18,%esp
}
  801f66:	c9                   	leave  
  801f67:	c3                   	ret    

00801f68 <sys_exit_env>:


void sys_exit_env(void)
{
  801f68:	55                   	push   %ebp
  801f69:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801f6b:	6a 00                	push   $0x0
  801f6d:	6a 00                	push   $0x0
  801f6f:	6a 00                	push   $0x0
  801f71:	6a 00                	push   $0x0
  801f73:	6a 00                	push   $0x0
  801f75:	6a 23                	push   $0x23
  801f77:	e8 ee fb ff ff       	call   801b6a <syscall>
  801f7c:	83 c4 18             	add    $0x18,%esp
}
  801f7f:	90                   	nop
  801f80:	c9                   	leave  
  801f81:	c3                   	ret    

00801f82 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801f82:	55                   	push   %ebp
  801f83:	89 e5                	mov    %esp,%ebp
  801f85:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801f88:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801f8b:	8d 50 04             	lea    0x4(%eax),%edx
  801f8e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801f91:	6a 00                	push   $0x0
  801f93:	6a 00                	push   $0x0
  801f95:	6a 00                	push   $0x0
  801f97:	52                   	push   %edx
  801f98:	50                   	push   %eax
  801f99:	6a 24                	push   $0x24
  801f9b:	e8 ca fb ff ff       	call   801b6a <syscall>
  801fa0:	83 c4 18             	add    $0x18,%esp
	return result;
  801fa3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801fa6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801fa9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801fac:	89 01                	mov    %eax,(%ecx)
  801fae:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801fb1:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb4:	c9                   	leave  
  801fb5:	c2 04 00             	ret    $0x4

00801fb8 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801fb8:	55                   	push   %ebp
  801fb9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801fbb:	6a 00                	push   $0x0
  801fbd:	6a 00                	push   $0x0
  801fbf:	ff 75 10             	pushl  0x10(%ebp)
  801fc2:	ff 75 0c             	pushl  0xc(%ebp)
  801fc5:	ff 75 08             	pushl  0x8(%ebp)
  801fc8:	6a 12                	push   $0x12
  801fca:	e8 9b fb ff ff       	call   801b6a <syscall>
  801fcf:	83 c4 18             	add    $0x18,%esp
	return ;
  801fd2:	90                   	nop
}
  801fd3:	c9                   	leave  
  801fd4:	c3                   	ret    

00801fd5 <sys_rcr2>:
uint32 sys_rcr2()
{
  801fd5:	55                   	push   %ebp
  801fd6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801fd8:	6a 00                	push   $0x0
  801fda:	6a 00                	push   $0x0
  801fdc:	6a 00                	push   $0x0
  801fde:	6a 00                	push   $0x0
  801fe0:	6a 00                	push   $0x0
  801fe2:	6a 25                	push   $0x25
  801fe4:	e8 81 fb ff ff       	call   801b6a <syscall>
  801fe9:	83 c4 18             	add    $0x18,%esp
}
  801fec:	c9                   	leave  
  801fed:	c3                   	ret    

00801fee <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801fee:	55                   	push   %ebp
  801fef:	89 e5                	mov    %esp,%ebp
  801ff1:	83 ec 04             	sub    $0x4,%esp
  801ff4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801ffa:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801ffe:	6a 00                	push   $0x0
  802000:	6a 00                	push   $0x0
  802002:	6a 00                	push   $0x0
  802004:	6a 00                	push   $0x0
  802006:	50                   	push   %eax
  802007:	6a 26                	push   $0x26
  802009:	e8 5c fb ff ff       	call   801b6a <syscall>
  80200e:	83 c4 18             	add    $0x18,%esp
	return ;
  802011:	90                   	nop
}
  802012:	c9                   	leave  
  802013:	c3                   	ret    

00802014 <rsttst>:
void rsttst()
{
  802014:	55                   	push   %ebp
  802015:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802017:	6a 00                	push   $0x0
  802019:	6a 00                	push   $0x0
  80201b:	6a 00                	push   $0x0
  80201d:	6a 00                	push   $0x0
  80201f:	6a 00                	push   $0x0
  802021:	6a 28                	push   $0x28
  802023:	e8 42 fb ff ff       	call   801b6a <syscall>
  802028:	83 c4 18             	add    $0x18,%esp
	return ;
  80202b:	90                   	nop
}
  80202c:	c9                   	leave  
  80202d:	c3                   	ret    

0080202e <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80202e:	55                   	push   %ebp
  80202f:	89 e5                	mov    %esp,%ebp
  802031:	83 ec 04             	sub    $0x4,%esp
  802034:	8b 45 14             	mov    0x14(%ebp),%eax
  802037:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80203a:	8b 55 18             	mov    0x18(%ebp),%edx
  80203d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802041:	52                   	push   %edx
  802042:	50                   	push   %eax
  802043:	ff 75 10             	pushl  0x10(%ebp)
  802046:	ff 75 0c             	pushl  0xc(%ebp)
  802049:	ff 75 08             	pushl  0x8(%ebp)
  80204c:	6a 27                	push   $0x27
  80204e:	e8 17 fb ff ff       	call   801b6a <syscall>
  802053:	83 c4 18             	add    $0x18,%esp
	return ;
  802056:	90                   	nop
}
  802057:	c9                   	leave  
  802058:	c3                   	ret    

00802059 <chktst>:
void chktst(uint32 n)
{
  802059:	55                   	push   %ebp
  80205a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80205c:	6a 00                	push   $0x0
  80205e:	6a 00                	push   $0x0
  802060:	6a 00                	push   $0x0
  802062:	6a 00                	push   $0x0
  802064:	ff 75 08             	pushl  0x8(%ebp)
  802067:	6a 29                	push   $0x29
  802069:	e8 fc fa ff ff       	call   801b6a <syscall>
  80206e:	83 c4 18             	add    $0x18,%esp
	return ;
  802071:	90                   	nop
}
  802072:	c9                   	leave  
  802073:	c3                   	ret    

00802074 <inctst>:

void inctst()
{
  802074:	55                   	push   %ebp
  802075:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802077:	6a 00                	push   $0x0
  802079:	6a 00                	push   $0x0
  80207b:	6a 00                	push   $0x0
  80207d:	6a 00                	push   $0x0
  80207f:	6a 00                	push   $0x0
  802081:	6a 2a                	push   $0x2a
  802083:	e8 e2 fa ff ff       	call   801b6a <syscall>
  802088:	83 c4 18             	add    $0x18,%esp
	return ;
  80208b:	90                   	nop
}
  80208c:	c9                   	leave  
  80208d:	c3                   	ret    

0080208e <gettst>:
uint32 gettst()
{
  80208e:	55                   	push   %ebp
  80208f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802091:	6a 00                	push   $0x0
  802093:	6a 00                	push   $0x0
  802095:	6a 00                	push   $0x0
  802097:	6a 00                	push   $0x0
  802099:	6a 00                	push   $0x0
  80209b:	6a 2b                	push   $0x2b
  80209d:	e8 c8 fa ff ff       	call   801b6a <syscall>
  8020a2:	83 c4 18             	add    $0x18,%esp
}
  8020a5:	c9                   	leave  
  8020a6:	c3                   	ret    

008020a7 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8020a7:	55                   	push   %ebp
  8020a8:	89 e5                	mov    %esp,%ebp
  8020aa:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8020ad:	6a 00                	push   $0x0
  8020af:	6a 00                	push   $0x0
  8020b1:	6a 00                	push   $0x0
  8020b3:	6a 00                	push   $0x0
  8020b5:	6a 00                	push   $0x0
  8020b7:	6a 2c                	push   $0x2c
  8020b9:	e8 ac fa ff ff       	call   801b6a <syscall>
  8020be:	83 c4 18             	add    $0x18,%esp
  8020c1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8020c4:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8020c8:	75 07                	jne    8020d1 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8020ca:	b8 01 00 00 00       	mov    $0x1,%eax
  8020cf:	eb 05                	jmp    8020d6 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8020d1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020d6:	c9                   	leave  
  8020d7:	c3                   	ret    

008020d8 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8020d8:	55                   	push   %ebp
  8020d9:	89 e5                	mov    %esp,%ebp
  8020db:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8020de:	6a 00                	push   $0x0
  8020e0:	6a 00                	push   $0x0
  8020e2:	6a 00                	push   $0x0
  8020e4:	6a 00                	push   $0x0
  8020e6:	6a 00                	push   $0x0
  8020e8:	6a 2c                	push   $0x2c
  8020ea:	e8 7b fa ff ff       	call   801b6a <syscall>
  8020ef:	83 c4 18             	add    $0x18,%esp
  8020f2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8020f5:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8020f9:	75 07                	jne    802102 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8020fb:	b8 01 00 00 00       	mov    $0x1,%eax
  802100:	eb 05                	jmp    802107 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802102:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802107:	c9                   	leave  
  802108:	c3                   	ret    

00802109 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802109:	55                   	push   %ebp
  80210a:	89 e5                	mov    %esp,%ebp
  80210c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80210f:	6a 00                	push   $0x0
  802111:	6a 00                	push   $0x0
  802113:	6a 00                	push   $0x0
  802115:	6a 00                	push   $0x0
  802117:	6a 00                	push   $0x0
  802119:	6a 2c                	push   $0x2c
  80211b:	e8 4a fa ff ff       	call   801b6a <syscall>
  802120:	83 c4 18             	add    $0x18,%esp
  802123:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802126:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80212a:	75 07                	jne    802133 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80212c:	b8 01 00 00 00       	mov    $0x1,%eax
  802131:	eb 05                	jmp    802138 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802133:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802138:	c9                   	leave  
  802139:	c3                   	ret    

0080213a <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80213a:	55                   	push   %ebp
  80213b:	89 e5                	mov    %esp,%ebp
  80213d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802140:	6a 00                	push   $0x0
  802142:	6a 00                	push   $0x0
  802144:	6a 00                	push   $0x0
  802146:	6a 00                	push   $0x0
  802148:	6a 00                	push   $0x0
  80214a:	6a 2c                	push   $0x2c
  80214c:	e8 19 fa ff ff       	call   801b6a <syscall>
  802151:	83 c4 18             	add    $0x18,%esp
  802154:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802157:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80215b:	75 07                	jne    802164 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80215d:	b8 01 00 00 00       	mov    $0x1,%eax
  802162:	eb 05                	jmp    802169 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802164:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802169:	c9                   	leave  
  80216a:	c3                   	ret    

0080216b <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80216b:	55                   	push   %ebp
  80216c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80216e:	6a 00                	push   $0x0
  802170:	6a 00                	push   $0x0
  802172:	6a 00                	push   $0x0
  802174:	6a 00                	push   $0x0
  802176:	ff 75 08             	pushl  0x8(%ebp)
  802179:	6a 2d                	push   $0x2d
  80217b:	e8 ea f9 ff ff       	call   801b6a <syscall>
  802180:	83 c4 18             	add    $0x18,%esp
	return ;
  802183:	90                   	nop
}
  802184:	c9                   	leave  
  802185:	c3                   	ret    

00802186 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802186:	55                   	push   %ebp
  802187:	89 e5                	mov    %esp,%ebp
  802189:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80218a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80218d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802190:	8b 55 0c             	mov    0xc(%ebp),%edx
  802193:	8b 45 08             	mov    0x8(%ebp),%eax
  802196:	6a 00                	push   $0x0
  802198:	53                   	push   %ebx
  802199:	51                   	push   %ecx
  80219a:	52                   	push   %edx
  80219b:	50                   	push   %eax
  80219c:	6a 2e                	push   $0x2e
  80219e:	e8 c7 f9 ff ff       	call   801b6a <syscall>
  8021a3:	83 c4 18             	add    $0x18,%esp
}
  8021a6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021a9:	c9                   	leave  
  8021aa:	c3                   	ret    

008021ab <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8021ab:	55                   	push   %ebp
  8021ac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8021ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b4:	6a 00                	push   $0x0
  8021b6:	6a 00                	push   $0x0
  8021b8:	6a 00                	push   $0x0
  8021ba:	52                   	push   %edx
  8021bb:	50                   	push   %eax
  8021bc:	6a 2f                	push   $0x2f
  8021be:	e8 a7 f9 ff ff       	call   801b6a <syscall>
  8021c3:	83 c4 18             	add    $0x18,%esp
}
  8021c6:	c9                   	leave  
  8021c7:	c3                   	ret    

008021c8 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  8021c8:	55                   	push   %ebp
  8021c9:	89 e5                	mov    %esp,%ebp
  8021cb:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  8021ce:	83 ec 0c             	sub    $0xc,%esp
  8021d1:	68 44 45 80 00       	push   $0x804544
  8021d6:	e8 8c e7 ff ff       	call   800967 <cprintf>
  8021db:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  8021de:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8021e5:	83 ec 0c             	sub    $0xc,%esp
  8021e8:	68 70 45 80 00       	push   $0x804570
  8021ed:	e8 75 e7 ff ff       	call   800967 <cprintf>
  8021f2:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8021f5:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8021f9:	a1 38 51 80 00       	mov    0x805138,%eax
  8021fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802201:	eb 56                	jmp    802259 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802203:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802207:	74 1c                	je     802225 <print_mem_block_lists+0x5d>
  802209:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80220c:	8b 50 08             	mov    0x8(%eax),%edx
  80220f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802212:	8b 48 08             	mov    0x8(%eax),%ecx
  802215:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802218:	8b 40 0c             	mov    0xc(%eax),%eax
  80221b:	01 c8                	add    %ecx,%eax
  80221d:	39 c2                	cmp    %eax,%edx
  80221f:	73 04                	jae    802225 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802221:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802225:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802228:	8b 50 08             	mov    0x8(%eax),%edx
  80222b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80222e:	8b 40 0c             	mov    0xc(%eax),%eax
  802231:	01 c2                	add    %eax,%edx
  802233:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802236:	8b 40 08             	mov    0x8(%eax),%eax
  802239:	83 ec 04             	sub    $0x4,%esp
  80223c:	52                   	push   %edx
  80223d:	50                   	push   %eax
  80223e:	68 85 45 80 00       	push   $0x804585
  802243:	e8 1f e7 ff ff       	call   800967 <cprintf>
  802248:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80224b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80224e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802251:	a1 40 51 80 00       	mov    0x805140,%eax
  802256:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802259:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80225d:	74 07                	je     802266 <print_mem_block_lists+0x9e>
  80225f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802262:	8b 00                	mov    (%eax),%eax
  802264:	eb 05                	jmp    80226b <print_mem_block_lists+0xa3>
  802266:	b8 00 00 00 00       	mov    $0x0,%eax
  80226b:	a3 40 51 80 00       	mov    %eax,0x805140
  802270:	a1 40 51 80 00       	mov    0x805140,%eax
  802275:	85 c0                	test   %eax,%eax
  802277:	75 8a                	jne    802203 <print_mem_block_lists+0x3b>
  802279:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80227d:	75 84                	jne    802203 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  80227f:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802283:	75 10                	jne    802295 <print_mem_block_lists+0xcd>
  802285:	83 ec 0c             	sub    $0xc,%esp
  802288:	68 94 45 80 00       	push   $0x804594
  80228d:	e8 d5 e6 ff ff       	call   800967 <cprintf>
  802292:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802295:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  80229c:	83 ec 0c             	sub    $0xc,%esp
  80229f:	68 b8 45 80 00       	push   $0x8045b8
  8022a4:	e8 be e6 ff ff       	call   800967 <cprintf>
  8022a9:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8022ac:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8022b0:	a1 40 50 80 00       	mov    0x805040,%eax
  8022b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022b8:	eb 56                	jmp    802310 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8022ba:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8022be:	74 1c                	je     8022dc <print_mem_block_lists+0x114>
  8022c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c3:	8b 50 08             	mov    0x8(%eax),%edx
  8022c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022c9:	8b 48 08             	mov    0x8(%eax),%ecx
  8022cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022cf:	8b 40 0c             	mov    0xc(%eax),%eax
  8022d2:	01 c8                	add    %ecx,%eax
  8022d4:	39 c2                	cmp    %eax,%edx
  8022d6:	73 04                	jae    8022dc <print_mem_block_lists+0x114>
			sorted = 0 ;
  8022d8:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8022dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022df:	8b 50 08             	mov    0x8(%eax),%edx
  8022e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e5:	8b 40 0c             	mov    0xc(%eax),%eax
  8022e8:	01 c2                	add    %eax,%edx
  8022ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ed:	8b 40 08             	mov    0x8(%eax),%eax
  8022f0:	83 ec 04             	sub    $0x4,%esp
  8022f3:	52                   	push   %edx
  8022f4:	50                   	push   %eax
  8022f5:	68 85 45 80 00       	push   $0x804585
  8022fa:	e8 68 e6 ff ff       	call   800967 <cprintf>
  8022ff:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802302:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802305:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802308:	a1 48 50 80 00       	mov    0x805048,%eax
  80230d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802310:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802314:	74 07                	je     80231d <print_mem_block_lists+0x155>
  802316:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802319:	8b 00                	mov    (%eax),%eax
  80231b:	eb 05                	jmp    802322 <print_mem_block_lists+0x15a>
  80231d:	b8 00 00 00 00       	mov    $0x0,%eax
  802322:	a3 48 50 80 00       	mov    %eax,0x805048
  802327:	a1 48 50 80 00       	mov    0x805048,%eax
  80232c:	85 c0                	test   %eax,%eax
  80232e:	75 8a                	jne    8022ba <print_mem_block_lists+0xf2>
  802330:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802334:	75 84                	jne    8022ba <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802336:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80233a:	75 10                	jne    80234c <print_mem_block_lists+0x184>
  80233c:	83 ec 0c             	sub    $0xc,%esp
  80233f:	68 d0 45 80 00       	push   $0x8045d0
  802344:	e8 1e e6 ff ff       	call   800967 <cprintf>
  802349:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  80234c:	83 ec 0c             	sub    $0xc,%esp
  80234f:	68 44 45 80 00       	push   $0x804544
  802354:	e8 0e e6 ff ff       	call   800967 <cprintf>
  802359:	83 c4 10             	add    $0x10,%esp

}
  80235c:	90                   	nop
  80235d:	c9                   	leave  
  80235e:	c3                   	ret    

0080235f <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  80235f:	55                   	push   %ebp
  802360:	89 e5                	mov    %esp,%ebp
  802362:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  802365:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  80236c:	00 00 00 
  80236f:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802376:	00 00 00 
  802379:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802380:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  802383:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80238a:	e9 9e 00 00 00       	jmp    80242d <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  80238f:	a1 50 50 80 00       	mov    0x805050,%eax
  802394:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802397:	c1 e2 04             	shl    $0x4,%edx
  80239a:	01 d0                	add    %edx,%eax
  80239c:	85 c0                	test   %eax,%eax
  80239e:	75 14                	jne    8023b4 <initialize_MemBlocksList+0x55>
  8023a0:	83 ec 04             	sub    $0x4,%esp
  8023a3:	68 f8 45 80 00       	push   $0x8045f8
  8023a8:	6a 46                	push   $0x46
  8023aa:	68 1b 46 80 00       	push   $0x80461b
  8023af:	e8 ff e2 ff ff       	call   8006b3 <_panic>
  8023b4:	a1 50 50 80 00       	mov    0x805050,%eax
  8023b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023bc:	c1 e2 04             	shl    $0x4,%edx
  8023bf:	01 d0                	add    %edx,%eax
  8023c1:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8023c7:	89 10                	mov    %edx,(%eax)
  8023c9:	8b 00                	mov    (%eax),%eax
  8023cb:	85 c0                	test   %eax,%eax
  8023cd:	74 18                	je     8023e7 <initialize_MemBlocksList+0x88>
  8023cf:	a1 48 51 80 00       	mov    0x805148,%eax
  8023d4:	8b 15 50 50 80 00    	mov    0x805050,%edx
  8023da:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8023dd:	c1 e1 04             	shl    $0x4,%ecx
  8023e0:	01 ca                	add    %ecx,%edx
  8023e2:	89 50 04             	mov    %edx,0x4(%eax)
  8023e5:	eb 12                	jmp    8023f9 <initialize_MemBlocksList+0x9a>
  8023e7:	a1 50 50 80 00       	mov    0x805050,%eax
  8023ec:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023ef:	c1 e2 04             	shl    $0x4,%edx
  8023f2:	01 d0                	add    %edx,%eax
  8023f4:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8023f9:	a1 50 50 80 00       	mov    0x805050,%eax
  8023fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802401:	c1 e2 04             	shl    $0x4,%edx
  802404:	01 d0                	add    %edx,%eax
  802406:	a3 48 51 80 00       	mov    %eax,0x805148
  80240b:	a1 50 50 80 00       	mov    0x805050,%eax
  802410:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802413:	c1 e2 04             	shl    $0x4,%edx
  802416:	01 d0                	add    %edx,%eax
  802418:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80241f:	a1 54 51 80 00       	mov    0x805154,%eax
  802424:	40                   	inc    %eax
  802425:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  80242a:	ff 45 f4             	incl   -0xc(%ebp)
  80242d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802430:	3b 45 08             	cmp    0x8(%ebp),%eax
  802433:	0f 82 56 ff ff ff    	jb     80238f <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  802439:	90                   	nop
  80243a:	c9                   	leave  
  80243b:	c3                   	ret    

0080243c <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80243c:	55                   	push   %ebp
  80243d:	89 e5                	mov    %esp,%ebp
  80243f:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802442:	8b 45 08             	mov    0x8(%ebp),%eax
  802445:	8b 00                	mov    (%eax),%eax
  802447:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80244a:	eb 19                	jmp    802465 <find_block+0x29>
	{
		if(va==point->sva)
  80244c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80244f:	8b 40 08             	mov    0x8(%eax),%eax
  802452:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802455:	75 05                	jne    80245c <find_block+0x20>
		   return point;
  802457:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80245a:	eb 36                	jmp    802492 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  80245c:	8b 45 08             	mov    0x8(%ebp),%eax
  80245f:	8b 40 08             	mov    0x8(%eax),%eax
  802462:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802465:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802469:	74 07                	je     802472 <find_block+0x36>
  80246b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80246e:	8b 00                	mov    (%eax),%eax
  802470:	eb 05                	jmp    802477 <find_block+0x3b>
  802472:	b8 00 00 00 00       	mov    $0x0,%eax
  802477:	8b 55 08             	mov    0x8(%ebp),%edx
  80247a:	89 42 08             	mov    %eax,0x8(%edx)
  80247d:	8b 45 08             	mov    0x8(%ebp),%eax
  802480:	8b 40 08             	mov    0x8(%eax),%eax
  802483:	85 c0                	test   %eax,%eax
  802485:	75 c5                	jne    80244c <find_block+0x10>
  802487:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80248b:	75 bf                	jne    80244c <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  80248d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802492:	c9                   	leave  
  802493:	c3                   	ret    

00802494 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802494:	55                   	push   %ebp
  802495:	89 e5                	mov    %esp,%ebp
  802497:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  80249a:	a1 40 50 80 00       	mov    0x805040,%eax
  80249f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  8024a2:	a1 44 50 80 00       	mov    0x805044,%eax
  8024a7:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  8024aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024ad:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8024b0:	74 24                	je     8024d6 <insert_sorted_allocList+0x42>
  8024b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b5:	8b 50 08             	mov    0x8(%eax),%edx
  8024b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024bb:	8b 40 08             	mov    0x8(%eax),%eax
  8024be:	39 c2                	cmp    %eax,%edx
  8024c0:	76 14                	jbe    8024d6 <insert_sorted_allocList+0x42>
  8024c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c5:	8b 50 08             	mov    0x8(%eax),%edx
  8024c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024cb:	8b 40 08             	mov    0x8(%eax),%eax
  8024ce:	39 c2                	cmp    %eax,%edx
  8024d0:	0f 82 60 01 00 00    	jb     802636 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  8024d6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8024da:	75 65                	jne    802541 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  8024dc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8024e0:	75 14                	jne    8024f6 <insert_sorted_allocList+0x62>
  8024e2:	83 ec 04             	sub    $0x4,%esp
  8024e5:	68 f8 45 80 00       	push   $0x8045f8
  8024ea:	6a 6b                	push   $0x6b
  8024ec:	68 1b 46 80 00       	push   $0x80461b
  8024f1:	e8 bd e1 ff ff       	call   8006b3 <_panic>
  8024f6:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8024fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ff:	89 10                	mov    %edx,(%eax)
  802501:	8b 45 08             	mov    0x8(%ebp),%eax
  802504:	8b 00                	mov    (%eax),%eax
  802506:	85 c0                	test   %eax,%eax
  802508:	74 0d                	je     802517 <insert_sorted_allocList+0x83>
  80250a:	a1 40 50 80 00       	mov    0x805040,%eax
  80250f:	8b 55 08             	mov    0x8(%ebp),%edx
  802512:	89 50 04             	mov    %edx,0x4(%eax)
  802515:	eb 08                	jmp    80251f <insert_sorted_allocList+0x8b>
  802517:	8b 45 08             	mov    0x8(%ebp),%eax
  80251a:	a3 44 50 80 00       	mov    %eax,0x805044
  80251f:	8b 45 08             	mov    0x8(%ebp),%eax
  802522:	a3 40 50 80 00       	mov    %eax,0x805040
  802527:	8b 45 08             	mov    0x8(%ebp),%eax
  80252a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802531:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802536:	40                   	inc    %eax
  802537:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80253c:	e9 dc 01 00 00       	jmp    80271d <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802541:	8b 45 08             	mov    0x8(%ebp),%eax
  802544:	8b 50 08             	mov    0x8(%eax),%edx
  802547:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80254a:	8b 40 08             	mov    0x8(%eax),%eax
  80254d:	39 c2                	cmp    %eax,%edx
  80254f:	77 6c                	ja     8025bd <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802551:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802555:	74 06                	je     80255d <insert_sorted_allocList+0xc9>
  802557:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80255b:	75 14                	jne    802571 <insert_sorted_allocList+0xdd>
  80255d:	83 ec 04             	sub    $0x4,%esp
  802560:	68 34 46 80 00       	push   $0x804634
  802565:	6a 6f                	push   $0x6f
  802567:	68 1b 46 80 00       	push   $0x80461b
  80256c:	e8 42 e1 ff ff       	call   8006b3 <_panic>
  802571:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802574:	8b 50 04             	mov    0x4(%eax),%edx
  802577:	8b 45 08             	mov    0x8(%ebp),%eax
  80257a:	89 50 04             	mov    %edx,0x4(%eax)
  80257d:	8b 45 08             	mov    0x8(%ebp),%eax
  802580:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802583:	89 10                	mov    %edx,(%eax)
  802585:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802588:	8b 40 04             	mov    0x4(%eax),%eax
  80258b:	85 c0                	test   %eax,%eax
  80258d:	74 0d                	je     80259c <insert_sorted_allocList+0x108>
  80258f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802592:	8b 40 04             	mov    0x4(%eax),%eax
  802595:	8b 55 08             	mov    0x8(%ebp),%edx
  802598:	89 10                	mov    %edx,(%eax)
  80259a:	eb 08                	jmp    8025a4 <insert_sorted_allocList+0x110>
  80259c:	8b 45 08             	mov    0x8(%ebp),%eax
  80259f:	a3 40 50 80 00       	mov    %eax,0x805040
  8025a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025a7:	8b 55 08             	mov    0x8(%ebp),%edx
  8025aa:	89 50 04             	mov    %edx,0x4(%eax)
  8025ad:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8025b2:	40                   	inc    %eax
  8025b3:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8025b8:	e9 60 01 00 00       	jmp    80271d <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  8025bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c0:	8b 50 08             	mov    0x8(%eax),%edx
  8025c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025c6:	8b 40 08             	mov    0x8(%eax),%eax
  8025c9:	39 c2                	cmp    %eax,%edx
  8025cb:	0f 82 4c 01 00 00    	jb     80271d <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8025d1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8025d5:	75 14                	jne    8025eb <insert_sorted_allocList+0x157>
  8025d7:	83 ec 04             	sub    $0x4,%esp
  8025da:	68 6c 46 80 00       	push   $0x80466c
  8025df:	6a 73                	push   $0x73
  8025e1:	68 1b 46 80 00       	push   $0x80461b
  8025e6:	e8 c8 e0 ff ff       	call   8006b3 <_panic>
  8025eb:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8025f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8025f4:	89 50 04             	mov    %edx,0x4(%eax)
  8025f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8025fa:	8b 40 04             	mov    0x4(%eax),%eax
  8025fd:	85 c0                	test   %eax,%eax
  8025ff:	74 0c                	je     80260d <insert_sorted_allocList+0x179>
  802601:	a1 44 50 80 00       	mov    0x805044,%eax
  802606:	8b 55 08             	mov    0x8(%ebp),%edx
  802609:	89 10                	mov    %edx,(%eax)
  80260b:	eb 08                	jmp    802615 <insert_sorted_allocList+0x181>
  80260d:	8b 45 08             	mov    0x8(%ebp),%eax
  802610:	a3 40 50 80 00       	mov    %eax,0x805040
  802615:	8b 45 08             	mov    0x8(%ebp),%eax
  802618:	a3 44 50 80 00       	mov    %eax,0x805044
  80261d:	8b 45 08             	mov    0x8(%ebp),%eax
  802620:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802626:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80262b:	40                   	inc    %eax
  80262c:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802631:	e9 e7 00 00 00       	jmp    80271d <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802636:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802639:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  80263c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802643:	a1 40 50 80 00       	mov    0x805040,%eax
  802648:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80264b:	e9 9d 00 00 00       	jmp    8026ed <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802650:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802653:	8b 00                	mov    (%eax),%eax
  802655:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802658:	8b 45 08             	mov    0x8(%ebp),%eax
  80265b:	8b 50 08             	mov    0x8(%eax),%edx
  80265e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802661:	8b 40 08             	mov    0x8(%eax),%eax
  802664:	39 c2                	cmp    %eax,%edx
  802666:	76 7d                	jbe    8026e5 <insert_sorted_allocList+0x251>
  802668:	8b 45 08             	mov    0x8(%ebp),%eax
  80266b:	8b 50 08             	mov    0x8(%eax),%edx
  80266e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802671:	8b 40 08             	mov    0x8(%eax),%eax
  802674:	39 c2                	cmp    %eax,%edx
  802676:	73 6d                	jae    8026e5 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802678:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80267c:	74 06                	je     802684 <insert_sorted_allocList+0x1f0>
  80267e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802682:	75 14                	jne    802698 <insert_sorted_allocList+0x204>
  802684:	83 ec 04             	sub    $0x4,%esp
  802687:	68 90 46 80 00       	push   $0x804690
  80268c:	6a 7f                	push   $0x7f
  80268e:	68 1b 46 80 00       	push   $0x80461b
  802693:	e8 1b e0 ff ff       	call   8006b3 <_panic>
  802698:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269b:	8b 10                	mov    (%eax),%edx
  80269d:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a0:	89 10                	mov    %edx,(%eax)
  8026a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a5:	8b 00                	mov    (%eax),%eax
  8026a7:	85 c0                	test   %eax,%eax
  8026a9:	74 0b                	je     8026b6 <insert_sorted_allocList+0x222>
  8026ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ae:	8b 00                	mov    (%eax),%eax
  8026b0:	8b 55 08             	mov    0x8(%ebp),%edx
  8026b3:	89 50 04             	mov    %edx,0x4(%eax)
  8026b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b9:	8b 55 08             	mov    0x8(%ebp),%edx
  8026bc:	89 10                	mov    %edx,(%eax)
  8026be:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026c4:	89 50 04             	mov    %edx,0x4(%eax)
  8026c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ca:	8b 00                	mov    (%eax),%eax
  8026cc:	85 c0                	test   %eax,%eax
  8026ce:	75 08                	jne    8026d8 <insert_sorted_allocList+0x244>
  8026d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8026d3:	a3 44 50 80 00       	mov    %eax,0x805044
  8026d8:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8026dd:	40                   	inc    %eax
  8026de:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  8026e3:	eb 39                	jmp    80271e <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8026e5:	a1 48 50 80 00       	mov    0x805048,%eax
  8026ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026ed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026f1:	74 07                	je     8026fa <insert_sorted_allocList+0x266>
  8026f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f6:	8b 00                	mov    (%eax),%eax
  8026f8:	eb 05                	jmp    8026ff <insert_sorted_allocList+0x26b>
  8026fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8026ff:	a3 48 50 80 00       	mov    %eax,0x805048
  802704:	a1 48 50 80 00       	mov    0x805048,%eax
  802709:	85 c0                	test   %eax,%eax
  80270b:	0f 85 3f ff ff ff    	jne    802650 <insert_sorted_allocList+0x1bc>
  802711:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802715:	0f 85 35 ff ff ff    	jne    802650 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80271b:	eb 01                	jmp    80271e <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80271d:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80271e:	90                   	nop
  80271f:	c9                   	leave  
  802720:	c3                   	ret    

00802721 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802721:	55                   	push   %ebp
  802722:	89 e5                	mov    %esp,%ebp
  802724:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802727:	a1 38 51 80 00       	mov    0x805138,%eax
  80272c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80272f:	e9 85 01 00 00       	jmp    8028b9 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802734:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802737:	8b 40 0c             	mov    0xc(%eax),%eax
  80273a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80273d:	0f 82 6e 01 00 00    	jb     8028b1 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802743:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802746:	8b 40 0c             	mov    0xc(%eax),%eax
  802749:	3b 45 08             	cmp    0x8(%ebp),%eax
  80274c:	0f 85 8a 00 00 00    	jne    8027dc <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802752:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802756:	75 17                	jne    80276f <alloc_block_FF+0x4e>
  802758:	83 ec 04             	sub    $0x4,%esp
  80275b:	68 c4 46 80 00       	push   $0x8046c4
  802760:	68 93 00 00 00       	push   $0x93
  802765:	68 1b 46 80 00       	push   $0x80461b
  80276a:	e8 44 df ff ff       	call   8006b3 <_panic>
  80276f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802772:	8b 00                	mov    (%eax),%eax
  802774:	85 c0                	test   %eax,%eax
  802776:	74 10                	je     802788 <alloc_block_FF+0x67>
  802778:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277b:	8b 00                	mov    (%eax),%eax
  80277d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802780:	8b 52 04             	mov    0x4(%edx),%edx
  802783:	89 50 04             	mov    %edx,0x4(%eax)
  802786:	eb 0b                	jmp    802793 <alloc_block_FF+0x72>
  802788:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278b:	8b 40 04             	mov    0x4(%eax),%eax
  80278e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802793:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802796:	8b 40 04             	mov    0x4(%eax),%eax
  802799:	85 c0                	test   %eax,%eax
  80279b:	74 0f                	je     8027ac <alloc_block_FF+0x8b>
  80279d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a0:	8b 40 04             	mov    0x4(%eax),%eax
  8027a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027a6:	8b 12                	mov    (%edx),%edx
  8027a8:	89 10                	mov    %edx,(%eax)
  8027aa:	eb 0a                	jmp    8027b6 <alloc_block_FF+0x95>
  8027ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027af:	8b 00                	mov    (%eax),%eax
  8027b1:	a3 38 51 80 00       	mov    %eax,0x805138
  8027b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027c9:	a1 44 51 80 00       	mov    0x805144,%eax
  8027ce:	48                   	dec    %eax
  8027cf:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  8027d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d7:	e9 10 01 00 00       	jmp    8028ec <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  8027dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027df:	8b 40 0c             	mov    0xc(%eax),%eax
  8027e2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027e5:	0f 86 c6 00 00 00    	jbe    8028b1 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8027eb:	a1 48 51 80 00       	mov    0x805148,%eax
  8027f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  8027f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f6:	8b 50 08             	mov    0x8(%eax),%edx
  8027f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027fc:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  8027ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802802:	8b 55 08             	mov    0x8(%ebp),%edx
  802805:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802808:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80280c:	75 17                	jne    802825 <alloc_block_FF+0x104>
  80280e:	83 ec 04             	sub    $0x4,%esp
  802811:	68 c4 46 80 00       	push   $0x8046c4
  802816:	68 9b 00 00 00       	push   $0x9b
  80281b:	68 1b 46 80 00       	push   $0x80461b
  802820:	e8 8e de ff ff       	call   8006b3 <_panic>
  802825:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802828:	8b 00                	mov    (%eax),%eax
  80282a:	85 c0                	test   %eax,%eax
  80282c:	74 10                	je     80283e <alloc_block_FF+0x11d>
  80282e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802831:	8b 00                	mov    (%eax),%eax
  802833:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802836:	8b 52 04             	mov    0x4(%edx),%edx
  802839:	89 50 04             	mov    %edx,0x4(%eax)
  80283c:	eb 0b                	jmp    802849 <alloc_block_FF+0x128>
  80283e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802841:	8b 40 04             	mov    0x4(%eax),%eax
  802844:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802849:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80284c:	8b 40 04             	mov    0x4(%eax),%eax
  80284f:	85 c0                	test   %eax,%eax
  802851:	74 0f                	je     802862 <alloc_block_FF+0x141>
  802853:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802856:	8b 40 04             	mov    0x4(%eax),%eax
  802859:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80285c:	8b 12                	mov    (%edx),%edx
  80285e:	89 10                	mov    %edx,(%eax)
  802860:	eb 0a                	jmp    80286c <alloc_block_FF+0x14b>
  802862:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802865:	8b 00                	mov    (%eax),%eax
  802867:	a3 48 51 80 00       	mov    %eax,0x805148
  80286c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80286f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802875:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802878:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80287f:	a1 54 51 80 00       	mov    0x805154,%eax
  802884:	48                   	dec    %eax
  802885:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  80288a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288d:	8b 50 08             	mov    0x8(%eax),%edx
  802890:	8b 45 08             	mov    0x8(%ebp),%eax
  802893:	01 c2                	add    %eax,%edx
  802895:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802898:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  80289b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289e:	8b 40 0c             	mov    0xc(%eax),%eax
  8028a1:	2b 45 08             	sub    0x8(%ebp),%eax
  8028a4:	89 c2                	mov    %eax,%edx
  8028a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a9:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  8028ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028af:	eb 3b                	jmp    8028ec <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8028b1:	a1 40 51 80 00       	mov    0x805140,%eax
  8028b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028b9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028bd:	74 07                	je     8028c6 <alloc_block_FF+0x1a5>
  8028bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c2:	8b 00                	mov    (%eax),%eax
  8028c4:	eb 05                	jmp    8028cb <alloc_block_FF+0x1aa>
  8028c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8028cb:	a3 40 51 80 00       	mov    %eax,0x805140
  8028d0:	a1 40 51 80 00       	mov    0x805140,%eax
  8028d5:	85 c0                	test   %eax,%eax
  8028d7:	0f 85 57 fe ff ff    	jne    802734 <alloc_block_FF+0x13>
  8028dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028e1:	0f 85 4d fe ff ff    	jne    802734 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  8028e7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028ec:	c9                   	leave  
  8028ed:	c3                   	ret    

008028ee <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8028ee:	55                   	push   %ebp
  8028ef:	89 e5                	mov    %esp,%ebp
  8028f1:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  8028f4:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8028fb:	a1 38 51 80 00       	mov    0x805138,%eax
  802900:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802903:	e9 df 00 00 00       	jmp    8029e7 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802908:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290b:	8b 40 0c             	mov    0xc(%eax),%eax
  80290e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802911:	0f 82 c8 00 00 00    	jb     8029df <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802917:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291a:	8b 40 0c             	mov    0xc(%eax),%eax
  80291d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802920:	0f 85 8a 00 00 00    	jne    8029b0 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802926:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80292a:	75 17                	jne    802943 <alloc_block_BF+0x55>
  80292c:	83 ec 04             	sub    $0x4,%esp
  80292f:	68 c4 46 80 00       	push   $0x8046c4
  802934:	68 b7 00 00 00       	push   $0xb7
  802939:	68 1b 46 80 00       	push   $0x80461b
  80293e:	e8 70 dd ff ff       	call   8006b3 <_panic>
  802943:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802946:	8b 00                	mov    (%eax),%eax
  802948:	85 c0                	test   %eax,%eax
  80294a:	74 10                	je     80295c <alloc_block_BF+0x6e>
  80294c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294f:	8b 00                	mov    (%eax),%eax
  802951:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802954:	8b 52 04             	mov    0x4(%edx),%edx
  802957:	89 50 04             	mov    %edx,0x4(%eax)
  80295a:	eb 0b                	jmp    802967 <alloc_block_BF+0x79>
  80295c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295f:	8b 40 04             	mov    0x4(%eax),%eax
  802962:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802967:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296a:	8b 40 04             	mov    0x4(%eax),%eax
  80296d:	85 c0                	test   %eax,%eax
  80296f:	74 0f                	je     802980 <alloc_block_BF+0x92>
  802971:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802974:	8b 40 04             	mov    0x4(%eax),%eax
  802977:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80297a:	8b 12                	mov    (%edx),%edx
  80297c:	89 10                	mov    %edx,(%eax)
  80297e:	eb 0a                	jmp    80298a <alloc_block_BF+0x9c>
  802980:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802983:	8b 00                	mov    (%eax),%eax
  802985:	a3 38 51 80 00       	mov    %eax,0x805138
  80298a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802993:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802996:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80299d:	a1 44 51 80 00       	mov    0x805144,%eax
  8029a2:	48                   	dec    %eax
  8029a3:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  8029a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ab:	e9 4d 01 00 00       	jmp    802afd <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  8029b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b3:	8b 40 0c             	mov    0xc(%eax),%eax
  8029b6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029b9:	76 24                	jbe    8029df <alloc_block_BF+0xf1>
  8029bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029be:	8b 40 0c             	mov    0xc(%eax),%eax
  8029c1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8029c4:	73 19                	jae    8029df <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  8029c6:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  8029cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d0:	8b 40 0c             	mov    0xc(%eax),%eax
  8029d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  8029d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d9:	8b 40 08             	mov    0x8(%eax),%eax
  8029dc:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8029df:	a1 40 51 80 00       	mov    0x805140,%eax
  8029e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029e7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029eb:	74 07                	je     8029f4 <alloc_block_BF+0x106>
  8029ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f0:	8b 00                	mov    (%eax),%eax
  8029f2:	eb 05                	jmp    8029f9 <alloc_block_BF+0x10b>
  8029f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8029f9:	a3 40 51 80 00       	mov    %eax,0x805140
  8029fe:	a1 40 51 80 00       	mov    0x805140,%eax
  802a03:	85 c0                	test   %eax,%eax
  802a05:	0f 85 fd fe ff ff    	jne    802908 <alloc_block_BF+0x1a>
  802a0b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a0f:	0f 85 f3 fe ff ff    	jne    802908 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802a15:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802a19:	0f 84 d9 00 00 00    	je     802af8 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802a1f:	a1 48 51 80 00       	mov    0x805148,%eax
  802a24:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802a27:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a2a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a2d:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802a30:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a33:	8b 55 08             	mov    0x8(%ebp),%edx
  802a36:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802a39:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802a3d:	75 17                	jne    802a56 <alloc_block_BF+0x168>
  802a3f:	83 ec 04             	sub    $0x4,%esp
  802a42:	68 c4 46 80 00       	push   $0x8046c4
  802a47:	68 c7 00 00 00       	push   $0xc7
  802a4c:	68 1b 46 80 00       	push   $0x80461b
  802a51:	e8 5d dc ff ff       	call   8006b3 <_panic>
  802a56:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a59:	8b 00                	mov    (%eax),%eax
  802a5b:	85 c0                	test   %eax,%eax
  802a5d:	74 10                	je     802a6f <alloc_block_BF+0x181>
  802a5f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a62:	8b 00                	mov    (%eax),%eax
  802a64:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802a67:	8b 52 04             	mov    0x4(%edx),%edx
  802a6a:	89 50 04             	mov    %edx,0x4(%eax)
  802a6d:	eb 0b                	jmp    802a7a <alloc_block_BF+0x18c>
  802a6f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a72:	8b 40 04             	mov    0x4(%eax),%eax
  802a75:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802a7a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a7d:	8b 40 04             	mov    0x4(%eax),%eax
  802a80:	85 c0                	test   %eax,%eax
  802a82:	74 0f                	je     802a93 <alloc_block_BF+0x1a5>
  802a84:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a87:	8b 40 04             	mov    0x4(%eax),%eax
  802a8a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802a8d:	8b 12                	mov    (%edx),%edx
  802a8f:	89 10                	mov    %edx,(%eax)
  802a91:	eb 0a                	jmp    802a9d <alloc_block_BF+0x1af>
  802a93:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a96:	8b 00                	mov    (%eax),%eax
  802a98:	a3 48 51 80 00       	mov    %eax,0x805148
  802a9d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802aa0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802aa6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802aa9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ab0:	a1 54 51 80 00       	mov    0x805154,%eax
  802ab5:	48                   	dec    %eax
  802ab6:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802abb:	83 ec 08             	sub    $0x8,%esp
  802abe:	ff 75 ec             	pushl  -0x14(%ebp)
  802ac1:	68 38 51 80 00       	push   $0x805138
  802ac6:	e8 71 f9 ff ff       	call   80243c <find_block>
  802acb:	83 c4 10             	add    $0x10,%esp
  802ace:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802ad1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ad4:	8b 50 08             	mov    0x8(%eax),%edx
  802ad7:	8b 45 08             	mov    0x8(%ebp),%eax
  802ada:	01 c2                	add    %eax,%edx
  802adc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802adf:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802ae2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ae5:	8b 40 0c             	mov    0xc(%eax),%eax
  802ae8:	2b 45 08             	sub    0x8(%ebp),%eax
  802aeb:	89 c2                	mov    %eax,%edx
  802aed:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802af0:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802af3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802af6:	eb 05                	jmp    802afd <alloc_block_BF+0x20f>
	}
	return NULL;
  802af8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802afd:	c9                   	leave  
  802afe:	c3                   	ret    

00802aff <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802aff:	55                   	push   %ebp
  802b00:	89 e5                	mov    %esp,%ebp
  802b02:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802b05:	a1 28 50 80 00       	mov    0x805028,%eax
  802b0a:	85 c0                	test   %eax,%eax
  802b0c:	0f 85 de 01 00 00    	jne    802cf0 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802b12:	a1 38 51 80 00       	mov    0x805138,%eax
  802b17:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b1a:	e9 9e 01 00 00       	jmp    802cbd <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802b1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b22:	8b 40 0c             	mov    0xc(%eax),%eax
  802b25:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b28:	0f 82 87 01 00 00    	jb     802cb5 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802b2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b31:	8b 40 0c             	mov    0xc(%eax),%eax
  802b34:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b37:	0f 85 95 00 00 00    	jne    802bd2 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802b3d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b41:	75 17                	jne    802b5a <alloc_block_NF+0x5b>
  802b43:	83 ec 04             	sub    $0x4,%esp
  802b46:	68 c4 46 80 00       	push   $0x8046c4
  802b4b:	68 e0 00 00 00       	push   $0xe0
  802b50:	68 1b 46 80 00       	push   $0x80461b
  802b55:	e8 59 db ff ff       	call   8006b3 <_panic>
  802b5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5d:	8b 00                	mov    (%eax),%eax
  802b5f:	85 c0                	test   %eax,%eax
  802b61:	74 10                	je     802b73 <alloc_block_NF+0x74>
  802b63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b66:	8b 00                	mov    (%eax),%eax
  802b68:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b6b:	8b 52 04             	mov    0x4(%edx),%edx
  802b6e:	89 50 04             	mov    %edx,0x4(%eax)
  802b71:	eb 0b                	jmp    802b7e <alloc_block_NF+0x7f>
  802b73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b76:	8b 40 04             	mov    0x4(%eax),%eax
  802b79:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802b7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b81:	8b 40 04             	mov    0x4(%eax),%eax
  802b84:	85 c0                	test   %eax,%eax
  802b86:	74 0f                	je     802b97 <alloc_block_NF+0x98>
  802b88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8b:	8b 40 04             	mov    0x4(%eax),%eax
  802b8e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b91:	8b 12                	mov    (%edx),%edx
  802b93:	89 10                	mov    %edx,(%eax)
  802b95:	eb 0a                	jmp    802ba1 <alloc_block_NF+0xa2>
  802b97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9a:	8b 00                	mov    (%eax),%eax
  802b9c:	a3 38 51 80 00       	mov    %eax,0x805138
  802ba1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802baa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bad:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bb4:	a1 44 51 80 00       	mov    0x805144,%eax
  802bb9:	48                   	dec    %eax
  802bba:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802bbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc2:	8b 40 08             	mov    0x8(%eax),%eax
  802bc5:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  802bca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bcd:	e9 f8 04 00 00       	jmp    8030ca <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802bd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd5:	8b 40 0c             	mov    0xc(%eax),%eax
  802bd8:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bdb:	0f 86 d4 00 00 00    	jbe    802cb5 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802be1:	a1 48 51 80 00       	mov    0x805148,%eax
  802be6:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802be9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bec:	8b 50 08             	mov    0x8(%eax),%edx
  802bef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bf2:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802bf5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bf8:	8b 55 08             	mov    0x8(%ebp),%edx
  802bfb:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802bfe:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c02:	75 17                	jne    802c1b <alloc_block_NF+0x11c>
  802c04:	83 ec 04             	sub    $0x4,%esp
  802c07:	68 c4 46 80 00       	push   $0x8046c4
  802c0c:	68 e9 00 00 00       	push   $0xe9
  802c11:	68 1b 46 80 00       	push   $0x80461b
  802c16:	e8 98 da ff ff       	call   8006b3 <_panic>
  802c1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c1e:	8b 00                	mov    (%eax),%eax
  802c20:	85 c0                	test   %eax,%eax
  802c22:	74 10                	je     802c34 <alloc_block_NF+0x135>
  802c24:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c27:	8b 00                	mov    (%eax),%eax
  802c29:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c2c:	8b 52 04             	mov    0x4(%edx),%edx
  802c2f:	89 50 04             	mov    %edx,0x4(%eax)
  802c32:	eb 0b                	jmp    802c3f <alloc_block_NF+0x140>
  802c34:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c37:	8b 40 04             	mov    0x4(%eax),%eax
  802c3a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802c3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c42:	8b 40 04             	mov    0x4(%eax),%eax
  802c45:	85 c0                	test   %eax,%eax
  802c47:	74 0f                	je     802c58 <alloc_block_NF+0x159>
  802c49:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c4c:	8b 40 04             	mov    0x4(%eax),%eax
  802c4f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c52:	8b 12                	mov    (%edx),%edx
  802c54:	89 10                	mov    %edx,(%eax)
  802c56:	eb 0a                	jmp    802c62 <alloc_block_NF+0x163>
  802c58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c5b:	8b 00                	mov    (%eax),%eax
  802c5d:	a3 48 51 80 00       	mov    %eax,0x805148
  802c62:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c65:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c6e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c75:	a1 54 51 80 00       	mov    0x805154,%eax
  802c7a:	48                   	dec    %eax
  802c7b:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802c80:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c83:	8b 40 08             	mov    0x8(%eax),%eax
  802c86:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802c8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c8e:	8b 50 08             	mov    0x8(%eax),%edx
  802c91:	8b 45 08             	mov    0x8(%ebp),%eax
  802c94:	01 c2                	add    %eax,%edx
  802c96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c99:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802c9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9f:	8b 40 0c             	mov    0xc(%eax),%eax
  802ca2:	2b 45 08             	sub    0x8(%ebp),%eax
  802ca5:	89 c2                	mov    %eax,%edx
  802ca7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802caa:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802cad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cb0:	e9 15 04 00 00       	jmp    8030ca <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802cb5:	a1 40 51 80 00       	mov    0x805140,%eax
  802cba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cbd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cc1:	74 07                	je     802cca <alloc_block_NF+0x1cb>
  802cc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc6:	8b 00                	mov    (%eax),%eax
  802cc8:	eb 05                	jmp    802ccf <alloc_block_NF+0x1d0>
  802cca:	b8 00 00 00 00       	mov    $0x0,%eax
  802ccf:	a3 40 51 80 00       	mov    %eax,0x805140
  802cd4:	a1 40 51 80 00       	mov    0x805140,%eax
  802cd9:	85 c0                	test   %eax,%eax
  802cdb:	0f 85 3e fe ff ff    	jne    802b1f <alloc_block_NF+0x20>
  802ce1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ce5:	0f 85 34 fe ff ff    	jne    802b1f <alloc_block_NF+0x20>
  802ceb:	e9 d5 03 00 00       	jmp    8030c5 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802cf0:	a1 38 51 80 00       	mov    0x805138,%eax
  802cf5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cf8:	e9 b1 01 00 00       	jmp    802eae <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802cfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d00:	8b 50 08             	mov    0x8(%eax),%edx
  802d03:	a1 28 50 80 00       	mov    0x805028,%eax
  802d08:	39 c2                	cmp    %eax,%edx
  802d0a:	0f 82 96 01 00 00    	jb     802ea6 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802d10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d13:	8b 40 0c             	mov    0xc(%eax),%eax
  802d16:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d19:	0f 82 87 01 00 00    	jb     802ea6 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802d1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d22:	8b 40 0c             	mov    0xc(%eax),%eax
  802d25:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d28:	0f 85 95 00 00 00    	jne    802dc3 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802d2e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d32:	75 17                	jne    802d4b <alloc_block_NF+0x24c>
  802d34:	83 ec 04             	sub    $0x4,%esp
  802d37:	68 c4 46 80 00       	push   $0x8046c4
  802d3c:	68 fc 00 00 00       	push   $0xfc
  802d41:	68 1b 46 80 00       	push   $0x80461b
  802d46:	e8 68 d9 ff ff       	call   8006b3 <_panic>
  802d4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d4e:	8b 00                	mov    (%eax),%eax
  802d50:	85 c0                	test   %eax,%eax
  802d52:	74 10                	je     802d64 <alloc_block_NF+0x265>
  802d54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d57:	8b 00                	mov    (%eax),%eax
  802d59:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d5c:	8b 52 04             	mov    0x4(%edx),%edx
  802d5f:	89 50 04             	mov    %edx,0x4(%eax)
  802d62:	eb 0b                	jmp    802d6f <alloc_block_NF+0x270>
  802d64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d67:	8b 40 04             	mov    0x4(%eax),%eax
  802d6a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d72:	8b 40 04             	mov    0x4(%eax),%eax
  802d75:	85 c0                	test   %eax,%eax
  802d77:	74 0f                	je     802d88 <alloc_block_NF+0x289>
  802d79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d7c:	8b 40 04             	mov    0x4(%eax),%eax
  802d7f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d82:	8b 12                	mov    (%edx),%edx
  802d84:	89 10                	mov    %edx,(%eax)
  802d86:	eb 0a                	jmp    802d92 <alloc_block_NF+0x293>
  802d88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d8b:	8b 00                	mov    (%eax),%eax
  802d8d:	a3 38 51 80 00       	mov    %eax,0x805138
  802d92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d95:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d9e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802da5:	a1 44 51 80 00       	mov    0x805144,%eax
  802daa:	48                   	dec    %eax
  802dab:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802db0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db3:	8b 40 08             	mov    0x8(%eax),%eax
  802db6:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802dbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dbe:	e9 07 03 00 00       	jmp    8030ca <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802dc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc6:	8b 40 0c             	mov    0xc(%eax),%eax
  802dc9:	3b 45 08             	cmp    0x8(%ebp),%eax
  802dcc:	0f 86 d4 00 00 00    	jbe    802ea6 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802dd2:	a1 48 51 80 00       	mov    0x805148,%eax
  802dd7:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802dda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ddd:	8b 50 08             	mov    0x8(%eax),%edx
  802de0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802de3:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802de6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802de9:	8b 55 08             	mov    0x8(%ebp),%edx
  802dec:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802def:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802df3:	75 17                	jne    802e0c <alloc_block_NF+0x30d>
  802df5:	83 ec 04             	sub    $0x4,%esp
  802df8:	68 c4 46 80 00       	push   $0x8046c4
  802dfd:	68 04 01 00 00       	push   $0x104
  802e02:	68 1b 46 80 00       	push   $0x80461b
  802e07:	e8 a7 d8 ff ff       	call   8006b3 <_panic>
  802e0c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e0f:	8b 00                	mov    (%eax),%eax
  802e11:	85 c0                	test   %eax,%eax
  802e13:	74 10                	je     802e25 <alloc_block_NF+0x326>
  802e15:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e18:	8b 00                	mov    (%eax),%eax
  802e1a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e1d:	8b 52 04             	mov    0x4(%edx),%edx
  802e20:	89 50 04             	mov    %edx,0x4(%eax)
  802e23:	eb 0b                	jmp    802e30 <alloc_block_NF+0x331>
  802e25:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e28:	8b 40 04             	mov    0x4(%eax),%eax
  802e2b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e30:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e33:	8b 40 04             	mov    0x4(%eax),%eax
  802e36:	85 c0                	test   %eax,%eax
  802e38:	74 0f                	je     802e49 <alloc_block_NF+0x34a>
  802e3a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e3d:	8b 40 04             	mov    0x4(%eax),%eax
  802e40:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e43:	8b 12                	mov    (%edx),%edx
  802e45:	89 10                	mov    %edx,(%eax)
  802e47:	eb 0a                	jmp    802e53 <alloc_block_NF+0x354>
  802e49:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e4c:	8b 00                	mov    (%eax),%eax
  802e4e:	a3 48 51 80 00       	mov    %eax,0x805148
  802e53:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e56:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e5c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e5f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e66:	a1 54 51 80 00       	mov    0x805154,%eax
  802e6b:	48                   	dec    %eax
  802e6c:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802e71:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e74:	8b 40 08             	mov    0x8(%eax),%eax
  802e77:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802e7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e7f:	8b 50 08             	mov    0x8(%eax),%edx
  802e82:	8b 45 08             	mov    0x8(%ebp),%eax
  802e85:	01 c2                	add    %eax,%edx
  802e87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e8a:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802e8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e90:	8b 40 0c             	mov    0xc(%eax),%eax
  802e93:	2b 45 08             	sub    0x8(%ebp),%eax
  802e96:	89 c2                	mov    %eax,%edx
  802e98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e9b:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802e9e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ea1:	e9 24 02 00 00       	jmp    8030ca <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802ea6:	a1 40 51 80 00       	mov    0x805140,%eax
  802eab:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802eae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802eb2:	74 07                	je     802ebb <alloc_block_NF+0x3bc>
  802eb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb7:	8b 00                	mov    (%eax),%eax
  802eb9:	eb 05                	jmp    802ec0 <alloc_block_NF+0x3c1>
  802ebb:	b8 00 00 00 00       	mov    $0x0,%eax
  802ec0:	a3 40 51 80 00       	mov    %eax,0x805140
  802ec5:	a1 40 51 80 00       	mov    0x805140,%eax
  802eca:	85 c0                	test   %eax,%eax
  802ecc:	0f 85 2b fe ff ff    	jne    802cfd <alloc_block_NF+0x1fe>
  802ed2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ed6:	0f 85 21 fe ff ff    	jne    802cfd <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802edc:	a1 38 51 80 00       	mov    0x805138,%eax
  802ee1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ee4:	e9 ae 01 00 00       	jmp    803097 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802ee9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eec:	8b 50 08             	mov    0x8(%eax),%edx
  802eef:	a1 28 50 80 00       	mov    0x805028,%eax
  802ef4:	39 c2                	cmp    %eax,%edx
  802ef6:	0f 83 93 01 00 00    	jae    80308f <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802efc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eff:	8b 40 0c             	mov    0xc(%eax),%eax
  802f02:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f05:	0f 82 84 01 00 00    	jb     80308f <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802f0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f0e:	8b 40 0c             	mov    0xc(%eax),%eax
  802f11:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f14:	0f 85 95 00 00 00    	jne    802faf <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802f1a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f1e:	75 17                	jne    802f37 <alloc_block_NF+0x438>
  802f20:	83 ec 04             	sub    $0x4,%esp
  802f23:	68 c4 46 80 00       	push   $0x8046c4
  802f28:	68 14 01 00 00       	push   $0x114
  802f2d:	68 1b 46 80 00       	push   $0x80461b
  802f32:	e8 7c d7 ff ff       	call   8006b3 <_panic>
  802f37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f3a:	8b 00                	mov    (%eax),%eax
  802f3c:	85 c0                	test   %eax,%eax
  802f3e:	74 10                	je     802f50 <alloc_block_NF+0x451>
  802f40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f43:	8b 00                	mov    (%eax),%eax
  802f45:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f48:	8b 52 04             	mov    0x4(%edx),%edx
  802f4b:	89 50 04             	mov    %edx,0x4(%eax)
  802f4e:	eb 0b                	jmp    802f5b <alloc_block_NF+0x45c>
  802f50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f53:	8b 40 04             	mov    0x4(%eax),%eax
  802f56:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f5e:	8b 40 04             	mov    0x4(%eax),%eax
  802f61:	85 c0                	test   %eax,%eax
  802f63:	74 0f                	je     802f74 <alloc_block_NF+0x475>
  802f65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f68:	8b 40 04             	mov    0x4(%eax),%eax
  802f6b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f6e:	8b 12                	mov    (%edx),%edx
  802f70:	89 10                	mov    %edx,(%eax)
  802f72:	eb 0a                	jmp    802f7e <alloc_block_NF+0x47f>
  802f74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f77:	8b 00                	mov    (%eax),%eax
  802f79:	a3 38 51 80 00       	mov    %eax,0x805138
  802f7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f81:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f8a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f91:	a1 44 51 80 00       	mov    0x805144,%eax
  802f96:	48                   	dec    %eax
  802f97:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802f9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f9f:	8b 40 08             	mov    0x8(%eax),%eax
  802fa2:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802fa7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802faa:	e9 1b 01 00 00       	jmp    8030ca <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802faf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb2:	8b 40 0c             	mov    0xc(%eax),%eax
  802fb5:	3b 45 08             	cmp    0x8(%ebp),%eax
  802fb8:	0f 86 d1 00 00 00    	jbe    80308f <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802fbe:	a1 48 51 80 00       	mov    0x805148,%eax
  802fc3:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802fc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc9:	8b 50 08             	mov    0x8(%eax),%edx
  802fcc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fcf:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802fd2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fd5:	8b 55 08             	mov    0x8(%ebp),%edx
  802fd8:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802fdb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802fdf:	75 17                	jne    802ff8 <alloc_block_NF+0x4f9>
  802fe1:	83 ec 04             	sub    $0x4,%esp
  802fe4:	68 c4 46 80 00       	push   $0x8046c4
  802fe9:	68 1c 01 00 00       	push   $0x11c
  802fee:	68 1b 46 80 00       	push   $0x80461b
  802ff3:	e8 bb d6 ff ff       	call   8006b3 <_panic>
  802ff8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ffb:	8b 00                	mov    (%eax),%eax
  802ffd:	85 c0                	test   %eax,%eax
  802fff:	74 10                	je     803011 <alloc_block_NF+0x512>
  803001:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803004:	8b 00                	mov    (%eax),%eax
  803006:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803009:	8b 52 04             	mov    0x4(%edx),%edx
  80300c:	89 50 04             	mov    %edx,0x4(%eax)
  80300f:	eb 0b                	jmp    80301c <alloc_block_NF+0x51d>
  803011:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803014:	8b 40 04             	mov    0x4(%eax),%eax
  803017:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80301c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80301f:	8b 40 04             	mov    0x4(%eax),%eax
  803022:	85 c0                	test   %eax,%eax
  803024:	74 0f                	je     803035 <alloc_block_NF+0x536>
  803026:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803029:	8b 40 04             	mov    0x4(%eax),%eax
  80302c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80302f:	8b 12                	mov    (%edx),%edx
  803031:	89 10                	mov    %edx,(%eax)
  803033:	eb 0a                	jmp    80303f <alloc_block_NF+0x540>
  803035:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803038:	8b 00                	mov    (%eax),%eax
  80303a:	a3 48 51 80 00       	mov    %eax,0x805148
  80303f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803042:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803048:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80304b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803052:	a1 54 51 80 00       	mov    0x805154,%eax
  803057:	48                   	dec    %eax
  803058:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  80305d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803060:	8b 40 08             	mov    0x8(%eax),%eax
  803063:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  803068:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80306b:	8b 50 08             	mov    0x8(%eax),%edx
  80306e:	8b 45 08             	mov    0x8(%ebp),%eax
  803071:	01 c2                	add    %eax,%edx
  803073:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803076:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  803079:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80307c:	8b 40 0c             	mov    0xc(%eax),%eax
  80307f:	2b 45 08             	sub    0x8(%ebp),%eax
  803082:	89 c2                	mov    %eax,%edx
  803084:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803087:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  80308a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80308d:	eb 3b                	jmp    8030ca <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  80308f:	a1 40 51 80 00       	mov    0x805140,%eax
  803094:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803097:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80309b:	74 07                	je     8030a4 <alloc_block_NF+0x5a5>
  80309d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a0:	8b 00                	mov    (%eax),%eax
  8030a2:	eb 05                	jmp    8030a9 <alloc_block_NF+0x5aa>
  8030a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8030a9:	a3 40 51 80 00       	mov    %eax,0x805140
  8030ae:	a1 40 51 80 00       	mov    0x805140,%eax
  8030b3:	85 c0                	test   %eax,%eax
  8030b5:	0f 85 2e fe ff ff    	jne    802ee9 <alloc_block_NF+0x3ea>
  8030bb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030bf:	0f 85 24 fe ff ff    	jne    802ee9 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  8030c5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8030ca:	c9                   	leave  
  8030cb:	c3                   	ret    

008030cc <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  8030cc:	55                   	push   %ebp
  8030cd:	89 e5                	mov    %esp,%ebp
  8030cf:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  8030d2:	a1 38 51 80 00       	mov    0x805138,%eax
  8030d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  8030da:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8030df:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  8030e2:	a1 38 51 80 00       	mov    0x805138,%eax
  8030e7:	85 c0                	test   %eax,%eax
  8030e9:	74 14                	je     8030ff <insert_sorted_with_merge_freeList+0x33>
  8030eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ee:	8b 50 08             	mov    0x8(%eax),%edx
  8030f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030f4:	8b 40 08             	mov    0x8(%eax),%eax
  8030f7:	39 c2                	cmp    %eax,%edx
  8030f9:	0f 87 9b 01 00 00    	ja     80329a <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  8030ff:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803103:	75 17                	jne    80311c <insert_sorted_with_merge_freeList+0x50>
  803105:	83 ec 04             	sub    $0x4,%esp
  803108:	68 f8 45 80 00       	push   $0x8045f8
  80310d:	68 38 01 00 00       	push   $0x138
  803112:	68 1b 46 80 00       	push   $0x80461b
  803117:	e8 97 d5 ff ff       	call   8006b3 <_panic>
  80311c:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803122:	8b 45 08             	mov    0x8(%ebp),%eax
  803125:	89 10                	mov    %edx,(%eax)
  803127:	8b 45 08             	mov    0x8(%ebp),%eax
  80312a:	8b 00                	mov    (%eax),%eax
  80312c:	85 c0                	test   %eax,%eax
  80312e:	74 0d                	je     80313d <insert_sorted_with_merge_freeList+0x71>
  803130:	a1 38 51 80 00       	mov    0x805138,%eax
  803135:	8b 55 08             	mov    0x8(%ebp),%edx
  803138:	89 50 04             	mov    %edx,0x4(%eax)
  80313b:	eb 08                	jmp    803145 <insert_sorted_with_merge_freeList+0x79>
  80313d:	8b 45 08             	mov    0x8(%ebp),%eax
  803140:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803145:	8b 45 08             	mov    0x8(%ebp),%eax
  803148:	a3 38 51 80 00       	mov    %eax,0x805138
  80314d:	8b 45 08             	mov    0x8(%ebp),%eax
  803150:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803157:	a1 44 51 80 00       	mov    0x805144,%eax
  80315c:	40                   	inc    %eax
  80315d:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803162:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803166:	0f 84 a8 06 00 00    	je     803814 <insert_sorted_with_merge_freeList+0x748>
  80316c:	8b 45 08             	mov    0x8(%ebp),%eax
  80316f:	8b 50 08             	mov    0x8(%eax),%edx
  803172:	8b 45 08             	mov    0x8(%ebp),%eax
  803175:	8b 40 0c             	mov    0xc(%eax),%eax
  803178:	01 c2                	add    %eax,%edx
  80317a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80317d:	8b 40 08             	mov    0x8(%eax),%eax
  803180:	39 c2                	cmp    %eax,%edx
  803182:	0f 85 8c 06 00 00    	jne    803814 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  803188:	8b 45 08             	mov    0x8(%ebp),%eax
  80318b:	8b 50 0c             	mov    0xc(%eax),%edx
  80318e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803191:	8b 40 0c             	mov    0xc(%eax),%eax
  803194:	01 c2                	add    %eax,%edx
  803196:	8b 45 08             	mov    0x8(%ebp),%eax
  803199:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  80319c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8031a0:	75 17                	jne    8031b9 <insert_sorted_with_merge_freeList+0xed>
  8031a2:	83 ec 04             	sub    $0x4,%esp
  8031a5:	68 c4 46 80 00       	push   $0x8046c4
  8031aa:	68 3c 01 00 00       	push   $0x13c
  8031af:	68 1b 46 80 00       	push   $0x80461b
  8031b4:	e8 fa d4 ff ff       	call   8006b3 <_panic>
  8031b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031bc:	8b 00                	mov    (%eax),%eax
  8031be:	85 c0                	test   %eax,%eax
  8031c0:	74 10                	je     8031d2 <insert_sorted_with_merge_freeList+0x106>
  8031c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031c5:	8b 00                	mov    (%eax),%eax
  8031c7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031ca:	8b 52 04             	mov    0x4(%edx),%edx
  8031cd:	89 50 04             	mov    %edx,0x4(%eax)
  8031d0:	eb 0b                	jmp    8031dd <insert_sorted_with_merge_freeList+0x111>
  8031d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031d5:	8b 40 04             	mov    0x4(%eax),%eax
  8031d8:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8031dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031e0:	8b 40 04             	mov    0x4(%eax),%eax
  8031e3:	85 c0                	test   %eax,%eax
  8031e5:	74 0f                	je     8031f6 <insert_sorted_with_merge_freeList+0x12a>
  8031e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031ea:	8b 40 04             	mov    0x4(%eax),%eax
  8031ed:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031f0:	8b 12                	mov    (%edx),%edx
  8031f2:	89 10                	mov    %edx,(%eax)
  8031f4:	eb 0a                	jmp    803200 <insert_sorted_with_merge_freeList+0x134>
  8031f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031f9:	8b 00                	mov    (%eax),%eax
  8031fb:	a3 38 51 80 00       	mov    %eax,0x805138
  803200:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803203:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803209:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80320c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803213:	a1 44 51 80 00       	mov    0x805144,%eax
  803218:	48                   	dec    %eax
  803219:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  80321e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803221:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  803228:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80322b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  803232:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803236:	75 17                	jne    80324f <insert_sorted_with_merge_freeList+0x183>
  803238:	83 ec 04             	sub    $0x4,%esp
  80323b:	68 f8 45 80 00       	push   $0x8045f8
  803240:	68 3f 01 00 00       	push   $0x13f
  803245:	68 1b 46 80 00       	push   $0x80461b
  80324a:	e8 64 d4 ff ff       	call   8006b3 <_panic>
  80324f:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803255:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803258:	89 10                	mov    %edx,(%eax)
  80325a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80325d:	8b 00                	mov    (%eax),%eax
  80325f:	85 c0                	test   %eax,%eax
  803261:	74 0d                	je     803270 <insert_sorted_with_merge_freeList+0x1a4>
  803263:	a1 48 51 80 00       	mov    0x805148,%eax
  803268:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80326b:	89 50 04             	mov    %edx,0x4(%eax)
  80326e:	eb 08                	jmp    803278 <insert_sorted_with_merge_freeList+0x1ac>
  803270:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803273:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803278:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80327b:	a3 48 51 80 00       	mov    %eax,0x805148
  803280:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803283:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80328a:	a1 54 51 80 00       	mov    0x805154,%eax
  80328f:	40                   	inc    %eax
  803290:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803295:	e9 7a 05 00 00       	jmp    803814 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  80329a:	8b 45 08             	mov    0x8(%ebp),%eax
  80329d:	8b 50 08             	mov    0x8(%eax),%edx
  8032a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032a3:	8b 40 08             	mov    0x8(%eax),%eax
  8032a6:	39 c2                	cmp    %eax,%edx
  8032a8:	0f 82 14 01 00 00    	jb     8033c2 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  8032ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032b1:	8b 50 08             	mov    0x8(%eax),%edx
  8032b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032b7:	8b 40 0c             	mov    0xc(%eax),%eax
  8032ba:	01 c2                	add    %eax,%edx
  8032bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8032bf:	8b 40 08             	mov    0x8(%eax),%eax
  8032c2:	39 c2                	cmp    %eax,%edx
  8032c4:	0f 85 90 00 00 00    	jne    80335a <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  8032ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032cd:	8b 50 0c             	mov    0xc(%eax),%edx
  8032d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d3:	8b 40 0c             	mov    0xc(%eax),%eax
  8032d6:	01 c2                	add    %eax,%edx
  8032d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032db:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  8032de:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e1:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  8032e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8032eb:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8032f2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032f6:	75 17                	jne    80330f <insert_sorted_with_merge_freeList+0x243>
  8032f8:	83 ec 04             	sub    $0x4,%esp
  8032fb:	68 f8 45 80 00       	push   $0x8045f8
  803300:	68 49 01 00 00       	push   $0x149
  803305:	68 1b 46 80 00       	push   $0x80461b
  80330a:	e8 a4 d3 ff ff       	call   8006b3 <_panic>
  80330f:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803315:	8b 45 08             	mov    0x8(%ebp),%eax
  803318:	89 10                	mov    %edx,(%eax)
  80331a:	8b 45 08             	mov    0x8(%ebp),%eax
  80331d:	8b 00                	mov    (%eax),%eax
  80331f:	85 c0                	test   %eax,%eax
  803321:	74 0d                	je     803330 <insert_sorted_with_merge_freeList+0x264>
  803323:	a1 48 51 80 00       	mov    0x805148,%eax
  803328:	8b 55 08             	mov    0x8(%ebp),%edx
  80332b:	89 50 04             	mov    %edx,0x4(%eax)
  80332e:	eb 08                	jmp    803338 <insert_sorted_with_merge_freeList+0x26c>
  803330:	8b 45 08             	mov    0x8(%ebp),%eax
  803333:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803338:	8b 45 08             	mov    0x8(%ebp),%eax
  80333b:	a3 48 51 80 00       	mov    %eax,0x805148
  803340:	8b 45 08             	mov    0x8(%ebp),%eax
  803343:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80334a:	a1 54 51 80 00       	mov    0x805154,%eax
  80334f:	40                   	inc    %eax
  803350:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803355:	e9 bb 04 00 00       	jmp    803815 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  80335a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80335e:	75 17                	jne    803377 <insert_sorted_with_merge_freeList+0x2ab>
  803360:	83 ec 04             	sub    $0x4,%esp
  803363:	68 6c 46 80 00       	push   $0x80466c
  803368:	68 4c 01 00 00       	push   $0x14c
  80336d:	68 1b 46 80 00       	push   $0x80461b
  803372:	e8 3c d3 ff ff       	call   8006b3 <_panic>
  803377:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  80337d:	8b 45 08             	mov    0x8(%ebp),%eax
  803380:	89 50 04             	mov    %edx,0x4(%eax)
  803383:	8b 45 08             	mov    0x8(%ebp),%eax
  803386:	8b 40 04             	mov    0x4(%eax),%eax
  803389:	85 c0                	test   %eax,%eax
  80338b:	74 0c                	je     803399 <insert_sorted_with_merge_freeList+0x2cd>
  80338d:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803392:	8b 55 08             	mov    0x8(%ebp),%edx
  803395:	89 10                	mov    %edx,(%eax)
  803397:	eb 08                	jmp    8033a1 <insert_sorted_with_merge_freeList+0x2d5>
  803399:	8b 45 08             	mov    0x8(%ebp),%eax
  80339c:	a3 38 51 80 00       	mov    %eax,0x805138
  8033a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a4:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8033a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ac:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033b2:	a1 44 51 80 00       	mov    0x805144,%eax
  8033b7:	40                   	inc    %eax
  8033b8:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8033bd:	e9 53 04 00 00       	jmp    803815 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8033c2:	a1 38 51 80 00       	mov    0x805138,%eax
  8033c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033ca:	e9 15 04 00 00       	jmp    8037e4 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  8033cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033d2:	8b 00                	mov    (%eax),%eax
  8033d4:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  8033d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8033da:	8b 50 08             	mov    0x8(%eax),%edx
  8033dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033e0:	8b 40 08             	mov    0x8(%eax),%eax
  8033e3:	39 c2                	cmp    %eax,%edx
  8033e5:	0f 86 f1 03 00 00    	jbe    8037dc <insert_sorted_with_merge_freeList+0x710>
  8033eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ee:	8b 50 08             	mov    0x8(%eax),%edx
  8033f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033f4:	8b 40 08             	mov    0x8(%eax),%eax
  8033f7:	39 c2                	cmp    %eax,%edx
  8033f9:	0f 83 dd 03 00 00    	jae    8037dc <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  8033ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803402:	8b 50 08             	mov    0x8(%eax),%edx
  803405:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803408:	8b 40 0c             	mov    0xc(%eax),%eax
  80340b:	01 c2                	add    %eax,%edx
  80340d:	8b 45 08             	mov    0x8(%ebp),%eax
  803410:	8b 40 08             	mov    0x8(%eax),%eax
  803413:	39 c2                	cmp    %eax,%edx
  803415:	0f 85 b9 01 00 00    	jne    8035d4 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  80341b:	8b 45 08             	mov    0x8(%ebp),%eax
  80341e:	8b 50 08             	mov    0x8(%eax),%edx
  803421:	8b 45 08             	mov    0x8(%ebp),%eax
  803424:	8b 40 0c             	mov    0xc(%eax),%eax
  803427:	01 c2                	add    %eax,%edx
  803429:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80342c:	8b 40 08             	mov    0x8(%eax),%eax
  80342f:	39 c2                	cmp    %eax,%edx
  803431:	0f 85 0d 01 00 00    	jne    803544 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  803437:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80343a:	8b 50 0c             	mov    0xc(%eax),%edx
  80343d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803440:	8b 40 0c             	mov    0xc(%eax),%eax
  803443:	01 c2                	add    %eax,%edx
  803445:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803448:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80344b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80344f:	75 17                	jne    803468 <insert_sorted_with_merge_freeList+0x39c>
  803451:	83 ec 04             	sub    $0x4,%esp
  803454:	68 c4 46 80 00       	push   $0x8046c4
  803459:	68 5c 01 00 00       	push   $0x15c
  80345e:	68 1b 46 80 00       	push   $0x80461b
  803463:	e8 4b d2 ff ff       	call   8006b3 <_panic>
  803468:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80346b:	8b 00                	mov    (%eax),%eax
  80346d:	85 c0                	test   %eax,%eax
  80346f:	74 10                	je     803481 <insert_sorted_with_merge_freeList+0x3b5>
  803471:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803474:	8b 00                	mov    (%eax),%eax
  803476:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803479:	8b 52 04             	mov    0x4(%edx),%edx
  80347c:	89 50 04             	mov    %edx,0x4(%eax)
  80347f:	eb 0b                	jmp    80348c <insert_sorted_with_merge_freeList+0x3c0>
  803481:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803484:	8b 40 04             	mov    0x4(%eax),%eax
  803487:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80348c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80348f:	8b 40 04             	mov    0x4(%eax),%eax
  803492:	85 c0                	test   %eax,%eax
  803494:	74 0f                	je     8034a5 <insert_sorted_with_merge_freeList+0x3d9>
  803496:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803499:	8b 40 04             	mov    0x4(%eax),%eax
  80349c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80349f:	8b 12                	mov    (%edx),%edx
  8034a1:	89 10                	mov    %edx,(%eax)
  8034a3:	eb 0a                	jmp    8034af <insert_sorted_with_merge_freeList+0x3e3>
  8034a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034a8:	8b 00                	mov    (%eax),%eax
  8034aa:	a3 38 51 80 00       	mov    %eax,0x805138
  8034af:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034b2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034bb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034c2:	a1 44 51 80 00       	mov    0x805144,%eax
  8034c7:	48                   	dec    %eax
  8034c8:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  8034cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034d0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  8034d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034da:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8034e1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8034e5:	75 17                	jne    8034fe <insert_sorted_with_merge_freeList+0x432>
  8034e7:	83 ec 04             	sub    $0x4,%esp
  8034ea:	68 f8 45 80 00       	push   $0x8045f8
  8034ef:	68 5f 01 00 00       	push   $0x15f
  8034f4:	68 1b 46 80 00       	push   $0x80461b
  8034f9:	e8 b5 d1 ff ff       	call   8006b3 <_panic>
  8034fe:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803504:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803507:	89 10                	mov    %edx,(%eax)
  803509:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80350c:	8b 00                	mov    (%eax),%eax
  80350e:	85 c0                	test   %eax,%eax
  803510:	74 0d                	je     80351f <insert_sorted_with_merge_freeList+0x453>
  803512:	a1 48 51 80 00       	mov    0x805148,%eax
  803517:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80351a:	89 50 04             	mov    %edx,0x4(%eax)
  80351d:	eb 08                	jmp    803527 <insert_sorted_with_merge_freeList+0x45b>
  80351f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803522:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803527:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80352a:	a3 48 51 80 00       	mov    %eax,0x805148
  80352f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803532:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803539:	a1 54 51 80 00       	mov    0x805154,%eax
  80353e:	40                   	inc    %eax
  80353f:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803544:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803547:	8b 50 0c             	mov    0xc(%eax),%edx
  80354a:	8b 45 08             	mov    0x8(%ebp),%eax
  80354d:	8b 40 0c             	mov    0xc(%eax),%eax
  803550:	01 c2                	add    %eax,%edx
  803552:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803555:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803558:	8b 45 08             	mov    0x8(%ebp),%eax
  80355b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803562:	8b 45 08             	mov    0x8(%ebp),%eax
  803565:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80356c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803570:	75 17                	jne    803589 <insert_sorted_with_merge_freeList+0x4bd>
  803572:	83 ec 04             	sub    $0x4,%esp
  803575:	68 f8 45 80 00       	push   $0x8045f8
  80357a:	68 64 01 00 00       	push   $0x164
  80357f:	68 1b 46 80 00       	push   $0x80461b
  803584:	e8 2a d1 ff ff       	call   8006b3 <_panic>
  803589:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80358f:	8b 45 08             	mov    0x8(%ebp),%eax
  803592:	89 10                	mov    %edx,(%eax)
  803594:	8b 45 08             	mov    0x8(%ebp),%eax
  803597:	8b 00                	mov    (%eax),%eax
  803599:	85 c0                	test   %eax,%eax
  80359b:	74 0d                	je     8035aa <insert_sorted_with_merge_freeList+0x4de>
  80359d:	a1 48 51 80 00       	mov    0x805148,%eax
  8035a2:	8b 55 08             	mov    0x8(%ebp),%edx
  8035a5:	89 50 04             	mov    %edx,0x4(%eax)
  8035a8:	eb 08                	jmp    8035b2 <insert_sorted_with_merge_freeList+0x4e6>
  8035aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ad:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8035b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8035b5:	a3 48 51 80 00       	mov    %eax,0x805148
  8035ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8035bd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035c4:	a1 54 51 80 00       	mov    0x805154,%eax
  8035c9:	40                   	inc    %eax
  8035ca:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8035cf:	e9 41 02 00 00       	jmp    803815 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8035d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8035d7:	8b 50 08             	mov    0x8(%eax),%edx
  8035da:	8b 45 08             	mov    0x8(%ebp),%eax
  8035dd:	8b 40 0c             	mov    0xc(%eax),%eax
  8035e0:	01 c2                	add    %eax,%edx
  8035e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035e5:	8b 40 08             	mov    0x8(%eax),%eax
  8035e8:	39 c2                	cmp    %eax,%edx
  8035ea:	0f 85 7c 01 00 00    	jne    80376c <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  8035f0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8035f4:	74 06                	je     8035fc <insert_sorted_with_merge_freeList+0x530>
  8035f6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8035fa:	75 17                	jne    803613 <insert_sorted_with_merge_freeList+0x547>
  8035fc:	83 ec 04             	sub    $0x4,%esp
  8035ff:	68 34 46 80 00       	push   $0x804634
  803604:	68 69 01 00 00       	push   $0x169
  803609:	68 1b 46 80 00       	push   $0x80461b
  80360e:	e8 a0 d0 ff ff       	call   8006b3 <_panic>
  803613:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803616:	8b 50 04             	mov    0x4(%eax),%edx
  803619:	8b 45 08             	mov    0x8(%ebp),%eax
  80361c:	89 50 04             	mov    %edx,0x4(%eax)
  80361f:	8b 45 08             	mov    0x8(%ebp),%eax
  803622:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803625:	89 10                	mov    %edx,(%eax)
  803627:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80362a:	8b 40 04             	mov    0x4(%eax),%eax
  80362d:	85 c0                	test   %eax,%eax
  80362f:	74 0d                	je     80363e <insert_sorted_with_merge_freeList+0x572>
  803631:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803634:	8b 40 04             	mov    0x4(%eax),%eax
  803637:	8b 55 08             	mov    0x8(%ebp),%edx
  80363a:	89 10                	mov    %edx,(%eax)
  80363c:	eb 08                	jmp    803646 <insert_sorted_with_merge_freeList+0x57a>
  80363e:	8b 45 08             	mov    0x8(%ebp),%eax
  803641:	a3 38 51 80 00       	mov    %eax,0x805138
  803646:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803649:	8b 55 08             	mov    0x8(%ebp),%edx
  80364c:	89 50 04             	mov    %edx,0x4(%eax)
  80364f:	a1 44 51 80 00       	mov    0x805144,%eax
  803654:	40                   	inc    %eax
  803655:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  80365a:	8b 45 08             	mov    0x8(%ebp),%eax
  80365d:	8b 50 0c             	mov    0xc(%eax),%edx
  803660:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803663:	8b 40 0c             	mov    0xc(%eax),%eax
  803666:	01 c2                	add    %eax,%edx
  803668:	8b 45 08             	mov    0x8(%ebp),%eax
  80366b:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80366e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803672:	75 17                	jne    80368b <insert_sorted_with_merge_freeList+0x5bf>
  803674:	83 ec 04             	sub    $0x4,%esp
  803677:	68 c4 46 80 00       	push   $0x8046c4
  80367c:	68 6b 01 00 00       	push   $0x16b
  803681:	68 1b 46 80 00       	push   $0x80461b
  803686:	e8 28 d0 ff ff       	call   8006b3 <_panic>
  80368b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80368e:	8b 00                	mov    (%eax),%eax
  803690:	85 c0                	test   %eax,%eax
  803692:	74 10                	je     8036a4 <insert_sorted_with_merge_freeList+0x5d8>
  803694:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803697:	8b 00                	mov    (%eax),%eax
  803699:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80369c:	8b 52 04             	mov    0x4(%edx),%edx
  80369f:	89 50 04             	mov    %edx,0x4(%eax)
  8036a2:	eb 0b                	jmp    8036af <insert_sorted_with_merge_freeList+0x5e3>
  8036a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036a7:	8b 40 04             	mov    0x4(%eax),%eax
  8036aa:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8036af:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036b2:	8b 40 04             	mov    0x4(%eax),%eax
  8036b5:	85 c0                	test   %eax,%eax
  8036b7:	74 0f                	je     8036c8 <insert_sorted_with_merge_freeList+0x5fc>
  8036b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036bc:	8b 40 04             	mov    0x4(%eax),%eax
  8036bf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8036c2:	8b 12                	mov    (%edx),%edx
  8036c4:	89 10                	mov    %edx,(%eax)
  8036c6:	eb 0a                	jmp    8036d2 <insert_sorted_with_merge_freeList+0x606>
  8036c8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036cb:	8b 00                	mov    (%eax),%eax
  8036cd:	a3 38 51 80 00       	mov    %eax,0x805138
  8036d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036d5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036db:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036de:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036e5:	a1 44 51 80 00       	mov    0x805144,%eax
  8036ea:	48                   	dec    %eax
  8036eb:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  8036f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036f3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  8036fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036fd:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803704:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803708:	75 17                	jne    803721 <insert_sorted_with_merge_freeList+0x655>
  80370a:	83 ec 04             	sub    $0x4,%esp
  80370d:	68 f8 45 80 00       	push   $0x8045f8
  803712:	68 6e 01 00 00       	push   $0x16e
  803717:	68 1b 46 80 00       	push   $0x80461b
  80371c:	e8 92 cf ff ff       	call   8006b3 <_panic>
  803721:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803727:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80372a:	89 10                	mov    %edx,(%eax)
  80372c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80372f:	8b 00                	mov    (%eax),%eax
  803731:	85 c0                	test   %eax,%eax
  803733:	74 0d                	je     803742 <insert_sorted_with_merge_freeList+0x676>
  803735:	a1 48 51 80 00       	mov    0x805148,%eax
  80373a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80373d:	89 50 04             	mov    %edx,0x4(%eax)
  803740:	eb 08                	jmp    80374a <insert_sorted_with_merge_freeList+0x67e>
  803742:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803745:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80374a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80374d:	a3 48 51 80 00       	mov    %eax,0x805148
  803752:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803755:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80375c:	a1 54 51 80 00       	mov    0x805154,%eax
  803761:	40                   	inc    %eax
  803762:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803767:	e9 a9 00 00 00       	jmp    803815 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  80376c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803770:	74 06                	je     803778 <insert_sorted_with_merge_freeList+0x6ac>
  803772:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803776:	75 17                	jne    80378f <insert_sorted_with_merge_freeList+0x6c3>
  803778:	83 ec 04             	sub    $0x4,%esp
  80377b:	68 90 46 80 00       	push   $0x804690
  803780:	68 73 01 00 00       	push   $0x173
  803785:	68 1b 46 80 00       	push   $0x80461b
  80378a:	e8 24 cf ff ff       	call   8006b3 <_panic>
  80378f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803792:	8b 10                	mov    (%eax),%edx
  803794:	8b 45 08             	mov    0x8(%ebp),%eax
  803797:	89 10                	mov    %edx,(%eax)
  803799:	8b 45 08             	mov    0x8(%ebp),%eax
  80379c:	8b 00                	mov    (%eax),%eax
  80379e:	85 c0                	test   %eax,%eax
  8037a0:	74 0b                	je     8037ad <insert_sorted_with_merge_freeList+0x6e1>
  8037a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037a5:	8b 00                	mov    (%eax),%eax
  8037a7:	8b 55 08             	mov    0x8(%ebp),%edx
  8037aa:	89 50 04             	mov    %edx,0x4(%eax)
  8037ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037b0:	8b 55 08             	mov    0x8(%ebp),%edx
  8037b3:	89 10                	mov    %edx,(%eax)
  8037b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8037b8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8037bb:	89 50 04             	mov    %edx,0x4(%eax)
  8037be:	8b 45 08             	mov    0x8(%ebp),%eax
  8037c1:	8b 00                	mov    (%eax),%eax
  8037c3:	85 c0                	test   %eax,%eax
  8037c5:	75 08                	jne    8037cf <insert_sorted_with_merge_freeList+0x703>
  8037c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8037ca:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8037cf:	a1 44 51 80 00       	mov    0x805144,%eax
  8037d4:	40                   	inc    %eax
  8037d5:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  8037da:	eb 39                	jmp    803815 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8037dc:	a1 40 51 80 00       	mov    0x805140,%eax
  8037e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8037e4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037e8:	74 07                	je     8037f1 <insert_sorted_with_merge_freeList+0x725>
  8037ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037ed:	8b 00                	mov    (%eax),%eax
  8037ef:	eb 05                	jmp    8037f6 <insert_sorted_with_merge_freeList+0x72a>
  8037f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8037f6:	a3 40 51 80 00       	mov    %eax,0x805140
  8037fb:	a1 40 51 80 00       	mov    0x805140,%eax
  803800:	85 c0                	test   %eax,%eax
  803802:	0f 85 c7 fb ff ff    	jne    8033cf <insert_sorted_with_merge_freeList+0x303>
  803808:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80380c:	0f 85 bd fb ff ff    	jne    8033cf <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803812:	eb 01                	jmp    803815 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803814:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803815:	90                   	nop
  803816:	c9                   	leave  
  803817:	c3                   	ret    

00803818 <__udivdi3>:
  803818:	55                   	push   %ebp
  803819:	57                   	push   %edi
  80381a:	56                   	push   %esi
  80381b:	53                   	push   %ebx
  80381c:	83 ec 1c             	sub    $0x1c,%esp
  80381f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803823:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803827:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80382b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80382f:	89 ca                	mov    %ecx,%edx
  803831:	89 f8                	mov    %edi,%eax
  803833:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803837:	85 f6                	test   %esi,%esi
  803839:	75 2d                	jne    803868 <__udivdi3+0x50>
  80383b:	39 cf                	cmp    %ecx,%edi
  80383d:	77 65                	ja     8038a4 <__udivdi3+0x8c>
  80383f:	89 fd                	mov    %edi,%ebp
  803841:	85 ff                	test   %edi,%edi
  803843:	75 0b                	jne    803850 <__udivdi3+0x38>
  803845:	b8 01 00 00 00       	mov    $0x1,%eax
  80384a:	31 d2                	xor    %edx,%edx
  80384c:	f7 f7                	div    %edi
  80384e:	89 c5                	mov    %eax,%ebp
  803850:	31 d2                	xor    %edx,%edx
  803852:	89 c8                	mov    %ecx,%eax
  803854:	f7 f5                	div    %ebp
  803856:	89 c1                	mov    %eax,%ecx
  803858:	89 d8                	mov    %ebx,%eax
  80385a:	f7 f5                	div    %ebp
  80385c:	89 cf                	mov    %ecx,%edi
  80385e:	89 fa                	mov    %edi,%edx
  803860:	83 c4 1c             	add    $0x1c,%esp
  803863:	5b                   	pop    %ebx
  803864:	5e                   	pop    %esi
  803865:	5f                   	pop    %edi
  803866:	5d                   	pop    %ebp
  803867:	c3                   	ret    
  803868:	39 ce                	cmp    %ecx,%esi
  80386a:	77 28                	ja     803894 <__udivdi3+0x7c>
  80386c:	0f bd fe             	bsr    %esi,%edi
  80386f:	83 f7 1f             	xor    $0x1f,%edi
  803872:	75 40                	jne    8038b4 <__udivdi3+0x9c>
  803874:	39 ce                	cmp    %ecx,%esi
  803876:	72 0a                	jb     803882 <__udivdi3+0x6a>
  803878:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80387c:	0f 87 9e 00 00 00    	ja     803920 <__udivdi3+0x108>
  803882:	b8 01 00 00 00       	mov    $0x1,%eax
  803887:	89 fa                	mov    %edi,%edx
  803889:	83 c4 1c             	add    $0x1c,%esp
  80388c:	5b                   	pop    %ebx
  80388d:	5e                   	pop    %esi
  80388e:	5f                   	pop    %edi
  80388f:	5d                   	pop    %ebp
  803890:	c3                   	ret    
  803891:	8d 76 00             	lea    0x0(%esi),%esi
  803894:	31 ff                	xor    %edi,%edi
  803896:	31 c0                	xor    %eax,%eax
  803898:	89 fa                	mov    %edi,%edx
  80389a:	83 c4 1c             	add    $0x1c,%esp
  80389d:	5b                   	pop    %ebx
  80389e:	5e                   	pop    %esi
  80389f:	5f                   	pop    %edi
  8038a0:	5d                   	pop    %ebp
  8038a1:	c3                   	ret    
  8038a2:	66 90                	xchg   %ax,%ax
  8038a4:	89 d8                	mov    %ebx,%eax
  8038a6:	f7 f7                	div    %edi
  8038a8:	31 ff                	xor    %edi,%edi
  8038aa:	89 fa                	mov    %edi,%edx
  8038ac:	83 c4 1c             	add    $0x1c,%esp
  8038af:	5b                   	pop    %ebx
  8038b0:	5e                   	pop    %esi
  8038b1:	5f                   	pop    %edi
  8038b2:	5d                   	pop    %ebp
  8038b3:	c3                   	ret    
  8038b4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8038b9:	89 eb                	mov    %ebp,%ebx
  8038bb:	29 fb                	sub    %edi,%ebx
  8038bd:	89 f9                	mov    %edi,%ecx
  8038bf:	d3 e6                	shl    %cl,%esi
  8038c1:	89 c5                	mov    %eax,%ebp
  8038c3:	88 d9                	mov    %bl,%cl
  8038c5:	d3 ed                	shr    %cl,%ebp
  8038c7:	89 e9                	mov    %ebp,%ecx
  8038c9:	09 f1                	or     %esi,%ecx
  8038cb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8038cf:	89 f9                	mov    %edi,%ecx
  8038d1:	d3 e0                	shl    %cl,%eax
  8038d3:	89 c5                	mov    %eax,%ebp
  8038d5:	89 d6                	mov    %edx,%esi
  8038d7:	88 d9                	mov    %bl,%cl
  8038d9:	d3 ee                	shr    %cl,%esi
  8038db:	89 f9                	mov    %edi,%ecx
  8038dd:	d3 e2                	shl    %cl,%edx
  8038df:	8b 44 24 08          	mov    0x8(%esp),%eax
  8038e3:	88 d9                	mov    %bl,%cl
  8038e5:	d3 e8                	shr    %cl,%eax
  8038e7:	09 c2                	or     %eax,%edx
  8038e9:	89 d0                	mov    %edx,%eax
  8038eb:	89 f2                	mov    %esi,%edx
  8038ed:	f7 74 24 0c          	divl   0xc(%esp)
  8038f1:	89 d6                	mov    %edx,%esi
  8038f3:	89 c3                	mov    %eax,%ebx
  8038f5:	f7 e5                	mul    %ebp
  8038f7:	39 d6                	cmp    %edx,%esi
  8038f9:	72 19                	jb     803914 <__udivdi3+0xfc>
  8038fb:	74 0b                	je     803908 <__udivdi3+0xf0>
  8038fd:	89 d8                	mov    %ebx,%eax
  8038ff:	31 ff                	xor    %edi,%edi
  803901:	e9 58 ff ff ff       	jmp    80385e <__udivdi3+0x46>
  803906:	66 90                	xchg   %ax,%ax
  803908:	8b 54 24 08          	mov    0x8(%esp),%edx
  80390c:	89 f9                	mov    %edi,%ecx
  80390e:	d3 e2                	shl    %cl,%edx
  803910:	39 c2                	cmp    %eax,%edx
  803912:	73 e9                	jae    8038fd <__udivdi3+0xe5>
  803914:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803917:	31 ff                	xor    %edi,%edi
  803919:	e9 40 ff ff ff       	jmp    80385e <__udivdi3+0x46>
  80391e:	66 90                	xchg   %ax,%ax
  803920:	31 c0                	xor    %eax,%eax
  803922:	e9 37 ff ff ff       	jmp    80385e <__udivdi3+0x46>
  803927:	90                   	nop

00803928 <__umoddi3>:
  803928:	55                   	push   %ebp
  803929:	57                   	push   %edi
  80392a:	56                   	push   %esi
  80392b:	53                   	push   %ebx
  80392c:	83 ec 1c             	sub    $0x1c,%esp
  80392f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803933:	8b 74 24 34          	mov    0x34(%esp),%esi
  803937:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80393b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80393f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803943:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803947:	89 f3                	mov    %esi,%ebx
  803949:	89 fa                	mov    %edi,%edx
  80394b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80394f:	89 34 24             	mov    %esi,(%esp)
  803952:	85 c0                	test   %eax,%eax
  803954:	75 1a                	jne    803970 <__umoddi3+0x48>
  803956:	39 f7                	cmp    %esi,%edi
  803958:	0f 86 a2 00 00 00    	jbe    803a00 <__umoddi3+0xd8>
  80395e:	89 c8                	mov    %ecx,%eax
  803960:	89 f2                	mov    %esi,%edx
  803962:	f7 f7                	div    %edi
  803964:	89 d0                	mov    %edx,%eax
  803966:	31 d2                	xor    %edx,%edx
  803968:	83 c4 1c             	add    $0x1c,%esp
  80396b:	5b                   	pop    %ebx
  80396c:	5e                   	pop    %esi
  80396d:	5f                   	pop    %edi
  80396e:	5d                   	pop    %ebp
  80396f:	c3                   	ret    
  803970:	39 f0                	cmp    %esi,%eax
  803972:	0f 87 ac 00 00 00    	ja     803a24 <__umoddi3+0xfc>
  803978:	0f bd e8             	bsr    %eax,%ebp
  80397b:	83 f5 1f             	xor    $0x1f,%ebp
  80397e:	0f 84 ac 00 00 00    	je     803a30 <__umoddi3+0x108>
  803984:	bf 20 00 00 00       	mov    $0x20,%edi
  803989:	29 ef                	sub    %ebp,%edi
  80398b:	89 fe                	mov    %edi,%esi
  80398d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803991:	89 e9                	mov    %ebp,%ecx
  803993:	d3 e0                	shl    %cl,%eax
  803995:	89 d7                	mov    %edx,%edi
  803997:	89 f1                	mov    %esi,%ecx
  803999:	d3 ef                	shr    %cl,%edi
  80399b:	09 c7                	or     %eax,%edi
  80399d:	89 e9                	mov    %ebp,%ecx
  80399f:	d3 e2                	shl    %cl,%edx
  8039a1:	89 14 24             	mov    %edx,(%esp)
  8039a4:	89 d8                	mov    %ebx,%eax
  8039a6:	d3 e0                	shl    %cl,%eax
  8039a8:	89 c2                	mov    %eax,%edx
  8039aa:	8b 44 24 08          	mov    0x8(%esp),%eax
  8039ae:	d3 e0                	shl    %cl,%eax
  8039b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8039b4:	8b 44 24 08          	mov    0x8(%esp),%eax
  8039b8:	89 f1                	mov    %esi,%ecx
  8039ba:	d3 e8                	shr    %cl,%eax
  8039bc:	09 d0                	or     %edx,%eax
  8039be:	d3 eb                	shr    %cl,%ebx
  8039c0:	89 da                	mov    %ebx,%edx
  8039c2:	f7 f7                	div    %edi
  8039c4:	89 d3                	mov    %edx,%ebx
  8039c6:	f7 24 24             	mull   (%esp)
  8039c9:	89 c6                	mov    %eax,%esi
  8039cb:	89 d1                	mov    %edx,%ecx
  8039cd:	39 d3                	cmp    %edx,%ebx
  8039cf:	0f 82 87 00 00 00    	jb     803a5c <__umoddi3+0x134>
  8039d5:	0f 84 91 00 00 00    	je     803a6c <__umoddi3+0x144>
  8039db:	8b 54 24 04          	mov    0x4(%esp),%edx
  8039df:	29 f2                	sub    %esi,%edx
  8039e1:	19 cb                	sbb    %ecx,%ebx
  8039e3:	89 d8                	mov    %ebx,%eax
  8039e5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8039e9:	d3 e0                	shl    %cl,%eax
  8039eb:	89 e9                	mov    %ebp,%ecx
  8039ed:	d3 ea                	shr    %cl,%edx
  8039ef:	09 d0                	or     %edx,%eax
  8039f1:	89 e9                	mov    %ebp,%ecx
  8039f3:	d3 eb                	shr    %cl,%ebx
  8039f5:	89 da                	mov    %ebx,%edx
  8039f7:	83 c4 1c             	add    $0x1c,%esp
  8039fa:	5b                   	pop    %ebx
  8039fb:	5e                   	pop    %esi
  8039fc:	5f                   	pop    %edi
  8039fd:	5d                   	pop    %ebp
  8039fe:	c3                   	ret    
  8039ff:	90                   	nop
  803a00:	89 fd                	mov    %edi,%ebp
  803a02:	85 ff                	test   %edi,%edi
  803a04:	75 0b                	jne    803a11 <__umoddi3+0xe9>
  803a06:	b8 01 00 00 00       	mov    $0x1,%eax
  803a0b:	31 d2                	xor    %edx,%edx
  803a0d:	f7 f7                	div    %edi
  803a0f:	89 c5                	mov    %eax,%ebp
  803a11:	89 f0                	mov    %esi,%eax
  803a13:	31 d2                	xor    %edx,%edx
  803a15:	f7 f5                	div    %ebp
  803a17:	89 c8                	mov    %ecx,%eax
  803a19:	f7 f5                	div    %ebp
  803a1b:	89 d0                	mov    %edx,%eax
  803a1d:	e9 44 ff ff ff       	jmp    803966 <__umoddi3+0x3e>
  803a22:	66 90                	xchg   %ax,%ax
  803a24:	89 c8                	mov    %ecx,%eax
  803a26:	89 f2                	mov    %esi,%edx
  803a28:	83 c4 1c             	add    $0x1c,%esp
  803a2b:	5b                   	pop    %ebx
  803a2c:	5e                   	pop    %esi
  803a2d:	5f                   	pop    %edi
  803a2e:	5d                   	pop    %ebp
  803a2f:	c3                   	ret    
  803a30:	3b 04 24             	cmp    (%esp),%eax
  803a33:	72 06                	jb     803a3b <__umoddi3+0x113>
  803a35:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803a39:	77 0f                	ja     803a4a <__umoddi3+0x122>
  803a3b:	89 f2                	mov    %esi,%edx
  803a3d:	29 f9                	sub    %edi,%ecx
  803a3f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803a43:	89 14 24             	mov    %edx,(%esp)
  803a46:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803a4a:	8b 44 24 04          	mov    0x4(%esp),%eax
  803a4e:	8b 14 24             	mov    (%esp),%edx
  803a51:	83 c4 1c             	add    $0x1c,%esp
  803a54:	5b                   	pop    %ebx
  803a55:	5e                   	pop    %esi
  803a56:	5f                   	pop    %edi
  803a57:	5d                   	pop    %ebp
  803a58:	c3                   	ret    
  803a59:	8d 76 00             	lea    0x0(%esi),%esi
  803a5c:	2b 04 24             	sub    (%esp),%eax
  803a5f:	19 fa                	sbb    %edi,%edx
  803a61:	89 d1                	mov    %edx,%ecx
  803a63:	89 c6                	mov    %eax,%esi
  803a65:	e9 71 ff ff ff       	jmp    8039db <__umoddi3+0xb3>
  803a6a:	66 90                	xchg   %ax,%ax
  803a6c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803a70:	72 ea                	jb     803a5c <__umoddi3+0x134>
  803a72:	89 d9                	mov    %ebx,%ecx
  803a74:	e9 62 ff ff ff       	jmp    8039db <__umoddi3+0xb3>
