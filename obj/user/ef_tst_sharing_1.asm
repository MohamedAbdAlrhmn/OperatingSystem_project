
obj/user/ef_tst_sharing_1:     file format elf32-i386


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
  800031:	e8 64 03 00 00       	call   80039a <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Test the creation of shared variables (create_shared_memory)
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	83 ec 34             	sub    $0x34,%esp
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
  80008d:	68 60 37 80 00       	push   $0x803760
  800092:	6a 12                	push   $0x12
  800094:	68 7c 37 80 00       	push   $0x80377c
  800099:	e8 38 04 00 00       	call   8004d6 <_panic>
	}

	uint32 *x, *y, *z ;
	cprintf("STEP A: checking the creation of shared variables... \n");
  80009e:	83 ec 0c             	sub    $0xc,%esp
  8000a1:	68 94 37 80 00       	push   $0x803794
  8000a6:	e8 df 06 00 00       	call   80078a <cprintf>
  8000ab:	83 c4 10             	add    $0x10,%esp
	{
		int freeFrames = sys_calculate_free_frames() ;
  8000ae:	e8 7f 18 00 00       	call   801932 <sys_calculate_free_frames>
  8000b3:	89 45 e8             	mov    %eax,-0x18(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8000b6:	83 ec 04             	sub    $0x4,%esp
  8000b9:	6a 01                	push   $0x1
  8000bb:	68 00 10 00 00       	push   $0x1000
  8000c0:	68 cb 37 80 00       	push   $0x8037cb
  8000c5:	e8 90 16 00 00       	call   80175a <smalloc>
  8000ca:	83 c4 10             	add    $0x10,%esp
  8000cd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (x != (uint32*)USER_HEAP_START) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  8000d0:	81 7d e4 00 00 00 80 	cmpl   $0x80000000,-0x1c(%ebp)
  8000d7:	74 14                	je     8000ed <_main+0xb5>
  8000d9:	83 ec 04             	sub    $0x4,%esp
  8000dc:	68 d0 37 80 00       	push   $0x8037d0
  8000e1:	6a 1a                	push   $0x1a
  8000e3:	68 7c 37 80 00       	push   $0x80377c
  8000e8:	e8 e9 03 00 00       	call   8004d6 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage %d %d %d", freeFrames, sys_calculate_free_frames(), freeFrames - sys_calculate_free_frames());
  8000ed:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8000f0:	e8 3d 18 00 00       	call   801932 <sys_calculate_free_frames>
  8000f5:	29 c3                	sub    %eax,%ebx
  8000f7:	89 d8                	mov    %ebx,%eax
  8000f9:	83 f8 04             	cmp    $0x4,%eax
  8000fc:	74 28                	je     800126 <_main+0xee>
  8000fe:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800101:	e8 2c 18 00 00       	call   801932 <sys_calculate_free_frames>
  800106:	29 c3                	sub    %eax,%ebx
  800108:	e8 25 18 00 00       	call   801932 <sys_calculate_free_frames>
  80010d:	83 ec 08             	sub    $0x8,%esp
  800110:	53                   	push   %ebx
  800111:	50                   	push   %eax
  800112:	ff 75 e8             	pushl  -0x18(%ebp)
  800115:	68 3c 38 80 00       	push   $0x80383c
  80011a:	6a 1b                	push   $0x1b
  80011c:	68 7c 37 80 00       	push   $0x80377c
  800121:	e8 b0 03 00 00       	call   8004d6 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800126:	e8 07 18 00 00       	call   801932 <sys_calculate_free_frames>
  80012b:	89 45 e8             	mov    %eax,-0x18(%ebp)
		z = smalloc("y", PAGE_SIZE + 4, 1);
  80012e:	83 ec 04             	sub    $0x4,%esp
  800131:	6a 01                	push   $0x1
  800133:	68 04 10 00 00       	push   $0x1004
  800138:	68 c3 38 80 00       	push   $0x8038c3
  80013d:	e8 18 16 00 00       	call   80175a <smalloc>
  800142:	83 c4 10             	add    $0x10,%esp
  800145:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (z != (uint32*)(USER_HEAP_START + 1 * PAGE_SIZE)) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  800148:	81 7d e0 00 10 00 80 	cmpl   $0x80001000,-0x20(%ebp)
  80014f:	74 14                	je     800165 <_main+0x12d>
  800151:	83 ec 04             	sub    $0x4,%esp
  800154:	68 d0 37 80 00       	push   $0x8037d0
  800159:	6a 1f                	push   $0x1f
  80015b:	68 7c 37 80 00       	push   $0x80377c
  800160:	e8 71 03 00 00       	call   8004d6 <_panic>

		if ((freeFrames - sys_calculate_free_frames()) !=  2+0+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage %d %d %d", freeFrames, sys_calculate_free_frames(), freeFrames - sys_calculate_free_frames());
  800165:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800168:	e8 c5 17 00 00       	call   801932 <sys_calculate_free_frames>
  80016d:	29 c3                	sub    %eax,%ebx
  80016f:	89 d8                	mov    %ebx,%eax
  800171:	83 f8 04             	cmp    $0x4,%eax
  800174:	74 28                	je     80019e <_main+0x166>
  800176:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800179:	e8 b4 17 00 00       	call   801932 <sys_calculate_free_frames>
  80017e:	29 c3                	sub    %eax,%ebx
  800180:	e8 ad 17 00 00       	call   801932 <sys_calculate_free_frames>
  800185:	83 ec 08             	sub    $0x8,%esp
  800188:	53                   	push   %ebx
  800189:	50                   	push   %eax
  80018a:	ff 75 e8             	pushl  -0x18(%ebp)
  80018d:	68 3c 38 80 00       	push   $0x80383c
  800192:	6a 21                	push   $0x21
  800194:	68 7c 37 80 00       	push   $0x80377c
  800199:	e8 38 03 00 00       	call   8004d6 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  80019e:	e8 8f 17 00 00       	call   801932 <sys_calculate_free_frames>
  8001a3:	89 45 e8             	mov    %eax,-0x18(%ebp)
		y = smalloc("z", 4, 1);
  8001a6:	83 ec 04             	sub    $0x4,%esp
  8001a9:	6a 01                	push   $0x1
  8001ab:	6a 04                	push   $0x4
  8001ad:	68 c5 38 80 00       	push   $0x8038c5
  8001b2:	e8 a3 15 00 00       	call   80175a <smalloc>
  8001b7:	83 c4 10             	add    $0x10,%esp
  8001ba:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (y != (uint32*)(USER_HEAP_START + 3 * PAGE_SIZE)) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  8001bd:	81 7d dc 00 30 00 80 	cmpl   $0x80003000,-0x24(%ebp)
  8001c4:	74 14                	je     8001da <_main+0x1a2>
  8001c6:	83 ec 04             	sub    $0x4,%esp
  8001c9:	68 d0 37 80 00       	push   $0x8037d0
  8001ce:	6a 25                	push   $0x25
  8001d0:	68 7c 37 80 00       	push   $0x80377c
  8001d5:	e8 fc 02 00 00       	call   8004d6 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  1+0+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  8001da:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8001dd:	e8 50 17 00 00       	call   801932 <sys_calculate_free_frames>
  8001e2:	29 c3                	sub    %eax,%ebx
  8001e4:	89 d8                	mov    %ebx,%eax
  8001e6:	83 f8 03             	cmp    $0x3,%eax
  8001e9:	74 14                	je     8001ff <_main+0x1c7>
  8001eb:	83 ec 04             	sub    $0x4,%esp
  8001ee:	68 c8 38 80 00       	push   $0x8038c8
  8001f3:	6a 26                	push   $0x26
  8001f5:	68 7c 37 80 00       	push   $0x80377c
  8001fa:	e8 d7 02 00 00       	call   8004d6 <_panic>
	}
	cprintf("Step A is completed successfully!!\n\n\n");
  8001ff:	83 ec 0c             	sub    $0xc,%esp
  800202:	68 48 39 80 00       	push   $0x803948
  800207:	e8 7e 05 00 00       	call   80078a <cprintf>
  80020c:	83 c4 10             	add    $0x10,%esp


	cprintf("STEP B: checking reading & writing... \n");
  80020f:	83 ec 0c             	sub    $0xc,%esp
  800212:	68 70 39 80 00       	push   $0x803970
  800217:	e8 6e 05 00 00       	call   80078a <cprintf>
  80021c:	83 c4 10             	add    $0x10,%esp
	{
		int i=0;
  80021f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for(;i<PAGE_SIZE/4;i++)
  800226:	eb 2d                	jmp    800255 <_main+0x21d>
		{
			x[i] = -1;
  800228:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80022b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800232:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800235:	01 d0                	add    %edx,%eax
  800237:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
			y[i] = -1;
  80023d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800240:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800247:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80024a:	01 d0                	add    %edx,%eax
  80024c:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)


	cprintf("STEP B: checking reading & writing... \n");
	{
		int i=0;
		for(;i<PAGE_SIZE/4;i++)
  800252:	ff 45 ec             	incl   -0x14(%ebp)
  800255:	81 7d ec ff 03 00 00 	cmpl   $0x3ff,-0x14(%ebp)
  80025c:	7e ca                	jle    800228 <_main+0x1f0>
		{
			x[i] = -1;
			y[i] = -1;
		}

		i=0;
  80025e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for(;i<2*PAGE_SIZE/4;i++)
  800265:	eb 18                	jmp    80027f <_main+0x247>
		{
			z[i] = -1;
  800267:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80026a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800271:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800274:	01 d0                	add    %edx,%eax
  800276:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
			x[i] = -1;
			y[i] = -1;
		}

		i=0;
		for(;i<2*PAGE_SIZE/4;i++)
  80027c:	ff 45 ec             	incl   -0x14(%ebp)
  80027f:	81 7d ec ff 07 00 00 	cmpl   $0x7ff,-0x14(%ebp)
  800286:	7e df                	jle    800267 <_main+0x22f>
		{
			z[i] = -1;
		}

		if( x[0] !=  -1)  					panic("Reading/Writing of shared object is failed");
  800288:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80028b:	8b 00                	mov    (%eax),%eax
  80028d:	83 f8 ff             	cmp    $0xffffffff,%eax
  800290:	74 14                	je     8002a6 <_main+0x26e>
  800292:	83 ec 04             	sub    $0x4,%esp
  800295:	68 98 39 80 00       	push   $0x803998
  80029a:	6a 3a                	push   $0x3a
  80029c:	68 7c 37 80 00       	push   $0x80377c
  8002a1:	e8 30 02 00 00       	call   8004d6 <_panic>
		if( x[PAGE_SIZE/4 - 1] !=  -1)  	panic("Reading/Writing of shared object is failed");
  8002a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002a9:	05 fc 0f 00 00       	add    $0xffc,%eax
  8002ae:	8b 00                	mov    (%eax),%eax
  8002b0:	83 f8 ff             	cmp    $0xffffffff,%eax
  8002b3:	74 14                	je     8002c9 <_main+0x291>
  8002b5:	83 ec 04             	sub    $0x4,%esp
  8002b8:	68 98 39 80 00       	push   $0x803998
  8002bd:	6a 3b                	push   $0x3b
  8002bf:	68 7c 37 80 00       	push   $0x80377c
  8002c4:	e8 0d 02 00 00       	call   8004d6 <_panic>

		if( y[0] !=  -1)  					panic("Reading/Writing of shared object is failed");
  8002c9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002cc:	8b 00                	mov    (%eax),%eax
  8002ce:	83 f8 ff             	cmp    $0xffffffff,%eax
  8002d1:	74 14                	je     8002e7 <_main+0x2af>
  8002d3:	83 ec 04             	sub    $0x4,%esp
  8002d6:	68 98 39 80 00       	push   $0x803998
  8002db:	6a 3d                	push   $0x3d
  8002dd:	68 7c 37 80 00       	push   $0x80377c
  8002e2:	e8 ef 01 00 00       	call   8004d6 <_panic>
		if( y[PAGE_SIZE/4 - 1] !=  -1)  	panic("Reading/Writing of shared object is failed");
  8002e7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002ea:	05 fc 0f 00 00       	add    $0xffc,%eax
  8002ef:	8b 00                	mov    (%eax),%eax
  8002f1:	83 f8 ff             	cmp    $0xffffffff,%eax
  8002f4:	74 14                	je     80030a <_main+0x2d2>
  8002f6:	83 ec 04             	sub    $0x4,%esp
  8002f9:	68 98 39 80 00       	push   $0x803998
  8002fe:	6a 3e                	push   $0x3e
  800300:	68 7c 37 80 00       	push   $0x80377c
  800305:	e8 cc 01 00 00       	call   8004d6 <_panic>

		if( z[0] !=  -1)  					panic("Reading/Writing of shared object is failed");
  80030a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80030d:	8b 00                	mov    (%eax),%eax
  80030f:	83 f8 ff             	cmp    $0xffffffff,%eax
  800312:	74 14                	je     800328 <_main+0x2f0>
  800314:	83 ec 04             	sub    $0x4,%esp
  800317:	68 98 39 80 00       	push   $0x803998
  80031c:	6a 40                	push   $0x40
  80031e:	68 7c 37 80 00       	push   $0x80377c
  800323:	e8 ae 01 00 00       	call   8004d6 <_panic>
		if( z[2*PAGE_SIZE/4 - 1] !=  -1)  	panic("Reading/Writing of shared object is failed");
  800328:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80032b:	05 fc 1f 00 00       	add    $0x1ffc,%eax
  800330:	8b 00                	mov    (%eax),%eax
  800332:	83 f8 ff             	cmp    $0xffffffff,%eax
  800335:	74 14                	je     80034b <_main+0x313>
  800337:	83 ec 04             	sub    $0x4,%esp
  80033a:	68 98 39 80 00       	push   $0x803998
  80033f:	6a 41                	push   $0x41
  800341:	68 7c 37 80 00       	push   $0x80377c
  800346:	e8 8b 01 00 00       	call   8004d6 <_panic>
	}

	cprintf("Congratulations!! Test of Shared Variables [Create] [1] completed successfully!!\n\n\n");
  80034b:	83 ec 0c             	sub    $0xc,%esp
  80034e:	68 c4 39 80 00       	push   $0x8039c4
  800353:	e8 32 04 00 00       	call   80078a <cprintf>
  800358:	83 c4 10             	add    $0x10,%esp

	int32 parentenvID = sys_getparentenvid();
  80035b:	e8 cb 18 00 00       	call   801c2b <sys_getparentenvid>
  800360:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if(parentenvID > 0)
  800363:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800367:	7e 2b                	jle    800394 <_main+0x35c>
	{
		//Get the check-finishing counter
		int *finishedCount = NULL;
  800369:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		finishedCount = sget(parentenvID, "finishedCount") ;
  800370:	83 ec 08             	sub    $0x8,%esp
  800373:	68 18 3a 80 00       	push   $0x803a18
  800378:	ff 75 d8             	pushl  -0x28(%ebp)
  80037b:	e8 0e 14 00 00       	call   80178e <sget>
  800380:	83 c4 10             	add    $0x10,%esp
  800383:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		(*finishedCount)++ ;
  800386:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800389:	8b 00                	mov    (%eax),%eax
  80038b:	8d 50 01             	lea    0x1(%eax),%edx
  80038e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800391:	89 10                	mov    %edx,(%eax)
	}

	return;
  800393:	90                   	nop
  800394:	90                   	nop
}
  800395:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800398:	c9                   	leave  
  800399:	c3                   	ret    

0080039a <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80039a:	55                   	push   %ebp
  80039b:	89 e5                	mov    %esp,%ebp
  80039d:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8003a0:	e8 6d 18 00 00       	call   801c12 <sys_getenvindex>
  8003a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8003a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8003ab:	89 d0                	mov    %edx,%eax
  8003ad:	c1 e0 03             	shl    $0x3,%eax
  8003b0:	01 d0                	add    %edx,%eax
  8003b2:	01 c0                	add    %eax,%eax
  8003b4:	01 d0                	add    %edx,%eax
  8003b6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003bd:	01 d0                	add    %edx,%eax
  8003bf:	c1 e0 04             	shl    $0x4,%eax
  8003c2:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8003c7:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8003cc:	a1 20 50 80 00       	mov    0x805020,%eax
  8003d1:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8003d7:	84 c0                	test   %al,%al
  8003d9:	74 0f                	je     8003ea <libmain+0x50>
		binaryname = myEnv->prog_name;
  8003db:	a1 20 50 80 00       	mov    0x805020,%eax
  8003e0:	05 5c 05 00 00       	add    $0x55c,%eax
  8003e5:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8003ea:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8003ee:	7e 0a                	jle    8003fa <libmain+0x60>
		binaryname = argv[0];
  8003f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003f3:	8b 00                	mov    (%eax),%eax
  8003f5:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8003fa:	83 ec 08             	sub    $0x8,%esp
  8003fd:	ff 75 0c             	pushl  0xc(%ebp)
  800400:	ff 75 08             	pushl  0x8(%ebp)
  800403:	e8 30 fc ff ff       	call   800038 <_main>
  800408:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80040b:	e8 0f 16 00 00       	call   801a1f <sys_disable_interrupt>
	cprintf("**************************************\n");
  800410:	83 ec 0c             	sub    $0xc,%esp
  800413:	68 40 3a 80 00       	push   $0x803a40
  800418:	e8 6d 03 00 00       	call   80078a <cprintf>
  80041d:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800420:	a1 20 50 80 00       	mov    0x805020,%eax
  800425:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  80042b:	a1 20 50 80 00       	mov    0x805020,%eax
  800430:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800436:	83 ec 04             	sub    $0x4,%esp
  800439:	52                   	push   %edx
  80043a:	50                   	push   %eax
  80043b:	68 68 3a 80 00       	push   $0x803a68
  800440:	e8 45 03 00 00       	call   80078a <cprintf>
  800445:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800448:	a1 20 50 80 00       	mov    0x805020,%eax
  80044d:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800453:	a1 20 50 80 00       	mov    0x805020,%eax
  800458:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  80045e:	a1 20 50 80 00       	mov    0x805020,%eax
  800463:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800469:	51                   	push   %ecx
  80046a:	52                   	push   %edx
  80046b:	50                   	push   %eax
  80046c:	68 90 3a 80 00       	push   $0x803a90
  800471:	e8 14 03 00 00       	call   80078a <cprintf>
  800476:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800479:	a1 20 50 80 00       	mov    0x805020,%eax
  80047e:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800484:	83 ec 08             	sub    $0x8,%esp
  800487:	50                   	push   %eax
  800488:	68 e8 3a 80 00       	push   $0x803ae8
  80048d:	e8 f8 02 00 00       	call   80078a <cprintf>
  800492:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800495:	83 ec 0c             	sub    $0xc,%esp
  800498:	68 40 3a 80 00       	push   $0x803a40
  80049d:	e8 e8 02 00 00       	call   80078a <cprintf>
  8004a2:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8004a5:	e8 8f 15 00 00       	call   801a39 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8004aa:	e8 19 00 00 00       	call   8004c8 <exit>
}
  8004af:	90                   	nop
  8004b0:	c9                   	leave  
  8004b1:	c3                   	ret    

008004b2 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8004b2:	55                   	push   %ebp
  8004b3:	89 e5                	mov    %esp,%ebp
  8004b5:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8004b8:	83 ec 0c             	sub    $0xc,%esp
  8004bb:	6a 00                	push   $0x0
  8004bd:	e8 1c 17 00 00       	call   801bde <sys_destroy_env>
  8004c2:	83 c4 10             	add    $0x10,%esp
}
  8004c5:	90                   	nop
  8004c6:	c9                   	leave  
  8004c7:	c3                   	ret    

008004c8 <exit>:

void
exit(void)
{
  8004c8:	55                   	push   %ebp
  8004c9:	89 e5                	mov    %esp,%ebp
  8004cb:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8004ce:	e8 71 17 00 00       	call   801c44 <sys_exit_env>
}
  8004d3:	90                   	nop
  8004d4:	c9                   	leave  
  8004d5:	c3                   	ret    

008004d6 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8004d6:	55                   	push   %ebp
  8004d7:	89 e5                	mov    %esp,%ebp
  8004d9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8004dc:	8d 45 10             	lea    0x10(%ebp),%eax
  8004df:	83 c0 04             	add    $0x4,%eax
  8004e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8004e5:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8004ea:	85 c0                	test   %eax,%eax
  8004ec:	74 16                	je     800504 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8004ee:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8004f3:	83 ec 08             	sub    $0x8,%esp
  8004f6:	50                   	push   %eax
  8004f7:	68 fc 3a 80 00       	push   $0x803afc
  8004fc:	e8 89 02 00 00       	call   80078a <cprintf>
  800501:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800504:	a1 00 50 80 00       	mov    0x805000,%eax
  800509:	ff 75 0c             	pushl  0xc(%ebp)
  80050c:	ff 75 08             	pushl  0x8(%ebp)
  80050f:	50                   	push   %eax
  800510:	68 01 3b 80 00       	push   $0x803b01
  800515:	e8 70 02 00 00       	call   80078a <cprintf>
  80051a:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80051d:	8b 45 10             	mov    0x10(%ebp),%eax
  800520:	83 ec 08             	sub    $0x8,%esp
  800523:	ff 75 f4             	pushl  -0xc(%ebp)
  800526:	50                   	push   %eax
  800527:	e8 f3 01 00 00       	call   80071f <vcprintf>
  80052c:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80052f:	83 ec 08             	sub    $0x8,%esp
  800532:	6a 00                	push   $0x0
  800534:	68 1d 3b 80 00       	push   $0x803b1d
  800539:	e8 e1 01 00 00       	call   80071f <vcprintf>
  80053e:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800541:	e8 82 ff ff ff       	call   8004c8 <exit>

	// should not return here
	while (1) ;
  800546:	eb fe                	jmp    800546 <_panic+0x70>

