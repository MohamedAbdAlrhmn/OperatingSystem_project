
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
  80008d:	68 20 38 80 00       	push   $0x803820
  800092:	6a 12                	push   $0x12
  800094:	68 3c 38 80 00       	push   $0x80383c
  800099:	e8 38 04 00 00       	call   8004d6 <_panic>
	}

	uint32 *x, *y, *z ;
	cprintf("STEP A: checking the creation of shared variables... \n");
  80009e:	83 ec 0c             	sub    $0xc,%esp
  8000a1:	68 54 38 80 00       	push   $0x803854
  8000a6:	e8 df 06 00 00       	call   80078a <cprintf>
  8000ab:	83 c4 10             	add    $0x10,%esp
	{
		int freeFrames = sys_calculate_free_frames() ;
  8000ae:	e8 34 19 00 00       	call   8019e7 <sys_calculate_free_frames>
  8000b3:	89 45 e8             	mov    %eax,-0x18(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8000b6:	83 ec 04             	sub    $0x4,%esp
  8000b9:	6a 01                	push   $0x1
  8000bb:	68 00 10 00 00       	push   $0x1000
  8000c0:	68 8b 38 80 00       	push   $0x80388b
  8000c5:	e8 dd 16 00 00       	call   8017a7 <smalloc>
  8000ca:	83 c4 10             	add    $0x10,%esp
  8000cd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (x != (uint32*)USER_HEAP_START) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  8000d0:	81 7d e4 00 00 00 80 	cmpl   $0x80000000,-0x1c(%ebp)
  8000d7:	74 14                	je     8000ed <_main+0xb5>
  8000d9:	83 ec 04             	sub    $0x4,%esp
  8000dc:	68 90 38 80 00       	push   $0x803890
  8000e1:	6a 1a                	push   $0x1a
  8000e3:	68 3c 38 80 00       	push   $0x80383c
  8000e8:	e8 e9 03 00 00       	call   8004d6 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage %d %d %d", freeFrames, sys_calculate_free_frames(), freeFrames - sys_calculate_free_frames());
  8000ed:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8000f0:	e8 f2 18 00 00       	call   8019e7 <sys_calculate_free_frames>
  8000f5:	29 c3                	sub    %eax,%ebx
  8000f7:	89 d8                	mov    %ebx,%eax
  8000f9:	83 f8 04             	cmp    $0x4,%eax
  8000fc:	74 28                	je     800126 <_main+0xee>
  8000fe:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800101:	e8 e1 18 00 00       	call   8019e7 <sys_calculate_free_frames>
  800106:	29 c3                	sub    %eax,%ebx
  800108:	e8 da 18 00 00       	call   8019e7 <sys_calculate_free_frames>
  80010d:	83 ec 08             	sub    $0x8,%esp
  800110:	53                   	push   %ebx
  800111:	50                   	push   %eax
  800112:	ff 75 e8             	pushl  -0x18(%ebp)
  800115:	68 fc 38 80 00       	push   $0x8038fc
  80011a:	6a 1b                	push   $0x1b
  80011c:	68 3c 38 80 00       	push   $0x80383c
  800121:	e8 b0 03 00 00       	call   8004d6 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800126:	e8 bc 18 00 00       	call   8019e7 <sys_calculate_free_frames>
  80012b:	89 45 e8             	mov    %eax,-0x18(%ebp)
		z = smalloc("y", PAGE_SIZE + 4, 1);
  80012e:	83 ec 04             	sub    $0x4,%esp
  800131:	6a 01                	push   $0x1
  800133:	68 04 10 00 00       	push   $0x1004
  800138:	68 83 39 80 00       	push   $0x803983
  80013d:	e8 65 16 00 00       	call   8017a7 <smalloc>
  800142:	83 c4 10             	add    $0x10,%esp
  800145:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (z != (uint32*)(USER_HEAP_START + 1 * PAGE_SIZE)) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  800148:	81 7d e0 00 10 00 80 	cmpl   $0x80001000,-0x20(%ebp)
  80014f:	74 14                	je     800165 <_main+0x12d>
  800151:	83 ec 04             	sub    $0x4,%esp
  800154:	68 90 38 80 00       	push   $0x803890
  800159:	6a 1f                	push   $0x1f
  80015b:	68 3c 38 80 00       	push   $0x80383c
  800160:	e8 71 03 00 00       	call   8004d6 <_panic>

		if ((freeFrames - sys_calculate_free_frames()) !=  2+0+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage %d %d %d", freeFrames, sys_calculate_free_frames(), freeFrames - sys_calculate_free_frames());
  800165:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800168:	e8 7a 18 00 00       	call   8019e7 <sys_calculate_free_frames>
  80016d:	29 c3                	sub    %eax,%ebx
  80016f:	89 d8                	mov    %ebx,%eax
  800171:	83 f8 04             	cmp    $0x4,%eax
  800174:	74 28                	je     80019e <_main+0x166>
  800176:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800179:	e8 69 18 00 00       	call   8019e7 <sys_calculate_free_frames>
  80017e:	29 c3                	sub    %eax,%ebx
  800180:	e8 62 18 00 00       	call   8019e7 <sys_calculate_free_frames>
  800185:	83 ec 08             	sub    $0x8,%esp
  800188:	53                   	push   %ebx
  800189:	50                   	push   %eax
  80018a:	ff 75 e8             	pushl  -0x18(%ebp)
  80018d:	68 fc 38 80 00       	push   $0x8038fc
  800192:	6a 21                	push   $0x21
  800194:	68 3c 38 80 00       	push   $0x80383c
  800199:	e8 38 03 00 00       	call   8004d6 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  80019e:	e8 44 18 00 00       	call   8019e7 <sys_calculate_free_frames>
  8001a3:	89 45 e8             	mov    %eax,-0x18(%ebp)
		y = smalloc("z", 4, 1);
  8001a6:	83 ec 04             	sub    $0x4,%esp
  8001a9:	6a 01                	push   $0x1
  8001ab:	6a 04                	push   $0x4
  8001ad:	68 85 39 80 00       	push   $0x803985
  8001b2:	e8 f0 15 00 00       	call   8017a7 <smalloc>
  8001b7:	83 c4 10             	add    $0x10,%esp
  8001ba:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (y != (uint32*)(USER_HEAP_START + 3 * PAGE_SIZE)) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  8001bd:	81 7d dc 00 30 00 80 	cmpl   $0x80003000,-0x24(%ebp)
  8001c4:	74 14                	je     8001da <_main+0x1a2>
  8001c6:	83 ec 04             	sub    $0x4,%esp
  8001c9:	68 90 38 80 00       	push   $0x803890
  8001ce:	6a 25                	push   $0x25
  8001d0:	68 3c 38 80 00       	push   $0x80383c
  8001d5:	e8 fc 02 00 00       	call   8004d6 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  1+0+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  8001da:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8001dd:	e8 05 18 00 00       	call   8019e7 <sys_calculate_free_frames>
  8001e2:	29 c3                	sub    %eax,%ebx
  8001e4:	89 d8                	mov    %ebx,%eax
  8001e6:	83 f8 03             	cmp    $0x3,%eax
  8001e9:	74 14                	je     8001ff <_main+0x1c7>
  8001eb:	83 ec 04             	sub    $0x4,%esp
  8001ee:	68 88 39 80 00       	push   $0x803988
  8001f3:	6a 26                	push   $0x26
  8001f5:	68 3c 38 80 00       	push   $0x80383c
  8001fa:	e8 d7 02 00 00       	call   8004d6 <_panic>
	}
	cprintf("Step A is completed successfully!!\n\n\n");
  8001ff:	83 ec 0c             	sub    $0xc,%esp
  800202:	68 08 3a 80 00       	push   $0x803a08
  800207:	e8 7e 05 00 00       	call   80078a <cprintf>
  80020c:	83 c4 10             	add    $0x10,%esp


	cprintf("STEP B: checking reading & writing... \n");
  80020f:	83 ec 0c             	sub    $0xc,%esp
  800212:	68 30 3a 80 00       	push   $0x803a30
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
  800295:	68 58 3a 80 00       	push   $0x803a58
  80029a:	6a 3a                	push   $0x3a
  80029c:	68 3c 38 80 00       	push   $0x80383c
  8002a1:	e8 30 02 00 00       	call   8004d6 <_panic>
		if( x[PAGE_SIZE/4 - 1] !=  -1)  	panic("Reading/Writing of shared object is failed");
  8002a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002a9:	05 fc 0f 00 00       	add    $0xffc,%eax
  8002ae:	8b 00                	mov    (%eax),%eax
  8002b0:	83 f8 ff             	cmp    $0xffffffff,%eax
  8002b3:	74 14                	je     8002c9 <_main+0x291>
  8002b5:	83 ec 04             	sub    $0x4,%esp
  8002b8:	68 58 3a 80 00       	push   $0x803a58
  8002bd:	6a 3b                	push   $0x3b
  8002bf:	68 3c 38 80 00       	push   $0x80383c
  8002c4:	e8 0d 02 00 00       	call   8004d6 <_panic>

		if( y[0] !=  -1)  					panic("Reading/Writing of shared object is failed");
  8002c9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002cc:	8b 00                	mov    (%eax),%eax
  8002ce:	83 f8 ff             	cmp    $0xffffffff,%eax
  8002d1:	74 14                	je     8002e7 <_main+0x2af>
  8002d3:	83 ec 04             	sub    $0x4,%esp
  8002d6:	68 58 3a 80 00       	push   $0x803a58
  8002db:	6a 3d                	push   $0x3d
  8002dd:	68 3c 38 80 00       	push   $0x80383c
  8002e2:	e8 ef 01 00 00       	call   8004d6 <_panic>
		if( y[PAGE_SIZE/4 - 1] !=  -1)  	panic("Reading/Writing of shared object is failed");
  8002e7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002ea:	05 fc 0f 00 00       	add    $0xffc,%eax
  8002ef:	8b 00                	mov    (%eax),%eax
  8002f1:	83 f8 ff             	cmp    $0xffffffff,%eax
  8002f4:	74 14                	je     80030a <_main+0x2d2>
  8002f6:	83 ec 04             	sub    $0x4,%esp
  8002f9:	68 58 3a 80 00       	push   $0x803a58
  8002fe:	6a 3e                	push   $0x3e
  800300:	68 3c 38 80 00       	push   $0x80383c
  800305:	e8 cc 01 00 00       	call   8004d6 <_panic>

		if( z[0] !=  -1)  					panic("Reading/Writing of shared object is failed");
  80030a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80030d:	8b 00                	mov    (%eax),%eax
  80030f:	83 f8 ff             	cmp    $0xffffffff,%eax
  800312:	74 14                	je     800328 <_main+0x2f0>
  800314:	83 ec 04             	sub    $0x4,%esp
  800317:	68 58 3a 80 00       	push   $0x803a58
  80031c:	6a 40                	push   $0x40
  80031e:	68 3c 38 80 00       	push   $0x80383c
  800323:	e8 ae 01 00 00       	call   8004d6 <_panic>
		if( z[2*PAGE_SIZE/4 - 1] !=  -1)  	panic("Reading/Writing of shared object is failed");
  800328:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80032b:	05 fc 1f 00 00       	add    $0x1ffc,%eax
  800330:	8b 00                	mov    (%eax),%eax
  800332:	83 f8 ff             	cmp    $0xffffffff,%eax
  800335:	74 14                	je     80034b <_main+0x313>
  800337:	83 ec 04             	sub    $0x4,%esp
  80033a:	68 58 3a 80 00       	push   $0x803a58
  80033f:	6a 41                	push   $0x41
  800341:	68 3c 38 80 00       	push   $0x80383c
  800346:	e8 8b 01 00 00       	call   8004d6 <_panic>
	}

	cprintf("Congratulations!! Test of Shared Variables [Create] [1] completed successfully!!\n\n\n");
  80034b:	83 ec 0c             	sub    $0xc,%esp
  80034e:	68 84 3a 80 00       	push   $0x803a84
  800353:	e8 32 04 00 00       	call   80078a <cprintf>
  800358:	83 c4 10             	add    $0x10,%esp

	int32 parentenvID = sys_getparentenvid();
  80035b:	e8 80 19 00 00       	call   801ce0 <sys_getparentenvid>
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
  800373:	68 d8 3a 80 00       	push   $0x803ad8
  800378:	ff 75 d8             	pushl  -0x28(%ebp)
  80037b:	e8 c3 14 00 00       	call   801843 <sget>
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
  8003a0:	e8 22 19 00 00       	call   801cc7 <sys_getenvindex>
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
  80040b:	e8 c4 16 00 00       	call   801ad4 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800410:	83 ec 0c             	sub    $0xc,%esp
  800413:	68 00 3b 80 00       	push   $0x803b00
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
  80043b:	68 28 3b 80 00       	push   $0x803b28
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
  80046c:	68 50 3b 80 00       	push   $0x803b50
  800471:	e8 14 03 00 00       	call   80078a <cprintf>
  800476:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800479:	a1 20 50 80 00       	mov    0x805020,%eax
  80047e:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800484:	83 ec 08             	sub    $0x8,%esp
  800487:	50                   	push   %eax
  800488:	68 a8 3b 80 00       	push   $0x803ba8
  80048d:	e8 f8 02 00 00       	call   80078a <cprintf>
  800492:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800495:	83 ec 0c             	sub    $0xc,%esp
  800498:	68 00 3b 80 00       	push   $0x803b00
  80049d:	e8 e8 02 00 00       	call   80078a <cprintf>
  8004a2:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8004a5:	e8 44 16 00 00       	call   801aee <sys_enable_interrupt>

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
  8004bd:	e8 d1 17 00 00       	call   801c93 <sys_destroy_env>
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
  8004ce:	e8 26 18 00 00       	call   801cf9 <sys_exit_env>
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
  8004f7:	68 bc 3b 80 00       	push   $0x803bbc
  8004fc:	e8 89 02 00 00       	call   80078a <cprintf>
  800501:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800504:	a1 00 50 80 00       	mov    0x805000,%eax
  800509:	ff 75 0c             	pushl  0xc(%ebp)
  80050c:	ff 75 08             	pushl  0x8(%ebp)
  80050f:	50                   	push   %eax
  800510:	68 c1 3b 80 00       	push   $0x803bc1
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
  800534:	68 dd 3b 80 00       	push   $0x803bdd
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
  800560:	68 e0 3b 80 00       	push   $0x803be0
  800565:	6a 26                	push   $0x26
  800567:	68 2c 3c 80 00       	push   $0x803c2c
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
  800632:	68 38 3c 80 00       	push   $0x803c38
  800637:	6a 3a                	push   $0x3a
  800639:	68 2c 3c 80 00       	push   $0x803c2c
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
  8006a2:	68 8c 3c 80 00       	push   $0x803c8c
  8006a7:	6a 44                	push   $0x44
  8006a9:	68 2c 3c 80 00       	push   $0x803c2c
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
  8006fc:	e8 25 12 00 00       	call   801926 <sys_cputs>
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
  800773:	e8 ae 11 00 00       	call   801926 <sys_cputs>
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
  8007bd:	e8 12 13 00 00       	call   801ad4 <sys_disable_interrupt>
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
  8007dd:	e8 0c 13 00 00       	call   801aee <sys_enable_interrupt>
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
  800827:	e8 80 2d 00 00       	call   8035ac <__udivdi3>
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
  800877:	e8 40 2e 00 00       	call   8036bc <__umoddi3>
  80087c:	83 c4 10             	add    $0x10,%esp
  80087f:	05 f4 3e 80 00       	add    $0x803ef4,%eax
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
  8009d2:	8b 04 85 18 3f 80 00 	mov    0x803f18(,%eax,4),%eax
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
  800ab3:	8b 34 9d 60 3d 80 00 	mov    0x803d60(,%ebx,4),%esi
  800aba:	85 f6                	test   %esi,%esi
  800abc:	75 19                	jne    800ad7 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800abe:	53                   	push   %ebx
  800abf:	68 05 3f 80 00       	push   $0x803f05
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
  800ad8:	68 0e 3f 80 00       	push   $0x803f0e
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
  800b05:	be 11 3f 80 00       	mov    $0x803f11,%esi
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
  80152b:	68 70 40 80 00       	push   $0x804070
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
  8015fb:	e8 6a 04 00 00       	call   801a6a <sys_allocate_chunk>
  801600:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801603:	a1 20 51 80 00       	mov    0x805120,%eax
  801608:	83 ec 0c             	sub    $0xc,%esp
  80160b:	50                   	push   %eax
  80160c:	e8 df 0a 00 00       	call   8020f0 <initialize_MemBlocksList>
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
  801639:	68 95 40 80 00       	push   $0x804095
  80163e:	6a 33                	push   $0x33
  801640:	68 b3 40 80 00       	push   $0x8040b3
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
  8016b8:	68 c0 40 80 00       	push   $0x8040c0
  8016bd:	6a 34                	push   $0x34
  8016bf:	68 b3 40 80 00       	push   $0x8040b3
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
  801750:	e8 e3 06 00 00       	call   801e38 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801755:	85 c0                	test   %eax,%eax
  801757:	74 11                	je     80176a <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  801759:	83 ec 0c             	sub    $0xc,%esp
  80175c:	ff 75 e8             	pushl  -0x18(%ebp)
  80175f:	e8 4e 0d 00 00       	call   8024b2 <alloc_block_FF>
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
  801776:	e8 aa 0a 00 00       	call   802225 <insert_sorted_allocList>
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
  801790:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801793:	83 ec 04             	sub    $0x4,%esp
  801796:	68 e4 40 80 00       	push   $0x8040e4
  80179b:	6a 6f                	push   $0x6f
  80179d:	68 b3 40 80 00       	push   $0x8040b3
  8017a2:	e8 2f ed ff ff       	call   8004d6 <_panic>

008017a7 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8017a7:	55                   	push   %ebp
  8017a8:	89 e5                	mov    %esp,%ebp
  8017aa:	83 ec 38             	sub    $0x38,%esp
  8017ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8017b0:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8017b3:	e8 5c fd ff ff       	call   801514 <InitializeUHeap>
	if (size == 0) return NULL ;
  8017b8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8017bc:	75 07                	jne    8017c5 <smalloc+0x1e>
  8017be:	b8 00 00 00 00       	mov    $0x0,%eax
  8017c3:	eb 7c                	jmp    801841 <smalloc+0x9a>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  8017c5:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8017cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017d2:	01 d0                	add    %edx,%eax
  8017d4:	48                   	dec    %eax
  8017d5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8017d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017db:	ba 00 00 00 00       	mov    $0x0,%edx
  8017e0:	f7 75 f0             	divl   -0x10(%ebp)
  8017e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017e6:	29 d0                	sub    %edx,%eax
  8017e8:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  8017eb:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  8017f2:	e8 41 06 00 00       	call   801e38 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8017f7:	85 c0                	test   %eax,%eax
  8017f9:	74 11                	je     80180c <smalloc+0x65>
		mem_block = alloc_block_FF(allocate_space);
  8017fb:	83 ec 0c             	sub    $0xc,%esp
  8017fe:	ff 75 e8             	pushl  -0x18(%ebp)
  801801:	e8 ac 0c 00 00       	call   8024b2 <alloc_block_FF>
  801806:	83 c4 10             	add    $0x10,%esp
  801809:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  80180c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801810:	74 2a                	je     80183c <smalloc+0x95>
	{
		virtual_address = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801812:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801815:	8b 40 08             	mov    0x8(%eax),%eax
  801818:	89 c2                	mov    %eax,%edx
  80181a:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  80181e:	52                   	push   %edx
  80181f:	50                   	push   %eax
  801820:	ff 75 0c             	pushl  0xc(%ebp)
  801823:	ff 75 08             	pushl  0x8(%ebp)
  801826:	e8 92 03 00 00       	call   801bbd <sys_createSharedObject>
  80182b:	83 c4 10             	add    $0x10,%esp
  80182e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (virtual_address != -1)
  801831:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  801835:	74 05                	je     80183c <smalloc+0x95>
			return (void*)virtual_address;
  801837:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80183a:	eb 05                	jmp    801841 <smalloc+0x9a>
	}
	return NULL;
  80183c:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801841:	c9                   	leave  
  801842:	c3                   	ret    

00801843 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801843:	55                   	push   %ebp
  801844:	89 e5                	mov    %esp,%ebp
  801846:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801849:	e8 c6 fc ff ff       	call   801514 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  80184e:	83 ec 04             	sub    $0x4,%esp
  801851:	68 08 41 80 00       	push   $0x804108
  801856:	68 b0 00 00 00       	push   $0xb0
  80185b:	68 b3 40 80 00       	push   $0x8040b3
  801860:	e8 71 ec ff ff       	call   8004d6 <_panic>

00801865 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801865:	55                   	push   %ebp
  801866:	89 e5                	mov    %esp,%ebp
  801868:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80186b:	e8 a4 fc ff ff       	call   801514 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801870:	83 ec 04             	sub    $0x4,%esp
  801873:	68 2c 41 80 00       	push   $0x80412c
  801878:	68 f4 00 00 00       	push   $0xf4
  80187d:	68 b3 40 80 00       	push   $0x8040b3
  801882:	e8 4f ec ff ff       	call   8004d6 <_panic>

00801887 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801887:	55                   	push   %ebp
  801888:	89 e5                	mov    %esp,%ebp
  80188a:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80188d:	83 ec 04             	sub    $0x4,%esp
  801890:	68 54 41 80 00       	push   $0x804154
  801895:	68 08 01 00 00       	push   $0x108
  80189a:	68 b3 40 80 00       	push   $0x8040b3
  80189f:	e8 32 ec ff ff       	call   8004d6 <_panic>

008018a4 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8018a4:	55                   	push   %ebp
  8018a5:	89 e5                	mov    %esp,%ebp
  8018a7:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018aa:	83 ec 04             	sub    $0x4,%esp
  8018ad:	68 78 41 80 00       	push   $0x804178
  8018b2:	68 13 01 00 00       	push   $0x113
  8018b7:	68 b3 40 80 00       	push   $0x8040b3
  8018bc:	e8 15 ec ff ff       	call   8004d6 <_panic>

008018c1 <shrink>:

}
void shrink(uint32 newSize)
{
  8018c1:	55                   	push   %ebp
  8018c2:	89 e5                	mov    %esp,%ebp
  8018c4:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018c7:	83 ec 04             	sub    $0x4,%esp
  8018ca:	68 78 41 80 00       	push   $0x804178
  8018cf:	68 18 01 00 00       	push   $0x118
  8018d4:	68 b3 40 80 00       	push   $0x8040b3
  8018d9:	e8 f8 eb ff ff       	call   8004d6 <_panic>

008018de <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8018de:	55                   	push   %ebp
  8018df:	89 e5                	mov    %esp,%ebp
  8018e1:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018e4:	83 ec 04             	sub    $0x4,%esp
  8018e7:	68 78 41 80 00       	push   $0x804178
  8018ec:	68 1d 01 00 00       	push   $0x11d
  8018f1:	68 b3 40 80 00       	push   $0x8040b3
  8018f6:	e8 db eb ff ff       	call   8004d6 <_panic>

008018fb <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8018fb:	55                   	push   %ebp
  8018fc:	89 e5                	mov    %esp,%ebp
  8018fe:	57                   	push   %edi
  8018ff:	56                   	push   %esi
  801900:	53                   	push   %ebx
  801901:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801904:	8b 45 08             	mov    0x8(%ebp),%eax
  801907:	8b 55 0c             	mov    0xc(%ebp),%edx
  80190a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80190d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801910:	8b 7d 18             	mov    0x18(%ebp),%edi
  801913:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801916:	cd 30                	int    $0x30
  801918:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80191b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80191e:	83 c4 10             	add    $0x10,%esp
  801921:	5b                   	pop    %ebx
  801922:	5e                   	pop    %esi
  801923:	5f                   	pop    %edi
  801924:	5d                   	pop    %ebp
  801925:	c3                   	ret    

00801926 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801926:	55                   	push   %ebp
  801927:	89 e5                	mov    %esp,%ebp
  801929:	83 ec 04             	sub    $0x4,%esp
  80192c:	8b 45 10             	mov    0x10(%ebp),%eax
  80192f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801932:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801936:	8b 45 08             	mov    0x8(%ebp),%eax
  801939:	6a 00                	push   $0x0
  80193b:	6a 00                	push   $0x0
  80193d:	52                   	push   %edx
  80193e:	ff 75 0c             	pushl  0xc(%ebp)
  801941:	50                   	push   %eax
  801942:	6a 00                	push   $0x0
  801944:	e8 b2 ff ff ff       	call   8018fb <syscall>
  801949:	83 c4 18             	add    $0x18,%esp
}
  80194c:	90                   	nop
  80194d:	c9                   	leave  
  80194e:	c3                   	ret    

