
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
  80008d:	68 00 38 80 00       	push   $0x803800
  800092:	6a 12                	push   $0x12
  800094:	68 1c 38 80 00       	push   $0x80381c
  800099:	e8 38 04 00 00       	call   8004d6 <_panic>
	}

	uint32 *x, *y, *z ;
	cprintf("STEP A: checking the creation of shared variables... \n");
  80009e:	83 ec 0c             	sub    $0xc,%esp
  8000a1:	68 34 38 80 00       	push   $0x803834
  8000a6:	e8 df 06 00 00       	call   80078a <cprintf>
  8000ab:	83 c4 10             	add    $0x10,%esp
	{
		int freeFrames = sys_calculate_free_frames() ;
  8000ae:	e8 0c 19 00 00       	call   8019bf <sys_calculate_free_frames>
  8000b3:	89 45 e8             	mov    %eax,-0x18(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8000b6:	83 ec 04             	sub    $0x4,%esp
  8000b9:	6a 01                	push   $0x1
  8000bb:	68 00 10 00 00       	push   $0x1000
  8000c0:	68 6b 38 80 00       	push   $0x80386b
  8000c5:	e8 90 16 00 00       	call   80175a <smalloc>
  8000ca:	83 c4 10             	add    $0x10,%esp
  8000cd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (x != (uint32*)USER_HEAP_START) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  8000d0:	81 7d e4 00 00 00 80 	cmpl   $0x80000000,-0x1c(%ebp)
  8000d7:	74 14                	je     8000ed <_main+0xb5>
  8000d9:	83 ec 04             	sub    $0x4,%esp
  8000dc:	68 70 38 80 00       	push   $0x803870
  8000e1:	6a 1a                	push   $0x1a
  8000e3:	68 1c 38 80 00       	push   $0x80381c
  8000e8:	e8 e9 03 00 00       	call   8004d6 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage %d %d %d", freeFrames, sys_calculate_free_frames(), freeFrames - sys_calculate_free_frames());
  8000ed:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8000f0:	e8 ca 18 00 00       	call   8019bf <sys_calculate_free_frames>
  8000f5:	29 c3                	sub    %eax,%ebx
  8000f7:	89 d8                	mov    %ebx,%eax
  8000f9:	83 f8 04             	cmp    $0x4,%eax
  8000fc:	74 28                	je     800126 <_main+0xee>
  8000fe:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800101:	e8 b9 18 00 00       	call   8019bf <sys_calculate_free_frames>
  800106:	29 c3                	sub    %eax,%ebx
  800108:	e8 b2 18 00 00       	call   8019bf <sys_calculate_free_frames>
  80010d:	83 ec 08             	sub    $0x8,%esp
  800110:	53                   	push   %ebx
  800111:	50                   	push   %eax
  800112:	ff 75 e8             	pushl  -0x18(%ebp)
  800115:	68 dc 38 80 00       	push   $0x8038dc
  80011a:	6a 1b                	push   $0x1b
  80011c:	68 1c 38 80 00       	push   $0x80381c
  800121:	e8 b0 03 00 00       	call   8004d6 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800126:	e8 94 18 00 00       	call   8019bf <sys_calculate_free_frames>
  80012b:	89 45 e8             	mov    %eax,-0x18(%ebp)
		z = smalloc("y", PAGE_SIZE + 4, 1);
  80012e:	83 ec 04             	sub    $0x4,%esp
  800131:	6a 01                	push   $0x1
  800133:	68 04 10 00 00       	push   $0x1004
  800138:	68 63 39 80 00       	push   $0x803963
  80013d:	e8 18 16 00 00       	call   80175a <smalloc>
  800142:	83 c4 10             	add    $0x10,%esp
  800145:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (z != (uint32*)(USER_HEAP_START + 1 * PAGE_SIZE)) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  800148:	81 7d e0 00 10 00 80 	cmpl   $0x80001000,-0x20(%ebp)
  80014f:	74 14                	je     800165 <_main+0x12d>
  800151:	83 ec 04             	sub    $0x4,%esp
  800154:	68 70 38 80 00       	push   $0x803870
  800159:	6a 1f                	push   $0x1f
  80015b:	68 1c 38 80 00       	push   $0x80381c
  800160:	e8 71 03 00 00       	call   8004d6 <_panic>

		if ((freeFrames - sys_calculate_free_frames()) !=  2+0+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage %d %d %d", freeFrames, sys_calculate_free_frames(), freeFrames - sys_calculate_free_frames());
  800165:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800168:	e8 52 18 00 00       	call   8019bf <sys_calculate_free_frames>
  80016d:	29 c3                	sub    %eax,%ebx
  80016f:	89 d8                	mov    %ebx,%eax
  800171:	83 f8 04             	cmp    $0x4,%eax
  800174:	74 28                	je     80019e <_main+0x166>
  800176:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800179:	e8 41 18 00 00       	call   8019bf <sys_calculate_free_frames>
  80017e:	29 c3                	sub    %eax,%ebx
  800180:	e8 3a 18 00 00       	call   8019bf <sys_calculate_free_frames>
  800185:	83 ec 08             	sub    $0x8,%esp
  800188:	53                   	push   %ebx
  800189:	50                   	push   %eax
  80018a:	ff 75 e8             	pushl  -0x18(%ebp)
  80018d:	68 dc 38 80 00       	push   $0x8038dc
  800192:	6a 21                	push   $0x21
  800194:	68 1c 38 80 00       	push   $0x80381c
  800199:	e8 38 03 00 00       	call   8004d6 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  80019e:	e8 1c 18 00 00       	call   8019bf <sys_calculate_free_frames>
  8001a3:	89 45 e8             	mov    %eax,-0x18(%ebp)
		y = smalloc("z", 4, 1);
  8001a6:	83 ec 04             	sub    $0x4,%esp
  8001a9:	6a 01                	push   $0x1
  8001ab:	6a 04                	push   $0x4
  8001ad:	68 65 39 80 00       	push   $0x803965
  8001b2:	e8 a3 15 00 00       	call   80175a <smalloc>
  8001b7:	83 c4 10             	add    $0x10,%esp
  8001ba:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (y != (uint32*)(USER_HEAP_START + 3 * PAGE_SIZE)) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  8001bd:	81 7d dc 00 30 00 80 	cmpl   $0x80003000,-0x24(%ebp)
  8001c4:	74 14                	je     8001da <_main+0x1a2>
  8001c6:	83 ec 04             	sub    $0x4,%esp
  8001c9:	68 70 38 80 00       	push   $0x803870
  8001ce:	6a 25                	push   $0x25
  8001d0:	68 1c 38 80 00       	push   $0x80381c
  8001d5:	e8 fc 02 00 00       	call   8004d6 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  1+0+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  8001da:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8001dd:	e8 dd 17 00 00       	call   8019bf <sys_calculate_free_frames>
  8001e2:	29 c3                	sub    %eax,%ebx
  8001e4:	89 d8                	mov    %ebx,%eax
  8001e6:	83 f8 03             	cmp    $0x3,%eax
  8001e9:	74 14                	je     8001ff <_main+0x1c7>
  8001eb:	83 ec 04             	sub    $0x4,%esp
  8001ee:	68 68 39 80 00       	push   $0x803968
  8001f3:	6a 26                	push   $0x26
  8001f5:	68 1c 38 80 00       	push   $0x80381c
  8001fa:	e8 d7 02 00 00       	call   8004d6 <_panic>
	}
	cprintf("Step A is completed successfully!!\n\n\n");
  8001ff:	83 ec 0c             	sub    $0xc,%esp
  800202:	68 e8 39 80 00       	push   $0x8039e8
  800207:	e8 7e 05 00 00       	call   80078a <cprintf>
  80020c:	83 c4 10             	add    $0x10,%esp


	cprintf("STEP B: checking reading & writing... \n");
  80020f:	83 ec 0c             	sub    $0xc,%esp
  800212:	68 10 3a 80 00       	push   $0x803a10
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
  800295:	68 38 3a 80 00       	push   $0x803a38
  80029a:	6a 3a                	push   $0x3a
  80029c:	68 1c 38 80 00       	push   $0x80381c
  8002a1:	e8 30 02 00 00       	call   8004d6 <_panic>
		if( x[PAGE_SIZE/4 - 1] !=  -1)  	panic("Reading/Writing of shared object is failed");
  8002a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002a9:	05 fc 0f 00 00       	add    $0xffc,%eax
  8002ae:	8b 00                	mov    (%eax),%eax
  8002b0:	83 f8 ff             	cmp    $0xffffffff,%eax
  8002b3:	74 14                	je     8002c9 <_main+0x291>
  8002b5:	83 ec 04             	sub    $0x4,%esp
  8002b8:	68 38 3a 80 00       	push   $0x803a38
  8002bd:	6a 3b                	push   $0x3b
  8002bf:	68 1c 38 80 00       	push   $0x80381c
  8002c4:	e8 0d 02 00 00       	call   8004d6 <_panic>

		if( y[0] !=  -1)  					panic("Reading/Writing of shared object is failed");
  8002c9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002cc:	8b 00                	mov    (%eax),%eax
  8002ce:	83 f8 ff             	cmp    $0xffffffff,%eax
  8002d1:	74 14                	je     8002e7 <_main+0x2af>
  8002d3:	83 ec 04             	sub    $0x4,%esp
  8002d6:	68 38 3a 80 00       	push   $0x803a38
  8002db:	6a 3d                	push   $0x3d
  8002dd:	68 1c 38 80 00       	push   $0x80381c
  8002e2:	e8 ef 01 00 00       	call   8004d6 <_panic>
		if( y[PAGE_SIZE/4 - 1] !=  -1)  	panic("Reading/Writing of shared object is failed");
  8002e7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002ea:	05 fc 0f 00 00       	add    $0xffc,%eax
  8002ef:	8b 00                	mov    (%eax),%eax
  8002f1:	83 f8 ff             	cmp    $0xffffffff,%eax
  8002f4:	74 14                	je     80030a <_main+0x2d2>
  8002f6:	83 ec 04             	sub    $0x4,%esp
  8002f9:	68 38 3a 80 00       	push   $0x803a38
  8002fe:	6a 3e                	push   $0x3e
  800300:	68 1c 38 80 00       	push   $0x80381c
  800305:	e8 cc 01 00 00       	call   8004d6 <_panic>

		if( z[0] !=  -1)  					panic("Reading/Writing of shared object is failed");
  80030a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80030d:	8b 00                	mov    (%eax),%eax
  80030f:	83 f8 ff             	cmp    $0xffffffff,%eax
  800312:	74 14                	je     800328 <_main+0x2f0>
  800314:	83 ec 04             	sub    $0x4,%esp
  800317:	68 38 3a 80 00       	push   $0x803a38
  80031c:	6a 40                	push   $0x40
  80031e:	68 1c 38 80 00       	push   $0x80381c
  800323:	e8 ae 01 00 00       	call   8004d6 <_panic>
		if( z[2*PAGE_SIZE/4 - 1] !=  -1)  	panic("Reading/Writing of shared object is failed");
  800328:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80032b:	05 fc 1f 00 00       	add    $0x1ffc,%eax
  800330:	8b 00                	mov    (%eax),%eax
  800332:	83 f8 ff             	cmp    $0xffffffff,%eax
  800335:	74 14                	je     80034b <_main+0x313>
  800337:	83 ec 04             	sub    $0x4,%esp
  80033a:	68 38 3a 80 00       	push   $0x803a38
  80033f:	6a 41                	push   $0x41
  800341:	68 1c 38 80 00       	push   $0x80381c
  800346:	e8 8b 01 00 00       	call   8004d6 <_panic>
	}

	cprintf("Congratulations!! Test of Shared Variables [Create] [1] completed successfully!!\n\n\n");
  80034b:	83 ec 0c             	sub    $0xc,%esp
  80034e:	68 64 3a 80 00       	push   $0x803a64
  800353:	e8 32 04 00 00       	call   80078a <cprintf>
  800358:	83 c4 10             	add    $0x10,%esp

	int32 parentenvID = sys_getparentenvid();
  80035b:	e8 58 19 00 00       	call   801cb8 <sys_getparentenvid>
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
  800373:	68 b8 3a 80 00       	push   $0x803ab8
  800378:	ff 75 d8             	pushl  -0x28(%ebp)
  80037b:	e8 9b 14 00 00       	call   80181b <sget>
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
  8003a0:	e8 fa 18 00 00       	call   801c9f <sys_getenvindex>
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
  80040b:	e8 9c 16 00 00       	call   801aac <sys_disable_interrupt>
	cprintf("**************************************\n");
  800410:	83 ec 0c             	sub    $0xc,%esp
  800413:	68 e0 3a 80 00       	push   $0x803ae0
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
  80043b:	68 08 3b 80 00       	push   $0x803b08
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
  80046c:	68 30 3b 80 00       	push   $0x803b30
  800471:	e8 14 03 00 00       	call   80078a <cprintf>
  800476:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800479:	a1 20 50 80 00       	mov    0x805020,%eax
  80047e:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800484:	83 ec 08             	sub    $0x8,%esp
  800487:	50                   	push   %eax
  800488:	68 88 3b 80 00       	push   $0x803b88
  80048d:	e8 f8 02 00 00       	call   80078a <cprintf>
  800492:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800495:	83 ec 0c             	sub    $0xc,%esp
  800498:	68 e0 3a 80 00       	push   $0x803ae0
  80049d:	e8 e8 02 00 00       	call   80078a <cprintf>
  8004a2:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8004a5:	e8 1c 16 00 00       	call   801ac6 <sys_enable_interrupt>

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
  8004bd:	e8 a9 17 00 00       	call   801c6b <sys_destroy_env>
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
  8004ce:	e8 fe 17 00 00       	call   801cd1 <sys_exit_env>
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
  8004f7:	68 9c 3b 80 00       	push   $0x803b9c
  8004fc:	e8 89 02 00 00       	call   80078a <cprintf>
  800501:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800504:	a1 00 50 80 00       	mov    0x805000,%eax
  800509:	ff 75 0c             	pushl  0xc(%ebp)
  80050c:	ff 75 08             	pushl  0x8(%ebp)
  80050f:	50                   	push   %eax
  800510:	68 a1 3b 80 00       	push   $0x803ba1
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
  800534:	68 bd 3b 80 00       	push   $0x803bbd
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
  800560:	68 c0 3b 80 00       	push   $0x803bc0
  800565:	6a 26                	push   $0x26
  800567:	68 0c 3c 80 00       	push   $0x803c0c
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
  800632:	68 18 3c 80 00       	push   $0x803c18
  800637:	6a 3a                	push   $0x3a
  800639:	68 0c 3c 80 00       	push   $0x803c0c
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
  8006a2:	68 6c 3c 80 00       	push   $0x803c6c
  8006a7:	6a 44                	push   $0x44
  8006a9:	68 0c 3c 80 00       	push   $0x803c0c
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
  8006fc:	e8 fd 11 00 00       	call   8018fe <sys_cputs>
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
  800773:	e8 86 11 00 00       	call   8018fe <sys_cputs>
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
  8007bd:	e8 ea 12 00 00       	call   801aac <sys_disable_interrupt>
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
  8007dd:	e8 e4 12 00 00       	call   801ac6 <sys_enable_interrupt>
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
  800827:	e8 58 2d 00 00       	call   803584 <__udivdi3>
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
  800877:	e8 18 2e 00 00       	call   803694 <__umoddi3>
  80087c:	83 c4 10             	add    $0x10,%esp
  80087f:	05 d4 3e 80 00       	add    $0x803ed4,%eax
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
  8009d2:	8b 04 85 f8 3e 80 00 	mov    0x803ef8(,%eax,4),%eax
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
  800ab3:	8b 34 9d 40 3d 80 00 	mov    0x803d40(,%ebx,4),%esi
  800aba:	85 f6                	test   %esi,%esi
  800abc:	75 19                	jne    800ad7 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800abe:	53                   	push   %ebx
  800abf:	68 e5 3e 80 00       	push   $0x803ee5
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
  800ad8:	68 ee 3e 80 00       	push   $0x803eee
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
  800b05:	be f1 3e 80 00       	mov    $0x803ef1,%esi
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
  80152b:	68 50 40 80 00       	push   $0x804050
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
  8015fb:	e8 42 04 00 00       	call   801a42 <sys_allocate_chunk>
  801600:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801603:	a1 20 51 80 00       	mov    0x805120,%eax
  801608:	83 ec 0c             	sub    $0xc,%esp
  80160b:	50                   	push   %eax
  80160c:	e8 b7 0a 00 00       	call   8020c8 <initialize_MemBlocksList>
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
  801639:	68 75 40 80 00       	push   $0x804075
  80163e:	6a 33                	push   $0x33
  801640:	68 93 40 80 00       	push   $0x804093
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
  8016b8:	68 a0 40 80 00       	push   $0x8040a0
  8016bd:	6a 34                	push   $0x34
  8016bf:	68 93 40 80 00       	push   $0x804093
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
  80172d:	68 c4 40 80 00       	push   $0x8040c4
  801732:	6a 46                	push   $0x46
  801734:	68 93 40 80 00       	push   $0x804093
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
  801749:	68 ec 40 80 00       	push   $0x8040ec
  80174e:	6a 61                	push   $0x61
  801750:	68 93 40 80 00       	push   $0x804093
  801755:	e8 7c ed ff ff       	call   8004d6 <_panic>

0080175a <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80175a:	55                   	push   %ebp
  80175b:	89 e5                	mov    %esp,%ebp
  80175d:	83 ec 38             	sub    $0x38,%esp
  801760:	8b 45 10             	mov    0x10(%ebp),%eax
  801763:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801766:	e8 a9 fd ff ff       	call   801514 <InitializeUHeap>
	if (size == 0) return NULL ;
  80176b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80176f:	75 0a                	jne    80177b <smalloc+0x21>
  801771:	b8 00 00 00 00       	mov    $0x0,%eax
  801776:	e9 9e 00 00 00       	jmp    801819 <smalloc+0xbf>
	//3-If the Kernel successfully creates the shared variable, return its virtual address
	//4-Else, return NULL



	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  80177b:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801782:	8b 55 0c             	mov    0xc(%ebp),%edx
  801785:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801788:	01 d0                	add    %edx,%eax
  80178a:	48                   	dec    %eax
  80178b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80178e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801791:	ba 00 00 00 00       	mov    $0x0,%edx
  801796:	f7 75 f0             	divl   -0x10(%ebp)
  801799:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80179c:	29 d0                	sub    %edx,%eax
  80179e:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  8017a1:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  8017a8:	e8 63 06 00 00       	call   801e10 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8017ad:	85 c0                	test   %eax,%eax
  8017af:	74 11                	je     8017c2 <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  8017b1:	83 ec 0c             	sub    $0xc,%esp
  8017b4:	ff 75 e8             	pushl  -0x18(%ebp)
  8017b7:	e8 ce 0c 00 00       	call   80248a <alloc_block_FF>
  8017bc:	83 c4 10             	add    $0x10,%esp
  8017bf:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  8017c2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8017c6:	74 4c                	je     801814 <smalloc+0xba>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  8017c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017cb:	8b 40 08             	mov    0x8(%eax),%eax
  8017ce:	89 c2                	mov    %eax,%edx
  8017d0:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8017d4:	52                   	push   %edx
  8017d5:	50                   	push   %eax
  8017d6:	ff 75 0c             	pushl  0xc(%ebp)
  8017d9:	ff 75 08             	pushl  0x8(%ebp)
  8017dc:	e8 b4 03 00 00       	call   801b95 <sys_createSharedObject>
  8017e1:	83 c4 10             	add    $0x10,%esp
  8017e4:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cprintf("Output is :  %d \n" , result);
  8017e7:	83 ec 08             	sub    $0x8,%esp
  8017ea:	ff 75 e0             	pushl  -0x20(%ebp)
  8017ed:	68 0f 41 80 00       	push   $0x80410f
  8017f2:	e8 93 ef ff ff       	call   80078a <cprintf>
  8017f7:	83 c4 10             	add    $0x10,%esp
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  8017fa:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  8017fe:	74 14                	je     801814 <smalloc+0xba>
  801800:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  801804:	74 0e                	je     801814 <smalloc+0xba>
  801806:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  80180a:	74 08                	je     801814 <smalloc+0xba>
			return (void*) mem_block->sva;
  80180c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80180f:	8b 40 08             	mov    0x8(%eax),%eax
  801812:	eb 05                	jmp    801819 <smalloc+0xbf>
	}
	return NULL;
  801814:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801819:	c9                   	leave  
  80181a:	c3                   	ret    

