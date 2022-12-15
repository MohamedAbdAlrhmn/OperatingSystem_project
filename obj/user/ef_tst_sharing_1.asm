
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
  80008d:	68 a0 38 80 00       	push   $0x8038a0
  800092:	6a 12                	push   $0x12
  800094:	68 bc 38 80 00       	push   $0x8038bc
  800099:	e8 38 04 00 00       	call   8004d6 <_panic>
	}

	uint32 *x, *y, *z ;
	cprintf("STEP A: checking the creation of shared variables... \n");
  80009e:	83 ec 0c             	sub    $0xc,%esp
  8000a1:	68 d4 38 80 00       	push   $0x8038d4
  8000a6:	e8 df 06 00 00       	call   80078a <cprintf>
  8000ab:	83 c4 10             	add    $0x10,%esp
	{
		int freeFrames = sys_calculate_free_frames() ;
  8000ae:	e8 c6 19 00 00       	call   801a79 <sys_calculate_free_frames>
  8000b3:	89 45 e8             	mov    %eax,-0x18(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8000b6:	83 ec 04             	sub    $0x4,%esp
  8000b9:	6a 01                	push   $0x1
  8000bb:	68 00 10 00 00       	push   $0x1000
  8000c0:	68 0b 39 80 00       	push   $0x80390b
  8000c5:	e8 dd 16 00 00       	call   8017a7 <smalloc>
  8000ca:	83 c4 10             	add    $0x10,%esp
  8000cd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (x != (uint32*)USER_HEAP_START) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  8000d0:	81 7d e4 00 00 00 80 	cmpl   $0x80000000,-0x1c(%ebp)
  8000d7:	74 14                	je     8000ed <_main+0xb5>
  8000d9:	83 ec 04             	sub    $0x4,%esp
  8000dc:	68 10 39 80 00       	push   $0x803910
  8000e1:	6a 1a                	push   $0x1a
  8000e3:	68 bc 38 80 00       	push   $0x8038bc
  8000e8:	e8 e9 03 00 00       	call   8004d6 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage %d %d %d", freeFrames, sys_calculate_free_frames(), freeFrames - sys_calculate_free_frames());
  8000ed:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8000f0:	e8 84 19 00 00       	call   801a79 <sys_calculate_free_frames>
  8000f5:	29 c3                	sub    %eax,%ebx
  8000f7:	89 d8                	mov    %ebx,%eax
  8000f9:	83 f8 04             	cmp    $0x4,%eax
  8000fc:	74 28                	je     800126 <_main+0xee>
  8000fe:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800101:	e8 73 19 00 00       	call   801a79 <sys_calculate_free_frames>
  800106:	29 c3                	sub    %eax,%ebx
  800108:	e8 6c 19 00 00       	call   801a79 <sys_calculate_free_frames>
  80010d:	83 ec 08             	sub    $0x8,%esp
  800110:	53                   	push   %ebx
  800111:	50                   	push   %eax
  800112:	ff 75 e8             	pushl  -0x18(%ebp)
  800115:	68 7c 39 80 00       	push   $0x80397c
  80011a:	6a 1b                	push   $0x1b
  80011c:	68 bc 38 80 00       	push   $0x8038bc
  800121:	e8 b0 03 00 00       	call   8004d6 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800126:	e8 4e 19 00 00       	call   801a79 <sys_calculate_free_frames>
  80012b:	89 45 e8             	mov    %eax,-0x18(%ebp)
		z = smalloc("y", PAGE_SIZE + 4, 1);
  80012e:	83 ec 04             	sub    $0x4,%esp
  800131:	6a 01                	push   $0x1
  800133:	68 04 10 00 00       	push   $0x1004
  800138:	68 03 3a 80 00       	push   $0x803a03
  80013d:	e8 65 16 00 00       	call   8017a7 <smalloc>
  800142:	83 c4 10             	add    $0x10,%esp
  800145:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (z != (uint32*)(USER_HEAP_START + 1 * PAGE_SIZE)) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  800148:	81 7d e0 00 10 00 80 	cmpl   $0x80001000,-0x20(%ebp)
  80014f:	74 14                	je     800165 <_main+0x12d>
  800151:	83 ec 04             	sub    $0x4,%esp
  800154:	68 10 39 80 00       	push   $0x803910
  800159:	6a 1f                	push   $0x1f
  80015b:	68 bc 38 80 00       	push   $0x8038bc
  800160:	e8 71 03 00 00       	call   8004d6 <_panic>

		if ((freeFrames - sys_calculate_free_frames()) !=  2+0+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage %d %d %d", freeFrames, sys_calculate_free_frames(), freeFrames - sys_calculate_free_frames());
  800165:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800168:	e8 0c 19 00 00       	call   801a79 <sys_calculate_free_frames>
  80016d:	29 c3                	sub    %eax,%ebx
  80016f:	89 d8                	mov    %ebx,%eax
  800171:	83 f8 04             	cmp    $0x4,%eax
  800174:	74 28                	je     80019e <_main+0x166>
  800176:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800179:	e8 fb 18 00 00       	call   801a79 <sys_calculate_free_frames>
  80017e:	29 c3                	sub    %eax,%ebx
  800180:	e8 f4 18 00 00       	call   801a79 <sys_calculate_free_frames>
  800185:	83 ec 08             	sub    $0x8,%esp
  800188:	53                   	push   %ebx
  800189:	50                   	push   %eax
  80018a:	ff 75 e8             	pushl  -0x18(%ebp)
  80018d:	68 7c 39 80 00       	push   $0x80397c
  800192:	6a 21                	push   $0x21
  800194:	68 bc 38 80 00       	push   $0x8038bc
  800199:	e8 38 03 00 00       	call   8004d6 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  80019e:	e8 d6 18 00 00       	call   801a79 <sys_calculate_free_frames>
  8001a3:	89 45 e8             	mov    %eax,-0x18(%ebp)
		y = smalloc("z", 4, 1);
  8001a6:	83 ec 04             	sub    $0x4,%esp
  8001a9:	6a 01                	push   $0x1
  8001ab:	6a 04                	push   $0x4
  8001ad:	68 05 3a 80 00       	push   $0x803a05
  8001b2:	e8 f0 15 00 00       	call   8017a7 <smalloc>
  8001b7:	83 c4 10             	add    $0x10,%esp
  8001ba:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (y != (uint32*)(USER_HEAP_START + 3 * PAGE_SIZE)) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  8001bd:	81 7d dc 00 30 00 80 	cmpl   $0x80003000,-0x24(%ebp)
  8001c4:	74 14                	je     8001da <_main+0x1a2>
  8001c6:	83 ec 04             	sub    $0x4,%esp
  8001c9:	68 10 39 80 00       	push   $0x803910
  8001ce:	6a 25                	push   $0x25
  8001d0:	68 bc 38 80 00       	push   $0x8038bc
  8001d5:	e8 fc 02 00 00       	call   8004d6 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  1+0+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  8001da:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8001dd:	e8 97 18 00 00       	call   801a79 <sys_calculate_free_frames>
  8001e2:	29 c3                	sub    %eax,%ebx
  8001e4:	89 d8                	mov    %ebx,%eax
  8001e6:	83 f8 03             	cmp    $0x3,%eax
  8001e9:	74 14                	je     8001ff <_main+0x1c7>
  8001eb:	83 ec 04             	sub    $0x4,%esp
  8001ee:	68 08 3a 80 00       	push   $0x803a08
  8001f3:	6a 26                	push   $0x26
  8001f5:	68 bc 38 80 00       	push   $0x8038bc
  8001fa:	e8 d7 02 00 00       	call   8004d6 <_panic>
	}
	cprintf("Step A is completed successfully!!\n\n\n");
  8001ff:	83 ec 0c             	sub    $0xc,%esp
  800202:	68 88 3a 80 00       	push   $0x803a88
  800207:	e8 7e 05 00 00       	call   80078a <cprintf>
  80020c:	83 c4 10             	add    $0x10,%esp


	cprintf("STEP B: checking reading & writing... \n");
  80020f:	83 ec 0c             	sub    $0xc,%esp
  800212:	68 b0 3a 80 00       	push   $0x803ab0
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
  800295:	68 d8 3a 80 00       	push   $0x803ad8
  80029a:	6a 3a                	push   $0x3a
  80029c:	68 bc 38 80 00       	push   $0x8038bc
  8002a1:	e8 30 02 00 00       	call   8004d6 <_panic>
		if( x[PAGE_SIZE/4 - 1] !=  -1)  	panic("Reading/Writing of shared object is failed");
  8002a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002a9:	05 fc 0f 00 00       	add    $0xffc,%eax
  8002ae:	8b 00                	mov    (%eax),%eax
  8002b0:	83 f8 ff             	cmp    $0xffffffff,%eax
  8002b3:	74 14                	je     8002c9 <_main+0x291>
  8002b5:	83 ec 04             	sub    $0x4,%esp
  8002b8:	68 d8 3a 80 00       	push   $0x803ad8
  8002bd:	6a 3b                	push   $0x3b
  8002bf:	68 bc 38 80 00       	push   $0x8038bc
  8002c4:	e8 0d 02 00 00       	call   8004d6 <_panic>

		if( y[0] !=  -1)  					panic("Reading/Writing of shared object is failed");
  8002c9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002cc:	8b 00                	mov    (%eax),%eax
  8002ce:	83 f8 ff             	cmp    $0xffffffff,%eax
  8002d1:	74 14                	je     8002e7 <_main+0x2af>
  8002d3:	83 ec 04             	sub    $0x4,%esp
  8002d6:	68 d8 3a 80 00       	push   $0x803ad8
  8002db:	6a 3d                	push   $0x3d
  8002dd:	68 bc 38 80 00       	push   $0x8038bc
  8002e2:	e8 ef 01 00 00       	call   8004d6 <_panic>
		if( y[PAGE_SIZE/4 - 1] !=  -1)  	panic("Reading/Writing of shared object is failed");
  8002e7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002ea:	05 fc 0f 00 00       	add    $0xffc,%eax
  8002ef:	8b 00                	mov    (%eax),%eax
  8002f1:	83 f8 ff             	cmp    $0xffffffff,%eax
  8002f4:	74 14                	je     80030a <_main+0x2d2>
  8002f6:	83 ec 04             	sub    $0x4,%esp
  8002f9:	68 d8 3a 80 00       	push   $0x803ad8
  8002fe:	6a 3e                	push   $0x3e
  800300:	68 bc 38 80 00       	push   $0x8038bc
  800305:	e8 cc 01 00 00       	call   8004d6 <_panic>

		if( z[0] !=  -1)  					panic("Reading/Writing of shared object is failed");
  80030a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80030d:	8b 00                	mov    (%eax),%eax
  80030f:	83 f8 ff             	cmp    $0xffffffff,%eax
  800312:	74 14                	je     800328 <_main+0x2f0>
  800314:	83 ec 04             	sub    $0x4,%esp
  800317:	68 d8 3a 80 00       	push   $0x803ad8
  80031c:	6a 40                	push   $0x40
  80031e:	68 bc 38 80 00       	push   $0x8038bc
  800323:	e8 ae 01 00 00       	call   8004d6 <_panic>
		if( z[2*PAGE_SIZE/4 - 1] !=  -1)  	panic("Reading/Writing of shared object is failed");
  800328:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80032b:	05 fc 1f 00 00       	add    $0x1ffc,%eax
  800330:	8b 00                	mov    (%eax),%eax
  800332:	83 f8 ff             	cmp    $0xffffffff,%eax
  800335:	74 14                	je     80034b <_main+0x313>
  800337:	83 ec 04             	sub    $0x4,%esp
  80033a:	68 d8 3a 80 00       	push   $0x803ad8
  80033f:	6a 41                	push   $0x41
  800341:	68 bc 38 80 00       	push   $0x8038bc
  800346:	e8 8b 01 00 00       	call   8004d6 <_panic>
	}

	cprintf("Congratulations!! Test of Shared Variables [Create] [1] completed successfully!!\n\n\n");
  80034b:	83 ec 0c             	sub    $0xc,%esp
  80034e:	68 04 3b 80 00       	push   $0x803b04
  800353:	e8 32 04 00 00       	call   80078a <cprintf>
  800358:	83 c4 10             	add    $0x10,%esp

	int32 parentenvID = sys_getparentenvid();
  80035b:	e8 12 1a 00 00       	call   801d72 <sys_getparentenvid>
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
  800373:	68 58 3b 80 00       	push   $0x803b58
  800378:	ff 75 d8             	pushl  -0x28(%ebp)
  80037b:	e8 d5 14 00 00       	call   801855 <sget>
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
  8003a0:	e8 b4 19 00 00       	call   801d59 <sys_getenvindex>
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
  80040b:	e8 56 17 00 00       	call   801b66 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800410:	83 ec 0c             	sub    $0xc,%esp
  800413:	68 80 3b 80 00       	push   $0x803b80
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
  80043b:	68 a8 3b 80 00       	push   $0x803ba8
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
  80046c:	68 d0 3b 80 00       	push   $0x803bd0
  800471:	e8 14 03 00 00       	call   80078a <cprintf>
  800476:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800479:	a1 20 50 80 00       	mov    0x805020,%eax
  80047e:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800484:	83 ec 08             	sub    $0x8,%esp
  800487:	50                   	push   %eax
  800488:	68 28 3c 80 00       	push   $0x803c28
  80048d:	e8 f8 02 00 00       	call   80078a <cprintf>
  800492:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800495:	83 ec 0c             	sub    $0xc,%esp
  800498:	68 80 3b 80 00       	push   $0x803b80
  80049d:	e8 e8 02 00 00       	call   80078a <cprintf>
  8004a2:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8004a5:	e8 d6 16 00 00       	call   801b80 <sys_enable_interrupt>

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
  8004bd:	e8 63 18 00 00       	call   801d25 <sys_destroy_env>
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
  8004ce:	e8 b8 18 00 00       	call   801d8b <sys_exit_env>
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
  8004f7:	68 3c 3c 80 00       	push   $0x803c3c
  8004fc:	e8 89 02 00 00       	call   80078a <cprintf>
  800501:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800504:	a1 00 50 80 00       	mov    0x805000,%eax
  800509:	ff 75 0c             	pushl  0xc(%ebp)
  80050c:	ff 75 08             	pushl  0x8(%ebp)
  80050f:	50                   	push   %eax
  800510:	68 41 3c 80 00       	push   $0x803c41
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
  800534:	68 5d 3c 80 00       	push   $0x803c5d
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
  800560:	68 60 3c 80 00       	push   $0x803c60
  800565:	6a 26                	push   $0x26
  800567:	68 ac 3c 80 00       	push   $0x803cac
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
  800632:	68 b8 3c 80 00       	push   $0x803cb8
  800637:	6a 3a                	push   $0x3a
  800639:	68 ac 3c 80 00       	push   $0x803cac
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
  8006a2:	68 0c 3d 80 00       	push   $0x803d0c
  8006a7:	6a 44                	push   $0x44
  8006a9:	68 ac 3c 80 00       	push   $0x803cac
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
  8006fc:	e8 b7 12 00 00       	call   8019b8 <sys_cputs>
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
  800773:	e8 40 12 00 00       	call   8019b8 <sys_cputs>
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
  8007bd:	e8 a4 13 00 00       	call   801b66 <sys_disable_interrupt>
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
  8007dd:	e8 9e 13 00 00       	call   801b80 <sys_enable_interrupt>
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
  800827:	e8 10 2e 00 00       	call   80363c <__udivdi3>
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
  800877:	e8 d0 2e 00 00       	call   80374c <__umoddi3>
  80087c:	83 c4 10             	add    $0x10,%esp
  80087f:	05 74 3f 80 00       	add    $0x803f74,%eax
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
  8009d2:	8b 04 85 98 3f 80 00 	mov    0x803f98(,%eax,4),%eax
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
  800ab3:	8b 34 9d e0 3d 80 00 	mov    0x803de0(,%ebx,4),%esi
  800aba:	85 f6                	test   %esi,%esi
  800abc:	75 19                	jne    800ad7 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800abe:	53                   	push   %ebx
  800abf:	68 85 3f 80 00       	push   $0x803f85
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
  800ad8:	68 8e 3f 80 00       	push   $0x803f8e
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
  800b05:	be 91 3f 80 00       	mov    $0x803f91,%esi
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
  80152b:	68 f0 40 80 00       	push   $0x8040f0
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
  8015fb:	e8 fc 04 00 00       	call   801afc <sys_allocate_chunk>
  801600:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801603:	a1 20 51 80 00       	mov    0x805120,%eax
  801608:	83 ec 0c             	sub    $0xc,%esp
  80160b:	50                   	push   %eax
  80160c:	e8 71 0b 00 00       	call   802182 <initialize_MemBlocksList>
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
  801639:	68 15 41 80 00       	push   $0x804115
  80163e:	6a 33                	push   $0x33
  801640:	68 33 41 80 00       	push   $0x804133
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
  8016b8:	68 40 41 80 00       	push   $0x804140
  8016bd:	6a 34                	push   $0x34
  8016bf:	68 33 41 80 00       	push   $0x804133
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
  801750:	e8 75 07 00 00       	call   801eca <sys_isUHeapPlacementStrategyFIRSTFIT>
  801755:	85 c0                	test   %eax,%eax
  801757:	74 11                	je     80176a <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  801759:	83 ec 0c             	sub    $0xc,%esp
  80175c:	ff 75 e8             	pushl  -0x18(%ebp)
  80175f:	e8 e0 0d 00 00       	call   802544 <alloc_block_FF>
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
  801776:	e8 3c 0b 00 00       	call   8022b7 <insert_sorted_allocList>
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
  801796:	68 64 41 80 00       	push   $0x804164
  80179b:	6a 6f                	push   $0x6f
  80179d:	68 33 41 80 00       	push   $0x804133
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
  8017bc:	75 0a                	jne    8017c8 <smalloc+0x21>
  8017be:	b8 00 00 00 00       	mov    $0x0,%eax
  8017c3:	e9 8b 00 00 00       	jmp    801853 <smalloc+0xac>
	//	   Else, return NULL

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  8017c8:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8017cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017d5:	01 d0                	add    %edx,%eax
  8017d7:	48                   	dec    %eax
  8017d8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8017db:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017de:	ba 00 00 00 00       	mov    $0x0,%edx
  8017e3:	f7 75 f0             	divl   -0x10(%ebp)
  8017e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017e9:	29 d0                	sub    %edx,%eax
  8017eb:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  8017ee:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  8017f5:	e8 d0 06 00 00       	call   801eca <sys_isUHeapPlacementStrategyFIRSTFIT>
  8017fa:	85 c0                	test   %eax,%eax
  8017fc:	74 11                	je     80180f <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  8017fe:	83 ec 0c             	sub    $0xc,%esp
  801801:	ff 75 e8             	pushl  -0x18(%ebp)
  801804:	e8 3b 0d 00 00       	call   802544 <alloc_block_FF>
  801809:	83 c4 10             	add    $0x10,%esp
  80180c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(mem_block != NULL)
  80180f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801813:	74 39                	je     80184e <smalloc+0xa7>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801815:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801818:	8b 40 08             	mov    0x8(%eax),%eax
  80181b:	89 c2                	mov    %eax,%edx
  80181d:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801821:	52                   	push   %edx
  801822:	50                   	push   %eax
  801823:	ff 75 0c             	pushl  0xc(%ebp)
  801826:	ff 75 08             	pushl  0x8(%ebp)
  801829:	e8 21 04 00 00       	call   801c4f <sys_createSharedObject>
  80182e:	83 c4 10             	add    $0x10,%esp
  801831:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  801834:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  801838:	74 14                	je     80184e <smalloc+0xa7>
  80183a:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  80183e:	74 0e                	je     80184e <smalloc+0xa7>
  801840:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  801844:	74 08                	je     80184e <smalloc+0xa7>
			return (void*) mem_block->sva;
  801846:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801849:	8b 40 08             	mov    0x8(%eax),%eax
  80184c:	eb 05                	jmp    801853 <smalloc+0xac>
	}
	return NULL;
  80184e:	b8 00 00 00 00       	mov    $0x0,%eax

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801853:	c9                   	leave  
  801854:	c3                   	ret    