0080194f <sys_cgetc>:

int
sys_cgetc(void)
{
  80194f:	55                   	push   %ebp
  801950:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801952:	6a 00                	push   $0x0
  801954:	6a 00                	push   $0x0
  801956:	6a 00                	push   $0x0
  801958:	6a 00                	push   $0x0
  80195a:	6a 00                	push   $0x0
  80195c:	6a 01                	push   $0x1
  80195e:	e8 98 ff ff ff       	call   8018fb <syscall>
  801963:	83 c4 18             	add    $0x18,%esp
}
  801966:	c9                   	leave  
  801967:	c3                   	ret    

00801968 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801968:	55                   	push   %ebp
  801969:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80196b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80196e:	8b 45 08             	mov    0x8(%ebp),%eax
  801971:	6a 00                	push   $0x0
  801973:	6a 00                	push   $0x0
  801975:	6a 00                	push   $0x0
  801977:	52                   	push   %edx
  801978:	50                   	push   %eax
  801979:	6a 05                	push   $0x5
  80197b:	e8 7b ff ff ff       	call   8018fb <syscall>
  801980:	83 c4 18             	add    $0x18,%esp
}
  801983:	c9                   	leave  
  801984:	c3                   	ret    

00801985 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801985:	55                   	push   %ebp
  801986:	89 e5                	mov    %esp,%ebp
  801988:	56                   	push   %esi
  801989:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80198a:	8b 75 18             	mov    0x18(%ebp),%esi
  80198d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801990:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801993:	8b 55 0c             	mov    0xc(%ebp),%edx
  801996:	8b 45 08             	mov    0x8(%ebp),%eax
  801999:	56                   	push   %esi
  80199a:	53                   	push   %ebx
  80199b:	51                   	push   %ecx
  80199c:	52                   	push   %edx
  80199d:	50                   	push   %eax
  80199e:	6a 06                	push   $0x6
  8019a0:	e8 56 ff ff ff       	call   8018fb <syscall>
  8019a5:	83 c4 18             	add    $0x18,%esp
}
  8019a8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019ab:	5b                   	pop    %ebx
  8019ac:	5e                   	pop    %esi
  8019ad:	5d                   	pop    %ebp
  8019ae:	c3                   	ret    

008019af <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8019af:	55                   	push   %ebp
  8019b0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8019b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b8:	6a 00                	push   $0x0
  8019ba:	6a 00                	push   $0x0
  8019bc:	6a 00                	push   $0x0
  8019be:	52                   	push   %edx
  8019bf:	50                   	push   %eax
  8019c0:	6a 07                	push   $0x7
  8019c2:	e8 34 ff ff ff       	call   8018fb <syscall>
  8019c7:	83 c4 18             	add    $0x18,%esp
}
  8019ca:	c9                   	leave  
  8019cb:	c3                   	ret    

008019cc <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8019cc:	55                   	push   %ebp
  8019cd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8019cf:	6a 00                	push   $0x0
  8019d1:	6a 00                	push   $0x0
  8019d3:	6a 00                	push   $0x0
  8019d5:	ff 75 0c             	pushl  0xc(%ebp)
  8019d8:	ff 75 08             	pushl  0x8(%ebp)
  8019db:	6a 08                	push   $0x8
  8019dd:	e8 19 ff ff ff       	call   8018fb <syscall>
  8019e2:	83 c4 18             	add    $0x18,%esp
}
  8019e5:	c9                   	leave  
  8019e6:	c3                   	ret    

008019e7 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8019e7:	55                   	push   %ebp
  8019e8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8019ea:	6a 00                	push   $0x0
  8019ec:	6a 00                	push   $0x0
  8019ee:	6a 00                	push   $0x0
  8019f0:	6a 00                	push   $0x0
  8019f2:	6a 00                	push   $0x0
  8019f4:	6a 09                	push   $0x9
  8019f6:	e8 00 ff ff ff       	call   8018fb <syscall>
  8019fb:	83 c4 18             	add    $0x18,%esp
}
  8019fe:	c9                   	leave  
  8019ff:	c3                   	ret    

00801a00 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801a00:	55                   	push   %ebp
  801a01:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801a03:	6a 00                	push   $0x0
  801a05:	6a 00                	push   $0x0
  801a07:	6a 00                	push   $0x0
  801a09:	6a 00                	push   $0x0
  801a0b:	6a 00                	push   $0x0
  801a0d:	6a 0a                	push   $0xa
  801a0f:	e8 e7 fe ff ff       	call   8018fb <syscall>
  801a14:	83 c4 18             	add    $0x18,%esp
}
  801a17:	c9                   	leave  
  801a18:	c3                   	ret    

00801a19 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801a19:	55                   	push   %ebp
  801a1a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801a1c:	6a 00                	push   $0x0
  801a1e:	6a 00                	push   $0x0
  801a20:	6a 00                	push   $0x0
  801a22:	6a 00                	push   $0x0
  801a24:	6a 00                	push   $0x0
  801a26:	6a 0b                	push   $0xb
  801a28:	e8 ce fe ff ff       	call   8018fb <syscall>
  801a2d:	83 c4 18             	add    $0x18,%esp
}
  801a30:	c9                   	leave  
  801a31:	c3                   	ret    

00801a32 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801a32:	55                   	push   %ebp
  801a33:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801a35:	6a 00                	push   $0x0
  801a37:	6a 00                	push   $0x0
  801a39:	6a 00                	push   $0x0
  801a3b:	ff 75 0c             	pushl  0xc(%ebp)
  801a3e:	ff 75 08             	pushl  0x8(%ebp)
  801a41:	6a 0f                	push   $0xf
  801a43:	e8 b3 fe ff ff       	call   8018fb <syscall>
  801a48:	83 c4 18             	add    $0x18,%esp
	return;
  801a4b:	90                   	nop
}
  801a4c:	c9                   	leave  
  801a4d:	c3                   	ret    

00801a4e <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801a4e:	55                   	push   %ebp
  801a4f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801a51:	6a 00                	push   $0x0
  801a53:	6a 00                	push   $0x0
  801a55:	6a 00                	push   $0x0
  801a57:	ff 75 0c             	pushl  0xc(%ebp)
  801a5a:	ff 75 08             	pushl  0x8(%ebp)
  801a5d:	6a 10                	push   $0x10
  801a5f:	e8 97 fe ff ff       	call   8018fb <syscall>
  801a64:	83 c4 18             	add    $0x18,%esp
	return ;
  801a67:	90                   	nop
}
  801a68:	c9                   	leave  
  801a69:	c3                   	ret    

00801a6a <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801a6a:	55                   	push   %ebp
  801a6b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801a6d:	6a 00                	push   $0x0
  801a6f:	6a 00                	push   $0x0
  801a71:	ff 75 10             	pushl  0x10(%ebp)
  801a74:	ff 75 0c             	pushl  0xc(%ebp)
  801a77:	ff 75 08             	pushl  0x8(%ebp)
  801a7a:	6a 11                	push   $0x11
  801a7c:	e8 7a fe ff ff       	call   8018fb <syscall>
  801a81:	83 c4 18             	add    $0x18,%esp
	return ;
  801a84:	90                   	nop
}
  801a85:	c9                   	leave  
  801a86:	c3                   	ret    

00801a87 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801a87:	55                   	push   %ebp
  801a88:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801a8a:	6a 00                	push   $0x0
  801a8c:	6a 00                	push   $0x0
  801a8e:	6a 00                	push   $0x0
  801a90:	6a 00                	push   $0x0
  801a92:	6a 00                	push   $0x0
  801a94:	6a 0c                	push   $0xc
  801a96:	e8 60 fe ff ff       	call   8018fb <syscall>
  801a9b:	83 c4 18             	add    $0x18,%esp
}
  801a9e:	c9                   	leave  
  801a9f:	c3                   	ret    

00801aa0 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801aa0:	55                   	push   %ebp
  801aa1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801aa3:	6a 00                	push   $0x0
  801aa5:	6a 00                	push   $0x0
  801aa7:	6a 00                	push   $0x0
  801aa9:	6a 00                	push   $0x0
  801aab:	ff 75 08             	pushl  0x8(%ebp)
  801aae:	6a 0d                	push   $0xd
  801ab0:	e8 46 fe ff ff       	call   8018fb <syscall>
  801ab5:	83 c4 18             	add    $0x18,%esp
}
  801ab8:	c9                   	leave  
  801ab9:	c3                   	ret    

00801aba <sys_scarce_memory>:

void sys_scarce_memory()
{
  801aba:	55                   	push   %ebp
  801abb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801abd:	6a 00                	push   $0x0
  801abf:	6a 00                	push   $0x0
  801ac1:	6a 00                	push   $0x0
  801ac3:	6a 00                	push   $0x0
  801ac5:	6a 00                	push   $0x0
  801ac7:	6a 0e                	push   $0xe
  801ac9:	e8 2d fe ff ff       	call   8018fb <syscall>
  801ace:	83 c4 18             	add    $0x18,%esp
}
  801ad1:	90                   	nop
  801ad2:	c9                   	leave  
  801ad3:	c3                   	ret    

00801ad4 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801ad4:	55                   	push   %ebp
  801ad5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801ad7:	6a 00                	push   $0x0
  801ad9:	6a 00                	push   $0x0
  801adb:	6a 00                	push   $0x0
  801add:	6a 00                	push   $0x0
  801adf:	6a 00                	push   $0x0
  801ae1:	6a 13                	push   $0x13
  801ae3:	e8 13 fe ff ff       	call   8018fb <syscall>
  801ae8:	83 c4 18             	add    $0x18,%esp
}
  801aeb:	90                   	nop
  801aec:	c9                   	leave  
  801aed:	c3                   	ret    

00801aee <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801aee:	55                   	push   %ebp
  801aef:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801af1:	6a 00                	push   $0x0
  801af3:	6a 00                	push   $0x0
  801af5:	6a 00                	push   $0x0
  801af7:	6a 00                	push   $0x0
  801af9:	6a 00                	push   $0x0
  801afb:	6a 14                	push   $0x14
  801afd:	e8 f9 fd ff ff       	call   8018fb <syscall>
  801b02:	83 c4 18             	add    $0x18,%esp
}
  801b05:	90                   	nop
  801b06:	c9                   	leave  
  801b07:	c3                   	ret    

00801b08 <sys_cputc>:


void
sys_cputc(const char c)
{
  801b08:	55                   	push   %ebp
  801b09:	89 e5                	mov    %esp,%ebp
  801b0b:	83 ec 04             	sub    $0x4,%esp
  801b0e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b11:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801b14:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b18:	6a 00                	push   $0x0
  801b1a:	6a 00                	push   $0x0
  801b1c:	6a 00                	push   $0x0
  801b1e:	6a 00                	push   $0x0
  801b20:	50                   	push   %eax
  801b21:	6a 15                	push   $0x15
  801b23:	e8 d3 fd ff ff       	call   8018fb <syscall>
  801b28:	83 c4 18             	add    $0x18,%esp
}
  801b2b:	90                   	nop
  801b2c:	c9                   	leave  
  801b2d:	c3                   	ret    

00801b2e <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801b2e:	55                   	push   %ebp
  801b2f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801b31:	6a 00                	push   $0x0
  801b33:	6a 00                	push   $0x0
  801b35:	6a 00                	push   $0x0
  801b37:	6a 00                	push   $0x0
  801b39:	6a 00                	push   $0x0
  801b3b:	6a 16                	push   $0x16
  801b3d:	e8 b9 fd ff ff       	call   8018fb <syscall>
  801b42:	83 c4 18             	add    $0x18,%esp
}
  801b45:	90                   	nop
  801b46:	c9                   	leave  
  801b47:	c3                   	ret    

00801b48 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801b48:	55                   	push   %ebp
  801b49:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4e:	6a 00                	push   $0x0
  801b50:	6a 00                	push   $0x0
  801b52:	6a 00                	push   $0x0
  801b54:	ff 75 0c             	pushl  0xc(%ebp)
  801b57:	50                   	push   %eax
  801b58:	6a 17                	push   $0x17
  801b5a:	e8 9c fd ff ff       	call   8018fb <syscall>
  801b5f:	83 c4 18             	add    $0x18,%esp
}
  801b62:	c9                   	leave  
  801b63:	c3                   	ret    

00801b64 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801b64:	55                   	push   %ebp
  801b65:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b67:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6d:	6a 00                	push   $0x0
  801b6f:	6a 00                	push   $0x0
  801b71:	6a 00                	push   $0x0
  801b73:	52                   	push   %edx
  801b74:	50                   	push   %eax
  801b75:	6a 1a                	push   $0x1a
  801b77:	e8 7f fd ff ff       	call   8018fb <syscall>
  801b7c:	83 c4 18             	add    $0x18,%esp
}
  801b7f:	c9                   	leave  
  801b80:	c3                   	ret    

00801b81 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b81:	55                   	push   %ebp
  801b82:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b84:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b87:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8a:	6a 00                	push   $0x0
  801b8c:	6a 00                	push   $0x0
  801b8e:	6a 00                	push   $0x0
  801b90:	52                   	push   %edx
  801b91:	50                   	push   %eax
  801b92:	6a 18                	push   $0x18
  801b94:	e8 62 fd ff ff       	call   8018fb <syscall>
  801b99:	83 c4 18             	add    $0x18,%esp
}
  801b9c:	90                   	nop
  801b9d:	c9                   	leave  
  801b9e:	c3                   	ret    

