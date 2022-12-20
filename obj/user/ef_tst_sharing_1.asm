
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
  80008d:	68 60 39 80 00       	push   $0x803960
  800092:	6a 12                	push   $0x12
  800094:	68 7c 39 80 00       	push   $0x80397c
  800099:	e8 38 04 00 00       	call   8004d6 <_panic>
	}

	uint32 *x, *y, *z ;
	cprintf("STEP A: checking the creation of shared variables... \n");
  80009e:	83 ec 0c             	sub    $0xc,%esp
  8000a1:	68 94 39 80 00       	push   $0x803994
  8000a6:	e8 df 06 00 00       	call   80078a <cprintf>
  8000ab:	83 c4 10             	add    $0x10,%esp
	{
		int freeFrames = sys_calculate_free_frames() ;
  8000ae:	e8 7c 1a 00 00       	call   801b2f <sys_calculate_free_frames>
  8000b3:	89 45 e8             	mov    %eax,-0x18(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8000b6:	83 ec 04             	sub    $0x4,%esp
  8000b9:	6a 01                	push   $0x1
  8000bb:	68 00 10 00 00       	push   $0x1000
  8000c0:	68 cb 39 80 00       	push   $0x8039cb
  8000c5:	e8 93 17 00 00       	call   80185d <smalloc>
  8000ca:	83 c4 10             	add    $0x10,%esp
  8000cd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (x != (uint32*)USER_HEAP_START) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  8000d0:	81 7d e4 00 00 00 80 	cmpl   $0x80000000,-0x1c(%ebp)
  8000d7:	74 14                	je     8000ed <_main+0xb5>
  8000d9:	83 ec 04             	sub    $0x4,%esp
  8000dc:	68 d0 39 80 00       	push   $0x8039d0
  8000e1:	6a 1a                	push   $0x1a
  8000e3:	68 7c 39 80 00       	push   $0x80397c
  8000e8:	e8 e9 03 00 00       	call   8004d6 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage %d %d %d", freeFrames, sys_calculate_free_frames(), freeFrames - sys_calculate_free_frames());
  8000ed:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8000f0:	e8 3a 1a 00 00       	call   801b2f <sys_calculate_free_frames>
  8000f5:	29 c3                	sub    %eax,%ebx
  8000f7:	89 d8                	mov    %ebx,%eax
  8000f9:	83 f8 04             	cmp    $0x4,%eax
  8000fc:	74 28                	je     800126 <_main+0xee>
  8000fe:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800101:	e8 29 1a 00 00       	call   801b2f <sys_calculate_free_frames>
  800106:	29 c3                	sub    %eax,%ebx
  800108:	e8 22 1a 00 00       	call   801b2f <sys_calculate_free_frames>
  80010d:	83 ec 08             	sub    $0x8,%esp
  800110:	53                   	push   %ebx
  800111:	50                   	push   %eax
  800112:	ff 75 e8             	pushl  -0x18(%ebp)
  800115:	68 3c 3a 80 00       	push   $0x803a3c
  80011a:	6a 1b                	push   $0x1b
  80011c:	68 7c 39 80 00       	push   $0x80397c
  800121:	e8 b0 03 00 00       	call   8004d6 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800126:	e8 04 1a 00 00       	call   801b2f <sys_calculate_free_frames>
  80012b:	89 45 e8             	mov    %eax,-0x18(%ebp)
		z = smalloc("y", PAGE_SIZE + 4, 1);
  80012e:	83 ec 04             	sub    $0x4,%esp
  800131:	6a 01                	push   $0x1
  800133:	68 04 10 00 00       	push   $0x1004
  800138:	68 c3 3a 80 00       	push   $0x803ac3
  80013d:	e8 1b 17 00 00       	call   80185d <smalloc>
  800142:	83 c4 10             	add    $0x10,%esp
  800145:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (z != (uint32*)(USER_HEAP_START + 1 * PAGE_SIZE)) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  800148:	81 7d e0 00 10 00 80 	cmpl   $0x80001000,-0x20(%ebp)
  80014f:	74 14                	je     800165 <_main+0x12d>
  800151:	83 ec 04             	sub    $0x4,%esp
  800154:	68 d0 39 80 00       	push   $0x8039d0
  800159:	6a 1f                	push   $0x1f
  80015b:	68 7c 39 80 00       	push   $0x80397c
  800160:	e8 71 03 00 00       	call   8004d6 <_panic>

		if ((freeFrames - sys_calculate_free_frames()) !=  2+0+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage %d %d %d", freeFrames, sys_calculate_free_frames(), freeFrames - sys_calculate_free_frames());
  800165:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800168:	e8 c2 19 00 00       	call   801b2f <sys_calculate_free_frames>
  80016d:	29 c3                	sub    %eax,%ebx
  80016f:	89 d8                	mov    %ebx,%eax
  800171:	83 f8 04             	cmp    $0x4,%eax
  800174:	74 28                	je     80019e <_main+0x166>
  800176:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800179:	e8 b1 19 00 00       	call   801b2f <sys_calculate_free_frames>
  80017e:	29 c3                	sub    %eax,%ebx
  800180:	e8 aa 19 00 00       	call   801b2f <sys_calculate_free_frames>
  800185:	83 ec 08             	sub    $0x8,%esp
  800188:	53                   	push   %ebx
  800189:	50                   	push   %eax
  80018a:	ff 75 e8             	pushl  -0x18(%ebp)
  80018d:	68 3c 3a 80 00       	push   $0x803a3c
  800192:	6a 21                	push   $0x21
  800194:	68 7c 39 80 00       	push   $0x80397c
  800199:	e8 38 03 00 00       	call   8004d6 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  80019e:	e8 8c 19 00 00       	call   801b2f <sys_calculate_free_frames>
  8001a3:	89 45 e8             	mov    %eax,-0x18(%ebp)
		y = smalloc("z", 4, 1);
  8001a6:	83 ec 04             	sub    $0x4,%esp
  8001a9:	6a 01                	push   $0x1
  8001ab:	6a 04                	push   $0x4
  8001ad:	68 c5 3a 80 00       	push   $0x803ac5
  8001b2:	e8 a6 16 00 00       	call   80185d <smalloc>
  8001b7:	83 c4 10             	add    $0x10,%esp
  8001ba:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (y != (uint32*)(USER_HEAP_START + 3 * PAGE_SIZE)) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  8001bd:	81 7d dc 00 30 00 80 	cmpl   $0x80003000,-0x24(%ebp)
  8001c4:	74 14                	je     8001da <_main+0x1a2>
  8001c6:	83 ec 04             	sub    $0x4,%esp
  8001c9:	68 d0 39 80 00       	push   $0x8039d0
  8001ce:	6a 25                	push   $0x25
  8001d0:	68 7c 39 80 00       	push   $0x80397c
  8001d5:	e8 fc 02 00 00       	call   8004d6 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  1+0+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  8001da:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8001dd:	e8 4d 19 00 00       	call   801b2f <sys_calculate_free_frames>
  8001e2:	29 c3                	sub    %eax,%ebx
  8001e4:	89 d8                	mov    %ebx,%eax
  8001e6:	83 f8 03             	cmp    $0x3,%eax
  8001e9:	74 14                	je     8001ff <_main+0x1c7>
  8001eb:	83 ec 04             	sub    $0x4,%esp
  8001ee:	68 c8 3a 80 00       	push   $0x803ac8
  8001f3:	6a 26                	push   $0x26
  8001f5:	68 7c 39 80 00       	push   $0x80397c
  8001fa:	e8 d7 02 00 00       	call   8004d6 <_panic>
	}
	cprintf("Step A is completed successfully!!\n\n\n");
  8001ff:	83 ec 0c             	sub    $0xc,%esp
  800202:	68 48 3b 80 00       	push   $0x803b48
  800207:	e8 7e 05 00 00       	call   80078a <cprintf>
  80020c:	83 c4 10             	add    $0x10,%esp


	cprintf("STEP B: checking reading & writing... \n");
  80020f:	83 ec 0c             	sub    $0xc,%esp
  800212:	68 70 3b 80 00       	push   $0x803b70
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
  800295:	68 98 3b 80 00       	push   $0x803b98
  80029a:	6a 3a                	push   $0x3a
  80029c:	68 7c 39 80 00       	push   $0x80397c
  8002a1:	e8 30 02 00 00       	call   8004d6 <_panic>
		if( x[PAGE_SIZE/4 - 1] !=  -1)  	panic("Reading/Writing of shared object is failed");
  8002a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002a9:	05 fc 0f 00 00       	add    $0xffc,%eax
  8002ae:	8b 00                	mov    (%eax),%eax
  8002b0:	83 f8 ff             	cmp    $0xffffffff,%eax
  8002b3:	74 14                	je     8002c9 <_main+0x291>
  8002b5:	83 ec 04             	sub    $0x4,%esp
  8002b8:	68 98 3b 80 00       	push   $0x803b98
  8002bd:	6a 3b                	push   $0x3b
  8002bf:	68 7c 39 80 00       	push   $0x80397c
  8002c4:	e8 0d 02 00 00       	call   8004d6 <_panic>

		if( y[0] !=  -1)  					panic("Reading/Writing of shared object is failed");
  8002c9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002cc:	8b 00                	mov    (%eax),%eax
  8002ce:	83 f8 ff             	cmp    $0xffffffff,%eax
  8002d1:	74 14                	je     8002e7 <_main+0x2af>
  8002d3:	83 ec 04             	sub    $0x4,%esp
  8002d6:	68 98 3b 80 00       	push   $0x803b98
  8002db:	6a 3d                	push   $0x3d
  8002dd:	68 7c 39 80 00       	push   $0x80397c
  8002e2:	e8 ef 01 00 00       	call   8004d6 <_panic>
		if( y[PAGE_SIZE/4 - 1] !=  -1)  	panic("Reading/Writing of shared object is failed");
  8002e7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002ea:	05 fc 0f 00 00       	add    $0xffc,%eax
  8002ef:	8b 00                	mov    (%eax),%eax
  8002f1:	83 f8 ff             	cmp    $0xffffffff,%eax
  8002f4:	74 14                	je     80030a <_main+0x2d2>
  8002f6:	83 ec 04             	sub    $0x4,%esp
  8002f9:	68 98 3b 80 00       	push   $0x803b98
  8002fe:	6a 3e                	push   $0x3e
  800300:	68 7c 39 80 00       	push   $0x80397c
  800305:	e8 cc 01 00 00       	call   8004d6 <_panic>

		if( z[0] !=  -1)  					panic("Reading/Writing of shared object is failed");
  80030a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80030d:	8b 00                	mov    (%eax),%eax
  80030f:	83 f8 ff             	cmp    $0xffffffff,%eax
  800312:	74 14                	je     800328 <_main+0x2f0>
  800314:	83 ec 04             	sub    $0x4,%esp
  800317:	68 98 3b 80 00       	push   $0x803b98
  80031c:	6a 40                	push   $0x40
  80031e:	68 7c 39 80 00       	push   $0x80397c
  800323:	e8 ae 01 00 00       	call   8004d6 <_panic>
		if( z[2*PAGE_SIZE/4 - 1] !=  -1)  	panic("Reading/Writing of shared object is failed");
  800328:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80032b:	05 fc 1f 00 00       	add    $0x1ffc,%eax
  800330:	8b 00                	mov    (%eax),%eax
  800332:	83 f8 ff             	cmp    $0xffffffff,%eax
  800335:	74 14                	je     80034b <_main+0x313>
  800337:	83 ec 04             	sub    $0x4,%esp
  80033a:	68 98 3b 80 00       	push   $0x803b98
  80033f:	6a 41                	push   $0x41
  800341:	68 7c 39 80 00       	push   $0x80397c
  800346:	e8 8b 01 00 00       	call   8004d6 <_panic>
	}

	cprintf("Congratulations!! Test of Shared Variables [Create] [1] completed successfully!!\n\n\n");
  80034b:	83 ec 0c             	sub    $0xc,%esp
  80034e:	68 c4 3b 80 00       	push   $0x803bc4
  800353:	e8 32 04 00 00       	call   80078a <cprintf>
  800358:	83 c4 10             	add    $0x10,%esp

	int32 parentenvID = sys_getparentenvid();
  80035b:	e8 c8 1a 00 00       	call   801e28 <sys_getparentenvid>
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
  800373:	68 18 3c 80 00       	push   $0x803c18
  800378:	ff 75 d8             	pushl  -0x28(%ebp)
  80037b:	e8 8b 15 00 00       	call   80190b <sget>
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
  8003a0:	e8 6a 1a 00 00       	call   801e0f <sys_getenvindex>
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
  80040b:	e8 0c 18 00 00       	call   801c1c <sys_disable_interrupt>
	cprintf("**************************************\n");
  800410:	83 ec 0c             	sub    $0xc,%esp
  800413:	68 40 3c 80 00       	push   $0x803c40
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
  80043b:	68 68 3c 80 00       	push   $0x803c68
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
  80046c:	68 90 3c 80 00       	push   $0x803c90
  800471:	e8 14 03 00 00       	call   80078a <cprintf>
  800476:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800479:	a1 20 50 80 00       	mov    0x805020,%eax
  80047e:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800484:	83 ec 08             	sub    $0x8,%esp
  800487:	50                   	push   %eax
  800488:	68 e8 3c 80 00       	push   $0x803ce8
  80048d:	e8 f8 02 00 00       	call   80078a <cprintf>
  800492:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800495:	83 ec 0c             	sub    $0xc,%esp
  800498:	68 40 3c 80 00       	push   $0x803c40
  80049d:	e8 e8 02 00 00       	call   80078a <cprintf>
  8004a2:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8004a5:	e8 8c 17 00 00       	call   801c36 <sys_enable_interrupt>

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
  8004bd:	e8 19 19 00 00       	call   801ddb <sys_destroy_env>
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
  8004ce:	e8 6e 19 00 00       	call   801e41 <sys_exit_env>
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
  8004f7:	68 fc 3c 80 00       	push   $0x803cfc
  8004fc:	e8 89 02 00 00       	call   80078a <cprintf>
  800501:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800504:	a1 00 50 80 00       	mov    0x805000,%eax
  800509:	ff 75 0c             	pushl  0xc(%ebp)
  80050c:	ff 75 08             	pushl  0x8(%ebp)
  80050f:	50                   	push   %eax
  800510:	68 01 3d 80 00       	push   $0x803d01
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
  800534:	68 1d 3d 80 00       	push   $0x803d1d
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
  800560:	68 20 3d 80 00       	push   $0x803d20
  800565:	6a 26                	push   $0x26
  800567:	68 6c 3d 80 00       	push   $0x803d6c
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
  800632:	68 78 3d 80 00       	push   $0x803d78
  800637:	6a 3a                	push   $0x3a
  800639:	68 6c 3d 80 00       	push   $0x803d6c
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
  8006a2:	68 cc 3d 80 00       	push   $0x803dcc
  8006a7:	6a 44                	push   $0x44
  8006a9:	68 6c 3d 80 00       	push   $0x803d6c
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
  8006fc:	e8 6d 13 00 00       	call   801a6e <sys_cputs>
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
  800773:	e8 f6 12 00 00       	call   801a6e <sys_cputs>
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
  8007bd:	e8 5a 14 00 00       	call   801c1c <sys_disable_interrupt>
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
  8007dd:	e8 54 14 00 00       	call   801c36 <sys_enable_interrupt>
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
  800827:	e8 c8 2e 00 00       	call   8036f4 <__udivdi3>
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
  800877:	e8 88 2f 00 00       	call   803804 <__umoddi3>
  80087c:	83 c4 10             	add    $0x10,%esp
  80087f:	05 34 40 80 00       	add    $0x804034,%eax
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
  8009d2:	8b 04 85 58 40 80 00 	mov    0x804058(,%eax,4),%eax
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
  800ab3:	8b 34 9d a0 3e 80 00 	mov    0x803ea0(,%ebx,4),%esi
  800aba:	85 f6                	test   %esi,%esi
  800abc:	75 19                	jne    800ad7 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800abe:	53                   	push   %ebx
  800abf:	68 45 40 80 00       	push   $0x804045
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
  800ad8:	68 4e 40 80 00       	push   $0x80404e
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
  800b05:	be 51 40 80 00       	mov    $0x804051,%esi
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
  80152b:	68 b0 41 80 00       	push   $0x8041b0
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
  8015fb:	e8 b2 05 00 00       	call   801bb2 <sys_allocate_chunk>
  801600:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801603:	a1 20 51 80 00       	mov    0x805120,%eax
  801608:	83 ec 0c             	sub    $0xc,%esp
  80160b:	50                   	push   %eax
  80160c:	e8 27 0c 00 00       	call   802238 <initialize_MemBlocksList>
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
  801639:	68 d5 41 80 00       	push   $0x8041d5
  80163e:	6a 33                	push   $0x33
  801640:	68 f3 41 80 00       	push   $0x8041f3
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
  8016b8:	68 00 42 80 00       	push   $0x804200
  8016bd:	6a 34                	push   $0x34
  8016bf:	68 f3 41 80 00       	push   $0x8041f3
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
  801715:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801718:	e8 f7 fd ff ff       	call   801514 <InitializeUHeap>
	if (size == 0) return NULL ;
  80171d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801721:	75 07                	jne    80172a <malloc+0x18>
  801723:	b8 00 00 00 00       	mov    $0x0,%eax
  801728:	eb 61                	jmp    80178b <malloc+0x79>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
	uint32 malloc_allocsize=ROUNDUP(size,PAGE_SIZE);
  80172a:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801731:	8b 55 08             	mov    0x8(%ebp),%edx
  801734:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801737:	01 d0                	add    %edx,%eax
  801739:	48                   	dec    %eax
  80173a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80173d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801740:	ba 00 00 00 00       	mov    $0x0,%edx
  801745:	f7 75 f0             	divl   -0x10(%ebp)
  801748:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80174b:	29 d0                	sub    %edx,%eax
  80174d:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 //int ret=0;
	struct MemBlock * user_block;
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801750:	e8 2b 08 00 00       	call   801f80 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801755:	85 c0                	test   %eax,%eax
  801757:	74 11                	je     80176a <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  801759:	83 ec 0c             	sub    $0xc,%esp
  80175c:	ff 75 e8             	pushl  -0x18(%ebp)
  80175f:	e8 96 0e 00 00       	call   8025fa <alloc_block_FF>
  801764:	83 c4 10             	add    $0x10,%esp
  801767:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(user_block!=NULL)
  80176a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80176e:	74 16                	je     801786 <malloc+0x74>
	{
		//sys_allocate_chunk(user_block->sva,malloc_allocsize,PERM_WRITEABLE| PERM_PRESENT);
		insert_sorted_allocList(user_block);
  801770:	83 ec 0c             	sub    $0xc,%esp
  801773:	ff 75 f4             	pushl  -0xc(%ebp)
  801776:	e8 f2 0b 00 00       	call   80236d <insert_sorted_allocList>
  80177b:	83 c4 10             	add    $0x10,%esp
		return (uint32 *)user_block->sva;
  80177e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801781:	8b 40 08             	mov    0x8(%eax),%eax
  801784:	eb 05                	jmp    80178b <malloc+0x79>
	}

    return NULL;
  801786:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80178b:	c9                   	leave  
  80178c:	c3                   	ret    

0080178d <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  80178d:	55                   	push   %ebp
  80178e:	89 e5                	mov    %esp,%ebp
  801790:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	struct MemBlock * free_block=find_block(&AllocMemBlocksList,(uint32)virtual_address);
  801793:	8b 45 08             	mov    0x8(%ebp),%eax
  801796:	83 ec 08             	sub    $0x8,%esp
  801799:	50                   	push   %eax
  80179a:	68 40 50 80 00       	push   $0x805040
  80179f:	e8 71 0b 00 00       	call   802315 <find_block>
  8017a4:	83 c4 10             	add    $0x10,%esp
  8017a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(free_block!=NULL)
  8017aa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8017ae:	0f 84 a6 00 00 00    	je     80185a <free+0xcd>
	{
		sys_free_user_mem(free_block->sva,free_block->size);
  8017b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017b7:	8b 50 0c             	mov    0xc(%eax),%edx
  8017ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017bd:	8b 40 08             	mov    0x8(%eax),%eax
  8017c0:	83 ec 08             	sub    $0x8,%esp
  8017c3:	52                   	push   %edx
  8017c4:	50                   	push   %eax
  8017c5:	e8 b0 03 00 00       	call   801b7a <sys_free_user_mem>
  8017ca:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,free_block);
  8017cd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8017d1:	75 14                	jne    8017e7 <free+0x5a>
  8017d3:	83 ec 04             	sub    $0x4,%esp
  8017d6:	68 d5 41 80 00       	push   $0x8041d5
  8017db:	6a 74                	push   $0x74
  8017dd:	68 f3 41 80 00       	push   $0x8041f3
  8017e2:	e8 ef ec ff ff       	call   8004d6 <_panic>
  8017e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017ea:	8b 00                	mov    (%eax),%eax
  8017ec:	85 c0                	test   %eax,%eax
  8017ee:	74 10                	je     801800 <free+0x73>
  8017f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017f3:	8b 00                	mov    (%eax),%eax
  8017f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017f8:	8b 52 04             	mov    0x4(%edx),%edx
  8017fb:	89 50 04             	mov    %edx,0x4(%eax)
  8017fe:	eb 0b                	jmp    80180b <free+0x7e>
  801800:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801803:	8b 40 04             	mov    0x4(%eax),%eax
  801806:	a3 44 50 80 00       	mov    %eax,0x805044
  80180b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80180e:	8b 40 04             	mov    0x4(%eax),%eax
  801811:	85 c0                	test   %eax,%eax
  801813:	74 0f                	je     801824 <free+0x97>
  801815:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801818:	8b 40 04             	mov    0x4(%eax),%eax
  80181b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80181e:	8b 12                	mov    (%edx),%edx
  801820:	89 10                	mov    %edx,(%eax)
  801822:	eb 0a                	jmp    80182e <free+0xa1>
  801824:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801827:	8b 00                	mov    (%eax),%eax
  801829:	a3 40 50 80 00       	mov    %eax,0x805040
  80182e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801831:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801837:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80183a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801841:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801846:	48                   	dec    %eax
  801847:	a3 4c 50 80 00       	mov    %eax,0x80504c
		insert_sorted_with_merge_freeList(free_block);
  80184c:	83 ec 0c             	sub    $0xc,%esp
  80184f:	ff 75 f4             	pushl  -0xc(%ebp)
  801852:	e8 4e 17 00 00       	call   802fa5 <insert_sorted_with_merge_freeList>
  801857:	83 c4 10             	add    $0x10,%esp
	}

	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  80185a:	90                   	nop
  80185b:	c9                   	leave  
  80185c:	c3                   	ret    

