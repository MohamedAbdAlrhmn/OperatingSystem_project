
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
  80008d:	68 c0 37 80 00       	push   $0x8037c0
  800092:	6a 12                	push   $0x12
  800094:	68 dc 37 80 00       	push   $0x8037dc
  800099:	e8 38 04 00 00       	call   8004d6 <_panic>
	}

	uint32 *x, *y, *z ;
	cprintf("STEP A: checking the creation of shared variables... \n");
  80009e:	83 ec 0c             	sub    $0xc,%esp
  8000a1:	68 f4 37 80 00       	push   $0x8037f4
  8000a6:	e8 df 06 00 00       	call   80078a <cprintf>
  8000ab:	83 c4 10             	add    $0x10,%esp
	{
		int freeFrames = sys_calculate_free_frames() ;
  8000ae:	e8 e7 18 00 00       	call   80199a <sys_calculate_free_frames>
  8000b3:	89 45 e8             	mov    %eax,-0x18(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8000b6:	83 ec 04             	sub    $0x4,%esp
  8000b9:	6a 01                	push   $0x1
  8000bb:	68 00 10 00 00       	push   $0x1000
  8000c0:	68 2b 38 80 00       	push   $0x80382b
  8000c5:	e8 90 16 00 00       	call   80175a <smalloc>
  8000ca:	83 c4 10             	add    $0x10,%esp
  8000cd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (x != (uint32*)USER_HEAP_START) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  8000d0:	81 7d e4 00 00 00 80 	cmpl   $0x80000000,-0x1c(%ebp)
  8000d7:	74 14                	je     8000ed <_main+0xb5>
  8000d9:	83 ec 04             	sub    $0x4,%esp
  8000dc:	68 30 38 80 00       	push   $0x803830
  8000e1:	6a 1a                	push   $0x1a
  8000e3:	68 dc 37 80 00       	push   $0x8037dc
  8000e8:	e8 e9 03 00 00       	call   8004d6 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage %d %d %d", freeFrames, sys_calculate_free_frames(), freeFrames - sys_calculate_free_frames());
  8000ed:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8000f0:	e8 a5 18 00 00       	call   80199a <sys_calculate_free_frames>
  8000f5:	29 c3                	sub    %eax,%ebx
  8000f7:	89 d8                	mov    %ebx,%eax
  8000f9:	83 f8 04             	cmp    $0x4,%eax
  8000fc:	74 28                	je     800126 <_main+0xee>
  8000fe:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800101:	e8 94 18 00 00       	call   80199a <sys_calculate_free_frames>
  800106:	29 c3                	sub    %eax,%ebx
  800108:	e8 8d 18 00 00       	call   80199a <sys_calculate_free_frames>
  80010d:	83 ec 08             	sub    $0x8,%esp
  800110:	53                   	push   %ebx
  800111:	50                   	push   %eax
  800112:	ff 75 e8             	pushl  -0x18(%ebp)
  800115:	68 9c 38 80 00       	push   $0x80389c
  80011a:	6a 1b                	push   $0x1b
  80011c:	68 dc 37 80 00       	push   $0x8037dc
  800121:	e8 b0 03 00 00       	call   8004d6 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800126:	e8 6f 18 00 00       	call   80199a <sys_calculate_free_frames>
  80012b:	89 45 e8             	mov    %eax,-0x18(%ebp)
		z = smalloc("y", PAGE_SIZE + 4, 1);
  80012e:	83 ec 04             	sub    $0x4,%esp
  800131:	6a 01                	push   $0x1
  800133:	68 04 10 00 00       	push   $0x1004
  800138:	68 23 39 80 00       	push   $0x803923
  80013d:	e8 18 16 00 00       	call   80175a <smalloc>
  800142:	83 c4 10             	add    $0x10,%esp
  800145:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (z != (uint32*)(USER_HEAP_START + 1 * PAGE_SIZE)) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  800148:	81 7d e0 00 10 00 80 	cmpl   $0x80001000,-0x20(%ebp)
  80014f:	74 14                	je     800165 <_main+0x12d>
  800151:	83 ec 04             	sub    $0x4,%esp
  800154:	68 30 38 80 00       	push   $0x803830
  800159:	6a 1f                	push   $0x1f
  80015b:	68 dc 37 80 00       	push   $0x8037dc
  800160:	e8 71 03 00 00       	call   8004d6 <_panic>

		if ((freeFrames - sys_calculate_free_frames()) !=  2+0+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage %d %d %d", freeFrames, sys_calculate_free_frames(), freeFrames - sys_calculate_free_frames());
  800165:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800168:	e8 2d 18 00 00       	call   80199a <sys_calculate_free_frames>
  80016d:	29 c3                	sub    %eax,%ebx
  80016f:	89 d8                	mov    %ebx,%eax
  800171:	83 f8 04             	cmp    $0x4,%eax
  800174:	74 28                	je     80019e <_main+0x166>
  800176:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800179:	e8 1c 18 00 00       	call   80199a <sys_calculate_free_frames>
  80017e:	29 c3                	sub    %eax,%ebx
  800180:	e8 15 18 00 00       	call   80199a <sys_calculate_free_frames>
  800185:	83 ec 08             	sub    $0x8,%esp
  800188:	53                   	push   %ebx
  800189:	50                   	push   %eax
  80018a:	ff 75 e8             	pushl  -0x18(%ebp)
  80018d:	68 9c 38 80 00       	push   $0x80389c
  800192:	6a 21                	push   $0x21
  800194:	68 dc 37 80 00       	push   $0x8037dc
  800199:	e8 38 03 00 00       	call   8004d6 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  80019e:	e8 f7 17 00 00       	call   80199a <sys_calculate_free_frames>
  8001a3:	89 45 e8             	mov    %eax,-0x18(%ebp)
		y = smalloc("z", 4, 1);
  8001a6:	83 ec 04             	sub    $0x4,%esp
  8001a9:	6a 01                	push   $0x1
  8001ab:	6a 04                	push   $0x4
  8001ad:	68 25 39 80 00       	push   $0x803925
  8001b2:	e8 a3 15 00 00       	call   80175a <smalloc>
  8001b7:	83 c4 10             	add    $0x10,%esp
  8001ba:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (y != (uint32*)(USER_HEAP_START + 3 * PAGE_SIZE)) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  8001bd:	81 7d dc 00 30 00 80 	cmpl   $0x80003000,-0x24(%ebp)
  8001c4:	74 14                	je     8001da <_main+0x1a2>
  8001c6:	83 ec 04             	sub    $0x4,%esp
  8001c9:	68 30 38 80 00       	push   $0x803830
  8001ce:	6a 25                	push   $0x25
  8001d0:	68 dc 37 80 00       	push   $0x8037dc
  8001d5:	e8 fc 02 00 00       	call   8004d6 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  1+0+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  8001da:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8001dd:	e8 b8 17 00 00       	call   80199a <sys_calculate_free_frames>
  8001e2:	29 c3                	sub    %eax,%ebx
  8001e4:	89 d8                	mov    %ebx,%eax
  8001e6:	83 f8 03             	cmp    $0x3,%eax
  8001e9:	74 14                	je     8001ff <_main+0x1c7>
  8001eb:	83 ec 04             	sub    $0x4,%esp
  8001ee:	68 28 39 80 00       	push   $0x803928
  8001f3:	6a 26                	push   $0x26
  8001f5:	68 dc 37 80 00       	push   $0x8037dc
  8001fa:	e8 d7 02 00 00       	call   8004d6 <_panic>
	}
	cprintf("Step A is completed successfully!!\n\n\n");
  8001ff:	83 ec 0c             	sub    $0xc,%esp
  800202:	68 a8 39 80 00       	push   $0x8039a8
  800207:	e8 7e 05 00 00       	call   80078a <cprintf>
  80020c:	83 c4 10             	add    $0x10,%esp


	cprintf("STEP B: checking reading & writing... \n");
  80020f:	83 ec 0c             	sub    $0xc,%esp
  800212:	68 d0 39 80 00       	push   $0x8039d0
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
  800295:	68 f8 39 80 00       	push   $0x8039f8
  80029a:	6a 3a                	push   $0x3a
  80029c:	68 dc 37 80 00       	push   $0x8037dc
  8002a1:	e8 30 02 00 00       	call   8004d6 <_panic>
		if( x[PAGE_SIZE/4 - 1] !=  -1)  	panic("Reading/Writing of shared object is failed");
  8002a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002a9:	05 fc 0f 00 00       	add    $0xffc,%eax
  8002ae:	8b 00                	mov    (%eax),%eax
  8002b0:	83 f8 ff             	cmp    $0xffffffff,%eax
  8002b3:	74 14                	je     8002c9 <_main+0x291>
  8002b5:	83 ec 04             	sub    $0x4,%esp
  8002b8:	68 f8 39 80 00       	push   $0x8039f8
  8002bd:	6a 3b                	push   $0x3b
  8002bf:	68 dc 37 80 00       	push   $0x8037dc
  8002c4:	e8 0d 02 00 00       	call   8004d6 <_panic>

		if( y[0] !=  -1)  					panic("Reading/Writing of shared object is failed");
  8002c9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002cc:	8b 00                	mov    (%eax),%eax
  8002ce:	83 f8 ff             	cmp    $0xffffffff,%eax
  8002d1:	74 14                	je     8002e7 <_main+0x2af>
  8002d3:	83 ec 04             	sub    $0x4,%esp
  8002d6:	68 f8 39 80 00       	push   $0x8039f8
  8002db:	6a 3d                	push   $0x3d
  8002dd:	68 dc 37 80 00       	push   $0x8037dc
  8002e2:	e8 ef 01 00 00       	call   8004d6 <_panic>
		if( y[PAGE_SIZE/4 - 1] !=  -1)  	panic("Reading/Writing of shared object is failed");
  8002e7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002ea:	05 fc 0f 00 00       	add    $0xffc,%eax
  8002ef:	8b 00                	mov    (%eax),%eax
  8002f1:	83 f8 ff             	cmp    $0xffffffff,%eax
  8002f4:	74 14                	je     80030a <_main+0x2d2>
  8002f6:	83 ec 04             	sub    $0x4,%esp
  8002f9:	68 f8 39 80 00       	push   $0x8039f8
  8002fe:	6a 3e                	push   $0x3e
  800300:	68 dc 37 80 00       	push   $0x8037dc
  800305:	e8 cc 01 00 00       	call   8004d6 <_panic>

		if( z[0] !=  -1)  					panic("Reading/Writing of shared object is failed");
  80030a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80030d:	8b 00                	mov    (%eax),%eax
  80030f:	83 f8 ff             	cmp    $0xffffffff,%eax
  800312:	74 14                	je     800328 <_main+0x2f0>
  800314:	83 ec 04             	sub    $0x4,%esp
  800317:	68 f8 39 80 00       	push   $0x8039f8
  80031c:	6a 40                	push   $0x40
  80031e:	68 dc 37 80 00       	push   $0x8037dc
  800323:	e8 ae 01 00 00       	call   8004d6 <_panic>
		if( z[2*PAGE_SIZE/4 - 1] !=  -1)  	panic("Reading/Writing of shared object is failed");
  800328:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80032b:	05 fc 1f 00 00       	add    $0x1ffc,%eax
  800330:	8b 00                	mov    (%eax),%eax
  800332:	83 f8 ff             	cmp    $0xffffffff,%eax
  800335:	74 14                	je     80034b <_main+0x313>
  800337:	83 ec 04             	sub    $0x4,%esp
  80033a:	68 f8 39 80 00       	push   $0x8039f8
  80033f:	6a 41                	push   $0x41
  800341:	68 dc 37 80 00       	push   $0x8037dc
  800346:	e8 8b 01 00 00       	call   8004d6 <_panic>
	}

	cprintf("Congratulations!! Test of Shared Variables [Create] [1] completed successfully!!\n\n\n");
  80034b:	83 ec 0c             	sub    $0xc,%esp
  80034e:	68 24 3a 80 00       	push   $0x803a24
  800353:	e8 32 04 00 00       	call   80078a <cprintf>
  800358:	83 c4 10             	add    $0x10,%esp

	int32 parentenvID = sys_getparentenvid();
  80035b:	e8 33 19 00 00       	call   801c93 <sys_getparentenvid>
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
  800373:	68 78 3a 80 00       	push   $0x803a78
  800378:	ff 75 d8             	pushl  -0x28(%ebp)
  80037b:	e8 76 14 00 00       	call   8017f6 <sget>
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
  8003a0:	e8 d5 18 00 00       	call   801c7a <sys_getenvindex>
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
  80040b:	e8 77 16 00 00       	call   801a87 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800410:	83 ec 0c             	sub    $0xc,%esp
  800413:	68 a0 3a 80 00       	push   $0x803aa0
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
  80043b:	68 c8 3a 80 00       	push   $0x803ac8
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
  80046c:	68 f0 3a 80 00       	push   $0x803af0
  800471:	e8 14 03 00 00       	call   80078a <cprintf>
  800476:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800479:	a1 20 50 80 00       	mov    0x805020,%eax
  80047e:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800484:	83 ec 08             	sub    $0x8,%esp
  800487:	50                   	push   %eax
  800488:	68 48 3b 80 00       	push   $0x803b48
  80048d:	e8 f8 02 00 00       	call   80078a <cprintf>
  800492:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800495:	83 ec 0c             	sub    $0xc,%esp
  800498:	68 a0 3a 80 00       	push   $0x803aa0
  80049d:	e8 e8 02 00 00       	call   80078a <cprintf>
  8004a2:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8004a5:	e8 f7 15 00 00       	call   801aa1 <sys_enable_interrupt>

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
  8004bd:	e8 84 17 00 00       	call   801c46 <sys_destroy_env>
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
  8004ce:	e8 d9 17 00 00       	call   801cac <sys_exit_env>
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
  8004f7:	68 5c 3b 80 00       	push   $0x803b5c
  8004fc:	e8 89 02 00 00       	call   80078a <cprintf>
  800501:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800504:	a1 00 50 80 00       	mov    0x805000,%eax
  800509:	ff 75 0c             	pushl  0xc(%ebp)
  80050c:	ff 75 08             	pushl  0x8(%ebp)
  80050f:	50                   	push   %eax
  800510:	68 61 3b 80 00       	push   $0x803b61
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
  800534:	68 7d 3b 80 00       	push   $0x803b7d
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
  800560:	68 80 3b 80 00       	push   $0x803b80
  800565:	6a 26                	push   $0x26
  800567:	68 cc 3b 80 00       	push   $0x803bcc
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
  800632:	68 d8 3b 80 00       	push   $0x803bd8
  800637:	6a 3a                	push   $0x3a
  800639:	68 cc 3b 80 00       	push   $0x803bcc
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
  8006a2:	68 2c 3c 80 00       	push   $0x803c2c
  8006a7:	6a 44                	push   $0x44
  8006a9:	68 cc 3b 80 00       	push   $0x803bcc
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
  8006fc:	e8 d8 11 00 00       	call   8018d9 <sys_cputs>
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
  800773:	e8 61 11 00 00       	call   8018d9 <sys_cputs>
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
  8007bd:	e8 c5 12 00 00       	call   801a87 <sys_disable_interrupt>
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
  8007dd:	e8 bf 12 00 00       	call   801aa1 <sys_enable_interrupt>
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
  800827:	e8 30 2d 00 00       	call   80355c <__udivdi3>
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
  800877:	e8 f0 2d 00 00       	call   80366c <__umoddi3>
  80087c:	83 c4 10             	add    $0x10,%esp
  80087f:	05 94 3e 80 00       	add    $0x803e94,%eax
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
  8009d2:	8b 04 85 b8 3e 80 00 	mov    0x803eb8(,%eax,4),%eax
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
  800ab3:	8b 34 9d 00 3d 80 00 	mov    0x803d00(,%ebx,4),%esi
  800aba:	85 f6                	test   %esi,%esi
  800abc:	75 19                	jne    800ad7 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800abe:	53                   	push   %ebx
  800abf:	68 a5 3e 80 00       	push   $0x803ea5
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
  800ad8:	68 ae 3e 80 00       	push   $0x803eae
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
  800b05:	be b1 3e 80 00       	mov    $0x803eb1,%esi
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
  80152b:	68 10 40 80 00       	push   $0x804010
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
  8015fb:	e8 1d 04 00 00       	call   801a1d <sys_allocate_chunk>
  801600:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801603:	a1 20 51 80 00       	mov    0x805120,%eax
  801608:	83 ec 0c             	sub    $0xc,%esp
  80160b:	50                   	push   %eax
  80160c:	e8 92 0a 00 00       	call   8020a3 <initialize_MemBlocksList>
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
  801639:	68 35 40 80 00       	push   $0x804035
  80163e:	6a 33                	push   $0x33
  801640:	68 53 40 80 00       	push   $0x804053
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
  8016b8:	68 60 40 80 00       	push   $0x804060
  8016bd:	6a 34                	push   $0x34
  8016bf:	68 53 40 80 00       	push   $0x804053
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
  80172d:	68 84 40 80 00       	push   $0x804084
  801732:	6a 46                	push   $0x46
  801734:	68 53 40 80 00       	push   $0x804053
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
  801749:	68 ac 40 80 00       	push   $0x8040ac
  80174e:	6a 61                	push   $0x61
  801750:	68 53 40 80 00       	push   $0x804053
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
  80176f:	75 07                	jne    801778 <smalloc+0x1e>
  801771:	b8 00 00 00 00       	mov    $0x0,%eax
  801776:	eb 7c                	jmp    8017f4 <smalloc+0x9a>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801778:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80177f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801782:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801785:	01 d0                	add    %edx,%eax
  801787:	48                   	dec    %eax
  801788:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80178b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80178e:	ba 00 00 00 00       	mov    $0x0,%edx
  801793:	f7 75 f0             	divl   -0x10(%ebp)
  801796:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801799:	29 d0                	sub    %edx,%eax
  80179b:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  80179e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  8017a5:	e8 41 06 00 00       	call   801deb <sys_isUHeapPlacementStrategyFIRSTFIT>
  8017aa:	85 c0                	test   %eax,%eax
  8017ac:	74 11                	je     8017bf <smalloc+0x65>
		mem_block = alloc_block_FF(allocate_space);
  8017ae:	83 ec 0c             	sub    $0xc,%esp
  8017b1:	ff 75 e8             	pushl  -0x18(%ebp)
  8017b4:	e8 ac 0c 00 00       	call   802465 <alloc_block_FF>
  8017b9:	83 c4 10             	add    $0x10,%esp
  8017bc:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  8017bf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8017c3:	74 2a                	je     8017ef <smalloc+0x95>
	{
		virtual_address = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  8017c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017c8:	8b 40 08             	mov    0x8(%eax),%eax
  8017cb:	89 c2                	mov    %eax,%edx
  8017cd:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8017d1:	52                   	push   %edx
  8017d2:	50                   	push   %eax
  8017d3:	ff 75 0c             	pushl  0xc(%ebp)
  8017d6:	ff 75 08             	pushl  0x8(%ebp)
  8017d9:	e8 92 03 00 00       	call   801b70 <sys_createSharedObject>
  8017de:	83 c4 10             	add    $0x10,%esp
  8017e1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (virtual_address != -1)
  8017e4:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  8017e8:	74 05                	je     8017ef <smalloc+0x95>
			return (void*)virtual_address;
  8017ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017ed:	eb 05                	jmp    8017f4 <smalloc+0x9a>
	}
	return NULL;
  8017ef:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8017f4:	c9                   	leave  
  8017f5:	c3                   	ret    

008017f6 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8017f6:	55                   	push   %ebp
  8017f7:	89 e5                	mov    %esp,%ebp
  8017f9:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8017fc:	e8 13 fd ff ff       	call   801514 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801801:	83 ec 04             	sub    $0x4,%esp
  801804:	68 d0 40 80 00       	push   $0x8040d0
  801809:	68 a2 00 00 00       	push   $0xa2
  80180e:	68 53 40 80 00       	push   $0x804053
  801813:	e8 be ec ff ff       	call   8004d6 <_panic>

00801818 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801818:	55                   	push   %ebp
  801819:	89 e5                	mov    %esp,%ebp
  80181b:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80181e:	e8 f1 fc ff ff       	call   801514 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801823:	83 ec 04             	sub    $0x4,%esp
  801826:	68 f4 40 80 00       	push   $0x8040f4
  80182b:	68 e6 00 00 00       	push   $0xe6
  801830:	68 53 40 80 00       	push   $0x804053
  801835:	e8 9c ec ff ff       	call   8004d6 <_panic>

0080183a <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80183a:	55                   	push   %ebp
  80183b:	89 e5                	mov    %esp,%ebp
  80183d:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801840:	83 ec 04             	sub    $0x4,%esp
  801843:	68 1c 41 80 00       	push   $0x80411c
  801848:	68 fa 00 00 00       	push   $0xfa
  80184d:	68 53 40 80 00       	push   $0x804053
  801852:	e8 7f ec ff ff       	call   8004d6 <_panic>

00801857 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801857:	55                   	push   %ebp
  801858:	89 e5                	mov    %esp,%ebp
  80185a:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80185d:	83 ec 04             	sub    $0x4,%esp
  801860:	68 40 41 80 00       	push   $0x804140
  801865:	68 05 01 00 00       	push   $0x105
  80186a:	68 53 40 80 00       	push   $0x804053
  80186f:	e8 62 ec ff ff       	call   8004d6 <_panic>

00801874 <shrink>:

}
void shrink(uint32 newSize)
{
  801874:	55                   	push   %ebp
  801875:	89 e5                	mov    %esp,%ebp
  801877:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80187a:	83 ec 04             	sub    $0x4,%esp
  80187d:	68 40 41 80 00       	push   $0x804140
  801882:	68 0a 01 00 00       	push   $0x10a
  801887:	68 53 40 80 00       	push   $0x804053
  80188c:	e8 45 ec ff ff       	call   8004d6 <_panic>

00801891 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801891:	55                   	push   %ebp
  801892:	89 e5                	mov    %esp,%ebp
  801894:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801897:	83 ec 04             	sub    $0x4,%esp
  80189a:	68 40 41 80 00       	push   $0x804140
  80189f:	68 0f 01 00 00       	push   $0x10f
  8018a4:	68 53 40 80 00       	push   $0x804053
  8018a9:	e8 28 ec ff ff       	call   8004d6 <_panic>

008018ae <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8018ae:	55                   	push   %ebp
  8018af:	89 e5                	mov    %esp,%ebp
  8018b1:	57                   	push   %edi
  8018b2:	56                   	push   %esi
  8018b3:	53                   	push   %ebx
  8018b4:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8018b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018bd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018c0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018c3:	8b 7d 18             	mov    0x18(%ebp),%edi
  8018c6:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8018c9:	cd 30                	int    $0x30
  8018cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8018ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8018d1:	83 c4 10             	add    $0x10,%esp
  8018d4:	5b                   	pop    %ebx
  8018d5:	5e                   	pop    %esi
  8018d6:	5f                   	pop    %edi
  8018d7:	5d                   	pop    %ebp
  8018d8:	c3                   	ret    

008018d9 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8018d9:	55                   	push   %ebp
  8018da:	89 e5                	mov    %esp,%ebp
  8018dc:	83 ec 04             	sub    $0x4,%esp
  8018df:	8b 45 10             	mov    0x10(%ebp),%eax
  8018e2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8018e5:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8018e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ec:	6a 00                	push   $0x0
  8018ee:	6a 00                	push   $0x0
  8018f0:	52                   	push   %edx
  8018f1:	ff 75 0c             	pushl  0xc(%ebp)
  8018f4:	50                   	push   %eax
  8018f5:	6a 00                	push   $0x0
  8018f7:	e8 b2 ff ff ff       	call   8018ae <syscall>
  8018fc:	83 c4 18             	add    $0x18,%esp
}
  8018ff:	90                   	nop
  801900:	c9                   	leave  
  801901:	c3                   	ret    