00801855 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801855:	55                   	push   %ebp
  801856:	89 e5                	mov    %esp,%ebp
  801858:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80185b:	e8 b4 fc ff ff       	call   801514 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801860:	83 ec 08             	sub    $0x8,%esp
  801863:	ff 75 0c             	pushl  0xc(%ebp)
  801866:	ff 75 08             	pushl  0x8(%ebp)
  801869:	e8 0b 04 00 00       	call   801c79 <sys_getSizeOfSharedObject>
  80186e:	83 c4 10             	add    $0x10,%esp
  801871:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size != E_SHARED_MEM_NOT_EXISTS)
  801874:	83 7d f0 f0          	cmpl   $0xfffffff0,-0x10(%ebp)
  801878:	74 76                	je     8018f0 <sget+0x9b>
	{
		uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  80187a:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801881:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801884:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801887:	01 d0                	add    %edx,%eax
  801889:	48                   	dec    %eax
  80188a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80188d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801890:	ba 00 00 00 00       	mov    $0x0,%edx
  801895:	f7 75 ec             	divl   -0x14(%ebp)
  801898:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80189b:	29 d0                	sub    %edx,%eax
  80189d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		struct MemBlock * mem_block = NULL;
  8018a0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  8018a7:	e8 1e 06 00 00       	call   801eca <sys_isUHeapPlacementStrategyFIRSTFIT>
  8018ac:	85 c0                	test   %eax,%eax
  8018ae:	74 11                	je     8018c1 <sget+0x6c>
			mem_block = alloc_block_FF(allocate_space);
  8018b0:	83 ec 0c             	sub    $0xc,%esp
  8018b3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8018b6:	e8 89 0c 00 00       	call   802544 <alloc_block_FF>
  8018bb:	83 c4 10             	add    $0x10,%esp
  8018be:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(mem_block != NULL)
  8018c1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8018c5:	74 29                	je     8018f0 <sget+0x9b>
		{
			uint32 shared_object_id = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)mem_block->sva);
  8018c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018ca:	8b 40 08             	mov    0x8(%eax),%eax
  8018cd:	83 ec 04             	sub    $0x4,%esp
  8018d0:	50                   	push   %eax
  8018d1:	ff 75 0c             	pushl  0xc(%ebp)
  8018d4:	ff 75 08             	pushl  0x8(%ebp)
  8018d7:	e8 ba 03 00 00       	call   801c96 <sys_getSharedObject>
  8018dc:	83 c4 10             	add    $0x10,%esp
  8018df:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (shared_object_id != E_SHARED_MEM_NOT_EXISTS)
  8018e2:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%ebp)
  8018e6:	74 08                	je     8018f0 <sget+0x9b>
				return (void *)mem_block->sva;
  8018e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018eb:	8b 40 08             	mov    0x8(%eax),%eax
  8018ee:	eb 05                	jmp    8018f5 <sget+0xa0>
		}
	}
	return NULL;
  8018f0:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8018f5:	c9                   	leave  
  8018f6:	c3                   	ret    

008018f7 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8018f7:	55                   	push   %ebp
  8018f8:	89 e5                	mov    %esp,%ebp
  8018fa:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8018fd:	e8 12 fc ff ff       	call   801514 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801902:	83 ec 04             	sub    $0x4,%esp
  801905:	68 88 41 80 00       	push   $0x804188
  80190a:	68 f1 00 00 00       	push   $0xf1
  80190f:	68 33 41 80 00       	push   $0x804133
  801914:	e8 bd eb ff ff       	call   8004d6 <_panic>

00801919 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801919:	55                   	push   %ebp
  80191a:	89 e5                	mov    %esp,%ebp
  80191c:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80191f:	83 ec 04             	sub    $0x4,%esp
  801922:	68 b0 41 80 00       	push   $0x8041b0
  801927:	68 05 01 00 00       	push   $0x105
  80192c:	68 33 41 80 00       	push   $0x804133
  801931:	e8 a0 eb ff ff       	call   8004d6 <_panic>

00801936 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801936:	55                   	push   %ebp
  801937:	89 e5                	mov    %esp,%ebp
  801939:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80193c:	83 ec 04             	sub    $0x4,%esp
  80193f:	68 d4 41 80 00       	push   $0x8041d4
  801944:	68 10 01 00 00       	push   $0x110
  801949:	68 33 41 80 00       	push   $0x804133
  80194e:	e8 83 eb ff ff       	call   8004d6 <_panic>

00801953 <shrink>:

}
void shrink(uint32 newSize)
{
  801953:	55                   	push   %ebp
  801954:	89 e5                	mov    %esp,%ebp
  801956:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801959:	83 ec 04             	sub    $0x4,%esp
  80195c:	68 d4 41 80 00       	push   $0x8041d4
  801961:	68 15 01 00 00       	push   $0x115
  801966:	68 33 41 80 00       	push   $0x804133
  80196b:	e8 66 eb ff ff       	call   8004d6 <_panic>

00801970 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801970:	55                   	push   %ebp
  801971:	89 e5                	mov    %esp,%ebp
  801973:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801976:	83 ec 04             	sub    $0x4,%esp
  801979:	68 d4 41 80 00       	push   $0x8041d4
  80197e:	68 1a 01 00 00       	push   $0x11a
  801983:	68 33 41 80 00       	push   $0x804133
  801988:	e8 49 eb ff ff       	call   8004d6 <_panic>

0080198d <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80198d:	55                   	push   %ebp
  80198e:	89 e5                	mov    %esp,%ebp
  801990:	57                   	push   %edi
  801991:	56                   	push   %esi
  801992:	53                   	push   %ebx
  801993:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801996:	8b 45 08             	mov    0x8(%ebp),%eax
  801999:	8b 55 0c             	mov    0xc(%ebp),%edx
  80199c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80199f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8019a2:	8b 7d 18             	mov    0x18(%ebp),%edi
  8019a5:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8019a8:	cd 30                	int    $0x30
  8019aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8019ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8019b0:	83 c4 10             	add    $0x10,%esp
  8019b3:	5b                   	pop    %ebx
  8019b4:	5e                   	pop    %esi
  8019b5:	5f                   	pop    %edi
  8019b6:	5d                   	pop    %ebp
  8019b7:	c3                   	ret    

008019b8 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8019b8:	55                   	push   %ebp
  8019b9:	89 e5                	mov    %esp,%ebp
  8019bb:	83 ec 04             	sub    $0x4,%esp
  8019be:	8b 45 10             	mov    0x10(%ebp),%eax
  8019c1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8019c4:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8019c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019cb:	6a 00                	push   $0x0
  8019cd:	6a 00                	push   $0x0
  8019cf:	52                   	push   %edx
  8019d0:	ff 75 0c             	pushl  0xc(%ebp)
  8019d3:	50                   	push   %eax
  8019d4:	6a 00                	push   $0x0
  8019d6:	e8 b2 ff ff ff       	call   80198d <syscall>
  8019db:	83 c4 18             	add    $0x18,%esp
}
  8019de:	90                   	nop
  8019df:	c9                   	leave  
  8019e0:	c3                   	ret    

008019e1 <sys_cgetc>:

int
sys_cgetc(void)
{
  8019e1:	55                   	push   %ebp
  8019e2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8019e4:	6a 00                	push   $0x0
  8019e6:	6a 00                	push   $0x0
  8019e8:	6a 00                	push   $0x0
  8019ea:	6a 00                	push   $0x0
  8019ec:	6a 00                	push   $0x0
  8019ee:	6a 01                	push   $0x1
  8019f0:	e8 98 ff ff ff       	call   80198d <syscall>
  8019f5:	83 c4 18             	add    $0x18,%esp
}
  8019f8:	c9                   	leave  
  8019f9:	c3                   	ret    

008019fa <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8019fa:	55                   	push   %ebp
  8019fb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8019fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a00:	8b 45 08             	mov    0x8(%ebp),%eax
  801a03:	6a 00                	push   $0x0
  801a05:	6a 00                	push   $0x0
  801a07:	6a 00                	push   $0x0
  801a09:	52                   	push   %edx
  801a0a:	50                   	push   %eax
  801a0b:	6a 05                	push   $0x5
  801a0d:	e8 7b ff ff ff       	call   80198d <syscall>
  801a12:	83 c4 18             	add    $0x18,%esp
}
  801a15:	c9                   	leave  
  801a16:	c3                   	ret    

00801a17 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801a17:	55                   	push   %ebp
  801a18:	89 e5                	mov    %esp,%ebp
  801a1a:	56                   	push   %esi
  801a1b:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801a1c:	8b 75 18             	mov    0x18(%ebp),%esi
  801a1f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a22:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a25:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a28:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2b:	56                   	push   %esi
  801a2c:	53                   	push   %ebx
  801a2d:	51                   	push   %ecx
  801a2e:	52                   	push   %edx
  801a2f:	50                   	push   %eax
  801a30:	6a 06                	push   $0x6
  801a32:	e8 56 ff ff ff       	call   80198d <syscall>
  801a37:	83 c4 18             	add    $0x18,%esp
}
  801a3a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a3d:	5b                   	pop    %ebx
  801a3e:	5e                   	pop    %esi
  801a3f:	5d                   	pop    %ebp
  801a40:	c3                   	ret    

00801a41 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801a41:	55                   	push   %ebp
  801a42:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801a44:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a47:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4a:	6a 00                	push   $0x0
  801a4c:	6a 00                	push   $0x0
  801a4e:	6a 00                	push   $0x0
  801a50:	52                   	push   %edx
  801a51:	50                   	push   %eax
  801a52:	6a 07                	push   $0x7
  801a54:	e8 34 ff ff ff       	call   80198d <syscall>
  801a59:	83 c4 18             	add    $0x18,%esp
}
  801a5c:	c9                   	leave  
  801a5d:	c3                   	ret    

00801a5e <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801a5e:	55                   	push   %ebp
  801a5f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801a61:	6a 00                	push   $0x0
  801a63:	6a 00                	push   $0x0
  801a65:	6a 00                	push   $0x0
  801a67:	ff 75 0c             	pushl  0xc(%ebp)
  801a6a:	ff 75 08             	pushl  0x8(%ebp)
  801a6d:	6a 08                	push   $0x8
  801a6f:	e8 19 ff ff ff       	call   80198d <syscall>
  801a74:	83 c4 18             	add    $0x18,%esp
}
  801a77:	c9                   	leave  
  801a78:	c3                   	ret    

00801a79 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801a79:	55                   	push   %ebp
  801a7a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801a7c:	6a 00                	push   $0x0
  801a7e:	6a 00                	push   $0x0
  801a80:	6a 00                	push   $0x0
  801a82:	6a 00                	push   $0x0
  801a84:	6a 00                	push   $0x0
  801a86:	6a 09                	push   $0x9
  801a88:	e8 00 ff ff ff       	call   80198d <syscall>
  801a8d:	83 c4 18             	add    $0x18,%esp
}
  801a90:	c9                   	leave  
  801a91:	c3                   	ret    

00801a92 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801a92:	55                   	push   %ebp
  801a93:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801a95:	6a 00                	push   $0x0
  801a97:	6a 00                	push   $0x0
  801a99:	6a 00                	push   $0x0
  801a9b:	6a 00                	push   $0x0
  801a9d:	6a 00                	push   $0x0
  801a9f:	6a 0a                	push   $0xa
  801aa1:	e8 e7 fe ff ff       	call   80198d <syscall>
  801aa6:	83 c4 18             	add    $0x18,%esp
}
  801aa9:	c9                   	leave  
  801aaa:	c3                   	ret    

00801aab <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801aab:	55                   	push   %ebp
  801aac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801aae:	6a 00                	push   $0x0
  801ab0:	6a 00                	push   $0x0
  801ab2:	6a 00                	push   $0x0
  801ab4:	6a 00                	push   $0x0
  801ab6:	6a 00                	push   $0x0
  801ab8:	6a 0b                	push   $0xb
  801aba:	e8 ce fe ff ff       	call   80198d <syscall>
  801abf:	83 c4 18             	add    $0x18,%esp
}
  801ac2:	c9                   	leave  
  801ac3:	c3                   	ret    

00801ac4 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801ac4:	55                   	push   %ebp
  801ac5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801ac7:	6a 00                	push   $0x0
  801ac9:	6a 00                	push   $0x0
  801acb:	6a 00                	push   $0x0
  801acd:	ff 75 0c             	pushl  0xc(%ebp)
  801ad0:	ff 75 08             	pushl  0x8(%ebp)
  801ad3:	6a 0f                	push   $0xf
  801ad5:	e8 b3 fe ff ff       	call   80198d <syscall>
  801ada:	83 c4 18             	add    $0x18,%esp
	return;
  801add:	90                   	nop
}
  801ade:	c9                   	leave  
  801adf:	c3                   	ret    

00801ae0 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801ae0:	55                   	push   %ebp
  801ae1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801ae3:	6a 00                	push   $0x0
  801ae5:	6a 00                	push   $0x0
  801ae7:	6a 00                	push   $0x0
  801ae9:	ff 75 0c             	pushl  0xc(%ebp)
  801aec:	ff 75 08             	pushl  0x8(%ebp)
  801aef:	6a 10                	push   $0x10
  801af1:	e8 97 fe ff ff       	call   80198d <syscall>
  801af6:	83 c4 18             	add    $0x18,%esp
	return ;
  801af9:	90                   	nop
}
  801afa:	c9                   	leave  
  801afb:	c3                   	ret    

00801afc <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801afc:	55                   	push   %ebp
  801afd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801aff:	6a 00                	push   $0x0
  801b01:	6a 00                	push   $0x0
  801b03:	ff 75 10             	pushl  0x10(%ebp)
  801b06:	ff 75 0c             	pushl  0xc(%ebp)
  801b09:	ff 75 08             	pushl  0x8(%ebp)
  801b0c:	6a 11                	push   $0x11
  801b0e:	e8 7a fe ff ff       	call   80198d <syscall>
  801b13:	83 c4 18             	add    $0x18,%esp
	return ;
  801b16:	90                   	nop
}
  801b17:	c9                   	leave  
  801b18:	c3                   	ret    

00801b19 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801b19:	55                   	push   %ebp
  801b1a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801b1c:	6a 00                	push   $0x0
  801b1e:	6a 00                	push   $0x0
  801b20:	6a 00                	push   $0x0
  801b22:	6a 00                	push   $0x0
  801b24:	6a 00                	push   $0x0
  801b26:	6a 0c                	push   $0xc
  801b28:	e8 60 fe ff ff       	call   80198d <syscall>
  801b2d:	83 c4 18             	add    $0x18,%esp
}
  801b30:	c9                   	leave  
  801b31:	c3                   	ret    

00801b32 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801b32:	55                   	push   %ebp
  801b33:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801b35:	6a 00                	push   $0x0
  801b37:	6a 00                	push   $0x0
  801b39:	6a 00                	push   $0x0
  801b3b:	6a 00                	push   $0x0
  801b3d:	ff 75 08             	pushl  0x8(%ebp)
  801b40:	6a 0d                	push   $0xd
  801b42:	e8 46 fe ff ff       	call   80198d <syscall>
  801b47:	83 c4 18             	add    $0x18,%esp
}
  801b4a:	c9                   	leave  
  801b4b:	c3                   	ret    

00801b4c <sys_scarce_memory>:

void sys_scarce_memory()
{
  801b4c:	55                   	push   %ebp
  801b4d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801b4f:	6a 00                	push   $0x0
  801b51:	6a 00                	push   $0x0
  801b53:	6a 00                	push   $0x0
  801b55:	6a 00                	push   $0x0
  801b57:	6a 00                	push   $0x0
  801b59:	6a 0e                	push   $0xe
  801b5b:	e8 2d fe ff ff       	call   80198d <syscall>
  801b60:	83 c4 18             	add    $0x18,%esp
}
  801b63:	90                   	nop
  801b64:	c9                   	leave  
  801b65:	c3                   	ret    

00801b66 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801b66:	55                   	push   %ebp
  801b67:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801b69:	6a 00                	push   $0x0
  801b6b:	6a 00                	push   $0x0
  801b6d:	6a 00                	push   $0x0
  801b6f:	6a 00                	push   $0x0
  801b71:	6a 00                	push   $0x0
  801b73:	6a 13                	push   $0x13
  801b75:	e8 13 fe ff ff       	call   80198d <syscall>
  801b7a:	83 c4 18             	add    $0x18,%esp
}
  801b7d:	90                   	nop
  801b7e:	c9                   	leave  
  801b7f:	c3                   	ret    

00801b80 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801b80:	55                   	push   %ebp
  801b81:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801b83:	6a 00                	push   $0x0
  801b85:	6a 00                	push   $0x0
  801b87:	6a 00                	push   $0x0
  801b89:	6a 00                	push   $0x0
  801b8b:	6a 00                	push   $0x0
  801b8d:	6a 14                	push   $0x14
  801b8f:	e8 f9 fd ff ff       	call   80198d <syscall>
  801b94:	83 c4 18             	add    $0x18,%esp
}
  801b97:	90                   	nop
  801b98:	c9                   	leave  
  801b99:	c3                   	ret    

00801b9a <sys_cputc>:


void
sys_cputc(const char c)
{
  801b9a:	55                   	push   %ebp
  801b9b:	89 e5                	mov    %esp,%ebp
  801b9d:	83 ec 04             	sub    $0x4,%esp
  801ba0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801ba6:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801baa:	6a 00                	push   $0x0
  801bac:	6a 00                	push   $0x0
  801bae:	6a 00                	push   $0x0
  801bb0:	6a 00                	push   $0x0
  801bb2:	50                   	push   %eax
  801bb3:	6a 15                	push   $0x15
  801bb5:	e8 d3 fd ff ff       	call   80198d <syscall>
  801bba:	83 c4 18             	add    $0x18,%esp
}
  801bbd:	90                   	nop
  801bbe:	c9                   	leave  
  801bbf:	c3                   	ret    

00801bc0 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801bc0:	55                   	push   %ebp
  801bc1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801bc3:	6a 00                	push   $0x0
  801bc5:	6a 00                	push   $0x0
  801bc7:	6a 00                	push   $0x0
  801bc9:	6a 00                	push   $0x0
  801bcb:	6a 00                	push   $0x0
  801bcd:	6a 16                	push   $0x16
  801bcf:	e8 b9 fd ff ff       	call   80198d <syscall>
  801bd4:	83 c4 18             	add    $0x18,%esp
}
  801bd7:	90                   	nop
  801bd8:	c9                   	leave  
  801bd9:	c3                   	ret    