0080185d <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80185d:	55                   	push   %ebp
  80185e:	89 e5                	mov    %esp,%ebp
  801860:	83 ec 38             	sub    $0x38,%esp
  801863:	8b 45 10             	mov    0x10(%ebp),%eax
  801866:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801869:	e8 a6 fc ff ff       	call   801514 <InitializeUHeap>
	if (size == 0) return NULL ;
  80186e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801872:	75 0a                	jne    80187e <smalloc+0x21>
  801874:	b8 00 00 00 00       	mov    $0x0,%eax
  801879:	e9 8b 00 00 00       	jmp    801909 <smalloc+0xac>
	//	   Else, return NULL

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  80187e:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801885:	8b 55 0c             	mov    0xc(%ebp),%edx
  801888:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80188b:	01 d0                	add    %edx,%eax
  80188d:	48                   	dec    %eax
  80188e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801891:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801894:	ba 00 00 00 00       	mov    $0x0,%edx
  801899:	f7 75 f0             	divl   -0x10(%ebp)
  80189c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80189f:	29 d0                	sub    %edx,%eax
  8018a1:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  8018a4:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  8018ab:	e8 d0 06 00 00       	call   801f80 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8018b0:	85 c0                	test   %eax,%eax
  8018b2:	74 11                	je     8018c5 <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  8018b4:	83 ec 0c             	sub    $0xc,%esp
  8018b7:	ff 75 e8             	pushl  -0x18(%ebp)
  8018ba:	e8 3b 0d 00 00       	call   8025fa <alloc_block_FF>
  8018bf:	83 c4 10             	add    $0x10,%esp
  8018c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(mem_block != NULL)
  8018c5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8018c9:	74 39                	je     801904 <smalloc+0xa7>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  8018cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018ce:	8b 40 08             	mov    0x8(%eax),%eax
  8018d1:	89 c2                	mov    %eax,%edx
  8018d3:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8018d7:	52                   	push   %edx
  8018d8:	50                   	push   %eax
  8018d9:	ff 75 0c             	pushl  0xc(%ebp)
  8018dc:	ff 75 08             	pushl  0x8(%ebp)
  8018df:	e8 21 04 00 00       	call   801d05 <sys_createSharedObject>
  8018e4:	83 c4 10             	add    $0x10,%esp
  8018e7:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  8018ea:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  8018ee:	74 14                	je     801904 <smalloc+0xa7>
  8018f0:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  8018f4:	74 0e                	je     801904 <smalloc+0xa7>
  8018f6:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  8018fa:	74 08                	je     801904 <smalloc+0xa7>
			return (void*) mem_block->sva;
  8018fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018ff:	8b 40 08             	mov    0x8(%eax),%eax
  801902:	eb 05                	jmp    801909 <smalloc+0xac>
	}
	return NULL;
  801904:	b8 00 00 00 00       	mov    $0x0,%eax

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801909:	c9                   	leave  
  80190a:	c3                   	ret    

0080190b <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80190b:	55                   	push   %ebp
  80190c:	89 e5                	mov    %esp,%ebp
  80190e:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801911:	e8 fe fb ff ff       	call   801514 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801916:	83 ec 08             	sub    $0x8,%esp
  801919:	ff 75 0c             	pushl  0xc(%ebp)
  80191c:	ff 75 08             	pushl  0x8(%ebp)
  80191f:	e8 0b 04 00 00       	call   801d2f <sys_getSizeOfSharedObject>
  801924:	83 c4 10             	add    $0x10,%esp
  801927:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size != E_SHARED_MEM_NOT_EXISTS)
  80192a:	83 7d f0 f0          	cmpl   $0xfffffff0,-0x10(%ebp)
  80192e:	74 76                	je     8019a6 <sget+0x9b>
	{
		uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801930:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801937:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80193a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80193d:	01 d0                	add    %edx,%eax
  80193f:	48                   	dec    %eax
  801940:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801943:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801946:	ba 00 00 00 00       	mov    $0x0,%edx
  80194b:	f7 75 ec             	divl   -0x14(%ebp)
  80194e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801951:	29 d0                	sub    %edx,%eax
  801953:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		struct MemBlock * mem_block = NULL;
  801956:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  80195d:	e8 1e 06 00 00       	call   801f80 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801962:	85 c0                	test   %eax,%eax
  801964:	74 11                	je     801977 <sget+0x6c>
			mem_block = alloc_block_FF(allocate_space);
  801966:	83 ec 0c             	sub    $0xc,%esp
  801969:	ff 75 e4             	pushl  -0x1c(%ebp)
  80196c:	e8 89 0c 00 00       	call   8025fa <alloc_block_FF>
  801971:	83 c4 10             	add    $0x10,%esp
  801974:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(mem_block != NULL)
  801977:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80197b:	74 29                	je     8019a6 <sget+0x9b>
		{
			uint32 shared_object_id = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)mem_block->sva);
  80197d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801980:	8b 40 08             	mov    0x8(%eax),%eax
  801983:	83 ec 04             	sub    $0x4,%esp
  801986:	50                   	push   %eax
  801987:	ff 75 0c             	pushl  0xc(%ebp)
  80198a:	ff 75 08             	pushl  0x8(%ebp)
  80198d:	e8 ba 03 00 00       	call   801d4c <sys_getSharedObject>
  801992:	83 c4 10             	add    $0x10,%esp
  801995:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (shared_object_id != E_SHARED_MEM_NOT_EXISTS)
  801998:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%ebp)
  80199c:	74 08                	je     8019a6 <sget+0x9b>
				return (void *)mem_block->sva;
  80199e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019a1:	8b 40 08             	mov    0x8(%eax),%eax
  8019a4:	eb 05                	jmp    8019ab <sget+0xa0>
		}
	}
	return NULL;
  8019a6:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8019ab:	c9                   	leave  
  8019ac:	c3                   	ret    

008019ad <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8019ad:	55                   	push   %ebp
  8019ae:	89 e5                	mov    %esp,%ebp
  8019b0:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8019b3:	e8 5c fb ff ff       	call   801514 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8019b8:	83 ec 04             	sub    $0x4,%esp
  8019bb:	68 24 42 80 00       	push   $0x804224
  8019c0:	68 f7 00 00 00       	push   $0xf7
  8019c5:	68 f3 41 80 00       	push   $0x8041f3
  8019ca:	e8 07 eb ff ff       	call   8004d6 <_panic>

008019cf <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8019cf:	55                   	push   %ebp
  8019d0:	89 e5                	mov    %esp,%ebp
  8019d2:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()


	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8019d5:	83 ec 04             	sub    $0x4,%esp
  8019d8:	68 4c 42 80 00       	push   $0x80424c
  8019dd:	68 0c 01 00 00       	push   $0x10c
  8019e2:	68 f3 41 80 00       	push   $0x8041f3
  8019e7:	e8 ea ea ff ff       	call   8004d6 <_panic>

008019ec <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8019ec:	55                   	push   %ebp
  8019ed:	89 e5                	mov    %esp,%ebp
  8019ef:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8019f2:	83 ec 04             	sub    $0x4,%esp
  8019f5:	68 70 42 80 00       	push   $0x804270
  8019fa:	68 44 01 00 00       	push   $0x144
  8019ff:	68 f3 41 80 00       	push   $0x8041f3
  801a04:	e8 cd ea ff ff       	call   8004d6 <_panic>

00801a09 <shrink>:

}
void shrink(uint32 newSize)
{
  801a09:	55                   	push   %ebp
  801a0a:	89 e5                	mov    %esp,%ebp
  801a0c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a0f:	83 ec 04             	sub    $0x4,%esp
  801a12:	68 70 42 80 00       	push   $0x804270
  801a17:	68 49 01 00 00       	push   $0x149
  801a1c:	68 f3 41 80 00       	push   $0x8041f3
  801a21:	e8 b0 ea ff ff       	call   8004d6 <_panic>

00801a26 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801a26:	55                   	push   %ebp
  801a27:	89 e5                	mov    %esp,%ebp
  801a29:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a2c:	83 ec 04             	sub    $0x4,%esp
  801a2f:	68 70 42 80 00       	push   $0x804270
  801a34:	68 4e 01 00 00       	push   $0x14e
  801a39:	68 f3 41 80 00       	push   $0x8041f3
  801a3e:	e8 93 ea ff ff       	call   8004d6 <_panic>

00801a43 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801a43:	55                   	push   %ebp
  801a44:	89 e5                	mov    %esp,%ebp
  801a46:	57                   	push   %edi
  801a47:	56                   	push   %esi
  801a48:	53                   	push   %ebx
  801a49:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801a4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a52:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a55:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a58:	8b 7d 18             	mov    0x18(%ebp),%edi
  801a5b:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801a5e:	cd 30                	int    $0x30
  801a60:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801a63:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801a66:	83 c4 10             	add    $0x10,%esp
  801a69:	5b                   	pop    %ebx
  801a6a:	5e                   	pop    %esi
  801a6b:	5f                   	pop    %edi
  801a6c:	5d                   	pop    %ebp
  801a6d:	c3                   	ret    

00801a6e <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801a6e:	55                   	push   %ebp
  801a6f:	89 e5                	mov    %esp,%ebp
  801a71:	83 ec 04             	sub    $0x4,%esp
  801a74:	8b 45 10             	mov    0x10(%ebp),%eax
  801a77:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801a7a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a81:	6a 00                	push   $0x0
  801a83:	6a 00                	push   $0x0
  801a85:	52                   	push   %edx
  801a86:	ff 75 0c             	pushl  0xc(%ebp)
  801a89:	50                   	push   %eax
  801a8a:	6a 00                	push   $0x0
  801a8c:	e8 b2 ff ff ff       	call   801a43 <syscall>
  801a91:	83 c4 18             	add    $0x18,%esp
}
  801a94:	90                   	nop
  801a95:	c9                   	leave  
  801a96:	c3                   	ret    

00801a97 <sys_cgetc>:

int
sys_cgetc(void)
{
  801a97:	55                   	push   %ebp
  801a98:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801a9a:	6a 00                	push   $0x0
  801a9c:	6a 00                	push   $0x0
  801a9e:	6a 00                	push   $0x0
  801aa0:	6a 00                	push   $0x0
  801aa2:	6a 00                	push   $0x0
  801aa4:	6a 01                	push   $0x1
  801aa6:	e8 98 ff ff ff       	call   801a43 <syscall>
  801aab:	83 c4 18             	add    $0x18,%esp
}
  801aae:	c9                   	leave  
  801aaf:	c3                   	ret    

00801ab0 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801ab0:	55                   	push   %ebp
  801ab1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801ab3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ab6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab9:	6a 00                	push   $0x0
  801abb:	6a 00                	push   $0x0
  801abd:	6a 00                	push   $0x0
  801abf:	52                   	push   %edx
  801ac0:	50                   	push   %eax
  801ac1:	6a 05                	push   $0x5
  801ac3:	e8 7b ff ff ff       	call   801a43 <syscall>
  801ac8:	83 c4 18             	add    $0x18,%esp
}
  801acb:	c9                   	leave  
  801acc:	c3                   	ret    

00801acd <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801acd:	55                   	push   %ebp
  801ace:	89 e5                	mov    %esp,%ebp
  801ad0:	56                   	push   %esi
  801ad1:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801ad2:	8b 75 18             	mov    0x18(%ebp),%esi
  801ad5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ad8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801adb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ade:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae1:	56                   	push   %esi
  801ae2:	53                   	push   %ebx
  801ae3:	51                   	push   %ecx
  801ae4:	52                   	push   %edx
  801ae5:	50                   	push   %eax
  801ae6:	6a 06                	push   $0x6
  801ae8:	e8 56 ff ff ff       	call   801a43 <syscall>
  801aed:	83 c4 18             	add    $0x18,%esp
}
  801af0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801af3:	5b                   	pop    %ebx
  801af4:	5e                   	pop    %esi
  801af5:	5d                   	pop    %ebp
  801af6:	c3                   	ret    

00801af7 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801af7:	55                   	push   %ebp
  801af8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801afa:	8b 55 0c             	mov    0xc(%ebp),%edx
  801afd:	8b 45 08             	mov    0x8(%ebp),%eax
  801b00:	6a 00                	push   $0x0
  801b02:	6a 00                	push   $0x0
  801b04:	6a 00                	push   $0x0
  801b06:	52                   	push   %edx
  801b07:	50                   	push   %eax
  801b08:	6a 07                	push   $0x7
  801b0a:	e8 34 ff ff ff       	call   801a43 <syscall>
  801b0f:	83 c4 18             	add    $0x18,%esp
}
  801b12:	c9                   	leave  
  801b13:	c3                   	ret    

00801b14 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801b14:	55                   	push   %ebp
  801b15:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801b17:	6a 00                	push   $0x0
  801b19:	6a 00                	push   $0x0
  801b1b:	6a 00                	push   $0x0
  801b1d:	ff 75 0c             	pushl  0xc(%ebp)
  801b20:	ff 75 08             	pushl  0x8(%ebp)
  801b23:	6a 08                	push   $0x8
  801b25:	e8 19 ff ff ff       	call   801a43 <syscall>
  801b2a:	83 c4 18             	add    $0x18,%esp
}
  801b2d:	c9                   	leave  
  801b2e:	c3                   	ret    

00801b2f <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801b2f:	55                   	push   %ebp
  801b30:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801b32:	6a 00                	push   $0x0
  801b34:	6a 00                	push   $0x0
  801b36:	6a 00                	push   $0x0
  801b38:	6a 00                	push   $0x0
  801b3a:	6a 00                	push   $0x0
  801b3c:	6a 09                	push   $0x9
  801b3e:	e8 00 ff ff ff       	call   801a43 <syscall>
  801b43:	83 c4 18             	add    $0x18,%esp
}
  801b46:	c9                   	leave  
  801b47:	c3                   	ret    

00801b48 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801b48:	55                   	push   %ebp
  801b49:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801b4b:	6a 00                	push   $0x0
  801b4d:	6a 00                	push   $0x0
  801b4f:	6a 00                	push   $0x0
  801b51:	6a 00                	push   $0x0
  801b53:	6a 00                	push   $0x0
  801b55:	6a 0a                	push   $0xa
  801b57:	e8 e7 fe ff ff       	call   801a43 <syscall>
  801b5c:	83 c4 18             	add    $0x18,%esp
}
  801b5f:	c9                   	leave  
  801b60:	c3                   	ret    

00801b61 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801b61:	55                   	push   %ebp
  801b62:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801b64:	6a 00                	push   $0x0
  801b66:	6a 00                	push   $0x0
  801b68:	6a 00                	push   $0x0
  801b6a:	6a 00                	push   $0x0
  801b6c:	6a 00                	push   $0x0
  801b6e:	6a 0b                	push   $0xb
  801b70:	e8 ce fe ff ff       	call   801a43 <syscall>
  801b75:	83 c4 18             	add    $0x18,%esp
}
  801b78:	c9                   	leave  
  801b79:	c3                   	ret    

00801b7a <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801b7a:	55                   	push   %ebp
  801b7b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801b7d:	6a 00                	push   $0x0
  801b7f:	6a 00                	push   $0x0
  801b81:	6a 00                	push   $0x0
  801b83:	ff 75 0c             	pushl  0xc(%ebp)
  801b86:	ff 75 08             	pushl  0x8(%ebp)
  801b89:	6a 0f                	push   $0xf
  801b8b:	e8 b3 fe ff ff       	call   801a43 <syscall>
  801b90:	83 c4 18             	add    $0x18,%esp
	return;
  801b93:	90                   	nop
}
  801b94:	c9                   	leave  
  801b95:	c3                   	ret    

00801b96 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801b96:	55                   	push   %ebp
  801b97:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801b99:	6a 00                	push   $0x0
  801b9b:	6a 00                	push   $0x0
  801b9d:	6a 00                	push   $0x0
  801b9f:	ff 75 0c             	pushl  0xc(%ebp)
  801ba2:	ff 75 08             	pushl  0x8(%ebp)
  801ba5:	6a 10                	push   $0x10
  801ba7:	e8 97 fe ff ff       	call   801a43 <syscall>
  801bac:	83 c4 18             	add    $0x18,%esp
	return ;
  801baf:	90                   	nop
}
  801bb0:	c9                   	leave  
  801bb1:	c3                   	ret    

00801bb2 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801bb2:	55                   	push   %ebp
  801bb3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801bb5:	6a 00                	push   $0x0
  801bb7:	6a 00                	push   $0x0
  801bb9:	ff 75 10             	pushl  0x10(%ebp)
  801bbc:	ff 75 0c             	pushl  0xc(%ebp)
  801bbf:	ff 75 08             	pushl  0x8(%ebp)
  801bc2:	6a 11                	push   $0x11
  801bc4:	e8 7a fe ff ff       	call   801a43 <syscall>
  801bc9:	83 c4 18             	add    $0x18,%esp
	return ;
  801bcc:	90                   	nop
}
  801bcd:	c9                   	leave  
  801bce:	c3                   	ret    

00801bcf <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801bcf:	55                   	push   %ebp
  801bd0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801bd2:	6a 00                	push   $0x0
  801bd4:	6a 00                	push   $0x0
  801bd6:	6a 00                	push   $0x0
  801bd8:	6a 00                	push   $0x0
  801bda:	6a 00                	push   $0x0
  801bdc:	6a 0c                	push   $0xc
  801bde:	e8 60 fe ff ff       	call   801a43 <syscall>
  801be3:	83 c4 18             	add    $0x18,%esp
}
  801be6:	c9                   	leave  
  801be7:	c3                   	ret    