00801902 <sys_cgetc>:

int
sys_cgetc(void)
{
  801902:	55                   	push   %ebp
  801903:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801905:	6a 00                	push   $0x0
  801907:	6a 00                	push   $0x0
  801909:	6a 00                	push   $0x0
  80190b:	6a 00                	push   $0x0
  80190d:	6a 00                	push   $0x0
  80190f:	6a 01                	push   $0x1
  801911:	e8 98 ff ff ff       	call   8018ae <syscall>
  801916:	83 c4 18             	add    $0x18,%esp
}
  801919:	c9                   	leave  
  80191a:	c3                   	ret    

0080191b <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80191b:	55                   	push   %ebp
  80191c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80191e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801921:	8b 45 08             	mov    0x8(%ebp),%eax
  801924:	6a 00                	push   $0x0
  801926:	6a 00                	push   $0x0
  801928:	6a 00                	push   $0x0
  80192a:	52                   	push   %edx
  80192b:	50                   	push   %eax
  80192c:	6a 05                	push   $0x5
  80192e:	e8 7b ff ff ff       	call   8018ae <syscall>
  801933:	83 c4 18             	add    $0x18,%esp
}
  801936:	c9                   	leave  
  801937:	c3                   	ret    

00801938 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801938:	55                   	push   %ebp
  801939:	89 e5                	mov    %esp,%ebp
  80193b:	56                   	push   %esi
  80193c:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80193d:	8b 75 18             	mov    0x18(%ebp),%esi
  801940:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801943:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801946:	8b 55 0c             	mov    0xc(%ebp),%edx
  801949:	8b 45 08             	mov    0x8(%ebp),%eax
  80194c:	56                   	push   %esi
  80194d:	53                   	push   %ebx
  80194e:	51                   	push   %ecx
  80194f:	52                   	push   %edx
  801950:	50                   	push   %eax
  801951:	6a 06                	push   $0x6
  801953:	e8 56 ff ff ff       	call   8018ae <syscall>
  801958:	83 c4 18             	add    $0x18,%esp
}
  80195b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80195e:	5b                   	pop    %ebx
  80195f:	5e                   	pop    %esi
  801960:	5d                   	pop    %ebp
  801961:	c3                   	ret    

00801962 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801962:	55                   	push   %ebp
  801963:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801965:	8b 55 0c             	mov    0xc(%ebp),%edx
  801968:	8b 45 08             	mov    0x8(%ebp),%eax
  80196b:	6a 00                	push   $0x0
  80196d:	6a 00                	push   $0x0
  80196f:	6a 00                	push   $0x0
  801971:	52                   	push   %edx
  801972:	50                   	push   %eax
  801973:	6a 07                	push   $0x7
  801975:	e8 34 ff ff ff       	call   8018ae <syscall>
  80197a:	83 c4 18             	add    $0x18,%esp
}
  80197d:	c9                   	leave  
  80197e:	c3                   	ret    

0080197f <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80197f:	55                   	push   %ebp
  801980:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801982:	6a 00                	push   $0x0
  801984:	6a 00                	push   $0x0
  801986:	6a 00                	push   $0x0
  801988:	ff 75 0c             	pushl  0xc(%ebp)
  80198b:	ff 75 08             	pushl  0x8(%ebp)
  80198e:	6a 08                	push   $0x8
  801990:	e8 19 ff ff ff       	call   8018ae <syscall>
  801995:	83 c4 18             	add    $0x18,%esp
}
  801998:	c9                   	leave  
  801999:	c3                   	ret    

0080199a <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80199a:	55                   	push   %ebp
  80199b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80199d:	6a 00                	push   $0x0
  80199f:	6a 00                	push   $0x0
  8019a1:	6a 00                	push   $0x0
  8019a3:	6a 00                	push   $0x0
  8019a5:	6a 00                	push   $0x0
  8019a7:	6a 09                	push   $0x9
  8019a9:	e8 00 ff ff ff       	call   8018ae <syscall>
  8019ae:	83 c4 18             	add    $0x18,%esp
}
  8019b1:	c9                   	leave  
  8019b2:	c3                   	ret    

008019b3 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8019b3:	55                   	push   %ebp
  8019b4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8019b6:	6a 00                	push   $0x0
  8019b8:	6a 00                	push   $0x0
  8019ba:	6a 00                	push   $0x0
  8019bc:	6a 00                	push   $0x0
  8019be:	6a 00                	push   $0x0
  8019c0:	6a 0a                	push   $0xa
  8019c2:	e8 e7 fe ff ff       	call   8018ae <syscall>
  8019c7:	83 c4 18             	add    $0x18,%esp
}
  8019ca:	c9                   	leave  
  8019cb:	c3                   	ret    

008019cc <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8019cc:	55                   	push   %ebp
  8019cd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8019cf:	6a 00                	push   $0x0
  8019d1:	6a 00                	push   $0x0
  8019d3:	6a 00                	push   $0x0
  8019d5:	6a 00                	push   $0x0
  8019d7:	6a 00                	push   $0x0
  8019d9:	6a 0b                	push   $0xb
  8019db:	e8 ce fe ff ff       	call   8018ae <syscall>
  8019e0:	83 c4 18             	add    $0x18,%esp
}
  8019e3:	c9                   	leave  
  8019e4:	c3                   	ret    

008019e5 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8019e5:	55                   	push   %ebp
  8019e6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8019e8:	6a 00                	push   $0x0
  8019ea:	6a 00                	push   $0x0
  8019ec:	6a 00                	push   $0x0
  8019ee:	ff 75 0c             	pushl  0xc(%ebp)
  8019f1:	ff 75 08             	pushl  0x8(%ebp)
  8019f4:	6a 0f                	push   $0xf
  8019f6:	e8 b3 fe ff ff       	call   8018ae <syscall>
  8019fb:	83 c4 18             	add    $0x18,%esp
	return;
  8019fe:	90                   	nop
}
  8019ff:	c9                   	leave  
  801a00:	c3                   	ret    

00801a01 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801a01:	55                   	push   %ebp
  801a02:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801a04:	6a 00                	push   $0x0
  801a06:	6a 00                	push   $0x0
  801a08:	6a 00                	push   $0x0
  801a0a:	ff 75 0c             	pushl  0xc(%ebp)
  801a0d:	ff 75 08             	pushl  0x8(%ebp)
  801a10:	6a 10                	push   $0x10
  801a12:	e8 97 fe ff ff       	call   8018ae <syscall>
  801a17:	83 c4 18             	add    $0x18,%esp
	return ;
  801a1a:	90                   	nop
}
  801a1b:	c9                   	leave  
  801a1c:	c3                   	ret    

00801a1d <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801a1d:	55                   	push   %ebp
  801a1e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801a20:	6a 00                	push   $0x0
  801a22:	6a 00                	push   $0x0
  801a24:	ff 75 10             	pushl  0x10(%ebp)
  801a27:	ff 75 0c             	pushl  0xc(%ebp)
  801a2a:	ff 75 08             	pushl  0x8(%ebp)
  801a2d:	6a 11                	push   $0x11
  801a2f:	e8 7a fe ff ff       	call   8018ae <syscall>
  801a34:	83 c4 18             	add    $0x18,%esp
	return ;
  801a37:	90                   	nop
}
  801a38:	c9                   	leave  
  801a39:	c3                   	ret    

00801a3a <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801a3a:	55                   	push   %ebp
  801a3b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801a3d:	6a 00                	push   $0x0
  801a3f:	6a 00                	push   $0x0
  801a41:	6a 00                	push   $0x0
  801a43:	6a 00                	push   $0x0
  801a45:	6a 00                	push   $0x0
  801a47:	6a 0c                	push   $0xc
  801a49:	e8 60 fe ff ff       	call   8018ae <syscall>
  801a4e:	83 c4 18             	add    $0x18,%esp
}
  801a51:	c9                   	leave  
  801a52:	c3                   	ret    

00801a53 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801a53:	55                   	push   %ebp
  801a54:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801a56:	6a 00                	push   $0x0
  801a58:	6a 00                	push   $0x0
  801a5a:	6a 00                	push   $0x0
  801a5c:	6a 00                	push   $0x0
  801a5e:	ff 75 08             	pushl  0x8(%ebp)
  801a61:	6a 0d                	push   $0xd
  801a63:	e8 46 fe ff ff       	call   8018ae <syscall>
  801a68:	83 c4 18             	add    $0x18,%esp
}
  801a6b:	c9                   	leave  
  801a6c:	c3                   	ret    

00801a6d <sys_scarce_memory>:

void sys_scarce_memory()
{
  801a6d:	55                   	push   %ebp
  801a6e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801a70:	6a 00                	push   $0x0
  801a72:	6a 00                	push   $0x0
  801a74:	6a 00                	push   $0x0
  801a76:	6a 00                	push   $0x0
  801a78:	6a 00                	push   $0x0
  801a7a:	6a 0e                	push   $0xe
  801a7c:	e8 2d fe ff ff       	call   8018ae <syscall>
  801a81:	83 c4 18             	add    $0x18,%esp
}
  801a84:	90                   	nop
  801a85:	c9                   	leave  
  801a86:	c3                   	ret    

00801a87 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801a87:	55                   	push   %ebp
  801a88:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801a8a:	6a 00                	push   $0x0
  801a8c:	6a 00                	push   $0x0
  801a8e:	6a 00                	push   $0x0
  801a90:	6a 00                	push   $0x0
  801a92:	6a 00                	push   $0x0
  801a94:	6a 13                	push   $0x13
  801a96:	e8 13 fe ff ff       	call   8018ae <syscall>
  801a9b:	83 c4 18             	add    $0x18,%esp
}
  801a9e:	90                   	nop
  801a9f:	c9                   	leave  
  801aa0:	c3                   	ret    

00801aa1 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801aa1:	55                   	push   %ebp
  801aa2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801aa4:	6a 00                	push   $0x0
  801aa6:	6a 00                	push   $0x0
  801aa8:	6a 00                	push   $0x0
  801aaa:	6a 00                	push   $0x0
  801aac:	6a 00                	push   $0x0
  801aae:	6a 14                	push   $0x14
  801ab0:	e8 f9 fd ff ff       	call   8018ae <syscall>
  801ab5:	83 c4 18             	add    $0x18,%esp
}
  801ab8:	90                   	nop
  801ab9:	c9                   	leave  
  801aba:	c3                   	ret    

00801abb <sys_cputc>:


void
sys_cputc(const char c)
{
  801abb:	55                   	push   %ebp
  801abc:	89 e5                	mov    %esp,%ebp
  801abe:	83 ec 04             	sub    $0x4,%esp
  801ac1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801ac7:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801acb:	6a 00                	push   $0x0
  801acd:	6a 00                	push   $0x0
  801acf:	6a 00                	push   $0x0
  801ad1:	6a 00                	push   $0x0
  801ad3:	50                   	push   %eax
  801ad4:	6a 15                	push   $0x15
  801ad6:	e8 d3 fd ff ff       	call   8018ae <syscall>
  801adb:	83 c4 18             	add    $0x18,%esp
}
  801ade:	90                   	nop
  801adf:	c9                   	leave  
  801ae0:	c3                   	ret    

00801ae1 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801ae1:	55                   	push   %ebp
  801ae2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801ae4:	6a 00                	push   $0x0
  801ae6:	6a 00                	push   $0x0
  801ae8:	6a 00                	push   $0x0
  801aea:	6a 00                	push   $0x0
  801aec:	6a 00                	push   $0x0
  801aee:	6a 16                	push   $0x16
  801af0:	e8 b9 fd ff ff       	call   8018ae <syscall>
  801af5:	83 c4 18             	add    $0x18,%esp
}
  801af8:	90                   	nop
  801af9:	c9                   	leave  
  801afa:	c3                   	ret    

00801afb <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801afb:	55                   	push   %ebp
  801afc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801afe:	8b 45 08             	mov    0x8(%ebp),%eax
  801b01:	6a 00                	push   $0x0
  801b03:	6a 00                	push   $0x0
  801b05:	6a 00                	push   $0x0
  801b07:	ff 75 0c             	pushl  0xc(%ebp)
  801b0a:	50                   	push   %eax
  801b0b:	6a 17                	push   $0x17
  801b0d:	e8 9c fd ff ff       	call   8018ae <syscall>
  801b12:	83 c4 18             	add    $0x18,%esp
}
  801b15:	c9                   	leave  
  801b16:	c3                   	ret    

00801b17 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801b17:	55                   	push   %ebp
  801b18:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b1a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b20:	6a 00                	push   $0x0
  801b22:	6a 00                	push   $0x0
  801b24:	6a 00                	push   $0x0
  801b26:	52                   	push   %edx
  801b27:	50                   	push   %eax
  801b28:	6a 1a                	push   $0x1a
  801b2a:	e8 7f fd ff ff       	call   8018ae <syscall>
  801b2f:	83 c4 18             	add    $0x18,%esp
}
  801b32:	c9                   	leave  
  801b33:	c3                   	ret    

00801b34 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b34:	55                   	push   %ebp
  801b35:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b37:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3d:	6a 00                	push   $0x0
  801b3f:	6a 00                	push   $0x0
  801b41:	6a 00                	push   $0x0
  801b43:	52                   	push   %edx
  801b44:	50                   	push   %eax
  801b45:	6a 18                	push   $0x18
  801b47:	e8 62 fd ff ff       	call   8018ae <syscall>
  801b4c:	83 c4 18             	add    $0x18,%esp
}
  801b4f:	90                   	nop
  801b50:	c9                   	leave  
  801b51:	c3                   	ret    

00801b52 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b52:	55                   	push   %ebp
  801b53:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b55:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b58:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5b:	6a 00                	push   $0x0
  801b5d:	6a 00                	push   $0x0
  801b5f:	6a 00                	push   $0x0
  801b61:	52                   	push   %edx
  801b62:	50                   	push   %eax
  801b63:	6a 19                	push   $0x19
  801b65:	e8 44 fd ff ff       	call   8018ae <syscall>
  801b6a:	83 c4 18             	add    $0x18,%esp
}
  801b6d:	90                   	nop
  801b6e:	c9                   	leave  
  801b6f:	c3                   	ret    