00800548 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800548:	55                   	push   %ebp
  800549:	89 e5                	mov    %esp,%ebp
  80054b:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80054e:	a1 20 50 80 00       	mov    0x805020,%eax
  800553:	8b 50 74             	mov    0x74(%eax),%edx
  800556:	8b 45 0c             	mov    0xc(%ebp),%eax
  800559:	39 c2                	cmp    %eax,%edx
  80055b:	74 14                	je     800571 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80055d:	83 ec 04             	sub    $0x4,%esp
  800560:	68 20 3b 80 00       	push   $0x803b20
  800565:	6a 26                	push   $0x26
  800567:	68 6c 3b 80 00       	push   $0x803b6c
  80056c:	e8 65 ff ff ff       	call   8004d6 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800571:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800578:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80057f:	e9 c2 00 00 00       	jmp    800646 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800584:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800587:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80058e:	8b 45 08             	mov    0x8(%ebp),%eax
  800591:	01 d0                	add    %edx,%eax
  800593:	8b 00                	mov    (%eax),%eax
  800595:	85 c0                	test   %eax,%eax
  800597:	75 08                	jne    8005a1 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800599:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80059c:	e9 a2 00 00 00       	jmp    800643 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8005a1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005a8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8005af:	eb 69                	jmp    80061a <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8005b1:	a1 20 50 80 00       	mov    0x805020,%eax
  8005b6:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8005bc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005bf:	89 d0                	mov    %edx,%eax
  8005c1:	01 c0                	add    %eax,%eax
  8005c3:	01 d0                	add    %edx,%eax
  8005c5:	c1 e0 03             	shl    $0x3,%eax
  8005c8:	01 c8                	add    %ecx,%eax
  8005ca:	8a 40 04             	mov    0x4(%eax),%al
  8005cd:	84 c0                	test   %al,%al
  8005cf:	75 46                	jne    800617 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005d1:	a1 20 50 80 00       	mov    0x805020,%eax
  8005d6:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8005dc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005df:	89 d0                	mov    %edx,%eax
  8005e1:	01 c0                	add    %eax,%eax
  8005e3:	01 d0                	add    %edx,%eax
  8005e5:	c1 e0 03             	shl    $0x3,%eax
  8005e8:	01 c8                	add    %ecx,%eax
  8005ea:	8b 00                	mov    (%eax),%eax
  8005ec:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8005ef:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005f2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8005f7:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8005f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005fc:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800603:	8b 45 08             	mov    0x8(%ebp),%eax
  800606:	01 c8                	add    %ecx,%eax
  800608:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80060a:	39 c2                	cmp    %eax,%edx
  80060c:	75 09                	jne    800617 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  80060e:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800615:	eb 12                	jmp    800629 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800617:	ff 45 e8             	incl   -0x18(%ebp)
  80061a:	a1 20 50 80 00       	mov    0x805020,%eax
  80061f:	8b 50 74             	mov    0x74(%eax),%edx
  800622:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800625:	39 c2                	cmp    %eax,%edx
  800627:	77 88                	ja     8005b1 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800629:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80062d:	75 14                	jne    800643 <CheckWSWithoutLastIndex+0xfb>
			panic(
  80062f:	83 ec 04             	sub    $0x4,%esp
  800632:	68 78 3b 80 00       	push   $0x803b78
  800637:	6a 3a                	push   $0x3a
  800639:	68 6c 3b 80 00       	push   $0x803b6c
  80063e:	e8 93 fe ff ff       	call   8004d6 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800643:	ff 45 f0             	incl   -0x10(%ebp)
  800646:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800649:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80064c:	0f 8c 32 ff ff ff    	jl     800584 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800652:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800659:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800660:	eb 26                	jmp    800688 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800662:	a1 20 50 80 00       	mov    0x805020,%eax
  800667:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80066d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800670:	89 d0                	mov    %edx,%eax
  800672:	01 c0                	add    %eax,%eax
  800674:	01 d0                	add    %edx,%eax
  800676:	c1 e0 03             	shl    $0x3,%eax
  800679:	01 c8                	add    %ecx,%eax
  80067b:	8a 40 04             	mov    0x4(%eax),%al
  80067e:	3c 01                	cmp    $0x1,%al
  800680:	75 03                	jne    800685 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800682:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800685:	ff 45 e0             	incl   -0x20(%ebp)
  800688:	a1 20 50 80 00       	mov    0x805020,%eax
  80068d:	8b 50 74             	mov    0x74(%eax),%edx
  800690:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800693:	39 c2                	cmp    %eax,%edx
  800695:	77 cb                	ja     800662 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800697:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80069a:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80069d:	74 14                	je     8006b3 <CheckWSWithoutLastIndex+0x16b>
		panic(
  80069f:	83 ec 04             	sub    $0x4,%esp
  8006a2:	68 cc 3b 80 00       	push   $0x803bcc
  8006a7:	6a 44                	push   $0x44
  8006a9:	68 6c 3b 80 00       	push   $0x803b6c
  8006ae:	e8 23 fe ff ff       	call   8004d6 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8006b3:	90                   	nop
  8006b4:	c9                   	leave  
  8006b5:	c3                   	ret    

008006b6 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8006b6:	55                   	push   %ebp
  8006b7:	89 e5                	mov    %esp,%ebp
  8006b9:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8006bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006bf:	8b 00                	mov    (%eax),%eax
  8006c1:	8d 48 01             	lea    0x1(%eax),%ecx
  8006c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006c7:	89 0a                	mov    %ecx,(%edx)
  8006c9:	8b 55 08             	mov    0x8(%ebp),%edx
  8006cc:	88 d1                	mov    %dl,%cl
  8006ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006d1:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8006d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006d8:	8b 00                	mov    (%eax),%eax
  8006da:	3d ff 00 00 00       	cmp    $0xff,%eax
  8006df:	75 2c                	jne    80070d <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8006e1:	a0 24 50 80 00       	mov    0x805024,%al
  8006e6:	0f b6 c0             	movzbl %al,%eax
  8006e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006ec:	8b 12                	mov    (%edx),%edx
  8006ee:	89 d1                	mov    %edx,%ecx
  8006f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006f3:	83 c2 08             	add    $0x8,%edx
  8006f6:	83 ec 04             	sub    $0x4,%esp
  8006f9:	50                   	push   %eax
  8006fa:	51                   	push   %ecx
  8006fb:	52                   	push   %edx
  8006fc:	e8 70 11 00 00       	call   801871 <sys_cputs>
  800701:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800704:	8b 45 0c             	mov    0xc(%ebp),%eax
  800707:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80070d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800710:	8b 40 04             	mov    0x4(%eax),%eax
  800713:	8d 50 01             	lea    0x1(%eax),%edx
  800716:	8b 45 0c             	mov    0xc(%ebp),%eax
  800719:	89 50 04             	mov    %edx,0x4(%eax)
}
  80071c:	90                   	nop
  80071d:	c9                   	leave  
  80071e:	c3                   	ret    

0080071f <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80071f:	55                   	push   %ebp
  800720:	89 e5                	mov    %esp,%ebp
  800722:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800728:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80072f:	00 00 00 
	b.cnt = 0;
  800732:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800739:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80073c:	ff 75 0c             	pushl  0xc(%ebp)
  80073f:	ff 75 08             	pushl  0x8(%ebp)
  800742:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800748:	50                   	push   %eax
  800749:	68 b6 06 80 00       	push   $0x8006b6
  80074e:	e8 11 02 00 00       	call   800964 <vprintfmt>
  800753:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800756:	a0 24 50 80 00       	mov    0x805024,%al
  80075b:	0f b6 c0             	movzbl %al,%eax
  80075e:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800764:	83 ec 04             	sub    $0x4,%esp
  800767:	50                   	push   %eax
  800768:	52                   	push   %edx
  800769:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80076f:	83 c0 08             	add    $0x8,%eax
  800772:	50                   	push   %eax
  800773:	e8 f9 10 00 00       	call   801871 <sys_cputs>
  800778:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80077b:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  800782:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800788:	c9                   	leave  
  800789:	c3                   	ret    

0080078a <cprintf>:

int cprintf(const char *fmt, ...) {
  80078a:	55                   	push   %ebp
  80078b:	89 e5                	mov    %esp,%ebp
  80078d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800790:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  800797:	8d 45 0c             	lea    0xc(%ebp),%eax
  80079a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80079d:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a0:	83 ec 08             	sub    $0x8,%esp
  8007a3:	ff 75 f4             	pushl  -0xc(%ebp)
  8007a6:	50                   	push   %eax
  8007a7:	e8 73 ff ff ff       	call   80071f <vcprintf>
  8007ac:	83 c4 10             	add    $0x10,%esp
  8007af:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8007b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007b5:	c9                   	leave  
  8007b6:	c3                   	ret    

008007b7 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8007b7:	55                   	push   %ebp
  8007b8:	89 e5                	mov    %esp,%ebp
  8007ba:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8007bd:	e8 5d 12 00 00       	call   801a1f <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8007c2:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007cb:	83 ec 08             	sub    $0x8,%esp
  8007ce:	ff 75 f4             	pushl  -0xc(%ebp)
  8007d1:	50                   	push   %eax
  8007d2:	e8 48 ff ff ff       	call   80071f <vcprintf>
  8007d7:	83 c4 10             	add    $0x10,%esp
  8007da:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8007dd:	e8 57 12 00 00       	call   801a39 <sys_enable_interrupt>
	return cnt;
  8007e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007e5:	c9                   	leave  
  8007e6:	c3                   	ret    

008007e7 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007e7:	55                   	push   %ebp
  8007e8:	89 e5                	mov    %esp,%ebp
  8007ea:	53                   	push   %ebx
  8007eb:	83 ec 14             	sub    $0x14,%esp
  8007ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8007f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8007fa:	8b 45 18             	mov    0x18(%ebp),%eax
  8007fd:	ba 00 00 00 00       	mov    $0x0,%edx
  800802:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800805:	77 55                	ja     80085c <printnum+0x75>
  800807:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80080a:	72 05                	jb     800811 <printnum+0x2a>
  80080c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80080f:	77 4b                	ja     80085c <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800811:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800814:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800817:	8b 45 18             	mov    0x18(%ebp),%eax
  80081a:	ba 00 00 00 00       	mov    $0x0,%edx
  80081f:	52                   	push   %edx
  800820:	50                   	push   %eax
  800821:	ff 75 f4             	pushl  -0xc(%ebp)
  800824:	ff 75 f0             	pushl  -0x10(%ebp)
  800827:	e8 c8 2c 00 00       	call   8034f4 <__udivdi3>
  80082c:	83 c4 10             	add    $0x10,%esp
  80082f:	83 ec 04             	sub    $0x4,%esp
  800832:	ff 75 20             	pushl  0x20(%ebp)
  800835:	53                   	push   %ebx
  800836:	ff 75 18             	pushl  0x18(%ebp)
  800839:	52                   	push   %edx
  80083a:	50                   	push   %eax
  80083b:	ff 75 0c             	pushl  0xc(%ebp)
  80083e:	ff 75 08             	pushl  0x8(%ebp)
  800841:	e8 a1 ff ff ff       	call   8007e7 <printnum>
  800846:	83 c4 20             	add    $0x20,%esp
  800849:	eb 1a                	jmp    800865 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80084b:	83 ec 08             	sub    $0x8,%esp
  80084e:	ff 75 0c             	pushl  0xc(%ebp)
  800851:	ff 75 20             	pushl  0x20(%ebp)
  800854:	8b 45 08             	mov    0x8(%ebp),%eax
  800857:	ff d0                	call   *%eax
  800859:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80085c:	ff 4d 1c             	decl   0x1c(%ebp)
  80085f:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800863:	7f e6                	jg     80084b <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800865:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800868:	bb 00 00 00 00       	mov    $0x0,%ebx
  80086d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800870:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800873:	53                   	push   %ebx
  800874:	51                   	push   %ecx
  800875:	52                   	push   %edx
  800876:	50                   	push   %eax
  800877:	e8 88 2d 00 00       	call   803604 <__umoddi3>
  80087c:	83 c4 10             	add    $0x10,%esp
  80087f:	05 34 3e 80 00       	add    $0x803e34,%eax
  800884:	8a 00                	mov    (%eax),%al
  800886:	0f be c0             	movsbl %al,%eax
  800889:	83 ec 08             	sub    $0x8,%esp
  80088c:	ff 75 0c             	pushl  0xc(%ebp)
  80088f:	50                   	push   %eax
  800890:	8b 45 08             	mov    0x8(%ebp),%eax
  800893:	ff d0                	call   *%eax
  800895:	83 c4 10             	add    $0x10,%esp
}
  800898:	90                   	nop
  800899:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80089c:	c9                   	leave  
  80089d:	c3                   	ret    

0080089e <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80089e:	55                   	push   %ebp
  80089f:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008a1:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008a5:	7e 1c                	jle    8008c3 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8008a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008aa:	8b 00                	mov    (%eax),%eax
  8008ac:	8d 50 08             	lea    0x8(%eax),%edx
  8008af:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b2:	89 10                	mov    %edx,(%eax)
  8008b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b7:	8b 00                	mov    (%eax),%eax
  8008b9:	83 e8 08             	sub    $0x8,%eax
  8008bc:	8b 50 04             	mov    0x4(%eax),%edx
  8008bf:	8b 00                	mov    (%eax),%eax
  8008c1:	eb 40                	jmp    800903 <getuint+0x65>
	else if (lflag)
  8008c3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008c7:	74 1e                	je     8008e7 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8008c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cc:	8b 00                	mov    (%eax),%eax
  8008ce:	8d 50 04             	lea    0x4(%eax),%edx
  8008d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d4:	89 10                	mov    %edx,(%eax)
  8008d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d9:	8b 00                	mov    (%eax),%eax
  8008db:	83 e8 04             	sub    $0x4,%eax
  8008de:	8b 00                	mov    (%eax),%eax
  8008e0:	ba 00 00 00 00       	mov    $0x0,%edx
  8008e5:	eb 1c                	jmp    800903 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8008e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ea:	8b 00                	mov    (%eax),%eax
  8008ec:	8d 50 04             	lea    0x4(%eax),%edx
  8008ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f2:	89 10                	mov    %edx,(%eax)
  8008f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f7:	8b 00                	mov    (%eax),%eax
  8008f9:	83 e8 04             	sub    $0x4,%eax
  8008fc:	8b 00                	mov    (%eax),%eax
  8008fe:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800903:	5d                   	pop    %ebp
  800904:	c3                   	ret    

00800905 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800905:	55                   	push   %ebp
  800906:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800908:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80090c:	7e 1c                	jle    80092a <getint+0x25>
		return va_arg(*ap, long long);
  80090e:	8b 45 08             	mov    0x8(%ebp),%eax
  800911:	8b 00                	mov    (%eax),%eax
  800913:	8d 50 08             	lea    0x8(%eax),%edx
  800916:	8b 45 08             	mov    0x8(%ebp),%eax
  800919:	89 10                	mov    %edx,(%eax)
  80091b:	8b 45 08             	mov    0x8(%ebp),%eax
  80091e:	8b 00                	mov    (%eax),%eax
  800920:	83 e8 08             	sub    $0x8,%eax
  800923:	8b 50 04             	mov    0x4(%eax),%edx
  800926:	8b 00                	mov    (%eax),%eax
  800928:	eb 38                	jmp    800962 <getint+0x5d>
	else if (lflag)
  80092a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80092e:	74 1a                	je     80094a <getint+0x45>
		return va_arg(*ap, long);
  800930:	8b 45 08             	mov    0x8(%ebp),%eax
  800933:	8b 00                	mov    (%eax),%eax
  800935:	8d 50 04             	lea    0x4(%eax),%edx
  800938:	8b 45 08             	mov    0x8(%ebp),%eax
  80093b:	89 10                	mov    %edx,(%eax)
  80093d:	8b 45 08             	mov    0x8(%ebp),%eax
  800940:	8b 00                	mov    (%eax),%eax
  800942:	83 e8 04             	sub    $0x4,%eax
  800945:	8b 00                	mov    (%eax),%eax
  800947:	99                   	cltd   
  800948:	eb 18                	jmp    800962 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80094a:	8b 45 08             	mov    0x8(%ebp),%eax
  80094d:	8b 00                	mov    (%eax),%eax
  80094f:	8d 50 04             	lea    0x4(%eax),%edx
  800952:	8b 45 08             	mov    0x8(%ebp),%eax
  800955:	89 10                	mov    %edx,(%eax)
  800957:	8b 45 08             	mov    0x8(%ebp),%eax
  80095a:	8b 00                	mov    (%eax),%eax
  80095c:	83 e8 04             	sub    $0x4,%eax
  80095f:	8b 00                	mov    (%eax),%eax
  800961:	99                   	cltd   
}
  800962:	5d                   	pop    %ebp
  800963:	c3                   	ret    

00800964 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800964:	55                   	push   %ebp
  800965:	89 e5                	mov    %esp,%ebp
  800967:	56                   	push   %esi
  800968:	53                   	push   %ebx
  800969:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80096c:	eb 17                	jmp    800985 <vprintfmt+0x21>
			if (ch == '\0')
  80096e:	85 db                	test   %ebx,%ebx
  800970:	0f 84 af 03 00 00    	je     800d25 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800976:	83 ec 08             	sub    $0x8,%esp
  800979:	ff 75 0c             	pushl  0xc(%ebp)
  80097c:	53                   	push   %ebx
  80097d:	8b 45 08             	mov    0x8(%ebp),%eax
  800980:	ff d0                	call   *%eax
  800982:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800985:	8b 45 10             	mov    0x10(%ebp),%eax
  800988:	8d 50 01             	lea    0x1(%eax),%edx
  80098b:	89 55 10             	mov    %edx,0x10(%ebp)
  80098e:	8a 00                	mov    (%eax),%al
  800990:	0f b6 d8             	movzbl %al,%ebx
  800993:	83 fb 25             	cmp    $0x25,%ebx
  800996:	75 d6                	jne    80096e <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800998:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80099c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8009a3:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8009aa:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8009b1:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8009bb:	8d 50 01             	lea    0x1(%eax),%edx
  8009be:	89 55 10             	mov    %edx,0x10(%ebp)
  8009c1:	8a 00                	mov    (%eax),%al
  8009c3:	0f b6 d8             	movzbl %al,%ebx
  8009c6:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8009c9:	83 f8 55             	cmp    $0x55,%eax
  8009cc:	0f 87 2b 03 00 00    	ja     800cfd <vprintfmt+0x399>
  8009d2:	8b 04 85 58 3e 80 00 	mov    0x803e58(,%eax,4),%eax
  8009d9:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8009db:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8009df:	eb d7                	jmp    8009b8 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009e1:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8009e5:	eb d1                	jmp    8009b8 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009e7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8009ee:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009f1:	89 d0                	mov    %edx,%eax
  8009f3:	c1 e0 02             	shl    $0x2,%eax
  8009f6:	01 d0                	add    %edx,%eax
  8009f8:	01 c0                	add    %eax,%eax
  8009fa:	01 d8                	add    %ebx,%eax
  8009fc:	83 e8 30             	sub    $0x30,%eax
  8009ff:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800a02:	8b 45 10             	mov    0x10(%ebp),%eax
  800a05:	8a 00                	mov    (%eax),%al
  800a07:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a0a:	83 fb 2f             	cmp    $0x2f,%ebx
  800a0d:	7e 3e                	jle    800a4d <vprintfmt+0xe9>
  800a0f:	83 fb 39             	cmp    $0x39,%ebx
  800a12:	7f 39                	jg     800a4d <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a14:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a17:	eb d5                	jmp    8009ee <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a19:	8b 45 14             	mov    0x14(%ebp),%eax
  800a1c:	83 c0 04             	add    $0x4,%eax
  800a1f:	89 45 14             	mov    %eax,0x14(%ebp)
  800a22:	8b 45 14             	mov    0x14(%ebp),%eax
  800a25:	83 e8 04             	sub    $0x4,%eax
  800a28:	8b 00                	mov    (%eax),%eax
  800a2a:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a2d:	eb 1f                	jmp    800a4e <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a2f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a33:	79 83                	jns    8009b8 <vprintfmt+0x54>
				width = 0;
  800a35:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a3c:	e9 77 ff ff ff       	jmp    8009b8 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a41:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a48:	e9 6b ff ff ff       	jmp    8009b8 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a4d:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a4e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a52:	0f 89 60 ff ff ff    	jns    8009b8 <vprintfmt+0x54>
				width = precision, precision = -1;
  800a58:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a5b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a5e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a65:	e9 4e ff ff ff       	jmp    8009b8 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a6a:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a6d:	e9 46 ff ff ff       	jmp    8009b8 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a72:	8b 45 14             	mov    0x14(%ebp),%eax
  800a75:	83 c0 04             	add    $0x4,%eax
  800a78:	89 45 14             	mov    %eax,0x14(%ebp)
  800a7b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a7e:	83 e8 04             	sub    $0x4,%eax
  800a81:	8b 00                	mov    (%eax),%eax
  800a83:	83 ec 08             	sub    $0x8,%esp
  800a86:	ff 75 0c             	pushl  0xc(%ebp)
  800a89:	50                   	push   %eax
  800a8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8d:	ff d0                	call   *%eax
  800a8f:	83 c4 10             	add    $0x10,%esp
			break;
  800a92:	e9 89 02 00 00       	jmp    800d20 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800a97:	8b 45 14             	mov    0x14(%ebp),%eax
  800a9a:	83 c0 04             	add    $0x4,%eax
  800a9d:	89 45 14             	mov    %eax,0x14(%ebp)
  800aa0:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa3:	83 e8 04             	sub    $0x4,%eax
  800aa6:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800aa8:	85 db                	test   %ebx,%ebx
  800aaa:	79 02                	jns    800aae <vprintfmt+0x14a>
				err = -err;
  800aac:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800aae:	83 fb 64             	cmp    $0x64,%ebx
  800ab1:	7f 0b                	jg     800abe <vprintfmt+0x15a>
  800ab3:	8b 34 9d a0 3c 80 00 	mov    0x803ca0(,%ebx,4),%esi
  800aba:	85 f6                	test   %esi,%esi
  800abc:	75 19                	jne    800ad7 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800abe:	53                   	push   %ebx
  800abf:	68 45 3e 80 00       	push   $0x803e45
  800ac4:	ff 75 0c             	pushl  0xc(%ebp)
  800ac7:	ff 75 08             	pushl  0x8(%ebp)
  800aca:	e8 5e 02 00 00       	call   800d2d <printfmt>
  800acf:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800ad2:	e9 49 02 00 00       	jmp    800d20 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800ad7:	56                   	push   %esi
  800ad8:	68 4e 3e 80 00       	push   $0x803e4e
  800add:	ff 75 0c             	pushl  0xc(%ebp)
  800ae0:	ff 75 08             	pushl  0x8(%ebp)
  800ae3:	e8 45 02 00 00       	call   800d2d <printfmt>
  800ae8:	83 c4 10             	add    $0x10,%esp
			break;
  800aeb:	e9 30 02 00 00       	jmp    800d20 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800af0:	8b 45 14             	mov    0x14(%ebp),%eax
  800af3:	83 c0 04             	add    $0x4,%eax
  800af6:	89 45 14             	mov    %eax,0x14(%ebp)
  800af9:	8b 45 14             	mov    0x14(%ebp),%eax
  800afc:	83 e8 04             	sub    $0x4,%eax
  800aff:	8b 30                	mov    (%eax),%esi
  800b01:	85 f6                	test   %esi,%esi
  800b03:	75 05                	jne    800b0a <vprintfmt+0x1a6>
				p = "(null)";
  800b05:	be 51 3e 80 00       	mov    $0x803e51,%esi
			if (width > 0 && padc != '-')
  800b0a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b0e:	7e 6d                	jle    800b7d <vprintfmt+0x219>
  800b10:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b14:	74 67                	je     800b7d <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b16:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b19:	83 ec 08             	sub    $0x8,%esp
  800b1c:	50                   	push   %eax
  800b1d:	56                   	push   %esi
  800b1e:	e8 0c 03 00 00       	call   800e2f <strnlen>
  800b23:	83 c4 10             	add    $0x10,%esp
  800b26:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b29:	eb 16                	jmp    800b41 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b2b:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b2f:	83 ec 08             	sub    $0x8,%esp
  800b32:	ff 75 0c             	pushl  0xc(%ebp)
  800b35:	50                   	push   %eax
  800b36:	8b 45 08             	mov    0x8(%ebp),%eax
  800b39:	ff d0                	call   *%eax
  800b3b:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b3e:	ff 4d e4             	decl   -0x1c(%ebp)
  800b41:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b45:	7f e4                	jg     800b2b <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b47:	eb 34                	jmp    800b7d <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b49:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b4d:	74 1c                	je     800b6b <vprintfmt+0x207>
  800b4f:	83 fb 1f             	cmp    $0x1f,%ebx
  800b52:	7e 05                	jle    800b59 <vprintfmt+0x1f5>
  800b54:	83 fb 7e             	cmp    $0x7e,%ebx
  800b57:	7e 12                	jle    800b6b <vprintfmt+0x207>
					putch('?', putdat);
  800b59:	83 ec 08             	sub    $0x8,%esp
  800b5c:	ff 75 0c             	pushl  0xc(%ebp)
  800b5f:	6a 3f                	push   $0x3f
  800b61:	8b 45 08             	mov    0x8(%ebp),%eax
  800b64:	ff d0                	call   *%eax
  800b66:	83 c4 10             	add    $0x10,%esp
  800b69:	eb 0f                	jmp    800b7a <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b6b:	83 ec 08             	sub    $0x8,%esp
  800b6e:	ff 75 0c             	pushl  0xc(%ebp)
  800b71:	53                   	push   %ebx
  800b72:	8b 45 08             	mov    0x8(%ebp),%eax
  800b75:	ff d0                	call   *%eax
  800b77:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b7a:	ff 4d e4             	decl   -0x1c(%ebp)
  800b7d:	89 f0                	mov    %esi,%eax
  800b7f:	8d 70 01             	lea    0x1(%eax),%esi
  800b82:	8a 00                	mov    (%eax),%al
  800b84:	0f be d8             	movsbl %al,%ebx
  800b87:	85 db                	test   %ebx,%ebx
  800b89:	74 24                	je     800baf <vprintfmt+0x24b>
  800b8b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b8f:	78 b8                	js     800b49 <vprintfmt+0x1e5>
  800b91:	ff 4d e0             	decl   -0x20(%ebp)
  800b94:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b98:	79 af                	jns    800b49 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b9a:	eb 13                	jmp    800baf <vprintfmt+0x24b>
				putch(' ', putdat);
  800b9c:	83 ec 08             	sub    $0x8,%esp
  800b9f:	ff 75 0c             	pushl  0xc(%ebp)
  800ba2:	6a 20                	push   $0x20
  800ba4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba7:	ff d0                	call   *%eax
  800ba9:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bac:	ff 4d e4             	decl   -0x1c(%ebp)
  800baf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bb3:	7f e7                	jg     800b9c <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800bb5:	e9 66 01 00 00       	jmp    800d20 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800bba:	83 ec 08             	sub    $0x8,%esp
  800bbd:	ff 75 e8             	pushl  -0x18(%ebp)
  800bc0:	8d 45 14             	lea    0x14(%ebp),%eax
  800bc3:	50                   	push   %eax
  800bc4:	e8 3c fd ff ff       	call   800905 <getint>
  800bc9:	83 c4 10             	add    $0x10,%esp
  800bcc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bcf:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800bd2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bd5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bd8:	85 d2                	test   %edx,%edx
  800bda:	79 23                	jns    800bff <vprintfmt+0x29b>
				putch('-', putdat);
  800bdc:	83 ec 08             	sub    $0x8,%esp
  800bdf:	ff 75 0c             	pushl  0xc(%ebp)
  800be2:	6a 2d                	push   $0x2d
  800be4:	8b 45 08             	mov    0x8(%ebp),%eax
  800be7:	ff d0                	call   *%eax
  800be9:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800bec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bf2:	f7 d8                	neg    %eax
  800bf4:	83 d2 00             	adc    $0x0,%edx
  800bf7:	f7 da                	neg    %edx
  800bf9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bfc:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800bff:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c06:	e9 bc 00 00 00       	jmp    800cc7 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c0b:	83 ec 08             	sub    $0x8,%esp
  800c0e:	ff 75 e8             	pushl  -0x18(%ebp)
  800c11:	8d 45 14             	lea    0x14(%ebp),%eax
  800c14:	50                   	push   %eax
  800c15:	e8 84 fc ff ff       	call   80089e <getuint>
  800c1a:	83 c4 10             	add    $0x10,%esp
  800c1d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c20:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c23:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c2a:	e9 98 00 00 00       	jmp    800cc7 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c2f:	83 ec 08             	sub    $0x8,%esp
  800c32:	ff 75 0c             	pushl  0xc(%ebp)
  800c35:	6a 58                	push   $0x58
  800c37:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3a:	ff d0                	call   *%eax
  800c3c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c3f:	83 ec 08             	sub    $0x8,%esp
  800c42:	ff 75 0c             	pushl  0xc(%ebp)
  800c45:	6a 58                	push   $0x58
  800c47:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4a:	ff d0                	call   *%eax
  800c4c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c4f:	83 ec 08             	sub    $0x8,%esp
  800c52:	ff 75 0c             	pushl  0xc(%ebp)
  800c55:	6a 58                	push   $0x58
  800c57:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5a:	ff d0                	call   *%eax
  800c5c:	83 c4 10             	add    $0x10,%esp
			break;
  800c5f:	e9 bc 00 00 00       	jmp    800d20 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800c64:	83 ec 08             	sub    $0x8,%esp
  800c67:	ff 75 0c             	pushl  0xc(%ebp)
  800c6a:	6a 30                	push   $0x30
  800c6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6f:	ff d0                	call   *%eax
  800c71:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c74:	83 ec 08             	sub    $0x8,%esp
  800c77:	ff 75 0c             	pushl  0xc(%ebp)
  800c7a:	6a 78                	push   $0x78
  800c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7f:	ff d0                	call   *%eax
  800c81:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c84:	8b 45 14             	mov    0x14(%ebp),%eax
  800c87:	83 c0 04             	add    $0x4,%eax
  800c8a:	89 45 14             	mov    %eax,0x14(%ebp)
  800c8d:	8b 45 14             	mov    0x14(%ebp),%eax
  800c90:	83 e8 04             	sub    $0x4,%eax
  800c93:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c95:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c98:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800c9f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800ca6:	eb 1f                	jmp    800cc7 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800ca8:	83 ec 08             	sub    $0x8,%esp
  800cab:	ff 75 e8             	pushl  -0x18(%ebp)
  800cae:	8d 45 14             	lea    0x14(%ebp),%eax
  800cb1:	50                   	push   %eax
  800cb2:	e8 e7 fb ff ff       	call   80089e <getuint>
  800cb7:	83 c4 10             	add    $0x10,%esp
  800cba:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cbd:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800cc0:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800cc7:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800ccb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cce:	83 ec 04             	sub    $0x4,%esp
  800cd1:	52                   	push   %edx
  800cd2:	ff 75 e4             	pushl  -0x1c(%ebp)
  800cd5:	50                   	push   %eax
  800cd6:	ff 75 f4             	pushl  -0xc(%ebp)
  800cd9:	ff 75 f0             	pushl  -0x10(%ebp)
  800cdc:	ff 75 0c             	pushl  0xc(%ebp)
  800cdf:	ff 75 08             	pushl  0x8(%ebp)
  800ce2:	e8 00 fb ff ff       	call   8007e7 <printnum>
  800ce7:	83 c4 20             	add    $0x20,%esp
			break;
  800cea:	eb 34                	jmp    800d20 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800cec:	83 ec 08             	sub    $0x8,%esp
  800cef:	ff 75 0c             	pushl  0xc(%ebp)
  800cf2:	53                   	push   %ebx
  800cf3:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf6:	ff d0                	call   *%eax
  800cf8:	83 c4 10             	add    $0x10,%esp
			break;
  800cfb:	eb 23                	jmp    800d20 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800cfd:	83 ec 08             	sub    $0x8,%esp
  800d00:	ff 75 0c             	pushl  0xc(%ebp)
  800d03:	6a 25                	push   $0x25
  800d05:	8b 45 08             	mov    0x8(%ebp),%eax
  800d08:	ff d0                	call   *%eax
  800d0a:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d0d:	ff 4d 10             	decl   0x10(%ebp)
  800d10:	eb 03                	jmp    800d15 <vprintfmt+0x3b1>
  800d12:	ff 4d 10             	decl   0x10(%ebp)
  800d15:	8b 45 10             	mov    0x10(%ebp),%eax
  800d18:	48                   	dec    %eax
  800d19:	8a 00                	mov    (%eax),%al
  800d1b:	3c 25                	cmp    $0x25,%al
  800d1d:	75 f3                	jne    800d12 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800d1f:	90                   	nop
		}
	}
  800d20:	e9 47 fc ff ff       	jmp    80096c <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d25:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d26:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d29:	5b                   	pop    %ebx
  800d2a:	5e                   	pop    %esi
  800d2b:	5d                   	pop    %ebp
  800d2c:	c3                   	ret    

00800d2d <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d2d:	55                   	push   %ebp
  800d2e:	89 e5                	mov    %esp,%ebp
  800d30:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d33:	8d 45 10             	lea    0x10(%ebp),%eax
  800d36:	83 c0 04             	add    $0x4,%eax
  800d39:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d3c:	8b 45 10             	mov    0x10(%ebp),%eax
  800d3f:	ff 75 f4             	pushl  -0xc(%ebp)
  800d42:	50                   	push   %eax
  800d43:	ff 75 0c             	pushl  0xc(%ebp)
  800d46:	ff 75 08             	pushl  0x8(%ebp)
  800d49:	e8 16 fc ff ff       	call   800964 <vprintfmt>
  800d4e:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d51:	90                   	nop
  800d52:	c9                   	leave  
  800d53:	c3                   	ret    

00800d54 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d54:	55                   	push   %ebp
  800d55:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d57:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5a:	8b 40 08             	mov    0x8(%eax),%eax
  800d5d:	8d 50 01             	lea    0x1(%eax),%edx
  800d60:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d63:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d66:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d69:	8b 10                	mov    (%eax),%edx
  800d6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d6e:	8b 40 04             	mov    0x4(%eax),%eax
  800d71:	39 c2                	cmp    %eax,%edx
  800d73:	73 12                	jae    800d87 <sprintputch+0x33>
		*b->buf++ = ch;
  800d75:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d78:	8b 00                	mov    (%eax),%eax
  800d7a:	8d 48 01             	lea    0x1(%eax),%ecx
  800d7d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d80:	89 0a                	mov    %ecx,(%edx)
  800d82:	8b 55 08             	mov    0x8(%ebp),%edx
  800d85:	88 10                	mov    %dl,(%eax)
}
  800d87:	90                   	nop
  800d88:	5d                   	pop    %ebp
  800d89:	c3                   	ret    

00800d8a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d8a:	55                   	push   %ebp
  800d8b:	89 e5                	mov    %esp,%ebp
  800d8d:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d90:	8b 45 08             	mov    0x8(%ebp),%eax
  800d93:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d96:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d99:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9f:	01 d0                	add    %edx,%eax
  800da1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800da4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800dab:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800daf:	74 06                	je     800db7 <vsnprintf+0x2d>
  800db1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800db5:	7f 07                	jg     800dbe <vsnprintf+0x34>
		return -E_INVAL;
  800db7:	b8 03 00 00 00       	mov    $0x3,%eax
  800dbc:	eb 20                	jmp    800dde <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800dbe:	ff 75 14             	pushl  0x14(%ebp)
  800dc1:	ff 75 10             	pushl  0x10(%ebp)
  800dc4:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800dc7:	50                   	push   %eax
  800dc8:	68 54 0d 80 00       	push   $0x800d54
  800dcd:	e8 92 fb ff ff       	call   800964 <vprintfmt>
  800dd2:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800dd5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800dd8:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800ddb:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800dde:	c9                   	leave  
  800ddf:	c3                   	ret    