00801be8 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801be8:	55                   	push   %ebp
  801be9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801beb:	6a 00                	push   $0x0
  801bed:	6a 00                	push   $0x0
  801bef:	6a 00                	push   $0x0
  801bf1:	6a 00                	push   $0x0
  801bf3:	ff 75 08             	pushl  0x8(%ebp)
  801bf6:	6a 0d                	push   $0xd
  801bf8:	e8 46 fe ff ff       	call   801a43 <syscall>
  801bfd:	83 c4 18             	add    $0x18,%esp
}
  801c00:	c9                   	leave  
  801c01:	c3                   	ret    

00801c02 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801c02:	55                   	push   %ebp
  801c03:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801c05:	6a 00                	push   $0x0
  801c07:	6a 00                	push   $0x0
  801c09:	6a 00                	push   $0x0
  801c0b:	6a 00                	push   $0x0
  801c0d:	6a 00                	push   $0x0
  801c0f:	6a 0e                	push   $0xe
  801c11:	e8 2d fe ff ff       	call   801a43 <syscall>
  801c16:	83 c4 18             	add    $0x18,%esp
}
  801c19:	90                   	nop
  801c1a:	c9                   	leave  
  801c1b:	c3                   	ret    

00801c1c <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801c1c:	55                   	push   %ebp
  801c1d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801c1f:	6a 00                	push   $0x0
  801c21:	6a 00                	push   $0x0
  801c23:	6a 00                	push   $0x0
  801c25:	6a 00                	push   $0x0
  801c27:	6a 00                	push   $0x0
  801c29:	6a 13                	push   $0x13
  801c2b:	e8 13 fe ff ff       	call   801a43 <syscall>
  801c30:	83 c4 18             	add    $0x18,%esp
}
  801c33:	90                   	nop
  801c34:	c9                   	leave  
  801c35:	c3                   	ret    

00801c36 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801c36:	55                   	push   %ebp
  801c37:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801c39:	6a 00                	push   $0x0
  801c3b:	6a 00                	push   $0x0
  801c3d:	6a 00                	push   $0x0
  801c3f:	6a 00                	push   $0x0
  801c41:	6a 00                	push   $0x0
  801c43:	6a 14                	push   $0x14
  801c45:	e8 f9 fd ff ff       	call   801a43 <syscall>
  801c4a:	83 c4 18             	add    $0x18,%esp
}
  801c4d:	90                   	nop
  801c4e:	c9                   	leave  
  801c4f:	c3                   	ret    

00801c50 <sys_cputc>:


void
sys_cputc(const char c)
{
  801c50:	55                   	push   %ebp
  801c51:	89 e5                	mov    %esp,%ebp
  801c53:	83 ec 04             	sub    $0x4,%esp
  801c56:	8b 45 08             	mov    0x8(%ebp),%eax
  801c59:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801c5c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c60:	6a 00                	push   $0x0
  801c62:	6a 00                	push   $0x0
  801c64:	6a 00                	push   $0x0
  801c66:	6a 00                	push   $0x0
  801c68:	50                   	push   %eax
  801c69:	6a 15                	push   $0x15
  801c6b:	e8 d3 fd ff ff       	call   801a43 <syscall>
  801c70:	83 c4 18             	add    $0x18,%esp
}
  801c73:	90                   	nop
  801c74:	c9                   	leave  
  801c75:	c3                   	ret    

00801c76 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801c76:	55                   	push   %ebp
  801c77:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801c79:	6a 00                	push   $0x0
  801c7b:	6a 00                	push   $0x0
  801c7d:	6a 00                	push   $0x0
  801c7f:	6a 00                	push   $0x0
  801c81:	6a 00                	push   $0x0
  801c83:	6a 16                	push   $0x16
  801c85:	e8 b9 fd ff ff       	call   801a43 <syscall>
  801c8a:	83 c4 18             	add    $0x18,%esp
}
  801c8d:	90                   	nop
  801c8e:	c9                   	leave  
  801c8f:	c3                   	ret    

00801c90 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801c90:	55                   	push   %ebp
  801c91:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801c93:	8b 45 08             	mov    0x8(%ebp),%eax
  801c96:	6a 00                	push   $0x0
  801c98:	6a 00                	push   $0x0
  801c9a:	6a 00                	push   $0x0
  801c9c:	ff 75 0c             	pushl  0xc(%ebp)
  801c9f:	50                   	push   %eax
  801ca0:	6a 17                	push   $0x17
  801ca2:	e8 9c fd ff ff       	call   801a43 <syscall>
  801ca7:	83 c4 18             	add    $0x18,%esp
}
  801caa:	c9                   	leave  
  801cab:	c3                   	ret    

00801cac <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801cac:	55                   	push   %ebp
  801cad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801caf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cb2:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb5:	6a 00                	push   $0x0
  801cb7:	6a 00                	push   $0x0
  801cb9:	6a 00                	push   $0x0
  801cbb:	52                   	push   %edx
  801cbc:	50                   	push   %eax
  801cbd:	6a 1a                	push   $0x1a
  801cbf:	e8 7f fd ff ff       	call   801a43 <syscall>
  801cc4:	83 c4 18             	add    $0x18,%esp
}
  801cc7:	c9                   	leave  
  801cc8:	c3                   	ret    

00801cc9 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801cc9:	55                   	push   %ebp
  801cca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ccc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ccf:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd2:	6a 00                	push   $0x0
  801cd4:	6a 00                	push   $0x0
  801cd6:	6a 00                	push   $0x0
  801cd8:	52                   	push   %edx
  801cd9:	50                   	push   %eax
  801cda:	6a 18                	push   $0x18
  801cdc:	e8 62 fd ff ff       	call   801a43 <syscall>
  801ce1:	83 c4 18             	add    $0x18,%esp
}
  801ce4:	90                   	nop
  801ce5:	c9                   	leave  
  801ce6:	c3                   	ret    

00801ce7 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801ce7:	55                   	push   %ebp
  801ce8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801cea:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ced:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf0:	6a 00                	push   $0x0
  801cf2:	6a 00                	push   $0x0
  801cf4:	6a 00                	push   $0x0
  801cf6:	52                   	push   %edx
  801cf7:	50                   	push   %eax
  801cf8:	6a 19                	push   $0x19
  801cfa:	e8 44 fd ff ff       	call   801a43 <syscall>
  801cff:	83 c4 18             	add    $0x18,%esp
}
  801d02:	90                   	nop
  801d03:	c9                   	leave  
  801d04:	c3                   	ret    

00801d05 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801d05:	55                   	push   %ebp
  801d06:	89 e5                	mov    %esp,%ebp
  801d08:	83 ec 04             	sub    $0x4,%esp
  801d0b:	8b 45 10             	mov    0x10(%ebp),%eax
  801d0e:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801d11:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801d14:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801d18:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1b:	6a 00                	push   $0x0
  801d1d:	51                   	push   %ecx
  801d1e:	52                   	push   %edx
  801d1f:	ff 75 0c             	pushl  0xc(%ebp)
  801d22:	50                   	push   %eax
  801d23:	6a 1b                	push   $0x1b
  801d25:	e8 19 fd ff ff       	call   801a43 <syscall>
  801d2a:	83 c4 18             	add    $0x18,%esp
}
  801d2d:	c9                   	leave  
  801d2e:	c3                   	ret    

00801d2f <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801d2f:	55                   	push   %ebp
  801d30:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801d32:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d35:	8b 45 08             	mov    0x8(%ebp),%eax
  801d38:	6a 00                	push   $0x0
  801d3a:	6a 00                	push   $0x0
  801d3c:	6a 00                	push   $0x0
  801d3e:	52                   	push   %edx
  801d3f:	50                   	push   %eax
  801d40:	6a 1c                	push   $0x1c
  801d42:	e8 fc fc ff ff       	call   801a43 <syscall>
  801d47:	83 c4 18             	add    $0x18,%esp
}
  801d4a:	c9                   	leave  
  801d4b:	c3                   	ret    

00801d4c <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801d4c:	55                   	push   %ebp
  801d4d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801d4f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d52:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d55:	8b 45 08             	mov    0x8(%ebp),%eax
  801d58:	6a 00                	push   $0x0
  801d5a:	6a 00                	push   $0x0
  801d5c:	51                   	push   %ecx
  801d5d:	52                   	push   %edx
  801d5e:	50                   	push   %eax
  801d5f:	6a 1d                	push   $0x1d
  801d61:	e8 dd fc ff ff       	call   801a43 <syscall>
  801d66:	83 c4 18             	add    $0x18,%esp
}
  801d69:	c9                   	leave  
  801d6a:	c3                   	ret    

00801d6b <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801d6b:	55                   	push   %ebp
  801d6c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801d6e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d71:	8b 45 08             	mov    0x8(%ebp),%eax
  801d74:	6a 00                	push   $0x0
  801d76:	6a 00                	push   $0x0
  801d78:	6a 00                	push   $0x0
  801d7a:	52                   	push   %edx
  801d7b:	50                   	push   %eax
  801d7c:	6a 1e                	push   $0x1e
  801d7e:	e8 c0 fc ff ff       	call   801a43 <syscall>
  801d83:	83 c4 18             	add    $0x18,%esp
}
  801d86:	c9                   	leave  
  801d87:	c3                   	ret    

00801d88 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801d88:	55                   	push   %ebp
  801d89:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801d8b:	6a 00                	push   $0x0
  801d8d:	6a 00                	push   $0x0
  801d8f:	6a 00                	push   $0x0
  801d91:	6a 00                	push   $0x0
  801d93:	6a 00                	push   $0x0
  801d95:	6a 1f                	push   $0x1f
  801d97:	e8 a7 fc ff ff       	call   801a43 <syscall>
  801d9c:	83 c4 18             	add    $0x18,%esp
}
  801d9f:	c9                   	leave  
  801da0:	c3                   	ret    

00801da1 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801da1:	55                   	push   %ebp
  801da2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801da4:	8b 45 08             	mov    0x8(%ebp),%eax
  801da7:	6a 00                	push   $0x0
  801da9:	ff 75 14             	pushl  0x14(%ebp)
  801dac:	ff 75 10             	pushl  0x10(%ebp)
  801daf:	ff 75 0c             	pushl  0xc(%ebp)
  801db2:	50                   	push   %eax
  801db3:	6a 20                	push   $0x20
  801db5:	e8 89 fc ff ff       	call   801a43 <syscall>
  801dba:	83 c4 18             	add    $0x18,%esp
}
  801dbd:	c9                   	leave  
  801dbe:	c3                   	ret    

00801dbf <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801dbf:	55                   	push   %ebp
  801dc0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801dc2:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc5:	6a 00                	push   $0x0
  801dc7:	6a 00                	push   $0x0
  801dc9:	6a 00                	push   $0x0
  801dcb:	6a 00                	push   $0x0
  801dcd:	50                   	push   %eax
  801dce:	6a 21                	push   $0x21
  801dd0:	e8 6e fc ff ff       	call   801a43 <syscall>
  801dd5:	83 c4 18             	add    $0x18,%esp
}
  801dd8:	90                   	nop
  801dd9:	c9                   	leave  
  801dda:	c3                   	ret    

00801ddb <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801ddb:	55                   	push   %ebp
  801ddc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801dde:	8b 45 08             	mov    0x8(%ebp),%eax
  801de1:	6a 00                	push   $0x0
  801de3:	6a 00                	push   $0x0
  801de5:	6a 00                	push   $0x0
  801de7:	6a 00                	push   $0x0
  801de9:	50                   	push   %eax
  801dea:	6a 22                	push   $0x22
  801dec:	e8 52 fc ff ff       	call   801a43 <syscall>
  801df1:	83 c4 18             	add    $0x18,%esp
}
  801df4:	c9                   	leave  
  801df5:	c3                   	ret    

00801df6 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801df6:	55                   	push   %ebp
  801df7:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801df9:	6a 00                	push   $0x0
  801dfb:	6a 00                	push   $0x0
  801dfd:	6a 00                	push   $0x0
  801dff:	6a 00                	push   $0x0
  801e01:	6a 00                	push   $0x0
  801e03:	6a 02                	push   $0x2
  801e05:	e8 39 fc ff ff       	call   801a43 <syscall>
  801e0a:	83 c4 18             	add    $0x18,%esp
}
  801e0d:	c9                   	leave  
  801e0e:	c3                   	ret    

00801e0f <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801e0f:	55                   	push   %ebp
  801e10:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801e12:	6a 00                	push   $0x0
  801e14:	6a 00                	push   $0x0
  801e16:	6a 00                	push   $0x0
  801e18:	6a 00                	push   $0x0
  801e1a:	6a 00                	push   $0x0
  801e1c:	6a 03                	push   $0x3
  801e1e:	e8 20 fc ff ff       	call   801a43 <syscall>
  801e23:	83 c4 18             	add    $0x18,%esp
}
  801e26:	c9                   	leave  
  801e27:	c3                   	ret    

00801e28 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801e28:	55                   	push   %ebp
  801e29:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801e2b:	6a 00                	push   $0x0
  801e2d:	6a 00                	push   $0x0
  801e2f:	6a 00                	push   $0x0
  801e31:	6a 00                	push   $0x0
  801e33:	6a 00                	push   $0x0
  801e35:	6a 04                	push   $0x4
  801e37:	e8 07 fc ff ff       	call   801a43 <syscall>
  801e3c:	83 c4 18             	add    $0x18,%esp
}
  801e3f:	c9                   	leave  
  801e40:	c3                   	ret    

00801e41 <sys_exit_env>:


void sys_exit_env(void)
{
  801e41:	55                   	push   %ebp
  801e42:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801e44:	6a 00                	push   $0x0
  801e46:	6a 00                	push   $0x0
  801e48:	6a 00                	push   $0x0
  801e4a:	6a 00                	push   $0x0
  801e4c:	6a 00                	push   $0x0
  801e4e:	6a 23                	push   $0x23
  801e50:	e8 ee fb ff ff       	call   801a43 <syscall>
  801e55:	83 c4 18             	add    $0x18,%esp
}
  801e58:	90                   	nop
  801e59:	c9                   	leave  
  801e5a:	c3                   	ret    

00801e5b <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801e5b:	55                   	push   %ebp
  801e5c:	89 e5                	mov    %esp,%ebp
  801e5e:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801e61:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e64:	8d 50 04             	lea    0x4(%eax),%edx
  801e67:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e6a:	6a 00                	push   $0x0
  801e6c:	6a 00                	push   $0x0
  801e6e:	6a 00                	push   $0x0
  801e70:	52                   	push   %edx
  801e71:	50                   	push   %eax
  801e72:	6a 24                	push   $0x24
  801e74:	e8 ca fb ff ff       	call   801a43 <syscall>
  801e79:	83 c4 18             	add    $0x18,%esp
	return result;
  801e7c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e7f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e82:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e85:	89 01                	mov    %eax,(%ecx)
  801e87:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801e8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e8d:	c9                   	leave  
  801e8e:	c2 04 00             	ret    $0x4

00801e91 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801e91:	55                   	push   %ebp
  801e92:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801e94:	6a 00                	push   $0x0
  801e96:	6a 00                	push   $0x0
  801e98:	ff 75 10             	pushl  0x10(%ebp)
  801e9b:	ff 75 0c             	pushl  0xc(%ebp)
  801e9e:	ff 75 08             	pushl  0x8(%ebp)
  801ea1:	6a 12                	push   $0x12
  801ea3:	e8 9b fb ff ff       	call   801a43 <syscall>
  801ea8:	83 c4 18             	add    $0x18,%esp
	return ;
  801eab:	90                   	nop
}
  801eac:	c9                   	leave  
  801ead:	c3                   	ret    

00801eae <sys_rcr2>:
uint32 sys_rcr2()
{
  801eae:	55                   	push   %ebp
  801eaf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801eb1:	6a 00                	push   $0x0
  801eb3:	6a 00                	push   $0x0
  801eb5:	6a 00                	push   $0x0
  801eb7:	6a 00                	push   $0x0
  801eb9:	6a 00                	push   $0x0
  801ebb:	6a 25                	push   $0x25
  801ebd:	e8 81 fb ff ff       	call   801a43 <syscall>
  801ec2:	83 c4 18             	add    $0x18,%esp
}
  801ec5:	c9                   	leave  
  801ec6:	c3                   	ret    

00801ec7 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801ec7:	55                   	push   %ebp
  801ec8:	89 e5                	mov    %esp,%ebp
  801eca:	83 ec 04             	sub    $0x4,%esp
  801ecd:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801ed3:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801ed7:	6a 00                	push   $0x0
  801ed9:	6a 00                	push   $0x0
  801edb:	6a 00                	push   $0x0
  801edd:	6a 00                	push   $0x0
  801edf:	50                   	push   %eax
  801ee0:	6a 26                	push   $0x26
  801ee2:	e8 5c fb ff ff       	call   801a43 <syscall>
  801ee7:	83 c4 18             	add    $0x18,%esp
	return ;
  801eea:	90                   	nop
}
  801eeb:	c9                   	leave  
  801eec:	c3                   	ret    

00801eed <rsttst>:
void rsttst()
{
  801eed:	55                   	push   %ebp
  801eee:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801ef0:	6a 00                	push   $0x0
  801ef2:	6a 00                	push   $0x0
  801ef4:	6a 00                	push   $0x0
  801ef6:	6a 00                	push   $0x0
  801ef8:	6a 00                	push   $0x0
  801efa:	6a 28                	push   $0x28
  801efc:	e8 42 fb ff ff       	call   801a43 <syscall>
  801f01:	83 c4 18             	add    $0x18,%esp
	return ;
  801f04:	90                   	nop
}
  801f05:	c9                   	leave  
  801f06:	c3                   	ret    

00801f07 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801f07:	55                   	push   %ebp
  801f08:	89 e5                	mov    %esp,%ebp
  801f0a:	83 ec 04             	sub    $0x4,%esp
  801f0d:	8b 45 14             	mov    0x14(%ebp),%eax
  801f10:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801f13:	8b 55 18             	mov    0x18(%ebp),%edx
  801f16:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801f1a:	52                   	push   %edx
  801f1b:	50                   	push   %eax
  801f1c:	ff 75 10             	pushl  0x10(%ebp)
  801f1f:	ff 75 0c             	pushl  0xc(%ebp)
  801f22:	ff 75 08             	pushl  0x8(%ebp)
  801f25:	6a 27                	push   $0x27
  801f27:	e8 17 fb ff ff       	call   801a43 <syscall>
  801f2c:	83 c4 18             	add    $0x18,%esp
	return ;
  801f2f:	90                   	nop
}
  801f30:	c9                   	leave  
  801f31:	c3                   	ret    

00801f32 <chktst>:
void chktst(uint32 n)
{
  801f32:	55                   	push   %ebp
  801f33:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801f35:	6a 00                	push   $0x0
  801f37:	6a 00                	push   $0x0
  801f39:	6a 00                	push   $0x0
  801f3b:	6a 00                	push   $0x0
  801f3d:	ff 75 08             	pushl  0x8(%ebp)
  801f40:	6a 29                	push   $0x29
  801f42:	e8 fc fa ff ff       	call   801a43 <syscall>
  801f47:	83 c4 18             	add    $0x18,%esp
	return ;
  801f4a:	90                   	nop
}
  801f4b:	c9                   	leave  
  801f4c:	c3                   	ret    

00801f4d <inctst>:

void inctst()
{
  801f4d:	55                   	push   %ebp
  801f4e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801f50:	6a 00                	push   $0x0
  801f52:	6a 00                	push   $0x0
  801f54:	6a 00                	push   $0x0
  801f56:	6a 00                	push   $0x0
  801f58:	6a 00                	push   $0x0
  801f5a:	6a 2a                	push   $0x2a
  801f5c:	e8 e2 fa ff ff       	call   801a43 <syscall>
  801f61:	83 c4 18             	add    $0x18,%esp
	return ;
  801f64:	90                   	nop
}
  801f65:	c9                   	leave  
  801f66:	c3                   	ret    