00801b70 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801b70:	55                   	push   %ebp
  801b71:	89 e5                	mov    %esp,%ebp
  801b73:	83 ec 04             	sub    $0x4,%esp
  801b76:	8b 45 10             	mov    0x10(%ebp),%eax
  801b79:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b7c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b7f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b83:	8b 45 08             	mov    0x8(%ebp),%eax
  801b86:	6a 00                	push   $0x0
  801b88:	51                   	push   %ecx
  801b89:	52                   	push   %edx
  801b8a:	ff 75 0c             	pushl  0xc(%ebp)
  801b8d:	50                   	push   %eax
  801b8e:	6a 1b                	push   $0x1b
  801b90:	e8 19 fd ff ff       	call   8018ae <syscall>
  801b95:	83 c4 18             	add    $0x18,%esp
}
  801b98:	c9                   	leave  
  801b99:	c3                   	ret    

00801b9a <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801b9a:	55                   	push   %ebp
  801b9b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b9d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ba0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba3:	6a 00                	push   $0x0
  801ba5:	6a 00                	push   $0x0
  801ba7:	6a 00                	push   $0x0
  801ba9:	52                   	push   %edx
  801baa:	50                   	push   %eax
  801bab:	6a 1c                	push   $0x1c
  801bad:	e8 fc fc ff ff       	call   8018ae <syscall>
  801bb2:	83 c4 18             	add    $0x18,%esp
}
  801bb5:	c9                   	leave  
  801bb6:	c3                   	ret    

00801bb7 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801bb7:	55                   	push   %ebp
  801bb8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801bba:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801bbd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bc0:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc3:	6a 00                	push   $0x0
  801bc5:	6a 00                	push   $0x0
  801bc7:	51                   	push   %ecx
  801bc8:	52                   	push   %edx
  801bc9:	50                   	push   %eax
  801bca:	6a 1d                	push   $0x1d
  801bcc:	e8 dd fc ff ff       	call   8018ae <syscall>
  801bd1:	83 c4 18             	add    $0x18,%esp
}
  801bd4:	c9                   	leave  
  801bd5:	c3                   	ret    

00801bd6 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801bd6:	55                   	push   %ebp
  801bd7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801bd9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bdc:	8b 45 08             	mov    0x8(%ebp),%eax
  801bdf:	6a 00                	push   $0x0
  801be1:	6a 00                	push   $0x0
  801be3:	6a 00                	push   $0x0
  801be5:	52                   	push   %edx
  801be6:	50                   	push   %eax
  801be7:	6a 1e                	push   $0x1e
  801be9:	e8 c0 fc ff ff       	call   8018ae <syscall>
  801bee:	83 c4 18             	add    $0x18,%esp
}
  801bf1:	c9                   	leave  
  801bf2:	c3                   	ret    

00801bf3 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801bf3:	55                   	push   %ebp
  801bf4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801bf6:	6a 00                	push   $0x0
  801bf8:	6a 00                	push   $0x0
  801bfa:	6a 00                	push   $0x0
  801bfc:	6a 00                	push   $0x0
  801bfe:	6a 00                	push   $0x0
  801c00:	6a 1f                	push   $0x1f
  801c02:	e8 a7 fc ff ff       	call   8018ae <syscall>
  801c07:	83 c4 18             	add    $0x18,%esp
}
  801c0a:	c9                   	leave  
  801c0b:	c3                   	ret    

00801c0c <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801c0c:	55                   	push   %ebp
  801c0d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801c0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c12:	6a 00                	push   $0x0
  801c14:	ff 75 14             	pushl  0x14(%ebp)
  801c17:	ff 75 10             	pushl  0x10(%ebp)
  801c1a:	ff 75 0c             	pushl  0xc(%ebp)
  801c1d:	50                   	push   %eax
  801c1e:	6a 20                	push   $0x20
  801c20:	e8 89 fc ff ff       	call   8018ae <syscall>
  801c25:	83 c4 18             	add    $0x18,%esp
}
  801c28:	c9                   	leave  
  801c29:	c3                   	ret    

00801c2a <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801c2a:	55                   	push   %ebp
  801c2b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801c2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c30:	6a 00                	push   $0x0
  801c32:	6a 00                	push   $0x0
  801c34:	6a 00                	push   $0x0
  801c36:	6a 00                	push   $0x0
  801c38:	50                   	push   %eax
  801c39:	6a 21                	push   $0x21
  801c3b:	e8 6e fc ff ff       	call   8018ae <syscall>
  801c40:	83 c4 18             	add    $0x18,%esp
}
  801c43:	90                   	nop
  801c44:	c9                   	leave  
  801c45:	c3                   	ret    

00801c46 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801c46:	55                   	push   %ebp
  801c47:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801c49:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4c:	6a 00                	push   $0x0
  801c4e:	6a 00                	push   $0x0
  801c50:	6a 00                	push   $0x0
  801c52:	6a 00                	push   $0x0
  801c54:	50                   	push   %eax
  801c55:	6a 22                	push   $0x22
  801c57:	e8 52 fc ff ff       	call   8018ae <syscall>
  801c5c:	83 c4 18             	add    $0x18,%esp
}
  801c5f:	c9                   	leave  
  801c60:	c3                   	ret    

00801c61 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801c61:	55                   	push   %ebp
  801c62:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801c64:	6a 00                	push   $0x0
  801c66:	6a 00                	push   $0x0
  801c68:	6a 00                	push   $0x0
  801c6a:	6a 00                	push   $0x0
  801c6c:	6a 00                	push   $0x0
  801c6e:	6a 02                	push   $0x2
  801c70:	e8 39 fc ff ff       	call   8018ae <syscall>
  801c75:	83 c4 18             	add    $0x18,%esp
}
  801c78:	c9                   	leave  
  801c79:	c3                   	ret    

00801c7a <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c7a:	55                   	push   %ebp
  801c7b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c7d:	6a 00                	push   $0x0
  801c7f:	6a 00                	push   $0x0
  801c81:	6a 00                	push   $0x0
  801c83:	6a 00                	push   $0x0
  801c85:	6a 00                	push   $0x0
  801c87:	6a 03                	push   $0x3
  801c89:	e8 20 fc ff ff       	call   8018ae <syscall>
  801c8e:	83 c4 18             	add    $0x18,%esp
}
  801c91:	c9                   	leave  
  801c92:	c3                   	ret    

00801c93 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c93:	55                   	push   %ebp
  801c94:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c96:	6a 00                	push   $0x0
  801c98:	6a 00                	push   $0x0
  801c9a:	6a 00                	push   $0x0
  801c9c:	6a 00                	push   $0x0
  801c9e:	6a 00                	push   $0x0
  801ca0:	6a 04                	push   $0x4
  801ca2:	e8 07 fc ff ff       	call   8018ae <syscall>
  801ca7:	83 c4 18             	add    $0x18,%esp
}
  801caa:	c9                   	leave  
  801cab:	c3                   	ret    

00801cac <sys_exit_env>:


void sys_exit_env(void)
{
  801cac:	55                   	push   %ebp
  801cad:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801caf:	6a 00                	push   $0x0
  801cb1:	6a 00                	push   $0x0
  801cb3:	6a 00                	push   $0x0
  801cb5:	6a 00                	push   $0x0
  801cb7:	6a 00                	push   $0x0
  801cb9:	6a 23                	push   $0x23
  801cbb:	e8 ee fb ff ff       	call   8018ae <syscall>
  801cc0:	83 c4 18             	add    $0x18,%esp
}
  801cc3:	90                   	nop
  801cc4:	c9                   	leave  
  801cc5:	c3                   	ret    

00801cc6 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801cc6:	55                   	push   %ebp
  801cc7:	89 e5                	mov    %esp,%ebp
  801cc9:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801ccc:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ccf:	8d 50 04             	lea    0x4(%eax),%edx
  801cd2:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801cd5:	6a 00                	push   $0x0
  801cd7:	6a 00                	push   $0x0
  801cd9:	6a 00                	push   $0x0
  801cdb:	52                   	push   %edx
  801cdc:	50                   	push   %eax
  801cdd:	6a 24                	push   $0x24
  801cdf:	e8 ca fb ff ff       	call   8018ae <syscall>
  801ce4:	83 c4 18             	add    $0x18,%esp
	return result;
  801ce7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801cea:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ced:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801cf0:	89 01                	mov    %eax,(%ecx)
  801cf2:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801cf5:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf8:	c9                   	leave  
  801cf9:	c2 04 00             	ret    $0x4

00801cfc <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801cfc:	55                   	push   %ebp
  801cfd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801cff:	6a 00                	push   $0x0
  801d01:	6a 00                	push   $0x0
  801d03:	ff 75 10             	pushl  0x10(%ebp)
  801d06:	ff 75 0c             	pushl  0xc(%ebp)
  801d09:	ff 75 08             	pushl  0x8(%ebp)
  801d0c:	6a 12                	push   $0x12
  801d0e:	e8 9b fb ff ff       	call   8018ae <syscall>
  801d13:	83 c4 18             	add    $0x18,%esp
	return ;
  801d16:	90                   	nop
}
  801d17:	c9                   	leave  
  801d18:	c3                   	ret    

00801d19 <sys_rcr2>:
uint32 sys_rcr2()
{
  801d19:	55                   	push   %ebp
  801d1a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801d1c:	6a 00                	push   $0x0
  801d1e:	6a 00                	push   $0x0
  801d20:	6a 00                	push   $0x0
  801d22:	6a 00                	push   $0x0
  801d24:	6a 00                	push   $0x0
  801d26:	6a 25                	push   $0x25
  801d28:	e8 81 fb ff ff       	call   8018ae <syscall>
  801d2d:	83 c4 18             	add    $0x18,%esp
}
  801d30:	c9                   	leave  
  801d31:	c3                   	ret    

00801d32 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801d32:	55                   	push   %ebp
  801d33:	89 e5                	mov    %esp,%ebp
  801d35:	83 ec 04             	sub    $0x4,%esp
  801d38:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801d3e:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801d42:	6a 00                	push   $0x0
  801d44:	6a 00                	push   $0x0
  801d46:	6a 00                	push   $0x0
  801d48:	6a 00                	push   $0x0
  801d4a:	50                   	push   %eax
  801d4b:	6a 26                	push   $0x26
  801d4d:	e8 5c fb ff ff       	call   8018ae <syscall>
  801d52:	83 c4 18             	add    $0x18,%esp
	return ;
  801d55:	90                   	nop
}
  801d56:	c9                   	leave  
  801d57:	c3                   	ret    

00801d58 <rsttst>:
void rsttst()
{
  801d58:	55                   	push   %ebp
  801d59:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801d5b:	6a 00                	push   $0x0
  801d5d:	6a 00                	push   $0x0
  801d5f:	6a 00                	push   $0x0
  801d61:	6a 00                	push   $0x0
  801d63:	6a 00                	push   $0x0
  801d65:	6a 28                	push   $0x28
  801d67:	e8 42 fb ff ff       	call   8018ae <syscall>
  801d6c:	83 c4 18             	add    $0x18,%esp
	return ;
  801d6f:	90                   	nop
}
  801d70:	c9                   	leave  
  801d71:	c3                   	ret    

00801d72 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d72:	55                   	push   %ebp
  801d73:	89 e5                	mov    %esp,%ebp
  801d75:	83 ec 04             	sub    $0x4,%esp
  801d78:	8b 45 14             	mov    0x14(%ebp),%eax
  801d7b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d7e:	8b 55 18             	mov    0x18(%ebp),%edx
  801d81:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d85:	52                   	push   %edx
  801d86:	50                   	push   %eax
  801d87:	ff 75 10             	pushl  0x10(%ebp)
  801d8a:	ff 75 0c             	pushl  0xc(%ebp)
  801d8d:	ff 75 08             	pushl  0x8(%ebp)
  801d90:	6a 27                	push   $0x27
  801d92:	e8 17 fb ff ff       	call   8018ae <syscall>
  801d97:	83 c4 18             	add    $0x18,%esp
	return ;
  801d9a:	90                   	nop
}
  801d9b:	c9                   	leave  
  801d9c:	c3                   	ret    

00801d9d <chktst>:
void chktst(uint32 n)
{
  801d9d:	55                   	push   %ebp
  801d9e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801da0:	6a 00                	push   $0x0
  801da2:	6a 00                	push   $0x0
  801da4:	6a 00                	push   $0x0
  801da6:	6a 00                	push   $0x0
  801da8:	ff 75 08             	pushl  0x8(%ebp)
  801dab:	6a 29                	push   $0x29
  801dad:	e8 fc fa ff ff       	call   8018ae <syscall>
  801db2:	83 c4 18             	add    $0x18,%esp
	return ;
  801db5:	90                   	nop
}
  801db6:	c9                   	leave  
  801db7:	c3                   	ret    

00801db8 <inctst>:

void inctst()
{
  801db8:	55                   	push   %ebp
  801db9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801dbb:	6a 00                	push   $0x0
  801dbd:	6a 00                	push   $0x0
  801dbf:	6a 00                	push   $0x0
  801dc1:	6a 00                	push   $0x0
  801dc3:	6a 00                	push   $0x0
  801dc5:	6a 2a                	push   $0x2a
  801dc7:	e8 e2 fa ff ff       	call   8018ae <syscall>
  801dcc:	83 c4 18             	add    $0x18,%esp
	return ;
  801dcf:	90                   	nop
}
  801dd0:	c9                   	leave  
  801dd1:	c3                   	ret    

00801dd2 <gettst>:
uint32 gettst()
{
  801dd2:	55                   	push   %ebp
  801dd3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801dd5:	6a 00                	push   $0x0
  801dd7:	6a 00                	push   $0x0
  801dd9:	6a 00                	push   $0x0
  801ddb:	6a 00                	push   $0x0
  801ddd:	6a 00                	push   $0x0
  801ddf:	6a 2b                	push   $0x2b
  801de1:	e8 c8 fa ff ff       	call   8018ae <syscall>
  801de6:	83 c4 18             	add    $0x18,%esp
}
  801de9:	c9                   	leave  
  801dea:	c3                   	ret    

00801deb <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801deb:	55                   	push   %ebp
  801dec:	89 e5                	mov    %esp,%ebp
  801dee:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801df1:	6a 00                	push   $0x0
  801df3:	6a 00                	push   $0x0
  801df5:	6a 00                	push   $0x0
  801df7:	6a 00                	push   $0x0
  801df9:	6a 00                	push   $0x0
  801dfb:	6a 2c                	push   $0x2c
  801dfd:	e8 ac fa ff ff       	call   8018ae <syscall>
  801e02:	83 c4 18             	add    $0x18,%esp
  801e05:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801e08:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801e0c:	75 07                	jne    801e15 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801e0e:	b8 01 00 00 00       	mov    $0x1,%eax
  801e13:	eb 05                	jmp    801e1a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801e15:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e1a:	c9                   	leave  
  801e1b:	c3                   	ret    

00801e1c <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801e1c:	55                   	push   %ebp
  801e1d:	89 e5                	mov    %esp,%ebp
  801e1f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e22:	6a 00                	push   $0x0
  801e24:	6a 00                	push   $0x0
  801e26:	6a 00                	push   $0x0
  801e28:	6a 00                	push   $0x0
  801e2a:	6a 00                	push   $0x0
  801e2c:	6a 2c                	push   $0x2c
  801e2e:	e8 7b fa ff ff       	call   8018ae <syscall>
  801e33:	83 c4 18             	add    $0x18,%esp
  801e36:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801e39:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801e3d:	75 07                	jne    801e46 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801e3f:	b8 01 00 00 00       	mov    $0x1,%eax
  801e44:	eb 05                	jmp    801e4b <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801e46:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e4b:	c9                   	leave  
  801e4c:	c3                   	ret    

00801e4d <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801e4d:	55                   	push   %ebp
  801e4e:	89 e5                	mov    %esp,%ebp
  801e50:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e53:	6a 00                	push   $0x0
  801e55:	6a 00                	push   $0x0
  801e57:	6a 00                	push   $0x0
  801e59:	6a 00                	push   $0x0
  801e5b:	6a 00                	push   $0x0
  801e5d:	6a 2c                	push   $0x2c
  801e5f:	e8 4a fa ff ff       	call   8018ae <syscall>
  801e64:	83 c4 18             	add    $0x18,%esp
  801e67:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801e6a:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801e6e:	75 07                	jne    801e77 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801e70:	b8 01 00 00 00       	mov    $0x1,%eax
  801e75:	eb 05                	jmp    801e7c <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801e77:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e7c:	c9                   	leave  
  801e7d:	c3                   	ret    

00801e7e <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801e7e:	55                   	push   %ebp
  801e7f:	89 e5                	mov    %esp,%ebp
  801e81:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e84:	6a 00                	push   $0x0
  801e86:	6a 00                	push   $0x0
  801e88:	6a 00                	push   $0x0
  801e8a:	6a 00                	push   $0x0
  801e8c:	6a 00                	push   $0x0
  801e8e:	6a 2c                	push   $0x2c
  801e90:	e8 19 fa ff ff       	call   8018ae <syscall>
  801e95:	83 c4 18             	add    $0x18,%esp
  801e98:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801e9b:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801e9f:	75 07                	jne    801ea8 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801ea1:	b8 01 00 00 00       	mov    $0x1,%eax
  801ea6:	eb 05                	jmp    801ead <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801ea8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ead:	c9                   	leave  
  801eae:	c3                   	ret    

00801eaf <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801eaf:	55                   	push   %ebp
  801eb0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801eb2:	6a 00                	push   $0x0
  801eb4:	6a 00                	push   $0x0
  801eb6:	6a 00                	push   $0x0
  801eb8:	6a 00                	push   $0x0
  801eba:	ff 75 08             	pushl  0x8(%ebp)
  801ebd:	6a 2d                	push   $0x2d
  801ebf:	e8 ea f9 ff ff       	call   8018ae <syscall>
  801ec4:	83 c4 18             	add    $0x18,%esp
	return ;
  801ec7:	90                   	nop
}
  801ec8:	c9                   	leave  
  801ec9:	c3                   	ret    

00801eca <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801eca:	55                   	push   %ebp
  801ecb:	89 e5                	mov    %esp,%ebp
  801ecd:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801ece:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ed1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ed4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ed7:	8b 45 08             	mov    0x8(%ebp),%eax
  801eda:	6a 00                	push   $0x0
  801edc:	53                   	push   %ebx
  801edd:	51                   	push   %ecx
  801ede:	52                   	push   %edx
  801edf:	50                   	push   %eax
  801ee0:	6a 2e                	push   $0x2e
  801ee2:	e8 c7 f9 ff ff       	call   8018ae <syscall>
  801ee7:	83 c4 18             	add    $0x18,%esp
}
  801eea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801eed:	c9                   	leave  
  801eee:	c3                   	ret    

00801eef <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801eef:	55                   	push   %ebp
  801ef0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801ef2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ef5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef8:	6a 00                	push   $0x0
  801efa:	6a 00                	push   $0x0
  801efc:	6a 00                	push   $0x0
  801efe:	52                   	push   %edx
  801eff:	50                   	push   %eax
  801f00:	6a 2f                	push   $0x2f
  801f02:	e8 a7 f9 ff ff       	call   8018ae <syscall>
  801f07:	83 c4 18             	add    $0x18,%esp
}
  801f0a:	c9                   	leave  
  801f0b:	c3                   	ret    