00800de0 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800de0:	55                   	push   %ebp
  800de1:	89 e5                	mov    %esp,%ebp
  800de3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800de6:	8d 45 10             	lea    0x10(%ebp),%eax
  800de9:	83 c0 04             	add    $0x4,%eax
  800dec:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800def:	8b 45 10             	mov    0x10(%ebp),%eax
  800df2:	ff 75 f4             	pushl  -0xc(%ebp)
  800df5:	50                   	push   %eax
  800df6:	ff 75 0c             	pushl  0xc(%ebp)
  800df9:	ff 75 08             	pushl  0x8(%ebp)
  800dfc:	e8 89 ff ff ff       	call   800d8a <vsnprintf>
  800e01:	83 c4 10             	add    $0x10,%esp
  800e04:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e07:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e0a:	c9                   	leave  
  800e0b:	c3                   	ret    

00800e0c <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800e0c:	55                   	push   %ebp
  800e0d:	89 e5                	mov    %esp,%ebp
  800e0f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e12:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e19:	eb 06                	jmp    800e21 <strlen+0x15>
		n++;
  800e1b:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e1e:	ff 45 08             	incl   0x8(%ebp)
  800e21:	8b 45 08             	mov    0x8(%ebp),%eax
  800e24:	8a 00                	mov    (%eax),%al
  800e26:	84 c0                	test   %al,%al
  800e28:	75 f1                	jne    800e1b <strlen+0xf>
		n++;
	return n;
  800e2a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e2d:	c9                   	leave  
  800e2e:	c3                   	ret    

00800e2f <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e2f:	55                   	push   %ebp
  800e30:	89 e5                	mov    %esp,%ebp
  800e32:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e35:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e3c:	eb 09                	jmp    800e47 <strnlen+0x18>
		n++;
  800e3e:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e41:	ff 45 08             	incl   0x8(%ebp)
  800e44:	ff 4d 0c             	decl   0xc(%ebp)
  800e47:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e4b:	74 09                	je     800e56 <strnlen+0x27>
  800e4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e50:	8a 00                	mov    (%eax),%al
  800e52:	84 c0                	test   %al,%al
  800e54:	75 e8                	jne    800e3e <strnlen+0xf>
		n++;
	return n;
  800e56:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e59:	c9                   	leave  
  800e5a:	c3                   	ret    

00800e5b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e5b:	55                   	push   %ebp
  800e5c:	89 e5                	mov    %esp,%ebp
  800e5e:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e61:	8b 45 08             	mov    0x8(%ebp),%eax
  800e64:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e67:	90                   	nop
  800e68:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6b:	8d 50 01             	lea    0x1(%eax),%edx
  800e6e:	89 55 08             	mov    %edx,0x8(%ebp)
  800e71:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e74:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e77:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e7a:	8a 12                	mov    (%edx),%dl
  800e7c:	88 10                	mov    %dl,(%eax)
  800e7e:	8a 00                	mov    (%eax),%al
  800e80:	84 c0                	test   %al,%al
  800e82:	75 e4                	jne    800e68 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800e84:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e87:	c9                   	leave  
  800e88:	c3                   	ret    

00800e89 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800e89:	55                   	push   %ebp
  800e8a:	89 e5                	mov    %esp,%ebp
  800e8c:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800e8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e92:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800e95:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e9c:	eb 1f                	jmp    800ebd <strncpy+0x34>
		*dst++ = *src;
  800e9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea1:	8d 50 01             	lea    0x1(%eax),%edx
  800ea4:	89 55 08             	mov    %edx,0x8(%ebp)
  800ea7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800eaa:	8a 12                	mov    (%edx),%dl
  800eac:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800eae:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb1:	8a 00                	mov    (%eax),%al
  800eb3:	84 c0                	test   %al,%al
  800eb5:	74 03                	je     800eba <strncpy+0x31>
			src++;
  800eb7:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800eba:	ff 45 fc             	incl   -0x4(%ebp)
  800ebd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ec0:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ec3:	72 d9                	jb     800e9e <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ec5:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ec8:	c9                   	leave  
  800ec9:	c3                   	ret    

00800eca <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800eca:	55                   	push   %ebp
  800ecb:	89 e5                	mov    %esp,%ebp
  800ecd:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800ed0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ed6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eda:	74 30                	je     800f0c <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800edc:	eb 16                	jmp    800ef4 <strlcpy+0x2a>
			*dst++ = *src++;
  800ede:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee1:	8d 50 01             	lea    0x1(%eax),%edx
  800ee4:	89 55 08             	mov    %edx,0x8(%ebp)
  800ee7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800eea:	8d 4a 01             	lea    0x1(%edx),%ecx
  800eed:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ef0:	8a 12                	mov    (%edx),%dl
  800ef2:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ef4:	ff 4d 10             	decl   0x10(%ebp)
  800ef7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800efb:	74 09                	je     800f06 <strlcpy+0x3c>
  800efd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f00:	8a 00                	mov    (%eax),%al
  800f02:	84 c0                	test   %al,%al
  800f04:	75 d8                	jne    800ede <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800f06:	8b 45 08             	mov    0x8(%ebp),%eax
  800f09:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f0c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f0f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f12:	29 c2                	sub    %eax,%edx
  800f14:	89 d0                	mov    %edx,%eax
}
  800f16:	c9                   	leave  
  800f17:	c3                   	ret    

00800f18 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f18:	55                   	push   %ebp
  800f19:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f1b:	eb 06                	jmp    800f23 <strcmp+0xb>
		p++, q++;
  800f1d:	ff 45 08             	incl   0x8(%ebp)
  800f20:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f23:	8b 45 08             	mov    0x8(%ebp),%eax
  800f26:	8a 00                	mov    (%eax),%al
  800f28:	84 c0                	test   %al,%al
  800f2a:	74 0e                	je     800f3a <strcmp+0x22>
  800f2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2f:	8a 10                	mov    (%eax),%dl
  800f31:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f34:	8a 00                	mov    (%eax),%al
  800f36:	38 c2                	cmp    %al,%dl
  800f38:	74 e3                	je     800f1d <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3d:	8a 00                	mov    (%eax),%al
  800f3f:	0f b6 d0             	movzbl %al,%edx
  800f42:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f45:	8a 00                	mov    (%eax),%al
  800f47:	0f b6 c0             	movzbl %al,%eax
  800f4a:	29 c2                	sub    %eax,%edx
  800f4c:	89 d0                	mov    %edx,%eax
}
  800f4e:	5d                   	pop    %ebp
  800f4f:	c3                   	ret    

00800f50 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f50:	55                   	push   %ebp
  800f51:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f53:	eb 09                	jmp    800f5e <strncmp+0xe>
		n--, p++, q++;
  800f55:	ff 4d 10             	decl   0x10(%ebp)
  800f58:	ff 45 08             	incl   0x8(%ebp)
  800f5b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f5e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f62:	74 17                	je     800f7b <strncmp+0x2b>
  800f64:	8b 45 08             	mov    0x8(%ebp),%eax
  800f67:	8a 00                	mov    (%eax),%al
  800f69:	84 c0                	test   %al,%al
  800f6b:	74 0e                	je     800f7b <strncmp+0x2b>
  800f6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f70:	8a 10                	mov    (%eax),%dl
  800f72:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f75:	8a 00                	mov    (%eax),%al
  800f77:	38 c2                	cmp    %al,%dl
  800f79:	74 da                	je     800f55 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f7b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f7f:	75 07                	jne    800f88 <strncmp+0x38>
		return 0;
  800f81:	b8 00 00 00 00       	mov    $0x0,%eax
  800f86:	eb 14                	jmp    800f9c <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800f88:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8b:	8a 00                	mov    (%eax),%al
  800f8d:	0f b6 d0             	movzbl %al,%edx
  800f90:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f93:	8a 00                	mov    (%eax),%al
  800f95:	0f b6 c0             	movzbl %al,%eax
  800f98:	29 c2                	sub    %eax,%edx
  800f9a:	89 d0                	mov    %edx,%eax
}
  800f9c:	5d                   	pop    %ebp
  800f9d:	c3                   	ret    

00800f9e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800f9e:	55                   	push   %ebp
  800f9f:	89 e5                	mov    %esp,%ebp
  800fa1:	83 ec 04             	sub    $0x4,%esp
  800fa4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa7:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800faa:	eb 12                	jmp    800fbe <strchr+0x20>
		if (*s == c)
  800fac:	8b 45 08             	mov    0x8(%ebp),%eax
  800faf:	8a 00                	mov    (%eax),%al
  800fb1:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fb4:	75 05                	jne    800fbb <strchr+0x1d>
			return (char *) s;
  800fb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb9:	eb 11                	jmp    800fcc <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800fbb:	ff 45 08             	incl   0x8(%ebp)
  800fbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc1:	8a 00                	mov    (%eax),%al
  800fc3:	84 c0                	test   %al,%al
  800fc5:	75 e5                	jne    800fac <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800fc7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fcc:	c9                   	leave  
  800fcd:	c3                   	ret    

00800fce <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800fce:	55                   	push   %ebp
  800fcf:	89 e5                	mov    %esp,%ebp
  800fd1:	83 ec 04             	sub    $0x4,%esp
  800fd4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd7:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fda:	eb 0d                	jmp    800fe9 <strfind+0x1b>
		if (*s == c)
  800fdc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdf:	8a 00                	mov    (%eax),%al
  800fe1:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fe4:	74 0e                	je     800ff4 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800fe6:	ff 45 08             	incl   0x8(%ebp)
  800fe9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fec:	8a 00                	mov    (%eax),%al
  800fee:	84 c0                	test   %al,%al
  800ff0:	75 ea                	jne    800fdc <strfind+0xe>
  800ff2:	eb 01                	jmp    800ff5 <strfind+0x27>
		if (*s == c)
			break;
  800ff4:	90                   	nop
	return (char *) s;
  800ff5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ff8:	c9                   	leave  
  800ff9:	c3                   	ret    

00800ffa <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800ffa:	55                   	push   %ebp
  800ffb:	89 e5                	mov    %esp,%ebp
  800ffd:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801000:	8b 45 08             	mov    0x8(%ebp),%eax
  801003:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801006:	8b 45 10             	mov    0x10(%ebp),%eax
  801009:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  80100c:	eb 0e                	jmp    80101c <memset+0x22>
		*p++ = c;
  80100e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801011:	8d 50 01             	lea    0x1(%eax),%edx
  801014:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801017:	8b 55 0c             	mov    0xc(%ebp),%edx
  80101a:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  80101c:	ff 4d f8             	decl   -0x8(%ebp)
  80101f:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801023:	79 e9                	jns    80100e <memset+0x14>
		*p++ = c;

	return v;
  801025:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801028:	c9                   	leave  
  801029:	c3                   	ret    

0080102a <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80102a:	55                   	push   %ebp
  80102b:	89 e5                	mov    %esp,%ebp
  80102d:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801030:	8b 45 0c             	mov    0xc(%ebp),%eax
  801033:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801036:	8b 45 08             	mov    0x8(%ebp),%eax
  801039:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  80103c:	eb 16                	jmp    801054 <memcpy+0x2a>
		*d++ = *s++;
  80103e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801041:	8d 50 01             	lea    0x1(%eax),%edx
  801044:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801047:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80104a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80104d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801050:	8a 12                	mov    (%edx),%dl
  801052:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801054:	8b 45 10             	mov    0x10(%ebp),%eax
  801057:	8d 50 ff             	lea    -0x1(%eax),%edx
  80105a:	89 55 10             	mov    %edx,0x10(%ebp)
  80105d:	85 c0                	test   %eax,%eax
  80105f:	75 dd                	jne    80103e <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801061:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801064:	c9                   	leave  
  801065:	c3                   	ret    

00801066 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801066:	55                   	push   %ebp
  801067:	89 e5                	mov    %esp,%ebp
  801069:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80106c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80106f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801072:	8b 45 08             	mov    0x8(%ebp),%eax
  801075:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801078:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80107b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80107e:	73 50                	jae    8010d0 <memmove+0x6a>
  801080:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801083:	8b 45 10             	mov    0x10(%ebp),%eax
  801086:	01 d0                	add    %edx,%eax
  801088:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80108b:	76 43                	jbe    8010d0 <memmove+0x6a>
		s += n;
  80108d:	8b 45 10             	mov    0x10(%ebp),%eax
  801090:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801093:	8b 45 10             	mov    0x10(%ebp),%eax
  801096:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801099:	eb 10                	jmp    8010ab <memmove+0x45>
			*--d = *--s;
  80109b:	ff 4d f8             	decl   -0x8(%ebp)
  80109e:	ff 4d fc             	decl   -0x4(%ebp)
  8010a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010a4:	8a 10                	mov    (%eax),%dl
  8010a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010a9:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8010ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ae:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010b1:	89 55 10             	mov    %edx,0x10(%ebp)
  8010b4:	85 c0                	test   %eax,%eax
  8010b6:	75 e3                	jne    80109b <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8010b8:	eb 23                	jmp    8010dd <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8010ba:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010bd:	8d 50 01             	lea    0x1(%eax),%edx
  8010c0:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010c3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010c6:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010c9:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8010cc:	8a 12                	mov    (%edx),%dl
  8010ce:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8010d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8010d3:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010d6:	89 55 10             	mov    %edx,0x10(%ebp)
  8010d9:	85 c0                	test   %eax,%eax
  8010db:	75 dd                	jne    8010ba <memmove+0x54>
			*d++ = *s++;

	return dst;
  8010dd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010e0:	c9                   	leave  
  8010e1:	c3                   	ret    

008010e2 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8010e2:	55                   	push   %ebp
  8010e3:	89 e5                	mov    %esp,%ebp
  8010e5:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8010e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010eb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8010ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f1:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8010f4:	eb 2a                	jmp    801120 <memcmp+0x3e>
		if (*s1 != *s2)
  8010f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010f9:	8a 10                	mov    (%eax),%dl
  8010fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010fe:	8a 00                	mov    (%eax),%al
  801100:	38 c2                	cmp    %al,%dl
  801102:	74 16                	je     80111a <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801104:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801107:	8a 00                	mov    (%eax),%al
  801109:	0f b6 d0             	movzbl %al,%edx
  80110c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80110f:	8a 00                	mov    (%eax),%al
  801111:	0f b6 c0             	movzbl %al,%eax
  801114:	29 c2                	sub    %eax,%edx
  801116:	89 d0                	mov    %edx,%eax
  801118:	eb 18                	jmp    801132 <memcmp+0x50>
		s1++, s2++;
  80111a:	ff 45 fc             	incl   -0x4(%ebp)
  80111d:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801120:	8b 45 10             	mov    0x10(%ebp),%eax
  801123:	8d 50 ff             	lea    -0x1(%eax),%edx
  801126:	89 55 10             	mov    %edx,0x10(%ebp)
  801129:	85 c0                	test   %eax,%eax
  80112b:	75 c9                	jne    8010f6 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80112d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801132:	c9                   	leave  
  801133:	c3                   	ret    

00801134 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801134:	55                   	push   %ebp
  801135:	89 e5                	mov    %esp,%ebp
  801137:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80113a:	8b 55 08             	mov    0x8(%ebp),%edx
  80113d:	8b 45 10             	mov    0x10(%ebp),%eax
  801140:	01 d0                	add    %edx,%eax
  801142:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801145:	eb 15                	jmp    80115c <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801147:	8b 45 08             	mov    0x8(%ebp),%eax
  80114a:	8a 00                	mov    (%eax),%al
  80114c:	0f b6 d0             	movzbl %al,%edx
  80114f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801152:	0f b6 c0             	movzbl %al,%eax
  801155:	39 c2                	cmp    %eax,%edx
  801157:	74 0d                	je     801166 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801159:	ff 45 08             	incl   0x8(%ebp)
  80115c:	8b 45 08             	mov    0x8(%ebp),%eax
  80115f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801162:	72 e3                	jb     801147 <memfind+0x13>
  801164:	eb 01                	jmp    801167 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801166:	90                   	nop
	return (void *) s;
  801167:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80116a:	c9                   	leave  
  80116b:	c3                   	ret    

0080116c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80116c:	55                   	push   %ebp
  80116d:	89 e5                	mov    %esp,%ebp
  80116f:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801172:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801179:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801180:	eb 03                	jmp    801185 <strtol+0x19>
		s++;
  801182:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801185:	8b 45 08             	mov    0x8(%ebp),%eax
  801188:	8a 00                	mov    (%eax),%al
  80118a:	3c 20                	cmp    $0x20,%al
  80118c:	74 f4                	je     801182 <strtol+0x16>
  80118e:	8b 45 08             	mov    0x8(%ebp),%eax
  801191:	8a 00                	mov    (%eax),%al
  801193:	3c 09                	cmp    $0x9,%al
  801195:	74 eb                	je     801182 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801197:	8b 45 08             	mov    0x8(%ebp),%eax
  80119a:	8a 00                	mov    (%eax),%al
  80119c:	3c 2b                	cmp    $0x2b,%al
  80119e:	75 05                	jne    8011a5 <strtol+0x39>
		s++;
  8011a0:	ff 45 08             	incl   0x8(%ebp)
  8011a3:	eb 13                	jmp    8011b8 <strtol+0x4c>
	else if (*s == '-')
  8011a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a8:	8a 00                	mov    (%eax),%al
  8011aa:	3c 2d                	cmp    $0x2d,%al
  8011ac:	75 0a                	jne    8011b8 <strtol+0x4c>
		s++, neg = 1;
  8011ae:	ff 45 08             	incl   0x8(%ebp)
  8011b1:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8011b8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011bc:	74 06                	je     8011c4 <strtol+0x58>
  8011be:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8011c2:	75 20                	jne    8011e4 <strtol+0x78>
  8011c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c7:	8a 00                	mov    (%eax),%al
  8011c9:	3c 30                	cmp    $0x30,%al
  8011cb:	75 17                	jne    8011e4 <strtol+0x78>
  8011cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d0:	40                   	inc    %eax
  8011d1:	8a 00                	mov    (%eax),%al
  8011d3:	3c 78                	cmp    $0x78,%al
  8011d5:	75 0d                	jne    8011e4 <strtol+0x78>
		s += 2, base = 16;
  8011d7:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8011db:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8011e2:	eb 28                	jmp    80120c <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8011e4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011e8:	75 15                	jne    8011ff <strtol+0x93>
  8011ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ed:	8a 00                	mov    (%eax),%al
  8011ef:	3c 30                	cmp    $0x30,%al
  8011f1:	75 0c                	jne    8011ff <strtol+0x93>
		s++, base = 8;
  8011f3:	ff 45 08             	incl   0x8(%ebp)
  8011f6:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8011fd:	eb 0d                	jmp    80120c <strtol+0xa0>
	else if (base == 0)
  8011ff:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801203:	75 07                	jne    80120c <strtol+0xa0>
		base = 10;
  801205:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80120c:	8b 45 08             	mov    0x8(%ebp),%eax
  80120f:	8a 00                	mov    (%eax),%al
  801211:	3c 2f                	cmp    $0x2f,%al
  801213:	7e 19                	jle    80122e <strtol+0xc2>
  801215:	8b 45 08             	mov    0x8(%ebp),%eax
  801218:	8a 00                	mov    (%eax),%al
  80121a:	3c 39                	cmp    $0x39,%al
  80121c:	7f 10                	jg     80122e <strtol+0xc2>
			dig = *s - '0';
  80121e:	8b 45 08             	mov    0x8(%ebp),%eax
  801221:	8a 00                	mov    (%eax),%al
  801223:	0f be c0             	movsbl %al,%eax
  801226:	83 e8 30             	sub    $0x30,%eax
  801229:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80122c:	eb 42                	jmp    801270 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80122e:	8b 45 08             	mov    0x8(%ebp),%eax
  801231:	8a 00                	mov    (%eax),%al
  801233:	3c 60                	cmp    $0x60,%al
  801235:	7e 19                	jle    801250 <strtol+0xe4>
  801237:	8b 45 08             	mov    0x8(%ebp),%eax
  80123a:	8a 00                	mov    (%eax),%al
  80123c:	3c 7a                	cmp    $0x7a,%al
  80123e:	7f 10                	jg     801250 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801240:	8b 45 08             	mov    0x8(%ebp),%eax
  801243:	8a 00                	mov    (%eax),%al
  801245:	0f be c0             	movsbl %al,%eax
  801248:	83 e8 57             	sub    $0x57,%eax
  80124b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80124e:	eb 20                	jmp    801270 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801250:	8b 45 08             	mov    0x8(%ebp),%eax
  801253:	8a 00                	mov    (%eax),%al
  801255:	3c 40                	cmp    $0x40,%al
  801257:	7e 39                	jle    801292 <strtol+0x126>
  801259:	8b 45 08             	mov    0x8(%ebp),%eax
  80125c:	8a 00                	mov    (%eax),%al
  80125e:	3c 5a                	cmp    $0x5a,%al
  801260:	7f 30                	jg     801292 <strtol+0x126>
			dig = *s - 'A' + 10;
  801262:	8b 45 08             	mov    0x8(%ebp),%eax
  801265:	8a 00                	mov    (%eax),%al
  801267:	0f be c0             	movsbl %al,%eax
  80126a:	83 e8 37             	sub    $0x37,%eax
  80126d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801270:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801273:	3b 45 10             	cmp    0x10(%ebp),%eax
  801276:	7d 19                	jge    801291 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801278:	ff 45 08             	incl   0x8(%ebp)
  80127b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80127e:	0f af 45 10          	imul   0x10(%ebp),%eax
  801282:	89 c2                	mov    %eax,%edx
  801284:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801287:	01 d0                	add    %edx,%eax
  801289:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80128c:	e9 7b ff ff ff       	jmp    80120c <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801291:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801292:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801296:	74 08                	je     8012a0 <strtol+0x134>
		*endptr = (char *) s;
  801298:	8b 45 0c             	mov    0xc(%ebp),%eax
  80129b:	8b 55 08             	mov    0x8(%ebp),%edx
  80129e:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8012a0:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8012a4:	74 07                	je     8012ad <strtol+0x141>
  8012a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012a9:	f7 d8                	neg    %eax
  8012ab:	eb 03                	jmp    8012b0 <strtol+0x144>
  8012ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8012b0:	c9                   	leave  
  8012b1:	c3                   	ret    

008012b2 <ltostr>:

void
ltostr(long value, char *str)
{
  8012b2:	55                   	push   %ebp
  8012b3:	89 e5                	mov    %esp,%ebp
  8012b5:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8012b8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8012bf:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8012c6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012ca:	79 13                	jns    8012df <ltostr+0x2d>
	{
		neg = 1;
  8012cc:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8012d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012d6:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8012d9:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8012dc:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8012df:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e2:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8012e7:	99                   	cltd   
  8012e8:	f7 f9                	idiv   %ecx
  8012ea:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8012ed:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012f0:	8d 50 01             	lea    0x1(%eax),%edx
  8012f3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012f6:	89 c2                	mov    %eax,%edx
  8012f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012fb:	01 d0                	add    %edx,%eax
  8012fd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801300:	83 c2 30             	add    $0x30,%edx
  801303:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801305:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801308:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80130d:	f7 e9                	imul   %ecx
  80130f:	c1 fa 02             	sar    $0x2,%edx
  801312:	89 c8                	mov    %ecx,%eax
  801314:	c1 f8 1f             	sar    $0x1f,%eax
  801317:	29 c2                	sub    %eax,%edx
  801319:	89 d0                	mov    %edx,%eax
  80131b:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80131e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801321:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801326:	f7 e9                	imul   %ecx
  801328:	c1 fa 02             	sar    $0x2,%edx
  80132b:	89 c8                	mov    %ecx,%eax
  80132d:	c1 f8 1f             	sar    $0x1f,%eax
  801330:	29 c2                	sub    %eax,%edx
  801332:	89 d0                	mov    %edx,%eax
  801334:	c1 e0 02             	shl    $0x2,%eax
  801337:	01 d0                	add    %edx,%eax
  801339:	01 c0                	add    %eax,%eax
  80133b:	29 c1                	sub    %eax,%ecx
  80133d:	89 ca                	mov    %ecx,%edx
  80133f:	85 d2                	test   %edx,%edx
  801341:	75 9c                	jne    8012df <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801343:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80134a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80134d:	48                   	dec    %eax
  80134e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801351:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801355:	74 3d                	je     801394 <ltostr+0xe2>
		start = 1 ;
  801357:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80135e:	eb 34                	jmp    801394 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801360:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801363:	8b 45 0c             	mov    0xc(%ebp),%eax
  801366:	01 d0                	add    %edx,%eax
  801368:	8a 00                	mov    (%eax),%al
  80136a:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80136d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801370:	8b 45 0c             	mov    0xc(%ebp),%eax
  801373:	01 c2                	add    %eax,%edx
  801375:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801378:	8b 45 0c             	mov    0xc(%ebp),%eax
  80137b:	01 c8                	add    %ecx,%eax
  80137d:	8a 00                	mov    (%eax),%al
  80137f:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801381:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801384:	8b 45 0c             	mov    0xc(%ebp),%eax
  801387:	01 c2                	add    %eax,%edx
  801389:	8a 45 eb             	mov    -0x15(%ebp),%al
  80138c:	88 02                	mov    %al,(%edx)
		start++ ;
  80138e:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801391:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801394:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801397:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80139a:	7c c4                	jl     801360 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80139c:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80139f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013a2:	01 d0                	add    %edx,%eax
  8013a4:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8013a7:	90                   	nop
  8013a8:	c9                   	leave  
  8013a9:	c3                   	ret    

008013aa <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8013aa:	55                   	push   %ebp
  8013ab:	89 e5                	mov    %esp,%ebp
  8013ad:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8013b0:	ff 75 08             	pushl  0x8(%ebp)
  8013b3:	e8 54 fa ff ff       	call   800e0c <strlen>
  8013b8:	83 c4 04             	add    $0x4,%esp
  8013bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8013be:	ff 75 0c             	pushl  0xc(%ebp)
  8013c1:	e8 46 fa ff ff       	call   800e0c <strlen>
  8013c6:	83 c4 04             	add    $0x4,%esp
  8013c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8013cc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8013d3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013da:	eb 17                	jmp    8013f3 <strcconcat+0x49>
		final[s] = str1[s] ;
  8013dc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013df:	8b 45 10             	mov    0x10(%ebp),%eax
  8013e2:	01 c2                	add    %eax,%edx
  8013e4:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8013e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ea:	01 c8                	add    %ecx,%eax
  8013ec:	8a 00                	mov    (%eax),%al
  8013ee:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8013f0:	ff 45 fc             	incl   -0x4(%ebp)
  8013f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013f6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8013f9:	7c e1                	jl     8013dc <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8013fb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801402:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801409:	eb 1f                	jmp    80142a <strcconcat+0x80>
		final[s++] = str2[i] ;
  80140b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80140e:	8d 50 01             	lea    0x1(%eax),%edx
  801411:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801414:	89 c2                	mov    %eax,%edx
  801416:	8b 45 10             	mov    0x10(%ebp),%eax
  801419:	01 c2                	add    %eax,%edx
  80141b:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80141e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801421:	01 c8                	add    %ecx,%eax
  801423:	8a 00                	mov    (%eax),%al
  801425:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801427:	ff 45 f8             	incl   -0x8(%ebp)
  80142a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80142d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801430:	7c d9                	jl     80140b <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801432:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801435:	8b 45 10             	mov    0x10(%ebp),%eax
  801438:	01 d0                	add    %edx,%eax
  80143a:	c6 00 00             	movb   $0x0,(%eax)
}
  80143d:	90                   	nop
  80143e:	c9                   	leave  
  80143f:	c3                   	ret    

00801440 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801440:	55                   	push   %ebp
  801441:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801443:	8b 45 14             	mov    0x14(%ebp),%eax
  801446:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80144c:	8b 45 14             	mov    0x14(%ebp),%eax
  80144f:	8b 00                	mov    (%eax),%eax
  801451:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801458:	8b 45 10             	mov    0x10(%ebp),%eax
  80145b:	01 d0                	add    %edx,%eax
  80145d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801463:	eb 0c                	jmp    801471 <strsplit+0x31>
			*string++ = 0;
  801465:	8b 45 08             	mov    0x8(%ebp),%eax
  801468:	8d 50 01             	lea    0x1(%eax),%edx
  80146b:	89 55 08             	mov    %edx,0x8(%ebp)
  80146e:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801471:	8b 45 08             	mov    0x8(%ebp),%eax
  801474:	8a 00                	mov    (%eax),%al
  801476:	84 c0                	test   %al,%al
  801478:	74 18                	je     801492 <strsplit+0x52>
  80147a:	8b 45 08             	mov    0x8(%ebp),%eax
  80147d:	8a 00                	mov    (%eax),%al
  80147f:	0f be c0             	movsbl %al,%eax
  801482:	50                   	push   %eax
  801483:	ff 75 0c             	pushl  0xc(%ebp)
  801486:	e8 13 fb ff ff       	call   800f9e <strchr>
  80148b:	83 c4 08             	add    $0x8,%esp
  80148e:	85 c0                	test   %eax,%eax
  801490:	75 d3                	jne    801465 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801492:	8b 45 08             	mov    0x8(%ebp),%eax
  801495:	8a 00                	mov    (%eax),%al
  801497:	84 c0                	test   %al,%al
  801499:	74 5a                	je     8014f5 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80149b:	8b 45 14             	mov    0x14(%ebp),%eax
  80149e:	8b 00                	mov    (%eax),%eax
  8014a0:	83 f8 0f             	cmp    $0xf,%eax
  8014a3:	75 07                	jne    8014ac <strsplit+0x6c>
		{
			return 0;
  8014a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8014aa:	eb 66                	jmp    801512 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8014ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8014af:	8b 00                	mov    (%eax),%eax
  8014b1:	8d 48 01             	lea    0x1(%eax),%ecx
  8014b4:	8b 55 14             	mov    0x14(%ebp),%edx
  8014b7:	89 0a                	mov    %ecx,(%edx)
  8014b9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8014c3:	01 c2                	add    %eax,%edx
  8014c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c8:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014ca:	eb 03                	jmp    8014cf <strsplit+0x8f>
			string++;
  8014cc:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d2:	8a 00                	mov    (%eax),%al
  8014d4:	84 c0                	test   %al,%al
  8014d6:	74 8b                	je     801463 <strsplit+0x23>
  8014d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014db:	8a 00                	mov    (%eax),%al
  8014dd:	0f be c0             	movsbl %al,%eax
  8014e0:	50                   	push   %eax
  8014e1:	ff 75 0c             	pushl  0xc(%ebp)
  8014e4:	e8 b5 fa ff ff       	call   800f9e <strchr>
  8014e9:	83 c4 08             	add    $0x8,%esp
  8014ec:	85 c0                	test   %eax,%eax
  8014ee:	74 dc                	je     8014cc <strsplit+0x8c>
			string++;
	}
  8014f0:	e9 6e ff ff ff       	jmp    801463 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8014f5:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8014f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8014f9:	8b 00                	mov    (%eax),%eax
  8014fb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801502:	8b 45 10             	mov    0x10(%ebp),%eax
  801505:	01 d0                	add    %edx,%eax
  801507:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80150d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801512:	c9                   	leave  
  801513:	c3                   	ret    

00801514 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801514:	55                   	push   %ebp
  801515:	89 e5                	mov    %esp,%ebp
  801517:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  80151a:	a1 04 50 80 00       	mov    0x805004,%eax
  80151f:	85 c0                	test   %eax,%eax
  801521:	74 1f                	je     801542 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801523:	e8 1d 00 00 00       	call   801545 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801528:	83 ec 0c             	sub    $0xc,%esp
  80152b:	68 b0 3f 80 00       	push   $0x803fb0
  801530:	e8 55 f2 ff ff       	call   80078a <cprintf>
  801535:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801538:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  80153f:	00 00 00 
	}
}
  801542:	90                   	nop
  801543:	c9                   	leave  
  801544:	c3                   	ret    