00801f67 <gettst>:
uint32 gettst()
{
  801f67:	55                   	push   %ebp
  801f68:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801f6a:	6a 00                	push   $0x0
  801f6c:	6a 00                	push   $0x0
  801f6e:	6a 00                	push   $0x0
  801f70:	6a 00                	push   $0x0
  801f72:	6a 00                	push   $0x0
  801f74:	6a 2b                	push   $0x2b
  801f76:	e8 c8 fa ff ff       	call   801a43 <syscall>
  801f7b:	83 c4 18             	add    $0x18,%esp
}
  801f7e:	c9                   	leave  
  801f7f:	c3                   	ret    

00801f80 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801f80:	55                   	push   %ebp
  801f81:	89 e5                	mov    %esp,%ebp
  801f83:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f86:	6a 00                	push   $0x0
  801f88:	6a 00                	push   $0x0
  801f8a:	6a 00                	push   $0x0
  801f8c:	6a 00                	push   $0x0
  801f8e:	6a 00                	push   $0x0
  801f90:	6a 2c                	push   $0x2c
  801f92:	e8 ac fa ff ff       	call   801a43 <syscall>
  801f97:	83 c4 18             	add    $0x18,%esp
  801f9a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801f9d:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801fa1:	75 07                	jne    801faa <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801fa3:	b8 01 00 00 00       	mov    $0x1,%eax
  801fa8:	eb 05                	jmp    801faf <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801faa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801faf:	c9                   	leave  
  801fb0:	c3                   	ret    

00801fb1 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801fb1:	55                   	push   %ebp
  801fb2:	89 e5                	mov    %esp,%ebp
  801fb4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fb7:	6a 00                	push   $0x0
  801fb9:	6a 00                	push   $0x0
  801fbb:	6a 00                	push   $0x0
  801fbd:	6a 00                	push   $0x0
  801fbf:	6a 00                	push   $0x0
  801fc1:	6a 2c                	push   $0x2c
  801fc3:	e8 7b fa ff ff       	call   801a43 <syscall>
  801fc8:	83 c4 18             	add    $0x18,%esp
  801fcb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801fce:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801fd2:	75 07                	jne    801fdb <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801fd4:	b8 01 00 00 00       	mov    $0x1,%eax
  801fd9:	eb 05                	jmp    801fe0 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801fdb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fe0:	c9                   	leave  
  801fe1:	c3                   	ret    

00801fe2 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801fe2:	55                   	push   %ebp
  801fe3:	89 e5                	mov    %esp,%ebp
  801fe5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fe8:	6a 00                	push   $0x0
  801fea:	6a 00                	push   $0x0
  801fec:	6a 00                	push   $0x0
  801fee:	6a 00                	push   $0x0
  801ff0:	6a 00                	push   $0x0
  801ff2:	6a 2c                	push   $0x2c
  801ff4:	e8 4a fa ff ff       	call   801a43 <syscall>
  801ff9:	83 c4 18             	add    $0x18,%esp
  801ffc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801fff:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802003:	75 07                	jne    80200c <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802005:	b8 01 00 00 00       	mov    $0x1,%eax
  80200a:	eb 05                	jmp    802011 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80200c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802011:	c9                   	leave  
  802012:	c3                   	ret    

00802013 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802013:	55                   	push   %ebp
  802014:	89 e5                	mov    %esp,%ebp
  802016:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802019:	6a 00                	push   $0x0
  80201b:	6a 00                	push   $0x0
  80201d:	6a 00                	push   $0x0
  80201f:	6a 00                	push   $0x0
  802021:	6a 00                	push   $0x0
  802023:	6a 2c                	push   $0x2c
  802025:	e8 19 fa ff ff       	call   801a43 <syscall>
  80202a:	83 c4 18             	add    $0x18,%esp
  80202d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802030:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802034:	75 07                	jne    80203d <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802036:	b8 01 00 00 00       	mov    $0x1,%eax
  80203b:	eb 05                	jmp    802042 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80203d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802042:	c9                   	leave  
  802043:	c3                   	ret    

00802044 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802044:	55                   	push   %ebp
  802045:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802047:	6a 00                	push   $0x0
  802049:	6a 00                	push   $0x0
  80204b:	6a 00                	push   $0x0
  80204d:	6a 00                	push   $0x0
  80204f:	ff 75 08             	pushl  0x8(%ebp)
  802052:	6a 2d                	push   $0x2d
  802054:	e8 ea f9 ff ff       	call   801a43 <syscall>
  802059:	83 c4 18             	add    $0x18,%esp
	return ;
  80205c:	90                   	nop
}
  80205d:	c9                   	leave  
  80205e:	c3                   	ret    

0080205f <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80205f:	55                   	push   %ebp
  802060:	89 e5                	mov    %esp,%ebp
  802062:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802063:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802066:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802069:	8b 55 0c             	mov    0xc(%ebp),%edx
  80206c:	8b 45 08             	mov    0x8(%ebp),%eax
  80206f:	6a 00                	push   $0x0
  802071:	53                   	push   %ebx
  802072:	51                   	push   %ecx
  802073:	52                   	push   %edx
  802074:	50                   	push   %eax
  802075:	6a 2e                	push   $0x2e
  802077:	e8 c7 f9 ff ff       	call   801a43 <syscall>
  80207c:	83 c4 18             	add    $0x18,%esp
}
  80207f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802082:	c9                   	leave  
  802083:	c3                   	ret    

00802084 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802084:	55                   	push   %ebp
  802085:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802087:	8b 55 0c             	mov    0xc(%ebp),%edx
  80208a:	8b 45 08             	mov    0x8(%ebp),%eax
  80208d:	6a 00                	push   $0x0
  80208f:	6a 00                	push   $0x0
  802091:	6a 00                	push   $0x0
  802093:	52                   	push   %edx
  802094:	50                   	push   %eax
  802095:	6a 2f                	push   $0x2f
  802097:	e8 a7 f9 ff ff       	call   801a43 <syscall>
  80209c:	83 c4 18             	add    $0x18,%esp
}
  80209f:	c9                   	leave  
  8020a0:	c3                   	ret    

008020a1 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  8020a1:	55                   	push   %ebp
  8020a2:	89 e5                	mov    %esp,%ebp
  8020a4:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  8020a7:	83 ec 0c             	sub    $0xc,%esp
  8020aa:	68 80 42 80 00       	push   $0x804280
  8020af:	e8 d6 e6 ff ff       	call   80078a <cprintf>
  8020b4:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  8020b7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8020be:	83 ec 0c             	sub    $0xc,%esp
  8020c1:	68 ac 42 80 00       	push   $0x8042ac
  8020c6:	e8 bf e6 ff ff       	call   80078a <cprintf>
  8020cb:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8020ce:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8020d2:	a1 38 51 80 00       	mov    0x805138,%eax
  8020d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020da:	eb 56                	jmp    802132 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8020dc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8020e0:	74 1c                	je     8020fe <print_mem_block_lists+0x5d>
  8020e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e5:	8b 50 08             	mov    0x8(%eax),%edx
  8020e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020eb:	8b 48 08             	mov    0x8(%eax),%ecx
  8020ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020f1:	8b 40 0c             	mov    0xc(%eax),%eax
  8020f4:	01 c8                	add    %ecx,%eax
  8020f6:	39 c2                	cmp    %eax,%edx
  8020f8:	73 04                	jae    8020fe <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8020fa:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8020fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802101:	8b 50 08             	mov    0x8(%eax),%edx
  802104:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802107:	8b 40 0c             	mov    0xc(%eax),%eax
  80210a:	01 c2                	add    %eax,%edx
  80210c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80210f:	8b 40 08             	mov    0x8(%eax),%eax
  802112:	83 ec 04             	sub    $0x4,%esp
  802115:	52                   	push   %edx
  802116:	50                   	push   %eax
  802117:	68 c1 42 80 00       	push   $0x8042c1
  80211c:	e8 69 e6 ff ff       	call   80078a <cprintf>
  802121:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802124:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802127:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80212a:	a1 40 51 80 00       	mov    0x805140,%eax
  80212f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802132:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802136:	74 07                	je     80213f <print_mem_block_lists+0x9e>
  802138:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80213b:	8b 00                	mov    (%eax),%eax
  80213d:	eb 05                	jmp    802144 <print_mem_block_lists+0xa3>
  80213f:	b8 00 00 00 00       	mov    $0x0,%eax
  802144:	a3 40 51 80 00       	mov    %eax,0x805140
  802149:	a1 40 51 80 00       	mov    0x805140,%eax
  80214e:	85 c0                	test   %eax,%eax
  802150:	75 8a                	jne    8020dc <print_mem_block_lists+0x3b>
  802152:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802156:	75 84                	jne    8020dc <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802158:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80215c:	75 10                	jne    80216e <print_mem_block_lists+0xcd>
  80215e:	83 ec 0c             	sub    $0xc,%esp
  802161:	68 d0 42 80 00       	push   $0x8042d0
  802166:	e8 1f e6 ff ff       	call   80078a <cprintf>
  80216b:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  80216e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802175:	83 ec 0c             	sub    $0xc,%esp
  802178:	68 f4 42 80 00       	push   $0x8042f4
  80217d:	e8 08 e6 ff ff       	call   80078a <cprintf>
  802182:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802185:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802189:	a1 40 50 80 00       	mov    0x805040,%eax
  80218e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802191:	eb 56                	jmp    8021e9 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802193:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802197:	74 1c                	je     8021b5 <print_mem_block_lists+0x114>
  802199:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80219c:	8b 50 08             	mov    0x8(%eax),%edx
  80219f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021a2:	8b 48 08             	mov    0x8(%eax),%ecx
  8021a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021a8:	8b 40 0c             	mov    0xc(%eax),%eax
  8021ab:	01 c8                	add    %ecx,%eax
  8021ad:	39 c2                	cmp    %eax,%edx
  8021af:	73 04                	jae    8021b5 <print_mem_block_lists+0x114>
			sorted = 0 ;
  8021b1:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8021b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b8:	8b 50 08             	mov    0x8(%eax),%edx
  8021bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021be:	8b 40 0c             	mov    0xc(%eax),%eax
  8021c1:	01 c2                	add    %eax,%edx
  8021c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c6:	8b 40 08             	mov    0x8(%eax),%eax
  8021c9:	83 ec 04             	sub    $0x4,%esp
  8021cc:	52                   	push   %edx
  8021cd:	50                   	push   %eax
  8021ce:	68 c1 42 80 00       	push   $0x8042c1
  8021d3:	e8 b2 e5 ff ff       	call   80078a <cprintf>
  8021d8:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8021db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021de:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8021e1:	a1 48 50 80 00       	mov    0x805048,%eax
  8021e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021ed:	74 07                	je     8021f6 <print_mem_block_lists+0x155>
  8021ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021f2:	8b 00                	mov    (%eax),%eax
  8021f4:	eb 05                	jmp    8021fb <print_mem_block_lists+0x15a>
  8021f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8021fb:	a3 48 50 80 00       	mov    %eax,0x805048
  802200:	a1 48 50 80 00       	mov    0x805048,%eax
  802205:	85 c0                	test   %eax,%eax
  802207:	75 8a                	jne    802193 <print_mem_block_lists+0xf2>
  802209:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80220d:	75 84                	jne    802193 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  80220f:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802213:	75 10                	jne    802225 <print_mem_block_lists+0x184>
  802215:	83 ec 0c             	sub    $0xc,%esp
  802218:	68 0c 43 80 00       	push   $0x80430c
  80221d:	e8 68 e5 ff ff       	call   80078a <cprintf>
  802222:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802225:	83 ec 0c             	sub    $0xc,%esp
  802228:	68 80 42 80 00       	push   $0x804280
  80222d:	e8 58 e5 ff ff       	call   80078a <cprintf>
  802232:	83 c4 10             	add    $0x10,%esp

}
  802235:	90                   	nop
  802236:	c9                   	leave  
  802237:	c3                   	ret    

00802238 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802238:	55                   	push   %ebp
  802239:	89 e5                	mov    %esp,%ebp
  80223b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  80223e:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802245:	00 00 00 
  802248:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  80224f:	00 00 00 
  802252:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802259:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  80225c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802263:	e9 9e 00 00 00       	jmp    802306 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  802268:	a1 50 50 80 00       	mov    0x805050,%eax
  80226d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802270:	c1 e2 04             	shl    $0x4,%edx
  802273:	01 d0                	add    %edx,%eax
  802275:	85 c0                	test   %eax,%eax
  802277:	75 14                	jne    80228d <initialize_MemBlocksList+0x55>
  802279:	83 ec 04             	sub    $0x4,%esp
  80227c:	68 34 43 80 00       	push   $0x804334
  802281:	6a 46                	push   $0x46
  802283:	68 57 43 80 00       	push   $0x804357
  802288:	e8 49 e2 ff ff       	call   8004d6 <_panic>
  80228d:	a1 50 50 80 00       	mov    0x805050,%eax
  802292:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802295:	c1 e2 04             	shl    $0x4,%edx
  802298:	01 d0                	add    %edx,%eax
  80229a:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8022a0:	89 10                	mov    %edx,(%eax)
  8022a2:	8b 00                	mov    (%eax),%eax
  8022a4:	85 c0                	test   %eax,%eax
  8022a6:	74 18                	je     8022c0 <initialize_MemBlocksList+0x88>
  8022a8:	a1 48 51 80 00       	mov    0x805148,%eax
  8022ad:	8b 15 50 50 80 00    	mov    0x805050,%edx
  8022b3:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8022b6:	c1 e1 04             	shl    $0x4,%ecx
  8022b9:	01 ca                	add    %ecx,%edx
  8022bb:	89 50 04             	mov    %edx,0x4(%eax)
  8022be:	eb 12                	jmp    8022d2 <initialize_MemBlocksList+0x9a>
  8022c0:	a1 50 50 80 00       	mov    0x805050,%eax
  8022c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022c8:	c1 e2 04             	shl    $0x4,%edx
  8022cb:	01 d0                	add    %edx,%eax
  8022cd:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8022d2:	a1 50 50 80 00       	mov    0x805050,%eax
  8022d7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022da:	c1 e2 04             	shl    $0x4,%edx
  8022dd:	01 d0                	add    %edx,%eax
  8022df:	a3 48 51 80 00       	mov    %eax,0x805148
  8022e4:	a1 50 50 80 00       	mov    0x805050,%eax
  8022e9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022ec:	c1 e2 04             	shl    $0x4,%edx
  8022ef:	01 d0                	add    %edx,%eax
  8022f1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022f8:	a1 54 51 80 00       	mov    0x805154,%eax
  8022fd:	40                   	inc    %eax
  8022fe:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  802303:	ff 45 f4             	incl   -0xc(%ebp)
  802306:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802309:	3b 45 08             	cmp    0x8(%ebp),%eax
  80230c:	0f 82 56 ff ff ff    	jb     802268 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  802312:	90                   	nop
  802313:	c9                   	leave  
  802314:	c3                   	ret    