00801f0c <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801f0c:	55                   	push   %ebp
  801f0d:	89 e5                	mov    %esp,%ebp
  801f0f:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801f12:	83 ec 0c             	sub    $0xc,%esp
  801f15:	68 50 41 80 00       	push   $0x804150
  801f1a:	e8 6b e8 ff ff       	call   80078a <cprintf>
  801f1f:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801f22:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801f29:	83 ec 0c             	sub    $0xc,%esp
  801f2c:	68 7c 41 80 00       	push   $0x80417c
  801f31:	e8 54 e8 ff ff       	call   80078a <cprintf>
  801f36:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801f39:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f3d:	a1 38 51 80 00       	mov    0x805138,%eax
  801f42:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f45:	eb 56                	jmp    801f9d <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f47:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f4b:	74 1c                	je     801f69 <print_mem_block_lists+0x5d>
  801f4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f50:	8b 50 08             	mov    0x8(%eax),%edx
  801f53:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f56:	8b 48 08             	mov    0x8(%eax),%ecx
  801f59:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f5c:	8b 40 0c             	mov    0xc(%eax),%eax
  801f5f:	01 c8                	add    %ecx,%eax
  801f61:	39 c2                	cmp    %eax,%edx
  801f63:	73 04                	jae    801f69 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801f65:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f6c:	8b 50 08             	mov    0x8(%eax),%edx
  801f6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f72:	8b 40 0c             	mov    0xc(%eax),%eax
  801f75:	01 c2                	add    %eax,%edx
  801f77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f7a:	8b 40 08             	mov    0x8(%eax),%eax
  801f7d:	83 ec 04             	sub    $0x4,%esp
  801f80:	52                   	push   %edx
  801f81:	50                   	push   %eax
  801f82:	68 91 41 80 00       	push   $0x804191
  801f87:	e8 fe e7 ff ff       	call   80078a <cprintf>
  801f8c:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f92:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f95:	a1 40 51 80 00       	mov    0x805140,%eax
  801f9a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f9d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fa1:	74 07                	je     801faa <print_mem_block_lists+0x9e>
  801fa3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fa6:	8b 00                	mov    (%eax),%eax
  801fa8:	eb 05                	jmp    801faf <print_mem_block_lists+0xa3>
  801faa:	b8 00 00 00 00       	mov    $0x0,%eax
  801faf:	a3 40 51 80 00       	mov    %eax,0x805140
  801fb4:	a1 40 51 80 00       	mov    0x805140,%eax
  801fb9:	85 c0                	test   %eax,%eax
  801fbb:	75 8a                	jne    801f47 <print_mem_block_lists+0x3b>
  801fbd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fc1:	75 84                	jne    801f47 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801fc3:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801fc7:	75 10                	jne    801fd9 <print_mem_block_lists+0xcd>
  801fc9:	83 ec 0c             	sub    $0xc,%esp
  801fcc:	68 a0 41 80 00       	push   $0x8041a0
  801fd1:	e8 b4 e7 ff ff       	call   80078a <cprintf>
  801fd6:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801fd9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801fe0:	83 ec 0c             	sub    $0xc,%esp
  801fe3:	68 c4 41 80 00       	push   $0x8041c4
  801fe8:	e8 9d e7 ff ff       	call   80078a <cprintf>
  801fed:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801ff0:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801ff4:	a1 40 50 80 00       	mov    0x805040,%eax
  801ff9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ffc:	eb 56                	jmp    802054 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801ffe:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802002:	74 1c                	je     802020 <print_mem_block_lists+0x114>
  802004:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802007:	8b 50 08             	mov    0x8(%eax),%edx
  80200a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80200d:	8b 48 08             	mov    0x8(%eax),%ecx
  802010:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802013:	8b 40 0c             	mov    0xc(%eax),%eax
  802016:	01 c8                	add    %ecx,%eax
  802018:	39 c2                	cmp    %eax,%edx
  80201a:	73 04                	jae    802020 <print_mem_block_lists+0x114>
			sorted = 0 ;
  80201c:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802020:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802023:	8b 50 08             	mov    0x8(%eax),%edx
  802026:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802029:	8b 40 0c             	mov    0xc(%eax),%eax
  80202c:	01 c2                	add    %eax,%edx
  80202e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802031:	8b 40 08             	mov    0x8(%eax),%eax
  802034:	83 ec 04             	sub    $0x4,%esp
  802037:	52                   	push   %edx
  802038:	50                   	push   %eax
  802039:	68 91 41 80 00       	push   $0x804191
  80203e:	e8 47 e7 ff ff       	call   80078a <cprintf>
  802043:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802046:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802049:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80204c:	a1 48 50 80 00       	mov    0x805048,%eax
  802051:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802054:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802058:	74 07                	je     802061 <print_mem_block_lists+0x155>
  80205a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80205d:	8b 00                	mov    (%eax),%eax
  80205f:	eb 05                	jmp    802066 <print_mem_block_lists+0x15a>
  802061:	b8 00 00 00 00       	mov    $0x0,%eax
  802066:	a3 48 50 80 00       	mov    %eax,0x805048
  80206b:	a1 48 50 80 00       	mov    0x805048,%eax
  802070:	85 c0                	test   %eax,%eax
  802072:	75 8a                	jne    801ffe <print_mem_block_lists+0xf2>
  802074:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802078:	75 84                	jne    801ffe <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  80207a:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80207e:	75 10                	jne    802090 <print_mem_block_lists+0x184>
  802080:	83 ec 0c             	sub    $0xc,%esp
  802083:	68 dc 41 80 00       	push   $0x8041dc
  802088:	e8 fd e6 ff ff       	call   80078a <cprintf>
  80208d:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802090:	83 ec 0c             	sub    $0xc,%esp
  802093:	68 50 41 80 00       	push   $0x804150
  802098:	e8 ed e6 ff ff       	call   80078a <cprintf>
  80209d:	83 c4 10             	add    $0x10,%esp

}
  8020a0:	90                   	nop
  8020a1:	c9                   	leave  
  8020a2:	c3                   	ret    

008020a3 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8020a3:	55                   	push   %ebp
  8020a4:	89 e5                	mov    %esp,%ebp
  8020a6:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  8020a9:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  8020b0:	00 00 00 
  8020b3:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  8020ba:	00 00 00 
  8020bd:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  8020c4:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  8020c7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8020ce:	e9 9e 00 00 00       	jmp    802171 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  8020d3:	a1 50 50 80 00       	mov    0x805050,%eax
  8020d8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020db:	c1 e2 04             	shl    $0x4,%edx
  8020de:	01 d0                	add    %edx,%eax
  8020e0:	85 c0                	test   %eax,%eax
  8020e2:	75 14                	jne    8020f8 <initialize_MemBlocksList+0x55>
  8020e4:	83 ec 04             	sub    $0x4,%esp
  8020e7:	68 04 42 80 00       	push   $0x804204
  8020ec:	6a 46                	push   $0x46
  8020ee:	68 27 42 80 00       	push   $0x804227
  8020f3:	e8 de e3 ff ff       	call   8004d6 <_panic>
  8020f8:	a1 50 50 80 00       	mov    0x805050,%eax
  8020fd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802100:	c1 e2 04             	shl    $0x4,%edx
  802103:	01 d0                	add    %edx,%eax
  802105:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80210b:	89 10                	mov    %edx,(%eax)
  80210d:	8b 00                	mov    (%eax),%eax
  80210f:	85 c0                	test   %eax,%eax
  802111:	74 18                	je     80212b <initialize_MemBlocksList+0x88>
  802113:	a1 48 51 80 00       	mov    0x805148,%eax
  802118:	8b 15 50 50 80 00    	mov    0x805050,%edx
  80211e:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802121:	c1 e1 04             	shl    $0x4,%ecx
  802124:	01 ca                	add    %ecx,%edx
  802126:	89 50 04             	mov    %edx,0x4(%eax)
  802129:	eb 12                	jmp    80213d <initialize_MemBlocksList+0x9a>
  80212b:	a1 50 50 80 00       	mov    0x805050,%eax
  802130:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802133:	c1 e2 04             	shl    $0x4,%edx
  802136:	01 d0                	add    %edx,%eax
  802138:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80213d:	a1 50 50 80 00       	mov    0x805050,%eax
  802142:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802145:	c1 e2 04             	shl    $0x4,%edx
  802148:	01 d0                	add    %edx,%eax
  80214a:	a3 48 51 80 00       	mov    %eax,0x805148
  80214f:	a1 50 50 80 00       	mov    0x805050,%eax
  802154:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802157:	c1 e2 04             	shl    $0x4,%edx
  80215a:	01 d0                	add    %edx,%eax
  80215c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802163:	a1 54 51 80 00       	mov    0x805154,%eax
  802168:	40                   	inc    %eax
  802169:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  80216e:	ff 45 f4             	incl   -0xc(%ebp)
  802171:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802174:	3b 45 08             	cmp    0x8(%ebp),%eax
  802177:	0f 82 56 ff ff ff    	jb     8020d3 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  80217d:	90                   	nop
  80217e:	c9                   	leave  
  80217f:	c3                   	ret    