00801545 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801545:	55                   	push   %ebp
  801546:	89 e5                	mov    %esp,%ebp
  801548:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	LIST_INIT(&AllocMemBlocksList);
  80154b:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801552:	00 00 00 
  801555:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  80155c:	00 00 00 
  80155f:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801566:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801569:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801570:	00 00 00 
  801573:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  80157a:	00 00 00 
  80157d:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801584:	00 00 00 
	uint32 arr_size = 0;
  801587:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	MemBlockNodes  =(struct MemBlock*) USER_DYN_BLKS_ARRAY;
  80158e:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  801595:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801598:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80159d:	2d 00 10 00 00       	sub    $0x1000,%eax
  8015a2:	a3 50 50 80 00       	mov    %eax,0x805050
	MAX_MEM_BLOCK_CNT = (USER_HEAP_MAX-USER_HEAP_START)/PAGE_SIZE;
  8015a7:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  8015ae:	00 02 00 
	arr_size =  ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock), PAGE_SIZE);
  8015b1:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8015b8:	a1 20 51 80 00       	mov    0x805120,%eax
  8015bd:	c1 e0 04             	shl    $0x4,%eax
  8015c0:	89 c2                	mov    %eax,%edx
  8015c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015c5:	01 d0                	add    %edx,%eax
  8015c7:	48                   	dec    %eax
  8015c8:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8015cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8015d3:	f7 75 ec             	divl   -0x14(%ebp)
  8015d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015d9:	29 d0                	sub    %edx,%eax
  8015db:	89 45 f4             	mov    %eax,-0xc(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY , arr_size , PERM_WRITEABLE | PERM_USER);
  8015de:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  8015e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8015e8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8015ed:	2d 00 10 00 00       	sub    $0x1000,%eax
  8015f2:	83 ec 04             	sub    $0x4,%esp
  8015f5:	6a 06                	push   $0x6
  8015f7:	ff 75 f4             	pushl  -0xc(%ebp)
  8015fa:	50                   	push   %eax
  8015fb:	e8 b5 03 00 00       	call   8019b5 <sys_allocate_chunk>
  801600:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801603:	a1 20 51 80 00       	mov    0x805120,%eax
  801608:	83 ec 0c             	sub    $0xc,%esp
  80160b:	50                   	push   %eax
  80160c:	e8 2a 0a 00 00       	call   80203b <initialize_MemBlocksList>
  801611:	83 c4 10             	add    $0x10,%esp
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	struct MemBlock * NewBlock = LIST_FIRST(&AvailableMemBlocksList);
  801614:	a1 48 51 80 00       	mov    0x805148,%eax
  801619:	89 45 e0             	mov    %eax,-0x20(%ebp)
	NewBlock->sva = USER_HEAP_START;
  80161c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80161f:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	NewBlock->size = (USER_HEAP_MAX-USER_HEAP_START);
  801626:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801629:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	LIST_REMOVE(&AvailableMemBlocksList,NewBlock);
  801630:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801634:	75 14                	jne    80164a <initialize_dyn_block_system+0x105>
  801636:	83 ec 04             	sub    $0x4,%esp
  801639:	68 d5 3f 80 00       	push   $0x803fd5
  80163e:	6a 33                	push   $0x33
  801640:	68 f3 3f 80 00       	push   $0x803ff3
  801645:	e8 8c ee ff ff       	call   8004d6 <_panic>
  80164a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80164d:	8b 00                	mov    (%eax),%eax
  80164f:	85 c0                	test   %eax,%eax
  801651:	74 10                	je     801663 <initialize_dyn_block_system+0x11e>
  801653:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801656:	8b 00                	mov    (%eax),%eax
  801658:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80165b:	8b 52 04             	mov    0x4(%edx),%edx
  80165e:	89 50 04             	mov    %edx,0x4(%eax)
  801661:	eb 0b                	jmp    80166e <initialize_dyn_block_system+0x129>
  801663:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801666:	8b 40 04             	mov    0x4(%eax),%eax
  801669:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80166e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801671:	8b 40 04             	mov    0x4(%eax),%eax
  801674:	85 c0                	test   %eax,%eax
  801676:	74 0f                	je     801687 <initialize_dyn_block_system+0x142>
  801678:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80167b:	8b 40 04             	mov    0x4(%eax),%eax
  80167e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801681:	8b 12                	mov    (%edx),%edx
  801683:	89 10                	mov    %edx,(%eax)
  801685:	eb 0a                	jmp    801691 <initialize_dyn_block_system+0x14c>
  801687:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80168a:	8b 00                	mov    (%eax),%eax
  80168c:	a3 48 51 80 00       	mov    %eax,0x805148
  801691:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801694:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80169a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80169d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8016a4:	a1 54 51 80 00       	mov    0x805154,%eax
  8016a9:	48                   	dec    %eax
  8016aa:	a3 54 51 80 00       	mov    %eax,0x805154
	LIST_INSERT_HEAD(&FreeMemBlocksList, NewBlock);
  8016af:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8016b3:	75 14                	jne    8016c9 <initialize_dyn_block_system+0x184>
  8016b5:	83 ec 04             	sub    $0x4,%esp
  8016b8:	68 00 40 80 00       	push   $0x804000
  8016bd:	6a 34                	push   $0x34
  8016bf:	68 f3 3f 80 00       	push   $0x803ff3
  8016c4:	e8 0d ee ff ff       	call   8004d6 <_panic>
  8016c9:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8016cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016d2:	89 10                	mov    %edx,(%eax)
  8016d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016d7:	8b 00                	mov    (%eax),%eax
  8016d9:	85 c0                	test   %eax,%eax
  8016db:	74 0d                	je     8016ea <initialize_dyn_block_system+0x1a5>
  8016dd:	a1 38 51 80 00       	mov    0x805138,%eax
  8016e2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8016e5:	89 50 04             	mov    %edx,0x4(%eax)
  8016e8:	eb 08                	jmp    8016f2 <initialize_dyn_block_system+0x1ad>
  8016ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016ed:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8016f2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016f5:	a3 38 51 80 00       	mov    %eax,0x805138
  8016fa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016fd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801704:	a1 44 51 80 00       	mov    0x805144,%eax
  801709:	40                   	inc    %eax
  80170a:	a3 44 51 80 00       	mov    %eax,0x805144
}
  80170f:	90                   	nop
  801710:	c9                   	leave  
  801711:	c3                   	ret    

00801712 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801712:	55                   	push   %ebp
  801713:	89 e5                	mov    %esp,%ebp
  801715:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801718:	e8 f7 fd ff ff       	call   801514 <InitializeUHeap>
	if (size == 0) return NULL ;
  80171d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801721:	75 07                	jne    80172a <malloc+0x18>
  801723:	b8 00 00 00 00       	mov    $0x0,%eax
  801728:	eb 14                	jmp    80173e <malloc+0x2c>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  80172a:	83 ec 04             	sub    $0x4,%esp
  80172d:	68 24 40 80 00       	push   $0x804024
  801732:	6a 46                	push   $0x46
  801734:	68 f3 3f 80 00       	push   $0x803ff3
  801739:	e8 98 ed ff ff       	call   8004d6 <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  80173e:	c9                   	leave  
  80173f:	c3                   	ret    

00801740 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801740:	55                   	push   %ebp
  801741:	89 e5                	mov    %esp,%ebp
  801743:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801746:	83 ec 04             	sub    $0x4,%esp
  801749:	68 4c 40 80 00       	push   $0x80404c
  80174e:	6a 61                	push   $0x61
  801750:	68 f3 3f 80 00       	push   $0x803ff3
  801755:	e8 7c ed ff ff       	call   8004d6 <_panic>

0080175a <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80175a:	55                   	push   %ebp
  80175b:	89 e5                	mov    %esp,%ebp
  80175d:	83 ec 18             	sub    $0x18,%esp
  801760:	8b 45 10             	mov    0x10(%ebp),%eax
  801763:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801766:	e8 a9 fd ff ff       	call   801514 <InitializeUHeap>
	if (size == 0) return NULL ;
  80176b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80176f:	75 07                	jne    801778 <smalloc+0x1e>
  801771:	b8 00 00 00 00       	mov    $0x0,%eax
  801776:	eb 14                	jmp    80178c <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  801778:	83 ec 04             	sub    $0x4,%esp
  80177b:	68 70 40 80 00       	push   $0x804070
  801780:	6a 76                	push   $0x76
  801782:	68 f3 3f 80 00       	push   $0x803ff3
  801787:	e8 4a ed ff ff       	call   8004d6 <_panic>

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80178c:	c9                   	leave  
  80178d:	c3                   	ret    

0080178e <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80178e:	55                   	push   %ebp
  80178f:	89 e5                	mov    %esp,%ebp
  801791:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801794:	e8 7b fd ff ff       	call   801514 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801799:	83 ec 04             	sub    $0x4,%esp
  80179c:	68 98 40 80 00       	push   $0x804098
  8017a1:	68 93 00 00 00       	push   $0x93
  8017a6:	68 f3 3f 80 00       	push   $0x803ff3
  8017ab:	e8 26 ed ff ff       	call   8004d6 <_panic>

008017b0 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8017b0:	55                   	push   %ebp
  8017b1:	89 e5                	mov    %esp,%ebp
  8017b3:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8017b6:	e8 59 fd ff ff       	call   801514 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8017bb:	83 ec 04             	sub    $0x4,%esp
  8017be:	68 bc 40 80 00       	push   $0x8040bc
  8017c3:	68 c5 00 00 00       	push   $0xc5
  8017c8:	68 f3 3f 80 00       	push   $0x803ff3
  8017cd:	e8 04 ed ff ff       	call   8004d6 <_panic>

008017d2 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8017d2:	55                   	push   %ebp
  8017d3:	89 e5                	mov    %esp,%ebp
  8017d5:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8017d8:	83 ec 04             	sub    $0x4,%esp
  8017db:	68 e4 40 80 00       	push   $0x8040e4
  8017e0:	68 d9 00 00 00       	push   $0xd9
  8017e5:	68 f3 3f 80 00       	push   $0x803ff3
  8017ea:	e8 e7 ec ff ff       	call   8004d6 <_panic>

008017ef <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8017ef:	55                   	push   %ebp
  8017f0:	89 e5                	mov    %esp,%ebp
  8017f2:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017f5:	83 ec 04             	sub    $0x4,%esp
  8017f8:	68 08 41 80 00       	push   $0x804108
  8017fd:	68 e4 00 00 00       	push   $0xe4
  801802:	68 f3 3f 80 00       	push   $0x803ff3
  801807:	e8 ca ec ff ff       	call   8004d6 <_panic>

0080180c <shrink>:

}
void shrink(uint32 newSize)
{
  80180c:	55                   	push   %ebp
  80180d:	89 e5                	mov    %esp,%ebp
  80180f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801812:	83 ec 04             	sub    $0x4,%esp
  801815:	68 08 41 80 00       	push   $0x804108
  80181a:	68 e9 00 00 00       	push   $0xe9
  80181f:	68 f3 3f 80 00       	push   $0x803ff3
  801824:	e8 ad ec ff ff       	call   8004d6 <_panic>

00801829 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801829:	55                   	push   %ebp
  80182a:	89 e5                	mov    %esp,%ebp
  80182c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80182f:	83 ec 04             	sub    $0x4,%esp
  801832:	68 08 41 80 00       	push   $0x804108
  801837:	68 ee 00 00 00       	push   $0xee
  80183c:	68 f3 3f 80 00       	push   $0x803ff3
  801841:	e8 90 ec ff ff       	call   8004d6 <_panic>

00801846 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801846:	55                   	push   %ebp
  801847:	89 e5                	mov    %esp,%ebp
  801849:	57                   	push   %edi
  80184a:	56                   	push   %esi
  80184b:	53                   	push   %ebx
  80184c:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80184f:	8b 45 08             	mov    0x8(%ebp),%eax
  801852:	8b 55 0c             	mov    0xc(%ebp),%edx
  801855:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801858:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80185b:	8b 7d 18             	mov    0x18(%ebp),%edi
  80185e:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801861:	cd 30                	int    $0x30
  801863:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801866:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801869:	83 c4 10             	add    $0x10,%esp
  80186c:	5b                   	pop    %ebx
  80186d:	5e                   	pop    %esi
  80186e:	5f                   	pop    %edi
  80186f:	5d                   	pop    %ebp
  801870:	c3                   	ret    

00801871 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801871:	55                   	push   %ebp
  801872:	89 e5                	mov    %esp,%ebp
  801874:	83 ec 04             	sub    $0x4,%esp
  801877:	8b 45 10             	mov    0x10(%ebp),%eax
  80187a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80187d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801881:	8b 45 08             	mov    0x8(%ebp),%eax
  801884:	6a 00                	push   $0x0
  801886:	6a 00                	push   $0x0
  801888:	52                   	push   %edx
  801889:	ff 75 0c             	pushl  0xc(%ebp)
  80188c:	50                   	push   %eax
  80188d:	6a 00                	push   $0x0
  80188f:	e8 b2 ff ff ff       	call   801846 <syscall>
  801894:	83 c4 18             	add    $0x18,%esp
}
  801897:	90                   	nop
  801898:	c9                   	leave  
  801899:	c3                   	ret    

0080189a <sys_cgetc>:

int
sys_cgetc(void)
{
  80189a:	55                   	push   %ebp
  80189b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80189d:	6a 00                	push   $0x0
  80189f:	6a 00                	push   $0x0
  8018a1:	6a 00                	push   $0x0
  8018a3:	6a 00                	push   $0x0
  8018a5:	6a 00                	push   $0x0
  8018a7:	6a 01                	push   $0x1
  8018a9:	e8 98 ff ff ff       	call   801846 <syscall>
  8018ae:	83 c4 18             	add    $0x18,%esp
}
  8018b1:	c9                   	leave  
  8018b2:	c3                   	ret    

008018b3 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8018b3:	55                   	push   %ebp
  8018b4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8018b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018bc:	6a 00                	push   $0x0
  8018be:	6a 00                	push   $0x0
  8018c0:	6a 00                	push   $0x0
  8018c2:	52                   	push   %edx
  8018c3:	50                   	push   %eax
  8018c4:	6a 05                	push   $0x5
  8018c6:	e8 7b ff ff ff       	call   801846 <syscall>
  8018cb:	83 c4 18             	add    $0x18,%esp
}
  8018ce:	c9                   	leave  
  8018cf:	c3                   	ret    

008018d0 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8018d0:	55                   	push   %ebp
  8018d1:	89 e5                	mov    %esp,%ebp
  8018d3:	56                   	push   %esi
  8018d4:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8018d5:	8b 75 18             	mov    0x18(%ebp),%esi
  8018d8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018db:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018de:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e4:	56                   	push   %esi
  8018e5:	53                   	push   %ebx
  8018e6:	51                   	push   %ecx
  8018e7:	52                   	push   %edx
  8018e8:	50                   	push   %eax
  8018e9:	6a 06                	push   $0x6
  8018eb:	e8 56 ff ff ff       	call   801846 <syscall>
  8018f0:	83 c4 18             	add    $0x18,%esp
}
  8018f3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018f6:	5b                   	pop    %ebx
  8018f7:	5e                   	pop    %esi
  8018f8:	5d                   	pop    %ebp
  8018f9:	c3                   	ret    

008018fa <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8018fa:	55                   	push   %ebp
  8018fb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8018fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801900:	8b 45 08             	mov    0x8(%ebp),%eax
  801903:	6a 00                	push   $0x0
  801905:	6a 00                	push   $0x0
  801907:	6a 00                	push   $0x0
  801909:	52                   	push   %edx
  80190a:	50                   	push   %eax
  80190b:	6a 07                	push   $0x7
  80190d:	e8 34 ff ff ff       	call   801846 <syscall>
  801912:	83 c4 18             	add    $0x18,%esp
}
  801915:	c9                   	leave  
  801916:	c3                   	ret    

00801917 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801917:	55                   	push   %ebp
  801918:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80191a:	6a 00                	push   $0x0
  80191c:	6a 00                	push   $0x0
  80191e:	6a 00                	push   $0x0
  801920:	ff 75 0c             	pushl  0xc(%ebp)
  801923:	ff 75 08             	pushl  0x8(%ebp)
  801926:	6a 08                	push   $0x8
  801928:	e8 19 ff ff ff       	call   801846 <syscall>
  80192d:	83 c4 18             	add    $0x18,%esp
}
  801930:	c9                   	leave  
  801931:	c3                   	ret    

00801932 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801932:	55                   	push   %ebp
  801933:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801935:	6a 00                	push   $0x0
  801937:	6a 00                	push   $0x0
  801939:	6a 00                	push   $0x0
  80193b:	6a 00                	push   $0x0
  80193d:	6a 00                	push   $0x0
  80193f:	6a 09                	push   $0x9
  801941:	e8 00 ff ff ff       	call   801846 <syscall>
  801946:	83 c4 18             	add    $0x18,%esp
}
  801949:	c9                   	leave  
  80194a:	c3                   	ret    

0080194b <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80194b:	55                   	push   %ebp
  80194c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80194e:	6a 00                	push   $0x0
  801950:	6a 00                	push   $0x0
  801952:	6a 00                	push   $0x0
  801954:	6a 00                	push   $0x0
  801956:	6a 00                	push   $0x0
  801958:	6a 0a                	push   $0xa
  80195a:	e8 e7 fe ff ff       	call   801846 <syscall>
  80195f:	83 c4 18             	add    $0x18,%esp
}
  801962:	c9                   	leave  
  801963:	c3                   	ret    

00801964 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801964:	55                   	push   %ebp
  801965:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801967:	6a 00                	push   $0x0
  801969:	6a 00                	push   $0x0
  80196b:	6a 00                	push   $0x0
  80196d:	6a 00                	push   $0x0
  80196f:	6a 00                	push   $0x0
  801971:	6a 0b                	push   $0xb
  801973:	e8 ce fe ff ff       	call   801846 <syscall>
  801978:	83 c4 18             	add    $0x18,%esp
}
  80197b:	c9                   	leave  
  80197c:	c3                   	ret    

0080197d <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80197d:	55                   	push   %ebp
  80197e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801980:	6a 00                	push   $0x0
  801982:	6a 00                	push   $0x0
  801984:	6a 00                	push   $0x0
  801986:	ff 75 0c             	pushl  0xc(%ebp)
  801989:	ff 75 08             	pushl  0x8(%ebp)
  80198c:	6a 0f                	push   $0xf
  80198e:	e8 b3 fe ff ff       	call   801846 <syscall>
  801993:	83 c4 18             	add    $0x18,%esp
	return;
  801996:	90                   	nop
}
  801997:	c9                   	leave  
  801998:	c3                   	ret    

00801999 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801999:	55                   	push   %ebp
  80199a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80199c:	6a 00                	push   $0x0
  80199e:	6a 00                	push   $0x0
  8019a0:	6a 00                	push   $0x0
  8019a2:	ff 75 0c             	pushl  0xc(%ebp)
  8019a5:	ff 75 08             	pushl  0x8(%ebp)
  8019a8:	6a 10                	push   $0x10
  8019aa:	e8 97 fe ff ff       	call   801846 <syscall>
  8019af:	83 c4 18             	add    $0x18,%esp
	return ;
  8019b2:	90                   	nop
}
  8019b3:	c9                   	leave  
  8019b4:	c3                   	ret    

008019b5 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8019b5:	55                   	push   %ebp
  8019b6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8019b8:	6a 00                	push   $0x0
  8019ba:	6a 00                	push   $0x0
  8019bc:	ff 75 10             	pushl  0x10(%ebp)
  8019bf:	ff 75 0c             	pushl  0xc(%ebp)
  8019c2:	ff 75 08             	pushl  0x8(%ebp)
  8019c5:	6a 11                	push   $0x11
  8019c7:	e8 7a fe ff ff       	call   801846 <syscall>
  8019cc:	83 c4 18             	add    $0x18,%esp
	return ;
  8019cf:	90                   	nop
}
  8019d0:	c9                   	leave  
  8019d1:	c3                   	ret    

008019d2 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8019d2:	55                   	push   %ebp
  8019d3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8019d5:	6a 00                	push   $0x0
  8019d7:	6a 00                	push   $0x0
  8019d9:	6a 00                	push   $0x0
  8019db:	6a 00                	push   $0x0
  8019dd:	6a 00                	push   $0x0
  8019df:	6a 0c                	push   $0xc
  8019e1:	e8 60 fe ff ff       	call   801846 <syscall>
  8019e6:	83 c4 18             	add    $0x18,%esp
}
  8019e9:	c9                   	leave  
  8019ea:	c3                   	ret    

008019eb <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8019eb:	55                   	push   %ebp
  8019ec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8019ee:	6a 00                	push   $0x0
  8019f0:	6a 00                	push   $0x0
  8019f2:	6a 00                	push   $0x0
  8019f4:	6a 00                	push   $0x0
  8019f6:	ff 75 08             	pushl  0x8(%ebp)
  8019f9:	6a 0d                	push   $0xd
  8019fb:	e8 46 fe ff ff       	call   801846 <syscall>
  801a00:	83 c4 18             	add    $0x18,%esp
}
  801a03:	c9                   	leave  
  801a04:	c3                   	ret    

00801a05 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801a05:	55                   	push   %ebp
  801a06:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801a08:	6a 00                	push   $0x0
  801a0a:	6a 00                	push   $0x0
  801a0c:	6a 00                	push   $0x0
  801a0e:	6a 00                	push   $0x0
  801a10:	6a 00                	push   $0x0
  801a12:	6a 0e                	push   $0xe
  801a14:	e8 2d fe ff ff       	call   801846 <syscall>
  801a19:	83 c4 18             	add    $0x18,%esp
}
  801a1c:	90                   	nop
  801a1d:	c9                   	leave  
  801a1e:	c3                   	ret    

00801a1f <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801a1f:	55                   	push   %ebp
  801a20:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801a22:	6a 00                	push   $0x0
  801a24:	6a 00                	push   $0x0
  801a26:	6a 00                	push   $0x0
  801a28:	6a 00                	push   $0x0
  801a2a:	6a 00                	push   $0x0
  801a2c:	6a 13                	push   $0x13
  801a2e:	e8 13 fe ff ff       	call   801846 <syscall>
  801a33:	83 c4 18             	add    $0x18,%esp
}
  801a36:	90                   	nop
  801a37:	c9                   	leave  
  801a38:	c3                   	ret    

00801a39 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801a39:	55                   	push   %ebp
  801a3a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801a3c:	6a 00                	push   $0x0
  801a3e:	6a 00                	push   $0x0
  801a40:	6a 00                	push   $0x0
  801a42:	6a 00                	push   $0x0
  801a44:	6a 00                	push   $0x0
  801a46:	6a 14                	push   $0x14
  801a48:	e8 f9 fd ff ff       	call   801846 <syscall>
  801a4d:	83 c4 18             	add    $0x18,%esp
}
  801a50:	90                   	nop
  801a51:	c9                   	leave  
  801a52:	c3                   	ret    

00801a53 <sys_cputc>:


void
sys_cputc(const char c)
{
  801a53:	55                   	push   %ebp
  801a54:	89 e5                	mov    %esp,%ebp
  801a56:	83 ec 04             	sub    $0x4,%esp
  801a59:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801a5f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a63:	6a 00                	push   $0x0
  801a65:	6a 00                	push   $0x0
  801a67:	6a 00                	push   $0x0
  801a69:	6a 00                	push   $0x0
  801a6b:	50                   	push   %eax
  801a6c:	6a 15                	push   $0x15
  801a6e:	e8 d3 fd ff ff       	call   801846 <syscall>
  801a73:	83 c4 18             	add    $0x18,%esp
}
  801a76:	90                   	nop
  801a77:	c9                   	leave  
  801a78:	c3                   	ret    

00801a79 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a79:	55                   	push   %ebp
  801a7a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a7c:	6a 00                	push   $0x0
  801a7e:	6a 00                	push   $0x0
  801a80:	6a 00                	push   $0x0
  801a82:	6a 00                	push   $0x0
  801a84:	6a 00                	push   $0x0
  801a86:	6a 16                	push   $0x16
  801a88:	e8 b9 fd ff ff       	call   801846 <syscall>
  801a8d:	83 c4 18             	add    $0x18,%esp
}
  801a90:	90                   	nop
  801a91:	c9                   	leave  
  801a92:	c3                   	ret    

00801a93 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801a93:	55                   	push   %ebp
  801a94:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801a96:	8b 45 08             	mov    0x8(%ebp),%eax
  801a99:	6a 00                	push   $0x0
  801a9b:	6a 00                	push   $0x0
  801a9d:	6a 00                	push   $0x0
  801a9f:	ff 75 0c             	pushl  0xc(%ebp)
  801aa2:	50                   	push   %eax
  801aa3:	6a 17                	push   $0x17
  801aa5:	e8 9c fd ff ff       	call   801846 <syscall>
  801aaa:	83 c4 18             	add    $0x18,%esp
}
  801aad:	c9                   	leave  
  801aae:	c3                   	ret    

00801aaf <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801aaf:	55                   	push   %ebp
  801ab0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ab2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ab5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab8:	6a 00                	push   $0x0
  801aba:	6a 00                	push   $0x0
  801abc:	6a 00                	push   $0x0
  801abe:	52                   	push   %edx
  801abf:	50                   	push   %eax
  801ac0:	6a 1a                	push   $0x1a
  801ac2:	e8 7f fd ff ff       	call   801846 <syscall>
  801ac7:	83 c4 18             	add    $0x18,%esp
}
  801aca:	c9                   	leave  
  801acb:	c3                   	ret    