00802315 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802315:	55                   	push   %ebp
  802316:	89 e5                	mov    %esp,%ebp
  802318:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  80231b:	8b 45 08             	mov    0x8(%ebp),%eax
  80231e:	8b 00                	mov    (%eax),%eax
  802320:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802323:	eb 19                	jmp    80233e <find_block+0x29>
	{
		if(va==point->sva)
  802325:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802328:	8b 40 08             	mov    0x8(%eax),%eax
  80232b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80232e:	75 05                	jne    802335 <find_block+0x20>
		   return point;
  802330:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802333:	eb 36                	jmp    80236b <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802335:	8b 45 08             	mov    0x8(%ebp),%eax
  802338:	8b 40 08             	mov    0x8(%eax),%eax
  80233b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80233e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802342:	74 07                	je     80234b <find_block+0x36>
  802344:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802347:	8b 00                	mov    (%eax),%eax
  802349:	eb 05                	jmp    802350 <find_block+0x3b>
  80234b:	b8 00 00 00 00       	mov    $0x0,%eax
  802350:	8b 55 08             	mov    0x8(%ebp),%edx
  802353:	89 42 08             	mov    %eax,0x8(%edx)
  802356:	8b 45 08             	mov    0x8(%ebp),%eax
  802359:	8b 40 08             	mov    0x8(%eax),%eax
  80235c:	85 c0                	test   %eax,%eax
  80235e:	75 c5                	jne    802325 <find_block+0x10>
  802360:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802364:	75 bf                	jne    802325 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802366:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80236b:	c9                   	leave  
  80236c:	c3                   	ret    

0080236d <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80236d:	55                   	push   %ebp
  80236e:	89 e5                	mov    %esp,%ebp
  802370:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  802373:	a1 40 50 80 00       	mov    0x805040,%eax
  802378:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  80237b:	a1 44 50 80 00       	mov    0x805044,%eax
  802380:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  802383:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802386:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802389:	74 24                	je     8023af <insert_sorted_allocList+0x42>
  80238b:	8b 45 08             	mov    0x8(%ebp),%eax
  80238e:	8b 50 08             	mov    0x8(%eax),%edx
  802391:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802394:	8b 40 08             	mov    0x8(%eax),%eax
  802397:	39 c2                	cmp    %eax,%edx
  802399:	76 14                	jbe    8023af <insert_sorted_allocList+0x42>
  80239b:	8b 45 08             	mov    0x8(%ebp),%eax
  80239e:	8b 50 08             	mov    0x8(%eax),%edx
  8023a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023a4:	8b 40 08             	mov    0x8(%eax),%eax
  8023a7:	39 c2                	cmp    %eax,%edx
  8023a9:	0f 82 60 01 00 00    	jb     80250f <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  8023af:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8023b3:	75 65                	jne    80241a <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  8023b5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023b9:	75 14                	jne    8023cf <insert_sorted_allocList+0x62>
  8023bb:	83 ec 04             	sub    $0x4,%esp
  8023be:	68 34 43 80 00       	push   $0x804334
  8023c3:	6a 6b                	push   $0x6b
  8023c5:	68 57 43 80 00       	push   $0x804357
  8023ca:	e8 07 e1 ff ff       	call   8004d6 <_panic>
  8023cf:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8023d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d8:	89 10                	mov    %edx,(%eax)
  8023da:	8b 45 08             	mov    0x8(%ebp),%eax
  8023dd:	8b 00                	mov    (%eax),%eax
  8023df:	85 c0                	test   %eax,%eax
  8023e1:	74 0d                	je     8023f0 <insert_sorted_allocList+0x83>
  8023e3:	a1 40 50 80 00       	mov    0x805040,%eax
  8023e8:	8b 55 08             	mov    0x8(%ebp),%edx
  8023eb:	89 50 04             	mov    %edx,0x4(%eax)
  8023ee:	eb 08                	jmp    8023f8 <insert_sorted_allocList+0x8b>
  8023f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f3:	a3 44 50 80 00       	mov    %eax,0x805044
  8023f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023fb:	a3 40 50 80 00       	mov    %eax,0x805040
  802400:	8b 45 08             	mov    0x8(%ebp),%eax
  802403:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80240a:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80240f:	40                   	inc    %eax
  802410:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802415:	e9 dc 01 00 00       	jmp    8025f6 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  80241a:	8b 45 08             	mov    0x8(%ebp),%eax
  80241d:	8b 50 08             	mov    0x8(%eax),%edx
  802420:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802423:	8b 40 08             	mov    0x8(%eax),%eax
  802426:	39 c2                	cmp    %eax,%edx
  802428:	77 6c                	ja     802496 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  80242a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80242e:	74 06                	je     802436 <insert_sorted_allocList+0xc9>
  802430:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802434:	75 14                	jne    80244a <insert_sorted_allocList+0xdd>
  802436:	83 ec 04             	sub    $0x4,%esp
  802439:	68 70 43 80 00       	push   $0x804370
  80243e:	6a 6f                	push   $0x6f
  802440:	68 57 43 80 00       	push   $0x804357
  802445:	e8 8c e0 ff ff       	call   8004d6 <_panic>
  80244a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80244d:	8b 50 04             	mov    0x4(%eax),%edx
  802450:	8b 45 08             	mov    0x8(%ebp),%eax
  802453:	89 50 04             	mov    %edx,0x4(%eax)
  802456:	8b 45 08             	mov    0x8(%ebp),%eax
  802459:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80245c:	89 10                	mov    %edx,(%eax)
  80245e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802461:	8b 40 04             	mov    0x4(%eax),%eax
  802464:	85 c0                	test   %eax,%eax
  802466:	74 0d                	je     802475 <insert_sorted_allocList+0x108>
  802468:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80246b:	8b 40 04             	mov    0x4(%eax),%eax
  80246e:	8b 55 08             	mov    0x8(%ebp),%edx
  802471:	89 10                	mov    %edx,(%eax)
  802473:	eb 08                	jmp    80247d <insert_sorted_allocList+0x110>
  802475:	8b 45 08             	mov    0x8(%ebp),%eax
  802478:	a3 40 50 80 00       	mov    %eax,0x805040
  80247d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802480:	8b 55 08             	mov    0x8(%ebp),%edx
  802483:	89 50 04             	mov    %edx,0x4(%eax)
  802486:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80248b:	40                   	inc    %eax
  80248c:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802491:	e9 60 01 00 00       	jmp    8025f6 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802496:	8b 45 08             	mov    0x8(%ebp),%eax
  802499:	8b 50 08             	mov    0x8(%eax),%edx
  80249c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80249f:	8b 40 08             	mov    0x8(%eax),%eax
  8024a2:	39 c2                	cmp    %eax,%edx
  8024a4:	0f 82 4c 01 00 00    	jb     8025f6 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8024aa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8024ae:	75 14                	jne    8024c4 <insert_sorted_allocList+0x157>
  8024b0:	83 ec 04             	sub    $0x4,%esp
  8024b3:	68 a8 43 80 00       	push   $0x8043a8
  8024b8:	6a 73                	push   $0x73
  8024ba:	68 57 43 80 00       	push   $0x804357
  8024bf:	e8 12 e0 ff ff       	call   8004d6 <_panic>
  8024c4:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8024ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8024cd:	89 50 04             	mov    %edx,0x4(%eax)
  8024d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d3:	8b 40 04             	mov    0x4(%eax),%eax
  8024d6:	85 c0                	test   %eax,%eax
  8024d8:	74 0c                	je     8024e6 <insert_sorted_allocList+0x179>
  8024da:	a1 44 50 80 00       	mov    0x805044,%eax
  8024df:	8b 55 08             	mov    0x8(%ebp),%edx
  8024e2:	89 10                	mov    %edx,(%eax)
  8024e4:	eb 08                	jmp    8024ee <insert_sorted_allocList+0x181>
  8024e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e9:	a3 40 50 80 00       	mov    %eax,0x805040
  8024ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f1:	a3 44 50 80 00       	mov    %eax,0x805044
  8024f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024ff:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802504:	40                   	inc    %eax
  802505:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80250a:	e9 e7 00 00 00       	jmp    8025f6 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  80250f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802512:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802515:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80251c:	a1 40 50 80 00       	mov    0x805040,%eax
  802521:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802524:	e9 9d 00 00 00       	jmp    8025c6 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802529:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252c:	8b 00                	mov    (%eax),%eax
  80252e:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802531:	8b 45 08             	mov    0x8(%ebp),%eax
  802534:	8b 50 08             	mov    0x8(%eax),%edx
  802537:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253a:	8b 40 08             	mov    0x8(%eax),%eax
  80253d:	39 c2                	cmp    %eax,%edx
  80253f:	76 7d                	jbe    8025be <insert_sorted_allocList+0x251>
  802541:	8b 45 08             	mov    0x8(%ebp),%eax
  802544:	8b 50 08             	mov    0x8(%eax),%edx
  802547:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80254a:	8b 40 08             	mov    0x8(%eax),%eax
  80254d:	39 c2                	cmp    %eax,%edx
  80254f:	73 6d                	jae    8025be <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802551:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802555:	74 06                	je     80255d <insert_sorted_allocList+0x1f0>
  802557:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80255b:	75 14                	jne    802571 <insert_sorted_allocList+0x204>
  80255d:	83 ec 04             	sub    $0x4,%esp
  802560:	68 cc 43 80 00       	push   $0x8043cc
  802565:	6a 7f                	push   $0x7f
  802567:	68 57 43 80 00       	push   $0x804357
  80256c:	e8 65 df ff ff       	call   8004d6 <_panic>
  802571:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802574:	8b 10                	mov    (%eax),%edx
  802576:	8b 45 08             	mov    0x8(%ebp),%eax
  802579:	89 10                	mov    %edx,(%eax)
  80257b:	8b 45 08             	mov    0x8(%ebp),%eax
  80257e:	8b 00                	mov    (%eax),%eax
  802580:	85 c0                	test   %eax,%eax
  802582:	74 0b                	je     80258f <insert_sorted_allocList+0x222>
  802584:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802587:	8b 00                	mov    (%eax),%eax
  802589:	8b 55 08             	mov    0x8(%ebp),%edx
  80258c:	89 50 04             	mov    %edx,0x4(%eax)
  80258f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802592:	8b 55 08             	mov    0x8(%ebp),%edx
  802595:	89 10                	mov    %edx,(%eax)
  802597:	8b 45 08             	mov    0x8(%ebp),%eax
  80259a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80259d:	89 50 04             	mov    %edx,0x4(%eax)
  8025a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a3:	8b 00                	mov    (%eax),%eax
  8025a5:	85 c0                	test   %eax,%eax
  8025a7:	75 08                	jne    8025b1 <insert_sorted_allocList+0x244>
  8025a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ac:	a3 44 50 80 00       	mov    %eax,0x805044
  8025b1:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8025b6:	40                   	inc    %eax
  8025b7:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  8025bc:	eb 39                	jmp    8025f7 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8025be:	a1 48 50 80 00       	mov    0x805048,%eax
  8025c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025c6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025ca:	74 07                	je     8025d3 <insert_sorted_allocList+0x266>
  8025cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025cf:	8b 00                	mov    (%eax),%eax
  8025d1:	eb 05                	jmp    8025d8 <insert_sorted_allocList+0x26b>
  8025d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8025d8:	a3 48 50 80 00       	mov    %eax,0x805048
  8025dd:	a1 48 50 80 00       	mov    0x805048,%eax
  8025e2:	85 c0                	test   %eax,%eax
  8025e4:	0f 85 3f ff ff ff    	jne    802529 <insert_sorted_allocList+0x1bc>
  8025ea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025ee:	0f 85 35 ff ff ff    	jne    802529 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8025f4:	eb 01                	jmp    8025f7 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8025f6:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8025f7:	90                   	nop
  8025f8:	c9                   	leave  
  8025f9:	c3                   	ret    

008025fa <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8025fa:	55                   	push   %ebp
  8025fb:	89 e5                	mov    %esp,%ebp
  8025fd:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802600:	a1 38 51 80 00       	mov    0x805138,%eax
  802605:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802608:	e9 85 01 00 00       	jmp    802792 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  80260d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802610:	8b 40 0c             	mov    0xc(%eax),%eax
  802613:	3b 45 08             	cmp    0x8(%ebp),%eax
  802616:	0f 82 6e 01 00 00    	jb     80278a <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  80261c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261f:	8b 40 0c             	mov    0xc(%eax),%eax
  802622:	3b 45 08             	cmp    0x8(%ebp),%eax
  802625:	0f 85 8a 00 00 00    	jne    8026b5 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  80262b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80262f:	75 17                	jne    802648 <alloc_block_FF+0x4e>
  802631:	83 ec 04             	sub    $0x4,%esp
  802634:	68 00 44 80 00       	push   $0x804400
  802639:	68 93 00 00 00       	push   $0x93
  80263e:	68 57 43 80 00       	push   $0x804357
  802643:	e8 8e de ff ff       	call   8004d6 <_panic>
  802648:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264b:	8b 00                	mov    (%eax),%eax
  80264d:	85 c0                	test   %eax,%eax
  80264f:	74 10                	je     802661 <alloc_block_FF+0x67>
  802651:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802654:	8b 00                	mov    (%eax),%eax
  802656:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802659:	8b 52 04             	mov    0x4(%edx),%edx
  80265c:	89 50 04             	mov    %edx,0x4(%eax)
  80265f:	eb 0b                	jmp    80266c <alloc_block_FF+0x72>
  802661:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802664:	8b 40 04             	mov    0x4(%eax),%eax
  802667:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80266c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266f:	8b 40 04             	mov    0x4(%eax),%eax
  802672:	85 c0                	test   %eax,%eax
  802674:	74 0f                	je     802685 <alloc_block_FF+0x8b>
  802676:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802679:	8b 40 04             	mov    0x4(%eax),%eax
  80267c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80267f:	8b 12                	mov    (%edx),%edx
  802681:	89 10                	mov    %edx,(%eax)
  802683:	eb 0a                	jmp    80268f <alloc_block_FF+0x95>
  802685:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802688:	8b 00                	mov    (%eax),%eax
  80268a:	a3 38 51 80 00       	mov    %eax,0x805138
  80268f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802692:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802698:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026a2:	a1 44 51 80 00       	mov    0x805144,%eax
  8026a7:	48                   	dec    %eax
  8026a8:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  8026ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b0:	e9 10 01 00 00       	jmp    8027c5 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  8026b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b8:	8b 40 0c             	mov    0xc(%eax),%eax
  8026bb:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026be:	0f 86 c6 00 00 00    	jbe    80278a <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8026c4:	a1 48 51 80 00       	mov    0x805148,%eax
  8026c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  8026cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026cf:	8b 50 08             	mov    0x8(%eax),%edx
  8026d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026d5:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  8026d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026db:	8b 55 08             	mov    0x8(%ebp),%edx
  8026de:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8026e1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8026e5:	75 17                	jne    8026fe <alloc_block_FF+0x104>
  8026e7:	83 ec 04             	sub    $0x4,%esp
  8026ea:	68 00 44 80 00       	push   $0x804400
  8026ef:	68 9b 00 00 00       	push   $0x9b
  8026f4:	68 57 43 80 00       	push   $0x804357
  8026f9:	e8 d8 dd ff ff       	call   8004d6 <_panic>
  8026fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802701:	8b 00                	mov    (%eax),%eax
  802703:	85 c0                	test   %eax,%eax
  802705:	74 10                	je     802717 <alloc_block_FF+0x11d>
  802707:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80270a:	8b 00                	mov    (%eax),%eax
  80270c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80270f:	8b 52 04             	mov    0x4(%edx),%edx
  802712:	89 50 04             	mov    %edx,0x4(%eax)
  802715:	eb 0b                	jmp    802722 <alloc_block_FF+0x128>
  802717:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80271a:	8b 40 04             	mov    0x4(%eax),%eax
  80271d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802722:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802725:	8b 40 04             	mov    0x4(%eax),%eax
  802728:	85 c0                	test   %eax,%eax
  80272a:	74 0f                	je     80273b <alloc_block_FF+0x141>
  80272c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80272f:	8b 40 04             	mov    0x4(%eax),%eax
  802732:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802735:	8b 12                	mov    (%edx),%edx
  802737:	89 10                	mov    %edx,(%eax)
  802739:	eb 0a                	jmp    802745 <alloc_block_FF+0x14b>
  80273b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80273e:	8b 00                	mov    (%eax),%eax
  802740:	a3 48 51 80 00       	mov    %eax,0x805148
  802745:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802748:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80274e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802751:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802758:	a1 54 51 80 00       	mov    0x805154,%eax
  80275d:	48                   	dec    %eax
  80275e:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802763:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802766:	8b 50 08             	mov    0x8(%eax),%edx
  802769:	8b 45 08             	mov    0x8(%ebp),%eax
  80276c:	01 c2                	add    %eax,%edx
  80276e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802771:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802774:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802777:	8b 40 0c             	mov    0xc(%eax),%eax
  80277a:	2b 45 08             	sub    0x8(%ebp),%eax
  80277d:	89 c2                	mov    %eax,%edx
  80277f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802782:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802785:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802788:	eb 3b                	jmp    8027c5 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  80278a:	a1 40 51 80 00       	mov    0x805140,%eax
  80278f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802792:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802796:	74 07                	je     80279f <alloc_block_FF+0x1a5>
  802798:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279b:	8b 00                	mov    (%eax),%eax
  80279d:	eb 05                	jmp    8027a4 <alloc_block_FF+0x1aa>
  80279f:	b8 00 00 00 00       	mov    $0x0,%eax
  8027a4:	a3 40 51 80 00       	mov    %eax,0x805140
  8027a9:	a1 40 51 80 00       	mov    0x805140,%eax
  8027ae:	85 c0                	test   %eax,%eax
  8027b0:	0f 85 57 fe ff ff    	jne    80260d <alloc_block_FF+0x13>
  8027b6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027ba:	0f 85 4d fe ff ff    	jne    80260d <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  8027c0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027c5:	c9                   	leave  
  8027c6:	c3                   	ret    

008027c7 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8027c7:	55                   	push   %ebp
  8027c8:	89 e5                	mov    %esp,%ebp
  8027ca:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  8027cd:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8027d4:	a1 38 51 80 00       	mov    0x805138,%eax
  8027d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027dc:	e9 df 00 00 00       	jmp    8028c0 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  8027e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e4:	8b 40 0c             	mov    0xc(%eax),%eax
  8027e7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027ea:	0f 82 c8 00 00 00    	jb     8028b8 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  8027f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f3:	8b 40 0c             	mov    0xc(%eax),%eax
  8027f6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027f9:	0f 85 8a 00 00 00    	jne    802889 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  8027ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802803:	75 17                	jne    80281c <alloc_block_BF+0x55>
  802805:	83 ec 04             	sub    $0x4,%esp
  802808:	68 00 44 80 00       	push   $0x804400
  80280d:	68 b7 00 00 00       	push   $0xb7
  802812:	68 57 43 80 00       	push   $0x804357
  802817:	e8 ba dc ff ff       	call   8004d6 <_panic>
  80281c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281f:	8b 00                	mov    (%eax),%eax
  802821:	85 c0                	test   %eax,%eax
  802823:	74 10                	je     802835 <alloc_block_BF+0x6e>
  802825:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802828:	8b 00                	mov    (%eax),%eax
  80282a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80282d:	8b 52 04             	mov    0x4(%edx),%edx
  802830:	89 50 04             	mov    %edx,0x4(%eax)
  802833:	eb 0b                	jmp    802840 <alloc_block_BF+0x79>
  802835:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802838:	8b 40 04             	mov    0x4(%eax),%eax
  80283b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802840:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802843:	8b 40 04             	mov    0x4(%eax),%eax
  802846:	85 c0                	test   %eax,%eax
  802848:	74 0f                	je     802859 <alloc_block_BF+0x92>
  80284a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284d:	8b 40 04             	mov    0x4(%eax),%eax
  802850:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802853:	8b 12                	mov    (%edx),%edx
  802855:	89 10                	mov    %edx,(%eax)
  802857:	eb 0a                	jmp    802863 <alloc_block_BF+0x9c>
  802859:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285c:	8b 00                	mov    (%eax),%eax
  80285e:	a3 38 51 80 00       	mov    %eax,0x805138
  802863:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802866:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80286c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802876:	a1 44 51 80 00       	mov    0x805144,%eax
  80287b:	48                   	dec    %eax
  80287c:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802881:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802884:	e9 4d 01 00 00       	jmp    8029d6 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802889:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288c:	8b 40 0c             	mov    0xc(%eax),%eax
  80288f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802892:	76 24                	jbe    8028b8 <alloc_block_BF+0xf1>
  802894:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802897:	8b 40 0c             	mov    0xc(%eax),%eax
  80289a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80289d:	73 19                	jae    8028b8 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  80289f:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  8028a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a9:	8b 40 0c             	mov    0xc(%eax),%eax
  8028ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  8028af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b2:	8b 40 08             	mov    0x8(%eax),%eax
  8028b5:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8028b8:	a1 40 51 80 00       	mov    0x805140,%eax
  8028bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028c0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028c4:	74 07                	je     8028cd <alloc_block_BF+0x106>
  8028c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c9:	8b 00                	mov    (%eax),%eax
  8028cb:	eb 05                	jmp    8028d2 <alloc_block_BF+0x10b>
  8028cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8028d2:	a3 40 51 80 00       	mov    %eax,0x805140
  8028d7:	a1 40 51 80 00       	mov    0x805140,%eax
  8028dc:	85 c0                	test   %eax,%eax
  8028de:	0f 85 fd fe ff ff    	jne    8027e1 <alloc_block_BF+0x1a>
  8028e4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028e8:	0f 85 f3 fe ff ff    	jne    8027e1 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  8028ee:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8028f2:	0f 84 d9 00 00 00    	je     8029d1 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  8028f8:	a1 48 51 80 00       	mov    0x805148,%eax
  8028fd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802900:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802903:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802906:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802909:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80290c:	8b 55 08             	mov    0x8(%ebp),%edx
  80290f:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802912:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802916:	75 17                	jne    80292f <alloc_block_BF+0x168>
  802918:	83 ec 04             	sub    $0x4,%esp
  80291b:	68 00 44 80 00       	push   $0x804400
  802920:	68 c7 00 00 00       	push   $0xc7
  802925:	68 57 43 80 00       	push   $0x804357
  80292a:	e8 a7 db ff ff       	call   8004d6 <_panic>
  80292f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802932:	8b 00                	mov    (%eax),%eax
  802934:	85 c0                	test   %eax,%eax
  802936:	74 10                	je     802948 <alloc_block_BF+0x181>
  802938:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80293b:	8b 00                	mov    (%eax),%eax
  80293d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802940:	8b 52 04             	mov    0x4(%edx),%edx
  802943:	89 50 04             	mov    %edx,0x4(%eax)
  802946:	eb 0b                	jmp    802953 <alloc_block_BF+0x18c>
  802948:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80294b:	8b 40 04             	mov    0x4(%eax),%eax
  80294e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802953:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802956:	8b 40 04             	mov    0x4(%eax),%eax
  802959:	85 c0                	test   %eax,%eax
  80295b:	74 0f                	je     80296c <alloc_block_BF+0x1a5>
  80295d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802960:	8b 40 04             	mov    0x4(%eax),%eax
  802963:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802966:	8b 12                	mov    (%edx),%edx
  802968:	89 10                	mov    %edx,(%eax)
  80296a:	eb 0a                	jmp    802976 <alloc_block_BF+0x1af>
  80296c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80296f:	8b 00                	mov    (%eax),%eax
  802971:	a3 48 51 80 00       	mov    %eax,0x805148
  802976:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802979:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80297f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802982:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802989:	a1 54 51 80 00       	mov    0x805154,%eax
  80298e:	48                   	dec    %eax
  80298f:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802994:	83 ec 08             	sub    $0x8,%esp
  802997:	ff 75 ec             	pushl  -0x14(%ebp)
  80299a:	68 38 51 80 00       	push   $0x805138
  80299f:	e8 71 f9 ff ff       	call   802315 <find_block>
  8029a4:	83 c4 10             	add    $0x10,%esp
  8029a7:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  8029aa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029ad:	8b 50 08             	mov    0x8(%eax),%edx
  8029b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b3:	01 c2                	add    %eax,%edx
  8029b5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029b8:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  8029bb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029be:	8b 40 0c             	mov    0xc(%eax),%eax
  8029c1:	2b 45 08             	sub    0x8(%ebp),%eax
  8029c4:	89 c2                	mov    %eax,%edx
  8029c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029c9:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  8029cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029cf:	eb 05                	jmp    8029d6 <alloc_block_BF+0x20f>
	}
	return NULL;
  8029d1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029d6:	c9                   	leave  
  8029d7:	c3                   	ret    