00802180 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802180:	55                   	push   %ebp
  802181:	89 e5                	mov    %esp,%ebp
  802183:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802186:	8b 45 08             	mov    0x8(%ebp),%eax
  802189:	8b 00                	mov    (%eax),%eax
  80218b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80218e:	eb 19                	jmp    8021a9 <find_block+0x29>
	{
		if(va==point->sva)
  802190:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802193:	8b 40 08             	mov    0x8(%eax),%eax
  802196:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802199:	75 05                	jne    8021a0 <find_block+0x20>
		   return point;
  80219b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80219e:	eb 36                	jmp    8021d6 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8021a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a3:	8b 40 08             	mov    0x8(%eax),%eax
  8021a6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8021a9:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8021ad:	74 07                	je     8021b6 <find_block+0x36>
  8021af:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021b2:	8b 00                	mov    (%eax),%eax
  8021b4:	eb 05                	jmp    8021bb <find_block+0x3b>
  8021b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8021bb:	8b 55 08             	mov    0x8(%ebp),%edx
  8021be:	89 42 08             	mov    %eax,0x8(%edx)
  8021c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c4:	8b 40 08             	mov    0x8(%eax),%eax
  8021c7:	85 c0                	test   %eax,%eax
  8021c9:	75 c5                	jne    802190 <find_block+0x10>
  8021cb:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8021cf:	75 bf                	jne    802190 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  8021d1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021d6:	c9                   	leave  
  8021d7:	c3                   	ret    

008021d8 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8021d8:	55                   	push   %ebp
  8021d9:	89 e5                	mov    %esp,%ebp
  8021db:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  8021de:	a1 40 50 80 00       	mov    0x805040,%eax
  8021e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  8021e6:	a1 44 50 80 00       	mov    0x805044,%eax
  8021eb:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  8021ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021f1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8021f4:	74 24                	je     80221a <insert_sorted_allocList+0x42>
  8021f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f9:	8b 50 08             	mov    0x8(%eax),%edx
  8021fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021ff:	8b 40 08             	mov    0x8(%eax),%eax
  802202:	39 c2                	cmp    %eax,%edx
  802204:	76 14                	jbe    80221a <insert_sorted_allocList+0x42>
  802206:	8b 45 08             	mov    0x8(%ebp),%eax
  802209:	8b 50 08             	mov    0x8(%eax),%edx
  80220c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80220f:	8b 40 08             	mov    0x8(%eax),%eax
  802212:	39 c2                	cmp    %eax,%edx
  802214:	0f 82 60 01 00 00    	jb     80237a <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  80221a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80221e:	75 65                	jne    802285 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802220:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802224:	75 14                	jne    80223a <insert_sorted_allocList+0x62>
  802226:	83 ec 04             	sub    $0x4,%esp
  802229:	68 04 42 80 00       	push   $0x804204
  80222e:	6a 6b                	push   $0x6b
  802230:	68 27 42 80 00       	push   $0x804227
  802235:	e8 9c e2 ff ff       	call   8004d6 <_panic>
  80223a:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802240:	8b 45 08             	mov    0x8(%ebp),%eax
  802243:	89 10                	mov    %edx,(%eax)
  802245:	8b 45 08             	mov    0x8(%ebp),%eax
  802248:	8b 00                	mov    (%eax),%eax
  80224a:	85 c0                	test   %eax,%eax
  80224c:	74 0d                	je     80225b <insert_sorted_allocList+0x83>
  80224e:	a1 40 50 80 00       	mov    0x805040,%eax
  802253:	8b 55 08             	mov    0x8(%ebp),%edx
  802256:	89 50 04             	mov    %edx,0x4(%eax)
  802259:	eb 08                	jmp    802263 <insert_sorted_allocList+0x8b>
  80225b:	8b 45 08             	mov    0x8(%ebp),%eax
  80225e:	a3 44 50 80 00       	mov    %eax,0x805044
  802263:	8b 45 08             	mov    0x8(%ebp),%eax
  802266:	a3 40 50 80 00       	mov    %eax,0x805040
  80226b:	8b 45 08             	mov    0x8(%ebp),%eax
  80226e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802275:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80227a:	40                   	inc    %eax
  80227b:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802280:	e9 dc 01 00 00       	jmp    802461 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802285:	8b 45 08             	mov    0x8(%ebp),%eax
  802288:	8b 50 08             	mov    0x8(%eax),%edx
  80228b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80228e:	8b 40 08             	mov    0x8(%eax),%eax
  802291:	39 c2                	cmp    %eax,%edx
  802293:	77 6c                	ja     802301 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802295:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802299:	74 06                	je     8022a1 <insert_sorted_allocList+0xc9>
  80229b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80229f:	75 14                	jne    8022b5 <insert_sorted_allocList+0xdd>
  8022a1:	83 ec 04             	sub    $0x4,%esp
  8022a4:	68 40 42 80 00       	push   $0x804240
  8022a9:	6a 6f                	push   $0x6f
  8022ab:	68 27 42 80 00       	push   $0x804227
  8022b0:	e8 21 e2 ff ff       	call   8004d6 <_panic>
  8022b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022b8:	8b 50 04             	mov    0x4(%eax),%edx
  8022bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8022be:	89 50 04             	mov    %edx,0x4(%eax)
  8022c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022c7:	89 10                	mov    %edx,(%eax)
  8022c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022cc:	8b 40 04             	mov    0x4(%eax),%eax
  8022cf:	85 c0                	test   %eax,%eax
  8022d1:	74 0d                	je     8022e0 <insert_sorted_allocList+0x108>
  8022d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022d6:	8b 40 04             	mov    0x4(%eax),%eax
  8022d9:	8b 55 08             	mov    0x8(%ebp),%edx
  8022dc:	89 10                	mov    %edx,(%eax)
  8022de:	eb 08                	jmp    8022e8 <insert_sorted_allocList+0x110>
  8022e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e3:	a3 40 50 80 00       	mov    %eax,0x805040
  8022e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022eb:	8b 55 08             	mov    0x8(%ebp),%edx
  8022ee:	89 50 04             	mov    %edx,0x4(%eax)
  8022f1:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8022f6:	40                   	inc    %eax
  8022f7:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8022fc:	e9 60 01 00 00       	jmp    802461 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802301:	8b 45 08             	mov    0x8(%ebp),%eax
  802304:	8b 50 08             	mov    0x8(%eax),%edx
  802307:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80230a:	8b 40 08             	mov    0x8(%eax),%eax
  80230d:	39 c2                	cmp    %eax,%edx
  80230f:	0f 82 4c 01 00 00    	jb     802461 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802315:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802319:	75 14                	jne    80232f <insert_sorted_allocList+0x157>
  80231b:	83 ec 04             	sub    $0x4,%esp
  80231e:	68 78 42 80 00       	push   $0x804278
  802323:	6a 73                	push   $0x73
  802325:	68 27 42 80 00       	push   $0x804227
  80232a:	e8 a7 e1 ff ff       	call   8004d6 <_panic>
  80232f:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802335:	8b 45 08             	mov    0x8(%ebp),%eax
  802338:	89 50 04             	mov    %edx,0x4(%eax)
  80233b:	8b 45 08             	mov    0x8(%ebp),%eax
  80233e:	8b 40 04             	mov    0x4(%eax),%eax
  802341:	85 c0                	test   %eax,%eax
  802343:	74 0c                	je     802351 <insert_sorted_allocList+0x179>
  802345:	a1 44 50 80 00       	mov    0x805044,%eax
  80234a:	8b 55 08             	mov    0x8(%ebp),%edx
  80234d:	89 10                	mov    %edx,(%eax)
  80234f:	eb 08                	jmp    802359 <insert_sorted_allocList+0x181>
  802351:	8b 45 08             	mov    0x8(%ebp),%eax
  802354:	a3 40 50 80 00       	mov    %eax,0x805040
  802359:	8b 45 08             	mov    0x8(%ebp),%eax
  80235c:	a3 44 50 80 00       	mov    %eax,0x805044
  802361:	8b 45 08             	mov    0x8(%ebp),%eax
  802364:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80236a:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80236f:	40                   	inc    %eax
  802370:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802375:	e9 e7 00 00 00       	jmp    802461 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  80237a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80237d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802380:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802387:	a1 40 50 80 00       	mov    0x805040,%eax
  80238c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80238f:	e9 9d 00 00 00       	jmp    802431 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802394:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802397:	8b 00                	mov    (%eax),%eax
  802399:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  80239c:	8b 45 08             	mov    0x8(%ebp),%eax
  80239f:	8b 50 08             	mov    0x8(%eax),%edx
  8023a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a5:	8b 40 08             	mov    0x8(%eax),%eax
  8023a8:	39 c2                	cmp    %eax,%edx
  8023aa:	76 7d                	jbe    802429 <insert_sorted_allocList+0x251>
  8023ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8023af:	8b 50 08             	mov    0x8(%eax),%edx
  8023b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8023b5:	8b 40 08             	mov    0x8(%eax),%eax
  8023b8:	39 c2                	cmp    %eax,%edx
  8023ba:	73 6d                	jae    802429 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  8023bc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023c0:	74 06                	je     8023c8 <insert_sorted_allocList+0x1f0>
  8023c2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023c6:	75 14                	jne    8023dc <insert_sorted_allocList+0x204>
  8023c8:	83 ec 04             	sub    $0x4,%esp
  8023cb:	68 9c 42 80 00       	push   $0x80429c
  8023d0:	6a 7f                	push   $0x7f
  8023d2:	68 27 42 80 00       	push   $0x804227
  8023d7:	e8 fa e0 ff ff       	call   8004d6 <_panic>
  8023dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023df:	8b 10                	mov    (%eax),%edx
  8023e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e4:	89 10                	mov    %edx,(%eax)
  8023e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e9:	8b 00                	mov    (%eax),%eax
  8023eb:	85 c0                	test   %eax,%eax
  8023ed:	74 0b                	je     8023fa <insert_sorted_allocList+0x222>
  8023ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f2:	8b 00                	mov    (%eax),%eax
  8023f4:	8b 55 08             	mov    0x8(%ebp),%edx
  8023f7:	89 50 04             	mov    %edx,0x4(%eax)
  8023fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023fd:	8b 55 08             	mov    0x8(%ebp),%edx
  802400:	89 10                	mov    %edx,(%eax)
  802402:	8b 45 08             	mov    0x8(%ebp),%eax
  802405:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802408:	89 50 04             	mov    %edx,0x4(%eax)
  80240b:	8b 45 08             	mov    0x8(%ebp),%eax
  80240e:	8b 00                	mov    (%eax),%eax
  802410:	85 c0                	test   %eax,%eax
  802412:	75 08                	jne    80241c <insert_sorted_allocList+0x244>
  802414:	8b 45 08             	mov    0x8(%ebp),%eax
  802417:	a3 44 50 80 00       	mov    %eax,0x805044
  80241c:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802421:	40                   	inc    %eax
  802422:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802427:	eb 39                	jmp    802462 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802429:	a1 48 50 80 00       	mov    0x805048,%eax
  80242e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802431:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802435:	74 07                	je     80243e <insert_sorted_allocList+0x266>
  802437:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243a:	8b 00                	mov    (%eax),%eax
  80243c:	eb 05                	jmp    802443 <insert_sorted_allocList+0x26b>
  80243e:	b8 00 00 00 00       	mov    $0x0,%eax
  802443:	a3 48 50 80 00       	mov    %eax,0x805048
  802448:	a1 48 50 80 00       	mov    0x805048,%eax
  80244d:	85 c0                	test   %eax,%eax
  80244f:	0f 85 3f ff ff ff    	jne    802394 <insert_sorted_allocList+0x1bc>
  802455:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802459:	0f 85 35 ff ff ff    	jne    802394 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80245f:	eb 01                	jmp    802462 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802461:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802462:	90                   	nop
  802463:	c9                   	leave  
  802464:	c3                   	ret    

00802465 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802465:	55                   	push   %ebp
  802466:	89 e5                	mov    %esp,%ebp
  802468:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  80246b:	a1 38 51 80 00       	mov    0x805138,%eax
  802470:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802473:	e9 85 01 00 00       	jmp    8025fd <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802478:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247b:	8b 40 0c             	mov    0xc(%eax),%eax
  80247e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802481:	0f 82 6e 01 00 00    	jb     8025f5 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802487:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248a:	8b 40 0c             	mov    0xc(%eax),%eax
  80248d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802490:	0f 85 8a 00 00 00    	jne    802520 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802496:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80249a:	75 17                	jne    8024b3 <alloc_block_FF+0x4e>
  80249c:	83 ec 04             	sub    $0x4,%esp
  80249f:	68 d0 42 80 00       	push   $0x8042d0
  8024a4:	68 93 00 00 00       	push   $0x93
  8024a9:	68 27 42 80 00       	push   $0x804227
  8024ae:	e8 23 e0 ff ff       	call   8004d6 <_panic>
  8024b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b6:	8b 00                	mov    (%eax),%eax
  8024b8:	85 c0                	test   %eax,%eax
  8024ba:	74 10                	je     8024cc <alloc_block_FF+0x67>
  8024bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024bf:	8b 00                	mov    (%eax),%eax
  8024c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024c4:	8b 52 04             	mov    0x4(%edx),%edx
  8024c7:	89 50 04             	mov    %edx,0x4(%eax)
  8024ca:	eb 0b                	jmp    8024d7 <alloc_block_FF+0x72>
  8024cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024cf:	8b 40 04             	mov    0x4(%eax),%eax
  8024d2:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8024d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024da:	8b 40 04             	mov    0x4(%eax),%eax
  8024dd:	85 c0                	test   %eax,%eax
  8024df:	74 0f                	je     8024f0 <alloc_block_FF+0x8b>
  8024e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e4:	8b 40 04             	mov    0x4(%eax),%eax
  8024e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024ea:	8b 12                	mov    (%edx),%edx
  8024ec:	89 10                	mov    %edx,(%eax)
  8024ee:	eb 0a                	jmp    8024fa <alloc_block_FF+0x95>
  8024f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f3:	8b 00                	mov    (%eax),%eax
  8024f5:	a3 38 51 80 00       	mov    %eax,0x805138
  8024fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024fd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802503:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802506:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80250d:	a1 44 51 80 00       	mov    0x805144,%eax
  802512:	48                   	dec    %eax
  802513:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802518:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251b:	e9 10 01 00 00       	jmp    802630 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802520:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802523:	8b 40 0c             	mov    0xc(%eax),%eax
  802526:	3b 45 08             	cmp    0x8(%ebp),%eax
  802529:	0f 86 c6 00 00 00    	jbe    8025f5 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80252f:	a1 48 51 80 00       	mov    0x805148,%eax
  802534:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802537:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253a:	8b 50 08             	mov    0x8(%eax),%edx
  80253d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802540:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802543:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802546:	8b 55 08             	mov    0x8(%ebp),%edx
  802549:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80254c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802550:	75 17                	jne    802569 <alloc_block_FF+0x104>
  802552:	83 ec 04             	sub    $0x4,%esp
  802555:	68 d0 42 80 00       	push   $0x8042d0
  80255a:	68 9b 00 00 00       	push   $0x9b
  80255f:	68 27 42 80 00       	push   $0x804227
  802564:	e8 6d df ff ff       	call   8004d6 <_panic>
  802569:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80256c:	8b 00                	mov    (%eax),%eax
  80256e:	85 c0                	test   %eax,%eax
  802570:	74 10                	je     802582 <alloc_block_FF+0x11d>
  802572:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802575:	8b 00                	mov    (%eax),%eax
  802577:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80257a:	8b 52 04             	mov    0x4(%edx),%edx
  80257d:	89 50 04             	mov    %edx,0x4(%eax)
  802580:	eb 0b                	jmp    80258d <alloc_block_FF+0x128>
  802582:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802585:	8b 40 04             	mov    0x4(%eax),%eax
  802588:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80258d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802590:	8b 40 04             	mov    0x4(%eax),%eax
  802593:	85 c0                	test   %eax,%eax
  802595:	74 0f                	je     8025a6 <alloc_block_FF+0x141>
  802597:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80259a:	8b 40 04             	mov    0x4(%eax),%eax
  80259d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025a0:	8b 12                	mov    (%edx),%edx
  8025a2:	89 10                	mov    %edx,(%eax)
  8025a4:	eb 0a                	jmp    8025b0 <alloc_block_FF+0x14b>
  8025a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025a9:	8b 00                	mov    (%eax),%eax
  8025ab:	a3 48 51 80 00       	mov    %eax,0x805148
  8025b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025b3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025bc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025c3:	a1 54 51 80 00       	mov    0x805154,%eax
  8025c8:	48                   	dec    %eax
  8025c9:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  8025ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d1:	8b 50 08             	mov    0x8(%eax),%edx
  8025d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8025d7:	01 c2                	add    %eax,%edx
  8025d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025dc:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  8025df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e2:	8b 40 0c             	mov    0xc(%eax),%eax
  8025e5:	2b 45 08             	sub    0x8(%ebp),%eax
  8025e8:	89 c2                	mov    %eax,%edx
  8025ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ed:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  8025f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025f3:	eb 3b                	jmp    802630 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8025f5:	a1 40 51 80 00       	mov    0x805140,%eax
  8025fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025fd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802601:	74 07                	je     80260a <alloc_block_FF+0x1a5>
  802603:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802606:	8b 00                	mov    (%eax),%eax
  802608:	eb 05                	jmp    80260f <alloc_block_FF+0x1aa>
  80260a:	b8 00 00 00 00       	mov    $0x0,%eax
  80260f:	a3 40 51 80 00       	mov    %eax,0x805140
  802614:	a1 40 51 80 00       	mov    0x805140,%eax
  802619:	85 c0                	test   %eax,%eax
  80261b:	0f 85 57 fe ff ff    	jne    802478 <alloc_block_FF+0x13>
  802621:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802625:	0f 85 4d fe ff ff    	jne    802478 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  80262b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802630:	c9                   	leave  
  802631:	c3                   	ret    

00802632 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802632:	55                   	push   %ebp
  802633:	89 e5                	mov    %esp,%ebp
  802635:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802638:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  80263f:	a1 38 51 80 00       	mov    0x805138,%eax
  802644:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802647:	e9 df 00 00 00       	jmp    80272b <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  80264c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264f:	8b 40 0c             	mov    0xc(%eax),%eax
  802652:	3b 45 08             	cmp    0x8(%ebp),%eax
  802655:	0f 82 c8 00 00 00    	jb     802723 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  80265b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265e:	8b 40 0c             	mov    0xc(%eax),%eax
  802661:	3b 45 08             	cmp    0x8(%ebp),%eax
  802664:	0f 85 8a 00 00 00    	jne    8026f4 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  80266a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80266e:	75 17                	jne    802687 <alloc_block_BF+0x55>
  802670:	83 ec 04             	sub    $0x4,%esp
  802673:	68 d0 42 80 00       	push   $0x8042d0
  802678:	68 b7 00 00 00       	push   $0xb7
  80267d:	68 27 42 80 00       	push   $0x804227
  802682:	e8 4f de ff ff       	call   8004d6 <_panic>
  802687:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268a:	8b 00                	mov    (%eax),%eax
  80268c:	85 c0                	test   %eax,%eax
  80268e:	74 10                	je     8026a0 <alloc_block_BF+0x6e>
  802690:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802693:	8b 00                	mov    (%eax),%eax
  802695:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802698:	8b 52 04             	mov    0x4(%edx),%edx
  80269b:	89 50 04             	mov    %edx,0x4(%eax)
  80269e:	eb 0b                	jmp    8026ab <alloc_block_BF+0x79>
  8026a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a3:	8b 40 04             	mov    0x4(%eax),%eax
  8026a6:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8026ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ae:	8b 40 04             	mov    0x4(%eax),%eax
  8026b1:	85 c0                	test   %eax,%eax
  8026b3:	74 0f                	je     8026c4 <alloc_block_BF+0x92>
  8026b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b8:	8b 40 04             	mov    0x4(%eax),%eax
  8026bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026be:	8b 12                	mov    (%edx),%edx
  8026c0:	89 10                	mov    %edx,(%eax)
  8026c2:	eb 0a                	jmp    8026ce <alloc_block_BF+0x9c>
  8026c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c7:	8b 00                	mov    (%eax),%eax
  8026c9:	a3 38 51 80 00       	mov    %eax,0x805138
  8026ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026da:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026e1:	a1 44 51 80 00       	mov    0x805144,%eax
  8026e6:	48                   	dec    %eax
  8026e7:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  8026ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ef:	e9 4d 01 00 00       	jmp    802841 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  8026f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f7:	8b 40 0c             	mov    0xc(%eax),%eax
  8026fa:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026fd:	76 24                	jbe    802723 <alloc_block_BF+0xf1>
  8026ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802702:	8b 40 0c             	mov    0xc(%eax),%eax
  802705:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802708:	73 19                	jae    802723 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  80270a:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802711:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802714:	8b 40 0c             	mov    0xc(%eax),%eax
  802717:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  80271a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271d:	8b 40 08             	mov    0x8(%eax),%eax
  802720:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802723:	a1 40 51 80 00       	mov    0x805140,%eax
  802728:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80272b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80272f:	74 07                	je     802738 <alloc_block_BF+0x106>
  802731:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802734:	8b 00                	mov    (%eax),%eax
  802736:	eb 05                	jmp    80273d <alloc_block_BF+0x10b>
  802738:	b8 00 00 00 00       	mov    $0x0,%eax
  80273d:	a3 40 51 80 00       	mov    %eax,0x805140
  802742:	a1 40 51 80 00       	mov    0x805140,%eax
  802747:	85 c0                	test   %eax,%eax
  802749:	0f 85 fd fe ff ff    	jne    80264c <alloc_block_BF+0x1a>
  80274f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802753:	0f 85 f3 fe ff ff    	jne    80264c <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802759:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80275d:	0f 84 d9 00 00 00    	je     80283c <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802763:	a1 48 51 80 00       	mov    0x805148,%eax
  802768:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  80276b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80276e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802771:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802774:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802777:	8b 55 08             	mov    0x8(%ebp),%edx
  80277a:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  80277d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802781:	75 17                	jne    80279a <alloc_block_BF+0x168>
  802783:	83 ec 04             	sub    $0x4,%esp
  802786:	68 d0 42 80 00       	push   $0x8042d0
  80278b:	68 c7 00 00 00       	push   $0xc7
  802790:	68 27 42 80 00       	push   $0x804227
  802795:	e8 3c dd ff ff       	call   8004d6 <_panic>
  80279a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80279d:	8b 00                	mov    (%eax),%eax
  80279f:	85 c0                	test   %eax,%eax
  8027a1:	74 10                	je     8027b3 <alloc_block_BF+0x181>
  8027a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027a6:	8b 00                	mov    (%eax),%eax
  8027a8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8027ab:	8b 52 04             	mov    0x4(%edx),%edx
  8027ae:	89 50 04             	mov    %edx,0x4(%eax)
  8027b1:	eb 0b                	jmp    8027be <alloc_block_BF+0x18c>
  8027b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027b6:	8b 40 04             	mov    0x4(%eax),%eax
  8027b9:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8027be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027c1:	8b 40 04             	mov    0x4(%eax),%eax
  8027c4:	85 c0                	test   %eax,%eax
  8027c6:	74 0f                	je     8027d7 <alloc_block_BF+0x1a5>
  8027c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027cb:	8b 40 04             	mov    0x4(%eax),%eax
  8027ce:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8027d1:	8b 12                	mov    (%edx),%edx
  8027d3:	89 10                	mov    %edx,(%eax)
  8027d5:	eb 0a                	jmp    8027e1 <alloc_block_BF+0x1af>
  8027d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027da:	8b 00                	mov    (%eax),%eax
  8027dc:	a3 48 51 80 00       	mov    %eax,0x805148
  8027e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027e4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027ed:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027f4:	a1 54 51 80 00       	mov    0x805154,%eax
  8027f9:	48                   	dec    %eax
  8027fa:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  8027ff:	83 ec 08             	sub    $0x8,%esp
  802802:	ff 75 ec             	pushl  -0x14(%ebp)
  802805:	68 38 51 80 00       	push   $0x805138
  80280a:	e8 71 f9 ff ff       	call   802180 <find_block>
  80280f:	83 c4 10             	add    $0x10,%esp
  802812:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802815:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802818:	8b 50 08             	mov    0x8(%eax),%edx
  80281b:	8b 45 08             	mov    0x8(%ebp),%eax
  80281e:	01 c2                	add    %eax,%edx
  802820:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802823:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802826:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802829:	8b 40 0c             	mov    0xc(%eax),%eax
  80282c:	2b 45 08             	sub    0x8(%ebp),%eax
  80282f:	89 c2                	mov    %eax,%edx
  802831:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802834:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802837:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80283a:	eb 05                	jmp    802841 <alloc_block_BF+0x20f>
	}
	return NULL;
  80283c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802841:	c9                   	leave  
  802842:	c3                   	ret    