00801acc <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801acc:	55                   	push   %ebp
  801acd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801acf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ad2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad5:	6a 00                	push   $0x0
  801ad7:	6a 00                	push   $0x0
  801ad9:	6a 00                	push   $0x0
  801adb:	52                   	push   %edx
  801adc:	50                   	push   %eax
  801add:	6a 18                	push   $0x18
  801adf:	e8 62 fd ff ff       	call   801846 <syscall>
  801ae4:	83 c4 18             	add    $0x18,%esp
}
  801ae7:	90                   	nop
  801ae8:	c9                   	leave  
  801ae9:	c3                   	ret    

00801aea <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801aea:	55                   	push   %ebp
  801aeb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801aed:	8b 55 0c             	mov    0xc(%ebp),%edx
  801af0:	8b 45 08             	mov    0x8(%ebp),%eax
  801af3:	6a 00                	push   $0x0
  801af5:	6a 00                	push   $0x0
  801af7:	6a 00                	push   $0x0
  801af9:	52                   	push   %edx
  801afa:	50                   	push   %eax
  801afb:	6a 19                	push   $0x19
  801afd:	e8 44 fd ff ff       	call   801846 <syscall>
  801b02:	83 c4 18             	add    $0x18,%esp
}
  801b05:	90                   	nop
  801b06:	c9                   	leave  
  801b07:	c3                   	ret    

00801b08 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801b08:	55                   	push   %ebp
  801b09:	89 e5                	mov    %esp,%ebp
  801b0b:	83 ec 04             	sub    $0x4,%esp
  801b0e:	8b 45 10             	mov    0x10(%ebp),%eax
  801b11:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b14:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b17:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b1e:	6a 00                	push   $0x0
  801b20:	51                   	push   %ecx
  801b21:	52                   	push   %edx
  801b22:	ff 75 0c             	pushl  0xc(%ebp)
  801b25:	50                   	push   %eax
  801b26:	6a 1b                	push   $0x1b
  801b28:	e8 19 fd ff ff       	call   801846 <syscall>
  801b2d:	83 c4 18             	add    $0x18,%esp
}
  801b30:	c9                   	leave  
  801b31:	c3                   	ret    

00801b32 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801b32:	55                   	push   %ebp
  801b33:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b35:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b38:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3b:	6a 00                	push   $0x0
  801b3d:	6a 00                	push   $0x0
  801b3f:	6a 00                	push   $0x0
  801b41:	52                   	push   %edx
  801b42:	50                   	push   %eax
  801b43:	6a 1c                	push   $0x1c
  801b45:	e8 fc fc ff ff       	call   801846 <syscall>
  801b4a:	83 c4 18             	add    $0x18,%esp
}
  801b4d:	c9                   	leave  
  801b4e:	c3                   	ret    

00801b4f <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801b4f:	55                   	push   %ebp
  801b50:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801b52:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b55:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b58:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5b:	6a 00                	push   $0x0
  801b5d:	6a 00                	push   $0x0
  801b5f:	51                   	push   %ecx
  801b60:	52                   	push   %edx
  801b61:	50                   	push   %eax
  801b62:	6a 1d                	push   $0x1d
  801b64:	e8 dd fc ff ff       	call   801846 <syscall>
  801b69:	83 c4 18             	add    $0x18,%esp
}
  801b6c:	c9                   	leave  
  801b6d:	c3                   	ret    

00801b6e <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801b6e:	55                   	push   %ebp
  801b6f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b71:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b74:	8b 45 08             	mov    0x8(%ebp),%eax
  801b77:	6a 00                	push   $0x0
  801b79:	6a 00                	push   $0x0
  801b7b:	6a 00                	push   $0x0
  801b7d:	52                   	push   %edx
  801b7e:	50                   	push   %eax
  801b7f:	6a 1e                	push   $0x1e
  801b81:	e8 c0 fc ff ff       	call   801846 <syscall>
  801b86:	83 c4 18             	add    $0x18,%esp
}
  801b89:	c9                   	leave  
  801b8a:	c3                   	ret    

00801b8b <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801b8b:	55                   	push   %ebp
  801b8c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801b8e:	6a 00                	push   $0x0
  801b90:	6a 00                	push   $0x0
  801b92:	6a 00                	push   $0x0
  801b94:	6a 00                	push   $0x0
  801b96:	6a 00                	push   $0x0
  801b98:	6a 1f                	push   $0x1f
  801b9a:	e8 a7 fc ff ff       	call   801846 <syscall>
  801b9f:	83 c4 18             	add    $0x18,%esp
}
  801ba2:	c9                   	leave  
  801ba3:	c3                   	ret    

00801ba4 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801ba4:	55                   	push   %ebp
  801ba5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801ba7:	8b 45 08             	mov    0x8(%ebp),%eax
  801baa:	6a 00                	push   $0x0
  801bac:	ff 75 14             	pushl  0x14(%ebp)
  801baf:	ff 75 10             	pushl  0x10(%ebp)
  801bb2:	ff 75 0c             	pushl  0xc(%ebp)
  801bb5:	50                   	push   %eax
  801bb6:	6a 20                	push   $0x20
  801bb8:	e8 89 fc ff ff       	call   801846 <syscall>
  801bbd:	83 c4 18             	add    $0x18,%esp
}
  801bc0:	c9                   	leave  
  801bc1:	c3                   	ret    

00801bc2 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801bc2:	55                   	push   %ebp
  801bc3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801bc5:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc8:	6a 00                	push   $0x0
  801bca:	6a 00                	push   $0x0
  801bcc:	6a 00                	push   $0x0
  801bce:	6a 00                	push   $0x0
  801bd0:	50                   	push   %eax
  801bd1:	6a 21                	push   $0x21
  801bd3:	e8 6e fc ff ff       	call   801846 <syscall>
  801bd8:	83 c4 18             	add    $0x18,%esp
}
  801bdb:	90                   	nop
  801bdc:	c9                   	leave  
  801bdd:	c3                   	ret    

00801bde <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801bde:	55                   	push   %ebp
  801bdf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801be1:	8b 45 08             	mov    0x8(%ebp),%eax
  801be4:	6a 00                	push   $0x0
  801be6:	6a 00                	push   $0x0
  801be8:	6a 00                	push   $0x0
  801bea:	6a 00                	push   $0x0
  801bec:	50                   	push   %eax
  801bed:	6a 22                	push   $0x22
  801bef:	e8 52 fc ff ff       	call   801846 <syscall>
  801bf4:	83 c4 18             	add    $0x18,%esp
}
  801bf7:	c9                   	leave  
  801bf8:	c3                   	ret    

00801bf9 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801bf9:	55                   	push   %ebp
  801bfa:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801bfc:	6a 00                	push   $0x0
  801bfe:	6a 00                	push   $0x0
  801c00:	6a 00                	push   $0x0
  801c02:	6a 00                	push   $0x0
  801c04:	6a 00                	push   $0x0
  801c06:	6a 02                	push   $0x2
  801c08:	e8 39 fc ff ff       	call   801846 <syscall>
  801c0d:	83 c4 18             	add    $0x18,%esp
}
  801c10:	c9                   	leave  
  801c11:	c3                   	ret    

00801c12 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c12:	55                   	push   %ebp
  801c13:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c15:	6a 00                	push   $0x0
  801c17:	6a 00                	push   $0x0
  801c19:	6a 00                	push   $0x0
  801c1b:	6a 00                	push   $0x0
  801c1d:	6a 00                	push   $0x0
  801c1f:	6a 03                	push   $0x3
  801c21:	e8 20 fc ff ff       	call   801846 <syscall>
  801c26:	83 c4 18             	add    $0x18,%esp
}
  801c29:	c9                   	leave  
  801c2a:	c3                   	ret    

00801c2b <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c2b:	55                   	push   %ebp
  801c2c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c2e:	6a 00                	push   $0x0
  801c30:	6a 00                	push   $0x0
  801c32:	6a 00                	push   $0x0
  801c34:	6a 00                	push   $0x0
  801c36:	6a 00                	push   $0x0
  801c38:	6a 04                	push   $0x4
  801c3a:	e8 07 fc ff ff       	call   801846 <syscall>
  801c3f:	83 c4 18             	add    $0x18,%esp
}
  801c42:	c9                   	leave  
  801c43:	c3                   	ret    

00801c44 <sys_exit_env>:


void sys_exit_env(void)
{
  801c44:	55                   	push   %ebp
  801c45:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801c47:	6a 00                	push   $0x0
  801c49:	6a 00                	push   $0x0
  801c4b:	6a 00                	push   $0x0
  801c4d:	6a 00                	push   $0x0
  801c4f:	6a 00                	push   $0x0
  801c51:	6a 23                	push   $0x23
  801c53:	e8 ee fb ff ff       	call   801846 <syscall>
  801c58:	83 c4 18             	add    $0x18,%esp
}
  801c5b:	90                   	nop
  801c5c:	c9                   	leave  
  801c5d:	c3                   	ret    

00801c5e <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801c5e:	55                   	push   %ebp
  801c5f:	89 e5                	mov    %esp,%ebp
  801c61:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c64:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c67:	8d 50 04             	lea    0x4(%eax),%edx
  801c6a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c6d:	6a 00                	push   $0x0
  801c6f:	6a 00                	push   $0x0
  801c71:	6a 00                	push   $0x0
  801c73:	52                   	push   %edx
  801c74:	50                   	push   %eax
  801c75:	6a 24                	push   $0x24
  801c77:	e8 ca fb ff ff       	call   801846 <syscall>
  801c7c:	83 c4 18             	add    $0x18,%esp
	return result;
  801c7f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c82:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c85:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c88:	89 01                	mov    %eax,(%ecx)
  801c8a:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c8d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c90:	c9                   	leave  
  801c91:	c2 04 00             	ret    $0x4

00801c94 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c94:	55                   	push   %ebp
  801c95:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801c97:	6a 00                	push   $0x0
  801c99:	6a 00                	push   $0x0
  801c9b:	ff 75 10             	pushl  0x10(%ebp)
  801c9e:	ff 75 0c             	pushl  0xc(%ebp)
  801ca1:	ff 75 08             	pushl  0x8(%ebp)
  801ca4:	6a 12                	push   $0x12
  801ca6:	e8 9b fb ff ff       	call   801846 <syscall>
  801cab:	83 c4 18             	add    $0x18,%esp
	return ;
  801cae:	90                   	nop
}
  801caf:	c9                   	leave  
  801cb0:	c3                   	ret    

00801cb1 <sys_rcr2>:
uint32 sys_rcr2()
{
  801cb1:	55                   	push   %ebp
  801cb2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801cb4:	6a 00                	push   $0x0
  801cb6:	6a 00                	push   $0x0
  801cb8:	6a 00                	push   $0x0
  801cba:	6a 00                	push   $0x0
  801cbc:	6a 00                	push   $0x0
  801cbe:	6a 25                	push   $0x25
  801cc0:	e8 81 fb ff ff       	call   801846 <syscall>
  801cc5:	83 c4 18             	add    $0x18,%esp
}
  801cc8:	c9                   	leave  
  801cc9:	c3                   	ret    

00801cca <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801cca:	55                   	push   %ebp
  801ccb:	89 e5                	mov    %esp,%ebp
  801ccd:	83 ec 04             	sub    $0x4,%esp
  801cd0:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801cd6:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801cda:	6a 00                	push   $0x0
  801cdc:	6a 00                	push   $0x0
  801cde:	6a 00                	push   $0x0
  801ce0:	6a 00                	push   $0x0
  801ce2:	50                   	push   %eax
  801ce3:	6a 26                	push   $0x26
  801ce5:	e8 5c fb ff ff       	call   801846 <syscall>
  801cea:	83 c4 18             	add    $0x18,%esp
	return ;
  801ced:	90                   	nop
}
  801cee:	c9                   	leave  
  801cef:	c3                   	ret    

00801cf0 <rsttst>:
void rsttst()
{
  801cf0:	55                   	push   %ebp
  801cf1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801cf3:	6a 00                	push   $0x0
  801cf5:	6a 00                	push   $0x0
  801cf7:	6a 00                	push   $0x0
  801cf9:	6a 00                	push   $0x0
  801cfb:	6a 00                	push   $0x0
  801cfd:	6a 28                	push   $0x28
  801cff:	e8 42 fb ff ff       	call   801846 <syscall>
  801d04:	83 c4 18             	add    $0x18,%esp
	return ;
  801d07:	90                   	nop
}
  801d08:	c9                   	leave  
  801d09:	c3                   	ret    

00801d0a <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d0a:	55                   	push   %ebp
  801d0b:	89 e5                	mov    %esp,%ebp
  801d0d:	83 ec 04             	sub    $0x4,%esp
  801d10:	8b 45 14             	mov    0x14(%ebp),%eax
  801d13:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d16:	8b 55 18             	mov    0x18(%ebp),%edx
  801d19:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d1d:	52                   	push   %edx
  801d1e:	50                   	push   %eax
  801d1f:	ff 75 10             	pushl  0x10(%ebp)
  801d22:	ff 75 0c             	pushl  0xc(%ebp)
  801d25:	ff 75 08             	pushl  0x8(%ebp)
  801d28:	6a 27                	push   $0x27
  801d2a:	e8 17 fb ff ff       	call   801846 <syscall>
  801d2f:	83 c4 18             	add    $0x18,%esp
	return ;
  801d32:	90                   	nop
}
  801d33:	c9                   	leave  
  801d34:	c3                   	ret    

00801d35 <chktst>:
void chktst(uint32 n)
{
  801d35:	55                   	push   %ebp
  801d36:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d38:	6a 00                	push   $0x0
  801d3a:	6a 00                	push   $0x0
  801d3c:	6a 00                	push   $0x0
  801d3e:	6a 00                	push   $0x0
  801d40:	ff 75 08             	pushl  0x8(%ebp)
  801d43:	6a 29                	push   $0x29
  801d45:	e8 fc fa ff ff       	call   801846 <syscall>
  801d4a:	83 c4 18             	add    $0x18,%esp
	return ;
  801d4d:	90                   	nop
}
  801d4e:	c9                   	leave  
  801d4f:	c3                   	ret    

00801d50 <inctst>:

void inctst()
{
  801d50:	55                   	push   %ebp
  801d51:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d53:	6a 00                	push   $0x0
  801d55:	6a 00                	push   $0x0
  801d57:	6a 00                	push   $0x0
  801d59:	6a 00                	push   $0x0
  801d5b:	6a 00                	push   $0x0
  801d5d:	6a 2a                	push   $0x2a
  801d5f:	e8 e2 fa ff ff       	call   801846 <syscall>
  801d64:	83 c4 18             	add    $0x18,%esp
	return ;
  801d67:	90                   	nop
}
  801d68:	c9                   	leave  
  801d69:	c3                   	ret    

00801d6a <gettst>:
uint32 gettst()
{
  801d6a:	55                   	push   %ebp
  801d6b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d6d:	6a 00                	push   $0x0
  801d6f:	6a 00                	push   $0x0
  801d71:	6a 00                	push   $0x0
  801d73:	6a 00                	push   $0x0
  801d75:	6a 00                	push   $0x0
  801d77:	6a 2b                	push   $0x2b
  801d79:	e8 c8 fa ff ff       	call   801846 <syscall>
  801d7e:	83 c4 18             	add    $0x18,%esp
}
  801d81:	c9                   	leave  
  801d82:	c3                   	ret    

00801d83 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d83:	55                   	push   %ebp
  801d84:	89 e5                	mov    %esp,%ebp
  801d86:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d89:	6a 00                	push   $0x0
  801d8b:	6a 00                	push   $0x0
  801d8d:	6a 00                	push   $0x0
  801d8f:	6a 00                	push   $0x0
  801d91:	6a 00                	push   $0x0
  801d93:	6a 2c                	push   $0x2c
  801d95:	e8 ac fa ff ff       	call   801846 <syscall>
  801d9a:	83 c4 18             	add    $0x18,%esp
  801d9d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801da0:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801da4:	75 07                	jne    801dad <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801da6:	b8 01 00 00 00       	mov    $0x1,%eax
  801dab:	eb 05                	jmp    801db2 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801dad:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801db2:	c9                   	leave  
  801db3:	c3                   	ret    

00801db4 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801db4:	55                   	push   %ebp
  801db5:	89 e5                	mov    %esp,%ebp
  801db7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dba:	6a 00                	push   $0x0
  801dbc:	6a 00                	push   $0x0
  801dbe:	6a 00                	push   $0x0
  801dc0:	6a 00                	push   $0x0
  801dc2:	6a 00                	push   $0x0
  801dc4:	6a 2c                	push   $0x2c
  801dc6:	e8 7b fa ff ff       	call   801846 <syscall>
  801dcb:	83 c4 18             	add    $0x18,%esp
  801dce:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801dd1:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801dd5:	75 07                	jne    801dde <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801dd7:	b8 01 00 00 00       	mov    $0x1,%eax
  801ddc:	eb 05                	jmp    801de3 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801dde:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801de3:	c9                   	leave  
  801de4:	c3                   	ret    

00801de5 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801de5:	55                   	push   %ebp
  801de6:	89 e5                	mov    %esp,%ebp
  801de8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801deb:	6a 00                	push   $0x0
  801ded:	6a 00                	push   $0x0
  801def:	6a 00                	push   $0x0
  801df1:	6a 00                	push   $0x0
  801df3:	6a 00                	push   $0x0
  801df5:	6a 2c                	push   $0x2c
  801df7:	e8 4a fa ff ff       	call   801846 <syscall>
  801dfc:	83 c4 18             	add    $0x18,%esp
  801dff:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801e02:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801e06:	75 07                	jne    801e0f <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801e08:	b8 01 00 00 00       	mov    $0x1,%eax
  801e0d:	eb 05                	jmp    801e14 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801e0f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e14:	c9                   	leave  
  801e15:	c3                   	ret    

00801e16 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801e16:	55                   	push   %ebp
  801e17:	89 e5                	mov    %esp,%ebp
  801e19:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e1c:	6a 00                	push   $0x0
  801e1e:	6a 00                	push   $0x0
  801e20:	6a 00                	push   $0x0
  801e22:	6a 00                	push   $0x0
  801e24:	6a 00                	push   $0x0
  801e26:	6a 2c                	push   $0x2c
  801e28:	e8 19 fa ff ff       	call   801846 <syscall>
  801e2d:	83 c4 18             	add    $0x18,%esp
  801e30:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801e33:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801e37:	75 07                	jne    801e40 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801e39:	b8 01 00 00 00       	mov    $0x1,%eax
  801e3e:	eb 05                	jmp    801e45 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801e40:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e45:	c9                   	leave  
  801e46:	c3                   	ret    

00801e47 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801e47:	55                   	push   %ebp
  801e48:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e4a:	6a 00                	push   $0x0
  801e4c:	6a 00                	push   $0x0
  801e4e:	6a 00                	push   $0x0
  801e50:	6a 00                	push   $0x0
  801e52:	ff 75 08             	pushl  0x8(%ebp)
  801e55:	6a 2d                	push   $0x2d
  801e57:	e8 ea f9 ff ff       	call   801846 <syscall>
  801e5c:	83 c4 18             	add    $0x18,%esp
	return ;
  801e5f:	90                   	nop
}
  801e60:	c9                   	leave  
  801e61:	c3                   	ret    

00801e62 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e62:	55                   	push   %ebp
  801e63:	89 e5                	mov    %esp,%ebp
  801e65:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e66:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e69:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e6c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e72:	6a 00                	push   $0x0
  801e74:	53                   	push   %ebx
  801e75:	51                   	push   %ecx
  801e76:	52                   	push   %edx
  801e77:	50                   	push   %eax
  801e78:	6a 2e                	push   $0x2e
  801e7a:	e8 c7 f9 ff ff       	call   801846 <syscall>
  801e7f:	83 c4 18             	add    $0x18,%esp
}
  801e82:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e85:	c9                   	leave  
  801e86:	c3                   	ret    

00801e87 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e87:	55                   	push   %ebp
  801e88:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e8a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e8d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e90:	6a 00                	push   $0x0
  801e92:	6a 00                	push   $0x0
  801e94:	6a 00                	push   $0x0
  801e96:	52                   	push   %edx
  801e97:	50                   	push   %eax
  801e98:	6a 2f                	push   $0x2f
  801e9a:	e8 a7 f9 ff ff       	call   801846 <syscall>
  801e9f:	83 c4 18             	add    $0x18,%esp
}
  801ea2:	c9                   	leave  
  801ea3:	c3                   	ret    

00801ea4 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801ea4:	55                   	push   %ebp
  801ea5:	89 e5                	mov    %esp,%ebp
  801ea7:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801eaa:	83 ec 0c             	sub    $0xc,%esp
  801ead:	68 18 41 80 00       	push   $0x804118
  801eb2:	e8 d3 e8 ff ff       	call   80078a <cprintf>
  801eb7:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801eba:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801ec1:	83 ec 0c             	sub    $0xc,%esp
  801ec4:	68 44 41 80 00       	push   $0x804144
  801ec9:	e8 bc e8 ff ff       	call   80078a <cprintf>
  801ece:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801ed1:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801ed5:	a1 38 51 80 00       	mov    0x805138,%eax
  801eda:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801edd:	eb 56                	jmp    801f35 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801edf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801ee3:	74 1c                	je     801f01 <print_mem_block_lists+0x5d>
  801ee5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ee8:	8b 50 08             	mov    0x8(%eax),%edx
  801eeb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801eee:	8b 48 08             	mov    0x8(%eax),%ecx
  801ef1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ef4:	8b 40 0c             	mov    0xc(%eax),%eax
  801ef7:	01 c8                	add    %ecx,%eax
  801ef9:	39 c2                	cmp    %eax,%edx
  801efb:	73 04                	jae    801f01 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801efd:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f04:	8b 50 08             	mov    0x8(%eax),%edx
  801f07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f0a:	8b 40 0c             	mov    0xc(%eax),%eax
  801f0d:	01 c2                	add    %eax,%edx
  801f0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f12:	8b 40 08             	mov    0x8(%eax),%eax
  801f15:	83 ec 04             	sub    $0x4,%esp
  801f18:	52                   	push   %edx
  801f19:	50                   	push   %eax
  801f1a:	68 59 41 80 00       	push   $0x804159
  801f1f:	e8 66 e8 ff ff       	call   80078a <cprintf>
  801f24:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f2a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f2d:	a1 40 51 80 00       	mov    0x805140,%eax
  801f32:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f35:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f39:	74 07                	je     801f42 <print_mem_block_lists+0x9e>
  801f3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f3e:	8b 00                	mov    (%eax),%eax
  801f40:	eb 05                	jmp    801f47 <print_mem_block_lists+0xa3>
  801f42:	b8 00 00 00 00       	mov    $0x0,%eax
  801f47:	a3 40 51 80 00       	mov    %eax,0x805140
  801f4c:	a1 40 51 80 00       	mov    0x805140,%eax
  801f51:	85 c0                	test   %eax,%eax
  801f53:	75 8a                	jne    801edf <print_mem_block_lists+0x3b>
  801f55:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f59:	75 84                	jne    801edf <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801f5b:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f5f:	75 10                	jne    801f71 <print_mem_block_lists+0xcd>
  801f61:	83 ec 0c             	sub    $0xc,%esp
  801f64:	68 68 41 80 00       	push   $0x804168
  801f69:	e8 1c e8 ff ff       	call   80078a <cprintf>
  801f6e:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801f71:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801f78:	83 ec 0c             	sub    $0xc,%esp
  801f7b:	68 8c 41 80 00       	push   $0x80418c
  801f80:	e8 05 e8 ff ff       	call   80078a <cprintf>
  801f85:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801f88:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f8c:	a1 40 50 80 00       	mov    0x805040,%eax
  801f91:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f94:	eb 56                	jmp    801fec <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f96:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f9a:	74 1c                	je     801fb8 <print_mem_block_lists+0x114>
  801f9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f9f:	8b 50 08             	mov    0x8(%eax),%edx
  801fa2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fa5:	8b 48 08             	mov    0x8(%eax),%ecx
  801fa8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fab:	8b 40 0c             	mov    0xc(%eax),%eax
  801fae:	01 c8                	add    %ecx,%eax
  801fb0:	39 c2                	cmp    %eax,%edx
  801fb2:	73 04                	jae    801fb8 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801fb4:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801fb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fbb:	8b 50 08             	mov    0x8(%eax),%edx
  801fbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fc1:	8b 40 0c             	mov    0xc(%eax),%eax
  801fc4:	01 c2                	add    %eax,%edx
  801fc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fc9:	8b 40 08             	mov    0x8(%eax),%eax
  801fcc:	83 ec 04             	sub    $0x4,%esp
  801fcf:	52                   	push   %edx
  801fd0:	50                   	push   %eax
  801fd1:	68 59 41 80 00       	push   $0x804159
  801fd6:	e8 af e7 ff ff       	call   80078a <cprintf>
  801fdb:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801fde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fe1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801fe4:	a1 48 50 80 00       	mov    0x805048,%eax
  801fe9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ff0:	74 07                	je     801ff9 <print_mem_block_lists+0x155>
  801ff2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ff5:	8b 00                	mov    (%eax),%eax
  801ff7:	eb 05                	jmp    801ffe <print_mem_block_lists+0x15a>
  801ff9:	b8 00 00 00 00       	mov    $0x0,%eax
  801ffe:	a3 48 50 80 00       	mov    %eax,0x805048
  802003:	a1 48 50 80 00       	mov    0x805048,%eax
  802008:	85 c0                	test   %eax,%eax
  80200a:	75 8a                	jne    801f96 <print_mem_block_lists+0xf2>
  80200c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802010:	75 84                	jne    801f96 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802012:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802016:	75 10                	jne    802028 <print_mem_block_lists+0x184>
  802018:	83 ec 0c             	sub    $0xc,%esp
  80201b:	68 a4 41 80 00       	push   $0x8041a4
  802020:	e8 65 e7 ff ff       	call   80078a <cprintf>
  802025:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802028:	83 ec 0c             	sub    $0xc,%esp
  80202b:	68 18 41 80 00       	push   $0x804118
  802030:	e8 55 e7 ff ff       	call   80078a <cprintf>
  802035:	83 c4 10             	add    $0x10,%esp

}
  802038:	90                   	nop
  802039:	c9                   	leave  
  80203a:	c3                   	ret    

0080203b <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  80203b:	55                   	push   %ebp
  80203c:	89 e5                	mov    %esp,%ebp
  80203e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  802041:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802048:	00 00 00 
  80204b:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802052:	00 00 00 
  802055:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  80205c:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  80205f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802066:	e9 9e 00 00 00       	jmp    802109 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  80206b:	a1 50 50 80 00       	mov    0x805050,%eax
  802070:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802073:	c1 e2 04             	shl    $0x4,%edx
  802076:	01 d0                	add    %edx,%eax
  802078:	85 c0                	test   %eax,%eax
  80207a:	75 14                	jne    802090 <initialize_MemBlocksList+0x55>
  80207c:	83 ec 04             	sub    $0x4,%esp
  80207f:	68 cc 41 80 00       	push   $0x8041cc
  802084:	6a 46                	push   $0x46
  802086:	68 ef 41 80 00       	push   $0x8041ef
  80208b:	e8 46 e4 ff ff       	call   8004d6 <_panic>
  802090:	a1 50 50 80 00       	mov    0x805050,%eax
  802095:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802098:	c1 e2 04             	shl    $0x4,%edx
  80209b:	01 d0                	add    %edx,%eax
  80209d:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8020a3:	89 10                	mov    %edx,(%eax)
  8020a5:	8b 00                	mov    (%eax),%eax
  8020a7:	85 c0                	test   %eax,%eax
  8020a9:	74 18                	je     8020c3 <initialize_MemBlocksList+0x88>
  8020ab:	a1 48 51 80 00       	mov    0x805148,%eax
  8020b0:	8b 15 50 50 80 00    	mov    0x805050,%edx
  8020b6:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8020b9:	c1 e1 04             	shl    $0x4,%ecx
  8020bc:	01 ca                	add    %ecx,%edx
  8020be:	89 50 04             	mov    %edx,0x4(%eax)
  8020c1:	eb 12                	jmp    8020d5 <initialize_MemBlocksList+0x9a>
  8020c3:	a1 50 50 80 00       	mov    0x805050,%eax
  8020c8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020cb:	c1 e2 04             	shl    $0x4,%edx
  8020ce:	01 d0                	add    %edx,%eax
  8020d0:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8020d5:	a1 50 50 80 00       	mov    0x805050,%eax
  8020da:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020dd:	c1 e2 04             	shl    $0x4,%edx
  8020e0:	01 d0                	add    %edx,%eax
  8020e2:	a3 48 51 80 00       	mov    %eax,0x805148
  8020e7:	a1 50 50 80 00       	mov    0x805050,%eax
  8020ec:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020ef:	c1 e2 04             	shl    $0x4,%edx
  8020f2:	01 d0                	add    %edx,%eax
  8020f4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020fb:	a1 54 51 80 00       	mov    0x805154,%eax
  802100:	40                   	inc    %eax
  802101:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  802106:	ff 45 f4             	incl   -0xc(%ebp)
  802109:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80210c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80210f:	0f 82 56 ff ff ff    	jb     80206b <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  802115:	90                   	nop
  802116:	c9                   	leave  
  802117:	c3                   	ret    