00801b9f <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b9f:	55                   	push   %ebp
  801ba0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ba2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ba5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba8:	6a 00                	push   $0x0
  801baa:	6a 00                	push   $0x0
  801bac:	6a 00                	push   $0x0
  801bae:	52                   	push   %edx
  801baf:	50                   	push   %eax
  801bb0:	6a 19                	push   $0x19
  801bb2:	e8 44 fd ff ff       	call   8018fb <syscall>
  801bb7:	83 c4 18             	add    $0x18,%esp
}
  801bba:	90                   	nop
  801bbb:	c9                   	leave  
  801bbc:	c3                   	ret    

00801bbd <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801bbd:	55                   	push   %ebp
  801bbe:	89 e5                	mov    %esp,%ebp
  801bc0:	83 ec 04             	sub    $0x4,%esp
  801bc3:	8b 45 10             	mov    0x10(%ebp),%eax
  801bc6:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801bc9:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801bcc:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801bd0:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd3:	6a 00                	push   $0x0
  801bd5:	51                   	push   %ecx
  801bd6:	52                   	push   %edx
  801bd7:	ff 75 0c             	pushl  0xc(%ebp)
  801bda:	50                   	push   %eax
  801bdb:	6a 1b                	push   $0x1b
  801bdd:	e8 19 fd ff ff       	call   8018fb <syscall>
  801be2:	83 c4 18             	add    $0x18,%esp
}
  801be5:	c9                   	leave  
  801be6:	c3                   	ret    

00801be7 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801be7:	55                   	push   %ebp
  801be8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801bea:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bed:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf0:	6a 00                	push   $0x0
  801bf2:	6a 00                	push   $0x0
  801bf4:	6a 00                	push   $0x0
  801bf6:	52                   	push   %edx
  801bf7:	50                   	push   %eax
  801bf8:	6a 1c                	push   $0x1c
  801bfa:	e8 fc fc ff ff       	call   8018fb <syscall>
  801bff:	83 c4 18             	add    $0x18,%esp
}
  801c02:	c9                   	leave  
  801c03:	c3                   	ret    

00801c04 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801c04:	55                   	push   %ebp
  801c05:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801c07:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c0a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c0d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c10:	6a 00                	push   $0x0
  801c12:	6a 00                	push   $0x0
  801c14:	51                   	push   %ecx
  801c15:	52                   	push   %edx
  801c16:	50                   	push   %eax
  801c17:	6a 1d                	push   $0x1d
  801c19:	e8 dd fc ff ff       	call   8018fb <syscall>
  801c1e:	83 c4 18             	add    $0x18,%esp
}
  801c21:	c9                   	leave  
  801c22:	c3                   	ret    

00801c23 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801c23:	55                   	push   %ebp
  801c24:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801c26:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c29:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2c:	6a 00                	push   $0x0
  801c2e:	6a 00                	push   $0x0
  801c30:	6a 00                	push   $0x0
  801c32:	52                   	push   %edx
  801c33:	50                   	push   %eax
  801c34:	6a 1e                	push   $0x1e
  801c36:	e8 c0 fc ff ff       	call   8018fb <syscall>
  801c3b:	83 c4 18             	add    $0x18,%esp
}
  801c3e:	c9                   	leave  
  801c3f:	c3                   	ret    

00801c40 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801c40:	55                   	push   %ebp
  801c41:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801c43:	6a 00                	push   $0x0
  801c45:	6a 00                	push   $0x0
  801c47:	6a 00                	push   $0x0
  801c49:	6a 00                	push   $0x0
  801c4b:	6a 00                	push   $0x0
  801c4d:	6a 1f                	push   $0x1f
  801c4f:	e8 a7 fc ff ff       	call   8018fb <syscall>
  801c54:	83 c4 18             	add    $0x18,%esp
}
  801c57:	c9                   	leave  
  801c58:	c3                   	ret    

00801c59 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801c59:	55                   	push   %ebp
  801c5a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801c5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5f:	6a 00                	push   $0x0
  801c61:	ff 75 14             	pushl  0x14(%ebp)
  801c64:	ff 75 10             	pushl  0x10(%ebp)
  801c67:	ff 75 0c             	pushl  0xc(%ebp)
  801c6a:	50                   	push   %eax
  801c6b:	6a 20                	push   $0x20
  801c6d:	e8 89 fc ff ff       	call   8018fb <syscall>
  801c72:	83 c4 18             	add    $0x18,%esp
}
  801c75:	c9                   	leave  
  801c76:	c3                   	ret    

00801c77 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801c77:	55                   	push   %ebp
  801c78:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801c7a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7d:	6a 00                	push   $0x0
  801c7f:	6a 00                	push   $0x0
  801c81:	6a 00                	push   $0x0
  801c83:	6a 00                	push   $0x0
  801c85:	50                   	push   %eax
  801c86:	6a 21                	push   $0x21
  801c88:	e8 6e fc ff ff       	call   8018fb <syscall>
  801c8d:	83 c4 18             	add    $0x18,%esp
}
  801c90:	90                   	nop
  801c91:	c9                   	leave  
  801c92:	c3                   	ret    

00801c93 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801c93:	55                   	push   %ebp
  801c94:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801c96:	8b 45 08             	mov    0x8(%ebp),%eax
  801c99:	6a 00                	push   $0x0
  801c9b:	6a 00                	push   $0x0
  801c9d:	6a 00                	push   $0x0
  801c9f:	6a 00                	push   $0x0
  801ca1:	50                   	push   %eax
  801ca2:	6a 22                	push   $0x22
  801ca4:	e8 52 fc ff ff       	call   8018fb <syscall>
  801ca9:	83 c4 18             	add    $0x18,%esp
}
  801cac:	c9                   	leave  
  801cad:	c3                   	ret    

00801cae <sys_getenvid>:

int32 sys_getenvid(void)
{
  801cae:	55                   	push   %ebp
  801caf:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801cb1:	6a 00                	push   $0x0
  801cb3:	6a 00                	push   $0x0
  801cb5:	6a 00                	push   $0x0
  801cb7:	6a 00                	push   $0x0
  801cb9:	6a 00                	push   $0x0
  801cbb:	6a 02                	push   $0x2
  801cbd:	e8 39 fc ff ff       	call   8018fb <syscall>
  801cc2:	83 c4 18             	add    $0x18,%esp
}
  801cc5:	c9                   	leave  
  801cc6:	c3                   	ret    

00801cc7 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801cc7:	55                   	push   %ebp
  801cc8:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801cca:	6a 00                	push   $0x0
  801ccc:	6a 00                	push   $0x0
  801cce:	6a 00                	push   $0x0
  801cd0:	6a 00                	push   $0x0
  801cd2:	6a 00                	push   $0x0
  801cd4:	6a 03                	push   $0x3
  801cd6:	e8 20 fc ff ff       	call   8018fb <syscall>
  801cdb:	83 c4 18             	add    $0x18,%esp
}
  801cde:	c9                   	leave  
  801cdf:	c3                   	ret    

00801ce0 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801ce0:	55                   	push   %ebp
  801ce1:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801ce3:	6a 00                	push   $0x0
  801ce5:	6a 00                	push   $0x0
  801ce7:	6a 00                	push   $0x0
  801ce9:	6a 00                	push   $0x0
  801ceb:	6a 00                	push   $0x0
  801ced:	6a 04                	push   $0x4
  801cef:	e8 07 fc ff ff       	call   8018fb <syscall>
  801cf4:	83 c4 18             	add    $0x18,%esp
}
  801cf7:	c9                   	leave  
  801cf8:	c3                   	ret    

00801cf9 <sys_exit_env>:


void sys_exit_env(void)
{
  801cf9:	55                   	push   %ebp
  801cfa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801cfc:	6a 00                	push   $0x0
  801cfe:	6a 00                	push   $0x0
  801d00:	6a 00                	push   $0x0
  801d02:	6a 00                	push   $0x0
  801d04:	6a 00                	push   $0x0
  801d06:	6a 23                	push   $0x23
  801d08:	e8 ee fb ff ff       	call   8018fb <syscall>
  801d0d:	83 c4 18             	add    $0x18,%esp
}
  801d10:	90                   	nop
  801d11:	c9                   	leave  
  801d12:	c3                   	ret    

00801d13 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801d13:	55                   	push   %ebp
  801d14:	89 e5                	mov    %esp,%ebp
  801d16:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801d19:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d1c:	8d 50 04             	lea    0x4(%eax),%edx
  801d1f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d22:	6a 00                	push   $0x0
  801d24:	6a 00                	push   $0x0
  801d26:	6a 00                	push   $0x0
  801d28:	52                   	push   %edx
  801d29:	50                   	push   %eax
  801d2a:	6a 24                	push   $0x24
  801d2c:	e8 ca fb ff ff       	call   8018fb <syscall>
  801d31:	83 c4 18             	add    $0x18,%esp
	return result;
  801d34:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d37:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d3a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d3d:	89 01                	mov    %eax,(%ecx)
  801d3f:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801d42:	8b 45 08             	mov    0x8(%ebp),%eax
  801d45:	c9                   	leave  
  801d46:	c2 04 00             	ret    $0x4

00801d49 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801d49:	55                   	push   %ebp
  801d4a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801d4c:	6a 00                	push   $0x0
  801d4e:	6a 00                	push   $0x0
  801d50:	ff 75 10             	pushl  0x10(%ebp)
  801d53:	ff 75 0c             	pushl  0xc(%ebp)
  801d56:	ff 75 08             	pushl  0x8(%ebp)
  801d59:	6a 12                	push   $0x12
  801d5b:	e8 9b fb ff ff       	call   8018fb <syscall>
  801d60:	83 c4 18             	add    $0x18,%esp
	return ;
  801d63:	90                   	nop
}
  801d64:	c9                   	leave  
  801d65:	c3                   	ret    

00801d66 <sys_rcr2>:
uint32 sys_rcr2()
{
  801d66:	55                   	push   %ebp
  801d67:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801d69:	6a 00                	push   $0x0
  801d6b:	6a 00                	push   $0x0
  801d6d:	6a 00                	push   $0x0
  801d6f:	6a 00                	push   $0x0
  801d71:	6a 00                	push   $0x0
  801d73:	6a 25                	push   $0x25
  801d75:	e8 81 fb ff ff       	call   8018fb <syscall>
  801d7a:	83 c4 18             	add    $0x18,%esp
}
  801d7d:	c9                   	leave  
  801d7e:	c3                   	ret    

00801d7f <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801d7f:	55                   	push   %ebp
  801d80:	89 e5                	mov    %esp,%ebp
  801d82:	83 ec 04             	sub    $0x4,%esp
  801d85:	8b 45 08             	mov    0x8(%ebp),%eax
  801d88:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801d8b:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801d8f:	6a 00                	push   $0x0
  801d91:	6a 00                	push   $0x0
  801d93:	6a 00                	push   $0x0
  801d95:	6a 00                	push   $0x0
  801d97:	50                   	push   %eax
  801d98:	6a 26                	push   $0x26
  801d9a:	e8 5c fb ff ff       	call   8018fb <syscall>
  801d9f:	83 c4 18             	add    $0x18,%esp
	return ;
  801da2:	90                   	nop
}
  801da3:	c9                   	leave  
  801da4:	c3                   	ret    

00801da5 <rsttst>:
void rsttst()
{
  801da5:	55                   	push   %ebp
  801da6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801da8:	6a 00                	push   $0x0
  801daa:	6a 00                	push   $0x0
  801dac:	6a 00                	push   $0x0
  801dae:	6a 00                	push   $0x0
  801db0:	6a 00                	push   $0x0
  801db2:	6a 28                	push   $0x28
  801db4:	e8 42 fb ff ff       	call   8018fb <syscall>
  801db9:	83 c4 18             	add    $0x18,%esp
	return ;
  801dbc:	90                   	nop
}
  801dbd:	c9                   	leave  
  801dbe:	c3                   	ret    

00801dbf <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801dbf:	55                   	push   %ebp
  801dc0:	89 e5                	mov    %esp,%ebp
  801dc2:	83 ec 04             	sub    $0x4,%esp
  801dc5:	8b 45 14             	mov    0x14(%ebp),%eax
  801dc8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801dcb:	8b 55 18             	mov    0x18(%ebp),%edx
  801dce:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801dd2:	52                   	push   %edx
  801dd3:	50                   	push   %eax
  801dd4:	ff 75 10             	pushl  0x10(%ebp)
  801dd7:	ff 75 0c             	pushl  0xc(%ebp)
  801dda:	ff 75 08             	pushl  0x8(%ebp)
  801ddd:	6a 27                	push   $0x27
  801ddf:	e8 17 fb ff ff       	call   8018fb <syscall>
  801de4:	83 c4 18             	add    $0x18,%esp
	return ;
  801de7:	90                   	nop
}
  801de8:	c9                   	leave  
  801de9:	c3                   	ret    

00801dea <chktst>:
void chktst(uint32 n)
{
  801dea:	55                   	push   %ebp
  801deb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801ded:	6a 00                	push   $0x0
  801def:	6a 00                	push   $0x0
  801df1:	6a 00                	push   $0x0
  801df3:	6a 00                	push   $0x0
  801df5:	ff 75 08             	pushl  0x8(%ebp)
  801df8:	6a 29                	push   $0x29
  801dfa:	e8 fc fa ff ff       	call   8018fb <syscall>
  801dff:	83 c4 18             	add    $0x18,%esp
	return ;
  801e02:	90                   	nop
}
  801e03:	c9                   	leave  
  801e04:	c3                   	ret    

00801e05 <inctst>:

void inctst()
{
  801e05:	55                   	push   %ebp
  801e06:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801e08:	6a 00                	push   $0x0
  801e0a:	6a 00                	push   $0x0
  801e0c:	6a 00                	push   $0x0
  801e0e:	6a 00                	push   $0x0
  801e10:	6a 00                	push   $0x0
  801e12:	6a 2a                	push   $0x2a
  801e14:	e8 e2 fa ff ff       	call   8018fb <syscall>
  801e19:	83 c4 18             	add    $0x18,%esp
	return ;
  801e1c:	90                   	nop
}
  801e1d:	c9                   	leave  
  801e1e:	c3                   	ret    

00801e1f <gettst>:
uint32 gettst()
{
  801e1f:	55                   	push   %ebp
  801e20:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801e22:	6a 00                	push   $0x0
  801e24:	6a 00                	push   $0x0
  801e26:	6a 00                	push   $0x0
  801e28:	6a 00                	push   $0x0
  801e2a:	6a 00                	push   $0x0
  801e2c:	6a 2b                	push   $0x2b
  801e2e:	e8 c8 fa ff ff       	call   8018fb <syscall>
  801e33:	83 c4 18             	add    $0x18,%esp
}
  801e36:	c9                   	leave  
  801e37:	c3                   	ret    

00801e38 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801e38:	55                   	push   %ebp
  801e39:	89 e5                	mov    %esp,%ebp
  801e3b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e3e:	6a 00                	push   $0x0
  801e40:	6a 00                	push   $0x0
  801e42:	6a 00                	push   $0x0
  801e44:	6a 00                	push   $0x0
  801e46:	6a 00                	push   $0x0
  801e48:	6a 2c                	push   $0x2c
  801e4a:	e8 ac fa ff ff       	call   8018fb <syscall>
  801e4f:	83 c4 18             	add    $0x18,%esp
  801e52:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801e55:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801e59:	75 07                	jne    801e62 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801e5b:	b8 01 00 00 00       	mov    $0x1,%eax
  801e60:	eb 05                	jmp    801e67 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801e62:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e67:	c9                   	leave  
  801e68:	c3                   	ret    

00801e69 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801e69:	55                   	push   %ebp
  801e6a:	89 e5                	mov    %esp,%ebp
  801e6c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e6f:	6a 00                	push   $0x0
  801e71:	6a 00                	push   $0x0
  801e73:	6a 00                	push   $0x0
  801e75:	6a 00                	push   $0x0
  801e77:	6a 00                	push   $0x0
  801e79:	6a 2c                	push   $0x2c
  801e7b:	e8 7b fa ff ff       	call   8018fb <syscall>
  801e80:	83 c4 18             	add    $0x18,%esp
  801e83:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801e86:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801e8a:	75 07                	jne    801e93 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801e8c:	b8 01 00 00 00       	mov    $0x1,%eax
  801e91:	eb 05                	jmp    801e98 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801e93:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e98:	c9                   	leave  
  801e99:	c3                   	ret    

00801e9a <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801e9a:	55                   	push   %ebp
  801e9b:	89 e5                	mov    %esp,%ebp
  801e9d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ea0:	6a 00                	push   $0x0
  801ea2:	6a 00                	push   $0x0
  801ea4:	6a 00                	push   $0x0
  801ea6:	6a 00                	push   $0x0
  801ea8:	6a 00                	push   $0x0
  801eaa:	6a 2c                	push   $0x2c
  801eac:	e8 4a fa ff ff       	call   8018fb <syscall>
  801eb1:	83 c4 18             	add    $0x18,%esp
  801eb4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801eb7:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801ebb:	75 07                	jne    801ec4 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801ebd:	b8 01 00 00 00       	mov    $0x1,%eax
  801ec2:	eb 05                	jmp    801ec9 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801ec4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ec9:	c9                   	leave  
  801eca:	c3                   	ret    

00801ecb <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801ecb:	55                   	push   %ebp
  801ecc:	89 e5                	mov    %esp,%ebp
  801ece:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ed1:	6a 00                	push   $0x0
  801ed3:	6a 00                	push   $0x0
  801ed5:	6a 00                	push   $0x0
  801ed7:	6a 00                	push   $0x0
  801ed9:	6a 00                	push   $0x0
  801edb:	6a 2c                	push   $0x2c
  801edd:	e8 19 fa ff ff       	call   8018fb <syscall>
  801ee2:	83 c4 18             	add    $0x18,%esp
  801ee5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801ee8:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801eec:	75 07                	jne    801ef5 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801eee:	b8 01 00 00 00       	mov    $0x1,%eax
  801ef3:	eb 05                	jmp    801efa <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801ef5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801efa:	c9                   	leave  
  801efb:	c3                   	ret    

00801efc <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801efc:	55                   	push   %ebp
  801efd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801eff:	6a 00                	push   $0x0
  801f01:	6a 00                	push   $0x0
  801f03:	6a 00                	push   $0x0
  801f05:	6a 00                	push   $0x0
  801f07:	ff 75 08             	pushl  0x8(%ebp)
  801f0a:	6a 2d                	push   $0x2d
  801f0c:	e8 ea f9 ff ff       	call   8018fb <syscall>
  801f11:	83 c4 18             	add    $0x18,%esp
	return ;
  801f14:	90                   	nop
}
  801f15:	c9                   	leave  
  801f16:	c3                   	ret    

00801f17 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801f17:	55                   	push   %ebp
  801f18:	89 e5                	mov    %esp,%ebp
  801f1a:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801f1b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f1e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f21:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f24:	8b 45 08             	mov    0x8(%ebp),%eax
  801f27:	6a 00                	push   $0x0
  801f29:	53                   	push   %ebx
  801f2a:	51                   	push   %ecx
  801f2b:	52                   	push   %edx
  801f2c:	50                   	push   %eax
  801f2d:	6a 2e                	push   $0x2e
  801f2f:	e8 c7 f9 ff ff       	call   8018fb <syscall>
  801f34:	83 c4 18             	add    $0x18,%esp
}
  801f37:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f3a:	c9                   	leave  
  801f3b:	c3                   	ret    