00801bda <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801bda:	55                   	push   %ebp
  801bdb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801bdd:	8b 45 08             	mov    0x8(%ebp),%eax
  801be0:	6a 00                	push   $0x0
  801be2:	6a 00                	push   $0x0
  801be4:	6a 00                	push   $0x0
  801be6:	ff 75 0c             	pushl  0xc(%ebp)
  801be9:	50                   	push   %eax
  801bea:	6a 17                	push   $0x17
  801bec:	e8 9c fd ff ff       	call   80198d <syscall>
  801bf1:	83 c4 18             	add    $0x18,%esp
}
  801bf4:	c9                   	leave  
  801bf5:	c3                   	ret    

00801bf6 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801bf6:	55                   	push   %ebp
  801bf7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801bf9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bfc:	8b 45 08             	mov    0x8(%ebp),%eax
  801bff:	6a 00                	push   $0x0
  801c01:	6a 00                	push   $0x0
  801c03:	6a 00                	push   $0x0
  801c05:	52                   	push   %edx
  801c06:	50                   	push   %eax
  801c07:	6a 1a                	push   $0x1a
  801c09:	e8 7f fd ff ff       	call   80198d <syscall>
  801c0e:	83 c4 18             	add    $0x18,%esp
}
  801c11:	c9                   	leave  
  801c12:	c3                   	ret    

00801c13 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801c13:	55                   	push   %ebp
  801c14:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801c16:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c19:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1c:	6a 00                	push   $0x0
  801c1e:	6a 00                	push   $0x0
  801c20:	6a 00                	push   $0x0
  801c22:	52                   	push   %edx
  801c23:	50                   	push   %eax
  801c24:	6a 18                	push   $0x18
  801c26:	e8 62 fd ff ff       	call   80198d <syscall>
  801c2b:	83 c4 18             	add    $0x18,%esp
}
  801c2e:	90                   	nop
  801c2f:	c9                   	leave  
  801c30:	c3                   	ret    

00801c31 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801c31:	55                   	push   %ebp
  801c32:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801c34:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c37:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3a:	6a 00                	push   $0x0
  801c3c:	6a 00                	push   $0x0
  801c3e:	6a 00                	push   $0x0
  801c40:	52                   	push   %edx
  801c41:	50                   	push   %eax
  801c42:	6a 19                	push   $0x19
  801c44:	e8 44 fd ff ff       	call   80198d <syscall>
  801c49:	83 c4 18             	add    $0x18,%esp
}
  801c4c:	90                   	nop
  801c4d:	c9                   	leave  
  801c4e:	c3                   	ret    

00801c4f <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801c4f:	55                   	push   %ebp
  801c50:	89 e5                	mov    %esp,%ebp
  801c52:	83 ec 04             	sub    $0x4,%esp
  801c55:	8b 45 10             	mov    0x10(%ebp),%eax
  801c58:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801c5b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801c5e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801c62:	8b 45 08             	mov    0x8(%ebp),%eax
  801c65:	6a 00                	push   $0x0
  801c67:	51                   	push   %ecx
  801c68:	52                   	push   %edx
  801c69:	ff 75 0c             	pushl  0xc(%ebp)
  801c6c:	50                   	push   %eax
  801c6d:	6a 1b                	push   $0x1b
  801c6f:	e8 19 fd ff ff       	call   80198d <syscall>
  801c74:	83 c4 18             	add    $0x18,%esp
}
  801c77:	c9                   	leave  
  801c78:	c3                   	ret    

00801c79 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801c79:	55                   	push   %ebp
  801c7a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801c7c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c82:	6a 00                	push   $0x0
  801c84:	6a 00                	push   $0x0
  801c86:	6a 00                	push   $0x0
  801c88:	52                   	push   %edx
  801c89:	50                   	push   %eax
  801c8a:	6a 1c                	push   $0x1c
  801c8c:	e8 fc fc ff ff       	call   80198d <syscall>
  801c91:	83 c4 18             	add    $0x18,%esp
}
  801c94:	c9                   	leave  
  801c95:	c3                   	ret    

00801c96 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801c96:	55                   	push   %ebp
  801c97:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801c99:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c9c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca2:	6a 00                	push   $0x0
  801ca4:	6a 00                	push   $0x0
  801ca6:	51                   	push   %ecx
  801ca7:	52                   	push   %edx
  801ca8:	50                   	push   %eax
  801ca9:	6a 1d                	push   $0x1d
  801cab:	e8 dd fc ff ff       	call   80198d <syscall>
  801cb0:	83 c4 18             	add    $0x18,%esp
}
  801cb3:	c9                   	leave  
  801cb4:	c3                   	ret    

00801cb5 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801cb5:	55                   	push   %ebp
  801cb6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801cb8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cbb:	8b 45 08             	mov    0x8(%ebp),%eax
  801cbe:	6a 00                	push   $0x0
  801cc0:	6a 00                	push   $0x0
  801cc2:	6a 00                	push   $0x0
  801cc4:	52                   	push   %edx
  801cc5:	50                   	push   %eax
  801cc6:	6a 1e                	push   $0x1e
  801cc8:	e8 c0 fc ff ff       	call   80198d <syscall>
  801ccd:	83 c4 18             	add    $0x18,%esp
}
  801cd0:	c9                   	leave  
  801cd1:	c3                   	ret    

00801cd2 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801cd2:	55                   	push   %ebp
  801cd3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801cd5:	6a 00                	push   $0x0
  801cd7:	6a 00                	push   $0x0
  801cd9:	6a 00                	push   $0x0
  801cdb:	6a 00                	push   $0x0
  801cdd:	6a 00                	push   $0x0
  801cdf:	6a 1f                	push   $0x1f
  801ce1:	e8 a7 fc ff ff       	call   80198d <syscall>
  801ce6:	83 c4 18             	add    $0x18,%esp
}
  801ce9:	c9                   	leave  
  801cea:	c3                   	ret    

00801ceb <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801ceb:	55                   	push   %ebp
  801cec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801cee:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf1:	6a 00                	push   $0x0
  801cf3:	ff 75 14             	pushl  0x14(%ebp)
  801cf6:	ff 75 10             	pushl  0x10(%ebp)
  801cf9:	ff 75 0c             	pushl  0xc(%ebp)
  801cfc:	50                   	push   %eax
  801cfd:	6a 20                	push   $0x20
  801cff:	e8 89 fc ff ff       	call   80198d <syscall>
  801d04:	83 c4 18             	add    $0x18,%esp
}
  801d07:	c9                   	leave  
  801d08:	c3                   	ret    

00801d09 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801d09:	55                   	push   %ebp
  801d0a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801d0c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0f:	6a 00                	push   $0x0
  801d11:	6a 00                	push   $0x0
  801d13:	6a 00                	push   $0x0
  801d15:	6a 00                	push   $0x0
  801d17:	50                   	push   %eax
  801d18:	6a 21                	push   $0x21
  801d1a:	e8 6e fc ff ff       	call   80198d <syscall>
  801d1f:	83 c4 18             	add    $0x18,%esp
}
  801d22:	90                   	nop
  801d23:	c9                   	leave  
  801d24:	c3                   	ret    

00801d25 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801d25:	55                   	push   %ebp
  801d26:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801d28:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2b:	6a 00                	push   $0x0
  801d2d:	6a 00                	push   $0x0
  801d2f:	6a 00                	push   $0x0
  801d31:	6a 00                	push   $0x0
  801d33:	50                   	push   %eax
  801d34:	6a 22                	push   $0x22
  801d36:	e8 52 fc ff ff       	call   80198d <syscall>
  801d3b:	83 c4 18             	add    $0x18,%esp
}
  801d3e:	c9                   	leave  
  801d3f:	c3                   	ret    

00801d40 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801d40:	55                   	push   %ebp
  801d41:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801d43:	6a 00                	push   $0x0
  801d45:	6a 00                	push   $0x0
  801d47:	6a 00                	push   $0x0
  801d49:	6a 00                	push   $0x0
  801d4b:	6a 00                	push   $0x0
  801d4d:	6a 02                	push   $0x2
  801d4f:	e8 39 fc ff ff       	call   80198d <syscall>
  801d54:	83 c4 18             	add    $0x18,%esp
}
  801d57:	c9                   	leave  
  801d58:	c3                   	ret    

00801d59 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801d59:	55                   	push   %ebp
  801d5a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801d5c:	6a 00                	push   $0x0
  801d5e:	6a 00                	push   $0x0
  801d60:	6a 00                	push   $0x0
  801d62:	6a 00                	push   $0x0
  801d64:	6a 00                	push   $0x0
  801d66:	6a 03                	push   $0x3
  801d68:	e8 20 fc ff ff       	call   80198d <syscall>
  801d6d:	83 c4 18             	add    $0x18,%esp
}
  801d70:	c9                   	leave  
  801d71:	c3                   	ret    

00801d72 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801d72:	55                   	push   %ebp
  801d73:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801d75:	6a 00                	push   $0x0
  801d77:	6a 00                	push   $0x0
  801d79:	6a 00                	push   $0x0
  801d7b:	6a 00                	push   $0x0
  801d7d:	6a 00                	push   $0x0
  801d7f:	6a 04                	push   $0x4
  801d81:	e8 07 fc ff ff       	call   80198d <syscall>
  801d86:	83 c4 18             	add    $0x18,%esp
}
  801d89:	c9                   	leave  
  801d8a:	c3                   	ret    

00801d8b <sys_exit_env>:


void sys_exit_env(void)
{
  801d8b:	55                   	push   %ebp
  801d8c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801d8e:	6a 00                	push   $0x0
  801d90:	6a 00                	push   $0x0
  801d92:	6a 00                	push   $0x0
  801d94:	6a 00                	push   $0x0
  801d96:	6a 00                	push   $0x0
  801d98:	6a 23                	push   $0x23
  801d9a:	e8 ee fb ff ff       	call   80198d <syscall>
  801d9f:	83 c4 18             	add    $0x18,%esp
}
  801da2:	90                   	nop
  801da3:	c9                   	leave  
  801da4:	c3                   	ret    

00801da5 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801da5:	55                   	push   %ebp
  801da6:	89 e5                	mov    %esp,%ebp
  801da8:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801dab:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801dae:	8d 50 04             	lea    0x4(%eax),%edx
  801db1:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801db4:	6a 00                	push   $0x0
  801db6:	6a 00                	push   $0x0
  801db8:	6a 00                	push   $0x0
  801dba:	52                   	push   %edx
  801dbb:	50                   	push   %eax
  801dbc:	6a 24                	push   $0x24
  801dbe:	e8 ca fb ff ff       	call   80198d <syscall>
  801dc3:	83 c4 18             	add    $0x18,%esp
	return result;
  801dc6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801dc9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801dcc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801dcf:	89 01                	mov    %eax,(%ecx)
  801dd1:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801dd4:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd7:	c9                   	leave  
  801dd8:	c2 04 00             	ret    $0x4

00801ddb <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801ddb:	55                   	push   %ebp
  801ddc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801dde:	6a 00                	push   $0x0
  801de0:	6a 00                	push   $0x0
  801de2:	ff 75 10             	pushl  0x10(%ebp)
  801de5:	ff 75 0c             	pushl  0xc(%ebp)
  801de8:	ff 75 08             	pushl  0x8(%ebp)
  801deb:	6a 12                	push   $0x12
  801ded:	e8 9b fb ff ff       	call   80198d <syscall>
  801df2:	83 c4 18             	add    $0x18,%esp
	return ;
  801df5:	90                   	nop
}
  801df6:	c9                   	leave  
  801df7:	c3                   	ret    

00801df8 <sys_rcr2>:
uint32 sys_rcr2()
{
  801df8:	55                   	push   %ebp
  801df9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801dfb:	6a 00                	push   $0x0
  801dfd:	6a 00                	push   $0x0
  801dff:	6a 00                	push   $0x0
  801e01:	6a 00                	push   $0x0
  801e03:	6a 00                	push   $0x0
  801e05:	6a 25                	push   $0x25
  801e07:	e8 81 fb ff ff       	call   80198d <syscall>
  801e0c:	83 c4 18             	add    $0x18,%esp
}
  801e0f:	c9                   	leave  
  801e10:	c3                   	ret    

00801e11 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801e11:	55                   	push   %ebp
  801e12:	89 e5                	mov    %esp,%ebp
  801e14:	83 ec 04             	sub    $0x4,%esp
  801e17:	8b 45 08             	mov    0x8(%ebp),%eax
  801e1a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801e1d:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801e21:	6a 00                	push   $0x0
  801e23:	6a 00                	push   $0x0
  801e25:	6a 00                	push   $0x0
  801e27:	6a 00                	push   $0x0
  801e29:	50                   	push   %eax
  801e2a:	6a 26                	push   $0x26
  801e2c:	e8 5c fb ff ff       	call   80198d <syscall>
  801e31:	83 c4 18             	add    $0x18,%esp
	return ;
  801e34:	90                   	nop
}
  801e35:	c9                   	leave  
  801e36:	c3                   	ret    

00801e37 <rsttst>:
void rsttst()
{
  801e37:	55                   	push   %ebp
  801e38:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801e3a:	6a 00                	push   $0x0
  801e3c:	6a 00                	push   $0x0
  801e3e:	6a 00                	push   $0x0
  801e40:	6a 00                	push   $0x0
  801e42:	6a 00                	push   $0x0
  801e44:	6a 28                	push   $0x28
  801e46:	e8 42 fb ff ff       	call   80198d <syscall>
  801e4b:	83 c4 18             	add    $0x18,%esp
	return ;
  801e4e:	90                   	nop
}
  801e4f:	c9                   	leave  
  801e50:	c3                   	ret    

00801e51 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801e51:	55                   	push   %ebp
  801e52:	89 e5                	mov    %esp,%ebp
  801e54:	83 ec 04             	sub    $0x4,%esp
  801e57:	8b 45 14             	mov    0x14(%ebp),%eax
  801e5a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801e5d:	8b 55 18             	mov    0x18(%ebp),%edx
  801e60:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801e64:	52                   	push   %edx
  801e65:	50                   	push   %eax
  801e66:	ff 75 10             	pushl  0x10(%ebp)
  801e69:	ff 75 0c             	pushl  0xc(%ebp)
  801e6c:	ff 75 08             	pushl  0x8(%ebp)
  801e6f:	6a 27                	push   $0x27
  801e71:	e8 17 fb ff ff       	call   80198d <syscall>
  801e76:	83 c4 18             	add    $0x18,%esp
	return ;
  801e79:	90                   	nop
}
  801e7a:	c9                   	leave  
  801e7b:	c3                   	ret    

00801e7c <chktst>:
void chktst(uint32 n)
{
  801e7c:	55                   	push   %ebp
  801e7d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801e7f:	6a 00                	push   $0x0
  801e81:	6a 00                	push   $0x0
  801e83:	6a 00                	push   $0x0
  801e85:	6a 00                	push   $0x0
  801e87:	ff 75 08             	pushl  0x8(%ebp)
  801e8a:	6a 29                	push   $0x29
  801e8c:	e8 fc fa ff ff       	call   80198d <syscall>
  801e91:	83 c4 18             	add    $0x18,%esp
	return ;
  801e94:	90                   	nop
}
  801e95:	c9                   	leave  
  801e96:	c3                   	ret    

00801e97 <inctst>:

void inctst()
{
  801e97:	55                   	push   %ebp
  801e98:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801e9a:	6a 00                	push   $0x0
  801e9c:	6a 00                	push   $0x0
  801e9e:	6a 00                	push   $0x0
  801ea0:	6a 00                	push   $0x0
  801ea2:	6a 00                	push   $0x0
  801ea4:	6a 2a                	push   $0x2a
  801ea6:	e8 e2 fa ff ff       	call   80198d <syscall>
  801eab:	83 c4 18             	add    $0x18,%esp
	return ;
  801eae:	90                   	nop
}
  801eaf:	c9                   	leave  
  801eb0:	c3                   	ret    

00801eb1 <gettst>:
uint32 gettst()
{
  801eb1:	55                   	push   %ebp
  801eb2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801eb4:	6a 00                	push   $0x0
  801eb6:	6a 00                	push   $0x0
  801eb8:	6a 00                	push   $0x0
  801eba:	6a 00                	push   $0x0
  801ebc:	6a 00                	push   $0x0
  801ebe:	6a 2b                	push   $0x2b
  801ec0:	e8 c8 fa ff ff       	call   80198d <syscall>
  801ec5:	83 c4 18             	add    $0x18,%esp
}
  801ec8:	c9                   	leave  
  801ec9:	c3                   	ret    

00801eca <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801eca:	55                   	push   %ebp
  801ecb:	89 e5                	mov    %esp,%ebp
  801ecd:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ed0:	6a 00                	push   $0x0
  801ed2:	6a 00                	push   $0x0
  801ed4:	6a 00                	push   $0x0
  801ed6:	6a 00                	push   $0x0
  801ed8:	6a 00                	push   $0x0
  801eda:	6a 2c                	push   $0x2c
  801edc:	e8 ac fa ff ff       	call   80198d <syscall>
  801ee1:	83 c4 18             	add    $0x18,%esp
  801ee4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801ee7:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801eeb:	75 07                	jne    801ef4 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801eed:	b8 01 00 00 00       	mov    $0x1,%eax
  801ef2:	eb 05                	jmp    801ef9 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801ef4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ef9:	c9                   	leave  
  801efa:	c3                   	ret    

00801efb <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801efb:	55                   	push   %ebp
  801efc:	89 e5                	mov    %esp,%ebp
  801efe:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f01:	6a 00                	push   $0x0
  801f03:	6a 00                	push   $0x0
  801f05:	6a 00                	push   $0x0
  801f07:	6a 00                	push   $0x0
  801f09:	6a 00                	push   $0x0
  801f0b:	6a 2c                	push   $0x2c
  801f0d:	e8 7b fa ff ff       	call   80198d <syscall>
  801f12:	83 c4 18             	add    $0x18,%esp
  801f15:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801f18:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801f1c:	75 07                	jne    801f25 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801f1e:	b8 01 00 00 00       	mov    $0x1,%eax
  801f23:	eb 05                	jmp    801f2a <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801f25:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f2a:	c9                   	leave  
  801f2b:	c3                   	ret    

00801f2c <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801f2c:	55                   	push   %ebp
  801f2d:	89 e5                	mov    %esp,%ebp
  801f2f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f32:	6a 00                	push   $0x0
  801f34:	6a 00                	push   $0x0
  801f36:	6a 00                	push   $0x0
  801f38:	6a 00                	push   $0x0
  801f3a:	6a 00                	push   $0x0
  801f3c:	6a 2c                	push   $0x2c
  801f3e:	e8 4a fa ff ff       	call   80198d <syscall>
  801f43:	83 c4 18             	add    $0x18,%esp
  801f46:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801f49:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801f4d:	75 07                	jne    801f56 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801f4f:	b8 01 00 00 00       	mov    $0x1,%eax
  801f54:	eb 05                	jmp    801f5b <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801f56:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f5b:	c9                   	leave  
  801f5c:	c3                   	ret    

00801f5d <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801f5d:	55                   	push   %ebp
  801f5e:	89 e5                	mov    %esp,%ebp
  801f60:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f63:	6a 00                	push   $0x0
  801f65:	6a 00                	push   $0x0
  801f67:	6a 00                	push   $0x0
  801f69:	6a 00                	push   $0x0
  801f6b:	6a 00                	push   $0x0
  801f6d:	6a 2c                	push   $0x2c
  801f6f:	e8 19 fa ff ff       	call   80198d <syscall>
  801f74:	83 c4 18             	add    $0x18,%esp
  801f77:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801f7a:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801f7e:	75 07                	jne    801f87 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801f80:	b8 01 00 00 00       	mov    $0x1,%eax
  801f85:	eb 05                	jmp    801f8c <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801f87:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f8c:	c9                   	leave  
  801f8d:	c3                   	ret    