0080181b <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80181b:	55                   	push   %ebp
  80181c:	89 e5                	mov    %esp,%ebp
  80181e:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801821:	e8 ee fc ff ff       	call   801514 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801826:	83 ec 04             	sub    $0x4,%esp
  801829:	68 24 41 80 00       	push   $0x804124
  80182e:	68 ab 00 00 00       	push   $0xab
  801833:	68 93 40 80 00       	push   $0x804093
  801838:	e8 99 ec ff ff       	call   8004d6 <_panic>

0080183d <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80183d:	55                   	push   %ebp
  80183e:	89 e5                	mov    %esp,%ebp
  801840:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801843:	e8 cc fc ff ff       	call   801514 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801848:	83 ec 04             	sub    $0x4,%esp
  80184b:	68 48 41 80 00       	push   $0x804148
  801850:	68 ef 00 00 00       	push   $0xef
  801855:	68 93 40 80 00       	push   $0x804093
  80185a:	e8 77 ec ff ff       	call   8004d6 <_panic>

0080185f <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80185f:	55                   	push   %ebp
  801860:	89 e5                	mov    %esp,%ebp
  801862:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801865:	83 ec 04             	sub    $0x4,%esp
  801868:	68 70 41 80 00       	push   $0x804170
  80186d:	68 03 01 00 00       	push   $0x103
  801872:	68 93 40 80 00       	push   $0x804093
  801877:	e8 5a ec ff ff       	call   8004d6 <_panic>

0080187c <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  80187c:	55                   	push   %ebp
  80187d:	89 e5                	mov    %esp,%ebp
  80187f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801882:	83 ec 04             	sub    $0x4,%esp
  801885:	68 94 41 80 00       	push   $0x804194
  80188a:	68 0e 01 00 00       	push   $0x10e
  80188f:	68 93 40 80 00       	push   $0x804093
  801894:	e8 3d ec ff ff       	call   8004d6 <_panic>

00801899 <shrink>:

}
void shrink(uint32 newSize)
{
  801899:	55                   	push   %ebp
  80189a:	89 e5                	mov    %esp,%ebp
  80189c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80189f:	83 ec 04             	sub    $0x4,%esp
  8018a2:	68 94 41 80 00       	push   $0x804194
  8018a7:	68 13 01 00 00       	push   $0x113
  8018ac:	68 93 40 80 00       	push   $0x804093
  8018b1:	e8 20 ec ff ff       	call   8004d6 <_panic>

008018b6 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8018b6:	55                   	push   %ebp
  8018b7:	89 e5                	mov    %esp,%ebp
  8018b9:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018bc:	83 ec 04             	sub    $0x4,%esp
  8018bf:	68 94 41 80 00       	push   $0x804194
  8018c4:	68 18 01 00 00       	push   $0x118
  8018c9:	68 93 40 80 00       	push   $0x804093
  8018ce:	e8 03 ec ff ff       	call   8004d6 <_panic>

008018d3 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8018d3:	55                   	push   %ebp
  8018d4:	89 e5                	mov    %esp,%ebp
  8018d6:	57                   	push   %edi
  8018d7:	56                   	push   %esi
  8018d8:	53                   	push   %ebx
  8018d9:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8018dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8018df:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018e2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018e5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018e8:	8b 7d 18             	mov    0x18(%ebp),%edi
  8018eb:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8018ee:	cd 30                	int    $0x30
  8018f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8018f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8018f6:	83 c4 10             	add    $0x10,%esp
  8018f9:	5b                   	pop    %ebx
  8018fa:	5e                   	pop    %esi
  8018fb:	5f                   	pop    %edi
  8018fc:	5d                   	pop    %ebp
  8018fd:	c3                   	ret    

008018fe <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8018fe:	55                   	push   %ebp
  8018ff:	89 e5                	mov    %esp,%ebp
  801901:	83 ec 04             	sub    $0x4,%esp
  801904:	8b 45 10             	mov    0x10(%ebp),%eax
  801907:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80190a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80190e:	8b 45 08             	mov    0x8(%ebp),%eax
  801911:	6a 00                	push   $0x0
  801913:	6a 00                	push   $0x0
  801915:	52                   	push   %edx
  801916:	ff 75 0c             	pushl  0xc(%ebp)
  801919:	50                   	push   %eax
  80191a:	6a 00                	push   $0x0
  80191c:	e8 b2 ff ff ff       	call   8018d3 <syscall>
  801921:	83 c4 18             	add    $0x18,%esp
}
  801924:	90                   	nop
  801925:	c9                   	leave  
  801926:	c3                   	ret    

00801927 <sys_cgetc>:

int
sys_cgetc(void)
{
  801927:	55                   	push   %ebp
  801928:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80192a:	6a 00                	push   $0x0
  80192c:	6a 00                	push   $0x0
  80192e:	6a 00                	push   $0x0
  801930:	6a 00                	push   $0x0
  801932:	6a 00                	push   $0x0
  801934:	6a 01                	push   $0x1
  801936:	e8 98 ff ff ff       	call   8018d3 <syscall>
  80193b:	83 c4 18             	add    $0x18,%esp
}
  80193e:	c9                   	leave  
  80193f:	c3                   	ret    

00801940 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801940:	55                   	push   %ebp
  801941:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801943:	8b 55 0c             	mov    0xc(%ebp),%edx
  801946:	8b 45 08             	mov    0x8(%ebp),%eax
  801949:	6a 00                	push   $0x0
  80194b:	6a 00                	push   $0x0
  80194d:	6a 00                	push   $0x0
  80194f:	52                   	push   %edx
  801950:	50                   	push   %eax
  801951:	6a 05                	push   $0x5
  801953:	e8 7b ff ff ff       	call   8018d3 <syscall>
  801958:	83 c4 18             	add    $0x18,%esp
}
  80195b:	c9                   	leave  
  80195c:	c3                   	ret    

0080195d <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80195d:	55                   	push   %ebp
  80195e:	89 e5                	mov    %esp,%ebp
  801960:	56                   	push   %esi
  801961:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801962:	8b 75 18             	mov    0x18(%ebp),%esi
  801965:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801968:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80196b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80196e:	8b 45 08             	mov    0x8(%ebp),%eax
  801971:	56                   	push   %esi
  801972:	53                   	push   %ebx
  801973:	51                   	push   %ecx
  801974:	52                   	push   %edx
  801975:	50                   	push   %eax
  801976:	6a 06                	push   $0x6
  801978:	e8 56 ff ff ff       	call   8018d3 <syscall>
  80197d:	83 c4 18             	add    $0x18,%esp
}
  801980:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801983:	5b                   	pop    %ebx
  801984:	5e                   	pop    %esi
  801985:	5d                   	pop    %ebp
  801986:	c3                   	ret    

00801987 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801987:	55                   	push   %ebp
  801988:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80198a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80198d:	8b 45 08             	mov    0x8(%ebp),%eax
  801990:	6a 00                	push   $0x0
  801992:	6a 00                	push   $0x0
  801994:	6a 00                	push   $0x0
  801996:	52                   	push   %edx
  801997:	50                   	push   %eax
  801998:	6a 07                	push   $0x7
  80199a:	e8 34 ff ff ff       	call   8018d3 <syscall>
  80199f:	83 c4 18             	add    $0x18,%esp
}
  8019a2:	c9                   	leave  
  8019a3:	c3                   	ret    

008019a4 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8019a4:	55                   	push   %ebp
  8019a5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8019a7:	6a 00                	push   $0x0
  8019a9:	6a 00                	push   $0x0
  8019ab:	6a 00                	push   $0x0
  8019ad:	ff 75 0c             	pushl  0xc(%ebp)
  8019b0:	ff 75 08             	pushl  0x8(%ebp)
  8019b3:	6a 08                	push   $0x8
  8019b5:	e8 19 ff ff ff       	call   8018d3 <syscall>
  8019ba:	83 c4 18             	add    $0x18,%esp
}
  8019bd:	c9                   	leave  
  8019be:	c3                   	ret    

008019bf <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8019bf:	55                   	push   %ebp
  8019c0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8019c2:	6a 00                	push   $0x0
  8019c4:	6a 00                	push   $0x0
  8019c6:	6a 00                	push   $0x0
  8019c8:	6a 00                	push   $0x0
  8019ca:	6a 00                	push   $0x0
  8019cc:	6a 09                	push   $0x9
  8019ce:	e8 00 ff ff ff       	call   8018d3 <syscall>
  8019d3:	83 c4 18             	add    $0x18,%esp
}
  8019d6:	c9                   	leave  
  8019d7:	c3                   	ret    

008019d8 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8019d8:	55                   	push   %ebp
  8019d9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8019db:	6a 00                	push   $0x0
  8019dd:	6a 00                	push   $0x0
  8019df:	6a 00                	push   $0x0
  8019e1:	6a 00                	push   $0x0
  8019e3:	6a 00                	push   $0x0
  8019e5:	6a 0a                	push   $0xa
  8019e7:	e8 e7 fe ff ff       	call   8018d3 <syscall>
  8019ec:	83 c4 18             	add    $0x18,%esp
}
  8019ef:	c9                   	leave  
  8019f0:	c3                   	ret    

008019f1 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8019f1:	55                   	push   %ebp
  8019f2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8019f4:	6a 00                	push   $0x0
  8019f6:	6a 00                	push   $0x0
  8019f8:	6a 00                	push   $0x0
  8019fa:	6a 00                	push   $0x0
  8019fc:	6a 00                	push   $0x0
  8019fe:	6a 0b                	push   $0xb
  801a00:	e8 ce fe ff ff       	call   8018d3 <syscall>
  801a05:	83 c4 18             	add    $0x18,%esp
}
  801a08:	c9                   	leave  
  801a09:	c3                   	ret    

00801a0a <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801a0a:	55                   	push   %ebp
  801a0b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801a0d:	6a 00                	push   $0x0
  801a0f:	6a 00                	push   $0x0
  801a11:	6a 00                	push   $0x0
  801a13:	ff 75 0c             	pushl  0xc(%ebp)
  801a16:	ff 75 08             	pushl  0x8(%ebp)
  801a19:	6a 0f                	push   $0xf
  801a1b:	e8 b3 fe ff ff       	call   8018d3 <syscall>
  801a20:	83 c4 18             	add    $0x18,%esp
	return;
  801a23:	90                   	nop
}
  801a24:	c9                   	leave  
  801a25:	c3                   	ret    

00801a26 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801a26:	55                   	push   %ebp
  801a27:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801a29:	6a 00                	push   $0x0
  801a2b:	6a 00                	push   $0x0
  801a2d:	6a 00                	push   $0x0
  801a2f:	ff 75 0c             	pushl  0xc(%ebp)
  801a32:	ff 75 08             	pushl  0x8(%ebp)
  801a35:	6a 10                	push   $0x10
  801a37:	e8 97 fe ff ff       	call   8018d3 <syscall>
  801a3c:	83 c4 18             	add    $0x18,%esp
	return ;
  801a3f:	90                   	nop
}
  801a40:	c9                   	leave  
  801a41:	c3                   	ret    

00801a42 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801a42:	55                   	push   %ebp
  801a43:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801a45:	6a 00                	push   $0x0
  801a47:	6a 00                	push   $0x0
  801a49:	ff 75 10             	pushl  0x10(%ebp)
  801a4c:	ff 75 0c             	pushl  0xc(%ebp)
  801a4f:	ff 75 08             	pushl  0x8(%ebp)
  801a52:	6a 11                	push   $0x11
  801a54:	e8 7a fe ff ff       	call   8018d3 <syscall>
  801a59:	83 c4 18             	add    $0x18,%esp
	return ;
  801a5c:	90                   	nop
}
  801a5d:	c9                   	leave  
  801a5e:	c3                   	ret    

00801a5f <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801a5f:	55                   	push   %ebp
  801a60:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801a62:	6a 00                	push   $0x0
  801a64:	6a 00                	push   $0x0
  801a66:	6a 00                	push   $0x0
  801a68:	6a 00                	push   $0x0
  801a6a:	6a 00                	push   $0x0
  801a6c:	6a 0c                	push   $0xc
  801a6e:	e8 60 fe ff ff       	call   8018d3 <syscall>
  801a73:	83 c4 18             	add    $0x18,%esp
}
  801a76:	c9                   	leave  
  801a77:	c3                   	ret    

00801a78 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801a78:	55                   	push   %ebp
  801a79:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801a7b:	6a 00                	push   $0x0
  801a7d:	6a 00                	push   $0x0
  801a7f:	6a 00                	push   $0x0
  801a81:	6a 00                	push   $0x0
  801a83:	ff 75 08             	pushl  0x8(%ebp)
  801a86:	6a 0d                	push   $0xd
  801a88:	e8 46 fe ff ff       	call   8018d3 <syscall>
  801a8d:	83 c4 18             	add    $0x18,%esp
}
  801a90:	c9                   	leave  
  801a91:	c3                   	ret    

00801a92 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801a92:	55                   	push   %ebp
  801a93:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801a95:	6a 00                	push   $0x0
  801a97:	6a 00                	push   $0x0
  801a99:	6a 00                	push   $0x0
  801a9b:	6a 00                	push   $0x0
  801a9d:	6a 00                	push   $0x0
  801a9f:	6a 0e                	push   $0xe
  801aa1:	e8 2d fe ff ff       	call   8018d3 <syscall>
  801aa6:	83 c4 18             	add    $0x18,%esp
}
  801aa9:	90                   	nop
  801aaa:	c9                   	leave  
  801aab:	c3                   	ret    

00801aac <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801aac:	55                   	push   %ebp
  801aad:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801aaf:	6a 00                	push   $0x0
  801ab1:	6a 00                	push   $0x0
  801ab3:	6a 00                	push   $0x0
  801ab5:	6a 00                	push   $0x0
  801ab7:	6a 00                	push   $0x0
  801ab9:	6a 13                	push   $0x13
  801abb:	e8 13 fe ff ff       	call   8018d3 <syscall>
  801ac0:	83 c4 18             	add    $0x18,%esp
}
  801ac3:	90                   	nop
  801ac4:	c9                   	leave  
  801ac5:	c3                   	ret    

00801ac6 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801ac6:	55                   	push   %ebp
  801ac7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801ac9:	6a 00                	push   $0x0
  801acb:	6a 00                	push   $0x0
  801acd:	6a 00                	push   $0x0
  801acf:	6a 00                	push   $0x0
  801ad1:	6a 00                	push   $0x0
  801ad3:	6a 14                	push   $0x14
  801ad5:	e8 f9 fd ff ff       	call   8018d3 <syscall>
  801ada:	83 c4 18             	add    $0x18,%esp
}
  801add:	90                   	nop
  801ade:	c9                   	leave  
  801adf:	c3                   	ret    

00801ae0 <sys_cputc>:


void
sys_cputc(const char c)
{
  801ae0:	55                   	push   %ebp
  801ae1:	89 e5                	mov    %esp,%ebp
  801ae3:	83 ec 04             	sub    $0x4,%esp
  801ae6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801aec:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801af0:	6a 00                	push   $0x0
  801af2:	6a 00                	push   $0x0
  801af4:	6a 00                	push   $0x0
  801af6:	6a 00                	push   $0x0
  801af8:	50                   	push   %eax
  801af9:	6a 15                	push   $0x15
  801afb:	e8 d3 fd ff ff       	call   8018d3 <syscall>
  801b00:	83 c4 18             	add    $0x18,%esp
}
  801b03:	90                   	nop
  801b04:	c9                   	leave  
  801b05:	c3                   	ret    

00801b06 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801b06:	55                   	push   %ebp
  801b07:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801b09:	6a 00                	push   $0x0
  801b0b:	6a 00                	push   $0x0
  801b0d:	6a 00                	push   $0x0
  801b0f:	6a 00                	push   $0x0
  801b11:	6a 00                	push   $0x0
  801b13:	6a 16                	push   $0x16
  801b15:	e8 b9 fd ff ff       	call   8018d3 <syscall>
  801b1a:	83 c4 18             	add    $0x18,%esp
}
  801b1d:	90                   	nop
  801b1e:	c9                   	leave  
  801b1f:	c3                   	ret    

00801b20 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801b20:	55                   	push   %ebp
  801b21:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801b23:	8b 45 08             	mov    0x8(%ebp),%eax
  801b26:	6a 00                	push   $0x0
  801b28:	6a 00                	push   $0x0
  801b2a:	6a 00                	push   $0x0
  801b2c:	ff 75 0c             	pushl  0xc(%ebp)
  801b2f:	50                   	push   %eax
  801b30:	6a 17                	push   $0x17
  801b32:	e8 9c fd ff ff       	call   8018d3 <syscall>
  801b37:	83 c4 18             	add    $0x18,%esp
}
  801b3a:	c9                   	leave  
  801b3b:	c3                   	ret    

00801b3c <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801b3c:	55                   	push   %ebp
  801b3d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b3f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b42:	8b 45 08             	mov    0x8(%ebp),%eax
  801b45:	6a 00                	push   $0x0
  801b47:	6a 00                	push   $0x0
  801b49:	6a 00                	push   $0x0
  801b4b:	52                   	push   %edx
  801b4c:	50                   	push   %eax
  801b4d:	6a 1a                	push   $0x1a
  801b4f:	e8 7f fd ff ff       	call   8018d3 <syscall>
  801b54:	83 c4 18             	add    $0x18,%esp
}
  801b57:	c9                   	leave  
  801b58:	c3                   	ret    

00801b59 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b59:	55                   	push   %ebp
  801b5a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b5c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b62:	6a 00                	push   $0x0
  801b64:	6a 00                	push   $0x0
  801b66:	6a 00                	push   $0x0
  801b68:	52                   	push   %edx
  801b69:	50                   	push   %eax
  801b6a:	6a 18                	push   $0x18
  801b6c:	e8 62 fd ff ff       	call   8018d3 <syscall>
  801b71:	83 c4 18             	add    $0x18,%esp
}
  801b74:	90                   	nop
  801b75:	c9                   	leave  
  801b76:	c3                   	ret    