00802843 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802843:	55                   	push   %ebp
  802844:	89 e5                	mov    %esp,%ebp
  802846:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802849:	a1 28 50 80 00       	mov    0x805028,%eax
  80284e:	85 c0                	test   %eax,%eax
  802850:	0f 85 de 01 00 00    	jne    802a34 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802856:	a1 38 51 80 00       	mov    0x805138,%eax
  80285b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80285e:	e9 9e 01 00 00       	jmp    802a01 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802863:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802866:	8b 40 0c             	mov    0xc(%eax),%eax
  802869:	3b 45 08             	cmp    0x8(%ebp),%eax
  80286c:	0f 82 87 01 00 00    	jb     8029f9 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802872:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802875:	8b 40 0c             	mov    0xc(%eax),%eax
  802878:	3b 45 08             	cmp    0x8(%ebp),%eax
  80287b:	0f 85 95 00 00 00    	jne    802916 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802881:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802885:	75 17                	jne    80289e <alloc_block_NF+0x5b>
  802887:	83 ec 04             	sub    $0x4,%esp
  80288a:	68 d0 42 80 00       	push   $0x8042d0
  80288f:	68 e0 00 00 00       	push   $0xe0
  802894:	68 27 42 80 00       	push   $0x804227
  802899:	e8 38 dc ff ff       	call   8004d6 <_panic>
  80289e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a1:	8b 00                	mov    (%eax),%eax
  8028a3:	85 c0                	test   %eax,%eax
  8028a5:	74 10                	je     8028b7 <alloc_block_NF+0x74>
  8028a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028aa:	8b 00                	mov    (%eax),%eax
  8028ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028af:	8b 52 04             	mov    0x4(%edx),%edx
  8028b2:	89 50 04             	mov    %edx,0x4(%eax)
  8028b5:	eb 0b                	jmp    8028c2 <alloc_block_NF+0x7f>
  8028b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ba:	8b 40 04             	mov    0x4(%eax),%eax
  8028bd:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8028c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c5:	8b 40 04             	mov    0x4(%eax),%eax
  8028c8:	85 c0                	test   %eax,%eax
  8028ca:	74 0f                	je     8028db <alloc_block_NF+0x98>
  8028cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028cf:	8b 40 04             	mov    0x4(%eax),%eax
  8028d2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028d5:	8b 12                	mov    (%edx),%edx
  8028d7:	89 10                	mov    %edx,(%eax)
  8028d9:	eb 0a                	jmp    8028e5 <alloc_block_NF+0xa2>
  8028db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028de:	8b 00                	mov    (%eax),%eax
  8028e0:	a3 38 51 80 00       	mov    %eax,0x805138
  8028e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028f8:	a1 44 51 80 00       	mov    0x805144,%eax
  8028fd:	48                   	dec    %eax
  8028fe:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802903:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802906:	8b 40 08             	mov    0x8(%eax),%eax
  802909:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  80290e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802911:	e9 f8 04 00 00       	jmp    802e0e <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802916:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802919:	8b 40 0c             	mov    0xc(%eax),%eax
  80291c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80291f:	0f 86 d4 00 00 00    	jbe    8029f9 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802925:	a1 48 51 80 00       	mov    0x805148,%eax
  80292a:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  80292d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802930:	8b 50 08             	mov    0x8(%eax),%edx
  802933:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802936:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802939:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80293c:	8b 55 08             	mov    0x8(%ebp),%edx
  80293f:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802942:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802946:	75 17                	jne    80295f <alloc_block_NF+0x11c>
  802948:	83 ec 04             	sub    $0x4,%esp
  80294b:	68 d0 42 80 00       	push   $0x8042d0
  802950:	68 e9 00 00 00       	push   $0xe9
  802955:	68 27 42 80 00       	push   $0x804227
  80295a:	e8 77 db ff ff       	call   8004d6 <_panic>
  80295f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802962:	8b 00                	mov    (%eax),%eax
  802964:	85 c0                	test   %eax,%eax
  802966:	74 10                	je     802978 <alloc_block_NF+0x135>
  802968:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80296b:	8b 00                	mov    (%eax),%eax
  80296d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802970:	8b 52 04             	mov    0x4(%edx),%edx
  802973:	89 50 04             	mov    %edx,0x4(%eax)
  802976:	eb 0b                	jmp    802983 <alloc_block_NF+0x140>
  802978:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80297b:	8b 40 04             	mov    0x4(%eax),%eax
  80297e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802983:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802986:	8b 40 04             	mov    0x4(%eax),%eax
  802989:	85 c0                	test   %eax,%eax
  80298b:	74 0f                	je     80299c <alloc_block_NF+0x159>
  80298d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802990:	8b 40 04             	mov    0x4(%eax),%eax
  802993:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802996:	8b 12                	mov    (%edx),%edx
  802998:	89 10                	mov    %edx,(%eax)
  80299a:	eb 0a                	jmp    8029a6 <alloc_block_NF+0x163>
  80299c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80299f:	8b 00                	mov    (%eax),%eax
  8029a1:	a3 48 51 80 00       	mov    %eax,0x805148
  8029a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029a9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029b2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029b9:	a1 54 51 80 00       	mov    0x805154,%eax
  8029be:	48                   	dec    %eax
  8029bf:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  8029c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029c7:	8b 40 08             	mov    0x8(%eax),%eax
  8029ca:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  8029cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d2:	8b 50 08             	mov    0x8(%eax),%edx
  8029d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d8:	01 c2                	add    %eax,%edx
  8029da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029dd:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  8029e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e3:	8b 40 0c             	mov    0xc(%eax),%eax
  8029e6:	2b 45 08             	sub    0x8(%ebp),%eax
  8029e9:	89 c2                	mov    %eax,%edx
  8029eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ee:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  8029f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029f4:	e9 15 04 00 00       	jmp    802e0e <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8029f9:	a1 40 51 80 00       	mov    0x805140,%eax
  8029fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a01:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a05:	74 07                	je     802a0e <alloc_block_NF+0x1cb>
  802a07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0a:	8b 00                	mov    (%eax),%eax
  802a0c:	eb 05                	jmp    802a13 <alloc_block_NF+0x1d0>
  802a0e:	b8 00 00 00 00       	mov    $0x0,%eax
  802a13:	a3 40 51 80 00       	mov    %eax,0x805140
  802a18:	a1 40 51 80 00       	mov    0x805140,%eax
  802a1d:	85 c0                	test   %eax,%eax
  802a1f:	0f 85 3e fe ff ff    	jne    802863 <alloc_block_NF+0x20>
  802a25:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a29:	0f 85 34 fe ff ff    	jne    802863 <alloc_block_NF+0x20>
  802a2f:	e9 d5 03 00 00       	jmp    802e09 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802a34:	a1 38 51 80 00       	mov    0x805138,%eax
  802a39:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a3c:	e9 b1 01 00 00       	jmp    802bf2 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802a41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a44:	8b 50 08             	mov    0x8(%eax),%edx
  802a47:	a1 28 50 80 00       	mov    0x805028,%eax
  802a4c:	39 c2                	cmp    %eax,%edx
  802a4e:	0f 82 96 01 00 00    	jb     802bea <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802a54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a57:	8b 40 0c             	mov    0xc(%eax),%eax
  802a5a:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a5d:	0f 82 87 01 00 00    	jb     802bea <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802a63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a66:	8b 40 0c             	mov    0xc(%eax),%eax
  802a69:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a6c:	0f 85 95 00 00 00    	jne    802b07 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802a72:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a76:	75 17                	jne    802a8f <alloc_block_NF+0x24c>
  802a78:	83 ec 04             	sub    $0x4,%esp
  802a7b:	68 d0 42 80 00       	push   $0x8042d0
  802a80:	68 fc 00 00 00       	push   $0xfc
  802a85:	68 27 42 80 00       	push   $0x804227
  802a8a:	e8 47 da ff ff       	call   8004d6 <_panic>
  802a8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a92:	8b 00                	mov    (%eax),%eax
  802a94:	85 c0                	test   %eax,%eax
  802a96:	74 10                	je     802aa8 <alloc_block_NF+0x265>
  802a98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9b:	8b 00                	mov    (%eax),%eax
  802a9d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802aa0:	8b 52 04             	mov    0x4(%edx),%edx
  802aa3:	89 50 04             	mov    %edx,0x4(%eax)
  802aa6:	eb 0b                	jmp    802ab3 <alloc_block_NF+0x270>
  802aa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aab:	8b 40 04             	mov    0x4(%eax),%eax
  802aae:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ab3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab6:	8b 40 04             	mov    0x4(%eax),%eax
  802ab9:	85 c0                	test   %eax,%eax
  802abb:	74 0f                	je     802acc <alloc_block_NF+0x289>
  802abd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac0:	8b 40 04             	mov    0x4(%eax),%eax
  802ac3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ac6:	8b 12                	mov    (%edx),%edx
  802ac8:	89 10                	mov    %edx,(%eax)
  802aca:	eb 0a                	jmp    802ad6 <alloc_block_NF+0x293>
  802acc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802acf:	8b 00                	mov    (%eax),%eax
  802ad1:	a3 38 51 80 00       	mov    %eax,0x805138
  802ad6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802adf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ae9:	a1 44 51 80 00       	mov    0x805144,%eax
  802aee:	48                   	dec    %eax
  802aef:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802af4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af7:	8b 40 08             	mov    0x8(%eax),%eax
  802afa:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802aff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b02:	e9 07 03 00 00       	jmp    802e0e <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802b07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0a:	8b 40 0c             	mov    0xc(%eax),%eax
  802b0d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b10:	0f 86 d4 00 00 00    	jbe    802bea <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802b16:	a1 48 51 80 00       	mov    0x805148,%eax
  802b1b:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802b1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b21:	8b 50 08             	mov    0x8(%eax),%edx
  802b24:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b27:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802b2a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b2d:	8b 55 08             	mov    0x8(%ebp),%edx
  802b30:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802b33:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802b37:	75 17                	jne    802b50 <alloc_block_NF+0x30d>
  802b39:	83 ec 04             	sub    $0x4,%esp
  802b3c:	68 d0 42 80 00       	push   $0x8042d0
  802b41:	68 04 01 00 00       	push   $0x104
  802b46:	68 27 42 80 00       	push   $0x804227
  802b4b:	e8 86 d9 ff ff       	call   8004d6 <_panic>
  802b50:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b53:	8b 00                	mov    (%eax),%eax
  802b55:	85 c0                	test   %eax,%eax
  802b57:	74 10                	je     802b69 <alloc_block_NF+0x326>
  802b59:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b5c:	8b 00                	mov    (%eax),%eax
  802b5e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b61:	8b 52 04             	mov    0x4(%edx),%edx
  802b64:	89 50 04             	mov    %edx,0x4(%eax)
  802b67:	eb 0b                	jmp    802b74 <alloc_block_NF+0x331>
  802b69:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b6c:	8b 40 04             	mov    0x4(%eax),%eax
  802b6f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b74:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b77:	8b 40 04             	mov    0x4(%eax),%eax
  802b7a:	85 c0                	test   %eax,%eax
  802b7c:	74 0f                	je     802b8d <alloc_block_NF+0x34a>
  802b7e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b81:	8b 40 04             	mov    0x4(%eax),%eax
  802b84:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b87:	8b 12                	mov    (%edx),%edx
  802b89:	89 10                	mov    %edx,(%eax)
  802b8b:	eb 0a                	jmp    802b97 <alloc_block_NF+0x354>
  802b8d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b90:	8b 00                	mov    (%eax),%eax
  802b92:	a3 48 51 80 00       	mov    %eax,0x805148
  802b97:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b9a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ba0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ba3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802baa:	a1 54 51 80 00       	mov    0x805154,%eax
  802baf:	48                   	dec    %eax
  802bb0:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802bb5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bb8:	8b 40 08             	mov    0x8(%eax),%eax
  802bbb:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802bc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc3:	8b 50 08             	mov    0x8(%eax),%edx
  802bc6:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc9:	01 c2                	add    %eax,%edx
  802bcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bce:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802bd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd4:	8b 40 0c             	mov    0xc(%eax),%eax
  802bd7:	2b 45 08             	sub    0x8(%ebp),%eax
  802bda:	89 c2                	mov    %eax,%edx
  802bdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bdf:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802be2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802be5:	e9 24 02 00 00       	jmp    802e0e <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802bea:	a1 40 51 80 00       	mov    0x805140,%eax
  802bef:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bf2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bf6:	74 07                	je     802bff <alloc_block_NF+0x3bc>
  802bf8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bfb:	8b 00                	mov    (%eax),%eax
  802bfd:	eb 05                	jmp    802c04 <alloc_block_NF+0x3c1>
  802bff:	b8 00 00 00 00       	mov    $0x0,%eax
  802c04:	a3 40 51 80 00       	mov    %eax,0x805140
  802c09:	a1 40 51 80 00       	mov    0x805140,%eax
  802c0e:	85 c0                	test   %eax,%eax
  802c10:	0f 85 2b fe ff ff    	jne    802a41 <alloc_block_NF+0x1fe>
  802c16:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c1a:	0f 85 21 fe ff ff    	jne    802a41 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802c20:	a1 38 51 80 00       	mov    0x805138,%eax
  802c25:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c28:	e9 ae 01 00 00       	jmp    802ddb <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802c2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c30:	8b 50 08             	mov    0x8(%eax),%edx
  802c33:	a1 28 50 80 00       	mov    0x805028,%eax
  802c38:	39 c2                	cmp    %eax,%edx
  802c3a:	0f 83 93 01 00 00    	jae    802dd3 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802c40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c43:	8b 40 0c             	mov    0xc(%eax),%eax
  802c46:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c49:	0f 82 84 01 00 00    	jb     802dd3 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802c4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c52:	8b 40 0c             	mov    0xc(%eax),%eax
  802c55:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c58:	0f 85 95 00 00 00    	jne    802cf3 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802c5e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c62:	75 17                	jne    802c7b <alloc_block_NF+0x438>
  802c64:	83 ec 04             	sub    $0x4,%esp
  802c67:	68 d0 42 80 00       	push   $0x8042d0
  802c6c:	68 14 01 00 00       	push   $0x114
  802c71:	68 27 42 80 00       	push   $0x804227
  802c76:	e8 5b d8 ff ff       	call   8004d6 <_panic>
  802c7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c7e:	8b 00                	mov    (%eax),%eax
  802c80:	85 c0                	test   %eax,%eax
  802c82:	74 10                	je     802c94 <alloc_block_NF+0x451>
  802c84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c87:	8b 00                	mov    (%eax),%eax
  802c89:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c8c:	8b 52 04             	mov    0x4(%edx),%edx
  802c8f:	89 50 04             	mov    %edx,0x4(%eax)
  802c92:	eb 0b                	jmp    802c9f <alloc_block_NF+0x45c>
  802c94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c97:	8b 40 04             	mov    0x4(%eax),%eax
  802c9a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca2:	8b 40 04             	mov    0x4(%eax),%eax
  802ca5:	85 c0                	test   %eax,%eax
  802ca7:	74 0f                	je     802cb8 <alloc_block_NF+0x475>
  802ca9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cac:	8b 40 04             	mov    0x4(%eax),%eax
  802caf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cb2:	8b 12                	mov    (%edx),%edx
  802cb4:	89 10                	mov    %edx,(%eax)
  802cb6:	eb 0a                	jmp    802cc2 <alloc_block_NF+0x47f>
  802cb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cbb:	8b 00                	mov    (%eax),%eax
  802cbd:	a3 38 51 80 00       	mov    %eax,0x805138
  802cc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ccb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cce:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cd5:	a1 44 51 80 00       	mov    0x805144,%eax
  802cda:	48                   	dec    %eax
  802cdb:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802ce0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce3:	8b 40 08             	mov    0x8(%eax),%eax
  802ce6:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802ceb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cee:	e9 1b 01 00 00       	jmp    802e0e <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802cf3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf6:	8b 40 0c             	mov    0xc(%eax),%eax
  802cf9:	3b 45 08             	cmp    0x8(%ebp),%eax
  802cfc:	0f 86 d1 00 00 00    	jbe    802dd3 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802d02:	a1 48 51 80 00       	mov    0x805148,%eax
  802d07:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802d0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0d:	8b 50 08             	mov    0x8(%eax),%edx
  802d10:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d13:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802d16:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d19:	8b 55 08             	mov    0x8(%ebp),%edx
  802d1c:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802d1f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802d23:	75 17                	jne    802d3c <alloc_block_NF+0x4f9>
  802d25:	83 ec 04             	sub    $0x4,%esp
  802d28:	68 d0 42 80 00       	push   $0x8042d0
  802d2d:	68 1c 01 00 00       	push   $0x11c
  802d32:	68 27 42 80 00       	push   $0x804227
  802d37:	e8 9a d7 ff ff       	call   8004d6 <_panic>
  802d3c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d3f:	8b 00                	mov    (%eax),%eax
  802d41:	85 c0                	test   %eax,%eax
  802d43:	74 10                	je     802d55 <alloc_block_NF+0x512>
  802d45:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d48:	8b 00                	mov    (%eax),%eax
  802d4a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d4d:	8b 52 04             	mov    0x4(%edx),%edx
  802d50:	89 50 04             	mov    %edx,0x4(%eax)
  802d53:	eb 0b                	jmp    802d60 <alloc_block_NF+0x51d>
  802d55:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d58:	8b 40 04             	mov    0x4(%eax),%eax
  802d5b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d60:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d63:	8b 40 04             	mov    0x4(%eax),%eax
  802d66:	85 c0                	test   %eax,%eax
  802d68:	74 0f                	je     802d79 <alloc_block_NF+0x536>
  802d6a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d6d:	8b 40 04             	mov    0x4(%eax),%eax
  802d70:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d73:	8b 12                	mov    (%edx),%edx
  802d75:	89 10                	mov    %edx,(%eax)
  802d77:	eb 0a                	jmp    802d83 <alloc_block_NF+0x540>
  802d79:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d7c:	8b 00                	mov    (%eax),%eax
  802d7e:	a3 48 51 80 00       	mov    %eax,0x805148
  802d83:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d86:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d8c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d8f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d96:	a1 54 51 80 00       	mov    0x805154,%eax
  802d9b:	48                   	dec    %eax
  802d9c:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802da1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802da4:	8b 40 08             	mov    0x8(%eax),%eax
  802da7:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802dac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802daf:	8b 50 08             	mov    0x8(%eax),%edx
  802db2:	8b 45 08             	mov    0x8(%ebp),%eax
  802db5:	01 c2                	add    %eax,%edx
  802db7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dba:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802dbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc0:	8b 40 0c             	mov    0xc(%eax),%eax
  802dc3:	2b 45 08             	sub    0x8(%ebp),%eax
  802dc6:	89 c2                	mov    %eax,%edx
  802dc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dcb:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802dce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dd1:	eb 3b                	jmp    802e0e <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802dd3:	a1 40 51 80 00       	mov    0x805140,%eax
  802dd8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ddb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ddf:	74 07                	je     802de8 <alloc_block_NF+0x5a5>
  802de1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de4:	8b 00                	mov    (%eax),%eax
  802de6:	eb 05                	jmp    802ded <alloc_block_NF+0x5aa>
  802de8:	b8 00 00 00 00       	mov    $0x0,%eax
  802ded:	a3 40 51 80 00       	mov    %eax,0x805140
  802df2:	a1 40 51 80 00       	mov    0x805140,%eax
  802df7:	85 c0                	test   %eax,%eax
  802df9:	0f 85 2e fe ff ff    	jne    802c2d <alloc_block_NF+0x3ea>
  802dff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e03:	0f 85 24 fe ff ff    	jne    802c2d <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802e09:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e0e:	c9                   	leave  
  802e0f:	c3                   	ret    