008029d8 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  8029d8:	55                   	push   %ebp
  8029d9:	89 e5                	mov    %esp,%ebp
  8029db:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  8029de:	a1 28 50 80 00       	mov    0x805028,%eax
  8029e3:	85 c0                	test   %eax,%eax
  8029e5:	0f 85 de 01 00 00    	jne    802bc9 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8029eb:	a1 38 51 80 00       	mov    0x805138,%eax
  8029f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029f3:	e9 9e 01 00 00       	jmp    802b96 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  8029f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029fb:	8b 40 0c             	mov    0xc(%eax),%eax
  8029fe:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a01:	0f 82 87 01 00 00    	jb     802b8e <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802a07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0a:	8b 40 0c             	mov    0xc(%eax),%eax
  802a0d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a10:	0f 85 95 00 00 00    	jne    802aab <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802a16:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a1a:	75 17                	jne    802a33 <alloc_block_NF+0x5b>
  802a1c:	83 ec 04             	sub    $0x4,%esp
  802a1f:	68 00 44 80 00       	push   $0x804400
  802a24:	68 e0 00 00 00       	push   $0xe0
  802a29:	68 57 43 80 00       	push   $0x804357
  802a2e:	e8 a3 da ff ff       	call   8004d6 <_panic>
  802a33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a36:	8b 00                	mov    (%eax),%eax
  802a38:	85 c0                	test   %eax,%eax
  802a3a:	74 10                	je     802a4c <alloc_block_NF+0x74>
  802a3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3f:	8b 00                	mov    (%eax),%eax
  802a41:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a44:	8b 52 04             	mov    0x4(%edx),%edx
  802a47:	89 50 04             	mov    %edx,0x4(%eax)
  802a4a:	eb 0b                	jmp    802a57 <alloc_block_NF+0x7f>
  802a4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4f:	8b 40 04             	mov    0x4(%eax),%eax
  802a52:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802a57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5a:	8b 40 04             	mov    0x4(%eax),%eax
  802a5d:	85 c0                	test   %eax,%eax
  802a5f:	74 0f                	je     802a70 <alloc_block_NF+0x98>
  802a61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a64:	8b 40 04             	mov    0x4(%eax),%eax
  802a67:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a6a:	8b 12                	mov    (%edx),%edx
  802a6c:	89 10                	mov    %edx,(%eax)
  802a6e:	eb 0a                	jmp    802a7a <alloc_block_NF+0xa2>
  802a70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a73:	8b 00                	mov    (%eax),%eax
  802a75:	a3 38 51 80 00       	mov    %eax,0x805138
  802a7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a86:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a8d:	a1 44 51 80 00       	mov    0x805144,%eax
  802a92:	48                   	dec    %eax
  802a93:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802a98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9b:	8b 40 08             	mov    0x8(%eax),%eax
  802a9e:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  802aa3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa6:	e9 f8 04 00 00       	jmp    802fa3 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802aab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aae:	8b 40 0c             	mov    0xc(%eax),%eax
  802ab1:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ab4:	0f 86 d4 00 00 00    	jbe    802b8e <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802aba:	a1 48 51 80 00       	mov    0x805148,%eax
  802abf:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802ac2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac5:	8b 50 08             	mov    0x8(%eax),%edx
  802ac8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802acb:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802ace:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ad1:	8b 55 08             	mov    0x8(%ebp),%edx
  802ad4:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802ad7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802adb:	75 17                	jne    802af4 <alloc_block_NF+0x11c>
  802add:	83 ec 04             	sub    $0x4,%esp
  802ae0:	68 00 44 80 00       	push   $0x804400
  802ae5:	68 e9 00 00 00       	push   $0xe9
  802aea:	68 57 43 80 00       	push   $0x804357
  802aef:	e8 e2 d9 ff ff       	call   8004d6 <_panic>
  802af4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802af7:	8b 00                	mov    (%eax),%eax
  802af9:	85 c0                	test   %eax,%eax
  802afb:	74 10                	je     802b0d <alloc_block_NF+0x135>
  802afd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b00:	8b 00                	mov    (%eax),%eax
  802b02:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b05:	8b 52 04             	mov    0x4(%edx),%edx
  802b08:	89 50 04             	mov    %edx,0x4(%eax)
  802b0b:	eb 0b                	jmp    802b18 <alloc_block_NF+0x140>
  802b0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b10:	8b 40 04             	mov    0x4(%eax),%eax
  802b13:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b1b:	8b 40 04             	mov    0x4(%eax),%eax
  802b1e:	85 c0                	test   %eax,%eax
  802b20:	74 0f                	je     802b31 <alloc_block_NF+0x159>
  802b22:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b25:	8b 40 04             	mov    0x4(%eax),%eax
  802b28:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b2b:	8b 12                	mov    (%edx),%edx
  802b2d:	89 10                	mov    %edx,(%eax)
  802b2f:	eb 0a                	jmp    802b3b <alloc_block_NF+0x163>
  802b31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b34:	8b 00                	mov    (%eax),%eax
  802b36:	a3 48 51 80 00       	mov    %eax,0x805148
  802b3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b3e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b44:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b47:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b4e:	a1 54 51 80 00       	mov    0x805154,%eax
  802b53:	48                   	dec    %eax
  802b54:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802b59:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b5c:	8b 40 08             	mov    0x8(%eax),%eax
  802b5f:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802b64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b67:	8b 50 08             	mov    0x8(%eax),%edx
  802b6a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b6d:	01 c2                	add    %eax,%edx
  802b6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b72:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802b75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b78:	8b 40 0c             	mov    0xc(%eax),%eax
  802b7b:	2b 45 08             	sub    0x8(%ebp),%eax
  802b7e:	89 c2                	mov    %eax,%edx
  802b80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b83:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802b86:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b89:	e9 15 04 00 00       	jmp    802fa3 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802b8e:	a1 40 51 80 00       	mov    0x805140,%eax
  802b93:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b96:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b9a:	74 07                	je     802ba3 <alloc_block_NF+0x1cb>
  802b9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9f:	8b 00                	mov    (%eax),%eax
  802ba1:	eb 05                	jmp    802ba8 <alloc_block_NF+0x1d0>
  802ba3:	b8 00 00 00 00       	mov    $0x0,%eax
  802ba8:	a3 40 51 80 00       	mov    %eax,0x805140
  802bad:	a1 40 51 80 00       	mov    0x805140,%eax
  802bb2:	85 c0                	test   %eax,%eax
  802bb4:	0f 85 3e fe ff ff    	jne    8029f8 <alloc_block_NF+0x20>
  802bba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bbe:	0f 85 34 fe ff ff    	jne    8029f8 <alloc_block_NF+0x20>
  802bc4:	e9 d5 03 00 00       	jmp    802f9e <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802bc9:	a1 38 51 80 00       	mov    0x805138,%eax
  802bce:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bd1:	e9 b1 01 00 00       	jmp    802d87 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802bd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd9:	8b 50 08             	mov    0x8(%eax),%edx
  802bdc:	a1 28 50 80 00       	mov    0x805028,%eax
  802be1:	39 c2                	cmp    %eax,%edx
  802be3:	0f 82 96 01 00 00    	jb     802d7f <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802be9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bec:	8b 40 0c             	mov    0xc(%eax),%eax
  802bef:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bf2:	0f 82 87 01 00 00    	jb     802d7f <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802bf8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bfb:	8b 40 0c             	mov    0xc(%eax),%eax
  802bfe:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c01:	0f 85 95 00 00 00    	jne    802c9c <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802c07:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c0b:	75 17                	jne    802c24 <alloc_block_NF+0x24c>
  802c0d:	83 ec 04             	sub    $0x4,%esp
  802c10:	68 00 44 80 00       	push   $0x804400
  802c15:	68 fc 00 00 00       	push   $0xfc
  802c1a:	68 57 43 80 00       	push   $0x804357
  802c1f:	e8 b2 d8 ff ff       	call   8004d6 <_panic>
  802c24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c27:	8b 00                	mov    (%eax),%eax
  802c29:	85 c0                	test   %eax,%eax
  802c2b:	74 10                	je     802c3d <alloc_block_NF+0x265>
  802c2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c30:	8b 00                	mov    (%eax),%eax
  802c32:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c35:	8b 52 04             	mov    0x4(%edx),%edx
  802c38:	89 50 04             	mov    %edx,0x4(%eax)
  802c3b:	eb 0b                	jmp    802c48 <alloc_block_NF+0x270>
  802c3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c40:	8b 40 04             	mov    0x4(%eax),%eax
  802c43:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4b:	8b 40 04             	mov    0x4(%eax),%eax
  802c4e:	85 c0                	test   %eax,%eax
  802c50:	74 0f                	je     802c61 <alloc_block_NF+0x289>
  802c52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c55:	8b 40 04             	mov    0x4(%eax),%eax
  802c58:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c5b:	8b 12                	mov    (%edx),%edx
  802c5d:	89 10                	mov    %edx,(%eax)
  802c5f:	eb 0a                	jmp    802c6b <alloc_block_NF+0x293>
  802c61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c64:	8b 00                	mov    (%eax),%eax
  802c66:	a3 38 51 80 00       	mov    %eax,0x805138
  802c6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c6e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c77:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c7e:	a1 44 51 80 00       	mov    0x805144,%eax
  802c83:	48                   	dec    %eax
  802c84:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802c89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c8c:	8b 40 08             	mov    0x8(%eax),%eax
  802c8f:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802c94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c97:	e9 07 03 00 00       	jmp    802fa3 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802c9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9f:	8b 40 0c             	mov    0xc(%eax),%eax
  802ca2:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ca5:	0f 86 d4 00 00 00    	jbe    802d7f <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802cab:	a1 48 51 80 00       	mov    0x805148,%eax
  802cb0:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802cb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb6:	8b 50 08             	mov    0x8(%eax),%edx
  802cb9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cbc:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802cbf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cc2:	8b 55 08             	mov    0x8(%ebp),%edx
  802cc5:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802cc8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802ccc:	75 17                	jne    802ce5 <alloc_block_NF+0x30d>
  802cce:	83 ec 04             	sub    $0x4,%esp
  802cd1:	68 00 44 80 00       	push   $0x804400
  802cd6:	68 04 01 00 00       	push   $0x104
  802cdb:	68 57 43 80 00       	push   $0x804357
  802ce0:	e8 f1 d7 ff ff       	call   8004d6 <_panic>
  802ce5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ce8:	8b 00                	mov    (%eax),%eax
  802cea:	85 c0                	test   %eax,%eax
  802cec:	74 10                	je     802cfe <alloc_block_NF+0x326>
  802cee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cf1:	8b 00                	mov    (%eax),%eax
  802cf3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802cf6:	8b 52 04             	mov    0x4(%edx),%edx
  802cf9:	89 50 04             	mov    %edx,0x4(%eax)
  802cfc:	eb 0b                	jmp    802d09 <alloc_block_NF+0x331>
  802cfe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d01:	8b 40 04             	mov    0x4(%eax),%eax
  802d04:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d09:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d0c:	8b 40 04             	mov    0x4(%eax),%eax
  802d0f:	85 c0                	test   %eax,%eax
  802d11:	74 0f                	je     802d22 <alloc_block_NF+0x34a>
  802d13:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d16:	8b 40 04             	mov    0x4(%eax),%eax
  802d19:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d1c:	8b 12                	mov    (%edx),%edx
  802d1e:	89 10                	mov    %edx,(%eax)
  802d20:	eb 0a                	jmp    802d2c <alloc_block_NF+0x354>
  802d22:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d25:	8b 00                	mov    (%eax),%eax
  802d27:	a3 48 51 80 00       	mov    %eax,0x805148
  802d2c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d2f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d35:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d38:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d3f:	a1 54 51 80 00       	mov    0x805154,%eax
  802d44:	48                   	dec    %eax
  802d45:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802d4a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d4d:	8b 40 08             	mov    0x8(%eax),%eax
  802d50:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802d55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d58:	8b 50 08             	mov    0x8(%eax),%edx
  802d5b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d5e:	01 c2                	add    %eax,%edx
  802d60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d63:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802d66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d69:	8b 40 0c             	mov    0xc(%eax),%eax
  802d6c:	2b 45 08             	sub    0x8(%ebp),%eax
  802d6f:	89 c2                	mov    %eax,%edx
  802d71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d74:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802d77:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d7a:	e9 24 02 00 00       	jmp    802fa3 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802d7f:	a1 40 51 80 00       	mov    0x805140,%eax
  802d84:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d87:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d8b:	74 07                	je     802d94 <alloc_block_NF+0x3bc>
  802d8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d90:	8b 00                	mov    (%eax),%eax
  802d92:	eb 05                	jmp    802d99 <alloc_block_NF+0x3c1>
  802d94:	b8 00 00 00 00       	mov    $0x0,%eax
  802d99:	a3 40 51 80 00       	mov    %eax,0x805140
  802d9e:	a1 40 51 80 00       	mov    0x805140,%eax
  802da3:	85 c0                	test   %eax,%eax
  802da5:	0f 85 2b fe ff ff    	jne    802bd6 <alloc_block_NF+0x1fe>
  802dab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802daf:	0f 85 21 fe ff ff    	jne    802bd6 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802db5:	a1 38 51 80 00       	mov    0x805138,%eax
  802dba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802dbd:	e9 ae 01 00 00       	jmp    802f70 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802dc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc5:	8b 50 08             	mov    0x8(%eax),%edx
  802dc8:	a1 28 50 80 00       	mov    0x805028,%eax
  802dcd:	39 c2                	cmp    %eax,%edx
  802dcf:	0f 83 93 01 00 00    	jae    802f68 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802dd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd8:	8b 40 0c             	mov    0xc(%eax),%eax
  802ddb:	3b 45 08             	cmp    0x8(%ebp),%eax
  802dde:	0f 82 84 01 00 00    	jb     802f68 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802de4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de7:	8b 40 0c             	mov    0xc(%eax),%eax
  802dea:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ded:	0f 85 95 00 00 00    	jne    802e88 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802df3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802df7:	75 17                	jne    802e10 <alloc_block_NF+0x438>
  802df9:	83 ec 04             	sub    $0x4,%esp
  802dfc:	68 00 44 80 00       	push   $0x804400
  802e01:	68 14 01 00 00       	push   $0x114
  802e06:	68 57 43 80 00       	push   $0x804357
  802e0b:	e8 c6 d6 ff ff       	call   8004d6 <_panic>
  802e10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e13:	8b 00                	mov    (%eax),%eax
  802e15:	85 c0                	test   %eax,%eax
  802e17:	74 10                	je     802e29 <alloc_block_NF+0x451>
  802e19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e1c:	8b 00                	mov    (%eax),%eax
  802e1e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e21:	8b 52 04             	mov    0x4(%edx),%edx
  802e24:	89 50 04             	mov    %edx,0x4(%eax)
  802e27:	eb 0b                	jmp    802e34 <alloc_block_NF+0x45c>
  802e29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e2c:	8b 40 04             	mov    0x4(%eax),%eax
  802e2f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e37:	8b 40 04             	mov    0x4(%eax),%eax
  802e3a:	85 c0                	test   %eax,%eax
  802e3c:	74 0f                	je     802e4d <alloc_block_NF+0x475>
  802e3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e41:	8b 40 04             	mov    0x4(%eax),%eax
  802e44:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e47:	8b 12                	mov    (%edx),%edx
  802e49:	89 10                	mov    %edx,(%eax)
  802e4b:	eb 0a                	jmp    802e57 <alloc_block_NF+0x47f>
  802e4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e50:	8b 00                	mov    (%eax),%eax
  802e52:	a3 38 51 80 00       	mov    %eax,0x805138
  802e57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e5a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e63:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e6a:	a1 44 51 80 00       	mov    0x805144,%eax
  802e6f:	48                   	dec    %eax
  802e70:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802e75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e78:	8b 40 08             	mov    0x8(%eax),%eax
  802e7b:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802e80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e83:	e9 1b 01 00 00       	jmp    802fa3 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802e88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e8b:	8b 40 0c             	mov    0xc(%eax),%eax
  802e8e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e91:	0f 86 d1 00 00 00    	jbe    802f68 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802e97:	a1 48 51 80 00       	mov    0x805148,%eax
  802e9c:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802e9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea2:	8b 50 08             	mov    0x8(%eax),%edx
  802ea5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ea8:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802eab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802eae:	8b 55 08             	mov    0x8(%ebp),%edx
  802eb1:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802eb4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802eb8:	75 17                	jne    802ed1 <alloc_block_NF+0x4f9>
  802eba:	83 ec 04             	sub    $0x4,%esp
  802ebd:	68 00 44 80 00       	push   $0x804400
  802ec2:	68 1c 01 00 00       	push   $0x11c
  802ec7:	68 57 43 80 00       	push   $0x804357
  802ecc:	e8 05 d6 ff ff       	call   8004d6 <_panic>
  802ed1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ed4:	8b 00                	mov    (%eax),%eax
  802ed6:	85 c0                	test   %eax,%eax
  802ed8:	74 10                	je     802eea <alloc_block_NF+0x512>
  802eda:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802edd:	8b 00                	mov    (%eax),%eax
  802edf:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ee2:	8b 52 04             	mov    0x4(%edx),%edx
  802ee5:	89 50 04             	mov    %edx,0x4(%eax)
  802ee8:	eb 0b                	jmp    802ef5 <alloc_block_NF+0x51d>
  802eea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802eed:	8b 40 04             	mov    0x4(%eax),%eax
  802ef0:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ef5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ef8:	8b 40 04             	mov    0x4(%eax),%eax
  802efb:	85 c0                	test   %eax,%eax
  802efd:	74 0f                	je     802f0e <alloc_block_NF+0x536>
  802eff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f02:	8b 40 04             	mov    0x4(%eax),%eax
  802f05:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802f08:	8b 12                	mov    (%edx),%edx
  802f0a:	89 10                	mov    %edx,(%eax)
  802f0c:	eb 0a                	jmp    802f18 <alloc_block_NF+0x540>
  802f0e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f11:	8b 00                	mov    (%eax),%eax
  802f13:	a3 48 51 80 00       	mov    %eax,0x805148
  802f18:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f1b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f21:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f24:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f2b:	a1 54 51 80 00       	mov    0x805154,%eax
  802f30:	48                   	dec    %eax
  802f31:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802f36:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f39:	8b 40 08             	mov    0x8(%eax),%eax
  802f3c:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802f41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f44:	8b 50 08             	mov    0x8(%eax),%edx
  802f47:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4a:	01 c2                	add    %eax,%edx
  802f4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f4f:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802f52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f55:	8b 40 0c             	mov    0xc(%eax),%eax
  802f58:	2b 45 08             	sub    0x8(%ebp),%eax
  802f5b:	89 c2                	mov    %eax,%edx
  802f5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f60:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802f63:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f66:	eb 3b                	jmp    802fa3 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802f68:	a1 40 51 80 00       	mov    0x805140,%eax
  802f6d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f70:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f74:	74 07                	je     802f7d <alloc_block_NF+0x5a5>
  802f76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f79:	8b 00                	mov    (%eax),%eax
  802f7b:	eb 05                	jmp    802f82 <alloc_block_NF+0x5aa>
  802f7d:	b8 00 00 00 00       	mov    $0x0,%eax
  802f82:	a3 40 51 80 00       	mov    %eax,0x805140
  802f87:	a1 40 51 80 00       	mov    0x805140,%eax
  802f8c:	85 c0                	test   %eax,%eax
  802f8e:	0f 85 2e fe ff ff    	jne    802dc2 <alloc_block_NF+0x3ea>
  802f94:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f98:	0f 85 24 fe ff ff    	jne    802dc2 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802f9e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802fa3:	c9                   	leave  
  802fa4:	c3                   	ret    