00801b77 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b77:	55                   	push   %ebp
  801b78:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b7a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b7d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b80:	6a 00                	push   $0x0
  801b82:	6a 00                	push   $0x0
  801b84:	6a 00                	push   $0x0
  801b86:	52                   	push   %edx
  801b87:	50                   	push   %eax
  801b88:	6a 19                	push   $0x19
  801b8a:	e8 44 fd ff ff       	call   8018d3 <syscall>
  801b8f:	83 c4 18             	add    $0x18,%esp
}
  801b92:	90                   	nop
  801b93:	c9                   	leave  
  801b94:	c3                   	ret    

00801b95 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801b95:	55                   	push   %ebp
  801b96:	89 e5                	mov    %esp,%ebp
  801b98:	83 ec 04             	sub    $0x4,%esp
  801b9b:	8b 45 10             	mov    0x10(%ebp),%eax
  801b9e:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801ba1:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801ba4:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ba8:	8b 45 08             	mov    0x8(%ebp),%eax
  801bab:	6a 00                	push   $0x0
  801bad:	51                   	push   %ecx
  801bae:	52                   	push   %edx
  801baf:	ff 75 0c             	pushl  0xc(%ebp)
  801bb2:	50                   	push   %eax
  801bb3:	6a 1b                	push   $0x1b
  801bb5:	e8 19 fd ff ff       	call   8018d3 <syscall>
  801bba:	83 c4 18             	add    $0x18,%esp
}
  801bbd:	c9                   	leave  
  801bbe:	c3                   	ret    

00801bbf <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801bbf:	55                   	push   %ebp
  801bc0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801bc2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bc5:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc8:	6a 00                	push   $0x0
  801bca:	6a 00                	push   $0x0
  801bcc:	6a 00                	push   $0x0
  801bce:	52                   	push   %edx
  801bcf:	50                   	push   %eax
  801bd0:	6a 1c                	push   $0x1c
  801bd2:	e8 fc fc ff ff       	call   8018d3 <syscall>
  801bd7:	83 c4 18             	add    $0x18,%esp
}
  801bda:	c9                   	leave  
  801bdb:	c3                   	ret    

00801bdc <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801bdc:	55                   	push   %ebp
  801bdd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801bdf:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801be2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801be5:	8b 45 08             	mov    0x8(%ebp),%eax
  801be8:	6a 00                	push   $0x0
  801bea:	6a 00                	push   $0x0
  801bec:	51                   	push   %ecx
  801bed:	52                   	push   %edx
  801bee:	50                   	push   %eax
  801bef:	6a 1d                	push   $0x1d
  801bf1:	e8 dd fc ff ff       	call   8018d3 <syscall>
  801bf6:	83 c4 18             	add    $0x18,%esp
}
  801bf9:	c9                   	leave  
  801bfa:	c3                   	ret    

00801bfb <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801bfb:	55                   	push   %ebp
  801bfc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801bfe:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c01:	8b 45 08             	mov    0x8(%ebp),%eax
  801c04:	6a 00                	push   $0x0
  801c06:	6a 00                	push   $0x0
  801c08:	6a 00                	push   $0x0
  801c0a:	52                   	push   %edx
  801c0b:	50                   	push   %eax
  801c0c:	6a 1e                	push   $0x1e
  801c0e:	e8 c0 fc ff ff       	call   8018d3 <syscall>
  801c13:	83 c4 18             	add    $0x18,%esp
}
  801c16:	c9                   	leave  
  801c17:	c3                   	ret    

00801c18 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801c18:	55                   	push   %ebp
  801c19:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801c1b:	6a 00                	push   $0x0
  801c1d:	6a 00                	push   $0x0
  801c1f:	6a 00                	push   $0x0
  801c21:	6a 00                	push   $0x0
  801c23:	6a 00                	push   $0x0
  801c25:	6a 1f                	push   $0x1f
  801c27:	e8 a7 fc ff ff       	call   8018d3 <syscall>
  801c2c:	83 c4 18             	add    $0x18,%esp
}
  801c2f:	c9                   	leave  
  801c30:	c3                   	ret    

00801c31 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801c31:	55                   	push   %ebp
  801c32:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801c34:	8b 45 08             	mov    0x8(%ebp),%eax
  801c37:	6a 00                	push   $0x0
  801c39:	ff 75 14             	pushl  0x14(%ebp)
  801c3c:	ff 75 10             	pushl  0x10(%ebp)
  801c3f:	ff 75 0c             	pushl  0xc(%ebp)
  801c42:	50                   	push   %eax
  801c43:	6a 20                	push   $0x20
  801c45:	e8 89 fc ff ff       	call   8018d3 <syscall>
  801c4a:	83 c4 18             	add    $0x18,%esp
}
  801c4d:	c9                   	leave  
  801c4e:	c3                   	ret    

00801c4f <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801c4f:	55                   	push   %ebp
  801c50:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801c52:	8b 45 08             	mov    0x8(%ebp),%eax
  801c55:	6a 00                	push   $0x0
  801c57:	6a 00                	push   $0x0
  801c59:	6a 00                	push   $0x0
  801c5b:	6a 00                	push   $0x0
  801c5d:	50                   	push   %eax
  801c5e:	6a 21                	push   $0x21
  801c60:	e8 6e fc ff ff       	call   8018d3 <syscall>
  801c65:	83 c4 18             	add    $0x18,%esp
}
  801c68:	90                   	nop
  801c69:	c9                   	leave  
  801c6a:	c3                   	ret    

00801c6b <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801c6b:	55                   	push   %ebp
  801c6c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801c6e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c71:	6a 00                	push   $0x0
  801c73:	6a 00                	push   $0x0
  801c75:	6a 00                	push   $0x0
  801c77:	6a 00                	push   $0x0
  801c79:	50                   	push   %eax
  801c7a:	6a 22                	push   $0x22
  801c7c:	e8 52 fc ff ff       	call   8018d3 <syscall>
  801c81:	83 c4 18             	add    $0x18,%esp
}
  801c84:	c9                   	leave  
  801c85:	c3                   	ret    

00801c86 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801c86:	55                   	push   %ebp
  801c87:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801c89:	6a 00                	push   $0x0
  801c8b:	6a 00                	push   $0x0
  801c8d:	6a 00                	push   $0x0
  801c8f:	6a 00                	push   $0x0
  801c91:	6a 00                	push   $0x0
  801c93:	6a 02                	push   $0x2
  801c95:	e8 39 fc ff ff       	call   8018d3 <syscall>
  801c9a:	83 c4 18             	add    $0x18,%esp
}
  801c9d:	c9                   	leave  
  801c9e:	c3                   	ret    

00801c9f <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c9f:	55                   	push   %ebp
  801ca0:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801ca2:	6a 00                	push   $0x0
  801ca4:	6a 00                	push   $0x0
  801ca6:	6a 00                	push   $0x0
  801ca8:	6a 00                	push   $0x0
  801caa:	6a 00                	push   $0x0
  801cac:	6a 03                	push   $0x3
  801cae:	e8 20 fc ff ff       	call   8018d3 <syscall>
  801cb3:	83 c4 18             	add    $0x18,%esp
}
  801cb6:	c9                   	leave  
  801cb7:	c3                   	ret    

00801cb8 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801cb8:	55                   	push   %ebp
  801cb9:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801cbb:	6a 00                	push   $0x0
  801cbd:	6a 00                	push   $0x0
  801cbf:	6a 00                	push   $0x0
  801cc1:	6a 00                	push   $0x0
  801cc3:	6a 00                	push   $0x0
  801cc5:	6a 04                	push   $0x4
  801cc7:	e8 07 fc ff ff       	call   8018d3 <syscall>
  801ccc:	83 c4 18             	add    $0x18,%esp
}
  801ccf:	c9                   	leave  
  801cd0:	c3                   	ret    

00801cd1 <sys_exit_env>:


void sys_exit_env(void)
{
  801cd1:	55                   	push   %ebp
  801cd2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801cd4:	6a 00                	push   $0x0
  801cd6:	6a 00                	push   $0x0
  801cd8:	6a 00                	push   $0x0
  801cda:	6a 00                	push   $0x0
  801cdc:	6a 00                	push   $0x0
  801cde:	6a 23                	push   $0x23
  801ce0:	e8 ee fb ff ff       	call   8018d3 <syscall>
  801ce5:	83 c4 18             	add    $0x18,%esp
}
  801ce8:	90                   	nop
  801ce9:	c9                   	leave  
  801cea:	c3                   	ret    

00801ceb <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801ceb:	55                   	push   %ebp
  801cec:	89 e5                	mov    %esp,%ebp
  801cee:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801cf1:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801cf4:	8d 50 04             	lea    0x4(%eax),%edx
  801cf7:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801cfa:	6a 00                	push   $0x0
  801cfc:	6a 00                	push   $0x0
  801cfe:	6a 00                	push   $0x0
  801d00:	52                   	push   %edx
  801d01:	50                   	push   %eax
  801d02:	6a 24                	push   $0x24
  801d04:	e8 ca fb ff ff       	call   8018d3 <syscall>
  801d09:	83 c4 18             	add    $0x18,%esp
	return result;
  801d0c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d0f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d12:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d15:	89 01                	mov    %eax,(%ecx)
  801d17:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1d:	c9                   	leave  
  801d1e:	c2 04 00             	ret    $0x4

00801d21 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801d21:	55                   	push   %ebp
  801d22:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801d24:	6a 00                	push   $0x0
  801d26:	6a 00                	push   $0x0
  801d28:	ff 75 10             	pushl  0x10(%ebp)
  801d2b:	ff 75 0c             	pushl  0xc(%ebp)
  801d2e:	ff 75 08             	pushl  0x8(%ebp)
  801d31:	6a 12                	push   $0x12
  801d33:	e8 9b fb ff ff       	call   8018d3 <syscall>
  801d38:	83 c4 18             	add    $0x18,%esp
	return ;
  801d3b:	90                   	nop
}
  801d3c:	c9                   	leave  
  801d3d:	c3                   	ret    

00801d3e <sys_rcr2>:
uint32 sys_rcr2()
{
  801d3e:	55                   	push   %ebp
  801d3f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801d41:	6a 00                	push   $0x0
  801d43:	6a 00                	push   $0x0
  801d45:	6a 00                	push   $0x0
  801d47:	6a 00                	push   $0x0
  801d49:	6a 00                	push   $0x0
  801d4b:	6a 25                	push   $0x25
  801d4d:	e8 81 fb ff ff       	call   8018d3 <syscall>
  801d52:	83 c4 18             	add    $0x18,%esp
}
  801d55:	c9                   	leave  
  801d56:	c3                   	ret    

00801d57 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801d57:	55                   	push   %ebp
  801d58:	89 e5                	mov    %esp,%ebp
  801d5a:	83 ec 04             	sub    $0x4,%esp
  801d5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d60:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801d63:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801d67:	6a 00                	push   $0x0
  801d69:	6a 00                	push   $0x0
  801d6b:	6a 00                	push   $0x0
  801d6d:	6a 00                	push   $0x0
  801d6f:	50                   	push   %eax
  801d70:	6a 26                	push   $0x26
  801d72:	e8 5c fb ff ff       	call   8018d3 <syscall>
  801d77:	83 c4 18             	add    $0x18,%esp
	return ;
  801d7a:	90                   	nop
}
  801d7b:	c9                   	leave  
  801d7c:	c3                   	ret    

00801d7d <rsttst>:
void rsttst()
{
  801d7d:	55                   	push   %ebp
  801d7e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801d80:	6a 00                	push   $0x0
  801d82:	6a 00                	push   $0x0
  801d84:	6a 00                	push   $0x0
  801d86:	6a 00                	push   $0x0
  801d88:	6a 00                	push   $0x0
  801d8a:	6a 28                	push   $0x28
  801d8c:	e8 42 fb ff ff       	call   8018d3 <syscall>
  801d91:	83 c4 18             	add    $0x18,%esp
	return ;
  801d94:	90                   	nop
}
  801d95:	c9                   	leave  
  801d96:	c3                   	ret    

00801d97 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d97:	55                   	push   %ebp
  801d98:	89 e5                	mov    %esp,%ebp
  801d9a:	83 ec 04             	sub    $0x4,%esp
  801d9d:	8b 45 14             	mov    0x14(%ebp),%eax
  801da0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801da3:	8b 55 18             	mov    0x18(%ebp),%edx
  801da6:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801daa:	52                   	push   %edx
  801dab:	50                   	push   %eax
  801dac:	ff 75 10             	pushl  0x10(%ebp)
  801daf:	ff 75 0c             	pushl  0xc(%ebp)
  801db2:	ff 75 08             	pushl  0x8(%ebp)
  801db5:	6a 27                	push   $0x27
  801db7:	e8 17 fb ff ff       	call   8018d3 <syscall>
  801dbc:	83 c4 18             	add    $0x18,%esp
	return ;
  801dbf:	90                   	nop
}
  801dc0:	c9                   	leave  
  801dc1:	c3                   	ret    

00801dc2 <chktst>:
void chktst(uint32 n)
{
  801dc2:	55                   	push   %ebp
  801dc3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801dc5:	6a 00                	push   $0x0
  801dc7:	6a 00                	push   $0x0
  801dc9:	6a 00                	push   $0x0
  801dcb:	6a 00                	push   $0x0
  801dcd:	ff 75 08             	pushl  0x8(%ebp)
  801dd0:	6a 29                	push   $0x29
  801dd2:	e8 fc fa ff ff       	call   8018d3 <syscall>
  801dd7:	83 c4 18             	add    $0x18,%esp
	return ;
  801dda:	90                   	nop
}
  801ddb:	c9                   	leave  
  801ddc:	c3                   	ret    

00801ddd <inctst>:

void inctst()
{
  801ddd:	55                   	push   %ebp
  801dde:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801de0:	6a 00                	push   $0x0
  801de2:	6a 00                	push   $0x0
  801de4:	6a 00                	push   $0x0
  801de6:	6a 00                	push   $0x0
  801de8:	6a 00                	push   $0x0
  801dea:	6a 2a                	push   $0x2a
  801dec:	e8 e2 fa ff ff       	call   8018d3 <syscall>
  801df1:	83 c4 18             	add    $0x18,%esp
	return ;
  801df4:	90                   	nop
}
  801df5:	c9                   	leave  
  801df6:	c3                   	ret    

00801df7 <gettst>:
uint32 gettst()
{
  801df7:	55                   	push   %ebp
  801df8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801dfa:	6a 00                	push   $0x0
  801dfc:	6a 00                	push   $0x0
  801dfe:	6a 00                	push   $0x0
  801e00:	6a 00                	push   $0x0
  801e02:	6a 00                	push   $0x0
  801e04:	6a 2b                	push   $0x2b
  801e06:	e8 c8 fa ff ff       	call   8018d3 <syscall>
  801e0b:	83 c4 18             	add    $0x18,%esp
}
  801e0e:	c9                   	leave  
  801e0f:	c3                   	ret    

00801e10 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801e10:	55                   	push   %ebp
  801e11:	89 e5                	mov    %esp,%ebp
  801e13:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e16:	6a 00                	push   $0x0
  801e18:	6a 00                	push   $0x0
  801e1a:	6a 00                	push   $0x0
  801e1c:	6a 00                	push   $0x0
  801e1e:	6a 00                	push   $0x0
  801e20:	6a 2c                	push   $0x2c
  801e22:	e8 ac fa ff ff       	call   8018d3 <syscall>
  801e27:	83 c4 18             	add    $0x18,%esp
  801e2a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801e2d:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801e31:	75 07                	jne    801e3a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801e33:	b8 01 00 00 00       	mov    $0x1,%eax
  801e38:	eb 05                	jmp    801e3f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801e3a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e3f:	c9                   	leave  
  801e40:	c3                   	ret    

00801e41 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801e41:	55                   	push   %ebp
  801e42:	89 e5                	mov    %esp,%ebp
  801e44:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e47:	6a 00                	push   $0x0
  801e49:	6a 00                	push   $0x0
  801e4b:	6a 00                	push   $0x0
  801e4d:	6a 00                	push   $0x0
  801e4f:	6a 00                	push   $0x0
  801e51:	6a 2c                	push   $0x2c
  801e53:	e8 7b fa ff ff       	call   8018d3 <syscall>
  801e58:	83 c4 18             	add    $0x18,%esp
  801e5b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801e5e:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801e62:	75 07                	jne    801e6b <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801e64:	b8 01 00 00 00       	mov    $0x1,%eax
  801e69:	eb 05                	jmp    801e70 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801e6b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e70:	c9                   	leave  
  801e71:	c3                   	ret    

00801e72 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801e72:	55                   	push   %ebp
  801e73:	89 e5                	mov    %esp,%ebp
  801e75:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e78:	6a 00                	push   $0x0
  801e7a:	6a 00                	push   $0x0
  801e7c:	6a 00                	push   $0x0
  801e7e:	6a 00                	push   $0x0
  801e80:	6a 00                	push   $0x0
  801e82:	6a 2c                	push   $0x2c
  801e84:	e8 4a fa ff ff       	call   8018d3 <syscall>
  801e89:	83 c4 18             	add    $0x18,%esp
  801e8c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801e8f:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801e93:	75 07                	jne    801e9c <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801e95:	b8 01 00 00 00       	mov    $0x1,%eax
  801e9a:	eb 05                	jmp    801ea1 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801e9c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ea1:	c9                   	leave  
  801ea2:	c3                   	ret    

00801ea3 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801ea3:	55                   	push   %ebp
  801ea4:	89 e5                	mov    %esp,%ebp
  801ea6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ea9:	6a 00                	push   $0x0
  801eab:	6a 00                	push   $0x0
  801ead:	6a 00                	push   $0x0
  801eaf:	6a 00                	push   $0x0
  801eb1:	6a 00                	push   $0x0
  801eb3:	6a 2c                	push   $0x2c
  801eb5:	e8 19 fa ff ff       	call   8018d3 <syscall>
  801eba:	83 c4 18             	add    $0x18,%esp
  801ebd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801ec0:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801ec4:	75 07                	jne    801ecd <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801ec6:	b8 01 00 00 00       	mov    $0x1,%eax
  801ecb:	eb 05                	jmp    801ed2 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801ecd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ed2:	c9                   	leave  
  801ed3:	c3                   	ret    

00801ed4 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801ed4:	55                   	push   %ebp
  801ed5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801ed7:	6a 00                	push   $0x0
  801ed9:	6a 00                	push   $0x0
  801edb:	6a 00                	push   $0x0
  801edd:	6a 00                	push   $0x0
  801edf:	ff 75 08             	pushl  0x8(%ebp)
  801ee2:	6a 2d                	push   $0x2d
  801ee4:	e8 ea f9 ff ff       	call   8018d3 <syscall>
  801ee9:	83 c4 18             	add    $0x18,%esp
	return ;
  801eec:	90                   	nop
}
  801eed:	c9                   	leave  
  801eee:	c3                   	ret    

00801eef <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801eef:	55                   	push   %ebp
  801ef0:	89 e5                	mov    %esp,%ebp
  801ef2:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801ef3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ef6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ef9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801efc:	8b 45 08             	mov    0x8(%ebp),%eax
  801eff:	6a 00                	push   $0x0
  801f01:	53                   	push   %ebx
  801f02:	51                   	push   %ecx
  801f03:	52                   	push   %edx
  801f04:	50                   	push   %eax
  801f05:	6a 2e                	push   $0x2e
  801f07:	e8 c7 f9 ff ff       	call   8018d3 <syscall>
  801f0c:	83 c4 18             	add    $0x18,%esp
}
  801f0f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f12:	c9                   	leave  
  801f13:	c3                   	ret    