00802e10 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802e10:	55                   	push   %ebp
  802e11:	89 e5                	mov    %esp,%ebp
  802e13:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802e16:	a1 38 51 80 00       	mov    0x805138,%eax
  802e1b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802e1e:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802e23:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802e26:	a1 38 51 80 00       	mov    0x805138,%eax
  802e2b:	85 c0                	test   %eax,%eax
  802e2d:	74 14                	je     802e43 <insert_sorted_with_merge_freeList+0x33>
  802e2f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e32:	8b 50 08             	mov    0x8(%eax),%edx
  802e35:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e38:	8b 40 08             	mov    0x8(%eax),%eax
  802e3b:	39 c2                	cmp    %eax,%edx
  802e3d:	0f 87 9b 01 00 00    	ja     802fde <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802e43:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e47:	75 17                	jne    802e60 <insert_sorted_with_merge_freeList+0x50>
  802e49:	83 ec 04             	sub    $0x4,%esp
  802e4c:	68 04 42 80 00       	push   $0x804204
  802e51:	68 38 01 00 00       	push   $0x138
  802e56:	68 27 42 80 00       	push   $0x804227
  802e5b:	e8 76 d6 ff ff       	call   8004d6 <_panic>
  802e60:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802e66:	8b 45 08             	mov    0x8(%ebp),%eax
  802e69:	89 10                	mov    %edx,(%eax)
  802e6b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e6e:	8b 00                	mov    (%eax),%eax
  802e70:	85 c0                	test   %eax,%eax
  802e72:	74 0d                	je     802e81 <insert_sorted_with_merge_freeList+0x71>
  802e74:	a1 38 51 80 00       	mov    0x805138,%eax
  802e79:	8b 55 08             	mov    0x8(%ebp),%edx
  802e7c:	89 50 04             	mov    %edx,0x4(%eax)
  802e7f:	eb 08                	jmp    802e89 <insert_sorted_with_merge_freeList+0x79>
  802e81:	8b 45 08             	mov    0x8(%ebp),%eax
  802e84:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e89:	8b 45 08             	mov    0x8(%ebp),%eax
  802e8c:	a3 38 51 80 00       	mov    %eax,0x805138
  802e91:	8b 45 08             	mov    0x8(%ebp),%eax
  802e94:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e9b:	a1 44 51 80 00       	mov    0x805144,%eax
  802ea0:	40                   	inc    %eax
  802ea1:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802ea6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802eaa:	0f 84 a8 06 00 00    	je     803558 <insert_sorted_with_merge_freeList+0x748>
  802eb0:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb3:	8b 50 08             	mov    0x8(%eax),%edx
  802eb6:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb9:	8b 40 0c             	mov    0xc(%eax),%eax
  802ebc:	01 c2                	add    %eax,%edx
  802ebe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ec1:	8b 40 08             	mov    0x8(%eax),%eax
  802ec4:	39 c2                	cmp    %eax,%edx
  802ec6:	0f 85 8c 06 00 00    	jne    803558 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802ecc:	8b 45 08             	mov    0x8(%ebp),%eax
  802ecf:	8b 50 0c             	mov    0xc(%eax),%edx
  802ed2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ed5:	8b 40 0c             	mov    0xc(%eax),%eax
  802ed8:	01 c2                	add    %eax,%edx
  802eda:	8b 45 08             	mov    0x8(%ebp),%eax
  802edd:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802ee0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ee4:	75 17                	jne    802efd <insert_sorted_with_merge_freeList+0xed>
  802ee6:	83 ec 04             	sub    $0x4,%esp
  802ee9:	68 d0 42 80 00       	push   $0x8042d0
  802eee:	68 3c 01 00 00       	push   $0x13c
  802ef3:	68 27 42 80 00       	push   $0x804227
  802ef8:	e8 d9 d5 ff ff       	call   8004d6 <_panic>
  802efd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f00:	8b 00                	mov    (%eax),%eax
  802f02:	85 c0                	test   %eax,%eax
  802f04:	74 10                	je     802f16 <insert_sorted_with_merge_freeList+0x106>
  802f06:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f09:	8b 00                	mov    (%eax),%eax
  802f0b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f0e:	8b 52 04             	mov    0x4(%edx),%edx
  802f11:	89 50 04             	mov    %edx,0x4(%eax)
  802f14:	eb 0b                	jmp    802f21 <insert_sorted_with_merge_freeList+0x111>
  802f16:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f19:	8b 40 04             	mov    0x4(%eax),%eax
  802f1c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f21:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f24:	8b 40 04             	mov    0x4(%eax),%eax
  802f27:	85 c0                	test   %eax,%eax
  802f29:	74 0f                	je     802f3a <insert_sorted_with_merge_freeList+0x12a>
  802f2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f2e:	8b 40 04             	mov    0x4(%eax),%eax
  802f31:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f34:	8b 12                	mov    (%edx),%edx
  802f36:	89 10                	mov    %edx,(%eax)
  802f38:	eb 0a                	jmp    802f44 <insert_sorted_with_merge_freeList+0x134>
  802f3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f3d:	8b 00                	mov    (%eax),%eax
  802f3f:	a3 38 51 80 00       	mov    %eax,0x805138
  802f44:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f47:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f50:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f57:	a1 44 51 80 00       	mov    0x805144,%eax
  802f5c:	48                   	dec    %eax
  802f5d:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802f62:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f65:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802f6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f6f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802f76:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f7a:	75 17                	jne    802f93 <insert_sorted_with_merge_freeList+0x183>
  802f7c:	83 ec 04             	sub    $0x4,%esp
  802f7f:	68 04 42 80 00       	push   $0x804204
  802f84:	68 3f 01 00 00       	push   $0x13f
  802f89:	68 27 42 80 00       	push   $0x804227
  802f8e:	e8 43 d5 ff ff       	call   8004d6 <_panic>
  802f93:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802f99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f9c:	89 10                	mov    %edx,(%eax)
  802f9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fa1:	8b 00                	mov    (%eax),%eax
  802fa3:	85 c0                	test   %eax,%eax
  802fa5:	74 0d                	je     802fb4 <insert_sorted_with_merge_freeList+0x1a4>
  802fa7:	a1 48 51 80 00       	mov    0x805148,%eax
  802fac:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802faf:	89 50 04             	mov    %edx,0x4(%eax)
  802fb2:	eb 08                	jmp    802fbc <insert_sorted_with_merge_freeList+0x1ac>
  802fb4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fb7:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802fbc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fbf:	a3 48 51 80 00       	mov    %eax,0x805148
  802fc4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fc7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fce:	a1 54 51 80 00       	mov    0x805154,%eax
  802fd3:	40                   	inc    %eax
  802fd4:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802fd9:	e9 7a 05 00 00       	jmp    803558 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802fde:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe1:	8b 50 08             	mov    0x8(%eax),%edx
  802fe4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fe7:	8b 40 08             	mov    0x8(%eax),%eax
  802fea:	39 c2                	cmp    %eax,%edx
  802fec:	0f 82 14 01 00 00    	jb     803106 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802ff2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ff5:	8b 50 08             	mov    0x8(%eax),%edx
  802ff8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ffb:	8b 40 0c             	mov    0xc(%eax),%eax
  802ffe:	01 c2                	add    %eax,%edx
  803000:	8b 45 08             	mov    0x8(%ebp),%eax
  803003:	8b 40 08             	mov    0x8(%eax),%eax
  803006:	39 c2                	cmp    %eax,%edx
  803008:	0f 85 90 00 00 00    	jne    80309e <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  80300e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803011:	8b 50 0c             	mov    0xc(%eax),%edx
  803014:	8b 45 08             	mov    0x8(%ebp),%eax
  803017:	8b 40 0c             	mov    0xc(%eax),%eax
  80301a:	01 c2                	add    %eax,%edx
  80301c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80301f:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  803022:	8b 45 08             	mov    0x8(%ebp),%eax
  803025:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  80302c:	8b 45 08             	mov    0x8(%ebp),%eax
  80302f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803036:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80303a:	75 17                	jne    803053 <insert_sorted_with_merge_freeList+0x243>
  80303c:	83 ec 04             	sub    $0x4,%esp
  80303f:	68 04 42 80 00       	push   $0x804204
  803044:	68 49 01 00 00       	push   $0x149
  803049:	68 27 42 80 00       	push   $0x804227
  80304e:	e8 83 d4 ff ff       	call   8004d6 <_panic>
  803053:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803059:	8b 45 08             	mov    0x8(%ebp),%eax
  80305c:	89 10                	mov    %edx,(%eax)
  80305e:	8b 45 08             	mov    0x8(%ebp),%eax
  803061:	8b 00                	mov    (%eax),%eax
  803063:	85 c0                	test   %eax,%eax
  803065:	74 0d                	je     803074 <insert_sorted_with_merge_freeList+0x264>
  803067:	a1 48 51 80 00       	mov    0x805148,%eax
  80306c:	8b 55 08             	mov    0x8(%ebp),%edx
  80306f:	89 50 04             	mov    %edx,0x4(%eax)
  803072:	eb 08                	jmp    80307c <insert_sorted_with_merge_freeList+0x26c>
  803074:	8b 45 08             	mov    0x8(%ebp),%eax
  803077:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80307c:	8b 45 08             	mov    0x8(%ebp),%eax
  80307f:	a3 48 51 80 00       	mov    %eax,0x805148
  803084:	8b 45 08             	mov    0x8(%ebp),%eax
  803087:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80308e:	a1 54 51 80 00       	mov    0x805154,%eax
  803093:	40                   	inc    %eax
  803094:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803099:	e9 bb 04 00 00       	jmp    803559 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  80309e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030a2:	75 17                	jne    8030bb <insert_sorted_with_merge_freeList+0x2ab>
  8030a4:	83 ec 04             	sub    $0x4,%esp
  8030a7:	68 78 42 80 00       	push   $0x804278
  8030ac:	68 4c 01 00 00       	push   $0x14c
  8030b1:	68 27 42 80 00       	push   $0x804227
  8030b6:	e8 1b d4 ff ff       	call   8004d6 <_panic>
  8030bb:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  8030c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c4:	89 50 04             	mov    %edx,0x4(%eax)
  8030c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ca:	8b 40 04             	mov    0x4(%eax),%eax
  8030cd:	85 c0                	test   %eax,%eax
  8030cf:	74 0c                	je     8030dd <insert_sorted_with_merge_freeList+0x2cd>
  8030d1:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8030d6:	8b 55 08             	mov    0x8(%ebp),%edx
  8030d9:	89 10                	mov    %edx,(%eax)
  8030db:	eb 08                	jmp    8030e5 <insert_sorted_with_merge_freeList+0x2d5>
  8030dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e0:	a3 38 51 80 00       	mov    %eax,0x805138
  8030e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e8:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8030ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030f6:	a1 44 51 80 00       	mov    0x805144,%eax
  8030fb:	40                   	inc    %eax
  8030fc:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803101:	e9 53 04 00 00       	jmp    803559 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803106:	a1 38 51 80 00       	mov    0x805138,%eax
  80310b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80310e:	e9 15 04 00 00       	jmp    803528 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  803113:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803116:	8b 00                	mov    (%eax),%eax
  803118:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  80311b:	8b 45 08             	mov    0x8(%ebp),%eax
  80311e:	8b 50 08             	mov    0x8(%eax),%edx
  803121:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803124:	8b 40 08             	mov    0x8(%eax),%eax
  803127:	39 c2                	cmp    %eax,%edx
  803129:	0f 86 f1 03 00 00    	jbe    803520 <insert_sorted_with_merge_freeList+0x710>
  80312f:	8b 45 08             	mov    0x8(%ebp),%eax
  803132:	8b 50 08             	mov    0x8(%eax),%edx
  803135:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803138:	8b 40 08             	mov    0x8(%eax),%eax
  80313b:	39 c2                	cmp    %eax,%edx
  80313d:	0f 83 dd 03 00 00    	jae    803520 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  803143:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803146:	8b 50 08             	mov    0x8(%eax),%edx
  803149:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80314c:	8b 40 0c             	mov    0xc(%eax),%eax
  80314f:	01 c2                	add    %eax,%edx
  803151:	8b 45 08             	mov    0x8(%ebp),%eax
  803154:	8b 40 08             	mov    0x8(%eax),%eax
  803157:	39 c2                	cmp    %eax,%edx
  803159:	0f 85 b9 01 00 00    	jne    803318 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  80315f:	8b 45 08             	mov    0x8(%ebp),%eax
  803162:	8b 50 08             	mov    0x8(%eax),%edx
  803165:	8b 45 08             	mov    0x8(%ebp),%eax
  803168:	8b 40 0c             	mov    0xc(%eax),%eax
  80316b:	01 c2                	add    %eax,%edx
  80316d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803170:	8b 40 08             	mov    0x8(%eax),%eax
  803173:	39 c2                	cmp    %eax,%edx
  803175:	0f 85 0d 01 00 00    	jne    803288 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  80317b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80317e:	8b 50 0c             	mov    0xc(%eax),%edx
  803181:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803184:	8b 40 0c             	mov    0xc(%eax),%eax
  803187:	01 c2                	add    %eax,%edx
  803189:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80318c:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80318f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803193:	75 17                	jne    8031ac <insert_sorted_with_merge_freeList+0x39c>
  803195:	83 ec 04             	sub    $0x4,%esp
  803198:	68 d0 42 80 00       	push   $0x8042d0
  80319d:	68 5c 01 00 00       	push   $0x15c
  8031a2:	68 27 42 80 00       	push   $0x804227
  8031a7:	e8 2a d3 ff ff       	call   8004d6 <_panic>
  8031ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031af:	8b 00                	mov    (%eax),%eax
  8031b1:	85 c0                	test   %eax,%eax
  8031b3:	74 10                	je     8031c5 <insert_sorted_with_merge_freeList+0x3b5>
  8031b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031b8:	8b 00                	mov    (%eax),%eax
  8031ba:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031bd:	8b 52 04             	mov    0x4(%edx),%edx
  8031c0:	89 50 04             	mov    %edx,0x4(%eax)
  8031c3:	eb 0b                	jmp    8031d0 <insert_sorted_with_merge_freeList+0x3c0>
  8031c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031c8:	8b 40 04             	mov    0x4(%eax),%eax
  8031cb:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8031d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031d3:	8b 40 04             	mov    0x4(%eax),%eax
  8031d6:	85 c0                	test   %eax,%eax
  8031d8:	74 0f                	je     8031e9 <insert_sorted_with_merge_freeList+0x3d9>
  8031da:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031dd:	8b 40 04             	mov    0x4(%eax),%eax
  8031e0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031e3:	8b 12                	mov    (%edx),%edx
  8031e5:	89 10                	mov    %edx,(%eax)
  8031e7:	eb 0a                	jmp    8031f3 <insert_sorted_with_merge_freeList+0x3e3>
  8031e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ec:	8b 00                	mov    (%eax),%eax
  8031ee:	a3 38 51 80 00       	mov    %eax,0x805138
  8031f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031f6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ff:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803206:	a1 44 51 80 00       	mov    0x805144,%eax
  80320b:	48                   	dec    %eax
  80320c:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  803211:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803214:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  80321b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80321e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803225:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803229:	75 17                	jne    803242 <insert_sorted_with_merge_freeList+0x432>
  80322b:	83 ec 04             	sub    $0x4,%esp
  80322e:	68 04 42 80 00       	push   $0x804204
  803233:	68 5f 01 00 00       	push   $0x15f
  803238:	68 27 42 80 00       	push   $0x804227
  80323d:	e8 94 d2 ff ff       	call   8004d6 <_panic>
  803242:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803248:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80324b:	89 10                	mov    %edx,(%eax)
  80324d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803250:	8b 00                	mov    (%eax),%eax
  803252:	85 c0                	test   %eax,%eax
  803254:	74 0d                	je     803263 <insert_sorted_with_merge_freeList+0x453>
  803256:	a1 48 51 80 00       	mov    0x805148,%eax
  80325b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80325e:	89 50 04             	mov    %edx,0x4(%eax)
  803261:	eb 08                	jmp    80326b <insert_sorted_with_merge_freeList+0x45b>
  803263:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803266:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80326b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80326e:	a3 48 51 80 00       	mov    %eax,0x805148
  803273:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803276:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80327d:	a1 54 51 80 00       	mov    0x805154,%eax
  803282:	40                   	inc    %eax
  803283:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803288:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80328b:	8b 50 0c             	mov    0xc(%eax),%edx
  80328e:	8b 45 08             	mov    0x8(%ebp),%eax
  803291:	8b 40 0c             	mov    0xc(%eax),%eax
  803294:	01 c2                	add    %eax,%edx
  803296:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803299:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  80329c:	8b 45 08             	mov    0x8(%ebp),%eax
  80329f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  8032a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8032b0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032b4:	75 17                	jne    8032cd <insert_sorted_with_merge_freeList+0x4bd>
  8032b6:	83 ec 04             	sub    $0x4,%esp
  8032b9:	68 04 42 80 00       	push   $0x804204
  8032be:	68 64 01 00 00       	push   $0x164
  8032c3:	68 27 42 80 00       	push   $0x804227
  8032c8:	e8 09 d2 ff ff       	call   8004d6 <_panic>
  8032cd:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8032d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d6:	89 10                	mov    %edx,(%eax)
  8032d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8032db:	8b 00                	mov    (%eax),%eax
  8032dd:	85 c0                	test   %eax,%eax
  8032df:	74 0d                	je     8032ee <insert_sorted_with_merge_freeList+0x4de>
  8032e1:	a1 48 51 80 00       	mov    0x805148,%eax
  8032e6:	8b 55 08             	mov    0x8(%ebp),%edx
  8032e9:	89 50 04             	mov    %edx,0x4(%eax)
  8032ec:	eb 08                	jmp    8032f6 <insert_sorted_with_merge_freeList+0x4e6>
  8032ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f1:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8032f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f9:	a3 48 51 80 00       	mov    %eax,0x805148
  8032fe:	8b 45 08             	mov    0x8(%ebp),%eax
  803301:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803308:	a1 54 51 80 00       	mov    0x805154,%eax
  80330d:	40                   	inc    %eax
  80330e:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803313:	e9 41 02 00 00       	jmp    803559 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803318:	8b 45 08             	mov    0x8(%ebp),%eax
  80331b:	8b 50 08             	mov    0x8(%eax),%edx
  80331e:	8b 45 08             	mov    0x8(%ebp),%eax
  803321:	8b 40 0c             	mov    0xc(%eax),%eax
  803324:	01 c2                	add    %eax,%edx
  803326:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803329:	8b 40 08             	mov    0x8(%eax),%eax
  80332c:	39 c2                	cmp    %eax,%edx
  80332e:	0f 85 7c 01 00 00    	jne    8034b0 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803334:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803338:	74 06                	je     803340 <insert_sorted_with_merge_freeList+0x530>
  80333a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80333e:	75 17                	jne    803357 <insert_sorted_with_merge_freeList+0x547>
  803340:	83 ec 04             	sub    $0x4,%esp
  803343:	68 40 42 80 00       	push   $0x804240
  803348:	68 69 01 00 00       	push   $0x169
  80334d:	68 27 42 80 00       	push   $0x804227
  803352:	e8 7f d1 ff ff       	call   8004d6 <_panic>
  803357:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80335a:	8b 50 04             	mov    0x4(%eax),%edx
  80335d:	8b 45 08             	mov    0x8(%ebp),%eax
  803360:	89 50 04             	mov    %edx,0x4(%eax)
  803363:	8b 45 08             	mov    0x8(%ebp),%eax
  803366:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803369:	89 10                	mov    %edx,(%eax)
  80336b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80336e:	8b 40 04             	mov    0x4(%eax),%eax
  803371:	85 c0                	test   %eax,%eax
  803373:	74 0d                	je     803382 <insert_sorted_with_merge_freeList+0x572>
  803375:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803378:	8b 40 04             	mov    0x4(%eax),%eax
  80337b:	8b 55 08             	mov    0x8(%ebp),%edx
  80337e:	89 10                	mov    %edx,(%eax)
  803380:	eb 08                	jmp    80338a <insert_sorted_with_merge_freeList+0x57a>
  803382:	8b 45 08             	mov    0x8(%ebp),%eax
  803385:	a3 38 51 80 00       	mov    %eax,0x805138
  80338a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80338d:	8b 55 08             	mov    0x8(%ebp),%edx
  803390:	89 50 04             	mov    %edx,0x4(%eax)
  803393:	a1 44 51 80 00       	mov    0x805144,%eax
  803398:	40                   	inc    %eax
  803399:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  80339e:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a1:	8b 50 0c             	mov    0xc(%eax),%edx
  8033a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033a7:	8b 40 0c             	mov    0xc(%eax),%eax
  8033aa:	01 c2                	add    %eax,%edx
  8033ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8033af:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8033b2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8033b6:	75 17                	jne    8033cf <insert_sorted_with_merge_freeList+0x5bf>
  8033b8:	83 ec 04             	sub    $0x4,%esp
  8033bb:	68 d0 42 80 00       	push   $0x8042d0
  8033c0:	68 6b 01 00 00       	push   $0x16b
  8033c5:	68 27 42 80 00       	push   $0x804227
  8033ca:	e8 07 d1 ff ff       	call   8004d6 <_panic>
  8033cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033d2:	8b 00                	mov    (%eax),%eax
  8033d4:	85 c0                	test   %eax,%eax
  8033d6:	74 10                	je     8033e8 <insert_sorted_with_merge_freeList+0x5d8>
  8033d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033db:	8b 00                	mov    (%eax),%eax
  8033dd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8033e0:	8b 52 04             	mov    0x4(%edx),%edx
  8033e3:	89 50 04             	mov    %edx,0x4(%eax)
  8033e6:	eb 0b                	jmp    8033f3 <insert_sorted_with_merge_freeList+0x5e3>
  8033e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033eb:	8b 40 04             	mov    0x4(%eax),%eax
  8033ee:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8033f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033f6:	8b 40 04             	mov    0x4(%eax),%eax
  8033f9:	85 c0                	test   %eax,%eax
  8033fb:	74 0f                	je     80340c <insert_sorted_with_merge_freeList+0x5fc>
  8033fd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803400:	8b 40 04             	mov    0x4(%eax),%eax
  803403:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803406:	8b 12                	mov    (%edx),%edx
  803408:	89 10                	mov    %edx,(%eax)
  80340a:	eb 0a                	jmp    803416 <insert_sorted_with_merge_freeList+0x606>
  80340c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80340f:	8b 00                	mov    (%eax),%eax
  803411:	a3 38 51 80 00       	mov    %eax,0x805138
  803416:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803419:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80341f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803422:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803429:	a1 44 51 80 00       	mov    0x805144,%eax
  80342e:	48                   	dec    %eax
  80342f:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803434:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803437:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  80343e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803441:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803448:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80344c:	75 17                	jne    803465 <insert_sorted_with_merge_freeList+0x655>
  80344e:	83 ec 04             	sub    $0x4,%esp
  803451:	68 04 42 80 00       	push   $0x804204
  803456:	68 6e 01 00 00       	push   $0x16e
  80345b:	68 27 42 80 00       	push   $0x804227
  803460:	e8 71 d0 ff ff       	call   8004d6 <_panic>
  803465:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80346b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80346e:	89 10                	mov    %edx,(%eax)
  803470:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803473:	8b 00                	mov    (%eax),%eax
  803475:	85 c0                	test   %eax,%eax
  803477:	74 0d                	je     803486 <insert_sorted_with_merge_freeList+0x676>
  803479:	a1 48 51 80 00       	mov    0x805148,%eax
  80347e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803481:	89 50 04             	mov    %edx,0x4(%eax)
  803484:	eb 08                	jmp    80348e <insert_sorted_with_merge_freeList+0x67e>
  803486:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803489:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80348e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803491:	a3 48 51 80 00       	mov    %eax,0x805148
  803496:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803499:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034a0:	a1 54 51 80 00       	mov    0x805154,%eax
  8034a5:	40                   	inc    %eax
  8034a6:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8034ab:	e9 a9 00 00 00       	jmp    803559 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  8034b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034b4:	74 06                	je     8034bc <insert_sorted_with_merge_freeList+0x6ac>
  8034b6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034ba:	75 17                	jne    8034d3 <insert_sorted_with_merge_freeList+0x6c3>
  8034bc:	83 ec 04             	sub    $0x4,%esp
  8034bf:	68 9c 42 80 00       	push   $0x80429c
  8034c4:	68 73 01 00 00       	push   $0x173
  8034c9:	68 27 42 80 00       	push   $0x804227
  8034ce:	e8 03 d0 ff ff       	call   8004d6 <_panic>
  8034d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034d6:	8b 10                	mov    (%eax),%edx
  8034d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8034db:	89 10                	mov    %edx,(%eax)
  8034dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e0:	8b 00                	mov    (%eax),%eax
  8034e2:	85 c0                	test   %eax,%eax
  8034e4:	74 0b                	je     8034f1 <insert_sorted_with_merge_freeList+0x6e1>
  8034e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034e9:	8b 00                	mov    (%eax),%eax
  8034eb:	8b 55 08             	mov    0x8(%ebp),%edx
  8034ee:	89 50 04             	mov    %edx,0x4(%eax)
  8034f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034f4:	8b 55 08             	mov    0x8(%ebp),%edx
  8034f7:	89 10                	mov    %edx,(%eax)
  8034f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8034fc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8034ff:	89 50 04             	mov    %edx,0x4(%eax)
  803502:	8b 45 08             	mov    0x8(%ebp),%eax
  803505:	8b 00                	mov    (%eax),%eax
  803507:	85 c0                	test   %eax,%eax
  803509:	75 08                	jne    803513 <insert_sorted_with_merge_freeList+0x703>
  80350b:	8b 45 08             	mov    0x8(%ebp),%eax
  80350e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803513:	a1 44 51 80 00       	mov    0x805144,%eax
  803518:	40                   	inc    %eax
  803519:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  80351e:	eb 39                	jmp    803559 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803520:	a1 40 51 80 00       	mov    0x805140,%eax
  803525:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803528:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80352c:	74 07                	je     803535 <insert_sorted_with_merge_freeList+0x725>
  80352e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803531:	8b 00                	mov    (%eax),%eax
  803533:	eb 05                	jmp    80353a <insert_sorted_with_merge_freeList+0x72a>
  803535:	b8 00 00 00 00       	mov    $0x0,%eax
  80353a:	a3 40 51 80 00       	mov    %eax,0x805140
  80353f:	a1 40 51 80 00       	mov    0x805140,%eax
  803544:	85 c0                	test   %eax,%eax
  803546:	0f 85 c7 fb ff ff    	jne    803113 <insert_sorted_with_merge_freeList+0x303>
  80354c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803550:	0f 85 bd fb ff ff    	jne    803113 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803556:	eb 01                	jmp    803559 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803558:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803559:	90                   	nop
  80355a:	c9                   	leave  
  80355b:	c3                   	ret    