00801f3c <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801f3c:	55                   	push   %ebp
  801f3d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801f3f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f42:	8b 45 08             	mov    0x8(%ebp),%eax
  801f45:	6a 00                	push   $0x0
  801f47:	6a 00                	push   $0x0
  801f49:	6a 00                	push   $0x0
  801f4b:	52                   	push   %edx
  801f4c:	50                   	push   %eax
  801f4d:	6a 2f                	push   $0x2f
  801f4f:	e8 a7 f9 ff ff       	call   8018fb <syscall>
  801f54:	83 c4 18             	add    $0x18,%esp
}
  801f57:	c9                   	leave  
  801f58:	c3                   	ret    

00801f59 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801f59:	55                   	push   %ebp
  801f5a:	89 e5                	mov    %esp,%ebp
  801f5c:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801f5f:	83 ec 0c             	sub    $0xc,%esp
  801f62:	68 88 41 80 00       	push   $0x804188
  801f67:	e8 1e e8 ff ff       	call   80078a <cprintf>
  801f6c:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801f6f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801f76:	83 ec 0c             	sub    $0xc,%esp
  801f79:	68 b4 41 80 00       	push   $0x8041b4
  801f7e:	e8 07 e8 ff ff       	call   80078a <cprintf>
  801f83:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801f86:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f8a:	a1 38 51 80 00       	mov    0x805138,%eax
  801f8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f92:	eb 56                	jmp    801fea <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f94:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f98:	74 1c                	je     801fb6 <print_mem_block_lists+0x5d>
  801f9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f9d:	8b 50 08             	mov    0x8(%eax),%edx
  801fa0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fa3:	8b 48 08             	mov    0x8(%eax),%ecx
  801fa6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fa9:	8b 40 0c             	mov    0xc(%eax),%eax
  801fac:	01 c8                	add    %ecx,%eax
  801fae:	39 c2                	cmp    %eax,%edx
  801fb0:	73 04                	jae    801fb6 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801fb2:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801fb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb9:	8b 50 08             	mov    0x8(%eax),%edx
  801fbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fbf:	8b 40 0c             	mov    0xc(%eax),%eax
  801fc2:	01 c2                	add    %eax,%edx
  801fc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fc7:	8b 40 08             	mov    0x8(%eax),%eax
  801fca:	83 ec 04             	sub    $0x4,%esp
  801fcd:	52                   	push   %edx
  801fce:	50                   	push   %eax
  801fcf:	68 c9 41 80 00       	push   $0x8041c9
  801fd4:	e8 b1 e7 ff ff       	call   80078a <cprintf>
  801fd9:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801fdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fdf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801fe2:	a1 40 51 80 00       	mov    0x805140,%eax
  801fe7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fee:	74 07                	je     801ff7 <print_mem_block_lists+0x9e>
  801ff0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ff3:	8b 00                	mov    (%eax),%eax
  801ff5:	eb 05                	jmp    801ffc <print_mem_block_lists+0xa3>
  801ff7:	b8 00 00 00 00       	mov    $0x0,%eax
  801ffc:	a3 40 51 80 00       	mov    %eax,0x805140
  802001:	a1 40 51 80 00       	mov    0x805140,%eax
  802006:	85 c0                	test   %eax,%eax
  802008:	75 8a                	jne    801f94 <print_mem_block_lists+0x3b>
  80200a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80200e:	75 84                	jne    801f94 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802010:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802014:	75 10                	jne    802026 <print_mem_block_lists+0xcd>
  802016:	83 ec 0c             	sub    $0xc,%esp
  802019:	68 d8 41 80 00       	push   $0x8041d8
  80201e:	e8 67 e7 ff ff       	call   80078a <cprintf>
  802023:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802026:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  80202d:	83 ec 0c             	sub    $0xc,%esp
  802030:	68 fc 41 80 00       	push   $0x8041fc
  802035:	e8 50 e7 ff ff       	call   80078a <cprintf>
  80203a:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  80203d:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802041:	a1 40 50 80 00       	mov    0x805040,%eax
  802046:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802049:	eb 56                	jmp    8020a1 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80204b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80204f:	74 1c                	je     80206d <print_mem_block_lists+0x114>
  802051:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802054:	8b 50 08             	mov    0x8(%eax),%edx
  802057:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80205a:	8b 48 08             	mov    0x8(%eax),%ecx
  80205d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802060:	8b 40 0c             	mov    0xc(%eax),%eax
  802063:	01 c8                	add    %ecx,%eax
  802065:	39 c2                	cmp    %eax,%edx
  802067:	73 04                	jae    80206d <print_mem_block_lists+0x114>
			sorted = 0 ;
  802069:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80206d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802070:	8b 50 08             	mov    0x8(%eax),%edx
  802073:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802076:	8b 40 0c             	mov    0xc(%eax),%eax
  802079:	01 c2                	add    %eax,%edx
  80207b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80207e:	8b 40 08             	mov    0x8(%eax),%eax
  802081:	83 ec 04             	sub    $0x4,%esp
  802084:	52                   	push   %edx
  802085:	50                   	push   %eax
  802086:	68 c9 41 80 00       	push   $0x8041c9
  80208b:	e8 fa e6 ff ff       	call   80078a <cprintf>
  802090:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802093:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802096:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802099:	a1 48 50 80 00       	mov    0x805048,%eax
  80209e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020a1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020a5:	74 07                	je     8020ae <print_mem_block_lists+0x155>
  8020a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020aa:	8b 00                	mov    (%eax),%eax
  8020ac:	eb 05                	jmp    8020b3 <print_mem_block_lists+0x15a>
  8020ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8020b3:	a3 48 50 80 00       	mov    %eax,0x805048
  8020b8:	a1 48 50 80 00       	mov    0x805048,%eax
  8020bd:	85 c0                	test   %eax,%eax
  8020bf:	75 8a                	jne    80204b <print_mem_block_lists+0xf2>
  8020c1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020c5:	75 84                	jne    80204b <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8020c7:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8020cb:	75 10                	jne    8020dd <print_mem_block_lists+0x184>
  8020cd:	83 ec 0c             	sub    $0xc,%esp
  8020d0:	68 14 42 80 00       	push   $0x804214
  8020d5:	e8 b0 e6 ff ff       	call   80078a <cprintf>
  8020da:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8020dd:	83 ec 0c             	sub    $0xc,%esp
  8020e0:	68 88 41 80 00       	push   $0x804188
  8020e5:	e8 a0 e6 ff ff       	call   80078a <cprintf>
  8020ea:	83 c4 10             	add    $0x10,%esp

}
  8020ed:	90                   	nop
  8020ee:	c9                   	leave  
  8020ef:	c3                   	ret    

008020f0 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8020f0:	55                   	push   %ebp
  8020f1:	89 e5                	mov    %esp,%ebp
  8020f3:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  8020f6:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  8020fd:	00 00 00 
  802100:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802107:	00 00 00 
  80210a:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802111:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  802114:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80211b:	e9 9e 00 00 00       	jmp    8021be <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  802120:	a1 50 50 80 00       	mov    0x805050,%eax
  802125:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802128:	c1 e2 04             	shl    $0x4,%edx
  80212b:	01 d0                	add    %edx,%eax
  80212d:	85 c0                	test   %eax,%eax
  80212f:	75 14                	jne    802145 <initialize_MemBlocksList+0x55>
  802131:	83 ec 04             	sub    $0x4,%esp
  802134:	68 3c 42 80 00       	push   $0x80423c
  802139:	6a 46                	push   $0x46
  80213b:	68 5f 42 80 00       	push   $0x80425f
  802140:	e8 91 e3 ff ff       	call   8004d6 <_panic>
  802145:	a1 50 50 80 00       	mov    0x805050,%eax
  80214a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80214d:	c1 e2 04             	shl    $0x4,%edx
  802150:	01 d0                	add    %edx,%eax
  802152:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802158:	89 10                	mov    %edx,(%eax)
  80215a:	8b 00                	mov    (%eax),%eax
  80215c:	85 c0                	test   %eax,%eax
  80215e:	74 18                	je     802178 <initialize_MemBlocksList+0x88>
  802160:	a1 48 51 80 00       	mov    0x805148,%eax
  802165:	8b 15 50 50 80 00    	mov    0x805050,%edx
  80216b:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80216e:	c1 e1 04             	shl    $0x4,%ecx
  802171:	01 ca                	add    %ecx,%edx
  802173:	89 50 04             	mov    %edx,0x4(%eax)
  802176:	eb 12                	jmp    80218a <initialize_MemBlocksList+0x9a>
  802178:	a1 50 50 80 00       	mov    0x805050,%eax
  80217d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802180:	c1 e2 04             	shl    $0x4,%edx
  802183:	01 d0                	add    %edx,%eax
  802185:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80218a:	a1 50 50 80 00       	mov    0x805050,%eax
  80218f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802192:	c1 e2 04             	shl    $0x4,%edx
  802195:	01 d0                	add    %edx,%eax
  802197:	a3 48 51 80 00       	mov    %eax,0x805148
  80219c:	a1 50 50 80 00       	mov    0x805050,%eax
  8021a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021a4:	c1 e2 04             	shl    $0x4,%edx
  8021a7:	01 d0                	add    %edx,%eax
  8021a9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021b0:	a1 54 51 80 00       	mov    0x805154,%eax
  8021b5:	40                   	inc    %eax
  8021b6:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  8021bb:	ff 45 f4             	incl   -0xc(%ebp)
  8021be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8021c4:	0f 82 56 ff ff ff    	jb     802120 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  8021ca:	90                   	nop
  8021cb:	c9                   	leave  
  8021cc:	c3                   	ret    