00802118 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802118:	55                   	push   %ebp
  802119:	89 e5                	mov    %esp,%ebp
  80211b:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  80211e:	8b 45 08             	mov    0x8(%ebp),%eax
  802121:	8b 00                	mov    (%eax),%eax
  802123:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802126:	eb 19                	jmp    802141 <find_block+0x29>
	{
		if(va==point->sva)
  802128:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80212b:	8b 40 08             	mov    0x8(%eax),%eax
  80212e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802131:	75 05                	jne    802138 <find_block+0x20>
		   return point;
  802133:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802136:	eb 36                	jmp    80216e <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802138:	8b 45 08             	mov    0x8(%ebp),%eax
  80213b:	8b 40 08             	mov    0x8(%eax),%eax
  80213e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802141:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802145:	74 07                	je     80214e <find_block+0x36>
  802147:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80214a:	8b 00                	mov    (%eax),%eax
  80214c:	eb 05                	jmp    802153 <find_block+0x3b>
  80214e:	b8 00 00 00 00       	mov    $0x0,%eax
  802153:	8b 55 08             	mov    0x8(%ebp),%edx
  802156:	89 42 08             	mov    %eax,0x8(%edx)
  802159:	8b 45 08             	mov    0x8(%ebp),%eax
  80215c:	8b 40 08             	mov    0x8(%eax),%eax
  80215f:	85 c0                	test   %eax,%eax
  802161:	75 c5                	jne    802128 <find_block+0x10>
  802163:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802167:	75 bf                	jne    802128 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802169:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80216e:	c9                   	leave  
  80216f:	c3                   	ret    

00802170 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802170:	55                   	push   %ebp
  802171:	89 e5                	mov    %esp,%ebp
  802173:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  802176:	a1 40 50 80 00       	mov    0x805040,%eax
  80217b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  80217e:	a1 44 50 80 00       	mov    0x805044,%eax
  802183:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  802186:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802189:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80218c:	74 24                	je     8021b2 <insert_sorted_allocList+0x42>
  80218e:	8b 45 08             	mov    0x8(%ebp),%eax
  802191:	8b 50 08             	mov    0x8(%eax),%edx
  802194:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802197:	8b 40 08             	mov    0x8(%eax),%eax
  80219a:	39 c2                	cmp    %eax,%edx
  80219c:	76 14                	jbe    8021b2 <insert_sorted_allocList+0x42>
  80219e:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a1:	8b 50 08             	mov    0x8(%eax),%edx
  8021a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021a7:	8b 40 08             	mov    0x8(%eax),%eax
  8021aa:	39 c2                	cmp    %eax,%edx
  8021ac:	0f 82 60 01 00 00    	jb     802312 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  8021b2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8021b6:	75 65                	jne    80221d <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  8021b8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021bc:	75 14                	jne    8021d2 <insert_sorted_allocList+0x62>
  8021be:	83 ec 04             	sub    $0x4,%esp
  8021c1:	68 cc 41 80 00       	push   $0x8041cc
  8021c6:	6a 6b                	push   $0x6b
  8021c8:	68 ef 41 80 00       	push   $0x8041ef
  8021cd:	e8 04 e3 ff ff       	call   8004d6 <_panic>
  8021d2:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8021d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021db:	89 10                	mov    %edx,(%eax)
  8021dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e0:	8b 00                	mov    (%eax),%eax
  8021e2:	85 c0                	test   %eax,%eax
  8021e4:	74 0d                	je     8021f3 <insert_sorted_allocList+0x83>
  8021e6:	a1 40 50 80 00       	mov    0x805040,%eax
  8021eb:	8b 55 08             	mov    0x8(%ebp),%edx
  8021ee:	89 50 04             	mov    %edx,0x4(%eax)
  8021f1:	eb 08                	jmp    8021fb <insert_sorted_allocList+0x8b>
  8021f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f6:	a3 44 50 80 00       	mov    %eax,0x805044
  8021fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fe:	a3 40 50 80 00       	mov    %eax,0x805040
  802203:	8b 45 08             	mov    0x8(%ebp),%eax
  802206:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80220d:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802212:	40                   	inc    %eax
  802213:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802218:	e9 dc 01 00 00       	jmp    8023f9 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  80221d:	8b 45 08             	mov    0x8(%ebp),%eax
  802220:	8b 50 08             	mov    0x8(%eax),%edx
  802223:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802226:	8b 40 08             	mov    0x8(%eax),%eax
  802229:	39 c2                	cmp    %eax,%edx
  80222b:	77 6c                	ja     802299 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  80222d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802231:	74 06                	je     802239 <insert_sorted_allocList+0xc9>
  802233:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802237:	75 14                	jne    80224d <insert_sorted_allocList+0xdd>
  802239:	83 ec 04             	sub    $0x4,%esp
  80223c:	68 08 42 80 00       	push   $0x804208
  802241:	6a 6f                	push   $0x6f
  802243:	68 ef 41 80 00       	push   $0x8041ef
  802248:	e8 89 e2 ff ff       	call   8004d6 <_panic>
  80224d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802250:	8b 50 04             	mov    0x4(%eax),%edx
  802253:	8b 45 08             	mov    0x8(%ebp),%eax
  802256:	89 50 04             	mov    %edx,0x4(%eax)
  802259:	8b 45 08             	mov    0x8(%ebp),%eax
  80225c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80225f:	89 10                	mov    %edx,(%eax)
  802261:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802264:	8b 40 04             	mov    0x4(%eax),%eax
  802267:	85 c0                	test   %eax,%eax
  802269:	74 0d                	je     802278 <insert_sorted_allocList+0x108>
  80226b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80226e:	8b 40 04             	mov    0x4(%eax),%eax
  802271:	8b 55 08             	mov    0x8(%ebp),%edx
  802274:	89 10                	mov    %edx,(%eax)
  802276:	eb 08                	jmp    802280 <insert_sorted_allocList+0x110>
  802278:	8b 45 08             	mov    0x8(%ebp),%eax
  80227b:	a3 40 50 80 00       	mov    %eax,0x805040
  802280:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802283:	8b 55 08             	mov    0x8(%ebp),%edx
  802286:	89 50 04             	mov    %edx,0x4(%eax)
  802289:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80228e:	40                   	inc    %eax
  80228f:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802294:	e9 60 01 00 00       	jmp    8023f9 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802299:	8b 45 08             	mov    0x8(%ebp),%eax
  80229c:	8b 50 08             	mov    0x8(%eax),%edx
  80229f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022a2:	8b 40 08             	mov    0x8(%eax),%eax
  8022a5:	39 c2                	cmp    %eax,%edx
  8022a7:	0f 82 4c 01 00 00    	jb     8023f9 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8022ad:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022b1:	75 14                	jne    8022c7 <insert_sorted_allocList+0x157>
  8022b3:	83 ec 04             	sub    $0x4,%esp
  8022b6:	68 40 42 80 00       	push   $0x804240
  8022bb:	6a 73                	push   $0x73
  8022bd:	68 ef 41 80 00       	push   $0x8041ef
  8022c2:	e8 0f e2 ff ff       	call   8004d6 <_panic>
  8022c7:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8022cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d0:	89 50 04             	mov    %edx,0x4(%eax)
  8022d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d6:	8b 40 04             	mov    0x4(%eax),%eax
  8022d9:	85 c0                	test   %eax,%eax
  8022db:	74 0c                	je     8022e9 <insert_sorted_allocList+0x179>
  8022dd:	a1 44 50 80 00       	mov    0x805044,%eax
  8022e2:	8b 55 08             	mov    0x8(%ebp),%edx
  8022e5:	89 10                	mov    %edx,(%eax)
  8022e7:	eb 08                	jmp    8022f1 <insert_sorted_allocList+0x181>
  8022e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ec:	a3 40 50 80 00       	mov    %eax,0x805040
  8022f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f4:	a3 44 50 80 00       	mov    %eax,0x805044
  8022f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802302:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802307:	40                   	inc    %eax
  802308:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80230d:	e9 e7 00 00 00       	jmp    8023f9 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802312:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802315:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802318:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80231f:	a1 40 50 80 00       	mov    0x805040,%eax
  802324:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802327:	e9 9d 00 00 00       	jmp    8023c9 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  80232c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80232f:	8b 00                	mov    (%eax),%eax
  802331:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802334:	8b 45 08             	mov    0x8(%ebp),%eax
  802337:	8b 50 08             	mov    0x8(%eax),%edx
  80233a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80233d:	8b 40 08             	mov    0x8(%eax),%eax
  802340:	39 c2                	cmp    %eax,%edx
  802342:	76 7d                	jbe    8023c1 <insert_sorted_allocList+0x251>
  802344:	8b 45 08             	mov    0x8(%ebp),%eax
  802347:	8b 50 08             	mov    0x8(%eax),%edx
  80234a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80234d:	8b 40 08             	mov    0x8(%eax),%eax
  802350:	39 c2                	cmp    %eax,%edx
  802352:	73 6d                	jae    8023c1 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802354:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802358:	74 06                	je     802360 <insert_sorted_allocList+0x1f0>
  80235a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80235e:	75 14                	jne    802374 <insert_sorted_allocList+0x204>
  802360:	83 ec 04             	sub    $0x4,%esp
  802363:	68 64 42 80 00       	push   $0x804264
  802368:	6a 7f                	push   $0x7f
  80236a:	68 ef 41 80 00       	push   $0x8041ef
  80236f:	e8 62 e1 ff ff       	call   8004d6 <_panic>
  802374:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802377:	8b 10                	mov    (%eax),%edx
  802379:	8b 45 08             	mov    0x8(%ebp),%eax
  80237c:	89 10                	mov    %edx,(%eax)
  80237e:	8b 45 08             	mov    0x8(%ebp),%eax
  802381:	8b 00                	mov    (%eax),%eax
  802383:	85 c0                	test   %eax,%eax
  802385:	74 0b                	je     802392 <insert_sorted_allocList+0x222>
  802387:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238a:	8b 00                	mov    (%eax),%eax
  80238c:	8b 55 08             	mov    0x8(%ebp),%edx
  80238f:	89 50 04             	mov    %edx,0x4(%eax)
  802392:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802395:	8b 55 08             	mov    0x8(%ebp),%edx
  802398:	89 10                	mov    %edx,(%eax)
  80239a:	8b 45 08             	mov    0x8(%ebp),%eax
  80239d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023a0:	89 50 04             	mov    %edx,0x4(%eax)
  8023a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a6:	8b 00                	mov    (%eax),%eax
  8023a8:	85 c0                	test   %eax,%eax
  8023aa:	75 08                	jne    8023b4 <insert_sorted_allocList+0x244>
  8023ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8023af:	a3 44 50 80 00       	mov    %eax,0x805044
  8023b4:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8023b9:	40                   	inc    %eax
  8023ba:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  8023bf:	eb 39                	jmp    8023fa <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8023c1:	a1 48 50 80 00       	mov    0x805048,%eax
  8023c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023c9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023cd:	74 07                	je     8023d6 <insert_sorted_allocList+0x266>
  8023cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d2:	8b 00                	mov    (%eax),%eax
  8023d4:	eb 05                	jmp    8023db <insert_sorted_allocList+0x26b>
  8023d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8023db:	a3 48 50 80 00       	mov    %eax,0x805048
  8023e0:	a1 48 50 80 00       	mov    0x805048,%eax
  8023e5:	85 c0                	test   %eax,%eax
  8023e7:	0f 85 3f ff ff ff    	jne    80232c <insert_sorted_allocList+0x1bc>
  8023ed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023f1:	0f 85 35 ff ff ff    	jne    80232c <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8023f7:	eb 01                	jmp    8023fa <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8023f9:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8023fa:	90                   	nop
  8023fb:	c9                   	leave  
  8023fc:	c3                   	ret    

008023fd <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8023fd:	55                   	push   %ebp
  8023fe:	89 e5                	mov    %esp,%ebp
  802400:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802403:	a1 38 51 80 00       	mov    0x805138,%eax
  802408:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80240b:	e9 85 01 00 00       	jmp    802595 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802410:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802413:	8b 40 0c             	mov    0xc(%eax),%eax
  802416:	3b 45 08             	cmp    0x8(%ebp),%eax
  802419:	0f 82 6e 01 00 00    	jb     80258d <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  80241f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802422:	8b 40 0c             	mov    0xc(%eax),%eax
  802425:	3b 45 08             	cmp    0x8(%ebp),%eax
  802428:	0f 85 8a 00 00 00    	jne    8024b8 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  80242e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802432:	75 17                	jne    80244b <alloc_block_FF+0x4e>
  802434:	83 ec 04             	sub    $0x4,%esp
  802437:	68 98 42 80 00       	push   $0x804298
  80243c:	68 93 00 00 00       	push   $0x93
  802441:	68 ef 41 80 00       	push   $0x8041ef
  802446:	e8 8b e0 ff ff       	call   8004d6 <_panic>
  80244b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244e:	8b 00                	mov    (%eax),%eax
  802450:	85 c0                	test   %eax,%eax
  802452:	74 10                	je     802464 <alloc_block_FF+0x67>
  802454:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802457:	8b 00                	mov    (%eax),%eax
  802459:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80245c:	8b 52 04             	mov    0x4(%edx),%edx
  80245f:	89 50 04             	mov    %edx,0x4(%eax)
  802462:	eb 0b                	jmp    80246f <alloc_block_FF+0x72>
  802464:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802467:	8b 40 04             	mov    0x4(%eax),%eax
  80246a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80246f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802472:	8b 40 04             	mov    0x4(%eax),%eax
  802475:	85 c0                	test   %eax,%eax
  802477:	74 0f                	je     802488 <alloc_block_FF+0x8b>
  802479:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247c:	8b 40 04             	mov    0x4(%eax),%eax
  80247f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802482:	8b 12                	mov    (%edx),%edx
  802484:	89 10                	mov    %edx,(%eax)
  802486:	eb 0a                	jmp    802492 <alloc_block_FF+0x95>
  802488:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248b:	8b 00                	mov    (%eax),%eax
  80248d:	a3 38 51 80 00       	mov    %eax,0x805138
  802492:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802495:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80249b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024a5:	a1 44 51 80 00       	mov    0x805144,%eax
  8024aa:	48                   	dec    %eax
  8024ab:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  8024b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b3:	e9 10 01 00 00       	jmp    8025c8 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  8024b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024bb:	8b 40 0c             	mov    0xc(%eax),%eax
  8024be:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024c1:	0f 86 c6 00 00 00    	jbe    80258d <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8024c7:	a1 48 51 80 00       	mov    0x805148,%eax
  8024cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  8024cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d2:	8b 50 08             	mov    0x8(%eax),%edx
  8024d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024d8:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  8024db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024de:	8b 55 08             	mov    0x8(%ebp),%edx
  8024e1:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8024e4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8024e8:	75 17                	jne    802501 <alloc_block_FF+0x104>
  8024ea:	83 ec 04             	sub    $0x4,%esp
  8024ed:	68 98 42 80 00       	push   $0x804298
  8024f2:	68 9b 00 00 00       	push   $0x9b
  8024f7:	68 ef 41 80 00       	push   $0x8041ef
  8024fc:	e8 d5 df ff ff       	call   8004d6 <_panic>
  802501:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802504:	8b 00                	mov    (%eax),%eax
  802506:	85 c0                	test   %eax,%eax
  802508:	74 10                	je     80251a <alloc_block_FF+0x11d>
  80250a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80250d:	8b 00                	mov    (%eax),%eax
  80250f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802512:	8b 52 04             	mov    0x4(%edx),%edx
  802515:	89 50 04             	mov    %edx,0x4(%eax)
  802518:	eb 0b                	jmp    802525 <alloc_block_FF+0x128>
  80251a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80251d:	8b 40 04             	mov    0x4(%eax),%eax
  802520:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802525:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802528:	8b 40 04             	mov    0x4(%eax),%eax
  80252b:	85 c0                	test   %eax,%eax
  80252d:	74 0f                	je     80253e <alloc_block_FF+0x141>
  80252f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802532:	8b 40 04             	mov    0x4(%eax),%eax
  802535:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802538:	8b 12                	mov    (%edx),%edx
  80253a:	89 10                	mov    %edx,(%eax)
  80253c:	eb 0a                	jmp    802548 <alloc_block_FF+0x14b>
  80253e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802541:	8b 00                	mov    (%eax),%eax
  802543:	a3 48 51 80 00       	mov    %eax,0x805148
  802548:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80254b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802551:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802554:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80255b:	a1 54 51 80 00       	mov    0x805154,%eax
  802560:	48                   	dec    %eax
  802561:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802566:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802569:	8b 50 08             	mov    0x8(%eax),%edx
  80256c:	8b 45 08             	mov    0x8(%ebp),%eax
  80256f:	01 c2                	add    %eax,%edx
  802571:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802574:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802577:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257a:	8b 40 0c             	mov    0xc(%eax),%eax
  80257d:	2b 45 08             	sub    0x8(%ebp),%eax
  802580:	89 c2                	mov    %eax,%edx
  802582:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802585:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802588:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80258b:	eb 3b                	jmp    8025c8 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  80258d:	a1 40 51 80 00       	mov    0x805140,%eax
  802592:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802595:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802599:	74 07                	je     8025a2 <alloc_block_FF+0x1a5>
  80259b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259e:	8b 00                	mov    (%eax),%eax
  8025a0:	eb 05                	jmp    8025a7 <alloc_block_FF+0x1aa>
  8025a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8025a7:	a3 40 51 80 00       	mov    %eax,0x805140
  8025ac:	a1 40 51 80 00       	mov    0x805140,%eax
  8025b1:	85 c0                	test   %eax,%eax
  8025b3:	0f 85 57 fe ff ff    	jne    802410 <alloc_block_FF+0x13>
  8025b9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025bd:	0f 85 4d fe ff ff    	jne    802410 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  8025c3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025c8:	c9                   	leave  
  8025c9:	c3                   	ret    

008025ca <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8025ca:	55                   	push   %ebp
  8025cb:	89 e5                	mov    %esp,%ebp
  8025cd:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  8025d0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8025d7:	a1 38 51 80 00       	mov    0x805138,%eax
  8025dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025df:	e9 df 00 00 00       	jmp    8026c3 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  8025e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e7:	8b 40 0c             	mov    0xc(%eax),%eax
  8025ea:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025ed:	0f 82 c8 00 00 00    	jb     8026bb <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  8025f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f6:	8b 40 0c             	mov    0xc(%eax),%eax
  8025f9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025fc:	0f 85 8a 00 00 00    	jne    80268c <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802602:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802606:	75 17                	jne    80261f <alloc_block_BF+0x55>
  802608:	83 ec 04             	sub    $0x4,%esp
  80260b:	68 98 42 80 00       	push   $0x804298
  802610:	68 b7 00 00 00       	push   $0xb7
  802615:	68 ef 41 80 00       	push   $0x8041ef
  80261a:	e8 b7 de ff ff       	call   8004d6 <_panic>
  80261f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802622:	8b 00                	mov    (%eax),%eax
  802624:	85 c0                	test   %eax,%eax
  802626:	74 10                	je     802638 <alloc_block_BF+0x6e>
  802628:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262b:	8b 00                	mov    (%eax),%eax
  80262d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802630:	8b 52 04             	mov    0x4(%edx),%edx
  802633:	89 50 04             	mov    %edx,0x4(%eax)
  802636:	eb 0b                	jmp    802643 <alloc_block_BF+0x79>
  802638:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263b:	8b 40 04             	mov    0x4(%eax),%eax
  80263e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802643:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802646:	8b 40 04             	mov    0x4(%eax),%eax
  802649:	85 c0                	test   %eax,%eax
  80264b:	74 0f                	je     80265c <alloc_block_BF+0x92>
  80264d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802650:	8b 40 04             	mov    0x4(%eax),%eax
  802653:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802656:	8b 12                	mov    (%edx),%edx
  802658:	89 10                	mov    %edx,(%eax)
  80265a:	eb 0a                	jmp    802666 <alloc_block_BF+0x9c>
  80265c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265f:	8b 00                	mov    (%eax),%eax
  802661:	a3 38 51 80 00       	mov    %eax,0x805138
  802666:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802669:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80266f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802672:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802679:	a1 44 51 80 00       	mov    0x805144,%eax
  80267e:	48                   	dec    %eax
  80267f:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802684:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802687:	e9 4d 01 00 00       	jmp    8027d9 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  80268c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268f:	8b 40 0c             	mov    0xc(%eax),%eax
  802692:	3b 45 08             	cmp    0x8(%ebp),%eax
  802695:	76 24                	jbe    8026bb <alloc_block_BF+0xf1>
  802697:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269a:	8b 40 0c             	mov    0xc(%eax),%eax
  80269d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8026a0:	73 19                	jae    8026bb <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  8026a2:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  8026a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ac:	8b 40 0c             	mov    0xc(%eax),%eax
  8026af:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  8026b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b5:	8b 40 08             	mov    0x8(%eax),%eax
  8026b8:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8026bb:	a1 40 51 80 00       	mov    0x805140,%eax
  8026c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026c3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026c7:	74 07                	je     8026d0 <alloc_block_BF+0x106>
  8026c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026cc:	8b 00                	mov    (%eax),%eax
  8026ce:	eb 05                	jmp    8026d5 <alloc_block_BF+0x10b>
  8026d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8026d5:	a3 40 51 80 00       	mov    %eax,0x805140
  8026da:	a1 40 51 80 00       	mov    0x805140,%eax
  8026df:	85 c0                	test   %eax,%eax
  8026e1:	0f 85 fd fe ff ff    	jne    8025e4 <alloc_block_BF+0x1a>
  8026e7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026eb:	0f 85 f3 fe ff ff    	jne    8025e4 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  8026f1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8026f5:	0f 84 d9 00 00 00    	je     8027d4 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  8026fb:	a1 48 51 80 00       	mov    0x805148,%eax
  802700:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802703:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802706:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802709:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  80270c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80270f:	8b 55 08             	mov    0x8(%ebp),%edx
  802712:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802715:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802719:	75 17                	jne    802732 <alloc_block_BF+0x168>
  80271b:	83 ec 04             	sub    $0x4,%esp
  80271e:	68 98 42 80 00       	push   $0x804298
  802723:	68 c7 00 00 00       	push   $0xc7
  802728:	68 ef 41 80 00       	push   $0x8041ef
  80272d:	e8 a4 dd ff ff       	call   8004d6 <_panic>
  802732:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802735:	8b 00                	mov    (%eax),%eax
  802737:	85 c0                	test   %eax,%eax
  802739:	74 10                	je     80274b <alloc_block_BF+0x181>
  80273b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80273e:	8b 00                	mov    (%eax),%eax
  802740:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802743:	8b 52 04             	mov    0x4(%edx),%edx
  802746:	89 50 04             	mov    %edx,0x4(%eax)
  802749:	eb 0b                	jmp    802756 <alloc_block_BF+0x18c>
  80274b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80274e:	8b 40 04             	mov    0x4(%eax),%eax
  802751:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802756:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802759:	8b 40 04             	mov    0x4(%eax),%eax
  80275c:	85 c0                	test   %eax,%eax
  80275e:	74 0f                	je     80276f <alloc_block_BF+0x1a5>
  802760:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802763:	8b 40 04             	mov    0x4(%eax),%eax
  802766:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802769:	8b 12                	mov    (%edx),%edx
  80276b:	89 10                	mov    %edx,(%eax)
  80276d:	eb 0a                	jmp    802779 <alloc_block_BF+0x1af>
  80276f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802772:	8b 00                	mov    (%eax),%eax
  802774:	a3 48 51 80 00       	mov    %eax,0x805148
  802779:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80277c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802782:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802785:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80278c:	a1 54 51 80 00       	mov    0x805154,%eax
  802791:	48                   	dec    %eax
  802792:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802797:	83 ec 08             	sub    $0x8,%esp
  80279a:	ff 75 ec             	pushl  -0x14(%ebp)
  80279d:	68 38 51 80 00       	push   $0x805138
  8027a2:	e8 71 f9 ff ff       	call   802118 <find_block>
  8027a7:	83 c4 10             	add    $0x10,%esp
  8027aa:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  8027ad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027b0:	8b 50 08             	mov    0x8(%eax),%edx
  8027b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8027b6:	01 c2                	add    %eax,%edx
  8027b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027bb:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  8027be:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027c1:	8b 40 0c             	mov    0xc(%eax),%eax
  8027c4:	2b 45 08             	sub    0x8(%ebp),%eax
  8027c7:	89 c2                	mov    %eax,%edx
  8027c9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027cc:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  8027cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027d2:	eb 05                	jmp    8027d9 <alloc_block_BF+0x20f>
	}
	return NULL;
  8027d4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027d9:	c9                   	leave  
  8027da:	c3                   	ret    