0080355c <__udivdi3>:
  80355c:	55                   	push   %ebp
  80355d:	57                   	push   %edi
  80355e:	56                   	push   %esi
  80355f:	53                   	push   %ebx
  803560:	83 ec 1c             	sub    $0x1c,%esp
  803563:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803567:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80356b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80356f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803573:	89 ca                	mov    %ecx,%edx
  803575:	89 f8                	mov    %edi,%eax
  803577:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80357b:	85 f6                	test   %esi,%esi
  80357d:	75 2d                	jne    8035ac <__udivdi3+0x50>
  80357f:	39 cf                	cmp    %ecx,%edi
  803581:	77 65                	ja     8035e8 <__udivdi3+0x8c>
  803583:	89 fd                	mov    %edi,%ebp
  803585:	85 ff                	test   %edi,%edi
  803587:	75 0b                	jne    803594 <__udivdi3+0x38>
  803589:	b8 01 00 00 00       	mov    $0x1,%eax
  80358e:	31 d2                	xor    %edx,%edx
  803590:	f7 f7                	div    %edi
  803592:	89 c5                	mov    %eax,%ebp
  803594:	31 d2                	xor    %edx,%edx
  803596:	89 c8                	mov    %ecx,%eax
  803598:	f7 f5                	div    %ebp
  80359a:	89 c1                	mov    %eax,%ecx
  80359c:	89 d8                	mov    %ebx,%eax
  80359e:	f7 f5                	div    %ebp
  8035a0:	89 cf                	mov    %ecx,%edi
  8035a2:	89 fa                	mov    %edi,%edx
  8035a4:	83 c4 1c             	add    $0x1c,%esp
  8035a7:	5b                   	pop    %ebx
  8035a8:	5e                   	pop    %esi
  8035a9:	5f                   	pop    %edi
  8035aa:	5d                   	pop    %ebp
  8035ab:	c3                   	ret    
  8035ac:	39 ce                	cmp    %ecx,%esi
  8035ae:	77 28                	ja     8035d8 <__udivdi3+0x7c>
  8035b0:	0f bd fe             	bsr    %esi,%edi
  8035b3:	83 f7 1f             	xor    $0x1f,%edi
  8035b6:	75 40                	jne    8035f8 <__udivdi3+0x9c>
  8035b8:	39 ce                	cmp    %ecx,%esi
  8035ba:	72 0a                	jb     8035c6 <__udivdi3+0x6a>
  8035bc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8035c0:	0f 87 9e 00 00 00    	ja     803664 <__udivdi3+0x108>
  8035c6:	b8 01 00 00 00       	mov    $0x1,%eax
  8035cb:	89 fa                	mov    %edi,%edx
  8035cd:	83 c4 1c             	add    $0x1c,%esp
  8035d0:	5b                   	pop    %ebx
  8035d1:	5e                   	pop    %esi
  8035d2:	5f                   	pop    %edi
  8035d3:	5d                   	pop    %ebp
  8035d4:	c3                   	ret    
  8035d5:	8d 76 00             	lea    0x0(%esi),%esi
  8035d8:	31 ff                	xor    %edi,%edi
  8035da:	31 c0                	xor    %eax,%eax
  8035dc:	89 fa                	mov    %edi,%edx
  8035de:	83 c4 1c             	add    $0x1c,%esp
  8035e1:	5b                   	pop    %ebx
  8035e2:	5e                   	pop    %esi
  8035e3:	5f                   	pop    %edi
  8035e4:	5d                   	pop    %ebp
  8035e5:	c3                   	ret    
  8035e6:	66 90                	xchg   %ax,%ax
  8035e8:	89 d8                	mov    %ebx,%eax
  8035ea:	f7 f7                	div    %edi
  8035ec:	31 ff                	xor    %edi,%edi
  8035ee:	89 fa                	mov    %edi,%edx
  8035f0:	83 c4 1c             	add    $0x1c,%esp
  8035f3:	5b                   	pop    %ebx
  8035f4:	5e                   	pop    %esi
  8035f5:	5f                   	pop    %edi
  8035f6:	5d                   	pop    %ebp
  8035f7:	c3                   	ret    
  8035f8:	bd 20 00 00 00       	mov    $0x20,%ebp
  8035fd:	89 eb                	mov    %ebp,%ebx
  8035ff:	29 fb                	sub    %edi,%ebx
  803601:	89 f9                	mov    %edi,%ecx
  803603:	d3 e6                	shl    %cl,%esi
  803605:	89 c5                	mov    %eax,%ebp
  803607:	88 d9                	mov    %bl,%cl
  803609:	d3 ed                	shr    %cl,%ebp
  80360b:	89 e9                	mov    %ebp,%ecx
  80360d:	09 f1                	or     %esi,%ecx
  80360f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803613:	89 f9                	mov    %edi,%ecx
  803615:	d3 e0                	shl    %cl,%eax
  803617:	89 c5                	mov    %eax,%ebp
  803619:	89 d6                	mov    %edx,%esi
  80361b:	88 d9                	mov    %bl,%cl
  80361d:	d3 ee                	shr    %cl,%esi
  80361f:	89 f9                	mov    %edi,%ecx
  803621:	d3 e2                	shl    %cl,%edx
  803623:	8b 44 24 08          	mov    0x8(%esp),%eax
  803627:	88 d9                	mov    %bl,%cl
  803629:	d3 e8                	shr    %cl,%eax
  80362b:	09 c2                	or     %eax,%edx
  80362d:	89 d0                	mov    %edx,%eax
  80362f:	89 f2                	mov    %esi,%edx
  803631:	f7 74 24 0c          	divl   0xc(%esp)
  803635:	89 d6                	mov    %edx,%esi
  803637:	89 c3                	mov    %eax,%ebx
  803639:	f7 e5                	mul    %ebp
  80363b:	39 d6                	cmp    %edx,%esi
  80363d:	72 19                	jb     803658 <__udivdi3+0xfc>
  80363f:	74 0b                	je     80364c <__udivdi3+0xf0>
  803641:	89 d8                	mov    %ebx,%eax
  803643:	31 ff                	xor    %edi,%edi
  803645:	e9 58 ff ff ff       	jmp    8035a2 <__udivdi3+0x46>
  80364a:	66 90                	xchg   %ax,%ax
  80364c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803650:	89 f9                	mov    %edi,%ecx
  803652:	d3 e2                	shl    %cl,%edx
  803654:	39 c2                	cmp    %eax,%edx
  803656:	73 e9                	jae    803641 <__udivdi3+0xe5>
  803658:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80365b:	31 ff                	xor    %edi,%edi
  80365d:	e9 40 ff ff ff       	jmp    8035a2 <__udivdi3+0x46>
  803662:	66 90                	xchg   %ax,%ax
  803664:	31 c0                	xor    %eax,%eax
  803666:	e9 37 ff ff ff       	jmp    8035a2 <__udivdi3+0x46>
  80366b:	90                   	nop

0080366c <__umoddi3>:
  80366c:	55                   	push   %ebp
  80366d:	57                   	push   %edi
  80366e:	56                   	push   %esi
  80366f:	53                   	push   %ebx
  803670:	83 ec 1c             	sub    $0x1c,%esp
  803673:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803677:	8b 74 24 34          	mov    0x34(%esp),%esi
  80367b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80367f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803683:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803687:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80368b:	89 f3                	mov    %esi,%ebx
  80368d:	89 fa                	mov    %edi,%edx
  80368f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803693:	89 34 24             	mov    %esi,(%esp)
  803696:	85 c0                	test   %eax,%eax
  803698:	75 1a                	jne    8036b4 <__umoddi3+0x48>
  80369a:	39 f7                	cmp    %esi,%edi
  80369c:	0f 86 a2 00 00 00    	jbe    803744 <__umoddi3+0xd8>
  8036a2:	89 c8                	mov    %ecx,%eax
  8036a4:	89 f2                	mov    %esi,%edx
  8036a6:	f7 f7                	div    %edi
  8036a8:	89 d0                	mov    %edx,%eax
  8036aa:	31 d2                	xor    %edx,%edx
  8036ac:	83 c4 1c             	add    $0x1c,%esp
  8036af:	5b                   	pop    %ebx
  8036b0:	5e                   	pop    %esi
  8036b1:	5f                   	pop    %edi
  8036b2:	5d                   	pop    %ebp
  8036b3:	c3                   	ret    
  8036b4:	39 f0                	cmp    %esi,%eax
  8036b6:	0f 87 ac 00 00 00    	ja     803768 <__umoddi3+0xfc>
  8036bc:	0f bd e8             	bsr    %eax,%ebp
  8036bf:	83 f5 1f             	xor    $0x1f,%ebp
  8036c2:	0f 84 ac 00 00 00    	je     803774 <__umoddi3+0x108>
  8036c8:	bf 20 00 00 00       	mov    $0x20,%edi
  8036cd:	29 ef                	sub    %ebp,%edi
  8036cf:	89 fe                	mov    %edi,%esi
  8036d1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8036d5:	89 e9                	mov    %ebp,%ecx
  8036d7:	d3 e0                	shl    %cl,%eax
  8036d9:	89 d7                	mov    %edx,%edi
  8036db:	89 f1                	mov    %esi,%ecx
  8036dd:	d3 ef                	shr    %cl,%edi
  8036df:	09 c7                	or     %eax,%edi
  8036e1:	89 e9                	mov    %ebp,%ecx
  8036e3:	d3 e2                	shl    %cl,%edx
  8036e5:	89 14 24             	mov    %edx,(%esp)
  8036e8:	89 d8                	mov    %ebx,%eax
  8036ea:	d3 e0                	shl    %cl,%eax
  8036ec:	89 c2                	mov    %eax,%edx
  8036ee:	8b 44 24 08          	mov    0x8(%esp),%eax
  8036f2:	d3 e0                	shl    %cl,%eax
  8036f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8036f8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8036fc:	89 f1                	mov    %esi,%ecx
  8036fe:	d3 e8                	shr    %cl,%eax
  803700:	09 d0                	or     %edx,%eax
  803702:	d3 eb                	shr    %cl,%ebx
  803704:	89 da                	mov    %ebx,%edx
  803706:	f7 f7                	div    %edi
  803708:	89 d3                	mov    %edx,%ebx
  80370a:	f7 24 24             	mull   (%esp)
  80370d:	89 c6                	mov    %eax,%esi
  80370f:	89 d1                	mov    %edx,%ecx
  803711:	39 d3                	cmp    %edx,%ebx
  803713:	0f 82 87 00 00 00    	jb     8037a0 <__umoddi3+0x134>
  803719:	0f 84 91 00 00 00    	je     8037b0 <__umoddi3+0x144>
  80371f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803723:	29 f2                	sub    %esi,%edx
  803725:	19 cb                	sbb    %ecx,%ebx
  803727:	89 d8                	mov    %ebx,%eax
  803729:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80372d:	d3 e0                	shl    %cl,%eax
  80372f:	89 e9                	mov    %ebp,%ecx
  803731:	d3 ea                	shr    %cl,%edx
  803733:	09 d0                	or     %edx,%eax
  803735:	89 e9                	mov    %ebp,%ecx
  803737:	d3 eb                	shr    %cl,%ebx
  803739:	89 da                	mov    %ebx,%edx
  80373b:	83 c4 1c             	add    $0x1c,%esp
  80373e:	5b                   	pop    %ebx
  80373f:	5e                   	pop    %esi
  803740:	5f                   	pop    %edi
  803741:	5d                   	pop    %ebp
  803742:	c3                   	ret    
  803743:	90                   	nop
  803744:	89 fd                	mov    %edi,%ebp
  803746:	85 ff                	test   %edi,%edi
  803748:	75 0b                	jne    803755 <__umoddi3+0xe9>
  80374a:	b8 01 00 00 00       	mov    $0x1,%eax
  80374f:	31 d2                	xor    %edx,%edx
  803751:	f7 f7                	div    %edi
  803753:	89 c5                	mov    %eax,%ebp
  803755:	89 f0                	mov    %esi,%eax
  803757:	31 d2                	xor    %edx,%edx
  803759:	f7 f5                	div    %ebp
  80375b:	89 c8                	mov    %ecx,%eax
  80375d:	f7 f5                	div    %ebp
  80375f:	89 d0                	mov    %edx,%eax
  803761:	e9 44 ff ff ff       	jmp    8036aa <__umoddi3+0x3e>
  803766:	66 90                	xchg   %ax,%ax
  803768:	89 c8                	mov    %ecx,%eax
  80376a:	89 f2                	mov    %esi,%edx
  80376c:	83 c4 1c             	add    $0x1c,%esp
  80376f:	5b                   	pop    %ebx
  803770:	5e                   	pop    %esi
  803771:	5f                   	pop    %edi
  803772:	5d                   	pop    %ebp
  803773:	c3                   	ret    
  803774:	3b 04 24             	cmp    (%esp),%eax
  803777:	72 06                	jb     80377f <__umoddi3+0x113>
  803779:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80377d:	77 0f                	ja     80378e <__umoddi3+0x122>
  80377f:	89 f2                	mov    %esi,%edx
  803781:	29 f9                	sub    %edi,%ecx
  803783:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803787:	89 14 24             	mov    %edx,(%esp)
  80378a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80378e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803792:	8b 14 24             	mov    (%esp),%edx
  803795:	83 c4 1c             	add    $0x1c,%esp
  803798:	5b                   	pop    %ebx
  803799:	5e                   	pop    %esi
  80379a:	5f                   	pop    %edi
  80379b:	5d                   	pop    %ebp
  80379c:	c3                   	ret    
  80379d:	8d 76 00             	lea    0x0(%esi),%esi
  8037a0:	2b 04 24             	sub    (%esp),%eax
  8037a3:	19 fa                	sbb    %edi,%edx
  8037a5:	89 d1                	mov    %edx,%ecx
  8037a7:	89 c6                	mov    %eax,%esi
  8037a9:	e9 71 ff ff ff       	jmp    80371f <__umoddi3+0xb3>
  8037ae:	66 90                	xchg   %ax,%ax
  8037b0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8037b4:	72 ea                	jb     8037a0 <__umoddi3+0x134>
  8037b6:	89 d9                	mov    %ebx,%ecx
  8037b8:	e9 62 ff ff ff       	jmp    80371f <__umoddi3+0xb3>