008021cd <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8021cd:	55                   	push   %ebp
  8021ce:	89 e5                	mov    %esp,%ebp
  8021d0:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8021d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d6:	8b 00                	mov    (%eax),%eax
  8021d8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8021db:	eb 19                	jmp    8021f6 <find_block+0x29>
	{
		if(va==point->sva)
  8021dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021e0:	8b 40 08             	mov    0x8(%eax),%eax
  8021e3:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8021e6:	75 05                	jne    8021ed <find_block+0x20>
		   return point;
  8021e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021eb:	eb 36                	jmp    802223 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8021ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f0:	8b 40 08             	mov    0x8(%eax),%eax
  8021f3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8021f6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8021fa:	74 07                	je     802203 <find_block+0x36>
  8021fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021ff:	8b 00                	mov    (%eax),%eax
  802201:	eb 05                	jmp    802208 <find_block+0x3b>
  802203:	b8 00 00 00 00       	mov    $0x0,%eax
  802208:	8b 55 08             	mov    0x8(%ebp),%edx
  80220b:	89 42 08             	mov    %eax,0x8(%edx)
  80220e:	8b 45 08             	mov    0x8(%ebp),%eax
  802211:	8b 40 08             	mov    0x8(%eax),%eax
  802214:	85 c0                	test   %eax,%eax
  802216:	75 c5                	jne    8021dd <find_block+0x10>
  802218:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80221c:	75 bf                	jne    8021dd <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  80221e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802223:	c9                   	leave  
  802224:	c3                   	ret    

00802225 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802225:	55                   	push   %ebp
  802226:	89 e5                	mov    %esp,%ebp
  802228:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  80222b:	a1 40 50 80 00       	mov    0x805040,%eax
  802230:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802233:	a1 44 50 80 00       	mov    0x805044,%eax
  802238:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  80223b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80223e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802241:	74 24                	je     802267 <insert_sorted_allocList+0x42>
  802243:	8b 45 08             	mov    0x8(%ebp),%eax
  802246:	8b 50 08             	mov    0x8(%eax),%edx
  802249:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80224c:	8b 40 08             	mov    0x8(%eax),%eax
  80224f:	39 c2                	cmp    %eax,%edx
  802251:	76 14                	jbe    802267 <insert_sorted_allocList+0x42>
  802253:	8b 45 08             	mov    0x8(%ebp),%eax
  802256:	8b 50 08             	mov    0x8(%eax),%edx
  802259:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80225c:	8b 40 08             	mov    0x8(%eax),%eax
  80225f:	39 c2                	cmp    %eax,%edx
  802261:	0f 82 60 01 00 00    	jb     8023c7 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802267:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80226b:	75 65                	jne    8022d2 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  80226d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802271:	75 14                	jne    802287 <insert_sorted_allocList+0x62>
  802273:	83 ec 04             	sub    $0x4,%esp
  802276:	68 3c 42 80 00       	push   $0x80423c
  80227b:	6a 6b                	push   $0x6b
  80227d:	68 5f 42 80 00       	push   $0x80425f
  802282:	e8 4f e2 ff ff       	call   8004d6 <_panic>
  802287:	8b 15 40 50 80 00    	mov    0x805040,%edx
  80228d:	8b 45 08             	mov    0x8(%ebp),%eax
  802290:	89 10                	mov    %edx,(%eax)
  802292:	8b 45 08             	mov    0x8(%ebp),%eax
  802295:	8b 00                	mov    (%eax),%eax
  802297:	85 c0                	test   %eax,%eax
  802299:	74 0d                	je     8022a8 <insert_sorted_allocList+0x83>
  80229b:	a1 40 50 80 00       	mov    0x805040,%eax
  8022a0:	8b 55 08             	mov    0x8(%ebp),%edx
  8022a3:	89 50 04             	mov    %edx,0x4(%eax)
  8022a6:	eb 08                	jmp    8022b0 <insert_sorted_allocList+0x8b>
  8022a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ab:	a3 44 50 80 00       	mov    %eax,0x805044
  8022b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b3:	a3 40 50 80 00       	mov    %eax,0x805040
  8022b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022bb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022c2:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8022c7:	40                   	inc    %eax
  8022c8:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8022cd:	e9 dc 01 00 00       	jmp    8024ae <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  8022d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d5:	8b 50 08             	mov    0x8(%eax),%edx
  8022d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022db:	8b 40 08             	mov    0x8(%eax),%eax
  8022de:	39 c2                	cmp    %eax,%edx
  8022e0:	77 6c                	ja     80234e <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  8022e2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8022e6:	74 06                	je     8022ee <insert_sorted_allocList+0xc9>
  8022e8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022ec:	75 14                	jne    802302 <insert_sorted_allocList+0xdd>
  8022ee:	83 ec 04             	sub    $0x4,%esp
  8022f1:	68 78 42 80 00       	push   $0x804278
  8022f6:	6a 6f                	push   $0x6f
  8022f8:	68 5f 42 80 00       	push   $0x80425f
  8022fd:	e8 d4 e1 ff ff       	call   8004d6 <_panic>
  802302:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802305:	8b 50 04             	mov    0x4(%eax),%edx
  802308:	8b 45 08             	mov    0x8(%ebp),%eax
  80230b:	89 50 04             	mov    %edx,0x4(%eax)
  80230e:	8b 45 08             	mov    0x8(%ebp),%eax
  802311:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802314:	89 10                	mov    %edx,(%eax)
  802316:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802319:	8b 40 04             	mov    0x4(%eax),%eax
  80231c:	85 c0                	test   %eax,%eax
  80231e:	74 0d                	je     80232d <insert_sorted_allocList+0x108>
  802320:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802323:	8b 40 04             	mov    0x4(%eax),%eax
  802326:	8b 55 08             	mov    0x8(%ebp),%edx
  802329:	89 10                	mov    %edx,(%eax)
  80232b:	eb 08                	jmp    802335 <insert_sorted_allocList+0x110>
  80232d:	8b 45 08             	mov    0x8(%ebp),%eax
  802330:	a3 40 50 80 00       	mov    %eax,0x805040
  802335:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802338:	8b 55 08             	mov    0x8(%ebp),%edx
  80233b:	89 50 04             	mov    %edx,0x4(%eax)
  80233e:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802343:	40                   	inc    %eax
  802344:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802349:	e9 60 01 00 00       	jmp    8024ae <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  80234e:	8b 45 08             	mov    0x8(%ebp),%eax
  802351:	8b 50 08             	mov    0x8(%eax),%edx
  802354:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802357:	8b 40 08             	mov    0x8(%eax),%eax
  80235a:	39 c2                	cmp    %eax,%edx
  80235c:	0f 82 4c 01 00 00    	jb     8024ae <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802362:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802366:	75 14                	jne    80237c <insert_sorted_allocList+0x157>
  802368:	83 ec 04             	sub    $0x4,%esp
  80236b:	68 b0 42 80 00       	push   $0x8042b0
  802370:	6a 73                	push   $0x73
  802372:	68 5f 42 80 00       	push   $0x80425f
  802377:	e8 5a e1 ff ff       	call   8004d6 <_panic>
  80237c:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802382:	8b 45 08             	mov    0x8(%ebp),%eax
  802385:	89 50 04             	mov    %edx,0x4(%eax)
  802388:	8b 45 08             	mov    0x8(%ebp),%eax
  80238b:	8b 40 04             	mov    0x4(%eax),%eax
  80238e:	85 c0                	test   %eax,%eax
  802390:	74 0c                	je     80239e <insert_sorted_allocList+0x179>
  802392:	a1 44 50 80 00       	mov    0x805044,%eax
  802397:	8b 55 08             	mov    0x8(%ebp),%edx
  80239a:	89 10                	mov    %edx,(%eax)
  80239c:	eb 08                	jmp    8023a6 <insert_sorted_allocList+0x181>
  80239e:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a1:	a3 40 50 80 00       	mov    %eax,0x805040
  8023a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a9:	a3 44 50 80 00       	mov    %eax,0x805044
  8023ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023b7:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8023bc:	40                   	inc    %eax
  8023bd:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8023c2:	e9 e7 00 00 00       	jmp    8024ae <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  8023c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  8023cd:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8023d4:	a1 40 50 80 00       	mov    0x805040,%eax
  8023d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023dc:	e9 9d 00 00 00       	jmp    80247e <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  8023e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e4:	8b 00                	mov    (%eax),%eax
  8023e6:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  8023e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ec:	8b 50 08             	mov    0x8(%eax),%edx
  8023ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f2:	8b 40 08             	mov    0x8(%eax),%eax
  8023f5:	39 c2                	cmp    %eax,%edx
  8023f7:	76 7d                	jbe    802476 <insert_sorted_allocList+0x251>
  8023f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8023fc:	8b 50 08             	mov    0x8(%eax),%edx
  8023ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802402:	8b 40 08             	mov    0x8(%eax),%eax
  802405:	39 c2                	cmp    %eax,%edx
  802407:	73 6d                	jae    802476 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802409:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80240d:	74 06                	je     802415 <insert_sorted_allocList+0x1f0>
  80240f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802413:	75 14                	jne    802429 <insert_sorted_allocList+0x204>
  802415:	83 ec 04             	sub    $0x4,%esp
  802418:	68 d4 42 80 00       	push   $0x8042d4
  80241d:	6a 7f                	push   $0x7f
  80241f:	68 5f 42 80 00       	push   $0x80425f
  802424:	e8 ad e0 ff ff       	call   8004d6 <_panic>
  802429:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80242c:	8b 10                	mov    (%eax),%edx
  80242e:	8b 45 08             	mov    0x8(%ebp),%eax
  802431:	89 10                	mov    %edx,(%eax)
  802433:	8b 45 08             	mov    0x8(%ebp),%eax
  802436:	8b 00                	mov    (%eax),%eax
  802438:	85 c0                	test   %eax,%eax
  80243a:	74 0b                	je     802447 <insert_sorted_allocList+0x222>
  80243c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243f:	8b 00                	mov    (%eax),%eax
  802441:	8b 55 08             	mov    0x8(%ebp),%edx
  802444:	89 50 04             	mov    %edx,0x4(%eax)
  802447:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244a:	8b 55 08             	mov    0x8(%ebp),%edx
  80244d:	89 10                	mov    %edx,(%eax)
  80244f:	8b 45 08             	mov    0x8(%ebp),%eax
  802452:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802455:	89 50 04             	mov    %edx,0x4(%eax)
  802458:	8b 45 08             	mov    0x8(%ebp),%eax
  80245b:	8b 00                	mov    (%eax),%eax
  80245d:	85 c0                	test   %eax,%eax
  80245f:	75 08                	jne    802469 <insert_sorted_allocList+0x244>
  802461:	8b 45 08             	mov    0x8(%ebp),%eax
  802464:	a3 44 50 80 00       	mov    %eax,0x805044
  802469:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80246e:	40                   	inc    %eax
  80246f:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802474:	eb 39                	jmp    8024af <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802476:	a1 48 50 80 00       	mov    0x805048,%eax
  80247b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80247e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802482:	74 07                	je     80248b <insert_sorted_allocList+0x266>
  802484:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802487:	8b 00                	mov    (%eax),%eax
  802489:	eb 05                	jmp    802490 <insert_sorted_allocList+0x26b>
  80248b:	b8 00 00 00 00       	mov    $0x0,%eax
  802490:	a3 48 50 80 00       	mov    %eax,0x805048
  802495:	a1 48 50 80 00       	mov    0x805048,%eax
  80249a:	85 c0                	test   %eax,%eax
  80249c:	0f 85 3f ff ff ff    	jne    8023e1 <insert_sorted_allocList+0x1bc>
  8024a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024a6:	0f 85 35 ff ff ff    	jne    8023e1 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8024ac:	eb 01                	jmp    8024af <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8024ae:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8024af:	90                   	nop
  8024b0:	c9                   	leave  
  8024b1:	c3                   	ret    

008024b2 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8024b2:	55                   	push   %ebp
  8024b3:	89 e5                	mov    %esp,%ebp
  8024b5:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8024b8:	a1 38 51 80 00       	mov    0x805138,%eax
  8024bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024c0:	e9 85 01 00 00       	jmp    80264a <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  8024c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c8:	8b 40 0c             	mov    0xc(%eax),%eax
  8024cb:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024ce:	0f 82 6e 01 00 00    	jb     802642 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  8024d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d7:	8b 40 0c             	mov    0xc(%eax),%eax
  8024da:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024dd:	0f 85 8a 00 00 00    	jne    80256d <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  8024e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024e7:	75 17                	jne    802500 <alloc_block_FF+0x4e>
  8024e9:	83 ec 04             	sub    $0x4,%esp
  8024ec:	68 08 43 80 00       	push   $0x804308
  8024f1:	68 93 00 00 00       	push   $0x93
  8024f6:	68 5f 42 80 00       	push   $0x80425f
  8024fb:	e8 d6 df ff ff       	call   8004d6 <_panic>
  802500:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802503:	8b 00                	mov    (%eax),%eax
  802505:	85 c0                	test   %eax,%eax
  802507:	74 10                	je     802519 <alloc_block_FF+0x67>
  802509:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250c:	8b 00                	mov    (%eax),%eax
  80250e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802511:	8b 52 04             	mov    0x4(%edx),%edx
  802514:	89 50 04             	mov    %edx,0x4(%eax)
  802517:	eb 0b                	jmp    802524 <alloc_block_FF+0x72>
  802519:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251c:	8b 40 04             	mov    0x4(%eax),%eax
  80251f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802524:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802527:	8b 40 04             	mov    0x4(%eax),%eax
  80252a:	85 c0                	test   %eax,%eax
  80252c:	74 0f                	je     80253d <alloc_block_FF+0x8b>
  80252e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802531:	8b 40 04             	mov    0x4(%eax),%eax
  802534:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802537:	8b 12                	mov    (%edx),%edx
  802539:	89 10                	mov    %edx,(%eax)
  80253b:	eb 0a                	jmp    802547 <alloc_block_FF+0x95>
  80253d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802540:	8b 00                	mov    (%eax),%eax
  802542:	a3 38 51 80 00       	mov    %eax,0x805138
  802547:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802550:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802553:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80255a:	a1 44 51 80 00       	mov    0x805144,%eax
  80255f:	48                   	dec    %eax
  802560:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802565:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802568:	e9 10 01 00 00       	jmp    80267d <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  80256d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802570:	8b 40 0c             	mov    0xc(%eax),%eax
  802573:	3b 45 08             	cmp    0x8(%ebp),%eax
  802576:	0f 86 c6 00 00 00    	jbe    802642 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80257c:	a1 48 51 80 00       	mov    0x805148,%eax
  802581:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802584:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802587:	8b 50 08             	mov    0x8(%eax),%edx
  80258a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80258d:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802590:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802593:	8b 55 08             	mov    0x8(%ebp),%edx
  802596:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802599:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80259d:	75 17                	jne    8025b6 <alloc_block_FF+0x104>
  80259f:	83 ec 04             	sub    $0x4,%esp
  8025a2:	68 08 43 80 00       	push   $0x804308
  8025a7:	68 9b 00 00 00       	push   $0x9b
  8025ac:	68 5f 42 80 00       	push   $0x80425f
  8025b1:	e8 20 df ff ff       	call   8004d6 <_panic>
  8025b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025b9:	8b 00                	mov    (%eax),%eax
  8025bb:	85 c0                	test   %eax,%eax
  8025bd:	74 10                	je     8025cf <alloc_block_FF+0x11d>
  8025bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025c2:	8b 00                	mov    (%eax),%eax
  8025c4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025c7:	8b 52 04             	mov    0x4(%edx),%edx
  8025ca:	89 50 04             	mov    %edx,0x4(%eax)
  8025cd:	eb 0b                	jmp    8025da <alloc_block_FF+0x128>
  8025cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025d2:	8b 40 04             	mov    0x4(%eax),%eax
  8025d5:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8025da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025dd:	8b 40 04             	mov    0x4(%eax),%eax
  8025e0:	85 c0                	test   %eax,%eax
  8025e2:	74 0f                	je     8025f3 <alloc_block_FF+0x141>
  8025e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025e7:	8b 40 04             	mov    0x4(%eax),%eax
  8025ea:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025ed:	8b 12                	mov    (%edx),%edx
  8025ef:	89 10                	mov    %edx,(%eax)
  8025f1:	eb 0a                	jmp    8025fd <alloc_block_FF+0x14b>
  8025f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025f6:	8b 00                	mov    (%eax),%eax
  8025f8:	a3 48 51 80 00       	mov    %eax,0x805148
  8025fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802600:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802606:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802609:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802610:	a1 54 51 80 00       	mov    0x805154,%eax
  802615:	48                   	dec    %eax
  802616:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  80261b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261e:	8b 50 08             	mov    0x8(%eax),%edx
  802621:	8b 45 08             	mov    0x8(%ebp),%eax
  802624:	01 c2                	add    %eax,%edx
  802626:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802629:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  80262c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262f:	8b 40 0c             	mov    0xc(%eax),%eax
  802632:	2b 45 08             	sub    0x8(%ebp),%eax
  802635:	89 c2                	mov    %eax,%edx
  802637:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263a:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  80263d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802640:	eb 3b                	jmp    80267d <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802642:	a1 40 51 80 00       	mov    0x805140,%eax
  802647:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80264a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80264e:	74 07                	je     802657 <alloc_block_FF+0x1a5>
  802650:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802653:	8b 00                	mov    (%eax),%eax
  802655:	eb 05                	jmp    80265c <alloc_block_FF+0x1aa>
  802657:	b8 00 00 00 00       	mov    $0x0,%eax
  80265c:	a3 40 51 80 00       	mov    %eax,0x805140
  802661:	a1 40 51 80 00       	mov    0x805140,%eax
  802666:	85 c0                	test   %eax,%eax
  802668:	0f 85 57 fe ff ff    	jne    8024c5 <alloc_block_FF+0x13>
  80266e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802672:	0f 85 4d fe ff ff    	jne    8024c5 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802678:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80267d:	c9                   	leave  
  80267e:	c3                   	ret    

0080267f <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  80267f:	55                   	push   %ebp
  802680:	89 e5                	mov    %esp,%ebp
  802682:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802685:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  80268c:	a1 38 51 80 00       	mov    0x805138,%eax
  802691:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802694:	e9 df 00 00 00       	jmp    802778 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802699:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269c:	8b 40 0c             	mov    0xc(%eax),%eax
  80269f:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026a2:	0f 82 c8 00 00 00    	jb     802770 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  8026a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ab:	8b 40 0c             	mov    0xc(%eax),%eax
  8026ae:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026b1:	0f 85 8a 00 00 00    	jne    802741 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  8026b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026bb:	75 17                	jne    8026d4 <alloc_block_BF+0x55>
  8026bd:	83 ec 04             	sub    $0x4,%esp
  8026c0:	68 08 43 80 00       	push   $0x804308
  8026c5:	68 b7 00 00 00       	push   $0xb7
  8026ca:	68 5f 42 80 00       	push   $0x80425f
  8026cf:	e8 02 de ff ff       	call   8004d6 <_panic>
  8026d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d7:	8b 00                	mov    (%eax),%eax
  8026d9:	85 c0                	test   %eax,%eax
  8026db:	74 10                	je     8026ed <alloc_block_BF+0x6e>
  8026dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e0:	8b 00                	mov    (%eax),%eax
  8026e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026e5:	8b 52 04             	mov    0x4(%edx),%edx
  8026e8:	89 50 04             	mov    %edx,0x4(%eax)
  8026eb:	eb 0b                	jmp    8026f8 <alloc_block_BF+0x79>
  8026ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f0:	8b 40 04             	mov    0x4(%eax),%eax
  8026f3:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8026f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fb:	8b 40 04             	mov    0x4(%eax),%eax
  8026fe:	85 c0                	test   %eax,%eax
  802700:	74 0f                	je     802711 <alloc_block_BF+0x92>
  802702:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802705:	8b 40 04             	mov    0x4(%eax),%eax
  802708:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80270b:	8b 12                	mov    (%edx),%edx
  80270d:	89 10                	mov    %edx,(%eax)
  80270f:	eb 0a                	jmp    80271b <alloc_block_BF+0x9c>
  802711:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802714:	8b 00                	mov    (%eax),%eax
  802716:	a3 38 51 80 00       	mov    %eax,0x805138
  80271b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802724:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802727:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80272e:	a1 44 51 80 00       	mov    0x805144,%eax
  802733:	48                   	dec    %eax
  802734:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802739:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273c:	e9 4d 01 00 00       	jmp    80288e <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802741:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802744:	8b 40 0c             	mov    0xc(%eax),%eax
  802747:	3b 45 08             	cmp    0x8(%ebp),%eax
  80274a:	76 24                	jbe    802770 <alloc_block_BF+0xf1>
  80274c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274f:	8b 40 0c             	mov    0xc(%eax),%eax
  802752:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802755:	73 19                	jae    802770 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802757:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  80275e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802761:	8b 40 0c             	mov    0xc(%eax),%eax
  802764:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802767:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276a:	8b 40 08             	mov    0x8(%eax),%eax
  80276d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802770:	a1 40 51 80 00       	mov    0x805140,%eax
  802775:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802778:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80277c:	74 07                	je     802785 <alloc_block_BF+0x106>
  80277e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802781:	8b 00                	mov    (%eax),%eax
  802783:	eb 05                	jmp    80278a <alloc_block_BF+0x10b>
  802785:	b8 00 00 00 00       	mov    $0x0,%eax
  80278a:	a3 40 51 80 00       	mov    %eax,0x805140
  80278f:	a1 40 51 80 00       	mov    0x805140,%eax
  802794:	85 c0                	test   %eax,%eax
  802796:	0f 85 fd fe ff ff    	jne    802699 <alloc_block_BF+0x1a>
  80279c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027a0:	0f 85 f3 fe ff ff    	jne    802699 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  8027a6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8027aa:	0f 84 d9 00 00 00    	je     802889 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  8027b0:	a1 48 51 80 00       	mov    0x805148,%eax
  8027b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  8027b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027bb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8027be:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  8027c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027c4:	8b 55 08             	mov    0x8(%ebp),%edx
  8027c7:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  8027ca:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8027ce:	75 17                	jne    8027e7 <alloc_block_BF+0x168>
  8027d0:	83 ec 04             	sub    $0x4,%esp
  8027d3:	68 08 43 80 00       	push   $0x804308
  8027d8:	68 c7 00 00 00       	push   $0xc7
  8027dd:	68 5f 42 80 00       	push   $0x80425f
  8027e2:	e8 ef dc ff ff       	call   8004d6 <_panic>
  8027e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027ea:	8b 00                	mov    (%eax),%eax
  8027ec:	85 c0                	test   %eax,%eax
  8027ee:	74 10                	je     802800 <alloc_block_BF+0x181>
  8027f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027f3:	8b 00                	mov    (%eax),%eax
  8027f5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8027f8:	8b 52 04             	mov    0x4(%edx),%edx
  8027fb:	89 50 04             	mov    %edx,0x4(%eax)
  8027fe:	eb 0b                	jmp    80280b <alloc_block_BF+0x18c>
  802800:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802803:	8b 40 04             	mov    0x4(%eax),%eax
  802806:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80280b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80280e:	8b 40 04             	mov    0x4(%eax),%eax
  802811:	85 c0                	test   %eax,%eax
  802813:	74 0f                	je     802824 <alloc_block_BF+0x1a5>
  802815:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802818:	8b 40 04             	mov    0x4(%eax),%eax
  80281b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80281e:	8b 12                	mov    (%edx),%edx
  802820:	89 10                	mov    %edx,(%eax)
  802822:	eb 0a                	jmp    80282e <alloc_block_BF+0x1af>
  802824:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802827:	8b 00                	mov    (%eax),%eax
  802829:	a3 48 51 80 00       	mov    %eax,0x805148
  80282e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802831:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802837:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80283a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802841:	a1 54 51 80 00       	mov    0x805154,%eax
  802846:	48                   	dec    %eax
  802847:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  80284c:	83 ec 08             	sub    $0x8,%esp
  80284f:	ff 75 ec             	pushl  -0x14(%ebp)
  802852:	68 38 51 80 00       	push   $0x805138
  802857:	e8 71 f9 ff ff       	call   8021cd <find_block>
  80285c:	83 c4 10             	add    $0x10,%esp
  80285f:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802862:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802865:	8b 50 08             	mov    0x8(%eax),%edx
  802868:	8b 45 08             	mov    0x8(%ebp),%eax
  80286b:	01 c2                	add    %eax,%edx
  80286d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802870:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802873:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802876:	8b 40 0c             	mov    0xc(%eax),%eax
  802879:	2b 45 08             	sub    0x8(%ebp),%eax
  80287c:	89 c2                	mov    %eax,%edx
  80287e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802881:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802884:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802887:	eb 05                	jmp    80288e <alloc_block_BF+0x20f>
	}
	return NULL;
  802889:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80288e:	c9                   	leave  
  80288f:	c3                   	ret    