00801f8e <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801f8e:	55                   	push   %ebp
  801f8f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801f91:	6a 00                	push   $0x0
  801f93:	6a 00                	push   $0x0
  801f95:	6a 00                	push   $0x0
  801f97:	6a 00                	push   $0x0
  801f99:	ff 75 08             	pushl  0x8(%ebp)
  801f9c:	6a 2d                	push   $0x2d
  801f9e:	e8 ea f9 ff ff       	call   80198d <syscall>
  801fa3:	83 c4 18             	add    $0x18,%esp
	return ;
  801fa6:	90                   	nop
}
  801fa7:	c9                   	leave  
  801fa8:	c3                   	ret    

00801fa9 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801fa9:	55                   	push   %ebp
  801faa:	89 e5                	mov    %esp,%ebp
  801fac:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801fad:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801fb0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801fb3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fb6:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb9:	6a 00                	push   $0x0
  801fbb:	53                   	push   %ebx
  801fbc:	51                   	push   %ecx
  801fbd:	52                   	push   %edx
  801fbe:	50                   	push   %eax
  801fbf:	6a 2e                	push   $0x2e
  801fc1:	e8 c7 f9 ff ff       	call   80198d <syscall>
  801fc6:	83 c4 18             	add    $0x18,%esp
}
  801fc9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fcc:	c9                   	leave  
  801fcd:	c3                   	ret    

00801fce <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801fce:	55                   	push   %ebp
  801fcf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801fd1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fd4:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd7:	6a 00                	push   $0x0
  801fd9:	6a 00                	push   $0x0
  801fdb:	6a 00                	push   $0x0
  801fdd:	52                   	push   %edx
  801fde:	50                   	push   %eax
  801fdf:	6a 2f                	push   $0x2f
  801fe1:	e8 a7 f9 ff ff       	call   80198d <syscall>
  801fe6:	83 c4 18             	add    $0x18,%esp
}
  801fe9:	c9                   	leave  
  801fea:	c3                   	ret    

00801feb <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801feb:	55                   	push   %ebp
  801fec:	89 e5                	mov    %esp,%ebp
  801fee:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801ff1:	83 ec 0c             	sub    $0xc,%esp
  801ff4:	68 e4 41 80 00       	push   $0x8041e4
  801ff9:	e8 8c e7 ff ff       	call   80078a <cprintf>
  801ffe:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802001:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802008:	83 ec 0c             	sub    $0xc,%esp
  80200b:	68 10 42 80 00       	push   $0x804210
  802010:	e8 75 e7 ff ff       	call   80078a <cprintf>
  802015:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802018:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80201c:	a1 38 51 80 00       	mov    0x805138,%eax
  802021:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802024:	eb 56                	jmp    80207c <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802026:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80202a:	74 1c                	je     802048 <print_mem_block_lists+0x5d>
  80202c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80202f:	8b 50 08             	mov    0x8(%eax),%edx
  802032:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802035:	8b 48 08             	mov    0x8(%eax),%ecx
  802038:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80203b:	8b 40 0c             	mov    0xc(%eax),%eax
  80203e:	01 c8                	add    %ecx,%eax
  802040:	39 c2                	cmp    %eax,%edx
  802042:	73 04                	jae    802048 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802044:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802048:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80204b:	8b 50 08             	mov    0x8(%eax),%edx
  80204e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802051:	8b 40 0c             	mov    0xc(%eax),%eax
  802054:	01 c2                	add    %eax,%edx
  802056:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802059:	8b 40 08             	mov    0x8(%eax),%eax
  80205c:	83 ec 04             	sub    $0x4,%esp
  80205f:	52                   	push   %edx
  802060:	50                   	push   %eax
  802061:	68 25 42 80 00       	push   $0x804225
  802066:	e8 1f e7 ff ff       	call   80078a <cprintf>
  80206b:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80206e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802071:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802074:	a1 40 51 80 00       	mov    0x805140,%eax
  802079:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80207c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802080:	74 07                	je     802089 <print_mem_block_lists+0x9e>
  802082:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802085:	8b 00                	mov    (%eax),%eax
  802087:	eb 05                	jmp    80208e <print_mem_block_lists+0xa3>
  802089:	b8 00 00 00 00       	mov    $0x0,%eax
  80208e:	a3 40 51 80 00       	mov    %eax,0x805140
  802093:	a1 40 51 80 00       	mov    0x805140,%eax
  802098:	85 c0                	test   %eax,%eax
  80209a:	75 8a                	jne    802026 <print_mem_block_lists+0x3b>
  80209c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020a0:	75 84                	jne    802026 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8020a2:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8020a6:	75 10                	jne    8020b8 <print_mem_block_lists+0xcd>
  8020a8:	83 ec 0c             	sub    $0xc,%esp
  8020ab:	68 34 42 80 00       	push   $0x804234
  8020b0:	e8 d5 e6 ff ff       	call   80078a <cprintf>
  8020b5:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8020b8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8020bf:	83 ec 0c             	sub    $0xc,%esp
  8020c2:	68 58 42 80 00       	push   $0x804258
  8020c7:	e8 be e6 ff ff       	call   80078a <cprintf>
  8020cc:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8020cf:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8020d3:	a1 40 50 80 00       	mov    0x805040,%eax
  8020d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020db:	eb 56                	jmp    802133 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8020dd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8020e1:	74 1c                	je     8020ff <print_mem_block_lists+0x114>
  8020e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e6:	8b 50 08             	mov    0x8(%eax),%edx
  8020e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020ec:	8b 48 08             	mov    0x8(%eax),%ecx
  8020ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020f2:	8b 40 0c             	mov    0xc(%eax),%eax
  8020f5:	01 c8                	add    %ecx,%eax
  8020f7:	39 c2                	cmp    %eax,%edx
  8020f9:	73 04                	jae    8020ff <print_mem_block_lists+0x114>
			sorted = 0 ;
  8020fb:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8020ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802102:	8b 50 08             	mov    0x8(%eax),%edx
  802105:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802108:	8b 40 0c             	mov    0xc(%eax),%eax
  80210b:	01 c2                	add    %eax,%edx
  80210d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802110:	8b 40 08             	mov    0x8(%eax),%eax
  802113:	83 ec 04             	sub    $0x4,%esp
  802116:	52                   	push   %edx
  802117:	50                   	push   %eax
  802118:	68 25 42 80 00       	push   $0x804225
  80211d:	e8 68 e6 ff ff       	call   80078a <cprintf>
  802122:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802125:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802128:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80212b:	a1 48 50 80 00       	mov    0x805048,%eax
  802130:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802133:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802137:	74 07                	je     802140 <print_mem_block_lists+0x155>
  802139:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80213c:	8b 00                	mov    (%eax),%eax
  80213e:	eb 05                	jmp    802145 <print_mem_block_lists+0x15a>
  802140:	b8 00 00 00 00       	mov    $0x0,%eax
  802145:	a3 48 50 80 00       	mov    %eax,0x805048
  80214a:	a1 48 50 80 00       	mov    0x805048,%eax
  80214f:	85 c0                	test   %eax,%eax
  802151:	75 8a                	jne    8020dd <print_mem_block_lists+0xf2>
  802153:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802157:	75 84                	jne    8020dd <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802159:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80215d:	75 10                	jne    80216f <print_mem_block_lists+0x184>
  80215f:	83 ec 0c             	sub    $0xc,%esp
  802162:	68 70 42 80 00       	push   $0x804270
  802167:	e8 1e e6 ff ff       	call   80078a <cprintf>
  80216c:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  80216f:	83 ec 0c             	sub    $0xc,%esp
  802172:	68 e4 41 80 00       	push   $0x8041e4
  802177:	e8 0e e6 ff ff       	call   80078a <cprintf>
  80217c:	83 c4 10             	add    $0x10,%esp

}
  80217f:	90                   	nop
  802180:	c9                   	leave  
  802181:	c3                   	ret    

00802182 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802182:	55                   	push   %ebp
  802183:	89 e5                	mov    %esp,%ebp
  802185:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  802188:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  80218f:	00 00 00 
  802192:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802199:	00 00 00 
  80219c:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  8021a3:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  8021a6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8021ad:	e9 9e 00 00 00       	jmp    802250 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  8021b2:	a1 50 50 80 00       	mov    0x805050,%eax
  8021b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021ba:	c1 e2 04             	shl    $0x4,%edx
  8021bd:	01 d0                	add    %edx,%eax
  8021bf:	85 c0                	test   %eax,%eax
  8021c1:	75 14                	jne    8021d7 <initialize_MemBlocksList+0x55>
  8021c3:	83 ec 04             	sub    $0x4,%esp
  8021c6:	68 98 42 80 00       	push   $0x804298
  8021cb:	6a 46                	push   $0x46
  8021cd:	68 bb 42 80 00       	push   $0x8042bb
  8021d2:	e8 ff e2 ff ff       	call   8004d6 <_panic>
  8021d7:	a1 50 50 80 00       	mov    0x805050,%eax
  8021dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021df:	c1 e2 04             	shl    $0x4,%edx
  8021e2:	01 d0                	add    %edx,%eax
  8021e4:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8021ea:	89 10                	mov    %edx,(%eax)
  8021ec:	8b 00                	mov    (%eax),%eax
  8021ee:	85 c0                	test   %eax,%eax
  8021f0:	74 18                	je     80220a <initialize_MemBlocksList+0x88>
  8021f2:	a1 48 51 80 00       	mov    0x805148,%eax
  8021f7:	8b 15 50 50 80 00    	mov    0x805050,%edx
  8021fd:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802200:	c1 e1 04             	shl    $0x4,%ecx
  802203:	01 ca                	add    %ecx,%edx
  802205:	89 50 04             	mov    %edx,0x4(%eax)
  802208:	eb 12                	jmp    80221c <initialize_MemBlocksList+0x9a>
  80220a:	a1 50 50 80 00       	mov    0x805050,%eax
  80220f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802212:	c1 e2 04             	shl    $0x4,%edx
  802215:	01 d0                	add    %edx,%eax
  802217:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80221c:	a1 50 50 80 00       	mov    0x805050,%eax
  802221:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802224:	c1 e2 04             	shl    $0x4,%edx
  802227:	01 d0                	add    %edx,%eax
  802229:	a3 48 51 80 00       	mov    %eax,0x805148
  80222e:	a1 50 50 80 00       	mov    0x805050,%eax
  802233:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802236:	c1 e2 04             	shl    $0x4,%edx
  802239:	01 d0                	add    %edx,%eax
  80223b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802242:	a1 54 51 80 00       	mov    0x805154,%eax
  802247:	40                   	inc    %eax
  802248:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  80224d:	ff 45 f4             	incl   -0xc(%ebp)
  802250:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802253:	3b 45 08             	cmp    0x8(%ebp),%eax
  802256:	0f 82 56 ff ff ff    	jb     8021b2 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  80225c:	90                   	nop
  80225d:	c9                   	leave  
  80225e:	c3                   	ret    