00802fa5 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802fa5:	55                   	push   %ebp
  802fa6:	89 e5                	mov    %esp,%ebp
  802fa8:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802fab:	a1 38 51 80 00       	mov    0x805138,%eax
  802fb0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802fb3:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802fb8:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802fbb:	a1 38 51 80 00       	mov    0x805138,%eax
  802fc0:	85 c0                	test   %eax,%eax
  802fc2:	74 14                	je     802fd8 <insert_sorted_with_merge_freeList+0x33>
  802fc4:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc7:	8b 50 08             	mov    0x8(%eax),%edx
  802fca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fcd:	8b 40 08             	mov    0x8(%eax),%eax
  802fd0:	39 c2                	cmp    %eax,%edx
  802fd2:	0f 87 9b 01 00 00    	ja     803173 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802fd8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fdc:	75 17                	jne    802ff5 <insert_sorted_with_merge_freeList+0x50>
  802fde:	83 ec 04             	sub    $0x4,%esp
  802fe1:	68 34 43 80 00       	push   $0x804334
  802fe6:	68 38 01 00 00       	push   $0x138
  802feb:	68 57 43 80 00       	push   $0x804357
  802ff0:	e8 e1 d4 ff ff       	call   8004d6 <_panic>
  802ff5:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802ffb:	8b 45 08             	mov    0x8(%ebp),%eax
  802ffe:	89 10                	mov    %edx,(%eax)
  803000:	8b 45 08             	mov    0x8(%ebp),%eax
  803003:	8b 00                	mov    (%eax),%eax
  803005:	85 c0                	test   %eax,%eax
  803007:	74 0d                	je     803016 <insert_sorted_with_merge_freeList+0x71>
  803009:	a1 38 51 80 00       	mov    0x805138,%eax
  80300e:	8b 55 08             	mov    0x8(%ebp),%edx
  803011:	89 50 04             	mov    %edx,0x4(%eax)
  803014:	eb 08                	jmp    80301e <insert_sorted_with_merge_freeList+0x79>
  803016:	8b 45 08             	mov    0x8(%ebp),%eax
  803019:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80301e:	8b 45 08             	mov    0x8(%ebp),%eax
  803021:	a3 38 51 80 00       	mov    %eax,0x805138
  803026:	8b 45 08             	mov    0x8(%ebp),%eax
  803029:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803030:	a1 44 51 80 00       	mov    0x805144,%eax
  803035:	40                   	inc    %eax
  803036:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80303b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80303f:	0f 84 a8 06 00 00    	je     8036ed <insert_sorted_with_merge_freeList+0x748>
  803045:	8b 45 08             	mov    0x8(%ebp),%eax
  803048:	8b 50 08             	mov    0x8(%eax),%edx
  80304b:	8b 45 08             	mov    0x8(%ebp),%eax
  80304e:	8b 40 0c             	mov    0xc(%eax),%eax
  803051:	01 c2                	add    %eax,%edx
  803053:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803056:	8b 40 08             	mov    0x8(%eax),%eax
  803059:	39 c2                	cmp    %eax,%edx
  80305b:	0f 85 8c 06 00 00    	jne    8036ed <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  803061:	8b 45 08             	mov    0x8(%ebp),%eax
  803064:	8b 50 0c             	mov    0xc(%eax),%edx
  803067:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80306a:	8b 40 0c             	mov    0xc(%eax),%eax
  80306d:	01 c2                	add    %eax,%edx
  80306f:	8b 45 08             	mov    0x8(%ebp),%eax
  803072:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  803075:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803079:	75 17                	jne    803092 <insert_sorted_with_merge_freeList+0xed>
  80307b:	83 ec 04             	sub    $0x4,%esp
  80307e:	68 00 44 80 00       	push   $0x804400
  803083:	68 3c 01 00 00       	push   $0x13c
  803088:	68 57 43 80 00       	push   $0x804357
  80308d:	e8 44 d4 ff ff       	call   8004d6 <_panic>
  803092:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803095:	8b 00                	mov    (%eax),%eax
  803097:	85 c0                	test   %eax,%eax
  803099:	74 10                	je     8030ab <insert_sorted_with_merge_freeList+0x106>
  80309b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80309e:	8b 00                	mov    (%eax),%eax
  8030a0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8030a3:	8b 52 04             	mov    0x4(%edx),%edx
  8030a6:	89 50 04             	mov    %edx,0x4(%eax)
  8030a9:	eb 0b                	jmp    8030b6 <insert_sorted_with_merge_freeList+0x111>
  8030ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030ae:	8b 40 04             	mov    0x4(%eax),%eax
  8030b1:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8030b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030b9:	8b 40 04             	mov    0x4(%eax),%eax
  8030bc:	85 c0                	test   %eax,%eax
  8030be:	74 0f                	je     8030cf <insert_sorted_with_merge_freeList+0x12a>
  8030c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030c3:	8b 40 04             	mov    0x4(%eax),%eax
  8030c6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8030c9:	8b 12                	mov    (%edx),%edx
  8030cb:	89 10                	mov    %edx,(%eax)
  8030cd:	eb 0a                	jmp    8030d9 <insert_sorted_with_merge_freeList+0x134>
  8030cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030d2:	8b 00                	mov    (%eax),%eax
  8030d4:	a3 38 51 80 00       	mov    %eax,0x805138
  8030d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030dc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030e5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030ec:	a1 44 51 80 00       	mov    0x805144,%eax
  8030f1:	48                   	dec    %eax
  8030f2:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  8030f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030fa:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  803101:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803104:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  80310b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80310f:	75 17                	jne    803128 <insert_sorted_with_merge_freeList+0x183>
  803111:	83 ec 04             	sub    $0x4,%esp
  803114:	68 34 43 80 00       	push   $0x804334
  803119:	68 3f 01 00 00       	push   $0x13f
  80311e:	68 57 43 80 00       	push   $0x804357
  803123:	e8 ae d3 ff ff       	call   8004d6 <_panic>
  803128:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80312e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803131:	89 10                	mov    %edx,(%eax)
  803133:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803136:	8b 00                	mov    (%eax),%eax
  803138:	85 c0                	test   %eax,%eax
  80313a:	74 0d                	je     803149 <insert_sorted_with_merge_freeList+0x1a4>
  80313c:	a1 48 51 80 00       	mov    0x805148,%eax
  803141:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803144:	89 50 04             	mov    %edx,0x4(%eax)
  803147:	eb 08                	jmp    803151 <insert_sorted_with_merge_freeList+0x1ac>
  803149:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80314c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803151:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803154:	a3 48 51 80 00       	mov    %eax,0x805148
  803159:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80315c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803163:	a1 54 51 80 00       	mov    0x805154,%eax
  803168:	40                   	inc    %eax
  803169:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80316e:	e9 7a 05 00 00       	jmp    8036ed <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  803173:	8b 45 08             	mov    0x8(%ebp),%eax
  803176:	8b 50 08             	mov    0x8(%eax),%edx
  803179:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80317c:	8b 40 08             	mov    0x8(%eax),%eax
  80317f:	39 c2                	cmp    %eax,%edx
  803181:	0f 82 14 01 00 00    	jb     80329b <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  803187:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80318a:	8b 50 08             	mov    0x8(%eax),%edx
  80318d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803190:	8b 40 0c             	mov    0xc(%eax),%eax
  803193:	01 c2                	add    %eax,%edx
  803195:	8b 45 08             	mov    0x8(%ebp),%eax
  803198:	8b 40 08             	mov    0x8(%eax),%eax
  80319b:	39 c2                	cmp    %eax,%edx
  80319d:	0f 85 90 00 00 00    	jne    803233 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  8031a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031a6:	8b 50 0c             	mov    0xc(%eax),%edx
  8031a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ac:	8b 40 0c             	mov    0xc(%eax),%eax
  8031af:	01 c2                	add    %eax,%edx
  8031b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031b4:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  8031b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ba:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  8031c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8031cb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031cf:	75 17                	jne    8031e8 <insert_sorted_with_merge_freeList+0x243>
  8031d1:	83 ec 04             	sub    $0x4,%esp
  8031d4:	68 34 43 80 00       	push   $0x804334
  8031d9:	68 49 01 00 00       	push   $0x149
  8031de:	68 57 43 80 00       	push   $0x804357
  8031e3:	e8 ee d2 ff ff       	call   8004d6 <_panic>
  8031e8:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8031ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f1:	89 10                	mov    %edx,(%eax)
  8031f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f6:	8b 00                	mov    (%eax),%eax
  8031f8:	85 c0                	test   %eax,%eax
  8031fa:	74 0d                	je     803209 <insert_sorted_with_merge_freeList+0x264>
  8031fc:	a1 48 51 80 00       	mov    0x805148,%eax
  803201:	8b 55 08             	mov    0x8(%ebp),%edx
  803204:	89 50 04             	mov    %edx,0x4(%eax)
  803207:	eb 08                	jmp    803211 <insert_sorted_with_merge_freeList+0x26c>
  803209:	8b 45 08             	mov    0x8(%ebp),%eax
  80320c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803211:	8b 45 08             	mov    0x8(%ebp),%eax
  803214:	a3 48 51 80 00       	mov    %eax,0x805148
  803219:	8b 45 08             	mov    0x8(%ebp),%eax
  80321c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803223:	a1 54 51 80 00       	mov    0x805154,%eax
  803228:	40                   	inc    %eax
  803229:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80322e:	e9 bb 04 00 00       	jmp    8036ee <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  803233:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803237:	75 17                	jne    803250 <insert_sorted_with_merge_freeList+0x2ab>
  803239:	83 ec 04             	sub    $0x4,%esp
  80323c:	68 a8 43 80 00       	push   $0x8043a8
  803241:	68 4c 01 00 00       	push   $0x14c
  803246:	68 57 43 80 00       	push   $0x804357
  80324b:	e8 86 d2 ff ff       	call   8004d6 <_panic>
  803250:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803256:	8b 45 08             	mov    0x8(%ebp),%eax
  803259:	89 50 04             	mov    %edx,0x4(%eax)
  80325c:	8b 45 08             	mov    0x8(%ebp),%eax
  80325f:	8b 40 04             	mov    0x4(%eax),%eax
  803262:	85 c0                	test   %eax,%eax
  803264:	74 0c                	je     803272 <insert_sorted_with_merge_freeList+0x2cd>
  803266:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80326b:	8b 55 08             	mov    0x8(%ebp),%edx
  80326e:	89 10                	mov    %edx,(%eax)
  803270:	eb 08                	jmp    80327a <insert_sorted_with_merge_freeList+0x2d5>
  803272:	8b 45 08             	mov    0x8(%ebp),%eax
  803275:	a3 38 51 80 00       	mov    %eax,0x805138
  80327a:	8b 45 08             	mov    0x8(%ebp),%eax
  80327d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803282:	8b 45 08             	mov    0x8(%ebp),%eax
  803285:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80328b:	a1 44 51 80 00       	mov    0x805144,%eax
  803290:	40                   	inc    %eax
  803291:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803296:	e9 53 04 00 00       	jmp    8036ee <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  80329b:	a1 38 51 80 00       	mov    0x805138,%eax
  8032a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8032a3:	e9 15 04 00 00       	jmp    8036bd <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  8032a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ab:	8b 00                	mov    (%eax),%eax
  8032ad:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  8032b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b3:	8b 50 08             	mov    0x8(%eax),%edx
  8032b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032b9:	8b 40 08             	mov    0x8(%eax),%eax
  8032bc:	39 c2                	cmp    %eax,%edx
  8032be:	0f 86 f1 03 00 00    	jbe    8036b5 <insert_sorted_with_merge_freeList+0x710>
  8032c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c7:	8b 50 08             	mov    0x8(%eax),%edx
  8032ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032cd:	8b 40 08             	mov    0x8(%eax),%eax
  8032d0:	39 c2                	cmp    %eax,%edx
  8032d2:	0f 83 dd 03 00 00    	jae    8036b5 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  8032d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032db:	8b 50 08             	mov    0x8(%eax),%edx
  8032de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032e1:	8b 40 0c             	mov    0xc(%eax),%eax
  8032e4:	01 c2                	add    %eax,%edx
  8032e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e9:	8b 40 08             	mov    0x8(%eax),%eax
  8032ec:	39 c2                	cmp    %eax,%edx
  8032ee:	0f 85 b9 01 00 00    	jne    8034ad <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8032f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f7:	8b 50 08             	mov    0x8(%eax),%edx
  8032fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8032fd:	8b 40 0c             	mov    0xc(%eax),%eax
  803300:	01 c2                	add    %eax,%edx
  803302:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803305:	8b 40 08             	mov    0x8(%eax),%eax
  803308:	39 c2                	cmp    %eax,%edx
  80330a:	0f 85 0d 01 00 00    	jne    80341d <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  803310:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803313:	8b 50 0c             	mov    0xc(%eax),%edx
  803316:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803319:	8b 40 0c             	mov    0xc(%eax),%eax
  80331c:	01 c2                	add    %eax,%edx
  80331e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803321:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803324:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803328:	75 17                	jne    803341 <insert_sorted_with_merge_freeList+0x39c>
  80332a:	83 ec 04             	sub    $0x4,%esp
  80332d:	68 00 44 80 00       	push   $0x804400
  803332:	68 5c 01 00 00       	push   $0x15c
  803337:	68 57 43 80 00       	push   $0x804357
  80333c:	e8 95 d1 ff ff       	call   8004d6 <_panic>
  803341:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803344:	8b 00                	mov    (%eax),%eax
  803346:	85 c0                	test   %eax,%eax
  803348:	74 10                	je     80335a <insert_sorted_with_merge_freeList+0x3b5>
  80334a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80334d:	8b 00                	mov    (%eax),%eax
  80334f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803352:	8b 52 04             	mov    0x4(%edx),%edx
  803355:	89 50 04             	mov    %edx,0x4(%eax)
  803358:	eb 0b                	jmp    803365 <insert_sorted_with_merge_freeList+0x3c0>
  80335a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80335d:	8b 40 04             	mov    0x4(%eax),%eax
  803360:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803365:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803368:	8b 40 04             	mov    0x4(%eax),%eax
  80336b:	85 c0                	test   %eax,%eax
  80336d:	74 0f                	je     80337e <insert_sorted_with_merge_freeList+0x3d9>
  80336f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803372:	8b 40 04             	mov    0x4(%eax),%eax
  803375:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803378:	8b 12                	mov    (%edx),%edx
  80337a:	89 10                	mov    %edx,(%eax)
  80337c:	eb 0a                	jmp    803388 <insert_sorted_with_merge_freeList+0x3e3>
  80337e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803381:	8b 00                	mov    (%eax),%eax
  803383:	a3 38 51 80 00       	mov    %eax,0x805138
  803388:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80338b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803391:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803394:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80339b:	a1 44 51 80 00       	mov    0x805144,%eax
  8033a0:	48                   	dec    %eax
  8033a1:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  8033a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033a9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  8033b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033b3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8033ba:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8033be:	75 17                	jne    8033d7 <insert_sorted_with_merge_freeList+0x432>
  8033c0:	83 ec 04             	sub    $0x4,%esp
  8033c3:	68 34 43 80 00       	push   $0x804334
  8033c8:	68 5f 01 00 00       	push   $0x15f
  8033cd:	68 57 43 80 00       	push   $0x804357
  8033d2:	e8 ff d0 ff ff       	call   8004d6 <_panic>
  8033d7:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8033dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033e0:	89 10                	mov    %edx,(%eax)
  8033e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033e5:	8b 00                	mov    (%eax),%eax
  8033e7:	85 c0                	test   %eax,%eax
  8033e9:	74 0d                	je     8033f8 <insert_sorted_with_merge_freeList+0x453>
  8033eb:	a1 48 51 80 00       	mov    0x805148,%eax
  8033f0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8033f3:	89 50 04             	mov    %edx,0x4(%eax)
  8033f6:	eb 08                	jmp    803400 <insert_sorted_with_merge_freeList+0x45b>
  8033f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033fb:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803400:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803403:	a3 48 51 80 00       	mov    %eax,0x805148
  803408:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80340b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803412:	a1 54 51 80 00       	mov    0x805154,%eax
  803417:	40                   	inc    %eax
  803418:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  80341d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803420:	8b 50 0c             	mov    0xc(%eax),%edx
  803423:	8b 45 08             	mov    0x8(%ebp),%eax
  803426:	8b 40 0c             	mov    0xc(%eax),%eax
  803429:	01 c2                	add    %eax,%edx
  80342b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80342e:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803431:	8b 45 08             	mov    0x8(%ebp),%eax
  803434:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  80343b:	8b 45 08             	mov    0x8(%ebp),%eax
  80343e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803445:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803449:	75 17                	jne    803462 <insert_sorted_with_merge_freeList+0x4bd>
  80344b:	83 ec 04             	sub    $0x4,%esp
  80344e:	68 34 43 80 00       	push   $0x804334
  803453:	68 64 01 00 00       	push   $0x164
  803458:	68 57 43 80 00       	push   $0x804357
  80345d:	e8 74 d0 ff ff       	call   8004d6 <_panic>
  803462:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803468:	8b 45 08             	mov    0x8(%ebp),%eax
  80346b:	89 10                	mov    %edx,(%eax)
  80346d:	8b 45 08             	mov    0x8(%ebp),%eax
  803470:	8b 00                	mov    (%eax),%eax
  803472:	85 c0                	test   %eax,%eax
  803474:	74 0d                	je     803483 <insert_sorted_with_merge_freeList+0x4de>
  803476:	a1 48 51 80 00       	mov    0x805148,%eax
  80347b:	8b 55 08             	mov    0x8(%ebp),%edx
  80347e:	89 50 04             	mov    %edx,0x4(%eax)
  803481:	eb 08                	jmp    80348b <insert_sorted_with_merge_freeList+0x4e6>
  803483:	8b 45 08             	mov    0x8(%ebp),%eax
  803486:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80348b:	8b 45 08             	mov    0x8(%ebp),%eax
  80348e:	a3 48 51 80 00       	mov    %eax,0x805148
  803493:	8b 45 08             	mov    0x8(%ebp),%eax
  803496:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80349d:	a1 54 51 80 00       	mov    0x805154,%eax
  8034a2:	40                   	inc    %eax
  8034a3:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8034a8:	e9 41 02 00 00       	jmp    8036ee <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8034ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8034b0:	8b 50 08             	mov    0x8(%eax),%edx
  8034b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8034b6:	8b 40 0c             	mov    0xc(%eax),%eax
  8034b9:	01 c2                	add    %eax,%edx
  8034bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034be:	8b 40 08             	mov    0x8(%eax),%eax
  8034c1:	39 c2                	cmp    %eax,%edx
  8034c3:	0f 85 7c 01 00 00    	jne    803645 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  8034c9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8034cd:	74 06                	je     8034d5 <insert_sorted_with_merge_freeList+0x530>
  8034cf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034d3:	75 17                	jne    8034ec <insert_sorted_with_merge_freeList+0x547>
  8034d5:	83 ec 04             	sub    $0x4,%esp
  8034d8:	68 70 43 80 00       	push   $0x804370
  8034dd:	68 69 01 00 00       	push   $0x169
  8034e2:	68 57 43 80 00       	push   $0x804357
  8034e7:	e8 ea cf ff ff       	call   8004d6 <_panic>
  8034ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034ef:	8b 50 04             	mov    0x4(%eax),%edx
  8034f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8034f5:	89 50 04             	mov    %edx,0x4(%eax)
  8034f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8034fb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8034fe:	89 10                	mov    %edx,(%eax)
  803500:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803503:	8b 40 04             	mov    0x4(%eax),%eax
  803506:	85 c0                	test   %eax,%eax
  803508:	74 0d                	je     803517 <insert_sorted_with_merge_freeList+0x572>
  80350a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80350d:	8b 40 04             	mov    0x4(%eax),%eax
  803510:	8b 55 08             	mov    0x8(%ebp),%edx
  803513:	89 10                	mov    %edx,(%eax)
  803515:	eb 08                	jmp    80351f <insert_sorted_with_merge_freeList+0x57a>
  803517:	8b 45 08             	mov    0x8(%ebp),%eax
  80351a:	a3 38 51 80 00       	mov    %eax,0x805138
  80351f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803522:	8b 55 08             	mov    0x8(%ebp),%edx
  803525:	89 50 04             	mov    %edx,0x4(%eax)
  803528:	a1 44 51 80 00       	mov    0x805144,%eax
  80352d:	40                   	inc    %eax
  80352e:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803533:	8b 45 08             	mov    0x8(%ebp),%eax
  803536:	8b 50 0c             	mov    0xc(%eax),%edx
  803539:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80353c:	8b 40 0c             	mov    0xc(%eax),%eax
  80353f:	01 c2                	add    %eax,%edx
  803541:	8b 45 08             	mov    0x8(%ebp),%eax
  803544:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803547:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80354b:	75 17                	jne    803564 <insert_sorted_with_merge_freeList+0x5bf>
  80354d:	83 ec 04             	sub    $0x4,%esp
  803550:	68 00 44 80 00       	push   $0x804400
  803555:	68 6b 01 00 00       	push   $0x16b
  80355a:	68 57 43 80 00       	push   $0x804357
  80355f:	e8 72 cf ff ff       	call   8004d6 <_panic>
  803564:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803567:	8b 00                	mov    (%eax),%eax
  803569:	85 c0                	test   %eax,%eax
  80356b:	74 10                	je     80357d <insert_sorted_with_merge_freeList+0x5d8>
  80356d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803570:	8b 00                	mov    (%eax),%eax
  803572:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803575:	8b 52 04             	mov    0x4(%edx),%edx
  803578:	89 50 04             	mov    %edx,0x4(%eax)
  80357b:	eb 0b                	jmp    803588 <insert_sorted_with_merge_freeList+0x5e3>
  80357d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803580:	8b 40 04             	mov    0x4(%eax),%eax
  803583:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803588:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80358b:	8b 40 04             	mov    0x4(%eax),%eax
  80358e:	85 c0                	test   %eax,%eax
  803590:	74 0f                	je     8035a1 <insert_sorted_with_merge_freeList+0x5fc>
  803592:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803595:	8b 40 04             	mov    0x4(%eax),%eax
  803598:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80359b:	8b 12                	mov    (%edx),%edx
  80359d:	89 10                	mov    %edx,(%eax)
  80359f:	eb 0a                	jmp    8035ab <insert_sorted_with_merge_freeList+0x606>
  8035a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035a4:	8b 00                	mov    (%eax),%eax
  8035a6:	a3 38 51 80 00       	mov    %eax,0x805138
  8035ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035ae:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035b7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035be:	a1 44 51 80 00       	mov    0x805144,%eax
  8035c3:	48                   	dec    %eax
  8035c4:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  8035c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035cc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  8035d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035d6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8035dd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8035e1:	75 17                	jne    8035fa <insert_sorted_with_merge_freeList+0x655>
  8035e3:	83 ec 04             	sub    $0x4,%esp
  8035e6:	68 34 43 80 00       	push   $0x804334
  8035eb:	68 6e 01 00 00       	push   $0x16e
  8035f0:	68 57 43 80 00       	push   $0x804357
  8035f5:	e8 dc ce ff ff       	call   8004d6 <_panic>
  8035fa:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803600:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803603:	89 10                	mov    %edx,(%eax)
  803605:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803608:	8b 00                	mov    (%eax),%eax
  80360a:	85 c0                	test   %eax,%eax
  80360c:	74 0d                	je     80361b <insert_sorted_with_merge_freeList+0x676>
  80360e:	a1 48 51 80 00       	mov    0x805148,%eax
  803613:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803616:	89 50 04             	mov    %edx,0x4(%eax)
  803619:	eb 08                	jmp    803623 <insert_sorted_with_merge_freeList+0x67e>
  80361b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80361e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803623:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803626:	a3 48 51 80 00       	mov    %eax,0x805148
  80362b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80362e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803635:	a1 54 51 80 00       	mov    0x805154,%eax
  80363a:	40                   	inc    %eax
  80363b:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803640:	e9 a9 00 00 00       	jmp    8036ee <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803645:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803649:	74 06                	je     803651 <insert_sorted_with_merge_freeList+0x6ac>
  80364b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80364f:	75 17                	jne    803668 <insert_sorted_with_merge_freeList+0x6c3>
  803651:	83 ec 04             	sub    $0x4,%esp
  803654:	68 cc 43 80 00       	push   $0x8043cc
  803659:	68 73 01 00 00       	push   $0x173
  80365e:	68 57 43 80 00       	push   $0x804357
  803663:	e8 6e ce ff ff       	call   8004d6 <_panic>
  803668:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80366b:	8b 10                	mov    (%eax),%edx
  80366d:	8b 45 08             	mov    0x8(%ebp),%eax
  803670:	89 10                	mov    %edx,(%eax)
  803672:	8b 45 08             	mov    0x8(%ebp),%eax
  803675:	8b 00                	mov    (%eax),%eax
  803677:	85 c0                	test   %eax,%eax
  803679:	74 0b                	je     803686 <insert_sorted_with_merge_freeList+0x6e1>
  80367b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80367e:	8b 00                	mov    (%eax),%eax
  803680:	8b 55 08             	mov    0x8(%ebp),%edx
  803683:	89 50 04             	mov    %edx,0x4(%eax)
  803686:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803689:	8b 55 08             	mov    0x8(%ebp),%edx
  80368c:	89 10                	mov    %edx,(%eax)
  80368e:	8b 45 08             	mov    0x8(%ebp),%eax
  803691:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803694:	89 50 04             	mov    %edx,0x4(%eax)
  803697:	8b 45 08             	mov    0x8(%ebp),%eax
  80369a:	8b 00                	mov    (%eax),%eax
  80369c:	85 c0                	test   %eax,%eax
  80369e:	75 08                	jne    8036a8 <insert_sorted_with_merge_freeList+0x703>
  8036a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8036a3:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8036a8:	a1 44 51 80 00       	mov    0x805144,%eax
  8036ad:	40                   	inc    %eax
  8036ae:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  8036b3:	eb 39                	jmp    8036ee <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8036b5:	a1 40 51 80 00       	mov    0x805140,%eax
  8036ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8036bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036c1:	74 07                	je     8036ca <insert_sorted_with_merge_freeList+0x725>
  8036c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036c6:	8b 00                	mov    (%eax),%eax
  8036c8:	eb 05                	jmp    8036cf <insert_sorted_with_merge_freeList+0x72a>
  8036ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8036cf:	a3 40 51 80 00       	mov    %eax,0x805140
  8036d4:	a1 40 51 80 00       	mov    0x805140,%eax
  8036d9:	85 c0                	test   %eax,%eax
  8036db:	0f 85 c7 fb ff ff    	jne    8032a8 <insert_sorted_with_merge_freeList+0x303>
  8036e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036e5:	0f 85 bd fb ff ff    	jne    8032a8 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8036eb:	eb 01                	jmp    8036ee <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8036ed:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8036ee:	90                   	nop
  8036ef:	c9                   	leave  
  8036f0:	c3                   	ret    
  8036f1:	66 90                	xchg   %ax,%ax
  8036f3:	90                   	nop