00802890 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802890:	55                   	push   %ebp
  802891:	89 e5                	mov    %esp,%ebp
  802893:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802896:	a1 28 50 80 00       	mov    0x805028,%eax
  80289b:	85 c0                	test   %eax,%eax
  80289d:	0f 85 de 01 00 00    	jne    802a81 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8028a3:	a1 38 51 80 00       	mov    0x805138,%eax
  8028a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028ab:	e9 9e 01 00 00       	jmp    802a4e <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  8028b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b3:	8b 40 0c             	mov    0xc(%eax),%eax
  8028b6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028b9:	0f 82 87 01 00 00    	jb     802a46 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  8028bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c2:	8b 40 0c             	mov    0xc(%eax),%eax
  8028c5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028c8:	0f 85 95 00 00 00    	jne    802963 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  8028ce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028d2:	75 17                	jne    8028eb <alloc_block_NF+0x5b>
  8028d4:	83 ec 04             	sub    $0x4,%esp
  8028d7:	68 08 43 80 00       	push   $0x804308
  8028dc:	68 e0 00 00 00       	push   $0xe0
  8028e1:	68 5f 42 80 00       	push   $0x80425f
  8028e6:	e8 eb db ff ff       	call   8004d6 <_panic>
  8028eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ee:	8b 00                	mov    (%eax),%eax
  8028f0:	85 c0                	test   %eax,%eax
  8028f2:	74 10                	je     802904 <alloc_block_NF+0x74>
  8028f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f7:	8b 00                	mov    (%eax),%eax
  8028f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028fc:	8b 52 04             	mov    0x4(%edx),%edx
  8028ff:	89 50 04             	mov    %edx,0x4(%eax)
  802902:	eb 0b                	jmp    80290f <alloc_block_NF+0x7f>
  802904:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802907:	8b 40 04             	mov    0x4(%eax),%eax
  80290a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80290f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802912:	8b 40 04             	mov    0x4(%eax),%eax
  802915:	85 c0                	test   %eax,%eax
  802917:	74 0f                	je     802928 <alloc_block_NF+0x98>
  802919:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291c:	8b 40 04             	mov    0x4(%eax),%eax
  80291f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802922:	8b 12                	mov    (%edx),%edx
  802924:	89 10                	mov    %edx,(%eax)
  802926:	eb 0a                	jmp    802932 <alloc_block_NF+0xa2>
  802928:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292b:	8b 00                	mov    (%eax),%eax
  80292d:	a3 38 51 80 00       	mov    %eax,0x805138
  802932:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802935:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80293b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802945:	a1 44 51 80 00       	mov    0x805144,%eax
  80294a:	48                   	dec    %eax
  80294b:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802950:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802953:	8b 40 08             	mov    0x8(%eax),%eax
  802956:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  80295b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295e:	e9 f8 04 00 00       	jmp    802e5b <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802963:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802966:	8b 40 0c             	mov    0xc(%eax),%eax
  802969:	3b 45 08             	cmp    0x8(%ebp),%eax
  80296c:	0f 86 d4 00 00 00    	jbe    802a46 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802972:	a1 48 51 80 00       	mov    0x805148,%eax
  802977:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  80297a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297d:	8b 50 08             	mov    0x8(%eax),%edx
  802980:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802983:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802986:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802989:	8b 55 08             	mov    0x8(%ebp),%edx
  80298c:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80298f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802993:	75 17                	jne    8029ac <alloc_block_NF+0x11c>
  802995:	83 ec 04             	sub    $0x4,%esp
  802998:	68 08 43 80 00       	push   $0x804308
  80299d:	68 e9 00 00 00       	push   $0xe9
  8029a2:	68 5f 42 80 00       	push   $0x80425f
  8029a7:	e8 2a db ff ff       	call   8004d6 <_panic>
  8029ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029af:	8b 00                	mov    (%eax),%eax
  8029b1:	85 c0                	test   %eax,%eax
  8029b3:	74 10                	je     8029c5 <alloc_block_NF+0x135>
  8029b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029b8:	8b 00                	mov    (%eax),%eax
  8029ba:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029bd:	8b 52 04             	mov    0x4(%edx),%edx
  8029c0:	89 50 04             	mov    %edx,0x4(%eax)
  8029c3:	eb 0b                	jmp    8029d0 <alloc_block_NF+0x140>
  8029c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029c8:	8b 40 04             	mov    0x4(%eax),%eax
  8029cb:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8029d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029d3:	8b 40 04             	mov    0x4(%eax),%eax
  8029d6:	85 c0                	test   %eax,%eax
  8029d8:	74 0f                	je     8029e9 <alloc_block_NF+0x159>
  8029da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029dd:	8b 40 04             	mov    0x4(%eax),%eax
  8029e0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029e3:	8b 12                	mov    (%edx),%edx
  8029e5:	89 10                	mov    %edx,(%eax)
  8029e7:	eb 0a                	jmp    8029f3 <alloc_block_NF+0x163>
  8029e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029ec:	8b 00                	mov    (%eax),%eax
  8029ee:	a3 48 51 80 00       	mov    %eax,0x805148
  8029f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029f6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029ff:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a06:	a1 54 51 80 00       	mov    0x805154,%eax
  802a0b:	48                   	dec    %eax
  802a0c:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802a11:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a14:	8b 40 08             	mov    0x8(%eax),%eax
  802a17:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802a1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1f:	8b 50 08             	mov    0x8(%eax),%edx
  802a22:	8b 45 08             	mov    0x8(%ebp),%eax
  802a25:	01 c2                	add    %eax,%edx
  802a27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2a:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802a2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a30:	8b 40 0c             	mov    0xc(%eax),%eax
  802a33:	2b 45 08             	sub    0x8(%ebp),%eax
  802a36:	89 c2                	mov    %eax,%edx
  802a38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3b:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802a3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a41:	e9 15 04 00 00       	jmp    802e5b <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802a46:	a1 40 51 80 00       	mov    0x805140,%eax
  802a4b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a4e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a52:	74 07                	je     802a5b <alloc_block_NF+0x1cb>
  802a54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a57:	8b 00                	mov    (%eax),%eax
  802a59:	eb 05                	jmp    802a60 <alloc_block_NF+0x1d0>
  802a5b:	b8 00 00 00 00       	mov    $0x0,%eax
  802a60:	a3 40 51 80 00       	mov    %eax,0x805140
  802a65:	a1 40 51 80 00       	mov    0x805140,%eax
  802a6a:	85 c0                	test   %eax,%eax
  802a6c:	0f 85 3e fe ff ff    	jne    8028b0 <alloc_block_NF+0x20>
  802a72:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a76:	0f 85 34 fe ff ff    	jne    8028b0 <alloc_block_NF+0x20>
  802a7c:	e9 d5 03 00 00       	jmp    802e56 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802a81:	a1 38 51 80 00       	mov    0x805138,%eax
  802a86:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a89:	e9 b1 01 00 00       	jmp    802c3f <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802a8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a91:	8b 50 08             	mov    0x8(%eax),%edx
  802a94:	a1 28 50 80 00       	mov    0x805028,%eax
  802a99:	39 c2                	cmp    %eax,%edx
  802a9b:	0f 82 96 01 00 00    	jb     802c37 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802aa1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa4:	8b 40 0c             	mov    0xc(%eax),%eax
  802aa7:	3b 45 08             	cmp    0x8(%ebp),%eax
  802aaa:	0f 82 87 01 00 00    	jb     802c37 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802ab0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab3:	8b 40 0c             	mov    0xc(%eax),%eax
  802ab6:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ab9:	0f 85 95 00 00 00    	jne    802b54 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802abf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ac3:	75 17                	jne    802adc <alloc_block_NF+0x24c>
  802ac5:	83 ec 04             	sub    $0x4,%esp
  802ac8:	68 08 43 80 00       	push   $0x804308
  802acd:	68 fc 00 00 00       	push   $0xfc
  802ad2:	68 5f 42 80 00       	push   $0x80425f
  802ad7:	e8 fa d9 ff ff       	call   8004d6 <_panic>
  802adc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802adf:	8b 00                	mov    (%eax),%eax
  802ae1:	85 c0                	test   %eax,%eax
  802ae3:	74 10                	je     802af5 <alloc_block_NF+0x265>
  802ae5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae8:	8b 00                	mov    (%eax),%eax
  802aea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802aed:	8b 52 04             	mov    0x4(%edx),%edx
  802af0:	89 50 04             	mov    %edx,0x4(%eax)
  802af3:	eb 0b                	jmp    802b00 <alloc_block_NF+0x270>
  802af5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af8:	8b 40 04             	mov    0x4(%eax),%eax
  802afb:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802b00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b03:	8b 40 04             	mov    0x4(%eax),%eax
  802b06:	85 c0                	test   %eax,%eax
  802b08:	74 0f                	je     802b19 <alloc_block_NF+0x289>
  802b0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0d:	8b 40 04             	mov    0x4(%eax),%eax
  802b10:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b13:	8b 12                	mov    (%edx),%edx
  802b15:	89 10                	mov    %edx,(%eax)
  802b17:	eb 0a                	jmp    802b23 <alloc_block_NF+0x293>
  802b19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1c:	8b 00                	mov    (%eax),%eax
  802b1e:	a3 38 51 80 00       	mov    %eax,0x805138
  802b23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b26:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b2f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b36:	a1 44 51 80 00       	mov    0x805144,%eax
  802b3b:	48                   	dec    %eax
  802b3c:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802b41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b44:	8b 40 08             	mov    0x8(%eax),%eax
  802b47:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802b4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4f:	e9 07 03 00 00       	jmp    802e5b <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802b54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b57:	8b 40 0c             	mov    0xc(%eax),%eax
  802b5a:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b5d:	0f 86 d4 00 00 00    	jbe    802c37 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802b63:	a1 48 51 80 00       	mov    0x805148,%eax
  802b68:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802b6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6e:	8b 50 08             	mov    0x8(%eax),%edx
  802b71:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b74:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802b77:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b7a:	8b 55 08             	mov    0x8(%ebp),%edx
  802b7d:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802b80:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802b84:	75 17                	jne    802b9d <alloc_block_NF+0x30d>
  802b86:	83 ec 04             	sub    $0x4,%esp
  802b89:	68 08 43 80 00       	push   $0x804308
  802b8e:	68 04 01 00 00       	push   $0x104
  802b93:	68 5f 42 80 00       	push   $0x80425f
  802b98:	e8 39 d9 ff ff       	call   8004d6 <_panic>
  802b9d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ba0:	8b 00                	mov    (%eax),%eax
  802ba2:	85 c0                	test   %eax,%eax
  802ba4:	74 10                	je     802bb6 <alloc_block_NF+0x326>
  802ba6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ba9:	8b 00                	mov    (%eax),%eax
  802bab:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802bae:	8b 52 04             	mov    0x4(%edx),%edx
  802bb1:	89 50 04             	mov    %edx,0x4(%eax)
  802bb4:	eb 0b                	jmp    802bc1 <alloc_block_NF+0x331>
  802bb6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bb9:	8b 40 04             	mov    0x4(%eax),%eax
  802bbc:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802bc1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bc4:	8b 40 04             	mov    0x4(%eax),%eax
  802bc7:	85 c0                	test   %eax,%eax
  802bc9:	74 0f                	je     802bda <alloc_block_NF+0x34a>
  802bcb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bce:	8b 40 04             	mov    0x4(%eax),%eax
  802bd1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802bd4:	8b 12                	mov    (%edx),%edx
  802bd6:	89 10                	mov    %edx,(%eax)
  802bd8:	eb 0a                	jmp    802be4 <alloc_block_NF+0x354>
  802bda:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bdd:	8b 00                	mov    (%eax),%eax
  802bdf:	a3 48 51 80 00       	mov    %eax,0x805148
  802be4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802be7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bf0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bf7:	a1 54 51 80 00       	mov    0x805154,%eax
  802bfc:	48                   	dec    %eax
  802bfd:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802c02:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c05:	8b 40 08             	mov    0x8(%eax),%eax
  802c08:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802c0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c10:	8b 50 08             	mov    0x8(%eax),%edx
  802c13:	8b 45 08             	mov    0x8(%ebp),%eax
  802c16:	01 c2                	add    %eax,%edx
  802c18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1b:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802c1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c21:	8b 40 0c             	mov    0xc(%eax),%eax
  802c24:	2b 45 08             	sub    0x8(%ebp),%eax
  802c27:	89 c2                	mov    %eax,%edx
  802c29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c2c:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802c2f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c32:	e9 24 02 00 00       	jmp    802e5b <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802c37:	a1 40 51 80 00       	mov    0x805140,%eax
  802c3c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c3f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c43:	74 07                	je     802c4c <alloc_block_NF+0x3bc>
  802c45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c48:	8b 00                	mov    (%eax),%eax
  802c4a:	eb 05                	jmp    802c51 <alloc_block_NF+0x3c1>
  802c4c:	b8 00 00 00 00       	mov    $0x0,%eax
  802c51:	a3 40 51 80 00       	mov    %eax,0x805140
  802c56:	a1 40 51 80 00       	mov    0x805140,%eax
  802c5b:	85 c0                	test   %eax,%eax
  802c5d:	0f 85 2b fe ff ff    	jne    802a8e <alloc_block_NF+0x1fe>
  802c63:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c67:	0f 85 21 fe ff ff    	jne    802a8e <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802c6d:	a1 38 51 80 00       	mov    0x805138,%eax
  802c72:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c75:	e9 ae 01 00 00       	jmp    802e28 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802c7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c7d:	8b 50 08             	mov    0x8(%eax),%edx
  802c80:	a1 28 50 80 00       	mov    0x805028,%eax
  802c85:	39 c2                	cmp    %eax,%edx
  802c87:	0f 83 93 01 00 00    	jae    802e20 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802c8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c90:	8b 40 0c             	mov    0xc(%eax),%eax
  802c93:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c96:	0f 82 84 01 00 00    	jb     802e20 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802c9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9f:	8b 40 0c             	mov    0xc(%eax),%eax
  802ca2:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ca5:	0f 85 95 00 00 00    	jne    802d40 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802cab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802caf:	75 17                	jne    802cc8 <alloc_block_NF+0x438>
  802cb1:	83 ec 04             	sub    $0x4,%esp
  802cb4:	68 08 43 80 00       	push   $0x804308
  802cb9:	68 14 01 00 00       	push   $0x114
  802cbe:	68 5f 42 80 00       	push   $0x80425f
  802cc3:	e8 0e d8 ff ff       	call   8004d6 <_panic>
  802cc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ccb:	8b 00                	mov    (%eax),%eax
  802ccd:	85 c0                	test   %eax,%eax
  802ccf:	74 10                	je     802ce1 <alloc_block_NF+0x451>
  802cd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd4:	8b 00                	mov    (%eax),%eax
  802cd6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cd9:	8b 52 04             	mov    0x4(%edx),%edx
  802cdc:	89 50 04             	mov    %edx,0x4(%eax)
  802cdf:	eb 0b                	jmp    802cec <alloc_block_NF+0x45c>
  802ce1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce4:	8b 40 04             	mov    0x4(%eax),%eax
  802ce7:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802cec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cef:	8b 40 04             	mov    0x4(%eax),%eax
  802cf2:	85 c0                	test   %eax,%eax
  802cf4:	74 0f                	je     802d05 <alloc_block_NF+0x475>
  802cf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf9:	8b 40 04             	mov    0x4(%eax),%eax
  802cfc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cff:	8b 12                	mov    (%edx),%edx
  802d01:	89 10                	mov    %edx,(%eax)
  802d03:	eb 0a                	jmp    802d0f <alloc_block_NF+0x47f>
  802d05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d08:	8b 00                	mov    (%eax),%eax
  802d0a:	a3 38 51 80 00       	mov    %eax,0x805138
  802d0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d12:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d1b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d22:	a1 44 51 80 00       	mov    0x805144,%eax
  802d27:	48                   	dec    %eax
  802d28:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802d2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d30:	8b 40 08             	mov    0x8(%eax),%eax
  802d33:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802d38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3b:	e9 1b 01 00 00       	jmp    802e5b <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802d40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d43:	8b 40 0c             	mov    0xc(%eax),%eax
  802d46:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d49:	0f 86 d1 00 00 00    	jbe    802e20 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802d4f:	a1 48 51 80 00       	mov    0x805148,%eax
  802d54:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802d57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d5a:	8b 50 08             	mov    0x8(%eax),%edx
  802d5d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d60:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802d63:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d66:	8b 55 08             	mov    0x8(%ebp),%edx
  802d69:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802d6c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802d70:	75 17                	jne    802d89 <alloc_block_NF+0x4f9>
  802d72:	83 ec 04             	sub    $0x4,%esp
  802d75:	68 08 43 80 00       	push   $0x804308
  802d7a:	68 1c 01 00 00       	push   $0x11c
  802d7f:	68 5f 42 80 00       	push   $0x80425f
  802d84:	e8 4d d7 ff ff       	call   8004d6 <_panic>
  802d89:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d8c:	8b 00                	mov    (%eax),%eax
  802d8e:	85 c0                	test   %eax,%eax
  802d90:	74 10                	je     802da2 <alloc_block_NF+0x512>
  802d92:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d95:	8b 00                	mov    (%eax),%eax
  802d97:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d9a:	8b 52 04             	mov    0x4(%edx),%edx
  802d9d:	89 50 04             	mov    %edx,0x4(%eax)
  802da0:	eb 0b                	jmp    802dad <alloc_block_NF+0x51d>
  802da2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802da5:	8b 40 04             	mov    0x4(%eax),%eax
  802da8:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802dad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802db0:	8b 40 04             	mov    0x4(%eax),%eax
  802db3:	85 c0                	test   %eax,%eax
  802db5:	74 0f                	je     802dc6 <alloc_block_NF+0x536>
  802db7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dba:	8b 40 04             	mov    0x4(%eax),%eax
  802dbd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802dc0:	8b 12                	mov    (%edx),%edx
  802dc2:	89 10                	mov    %edx,(%eax)
  802dc4:	eb 0a                	jmp    802dd0 <alloc_block_NF+0x540>
  802dc6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dc9:	8b 00                	mov    (%eax),%eax
  802dcb:	a3 48 51 80 00       	mov    %eax,0x805148
  802dd0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dd3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802dd9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ddc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802de3:	a1 54 51 80 00       	mov    0x805154,%eax
  802de8:	48                   	dec    %eax
  802de9:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802dee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802df1:	8b 40 08             	mov    0x8(%eax),%eax
  802df4:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802df9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dfc:	8b 50 08             	mov    0x8(%eax),%edx
  802dff:	8b 45 08             	mov    0x8(%ebp),%eax
  802e02:	01 c2                	add    %eax,%edx
  802e04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e07:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802e0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e0d:	8b 40 0c             	mov    0xc(%eax),%eax
  802e10:	2b 45 08             	sub    0x8(%ebp),%eax
  802e13:	89 c2                	mov    %eax,%edx
  802e15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e18:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802e1b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e1e:	eb 3b                	jmp    802e5b <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802e20:	a1 40 51 80 00       	mov    0x805140,%eax
  802e25:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e28:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e2c:	74 07                	je     802e35 <alloc_block_NF+0x5a5>
  802e2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e31:	8b 00                	mov    (%eax),%eax
  802e33:	eb 05                	jmp    802e3a <alloc_block_NF+0x5aa>
  802e35:	b8 00 00 00 00       	mov    $0x0,%eax
  802e3a:	a3 40 51 80 00       	mov    %eax,0x805140
  802e3f:	a1 40 51 80 00       	mov    0x805140,%eax
  802e44:	85 c0                	test   %eax,%eax
  802e46:	0f 85 2e fe ff ff    	jne    802c7a <alloc_block_NF+0x3ea>
  802e4c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e50:	0f 85 24 fe ff ff    	jne    802c7a <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802e56:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e5b:	c9                   	leave  
  802e5c:	c3                   	ret    