0080225f <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80225f:	55                   	push   %ebp
  802260:	89 e5                	mov    %esp,%ebp
  802262:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802265:	8b 45 08             	mov    0x8(%ebp),%eax
  802268:	8b 00                	mov    (%eax),%eax
  80226a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80226d:	eb 19                	jmp    802288 <find_block+0x29>
	{
		if(va==point->sva)
  80226f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802272:	8b 40 08             	mov    0x8(%eax),%eax
  802275:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802278:	75 05                	jne    80227f <find_block+0x20>
		   return point;
  80227a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80227d:	eb 36                	jmp    8022b5 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  80227f:	8b 45 08             	mov    0x8(%ebp),%eax
  802282:	8b 40 08             	mov    0x8(%eax),%eax
  802285:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802288:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80228c:	74 07                	je     802295 <find_block+0x36>
  80228e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802291:	8b 00                	mov    (%eax),%eax
  802293:	eb 05                	jmp    80229a <find_block+0x3b>
  802295:	b8 00 00 00 00       	mov    $0x0,%eax
  80229a:	8b 55 08             	mov    0x8(%ebp),%edx
  80229d:	89 42 08             	mov    %eax,0x8(%edx)
  8022a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a3:	8b 40 08             	mov    0x8(%eax),%eax
  8022a6:	85 c0                	test   %eax,%eax
  8022a8:	75 c5                	jne    80226f <find_block+0x10>
  8022aa:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8022ae:	75 bf                	jne    80226f <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  8022b0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022b5:	c9                   	leave  
  8022b6:	c3                   	ret    

008022b7 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8022b7:	55                   	push   %ebp
  8022b8:	89 e5                	mov    %esp,%ebp
  8022ba:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  8022bd:	a1 40 50 80 00       	mov    0x805040,%eax
  8022c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  8022c5:	a1 44 50 80 00       	mov    0x805044,%eax
  8022ca:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  8022cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022d0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8022d3:	74 24                	je     8022f9 <insert_sorted_allocList+0x42>
  8022d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d8:	8b 50 08             	mov    0x8(%eax),%edx
  8022db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022de:	8b 40 08             	mov    0x8(%eax),%eax
  8022e1:	39 c2                	cmp    %eax,%edx
  8022e3:	76 14                	jbe    8022f9 <insert_sorted_allocList+0x42>
  8022e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e8:	8b 50 08             	mov    0x8(%eax),%edx
  8022eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022ee:	8b 40 08             	mov    0x8(%eax),%eax
  8022f1:	39 c2                	cmp    %eax,%edx
  8022f3:	0f 82 60 01 00 00    	jb     802459 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  8022f9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8022fd:	75 65                	jne    802364 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  8022ff:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802303:	75 14                	jne    802319 <insert_sorted_allocList+0x62>
  802305:	83 ec 04             	sub    $0x4,%esp
  802308:	68 98 42 80 00       	push   $0x804298
  80230d:	6a 6b                	push   $0x6b
  80230f:	68 bb 42 80 00       	push   $0x8042bb
  802314:	e8 bd e1 ff ff       	call   8004d6 <_panic>
  802319:	8b 15 40 50 80 00    	mov    0x805040,%edx
  80231f:	8b 45 08             	mov    0x8(%ebp),%eax
  802322:	89 10                	mov    %edx,(%eax)
  802324:	8b 45 08             	mov    0x8(%ebp),%eax
  802327:	8b 00                	mov    (%eax),%eax
  802329:	85 c0                	test   %eax,%eax
  80232b:	74 0d                	je     80233a <insert_sorted_allocList+0x83>
  80232d:	a1 40 50 80 00       	mov    0x805040,%eax
  802332:	8b 55 08             	mov    0x8(%ebp),%edx
  802335:	89 50 04             	mov    %edx,0x4(%eax)
  802338:	eb 08                	jmp    802342 <insert_sorted_allocList+0x8b>
  80233a:	8b 45 08             	mov    0x8(%ebp),%eax
  80233d:	a3 44 50 80 00       	mov    %eax,0x805044
  802342:	8b 45 08             	mov    0x8(%ebp),%eax
  802345:	a3 40 50 80 00       	mov    %eax,0x805040
  80234a:	8b 45 08             	mov    0x8(%ebp),%eax
  80234d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802354:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802359:	40                   	inc    %eax
  80235a:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80235f:	e9 dc 01 00 00       	jmp    802540 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802364:	8b 45 08             	mov    0x8(%ebp),%eax
  802367:	8b 50 08             	mov    0x8(%eax),%edx
  80236a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80236d:	8b 40 08             	mov    0x8(%eax),%eax
  802370:	39 c2                	cmp    %eax,%edx
  802372:	77 6c                	ja     8023e0 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802374:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802378:	74 06                	je     802380 <insert_sorted_allocList+0xc9>
  80237a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80237e:	75 14                	jne    802394 <insert_sorted_allocList+0xdd>
  802380:	83 ec 04             	sub    $0x4,%esp
  802383:	68 d4 42 80 00       	push   $0x8042d4
  802388:	6a 6f                	push   $0x6f
  80238a:	68 bb 42 80 00       	push   $0x8042bb
  80238f:	e8 42 e1 ff ff       	call   8004d6 <_panic>
  802394:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802397:	8b 50 04             	mov    0x4(%eax),%edx
  80239a:	8b 45 08             	mov    0x8(%ebp),%eax
  80239d:	89 50 04             	mov    %edx,0x4(%eax)
  8023a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023a6:	89 10                	mov    %edx,(%eax)
  8023a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023ab:	8b 40 04             	mov    0x4(%eax),%eax
  8023ae:	85 c0                	test   %eax,%eax
  8023b0:	74 0d                	je     8023bf <insert_sorted_allocList+0x108>
  8023b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023b5:	8b 40 04             	mov    0x4(%eax),%eax
  8023b8:	8b 55 08             	mov    0x8(%ebp),%edx
  8023bb:	89 10                	mov    %edx,(%eax)
  8023bd:	eb 08                	jmp    8023c7 <insert_sorted_allocList+0x110>
  8023bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c2:	a3 40 50 80 00       	mov    %eax,0x805040
  8023c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023ca:	8b 55 08             	mov    0x8(%ebp),%edx
  8023cd:	89 50 04             	mov    %edx,0x4(%eax)
  8023d0:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8023d5:	40                   	inc    %eax
  8023d6:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8023db:	e9 60 01 00 00       	jmp    802540 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  8023e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e3:	8b 50 08             	mov    0x8(%eax),%edx
  8023e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023e9:	8b 40 08             	mov    0x8(%eax),%eax
  8023ec:	39 c2                	cmp    %eax,%edx
  8023ee:	0f 82 4c 01 00 00    	jb     802540 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8023f4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023f8:	75 14                	jne    80240e <insert_sorted_allocList+0x157>
  8023fa:	83 ec 04             	sub    $0x4,%esp
  8023fd:	68 0c 43 80 00       	push   $0x80430c
  802402:	6a 73                	push   $0x73
  802404:	68 bb 42 80 00       	push   $0x8042bb
  802409:	e8 c8 e0 ff ff       	call   8004d6 <_panic>
  80240e:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802414:	8b 45 08             	mov    0x8(%ebp),%eax
  802417:	89 50 04             	mov    %edx,0x4(%eax)
  80241a:	8b 45 08             	mov    0x8(%ebp),%eax
  80241d:	8b 40 04             	mov    0x4(%eax),%eax
  802420:	85 c0                	test   %eax,%eax
  802422:	74 0c                	je     802430 <insert_sorted_allocList+0x179>
  802424:	a1 44 50 80 00       	mov    0x805044,%eax
  802429:	8b 55 08             	mov    0x8(%ebp),%edx
  80242c:	89 10                	mov    %edx,(%eax)
  80242e:	eb 08                	jmp    802438 <insert_sorted_allocList+0x181>
  802430:	8b 45 08             	mov    0x8(%ebp),%eax
  802433:	a3 40 50 80 00       	mov    %eax,0x805040
  802438:	8b 45 08             	mov    0x8(%ebp),%eax
  80243b:	a3 44 50 80 00       	mov    %eax,0x805044
  802440:	8b 45 08             	mov    0x8(%ebp),%eax
  802443:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802449:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80244e:	40                   	inc    %eax
  80244f:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802454:	e9 e7 00 00 00       	jmp    802540 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802459:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80245c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  80245f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802466:	a1 40 50 80 00       	mov    0x805040,%eax
  80246b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80246e:	e9 9d 00 00 00       	jmp    802510 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802473:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802476:	8b 00                	mov    (%eax),%eax
  802478:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  80247b:	8b 45 08             	mov    0x8(%ebp),%eax
  80247e:	8b 50 08             	mov    0x8(%eax),%edx
  802481:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802484:	8b 40 08             	mov    0x8(%eax),%eax
  802487:	39 c2                	cmp    %eax,%edx
  802489:	76 7d                	jbe    802508 <insert_sorted_allocList+0x251>
  80248b:	8b 45 08             	mov    0x8(%ebp),%eax
  80248e:	8b 50 08             	mov    0x8(%eax),%edx
  802491:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802494:	8b 40 08             	mov    0x8(%eax),%eax
  802497:	39 c2                	cmp    %eax,%edx
  802499:	73 6d                	jae    802508 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  80249b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80249f:	74 06                	je     8024a7 <insert_sorted_allocList+0x1f0>
  8024a1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8024a5:	75 14                	jne    8024bb <insert_sorted_allocList+0x204>
  8024a7:	83 ec 04             	sub    $0x4,%esp
  8024aa:	68 30 43 80 00       	push   $0x804330
  8024af:	6a 7f                	push   $0x7f
  8024b1:	68 bb 42 80 00       	push   $0x8042bb
  8024b6:	e8 1b e0 ff ff       	call   8004d6 <_panic>
  8024bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024be:	8b 10                	mov    (%eax),%edx
  8024c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c3:	89 10                	mov    %edx,(%eax)
  8024c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c8:	8b 00                	mov    (%eax),%eax
  8024ca:	85 c0                	test   %eax,%eax
  8024cc:	74 0b                	je     8024d9 <insert_sorted_allocList+0x222>
  8024ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d1:	8b 00                	mov    (%eax),%eax
  8024d3:	8b 55 08             	mov    0x8(%ebp),%edx
  8024d6:	89 50 04             	mov    %edx,0x4(%eax)
  8024d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024dc:	8b 55 08             	mov    0x8(%ebp),%edx
  8024df:	89 10                	mov    %edx,(%eax)
  8024e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024e7:	89 50 04             	mov    %edx,0x4(%eax)
  8024ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ed:	8b 00                	mov    (%eax),%eax
  8024ef:	85 c0                	test   %eax,%eax
  8024f1:	75 08                	jne    8024fb <insert_sorted_allocList+0x244>
  8024f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f6:	a3 44 50 80 00       	mov    %eax,0x805044
  8024fb:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802500:	40                   	inc    %eax
  802501:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802506:	eb 39                	jmp    802541 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802508:	a1 48 50 80 00       	mov    0x805048,%eax
  80250d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802510:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802514:	74 07                	je     80251d <insert_sorted_allocList+0x266>
  802516:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802519:	8b 00                	mov    (%eax),%eax
  80251b:	eb 05                	jmp    802522 <insert_sorted_allocList+0x26b>
  80251d:	b8 00 00 00 00       	mov    $0x0,%eax
  802522:	a3 48 50 80 00       	mov    %eax,0x805048
  802527:	a1 48 50 80 00       	mov    0x805048,%eax
  80252c:	85 c0                	test   %eax,%eax
  80252e:	0f 85 3f ff ff ff    	jne    802473 <insert_sorted_allocList+0x1bc>
  802534:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802538:	0f 85 35 ff ff ff    	jne    802473 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80253e:	eb 01                	jmp    802541 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802540:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802541:	90                   	nop
  802542:	c9                   	leave  
  802543:	c3                   	ret    

00802544 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802544:	55                   	push   %ebp
  802545:	89 e5                	mov    %esp,%ebp
  802547:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  80254a:	a1 38 51 80 00       	mov    0x805138,%eax
  80254f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802552:	e9 85 01 00 00       	jmp    8026dc <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802557:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255a:	8b 40 0c             	mov    0xc(%eax),%eax
  80255d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802560:	0f 82 6e 01 00 00    	jb     8026d4 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802566:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802569:	8b 40 0c             	mov    0xc(%eax),%eax
  80256c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80256f:	0f 85 8a 00 00 00    	jne    8025ff <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802575:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802579:	75 17                	jne    802592 <alloc_block_FF+0x4e>
  80257b:	83 ec 04             	sub    $0x4,%esp
  80257e:	68 64 43 80 00       	push   $0x804364
  802583:	68 93 00 00 00       	push   $0x93
  802588:	68 bb 42 80 00       	push   $0x8042bb
  80258d:	e8 44 df ff ff       	call   8004d6 <_panic>
  802592:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802595:	8b 00                	mov    (%eax),%eax
  802597:	85 c0                	test   %eax,%eax
  802599:	74 10                	je     8025ab <alloc_block_FF+0x67>
  80259b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259e:	8b 00                	mov    (%eax),%eax
  8025a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025a3:	8b 52 04             	mov    0x4(%edx),%edx
  8025a6:	89 50 04             	mov    %edx,0x4(%eax)
  8025a9:	eb 0b                	jmp    8025b6 <alloc_block_FF+0x72>
  8025ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ae:	8b 40 04             	mov    0x4(%eax),%eax
  8025b1:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8025b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b9:	8b 40 04             	mov    0x4(%eax),%eax
  8025bc:	85 c0                	test   %eax,%eax
  8025be:	74 0f                	je     8025cf <alloc_block_FF+0x8b>
  8025c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c3:	8b 40 04             	mov    0x4(%eax),%eax
  8025c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025c9:	8b 12                	mov    (%edx),%edx
  8025cb:	89 10                	mov    %edx,(%eax)
  8025cd:	eb 0a                	jmp    8025d9 <alloc_block_FF+0x95>
  8025cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d2:	8b 00                	mov    (%eax),%eax
  8025d4:	a3 38 51 80 00       	mov    %eax,0x805138
  8025d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025dc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025ec:	a1 44 51 80 00       	mov    0x805144,%eax
  8025f1:	48                   	dec    %eax
  8025f2:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  8025f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fa:	e9 10 01 00 00       	jmp    80270f <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  8025ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802602:	8b 40 0c             	mov    0xc(%eax),%eax
  802605:	3b 45 08             	cmp    0x8(%ebp),%eax
  802608:	0f 86 c6 00 00 00    	jbe    8026d4 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80260e:	a1 48 51 80 00       	mov    0x805148,%eax
  802613:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802616:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802619:	8b 50 08             	mov    0x8(%eax),%edx
  80261c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80261f:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802622:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802625:	8b 55 08             	mov    0x8(%ebp),%edx
  802628:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80262b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80262f:	75 17                	jne    802648 <alloc_block_FF+0x104>
  802631:	83 ec 04             	sub    $0x4,%esp
  802634:	68 64 43 80 00       	push   $0x804364
  802639:	68 9b 00 00 00       	push   $0x9b
  80263e:	68 bb 42 80 00       	push   $0x8042bb
  802643:	e8 8e de ff ff       	call   8004d6 <_panic>
  802648:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80264b:	8b 00                	mov    (%eax),%eax
  80264d:	85 c0                	test   %eax,%eax
  80264f:	74 10                	je     802661 <alloc_block_FF+0x11d>
  802651:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802654:	8b 00                	mov    (%eax),%eax
  802656:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802659:	8b 52 04             	mov    0x4(%edx),%edx
  80265c:	89 50 04             	mov    %edx,0x4(%eax)
  80265f:	eb 0b                	jmp    80266c <alloc_block_FF+0x128>
  802661:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802664:	8b 40 04             	mov    0x4(%eax),%eax
  802667:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80266c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80266f:	8b 40 04             	mov    0x4(%eax),%eax
  802672:	85 c0                	test   %eax,%eax
  802674:	74 0f                	je     802685 <alloc_block_FF+0x141>
  802676:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802679:	8b 40 04             	mov    0x4(%eax),%eax
  80267c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80267f:	8b 12                	mov    (%edx),%edx
  802681:	89 10                	mov    %edx,(%eax)
  802683:	eb 0a                	jmp    80268f <alloc_block_FF+0x14b>
  802685:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802688:	8b 00                	mov    (%eax),%eax
  80268a:	a3 48 51 80 00       	mov    %eax,0x805148
  80268f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802692:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802698:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80269b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026a2:	a1 54 51 80 00       	mov    0x805154,%eax
  8026a7:	48                   	dec    %eax
  8026a8:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  8026ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b0:	8b 50 08             	mov    0x8(%eax),%edx
  8026b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b6:	01 c2                	add    %eax,%edx
  8026b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026bb:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  8026be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c1:	8b 40 0c             	mov    0xc(%eax),%eax
  8026c4:	2b 45 08             	sub    0x8(%ebp),%eax
  8026c7:	89 c2                	mov    %eax,%edx
  8026c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026cc:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  8026cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026d2:	eb 3b                	jmp    80270f <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8026d4:	a1 40 51 80 00       	mov    0x805140,%eax
  8026d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026dc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026e0:	74 07                	je     8026e9 <alloc_block_FF+0x1a5>
  8026e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e5:	8b 00                	mov    (%eax),%eax
  8026e7:	eb 05                	jmp    8026ee <alloc_block_FF+0x1aa>
  8026e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8026ee:	a3 40 51 80 00       	mov    %eax,0x805140
  8026f3:	a1 40 51 80 00       	mov    0x805140,%eax
  8026f8:	85 c0                	test   %eax,%eax
  8026fa:	0f 85 57 fe ff ff    	jne    802557 <alloc_block_FF+0x13>
  802700:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802704:	0f 85 4d fe ff ff    	jne    802557 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  80270a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80270f:	c9                   	leave  
  802710:	c3                   	ret    

00802711 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802711:	55                   	push   %ebp
  802712:	89 e5                	mov    %esp,%ebp
  802714:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802717:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  80271e:	a1 38 51 80 00       	mov    0x805138,%eax
  802723:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802726:	e9 df 00 00 00       	jmp    80280a <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  80272b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272e:	8b 40 0c             	mov    0xc(%eax),%eax
  802731:	3b 45 08             	cmp    0x8(%ebp),%eax
  802734:	0f 82 c8 00 00 00    	jb     802802 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  80273a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273d:	8b 40 0c             	mov    0xc(%eax),%eax
  802740:	3b 45 08             	cmp    0x8(%ebp),%eax
  802743:	0f 85 8a 00 00 00    	jne    8027d3 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802749:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80274d:	75 17                	jne    802766 <alloc_block_BF+0x55>
  80274f:	83 ec 04             	sub    $0x4,%esp
  802752:	68 64 43 80 00       	push   $0x804364
  802757:	68 b7 00 00 00       	push   $0xb7
  80275c:	68 bb 42 80 00       	push   $0x8042bb
  802761:	e8 70 dd ff ff       	call   8004d6 <_panic>
  802766:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802769:	8b 00                	mov    (%eax),%eax
  80276b:	85 c0                	test   %eax,%eax
  80276d:	74 10                	je     80277f <alloc_block_BF+0x6e>
  80276f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802772:	8b 00                	mov    (%eax),%eax
  802774:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802777:	8b 52 04             	mov    0x4(%edx),%edx
  80277a:	89 50 04             	mov    %edx,0x4(%eax)
  80277d:	eb 0b                	jmp    80278a <alloc_block_BF+0x79>
  80277f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802782:	8b 40 04             	mov    0x4(%eax),%eax
  802785:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80278a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278d:	8b 40 04             	mov    0x4(%eax),%eax
  802790:	85 c0                	test   %eax,%eax
  802792:	74 0f                	je     8027a3 <alloc_block_BF+0x92>
  802794:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802797:	8b 40 04             	mov    0x4(%eax),%eax
  80279a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80279d:	8b 12                	mov    (%edx),%edx
  80279f:	89 10                	mov    %edx,(%eax)
  8027a1:	eb 0a                	jmp    8027ad <alloc_block_BF+0x9c>
  8027a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a6:	8b 00                	mov    (%eax),%eax
  8027a8:	a3 38 51 80 00       	mov    %eax,0x805138
  8027ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027c0:	a1 44 51 80 00       	mov    0x805144,%eax
  8027c5:	48                   	dec    %eax
  8027c6:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  8027cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ce:	e9 4d 01 00 00       	jmp    802920 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  8027d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d6:	8b 40 0c             	mov    0xc(%eax),%eax
  8027d9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027dc:	76 24                	jbe    802802 <alloc_block_BF+0xf1>
  8027de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e1:	8b 40 0c             	mov    0xc(%eax),%eax
  8027e4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8027e7:	73 19                	jae    802802 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  8027e9:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  8027f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f3:	8b 40 0c             	mov    0xc(%eax),%eax
  8027f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  8027f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027fc:	8b 40 08             	mov    0x8(%eax),%eax
  8027ff:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802802:	a1 40 51 80 00       	mov    0x805140,%eax
  802807:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80280a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80280e:	74 07                	je     802817 <alloc_block_BF+0x106>
  802810:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802813:	8b 00                	mov    (%eax),%eax
  802815:	eb 05                	jmp    80281c <alloc_block_BF+0x10b>
  802817:	b8 00 00 00 00       	mov    $0x0,%eax
  80281c:	a3 40 51 80 00       	mov    %eax,0x805140
  802821:	a1 40 51 80 00       	mov    0x805140,%eax
  802826:	85 c0                	test   %eax,%eax
  802828:	0f 85 fd fe ff ff    	jne    80272b <alloc_block_BF+0x1a>
  80282e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802832:	0f 85 f3 fe ff ff    	jne    80272b <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802838:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80283c:	0f 84 d9 00 00 00    	je     80291b <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802842:	a1 48 51 80 00       	mov    0x805148,%eax
  802847:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  80284a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80284d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802850:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802853:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802856:	8b 55 08             	mov    0x8(%ebp),%edx
  802859:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  80285c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802860:	75 17                	jne    802879 <alloc_block_BF+0x168>
  802862:	83 ec 04             	sub    $0x4,%esp
  802865:	68 64 43 80 00       	push   $0x804364
  80286a:	68 c7 00 00 00       	push   $0xc7
  80286f:	68 bb 42 80 00       	push   $0x8042bb
  802874:	e8 5d dc ff ff       	call   8004d6 <_panic>
  802879:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80287c:	8b 00                	mov    (%eax),%eax
  80287e:	85 c0                	test   %eax,%eax
  802880:	74 10                	je     802892 <alloc_block_BF+0x181>
  802882:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802885:	8b 00                	mov    (%eax),%eax
  802887:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80288a:	8b 52 04             	mov    0x4(%edx),%edx
  80288d:	89 50 04             	mov    %edx,0x4(%eax)
  802890:	eb 0b                	jmp    80289d <alloc_block_BF+0x18c>
  802892:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802895:	8b 40 04             	mov    0x4(%eax),%eax
  802898:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80289d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028a0:	8b 40 04             	mov    0x4(%eax),%eax
  8028a3:	85 c0                	test   %eax,%eax
  8028a5:	74 0f                	je     8028b6 <alloc_block_BF+0x1a5>
  8028a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028aa:	8b 40 04             	mov    0x4(%eax),%eax
  8028ad:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8028b0:	8b 12                	mov    (%edx),%edx
  8028b2:	89 10                	mov    %edx,(%eax)
  8028b4:	eb 0a                	jmp    8028c0 <alloc_block_BF+0x1af>
  8028b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028b9:	8b 00                	mov    (%eax),%eax
  8028bb:	a3 48 51 80 00       	mov    %eax,0x805148
  8028c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028c3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028cc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028d3:	a1 54 51 80 00       	mov    0x805154,%eax
  8028d8:	48                   	dec    %eax
  8028d9:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  8028de:	83 ec 08             	sub    $0x8,%esp
  8028e1:	ff 75 ec             	pushl  -0x14(%ebp)
  8028e4:	68 38 51 80 00       	push   $0x805138
  8028e9:	e8 71 f9 ff ff       	call   80225f <find_block>
  8028ee:	83 c4 10             	add    $0x10,%esp
  8028f1:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  8028f4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028f7:	8b 50 08             	mov    0x8(%eax),%edx
  8028fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8028fd:	01 c2                	add    %eax,%edx
  8028ff:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802902:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802905:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802908:	8b 40 0c             	mov    0xc(%eax),%eax
  80290b:	2b 45 08             	sub    0x8(%ebp),%eax
  80290e:	89 c2                	mov    %eax,%edx
  802910:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802913:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802916:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802919:	eb 05                	jmp    802920 <alloc_block_BF+0x20f>
	}
	return NULL;
  80291b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802920:	c9                   	leave  
  802921:	c3                   	ret    