00801f14 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801f14:	55                   	push   %ebp
  801f15:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801f17:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1d:	6a 00                	push   $0x0
  801f1f:	6a 00                	push   $0x0
  801f21:	6a 00                	push   $0x0
  801f23:	52                   	push   %edx
  801f24:	50                   	push   %eax
  801f25:	6a 2f                	push   $0x2f
  801f27:	e8 a7 f9 ff ff       	call   8018d3 <syscall>
  801f2c:	83 c4 18             	add    $0x18,%esp
}
  801f2f:	c9                   	leave  
  801f30:	c3                   	ret    

00801f31 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801f31:	55                   	push   %ebp
  801f32:	89 e5                	mov    %esp,%ebp
  801f34:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801f37:	83 ec 0c             	sub    $0xc,%esp
  801f3a:	68 a4 41 80 00       	push   $0x8041a4
  801f3f:	e8 46 e8 ff ff       	call   80078a <cprintf>
  801f44:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801f47:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801f4e:	83 ec 0c             	sub    $0xc,%esp
  801f51:	68 d0 41 80 00       	push   $0x8041d0
  801f56:	e8 2f e8 ff ff       	call   80078a <cprintf>
  801f5b:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801f5e:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f62:	a1 38 51 80 00       	mov    0x805138,%eax
  801f67:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f6a:	eb 56                	jmp    801fc2 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f6c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f70:	74 1c                	je     801f8e <print_mem_block_lists+0x5d>
  801f72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f75:	8b 50 08             	mov    0x8(%eax),%edx
  801f78:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f7b:	8b 48 08             	mov    0x8(%eax),%ecx
  801f7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f81:	8b 40 0c             	mov    0xc(%eax),%eax
  801f84:	01 c8                	add    %ecx,%eax
  801f86:	39 c2                	cmp    %eax,%edx
  801f88:	73 04                	jae    801f8e <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801f8a:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f91:	8b 50 08             	mov    0x8(%eax),%edx
  801f94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f97:	8b 40 0c             	mov    0xc(%eax),%eax
  801f9a:	01 c2                	add    %eax,%edx
  801f9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f9f:	8b 40 08             	mov    0x8(%eax),%eax
  801fa2:	83 ec 04             	sub    $0x4,%esp
  801fa5:	52                   	push   %edx
  801fa6:	50                   	push   %eax
  801fa7:	68 e5 41 80 00       	push   $0x8041e5
  801fac:	e8 d9 e7 ff ff       	call   80078a <cprintf>
  801fb1:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801fb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801fba:	a1 40 51 80 00       	mov    0x805140,%eax
  801fbf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fc2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fc6:	74 07                	je     801fcf <print_mem_block_lists+0x9e>
  801fc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fcb:	8b 00                	mov    (%eax),%eax
  801fcd:	eb 05                	jmp    801fd4 <print_mem_block_lists+0xa3>
  801fcf:	b8 00 00 00 00       	mov    $0x0,%eax
  801fd4:	a3 40 51 80 00       	mov    %eax,0x805140
  801fd9:	a1 40 51 80 00       	mov    0x805140,%eax
  801fde:	85 c0                	test   %eax,%eax
  801fe0:	75 8a                	jne    801f6c <print_mem_block_lists+0x3b>
  801fe2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fe6:	75 84                	jne    801f6c <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801fe8:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801fec:	75 10                	jne    801ffe <print_mem_block_lists+0xcd>
  801fee:	83 ec 0c             	sub    $0xc,%esp
  801ff1:	68 f4 41 80 00       	push   $0x8041f4
  801ff6:	e8 8f e7 ff ff       	call   80078a <cprintf>
  801ffb:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801ffe:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802005:	83 ec 0c             	sub    $0xc,%esp
  802008:	68 18 42 80 00       	push   $0x804218
  80200d:	e8 78 e7 ff ff       	call   80078a <cprintf>
  802012:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802015:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802019:	a1 40 50 80 00       	mov    0x805040,%eax
  80201e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802021:	eb 56                	jmp    802079 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802023:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802027:	74 1c                	je     802045 <print_mem_block_lists+0x114>
  802029:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80202c:	8b 50 08             	mov    0x8(%eax),%edx
  80202f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802032:	8b 48 08             	mov    0x8(%eax),%ecx
  802035:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802038:	8b 40 0c             	mov    0xc(%eax),%eax
  80203b:	01 c8                	add    %ecx,%eax
  80203d:	39 c2                	cmp    %eax,%edx
  80203f:	73 04                	jae    802045 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802041:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802045:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802048:	8b 50 08             	mov    0x8(%eax),%edx
  80204b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80204e:	8b 40 0c             	mov    0xc(%eax),%eax
  802051:	01 c2                	add    %eax,%edx
  802053:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802056:	8b 40 08             	mov    0x8(%eax),%eax
  802059:	83 ec 04             	sub    $0x4,%esp
  80205c:	52                   	push   %edx
  80205d:	50                   	push   %eax
  80205e:	68 e5 41 80 00       	push   $0x8041e5
  802063:	e8 22 e7 ff ff       	call   80078a <cprintf>
  802068:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80206b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80206e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802071:	a1 48 50 80 00       	mov    0x805048,%eax
  802076:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802079:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80207d:	74 07                	je     802086 <print_mem_block_lists+0x155>
  80207f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802082:	8b 00                	mov    (%eax),%eax
  802084:	eb 05                	jmp    80208b <print_mem_block_lists+0x15a>
  802086:	b8 00 00 00 00       	mov    $0x0,%eax
  80208b:	a3 48 50 80 00       	mov    %eax,0x805048
  802090:	a1 48 50 80 00       	mov    0x805048,%eax
  802095:	85 c0                	test   %eax,%eax
  802097:	75 8a                	jne    802023 <print_mem_block_lists+0xf2>
  802099:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80209d:	75 84                	jne    802023 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  80209f:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8020a3:	75 10                	jne    8020b5 <print_mem_block_lists+0x184>
  8020a5:	83 ec 0c             	sub    $0xc,%esp
  8020a8:	68 30 42 80 00       	push   $0x804230
  8020ad:	e8 d8 e6 ff ff       	call   80078a <cprintf>
  8020b2:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8020b5:	83 ec 0c             	sub    $0xc,%esp
  8020b8:	68 a4 41 80 00       	push   $0x8041a4
  8020bd:	e8 c8 e6 ff ff       	call   80078a <cprintf>
  8020c2:	83 c4 10             	add    $0x10,%esp

}
  8020c5:	90                   	nop
  8020c6:	c9                   	leave  
  8020c7:	c3                   	ret    

008020c8 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8020c8:	55                   	push   %ebp
  8020c9:	89 e5                	mov    %esp,%ebp
  8020cb:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  8020ce:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  8020d5:	00 00 00 
  8020d8:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  8020df:	00 00 00 
  8020e2:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  8020e9:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  8020ec:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8020f3:	e9 9e 00 00 00       	jmp    802196 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  8020f8:	a1 50 50 80 00       	mov    0x805050,%eax
  8020fd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802100:	c1 e2 04             	shl    $0x4,%edx
  802103:	01 d0                	add    %edx,%eax
  802105:	85 c0                	test   %eax,%eax
  802107:	75 14                	jne    80211d <initialize_MemBlocksList+0x55>
  802109:	83 ec 04             	sub    $0x4,%esp
  80210c:	68 58 42 80 00       	push   $0x804258
  802111:	6a 46                	push   $0x46
  802113:	68 7b 42 80 00       	push   $0x80427b
  802118:	e8 b9 e3 ff ff       	call   8004d6 <_panic>
  80211d:	a1 50 50 80 00       	mov    0x805050,%eax
  802122:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802125:	c1 e2 04             	shl    $0x4,%edx
  802128:	01 d0                	add    %edx,%eax
  80212a:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802130:	89 10                	mov    %edx,(%eax)
  802132:	8b 00                	mov    (%eax),%eax
  802134:	85 c0                	test   %eax,%eax
  802136:	74 18                	je     802150 <initialize_MemBlocksList+0x88>
  802138:	a1 48 51 80 00       	mov    0x805148,%eax
  80213d:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802143:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802146:	c1 e1 04             	shl    $0x4,%ecx
  802149:	01 ca                	add    %ecx,%edx
  80214b:	89 50 04             	mov    %edx,0x4(%eax)
  80214e:	eb 12                	jmp    802162 <initialize_MemBlocksList+0x9a>
  802150:	a1 50 50 80 00       	mov    0x805050,%eax
  802155:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802158:	c1 e2 04             	shl    $0x4,%edx
  80215b:	01 d0                	add    %edx,%eax
  80215d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802162:	a1 50 50 80 00       	mov    0x805050,%eax
  802167:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80216a:	c1 e2 04             	shl    $0x4,%edx
  80216d:	01 d0                	add    %edx,%eax
  80216f:	a3 48 51 80 00       	mov    %eax,0x805148
  802174:	a1 50 50 80 00       	mov    0x805050,%eax
  802179:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80217c:	c1 e2 04             	shl    $0x4,%edx
  80217f:	01 d0                	add    %edx,%eax
  802181:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802188:	a1 54 51 80 00       	mov    0x805154,%eax
  80218d:	40                   	inc    %eax
  80218e:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  802193:	ff 45 f4             	incl   -0xc(%ebp)
  802196:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802199:	3b 45 08             	cmp    0x8(%ebp),%eax
  80219c:	0f 82 56 ff ff ff    	jb     8020f8 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  8021a2:	90                   	nop
  8021a3:	c9                   	leave  
  8021a4:	c3                   	ret    