00802e5d <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802e5d:	55                   	push   %ebp
  802e5e:	89 e5                	mov    %esp,%ebp
  802e60:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802e63:	a1 38 51 80 00       	mov    0x805138,%eax
  802e68:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802e6b:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802e70:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802e73:	a1 38 51 80 00       	mov    0x805138,%eax
  802e78:	85 c0                	test   %eax,%eax
  802e7a:	74 14                	je     802e90 <insert_sorted_with_merge_freeList+0x33>
  802e7c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e7f:	8b 50 08             	mov    0x8(%eax),%edx
  802e82:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e85:	8b 40 08             	mov    0x8(%eax),%eax
  802e88:	39 c2                	cmp    %eax,%edx
  802e8a:	0f 87 9b 01 00 00    	ja     80302b <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802e90:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e94:	75 17                	jne    802ead <insert_sorted_with_merge_freeList+0x50>
  802e96:	83 ec 04             	sub    $0x4,%esp
  802e99:	68 3c 42 80 00       	push   $0x80423c
  802e9e:	68 38 01 00 00       	push   $0x138
  802ea3:	68 5f 42 80 00       	push   $0x80425f
  802ea8:	e8 29 d6 ff ff       	call   8004d6 <_panic>
  802ead:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802eb3:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb6:	89 10                	mov    %edx,(%eax)
  802eb8:	8b 45 08             	mov    0x8(%ebp),%eax
  802ebb:	8b 00                	mov    (%eax),%eax
  802ebd:	85 c0                	test   %eax,%eax
  802ebf:	74 0d                	je     802ece <insert_sorted_with_merge_freeList+0x71>
  802ec1:	a1 38 51 80 00       	mov    0x805138,%eax
  802ec6:	8b 55 08             	mov    0x8(%ebp),%edx
  802ec9:	89 50 04             	mov    %edx,0x4(%eax)
  802ecc:	eb 08                	jmp    802ed6 <insert_sorted_with_merge_freeList+0x79>
  802ece:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed1:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ed6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed9:	a3 38 51 80 00       	mov    %eax,0x805138
  802ede:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ee8:	a1 44 51 80 00       	mov    0x805144,%eax
  802eed:	40                   	inc    %eax
  802eee:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802ef3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ef7:	0f 84 a8 06 00 00    	je     8035a5 <insert_sorted_with_merge_freeList+0x748>
  802efd:	8b 45 08             	mov    0x8(%ebp),%eax
  802f00:	8b 50 08             	mov    0x8(%eax),%edx
  802f03:	8b 45 08             	mov    0x8(%ebp),%eax
  802f06:	8b 40 0c             	mov    0xc(%eax),%eax
  802f09:	01 c2                	add    %eax,%edx
  802f0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f0e:	8b 40 08             	mov    0x8(%eax),%eax
  802f11:	39 c2                	cmp    %eax,%edx
  802f13:	0f 85 8c 06 00 00    	jne    8035a5 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802f19:	8b 45 08             	mov    0x8(%ebp),%eax
  802f1c:	8b 50 0c             	mov    0xc(%eax),%edx
  802f1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f22:	8b 40 0c             	mov    0xc(%eax),%eax
  802f25:	01 c2                	add    %eax,%edx
  802f27:	8b 45 08             	mov    0x8(%ebp),%eax
  802f2a:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802f2d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f31:	75 17                	jne    802f4a <insert_sorted_with_merge_freeList+0xed>
  802f33:	83 ec 04             	sub    $0x4,%esp
  802f36:	68 08 43 80 00       	push   $0x804308
  802f3b:	68 3c 01 00 00       	push   $0x13c
  802f40:	68 5f 42 80 00       	push   $0x80425f
  802f45:	e8 8c d5 ff ff       	call   8004d6 <_panic>
  802f4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f4d:	8b 00                	mov    (%eax),%eax
  802f4f:	85 c0                	test   %eax,%eax
  802f51:	74 10                	je     802f63 <insert_sorted_with_merge_freeList+0x106>
  802f53:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f56:	8b 00                	mov    (%eax),%eax
  802f58:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f5b:	8b 52 04             	mov    0x4(%edx),%edx
  802f5e:	89 50 04             	mov    %edx,0x4(%eax)
  802f61:	eb 0b                	jmp    802f6e <insert_sorted_with_merge_freeList+0x111>
  802f63:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f66:	8b 40 04             	mov    0x4(%eax),%eax
  802f69:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f71:	8b 40 04             	mov    0x4(%eax),%eax
  802f74:	85 c0                	test   %eax,%eax
  802f76:	74 0f                	je     802f87 <insert_sorted_with_merge_freeList+0x12a>
  802f78:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f7b:	8b 40 04             	mov    0x4(%eax),%eax
  802f7e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f81:	8b 12                	mov    (%edx),%edx
  802f83:	89 10                	mov    %edx,(%eax)
  802f85:	eb 0a                	jmp    802f91 <insert_sorted_with_merge_freeList+0x134>
  802f87:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f8a:	8b 00                	mov    (%eax),%eax
  802f8c:	a3 38 51 80 00       	mov    %eax,0x805138
  802f91:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f94:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f9d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fa4:	a1 44 51 80 00       	mov    0x805144,%eax
  802fa9:	48                   	dec    %eax
  802faa:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802faf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fb2:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802fb9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fbc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802fc3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802fc7:	75 17                	jne    802fe0 <insert_sorted_with_merge_freeList+0x183>
  802fc9:	83 ec 04             	sub    $0x4,%esp
  802fcc:	68 3c 42 80 00       	push   $0x80423c
  802fd1:	68 3f 01 00 00       	push   $0x13f
  802fd6:	68 5f 42 80 00       	push   $0x80425f
  802fdb:	e8 f6 d4 ff ff       	call   8004d6 <_panic>
  802fe0:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802fe6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fe9:	89 10                	mov    %edx,(%eax)
  802feb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fee:	8b 00                	mov    (%eax),%eax
  802ff0:	85 c0                	test   %eax,%eax
  802ff2:	74 0d                	je     803001 <insert_sorted_with_merge_freeList+0x1a4>
  802ff4:	a1 48 51 80 00       	mov    0x805148,%eax
  802ff9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ffc:	89 50 04             	mov    %edx,0x4(%eax)
  802fff:	eb 08                	jmp    803009 <insert_sorted_with_merge_freeList+0x1ac>
  803001:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803004:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803009:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80300c:	a3 48 51 80 00       	mov    %eax,0x805148
  803011:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803014:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80301b:	a1 54 51 80 00       	mov    0x805154,%eax
  803020:	40                   	inc    %eax
  803021:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803026:	e9 7a 05 00 00       	jmp    8035a5 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  80302b:	8b 45 08             	mov    0x8(%ebp),%eax
  80302e:	8b 50 08             	mov    0x8(%eax),%edx
  803031:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803034:	8b 40 08             	mov    0x8(%eax),%eax
  803037:	39 c2                	cmp    %eax,%edx
  803039:	0f 82 14 01 00 00    	jb     803153 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  80303f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803042:	8b 50 08             	mov    0x8(%eax),%edx
  803045:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803048:	8b 40 0c             	mov    0xc(%eax),%eax
  80304b:	01 c2                	add    %eax,%edx
  80304d:	8b 45 08             	mov    0x8(%ebp),%eax
  803050:	8b 40 08             	mov    0x8(%eax),%eax
  803053:	39 c2                	cmp    %eax,%edx
  803055:	0f 85 90 00 00 00    	jne    8030eb <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  80305b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80305e:	8b 50 0c             	mov    0xc(%eax),%edx
  803061:	8b 45 08             	mov    0x8(%ebp),%eax
  803064:	8b 40 0c             	mov    0xc(%eax),%eax
  803067:	01 c2                	add    %eax,%edx
  803069:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80306c:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  80306f:	8b 45 08             	mov    0x8(%ebp),%eax
  803072:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  803079:	8b 45 08             	mov    0x8(%ebp),%eax
  80307c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803083:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803087:	75 17                	jne    8030a0 <insert_sorted_with_merge_freeList+0x243>
  803089:	83 ec 04             	sub    $0x4,%esp
  80308c:	68 3c 42 80 00       	push   $0x80423c
  803091:	68 49 01 00 00       	push   $0x149
  803096:	68 5f 42 80 00       	push   $0x80425f
  80309b:	e8 36 d4 ff ff       	call   8004d6 <_panic>
  8030a0:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8030a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a9:	89 10                	mov    %edx,(%eax)
  8030ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ae:	8b 00                	mov    (%eax),%eax
  8030b0:	85 c0                	test   %eax,%eax
  8030b2:	74 0d                	je     8030c1 <insert_sorted_with_merge_freeList+0x264>
  8030b4:	a1 48 51 80 00       	mov    0x805148,%eax
  8030b9:	8b 55 08             	mov    0x8(%ebp),%edx
  8030bc:	89 50 04             	mov    %edx,0x4(%eax)
  8030bf:	eb 08                	jmp    8030c9 <insert_sorted_with_merge_freeList+0x26c>
  8030c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c4:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8030c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8030cc:	a3 48 51 80 00       	mov    %eax,0x805148
  8030d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030db:	a1 54 51 80 00       	mov    0x805154,%eax
  8030e0:	40                   	inc    %eax
  8030e1:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8030e6:	e9 bb 04 00 00       	jmp    8035a6 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  8030eb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030ef:	75 17                	jne    803108 <insert_sorted_with_merge_freeList+0x2ab>
  8030f1:	83 ec 04             	sub    $0x4,%esp
  8030f4:	68 b0 42 80 00       	push   $0x8042b0
  8030f9:	68 4c 01 00 00       	push   $0x14c
  8030fe:	68 5f 42 80 00       	push   $0x80425f
  803103:	e8 ce d3 ff ff       	call   8004d6 <_panic>
  803108:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  80310e:	8b 45 08             	mov    0x8(%ebp),%eax
  803111:	89 50 04             	mov    %edx,0x4(%eax)
  803114:	8b 45 08             	mov    0x8(%ebp),%eax
  803117:	8b 40 04             	mov    0x4(%eax),%eax
  80311a:	85 c0                	test   %eax,%eax
  80311c:	74 0c                	je     80312a <insert_sorted_with_merge_freeList+0x2cd>
  80311e:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803123:	8b 55 08             	mov    0x8(%ebp),%edx
  803126:	89 10                	mov    %edx,(%eax)
  803128:	eb 08                	jmp    803132 <insert_sorted_with_merge_freeList+0x2d5>
  80312a:	8b 45 08             	mov    0x8(%ebp),%eax
  80312d:	a3 38 51 80 00       	mov    %eax,0x805138
  803132:	8b 45 08             	mov    0x8(%ebp),%eax
  803135:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80313a:	8b 45 08             	mov    0x8(%ebp),%eax
  80313d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803143:	a1 44 51 80 00       	mov    0x805144,%eax
  803148:	40                   	inc    %eax
  803149:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80314e:	e9 53 04 00 00       	jmp    8035a6 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803153:	a1 38 51 80 00       	mov    0x805138,%eax
  803158:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80315b:	e9 15 04 00 00       	jmp    803575 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  803160:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803163:	8b 00                	mov    (%eax),%eax
  803165:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  803168:	8b 45 08             	mov    0x8(%ebp),%eax
  80316b:	8b 50 08             	mov    0x8(%eax),%edx
  80316e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803171:	8b 40 08             	mov    0x8(%eax),%eax
  803174:	39 c2                	cmp    %eax,%edx
  803176:	0f 86 f1 03 00 00    	jbe    80356d <insert_sorted_with_merge_freeList+0x710>
  80317c:	8b 45 08             	mov    0x8(%ebp),%eax
  80317f:	8b 50 08             	mov    0x8(%eax),%edx
  803182:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803185:	8b 40 08             	mov    0x8(%eax),%eax
  803188:	39 c2                	cmp    %eax,%edx
  80318a:	0f 83 dd 03 00 00    	jae    80356d <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  803190:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803193:	8b 50 08             	mov    0x8(%eax),%edx
  803196:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803199:	8b 40 0c             	mov    0xc(%eax),%eax
  80319c:	01 c2                	add    %eax,%edx
  80319e:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a1:	8b 40 08             	mov    0x8(%eax),%eax
  8031a4:	39 c2                	cmp    %eax,%edx
  8031a6:	0f 85 b9 01 00 00    	jne    803365 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8031ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8031af:	8b 50 08             	mov    0x8(%eax),%edx
  8031b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b5:	8b 40 0c             	mov    0xc(%eax),%eax
  8031b8:	01 c2                	add    %eax,%edx
  8031ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031bd:	8b 40 08             	mov    0x8(%eax),%eax
  8031c0:	39 c2                	cmp    %eax,%edx
  8031c2:	0f 85 0d 01 00 00    	jne    8032d5 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  8031c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031cb:	8b 50 0c             	mov    0xc(%eax),%edx
  8031ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031d1:	8b 40 0c             	mov    0xc(%eax),%eax
  8031d4:	01 c2                	add    %eax,%edx
  8031d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031d9:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8031dc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8031e0:	75 17                	jne    8031f9 <insert_sorted_with_merge_freeList+0x39c>
  8031e2:	83 ec 04             	sub    $0x4,%esp
  8031e5:	68 08 43 80 00       	push   $0x804308
  8031ea:	68 5c 01 00 00       	push   $0x15c
  8031ef:	68 5f 42 80 00       	push   $0x80425f
  8031f4:	e8 dd d2 ff ff       	call   8004d6 <_panic>
  8031f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031fc:	8b 00                	mov    (%eax),%eax
  8031fe:	85 c0                	test   %eax,%eax
  803200:	74 10                	je     803212 <insert_sorted_with_merge_freeList+0x3b5>
  803202:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803205:	8b 00                	mov    (%eax),%eax
  803207:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80320a:	8b 52 04             	mov    0x4(%edx),%edx
  80320d:	89 50 04             	mov    %edx,0x4(%eax)
  803210:	eb 0b                	jmp    80321d <insert_sorted_with_merge_freeList+0x3c0>
  803212:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803215:	8b 40 04             	mov    0x4(%eax),%eax
  803218:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80321d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803220:	8b 40 04             	mov    0x4(%eax),%eax
  803223:	85 c0                	test   %eax,%eax
  803225:	74 0f                	je     803236 <insert_sorted_with_merge_freeList+0x3d9>
  803227:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80322a:	8b 40 04             	mov    0x4(%eax),%eax
  80322d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803230:	8b 12                	mov    (%edx),%edx
  803232:	89 10                	mov    %edx,(%eax)
  803234:	eb 0a                	jmp    803240 <insert_sorted_with_merge_freeList+0x3e3>
  803236:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803239:	8b 00                	mov    (%eax),%eax
  80323b:	a3 38 51 80 00       	mov    %eax,0x805138
  803240:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803243:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803249:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80324c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803253:	a1 44 51 80 00       	mov    0x805144,%eax
  803258:	48                   	dec    %eax
  803259:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  80325e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803261:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803268:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80326b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803272:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803276:	75 17                	jne    80328f <insert_sorted_with_merge_freeList+0x432>
  803278:	83 ec 04             	sub    $0x4,%esp
  80327b:	68 3c 42 80 00       	push   $0x80423c
  803280:	68 5f 01 00 00       	push   $0x15f
  803285:	68 5f 42 80 00       	push   $0x80425f
  80328a:	e8 47 d2 ff ff       	call   8004d6 <_panic>
  80328f:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803295:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803298:	89 10                	mov    %edx,(%eax)
  80329a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80329d:	8b 00                	mov    (%eax),%eax
  80329f:	85 c0                	test   %eax,%eax
  8032a1:	74 0d                	je     8032b0 <insert_sorted_with_merge_freeList+0x453>
  8032a3:	a1 48 51 80 00       	mov    0x805148,%eax
  8032a8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032ab:	89 50 04             	mov    %edx,0x4(%eax)
  8032ae:	eb 08                	jmp    8032b8 <insert_sorted_with_merge_freeList+0x45b>
  8032b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032b3:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8032b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032bb:	a3 48 51 80 00       	mov    %eax,0x805148
  8032c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032c3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032ca:	a1 54 51 80 00       	mov    0x805154,%eax
  8032cf:	40                   	inc    %eax
  8032d0:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  8032d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032d8:	8b 50 0c             	mov    0xc(%eax),%edx
  8032db:	8b 45 08             	mov    0x8(%ebp),%eax
  8032de:	8b 40 0c             	mov    0xc(%eax),%eax
  8032e1:	01 c2                	add    %eax,%edx
  8032e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032e6:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  8032e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ec:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  8032f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8032fd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803301:	75 17                	jne    80331a <insert_sorted_with_merge_freeList+0x4bd>
  803303:	83 ec 04             	sub    $0x4,%esp
  803306:	68 3c 42 80 00       	push   $0x80423c
  80330b:	68 64 01 00 00       	push   $0x164
  803310:	68 5f 42 80 00       	push   $0x80425f
  803315:	e8 bc d1 ff ff       	call   8004d6 <_panic>
  80331a:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803320:	8b 45 08             	mov    0x8(%ebp),%eax
  803323:	89 10                	mov    %edx,(%eax)
  803325:	8b 45 08             	mov    0x8(%ebp),%eax
  803328:	8b 00                	mov    (%eax),%eax
  80332a:	85 c0                	test   %eax,%eax
  80332c:	74 0d                	je     80333b <insert_sorted_with_merge_freeList+0x4de>
  80332e:	a1 48 51 80 00       	mov    0x805148,%eax
  803333:	8b 55 08             	mov    0x8(%ebp),%edx
  803336:	89 50 04             	mov    %edx,0x4(%eax)
  803339:	eb 08                	jmp    803343 <insert_sorted_with_merge_freeList+0x4e6>
  80333b:	8b 45 08             	mov    0x8(%ebp),%eax
  80333e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803343:	8b 45 08             	mov    0x8(%ebp),%eax
  803346:	a3 48 51 80 00       	mov    %eax,0x805148
  80334b:	8b 45 08             	mov    0x8(%ebp),%eax
  80334e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803355:	a1 54 51 80 00       	mov    0x805154,%eax
  80335a:	40                   	inc    %eax
  80335b:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803360:	e9 41 02 00 00       	jmp    8035a6 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803365:	8b 45 08             	mov    0x8(%ebp),%eax
  803368:	8b 50 08             	mov    0x8(%eax),%edx
  80336b:	8b 45 08             	mov    0x8(%ebp),%eax
  80336e:	8b 40 0c             	mov    0xc(%eax),%eax
  803371:	01 c2                	add    %eax,%edx
  803373:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803376:	8b 40 08             	mov    0x8(%eax),%eax
  803379:	39 c2                	cmp    %eax,%edx
  80337b:	0f 85 7c 01 00 00    	jne    8034fd <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803381:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803385:	74 06                	je     80338d <insert_sorted_with_merge_freeList+0x530>
  803387:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80338b:	75 17                	jne    8033a4 <insert_sorted_with_merge_freeList+0x547>
  80338d:	83 ec 04             	sub    $0x4,%esp
  803390:	68 78 42 80 00       	push   $0x804278
  803395:	68 69 01 00 00       	push   $0x169
  80339a:	68 5f 42 80 00       	push   $0x80425f
  80339f:	e8 32 d1 ff ff       	call   8004d6 <_panic>
  8033a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033a7:	8b 50 04             	mov    0x4(%eax),%edx
  8033aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ad:	89 50 04             	mov    %edx,0x4(%eax)
  8033b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8033b6:	89 10                	mov    %edx,(%eax)
  8033b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033bb:	8b 40 04             	mov    0x4(%eax),%eax
  8033be:	85 c0                	test   %eax,%eax
  8033c0:	74 0d                	je     8033cf <insert_sorted_with_merge_freeList+0x572>
  8033c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033c5:	8b 40 04             	mov    0x4(%eax),%eax
  8033c8:	8b 55 08             	mov    0x8(%ebp),%edx
  8033cb:	89 10                	mov    %edx,(%eax)
  8033cd:	eb 08                	jmp    8033d7 <insert_sorted_with_merge_freeList+0x57a>
  8033cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d2:	a3 38 51 80 00       	mov    %eax,0x805138
  8033d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033da:	8b 55 08             	mov    0x8(%ebp),%edx
  8033dd:	89 50 04             	mov    %edx,0x4(%eax)
  8033e0:	a1 44 51 80 00       	mov    0x805144,%eax
  8033e5:	40                   	inc    %eax
  8033e6:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  8033eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ee:	8b 50 0c             	mov    0xc(%eax),%edx
  8033f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033f4:	8b 40 0c             	mov    0xc(%eax),%eax
  8033f7:	01 c2                	add    %eax,%edx
  8033f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8033fc:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8033ff:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803403:	75 17                	jne    80341c <insert_sorted_with_merge_freeList+0x5bf>
  803405:	83 ec 04             	sub    $0x4,%esp
  803408:	68 08 43 80 00       	push   $0x804308
  80340d:	68 6b 01 00 00       	push   $0x16b
  803412:	68 5f 42 80 00       	push   $0x80425f
  803417:	e8 ba d0 ff ff       	call   8004d6 <_panic>
  80341c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80341f:	8b 00                	mov    (%eax),%eax
  803421:	85 c0                	test   %eax,%eax
  803423:	74 10                	je     803435 <insert_sorted_with_merge_freeList+0x5d8>
  803425:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803428:	8b 00                	mov    (%eax),%eax
  80342a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80342d:	8b 52 04             	mov    0x4(%edx),%edx
  803430:	89 50 04             	mov    %edx,0x4(%eax)
  803433:	eb 0b                	jmp    803440 <insert_sorted_with_merge_freeList+0x5e3>
  803435:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803438:	8b 40 04             	mov    0x4(%eax),%eax
  80343b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803440:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803443:	8b 40 04             	mov    0x4(%eax),%eax
  803446:	85 c0                	test   %eax,%eax
  803448:	74 0f                	je     803459 <insert_sorted_with_merge_freeList+0x5fc>
  80344a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80344d:	8b 40 04             	mov    0x4(%eax),%eax
  803450:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803453:	8b 12                	mov    (%edx),%edx
  803455:	89 10                	mov    %edx,(%eax)
  803457:	eb 0a                	jmp    803463 <insert_sorted_with_merge_freeList+0x606>
  803459:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80345c:	8b 00                	mov    (%eax),%eax
  80345e:	a3 38 51 80 00       	mov    %eax,0x805138
  803463:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803466:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80346c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80346f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803476:	a1 44 51 80 00       	mov    0x805144,%eax
  80347b:	48                   	dec    %eax
  80347c:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803481:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803484:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  80348b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80348e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803495:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803499:	75 17                	jne    8034b2 <insert_sorted_with_merge_freeList+0x655>
  80349b:	83 ec 04             	sub    $0x4,%esp
  80349e:	68 3c 42 80 00       	push   $0x80423c
  8034a3:	68 6e 01 00 00       	push   $0x16e
  8034a8:	68 5f 42 80 00       	push   $0x80425f
  8034ad:	e8 24 d0 ff ff       	call   8004d6 <_panic>
  8034b2:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8034b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034bb:	89 10                	mov    %edx,(%eax)
  8034bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034c0:	8b 00                	mov    (%eax),%eax
  8034c2:	85 c0                	test   %eax,%eax
  8034c4:	74 0d                	je     8034d3 <insert_sorted_with_merge_freeList+0x676>
  8034c6:	a1 48 51 80 00       	mov    0x805148,%eax
  8034cb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8034ce:	89 50 04             	mov    %edx,0x4(%eax)
  8034d1:	eb 08                	jmp    8034db <insert_sorted_with_merge_freeList+0x67e>
  8034d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034d6:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8034db:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034de:	a3 48 51 80 00       	mov    %eax,0x805148
  8034e3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034e6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034ed:	a1 54 51 80 00       	mov    0x805154,%eax
  8034f2:	40                   	inc    %eax
  8034f3:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8034f8:	e9 a9 00 00 00       	jmp    8035a6 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  8034fd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803501:	74 06                	je     803509 <insert_sorted_with_merge_freeList+0x6ac>
  803503:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803507:	75 17                	jne    803520 <insert_sorted_with_merge_freeList+0x6c3>
  803509:	83 ec 04             	sub    $0x4,%esp
  80350c:	68 d4 42 80 00       	push   $0x8042d4
  803511:	68 73 01 00 00       	push   $0x173
  803516:	68 5f 42 80 00       	push   $0x80425f
  80351b:	e8 b6 cf ff ff       	call   8004d6 <_panic>
  803520:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803523:	8b 10                	mov    (%eax),%edx
  803525:	8b 45 08             	mov    0x8(%ebp),%eax
  803528:	89 10                	mov    %edx,(%eax)
  80352a:	8b 45 08             	mov    0x8(%ebp),%eax
  80352d:	8b 00                	mov    (%eax),%eax
  80352f:	85 c0                	test   %eax,%eax
  803531:	74 0b                	je     80353e <insert_sorted_with_merge_freeList+0x6e1>
  803533:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803536:	8b 00                	mov    (%eax),%eax
  803538:	8b 55 08             	mov    0x8(%ebp),%edx
  80353b:	89 50 04             	mov    %edx,0x4(%eax)
  80353e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803541:	8b 55 08             	mov    0x8(%ebp),%edx
  803544:	89 10                	mov    %edx,(%eax)
  803546:	8b 45 08             	mov    0x8(%ebp),%eax
  803549:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80354c:	89 50 04             	mov    %edx,0x4(%eax)
  80354f:	8b 45 08             	mov    0x8(%ebp),%eax
  803552:	8b 00                	mov    (%eax),%eax
  803554:	85 c0                	test   %eax,%eax
  803556:	75 08                	jne    803560 <insert_sorted_with_merge_freeList+0x703>
  803558:	8b 45 08             	mov    0x8(%ebp),%eax
  80355b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803560:	a1 44 51 80 00       	mov    0x805144,%eax
  803565:	40                   	inc    %eax
  803566:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  80356b:	eb 39                	jmp    8035a6 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  80356d:	a1 40 51 80 00       	mov    0x805140,%eax
  803572:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803575:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803579:	74 07                	je     803582 <insert_sorted_with_merge_freeList+0x725>
  80357b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80357e:	8b 00                	mov    (%eax),%eax
  803580:	eb 05                	jmp    803587 <insert_sorted_with_merge_freeList+0x72a>
  803582:	b8 00 00 00 00       	mov    $0x0,%eax
  803587:	a3 40 51 80 00       	mov    %eax,0x805140
  80358c:	a1 40 51 80 00       	mov    0x805140,%eax
  803591:	85 c0                	test   %eax,%eax
  803593:	0f 85 c7 fb ff ff    	jne    803160 <insert_sorted_with_merge_freeList+0x303>
  803599:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80359d:	0f 85 bd fb ff ff    	jne    803160 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8035a3:	eb 01                	jmp    8035a6 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8035a5:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8035a6:	90                   	nop
  8035a7:	c9                   	leave  
  8035a8:	c3                   	ret    
  8035a9:	66 90                	xchg   %ax,%ax
  8035ab:	90                   	nop