00802922 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802922:	55                   	push   %ebp
  802923:	89 e5                	mov    %esp,%ebp
  802925:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802928:	a1 28 50 80 00       	mov    0x805028,%eax
  80292d:	85 c0                	test   %eax,%eax
  80292f:	0f 85 de 01 00 00    	jne    802b13 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802935:	a1 38 51 80 00       	mov    0x805138,%eax
  80293a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80293d:	e9 9e 01 00 00       	jmp    802ae0 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802942:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802945:	8b 40 0c             	mov    0xc(%eax),%eax
  802948:	3b 45 08             	cmp    0x8(%ebp),%eax
  80294b:	0f 82 87 01 00 00    	jb     802ad8 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802951:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802954:	8b 40 0c             	mov    0xc(%eax),%eax
  802957:	3b 45 08             	cmp    0x8(%ebp),%eax
  80295a:	0f 85 95 00 00 00    	jne    8029f5 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802960:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802964:	75 17                	jne    80297d <alloc_block_NF+0x5b>
  802966:	83 ec 04             	sub    $0x4,%esp
  802969:	68 64 43 80 00       	push   $0x804364
  80296e:	68 e0 00 00 00       	push   $0xe0
  802973:	68 bb 42 80 00       	push   $0x8042bb
  802978:	e8 59 db ff ff       	call   8004d6 <_panic>
  80297d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802980:	8b 00                	mov    (%eax),%eax
  802982:	85 c0                	test   %eax,%eax
  802984:	74 10                	je     802996 <alloc_block_NF+0x74>
  802986:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802989:	8b 00                	mov    (%eax),%eax
  80298b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80298e:	8b 52 04             	mov    0x4(%edx),%edx
  802991:	89 50 04             	mov    %edx,0x4(%eax)
  802994:	eb 0b                	jmp    8029a1 <alloc_block_NF+0x7f>
  802996:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802999:	8b 40 04             	mov    0x4(%eax),%eax
  80299c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8029a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a4:	8b 40 04             	mov    0x4(%eax),%eax
  8029a7:	85 c0                	test   %eax,%eax
  8029a9:	74 0f                	je     8029ba <alloc_block_NF+0x98>
  8029ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ae:	8b 40 04             	mov    0x4(%eax),%eax
  8029b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029b4:	8b 12                	mov    (%edx),%edx
  8029b6:	89 10                	mov    %edx,(%eax)
  8029b8:	eb 0a                	jmp    8029c4 <alloc_block_NF+0xa2>
  8029ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029bd:	8b 00                	mov    (%eax),%eax
  8029bf:	a3 38 51 80 00       	mov    %eax,0x805138
  8029c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029d7:	a1 44 51 80 00       	mov    0x805144,%eax
  8029dc:	48                   	dec    %eax
  8029dd:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  8029e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e5:	8b 40 08             	mov    0x8(%eax),%eax
  8029e8:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  8029ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f0:	e9 f8 04 00 00       	jmp    802eed <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  8029f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f8:	8b 40 0c             	mov    0xc(%eax),%eax
  8029fb:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029fe:	0f 86 d4 00 00 00    	jbe    802ad8 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802a04:	a1 48 51 80 00       	mov    0x805148,%eax
  802a09:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802a0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0f:	8b 50 08             	mov    0x8(%eax),%edx
  802a12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a15:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802a18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a1b:	8b 55 08             	mov    0x8(%ebp),%edx
  802a1e:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802a21:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a25:	75 17                	jne    802a3e <alloc_block_NF+0x11c>
  802a27:	83 ec 04             	sub    $0x4,%esp
  802a2a:	68 64 43 80 00       	push   $0x804364
  802a2f:	68 e9 00 00 00       	push   $0xe9
  802a34:	68 bb 42 80 00       	push   $0x8042bb
  802a39:	e8 98 da ff ff       	call   8004d6 <_panic>
  802a3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a41:	8b 00                	mov    (%eax),%eax
  802a43:	85 c0                	test   %eax,%eax
  802a45:	74 10                	je     802a57 <alloc_block_NF+0x135>
  802a47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a4a:	8b 00                	mov    (%eax),%eax
  802a4c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a4f:	8b 52 04             	mov    0x4(%edx),%edx
  802a52:	89 50 04             	mov    %edx,0x4(%eax)
  802a55:	eb 0b                	jmp    802a62 <alloc_block_NF+0x140>
  802a57:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a5a:	8b 40 04             	mov    0x4(%eax),%eax
  802a5d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802a62:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a65:	8b 40 04             	mov    0x4(%eax),%eax
  802a68:	85 c0                	test   %eax,%eax
  802a6a:	74 0f                	je     802a7b <alloc_block_NF+0x159>
  802a6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a6f:	8b 40 04             	mov    0x4(%eax),%eax
  802a72:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a75:	8b 12                	mov    (%edx),%edx
  802a77:	89 10                	mov    %edx,(%eax)
  802a79:	eb 0a                	jmp    802a85 <alloc_block_NF+0x163>
  802a7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a7e:	8b 00                	mov    (%eax),%eax
  802a80:	a3 48 51 80 00       	mov    %eax,0x805148
  802a85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a88:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a91:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a98:	a1 54 51 80 00       	mov    0x805154,%eax
  802a9d:	48                   	dec    %eax
  802a9e:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802aa3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aa6:	8b 40 08             	mov    0x8(%eax),%eax
  802aa9:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802aae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab1:	8b 50 08             	mov    0x8(%eax),%edx
  802ab4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab7:	01 c2                	add    %eax,%edx
  802ab9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802abc:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802abf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac2:	8b 40 0c             	mov    0xc(%eax),%eax
  802ac5:	2b 45 08             	sub    0x8(%ebp),%eax
  802ac8:	89 c2                	mov    %eax,%edx
  802aca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802acd:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802ad0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ad3:	e9 15 04 00 00       	jmp    802eed <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802ad8:	a1 40 51 80 00       	mov    0x805140,%eax
  802add:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ae0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ae4:	74 07                	je     802aed <alloc_block_NF+0x1cb>
  802ae6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae9:	8b 00                	mov    (%eax),%eax
  802aeb:	eb 05                	jmp    802af2 <alloc_block_NF+0x1d0>
  802aed:	b8 00 00 00 00       	mov    $0x0,%eax
  802af2:	a3 40 51 80 00       	mov    %eax,0x805140
  802af7:	a1 40 51 80 00       	mov    0x805140,%eax
  802afc:	85 c0                	test   %eax,%eax
  802afe:	0f 85 3e fe ff ff    	jne    802942 <alloc_block_NF+0x20>
  802b04:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b08:	0f 85 34 fe ff ff    	jne    802942 <alloc_block_NF+0x20>
  802b0e:	e9 d5 03 00 00       	jmp    802ee8 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802b13:	a1 38 51 80 00       	mov    0x805138,%eax
  802b18:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b1b:	e9 b1 01 00 00       	jmp    802cd1 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802b20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b23:	8b 50 08             	mov    0x8(%eax),%edx
  802b26:	a1 28 50 80 00       	mov    0x805028,%eax
  802b2b:	39 c2                	cmp    %eax,%edx
  802b2d:	0f 82 96 01 00 00    	jb     802cc9 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802b33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b36:	8b 40 0c             	mov    0xc(%eax),%eax
  802b39:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b3c:	0f 82 87 01 00 00    	jb     802cc9 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802b42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b45:	8b 40 0c             	mov    0xc(%eax),%eax
  802b48:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b4b:	0f 85 95 00 00 00    	jne    802be6 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802b51:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b55:	75 17                	jne    802b6e <alloc_block_NF+0x24c>
  802b57:	83 ec 04             	sub    $0x4,%esp
  802b5a:	68 64 43 80 00       	push   $0x804364
  802b5f:	68 fc 00 00 00       	push   $0xfc
  802b64:	68 bb 42 80 00       	push   $0x8042bb
  802b69:	e8 68 d9 ff ff       	call   8004d6 <_panic>
  802b6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b71:	8b 00                	mov    (%eax),%eax
  802b73:	85 c0                	test   %eax,%eax
  802b75:	74 10                	je     802b87 <alloc_block_NF+0x265>
  802b77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b7a:	8b 00                	mov    (%eax),%eax
  802b7c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b7f:	8b 52 04             	mov    0x4(%edx),%edx
  802b82:	89 50 04             	mov    %edx,0x4(%eax)
  802b85:	eb 0b                	jmp    802b92 <alloc_block_NF+0x270>
  802b87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8a:	8b 40 04             	mov    0x4(%eax),%eax
  802b8d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802b92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b95:	8b 40 04             	mov    0x4(%eax),%eax
  802b98:	85 c0                	test   %eax,%eax
  802b9a:	74 0f                	je     802bab <alloc_block_NF+0x289>
  802b9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9f:	8b 40 04             	mov    0x4(%eax),%eax
  802ba2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ba5:	8b 12                	mov    (%edx),%edx
  802ba7:	89 10                	mov    %edx,(%eax)
  802ba9:	eb 0a                	jmp    802bb5 <alloc_block_NF+0x293>
  802bab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bae:	8b 00                	mov    (%eax),%eax
  802bb0:	a3 38 51 80 00       	mov    %eax,0x805138
  802bb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bc8:	a1 44 51 80 00       	mov    0x805144,%eax
  802bcd:	48                   	dec    %eax
  802bce:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802bd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd6:	8b 40 08             	mov    0x8(%eax),%eax
  802bd9:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802bde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be1:	e9 07 03 00 00       	jmp    802eed <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802be6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be9:	8b 40 0c             	mov    0xc(%eax),%eax
  802bec:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bef:	0f 86 d4 00 00 00    	jbe    802cc9 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802bf5:	a1 48 51 80 00       	mov    0x805148,%eax
  802bfa:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802bfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c00:	8b 50 08             	mov    0x8(%eax),%edx
  802c03:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c06:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802c09:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c0c:	8b 55 08             	mov    0x8(%ebp),%edx
  802c0f:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802c12:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802c16:	75 17                	jne    802c2f <alloc_block_NF+0x30d>
  802c18:	83 ec 04             	sub    $0x4,%esp
  802c1b:	68 64 43 80 00       	push   $0x804364
  802c20:	68 04 01 00 00       	push   $0x104
  802c25:	68 bb 42 80 00       	push   $0x8042bb
  802c2a:	e8 a7 d8 ff ff       	call   8004d6 <_panic>
  802c2f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c32:	8b 00                	mov    (%eax),%eax
  802c34:	85 c0                	test   %eax,%eax
  802c36:	74 10                	je     802c48 <alloc_block_NF+0x326>
  802c38:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c3b:	8b 00                	mov    (%eax),%eax
  802c3d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802c40:	8b 52 04             	mov    0x4(%edx),%edx
  802c43:	89 50 04             	mov    %edx,0x4(%eax)
  802c46:	eb 0b                	jmp    802c53 <alloc_block_NF+0x331>
  802c48:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c4b:	8b 40 04             	mov    0x4(%eax),%eax
  802c4e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802c53:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c56:	8b 40 04             	mov    0x4(%eax),%eax
  802c59:	85 c0                	test   %eax,%eax
  802c5b:	74 0f                	je     802c6c <alloc_block_NF+0x34a>
  802c5d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c60:	8b 40 04             	mov    0x4(%eax),%eax
  802c63:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802c66:	8b 12                	mov    (%edx),%edx
  802c68:	89 10                	mov    %edx,(%eax)
  802c6a:	eb 0a                	jmp    802c76 <alloc_block_NF+0x354>
  802c6c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c6f:	8b 00                	mov    (%eax),%eax
  802c71:	a3 48 51 80 00       	mov    %eax,0x805148
  802c76:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c79:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c7f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c82:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c89:	a1 54 51 80 00       	mov    0x805154,%eax
  802c8e:	48                   	dec    %eax
  802c8f:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802c94:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c97:	8b 40 08             	mov    0x8(%eax),%eax
  802c9a:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802c9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca2:	8b 50 08             	mov    0x8(%eax),%edx
  802ca5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca8:	01 c2                	add    %eax,%edx
  802caa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cad:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802cb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb3:	8b 40 0c             	mov    0xc(%eax),%eax
  802cb6:	2b 45 08             	sub    0x8(%ebp),%eax
  802cb9:	89 c2                	mov    %eax,%edx
  802cbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cbe:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802cc1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cc4:	e9 24 02 00 00       	jmp    802eed <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802cc9:	a1 40 51 80 00       	mov    0x805140,%eax
  802cce:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cd1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cd5:	74 07                	je     802cde <alloc_block_NF+0x3bc>
  802cd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cda:	8b 00                	mov    (%eax),%eax
  802cdc:	eb 05                	jmp    802ce3 <alloc_block_NF+0x3c1>
  802cde:	b8 00 00 00 00       	mov    $0x0,%eax
  802ce3:	a3 40 51 80 00       	mov    %eax,0x805140
  802ce8:	a1 40 51 80 00       	mov    0x805140,%eax
  802ced:	85 c0                	test   %eax,%eax
  802cef:	0f 85 2b fe ff ff    	jne    802b20 <alloc_block_NF+0x1fe>
  802cf5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cf9:	0f 85 21 fe ff ff    	jne    802b20 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802cff:	a1 38 51 80 00       	mov    0x805138,%eax
  802d04:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d07:	e9 ae 01 00 00       	jmp    802eba <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802d0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0f:	8b 50 08             	mov    0x8(%eax),%edx
  802d12:	a1 28 50 80 00       	mov    0x805028,%eax
  802d17:	39 c2                	cmp    %eax,%edx
  802d19:	0f 83 93 01 00 00    	jae    802eb2 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802d1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d22:	8b 40 0c             	mov    0xc(%eax),%eax
  802d25:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d28:	0f 82 84 01 00 00    	jb     802eb2 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802d2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d31:	8b 40 0c             	mov    0xc(%eax),%eax
  802d34:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d37:	0f 85 95 00 00 00    	jne    802dd2 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802d3d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d41:	75 17                	jne    802d5a <alloc_block_NF+0x438>
  802d43:	83 ec 04             	sub    $0x4,%esp
  802d46:	68 64 43 80 00       	push   $0x804364
  802d4b:	68 14 01 00 00       	push   $0x114
  802d50:	68 bb 42 80 00       	push   $0x8042bb
  802d55:	e8 7c d7 ff ff       	call   8004d6 <_panic>
  802d5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d5d:	8b 00                	mov    (%eax),%eax
  802d5f:	85 c0                	test   %eax,%eax
  802d61:	74 10                	je     802d73 <alloc_block_NF+0x451>
  802d63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d66:	8b 00                	mov    (%eax),%eax
  802d68:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d6b:	8b 52 04             	mov    0x4(%edx),%edx
  802d6e:	89 50 04             	mov    %edx,0x4(%eax)
  802d71:	eb 0b                	jmp    802d7e <alloc_block_NF+0x45c>
  802d73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d76:	8b 40 04             	mov    0x4(%eax),%eax
  802d79:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d81:	8b 40 04             	mov    0x4(%eax),%eax
  802d84:	85 c0                	test   %eax,%eax
  802d86:	74 0f                	je     802d97 <alloc_block_NF+0x475>
  802d88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d8b:	8b 40 04             	mov    0x4(%eax),%eax
  802d8e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d91:	8b 12                	mov    (%edx),%edx
  802d93:	89 10                	mov    %edx,(%eax)
  802d95:	eb 0a                	jmp    802da1 <alloc_block_NF+0x47f>
  802d97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d9a:	8b 00                	mov    (%eax),%eax
  802d9c:	a3 38 51 80 00       	mov    %eax,0x805138
  802da1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802daa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dad:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802db4:	a1 44 51 80 00       	mov    0x805144,%eax
  802db9:	48                   	dec    %eax
  802dba:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802dbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc2:	8b 40 08             	mov    0x8(%eax),%eax
  802dc5:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802dca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dcd:	e9 1b 01 00 00       	jmp    802eed <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802dd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd5:	8b 40 0c             	mov    0xc(%eax),%eax
  802dd8:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ddb:	0f 86 d1 00 00 00    	jbe    802eb2 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802de1:	a1 48 51 80 00       	mov    0x805148,%eax
  802de6:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802de9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dec:	8b 50 08             	mov    0x8(%eax),%edx
  802def:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802df2:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802df5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802df8:	8b 55 08             	mov    0x8(%ebp),%edx
  802dfb:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802dfe:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802e02:	75 17                	jne    802e1b <alloc_block_NF+0x4f9>
  802e04:	83 ec 04             	sub    $0x4,%esp
  802e07:	68 64 43 80 00       	push   $0x804364
  802e0c:	68 1c 01 00 00       	push   $0x11c
  802e11:	68 bb 42 80 00       	push   $0x8042bb
  802e16:	e8 bb d6 ff ff       	call   8004d6 <_panic>
  802e1b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e1e:	8b 00                	mov    (%eax),%eax
  802e20:	85 c0                	test   %eax,%eax
  802e22:	74 10                	je     802e34 <alloc_block_NF+0x512>
  802e24:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e27:	8b 00                	mov    (%eax),%eax
  802e29:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802e2c:	8b 52 04             	mov    0x4(%edx),%edx
  802e2f:	89 50 04             	mov    %edx,0x4(%eax)
  802e32:	eb 0b                	jmp    802e3f <alloc_block_NF+0x51d>
  802e34:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e37:	8b 40 04             	mov    0x4(%eax),%eax
  802e3a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e3f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e42:	8b 40 04             	mov    0x4(%eax),%eax
  802e45:	85 c0                	test   %eax,%eax
  802e47:	74 0f                	je     802e58 <alloc_block_NF+0x536>
  802e49:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e4c:	8b 40 04             	mov    0x4(%eax),%eax
  802e4f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802e52:	8b 12                	mov    (%edx),%edx
  802e54:	89 10                	mov    %edx,(%eax)
  802e56:	eb 0a                	jmp    802e62 <alloc_block_NF+0x540>
  802e58:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e5b:	8b 00                	mov    (%eax),%eax
  802e5d:	a3 48 51 80 00       	mov    %eax,0x805148
  802e62:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e65:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e6b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e6e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e75:	a1 54 51 80 00       	mov    0x805154,%eax
  802e7a:	48                   	dec    %eax
  802e7b:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802e80:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e83:	8b 40 08             	mov    0x8(%eax),%eax
  802e86:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802e8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e8e:	8b 50 08             	mov    0x8(%eax),%edx
  802e91:	8b 45 08             	mov    0x8(%ebp),%eax
  802e94:	01 c2                	add    %eax,%edx
  802e96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e99:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802e9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e9f:	8b 40 0c             	mov    0xc(%eax),%eax
  802ea2:	2b 45 08             	sub    0x8(%ebp),%eax
  802ea5:	89 c2                	mov    %eax,%edx
  802ea7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eaa:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802ead:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802eb0:	eb 3b                	jmp    802eed <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802eb2:	a1 40 51 80 00       	mov    0x805140,%eax
  802eb7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802eba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ebe:	74 07                	je     802ec7 <alloc_block_NF+0x5a5>
  802ec0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec3:	8b 00                	mov    (%eax),%eax
  802ec5:	eb 05                	jmp    802ecc <alloc_block_NF+0x5aa>
  802ec7:	b8 00 00 00 00       	mov    $0x0,%eax
  802ecc:	a3 40 51 80 00       	mov    %eax,0x805140
  802ed1:	a1 40 51 80 00       	mov    0x805140,%eax
  802ed6:	85 c0                	test   %eax,%eax
  802ed8:	0f 85 2e fe ff ff    	jne    802d0c <alloc_block_NF+0x3ea>
  802ede:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ee2:	0f 85 24 fe ff ff    	jne    802d0c <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802ee8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802eed:	c9                   	leave  
  802eee:	c3                   	ret    