008021a5 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8021a5:	55                   	push   %ebp
  8021a6:	89 e5                	mov    %esp,%ebp
  8021a8:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8021ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ae:	8b 00                	mov    (%eax),%eax
  8021b0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8021b3:	eb 19                	jmp    8021ce <find_block+0x29>
	{
		if(va==point->sva)
  8021b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021b8:	8b 40 08             	mov    0x8(%eax),%eax
  8021bb:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8021be:	75 05                	jne    8021c5 <find_block+0x20>
		   return point;
  8021c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021c3:	eb 36                	jmp    8021fb <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8021c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c8:	8b 40 08             	mov    0x8(%eax),%eax
  8021cb:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8021ce:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8021d2:	74 07                	je     8021db <find_block+0x36>
  8021d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021d7:	8b 00                	mov    (%eax),%eax
  8021d9:	eb 05                	jmp    8021e0 <find_block+0x3b>
  8021db:	b8 00 00 00 00       	mov    $0x0,%eax
  8021e0:	8b 55 08             	mov    0x8(%ebp),%edx
  8021e3:	89 42 08             	mov    %eax,0x8(%edx)
  8021e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e9:	8b 40 08             	mov    0x8(%eax),%eax
  8021ec:	85 c0                	test   %eax,%eax
  8021ee:	75 c5                	jne    8021b5 <find_block+0x10>
  8021f0:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8021f4:	75 bf                	jne    8021b5 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  8021f6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021fb:	c9                   	leave  
  8021fc:	c3                   	ret    

008021fd <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8021fd:	55                   	push   %ebp
  8021fe:	89 e5                	mov    %esp,%ebp
  802200:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  802203:	a1 40 50 80 00       	mov    0x805040,%eax
  802208:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  80220b:	a1 44 50 80 00       	mov    0x805044,%eax
  802210:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  802213:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802216:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802219:	74 24                	je     80223f <insert_sorted_allocList+0x42>
  80221b:	8b 45 08             	mov    0x8(%ebp),%eax
  80221e:	8b 50 08             	mov    0x8(%eax),%edx
  802221:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802224:	8b 40 08             	mov    0x8(%eax),%eax
  802227:	39 c2                	cmp    %eax,%edx
  802229:	76 14                	jbe    80223f <insert_sorted_allocList+0x42>
  80222b:	8b 45 08             	mov    0x8(%ebp),%eax
  80222e:	8b 50 08             	mov    0x8(%eax),%edx
  802231:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802234:	8b 40 08             	mov    0x8(%eax),%eax
  802237:	39 c2                	cmp    %eax,%edx
  802239:	0f 82 60 01 00 00    	jb     80239f <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  80223f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802243:	75 65                	jne    8022aa <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802245:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802249:	75 14                	jne    80225f <insert_sorted_allocList+0x62>
  80224b:	83 ec 04             	sub    $0x4,%esp
  80224e:	68 58 42 80 00       	push   $0x804258
  802253:	6a 6b                	push   $0x6b
  802255:	68 7b 42 80 00       	push   $0x80427b
  80225a:	e8 77 e2 ff ff       	call   8004d6 <_panic>
  80225f:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802265:	8b 45 08             	mov    0x8(%ebp),%eax
  802268:	89 10                	mov    %edx,(%eax)
  80226a:	8b 45 08             	mov    0x8(%ebp),%eax
  80226d:	8b 00                	mov    (%eax),%eax
  80226f:	85 c0                	test   %eax,%eax
  802271:	74 0d                	je     802280 <insert_sorted_allocList+0x83>
  802273:	a1 40 50 80 00       	mov    0x805040,%eax
  802278:	8b 55 08             	mov    0x8(%ebp),%edx
  80227b:	89 50 04             	mov    %edx,0x4(%eax)
  80227e:	eb 08                	jmp    802288 <insert_sorted_allocList+0x8b>
  802280:	8b 45 08             	mov    0x8(%ebp),%eax
  802283:	a3 44 50 80 00       	mov    %eax,0x805044
  802288:	8b 45 08             	mov    0x8(%ebp),%eax
  80228b:	a3 40 50 80 00       	mov    %eax,0x805040
  802290:	8b 45 08             	mov    0x8(%ebp),%eax
  802293:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80229a:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80229f:	40                   	inc    %eax
  8022a0:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8022a5:	e9 dc 01 00 00       	jmp    802486 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  8022aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ad:	8b 50 08             	mov    0x8(%eax),%edx
  8022b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022b3:	8b 40 08             	mov    0x8(%eax),%eax
  8022b6:	39 c2                	cmp    %eax,%edx
  8022b8:	77 6c                	ja     802326 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  8022ba:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8022be:	74 06                	je     8022c6 <insert_sorted_allocList+0xc9>
  8022c0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022c4:	75 14                	jne    8022da <insert_sorted_allocList+0xdd>
  8022c6:	83 ec 04             	sub    $0x4,%esp
  8022c9:	68 94 42 80 00       	push   $0x804294
  8022ce:	6a 6f                	push   $0x6f
  8022d0:	68 7b 42 80 00       	push   $0x80427b
  8022d5:	e8 fc e1 ff ff       	call   8004d6 <_panic>
  8022da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022dd:	8b 50 04             	mov    0x4(%eax),%edx
  8022e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e3:	89 50 04             	mov    %edx,0x4(%eax)
  8022e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022ec:	89 10                	mov    %edx,(%eax)
  8022ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022f1:	8b 40 04             	mov    0x4(%eax),%eax
  8022f4:	85 c0                	test   %eax,%eax
  8022f6:	74 0d                	je     802305 <insert_sorted_allocList+0x108>
  8022f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022fb:	8b 40 04             	mov    0x4(%eax),%eax
  8022fe:	8b 55 08             	mov    0x8(%ebp),%edx
  802301:	89 10                	mov    %edx,(%eax)
  802303:	eb 08                	jmp    80230d <insert_sorted_allocList+0x110>
  802305:	8b 45 08             	mov    0x8(%ebp),%eax
  802308:	a3 40 50 80 00       	mov    %eax,0x805040
  80230d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802310:	8b 55 08             	mov    0x8(%ebp),%edx
  802313:	89 50 04             	mov    %edx,0x4(%eax)
  802316:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80231b:	40                   	inc    %eax
  80231c:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802321:	e9 60 01 00 00       	jmp    802486 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802326:	8b 45 08             	mov    0x8(%ebp),%eax
  802329:	8b 50 08             	mov    0x8(%eax),%edx
  80232c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80232f:	8b 40 08             	mov    0x8(%eax),%eax
  802332:	39 c2                	cmp    %eax,%edx
  802334:	0f 82 4c 01 00 00    	jb     802486 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  80233a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80233e:	75 14                	jne    802354 <insert_sorted_allocList+0x157>
  802340:	83 ec 04             	sub    $0x4,%esp
  802343:	68 cc 42 80 00       	push   $0x8042cc
  802348:	6a 73                	push   $0x73
  80234a:	68 7b 42 80 00       	push   $0x80427b
  80234f:	e8 82 e1 ff ff       	call   8004d6 <_panic>
  802354:	8b 15 44 50 80 00    	mov    0x805044,%edx
  80235a:	8b 45 08             	mov    0x8(%ebp),%eax
  80235d:	89 50 04             	mov    %edx,0x4(%eax)
  802360:	8b 45 08             	mov    0x8(%ebp),%eax
  802363:	8b 40 04             	mov    0x4(%eax),%eax
  802366:	85 c0                	test   %eax,%eax
  802368:	74 0c                	je     802376 <insert_sorted_allocList+0x179>
  80236a:	a1 44 50 80 00       	mov    0x805044,%eax
  80236f:	8b 55 08             	mov    0x8(%ebp),%edx
  802372:	89 10                	mov    %edx,(%eax)
  802374:	eb 08                	jmp    80237e <insert_sorted_allocList+0x181>
  802376:	8b 45 08             	mov    0x8(%ebp),%eax
  802379:	a3 40 50 80 00       	mov    %eax,0x805040
  80237e:	8b 45 08             	mov    0x8(%ebp),%eax
  802381:	a3 44 50 80 00       	mov    %eax,0x805044
  802386:	8b 45 08             	mov    0x8(%ebp),%eax
  802389:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80238f:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802394:	40                   	inc    %eax
  802395:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80239a:	e9 e7 00 00 00       	jmp    802486 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  80239f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  8023a5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8023ac:	a1 40 50 80 00       	mov    0x805040,%eax
  8023b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023b4:	e9 9d 00 00 00       	jmp    802456 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  8023b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023bc:	8b 00                	mov    (%eax),%eax
  8023be:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  8023c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c4:	8b 50 08             	mov    0x8(%eax),%edx
  8023c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ca:	8b 40 08             	mov    0x8(%eax),%eax
  8023cd:	39 c2                	cmp    %eax,%edx
  8023cf:	76 7d                	jbe    80244e <insert_sorted_allocList+0x251>
  8023d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d4:	8b 50 08             	mov    0x8(%eax),%edx
  8023d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8023da:	8b 40 08             	mov    0x8(%eax),%eax
  8023dd:	39 c2                	cmp    %eax,%edx
  8023df:	73 6d                	jae    80244e <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  8023e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023e5:	74 06                	je     8023ed <insert_sorted_allocList+0x1f0>
  8023e7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023eb:	75 14                	jne    802401 <insert_sorted_allocList+0x204>
  8023ed:	83 ec 04             	sub    $0x4,%esp
  8023f0:	68 f0 42 80 00       	push   $0x8042f0
  8023f5:	6a 7f                	push   $0x7f
  8023f7:	68 7b 42 80 00       	push   $0x80427b
  8023fc:	e8 d5 e0 ff ff       	call   8004d6 <_panic>
  802401:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802404:	8b 10                	mov    (%eax),%edx
  802406:	8b 45 08             	mov    0x8(%ebp),%eax
  802409:	89 10                	mov    %edx,(%eax)
  80240b:	8b 45 08             	mov    0x8(%ebp),%eax
  80240e:	8b 00                	mov    (%eax),%eax
  802410:	85 c0                	test   %eax,%eax
  802412:	74 0b                	je     80241f <insert_sorted_allocList+0x222>
  802414:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802417:	8b 00                	mov    (%eax),%eax
  802419:	8b 55 08             	mov    0x8(%ebp),%edx
  80241c:	89 50 04             	mov    %edx,0x4(%eax)
  80241f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802422:	8b 55 08             	mov    0x8(%ebp),%edx
  802425:	89 10                	mov    %edx,(%eax)
  802427:	8b 45 08             	mov    0x8(%ebp),%eax
  80242a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80242d:	89 50 04             	mov    %edx,0x4(%eax)
  802430:	8b 45 08             	mov    0x8(%ebp),%eax
  802433:	8b 00                	mov    (%eax),%eax
  802435:	85 c0                	test   %eax,%eax
  802437:	75 08                	jne    802441 <insert_sorted_allocList+0x244>
  802439:	8b 45 08             	mov    0x8(%ebp),%eax
  80243c:	a3 44 50 80 00       	mov    %eax,0x805044
  802441:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802446:	40                   	inc    %eax
  802447:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  80244c:	eb 39                	jmp    802487 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80244e:	a1 48 50 80 00       	mov    0x805048,%eax
  802453:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802456:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80245a:	74 07                	je     802463 <insert_sorted_allocList+0x266>
  80245c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80245f:	8b 00                	mov    (%eax),%eax
  802461:	eb 05                	jmp    802468 <insert_sorted_allocList+0x26b>
  802463:	b8 00 00 00 00       	mov    $0x0,%eax
  802468:	a3 48 50 80 00       	mov    %eax,0x805048
  80246d:	a1 48 50 80 00       	mov    0x805048,%eax
  802472:	85 c0                	test   %eax,%eax
  802474:	0f 85 3f ff ff ff    	jne    8023b9 <insert_sorted_allocList+0x1bc>
  80247a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80247e:	0f 85 35 ff ff ff    	jne    8023b9 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802484:	eb 01                	jmp    802487 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802486:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802487:	90                   	nop
  802488:	c9                   	leave  
  802489:	c3                   	ret    

0080248a <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80248a:	55                   	push   %ebp
  80248b:	89 e5                	mov    %esp,%ebp
  80248d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802490:	a1 38 51 80 00       	mov    0x805138,%eax
  802495:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802498:	e9 85 01 00 00       	jmp    802622 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  80249d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a0:	8b 40 0c             	mov    0xc(%eax),%eax
  8024a3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024a6:	0f 82 6e 01 00 00    	jb     80261a <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  8024ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024af:	8b 40 0c             	mov    0xc(%eax),%eax
  8024b2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024b5:	0f 85 8a 00 00 00    	jne    802545 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  8024bb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024bf:	75 17                	jne    8024d8 <alloc_block_FF+0x4e>
  8024c1:	83 ec 04             	sub    $0x4,%esp
  8024c4:	68 24 43 80 00       	push   $0x804324
  8024c9:	68 93 00 00 00       	push   $0x93
  8024ce:	68 7b 42 80 00       	push   $0x80427b
  8024d3:	e8 fe df ff ff       	call   8004d6 <_panic>
  8024d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024db:	8b 00                	mov    (%eax),%eax
  8024dd:	85 c0                	test   %eax,%eax
  8024df:	74 10                	je     8024f1 <alloc_block_FF+0x67>
  8024e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e4:	8b 00                	mov    (%eax),%eax
  8024e6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024e9:	8b 52 04             	mov    0x4(%edx),%edx
  8024ec:	89 50 04             	mov    %edx,0x4(%eax)
  8024ef:	eb 0b                	jmp    8024fc <alloc_block_FF+0x72>
  8024f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f4:	8b 40 04             	mov    0x4(%eax),%eax
  8024f7:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8024fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ff:	8b 40 04             	mov    0x4(%eax),%eax
  802502:	85 c0                	test   %eax,%eax
  802504:	74 0f                	je     802515 <alloc_block_FF+0x8b>
  802506:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802509:	8b 40 04             	mov    0x4(%eax),%eax
  80250c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80250f:	8b 12                	mov    (%edx),%edx
  802511:	89 10                	mov    %edx,(%eax)
  802513:	eb 0a                	jmp    80251f <alloc_block_FF+0x95>
  802515:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802518:	8b 00                	mov    (%eax),%eax
  80251a:	a3 38 51 80 00       	mov    %eax,0x805138
  80251f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802522:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802528:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802532:	a1 44 51 80 00       	mov    0x805144,%eax
  802537:	48                   	dec    %eax
  802538:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  80253d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802540:	e9 10 01 00 00       	jmp    802655 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802545:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802548:	8b 40 0c             	mov    0xc(%eax),%eax
  80254b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80254e:	0f 86 c6 00 00 00    	jbe    80261a <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802554:	a1 48 51 80 00       	mov    0x805148,%eax
  802559:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  80255c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255f:	8b 50 08             	mov    0x8(%eax),%edx
  802562:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802565:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802568:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80256b:	8b 55 08             	mov    0x8(%ebp),%edx
  80256e:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802571:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802575:	75 17                	jne    80258e <alloc_block_FF+0x104>
  802577:	83 ec 04             	sub    $0x4,%esp
  80257a:	68 24 43 80 00       	push   $0x804324
  80257f:	68 9b 00 00 00       	push   $0x9b
  802584:	68 7b 42 80 00       	push   $0x80427b
  802589:	e8 48 df ff ff       	call   8004d6 <_panic>
  80258e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802591:	8b 00                	mov    (%eax),%eax
  802593:	85 c0                	test   %eax,%eax
  802595:	74 10                	je     8025a7 <alloc_block_FF+0x11d>
  802597:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80259a:	8b 00                	mov    (%eax),%eax
  80259c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80259f:	8b 52 04             	mov    0x4(%edx),%edx
  8025a2:	89 50 04             	mov    %edx,0x4(%eax)
  8025a5:	eb 0b                	jmp    8025b2 <alloc_block_FF+0x128>
  8025a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025aa:	8b 40 04             	mov    0x4(%eax),%eax
  8025ad:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8025b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025b5:	8b 40 04             	mov    0x4(%eax),%eax
  8025b8:	85 c0                	test   %eax,%eax
  8025ba:	74 0f                	je     8025cb <alloc_block_FF+0x141>
  8025bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025bf:	8b 40 04             	mov    0x4(%eax),%eax
  8025c2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025c5:	8b 12                	mov    (%edx),%edx
  8025c7:	89 10                	mov    %edx,(%eax)
  8025c9:	eb 0a                	jmp    8025d5 <alloc_block_FF+0x14b>
  8025cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025ce:	8b 00                	mov    (%eax),%eax
  8025d0:	a3 48 51 80 00       	mov    %eax,0x805148
  8025d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025d8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025e1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025e8:	a1 54 51 80 00       	mov    0x805154,%eax
  8025ed:	48                   	dec    %eax
  8025ee:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  8025f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f6:	8b 50 08             	mov    0x8(%eax),%edx
  8025f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8025fc:	01 c2                	add    %eax,%edx
  8025fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802601:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802604:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802607:	8b 40 0c             	mov    0xc(%eax),%eax
  80260a:	2b 45 08             	sub    0x8(%ebp),%eax
  80260d:	89 c2                	mov    %eax,%edx
  80260f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802612:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802615:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802618:	eb 3b                	jmp    802655 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  80261a:	a1 40 51 80 00       	mov    0x805140,%eax
  80261f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802622:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802626:	74 07                	je     80262f <alloc_block_FF+0x1a5>
  802628:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262b:	8b 00                	mov    (%eax),%eax
  80262d:	eb 05                	jmp    802634 <alloc_block_FF+0x1aa>
  80262f:	b8 00 00 00 00       	mov    $0x0,%eax
  802634:	a3 40 51 80 00       	mov    %eax,0x805140
  802639:	a1 40 51 80 00       	mov    0x805140,%eax
  80263e:	85 c0                	test   %eax,%eax
  802640:	0f 85 57 fe ff ff    	jne    80249d <alloc_block_FF+0x13>
  802646:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80264a:	0f 85 4d fe ff ff    	jne    80249d <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802650:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802655:	c9                   	leave  
  802656:	c3                   	ret    

00802657 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802657:	55                   	push   %ebp
  802658:	89 e5                	mov    %esp,%ebp
  80265a:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  80265d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802664:	a1 38 51 80 00       	mov    0x805138,%eax
  802669:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80266c:	e9 df 00 00 00       	jmp    802750 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802671:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802674:	8b 40 0c             	mov    0xc(%eax),%eax
  802677:	3b 45 08             	cmp    0x8(%ebp),%eax
  80267a:	0f 82 c8 00 00 00    	jb     802748 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802680:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802683:	8b 40 0c             	mov    0xc(%eax),%eax
  802686:	3b 45 08             	cmp    0x8(%ebp),%eax
  802689:	0f 85 8a 00 00 00    	jne    802719 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  80268f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802693:	75 17                	jne    8026ac <alloc_block_BF+0x55>
  802695:	83 ec 04             	sub    $0x4,%esp
  802698:	68 24 43 80 00       	push   $0x804324
  80269d:	68 b7 00 00 00       	push   $0xb7
  8026a2:	68 7b 42 80 00       	push   $0x80427b
  8026a7:	e8 2a de ff ff       	call   8004d6 <_panic>
  8026ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026af:	8b 00                	mov    (%eax),%eax
  8026b1:	85 c0                	test   %eax,%eax
  8026b3:	74 10                	je     8026c5 <alloc_block_BF+0x6e>
  8026b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b8:	8b 00                	mov    (%eax),%eax
  8026ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026bd:	8b 52 04             	mov    0x4(%edx),%edx
  8026c0:	89 50 04             	mov    %edx,0x4(%eax)
  8026c3:	eb 0b                	jmp    8026d0 <alloc_block_BF+0x79>
  8026c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c8:	8b 40 04             	mov    0x4(%eax),%eax
  8026cb:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8026d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d3:	8b 40 04             	mov    0x4(%eax),%eax
  8026d6:	85 c0                	test   %eax,%eax
  8026d8:	74 0f                	je     8026e9 <alloc_block_BF+0x92>
  8026da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026dd:	8b 40 04             	mov    0x4(%eax),%eax
  8026e0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026e3:	8b 12                	mov    (%edx),%edx
  8026e5:	89 10                	mov    %edx,(%eax)
  8026e7:	eb 0a                	jmp    8026f3 <alloc_block_BF+0x9c>
  8026e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ec:	8b 00                	mov    (%eax),%eax
  8026ee:	a3 38 51 80 00       	mov    %eax,0x805138
  8026f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ff:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802706:	a1 44 51 80 00       	mov    0x805144,%eax
  80270b:	48                   	dec    %eax
  80270c:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802711:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802714:	e9 4d 01 00 00       	jmp    802866 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802719:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271c:	8b 40 0c             	mov    0xc(%eax),%eax
  80271f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802722:	76 24                	jbe    802748 <alloc_block_BF+0xf1>
  802724:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802727:	8b 40 0c             	mov    0xc(%eax),%eax
  80272a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80272d:	73 19                	jae    802748 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  80272f:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802736:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802739:	8b 40 0c             	mov    0xc(%eax),%eax
  80273c:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  80273f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802742:	8b 40 08             	mov    0x8(%eax),%eax
  802745:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802748:	a1 40 51 80 00       	mov    0x805140,%eax
  80274d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802750:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802754:	74 07                	je     80275d <alloc_block_BF+0x106>
  802756:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802759:	8b 00                	mov    (%eax),%eax
  80275b:	eb 05                	jmp    802762 <alloc_block_BF+0x10b>
  80275d:	b8 00 00 00 00       	mov    $0x0,%eax
  802762:	a3 40 51 80 00       	mov    %eax,0x805140
  802767:	a1 40 51 80 00       	mov    0x805140,%eax
  80276c:	85 c0                	test   %eax,%eax
  80276e:	0f 85 fd fe ff ff    	jne    802671 <alloc_block_BF+0x1a>
  802774:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802778:	0f 85 f3 fe ff ff    	jne    802671 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  80277e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802782:	0f 84 d9 00 00 00    	je     802861 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802788:	a1 48 51 80 00       	mov    0x805148,%eax
  80278d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802790:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802793:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802796:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802799:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80279c:	8b 55 08             	mov    0x8(%ebp),%edx
  80279f:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  8027a2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8027a6:	75 17                	jne    8027bf <alloc_block_BF+0x168>
  8027a8:	83 ec 04             	sub    $0x4,%esp
  8027ab:	68 24 43 80 00       	push   $0x804324
  8027b0:	68 c7 00 00 00       	push   $0xc7
  8027b5:	68 7b 42 80 00       	push   $0x80427b
  8027ba:	e8 17 dd ff ff       	call   8004d6 <_panic>
  8027bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027c2:	8b 00                	mov    (%eax),%eax
  8027c4:	85 c0                	test   %eax,%eax
  8027c6:	74 10                	je     8027d8 <alloc_block_BF+0x181>
  8027c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027cb:	8b 00                	mov    (%eax),%eax
  8027cd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8027d0:	8b 52 04             	mov    0x4(%edx),%edx
  8027d3:	89 50 04             	mov    %edx,0x4(%eax)
  8027d6:	eb 0b                	jmp    8027e3 <alloc_block_BF+0x18c>
  8027d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027db:	8b 40 04             	mov    0x4(%eax),%eax
  8027de:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8027e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027e6:	8b 40 04             	mov    0x4(%eax),%eax
  8027e9:	85 c0                	test   %eax,%eax
  8027eb:	74 0f                	je     8027fc <alloc_block_BF+0x1a5>
  8027ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027f0:	8b 40 04             	mov    0x4(%eax),%eax
  8027f3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8027f6:	8b 12                	mov    (%edx),%edx
  8027f8:	89 10                	mov    %edx,(%eax)
  8027fa:	eb 0a                	jmp    802806 <alloc_block_BF+0x1af>
  8027fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027ff:	8b 00                	mov    (%eax),%eax
  802801:	a3 48 51 80 00       	mov    %eax,0x805148
  802806:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802809:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80280f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802812:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802819:	a1 54 51 80 00       	mov    0x805154,%eax
  80281e:	48                   	dec    %eax
  80281f:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802824:	83 ec 08             	sub    $0x8,%esp
  802827:	ff 75 ec             	pushl  -0x14(%ebp)
  80282a:	68 38 51 80 00       	push   $0x805138
  80282f:	e8 71 f9 ff ff       	call   8021a5 <find_block>
  802834:	83 c4 10             	add    $0x10,%esp
  802837:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  80283a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80283d:	8b 50 08             	mov    0x8(%eax),%edx
  802840:	8b 45 08             	mov    0x8(%ebp),%eax
  802843:	01 c2                	add    %eax,%edx
  802845:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802848:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  80284b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80284e:	8b 40 0c             	mov    0xc(%eax),%eax
  802851:	2b 45 08             	sub    0x8(%ebp),%eax
  802854:	89 c2                	mov    %eax,%edx
  802856:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802859:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  80285c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80285f:	eb 05                	jmp    802866 <alloc_block_BF+0x20f>
	}
	return NULL;
  802861:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802866:	c9                   	leave  
  802867:	c3                   	ret    