008035ac <__udivdi3>:
  8035ac:	55                   	push   %ebp
  8035ad:	57                   	push   %edi
  8035ae:	56                   	push   %esi
  8035af:	53                   	push   %ebx
  8035b0:	83 ec 1c             	sub    $0x1c,%esp
  8035b3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8035b7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8035bb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8035bf:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8035c3:	89 ca                	mov    %ecx,%edx
  8035c5:	89 f8                	mov    %edi,%eax
  8035c7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8035cb:	85 f6                	test   %esi,%esi
  8035cd:	75 2d                	jne    8035fc <__udivdi3+0x50>
  8035cf:	39 cf                	cmp    %ecx,%edi
  8035d1:	77 65                	ja     803638 <__udivdi3+0x8c>
  8035d3:	89 fd                	mov    %edi,%ebp
  8035d5:	85 ff                	test   %edi,%edi
  8035d7:	75 0b                	jne    8035e4 <__udivdi3+0x38>
  8035d9:	b8 01 00 00 00       	mov    $0x1,%eax
  8035de:	31 d2                	xor    %edx,%edx
  8035e0:	f7 f7                	div    %edi
  8035e2:	89 c5                	mov    %eax,%ebp
  8035e4:	31 d2                	xor    %edx,%edx
  8035e6:	89 c8                	mov    %ecx,%eax
  8035e8:	f7 f5                	div    %ebp
  8035ea:	89 c1                	mov    %eax,%ecx
  8035ec:	89 d8                	mov    %ebx,%eax
  8035ee:	f7 f5                	div    %ebp
  8035f0:	89 cf                	mov    %ecx,%edi
  8035f2:	89 fa                	mov    %edi,%edx
  8035f4:	83 c4 1c             	add    $0x1c,%esp
  8035f7:	5b                   	pop    %ebx
  8035f8:	5e                   	pop    %esi
  8035f9:	5f                   	pop    %edi
  8035fa:	5d                   	pop    %ebp
  8035fb:	c3                   	ret    
  8035fc:	39 ce                	cmp    %ecx,%esi
  8035fe:	77 28                	ja     803628 <__udivdi3+0x7c>
  803600:	0f bd fe             	bsr    %esi,%edi
  803603:	83 f7 1f             	xor    $0x1f,%edi
  803606:	75 40                	jne    803648 <__udivdi3+0x9c>
  803608:	39 ce                	cmp    %ecx,%esi
  80360a:	72 0a                	jb     803616 <__udivdi3+0x6a>
  80360c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803610:	0f 87 9e 00 00 00    	ja     8036b4 <__udivdi3+0x108>
  803616:	b8 01 00 00 00       	mov    $0x1,%eax
  80361b:	89 fa                	mov    %edi,%edx
  80361d:	83 c4 1c             	add    $0x1c,%esp
  803620:	5b                   	pop    %ebx
  803621:	5e                   	pop    %esi
  803622:	5f                   	pop    %edi
  803623:	5d                   	pop    %ebp
  803624:	c3                   	ret    
  803625:	8d 76 00             	lea    0x0(%esi),%esi
  803628:	31 ff                	xor    %edi,%edi
  80362a:	31 c0                	xor    %eax,%eax
  80362c:	89 fa                	mov    %edi,%edx
  80362e:	83 c4 1c             	add    $0x1c,%esp
  803631:	5b                   	pop    %ebx
  803632:	5e                   	pop    %esi
  803633:	5f                   	pop    %edi
  803634:	5d                   	pop    %ebp
  803635:	c3                   	ret    
  803636:	66 90                	xchg   %ax,%ax
  803638:	89 d8                	mov    %ebx,%eax
  80363a:	f7 f7                	div    %edi
  80363c:	31 ff                	xor    %edi,%edi
  80363e:	89 fa                	mov    %edi,%edx
  803640:	83 c4 1c             	add    $0x1c,%esp
  803643:	5b                   	pop    %ebx
  803644:	5e                   	pop    %esi
  803645:	5f                   	pop    %edi
  803646:	5d                   	pop    %ebp
  803647:	c3                   	ret    
  803648:	bd 20 00 00 00       	mov    $0x20,%ebp
  80364d:	89 eb                	mov    %ebp,%ebx
  80364f:	29 fb                	sub    %edi,%ebx
  803651:	89 f9                	mov    %edi,%ecx
  803653:	d3 e6                	shl    %cl,%esi
  803655:	89 c5                	mov    %eax,%ebp
  803657:	88 d9                	mov    %bl,%cl
  803659:	d3 ed                	shr    %cl,%ebp
  80365b:	89 e9                	mov    %ebp,%ecx
  80365d:	09 f1                	or     %esi,%ecx
  80365f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803663:	89 f9                	mov    %edi,%ecx
  803665:	d3 e0                	shl    %cl,%eax
  803667:	89 c5                	mov    %eax,%ebp
  803669:	89 d6                	mov    %edx,%esi
  80366b:	88 d9                	mov    %bl,%cl
  80366d:	d3 ee                	shr    %cl,%esi
  80366f:	89 f9                	mov    %edi,%ecx
  803671:	d3 e2                	shl    %cl,%edx
  803673:	8b 44 24 08          	mov    0x8(%esp),%eax
  803677:	88 d9                	mov    %bl,%cl
  803679:	d3 e8                	shr    %cl,%eax
  80367b:	09 c2                	or     %eax,%edx
  80367d:	89 d0                	mov    %edx,%eax
  80367f:	89 f2                	mov    %esi,%edx
  803681:	f7 74 24 0c          	divl   0xc(%esp)
  803685:	89 d6                	mov    %edx,%esi
  803687:	89 c3                	mov    %eax,%ebx
  803689:	f7 e5                	mul    %ebp
  80368b:	39 d6                	cmp    %edx,%esi
  80368d:	72 19                	jb     8036a8 <__udivdi3+0xfc>
  80368f:	74 0b                	je     80369c <__udivdi3+0xf0>
  803691:	89 d8                	mov    %ebx,%eax
  803693:	31 ff                	xor    %edi,%edi
  803695:	e9 58 ff ff ff       	jmp    8035f2 <__udivdi3+0x46>
  80369a:	66 90                	xchg   %ax,%ax
  80369c:	8b 54 24 08          	mov    0x8(%esp),%edx
  8036a0:	89 f9                	mov    %edi,%ecx
  8036a2:	d3 e2                	shl    %cl,%edx
  8036a4:	39 c2                	cmp    %eax,%edx
  8036a6:	73 e9                	jae    803691 <__udivdi3+0xe5>
  8036a8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8036ab:	31 ff                	xor    %edi,%edi
  8036ad:	e9 40 ff ff ff       	jmp    8035f2 <__udivdi3+0x46>
  8036b2:	66 90                	xchg   %ax,%ax
  8036b4:	31 c0                	xor    %eax,%eax
  8036b6:	e9 37 ff ff ff       	jmp    8035f2 <__udivdi3+0x46>
  8036bb:	90                   	nop

008036bc <__umoddi3>:
  8036bc:	55                   	push   %ebp
  8036bd:	57                   	push   %edi
  8036be:	56                   	push   %esi
  8036bf:	53                   	push   %ebx
  8036c0:	83 ec 1c             	sub    $0x1c,%esp
  8036c3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8036c7:	8b 74 24 34          	mov    0x34(%esp),%esi
  8036cb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8036cf:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8036d3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8036d7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8036db:	89 f3                	mov    %esi,%ebx
  8036dd:	89 fa                	mov    %edi,%edx
  8036df:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8036e3:	89 34 24             	mov    %esi,(%esp)
  8036e6:	85 c0                	test   %eax,%eax
  8036e8:	75 1a                	jne    803704 <__umoddi3+0x48>
  8036ea:	39 f7                	cmp    %esi,%edi
  8036ec:	0f 86 a2 00 00 00    	jbe    803794 <__umoddi3+0xd8>
  8036f2:	89 c8                	mov    %ecx,%eax
  8036f4:	89 f2                	mov    %esi,%edx
  8036f6:	f7 f7                	div    %edi
  8036f8:	89 d0                	mov    %edx,%eax
  8036fa:	31 d2                	xor    %edx,%edx
  8036fc:	83 c4 1c             	add    $0x1c,%esp
  8036ff:	5b                   	pop    %ebx
  803700:	5e                   	pop    %esi
  803701:	5f                   	pop    %edi
  803702:	5d                   	pop    %ebp
  803703:	c3                   	ret    
  803704:	39 f0                	cmp    %esi,%eax
  803706:	0f 87 ac 00 00 00    	ja     8037b8 <__umoddi3+0xfc>
  80370c:	0f bd e8             	bsr    %eax,%ebp
  80370f:	83 f5 1f             	xor    $0x1f,%ebp
  803712:	0f 84 ac 00 00 00    	je     8037c4 <__umoddi3+0x108>
  803718:	bf 20 00 00 00       	mov    $0x20,%edi
  80371d:	29 ef                	sub    %ebp,%edi
  80371f:	89 fe                	mov    %edi,%esi
  803721:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803725:	89 e9                	mov    %ebp,%ecx
  803727:	d3 e0                	shl    %cl,%eax
  803729:	89 d7                	mov    %edx,%edi
  80372b:	89 f1                	mov    %esi,%ecx
  80372d:	d3 ef                	shr    %cl,%edi
  80372f:	09 c7                	or     %eax,%edi
  803731:	89 e9                	mov    %ebp,%ecx
  803733:	d3 e2                	shl    %cl,%edx
  803735:	89 14 24             	mov    %edx,(%esp)
  803738:	89 d8                	mov    %ebx,%eax
  80373a:	d3 e0                	shl    %cl,%eax
  80373c:	89 c2                	mov    %eax,%edx
  80373e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803742:	d3 e0                	shl    %cl,%eax
  803744:	89 44 24 04          	mov    %eax,0x4(%esp)
  803748:	8b 44 24 08          	mov    0x8(%esp),%eax
  80374c:	89 f1                	mov    %esi,%ecx
  80374e:	d3 e8                	shr    %cl,%eax
  803750:	09 d0                	or     %edx,%eax
  803752:	d3 eb                	shr    %cl,%ebx
  803754:	89 da                	mov    %ebx,%edx
  803756:	f7 f7                	div    %edi
  803758:	89 d3                	mov    %edx,%ebx
  80375a:	f7 24 24             	mull   (%esp)
  80375d:	89 c6                	mov    %eax,%esi
  80375f:	89 d1                	mov    %edx,%ecx
  803761:	39 d3                	cmp    %edx,%ebx
  803763:	0f 82 87 00 00 00    	jb     8037f0 <__umoddi3+0x134>
  803769:	0f 84 91 00 00 00    	je     803800 <__umoddi3+0x144>
  80376f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803773:	29 f2                	sub    %esi,%edx
  803775:	19 cb                	sbb    %ecx,%ebx
  803777:	89 d8                	mov    %ebx,%eax
  803779:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80377d:	d3 e0                	shl    %cl,%eax
  80377f:	89 e9                	mov    %ebp,%ecx
  803781:	d3 ea                	shr    %cl,%edx
  803783:	09 d0                	or     %edx,%eax
  803785:	89 e9                	mov    %ebp,%ecx
  803787:	d3 eb                	shr    %cl,%ebx
  803789:	89 da                	mov    %ebx,%edx
  80378b:	83 c4 1c             	add    $0x1c,%esp
  80378e:	5b                   	pop    %ebx
  80378f:	5e                   	pop    %esi
  803790:	5f                   	pop    %edi
  803791:	5d                   	pop    %ebp
  803792:	c3                   	ret    
  803793:	90                   	nop
  803794:	89 fd                	mov    %edi,%ebp
  803796:	85 ff                	test   %edi,%edi
  803798:	75 0b                	jne    8037a5 <__umoddi3+0xe9>
  80379a:	b8 01 00 00 00       	mov    $0x1,%eax
  80379f:	31 d2                	xor    %edx,%edx
  8037a1:	f7 f7                	div    %edi
  8037a3:	89 c5                	mov    %eax,%ebp
  8037a5:	89 f0                	mov    %esi,%eax
  8037a7:	31 d2                	xor    %edx,%edx
  8037a9:	f7 f5                	div    %ebp
  8037ab:	89 c8                	mov    %ecx,%eax
  8037ad:	f7 f5                	div    %ebp
  8037af:	89 d0                	mov    %edx,%eax
  8037b1:	e9 44 ff ff ff       	jmp    8036fa <__umoddi3+0x3e>
  8037b6:	66 90                	xchg   %ax,%ax
  8037b8:	89 c8                	mov    %ecx,%eax
  8037ba:	89 f2                	mov    %esi,%edx
  8037bc:	83 c4 1c             	add    $0x1c,%esp
  8037bf:	5b                   	pop    %ebx
  8037c0:	5e                   	pop    %esi
  8037c1:	5f                   	pop    %edi
  8037c2:	5d                   	pop    %ebp
  8037c3:	c3                   	ret    
  8037c4:	3b 04 24             	cmp    (%esp),%eax
  8037c7:	72 06                	jb     8037cf <__umoddi3+0x113>
  8037c9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8037cd:	77 0f                	ja     8037de <__umoddi3+0x122>
  8037cf:	89 f2                	mov    %esi,%edx
  8037d1:	29 f9                	sub    %edi,%ecx
  8037d3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8037d7:	89 14 24             	mov    %edx,(%esp)
  8037da:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8037de:	8b 44 24 04          	mov    0x4(%esp),%eax
  8037e2:	8b 14 24             	mov    (%esp),%edx
  8037e5:	83 c4 1c             	add    $0x1c,%esp
  8037e8:	5b                   	pop    %ebx
  8037e9:	5e                   	pop    %esi
  8037ea:	5f                   	pop    %edi
  8037eb:	5d                   	pop    %ebp
  8037ec:	c3                   	ret    
  8037ed:	8d 76 00             	lea    0x0(%esi),%esi
  8037f0:	2b 04 24             	sub    (%esp),%eax
  8037f3:	19 fa                	sbb    %edi,%edx
  8037f5:	89 d1                	mov    %edx,%ecx
  8037f7:	89 c6                	mov    %eax,%esi
  8037f9:	e9 71 ff ff ff       	jmp    80376f <__umoddi3+0xb3>
  8037fe:	66 90                	xchg   %ax,%ax
  803800:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803804:	72 ea                	jb     8037f0 <__umoddi3+0x134>
  803806:	89 d9                	mov    %ebx,%ecx
  803808:	e9 62 ff ff ff       	jmp    80376f <__umoddi3+0xb3>