008036f4 <__udivdi3>:
  8036f4:	55                   	push   %ebp
  8036f5:	57                   	push   %edi
  8036f6:	56                   	push   %esi
  8036f7:	53                   	push   %ebx
  8036f8:	83 ec 1c             	sub    $0x1c,%esp
  8036fb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8036ff:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803703:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803707:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80370b:	89 ca                	mov    %ecx,%edx
  80370d:	89 f8                	mov    %edi,%eax
  80370f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803713:	85 f6                	test   %esi,%esi
  803715:	75 2d                	jne    803744 <__udivdi3+0x50>
  803717:	39 cf                	cmp    %ecx,%edi
  803719:	77 65                	ja     803780 <__udivdi3+0x8c>
  80371b:	89 fd                	mov    %edi,%ebp
  80371d:	85 ff                	test   %edi,%edi
  80371f:	75 0b                	jne    80372c <__udivdi3+0x38>
  803721:	b8 01 00 00 00       	mov    $0x1,%eax
  803726:	31 d2                	xor    %edx,%edx
  803728:	f7 f7                	div    %edi
  80372a:	89 c5                	mov    %eax,%ebp
  80372c:	31 d2                	xor    %edx,%edx
  80372e:	89 c8                	mov    %ecx,%eax
  803730:	f7 f5                	div    %ebp
  803732:	89 c1                	mov    %eax,%ecx
  803734:	89 d8                	mov    %ebx,%eax
  803736:	f7 f5                	div    %ebp
  803738:	89 cf                	mov    %ecx,%edi
  80373a:	89 fa                	mov    %edi,%edx
  80373c:	83 c4 1c             	add    $0x1c,%esp
  80373f:	5b                   	pop    %ebx
  803740:	5e                   	pop    %esi
  803741:	5f                   	pop    %edi
  803742:	5d                   	pop    %ebp
  803743:	c3                   	ret    
  803744:	39 ce                	cmp    %ecx,%esi
  803746:	77 28                	ja     803770 <__udivdi3+0x7c>
  803748:	0f bd fe             	bsr    %esi,%edi
  80374b:	83 f7 1f             	xor    $0x1f,%edi
  80374e:	75 40                	jne    803790 <__udivdi3+0x9c>
  803750:	39 ce                	cmp    %ecx,%esi
  803752:	72 0a                	jb     80375e <__udivdi3+0x6a>
  803754:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803758:	0f 87 9e 00 00 00    	ja     8037fc <__udivdi3+0x108>
  80375e:	b8 01 00 00 00       	mov    $0x1,%eax
  803763:	89 fa                	mov    %edi,%edx
  803765:	83 c4 1c             	add    $0x1c,%esp
  803768:	5b                   	pop    %ebx
  803769:	5e                   	pop    %esi
  80376a:	5f                   	pop    %edi
  80376b:	5d                   	pop    %ebp
  80376c:	c3                   	ret    
  80376d:	8d 76 00             	lea    0x0(%esi),%esi
  803770:	31 ff                	xor    %edi,%edi
  803772:	31 c0                	xor    %eax,%eax
  803774:	89 fa                	mov    %edi,%edx
  803776:	83 c4 1c             	add    $0x1c,%esp
  803779:	5b                   	pop    %ebx
  80377a:	5e                   	pop    %esi
  80377b:	5f                   	pop    %edi
  80377c:	5d                   	pop    %ebp
  80377d:	c3                   	ret    
  80377e:	66 90                	xchg   %ax,%ax
  803780:	89 d8                	mov    %ebx,%eax
  803782:	f7 f7                	div    %edi
  803784:	31 ff                	xor    %edi,%edi
  803786:	89 fa                	mov    %edi,%edx
  803788:	83 c4 1c             	add    $0x1c,%esp
  80378b:	5b                   	pop    %ebx
  80378c:	5e                   	pop    %esi
  80378d:	5f                   	pop    %edi
  80378e:	5d                   	pop    %ebp
  80378f:	c3                   	ret    
  803790:	bd 20 00 00 00       	mov    $0x20,%ebp
  803795:	89 eb                	mov    %ebp,%ebx
  803797:	29 fb                	sub    %edi,%ebx
  803799:	89 f9                	mov    %edi,%ecx
  80379b:	d3 e6                	shl    %cl,%esi
  80379d:	89 c5                	mov    %eax,%ebp
  80379f:	88 d9                	mov    %bl,%cl
  8037a1:	d3 ed                	shr    %cl,%ebp
  8037a3:	89 e9                	mov    %ebp,%ecx
  8037a5:	09 f1                	or     %esi,%ecx
  8037a7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8037ab:	89 f9                	mov    %edi,%ecx
  8037ad:	d3 e0                	shl    %cl,%eax
  8037af:	89 c5                	mov    %eax,%ebp
  8037b1:	89 d6                	mov    %edx,%esi
  8037b3:	88 d9                	mov    %bl,%cl
  8037b5:	d3 ee                	shr    %cl,%esi
  8037b7:	89 f9                	mov    %edi,%ecx
  8037b9:	d3 e2                	shl    %cl,%edx
  8037bb:	8b 44 24 08          	mov    0x8(%esp),%eax
  8037bf:	88 d9                	mov    %bl,%cl
  8037c1:	d3 e8                	shr    %cl,%eax
  8037c3:	09 c2                	or     %eax,%edx
  8037c5:	89 d0                	mov    %edx,%eax
  8037c7:	89 f2                	mov    %esi,%edx
  8037c9:	f7 74 24 0c          	divl   0xc(%esp)
  8037cd:	89 d6                	mov    %edx,%esi
  8037cf:	89 c3                	mov    %eax,%ebx
  8037d1:	f7 e5                	mul    %ebp
  8037d3:	39 d6                	cmp    %edx,%esi
  8037d5:	72 19                	jb     8037f0 <__udivdi3+0xfc>
  8037d7:	74 0b                	je     8037e4 <__udivdi3+0xf0>
  8037d9:	89 d8                	mov    %ebx,%eax
  8037db:	31 ff                	xor    %edi,%edi
  8037dd:	e9 58 ff ff ff       	jmp    80373a <__udivdi3+0x46>
  8037e2:	66 90                	xchg   %ax,%ax
  8037e4:	8b 54 24 08          	mov    0x8(%esp),%edx
  8037e8:	89 f9                	mov    %edi,%ecx
  8037ea:	d3 e2                	shl    %cl,%edx
  8037ec:	39 c2                	cmp    %eax,%edx
  8037ee:	73 e9                	jae    8037d9 <__udivdi3+0xe5>
  8037f0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8037f3:	31 ff                	xor    %edi,%edi
  8037f5:	e9 40 ff ff ff       	jmp    80373a <__udivdi3+0x46>
  8037fa:	66 90                	xchg   %ax,%ax
  8037fc:	31 c0                	xor    %eax,%eax
  8037fe:	e9 37 ff ff ff       	jmp    80373a <__udivdi3+0x46>
  803803:	90                   	nop

00803804 <__umoddi3>:
  803804:	55                   	push   %ebp
  803805:	57                   	push   %edi
  803806:	56                   	push   %esi
  803807:	53                   	push   %ebx
  803808:	83 ec 1c             	sub    $0x1c,%esp
  80380b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80380f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803813:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803817:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80381b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80381f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803823:	89 f3                	mov    %esi,%ebx
  803825:	89 fa                	mov    %edi,%edx
  803827:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80382b:	89 34 24             	mov    %esi,(%esp)
  80382e:	85 c0                	test   %eax,%eax
  803830:	75 1a                	jne    80384c <__umoddi3+0x48>
  803832:	39 f7                	cmp    %esi,%edi
  803834:	0f 86 a2 00 00 00    	jbe    8038dc <__umoddi3+0xd8>
  80383a:	89 c8                	mov    %ecx,%eax
  80383c:	89 f2                	mov    %esi,%edx
  80383e:	f7 f7                	div    %edi
  803840:	89 d0                	mov    %edx,%eax
  803842:	31 d2                	xor    %edx,%edx
  803844:	83 c4 1c             	add    $0x1c,%esp
  803847:	5b                   	pop    %ebx
  803848:	5e                   	pop    %esi
  803849:	5f                   	pop    %edi
  80384a:	5d                   	pop    %ebp
  80384b:	c3                   	ret    
  80384c:	39 f0                	cmp    %esi,%eax
  80384e:	0f 87 ac 00 00 00    	ja     803900 <__umoddi3+0xfc>
  803854:	0f bd e8             	bsr    %eax,%ebp
  803857:	83 f5 1f             	xor    $0x1f,%ebp
  80385a:	0f 84 ac 00 00 00    	je     80390c <__umoddi3+0x108>
  803860:	bf 20 00 00 00       	mov    $0x20,%edi
  803865:	29 ef                	sub    %ebp,%edi
  803867:	89 fe                	mov    %edi,%esi
  803869:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80386d:	89 e9                	mov    %ebp,%ecx
  80386f:	d3 e0                	shl    %cl,%eax
  803871:	89 d7                	mov    %edx,%edi
  803873:	89 f1                	mov    %esi,%ecx
  803875:	d3 ef                	shr    %cl,%edi
  803877:	09 c7                	or     %eax,%edi
  803879:	89 e9                	mov    %ebp,%ecx
  80387b:	d3 e2                	shl    %cl,%edx
  80387d:	89 14 24             	mov    %edx,(%esp)
  803880:	89 d8                	mov    %ebx,%eax
  803882:	d3 e0                	shl    %cl,%eax
  803884:	89 c2                	mov    %eax,%edx
  803886:	8b 44 24 08          	mov    0x8(%esp),%eax
  80388a:	d3 e0                	shl    %cl,%eax
  80388c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803890:	8b 44 24 08          	mov    0x8(%esp),%eax
  803894:	89 f1                	mov    %esi,%ecx
  803896:	d3 e8                	shr    %cl,%eax
  803898:	09 d0                	or     %edx,%eax
  80389a:	d3 eb                	shr    %cl,%ebx
  80389c:	89 da                	mov    %ebx,%edx
  80389e:	f7 f7                	div    %edi
  8038a0:	89 d3                	mov    %edx,%ebx
  8038a2:	f7 24 24             	mull   (%esp)
  8038a5:	89 c6                	mov    %eax,%esi
  8038a7:	89 d1                	mov    %edx,%ecx
  8038a9:	39 d3                	cmp    %edx,%ebx
  8038ab:	0f 82 87 00 00 00    	jb     803938 <__umoddi3+0x134>
  8038b1:	0f 84 91 00 00 00    	je     803948 <__umoddi3+0x144>
  8038b7:	8b 54 24 04          	mov    0x4(%esp),%edx
  8038bb:	29 f2                	sub    %esi,%edx
  8038bd:	19 cb                	sbb    %ecx,%ebx
  8038bf:	89 d8                	mov    %ebx,%eax
  8038c1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8038c5:	d3 e0                	shl    %cl,%eax
  8038c7:	89 e9                	mov    %ebp,%ecx
  8038c9:	d3 ea                	shr    %cl,%edx
  8038cb:	09 d0                	or     %edx,%eax
  8038cd:	89 e9                	mov    %ebp,%ecx
  8038cf:	d3 eb                	shr    %cl,%ebx
  8038d1:	89 da                	mov    %ebx,%edx
  8038d3:	83 c4 1c             	add    $0x1c,%esp
  8038d6:	5b                   	pop    %ebx
  8038d7:	5e                   	pop    %esi
  8038d8:	5f                   	pop    %edi
  8038d9:	5d                   	pop    %ebp
  8038da:	c3                   	ret    
  8038db:	90                   	nop
  8038dc:	89 fd                	mov    %edi,%ebp
  8038de:	85 ff                	test   %edi,%edi
  8038e0:	75 0b                	jne    8038ed <__umoddi3+0xe9>
  8038e2:	b8 01 00 00 00       	mov    $0x1,%eax
  8038e7:	31 d2                	xor    %edx,%edx
  8038e9:	f7 f7                	div    %edi
  8038eb:	89 c5                	mov    %eax,%ebp
  8038ed:	89 f0                	mov    %esi,%eax
  8038ef:	31 d2                	xor    %edx,%edx
  8038f1:	f7 f5                	div    %ebp
  8038f3:	89 c8                	mov    %ecx,%eax
  8038f5:	f7 f5                	div    %ebp
  8038f7:	89 d0                	mov    %edx,%eax
  8038f9:	e9 44 ff ff ff       	jmp    803842 <__umoddi3+0x3e>
  8038fe:	66 90                	xchg   %ax,%ax
  803900:	89 c8                	mov    %ecx,%eax
  803902:	89 f2                	mov    %esi,%edx
  803904:	83 c4 1c             	add    $0x1c,%esp
  803907:	5b                   	pop    %ebx
  803908:	5e                   	pop    %esi
  803909:	5f                   	pop    %edi
  80390a:	5d                   	pop    %ebp
  80390b:	c3                   	ret    
  80390c:	3b 04 24             	cmp    (%esp),%eax
  80390f:	72 06                	jb     803917 <__umoddi3+0x113>
  803911:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803915:	77 0f                	ja     803926 <__umoddi3+0x122>
  803917:	89 f2                	mov    %esi,%edx
  803919:	29 f9                	sub    %edi,%ecx
  80391b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80391f:	89 14 24             	mov    %edx,(%esp)
  803922:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803926:	8b 44 24 04          	mov    0x4(%esp),%eax
  80392a:	8b 14 24             	mov    (%esp),%edx
  80392d:	83 c4 1c             	add    $0x1c,%esp
  803930:	5b                   	pop    %ebx
  803931:	5e                   	pop    %esi
  803932:	5f                   	pop    %edi
  803933:	5d                   	pop    %ebp
  803934:	c3                   	ret    
  803935:	8d 76 00             	lea    0x0(%esi),%esi
  803938:	2b 04 24             	sub    (%esp),%eax
  80393b:	19 fa                	sbb    %edi,%edx
  80393d:	89 d1                	mov    %edx,%ecx
  80393f:	89 c6                	mov    %eax,%esi
  803941:	e9 71 ff ff ff       	jmp    8038b7 <__umoddi3+0xb3>
  803946:	66 90                	xchg   %ax,%ax
  803948:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80394c:	72 ea                	jb     803938 <__umoddi3+0x134>
  80394e:	89 d9                	mov    %ebx,%ecx
  803950:	e9 62 ff ff ff       	jmp    8038b7 <__umoddi3+0xb3>