00802868 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802868:	55                   	push   %ebp
  802869:	89 e5                	mov    %esp,%ebp
  80286b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  80286e:	a1 28 50 80 00       	mov    0x805028,%eax
  802873:	85 c0                	test   %eax,%eax
  802875:	0f 85 de 01 00 00    	jne    802a59 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  80287b:	a1 38 51 80 00       	mov    0x805138,%eax
  802880:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802883:	e9 9e 01 00 00       	jmp    802a26 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802888:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288b:	8b 40 0c             	mov    0xc(%eax),%eax
  80288e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802891:	0f 82 87 01 00 00    	jb     802a1e <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802897:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289a:	8b 40 0c             	mov    0xc(%eax),%eax
  80289d:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028a0:	0f 85 95 00 00 00    	jne    80293b <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  8028a6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028aa:	75 17                	jne    8028c3 <alloc_block_NF+0x5b>
  8028ac:	83 ec 04             	sub    $0x4,%esp
  8028af:	68 24 43 80 00       	push   $0x804324
  8028b4:	68 e0 00 00 00       	push   $0xe0
  8028b9:	68 7b 42 80 00       	push   $0x80427b
  8028be:	e8 13 dc ff ff       	call   8004d6 <_panic>
  8028c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c6:	8b 00                	mov    (%eax),%eax
  8028c8:	85 c0                	test   %eax,%eax
  8028ca:	74 10                	je     8028dc <alloc_block_NF+0x74>
  8028cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028cf:	8b 00                	mov    (%eax),%eax
  8028d1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028d4:	8b 52 04             	mov    0x4(%edx),%edx
  8028d7:	89 50 04             	mov    %edx,0x4(%eax)
  8028da:	eb 0b                	jmp    8028e7 <alloc_block_NF+0x7f>
  8028dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028df:	8b 40 04             	mov    0x4(%eax),%eax
  8028e2:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8028e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ea:	8b 40 04             	mov    0x4(%eax),%eax
  8028ed:	85 c0                	test   %eax,%eax
  8028ef:	74 0f                	je     802900 <alloc_block_NF+0x98>
  8028f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f4:	8b 40 04             	mov    0x4(%eax),%eax
  8028f7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028fa:	8b 12                	mov    (%edx),%edx
  8028fc:	89 10                	mov    %edx,(%eax)
  8028fe:	eb 0a                	jmp    80290a <alloc_block_NF+0xa2>
  802900:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802903:	8b 00                	mov    (%eax),%eax
  802905:	a3 38 51 80 00       	mov    %eax,0x805138
  80290a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802913:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802916:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80291d:	a1 44 51 80 00       	mov    0x805144,%eax
  802922:	48                   	dec    %eax
  802923:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802928:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292b:	8b 40 08             	mov    0x8(%eax),%eax
  80292e:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  802933:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802936:	e9 f8 04 00 00       	jmp    802e33 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  80293b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293e:	8b 40 0c             	mov    0xc(%eax),%eax
  802941:	3b 45 08             	cmp    0x8(%ebp),%eax
  802944:	0f 86 d4 00 00 00    	jbe    802a1e <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80294a:	a1 48 51 80 00       	mov    0x805148,%eax
  80294f:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802952:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802955:	8b 50 08             	mov    0x8(%eax),%edx
  802958:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80295b:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  80295e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802961:	8b 55 08             	mov    0x8(%ebp),%edx
  802964:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802967:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80296b:	75 17                	jne    802984 <alloc_block_NF+0x11c>
  80296d:	83 ec 04             	sub    $0x4,%esp
  802970:	68 24 43 80 00       	push   $0x804324
  802975:	68 e9 00 00 00       	push   $0xe9
  80297a:	68 7b 42 80 00       	push   $0x80427b
  80297f:	e8 52 db ff ff       	call   8004d6 <_panic>
  802984:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802987:	8b 00                	mov    (%eax),%eax
  802989:	85 c0                	test   %eax,%eax
  80298b:	74 10                	je     80299d <alloc_block_NF+0x135>
  80298d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802990:	8b 00                	mov    (%eax),%eax
  802992:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802995:	8b 52 04             	mov    0x4(%edx),%edx
  802998:	89 50 04             	mov    %edx,0x4(%eax)
  80299b:	eb 0b                	jmp    8029a8 <alloc_block_NF+0x140>
  80299d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029a0:	8b 40 04             	mov    0x4(%eax),%eax
  8029a3:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8029a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029ab:	8b 40 04             	mov    0x4(%eax),%eax
  8029ae:	85 c0                	test   %eax,%eax
  8029b0:	74 0f                	je     8029c1 <alloc_block_NF+0x159>
  8029b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029b5:	8b 40 04             	mov    0x4(%eax),%eax
  8029b8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029bb:	8b 12                	mov    (%edx),%edx
  8029bd:	89 10                	mov    %edx,(%eax)
  8029bf:	eb 0a                	jmp    8029cb <alloc_block_NF+0x163>
  8029c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029c4:	8b 00                	mov    (%eax),%eax
  8029c6:	a3 48 51 80 00       	mov    %eax,0x805148
  8029cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029ce:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029d7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029de:	a1 54 51 80 00       	mov    0x805154,%eax
  8029e3:	48                   	dec    %eax
  8029e4:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  8029e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029ec:	8b 40 08             	mov    0x8(%eax),%eax
  8029ef:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  8029f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f7:	8b 50 08             	mov    0x8(%eax),%edx
  8029fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8029fd:	01 c2                	add    %eax,%edx
  8029ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a02:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802a05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a08:	8b 40 0c             	mov    0xc(%eax),%eax
  802a0b:	2b 45 08             	sub    0x8(%ebp),%eax
  802a0e:	89 c2                	mov    %eax,%edx
  802a10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a13:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802a16:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a19:	e9 15 04 00 00       	jmp    802e33 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802a1e:	a1 40 51 80 00       	mov    0x805140,%eax
  802a23:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a26:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a2a:	74 07                	je     802a33 <alloc_block_NF+0x1cb>
  802a2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2f:	8b 00                	mov    (%eax),%eax
  802a31:	eb 05                	jmp    802a38 <alloc_block_NF+0x1d0>
  802a33:	b8 00 00 00 00       	mov    $0x0,%eax
  802a38:	a3 40 51 80 00       	mov    %eax,0x805140
  802a3d:	a1 40 51 80 00       	mov    0x805140,%eax
  802a42:	85 c0                	test   %eax,%eax
  802a44:	0f 85 3e fe ff ff    	jne    802888 <alloc_block_NF+0x20>
  802a4a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a4e:	0f 85 34 fe ff ff    	jne    802888 <alloc_block_NF+0x20>
  802a54:	e9 d5 03 00 00       	jmp    802e2e <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802a59:	a1 38 51 80 00       	mov    0x805138,%eax
  802a5e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a61:	e9 b1 01 00 00       	jmp    802c17 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802a66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a69:	8b 50 08             	mov    0x8(%eax),%edx
  802a6c:	a1 28 50 80 00       	mov    0x805028,%eax
  802a71:	39 c2                	cmp    %eax,%edx
  802a73:	0f 82 96 01 00 00    	jb     802c0f <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802a79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7c:	8b 40 0c             	mov    0xc(%eax),%eax
  802a7f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a82:	0f 82 87 01 00 00    	jb     802c0f <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802a88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8b:	8b 40 0c             	mov    0xc(%eax),%eax
  802a8e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a91:	0f 85 95 00 00 00    	jne    802b2c <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802a97:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a9b:	75 17                	jne    802ab4 <alloc_block_NF+0x24c>
  802a9d:	83 ec 04             	sub    $0x4,%esp
  802aa0:	68 24 43 80 00       	push   $0x804324
  802aa5:	68 fc 00 00 00       	push   $0xfc
  802aaa:	68 7b 42 80 00       	push   $0x80427b
  802aaf:	e8 22 da ff ff       	call   8004d6 <_panic>
  802ab4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab7:	8b 00                	mov    (%eax),%eax
  802ab9:	85 c0                	test   %eax,%eax
  802abb:	74 10                	je     802acd <alloc_block_NF+0x265>
  802abd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac0:	8b 00                	mov    (%eax),%eax
  802ac2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ac5:	8b 52 04             	mov    0x4(%edx),%edx
  802ac8:	89 50 04             	mov    %edx,0x4(%eax)
  802acb:	eb 0b                	jmp    802ad8 <alloc_block_NF+0x270>
  802acd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad0:	8b 40 04             	mov    0x4(%eax),%eax
  802ad3:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ad8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802adb:	8b 40 04             	mov    0x4(%eax),%eax
  802ade:	85 c0                	test   %eax,%eax
  802ae0:	74 0f                	je     802af1 <alloc_block_NF+0x289>
  802ae2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae5:	8b 40 04             	mov    0x4(%eax),%eax
  802ae8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802aeb:	8b 12                	mov    (%edx),%edx
  802aed:	89 10                	mov    %edx,(%eax)
  802aef:	eb 0a                	jmp    802afb <alloc_block_NF+0x293>
  802af1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af4:	8b 00                	mov    (%eax),%eax
  802af6:	a3 38 51 80 00       	mov    %eax,0x805138
  802afb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802afe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b07:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b0e:	a1 44 51 80 00       	mov    0x805144,%eax
  802b13:	48                   	dec    %eax
  802b14:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802b19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1c:	8b 40 08             	mov    0x8(%eax),%eax
  802b1f:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802b24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b27:	e9 07 03 00 00       	jmp    802e33 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802b2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b2f:	8b 40 0c             	mov    0xc(%eax),%eax
  802b32:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b35:	0f 86 d4 00 00 00    	jbe    802c0f <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802b3b:	a1 48 51 80 00       	mov    0x805148,%eax
  802b40:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802b43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b46:	8b 50 08             	mov    0x8(%eax),%edx
  802b49:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b4c:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802b4f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b52:	8b 55 08             	mov    0x8(%ebp),%edx
  802b55:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802b58:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802b5c:	75 17                	jne    802b75 <alloc_block_NF+0x30d>
  802b5e:	83 ec 04             	sub    $0x4,%esp
  802b61:	68 24 43 80 00       	push   $0x804324
  802b66:	68 04 01 00 00       	push   $0x104
  802b6b:	68 7b 42 80 00       	push   $0x80427b
  802b70:	e8 61 d9 ff ff       	call   8004d6 <_panic>
  802b75:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b78:	8b 00                	mov    (%eax),%eax
  802b7a:	85 c0                	test   %eax,%eax
  802b7c:	74 10                	je     802b8e <alloc_block_NF+0x326>
  802b7e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b81:	8b 00                	mov    (%eax),%eax
  802b83:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b86:	8b 52 04             	mov    0x4(%edx),%edx
  802b89:	89 50 04             	mov    %edx,0x4(%eax)
  802b8c:	eb 0b                	jmp    802b99 <alloc_block_NF+0x331>
  802b8e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b91:	8b 40 04             	mov    0x4(%eax),%eax
  802b94:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b99:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b9c:	8b 40 04             	mov    0x4(%eax),%eax
  802b9f:	85 c0                	test   %eax,%eax
  802ba1:	74 0f                	je     802bb2 <alloc_block_NF+0x34a>
  802ba3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ba6:	8b 40 04             	mov    0x4(%eax),%eax
  802ba9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802bac:	8b 12                	mov    (%edx),%edx
  802bae:	89 10                	mov    %edx,(%eax)
  802bb0:	eb 0a                	jmp    802bbc <alloc_block_NF+0x354>
  802bb2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bb5:	8b 00                	mov    (%eax),%eax
  802bb7:	a3 48 51 80 00       	mov    %eax,0x805148
  802bbc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bbf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bc5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bc8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bcf:	a1 54 51 80 00       	mov    0x805154,%eax
  802bd4:	48                   	dec    %eax
  802bd5:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802bda:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bdd:	8b 40 08             	mov    0x8(%eax),%eax
  802be0:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802be5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be8:	8b 50 08             	mov    0x8(%eax),%edx
  802beb:	8b 45 08             	mov    0x8(%ebp),%eax
  802bee:	01 c2                	add    %eax,%edx
  802bf0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf3:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802bf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf9:	8b 40 0c             	mov    0xc(%eax),%eax
  802bfc:	2b 45 08             	sub    0x8(%ebp),%eax
  802bff:	89 c2                	mov    %eax,%edx
  802c01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c04:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802c07:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c0a:	e9 24 02 00 00       	jmp    802e33 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802c0f:	a1 40 51 80 00       	mov    0x805140,%eax
  802c14:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c17:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c1b:	74 07                	je     802c24 <alloc_block_NF+0x3bc>
  802c1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c20:	8b 00                	mov    (%eax),%eax
  802c22:	eb 05                	jmp    802c29 <alloc_block_NF+0x3c1>
  802c24:	b8 00 00 00 00       	mov    $0x0,%eax
  802c29:	a3 40 51 80 00       	mov    %eax,0x805140
  802c2e:	a1 40 51 80 00       	mov    0x805140,%eax
  802c33:	85 c0                	test   %eax,%eax
  802c35:	0f 85 2b fe ff ff    	jne    802a66 <alloc_block_NF+0x1fe>
  802c3b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c3f:	0f 85 21 fe ff ff    	jne    802a66 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802c45:	a1 38 51 80 00       	mov    0x805138,%eax
  802c4a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c4d:	e9 ae 01 00 00       	jmp    802e00 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802c52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c55:	8b 50 08             	mov    0x8(%eax),%edx
  802c58:	a1 28 50 80 00       	mov    0x805028,%eax
  802c5d:	39 c2                	cmp    %eax,%edx
  802c5f:	0f 83 93 01 00 00    	jae    802df8 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802c65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c68:	8b 40 0c             	mov    0xc(%eax),%eax
  802c6b:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c6e:	0f 82 84 01 00 00    	jb     802df8 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802c74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c77:	8b 40 0c             	mov    0xc(%eax),%eax
  802c7a:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c7d:	0f 85 95 00 00 00    	jne    802d18 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802c83:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c87:	75 17                	jne    802ca0 <alloc_block_NF+0x438>
  802c89:	83 ec 04             	sub    $0x4,%esp
  802c8c:	68 24 43 80 00       	push   $0x804324
  802c91:	68 14 01 00 00       	push   $0x114
  802c96:	68 7b 42 80 00       	push   $0x80427b
  802c9b:	e8 36 d8 ff ff       	call   8004d6 <_panic>
  802ca0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca3:	8b 00                	mov    (%eax),%eax
  802ca5:	85 c0                	test   %eax,%eax
  802ca7:	74 10                	je     802cb9 <alloc_block_NF+0x451>
  802ca9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cac:	8b 00                	mov    (%eax),%eax
  802cae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cb1:	8b 52 04             	mov    0x4(%edx),%edx
  802cb4:	89 50 04             	mov    %edx,0x4(%eax)
  802cb7:	eb 0b                	jmp    802cc4 <alloc_block_NF+0x45c>
  802cb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cbc:	8b 40 04             	mov    0x4(%eax),%eax
  802cbf:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802cc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc7:	8b 40 04             	mov    0x4(%eax),%eax
  802cca:	85 c0                	test   %eax,%eax
  802ccc:	74 0f                	je     802cdd <alloc_block_NF+0x475>
  802cce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd1:	8b 40 04             	mov    0x4(%eax),%eax
  802cd4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cd7:	8b 12                	mov    (%edx),%edx
  802cd9:	89 10                	mov    %edx,(%eax)
  802cdb:	eb 0a                	jmp    802ce7 <alloc_block_NF+0x47f>
  802cdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce0:	8b 00                	mov    (%eax),%eax
  802ce2:	a3 38 51 80 00       	mov    %eax,0x805138
  802ce7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cea:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cf0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cfa:	a1 44 51 80 00       	mov    0x805144,%eax
  802cff:	48                   	dec    %eax
  802d00:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802d05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d08:	8b 40 08             	mov    0x8(%eax),%eax
  802d0b:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802d10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d13:	e9 1b 01 00 00       	jmp    802e33 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802d18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d1b:	8b 40 0c             	mov    0xc(%eax),%eax
  802d1e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d21:	0f 86 d1 00 00 00    	jbe    802df8 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802d27:	a1 48 51 80 00       	mov    0x805148,%eax
  802d2c:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802d2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d32:	8b 50 08             	mov    0x8(%eax),%edx
  802d35:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d38:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802d3b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d3e:	8b 55 08             	mov    0x8(%ebp),%edx
  802d41:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802d44:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802d48:	75 17                	jne    802d61 <alloc_block_NF+0x4f9>
  802d4a:	83 ec 04             	sub    $0x4,%esp
  802d4d:	68 24 43 80 00       	push   $0x804324
  802d52:	68 1c 01 00 00       	push   $0x11c
  802d57:	68 7b 42 80 00       	push   $0x80427b
  802d5c:	e8 75 d7 ff ff       	call   8004d6 <_panic>
  802d61:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d64:	8b 00                	mov    (%eax),%eax
  802d66:	85 c0                	test   %eax,%eax
  802d68:	74 10                	je     802d7a <alloc_block_NF+0x512>
  802d6a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d6d:	8b 00                	mov    (%eax),%eax
  802d6f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d72:	8b 52 04             	mov    0x4(%edx),%edx
  802d75:	89 50 04             	mov    %edx,0x4(%eax)
  802d78:	eb 0b                	jmp    802d85 <alloc_block_NF+0x51d>
  802d7a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d7d:	8b 40 04             	mov    0x4(%eax),%eax
  802d80:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d85:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d88:	8b 40 04             	mov    0x4(%eax),%eax
  802d8b:	85 c0                	test   %eax,%eax
  802d8d:	74 0f                	je     802d9e <alloc_block_NF+0x536>
  802d8f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d92:	8b 40 04             	mov    0x4(%eax),%eax
  802d95:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d98:	8b 12                	mov    (%edx),%edx
  802d9a:	89 10                	mov    %edx,(%eax)
  802d9c:	eb 0a                	jmp    802da8 <alloc_block_NF+0x540>
  802d9e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802da1:	8b 00                	mov    (%eax),%eax
  802da3:	a3 48 51 80 00       	mov    %eax,0x805148
  802da8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dab:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802db1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802db4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dbb:	a1 54 51 80 00       	mov    0x805154,%eax
  802dc0:	48                   	dec    %eax
  802dc1:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802dc6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dc9:	8b 40 08             	mov    0x8(%eax),%eax
  802dcc:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802dd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd4:	8b 50 08             	mov    0x8(%eax),%edx
  802dd7:	8b 45 08             	mov    0x8(%ebp),%eax
  802dda:	01 c2                	add    %eax,%edx
  802ddc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ddf:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802de2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de5:	8b 40 0c             	mov    0xc(%eax),%eax
  802de8:	2b 45 08             	sub    0x8(%ebp),%eax
  802deb:	89 c2                	mov    %eax,%edx
  802ded:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df0:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802df3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802df6:	eb 3b                	jmp    802e33 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802df8:	a1 40 51 80 00       	mov    0x805140,%eax
  802dfd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e00:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e04:	74 07                	je     802e0d <alloc_block_NF+0x5a5>
  802e06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e09:	8b 00                	mov    (%eax),%eax
  802e0b:	eb 05                	jmp    802e12 <alloc_block_NF+0x5aa>
  802e0d:	b8 00 00 00 00       	mov    $0x0,%eax
  802e12:	a3 40 51 80 00       	mov    %eax,0x805140
  802e17:	a1 40 51 80 00       	mov    0x805140,%eax
  802e1c:	85 c0                	test   %eax,%eax
  802e1e:	0f 85 2e fe ff ff    	jne    802c52 <alloc_block_NF+0x3ea>
  802e24:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e28:	0f 85 24 fe ff ff    	jne    802c52 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802e2e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e33:	c9                   	leave  
  802e34:	c3                   	ret    