008027db <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  8027db:	55                   	push   %ebp
  8027dc:	89 e5                	mov    %esp,%ebp
  8027de:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  8027e1:	a1 28 50 80 00       	mov    0x805028,%eax
  8027e6:	85 c0                	test   %eax,%eax
  8027e8:	0f 85 de 01 00 00    	jne    8029cc <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8027ee:	a1 38 51 80 00       	mov    0x805138,%eax
  8027f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027f6:	e9 9e 01 00 00       	jmp    802999 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  8027fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027fe:	8b 40 0c             	mov    0xc(%eax),%eax
  802801:	3b 45 08             	cmp    0x8(%ebp),%eax
  802804:	0f 82 87 01 00 00    	jb     802991 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  80280a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280d:	8b 40 0c             	mov    0xc(%eax),%eax
  802810:	3b 45 08             	cmp    0x8(%ebp),%eax
  802813:	0f 85 95 00 00 00    	jne    8028ae <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802819:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80281d:	75 17                	jne    802836 <alloc_block_NF+0x5b>
  80281f:	83 ec 04             	sub    $0x4,%esp
  802822:	68 98 42 80 00       	push   $0x804298
  802827:	68 e0 00 00 00       	push   $0xe0
  80282c:	68 ef 41 80 00       	push   $0x8041ef
  802831:	e8 a0 dc ff ff       	call   8004d6 <_panic>
  802836:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802839:	8b 00                	mov    (%eax),%eax
  80283b:	85 c0                	test   %eax,%eax
  80283d:	74 10                	je     80284f <alloc_block_NF+0x74>
  80283f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802842:	8b 00                	mov    (%eax),%eax
  802844:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802847:	8b 52 04             	mov    0x4(%edx),%edx
  80284a:	89 50 04             	mov    %edx,0x4(%eax)
  80284d:	eb 0b                	jmp    80285a <alloc_block_NF+0x7f>
  80284f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802852:	8b 40 04             	mov    0x4(%eax),%eax
  802855:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80285a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285d:	8b 40 04             	mov    0x4(%eax),%eax
  802860:	85 c0                	test   %eax,%eax
  802862:	74 0f                	je     802873 <alloc_block_NF+0x98>
  802864:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802867:	8b 40 04             	mov    0x4(%eax),%eax
  80286a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80286d:	8b 12                	mov    (%edx),%edx
  80286f:	89 10                	mov    %edx,(%eax)
  802871:	eb 0a                	jmp    80287d <alloc_block_NF+0xa2>
  802873:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802876:	8b 00                	mov    (%eax),%eax
  802878:	a3 38 51 80 00       	mov    %eax,0x805138
  80287d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802880:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802886:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802889:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802890:	a1 44 51 80 00       	mov    0x805144,%eax
  802895:	48                   	dec    %eax
  802896:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  80289b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289e:	8b 40 08             	mov    0x8(%eax),%eax
  8028a1:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  8028a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a9:	e9 f8 04 00 00       	jmp    802da6 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  8028ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b1:	8b 40 0c             	mov    0xc(%eax),%eax
  8028b4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028b7:	0f 86 d4 00 00 00    	jbe    802991 <alloc_block_NF+0x1b6>
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
  8028de:	75 17                	jne    8028f7 <alloc_block_NF+0x11c>
  8028e0:	83 ec 04             	sub    $0x4,%esp
  8028e3:	68 98 42 80 00       	push   $0x804298
  8028e8:	68 e9 00 00 00       	push   $0xe9
  8028ed:	68 ef 41 80 00       	push   $0x8041ef
  8028f2:	e8 df db ff ff       	call   8004d6 <_panic>
  8028f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028fa:	8b 00                	mov    (%eax),%eax
  8028fc:	85 c0                	test   %eax,%eax
  8028fe:	74 10                	je     802910 <alloc_block_NF+0x135>
  802900:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802903:	8b 00                	mov    (%eax),%eax
  802905:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802908:	8b 52 04             	mov    0x4(%edx),%edx
  80290b:	89 50 04             	mov    %edx,0x4(%eax)
  80290e:	eb 0b                	jmp    80291b <alloc_block_NF+0x140>
  802910:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802913:	8b 40 04             	mov    0x4(%eax),%eax
  802916:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80291b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80291e:	8b 40 04             	mov    0x4(%eax),%eax
  802921:	85 c0                	test   %eax,%eax
  802923:	74 0f                	je     802934 <alloc_block_NF+0x159>
  802925:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802928:	8b 40 04             	mov    0x4(%eax),%eax
  80292b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80292e:	8b 12                	mov    (%edx),%edx
  802930:	89 10                	mov    %edx,(%eax)
  802932:	eb 0a                	jmp    80293e <alloc_block_NF+0x163>
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
				   svaOfNF = ReturnedBlock->sva;
  80295c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80295f:	8b 40 08             	mov    0x8(%eax),%eax
  802962:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802967:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296a:	8b 50 08             	mov    0x8(%eax),%edx
  80296d:	8b 45 08             	mov    0x8(%ebp),%eax
  802970:	01 c2                	add    %eax,%edx
  802972:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802975:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802978:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297b:	8b 40 0c             	mov    0xc(%eax),%eax
  80297e:	2b 45 08             	sub    0x8(%ebp),%eax
  802981:	89 c2                	mov    %eax,%edx
  802983:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802986:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802989:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80298c:	e9 15 04 00 00       	jmp    802da6 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802991:	a1 40 51 80 00       	mov    0x805140,%eax
  802996:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802999:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80299d:	74 07                	je     8029a6 <alloc_block_NF+0x1cb>
  80299f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a2:	8b 00                	mov    (%eax),%eax
  8029a4:	eb 05                	jmp    8029ab <alloc_block_NF+0x1d0>
  8029a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8029ab:	a3 40 51 80 00       	mov    %eax,0x805140
  8029b0:	a1 40 51 80 00       	mov    0x805140,%eax
  8029b5:	85 c0                	test   %eax,%eax
  8029b7:	0f 85 3e fe ff ff    	jne    8027fb <alloc_block_NF+0x20>
  8029bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029c1:	0f 85 34 fe ff ff    	jne    8027fb <alloc_block_NF+0x20>
  8029c7:	e9 d5 03 00 00       	jmp    802da1 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8029cc:	a1 38 51 80 00       	mov    0x805138,%eax
  8029d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029d4:	e9 b1 01 00 00       	jmp    802b8a <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  8029d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029dc:	8b 50 08             	mov    0x8(%eax),%edx
  8029df:	a1 28 50 80 00       	mov    0x805028,%eax
  8029e4:	39 c2                	cmp    %eax,%edx
  8029e6:	0f 82 96 01 00 00    	jb     802b82 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  8029ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ef:	8b 40 0c             	mov    0xc(%eax),%eax
  8029f2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029f5:	0f 82 87 01 00 00    	jb     802b82 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  8029fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029fe:	8b 40 0c             	mov    0xc(%eax),%eax
  802a01:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a04:	0f 85 95 00 00 00    	jne    802a9f <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802a0a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a0e:	75 17                	jne    802a27 <alloc_block_NF+0x24c>
  802a10:	83 ec 04             	sub    $0x4,%esp
  802a13:	68 98 42 80 00       	push   $0x804298
  802a18:	68 fc 00 00 00       	push   $0xfc
  802a1d:	68 ef 41 80 00       	push   $0x8041ef
  802a22:	e8 af da ff ff       	call   8004d6 <_panic>
  802a27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2a:	8b 00                	mov    (%eax),%eax
  802a2c:	85 c0                	test   %eax,%eax
  802a2e:	74 10                	je     802a40 <alloc_block_NF+0x265>
  802a30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a33:	8b 00                	mov    (%eax),%eax
  802a35:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a38:	8b 52 04             	mov    0x4(%edx),%edx
  802a3b:	89 50 04             	mov    %edx,0x4(%eax)
  802a3e:	eb 0b                	jmp    802a4b <alloc_block_NF+0x270>
  802a40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a43:	8b 40 04             	mov    0x4(%eax),%eax
  802a46:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802a4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4e:	8b 40 04             	mov    0x4(%eax),%eax
  802a51:	85 c0                	test   %eax,%eax
  802a53:	74 0f                	je     802a64 <alloc_block_NF+0x289>
  802a55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a58:	8b 40 04             	mov    0x4(%eax),%eax
  802a5b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a5e:	8b 12                	mov    (%edx),%edx
  802a60:	89 10                	mov    %edx,(%eax)
  802a62:	eb 0a                	jmp    802a6e <alloc_block_NF+0x293>
  802a64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a67:	8b 00                	mov    (%eax),%eax
  802a69:	a3 38 51 80 00       	mov    %eax,0x805138
  802a6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a71:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a81:	a1 44 51 80 00       	mov    0x805144,%eax
  802a86:	48                   	dec    %eax
  802a87:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802a8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8f:	8b 40 08             	mov    0x8(%eax),%eax
  802a92:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802a97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9a:	e9 07 03 00 00       	jmp    802da6 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802a9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa2:	8b 40 0c             	mov    0xc(%eax),%eax
  802aa5:	3b 45 08             	cmp    0x8(%ebp),%eax
  802aa8:	0f 86 d4 00 00 00    	jbe    802b82 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802aae:	a1 48 51 80 00       	mov    0x805148,%eax
  802ab3:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802ab6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab9:	8b 50 08             	mov    0x8(%eax),%edx
  802abc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802abf:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802ac2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ac5:	8b 55 08             	mov    0x8(%ebp),%edx
  802ac8:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802acb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802acf:	75 17                	jne    802ae8 <alloc_block_NF+0x30d>
  802ad1:	83 ec 04             	sub    $0x4,%esp
  802ad4:	68 98 42 80 00       	push   $0x804298
  802ad9:	68 04 01 00 00       	push   $0x104
  802ade:	68 ef 41 80 00       	push   $0x8041ef
  802ae3:	e8 ee d9 ff ff       	call   8004d6 <_panic>
  802ae8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802aeb:	8b 00                	mov    (%eax),%eax
  802aed:	85 c0                	test   %eax,%eax
  802aef:	74 10                	je     802b01 <alloc_block_NF+0x326>
  802af1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802af4:	8b 00                	mov    (%eax),%eax
  802af6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802af9:	8b 52 04             	mov    0x4(%edx),%edx
  802afc:	89 50 04             	mov    %edx,0x4(%eax)
  802aff:	eb 0b                	jmp    802b0c <alloc_block_NF+0x331>
  802b01:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b04:	8b 40 04             	mov    0x4(%eax),%eax
  802b07:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b0c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b0f:	8b 40 04             	mov    0x4(%eax),%eax
  802b12:	85 c0                	test   %eax,%eax
  802b14:	74 0f                	je     802b25 <alloc_block_NF+0x34a>
  802b16:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b19:	8b 40 04             	mov    0x4(%eax),%eax
  802b1c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b1f:	8b 12                	mov    (%edx),%edx
  802b21:	89 10                	mov    %edx,(%eax)
  802b23:	eb 0a                	jmp    802b2f <alloc_block_NF+0x354>
  802b25:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b28:	8b 00                	mov    (%eax),%eax
  802b2a:	a3 48 51 80 00       	mov    %eax,0x805148
  802b2f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b32:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b38:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b3b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b42:	a1 54 51 80 00       	mov    0x805154,%eax
  802b47:	48                   	dec    %eax
  802b48:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802b4d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b50:	8b 40 08             	mov    0x8(%eax),%eax
  802b53:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802b58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5b:	8b 50 08             	mov    0x8(%eax),%edx
  802b5e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b61:	01 c2                	add    %eax,%edx
  802b63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b66:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802b69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6c:	8b 40 0c             	mov    0xc(%eax),%eax
  802b6f:	2b 45 08             	sub    0x8(%ebp),%eax
  802b72:	89 c2                	mov    %eax,%edx
  802b74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b77:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802b7a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b7d:	e9 24 02 00 00       	jmp    802da6 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802b82:	a1 40 51 80 00       	mov    0x805140,%eax
  802b87:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b8a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b8e:	74 07                	je     802b97 <alloc_block_NF+0x3bc>
  802b90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b93:	8b 00                	mov    (%eax),%eax
  802b95:	eb 05                	jmp    802b9c <alloc_block_NF+0x3c1>
  802b97:	b8 00 00 00 00       	mov    $0x0,%eax
  802b9c:	a3 40 51 80 00       	mov    %eax,0x805140
  802ba1:	a1 40 51 80 00       	mov    0x805140,%eax
  802ba6:	85 c0                	test   %eax,%eax
  802ba8:	0f 85 2b fe ff ff    	jne    8029d9 <alloc_block_NF+0x1fe>
  802bae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bb2:	0f 85 21 fe ff ff    	jne    8029d9 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802bb8:	a1 38 51 80 00       	mov    0x805138,%eax
  802bbd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bc0:	e9 ae 01 00 00       	jmp    802d73 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802bc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc8:	8b 50 08             	mov    0x8(%eax),%edx
  802bcb:	a1 28 50 80 00       	mov    0x805028,%eax
  802bd0:	39 c2                	cmp    %eax,%edx
  802bd2:	0f 83 93 01 00 00    	jae    802d6b <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802bd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bdb:	8b 40 0c             	mov    0xc(%eax),%eax
  802bde:	3b 45 08             	cmp    0x8(%ebp),%eax
  802be1:	0f 82 84 01 00 00    	jb     802d6b <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802be7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bea:	8b 40 0c             	mov    0xc(%eax),%eax
  802bed:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bf0:	0f 85 95 00 00 00    	jne    802c8b <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802bf6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bfa:	75 17                	jne    802c13 <alloc_block_NF+0x438>
  802bfc:	83 ec 04             	sub    $0x4,%esp
  802bff:	68 98 42 80 00       	push   $0x804298
  802c04:	68 14 01 00 00       	push   $0x114
  802c09:	68 ef 41 80 00       	push   $0x8041ef
  802c0e:	e8 c3 d8 ff ff       	call   8004d6 <_panic>
  802c13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c16:	8b 00                	mov    (%eax),%eax
  802c18:	85 c0                	test   %eax,%eax
  802c1a:	74 10                	je     802c2c <alloc_block_NF+0x451>
  802c1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1f:	8b 00                	mov    (%eax),%eax
  802c21:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c24:	8b 52 04             	mov    0x4(%edx),%edx
  802c27:	89 50 04             	mov    %edx,0x4(%eax)
  802c2a:	eb 0b                	jmp    802c37 <alloc_block_NF+0x45c>
  802c2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c2f:	8b 40 04             	mov    0x4(%eax),%eax
  802c32:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c3a:	8b 40 04             	mov    0x4(%eax),%eax
  802c3d:	85 c0                	test   %eax,%eax
  802c3f:	74 0f                	je     802c50 <alloc_block_NF+0x475>
  802c41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c44:	8b 40 04             	mov    0x4(%eax),%eax
  802c47:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c4a:	8b 12                	mov    (%edx),%edx
  802c4c:	89 10                	mov    %edx,(%eax)
  802c4e:	eb 0a                	jmp    802c5a <alloc_block_NF+0x47f>
  802c50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c53:	8b 00                	mov    (%eax),%eax
  802c55:	a3 38 51 80 00       	mov    %eax,0x805138
  802c5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c5d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c66:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c6d:	a1 44 51 80 00       	mov    0x805144,%eax
  802c72:	48                   	dec    %eax
  802c73:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802c78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c7b:	8b 40 08             	mov    0x8(%eax),%eax
  802c7e:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802c83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c86:	e9 1b 01 00 00       	jmp    802da6 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802c8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c8e:	8b 40 0c             	mov    0xc(%eax),%eax
  802c91:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c94:	0f 86 d1 00 00 00    	jbe    802d6b <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802c9a:	a1 48 51 80 00       	mov    0x805148,%eax
  802c9f:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802ca2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca5:	8b 50 08             	mov    0x8(%eax),%edx
  802ca8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cab:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802cae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cb1:	8b 55 08             	mov    0x8(%ebp),%edx
  802cb4:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802cb7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802cbb:	75 17                	jne    802cd4 <alloc_block_NF+0x4f9>
  802cbd:	83 ec 04             	sub    $0x4,%esp
  802cc0:	68 98 42 80 00       	push   $0x804298
  802cc5:	68 1c 01 00 00       	push   $0x11c
  802cca:	68 ef 41 80 00       	push   $0x8041ef
  802ccf:	e8 02 d8 ff ff       	call   8004d6 <_panic>
  802cd4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cd7:	8b 00                	mov    (%eax),%eax
  802cd9:	85 c0                	test   %eax,%eax
  802cdb:	74 10                	je     802ced <alloc_block_NF+0x512>
  802cdd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ce0:	8b 00                	mov    (%eax),%eax
  802ce2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ce5:	8b 52 04             	mov    0x4(%edx),%edx
  802ce8:	89 50 04             	mov    %edx,0x4(%eax)
  802ceb:	eb 0b                	jmp    802cf8 <alloc_block_NF+0x51d>
  802ced:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cf0:	8b 40 04             	mov    0x4(%eax),%eax
  802cf3:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802cf8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cfb:	8b 40 04             	mov    0x4(%eax),%eax
  802cfe:	85 c0                	test   %eax,%eax
  802d00:	74 0f                	je     802d11 <alloc_block_NF+0x536>
  802d02:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d05:	8b 40 04             	mov    0x4(%eax),%eax
  802d08:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d0b:	8b 12                	mov    (%edx),%edx
  802d0d:	89 10                	mov    %edx,(%eax)
  802d0f:	eb 0a                	jmp    802d1b <alloc_block_NF+0x540>
  802d11:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d14:	8b 00                	mov    (%eax),%eax
  802d16:	a3 48 51 80 00       	mov    %eax,0x805148
  802d1b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d1e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d24:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d27:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d2e:	a1 54 51 80 00       	mov    0x805154,%eax
  802d33:	48                   	dec    %eax
  802d34:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802d39:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d3c:	8b 40 08             	mov    0x8(%eax),%eax
  802d3f:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802d44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d47:	8b 50 08             	mov    0x8(%eax),%edx
  802d4a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d4d:	01 c2                	add    %eax,%edx
  802d4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d52:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802d55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d58:	8b 40 0c             	mov    0xc(%eax),%eax
  802d5b:	2b 45 08             	sub    0x8(%ebp),%eax
  802d5e:	89 c2                	mov    %eax,%edx
  802d60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d63:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802d66:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d69:	eb 3b                	jmp    802da6 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802d6b:	a1 40 51 80 00       	mov    0x805140,%eax
  802d70:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d73:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d77:	74 07                	je     802d80 <alloc_block_NF+0x5a5>
  802d79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d7c:	8b 00                	mov    (%eax),%eax
  802d7e:	eb 05                	jmp    802d85 <alloc_block_NF+0x5aa>
  802d80:	b8 00 00 00 00       	mov    $0x0,%eax
  802d85:	a3 40 51 80 00       	mov    %eax,0x805140
  802d8a:	a1 40 51 80 00       	mov    0x805140,%eax
  802d8f:	85 c0                	test   %eax,%eax
  802d91:	0f 85 2e fe ff ff    	jne    802bc5 <alloc_block_NF+0x3ea>
  802d97:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d9b:	0f 85 24 fe ff ff    	jne    802bc5 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802da1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802da6:	c9                   	leave  
  802da7:	c3                   	ret    