00802eef <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802eef:	55                   	push   %ebp
  802ef0:	89 e5                	mov    %esp,%ebp
  802ef2:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802ef5:	a1 38 51 80 00       	mov    0x805138,%eax
  802efa:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802efd:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802f02:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802f05:	a1 38 51 80 00       	mov    0x805138,%eax
  802f0a:	85 c0                	test   %eax,%eax
  802f0c:	74 14                	je     802f22 <insert_sorted_with_merge_freeList+0x33>
  802f0e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f11:	8b 50 08             	mov    0x8(%eax),%edx
  802f14:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f17:	8b 40 08             	mov    0x8(%eax),%eax
  802f1a:	39 c2                	cmp    %eax,%edx
  802f1c:	0f 87 9b 01 00 00    	ja     8030bd <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802f22:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f26:	75 17                	jne    802f3f <insert_sorted_with_merge_freeList+0x50>
  802f28:	83 ec 04             	sub    $0x4,%esp
  802f2b:	68 98 42 80 00       	push   $0x804298
  802f30:	68 38 01 00 00       	push   $0x138
  802f35:	68 bb 42 80 00       	push   $0x8042bb
  802f3a:	e8 97 d5 ff ff       	call   8004d6 <_panic>
  802f3f:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802f45:	8b 45 08             	mov    0x8(%ebp),%eax
  802f48:	89 10                	mov    %edx,(%eax)
  802f4a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4d:	8b 00                	mov    (%eax),%eax
  802f4f:	85 c0                	test   %eax,%eax
  802f51:	74 0d                	je     802f60 <insert_sorted_with_merge_freeList+0x71>
  802f53:	a1 38 51 80 00       	mov    0x805138,%eax
  802f58:	8b 55 08             	mov    0x8(%ebp),%edx
  802f5b:	89 50 04             	mov    %edx,0x4(%eax)
  802f5e:	eb 08                	jmp    802f68 <insert_sorted_with_merge_freeList+0x79>
  802f60:	8b 45 08             	mov    0x8(%ebp),%eax
  802f63:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f68:	8b 45 08             	mov    0x8(%ebp),%eax
  802f6b:	a3 38 51 80 00       	mov    %eax,0x805138
  802f70:	8b 45 08             	mov    0x8(%ebp),%eax
  802f73:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f7a:	a1 44 51 80 00       	mov    0x805144,%eax
  802f7f:	40                   	inc    %eax
  802f80:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802f85:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f89:	0f 84 a8 06 00 00    	je     803637 <insert_sorted_with_merge_freeList+0x748>
  802f8f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f92:	8b 50 08             	mov    0x8(%eax),%edx
  802f95:	8b 45 08             	mov    0x8(%ebp),%eax
  802f98:	8b 40 0c             	mov    0xc(%eax),%eax
  802f9b:	01 c2                	add    %eax,%edx
  802f9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fa0:	8b 40 08             	mov    0x8(%eax),%eax
  802fa3:	39 c2                	cmp    %eax,%edx
  802fa5:	0f 85 8c 06 00 00    	jne    803637 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802fab:	8b 45 08             	mov    0x8(%ebp),%eax
  802fae:	8b 50 0c             	mov    0xc(%eax),%edx
  802fb1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fb4:	8b 40 0c             	mov    0xc(%eax),%eax
  802fb7:	01 c2                	add    %eax,%edx
  802fb9:	8b 45 08             	mov    0x8(%ebp),%eax
  802fbc:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802fbf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802fc3:	75 17                	jne    802fdc <insert_sorted_with_merge_freeList+0xed>
  802fc5:	83 ec 04             	sub    $0x4,%esp
  802fc8:	68 64 43 80 00       	push   $0x804364
  802fcd:	68 3c 01 00 00       	push   $0x13c
  802fd2:	68 bb 42 80 00       	push   $0x8042bb
  802fd7:	e8 fa d4 ff ff       	call   8004d6 <_panic>
  802fdc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fdf:	8b 00                	mov    (%eax),%eax
  802fe1:	85 c0                	test   %eax,%eax
  802fe3:	74 10                	je     802ff5 <insert_sorted_with_merge_freeList+0x106>
  802fe5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fe8:	8b 00                	mov    (%eax),%eax
  802fea:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802fed:	8b 52 04             	mov    0x4(%edx),%edx
  802ff0:	89 50 04             	mov    %edx,0x4(%eax)
  802ff3:	eb 0b                	jmp    803000 <insert_sorted_with_merge_freeList+0x111>
  802ff5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ff8:	8b 40 04             	mov    0x4(%eax),%eax
  802ffb:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803000:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803003:	8b 40 04             	mov    0x4(%eax),%eax
  803006:	85 c0                	test   %eax,%eax
  803008:	74 0f                	je     803019 <insert_sorted_with_merge_freeList+0x12a>
  80300a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80300d:	8b 40 04             	mov    0x4(%eax),%eax
  803010:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803013:	8b 12                	mov    (%edx),%edx
  803015:	89 10                	mov    %edx,(%eax)
  803017:	eb 0a                	jmp    803023 <insert_sorted_with_merge_freeList+0x134>
  803019:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80301c:	8b 00                	mov    (%eax),%eax
  80301e:	a3 38 51 80 00       	mov    %eax,0x805138
  803023:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803026:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80302c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80302f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803036:	a1 44 51 80 00       	mov    0x805144,%eax
  80303b:	48                   	dec    %eax
  80303c:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  803041:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803044:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  80304b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80304e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  803055:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803059:	75 17                	jne    803072 <insert_sorted_with_merge_freeList+0x183>
  80305b:	83 ec 04             	sub    $0x4,%esp
  80305e:	68 98 42 80 00       	push   $0x804298
  803063:	68 3f 01 00 00       	push   $0x13f
  803068:	68 bb 42 80 00       	push   $0x8042bb
  80306d:	e8 64 d4 ff ff       	call   8004d6 <_panic>
  803072:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803078:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80307b:	89 10                	mov    %edx,(%eax)
  80307d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803080:	8b 00                	mov    (%eax),%eax
  803082:	85 c0                	test   %eax,%eax
  803084:	74 0d                	je     803093 <insert_sorted_with_merge_freeList+0x1a4>
  803086:	a1 48 51 80 00       	mov    0x805148,%eax
  80308b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80308e:	89 50 04             	mov    %edx,0x4(%eax)
  803091:	eb 08                	jmp    80309b <insert_sorted_with_merge_freeList+0x1ac>
  803093:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803096:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80309b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80309e:	a3 48 51 80 00       	mov    %eax,0x805148
  8030a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030a6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030ad:	a1 54 51 80 00       	mov    0x805154,%eax
  8030b2:	40                   	inc    %eax
  8030b3:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8030b8:	e9 7a 05 00 00       	jmp    803637 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  8030bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c0:	8b 50 08             	mov    0x8(%eax),%edx
  8030c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030c6:	8b 40 08             	mov    0x8(%eax),%eax
  8030c9:	39 c2                	cmp    %eax,%edx
  8030cb:	0f 82 14 01 00 00    	jb     8031e5 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  8030d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030d4:	8b 50 08             	mov    0x8(%eax),%edx
  8030d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030da:	8b 40 0c             	mov    0xc(%eax),%eax
  8030dd:	01 c2                	add    %eax,%edx
  8030df:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e2:	8b 40 08             	mov    0x8(%eax),%eax
  8030e5:	39 c2                	cmp    %eax,%edx
  8030e7:	0f 85 90 00 00 00    	jne    80317d <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  8030ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030f0:	8b 50 0c             	mov    0xc(%eax),%edx
  8030f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f6:	8b 40 0c             	mov    0xc(%eax),%eax
  8030f9:	01 c2                	add    %eax,%edx
  8030fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030fe:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  803101:	8b 45 08             	mov    0x8(%ebp),%eax
  803104:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  80310b:	8b 45 08             	mov    0x8(%ebp),%eax
  80310e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803115:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803119:	75 17                	jne    803132 <insert_sorted_with_merge_freeList+0x243>
  80311b:	83 ec 04             	sub    $0x4,%esp
  80311e:	68 98 42 80 00       	push   $0x804298
  803123:	68 49 01 00 00       	push   $0x149
  803128:	68 bb 42 80 00       	push   $0x8042bb
  80312d:	e8 a4 d3 ff ff       	call   8004d6 <_panic>
  803132:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803138:	8b 45 08             	mov    0x8(%ebp),%eax
  80313b:	89 10                	mov    %edx,(%eax)
  80313d:	8b 45 08             	mov    0x8(%ebp),%eax
  803140:	8b 00                	mov    (%eax),%eax
  803142:	85 c0                	test   %eax,%eax
  803144:	74 0d                	je     803153 <insert_sorted_with_merge_freeList+0x264>
  803146:	a1 48 51 80 00       	mov    0x805148,%eax
  80314b:	8b 55 08             	mov    0x8(%ebp),%edx
  80314e:	89 50 04             	mov    %edx,0x4(%eax)
  803151:	eb 08                	jmp    80315b <insert_sorted_with_merge_freeList+0x26c>
  803153:	8b 45 08             	mov    0x8(%ebp),%eax
  803156:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80315b:	8b 45 08             	mov    0x8(%ebp),%eax
  80315e:	a3 48 51 80 00       	mov    %eax,0x805148
  803163:	8b 45 08             	mov    0x8(%ebp),%eax
  803166:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80316d:	a1 54 51 80 00       	mov    0x805154,%eax
  803172:	40                   	inc    %eax
  803173:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803178:	e9 bb 04 00 00       	jmp    803638 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  80317d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803181:	75 17                	jne    80319a <insert_sorted_with_merge_freeList+0x2ab>
  803183:	83 ec 04             	sub    $0x4,%esp
  803186:	68 0c 43 80 00       	push   $0x80430c
  80318b:	68 4c 01 00 00       	push   $0x14c
  803190:	68 bb 42 80 00       	push   $0x8042bb
  803195:	e8 3c d3 ff ff       	call   8004d6 <_panic>
  80319a:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  8031a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a3:	89 50 04             	mov    %edx,0x4(%eax)
  8031a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a9:	8b 40 04             	mov    0x4(%eax),%eax
  8031ac:	85 c0                	test   %eax,%eax
  8031ae:	74 0c                	je     8031bc <insert_sorted_with_merge_freeList+0x2cd>
  8031b0:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8031b5:	8b 55 08             	mov    0x8(%ebp),%edx
  8031b8:	89 10                	mov    %edx,(%eax)
  8031ba:	eb 08                	jmp    8031c4 <insert_sorted_with_merge_freeList+0x2d5>
  8031bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8031bf:	a3 38 51 80 00       	mov    %eax,0x805138
  8031c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c7:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8031cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8031cf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031d5:	a1 44 51 80 00       	mov    0x805144,%eax
  8031da:	40                   	inc    %eax
  8031db:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8031e0:	e9 53 04 00 00       	jmp    803638 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8031e5:	a1 38 51 80 00       	mov    0x805138,%eax
  8031ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031ed:	e9 15 04 00 00       	jmp    803607 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  8031f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031f5:	8b 00                	mov    (%eax),%eax
  8031f7:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  8031fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8031fd:	8b 50 08             	mov    0x8(%eax),%edx
  803200:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803203:	8b 40 08             	mov    0x8(%eax),%eax
  803206:	39 c2                	cmp    %eax,%edx
  803208:	0f 86 f1 03 00 00    	jbe    8035ff <insert_sorted_with_merge_freeList+0x710>
  80320e:	8b 45 08             	mov    0x8(%ebp),%eax
  803211:	8b 50 08             	mov    0x8(%eax),%edx
  803214:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803217:	8b 40 08             	mov    0x8(%eax),%eax
  80321a:	39 c2                	cmp    %eax,%edx
  80321c:	0f 83 dd 03 00 00    	jae    8035ff <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  803222:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803225:	8b 50 08             	mov    0x8(%eax),%edx
  803228:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80322b:	8b 40 0c             	mov    0xc(%eax),%eax
  80322e:	01 c2                	add    %eax,%edx
  803230:	8b 45 08             	mov    0x8(%ebp),%eax
  803233:	8b 40 08             	mov    0x8(%eax),%eax
  803236:	39 c2                	cmp    %eax,%edx
  803238:	0f 85 b9 01 00 00    	jne    8033f7 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  80323e:	8b 45 08             	mov    0x8(%ebp),%eax
  803241:	8b 50 08             	mov    0x8(%eax),%edx
  803244:	8b 45 08             	mov    0x8(%ebp),%eax
  803247:	8b 40 0c             	mov    0xc(%eax),%eax
  80324a:	01 c2                	add    %eax,%edx
  80324c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80324f:	8b 40 08             	mov    0x8(%eax),%eax
  803252:	39 c2                	cmp    %eax,%edx
  803254:	0f 85 0d 01 00 00    	jne    803367 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  80325a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80325d:	8b 50 0c             	mov    0xc(%eax),%edx
  803260:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803263:	8b 40 0c             	mov    0xc(%eax),%eax
  803266:	01 c2                	add    %eax,%edx
  803268:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80326b:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80326e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803272:	75 17                	jne    80328b <insert_sorted_with_merge_freeList+0x39c>
  803274:	83 ec 04             	sub    $0x4,%esp
  803277:	68 64 43 80 00       	push   $0x804364
  80327c:	68 5c 01 00 00       	push   $0x15c
  803281:	68 bb 42 80 00       	push   $0x8042bb
  803286:	e8 4b d2 ff ff       	call   8004d6 <_panic>
  80328b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80328e:	8b 00                	mov    (%eax),%eax
  803290:	85 c0                	test   %eax,%eax
  803292:	74 10                	je     8032a4 <insert_sorted_with_merge_freeList+0x3b5>
  803294:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803297:	8b 00                	mov    (%eax),%eax
  803299:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80329c:	8b 52 04             	mov    0x4(%edx),%edx
  80329f:	89 50 04             	mov    %edx,0x4(%eax)
  8032a2:	eb 0b                	jmp    8032af <insert_sorted_with_merge_freeList+0x3c0>
  8032a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032a7:	8b 40 04             	mov    0x4(%eax),%eax
  8032aa:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8032af:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032b2:	8b 40 04             	mov    0x4(%eax),%eax
  8032b5:	85 c0                	test   %eax,%eax
  8032b7:	74 0f                	je     8032c8 <insert_sorted_with_merge_freeList+0x3d9>
  8032b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032bc:	8b 40 04             	mov    0x4(%eax),%eax
  8032bf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032c2:	8b 12                	mov    (%edx),%edx
  8032c4:	89 10                	mov    %edx,(%eax)
  8032c6:	eb 0a                	jmp    8032d2 <insert_sorted_with_merge_freeList+0x3e3>
  8032c8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032cb:	8b 00                	mov    (%eax),%eax
  8032cd:	a3 38 51 80 00       	mov    %eax,0x805138
  8032d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032d5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032db:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032de:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032e5:	a1 44 51 80 00       	mov    0x805144,%eax
  8032ea:	48                   	dec    %eax
  8032eb:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  8032f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032f3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  8032fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032fd:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803304:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803308:	75 17                	jne    803321 <insert_sorted_with_merge_freeList+0x432>
  80330a:	83 ec 04             	sub    $0x4,%esp
  80330d:	68 98 42 80 00       	push   $0x804298
  803312:	68 5f 01 00 00       	push   $0x15f
  803317:	68 bb 42 80 00       	push   $0x8042bb
  80331c:	e8 b5 d1 ff ff       	call   8004d6 <_panic>
  803321:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803327:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80332a:	89 10                	mov    %edx,(%eax)
  80332c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80332f:	8b 00                	mov    (%eax),%eax
  803331:	85 c0                	test   %eax,%eax
  803333:	74 0d                	je     803342 <insert_sorted_with_merge_freeList+0x453>
  803335:	a1 48 51 80 00       	mov    0x805148,%eax
  80333a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80333d:	89 50 04             	mov    %edx,0x4(%eax)
  803340:	eb 08                	jmp    80334a <insert_sorted_with_merge_freeList+0x45b>
  803342:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803345:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80334a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80334d:	a3 48 51 80 00       	mov    %eax,0x805148
  803352:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803355:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80335c:	a1 54 51 80 00       	mov    0x805154,%eax
  803361:	40                   	inc    %eax
  803362:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803367:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80336a:	8b 50 0c             	mov    0xc(%eax),%edx
  80336d:	8b 45 08             	mov    0x8(%ebp),%eax
  803370:	8b 40 0c             	mov    0xc(%eax),%eax
  803373:	01 c2                	add    %eax,%edx
  803375:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803378:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  80337b:	8b 45 08             	mov    0x8(%ebp),%eax
  80337e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803385:	8b 45 08             	mov    0x8(%ebp),%eax
  803388:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80338f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803393:	75 17                	jne    8033ac <insert_sorted_with_merge_freeList+0x4bd>
  803395:	83 ec 04             	sub    $0x4,%esp
  803398:	68 98 42 80 00       	push   $0x804298
  80339d:	68 64 01 00 00       	push   $0x164
  8033a2:	68 bb 42 80 00       	push   $0x8042bb
  8033a7:	e8 2a d1 ff ff       	call   8004d6 <_panic>
  8033ac:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8033b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b5:	89 10                	mov    %edx,(%eax)
  8033b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ba:	8b 00                	mov    (%eax),%eax
  8033bc:	85 c0                	test   %eax,%eax
  8033be:	74 0d                	je     8033cd <insert_sorted_with_merge_freeList+0x4de>
  8033c0:	a1 48 51 80 00       	mov    0x805148,%eax
  8033c5:	8b 55 08             	mov    0x8(%ebp),%edx
  8033c8:	89 50 04             	mov    %edx,0x4(%eax)
  8033cb:	eb 08                	jmp    8033d5 <insert_sorted_with_merge_freeList+0x4e6>
  8033cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d0:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8033d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d8:	a3 48 51 80 00       	mov    %eax,0x805148
  8033dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033e7:	a1 54 51 80 00       	mov    0x805154,%eax
  8033ec:	40                   	inc    %eax
  8033ed:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8033f2:	e9 41 02 00 00       	jmp    803638 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8033f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8033fa:	8b 50 08             	mov    0x8(%eax),%edx
  8033fd:	8b 45 08             	mov    0x8(%ebp),%eax
  803400:	8b 40 0c             	mov    0xc(%eax),%eax
  803403:	01 c2                	add    %eax,%edx
  803405:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803408:	8b 40 08             	mov    0x8(%eax),%eax
  80340b:	39 c2                	cmp    %eax,%edx
  80340d:	0f 85 7c 01 00 00    	jne    80358f <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803413:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803417:	74 06                	je     80341f <insert_sorted_with_merge_freeList+0x530>
  803419:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80341d:	75 17                	jne    803436 <insert_sorted_with_merge_freeList+0x547>
  80341f:	83 ec 04             	sub    $0x4,%esp
  803422:	68 d4 42 80 00       	push   $0x8042d4
  803427:	68 69 01 00 00       	push   $0x169
  80342c:	68 bb 42 80 00       	push   $0x8042bb
  803431:	e8 a0 d0 ff ff       	call   8004d6 <_panic>
  803436:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803439:	8b 50 04             	mov    0x4(%eax),%edx
  80343c:	8b 45 08             	mov    0x8(%ebp),%eax
  80343f:	89 50 04             	mov    %edx,0x4(%eax)
  803442:	8b 45 08             	mov    0x8(%ebp),%eax
  803445:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803448:	89 10                	mov    %edx,(%eax)
  80344a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80344d:	8b 40 04             	mov    0x4(%eax),%eax
  803450:	85 c0                	test   %eax,%eax
  803452:	74 0d                	je     803461 <insert_sorted_with_merge_freeList+0x572>
  803454:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803457:	8b 40 04             	mov    0x4(%eax),%eax
  80345a:	8b 55 08             	mov    0x8(%ebp),%edx
  80345d:	89 10                	mov    %edx,(%eax)
  80345f:	eb 08                	jmp    803469 <insert_sorted_with_merge_freeList+0x57a>
  803461:	8b 45 08             	mov    0x8(%ebp),%eax
  803464:	a3 38 51 80 00       	mov    %eax,0x805138
  803469:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80346c:	8b 55 08             	mov    0x8(%ebp),%edx
  80346f:	89 50 04             	mov    %edx,0x4(%eax)
  803472:	a1 44 51 80 00       	mov    0x805144,%eax
  803477:	40                   	inc    %eax
  803478:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  80347d:	8b 45 08             	mov    0x8(%ebp),%eax
  803480:	8b 50 0c             	mov    0xc(%eax),%edx
  803483:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803486:	8b 40 0c             	mov    0xc(%eax),%eax
  803489:	01 c2                	add    %eax,%edx
  80348b:	8b 45 08             	mov    0x8(%ebp),%eax
  80348e:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803491:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803495:	75 17                	jne    8034ae <insert_sorted_with_merge_freeList+0x5bf>
  803497:	83 ec 04             	sub    $0x4,%esp
  80349a:	68 64 43 80 00       	push   $0x804364
  80349f:	68 6b 01 00 00       	push   $0x16b
  8034a4:	68 bb 42 80 00       	push   $0x8042bb
  8034a9:	e8 28 d0 ff ff       	call   8004d6 <_panic>
  8034ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034b1:	8b 00                	mov    (%eax),%eax
  8034b3:	85 c0                	test   %eax,%eax
  8034b5:	74 10                	je     8034c7 <insert_sorted_with_merge_freeList+0x5d8>
  8034b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034ba:	8b 00                	mov    (%eax),%eax
  8034bc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8034bf:	8b 52 04             	mov    0x4(%edx),%edx
  8034c2:	89 50 04             	mov    %edx,0x4(%eax)
  8034c5:	eb 0b                	jmp    8034d2 <insert_sorted_with_merge_freeList+0x5e3>
  8034c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034ca:	8b 40 04             	mov    0x4(%eax),%eax
  8034cd:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8034d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034d5:	8b 40 04             	mov    0x4(%eax),%eax
  8034d8:	85 c0                	test   %eax,%eax
  8034da:	74 0f                	je     8034eb <insert_sorted_with_merge_freeList+0x5fc>
  8034dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034df:	8b 40 04             	mov    0x4(%eax),%eax
  8034e2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8034e5:	8b 12                	mov    (%edx),%edx
  8034e7:	89 10                	mov    %edx,(%eax)
  8034e9:	eb 0a                	jmp    8034f5 <insert_sorted_with_merge_freeList+0x606>
  8034eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034ee:	8b 00                	mov    (%eax),%eax
  8034f0:	a3 38 51 80 00       	mov    %eax,0x805138
  8034f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034f8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803501:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803508:	a1 44 51 80 00       	mov    0x805144,%eax
  80350d:	48                   	dec    %eax
  80350e:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803513:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803516:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  80351d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803520:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803527:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80352b:	75 17                	jne    803544 <insert_sorted_with_merge_freeList+0x655>
  80352d:	83 ec 04             	sub    $0x4,%esp
  803530:	68 98 42 80 00       	push   $0x804298
  803535:	68 6e 01 00 00       	push   $0x16e
  80353a:	68 bb 42 80 00       	push   $0x8042bb
  80353f:	e8 92 cf ff ff       	call   8004d6 <_panic>
  803544:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80354a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80354d:	89 10                	mov    %edx,(%eax)
  80354f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803552:	8b 00                	mov    (%eax),%eax
  803554:	85 c0                	test   %eax,%eax
  803556:	74 0d                	je     803565 <insert_sorted_with_merge_freeList+0x676>
  803558:	a1 48 51 80 00       	mov    0x805148,%eax
  80355d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803560:	89 50 04             	mov    %edx,0x4(%eax)
  803563:	eb 08                	jmp    80356d <insert_sorted_with_merge_freeList+0x67e>
  803565:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803568:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80356d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803570:	a3 48 51 80 00       	mov    %eax,0x805148
  803575:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803578:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80357f:	a1 54 51 80 00       	mov    0x805154,%eax
  803584:	40                   	inc    %eax
  803585:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  80358a:	e9 a9 00 00 00       	jmp    803638 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  80358f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803593:	74 06                	je     80359b <insert_sorted_with_merge_freeList+0x6ac>
  803595:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803599:	75 17                	jne    8035b2 <insert_sorted_with_merge_freeList+0x6c3>
  80359b:	83 ec 04             	sub    $0x4,%esp
  80359e:	68 30 43 80 00       	push   $0x804330
  8035a3:	68 73 01 00 00       	push   $0x173
  8035a8:	68 bb 42 80 00       	push   $0x8042bb
  8035ad:	e8 24 cf ff ff       	call   8004d6 <_panic>
  8035b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035b5:	8b 10                	mov    (%eax),%edx
  8035b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ba:	89 10                	mov    %edx,(%eax)
  8035bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8035bf:	8b 00                	mov    (%eax),%eax
  8035c1:	85 c0                	test   %eax,%eax
  8035c3:	74 0b                	je     8035d0 <insert_sorted_with_merge_freeList+0x6e1>
  8035c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035c8:	8b 00                	mov    (%eax),%eax
  8035ca:	8b 55 08             	mov    0x8(%ebp),%edx
  8035cd:	89 50 04             	mov    %edx,0x4(%eax)
  8035d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035d3:	8b 55 08             	mov    0x8(%ebp),%edx
  8035d6:	89 10                	mov    %edx,(%eax)
  8035d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8035db:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8035de:	89 50 04             	mov    %edx,0x4(%eax)
  8035e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8035e4:	8b 00                	mov    (%eax),%eax
  8035e6:	85 c0                	test   %eax,%eax
  8035e8:	75 08                	jne    8035f2 <insert_sorted_with_merge_freeList+0x703>
  8035ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ed:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8035f2:	a1 44 51 80 00       	mov    0x805144,%eax
  8035f7:	40                   	inc    %eax
  8035f8:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  8035fd:	eb 39                	jmp    803638 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8035ff:	a1 40 51 80 00       	mov    0x805140,%eax
  803604:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803607:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80360b:	74 07                	je     803614 <insert_sorted_with_merge_freeList+0x725>
  80360d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803610:	8b 00                	mov    (%eax),%eax
  803612:	eb 05                	jmp    803619 <insert_sorted_with_merge_freeList+0x72a>
  803614:	b8 00 00 00 00       	mov    $0x0,%eax
  803619:	a3 40 51 80 00       	mov    %eax,0x805140
  80361e:	a1 40 51 80 00       	mov    0x805140,%eax
  803623:	85 c0                	test   %eax,%eax
  803625:	0f 85 c7 fb ff ff    	jne    8031f2 <insert_sorted_with_merge_freeList+0x303>
  80362b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80362f:	0f 85 bd fb ff ff    	jne    8031f2 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803635:	eb 01                	jmp    803638 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803637:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803638:	90                   	nop
  803639:	c9                   	leave  
  80363a:	c3                   	ret    
  80363b:	90                   	nop