00802e35 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802e35:	55                   	push   %ebp
  802e36:	89 e5                	mov    %esp,%ebp
  802e38:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802e3b:	a1 38 51 80 00       	mov    0x805138,%eax
  802e40:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802e43:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802e48:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802e4b:	a1 38 51 80 00       	mov    0x805138,%eax
  802e50:	85 c0                	test   %eax,%eax
  802e52:	74 14                	je     802e68 <insert_sorted_with_merge_freeList+0x33>
  802e54:	8b 45 08             	mov    0x8(%ebp),%eax
  802e57:	8b 50 08             	mov    0x8(%eax),%edx
  802e5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e5d:	8b 40 08             	mov    0x8(%eax),%eax
  802e60:	39 c2                	cmp    %eax,%edx
  802e62:	0f 87 9b 01 00 00    	ja     803003 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802e68:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e6c:	75 17                	jne    802e85 <insert_sorted_with_merge_freeList+0x50>
  802e6e:	83 ec 04             	sub    $0x4,%esp
  802e71:	68 58 42 80 00       	push   $0x804258
  802e76:	68 38 01 00 00       	push   $0x138
  802e7b:	68 7b 42 80 00       	push   $0x80427b
  802e80:	e8 51 d6 ff ff       	call   8004d6 <_panic>
  802e85:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802e8b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e8e:	89 10                	mov    %edx,(%eax)
  802e90:	8b 45 08             	mov    0x8(%ebp),%eax
  802e93:	8b 00                	mov    (%eax),%eax
  802e95:	85 c0                	test   %eax,%eax
  802e97:	74 0d                	je     802ea6 <insert_sorted_with_merge_freeList+0x71>
  802e99:	a1 38 51 80 00       	mov    0x805138,%eax
  802e9e:	8b 55 08             	mov    0x8(%ebp),%edx
  802ea1:	89 50 04             	mov    %edx,0x4(%eax)
  802ea4:	eb 08                	jmp    802eae <insert_sorted_with_merge_freeList+0x79>
  802ea6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea9:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802eae:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb1:	a3 38 51 80 00       	mov    %eax,0x805138
  802eb6:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ec0:	a1 44 51 80 00       	mov    0x805144,%eax
  802ec5:	40                   	inc    %eax
  802ec6:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802ecb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ecf:	0f 84 a8 06 00 00    	je     80357d <insert_sorted_with_merge_freeList+0x748>
  802ed5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed8:	8b 50 08             	mov    0x8(%eax),%edx
  802edb:	8b 45 08             	mov    0x8(%ebp),%eax
  802ede:	8b 40 0c             	mov    0xc(%eax),%eax
  802ee1:	01 c2                	add    %eax,%edx
  802ee3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ee6:	8b 40 08             	mov    0x8(%eax),%eax
  802ee9:	39 c2                	cmp    %eax,%edx
  802eeb:	0f 85 8c 06 00 00    	jne    80357d <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802ef1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef4:	8b 50 0c             	mov    0xc(%eax),%edx
  802ef7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802efa:	8b 40 0c             	mov    0xc(%eax),%eax
  802efd:	01 c2                	add    %eax,%edx
  802eff:	8b 45 08             	mov    0x8(%ebp),%eax
  802f02:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802f05:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f09:	75 17                	jne    802f22 <insert_sorted_with_merge_freeList+0xed>
  802f0b:	83 ec 04             	sub    $0x4,%esp
  802f0e:	68 24 43 80 00       	push   $0x804324
  802f13:	68 3c 01 00 00       	push   $0x13c
  802f18:	68 7b 42 80 00       	push   $0x80427b
  802f1d:	e8 b4 d5 ff ff       	call   8004d6 <_panic>
  802f22:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f25:	8b 00                	mov    (%eax),%eax
  802f27:	85 c0                	test   %eax,%eax
  802f29:	74 10                	je     802f3b <insert_sorted_with_merge_freeList+0x106>
  802f2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f2e:	8b 00                	mov    (%eax),%eax
  802f30:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f33:	8b 52 04             	mov    0x4(%edx),%edx
  802f36:	89 50 04             	mov    %edx,0x4(%eax)
  802f39:	eb 0b                	jmp    802f46 <insert_sorted_with_merge_freeList+0x111>
  802f3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f3e:	8b 40 04             	mov    0x4(%eax),%eax
  802f41:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f46:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f49:	8b 40 04             	mov    0x4(%eax),%eax
  802f4c:	85 c0                	test   %eax,%eax
  802f4e:	74 0f                	je     802f5f <insert_sorted_with_merge_freeList+0x12a>
  802f50:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f53:	8b 40 04             	mov    0x4(%eax),%eax
  802f56:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f59:	8b 12                	mov    (%edx),%edx
  802f5b:	89 10                	mov    %edx,(%eax)
  802f5d:	eb 0a                	jmp    802f69 <insert_sorted_with_merge_freeList+0x134>
  802f5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f62:	8b 00                	mov    (%eax),%eax
  802f64:	a3 38 51 80 00       	mov    %eax,0x805138
  802f69:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f6c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f72:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f75:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f7c:	a1 44 51 80 00       	mov    0x805144,%eax
  802f81:	48                   	dec    %eax
  802f82:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802f87:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f8a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802f91:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f94:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802f9b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f9f:	75 17                	jne    802fb8 <insert_sorted_with_merge_freeList+0x183>
  802fa1:	83 ec 04             	sub    $0x4,%esp
  802fa4:	68 58 42 80 00       	push   $0x804258
  802fa9:	68 3f 01 00 00       	push   $0x13f
  802fae:	68 7b 42 80 00       	push   $0x80427b
  802fb3:	e8 1e d5 ff ff       	call   8004d6 <_panic>
  802fb8:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802fbe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fc1:	89 10                	mov    %edx,(%eax)
  802fc3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fc6:	8b 00                	mov    (%eax),%eax
  802fc8:	85 c0                	test   %eax,%eax
  802fca:	74 0d                	je     802fd9 <insert_sorted_with_merge_freeList+0x1a4>
  802fcc:	a1 48 51 80 00       	mov    0x805148,%eax
  802fd1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802fd4:	89 50 04             	mov    %edx,0x4(%eax)
  802fd7:	eb 08                	jmp    802fe1 <insert_sorted_with_merge_freeList+0x1ac>
  802fd9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fdc:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802fe1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fe4:	a3 48 51 80 00       	mov    %eax,0x805148
  802fe9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fec:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ff3:	a1 54 51 80 00       	mov    0x805154,%eax
  802ff8:	40                   	inc    %eax
  802ff9:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802ffe:	e9 7a 05 00 00       	jmp    80357d <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  803003:	8b 45 08             	mov    0x8(%ebp),%eax
  803006:	8b 50 08             	mov    0x8(%eax),%edx
  803009:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80300c:	8b 40 08             	mov    0x8(%eax),%eax
  80300f:	39 c2                	cmp    %eax,%edx
  803011:	0f 82 14 01 00 00    	jb     80312b <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  803017:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80301a:	8b 50 08             	mov    0x8(%eax),%edx
  80301d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803020:	8b 40 0c             	mov    0xc(%eax),%eax
  803023:	01 c2                	add    %eax,%edx
  803025:	8b 45 08             	mov    0x8(%ebp),%eax
  803028:	8b 40 08             	mov    0x8(%eax),%eax
  80302b:	39 c2                	cmp    %eax,%edx
  80302d:	0f 85 90 00 00 00    	jne    8030c3 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  803033:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803036:	8b 50 0c             	mov    0xc(%eax),%edx
  803039:	8b 45 08             	mov    0x8(%ebp),%eax
  80303c:	8b 40 0c             	mov    0xc(%eax),%eax
  80303f:	01 c2                	add    %eax,%edx
  803041:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803044:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  803047:	8b 45 08             	mov    0x8(%ebp),%eax
  80304a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  803051:	8b 45 08             	mov    0x8(%ebp),%eax
  803054:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80305b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80305f:	75 17                	jne    803078 <insert_sorted_with_merge_freeList+0x243>
  803061:	83 ec 04             	sub    $0x4,%esp
  803064:	68 58 42 80 00       	push   $0x804258
  803069:	68 49 01 00 00       	push   $0x149
  80306e:	68 7b 42 80 00       	push   $0x80427b
  803073:	e8 5e d4 ff ff       	call   8004d6 <_panic>
  803078:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80307e:	8b 45 08             	mov    0x8(%ebp),%eax
  803081:	89 10                	mov    %edx,(%eax)
  803083:	8b 45 08             	mov    0x8(%ebp),%eax
  803086:	8b 00                	mov    (%eax),%eax
  803088:	85 c0                	test   %eax,%eax
  80308a:	74 0d                	je     803099 <insert_sorted_with_merge_freeList+0x264>
  80308c:	a1 48 51 80 00       	mov    0x805148,%eax
  803091:	8b 55 08             	mov    0x8(%ebp),%edx
  803094:	89 50 04             	mov    %edx,0x4(%eax)
  803097:	eb 08                	jmp    8030a1 <insert_sorted_with_merge_freeList+0x26c>
  803099:	8b 45 08             	mov    0x8(%ebp),%eax
  80309c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8030a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a4:	a3 48 51 80 00       	mov    %eax,0x805148
  8030a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ac:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030b3:	a1 54 51 80 00       	mov    0x805154,%eax
  8030b8:	40                   	inc    %eax
  8030b9:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8030be:	e9 bb 04 00 00       	jmp    80357e <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  8030c3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030c7:	75 17                	jne    8030e0 <insert_sorted_with_merge_freeList+0x2ab>
  8030c9:	83 ec 04             	sub    $0x4,%esp
  8030cc:	68 cc 42 80 00       	push   $0x8042cc
  8030d1:	68 4c 01 00 00       	push   $0x14c
  8030d6:	68 7b 42 80 00       	push   $0x80427b
  8030db:	e8 f6 d3 ff ff       	call   8004d6 <_panic>
  8030e0:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  8030e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e9:	89 50 04             	mov    %edx,0x4(%eax)
  8030ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ef:	8b 40 04             	mov    0x4(%eax),%eax
  8030f2:	85 c0                	test   %eax,%eax
  8030f4:	74 0c                	je     803102 <insert_sorted_with_merge_freeList+0x2cd>
  8030f6:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8030fb:	8b 55 08             	mov    0x8(%ebp),%edx
  8030fe:	89 10                	mov    %edx,(%eax)
  803100:	eb 08                	jmp    80310a <insert_sorted_with_merge_freeList+0x2d5>
  803102:	8b 45 08             	mov    0x8(%ebp),%eax
  803105:	a3 38 51 80 00       	mov    %eax,0x805138
  80310a:	8b 45 08             	mov    0x8(%ebp),%eax
  80310d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803112:	8b 45 08             	mov    0x8(%ebp),%eax
  803115:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80311b:	a1 44 51 80 00       	mov    0x805144,%eax
  803120:	40                   	inc    %eax
  803121:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803126:	e9 53 04 00 00       	jmp    80357e <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  80312b:	a1 38 51 80 00       	mov    0x805138,%eax
  803130:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803133:	e9 15 04 00 00       	jmp    80354d <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  803138:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80313b:	8b 00                	mov    (%eax),%eax
  80313d:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  803140:	8b 45 08             	mov    0x8(%ebp),%eax
  803143:	8b 50 08             	mov    0x8(%eax),%edx
  803146:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803149:	8b 40 08             	mov    0x8(%eax),%eax
  80314c:	39 c2                	cmp    %eax,%edx
  80314e:	0f 86 f1 03 00 00    	jbe    803545 <insert_sorted_with_merge_freeList+0x710>
  803154:	8b 45 08             	mov    0x8(%ebp),%eax
  803157:	8b 50 08             	mov    0x8(%eax),%edx
  80315a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80315d:	8b 40 08             	mov    0x8(%eax),%eax
  803160:	39 c2                	cmp    %eax,%edx
  803162:	0f 83 dd 03 00 00    	jae    803545 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  803168:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80316b:	8b 50 08             	mov    0x8(%eax),%edx
  80316e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803171:	8b 40 0c             	mov    0xc(%eax),%eax
  803174:	01 c2                	add    %eax,%edx
  803176:	8b 45 08             	mov    0x8(%ebp),%eax
  803179:	8b 40 08             	mov    0x8(%eax),%eax
  80317c:	39 c2                	cmp    %eax,%edx
  80317e:	0f 85 b9 01 00 00    	jne    80333d <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803184:	8b 45 08             	mov    0x8(%ebp),%eax
  803187:	8b 50 08             	mov    0x8(%eax),%edx
  80318a:	8b 45 08             	mov    0x8(%ebp),%eax
  80318d:	8b 40 0c             	mov    0xc(%eax),%eax
  803190:	01 c2                	add    %eax,%edx
  803192:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803195:	8b 40 08             	mov    0x8(%eax),%eax
  803198:	39 c2                	cmp    %eax,%edx
  80319a:	0f 85 0d 01 00 00    	jne    8032ad <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  8031a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031a3:	8b 50 0c             	mov    0xc(%eax),%edx
  8031a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031a9:	8b 40 0c             	mov    0xc(%eax),%eax
  8031ac:	01 c2                	add    %eax,%edx
  8031ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031b1:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8031b4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8031b8:	75 17                	jne    8031d1 <insert_sorted_with_merge_freeList+0x39c>
  8031ba:	83 ec 04             	sub    $0x4,%esp
  8031bd:	68 24 43 80 00       	push   $0x804324
  8031c2:	68 5c 01 00 00       	push   $0x15c
  8031c7:	68 7b 42 80 00       	push   $0x80427b
  8031cc:	e8 05 d3 ff ff       	call   8004d6 <_panic>
  8031d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031d4:	8b 00                	mov    (%eax),%eax
  8031d6:	85 c0                	test   %eax,%eax
  8031d8:	74 10                	je     8031ea <insert_sorted_with_merge_freeList+0x3b5>
  8031da:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031dd:	8b 00                	mov    (%eax),%eax
  8031df:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031e2:	8b 52 04             	mov    0x4(%edx),%edx
  8031e5:	89 50 04             	mov    %edx,0x4(%eax)
  8031e8:	eb 0b                	jmp    8031f5 <insert_sorted_with_merge_freeList+0x3c0>
  8031ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ed:	8b 40 04             	mov    0x4(%eax),%eax
  8031f0:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8031f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031f8:	8b 40 04             	mov    0x4(%eax),%eax
  8031fb:	85 c0                	test   %eax,%eax
  8031fd:	74 0f                	je     80320e <insert_sorted_with_merge_freeList+0x3d9>
  8031ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803202:	8b 40 04             	mov    0x4(%eax),%eax
  803205:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803208:	8b 12                	mov    (%edx),%edx
  80320a:	89 10                	mov    %edx,(%eax)
  80320c:	eb 0a                	jmp    803218 <insert_sorted_with_merge_freeList+0x3e3>
  80320e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803211:	8b 00                	mov    (%eax),%eax
  803213:	a3 38 51 80 00       	mov    %eax,0x805138
  803218:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80321b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803221:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803224:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80322b:	a1 44 51 80 00       	mov    0x805144,%eax
  803230:	48                   	dec    %eax
  803231:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  803236:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803239:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803240:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803243:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80324a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80324e:	75 17                	jne    803267 <insert_sorted_with_merge_freeList+0x432>
  803250:	83 ec 04             	sub    $0x4,%esp
  803253:	68 58 42 80 00       	push   $0x804258
  803258:	68 5f 01 00 00       	push   $0x15f
  80325d:	68 7b 42 80 00       	push   $0x80427b
  803262:	e8 6f d2 ff ff       	call   8004d6 <_panic>
  803267:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80326d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803270:	89 10                	mov    %edx,(%eax)
  803272:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803275:	8b 00                	mov    (%eax),%eax
  803277:	85 c0                	test   %eax,%eax
  803279:	74 0d                	je     803288 <insert_sorted_with_merge_freeList+0x453>
  80327b:	a1 48 51 80 00       	mov    0x805148,%eax
  803280:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803283:	89 50 04             	mov    %edx,0x4(%eax)
  803286:	eb 08                	jmp    803290 <insert_sorted_with_merge_freeList+0x45b>
  803288:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80328b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803290:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803293:	a3 48 51 80 00       	mov    %eax,0x805148
  803298:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80329b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032a2:	a1 54 51 80 00       	mov    0x805154,%eax
  8032a7:	40                   	inc    %eax
  8032a8:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  8032ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032b0:	8b 50 0c             	mov    0xc(%eax),%edx
  8032b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b6:	8b 40 0c             	mov    0xc(%eax),%eax
  8032b9:	01 c2                	add    %eax,%edx
  8032bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032be:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  8032c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  8032cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ce:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8032d5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032d9:	75 17                	jne    8032f2 <insert_sorted_with_merge_freeList+0x4bd>
  8032db:	83 ec 04             	sub    $0x4,%esp
  8032de:	68 58 42 80 00       	push   $0x804258
  8032e3:	68 64 01 00 00       	push   $0x164
  8032e8:	68 7b 42 80 00       	push   $0x80427b
  8032ed:	e8 e4 d1 ff ff       	call   8004d6 <_panic>
  8032f2:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8032f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8032fb:	89 10                	mov    %edx,(%eax)
  8032fd:	8b 45 08             	mov    0x8(%ebp),%eax
  803300:	8b 00                	mov    (%eax),%eax
  803302:	85 c0                	test   %eax,%eax
  803304:	74 0d                	je     803313 <insert_sorted_with_merge_freeList+0x4de>
  803306:	a1 48 51 80 00       	mov    0x805148,%eax
  80330b:	8b 55 08             	mov    0x8(%ebp),%edx
  80330e:	89 50 04             	mov    %edx,0x4(%eax)
  803311:	eb 08                	jmp    80331b <insert_sorted_with_merge_freeList+0x4e6>
  803313:	8b 45 08             	mov    0x8(%ebp),%eax
  803316:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80331b:	8b 45 08             	mov    0x8(%ebp),%eax
  80331e:	a3 48 51 80 00       	mov    %eax,0x805148
  803323:	8b 45 08             	mov    0x8(%ebp),%eax
  803326:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80332d:	a1 54 51 80 00       	mov    0x805154,%eax
  803332:	40                   	inc    %eax
  803333:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803338:	e9 41 02 00 00       	jmp    80357e <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  80333d:	8b 45 08             	mov    0x8(%ebp),%eax
  803340:	8b 50 08             	mov    0x8(%eax),%edx
  803343:	8b 45 08             	mov    0x8(%ebp),%eax
  803346:	8b 40 0c             	mov    0xc(%eax),%eax
  803349:	01 c2                	add    %eax,%edx
  80334b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80334e:	8b 40 08             	mov    0x8(%eax),%eax
  803351:	39 c2                	cmp    %eax,%edx
  803353:	0f 85 7c 01 00 00    	jne    8034d5 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803359:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80335d:	74 06                	je     803365 <insert_sorted_with_merge_freeList+0x530>
  80335f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803363:	75 17                	jne    80337c <insert_sorted_with_merge_freeList+0x547>
  803365:	83 ec 04             	sub    $0x4,%esp
  803368:	68 94 42 80 00       	push   $0x804294
  80336d:	68 69 01 00 00       	push   $0x169
  803372:	68 7b 42 80 00       	push   $0x80427b
  803377:	e8 5a d1 ff ff       	call   8004d6 <_panic>
  80337c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80337f:	8b 50 04             	mov    0x4(%eax),%edx
  803382:	8b 45 08             	mov    0x8(%ebp),%eax
  803385:	89 50 04             	mov    %edx,0x4(%eax)
  803388:	8b 45 08             	mov    0x8(%ebp),%eax
  80338b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80338e:	89 10                	mov    %edx,(%eax)
  803390:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803393:	8b 40 04             	mov    0x4(%eax),%eax
  803396:	85 c0                	test   %eax,%eax
  803398:	74 0d                	je     8033a7 <insert_sorted_with_merge_freeList+0x572>
  80339a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80339d:	8b 40 04             	mov    0x4(%eax),%eax
  8033a0:	8b 55 08             	mov    0x8(%ebp),%edx
  8033a3:	89 10                	mov    %edx,(%eax)
  8033a5:	eb 08                	jmp    8033af <insert_sorted_with_merge_freeList+0x57a>
  8033a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8033aa:	a3 38 51 80 00       	mov    %eax,0x805138
  8033af:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033b2:	8b 55 08             	mov    0x8(%ebp),%edx
  8033b5:	89 50 04             	mov    %edx,0x4(%eax)
  8033b8:	a1 44 51 80 00       	mov    0x805144,%eax
  8033bd:	40                   	inc    %eax
  8033be:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  8033c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c6:	8b 50 0c             	mov    0xc(%eax),%edx
  8033c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033cc:	8b 40 0c             	mov    0xc(%eax),%eax
  8033cf:	01 c2                	add    %eax,%edx
  8033d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d4:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8033d7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8033db:	75 17                	jne    8033f4 <insert_sorted_with_merge_freeList+0x5bf>
  8033dd:	83 ec 04             	sub    $0x4,%esp
  8033e0:	68 24 43 80 00       	push   $0x804324
  8033e5:	68 6b 01 00 00       	push   $0x16b
  8033ea:	68 7b 42 80 00       	push   $0x80427b
  8033ef:	e8 e2 d0 ff ff       	call   8004d6 <_panic>
  8033f4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033f7:	8b 00                	mov    (%eax),%eax
  8033f9:	85 c0                	test   %eax,%eax
  8033fb:	74 10                	je     80340d <insert_sorted_with_merge_freeList+0x5d8>
  8033fd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803400:	8b 00                	mov    (%eax),%eax
  803402:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803405:	8b 52 04             	mov    0x4(%edx),%edx
  803408:	89 50 04             	mov    %edx,0x4(%eax)
  80340b:	eb 0b                	jmp    803418 <insert_sorted_with_merge_freeList+0x5e3>
  80340d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803410:	8b 40 04             	mov    0x4(%eax),%eax
  803413:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803418:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80341b:	8b 40 04             	mov    0x4(%eax),%eax
  80341e:	85 c0                	test   %eax,%eax
  803420:	74 0f                	je     803431 <insert_sorted_with_merge_freeList+0x5fc>
  803422:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803425:	8b 40 04             	mov    0x4(%eax),%eax
  803428:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80342b:	8b 12                	mov    (%edx),%edx
  80342d:	89 10                	mov    %edx,(%eax)
  80342f:	eb 0a                	jmp    80343b <insert_sorted_with_merge_freeList+0x606>
  803431:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803434:	8b 00                	mov    (%eax),%eax
  803436:	a3 38 51 80 00       	mov    %eax,0x805138
  80343b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80343e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803444:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803447:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80344e:	a1 44 51 80 00       	mov    0x805144,%eax
  803453:	48                   	dec    %eax
  803454:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803459:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80345c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803463:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803466:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80346d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803471:	75 17                	jne    80348a <insert_sorted_with_merge_freeList+0x655>
  803473:	83 ec 04             	sub    $0x4,%esp
  803476:	68 58 42 80 00       	push   $0x804258
  80347b:	68 6e 01 00 00       	push   $0x16e
  803480:	68 7b 42 80 00       	push   $0x80427b
  803485:	e8 4c d0 ff ff       	call   8004d6 <_panic>
  80348a:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803490:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803493:	89 10                	mov    %edx,(%eax)
  803495:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803498:	8b 00                	mov    (%eax),%eax
  80349a:	85 c0                	test   %eax,%eax
  80349c:	74 0d                	je     8034ab <insert_sorted_with_merge_freeList+0x676>
  80349e:	a1 48 51 80 00       	mov    0x805148,%eax
  8034a3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8034a6:	89 50 04             	mov    %edx,0x4(%eax)
  8034a9:	eb 08                	jmp    8034b3 <insert_sorted_with_merge_freeList+0x67e>
  8034ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034ae:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8034b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034b6:	a3 48 51 80 00       	mov    %eax,0x805148
  8034bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034be:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034c5:	a1 54 51 80 00       	mov    0x805154,%eax
  8034ca:	40                   	inc    %eax
  8034cb:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8034d0:	e9 a9 00 00 00       	jmp    80357e <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  8034d5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034d9:	74 06                	je     8034e1 <insert_sorted_with_merge_freeList+0x6ac>
  8034db:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034df:	75 17                	jne    8034f8 <insert_sorted_with_merge_freeList+0x6c3>
  8034e1:	83 ec 04             	sub    $0x4,%esp
  8034e4:	68 f0 42 80 00       	push   $0x8042f0
  8034e9:	68 73 01 00 00       	push   $0x173
  8034ee:	68 7b 42 80 00       	push   $0x80427b
  8034f3:	e8 de cf ff ff       	call   8004d6 <_panic>
  8034f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034fb:	8b 10                	mov    (%eax),%edx
  8034fd:	8b 45 08             	mov    0x8(%ebp),%eax
  803500:	89 10                	mov    %edx,(%eax)
  803502:	8b 45 08             	mov    0x8(%ebp),%eax
  803505:	8b 00                	mov    (%eax),%eax
  803507:	85 c0                	test   %eax,%eax
  803509:	74 0b                	je     803516 <insert_sorted_with_merge_freeList+0x6e1>
  80350b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80350e:	8b 00                	mov    (%eax),%eax
  803510:	8b 55 08             	mov    0x8(%ebp),%edx
  803513:	89 50 04             	mov    %edx,0x4(%eax)
  803516:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803519:	8b 55 08             	mov    0x8(%ebp),%edx
  80351c:	89 10                	mov    %edx,(%eax)
  80351e:	8b 45 08             	mov    0x8(%ebp),%eax
  803521:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803524:	89 50 04             	mov    %edx,0x4(%eax)
  803527:	8b 45 08             	mov    0x8(%ebp),%eax
  80352a:	8b 00                	mov    (%eax),%eax
  80352c:	85 c0                	test   %eax,%eax
  80352e:	75 08                	jne    803538 <insert_sorted_with_merge_freeList+0x703>
  803530:	8b 45 08             	mov    0x8(%ebp),%eax
  803533:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803538:	a1 44 51 80 00       	mov    0x805144,%eax
  80353d:	40                   	inc    %eax
  80353e:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803543:	eb 39                	jmp    80357e <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803545:	a1 40 51 80 00       	mov    0x805140,%eax
  80354a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80354d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803551:	74 07                	je     80355a <insert_sorted_with_merge_freeList+0x725>
  803553:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803556:	8b 00                	mov    (%eax),%eax
  803558:	eb 05                	jmp    80355f <insert_sorted_with_merge_freeList+0x72a>
  80355a:	b8 00 00 00 00       	mov    $0x0,%eax
  80355f:	a3 40 51 80 00       	mov    %eax,0x805140
  803564:	a1 40 51 80 00       	mov    0x805140,%eax
  803569:	85 c0                	test   %eax,%eax
  80356b:	0f 85 c7 fb ff ff    	jne    803138 <insert_sorted_with_merge_freeList+0x303>
  803571:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803575:	0f 85 bd fb ff ff    	jne    803138 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80357b:	eb 01                	jmp    80357e <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80357d:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80357e:	90                   	nop
  80357f:	c9                   	leave  
  803580:	c3                   	ret    
  803581:	66 90                	xchg   %ax,%ax
  803583:	90                   	nop