00802da8 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802da8:	55                   	push   %ebp
  802da9:	89 e5                	mov    %esp,%ebp
  802dab:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802dae:	a1 38 51 80 00       	mov    0x805138,%eax
  802db3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802db6:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802dbb:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802dbe:	a1 38 51 80 00       	mov    0x805138,%eax
  802dc3:	85 c0                	test   %eax,%eax
  802dc5:	74 14                	je     802ddb <insert_sorted_with_merge_freeList+0x33>
  802dc7:	8b 45 08             	mov    0x8(%ebp),%eax
  802dca:	8b 50 08             	mov    0x8(%eax),%edx
  802dcd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dd0:	8b 40 08             	mov    0x8(%eax),%eax
  802dd3:	39 c2                	cmp    %eax,%edx
  802dd5:	0f 87 9b 01 00 00    	ja     802f76 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802ddb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ddf:	75 17                	jne    802df8 <insert_sorted_with_merge_freeList+0x50>
  802de1:	83 ec 04             	sub    $0x4,%esp
  802de4:	68 cc 41 80 00       	push   $0x8041cc
  802de9:	68 38 01 00 00       	push   $0x138
  802dee:	68 ef 41 80 00       	push   $0x8041ef
  802df3:	e8 de d6 ff ff       	call   8004d6 <_panic>
  802df8:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802dfe:	8b 45 08             	mov    0x8(%ebp),%eax
  802e01:	89 10                	mov    %edx,(%eax)
  802e03:	8b 45 08             	mov    0x8(%ebp),%eax
  802e06:	8b 00                	mov    (%eax),%eax
  802e08:	85 c0                	test   %eax,%eax
  802e0a:	74 0d                	je     802e19 <insert_sorted_with_merge_freeList+0x71>
  802e0c:	a1 38 51 80 00       	mov    0x805138,%eax
  802e11:	8b 55 08             	mov    0x8(%ebp),%edx
  802e14:	89 50 04             	mov    %edx,0x4(%eax)
  802e17:	eb 08                	jmp    802e21 <insert_sorted_with_merge_freeList+0x79>
  802e19:	8b 45 08             	mov    0x8(%ebp),%eax
  802e1c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e21:	8b 45 08             	mov    0x8(%ebp),%eax
  802e24:	a3 38 51 80 00       	mov    %eax,0x805138
  802e29:	8b 45 08             	mov    0x8(%ebp),%eax
  802e2c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e33:	a1 44 51 80 00       	mov    0x805144,%eax
  802e38:	40                   	inc    %eax
  802e39:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802e3e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e42:	0f 84 a8 06 00 00    	je     8034f0 <insert_sorted_with_merge_freeList+0x748>
  802e48:	8b 45 08             	mov    0x8(%ebp),%eax
  802e4b:	8b 50 08             	mov    0x8(%eax),%edx
  802e4e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e51:	8b 40 0c             	mov    0xc(%eax),%eax
  802e54:	01 c2                	add    %eax,%edx
  802e56:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e59:	8b 40 08             	mov    0x8(%eax),%eax
  802e5c:	39 c2                	cmp    %eax,%edx
  802e5e:	0f 85 8c 06 00 00    	jne    8034f0 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802e64:	8b 45 08             	mov    0x8(%ebp),%eax
  802e67:	8b 50 0c             	mov    0xc(%eax),%edx
  802e6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e6d:	8b 40 0c             	mov    0xc(%eax),%eax
  802e70:	01 c2                	add    %eax,%edx
  802e72:	8b 45 08             	mov    0x8(%ebp),%eax
  802e75:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802e78:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e7c:	75 17                	jne    802e95 <insert_sorted_with_merge_freeList+0xed>
  802e7e:	83 ec 04             	sub    $0x4,%esp
  802e81:	68 98 42 80 00       	push   $0x804298
  802e86:	68 3c 01 00 00       	push   $0x13c
  802e8b:	68 ef 41 80 00       	push   $0x8041ef
  802e90:	e8 41 d6 ff ff       	call   8004d6 <_panic>
  802e95:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e98:	8b 00                	mov    (%eax),%eax
  802e9a:	85 c0                	test   %eax,%eax
  802e9c:	74 10                	je     802eae <insert_sorted_with_merge_freeList+0x106>
  802e9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ea1:	8b 00                	mov    (%eax),%eax
  802ea3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ea6:	8b 52 04             	mov    0x4(%edx),%edx
  802ea9:	89 50 04             	mov    %edx,0x4(%eax)
  802eac:	eb 0b                	jmp    802eb9 <insert_sorted_with_merge_freeList+0x111>
  802eae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eb1:	8b 40 04             	mov    0x4(%eax),%eax
  802eb4:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802eb9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ebc:	8b 40 04             	mov    0x4(%eax),%eax
  802ebf:	85 c0                	test   %eax,%eax
  802ec1:	74 0f                	je     802ed2 <insert_sorted_with_merge_freeList+0x12a>
  802ec3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ec6:	8b 40 04             	mov    0x4(%eax),%eax
  802ec9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ecc:	8b 12                	mov    (%edx),%edx
  802ece:	89 10                	mov    %edx,(%eax)
  802ed0:	eb 0a                	jmp    802edc <insert_sorted_with_merge_freeList+0x134>
  802ed2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ed5:	8b 00                	mov    (%eax),%eax
  802ed7:	a3 38 51 80 00       	mov    %eax,0x805138
  802edc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802edf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ee5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ee8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802eef:	a1 44 51 80 00       	mov    0x805144,%eax
  802ef4:	48                   	dec    %eax
  802ef5:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802efa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802efd:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802f04:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f07:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802f0e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f12:	75 17                	jne    802f2b <insert_sorted_with_merge_freeList+0x183>
  802f14:	83 ec 04             	sub    $0x4,%esp
  802f17:	68 cc 41 80 00       	push   $0x8041cc
  802f1c:	68 3f 01 00 00       	push   $0x13f
  802f21:	68 ef 41 80 00       	push   $0x8041ef
  802f26:	e8 ab d5 ff ff       	call   8004d6 <_panic>
  802f2b:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802f31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f34:	89 10                	mov    %edx,(%eax)
  802f36:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f39:	8b 00                	mov    (%eax),%eax
  802f3b:	85 c0                	test   %eax,%eax
  802f3d:	74 0d                	je     802f4c <insert_sorted_with_merge_freeList+0x1a4>
  802f3f:	a1 48 51 80 00       	mov    0x805148,%eax
  802f44:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f47:	89 50 04             	mov    %edx,0x4(%eax)
  802f4a:	eb 08                	jmp    802f54 <insert_sorted_with_merge_freeList+0x1ac>
  802f4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f4f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f54:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f57:	a3 48 51 80 00       	mov    %eax,0x805148
  802f5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f5f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f66:	a1 54 51 80 00       	mov    0x805154,%eax
  802f6b:	40                   	inc    %eax
  802f6c:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802f71:	e9 7a 05 00 00       	jmp    8034f0 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802f76:	8b 45 08             	mov    0x8(%ebp),%eax
  802f79:	8b 50 08             	mov    0x8(%eax),%edx
  802f7c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f7f:	8b 40 08             	mov    0x8(%eax),%eax
  802f82:	39 c2                	cmp    %eax,%edx
  802f84:	0f 82 14 01 00 00    	jb     80309e <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802f8a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f8d:	8b 50 08             	mov    0x8(%eax),%edx
  802f90:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f93:	8b 40 0c             	mov    0xc(%eax),%eax
  802f96:	01 c2                	add    %eax,%edx
  802f98:	8b 45 08             	mov    0x8(%ebp),%eax
  802f9b:	8b 40 08             	mov    0x8(%eax),%eax
  802f9e:	39 c2                	cmp    %eax,%edx
  802fa0:	0f 85 90 00 00 00    	jne    803036 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802fa6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fa9:	8b 50 0c             	mov    0xc(%eax),%edx
  802fac:	8b 45 08             	mov    0x8(%ebp),%eax
  802faf:	8b 40 0c             	mov    0xc(%eax),%eax
  802fb2:	01 c2                	add    %eax,%edx
  802fb4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fb7:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802fba:	8b 45 08             	mov    0x8(%ebp),%eax
  802fbd:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802fc4:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802fce:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fd2:	75 17                	jne    802feb <insert_sorted_with_merge_freeList+0x243>
  802fd4:	83 ec 04             	sub    $0x4,%esp
  802fd7:	68 cc 41 80 00       	push   $0x8041cc
  802fdc:	68 49 01 00 00       	push   $0x149
  802fe1:	68 ef 41 80 00       	push   $0x8041ef
  802fe6:	e8 eb d4 ff ff       	call   8004d6 <_panic>
  802feb:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802ff1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff4:	89 10                	mov    %edx,(%eax)
  802ff6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff9:	8b 00                	mov    (%eax),%eax
  802ffb:	85 c0                	test   %eax,%eax
  802ffd:	74 0d                	je     80300c <insert_sorted_with_merge_freeList+0x264>
  802fff:	a1 48 51 80 00       	mov    0x805148,%eax
  803004:	8b 55 08             	mov    0x8(%ebp),%edx
  803007:	89 50 04             	mov    %edx,0x4(%eax)
  80300a:	eb 08                	jmp    803014 <insert_sorted_with_merge_freeList+0x26c>
  80300c:	8b 45 08             	mov    0x8(%ebp),%eax
  80300f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803014:	8b 45 08             	mov    0x8(%ebp),%eax
  803017:	a3 48 51 80 00       	mov    %eax,0x805148
  80301c:	8b 45 08             	mov    0x8(%ebp),%eax
  80301f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803026:	a1 54 51 80 00       	mov    0x805154,%eax
  80302b:	40                   	inc    %eax
  80302c:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803031:	e9 bb 04 00 00       	jmp    8034f1 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  803036:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80303a:	75 17                	jne    803053 <insert_sorted_with_merge_freeList+0x2ab>
  80303c:	83 ec 04             	sub    $0x4,%esp
  80303f:	68 40 42 80 00       	push   $0x804240
  803044:	68 4c 01 00 00       	push   $0x14c
  803049:	68 ef 41 80 00       	push   $0x8041ef
  80304e:	e8 83 d4 ff ff       	call   8004d6 <_panic>
  803053:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803059:	8b 45 08             	mov    0x8(%ebp),%eax
  80305c:	89 50 04             	mov    %edx,0x4(%eax)
  80305f:	8b 45 08             	mov    0x8(%ebp),%eax
  803062:	8b 40 04             	mov    0x4(%eax),%eax
  803065:	85 c0                	test   %eax,%eax
  803067:	74 0c                	je     803075 <insert_sorted_with_merge_freeList+0x2cd>
  803069:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80306e:	8b 55 08             	mov    0x8(%ebp),%edx
  803071:	89 10                	mov    %edx,(%eax)
  803073:	eb 08                	jmp    80307d <insert_sorted_with_merge_freeList+0x2d5>
  803075:	8b 45 08             	mov    0x8(%ebp),%eax
  803078:	a3 38 51 80 00       	mov    %eax,0x805138
  80307d:	8b 45 08             	mov    0x8(%ebp),%eax
  803080:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803085:	8b 45 08             	mov    0x8(%ebp),%eax
  803088:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80308e:	a1 44 51 80 00       	mov    0x805144,%eax
  803093:	40                   	inc    %eax
  803094:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803099:	e9 53 04 00 00       	jmp    8034f1 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  80309e:	a1 38 51 80 00       	mov    0x805138,%eax
  8030a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030a6:	e9 15 04 00 00       	jmp    8034c0 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  8030ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ae:	8b 00                	mov    (%eax),%eax
  8030b0:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  8030b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b6:	8b 50 08             	mov    0x8(%eax),%edx
  8030b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030bc:	8b 40 08             	mov    0x8(%eax),%eax
  8030bf:	39 c2                	cmp    %eax,%edx
  8030c1:	0f 86 f1 03 00 00    	jbe    8034b8 <insert_sorted_with_merge_freeList+0x710>
  8030c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ca:	8b 50 08             	mov    0x8(%eax),%edx
  8030cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030d0:	8b 40 08             	mov    0x8(%eax),%eax
  8030d3:	39 c2                	cmp    %eax,%edx
  8030d5:	0f 83 dd 03 00 00    	jae    8034b8 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  8030db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030de:	8b 50 08             	mov    0x8(%eax),%edx
  8030e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e4:	8b 40 0c             	mov    0xc(%eax),%eax
  8030e7:	01 c2                	add    %eax,%edx
  8030e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ec:	8b 40 08             	mov    0x8(%eax),%eax
  8030ef:	39 c2                	cmp    %eax,%edx
  8030f1:	0f 85 b9 01 00 00    	jne    8032b0 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8030f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8030fa:	8b 50 08             	mov    0x8(%eax),%edx
  8030fd:	8b 45 08             	mov    0x8(%ebp),%eax
  803100:	8b 40 0c             	mov    0xc(%eax),%eax
  803103:	01 c2                	add    %eax,%edx
  803105:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803108:	8b 40 08             	mov    0x8(%eax),%eax
  80310b:	39 c2                	cmp    %eax,%edx
  80310d:	0f 85 0d 01 00 00    	jne    803220 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  803113:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803116:	8b 50 0c             	mov    0xc(%eax),%edx
  803119:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80311c:	8b 40 0c             	mov    0xc(%eax),%eax
  80311f:	01 c2                	add    %eax,%edx
  803121:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803124:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803127:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80312b:	75 17                	jne    803144 <insert_sorted_with_merge_freeList+0x39c>
  80312d:	83 ec 04             	sub    $0x4,%esp
  803130:	68 98 42 80 00       	push   $0x804298
  803135:	68 5c 01 00 00       	push   $0x15c
  80313a:	68 ef 41 80 00       	push   $0x8041ef
  80313f:	e8 92 d3 ff ff       	call   8004d6 <_panic>
  803144:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803147:	8b 00                	mov    (%eax),%eax
  803149:	85 c0                	test   %eax,%eax
  80314b:	74 10                	je     80315d <insert_sorted_with_merge_freeList+0x3b5>
  80314d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803150:	8b 00                	mov    (%eax),%eax
  803152:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803155:	8b 52 04             	mov    0x4(%edx),%edx
  803158:	89 50 04             	mov    %edx,0x4(%eax)
  80315b:	eb 0b                	jmp    803168 <insert_sorted_with_merge_freeList+0x3c0>
  80315d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803160:	8b 40 04             	mov    0x4(%eax),%eax
  803163:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803168:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80316b:	8b 40 04             	mov    0x4(%eax),%eax
  80316e:	85 c0                	test   %eax,%eax
  803170:	74 0f                	je     803181 <insert_sorted_with_merge_freeList+0x3d9>
  803172:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803175:	8b 40 04             	mov    0x4(%eax),%eax
  803178:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80317b:	8b 12                	mov    (%edx),%edx
  80317d:	89 10                	mov    %edx,(%eax)
  80317f:	eb 0a                	jmp    80318b <insert_sorted_with_merge_freeList+0x3e3>
  803181:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803184:	8b 00                	mov    (%eax),%eax
  803186:	a3 38 51 80 00       	mov    %eax,0x805138
  80318b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80318e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803194:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803197:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80319e:	a1 44 51 80 00       	mov    0x805144,%eax
  8031a3:	48                   	dec    %eax
  8031a4:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  8031a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ac:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  8031b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031b6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8031bd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8031c1:	75 17                	jne    8031da <insert_sorted_with_merge_freeList+0x432>
  8031c3:	83 ec 04             	sub    $0x4,%esp
  8031c6:	68 cc 41 80 00       	push   $0x8041cc
  8031cb:	68 5f 01 00 00       	push   $0x15f
  8031d0:	68 ef 41 80 00       	push   $0x8041ef
  8031d5:	e8 fc d2 ff ff       	call   8004d6 <_panic>
  8031da:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8031e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031e3:	89 10                	mov    %edx,(%eax)
  8031e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031e8:	8b 00                	mov    (%eax),%eax
  8031ea:	85 c0                	test   %eax,%eax
  8031ec:	74 0d                	je     8031fb <insert_sorted_with_merge_freeList+0x453>
  8031ee:	a1 48 51 80 00       	mov    0x805148,%eax
  8031f3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031f6:	89 50 04             	mov    %edx,0x4(%eax)
  8031f9:	eb 08                	jmp    803203 <insert_sorted_with_merge_freeList+0x45b>
  8031fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031fe:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803203:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803206:	a3 48 51 80 00       	mov    %eax,0x805148
  80320b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80320e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803215:	a1 54 51 80 00       	mov    0x805154,%eax
  80321a:	40                   	inc    %eax
  80321b:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803220:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803223:	8b 50 0c             	mov    0xc(%eax),%edx
  803226:	8b 45 08             	mov    0x8(%ebp),%eax
  803229:	8b 40 0c             	mov    0xc(%eax),%eax
  80322c:	01 c2                	add    %eax,%edx
  80322e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803231:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803234:	8b 45 08             	mov    0x8(%ebp),%eax
  803237:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  80323e:	8b 45 08             	mov    0x8(%ebp),%eax
  803241:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803248:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80324c:	75 17                	jne    803265 <insert_sorted_with_merge_freeList+0x4bd>
  80324e:	83 ec 04             	sub    $0x4,%esp
  803251:	68 cc 41 80 00       	push   $0x8041cc
  803256:	68 64 01 00 00       	push   $0x164
  80325b:	68 ef 41 80 00       	push   $0x8041ef
  803260:	e8 71 d2 ff ff       	call   8004d6 <_panic>
  803265:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80326b:	8b 45 08             	mov    0x8(%ebp),%eax
  80326e:	89 10                	mov    %edx,(%eax)
  803270:	8b 45 08             	mov    0x8(%ebp),%eax
  803273:	8b 00                	mov    (%eax),%eax
  803275:	85 c0                	test   %eax,%eax
  803277:	74 0d                	je     803286 <insert_sorted_with_merge_freeList+0x4de>
  803279:	a1 48 51 80 00       	mov    0x805148,%eax
  80327e:	8b 55 08             	mov    0x8(%ebp),%edx
  803281:	89 50 04             	mov    %edx,0x4(%eax)
  803284:	eb 08                	jmp    80328e <insert_sorted_with_merge_freeList+0x4e6>
  803286:	8b 45 08             	mov    0x8(%ebp),%eax
  803289:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80328e:	8b 45 08             	mov    0x8(%ebp),%eax
  803291:	a3 48 51 80 00       	mov    %eax,0x805148
  803296:	8b 45 08             	mov    0x8(%ebp),%eax
  803299:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032a0:	a1 54 51 80 00       	mov    0x805154,%eax
  8032a5:	40                   	inc    %eax
  8032a6:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8032ab:	e9 41 02 00 00       	jmp    8034f1 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8032b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b3:	8b 50 08             	mov    0x8(%eax),%edx
  8032b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b9:	8b 40 0c             	mov    0xc(%eax),%eax
  8032bc:	01 c2                	add    %eax,%edx
  8032be:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032c1:	8b 40 08             	mov    0x8(%eax),%eax
  8032c4:	39 c2                	cmp    %eax,%edx
  8032c6:	0f 85 7c 01 00 00    	jne    803448 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  8032cc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8032d0:	74 06                	je     8032d8 <insert_sorted_with_merge_freeList+0x530>
  8032d2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032d6:	75 17                	jne    8032ef <insert_sorted_with_merge_freeList+0x547>
  8032d8:	83 ec 04             	sub    $0x4,%esp
  8032db:	68 08 42 80 00       	push   $0x804208
  8032e0:	68 69 01 00 00       	push   $0x169
  8032e5:	68 ef 41 80 00       	push   $0x8041ef
  8032ea:	e8 e7 d1 ff ff       	call   8004d6 <_panic>
  8032ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032f2:	8b 50 04             	mov    0x4(%eax),%edx
  8032f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f8:	89 50 04             	mov    %edx,0x4(%eax)
  8032fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8032fe:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803301:	89 10                	mov    %edx,(%eax)
  803303:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803306:	8b 40 04             	mov    0x4(%eax),%eax
  803309:	85 c0                	test   %eax,%eax
  80330b:	74 0d                	je     80331a <insert_sorted_with_merge_freeList+0x572>
  80330d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803310:	8b 40 04             	mov    0x4(%eax),%eax
  803313:	8b 55 08             	mov    0x8(%ebp),%edx
  803316:	89 10                	mov    %edx,(%eax)
  803318:	eb 08                	jmp    803322 <insert_sorted_with_merge_freeList+0x57a>
  80331a:	8b 45 08             	mov    0x8(%ebp),%eax
  80331d:	a3 38 51 80 00       	mov    %eax,0x805138
  803322:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803325:	8b 55 08             	mov    0x8(%ebp),%edx
  803328:	89 50 04             	mov    %edx,0x4(%eax)
  80332b:	a1 44 51 80 00       	mov    0x805144,%eax
  803330:	40                   	inc    %eax
  803331:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803336:	8b 45 08             	mov    0x8(%ebp),%eax
  803339:	8b 50 0c             	mov    0xc(%eax),%edx
  80333c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80333f:	8b 40 0c             	mov    0xc(%eax),%eax
  803342:	01 c2                	add    %eax,%edx
  803344:	8b 45 08             	mov    0x8(%ebp),%eax
  803347:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80334a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80334e:	75 17                	jne    803367 <insert_sorted_with_merge_freeList+0x5bf>
  803350:	83 ec 04             	sub    $0x4,%esp
  803353:	68 98 42 80 00       	push   $0x804298
  803358:	68 6b 01 00 00       	push   $0x16b
  80335d:	68 ef 41 80 00       	push   $0x8041ef
  803362:	e8 6f d1 ff ff       	call   8004d6 <_panic>
  803367:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80336a:	8b 00                	mov    (%eax),%eax
  80336c:	85 c0                	test   %eax,%eax
  80336e:	74 10                	je     803380 <insert_sorted_with_merge_freeList+0x5d8>
  803370:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803373:	8b 00                	mov    (%eax),%eax
  803375:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803378:	8b 52 04             	mov    0x4(%edx),%edx
  80337b:	89 50 04             	mov    %edx,0x4(%eax)
  80337e:	eb 0b                	jmp    80338b <insert_sorted_with_merge_freeList+0x5e3>
  803380:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803383:	8b 40 04             	mov    0x4(%eax),%eax
  803386:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80338b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80338e:	8b 40 04             	mov    0x4(%eax),%eax
  803391:	85 c0                	test   %eax,%eax
  803393:	74 0f                	je     8033a4 <insert_sorted_with_merge_freeList+0x5fc>
  803395:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803398:	8b 40 04             	mov    0x4(%eax),%eax
  80339b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80339e:	8b 12                	mov    (%edx),%edx
  8033a0:	89 10                	mov    %edx,(%eax)
  8033a2:	eb 0a                	jmp    8033ae <insert_sorted_with_merge_freeList+0x606>
  8033a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033a7:	8b 00                	mov    (%eax),%eax
  8033a9:	a3 38 51 80 00       	mov    %eax,0x805138
  8033ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033b1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033ba:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033c1:	a1 44 51 80 00       	mov    0x805144,%eax
  8033c6:	48                   	dec    %eax
  8033c7:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  8033cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033cf:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  8033d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033d9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8033e0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8033e4:	75 17                	jne    8033fd <insert_sorted_with_merge_freeList+0x655>
  8033e6:	83 ec 04             	sub    $0x4,%esp
  8033e9:	68 cc 41 80 00       	push   $0x8041cc
  8033ee:	68 6e 01 00 00       	push   $0x16e
  8033f3:	68 ef 41 80 00       	push   $0x8041ef
  8033f8:	e8 d9 d0 ff ff       	call   8004d6 <_panic>
  8033fd:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803403:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803406:	89 10                	mov    %edx,(%eax)
  803408:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80340b:	8b 00                	mov    (%eax),%eax
  80340d:	85 c0                	test   %eax,%eax
  80340f:	74 0d                	je     80341e <insert_sorted_with_merge_freeList+0x676>
  803411:	a1 48 51 80 00       	mov    0x805148,%eax
  803416:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803419:	89 50 04             	mov    %edx,0x4(%eax)
  80341c:	eb 08                	jmp    803426 <insert_sorted_with_merge_freeList+0x67e>
  80341e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803421:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803426:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803429:	a3 48 51 80 00       	mov    %eax,0x805148
  80342e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803431:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803438:	a1 54 51 80 00       	mov    0x805154,%eax
  80343d:	40                   	inc    %eax
  80343e:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803443:	e9 a9 00 00 00       	jmp    8034f1 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803448:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80344c:	74 06                	je     803454 <insert_sorted_with_merge_freeList+0x6ac>
  80344e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803452:	75 17                	jne    80346b <insert_sorted_with_merge_freeList+0x6c3>
  803454:	83 ec 04             	sub    $0x4,%esp
  803457:	68 64 42 80 00       	push   $0x804264
  80345c:	68 73 01 00 00       	push   $0x173
  803461:	68 ef 41 80 00       	push   $0x8041ef
  803466:	e8 6b d0 ff ff       	call   8004d6 <_panic>
  80346b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80346e:	8b 10                	mov    (%eax),%edx
  803470:	8b 45 08             	mov    0x8(%ebp),%eax
  803473:	89 10                	mov    %edx,(%eax)
  803475:	8b 45 08             	mov    0x8(%ebp),%eax
  803478:	8b 00                	mov    (%eax),%eax
  80347a:	85 c0                	test   %eax,%eax
  80347c:	74 0b                	je     803489 <insert_sorted_with_merge_freeList+0x6e1>
  80347e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803481:	8b 00                	mov    (%eax),%eax
  803483:	8b 55 08             	mov    0x8(%ebp),%edx
  803486:	89 50 04             	mov    %edx,0x4(%eax)
  803489:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80348c:	8b 55 08             	mov    0x8(%ebp),%edx
  80348f:	89 10                	mov    %edx,(%eax)
  803491:	8b 45 08             	mov    0x8(%ebp),%eax
  803494:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803497:	89 50 04             	mov    %edx,0x4(%eax)
  80349a:	8b 45 08             	mov    0x8(%ebp),%eax
  80349d:	8b 00                	mov    (%eax),%eax
  80349f:	85 c0                	test   %eax,%eax
  8034a1:	75 08                	jne    8034ab <insert_sorted_with_merge_freeList+0x703>
  8034a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8034a6:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8034ab:	a1 44 51 80 00       	mov    0x805144,%eax
  8034b0:	40                   	inc    %eax
  8034b1:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  8034b6:	eb 39                	jmp    8034f1 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8034b8:	a1 40 51 80 00       	mov    0x805140,%eax
  8034bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8034c0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034c4:	74 07                	je     8034cd <insert_sorted_with_merge_freeList+0x725>
  8034c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034c9:	8b 00                	mov    (%eax),%eax
  8034cb:	eb 05                	jmp    8034d2 <insert_sorted_with_merge_freeList+0x72a>
  8034cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8034d2:	a3 40 51 80 00       	mov    %eax,0x805140
  8034d7:	a1 40 51 80 00       	mov    0x805140,%eax
  8034dc:	85 c0                	test   %eax,%eax
  8034de:	0f 85 c7 fb ff ff    	jne    8030ab <insert_sorted_with_merge_freeList+0x303>
  8034e4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034e8:	0f 85 bd fb ff ff    	jne    8030ab <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8034ee:	eb 01                	jmp    8034f1 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8034f0:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8034f1:	90                   	nop
  8034f2:	c9                   	leave  
  8034f3:	c3                   	ret    

008034f4 <__udivdi3>:
  8034f4:	55                   	push   %ebp
  8034f5:	57                   	push   %edi
  8034f6:	56                   	push   %esi
  8034f7:	53                   	push   %ebx
  8034f8:	83 ec 1c             	sub    $0x1c,%esp
  8034fb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8034ff:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803503:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803507:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80350b:	89 ca                	mov    %ecx,%edx
  80350d:	89 f8                	mov    %edi,%eax
  80350f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803513:	85 f6                	test   %esi,%esi
  803515:	75 2d                	jne    803544 <__udivdi3+0x50>
  803517:	39 cf                	cmp    %ecx,%edi
  803519:	77 65                	ja     803580 <__udivdi3+0x8c>
  80351b:	89 fd                	mov    %edi,%ebp
  80351d:	85 ff                	test   %edi,%edi
  80351f:	75 0b                	jne    80352c <__udivdi3+0x38>
  803521:	b8 01 00 00 00       	mov    $0x1,%eax
  803526:	31 d2                	xor    %edx,%edx
  803528:	f7 f7                	div    %edi
  80352a:	89 c5                	mov    %eax,%ebp
  80352c:	31 d2                	xor    %edx,%edx
  80352e:	89 c8                	mov    %ecx,%eax
  803530:	f7 f5                	div    %ebp
  803532:	89 c1                	mov    %eax,%ecx
  803534:	89 d8                	mov    %ebx,%eax
  803536:	f7 f5                	div    %ebp
  803538:	89 cf                	mov    %ecx,%edi
  80353a:	89 fa                	mov    %edi,%edx
  80353c:	83 c4 1c             	add    $0x1c,%esp
  80353f:	5b                   	pop    %ebx
  803540:	5e                   	pop    %esi
  803541:	5f                   	pop    %edi
  803542:	5d                   	pop    %ebp
  803543:	c3                   	ret    
  803544:	39 ce                	cmp    %ecx,%esi
  803546:	77 28                	ja     803570 <__udivdi3+0x7c>
  803548:	0f bd fe             	bsr    %esi,%edi
  80354b:	83 f7 1f             	xor    $0x1f,%edi
  80354e:	75 40                	jne    803590 <__udivdi3+0x9c>
  803550:	39 ce                	cmp    %ecx,%esi
  803552:	72 0a                	jb     80355e <__udivdi3+0x6a>
  803554:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803558:	0f 87 9e 00 00 00    	ja     8035fc <__udivdi3+0x108>
  80355e:	b8 01 00 00 00       	mov    $0x1,%eax
  803563:	89 fa                	mov    %edi,%edx
  803565:	83 c4 1c             	add    $0x1c,%esp
  803568:	5b                   	pop    %ebx
  803569:	5e                   	pop    %esi
  80356a:	5f                   	pop    %edi
  80356b:	5d                   	pop    %ebp
  80356c:	c3                   	ret    
  80356d:	8d 76 00             	lea    0x0(%esi),%esi
  803570:	31 ff                	xor    %edi,%edi
  803572:	31 c0                	xor    %eax,%eax
  803574:	89 fa                	mov    %edi,%edx
  803576:	83 c4 1c             	add    $0x1c,%esp
  803579:	5b                   	pop    %ebx
  80357a:	5e                   	pop    %esi
  80357b:	5f                   	pop    %edi
  80357c:	5d                   	pop    %ebp
  80357d:	c3                   	ret    
  80357e:	66 90                	xchg   %ax,%ax
  803580:	89 d8                	mov    %ebx,%eax
  803582:	f7 f7                	div    %edi
  803584:	31 ff                	xor    %edi,%edi
  803586:	89 fa                	mov    %edi,%edx
  803588:	83 c4 1c             	add    $0x1c,%esp
  80358b:	5b                   	pop    %ebx
  80358c:	5e                   	pop    %esi
  80358d:	5f                   	pop    %edi
  80358e:	5d                   	pop    %ebp
  80358f:	c3                   	ret    
  803590:	bd 20 00 00 00       	mov    $0x20,%ebp
  803595:	89 eb                	mov    %ebp,%ebx
  803597:	29 fb                	sub    %edi,%ebx
  803599:	89 f9                	mov    %edi,%ecx
  80359b:	d3 e6                	shl    %cl,%esi
  80359d:	89 c5                	mov    %eax,%ebp
  80359f:	88 d9                	mov    %bl,%cl
  8035a1:	d3 ed                	shr    %cl,%ebp
  8035a3:	89 e9                	mov    %ebp,%ecx
  8035a5:	09 f1                	or     %esi,%ecx
  8035a7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8035ab:	89 f9                	mov    %edi,%ecx
  8035ad:	d3 e0                	shl    %cl,%eax
  8035af:	89 c5                	mov    %eax,%ebp
  8035b1:	89 d6                	mov    %edx,%esi
  8035b3:	88 d9                	mov    %bl,%cl
  8035b5:	d3 ee                	shr    %cl,%esi
  8035b7:	89 f9                	mov    %edi,%ecx
  8035b9:	d3 e2                	shl    %cl,%edx
  8035bb:	8b 44 24 08          	mov    0x8(%esp),%eax
  8035bf:	88 d9                	mov    %bl,%cl
  8035c1:	d3 e8                	shr    %cl,%eax
  8035c3:	09 c2                	or     %eax,%edx
  8035c5:	89 d0                	mov    %edx,%eax
  8035c7:	89 f2                	mov    %esi,%edx
  8035c9:	f7 74 24 0c          	divl   0xc(%esp)
  8035cd:	89 d6                	mov    %edx,%esi
  8035cf:	89 c3                	mov    %eax,%ebx
  8035d1:	f7 e5                	mul    %ebp
  8035d3:	39 d6                	cmp    %edx,%esi
  8035d5:	72 19                	jb     8035f0 <__udivdi3+0xfc>
  8035d7:	74 0b                	je     8035e4 <__udivdi3+0xf0>
  8035d9:	89 d8                	mov    %ebx,%eax
  8035db:	31 ff                	xor    %edi,%edi
  8035dd:	e9 58 ff ff ff       	jmp    80353a <__udivdi3+0x46>
  8035e2:	66 90                	xchg   %ax,%ax
  8035e4:	8b 54 24 08          	mov    0x8(%esp),%edx
  8035e8:	89 f9                	mov    %edi,%ecx
  8035ea:	d3 e2                	shl    %cl,%edx
  8035ec:	39 c2                	cmp    %eax,%edx
  8035ee:	73 e9                	jae    8035d9 <__udivdi3+0xe5>
  8035f0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8035f3:	31 ff                	xor    %edi,%edi
  8035f5:	e9 40 ff ff ff       	jmp    80353a <__udivdi3+0x46>
  8035fa:	66 90                	xchg   %ax,%ax
  8035fc:	31 c0                	xor    %eax,%eax
  8035fe:	e9 37 ff ff ff       	jmp    80353a <__udivdi3+0x46>
  803603:	90                   	nop

00803604 <__umoddi3>:
  803604:	55                   	push   %ebp
  803605:	57                   	push   %edi
  803606:	56                   	push   %esi
  803607:	53                   	push   %ebx
  803608:	83 ec 1c             	sub    $0x1c,%esp
  80360b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80360f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803613:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803617:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80361b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80361f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803623:	89 f3                	mov    %esi,%ebx
  803625:	89 fa                	mov    %edi,%edx
  803627:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80362b:	89 34 24             	mov    %esi,(%esp)
  80362e:	85 c0                	test   %eax,%eax
  803630:	75 1a                	jne    80364c <__umoddi3+0x48>
  803632:	39 f7                	cmp    %esi,%edi
  803634:	0f 86 a2 00 00 00    	jbe    8036dc <__umoddi3+0xd8>
  80363a:	89 c8                	mov    %ecx,%eax
  80363c:	89 f2                	mov    %esi,%edx
  80363e:	f7 f7                	div    %edi
  803640:	89 d0                	mov    %edx,%eax
  803642:	31 d2                	xor    %edx,%edx
  803644:	83 c4 1c             	add    $0x1c,%esp
  803647:	5b                   	pop    %ebx
  803648:	5e                   	pop    %esi
  803649:	5f                   	pop    %edi
  80364a:	5d                   	pop    %ebp
  80364b:	c3                   	ret    
  80364c:	39 f0                	cmp    %esi,%eax
  80364e:	0f 87 ac 00 00 00    	ja     803700 <__umoddi3+0xfc>
  803654:	0f bd e8             	bsr    %eax,%ebp
  803657:	83 f5 1f             	xor    $0x1f,%ebp
  80365a:	0f 84 ac 00 00 00    	je     80370c <__umoddi3+0x108>
  803660:	bf 20 00 00 00       	mov    $0x20,%edi
  803665:	29 ef                	sub    %ebp,%edi
  803667:	89 fe                	mov    %edi,%esi
  803669:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80366d:	89 e9                	mov    %ebp,%ecx
  80366f:	d3 e0                	shl    %cl,%eax
  803671:	89 d7                	mov    %edx,%edi
  803673:	89 f1                	mov    %esi,%ecx
  803675:	d3 ef                	shr    %cl,%edi
  803677:	09 c7                	or     %eax,%edi
  803679:	89 e9                	mov    %ebp,%ecx
  80367b:	d3 e2                	shl    %cl,%edx
  80367d:	89 14 24             	mov    %edx,(%esp)
  803680:	89 d8                	mov    %ebx,%eax
  803682:	d3 e0                	shl    %cl,%eax
  803684:	89 c2                	mov    %eax,%edx
  803686:	8b 44 24 08          	mov    0x8(%esp),%eax
  80368a:	d3 e0                	shl    %cl,%eax
  80368c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803690:	8b 44 24 08          	mov    0x8(%esp),%eax
  803694:	89 f1                	mov    %esi,%ecx
  803696:	d3 e8                	shr    %cl,%eax
  803698:	09 d0                	or     %edx,%eax
  80369a:	d3 eb                	shr    %cl,%ebx
  80369c:	89 da                	mov    %ebx,%edx
  80369e:	f7 f7                	div    %edi
  8036a0:	89 d3                	mov    %edx,%ebx
  8036a2:	f7 24 24             	mull   (%esp)
  8036a5:	89 c6                	mov    %eax,%esi
  8036a7:	89 d1                	mov    %edx,%ecx
  8036a9:	39 d3                	cmp    %edx,%ebx
  8036ab:	0f 82 87 00 00 00    	jb     803738 <__umoddi3+0x134>
  8036b1:	0f 84 91 00 00 00    	je     803748 <__umoddi3+0x144>
  8036b7:	8b 54 24 04          	mov    0x4(%esp),%edx
  8036bb:	29 f2                	sub    %esi,%edx
  8036bd:	19 cb                	sbb    %ecx,%ebx
  8036bf:	89 d8                	mov    %ebx,%eax
  8036c1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8036c5:	d3 e0                	shl    %cl,%eax
  8036c7:	89 e9                	mov    %ebp,%ecx
  8036c9:	d3 ea                	shr    %cl,%edx
  8036cb:	09 d0                	or     %edx,%eax
  8036cd:	89 e9                	mov    %ebp,%ecx
  8036cf:	d3 eb                	shr    %cl,%ebx
  8036d1:	89 da                	mov    %ebx,%edx
  8036d3:	83 c4 1c             	add    $0x1c,%esp
  8036d6:	5b                   	pop    %ebx
  8036d7:	5e                   	pop    %esi
  8036d8:	5f                   	pop    %edi
  8036d9:	5d                   	pop    %ebp
  8036da:	c3                   	ret    
  8036db:	90                   	nop
  8036dc:	89 fd                	mov    %edi,%ebp
  8036de:	85 ff                	test   %edi,%edi
  8036e0:	75 0b                	jne    8036ed <__umoddi3+0xe9>
  8036e2:	b8 01 00 00 00       	mov    $0x1,%eax
  8036e7:	31 d2                	xor    %edx,%edx
  8036e9:	f7 f7                	div    %edi
  8036eb:	89 c5                	mov    %eax,%ebp
  8036ed:	89 f0                	mov    %esi,%eax
  8036ef:	31 d2                	xor    %edx,%edx
  8036f1:	f7 f5                	div    %ebp
  8036f3:	89 c8                	mov    %ecx,%eax
  8036f5:	f7 f5                	div    %ebp
  8036f7:	89 d0                	mov    %edx,%eax
  8036f9:	e9 44 ff ff ff       	jmp    803642 <__umoddi3+0x3e>
  8036fe:	66 90                	xchg   %ax,%ax
  803700:	89 c8                	mov    %ecx,%eax
  803702:	89 f2                	mov    %esi,%edx
  803704:	83 c4 1c             	add    $0x1c,%esp
  803707:	5b                   	pop    %ebx
  803708:	5e                   	pop    %esi
  803709:	5f                   	pop    %edi
  80370a:	5d                   	pop    %ebp
  80370b:	c3                   	ret    
  80370c:	3b 04 24             	cmp    (%esp),%eax
  80370f:	72 06                	jb     803717 <__umoddi3+0x113>
  803711:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803715:	77 0f                	ja     803726 <__umoddi3+0x122>
  803717:	89 f2                	mov    %esi,%edx
  803719:	29 f9                	sub    %edi,%ecx
  80371b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80371f:	89 14 24             	mov    %edx,(%esp)
  803722:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803726:	8b 44 24 04          	mov    0x4(%esp),%eax
  80372a:	8b 14 24             	mov    (%esp),%edx
  80372d:	83 c4 1c             	add    $0x1c,%esp
  803730:	5b                   	pop    %ebx
  803731:	5e                   	pop    %esi
  803732:	5f                   	pop    %edi
  803733:	5d                   	pop    %ebp
  803734:	c3                   	ret    
  803735:	8d 76 00             	lea    0x0(%esi),%esi
  803738:	2b 04 24             	sub    (%esp),%eax
  80373b:	19 fa                	sbb    %edi,%edx
  80373d:	89 d1                	mov    %edx,%ecx
  80373f:	89 c6                	mov    %eax,%esi
  803741:	e9 71 ff ff ff       	jmp    8036b7 <__umoddi3+0xb3>
  803746:	66 90                	xchg   %ax,%ax
  803748:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80374c:	72 ea                	jb     803738 <__umoddi3+0x134>
  80374e:	89 d9                	mov    %ebx,%ecx
  803750:	e9 62 ff ff ff       	jmp    8036b7 <__umoddi3+0xb3>