0080363c <__udivdi3>:
  80363c:	55                   	push   %ebp
  80363d:	57                   	push   %edi
  80363e:	56                   	push   %esi
  80363f:	53                   	push   %ebx
  803640:	83 ec 1c             	sub    $0x1c,%esp
  803643:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803647:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80364b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80364f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803653:	89 ca                	mov    %ecx,%edx
  803655:	89 f8                	mov    %edi,%eax
  803657:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80365b:	85 f6                	test   %esi,%esi
  80365d:	75 2d                	jne    80368c <__udivdi3+0x50>
  80365f:	39 cf                	cmp    %ecx,%edi
  803661:	77 65                	ja     8036c8 <__udivdi3+0x8c>
  803663:	89 fd                	mov    %edi,%ebp
  803665:	85 ff                	test   %edi,%edi
  803667:	75 0b                	jne    803674 <__udivdi3+0x38>
  803669:	b8 01 00 00 00       	mov    $0x1,%eax
  80366e:	31 d2                	xor    %edx,%edx
  803670:	f7 f7                	div    %edi
  803672:	89 c5                	mov    %eax,%ebp
  803674:	31 d2                	xor    %edx,%edx
  803676:	89 c8                	mov    %ecx,%eax
  803678:	f7 f5                	div    %ebp
  80367a:	89 c1                	mov    %eax,%ecx
  80367c:	89 d8                	mov    %ebx,%eax
  80367e:	f7 f5                	div    %ebp
  803680:	89 cf                	mov    %ecx,%edi
  803682:	89 fa                	mov    %edi,%edx
  803684:	83 c4 1c             	add    $0x1c,%esp
  803687:	5b                   	pop    %ebx
  803688:	5e                   	pop    %esi
  803689:	5f                   	pop    %edi
  80368a:	5d                   	pop    %ebp
  80368b:	c3                   	ret    
  80368c:	39 ce                	cmp    %ecx,%esi
  80368e:	77 28                	ja     8036b8 <__udivdi3+0x7c>
  803690:	0f bd fe             	bsr    %esi,%edi
  803693:	83 f7 1f             	xor    $0x1f,%edi
  803696:	75 40                	jne    8036d8 <__udivdi3+0x9c>
  803698:	39 ce                	cmp    %ecx,%esi
  80369a:	72 0a                	jb     8036a6 <__udivdi3+0x6a>
  80369c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8036a0:	0f 87 9e 00 00 00    	ja     803744 <__udivdi3+0x108>
  8036a6:	b8 01 00 00 00       	mov    $0x1,%eax
  8036ab:	89 fa                	mov    %edi,%edx
  8036ad:	83 c4 1c             	add    $0x1c,%esp
  8036b0:	5b                   	pop    %ebx
  8036b1:	5e                   	pop    %esi
  8036b2:	5f                   	pop    %edi
  8036b3:	5d                   	pop    %ebp
  8036b4:	c3                   	ret    
  8036b5:	8d 76 00             	lea    0x0(%esi),%esi
  8036b8:	31 ff                	xor    %edi,%edi
  8036ba:	31 c0                	xor    %eax,%eax
  8036bc:	89 fa                	mov    %edi,%edx
  8036be:	83 c4 1c             	add    $0x1c,%esp
  8036c1:	5b                   	pop    %ebx
  8036c2:	5e                   	pop    %esi
  8036c3:	5f                   	pop    %edi
  8036c4:	5d                   	pop    %ebp
  8036c5:	c3                   	ret    
  8036c6:	66 90                	xchg   %ax,%ax
  8036c8:	89 d8                	mov    %ebx,%eax
  8036ca:	f7 f7                	div    %edi
  8036cc:	31 ff                	xor    %edi,%edi
  8036ce:	89 fa                	mov    %edi,%edx
  8036d0:	83 c4 1c             	add    $0x1c,%esp
  8036d3:	5b                   	pop    %ebx
  8036d4:	5e                   	pop    %esi
  8036d5:	5f                   	pop    %edi
  8036d6:	5d                   	pop    %ebp
  8036d7:	c3                   	ret    
  8036d8:	bd 20 00 00 00       	mov    $0x20,%ebp
  8036dd:	89 eb                	mov    %ebp,%ebx
  8036df:	29 fb                	sub    %edi,%ebx
  8036e1:	89 f9                	mov    %edi,%ecx
  8036e3:	d3 e6                	shl    %cl,%esi
  8036e5:	89 c5                	mov    %eax,%ebp
  8036e7:	88 d9                	mov    %bl,%cl
  8036e9:	d3 ed                	shr    %cl,%ebp
  8036eb:	89 e9                	mov    %ebp,%ecx
  8036ed:	09 f1                	or     %esi,%ecx
  8036ef:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8036f3:	89 f9                	mov    %edi,%ecx
  8036f5:	d3 e0                	shl    %cl,%eax
  8036f7:	89 c5                	mov    %eax,%ebp
  8036f9:	89 d6                	mov    %edx,%esi
  8036fb:	88 d9                	mov    %bl,%cl
  8036fd:	d3 ee                	shr    %cl,%esi
  8036ff:	89 f9                	mov    %edi,%ecx
  803701:	d3 e2                	shl    %cl,%edx
  803703:	8b 44 24 08          	mov    0x8(%esp),%eax
  803707:	88 d9                	mov    %bl,%cl
  803709:	d3 e8                	shr    %cl,%eax
  80370b:	09 c2                	or     %eax,%edx
  80370d:	89 d0                	mov    %edx,%eax
  80370f:	89 f2                	mov    %esi,%edx
  803711:	f7 74 24 0c          	divl   0xc(%esp)
  803715:	89 d6                	mov    %edx,%esi
  803717:	89 c3                	mov    %eax,%ebx
  803719:	f7 e5                	mul    %ebp
  80371b:	39 d6                	cmp    %edx,%esi
  80371d:	72 19                	jb     803738 <__udivdi3+0xfc>
  80371f:	74 0b                	je     80372c <__udivdi3+0xf0>
  803721:	89 d8                	mov    %ebx,%eax
  803723:	31 ff                	xor    %edi,%edi
  803725:	e9 58 ff ff ff       	jmp    803682 <__udivdi3+0x46>
  80372a:	66 90                	xchg   %ax,%ax
  80372c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803730:	89 f9                	mov    %edi,%ecx
  803732:	d3 e2                	shl    %cl,%edx
  803734:	39 c2                	cmp    %eax,%edx
  803736:	73 e9                	jae    803721 <__udivdi3+0xe5>
  803738:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80373b:	31 ff                	xor    %edi,%edi
  80373d:	e9 40 ff ff ff       	jmp    803682 <__udivdi3+0x46>
  803742:	66 90                	xchg   %ax,%ax
  803744:	31 c0                	xor    %eax,%eax
  803746:	e9 37 ff ff ff       	jmp    803682 <__udivdi3+0x46>
  80374b:	90                   	nop

0080374c <__umoddi3>:
  80374c:	55                   	push   %ebp
  80374d:	57                   	push   %edi
  80374e:	56                   	push   %esi
  80374f:	53                   	push   %ebx
  803750:	83 ec 1c             	sub    $0x1c,%esp
  803753:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803757:	8b 74 24 34          	mov    0x34(%esp),%esi
  80375b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80375f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803763:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803767:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80376b:	89 f3                	mov    %esi,%ebx
  80376d:	89 fa                	mov    %edi,%edx
  80376f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803773:	89 34 24             	mov    %esi,(%esp)
  803776:	85 c0                	test   %eax,%eax
  803778:	75 1a                	jne    803794 <__umoddi3+0x48>
  80377a:	39 f7                	cmp    %esi,%edi
  80377c:	0f 86 a2 00 00 00    	jbe    803824 <__umoddi3+0xd8>
  803782:	89 c8                	mov    %ecx,%eax
  803784:	89 f2                	mov    %esi,%edx
  803786:	f7 f7                	div    %edi
  803788:	89 d0                	mov    %edx,%eax
  80378a:	31 d2                	xor    %edx,%edx
  80378c:	83 c4 1c             	add    $0x1c,%esp
  80378f:	5b                   	pop    %ebx
  803790:	5e                   	pop    %esi
  803791:	5f                   	pop    %edi
  803792:	5d                   	pop    %ebp
  803793:	c3                   	ret    
  803794:	39 f0                	cmp    %esi,%eax
  803796:	0f 87 ac 00 00 00    	ja     803848 <__umoddi3+0xfc>
  80379c:	0f bd e8             	bsr    %eax,%ebp
  80379f:	83 f5 1f             	xor    $0x1f,%ebp
  8037a2:	0f 84 ac 00 00 00    	je     803854 <__umoddi3+0x108>
  8037a8:	bf 20 00 00 00       	mov    $0x20,%edi
  8037ad:	29 ef                	sub    %ebp,%edi
  8037af:	89 fe                	mov    %edi,%esi
  8037b1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8037b5:	89 e9                	mov    %ebp,%ecx
  8037b7:	d3 e0                	shl    %cl,%eax
  8037b9:	89 d7                	mov    %edx,%edi
  8037bb:	89 f1                	mov    %esi,%ecx
  8037bd:	d3 ef                	shr    %cl,%edi
  8037bf:	09 c7                	or     %eax,%edi
  8037c1:	89 e9                	mov    %ebp,%ecx
  8037c3:	d3 e2                	shl    %cl,%edx
  8037c5:	89 14 24             	mov    %edx,(%esp)
  8037c8:	89 d8                	mov    %ebx,%eax
  8037ca:	d3 e0                	shl    %cl,%eax
  8037cc:	89 c2                	mov    %eax,%edx
  8037ce:	8b 44 24 08          	mov    0x8(%esp),%eax
  8037d2:	d3 e0                	shl    %cl,%eax
  8037d4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8037d8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8037dc:	89 f1                	mov    %esi,%ecx
  8037de:	d3 e8                	shr    %cl,%eax
  8037e0:	09 d0                	or     %edx,%eax
  8037e2:	d3 eb                	shr    %cl,%ebx
  8037e4:	89 da                	mov    %ebx,%edx
  8037e6:	f7 f7                	div    %edi
  8037e8:	89 d3                	mov    %edx,%ebx
  8037ea:	f7 24 24             	mull   (%esp)
  8037ed:	89 c6                	mov    %eax,%esi
  8037ef:	89 d1                	mov    %edx,%ecx
  8037f1:	39 d3                	cmp    %edx,%ebx
  8037f3:	0f 82 87 00 00 00    	jb     803880 <__umoddi3+0x134>
  8037f9:	0f 84 91 00 00 00    	je     803890 <__umoddi3+0x144>
  8037ff:	8b 54 24 04          	mov    0x4(%esp),%edx
  803803:	29 f2                	sub    %esi,%edx
  803805:	19 cb                	sbb    %ecx,%ebx
  803807:	89 d8                	mov    %ebx,%eax
  803809:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80380d:	d3 e0                	shl    %cl,%eax
  80380f:	89 e9                	mov    %ebp,%ecx
  803811:	d3 ea                	shr    %cl,%edx
  803813:	09 d0                	or     %edx,%eax
  803815:	89 e9                	mov    %ebp,%ecx
  803817:	d3 eb                	shr    %cl,%ebx
  803819:	89 da                	mov    %ebx,%edx
  80381b:	83 c4 1c             	add    $0x1c,%esp
  80381e:	5b                   	pop    %ebx
  80381f:	5e                   	pop    %esi
  803820:	5f                   	pop    %edi
  803821:	5d                   	pop    %ebp
  803822:	c3                   	ret    
  803823:	90                   	nop
  803824:	89 fd                	mov    %edi,%ebp
  803826:	85 ff                	test   %edi,%edi
  803828:	75 0b                	jne    803835 <__umoddi3+0xe9>
  80382a:	b8 01 00 00 00       	mov    $0x1,%eax
  80382f:	31 d2                	xor    %edx,%edx
  803831:	f7 f7                	div    %edi
  803833:	89 c5                	mov    %eax,%ebp
  803835:	89 f0                	mov    %esi,%eax
  803837:	31 d2                	xor    %edx,%edx
  803839:	f7 f5                	div    %ebp
  80383b:	89 c8                	mov    %ecx,%eax
  80383d:	f7 f5                	div    %ebp
  80383f:	89 d0                	mov    %edx,%eax
  803841:	e9 44 ff ff ff       	jmp    80378a <__umoddi3+0x3e>
  803846:	66 90                	xchg   %ax,%ax
  803848:	89 c8                	mov    %ecx,%eax
  80384a:	89 f2                	mov    %esi,%edx
  80384c:	83 c4 1c             	add    $0x1c,%esp
  80384f:	5b                   	pop    %ebx
  803850:	5e                   	pop    %esi
  803851:	5f                   	pop    %edi
  803852:	5d                   	pop    %ebp
  803853:	c3                   	ret    
  803854:	3b 04 24             	cmp    (%esp),%eax
  803857:	72 06                	jb     80385f <__umoddi3+0x113>
  803859:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80385d:	77 0f                	ja     80386e <__umoddi3+0x122>
  80385f:	89 f2                	mov    %esi,%edx
  803861:	29 f9                	sub    %edi,%ecx
  803863:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803867:	89 14 24             	mov    %edx,(%esp)
  80386a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80386e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803872:	8b 14 24             	mov    (%esp),%edx
  803875:	83 c4 1c             	add    $0x1c,%esp
  803878:	5b                   	pop    %ebx
  803879:	5e                   	pop    %esi
  80387a:	5f                   	pop    %edi
  80387b:	5d                   	pop    %ebp
  80387c:	c3                   	ret    
  80387d:	8d 76 00             	lea    0x0(%esi),%esi
  803880:	2b 04 24             	sub    (%esp),%eax
  803883:	19 fa                	sbb    %edi,%edx
  803885:	89 d1                	mov    %edx,%ecx
  803887:	89 c6                	mov    %eax,%esi
  803889:	e9 71 ff ff ff       	jmp    8037ff <__umoddi3+0xb3>
  80388e:	66 90                	xchg   %ax,%ax
  803890:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803894:	72 ea                	jb     803880 <__umoddi3+0x134>
  803896:	89 d9                	mov    %ebx,%ecx
  803898:	e9 62 ff ff ff       	jmp    8037ff <__umoddi3+0xb3>