00803584 <__udivdi3>:
  803584:	55                   	push   %ebp
  803585:	57                   	push   %edi
  803586:	56                   	push   %esi
  803587:	53                   	push   %ebx
  803588:	83 ec 1c             	sub    $0x1c,%esp
  80358b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80358f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803593:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803597:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80359b:	89 ca                	mov    %ecx,%edx
  80359d:	89 f8                	mov    %edi,%eax
  80359f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8035a3:	85 f6                	test   %esi,%esi
  8035a5:	75 2d                	jne    8035d4 <__udivdi3+0x50>
  8035a7:	39 cf                	cmp    %ecx,%edi
  8035a9:	77 65                	ja     803610 <__udivdi3+0x8c>
  8035ab:	89 fd                	mov    %edi,%ebp
  8035ad:	85 ff                	test   %edi,%edi
  8035af:	75 0b                	jne    8035bc <__udivdi3+0x38>
  8035b1:	b8 01 00 00 00       	mov    $0x1,%eax
  8035b6:	31 d2                	xor    %edx,%edx
  8035b8:	f7 f7                	div    %edi
  8035ba:	89 c5                	mov    %eax,%ebp
  8035bc:	31 d2                	xor    %edx,%edx
  8035be:	89 c8                	mov    %ecx,%eax
  8035c0:	f7 f5                	div    %ebp
  8035c2:	89 c1                	mov    %eax,%ecx
  8035c4:	89 d8                	mov    %ebx,%eax
  8035c6:	f7 f5                	div    %ebp
  8035c8:	89 cf                	mov    %ecx,%edi
  8035ca:	89 fa                	mov    %edi,%edx
  8035cc:	83 c4 1c             	add    $0x1c,%esp
  8035cf:	5b                   	pop    %ebx
  8035d0:	5e                   	pop    %esi
  8035d1:	5f                   	pop    %edi
  8035d2:	5d                   	pop    %ebp
  8035d3:	c3                   	ret    
  8035d4:	39 ce                	cmp    %ecx,%esi
  8035d6:	77 28                	ja     803600 <__udivdi3+0x7c>
  8035d8:	0f bd fe             	bsr    %esi,%edi
  8035db:	83 f7 1f             	xor    $0x1f,%edi
  8035de:	75 40                	jne    803620 <__udivdi3+0x9c>
  8035e0:	39 ce                	cmp    %ecx,%esi
  8035e2:	72 0a                	jb     8035ee <__udivdi3+0x6a>
  8035e4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8035e8:	0f 87 9e 00 00 00    	ja     80368c <__udivdi3+0x108>
  8035ee:	b8 01 00 00 00       	mov    $0x1,%eax
  8035f3:	89 fa                	mov    %edi,%edx
  8035f5:	83 c4 1c             	add    $0x1c,%esp
  8035f8:	5b                   	pop    %ebx
  8035f9:	5e                   	pop    %esi
  8035fa:	5f                   	pop    %edi
  8035fb:	5d                   	pop    %ebp
  8035fc:	c3                   	ret    
  8035fd:	8d 76 00             	lea    0x0(%esi),%esi
  803600:	31 ff                	xor    %edi,%edi
  803602:	31 c0                	xor    %eax,%eax
  803604:	89 fa                	mov    %edi,%edx
  803606:	83 c4 1c             	add    $0x1c,%esp
  803609:	5b                   	pop    %ebx
  80360a:	5e                   	pop    %esi
  80360b:	5f                   	pop    %edi
  80360c:	5d                   	pop    %ebp
  80360d:	c3                   	ret    
  80360e:	66 90                	xchg   %ax,%ax
  803610:	89 d8                	mov    %ebx,%eax
  803612:	f7 f7                	div    %edi
  803614:	31 ff                	xor    %edi,%edi
  803616:	89 fa                	mov    %edi,%edx
  803618:	83 c4 1c             	add    $0x1c,%esp
  80361b:	5b                   	pop    %ebx
  80361c:	5e                   	pop    %esi
  80361d:	5f                   	pop    %edi
  80361e:	5d                   	pop    %ebp
  80361f:	c3                   	ret    
  803620:	bd 20 00 00 00       	mov    $0x20,%ebp
  803625:	89 eb                	mov    %ebp,%ebx
  803627:	29 fb                	sub    %edi,%ebx
  803629:	89 f9                	mov    %edi,%ecx
  80362b:	d3 e6                	shl    %cl,%esi
  80362d:	89 c5                	mov    %eax,%ebp
  80362f:	88 d9                	mov    %bl,%cl
  803631:	d3 ed                	shr    %cl,%ebp
  803633:	89 e9                	mov    %ebp,%ecx
  803635:	09 f1                	or     %esi,%ecx
  803637:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80363b:	89 f9                	mov    %edi,%ecx
  80363d:	d3 e0                	shl    %cl,%eax
  80363f:	89 c5                	mov    %eax,%ebp
  803641:	89 d6                	mov    %edx,%esi
  803643:	88 d9                	mov    %bl,%cl
  803645:	d3 ee                	shr    %cl,%esi
  803647:	89 f9                	mov    %edi,%ecx
  803649:	d3 e2                	shl    %cl,%edx
  80364b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80364f:	88 d9                	mov    %bl,%cl
  803651:	d3 e8                	shr    %cl,%eax
  803653:	09 c2                	or     %eax,%edx
  803655:	89 d0                	mov    %edx,%eax
  803657:	89 f2                	mov    %esi,%edx
  803659:	f7 74 24 0c          	divl   0xc(%esp)
  80365d:	89 d6                	mov    %edx,%esi
  80365f:	89 c3                	mov    %eax,%ebx
  803661:	f7 e5                	mul    %ebp
  803663:	39 d6                	cmp    %edx,%esi
  803665:	72 19                	jb     803680 <__udivdi3+0xfc>
  803667:	74 0b                	je     803674 <__udivdi3+0xf0>
  803669:	89 d8                	mov    %ebx,%eax
  80366b:	31 ff                	xor    %edi,%edi
  80366d:	e9 58 ff ff ff       	jmp    8035ca <__udivdi3+0x46>
  803672:	66 90                	xchg   %ax,%ax
  803674:	8b 54 24 08          	mov    0x8(%esp),%edx
  803678:	89 f9                	mov    %edi,%ecx
  80367a:	d3 e2                	shl    %cl,%edx
  80367c:	39 c2                	cmp    %eax,%edx
  80367e:	73 e9                	jae    803669 <__udivdi3+0xe5>
  803680:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803683:	31 ff                	xor    %edi,%edi
  803685:	e9 40 ff ff ff       	jmp    8035ca <__udivdi3+0x46>
  80368a:	66 90                	xchg   %ax,%ax
  80368c:	31 c0                	xor    %eax,%eax
  80368e:	e9 37 ff ff ff       	jmp    8035ca <__udivdi3+0x46>
  803693:	90                   	nop

00803694 <__umoddi3>:
  803694:	55                   	push   %ebp
  803695:	57                   	push   %edi
  803696:	56                   	push   %esi
  803697:	53                   	push   %ebx
  803698:	83 ec 1c             	sub    $0x1c,%esp
  80369b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80369f:	8b 74 24 34          	mov    0x34(%esp),%esi
  8036a3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8036a7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8036ab:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8036af:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8036b3:	89 f3                	mov    %esi,%ebx
  8036b5:	89 fa                	mov    %edi,%edx
  8036b7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8036bb:	89 34 24             	mov    %esi,(%esp)
  8036be:	85 c0                	test   %eax,%eax
  8036c0:	75 1a                	jne    8036dc <__umoddi3+0x48>
  8036c2:	39 f7                	cmp    %esi,%edi
  8036c4:	0f 86 a2 00 00 00    	jbe    80376c <__umoddi3+0xd8>
  8036ca:	89 c8                	mov    %ecx,%eax
  8036cc:	89 f2                	mov    %esi,%edx
  8036ce:	f7 f7                	div    %edi
  8036d0:	89 d0                	mov    %edx,%eax
  8036d2:	31 d2                	xor    %edx,%edx
  8036d4:	83 c4 1c             	add    $0x1c,%esp
  8036d7:	5b                   	pop    %ebx
  8036d8:	5e                   	pop    %esi
  8036d9:	5f                   	pop    %edi
  8036da:	5d                   	pop    %ebp
  8036db:	c3                   	ret    
  8036dc:	39 f0                	cmp    %esi,%eax
  8036de:	0f 87 ac 00 00 00    	ja     803790 <__umoddi3+0xfc>
  8036e4:	0f bd e8             	bsr    %eax,%ebp
  8036e7:	83 f5 1f             	xor    $0x1f,%ebp
  8036ea:	0f 84 ac 00 00 00    	je     80379c <__umoddi3+0x108>
  8036f0:	bf 20 00 00 00       	mov    $0x20,%edi
  8036f5:	29 ef                	sub    %ebp,%edi
  8036f7:	89 fe                	mov    %edi,%esi
  8036f9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8036fd:	89 e9                	mov    %ebp,%ecx
  8036ff:	d3 e0                	shl    %cl,%eax
  803701:	89 d7                	mov    %edx,%edi
  803703:	89 f1                	mov    %esi,%ecx
  803705:	d3 ef                	shr    %cl,%edi
  803707:	09 c7                	or     %eax,%edi
  803709:	89 e9                	mov    %ebp,%ecx
  80370b:	d3 e2                	shl    %cl,%edx
  80370d:	89 14 24             	mov    %edx,(%esp)
  803710:	89 d8                	mov    %ebx,%eax
  803712:	d3 e0                	shl    %cl,%eax
  803714:	89 c2                	mov    %eax,%edx
  803716:	8b 44 24 08          	mov    0x8(%esp),%eax
  80371a:	d3 e0                	shl    %cl,%eax
  80371c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803720:	8b 44 24 08          	mov    0x8(%esp),%eax
  803724:	89 f1                	mov    %esi,%ecx
  803726:	d3 e8                	shr    %cl,%eax
  803728:	09 d0                	or     %edx,%eax
  80372a:	d3 eb                	shr    %cl,%ebx
  80372c:	89 da                	mov    %ebx,%edx
  80372e:	f7 f7                	div    %edi
  803730:	89 d3                	mov    %edx,%ebx
  803732:	f7 24 24             	mull   (%esp)
  803735:	89 c6                	mov    %eax,%esi
  803737:	89 d1                	mov    %edx,%ecx
  803739:	39 d3                	cmp    %edx,%ebx
  80373b:	0f 82 87 00 00 00    	jb     8037c8 <__umoddi3+0x134>
  803741:	0f 84 91 00 00 00    	je     8037d8 <__umoddi3+0x144>
  803747:	8b 54 24 04          	mov    0x4(%esp),%edx
  80374b:	29 f2                	sub    %esi,%edx
  80374d:	19 cb                	sbb    %ecx,%ebx
  80374f:	89 d8                	mov    %ebx,%eax
  803751:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803755:	d3 e0                	shl    %cl,%eax
  803757:	89 e9                	mov    %ebp,%ecx
  803759:	d3 ea                	shr    %cl,%edx
  80375b:	09 d0                	or     %edx,%eax
  80375d:	89 e9                	mov    %ebp,%ecx
  80375f:	d3 eb                	shr    %cl,%ebx
  803761:	89 da                	mov    %ebx,%edx
  803763:	83 c4 1c             	add    $0x1c,%esp
  803766:	5b                   	pop    %ebx
  803767:	5e                   	pop    %esi
  803768:	5f                   	pop    %edi
  803769:	5d                   	pop    %ebp
  80376a:	c3                   	ret    
  80376b:	90                   	nop
  80376c:	89 fd                	mov    %edi,%ebp
  80376e:	85 ff                	test   %edi,%edi
  803770:	75 0b                	jne    80377d <__umoddi3+0xe9>
  803772:	b8 01 00 00 00       	mov    $0x1,%eax
  803777:	31 d2                	xor    %edx,%edx
  803779:	f7 f7                	div    %edi
  80377b:	89 c5                	mov    %eax,%ebp
  80377d:	89 f0                	mov    %esi,%eax
  80377f:	31 d2                	xor    %edx,%edx
  803781:	f7 f5                	div    %ebp
  803783:	89 c8                	mov    %ecx,%eax
  803785:	f7 f5                	div    %ebp
  803787:	89 d0                	mov    %edx,%eax
  803789:	e9 44 ff ff ff       	jmp    8036d2 <__umoddi3+0x3e>
  80378e:	66 90                	xchg   %ax,%ax
  803790:	89 c8                	mov    %ecx,%eax
  803792:	89 f2                	mov    %esi,%edx
  803794:	83 c4 1c             	add    $0x1c,%esp
  803797:	5b                   	pop    %ebx
  803798:	5e                   	pop    %esi
  803799:	5f                   	pop    %edi
  80379a:	5d                   	pop    %ebp
  80379b:	c3                   	ret    
  80379c:	3b 04 24             	cmp    (%esp),%eax
  80379f:	72 06                	jb     8037a7 <__umoddi3+0x113>
  8037a1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8037a5:	77 0f                	ja     8037b6 <__umoddi3+0x122>
  8037a7:	89 f2                	mov    %esi,%edx
  8037a9:	29 f9                	sub    %edi,%ecx
  8037ab:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8037af:	89 14 24             	mov    %edx,(%esp)
  8037b2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8037b6:	8b 44 24 04          	mov    0x4(%esp),%eax
  8037ba:	8b 14 24             	mov    (%esp),%edx
  8037bd:	83 c4 1c             	add    $0x1c,%esp
  8037c0:	5b                   	pop    %ebx
  8037c1:	5e                   	pop    %esi
  8037c2:	5f                   	pop    %edi
  8037c3:	5d                   	pop    %ebp
  8037c4:	c3                   	ret    
  8037c5:	8d 76 00             	lea    0x0(%esi),%esi
  8037c8:	2b 04 24             	sub    (%esp),%eax
  8037cb:	19 fa                	sbb    %edi,%edx
  8037cd:	89 d1                	mov    %edx,%ecx
  8037cf:	89 c6                	mov    %eax,%esi
  8037d1:	e9 71 ff ff ff       	jmp    803747 <__umoddi3+0xb3>
  8037d6:	66 90                	xchg   %ax,%ax
  8037d8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8037dc:	72 ea                	jb     8037c8 <__umoddi3+0x134>
  8037de:	89 d9                	mov    %ebx,%ecx
  8037e0:	e9 62 ff ff ff       	jmp    803747 <__umoddi3+0xb3>
