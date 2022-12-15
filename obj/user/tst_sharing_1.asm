
obj/user/tst_sharing_1:     file format elf32-i386


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
  800031:	e8 27 03 00 00       	call   80035d <libmain>
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
  80003c:	83 ec 24             	sub    $0x24,%esp
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
  80008d:	68 80 38 80 00       	push   $0x803880
  800092:	6a 12                	push   $0x12
  800094:	68 9c 38 80 00       	push   $0x80389c
  800099:	e8 fb 03 00 00       	call   800499 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  80009e:	83 ec 0c             	sub    $0xc,%esp
  8000a1:	6a 00                	push   $0x0
  8000a3:	e8 2d 16 00 00       	call   8016d5 <malloc>
  8000a8:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/

	uint32 *x, *y, *z ;
	uint32 expected ;
	cprintf("STEP A: checking the creation of shared variables... \n");
  8000ab:	83 ec 0c             	sub    $0xc,%esp
  8000ae:	68 b4 38 80 00       	push   $0x8038b4
  8000b3:	e8 95 06 00 00       	call   80074d <cprintf>
  8000b8:	83 c4 10             	add    $0x10,%esp
	{
		int freeFrames = sys_calculate_free_frames() ;
  8000bb:	e8 7c 19 00 00       	call   801a3c <sys_calculate_free_frames>
  8000c0:	89 45 e8             	mov    %eax,-0x18(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8000c3:	83 ec 04             	sub    $0x4,%esp
  8000c6:	6a 01                	push   $0x1
  8000c8:	68 00 10 00 00       	push   $0x1000
  8000cd:	68 eb 38 80 00       	push   $0x8038eb
  8000d2:	e8 93 16 00 00       	call   80176a <smalloc>
  8000d7:	83 c4 10             	add    $0x10,%esp
  8000da:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (x != (uint32*)USER_HEAP_START) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  8000dd:	81 7d e4 00 00 00 80 	cmpl   $0x80000000,-0x1c(%ebp)
  8000e4:	74 14                	je     8000fa <_main+0xc2>
  8000e6:	83 ec 04             	sub    $0x4,%esp
  8000e9:	68 f0 38 80 00       	push   $0x8038f0
  8000ee:	6a 1e                	push   $0x1e
  8000f0:	68 9c 38 80 00       	push   $0x80389c
  8000f5:	e8 9f 03 00 00       	call   800499 <_panic>
		expected = 1+1+2 ;
  8000fa:	c7 45 e0 04 00 00 00 	movl   $0x4,-0x20(%ebp)
		if ((freeFrames - sys_calculate_free_frames()) !=  expected) panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);
  800101:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800104:	e8 33 19 00 00       	call   801a3c <sys_calculate_free_frames>
  800109:	29 c3                	sub    %eax,%ebx
  80010b:	89 d8                	mov    %ebx,%eax
  80010d:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800110:	74 24                	je     800136 <_main+0xfe>
  800112:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800115:	e8 22 19 00 00       	call   801a3c <sys_calculate_free_frames>
  80011a:	29 c3                	sub    %eax,%ebx
  80011c:	89 d8                	mov    %ebx,%eax
  80011e:	83 ec 0c             	sub    $0xc,%esp
  800121:	ff 75 e0             	pushl  -0x20(%ebp)
  800124:	50                   	push   %eax
  800125:	68 5c 39 80 00       	push   $0x80395c
  80012a:	6a 20                	push   $0x20
  80012c:	68 9c 38 80 00       	push   $0x80389c
  800131:	e8 63 03 00 00       	call   800499 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800136:	e8 01 19 00 00       	call   801a3c <sys_calculate_free_frames>
  80013b:	89 45 e8             	mov    %eax,-0x18(%ebp)
		z = smalloc("z", PAGE_SIZE + 4, 1);
  80013e:	83 ec 04             	sub    $0x4,%esp
  800141:	6a 01                	push   $0x1
  800143:	68 04 10 00 00       	push   $0x1004
  800148:	68 f4 39 80 00       	push   $0x8039f4
  80014d:	e8 18 16 00 00       	call   80176a <smalloc>
  800152:	83 c4 10             	add    $0x10,%esp
  800155:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (z != (uint32*)(USER_HEAP_START + 1 * PAGE_SIZE)) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  800158:	81 7d dc 00 10 00 80 	cmpl   $0x80001000,-0x24(%ebp)
  80015f:	74 14                	je     800175 <_main+0x13d>
  800161:	83 ec 04             	sub    $0x4,%esp
  800164:	68 f0 38 80 00       	push   $0x8038f0
  800169:	6a 24                	push   $0x24
  80016b:	68 9c 38 80 00       	push   $0x80389c
  800170:	e8 24 03 00 00       	call   800499 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  2+0+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800175:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800178:	e8 bf 18 00 00       	call   801a3c <sys_calculate_free_frames>
  80017d:	29 c3                	sub    %eax,%ebx
  80017f:	89 d8                	mov    %ebx,%eax
  800181:	83 f8 04             	cmp    $0x4,%eax
  800184:	74 14                	je     80019a <_main+0x162>
  800186:	83 ec 04             	sub    $0x4,%esp
  800189:	68 f8 39 80 00       	push   $0x8039f8
  80018e:	6a 25                	push   $0x25
  800190:	68 9c 38 80 00       	push   $0x80389c
  800195:	e8 ff 02 00 00       	call   800499 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  80019a:	e8 9d 18 00 00       	call   801a3c <sys_calculate_free_frames>
  80019f:	89 45 e8             	mov    %eax,-0x18(%ebp)
		y = smalloc("y", 4, 1);
  8001a2:	83 ec 04             	sub    $0x4,%esp
  8001a5:	6a 01                	push   $0x1
  8001a7:	6a 04                	push   $0x4
  8001a9:	68 76 3a 80 00       	push   $0x803a76
  8001ae:	e8 b7 15 00 00       	call   80176a <smalloc>
  8001b3:	83 c4 10             	add    $0x10,%esp
  8001b6:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if (y != (uint32*)(USER_HEAP_START + 3 * PAGE_SIZE)) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  8001b9:	81 7d d8 00 30 00 80 	cmpl   $0x80003000,-0x28(%ebp)
  8001c0:	74 14                	je     8001d6 <_main+0x19e>
  8001c2:	83 ec 04             	sub    $0x4,%esp
  8001c5:	68 f0 38 80 00       	push   $0x8038f0
  8001ca:	6a 29                	push   $0x29
  8001cc:	68 9c 38 80 00       	push   $0x80389c
  8001d1:	e8 c3 02 00 00       	call   800499 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  1+0+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  8001d6:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8001d9:	e8 5e 18 00 00       	call   801a3c <sys_calculate_free_frames>
  8001de:	29 c3                	sub    %eax,%ebx
  8001e0:	89 d8                	mov    %ebx,%eax
  8001e2:	83 f8 03             	cmp    $0x3,%eax
  8001e5:	74 14                	je     8001fb <_main+0x1c3>
  8001e7:	83 ec 04             	sub    $0x4,%esp
  8001ea:	68 f8 39 80 00       	push   $0x8039f8
  8001ef:	6a 2a                	push   $0x2a
  8001f1:	68 9c 38 80 00       	push   $0x80389c
  8001f6:	e8 9e 02 00 00       	call   800499 <_panic>
	}
	cprintf("Step A is completed successfully!!\n\n\n");
  8001fb:	83 ec 0c             	sub    $0xc,%esp
  8001fe:	68 78 3a 80 00       	push   $0x803a78
  800203:	e8 45 05 00 00       	call   80074d <cprintf>
  800208:	83 c4 10             	add    $0x10,%esp


	cprintf("STEP B: checking reading & writing... \n");
  80020b:	83 ec 0c             	sub    $0xc,%esp
  80020e:	68 a0 3a 80 00       	push   $0x803aa0
  800213:	e8 35 05 00 00       	call   80074d <cprintf>
  800218:	83 c4 10             	add    $0x10,%esp
	{
		int i=0;
  80021b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for(;i<PAGE_SIZE/4;i++)
  800222:	eb 2d                	jmp    800251 <_main+0x219>
		{
			x[i] = -1;
  800224:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800227:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80022e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800231:	01 d0                	add    %edx,%eax
  800233:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
			y[i] = -1;
  800239:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80023c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800243:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800246:	01 d0                	add    %edx,%eax
  800248:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)


	cprintf("STEP B: checking reading & writing... \n");
	{
		int i=0;
		for(;i<PAGE_SIZE/4;i++)
  80024e:	ff 45 ec             	incl   -0x14(%ebp)
  800251:	81 7d ec ff 03 00 00 	cmpl   $0x3ff,-0x14(%ebp)
  800258:	7e ca                	jle    800224 <_main+0x1ec>
		{
			x[i] = -1;
			y[i] = -1;
		}

		i=0;
  80025a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for(;i<2*PAGE_SIZE/4;i++)
  800261:	eb 18                	jmp    80027b <_main+0x243>
		{
			z[i] = -1;
  800263:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800266:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80026d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800270:	01 d0                	add    %edx,%eax
  800272:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
			x[i] = -1;
			y[i] = -1;
		}

		i=0;
		for(;i<2*PAGE_SIZE/4;i++)
  800278:	ff 45 ec             	incl   -0x14(%ebp)
  80027b:	81 7d ec ff 07 00 00 	cmpl   $0x7ff,-0x14(%ebp)
  800282:	7e df                	jle    800263 <_main+0x22b>
		{
			z[i] = -1;
		}

		if( x[0] !=  -1)  					panic("Reading/Writing of shared object is failed");
  800284:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800287:	8b 00                	mov    (%eax),%eax
  800289:	83 f8 ff             	cmp    $0xffffffff,%eax
  80028c:	74 14                	je     8002a2 <_main+0x26a>
  80028e:	83 ec 04             	sub    $0x4,%esp
  800291:	68 c8 3a 80 00       	push   $0x803ac8
  800296:	6a 3e                	push   $0x3e
  800298:	68 9c 38 80 00       	push   $0x80389c
  80029d:	e8 f7 01 00 00       	call   800499 <_panic>
		if( x[PAGE_SIZE/4 - 1] !=  -1)  	panic("Reading/Writing of shared object is failed");
  8002a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002a5:	05 fc 0f 00 00       	add    $0xffc,%eax
  8002aa:	8b 00                	mov    (%eax),%eax
  8002ac:	83 f8 ff             	cmp    $0xffffffff,%eax
  8002af:	74 14                	je     8002c5 <_main+0x28d>
  8002b1:	83 ec 04             	sub    $0x4,%esp
  8002b4:	68 c8 3a 80 00       	push   $0x803ac8
  8002b9:	6a 3f                	push   $0x3f
  8002bb:	68 9c 38 80 00       	push   $0x80389c
  8002c0:	e8 d4 01 00 00       	call   800499 <_panic>

		if( y[0] !=  -1)  					panic("Reading/Writing of shared object is failed");
  8002c5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8002c8:	8b 00                	mov    (%eax),%eax
  8002ca:	83 f8 ff             	cmp    $0xffffffff,%eax
  8002cd:	74 14                	je     8002e3 <_main+0x2ab>
  8002cf:	83 ec 04             	sub    $0x4,%esp
  8002d2:	68 c8 3a 80 00       	push   $0x803ac8
  8002d7:	6a 41                	push   $0x41
  8002d9:	68 9c 38 80 00       	push   $0x80389c
  8002de:	e8 b6 01 00 00       	call   800499 <_panic>
		if( y[PAGE_SIZE/4 - 1] !=  -1)  	panic("Reading/Writing of shared object is failed");
  8002e3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8002e6:	05 fc 0f 00 00       	add    $0xffc,%eax
  8002eb:	8b 00                	mov    (%eax),%eax
  8002ed:	83 f8 ff             	cmp    $0xffffffff,%eax
  8002f0:	74 14                	je     800306 <_main+0x2ce>
  8002f2:	83 ec 04             	sub    $0x4,%esp
  8002f5:	68 c8 3a 80 00       	push   $0x803ac8
  8002fa:	6a 42                	push   $0x42
  8002fc:	68 9c 38 80 00       	push   $0x80389c
  800301:	e8 93 01 00 00       	call   800499 <_panic>

		if( z[0] !=  -1)  					panic("Reading/Writing of shared object is failed");
  800306:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800309:	8b 00                	mov    (%eax),%eax
  80030b:	83 f8 ff             	cmp    $0xffffffff,%eax
  80030e:	74 14                	je     800324 <_main+0x2ec>
  800310:	83 ec 04             	sub    $0x4,%esp
  800313:	68 c8 3a 80 00       	push   $0x803ac8
  800318:	6a 44                	push   $0x44
  80031a:	68 9c 38 80 00       	push   $0x80389c
  80031f:	e8 75 01 00 00       	call   800499 <_panic>
		if( z[2*PAGE_SIZE/4 - 1] !=  -1)  	panic("Reading/Writing of shared object is failed");
  800324:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800327:	05 fc 1f 00 00       	add    $0x1ffc,%eax
  80032c:	8b 00                	mov    (%eax),%eax
  80032e:	83 f8 ff             	cmp    $0xffffffff,%eax
  800331:	74 14                	je     800347 <_main+0x30f>
  800333:	83 ec 04             	sub    $0x4,%esp
  800336:	68 c8 3a 80 00       	push   $0x803ac8
  80033b:	6a 45                	push   $0x45
  80033d:	68 9c 38 80 00       	push   $0x80389c
  800342:	e8 52 01 00 00       	call   800499 <_panic>
	}

	cprintf("Congratulations!! Test of Shared Variables [Create] [1] completed successfully!!\n\n\n");
  800347:	83 ec 0c             	sub    $0xc,%esp
  80034a:	68 f4 3a 80 00       	push   $0x803af4
  80034f:	e8 f9 03 00 00       	call   80074d <cprintf>
  800354:	83 c4 10             	add    $0x10,%esp

	return;
  800357:	90                   	nop
}
  800358:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80035b:	c9                   	leave  
  80035c:	c3                   	ret    

0080035d <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80035d:	55                   	push   %ebp
  80035e:	89 e5                	mov    %esp,%ebp
  800360:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800363:	e8 b4 19 00 00       	call   801d1c <sys_getenvindex>
  800368:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80036b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80036e:	89 d0                	mov    %edx,%eax
  800370:	c1 e0 03             	shl    $0x3,%eax
  800373:	01 d0                	add    %edx,%eax
  800375:	01 c0                	add    %eax,%eax
  800377:	01 d0                	add    %edx,%eax
  800379:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800380:	01 d0                	add    %edx,%eax
  800382:	c1 e0 04             	shl    $0x4,%eax
  800385:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80038a:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80038f:	a1 20 50 80 00       	mov    0x805020,%eax
  800394:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  80039a:	84 c0                	test   %al,%al
  80039c:	74 0f                	je     8003ad <libmain+0x50>
		binaryname = myEnv->prog_name;
  80039e:	a1 20 50 80 00       	mov    0x805020,%eax
  8003a3:	05 5c 05 00 00       	add    $0x55c,%eax
  8003a8:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8003ad:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8003b1:	7e 0a                	jle    8003bd <libmain+0x60>
		binaryname = argv[0];
  8003b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003b6:	8b 00                	mov    (%eax),%eax
  8003b8:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8003bd:	83 ec 08             	sub    $0x8,%esp
  8003c0:	ff 75 0c             	pushl  0xc(%ebp)
  8003c3:	ff 75 08             	pushl  0x8(%ebp)
  8003c6:	e8 6d fc ff ff       	call   800038 <_main>
  8003cb:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8003ce:	e8 56 17 00 00       	call   801b29 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8003d3:	83 ec 0c             	sub    $0xc,%esp
  8003d6:	68 60 3b 80 00       	push   $0x803b60
  8003db:	e8 6d 03 00 00       	call   80074d <cprintf>
  8003e0:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8003e3:	a1 20 50 80 00       	mov    0x805020,%eax
  8003e8:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8003ee:	a1 20 50 80 00       	mov    0x805020,%eax
  8003f3:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8003f9:	83 ec 04             	sub    $0x4,%esp
  8003fc:	52                   	push   %edx
  8003fd:	50                   	push   %eax
  8003fe:	68 88 3b 80 00       	push   $0x803b88
  800403:	e8 45 03 00 00       	call   80074d <cprintf>
  800408:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80040b:	a1 20 50 80 00       	mov    0x805020,%eax
  800410:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800416:	a1 20 50 80 00       	mov    0x805020,%eax
  80041b:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800421:	a1 20 50 80 00       	mov    0x805020,%eax
  800426:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  80042c:	51                   	push   %ecx
  80042d:	52                   	push   %edx
  80042e:	50                   	push   %eax
  80042f:	68 b0 3b 80 00       	push   $0x803bb0
  800434:	e8 14 03 00 00       	call   80074d <cprintf>
  800439:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80043c:	a1 20 50 80 00       	mov    0x805020,%eax
  800441:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800447:	83 ec 08             	sub    $0x8,%esp
  80044a:	50                   	push   %eax
  80044b:	68 08 3c 80 00       	push   $0x803c08
  800450:	e8 f8 02 00 00       	call   80074d <cprintf>
  800455:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800458:	83 ec 0c             	sub    $0xc,%esp
  80045b:	68 60 3b 80 00       	push   $0x803b60
  800460:	e8 e8 02 00 00       	call   80074d <cprintf>
  800465:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800468:	e8 d6 16 00 00       	call   801b43 <sys_enable_interrupt>

	// exit gracefully
	exit();
  80046d:	e8 19 00 00 00       	call   80048b <exit>
}
  800472:	90                   	nop
  800473:	c9                   	leave  
  800474:	c3                   	ret    

00800475 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800475:	55                   	push   %ebp
  800476:	89 e5                	mov    %esp,%ebp
  800478:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80047b:	83 ec 0c             	sub    $0xc,%esp
  80047e:	6a 00                	push   $0x0
  800480:	e8 63 18 00 00       	call   801ce8 <sys_destroy_env>
  800485:	83 c4 10             	add    $0x10,%esp
}
  800488:	90                   	nop
  800489:	c9                   	leave  
  80048a:	c3                   	ret    

0080048b <exit>:

void
exit(void)
{
  80048b:	55                   	push   %ebp
  80048c:	89 e5                	mov    %esp,%ebp
  80048e:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800491:	e8 b8 18 00 00       	call   801d4e <sys_exit_env>
}
  800496:	90                   	nop
  800497:	c9                   	leave  
  800498:	c3                   	ret    

00800499 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800499:	55                   	push   %ebp
  80049a:	89 e5                	mov    %esp,%ebp
  80049c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80049f:	8d 45 10             	lea    0x10(%ebp),%eax
  8004a2:	83 c0 04             	add    $0x4,%eax
  8004a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8004a8:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8004ad:	85 c0                	test   %eax,%eax
  8004af:	74 16                	je     8004c7 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8004b1:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8004b6:	83 ec 08             	sub    $0x8,%esp
  8004b9:	50                   	push   %eax
  8004ba:	68 1c 3c 80 00       	push   $0x803c1c
  8004bf:	e8 89 02 00 00       	call   80074d <cprintf>
  8004c4:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8004c7:	a1 00 50 80 00       	mov    0x805000,%eax
  8004cc:	ff 75 0c             	pushl  0xc(%ebp)
  8004cf:	ff 75 08             	pushl  0x8(%ebp)
  8004d2:	50                   	push   %eax
  8004d3:	68 21 3c 80 00       	push   $0x803c21
  8004d8:	e8 70 02 00 00       	call   80074d <cprintf>
  8004dd:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8004e0:	8b 45 10             	mov    0x10(%ebp),%eax
  8004e3:	83 ec 08             	sub    $0x8,%esp
  8004e6:	ff 75 f4             	pushl  -0xc(%ebp)
  8004e9:	50                   	push   %eax
  8004ea:	e8 f3 01 00 00       	call   8006e2 <vcprintf>
  8004ef:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8004f2:	83 ec 08             	sub    $0x8,%esp
  8004f5:	6a 00                	push   $0x0
  8004f7:	68 3d 3c 80 00       	push   $0x803c3d
  8004fc:	e8 e1 01 00 00       	call   8006e2 <vcprintf>
  800501:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800504:	e8 82 ff ff ff       	call   80048b <exit>

	// should not return here
	while (1) ;
  800509:	eb fe                	jmp    800509 <_panic+0x70>

0080050b <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80050b:	55                   	push   %ebp
  80050c:	89 e5                	mov    %esp,%ebp
  80050e:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800511:	a1 20 50 80 00       	mov    0x805020,%eax
  800516:	8b 50 74             	mov    0x74(%eax),%edx
  800519:	8b 45 0c             	mov    0xc(%ebp),%eax
  80051c:	39 c2                	cmp    %eax,%edx
  80051e:	74 14                	je     800534 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800520:	83 ec 04             	sub    $0x4,%esp
  800523:	68 40 3c 80 00       	push   $0x803c40
  800528:	6a 26                	push   $0x26
  80052a:	68 8c 3c 80 00       	push   $0x803c8c
  80052f:	e8 65 ff ff ff       	call   800499 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800534:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80053b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800542:	e9 c2 00 00 00       	jmp    800609 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800547:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80054a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800551:	8b 45 08             	mov    0x8(%ebp),%eax
  800554:	01 d0                	add    %edx,%eax
  800556:	8b 00                	mov    (%eax),%eax
  800558:	85 c0                	test   %eax,%eax
  80055a:	75 08                	jne    800564 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80055c:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80055f:	e9 a2 00 00 00       	jmp    800606 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800564:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80056b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800572:	eb 69                	jmp    8005dd <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800574:	a1 20 50 80 00       	mov    0x805020,%eax
  800579:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80057f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800582:	89 d0                	mov    %edx,%eax
  800584:	01 c0                	add    %eax,%eax
  800586:	01 d0                	add    %edx,%eax
  800588:	c1 e0 03             	shl    $0x3,%eax
  80058b:	01 c8                	add    %ecx,%eax
  80058d:	8a 40 04             	mov    0x4(%eax),%al
  800590:	84 c0                	test   %al,%al
  800592:	75 46                	jne    8005da <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800594:	a1 20 50 80 00       	mov    0x805020,%eax
  800599:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80059f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005a2:	89 d0                	mov    %edx,%eax
  8005a4:	01 c0                	add    %eax,%eax
  8005a6:	01 d0                	add    %edx,%eax
  8005a8:	c1 e0 03             	shl    $0x3,%eax
  8005ab:	01 c8                	add    %ecx,%eax
  8005ad:	8b 00                	mov    (%eax),%eax
  8005af:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8005b2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005b5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8005ba:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8005bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005bf:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c9:	01 c8                	add    %ecx,%eax
  8005cb:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005cd:	39 c2                	cmp    %eax,%edx
  8005cf:	75 09                	jne    8005da <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8005d1:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8005d8:	eb 12                	jmp    8005ec <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005da:	ff 45 e8             	incl   -0x18(%ebp)
  8005dd:	a1 20 50 80 00       	mov    0x805020,%eax
  8005e2:	8b 50 74             	mov    0x74(%eax),%edx
  8005e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005e8:	39 c2                	cmp    %eax,%edx
  8005ea:	77 88                	ja     800574 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8005ec:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8005f0:	75 14                	jne    800606 <CheckWSWithoutLastIndex+0xfb>
			panic(
  8005f2:	83 ec 04             	sub    $0x4,%esp
  8005f5:	68 98 3c 80 00       	push   $0x803c98
  8005fa:	6a 3a                	push   $0x3a
  8005fc:	68 8c 3c 80 00       	push   $0x803c8c
  800601:	e8 93 fe ff ff       	call   800499 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800606:	ff 45 f0             	incl   -0x10(%ebp)
  800609:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80060c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80060f:	0f 8c 32 ff ff ff    	jl     800547 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800615:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80061c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800623:	eb 26                	jmp    80064b <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800625:	a1 20 50 80 00       	mov    0x805020,%eax
  80062a:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800630:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800633:	89 d0                	mov    %edx,%eax
  800635:	01 c0                	add    %eax,%eax
  800637:	01 d0                	add    %edx,%eax
  800639:	c1 e0 03             	shl    $0x3,%eax
  80063c:	01 c8                	add    %ecx,%eax
  80063e:	8a 40 04             	mov    0x4(%eax),%al
  800641:	3c 01                	cmp    $0x1,%al
  800643:	75 03                	jne    800648 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800645:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800648:	ff 45 e0             	incl   -0x20(%ebp)
  80064b:	a1 20 50 80 00       	mov    0x805020,%eax
  800650:	8b 50 74             	mov    0x74(%eax),%edx
  800653:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800656:	39 c2                	cmp    %eax,%edx
  800658:	77 cb                	ja     800625 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80065a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80065d:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800660:	74 14                	je     800676 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800662:	83 ec 04             	sub    $0x4,%esp
  800665:	68 ec 3c 80 00       	push   $0x803cec
  80066a:	6a 44                	push   $0x44
  80066c:	68 8c 3c 80 00       	push   $0x803c8c
  800671:	e8 23 fe ff ff       	call   800499 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800676:	90                   	nop
  800677:	c9                   	leave  
  800678:	c3                   	ret    

00800679 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800679:	55                   	push   %ebp
  80067a:	89 e5                	mov    %esp,%ebp
  80067c:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80067f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800682:	8b 00                	mov    (%eax),%eax
  800684:	8d 48 01             	lea    0x1(%eax),%ecx
  800687:	8b 55 0c             	mov    0xc(%ebp),%edx
  80068a:	89 0a                	mov    %ecx,(%edx)
  80068c:	8b 55 08             	mov    0x8(%ebp),%edx
  80068f:	88 d1                	mov    %dl,%cl
  800691:	8b 55 0c             	mov    0xc(%ebp),%edx
  800694:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800698:	8b 45 0c             	mov    0xc(%ebp),%eax
  80069b:	8b 00                	mov    (%eax),%eax
  80069d:	3d ff 00 00 00       	cmp    $0xff,%eax
  8006a2:	75 2c                	jne    8006d0 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8006a4:	a0 24 50 80 00       	mov    0x805024,%al
  8006a9:	0f b6 c0             	movzbl %al,%eax
  8006ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006af:	8b 12                	mov    (%edx),%edx
  8006b1:	89 d1                	mov    %edx,%ecx
  8006b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006b6:	83 c2 08             	add    $0x8,%edx
  8006b9:	83 ec 04             	sub    $0x4,%esp
  8006bc:	50                   	push   %eax
  8006bd:	51                   	push   %ecx
  8006be:	52                   	push   %edx
  8006bf:	e8 b7 12 00 00       	call   80197b <sys_cputs>
  8006c4:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8006c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006ca:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8006d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006d3:	8b 40 04             	mov    0x4(%eax),%eax
  8006d6:	8d 50 01             	lea    0x1(%eax),%edx
  8006d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006dc:	89 50 04             	mov    %edx,0x4(%eax)
}
  8006df:	90                   	nop
  8006e0:	c9                   	leave  
  8006e1:	c3                   	ret    

008006e2 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8006e2:	55                   	push   %ebp
  8006e3:	89 e5                	mov    %esp,%ebp
  8006e5:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8006eb:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8006f2:	00 00 00 
	b.cnt = 0;
  8006f5:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8006fc:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8006ff:	ff 75 0c             	pushl  0xc(%ebp)
  800702:	ff 75 08             	pushl  0x8(%ebp)
  800705:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80070b:	50                   	push   %eax
  80070c:	68 79 06 80 00       	push   $0x800679
  800711:	e8 11 02 00 00       	call   800927 <vprintfmt>
  800716:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800719:	a0 24 50 80 00       	mov    0x805024,%al
  80071e:	0f b6 c0             	movzbl %al,%eax
  800721:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800727:	83 ec 04             	sub    $0x4,%esp
  80072a:	50                   	push   %eax
  80072b:	52                   	push   %edx
  80072c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800732:	83 c0 08             	add    $0x8,%eax
  800735:	50                   	push   %eax
  800736:	e8 40 12 00 00       	call   80197b <sys_cputs>
  80073b:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80073e:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  800745:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80074b:	c9                   	leave  
  80074c:	c3                   	ret    

0080074d <cprintf>:

int cprintf(const char *fmt, ...) {
  80074d:	55                   	push   %ebp
  80074e:	89 e5                	mov    %esp,%ebp
  800750:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800753:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  80075a:	8d 45 0c             	lea    0xc(%ebp),%eax
  80075d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800760:	8b 45 08             	mov    0x8(%ebp),%eax
  800763:	83 ec 08             	sub    $0x8,%esp
  800766:	ff 75 f4             	pushl  -0xc(%ebp)
  800769:	50                   	push   %eax
  80076a:	e8 73 ff ff ff       	call   8006e2 <vcprintf>
  80076f:	83 c4 10             	add    $0x10,%esp
  800772:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800775:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800778:	c9                   	leave  
  800779:	c3                   	ret    

0080077a <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80077a:	55                   	push   %ebp
  80077b:	89 e5                	mov    %esp,%ebp
  80077d:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800780:	e8 a4 13 00 00       	call   801b29 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800785:	8d 45 0c             	lea    0xc(%ebp),%eax
  800788:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80078b:	8b 45 08             	mov    0x8(%ebp),%eax
  80078e:	83 ec 08             	sub    $0x8,%esp
  800791:	ff 75 f4             	pushl  -0xc(%ebp)
  800794:	50                   	push   %eax
  800795:	e8 48 ff ff ff       	call   8006e2 <vcprintf>
  80079a:	83 c4 10             	add    $0x10,%esp
  80079d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8007a0:	e8 9e 13 00 00       	call   801b43 <sys_enable_interrupt>
	return cnt;
  8007a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007a8:	c9                   	leave  
  8007a9:	c3                   	ret    

008007aa <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007aa:	55                   	push   %ebp
  8007ab:	89 e5                	mov    %esp,%ebp
  8007ad:	53                   	push   %ebx
  8007ae:	83 ec 14             	sub    $0x14,%esp
  8007b1:	8b 45 10             	mov    0x10(%ebp),%eax
  8007b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8007bd:	8b 45 18             	mov    0x18(%ebp),%eax
  8007c0:	ba 00 00 00 00       	mov    $0x0,%edx
  8007c5:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007c8:	77 55                	ja     80081f <printnum+0x75>
  8007ca:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007cd:	72 05                	jb     8007d4 <printnum+0x2a>
  8007cf:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8007d2:	77 4b                	ja     80081f <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8007d4:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8007d7:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8007da:	8b 45 18             	mov    0x18(%ebp),%eax
  8007dd:	ba 00 00 00 00       	mov    $0x0,%edx
  8007e2:	52                   	push   %edx
  8007e3:	50                   	push   %eax
  8007e4:	ff 75 f4             	pushl  -0xc(%ebp)
  8007e7:	ff 75 f0             	pushl  -0x10(%ebp)
  8007ea:	e8 11 2e 00 00       	call   803600 <__udivdi3>
  8007ef:	83 c4 10             	add    $0x10,%esp
  8007f2:	83 ec 04             	sub    $0x4,%esp
  8007f5:	ff 75 20             	pushl  0x20(%ebp)
  8007f8:	53                   	push   %ebx
  8007f9:	ff 75 18             	pushl  0x18(%ebp)
  8007fc:	52                   	push   %edx
  8007fd:	50                   	push   %eax
  8007fe:	ff 75 0c             	pushl  0xc(%ebp)
  800801:	ff 75 08             	pushl  0x8(%ebp)
  800804:	e8 a1 ff ff ff       	call   8007aa <printnum>
  800809:	83 c4 20             	add    $0x20,%esp
  80080c:	eb 1a                	jmp    800828 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80080e:	83 ec 08             	sub    $0x8,%esp
  800811:	ff 75 0c             	pushl  0xc(%ebp)
  800814:	ff 75 20             	pushl  0x20(%ebp)
  800817:	8b 45 08             	mov    0x8(%ebp),%eax
  80081a:	ff d0                	call   *%eax
  80081c:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80081f:	ff 4d 1c             	decl   0x1c(%ebp)
  800822:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800826:	7f e6                	jg     80080e <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800828:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80082b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800830:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800833:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800836:	53                   	push   %ebx
  800837:	51                   	push   %ecx
  800838:	52                   	push   %edx
  800839:	50                   	push   %eax
  80083a:	e8 d1 2e 00 00       	call   803710 <__umoddi3>
  80083f:	83 c4 10             	add    $0x10,%esp
  800842:	05 54 3f 80 00       	add    $0x803f54,%eax
  800847:	8a 00                	mov    (%eax),%al
  800849:	0f be c0             	movsbl %al,%eax
  80084c:	83 ec 08             	sub    $0x8,%esp
  80084f:	ff 75 0c             	pushl  0xc(%ebp)
  800852:	50                   	push   %eax
  800853:	8b 45 08             	mov    0x8(%ebp),%eax
  800856:	ff d0                	call   *%eax
  800858:	83 c4 10             	add    $0x10,%esp
}
  80085b:	90                   	nop
  80085c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80085f:	c9                   	leave  
  800860:	c3                   	ret    

00800861 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800861:	55                   	push   %ebp
  800862:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800864:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800868:	7e 1c                	jle    800886 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80086a:	8b 45 08             	mov    0x8(%ebp),%eax
  80086d:	8b 00                	mov    (%eax),%eax
  80086f:	8d 50 08             	lea    0x8(%eax),%edx
  800872:	8b 45 08             	mov    0x8(%ebp),%eax
  800875:	89 10                	mov    %edx,(%eax)
  800877:	8b 45 08             	mov    0x8(%ebp),%eax
  80087a:	8b 00                	mov    (%eax),%eax
  80087c:	83 e8 08             	sub    $0x8,%eax
  80087f:	8b 50 04             	mov    0x4(%eax),%edx
  800882:	8b 00                	mov    (%eax),%eax
  800884:	eb 40                	jmp    8008c6 <getuint+0x65>
	else if (lflag)
  800886:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80088a:	74 1e                	je     8008aa <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80088c:	8b 45 08             	mov    0x8(%ebp),%eax
  80088f:	8b 00                	mov    (%eax),%eax
  800891:	8d 50 04             	lea    0x4(%eax),%edx
  800894:	8b 45 08             	mov    0x8(%ebp),%eax
  800897:	89 10                	mov    %edx,(%eax)
  800899:	8b 45 08             	mov    0x8(%ebp),%eax
  80089c:	8b 00                	mov    (%eax),%eax
  80089e:	83 e8 04             	sub    $0x4,%eax
  8008a1:	8b 00                	mov    (%eax),%eax
  8008a3:	ba 00 00 00 00       	mov    $0x0,%edx
  8008a8:	eb 1c                	jmp    8008c6 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8008aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ad:	8b 00                	mov    (%eax),%eax
  8008af:	8d 50 04             	lea    0x4(%eax),%edx
  8008b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b5:	89 10                	mov    %edx,(%eax)
  8008b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ba:	8b 00                	mov    (%eax),%eax
  8008bc:	83 e8 04             	sub    $0x4,%eax
  8008bf:	8b 00                	mov    (%eax),%eax
  8008c1:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8008c6:	5d                   	pop    %ebp
  8008c7:	c3                   	ret    

008008c8 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8008c8:	55                   	push   %ebp
  8008c9:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008cb:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008cf:	7e 1c                	jle    8008ed <getint+0x25>
		return va_arg(*ap, long long);
  8008d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d4:	8b 00                	mov    (%eax),%eax
  8008d6:	8d 50 08             	lea    0x8(%eax),%edx
  8008d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008dc:	89 10                	mov    %edx,(%eax)
  8008de:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e1:	8b 00                	mov    (%eax),%eax
  8008e3:	83 e8 08             	sub    $0x8,%eax
  8008e6:	8b 50 04             	mov    0x4(%eax),%edx
  8008e9:	8b 00                	mov    (%eax),%eax
  8008eb:	eb 38                	jmp    800925 <getint+0x5d>
	else if (lflag)
  8008ed:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008f1:	74 1a                	je     80090d <getint+0x45>
		return va_arg(*ap, long);
  8008f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f6:	8b 00                	mov    (%eax),%eax
  8008f8:	8d 50 04             	lea    0x4(%eax),%edx
  8008fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fe:	89 10                	mov    %edx,(%eax)
  800900:	8b 45 08             	mov    0x8(%ebp),%eax
  800903:	8b 00                	mov    (%eax),%eax
  800905:	83 e8 04             	sub    $0x4,%eax
  800908:	8b 00                	mov    (%eax),%eax
  80090a:	99                   	cltd   
  80090b:	eb 18                	jmp    800925 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80090d:	8b 45 08             	mov    0x8(%ebp),%eax
  800910:	8b 00                	mov    (%eax),%eax
  800912:	8d 50 04             	lea    0x4(%eax),%edx
  800915:	8b 45 08             	mov    0x8(%ebp),%eax
  800918:	89 10                	mov    %edx,(%eax)
  80091a:	8b 45 08             	mov    0x8(%ebp),%eax
  80091d:	8b 00                	mov    (%eax),%eax
  80091f:	83 e8 04             	sub    $0x4,%eax
  800922:	8b 00                	mov    (%eax),%eax
  800924:	99                   	cltd   
}
  800925:	5d                   	pop    %ebp
  800926:	c3                   	ret    

00800927 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800927:	55                   	push   %ebp
  800928:	89 e5                	mov    %esp,%ebp
  80092a:	56                   	push   %esi
  80092b:	53                   	push   %ebx
  80092c:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80092f:	eb 17                	jmp    800948 <vprintfmt+0x21>
			if (ch == '\0')
  800931:	85 db                	test   %ebx,%ebx
  800933:	0f 84 af 03 00 00    	je     800ce8 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800939:	83 ec 08             	sub    $0x8,%esp
  80093c:	ff 75 0c             	pushl  0xc(%ebp)
  80093f:	53                   	push   %ebx
  800940:	8b 45 08             	mov    0x8(%ebp),%eax
  800943:	ff d0                	call   *%eax
  800945:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800948:	8b 45 10             	mov    0x10(%ebp),%eax
  80094b:	8d 50 01             	lea    0x1(%eax),%edx
  80094e:	89 55 10             	mov    %edx,0x10(%ebp)
  800951:	8a 00                	mov    (%eax),%al
  800953:	0f b6 d8             	movzbl %al,%ebx
  800956:	83 fb 25             	cmp    $0x25,%ebx
  800959:	75 d6                	jne    800931 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80095b:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80095f:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800966:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80096d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800974:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80097b:	8b 45 10             	mov    0x10(%ebp),%eax
  80097e:	8d 50 01             	lea    0x1(%eax),%edx
  800981:	89 55 10             	mov    %edx,0x10(%ebp)
  800984:	8a 00                	mov    (%eax),%al
  800986:	0f b6 d8             	movzbl %al,%ebx
  800989:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80098c:	83 f8 55             	cmp    $0x55,%eax
  80098f:	0f 87 2b 03 00 00    	ja     800cc0 <vprintfmt+0x399>
  800995:	8b 04 85 78 3f 80 00 	mov    0x803f78(,%eax,4),%eax
  80099c:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80099e:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8009a2:	eb d7                	jmp    80097b <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009a4:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8009a8:	eb d1                	jmp    80097b <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009aa:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8009b1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009b4:	89 d0                	mov    %edx,%eax
  8009b6:	c1 e0 02             	shl    $0x2,%eax
  8009b9:	01 d0                	add    %edx,%eax
  8009bb:	01 c0                	add    %eax,%eax
  8009bd:	01 d8                	add    %ebx,%eax
  8009bf:	83 e8 30             	sub    $0x30,%eax
  8009c2:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8009c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8009c8:	8a 00                	mov    (%eax),%al
  8009ca:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8009cd:	83 fb 2f             	cmp    $0x2f,%ebx
  8009d0:	7e 3e                	jle    800a10 <vprintfmt+0xe9>
  8009d2:	83 fb 39             	cmp    $0x39,%ebx
  8009d5:	7f 39                	jg     800a10 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009d7:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8009da:	eb d5                	jmp    8009b1 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8009dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8009df:	83 c0 04             	add    $0x4,%eax
  8009e2:	89 45 14             	mov    %eax,0x14(%ebp)
  8009e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8009e8:	83 e8 04             	sub    $0x4,%eax
  8009eb:	8b 00                	mov    (%eax),%eax
  8009ed:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8009f0:	eb 1f                	jmp    800a11 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8009f2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009f6:	79 83                	jns    80097b <vprintfmt+0x54>
				width = 0;
  8009f8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8009ff:	e9 77 ff ff ff       	jmp    80097b <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a04:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a0b:	e9 6b ff ff ff       	jmp    80097b <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a10:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a11:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a15:	0f 89 60 ff ff ff    	jns    80097b <vprintfmt+0x54>
				width = precision, precision = -1;
  800a1b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a1e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a21:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a28:	e9 4e ff ff ff       	jmp    80097b <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a2d:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a30:	e9 46 ff ff ff       	jmp    80097b <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a35:	8b 45 14             	mov    0x14(%ebp),%eax
  800a38:	83 c0 04             	add    $0x4,%eax
  800a3b:	89 45 14             	mov    %eax,0x14(%ebp)
  800a3e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a41:	83 e8 04             	sub    $0x4,%eax
  800a44:	8b 00                	mov    (%eax),%eax
  800a46:	83 ec 08             	sub    $0x8,%esp
  800a49:	ff 75 0c             	pushl  0xc(%ebp)
  800a4c:	50                   	push   %eax
  800a4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a50:	ff d0                	call   *%eax
  800a52:	83 c4 10             	add    $0x10,%esp
			break;
  800a55:	e9 89 02 00 00       	jmp    800ce3 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800a5a:	8b 45 14             	mov    0x14(%ebp),%eax
  800a5d:	83 c0 04             	add    $0x4,%eax
  800a60:	89 45 14             	mov    %eax,0x14(%ebp)
  800a63:	8b 45 14             	mov    0x14(%ebp),%eax
  800a66:	83 e8 04             	sub    $0x4,%eax
  800a69:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800a6b:	85 db                	test   %ebx,%ebx
  800a6d:	79 02                	jns    800a71 <vprintfmt+0x14a>
				err = -err;
  800a6f:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800a71:	83 fb 64             	cmp    $0x64,%ebx
  800a74:	7f 0b                	jg     800a81 <vprintfmt+0x15a>
  800a76:	8b 34 9d c0 3d 80 00 	mov    0x803dc0(,%ebx,4),%esi
  800a7d:	85 f6                	test   %esi,%esi
  800a7f:	75 19                	jne    800a9a <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800a81:	53                   	push   %ebx
  800a82:	68 65 3f 80 00       	push   $0x803f65
  800a87:	ff 75 0c             	pushl  0xc(%ebp)
  800a8a:	ff 75 08             	pushl  0x8(%ebp)
  800a8d:	e8 5e 02 00 00       	call   800cf0 <printfmt>
  800a92:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800a95:	e9 49 02 00 00       	jmp    800ce3 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a9a:	56                   	push   %esi
  800a9b:	68 6e 3f 80 00       	push   $0x803f6e
  800aa0:	ff 75 0c             	pushl  0xc(%ebp)
  800aa3:	ff 75 08             	pushl  0x8(%ebp)
  800aa6:	e8 45 02 00 00       	call   800cf0 <printfmt>
  800aab:	83 c4 10             	add    $0x10,%esp
			break;
  800aae:	e9 30 02 00 00       	jmp    800ce3 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800ab3:	8b 45 14             	mov    0x14(%ebp),%eax
  800ab6:	83 c0 04             	add    $0x4,%eax
  800ab9:	89 45 14             	mov    %eax,0x14(%ebp)
  800abc:	8b 45 14             	mov    0x14(%ebp),%eax
  800abf:	83 e8 04             	sub    $0x4,%eax
  800ac2:	8b 30                	mov    (%eax),%esi
  800ac4:	85 f6                	test   %esi,%esi
  800ac6:	75 05                	jne    800acd <vprintfmt+0x1a6>
				p = "(null)";
  800ac8:	be 71 3f 80 00       	mov    $0x803f71,%esi
			if (width > 0 && padc != '-')
  800acd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ad1:	7e 6d                	jle    800b40 <vprintfmt+0x219>
  800ad3:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800ad7:	74 67                	je     800b40 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800ad9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800adc:	83 ec 08             	sub    $0x8,%esp
  800adf:	50                   	push   %eax
  800ae0:	56                   	push   %esi
  800ae1:	e8 0c 03 00 00       	call   800df2 <strnlen>
  800ae6:	83 c4 10             	add    $0x10,%esp
  800ae9:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800aec:	eb 16                	jmp    800b04 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800aee:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800af2:	83 ec 08             	sub    $0x8,%esp
  800af5:	ff 75 0c             	pushl  0xc(%ebp)
  800af8:	50                   	push   %eax
  800af9:	8b 45 08             	mov    0x8(%ebp),%eax
  800afc:	ff d0                	call   *%eax
  800afe:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b01:	ff 4d e4             	decl   -0x1c(%ebp)
  800b04:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b08:	7f e4                	jg     800aee <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b0a:	eb 34                	jmp    800b40 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b0c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b10:	74 1c                	je     800b2e <vprintfmt+0x207>
  800b12:	83 fb 1f             	cmp    $0x1f,%ebx
  800b15:	7e 05                	jle    800b1c <vprintfmt+0x1f5>
  800b17:	83 fb 7e             	cmp    $0x7e,%ebx
  800b1a:	7e 12                	jle    800b2e <vprintfmt+0x207>
					putch('?', putdat);
  800b1c:	83 ec 08             	sub    $0x8,%esp
  800b1f:	ff 75 0c             	pushl  0xc(%ebp)
  800b22:	6a 3f                	push   $0x3f
  800b24:	8b 45 08             	mov    0x8(%ebp),%eax
  800b27:	ff d0                	call   *%eax
  800b29:	83 c4 10             	add    $0x10,%esp
  800b2c:	eb 0f                	jmp    800b3d <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b2e:	83 ec 08             	sub    $0x8,%esp
  800b31:	ff 75 0c             	pushl  0xc(%ebp)
  800b34:	53                   	push   %ebx
  800b35:	8b 45 08             	mov    0x8(%ebp),%eax
  800b38:	ff d0                	call   *%eax
  800b3a:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b3d:	ff 4d e4             	decl   -0x1c(%ebp)
  800b40:	89 f0                	mov    %esi,%eax
  800b42:	8d 70 01             	lea    0x1(%eax),%esi
  800b45:	8a 00                	mov    (%eax),%al
  800b47:	0f be d8             	movsbl %al,%ebx
  800b4a:	85 db                	test   %ebx,%ebx
  800b4c:	74 24                	je     800b72 <vprintfmt+0x24b>
  800b4e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b52:	78 b8                	js     800b0c <vprintfmt+0x1e5>
  800b54:	ff 4d e0             	decl   -0x20(%ebp)
  800b57:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b5b:	79 af                	jns    800b0c <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b5d:	eb 13                	jmp    800b72 <vprintfmt+0x24b>
				putch(' ', putdat);
  800b5f:	83 ec 08             	sub    $0x8,%esp
  800b62:	ff 75 0c             	pushl  0xc(%ebp)
  800b65:	6a 20                	push   $0x20
  800b67:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6a:	ff d0                	call   *%eax
  800b6c:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b6f:	ff 4d e4             	decl   -0x1c(%ebp)
  800b72:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b76:	7f e7                	jg     800b5f <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800b78:	e9 66 01 00 00       	jmp    800ce3 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800b7d:	83 ec 08             	sub    $0x8,%esp
  800b80:	ff 75 e8             	pushl  -0x18(%ebp)
  800b83:	8d 45 14             	lea    0x14(%ebp),%eax
  800b86:	50                   	push   %eax
  800b87:	e8 3c fd ff ff       	call   8008c8 <getint>
  800b8c:	83 c4 10             	add    $0x10,%esp
  800b8f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b92:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800b95:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b98:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b9b:	85 d2                	test   %edx,%edx
  800b9d:	79 23                	jns    800bc2 <vprintfmt+0x29b>
				putch('-', putdat);
  800b9f:	83 ec 08             	sub    $0x8,%esp
  800ba2:	ff 75 0c             	pushl  0xc(%ebp)
  800ba5:	6a 2d                	push   $0x2d
  800ba7:	8b 45 08             	mov    0x8(%ebp),%eax
  800baa:	ff d0                	call   *%eax
  800bac:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800baf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bb2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bb5:	f7 d8                	neg    %eax
  800bb7:	83 d2 00             	adc    $0x0,%edx
  800bba:	f7 da                	neg    %edx
  800bbc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bbf:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800bc2:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800bc9:	e9 bc 00 00 00       	jmp    800c8a <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800bce:	83 ec 08             	sub    $0x8,%esp
  800bd1:	ff 75 e8             	pushl  -0x18(%ebp)
  800bd4:	8d 45 14             	lea    0x14(%ebp),%eax
  800bd7:	50                   	push   %eax
  800bd8:	e8 84 fc ff ff       	call   800861 <getuint>
  800bdd:	83 c4 10             	add    $0x10,%esp
  800be0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800be3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800be6:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800bed:	e9 98 00 00 00       	jmp    800c8a <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800bf2:	83 ec 08             	sub    $0x8,%esp
  800bf5:	ff 75 0c             	pushl  0xc(%ebp)
  800bf8:	6a 58                	push   $0x58
  800bfa:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfd:	ff d0                	call   *%eax
  800bff:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c02:	83 ec 08             	sub    $0x8,%esp
  800c05:	ff 75 0c             	pushl  0xc(%ebp)
  800c08:	6a 58                	push   $0x58
  800c0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0d:	ff d0                	call   *%eax
  800c0f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c12:	83 ec 08             	sub    $0x8,%esp
  800c15:	ff 75 0c             	pushl  0xc(%ebp)
  800c18:	6a 58                	push   $0x58
  800c1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1d:	ff d0                	call   *%eax
  800c1f:	83 c4 10             	add    $0x10,%esp
			break;
  800c22:	e9 bc 00 00 00       	jmp    800ce3 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800c27:	83 ec 08             	sub    $0x8,%esp
  800c2a:	ff 75 0c             	pushl  0xc(%ebp)
  800c2d:	6a 30                	push   $0x30
  800c2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c32:	ff d0                	call   *%eax
  800c34:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c37:	83 ec 08             	sub    $0x8,%esp
  800c3a:	ff 75 0c             	pushl  0xc(%ebp)
  800c3d:	6a 78                	push   $0x78
  800c3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c42:	ff d0                	call   *%eax
  800c44:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c47:	8b 45 14             	mov    0x14(%ebp),%eax
  800c4a:	83 c0 04             	add    $0x4,%eax
  800c4d:	89 45 14             	mov    %eax,0x14(%ebp)
  800c50:	8b 45 14             	mov    0x14(%ebp),%eax
  800c53:	83 e8 04             	sub    $0x4,%eax
  800c56:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c58:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c5b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800c62:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800c69:	eb 1f                	jmp    800c8a <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800c6b:	83 ec 08             	sub    $0x8,%esp
  800c6e:	ff 75 e8             	pushl  -0x18(%ebp)
  800c71:	8d 45 14             	lea    0x14(%ebp),%eax
  800c74:	50                   	push   %eax
  800c75:	e8 e7 fb ff ff       	call   800861 <getuint>
  800c7a:	83 c4 10             	add    $0x10,%esp
  800c7d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c80:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800c83:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800c8a:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800c8e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c91:	83 ec 04             	sub    $0x4,%esp
  800c94:	52                   	push   %edx
  800c95:	ff 75 e4             	pushl  -0x1c(%ebp)
  800c98:	50                   	push   %eax
  800c99:	ff 75 f4             	pushl  -0xc(%ebp)
  800c9c:	ff 75 f0             	pushl  -0x10(%ebp)
  800c9f:	ff 75 0c             	pushl  0xc(%ebp)
  800ca2:	ff 75 08             	pushl  0x8(%ebp)
  800ca5:	e8 00 fb ff ff       	call   8007aa <printnum>
  800caa:	83 c4 20             	add    $0x20,%esp
			break;
  800cad:	eb 34                	jmp    800ce3 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800caf:	83 ec 08             	sub    $0x8,%esp
  800cb2:	ff 75 0c             	pushl  0xc(%ebp)
  800cb5:	53                   	push   %ebx
  800cb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb9:	ff d0                	call   *%eax
  800cbb:	83 c4 10             	add    $0x10,%esp
			break;
  800cbe:	eb 23                	jmp    800ce3 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800cc0:	83 ec 08             	sub    $0x8,%esp
  800cc3:	ff 75 0c             	pushl  0xc(%ebp)
  800cc6:	6a 25                	push   $0x25
  800cc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccb:	ff d0                	call   *%eax
  800ccd:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800cd0:	ff 4d 10             	decl   0x10(%ebp)
  800cd3:	eb 03                	jmp    800cd8 <vprintfmt+0x3b1>
  800cd5:	ff 4d 10             	decl   0x10(%ebp)
  800cd8:	8b 45 10             	mov    0x10(%ebp),%eax
  800cdb:	48                   	dec    %eax
  800cdc:	8a 00                	mov    (%eax),%al
  800cde:	3c 25                	cmp    $0x25,%al
  800ce0:	75 f3                	jne    800cd5 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800ce2:	90                   	nop
		}
	}
  800ce3:	e9 47 fc ff ff       	jmp    80092f <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800ce8:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800ce9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800cec:	5b                   	pop    %ebx
  800ced:	5e                   	pop    %esi
  800cee:	5d                   	pop    %ebp
  800cef:	c3                   	ret    

00800cf0 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800cf0:	55                   	push   %ebp
  800cf1:	89 e5                	mov    %esp,%ebp
  800cf3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800cf6:	8d 45 10             	lea    0x10(%ebp),%eax
  800cf9:	83 c0 04             	add    $0x4,%eax
  800cfc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800cff:	8b 45 10             	mov    0x10(%ebp),%eax
  800d02:	ff 75 f4             	pushl  -0xc(%ebp)
  800d05:	50                   	push   %eax
  800d06:	ff 75 0c             	pushl  0xc(%ebp)
  800d09:	ff 75 08             	pushl  0x8(%ebp)
  800d0c:	e8 16 fc ff ff       	call   800927 <vprintfmt>
  800d11:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d14:	90                   	nop
  800d15:	c9                   	leave  
  800d16:	c3                   	ret    

00800d17 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d17:	55                   	push   %ebp
  800d18:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d1d:	8b 40 08             	mov    0x8(%eax),%eax
  800d20:	8d 50 01             	lea    0x1(%eax),%edx
  800d23:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d26:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d29:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2c:	8b 10                	mov    (%eax),%edx
  800d2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d31:	8b 40 04             	mov    0x4(%eax),%eax
  800d34:	39 c2                	cmp    %eax,%edx
  800d36:	73 12                	jae    800d4a <sprintputch+0x33>
		*b->buf++ = ch;
  800d38:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3b:	8b 00                	mov    (%eax),%eax
  800d3d:	8d 48 01             	lea    0x1(%eax),%ecx
  800d40:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d43:	89 0a                	mov    %ecx,(%edx)
  800d45:	8b 55 08             	mov    0x8(%ebp),%edx
  800d48:	88 10                	mov    %dl,(%eax)
}
  800d4a:	90                   	nop
  800d4b:	5d                   	pop    %ebp
  800d4c:	c3                   	ret    

00800d4d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d4d:	55                   	push   %ebp
  800d4e:	89 e5                	mov    %esp,%ebp
  800d50:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d53:	8b 45 08             	mov    0x8(%ebp),%eax
  800d56:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d59:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5c:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d62:	01 d0                	add    %edx,%eax
  800d64:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d67:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800d6e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800d72:	74 06                	je     800d7a <vsnprintf+0x2d>
  800d74:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d78:	7f 07                	jg     800d81 <vsnprintf+0x34>
		return -E_INVAL;
  800d7a:	b8 03 00 00 00       	mov    $0x3,%eax
  800d7f:	eb 20                	jmp    800da1 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800d81:	ff 75 14             	pushl  0x14(%ebp)
  800d84:	ff 75 10             	pushl  0x10(%ebp)
  800d87:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800d8a:	50                   	push   %eax
  800d8b:	68 17 0d 80 00       	push   $0x800d17
  800d90:	e8 92 fb ff ff       	call   800927 <vprintfmt>
  800d95:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800d98:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d9b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800d9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800da1:	c9                   	leave  
  800da2:	c3                   	ret    

00800da3 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800da3:	55                   	push   %ebp
  800da4:	89 e5                	mov    %esp,%ebp
  800da6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800da9:	8d 45 10             	lea    0x10(%ebp),%eax
  800dac:	83 c0 04             	add    $0x4,%eax
  800daf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800db2:	8b 45 10             	mov    0x10(%ebp),%eax
  800db5:	ff 75 f4             	pushl  -0xc(%ebp)
  800db8:	50                   	push   %eax
  800db9:	ff 75 0c             	pushl  0xc(%ebp)
  800dbc:	ff 75 08             	pushl  0x8(%ebp)
  800dbf:	e8 89 ff ff ff       	call   800d4d <vsnprintf>
  800dc4:	83 c4 10             	add    $0x10,%esp
  800dc7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800dca:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800dcd:	c9                   	leave  
  800dce:	c3                   	ret    

00800dcf <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800dcf:	55                   	push   %ebp
  800dd0:	89 e5                	mov    %esp,%ebp
  800dd2:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800dd5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ddc:	eb 06                	jmp    800de4 <strlen+0x15>
		n++;
  800dde:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800de1:	ff 45 08             	incl   0x8(%ebp)
  800de4:	8b 45 08             	mov    0x8(%ebp),%eax
  800de7:	8a 00                	mov    (%eax),%al
  800de9:	84 c0                	test   %al,%al
  800deb:	75 f1                	jne    800dde <strlen+0xf>
		n++;
	return n;
  800ded:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800df0:	c9                   	leave  
  800df1:	c3                   	ret    

00800df2 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800df2:	55                   	push   %ebp
  800df3:	89 e5                	mov    %esp,%ebp
  800df5:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800df8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800dff:	eb 09                	jmp    800e0a <strnlen+0x18>
		n++;
  800e01:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e04:	ff 45 08             	incl   0x8(%ebp)
  800e07:	ff 4d 0c             	decl   0xc(%ebp)
  800e0a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e0e:	74 09                	je     800e19 <strnlen+0x27>
  800e10:	8b 45 08             	mov    0x8(%ebp),%eax
  800e13:	8a 00                	mov    (%eax),%al
  800e15:	84 c0                	test   %al,%al
  800e17:	75 e8                	jne    800e01 <strnlen+0xf>
		n++;
	return n;
  800e19:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e1c:	c9                   	leave  
  800e1d:	c3                   	ret    

00800e1e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e1e:	55                   	push   %ebp
  800e1f:	89 e5                	mov    %esp,%ebp
  800e21:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e24:	8b 45 08             	mov    0x8(%ebp),%eax
  800e27:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e2a:	90                   	nop
  800e2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2e:	8d 50 01             	lea    0x1(%eax),%edx
  800e31:	89 55 08             	mov    %edx,0x8(%ebp)
  800e34:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e37:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e3a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e3d:	8a 12                	mov    (%edx),%dl
  800e3f:	88 10                	mov    %dl,(%eax)
  800e41:	8a 00                	mov    (%eax),%al
  800e43:	84 c0                	test   %al,%al
  800e45:	75 e4                	jne    800e2b <strcpy+0xd>
		/* do nothing */;
	return ret;
  800e47:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e4a:	c9                   	leave  
  800e4b:	c3                   	ret    

00800e4c <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800e4c:	55                   	push   %ebp
  800e4d:	89 e5                	mov    %esp,%ebp
  800e4f:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800e52:	8b 45 08             	mov    0x8(%ebp),%eax
  800e55:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800e58:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e5f:	eb 1f                	jmp    800e80 <strncpy+0x34>
		*dst++ = *src;
  800e61:	8b 45 08             	mov    0x8(%ebp),%eax
  800e64:	8d 50 01             	lea    0x1(%eax),%edx
  800e67:	89 55 08             	mov    %edx,0x8(%ebp)
  800e6a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e6d:	8a 12                	mov    (%edx),%dl
  800e6f:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800e71:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e74:	8a 00                	mov    (%eax),%al
  800e76:	84 c0                	test   %al,%al
  800e78:	74 03                	je     800e7d <strncpy+0x31>
			src++;
  800e7a:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800e7d:	ff 45 fc             	incl   -0x4(%ebp)
  800e80:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e83:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e86:	72 d9                	jb     800e61 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800e88:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e8b:	c9                   	leave  
  800e8c:	c3                   	ret    

00800e8d <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800e8d:	55                   	push   %ebp
  800e8e:	89 e5                	mov    %esp,%ebp
  800e90:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800e93:	8b 45 08             	mov    0x8(%ebp),%eax
  800e96:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800e99:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e9d:	74 30                	je     800ecf <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800e9f:	eb 16                	jmp    800eb7 <strlcpy+0x2a>
			*dst++ = *src++;
  800ea1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea4:	8d 50 01             	lea    0x1(%eax),%edx
  800ea7:	89 55 08             	mov    %edx,0x8(%ebp)
  800eaa:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ead:	8d 4a 01             	lea    0x1(%edx),%ecx
  800eb0:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800eb3:	8a 12                	mov    (%edx),%dl
  800eb5:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800eb7:	ff 4d 10             	decl   0x10(%ebp)
  800eba:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ebe:	74 09                	je     800ec9 <strlcpy+0x3c>
  800ec0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec3:	8a 00                	mov    (%eax),%al
  800ec5:	84 c0                	test   %al,%al
  800ec7:	75 d8                	jne    800ea1 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ec9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecc:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ecf:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ed5:	29 c2                	sub    %eax,%edx
  800ed7:	89 d0                	mov    %edx,%eax
}
  800ed9:	c9                   	leave  
  800eda:	c3                   	ret    

00800edb <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800edb:	55                   	push   %ebp
  800edc:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800ede:	eb 06                	jmp    800ee6 <strcmp+0xb>
		p++, q++;
  800ee0:	ff 45 08             	incl   0x8(%ebp)
  800ee3:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ee6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee9:	8a 00                	mov    (%eax),%al
  800eeb:	84 c0                	test   %al,%al
  800eed:	74 0e                	je     800efd <strcmp+0x22>
  800eef:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef2:	8a 10                	mov    (%eax),%dl
  800ef4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ef7:	8a 00                	mov    (%eax),%al
  800ef9:	38 c2                	cmp    %al,%dl
  800efb:	74 e3                	je     800ee0 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800efd:	8b 45 08             	mov    0x8(%ebp),%eax
  800f00:	8a 00                	mov    (%eax),%al
  800f02:	0f b6 d0             	movzbl %al,%edx
  800f05:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f08:	8a 00                	mov    (%eax),%al
  800f0a:	0f b6 c0             	movzbl %al,%eax
  800f0d:	29 c2                	sub    %eax,%edx
  800f0f:	89 d0                	mov    %edx,%eax
}
  800f11:	5d                   	pop    %ebp
  800f12:	c3                   	ret    

00800f13 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f13:	55                   	push   %ebp
  800f14:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f16:	eb 09                	jmp    800f21 <strncmp+0xe>
		n--, p++, q++;
  800f18:	ff 4d 10             	decl   0x10(%ebp)
  800f1b:	ff 45 08             	incl   0x8(%ebp)
  800f1e:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f21:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f25:	74 17                	je     800f3e <strncmp+0x2b>
  800f27:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2a:	8a 00                	mov    (%eax),%al
  800f2c:	84 c0                	test   %al,%al
  800f2e:	74 0e                	je     800f3e <strncmp+0x2b>
  800f30:	8b 45 08             	mov    0x8(%ebp),%eax
  800f33:	8a 10                	mov    (%eax),%dl
  800f35:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f38:	8a 00                	mov    (%eax),%al
  800f3a:	38 c2                	cmp    %al,%dl
  800f3c:	74 da                	je     800f18 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f3e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f42:	75 07                	jne    800f4b <strncmp+0x38>
		return 0;
  800f44:	b8 00 00 00 00       	mov    $0x0,%eax
  800f49:	eb 14                	jmp    800f5f <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800f4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4e:	8a 00                	mov    (%eax),%al
  800f50:	0f b6 d0             	movzbl %al,%edx
  800f53:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f56:	8a 00                	mov    (%eax),%al
  800f58:	0f b6 c0             	movzbl %al,%eax
  800f5b:	29 c2                	sub    %eax,%edx
  800f5d:	89 d0                	mov    %edx,%eax
}
  800f5f:	5d                   	pop    %ebp
  800f60:	c3                   	ret    

00800f61 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800f61:	55                   	push   %ebp
  800f62:	89 e5                	mov    %esp,%ebp
  800f64:	83 ec 04             	sub    $0x4,%esp
  800f67:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f6a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f6d:	eb 12                	jmp    800f81 <strchr+0x20>
		if (*s == c)
  800f6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f72:	8a 00                	mov    (%eax),%al
  800f74:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f77:	75 05                	jne    800f7e <strchr+0x1d>
			return (char *) s;
  800f79:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7c:	eb 11                	jmp    800f8f <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800f7e:	ff 45 08             	incl   0x8(%ebp)
  800f81:	8b 45 08             	mov    0x8(%ebp),%eax
  800f84:	8a 00                	mov    (%eax),%al
  800f86:	84 c0                	test   %al,%al
  800f88:	75 e5                	jne    800f6f <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800f8a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f8f:	c9                   	leave  
  800f90:	c3                   	ret    

00800f91 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800f91:	55                   	push   %ebp
  800f92:	89 e5                	mov    %esp,%ebp
  800f94:	83 ec 04             	sub    $0x4,%esp
  800f97:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f9a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f9d:	eb 0d                	jmp    800fac <strfind+0x1b>
		if (*s == c)
  800f9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa2:	8a 00                	mov    (%eax),%al
  800fa4:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fa7:	74 0e                	je     800fb7 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800fa9:	ff 45 08             	incl   0x8(%ebp)
  800fac:	8b 45 08             	mov    0x8(%ebp),%eax
  800faf:	8a 00                	mov    (%eax),%al
  800fb1:	84 c0                	test   %al,%al
  800fb3:	75 ea                	jne    800f9f <strfind+0xe>
  800fb5:	eb 01                	jmp    800fb8 <strfind+0x27>
		if (*s == c)
			break;
  800fb7:	90                   	nop
	return (char *) s;
  800fb8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fbb:	c9                   	leave  
  800fbc:	c3                   	ret    

00800fbd <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800fbd:	55                   	push   %ebp
  800fbe:	89 e5                	mov    %esp,%ebp
  800fc0:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800fc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800fc9:	8b 45 10             	mov    0x10(%ebp),%eax
  800fcc:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800fcf:	eb 0e                	jmp    800fdf <memset+0x22>
		*p++ = c;
  800fd1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fd4:	8d 50 01             	lea    0x1(%eax),%edx
  800fd7:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800fda:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fdd:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800fdf:	ff 4d f8             	decl   -0x8(%ebp)
  800fe2:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800fe6:	79 e9                	jns    800fd1 <memset+0x14>
		*p++ = c;

	return v;
  800fe8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800feb:	c9                   	leave  
  800fec:	c3                   	ret    

00800fed <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800fed:	55                   	push   %ebp
  800fee:	89 e5                	mov    %esp,%ebp
  800ff0:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800ff3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800ff9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffc:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800fff:	eb 16                	jmp    801017 <memcpy+0x2a>
		*d++ = *s++;
  801001:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801004:	8d 50 01             	lea    0x1(%eax),%edx
  801007:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80100a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80100d:	8d 4a 01             	lea    0x1(%edx),%ecx
  801010:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801013:	8a 12                	mov    (%edx),%dl
  801015:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801017:	8b 45 10             	mov    0x10(%ebp),%eax
  80101a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80101d:	89 55 10             	mov    %edx,0x10(%ebp)
  801020:	85 c0                	test   %eax,%eax
  801022:	75 dd                	jne    801001 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801024:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801027:	c9                   	leave  
  801028:	c3                   	ret    

00801029 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801029:	55                   	push   %ebp
  80102a:	89 e5                	mov    %esp,%ebp
  80102c:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80102f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801032:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801035:	8b 45 08             	mov    0x8(%ebp),%eax
  801038:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80103b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80103e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801041:	73 50                	jae    801093 <memmove+0x6a>
  801043:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801046:	8b 45 10             	mov    0x10(%ebp),%eax
  801049:	01 d0                	add    %edx,%eax
  80104b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80104e:	76 43                	jbe    801093 <memmove+0x6a>
		s += n;
  801050:	8b 45 10             	mov    0x10(%ebp),%eax
  801053:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801056:	8b 45 10             	mov    0x10(%ebp),%eax
  801059:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80105c:	eb 10                	jmp    80106e <memmove+0x45>
			*--d = *--s;
  80105e:	ff 4d f8             	decl   -0x8(%ebp)
  801061:	ff 4d fc             	decl   -0x4(%ebp)
  801064:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801067:	8a 10                	mov    (%eax),%dl
  801069:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80106c:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80106e:	8b 45 10             	mov    0x10(%ebp),%eax
  801071:	8d 50 ff             	lea    -0x1(%eax),%edx
  801074:	89 55 10             	mov    %edx,0x10(%ebp)
  801077:	85 c0                	test   %eax,%eax
  801079:	75 e3                	jne    80105e <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80107b:	eb 23                	jmp    8010a0 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80107d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801080:	8d 50 01             	lea    0x1(%eax),%edx
  801083:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801086:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801089:	8d 4a 01             	lea    0x1(%edx),%ecx
  80108c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80108f:	8a 12                	mov    (%edx),%dl
  801091:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801093:	8b 45 10             	mov    0x10(%ebp),%eax
  801096:	8d 50 ff             	lea    -0x1(%eax),%edx
  801099:	89 55 10             	mov    %edx,0x10(%ebp)
  80109c:	85 c0                	test   %eax,%eax
  80109e:	75 dd                	jne    80107d <memmove+0x54>
			*d++ = *s++;

	return dst;
  8010a0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010a3:	c9                   	leave  
  8010a4:	c3                   	ret    

008010a5 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8010a5:	55                   	push   %ebp
  8010a6:	89 e5                	mov    %esp,%ebp
  8010a8:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8010ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ae:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8010b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b4:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8010b7:	eb 2a                	jmp    8010e3 <memcmp+0x3e>
		if (*s1 != *s2)
  8010b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010bc:	8a 10                	mov    (%eax),%dl
  8010be:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010c1:	8a 00                	mov    (%eax),%al
  8010c3:	38 c2                	cmp    %al,%dl
  8010c5:	74 16                	je     8010dd <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8010c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010ca:	8a 00                	mov    (%eax),%al
  8010cc:	0f b6 d0             	movzbl %al,%edx
  8010cf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010d2:	8a 00                	mov    (%eax),%al
  8010d4:	0f b6 c0             	movzbl %al,%eax
  8010d7:	29 c2                	sub    %eax,%edx
  8010d9:	89 d0                	mov    %edx,%eax
  8010db:	eb 18                	jmp    8010f5 <memcmp+0x50>
		s1++, s2++;
  8010dd:	ff 45 fc             	incl   -0x4(%ebp)
  8010e0:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8010e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8010e6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010e9:	89 55 10             	mov    %edx,0x10(%ebp)
  8010ec:	85 c0                	test   %eax,%eax
  8010ee:	75 c9                	jne    8010b9 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8010f0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010f5:	c9                   	leave  
  8010f6:	c3                   	ret    

008010f7 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8010f7:	55                   	push   %ebp
  8010f8:	89 e5                	mov    %esp,%ebp
  8010fa:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8010fd:	8b 55 08             	mov    0x8(%ebp),%edx
  801100:	8b 45 10             	mov    0x10(%ebp),%eax
  801103:	01 d0                	add    %edx,%eax
  801105:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801108:	eb 15                	jmp    80111f <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80110a:	8b 45 08             	mov    0x8(%ebp),%eax
  80110d:	8a 00                	mov    (%eax),%al
  80110f:	0f b6 d0             	movzbl %al,%edx
  801112:	8b 45 0c             	mov    0xc(%ebp),%eax
  801115:	0f b6 c0             	movzbl %al,%eax
  801118:	39 c2                	cmp    %eax,%edx
  80111a:	74 0d                	je     801129 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80111c:	ff 45 08             	incl   0x8(%ebp)
  80111f:	8b 45 08             	mov    0x8(%ebp),%eax
  801122:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801125:	72 e3                	jb     80110a <memfind+0x13>
  801127:	eb 01                	jmp    80112a <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801129:	90                   	nop
	return (void *) s;
  80112a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80112d:	c9                   	leave  
  80112e:	c3                   	ret    

0080112f <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80112f:	55                   	push   %ebp
  801130:	89 e5                	mov    %esp,%ebp
  801132:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801135:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80113c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801143:	eb 03                	jmp    801148 <strtol+0x19>
		s++;
  801145:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801148:	8b 45 08             	mov    0x8(%ebp),%eax
  80114b:	8a 00                	mov    (%eax),%al
  80114d:	3c 20                	cmp    $0x20,%al
  80114f:	74 f4                	je     801145 <strtol+0x16>
  801151:	8b 45 08             	mov    0x8(%ebp),%eax
  801154:	8a 00                	mov    (%eax),%al
  801156:	3c 09                	cmp    $0x9,%al
  801158:	74 eb                	je     801145 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80115a:	8b 45 08             	mov    0x8(%ebp),%eax
  80115d:	8a 00                	mov    (%eax),%al
  80115f:	3c 2b                	cmp    $0x2b,%al
  801161:	75 05                	jne    801168 <strtol+0x39>
		s++;
  801163:	ff 45 08             	incl   0x8(%ebp)
  801166:	eb 13                	jmp    80117b <strtol+0x4c>
	else if (*s == '-')
  801168:	8b 45 08             	mov    0x8(%ebp),%eax
  80116b:	8a 00                	mov    (%eax),%al
  80116d:	3c 2d                	cmp    $0x2d,%al
  80116f:	75 0a                	jne    80117b <strtol+0x4c>
		s++, neg = 1;
  801171:	ff 45 08             	incl   0x8(%ebp)
  801174:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80117b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80117f:	74 06                	je     801187 <strtol+0x58>
  801181:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801185:	75 20                	jne    8011a7 <strtol+0x78>
  801187:	8b 45 08             	mov    0x8(%ebp),%eax
  80118a:	8a 00                	mov    (%eax),%al
  80118c:	3c 30                	cmp    $0x30,%al
  80118e:	75 17                	jne    8011a7 <strtol+0x78>
  801190:	8b 45 08             	mov    0x8(%ebp),%eax
  801193:	40                   	inc    %eax
  801194:	8a 00                	mov    (%eax),%al
  801196:	3c 78                	cmp    $0x78,%al
  801198:	75 0d                	jne    8011a7 <strtol+0x78>
		s += 2, base = 16;
  80119a:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80119e:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8011a5:	eb 28                	jmp    8011cf <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8011a7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011ab:	75 15                	jne    8011c2 <strtol+0x93>
  8011ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b0:	8a 00                	mov    (%eax),%al
  8011b2:	3c 30                	cmp    $0x30,%al
  8011b4:	75 0c                	jne    8011c2 <strtol+0x93>
		s++, base = 8;
  8011b6:	ff 45 08             	incl   0x8(%ebp)
  8011b9:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8011c0:	eb 0d                	jmp    8011cf <strtol+0xa0>
	else if (base == 0)
  8011c2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011c6:	75 07                	jne    8011cf <strtol+0xa0>
		base = 10;
  8011c8:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8011cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d2:	8a 00                	mov    (%eax),%al
  8011d4:	3c 2f                	cmp    $0x2f,%al
  8011d6:	7e 19                	jle    8011f1 <strtol+0xc2>
  8011d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011db:	8a 00                	mov    (%eax),%al
  8011dd:	3c 39                	cmp    $0x39,%al
  8011df:	7f 10                	jg     8011f1 <strtol+0xc2>
			dig = *s - '0';
  8011e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e4:	8a 00                	mov    (%eax),%al
  8011e6:	0f be c0             	movsbl %al,%eax
  8011e9:	83 e8 30             	sub    $0x30,%eax
  8011ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8011ef:	eb 42                	jmp    801233 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8011f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f4:	8a 00                	mov    (%eax),%al
  8011f6:	3c 60                	cmp    $0x60,%al
  8011f8:	7e 19                	jle    801213 <strtol+0xe4>
  8011fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fd:	8a 00                	mov    (%eax),%al
  8011ff:	3c 7a                	cmp    $0x7a,%al
  801201:	7f 10                	jg     801213 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801203:	8b 45 08             	mov    0x8(%ebp),%eax
  801206:	8a 00                	mov    (%eax),%al
  801208:	0f be c0             	movsbl %al,%eax
  80120b:	83 e8 57             	sub    $0x57,%eax
  80120e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801211:	eb 20                	jmp    801233 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801213:	8b 45 08             	mov    0x8(%ebp),%eax
  801216:	8a 00                	mov    (%eax),%al
  801218:	3c 40                	cmp    $0x40,%al
  80121a:	7e 39                	jle    801255 <strtol+0x126>
  80121c:	8b 45 08             	mov    0x8(%ebp),%eax
  80121f:	8a 00                	mov    (%eax),%al
  801221:	3c 5a                	cmp    $0x5a,%al
  801223:	7f 30                	jg     801255 <strtol+0x126>
			dig = *s - 'A' + 10;
  801225:	8b 45 08             	mov    0x8(%ebp),%eax
  801228:	8a 00                	mov    (%eax),%al
  80122a:	0f be c0             	movsbl %al,%eax
  80122d:	83 e8 37             	sub    $0x37,%eax
  801230:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801233:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801236:	3b 45 10             	cmp    0x10(%ebp),%eax
  801239:	7d 19                	jge    801254 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80123b:	ff 45 08             	incl   0x8(%ebp)
  80123e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801241:	0f af 45 10          	imul   0x10(%ebp),%eax
  801245:	89 c2                	mov    %eax,%edx
  801247:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80124a:	01 d0                	add    %edx,%eax
  80124c:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80124f:	e9 7b ff ff ff       	jmp    8011cf <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801254:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801255:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801259:	74 08                	je     801263 <strtol+0x134>
		*endptr = (char *) s;
  80125b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80125e:	8b 55 08             	mov    0x8(%ebp),%edx
  801261:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801263:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801267:	74 07                	je     801270 <strtol+0x141>
  801269:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80126c:	f7 d8                	neg    %eax
  80126e:	eb 03                	jmp    801273 <strtol+0x144>
  801270:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801273:	c9                   	leave  
  801274:	c3                   	ret    

00801275 <ltostr>:

void
ltostr(long value, char *str)
{
  801275:	55                   	push   %ebp
  801276:	89 e5                	mov    %esp,%ebp
  801278:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80127b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801282:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801289:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80128d:	79 13                	jns    8012a2 <ltostr+0x2d>
	{
		neg = 1;
  80128f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801296:	8b 45 0c             	mov    0xc(%ebp),%eax
  801299:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80129c:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80129f:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8012a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a5:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8012aa:	99                   	cltd   
  8012ab:	f7 f9                	idiv   %ecx
  8012ad:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8012b0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012b3:	8d 50 01             	lea    0x1(%eax),%edx
  8012b6:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012b9:	89 c2                	mov    %eax,%edx
  8012bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012be:	01 d0                	add    %edx,%eax
  8012c0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8012c3:	83 c2 30             	add    $0x30,%edx
  8012c6:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8012c8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012cb:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8012d0:	f7 e9                	imul   %ecx
  8012d2:	c1 fa 02             	sar    $0x2,%edx
  8012d5:	89 c8                	mov    %ecx,%eax
  8012d7:	c1 f8 1f             	sar    $0x1f,%eax
  8012da:	29 c2                	sub    %eax,%edx
  8012dc:	89 d0                	mov    %edx,%eax
  8012de:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8012e1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012e4:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8012e9:	f7 e9                	imul   %ecx
  8012eb:	c1 fa 02             	sar    $0x2,%edx
  8012ee:	89 c8                	mov    %ecx,%eax
  8012f0:	c1 f8 1f             	sar    $0x1f,%eax
  8012f3:	29 c2                	sub    %eax,%edx
  8012f5:	89 d0                	mov    %edx,%eax
  8012f7:	c1 e0 02             	shl    $0x2,%eax
  8012fa:	01 d0                	add    %edx,%eax
  8012fc:	01 c0                	add    %eax,%eax
  8012fe:	29 c1                	sub    %eax,%ecx
  801300:	89 ca                	mov    %ecx,%edx
  801302:	85 d2                	test   %edx,%edx
  801304:	75 9c                	jne    8012a2 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801306:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80130d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801310:	48                   	dec    %eax
  801311:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801314:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801318:	74 3d                	je     801357 <ltostr+0xe2>
		start = 1 ;
  80131a:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801321:	eb 34                	jmp    801357 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801323:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801326:	8b 45 0c             	mov    0xc(%ebp),%eax
  801329:	01 d0                	add    %edx,%eax
  80132b:	8a 00                	mov    (%eax),%al
  80132d:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801330:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801333:	8b 45 0c             	mov    0xc(%ebp),%eax
  801336:	01 c2                	add    %eax,%edx
  801338:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80133b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80133e:	01 c8                	add    %ecx,%eax
  801340:	8a 00                	mov    (%eax),%al
  801342:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801344:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801347:	8b 45 0c             	mov    0xc(%ebp),%eax
  80134a:	01 c2                	add    %eax,%edx
  80134c:	8a 45 eb             	mov    -0x15(%ebp),%al
  80134f:	88 02                	mov    %al,(%edx)
		start++ ;
  801351:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801354:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801357:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80135a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80135d:	7c c4                	jl     801323 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80135f:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801362:	8b 45 0c             	mov    0xc(%ebp),%eax
  801365:	01 d0                	add    %edx,%eax
  801367:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80136a:	90                   	nop
  80136b:	c9                   	leave  
  80136c:	c3                   	ret    

0080136d <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80136d:	55                   	push   %ebp
  80136e:	89 e5                	mov    %esp,%ebp
  801370:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801373:	ff 75 08             	pushl  0x8(%ebp)
  801376:	e8 54 fa ff ff       	call   800dcf <strlen>
  80137b:	83 c4 04             	add    $0x4,%esp
  80137e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801381:	ff 75 0c             	pushl  0xc(%ebp)
  801384:	e8 46 fa ff ff       	call   800dcf <strlen>
  801389:	83 c4 04             	add    $0x4,%esp
  80138c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80138f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801396:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80139d:	eb 17                	jmp    8013b6 <strcconcat+0x49>
		final[s] = str1[s] ;
  80139f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8013a5:	01 c2                	add    %eax,%edx
  8013a7:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8013aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ad:	01 c8                	add    %ecx,%eax
  8013af:	8a 00                	mov    (%eax),%al
  8013b1:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8013b3:	ff 45 fc             	incl   -0x4(%ebp)
  8013b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013b9:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8013bc:	7c e1                	jl     80139f <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8013be:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8013c5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8013cc:	eb 1f                	jmp    8013ed <strcconcat+0x80>
		final[s++] = str2[i] ;
  8013ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013d1:	8d 50 01             	lea    0x1(%eax),%edx
  8013d4:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8013d7:	89 c2                	mov    %eax,%edx
  8013d9:	8b 45 10             	mov    0x10(%ebp),%eax
  8013dc:	01 c2                	add    %eax,%edx
  8013de:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8013e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013e4:	01 c8                	add    %ecx,%eax
  8013e6:	8a 00                	mov    (%eax),%al
  8013e8:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8013ea:	ff 45 f8             	incl   -0x8(%ebp)
  8013ed:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013f0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8013f3:	7c d9                	jl     8013ce <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8013f5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013f8:	8b 45 10             	mov    0x10(%ebp),%eax
  8013fb:	01 d0                	add    %edx,%eax
  8013fd:	c6 00 00             	movb   $0x0,(%eax)
}
  801400:	90                   	nop
  801401:	c9                   	leave  
  801402:	c3                   	ret    

00801403 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801403:	55                   	push   %ebp
  801404:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801406:	8b 45 14             	mov    0x14(%ebp),%eax
  801409:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80140f:	8b 45 14             	mov    0x14(%ebp),%eax
  801412:	8b 00                	mov    (%eax),%eax
  801414:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80141b:	8b 45 10             	mov    0x10(%ebp),%eax
  80141e:	01 d0                	add    %edx,%eax
  801420:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801426:	eb 0c                	jmp    801434 <strsplit+0x31>
			*string++ = 0;
  801428:	8b 45 08             	mov    0x8(%ebp),%eax
  80142b:	8d 50 01             	lea    0x1(%eax),%edx
  80142e:	89 55 08             	mov    %edx,0x8(%ebp)
  801431:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801434:	8b 45 08             	mov    0x8(%ebp),%eax
  801437:	8a 00                	mov    (%eax),%al
  801439:	84 c0                	test   %al,%al
  80143b:	74 18                	je     801455 <strsplit+0x52>
  80143d:	8b 45 08             	mov    0x8(%ebp),%eax
  801440:	8a 00                	mov    (%eax),%al
  801442:	0f be c0             	movsbl %al,%eax
  801445:	50                   	push   %eax
  801446:	ff 75 0c             	pushl  0xc(%ebp)
  801449:	e8 13 fb ff ff       	call   800f61 <strchr>
  80144e:	83 c4 08             	add    $0x8,%esp
  801451:	85 c0                	test   %eax,%eax
  801453:	75 d3                	jne    801428 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801455:	8b 45 08             	mov    0x8(%ebp),%eax
  801458:	8a 00                	mov    (%eax),%al
  80145a:	84 c0                	test   %al,%al
  80145c:	74 5a                	je     8014b8 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80145e:	8b 45 14             	mov    0x14(%ebp),%eax
  801461:	8b 00                	mov    (%eax),%eax
  801463:	83 f8 0f             	cmp    $0xf,%eax
  801466:	75 07                	jne    80146f <strsplit+0x6c>
		{
			return 0;
  801468:	b8 00 00 00 00       	mov    $0x0,%eax
  80146d:	eb 66                	jmp    8014d5 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80146f:	8b 45 14             	mov    0x14(%ebp),%eax
  801472:	8b 00                	mov    (%eax),%eax
  801474:	8d 48 01             	lea    0x1(%eax),%ecx
  801477:	8b 55 14             	mov    0x14(%ebp),%edx
  80147a:	89 0a                	mov    %ecx,(%edx)
  80147c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801483:	8b 45 10             	mov    0x10(%ebp),%eax
  801486:	01 c2                	add    %eax,%edx
  801488:	8b 45 08             	mov    0x8(%ebp),%eax
  80148b:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80148d:	eb 03                	jmp    801492 <strsplit+0x8f>
			string++;
  80148f:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801492:	8b 45 08             	mov    0x8(%ebp),%eax
  801495:	8a 00                	mov    (%eax),%al
  801497:	84 c0                	test   %al,%al
  801499:	74 8b                	je     801426 <strsplit+0x23>
  80149b:	8b 45 08             	mov    0x8(%ebp),%eax
  80149e:	8a 00                	mov    (%eax),%al
  8014a0:	0f be c0             	movsbl %al,%eax
  8014a3:	50                   	push   %eax
  8014a4:	ff 75 0c             	pushl  0xc(%ebp)
  8014a7:	e8 b5 fa ff ff       	call   800f61 <strchr>
  8014ac:	83 c4 08             	add    $0x8,%esp
  8014af:	85 c0                	test   %eax,%eax
  8014b1:	74 dc                	je     80148f <strsplit+0x8c>
			string++;
	}
  8014b3:	e9 6e ff ff ff       	jmp    801426 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8014b8:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8014b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8014bc:	8b 00                	mov    (%eax),%eax
  8014be:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8014c8:	01 d0                	add    %edx,%eax
  8014ca:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8014d0:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8014d5:	c9                   	leave  
  8014d6:	c3                   	ret    

008014d7 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8014d7:	55                   	push   %ebp
  8014d8:	89 e5                	mov    %esp,%ebp
  8014da:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8014dd:	a1 04 50 80 00       	mov    0x805004,%eax
  8014e2:	85 c0                	test   %eax,%eax
  8014e4:	74 1f                	je     801505 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8014e6:	e8 1d 00 00 00       	call   801508 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8014eb:	83 ec 0c             	sub    $0xc,%esp
  8014ee:	68 d0 40 80 00       	push   $0x8040d0
  8014f3:	e8 55 f2 ff ff       	call   80074d <cprintf>
  8014f8:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8014fb:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801502:	00 00 00 
	}
}
  801505:	90                   	nop
  801506:	c9                   	leave  
  801507:	c3                   	ret    

00801508 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801508:	55                   	push   %ebp
  801509:	89 e5                	mov    %esp,%ebp
  80150b:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	LIST_INIT(&AllocMemBlocksList);
  80150e:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801515:	00 00 00 
  801518:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  80151f:	00 00 00 
  801522:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801529:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  80152c:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801533:	00 00 00 
  801536:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  80153d:	00 00 00 
  801540:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801547:	00 00 00 
	uint32 arr_size = 0;
  80154a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	MemBlockNodes  =(struct MemBlock*) USER_DYN_BLKS_ARRAY;
  801551:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  801558:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80155b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801560:	2d 00 10 00 00       	sub    $0x1000,%eax
  801565:	a3 50 50 80 00       	mov    %eax,0x805050
	MAX_MEM_BLOCK_CNT = (USER_HEAP_MAX-USER_HEAP_START)/PAGE_SIZE;
  80156a:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801571:	00 02 00 
	arr_size =  ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock), PAGE_SIZE);
  801574:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80157b:	a1 20 51 80 00       	mov    0x805120,%eax
  801580:	c1 e0 04             	shl    $0x4,%eax
  801583:	89 c2                	mov    %eax,%edx
  801585:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801588:	01 d0                	add    %edx,%eax
  80158a:	48                   	dec    %eax
  80158b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80158e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801591:	ba 00 00 00 00       	mov    $0x0,%edx
  801596:	f7 75 ec             	divl   -0x14(%ebp)
  801599:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80159c:	29 d0                	sub    %edx,%eax
  80159e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY , arr_size , PERM_WRITEABLE | PERM_USER);
  8015a1:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  8015a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8015ab:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8015b0:	2d 00 10 00 00       	sub    $0x1000,%eax
  8015b5:	83 ec 04             	sub    $0x4,%esp
  8015b8:	6a 06                	push   $0x6
  8015ba:	ff 75 f4             	pushl  -0xc(%ebp)
  8015bd:	50                   	push   %eax
  8015be:	e8 fc 04 00 00       	call   801abf <sys_allocate_chunk>
  8015c3:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8015c6:	a1 20 51 80 00       	mov    0x805120,%eax
  8015cb:	83 ec 0c             	sub    $0xc,%esp
  8015ce:	50                   	push   %eax
  8015cf:	e8 71 0b 00 00       	call   802145 <initialize_MemBlocksList>
  8015d4:	83 c4 10             	add    $0x10,%esp
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	struct MemBlock * NewBlock = LIST_FIRST(&AvailableMemBlocksList);
  8015d7:	a1 48 51 80 00       	mov    0x805148,%eax
  8015dc:	89 45 e0             	mov    %eax,-0x20(%ebp)
	NewBlock->sva = USER_HEAP_START;
  8015df:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015e2:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	NewBlock->size = (USER_HEAP_MAX-USER_HEAP_START);
  8015e9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015ec:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	LIST_REMOVE(&AvailableMemBlocksList,NewBlock);
  8015f3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8015f7:	75 14                	jne    80160d <initialize_dyn_block_system+0x105>
  8015f9:	83 ec 04             	sub    $0x4,%esp
  8015fc:	68 f5 40 80 00       	push   $0x8040f5
  801601:	6a 33                	push   $0x33
  801603:	68 13 41 80 00       	push   $0x804113
  801608:	e8 8c ee ff ff       	call   800499 <_panic>
  80160d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801610:	8b 00                	mov    (%eax),%eax
  801612:	85 c0                	test   %eax,%eax
  801614:	74 10                	je     801626 <initialize_dyn_block_system+0x11e>
  801616:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801619:	8b 00                	mov    (%eax),%eax
  80161b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80161e:	8b 52 04             	mov    0x4(%edx),%edx
  801621:	89 50 04             	mov    %edx,0x4(%eax)
  801624:	eb 0b                	jmp    801631 <initialize_dyn_block_system+0x129>
  801626:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801629:	8b 40 04             	mov    0x4(%eax),%eax
  80162c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801631:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801634:	8b 40 04             	mov    0x4(%eax),%eax
  801637:	85 c0                	test   %eax,%eax
  801639:	74 0f                	je     80164a <initialize_dyn_block_system+0x142>
  80163b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80163e:	8b 40 04             	mov    0x4(%eax),%eax
  801641:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801644:	8b 12                	mov    (%edx),%edx
  801646:	89 10                	mov    %edx,(%eax)
  801648:	eb 0a                	jmp    801654 <initialize_dyn_block_system+0x14c>
  80164a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80164d:	8b 00                	mov    (%eax),%eax
  80164f:	a3 48 51 80 00       	mov    %eax,0x805148
  801654:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801657:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80165d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801660:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801667:	a1 54 51 80 00       	mov    0x805154,%eax
  80166c:	48                   	dec    %eax
  80166d:	a3 54 51 80 00       	mov    %eax,0x805154
	LIST_INSERT_HEAD(&FreeMemBlocksList, NewBlock);
  801672:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801676:	75 14                	jne    80168c <initialize_dyn_block_system+0x184>
  801678:	83 ec 04             	sub    $0x4,%esp
  80167b:	68 20 41 80 00       	push   $0x804120
  801680:	6a 34                	push   $0x34
  801682:	68 13 41 80 00       	push   $0x804113
  801687:	e8 0d ee ff ff       	call   800499 <_panic>
  80168c:	8b 15 38 51 80 00    	mov    0x805138,%edx
  801692:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801695:	89 10                	mov    %edx,(%eax)
  801697:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80169a:	8b 00                	mov    (%eax),%eax
  80169c:	85 c0                	test   %eax,%eax
  80169e:	74 0d                	je     8016ad <initialize_dyn_block_system+0x1a5>
  8016a0:	a1 38 51 80 00       	mov    0x805138,%eax
  8016a5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8016a8:	89 50 04             	mov    %edx,0x4(%eax)
  8016ab:	eb 08                	jmp    8016b5 <initialize_dyn_block_system+0x1ad>
  8016ad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016b0:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8016b5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016b8:	a3 38 51 80 00       	mov    %eax,0x805138
  8016bd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016c0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8016c7:	a1 44 51 80 00       	mov    0x805144,%eax
  8016cc:	40                   	inc    %eax
  8016cd:	a3 44 51 80 00       	mov    %eax,0x805144
}
  8016d2:	90                   	nop
  8016d3:	c9                   	leave  
  8016d4:	c3                   	ret    

008016d5 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8016d5:	55                   	push   %ebp
  8016d6:	89 e5                	mov    %esp,%ebp
  8016d8:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016db:	e8 f7 fd ff ff       	call   8014d7 <InitializeUHeap>
	if (size == 0) return NULL ;
  8016e0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8016e4:	75 07                	jne    8016ed <malloc+0x18>
  8016e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8016eb:	eb 61                	jmp    80174e <malloc+0x79>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
	uint32 malloc_allocsize=ROUNDUP(size,PAGE_SIZE);
  8016ed:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8016f4:	8b 55 08             	mov    0x8(%ebp),%edx
  8016f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016fa:	01 d0                	add    %edx,%eax
  8016fc:	48                   	dec    %eax
  8016fd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801700:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801703:	ba 00 00 00 00       	mov    $0x0,%edx
  801708:	f7 75 f0             	divl   -0x10(%ebp)
  80170b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80170e:	29 d0                	sub    %edx,%eax
  801710:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 //int ret=0;
	struct MemBlock * user_block;
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801713:	e8 75 07 00 00       	call   801e8d <sys_isUHeapPlacementStrategyFIRSTFIT>
  801718:	85 c0                	test   %eax,%eax
  80171a:	74 11                	je     80172d <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  80171c:	83 ec 0c             	sub    $0xc,%esp
  80171f:	ff 75 e8             	pushl  -0x18(%ebp)
  801722:	e8 e0 0d 00 00       	call   802507 <alloc_block_FF>
  801727:	83 c4 10             	add    $0x10,%esp
  80172a:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(user_block!=NULL)
  80172d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801731:	74 16                	je     801749 <malloc+0x74>
	{
		//sys_allocate_chunk(user_block->sva,malloc_allocsize,PERM_WRITEABLE| PERM_PRESENT);
		insert_sorted_allocList(user_block);
  801733:	83 ec 0c             	sub    $0xc,%esp
  801736:	ff 75 f4             	pushl  -0xc(%ebp)
  801739:	e8 3c 0b 00 00       	call   80227a <insert_sorted_allocList>
  80173e:	83 c4 10             	add    $0x10,%esp
		return (uint32 *)user_block->sva;
  801741:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801744:	8b 40 08             	mov    0x8(%eax),%eax
  801747:	eb 05                	jmp    80174e <malloc+0x79>
	}

    return NULL;
  801749:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80174e:	c9                   	leave  
  80174f:	c3                   	ret    

00801750 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801750:	55                   	push   %ebp
  801751:	89 e5                	mov    %esp,%ebp
  801753:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801756:	83 ec 04             	sub    $0x4,%esp
  801759:	68 44 41 80 00       	push   $0x804144
  80175e:	6a 6f                	push   $0x6f
  801760:	68 13 41 80 00       	push   $0x804113
  801765:	e8 2f ed ff ff       	call   800499 <_panic>

0080176a <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80176a:	55                   	push   %ebp
  80176b:	89 e5                	mov    %esp,%ebp
  80176d:	83 ec 38             	sub    $0x38,%esp
  801770:	8b 45 10             	mov    0x10(%ebp),%eax
  801773:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801776:	e8 5c fd ff ff       	call   8014d7 <InitializeUHeap>
	if (size == 0) return NULL ;
  80177b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80177f:	75 0a                	jne    80178b <smalloc+0x21>
  801781:	b8 00 00 00 00       	mov    $0x0,%eax
  801786:	e9 8b 00 00 00       	jmp    801816 <smalloc+0xac>
	//	   Else, return NULL

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  80178b:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801792:	8b 55 0c             	mov    0xc(%ebp),%edx
  801795:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801798:	01 d0                	add    %edx,%eax
  80179a:	48                   	dec    %eax
  80179b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80179e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017a1:	ba 00 00 00 00       	mov    $0x0,%edx
  8017a6:	f7 75 f0             	divl   -0x10(%ebp)
  8017a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017ac:	29 d0                	sub    %edx,%eax
  8017ae:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  8017b1:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  8017b8:	e8 d0 06 00 00       	call   801e8d <sys_isUHeapPlacementStrategyFIRSTFIT>
  8017bd:	85 c0                	test   %eax,%eax
  8017bf:	74 11                	je     8017d2 <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  8017c1:	83 ec 0c             	sub    $0xc,%esp
  8017c4:	ff 75 e8             	pushl  -0x18(%ebp)
  8017c7:	e8 3b 0d 00 00       	call   802507 <alloc_block_FF>
  8017cc:	83 c4 10             	add    $0x10,%esp
  8017cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(mem_block != NULL)
  8017d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8017d6:	74 39                	je     801811 <smalloc+0xa7>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  8017d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017db:	8b 40 08             	mov    0x8(%eax),%eax
  8017de:	89 c2                	mov    %eax,%edx
  8017e0:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8017e4:	52                   	push   %edx
  8017e5:	50                   	push   %eax
  8017e6:	ff 75 0c             	pushl  0xc(%ebp)
  8017e9:	ff 75 08             	pushl  0x8(%ebp)
  8017ec:	e8 21 04 00 00       	call   801c12 <sys_createSharedObject>
  8017f1:	83 c4 10             	add    $0x10,%esp
  8017f4:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  8017f7:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  8017fb:	74 14                	je     801811 <smalloc+0xa7>
  8017fd:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  801801:	74 0e                	je     801811 <smalloc+0xa7>
  801803:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  801807:	74 08                	je     801811 <smalloc+0xa7>
			return (void*) mem_block->sva;
  801809:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80180c:	8b 40 08             	mov    0x8(%eax),%eax
  80180f:	eb 05                	jmp    801816 <smalloc+0xac>
	}
	return NULL;
  801811:	b8 00 00 00 00       	mov    $0x0,%eax

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801816:	c9                   	leave  
  801817:	c3                   	ret    

00801818 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801818:	55                   	push   %ebp
  801819:	89 e5                	mov    %esp,%ebp
  80181b:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80181e:	e8 b4 fc ff ff       	call   8014d7 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801823:	83 ec 08             	sub    $0x8,%esp
  801826:	ff 75 0c             	pushl  0xc(%ebp)
  801829:	ff 75 08             	pushl  0x8(%ebp)
  80182c:	e8 0b 04 00 00       	call   801c3c <sys_getSizeOfSharedObject>
  801831:	83 c4 10             	add    $0x10,%esp
  801834:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size != E_SHARED_MEM_NOT_EXISTS)
  801837:	83 7d f0 f0          	cmpl   $0xfffffff0,-0x10(%ebp)
  80183b:	74 76                	je     8018b3 <sget+0x9b>
	{
		uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  80183d:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801844:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801847:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80184a:	01 d0                	add    %edx,%eax
  80184c:	48                   	dec    %eax
  80184d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801850:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801853:	ba 00 00 00 00       	mov    $0x0,%edx
  801858:	f7 75 ec             	divl   -0x14(%ebp)
  80185b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80185e:	29 d0                	sub    %edx,%eax
  801860:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		struct MemBlock * mem_block = NULL;
  801863:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  80186a:	e8 1e 06 00 00       	call   801e8d <sys_isUHeapPlacementStrategyFIRSTFIT>
  80186f:	85 c0                	test   %eax,%eax
  801871:	74 11                	je     801884 <sget+0x6c>
			mem_block = alloc_block_FF(allocate_space);
  801873:	83 ec 0c             	sub    $0xc,%esp
  801876:	ff 75 e4             	pushl  -0x1c(%ebp)
  801879:	e8 89 0c 00 00       	call   802507 <alloc_block_FF>
  80187e:	83 c4 10             	add    $0x10,%esp
  801881:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(mem_block != NULL)
  801884:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801888:	74 29                	je     8018b3 <sget+0x9b>
		{
			uint32 shared_object_id = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)mem_block->sva);
  80188a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80188d:	8b 40 08             	mov    0x8(%eax),%eax
  801890:	83 ec 04             	sub    $0x4,%esp
  801893:	50                   	push   %eax
  801894:	ff 75 0c             	pushl  0xc(%ebp)
  801897:	ff 75 08             	pushl  0x8(%ebp)
  80189a:	e8 ba 03 00 00       	call   801c59 <sys_getSharedObject>
  80189f:	83 c4 10             	add    $0x10,%esp
  8018a2:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (shared_object_id != E_SHARED_MEM_NOT_EXISTS)
  8018a5:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%ebp)
  8018a9:	74 08                	je     8018b3 <sget+0x9b>
				return (void *)mem_block->sva;
  8018ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018ae:	8b 40 08             	mov    0x8(%eax),%eax
  8018b1:	eb 05                	jmp    8018b8 <sget+0xa0>
		}
	}
	return NULL;
  8018b3:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8018b8:	c9                   	leave  
  8018b9:	c3                   	ret    

008018ba <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8018ba:	55                   	push   %ebp
  8018bb:	89 e5                	mov    %esp,%ebp
  8018bd:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8018c0:	e8 12 fc ff ff       	call   8014d7 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8018c5:	83 ec 04             	sub    $0x4,%esp
  8018c8:	68 68 41 80 00       	push   $0x804168
  8018cd:	68 f1 00 00 00       	push   $0xf1
  8018d2:	68 13 41 80 00       	push   $0x804113
  8018d7:	e8 bd eb ff ff       	call   800499 <_panic>

008018dc <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8018dc:	55                   	push   %ebp
  8018dd:	89 e5                	mov    %esp,%ebp
  8018df:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8018e2:	83 ec 04             	sub    $0x4,%esp
  8018e5:	68 90 41 80 00       	push   $0x804190
  8018ea:	68 05 01 00 00       	push   $0x105
  8018ef:	68 13 41 80 00       	push   $0x804113
  8018f4:	e8 a0 eb ff ff       	call   800499 <_panic>

008018f9 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8018f9:	55                   	push   %ebp
  8018fa:	89 e5                	mov    %esp,%ebp
  8018fc:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018ff:	83 ec 04             	sub    $0x4,%esp
  801902:	68 b4 41 80 00       	push   $0x8041b4
  801907:	68 10 01 00 00       	push   $0x110
  80190c:	68 13 41 80 00       	push   $0x804113
  801911:	e8 83 eb ff ff       	call   800499 <_panic>

00801916 <shrink>:

}
void shrink(uint32 newSize)
{
  801916:	55                   	push   %ebp
  801917:	89 e5                	mov    %esp,%ebp
  801919:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80191c:	83 ec 04             	sub    $0x4,%esp
  80191f:	68 b4 41 80 00       	push   $0x8041b4
  801924:	68 15 01 00 00       	push   $0x115
  801929:	68 13 41 80 00       	push   $0x804113
  80192e:	e8 66 eb ff ff       	call   800499 <_panic>

00801933 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801933:	55                   	push   %ebp
  801934:	89 e5                	mov    %esp,%ebp
  801936:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801939:	83 ec 04             	sub    $0x4,%esp
  80193c:	68 b4 41 80 00       	push   $0x8041b4
  801941:	68 1a 01 00 00       	push   $0x11a
  801946:	68 13 41 80 00       	push   $0x804113
  80194b:	e8 49 eb ff ff       	call   800499 <_panic>

00801950 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801950:	55                   	push   %ebp
  801951:	89 e5                	mov    %esp,%ebp
  801953:	57                   	push   %edi
  801954:	56                   	push   %esi
  801955:	53                   	push   %ebx
  801956:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801959:	8b 45 08             	mov    0x8(%ebp),%eax
  80195c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80195f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801962:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801965:	8b 7d 18             	mov    0x18(%ebp),%edi
  801968:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80196b:	cd 30                	int    $0x30
  80196d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801970:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801973:	83 c4 10             	add    $0x10,%esp
  801976:	5b                   	pop    %ebx
  801977:	5e                   	pop    %esi
  801978:	5f                   	pop    %edi
  801979:	5d                   	pop    %ebp
  80197a:	c3                   	ret    

0080197b <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80197b:	55                   	push   %ebp
  80197c:	89 e5                	mov    %esp,%ebp
  80197e:	83 ec 04             	sub    $0x4,%esp
  801981:	8b 45 10             	mov    0x10(%ebp),%eax
  801984:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801987:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80198b:	8b 45 08             	mov    0x8(%ebp),%eax
  80198e:	6a 00                	push   $0x0
  801990:	6a 00                	push   $0x0
  801992:	52                   	push   %edx
  801993:	ff 75 0c             	pushl  0xc(%ebp)
  801996:	50                   	push   %eax
  801997:	6a 00                	push   $0x0
  801999:	e8 b2 ff ff ff       	call   801950 <syscall>
  80199e:	83 c4 18             	add    $0x18,%esp
}
  8019a1:	90                   	nop
  8019a2:	c9                   	leave  
  8019a3:	c3                   	ret    

008019a4 <sys_cgetc>:

int
sys_cgetc(void)
{
  8019a4:	55                   	push   %ebp
  8019a5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8019a7:	6a 00                	push   $0x0
  8019a9:	6a 00                	push   $0x0
  8019ab:	6a 00                	push   $0x0
  8019ad:	6a 00                	push   $0x0
  8019af:	6a 00                	push   $0x0
  8019b1:	6a 01                	push   $0x1
  8019b3:	e8 98 ff ff ff       	call   801950 <syscall>
  8019b8:	83 c4 18             	add    $0x18,%esp
}
  8019bb:	c9                   	leave  
  8019bc:	c3                   	ret    

008019bd <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8019bd:	55                   	push   %ebp
  8019be:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8019c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c6:	6a 00                	push   $0x0
  8019c8:	6a 00                	push   $0x0
  8019ca:	6a 00                	push   $0x0
  8019cc:	52                   	push   %edx
  8019cd:	50                   	push   %eax
  8019ce:	6a 05                	push   $0x5
  8019d0:	e8 7b ff ff ff       	call   801950 <syscall>
  8019d5:	83 c4 18             	add    $0x18,%esp
}
  8019d8:	c9                   	leave  
  8019d9:	c3                   	ret    

008019da <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8019da:	55                   	push   %ebp
  8019db:	89 e5                	mov    %esp,%ebp
  8019dd:	56                   	push   %esi
  8019de:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8019df:	8b 75 18             	mov    0x18(%ebp),%esi
  8019e2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8019e5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019e8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ee:	56                   	push   %esi
  8019ef:	53                   	push   %ebx
  8019f0:	51                   	push   %ecx
  8019f1:	52                   	push   %edx
  8019f2:	50                   	push   %eax
  8019f3:	6a 06                	push   $0x6
  8019f5:	e8 56 ff ff ff       	call   801950 <syscall>
  8019fa:	83 c4 18             	add    $0x18,%esp
}
  8019fd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a00:	5b                   	pop    %ebx
  801a01:	5e                   	pop    %esi
  801a02:	5d                   	pop    %ebp
  801a03:	c3                   	ret    

00801a04 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801a04:	55                   	push   %ebp
  801a05:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801a07:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0d:	6a 00                	push   $0x0
  801a0f:	6a 00                	push   $0x0
  801a11:	6a 00                	push   $0x0
  801a13:	52                   	push   %edx
  801a14:	50                   	push   %eax
  801a15:	6a 07                	push   $0x7
  801a17:	e8 34 ff ff ff       	call   801950 <syscall>
  801a1c:	83 c4 18             	add    $0x18,%esp
}
  801a1f:	c9                   	leave  
  801a20:	c3                   	ret    

00801a21 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801a21:	55                   	push   %ebp
  801a22:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801a24:	6a 00                	push   $0x0
  801a26:	6a 00                	push   $0x0
  801a28:	6a 00                	push   $0x0
  801a2a:	ff 75 0c             	pushl  0xc(%ebp)
  801a2d:	ff 75 08             	pushl  0x8(%ebp)
  801a30:	6a 08                	push   $0x8
  801a32:	e8 19 ff ff ff       	call   801950 <syscall>
  801a37:	83 c4 18             	add    $0x18,%esp
}
  801a3a:	c9                   	leave  
  801a3b:	c3                   	ret    

00801a3c <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801a3c:	55                   	push   %ebp
  801a3d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801a3f:	6a 00                	push   $0x0
  801a41:	6a 00                	push   $0x0
  801a43:	6a 00                	push   $0x0
  801a45:	6a 00                	push   $0x0
  801a47:	6a 00                	push   $0x0
  801a49:	6a 09                	push   $0x9
  801a4b:	e8 00 ff ff ff       	call   801950 <syscall>
  801a50:	83 c4 18             	add    $0x18,%esp
}
  801a53:	c9                   	leave  
  801a54:	c3                   	ret    

00801a55 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801a55:	55                   	push   %ebp
  801a56:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801a58:	6a 00                	push   $0x0
  801a5a:	6a 00                	push   $0x0
  801a5c:	6a 00                	push   $0x0
  801a5e:	6a 00                	push   $0x0
  801a60:	6a 00                	push   $0x0
  801a62:	6a 0a                	push   $0xa
  801a64:	e8 e7 fe ff ff       	call   801950 <syscall>
  801a69:	83 c4 18             	add    $0x18,%esp
}
  801a6c:	c9                   	leave  
  801a6d:	c3                   	ret    

00801a6e <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801a6e:	55                   	push   %ebp
  801a6f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801a71:	6a 00                	push   $0x0
  801a73:	6a 00                	push   $0x0
  801a75:	6a 00                	push   $0x0
  801a77:	6a 00                	push   $0x0
  801a79:	6a 00                	push   $0x0
  801a7b:	6a 0b                	push   $0xb
  801a7d:	e8 ce fe ff ff       	call   801950 <syscall>
  801a82:	83 c4 18             	add    $0x18,%esp
}
  801a85:	c9                   	leave  
  801a86:	c3                   	ret    

00801a87 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801a87:	55                   	push   %ebp
  801a88:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801a8a:	6a 00                	push   $0x0
  801a8c:	6a 00                	push   $0x0
  801a8e:	6a 00                	push   $0x0
  801a90:	ff 75 0c             	pushl  0xc(%ebp)
  801a93:	ff 75 08             	pushl  0x8(%ebp)
  801a96:	6a 0f                	push   $0xf
  801a98:	e8 b3 fe ff ff       	call   801950 <syscall>
  801a9d:	83 c4 18             	add    $0x18,%esp
	return;
  801aa0:	90                   	nop
}
  801aa1:	c9                   	leave  
  801aa2:	c3                   	ret    

00801aa3 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801aa3:	55                   	push   %ebp
  801aa4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801aa6:	6a 00                	push   $0x0
  801aa8:	6a 00                	push   $0x0
  801aaa:	6a 00                	push   $0x0
  801aac:	ff 75 0c             	pushl  0xc(%ebp)
  801aaf:	ff 75 08             	pushl  0x8(%ebp)
  801ab2:	6a 10                	push   $0x10
  801ab4:	e8 97 fe ff ff       	call   801950 <syscall>
  801ab9:	83 c4 18             	add    $0x18,%esp
	return ;
  801abc:	90                   	nop
}
  801abd:	c9                   	leave  
  801abe:	c3                   	ret    

00801abf <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801abf:	55                   	push   %ebp
  801ac0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801ac2:	6a 00                	push   $0x0
  801ac4:	6a 00                	push   $0x0
  801ac6:	ff 75 10             	pushl  0x10(%ebp)
  801ac9:	ff 75 0c             	pushl  0xc(%ebp)
  801acc:	ff 75 08             	pushl  0x8(%ebp)
  801acf:	6a 11                	push   $0x11
  801ad1:	e8 7a fe ff ff       	call   801950 <syscall>
  801ad6:	83 c4 18             	add    $0x18,%esp
	return ;
  801ad9:	90                   	nop
}
  801ada:	c9                   	leave  
  801adb:	c3                   	ret    

00801adc <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801adc:	55                   	push   %ebp
  801add:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801adf:	6a 00                	push   $0x0
  801ae1:	6a 00                	push   $0x0
  801ae3:	6a 00                	push   $0x0
  801ae5:	6a 00                	push   $0x0
  801ae7:	6a 00                	push   $0x0
  801ae9:	6a 0c                	push   $0xc
  801aeb:	e8 60 fe ff ff       	call   801950 <syscall>
  801af0:	83 c4 18             	add    $0x18,%esp
}
  801af3:	c9                   	leave  
  801af4:	c3                   	ret    

00801af5 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801af5:	55                   	push   %ebp
  801af6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801af8:	6a 00                	push   $0x0
  801afa:	6a 00                	push   $0x0
  801afc:	6a 00                	push   $0x0
  801afe:	6a 00                	push   $0x0
  801b00:	ff 75 08             	pushl  0x8(%ebp)
  801b03:	6a 0d                	push   $0xd
  801b05:	e8 46 fe ff ff       	call   801950 <syscall>
  801b0a:	83 c4 18             	add    $0x18,%esp
}
  801b0d:	c9                   	leave  
  801b0e:	c3                   	ret    

00801b0f <sys_scarce_memory>:

void sys_scarce_memory()
{
  801b0f:	55                   	push   %ebp
  801b10:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801b12:	6a 00                	push   $0x0
  801b14:	6a 00                	push   $0x0
  801b16:	6a 00                	push   $0x0
  801b18:	6a 00                	push   $0x0
  801b1a:	6a 00                	push   $0x0
  801b1c:	6a 0e                	push   $0xe
  801b1e:	e8 2d fe ff ff       	call   801950 <syscall>
  801b23:	83 c4 18             	add    $0x18,%esp
}
  801b26:	90                   	nop
  801b27:	c9                   	leave  
  801b28:	c3                   	ret    

00801b29 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801b29:	55                   	push   %ebp
  801b2a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801b2c:	6a 00                	push   $0x0
  801b2e:	6a 00                	push   $0x0
  801b30:	6a 00                	push   $0x0
  801b32:	6a 00                	push   $0x0
  801b34:	6a 00                	push   $0x0
  801b36:	6a 13                	push   $0x13
  801b38:	e8 13 fe ff ff       	call   801950 <syscall>
  801b3d:	83 c4 18             	add    $0x18,%esp
}
  801b40:	90                   	nop
  801b41:	c9                   	leave  
  801b42:	c3                   	ret    

00801b43 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801b43:	55                   	push   %ebp
  801b44:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801b46:	6a 00                	push   $0x0
  801b48:	6a 00                	push   $0x0
  801b4a:	6a 00                	push   $0x0
  801b4c:	6a 00                	push   $0x0
  801b4e:	6a 00                	push   $0x0
  801b50:	6a 14                	push   $0x14
  801b52:	e8 f9 fd ff ff       	call   801950 <syscall>
  801b57:	83 c4 18             	add    $0x18,%esp
}
  801b5a:	90                   	nop
  801b5b:	c9                   	leave  
  801b5c:	c3                   	ret    

00801b5d <sys_cputc>:


void
sys_cputc(const char c)
{
  801b5d:	55                   	push   %ebp
  801b5e:	89 e5                	mov    %esp,%ebp
  801b60:	83 ec 04             	sub    $0x4,%esp
  801b63:	8b 45 08             	mov    0x8(%ebp),%eax
  801b66:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801b69:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b6d:	6a 00                	push   $0x0
  801b6f:	6a 00                	push   $0x0
  801b71:	6a 00                	push   $0x0
  801b73:	6a 00                	push   $0x0
  801b75:	50                   	push   %eax
  801b76:	6a 15                	push   $0x15
  801b78:	e8 d3 fd ff ff       	call   801950 <syscall>
  801b7d:	83 c4 18             	add    $0x18,%esp
}
  801b80:	90                   	nop
  801b81:	c9                   	leave  
  801b82:	c3                   	ret    

00801b83 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801b83:	55                   	push   %ebp
  801b84:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801b86:	6a 00                	push   $0x0
  801b88:	6a 00                	push   $0x0
  801b8a:	6a 00                	push   $0x0
  801b8c:	6a 00                	push   $0x0
  801b8e:	6a 00                	push   $0x0
  801b90:	6a 16                	push   $0x16
  801b92:	e8 b9 fd ff ff       	call   801950 <syscall>
  801b97:	83 c4 18             	add    $0x18,%esp
}
  801b9a:	90                   	nop
  801b9b:	c9                   	leave  
  801b9c:	c3                   	ret    

00801b9d <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801b9d:	55                   	push   %ebp
  801b9e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801ba0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba3:	6a 00                	push   $0x0
  801ba5:	6a 00                	push   $0x0
  801ba7:	6a 00                	push   $0x0
  801ba9:	ff 75 0c             	pushl  0xc(%ebp)
  801bac:	50                   	push   %eax
  801bad:	6a 17                	push   $0x17
  801baf:	e8 9c fd ff ff       	call   801950 <syscall>
  801bb4:	83 c4 18             	add    $0x18,%esp
}
  801bb7:	c9                   	leave  
  801bb8:	c3                   	ret    

00801bb9 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801bb9:	55                   	push   %ebp
  801bba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801bbc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bbf:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc2:	6a 00                	push   $0x0
  801bc4:	6a 00                	push   $0x0
  801bc6:	6a 00                	push   $0x0
  801bc8:	52                   	push   %edx
  801bc9:	50                   	push   %eax
  801bca:	6a 1a                	push   $0x1a
  801bcc:	e8 7f fd ff ff       	call   801950 <syscall>
  801bd1:	83 c4 18             	add    $0x18,%esp
}
  801bd4:	c9                   	leave  
  801bd5:	c3                   	ret    

00801bd6 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801bd6:	55                   	push   %ebp
  801bd7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801bd9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bdc:	8b 45 08             	mov    0x8(%ebp),%eax
  801bdf:	6a 00                	push   $0x0
  801be1:	6a 00                	push   $0x0
  801be3:	6a 00                	push   $0x0
  801be5:	52                   	push   %edx
  801be6:	50                   	push   %eax
  801be7:	6a 18                	push   $0x18
  801be9:	e8 62 fd ff ff       	call   801950 <syscall>
  801bee:	83 c4 18             	add    $0x18,%esp
}
  801bf1:	90                   	nop
  801bf2:	c9                   	leave  
  801bf3:	c3                   	ret    

00801bf4 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801bf4:	55                   	push   %ebp
  801bf5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801bf7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bfa:	8b 45 08             	mov    0x8(%ebp),%eax
  801bfd:	6a 00                	push   $0x0
  801bff:	6a 00                	push   $0x0
  801c01:	6a 00                	push   $0x0
  801c03:	52                   	push   %edx
  801c04:	50                   	push   %eax
  801c05:	6a 19                	push   $0x19
  801c07:	e8 44 fd ff ff       	call   801950 <syscall>
  801c0c:	83 c4 18             	add    $0x18,%esp
}
  801c0f:	90                   	nop
  801c10:	c9                   	leave  
  801c11:	c3                   	ret    

00801c12 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801c12:	55                   	push   %ebp
  801c13:	89 e5                	mov    %esp,%ebp
  801c15:	83 ec 04             	sub    $0x4,%esp
  801c18:	8b 45 10             	mov    0x10(%ebp),%eax
  801c1b:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801c1e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801c21:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801c25:	8b 45 08             	mov    0x8(%ebp),%eax
  801c28:	6a 00                	push   $0x0
  801c2a:	51                   	push   %ecx
  801c2b:	52                   	push   %edx
  801c2c:	ff 75 0c             	pushl  0xc(%ebp)
  801c2f:	50                   	push   %eax
  801c30:	6a 1b                	push   $0x1b
  801c32:	e8 19 fd ff ff       	call   801950 <syscall>
  801c37:	83 c4 18             	add    $0x18,%esp
}
  801c3a:	c9                   	leave  
  801c3b:	c3                   	ret    

00801c3c <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801c3c:	55                   	push   %ebp
  801c3d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801c3f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c42:	8b 45 08             	mov    0x8(%ebp),%eax
  801c45:	6a 00                	push   $0x0
  801c47:	6a 00                	push   $0x0
  801c49:	6a 00                	push   $0x0
  801c4b:	52                   	push   %edx
  801c4c:	50                   	push   %eax
  801c4d:	6a 1c                	push   $0x1c
  801c4f:	e8 fc fc ff ff       	call   801950 <syscall>
  801c54:	83 c4 18             	add    $0x18,%esp
}
  801c57:	c9                   	leave  
  801c58:	c3                   	ret    

00801c59 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801c59:	55                   	push   %ebp
  801c5a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801c5c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c5f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c62:	8b 45 08             	mov    0x8(%ebp),%eax
  801c65:	6a 00                	push   $0x0
  801c67:	6a 00                	push   $0x0
  801c69:	51                   	push   %ecx
  801c6a:	52                   	push   %edx
  801c6b:	50                   	push   %eax
  801c6c:	6a 1d                	push   $0x1d
  801c6e:	e8 dd fc ff ff       	call   801950 <syscall>
  801c73:	83 c4 18             	add    $0x18,%esp
}
  801c76:	c9                   	leave  
  801c77:	c3                   	ret    

00801c78 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801c78:	55                   	push   %ebp
  801c79:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801c7b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c81:	6a 00                	push   $0x0
  801c83:	6a 00                	push   $0x0
  801c85:	6a 00                	push   $0x0
  801c87:	52                   	push   %edx
  801c88:	50                   	push   %eax
  801c89:	6a 1e                	push   $0x1e
  801c8b:	e8 c0 fc ff ff       	call   801950 <syscall>
  801c90:	83 c4 18             	add    $0x18,%esp
}
  801c93:	c9                   	leave  
  801c94:	c3                   	ret    

00801c95 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801c95:	55                   	push   %ebp
  801c96:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801c98:	6a 00                	push   $0x0
  801c9a:	6a 00                	push   $0x0
  801c9c:	6a 00                	push   $0x0
  801c9e:	6a 00                	push   $0x0
  801ca0:	6a 00                	push   $0x0
  801ca2:	6a 1f                	push   $0x1f
  801ca4:	e8 a7 fc ff ff       	call   801950 <syscall>
  801ca9:	83 c4 18             	add    $0x18,%esp
}
  801cac:	c9                   	leave  
  801cad:	c3                   	ret    

00801cae <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801cae:	55                   	push   %ebp
  801caf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801cb1:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb4:	6a 00                	push   $0x0
  801cb6:	ff 75 14             	pushl  0x14(%ebp)
  801cb9:	ff 75 10             	pushl  0x10(%ebp)
  801cbc:	ff 75 0c             	pushl  0xc(%ebp)
  801cbf:	50                   	push   %eax
  801cc0:	6a 20                	push   $0x20
  801cc2:	e8 89 fc ff ff       	call   801950 <syscall>
  801cc7:	83 c4 18             	add    $0x18,%esp
}
  801cca:	c9                   	leave  
  801ccb:	c3                   	ret    

00801ccc <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801ccc:	55                   	push   %ebp
  801ccd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801ccf:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd2:	6a 00                	push   $0x0
  801cd4:	6a 00                	push   $0x0
  801cd6:	6a 00                	push   $0x0
  801cd8:	6a 00                	push   $0x0
  801cda:	50                   	push   %eax
  801cdb:	6a 21                	push   $0x21
  801cdd:	e8 6e fc ff ff       	call   801950 <syscall>
  801ce2:	83 c4 18             	add    $0x18,%esp
}
  801ce5:	90                   	nop
  801ce6:	c9                   	leave  
  801ce7:	c3                   	ret    

00801ce8 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801ce8:	55                   	push   %ebp
  801ce9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801ceb:	8b 45 08             	mov    0x8(%ebp),%eax
  801cee:	6a 00                	push   $0x0
  801cf0:	6a 00                	push   $0x0
  801cf2:	6a 00                	push   $0x0
  801cf4:	6a 00                	push   $0x0
  801cf6:	50                   	push   %eax
  801cf7:	6a 22                	push   $0x22
  801cf9:	e8 52 fc ff ff       	call   801950 <syscall>
  801cfe:	83 c4 18             	add    $0x18,%esp
}
  801d01:	c9                   	leave  
  801d02:	c3                   	ret    

00801d03 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801d03:	55                   	push   %ebp
  801d04:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801d06:	6a 00                	push   $0x0
  801d08:	6a 00                	push   $0x0
  801d0a:	6a 00                	push   $0x0
  801d0c:	6a 00                	push   $0x0
  801d0e:	6a 00                	push   $0x0
  801d10:	6a 02                	push   $0x2
  801d12:	e8 39 fc ff ff       	call   801950 <syscall>
  801d17:	83 c4 18             	add    $0x18,%esp
}
  801d1a:	c9                   	leave  
  801d1b:	c3                   	ret    

00801d1c <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801d1c:	55                   	push   %ebp
  801d1d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801d1f:	6a 00                	push   $0x0
  801d21:	6a 00                	push   $0x0
  801d23:	6a 00                	push   $0x0
  801d25:	6a 00                	push   $0x0
  801d27:	6a 00                	push   $0x0
  801d29:	6a 03                	push   $0x3
  801d2b:	e8 20 fc ff ff       	call   801950 <syscall>
  801d30:	83 c4 18             	add    $0x18,%esp
}
  801d33:	c9                   	leave  
  801d34:	c3                   	ret    

00801d35 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801d35:	55                   	push   %ebp
  801d36:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801d38:	6a 00                	push   $0x0
  801d3a:	6a 00                	push   $0x0
  801d3c:	6a 00                	push   $0x0
  801d3e:	6a 00                	push   $0x0
  801d40:	6a 00                	push   $0x0
  801d42:	6a 04                	push   $0x4
  801d44:	e8 07 fc ff ff       	call   801950 <syscall>
  801d49:	83 c4 18             	add    $0x18,%esp
}
  801d4c:	c9                   	leave  
  801d4d:	c3                   	ret    

00801d4e <sys_exit_env>:


void sys_exit_env(void)
{
  801d4e:	55                   	push   %ebp
  801d4f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801d51:	6a 00                	push   $0x0
  801d53:	6a 00                	push   $0x0
  801d55:	6a 00                	push   $0x0
  801d57:	6a 00                	push   $0x0
  801d59:	6a 00                	push   $0x0
  801d5b:	6a 23                	push   $0x23
  801d5d:	e8 ee fb ff ff       	call   801950 <syscall>
  801d62:	83 c4 18             	add    $0x18,%esp
}
  801d65:	90                   	nop
  801d66:	c9                   	leave  
  801d67:	c3                   	ret    

00801d68 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801d68:	55                   	push   %ebp
  801d69:	89 e5                	mov    %esp,%ebp
  801d6b:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801d6e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d71:	8d 50 04             	lea    0x4(%eax),%edx
  801d74:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d77:	6a 00                	push   $0x0
  801d79:	6a 00                	push   $0x0
  801d7b:	6a 00                	push   $0x0
  801d7d:	52                   	push   %edx
  801d7e:	50                   	push   %eax
  801d7f:	6a 24                	push   $0x24
  801d81:	e8 ca fb ff ff       	call   801950 <syscall>
  801d86:	83 c4 18             	add    $0x18,%esp
	return result;
  801d89:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d8c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d8f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d92:	89 01                	mov    %eax,(%ecx)
  801d94:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801d97:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9a:	c9                   	leave  
  801d9b:	c2 04 00             	ret    $0x4

00801d9e <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801d9e:	55                   	push   %ebp
  801d9f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801da1:	6a 00                	push   $0x0
  801da3:	6a 00                	push   $0x0
  801da5:	ff 75 10             	pushl  0x10(%ebp)
  801da8:	ff 75 0c             	pushl  0xc(%ebp)
  801dab:	ff 75 08             	pushl  0x8(%ebp)
  801dae:	6a 12                	push   $0x12
  801db0:	e8 9b fb ff ff       	call   801950 <syscall>
  801db5:	83 c4 18             	add    $0x18,%esp
	return ;
  801db8:	90                   	nop
}
  801db9:	c9                   	leave  
  801dba:	c3                   	ret    

00801dbb <sys_rcr2>:
uint32 sys_rcr2()
{
  801dbb:	55                   	push   %ebp
  801dbc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801dbe:	6a 00                	push   $0x0
  801dc0:	6a 00                	push   $0x0
  801dc2:	6a 00                	push   $0x0
  801dc4:	6a 00                	push   $0x0
  801dc6:	6a 00                	push   $0x0
  801dc8:	6a 25                	push   $0x25
  801dca:	e8 81 fb ff ff       	call   801950 <syscall>
  801dcf:	83 c4 18             	add    $0x18,%esp
}
  801dd2:	c9                   	leave  
  801dd3:	c3                   	ret    

00801dd4 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801dd4:	55                   	push   %ebp
  801dd5:	89 e5                	mov    %esp,%ebp
  801dd7:	83 ec 04             	sub    $0x4,%esp
  801dda:	8b 45 08             	mov    0x8(%ebp),%eax
  801ddd:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801de0:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801de4:	6a 00                	push   $0x0
  801de6:	6a 00                	push   $0x0
  801de8:	6a 00                	push   $0x0
  801dea:	6a 00                	push   $0x0
  801dec:	50                   	push   %eax
  801ded:	6a 26                	push   $0x26
  801def:	e8 5c fb ff ff       	call   801950 <syscall>
  801df4:	83 c4 18             	add    $0x18,%esp
	return ;
  801df7:	90                   	nop
}
  801df8:	c9                   	leave  
  801df9:	c3                   	ret    

00801dfa <rsttst>:
void rsttst()
{
  801dfa:	55                   	push   %ebp
  801dfb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801dfd:	6a 00                	push   $0x0
  801dff:	6a 00                	push   $0x0
  801e01:	6a 00                	push   $0x0
  801e03:	6a 00                	push   $0x0
  801e05:	6a 00                	push   $0x0
  801e07:	6a 28                	push   $0x28
  801e09:	e8 42 fb ff ff       	call   801950 <syscall>
  801e0e:	83 c4 18             	add    $0x18,%esp
	return ;
  801e11:	90                   	nop
}
  801e12:	c9                   	leave  
  801e13:	c3                   	ret    

00801e14 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801e14:	55                   	push   %ebp
  801e15:	89 e5                	mov    %esp,%ebp
  801e17:	83 ec 04             	sub    $0x4,%esp
  801e1a:	8b 45 14             	mov    0x14(%ebp),%eax
  801e1d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801e20:	8b 55 18             	mov    0x18(%ebp),%edx
  801e23:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801e27:	52                   	push   %edx
  801e28:	50                   	push   %eax
  801e29:	ff 75 10             	pushl  0x10(%ebp)
  801e2c:	ff 75 0c             	pushl  0xc(%ebp)
  801e2f:	ff 75 08             	pushl  0x8(%ebp)
  801e32:	6a 27                	push   $0x27
  801e34:	e8 17 fb ff ff       	call   801950 <syscall>
  801e39:	83 c4 18             	add    $0x18,%esp
	return ;
  801e3c:	90                   	nop
}
  801e3d:	c9                   	leave  
  801e3e:	c3                   	ret    

00801e3f <chktst>:
void chktst(uint32 n)
{
  801e3f:	55                   	push   %ebp
  801e40:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801e42:	6a 00                	push   $0x0
  801e44:	6a 00                	push   $0x0
  801e46:	6a 00                	push   $0x0
  801e48:	6a 00                	push   $0x0
  801e4a:	ff 75 08             	pushl  0x8(%ebp)
  801e4d:	6a 29                	push   $0x29
  801e4f:	e8 fc fa ff ff       	call   801950 <syscall>
  801e54:	83 c4 18             	add    $0x18,%esp
	return ;
  801e57:	90                   	nop
}
  801e58:	c9                   	leave  
  801e59:	c3                   	ret    

00801e5a <inctst>:

void inctst()
{
  801e5a:	55                   	push   %ebp
  801e5b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801e5d:	6a 00                	push   $0x0
  801e5f:	6a 00                	push   $0x0
  801e61:	6a 00                	push   $0x0
  801e63:	6a 00                	push   $0x0
  801e65:	6a 00                	push   $0x0
  801e67:	6a 2a                	push   $0x2a
  801e69:	e8 e2 fa ff ff       	call   801950 <syscall>
  801e6e:	83 c4 18             	add    $0x18,%esp
	return ;
  801e71:	90                   	nop
}
  801e72:	c9                   	leave  
  801e73:	c3                   	ret    

00801e74 <gettst>:
uint32 gettst()
{
  801e74:	55                   	push   %ebp
  801e75:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801e77:	6a 00                	push   $0x0
  801e79:	6a 00                	push   $0x0
  801e7b:	6a 00                	push   $0x0
  801e7d:	6a 00                	push   $0x0
  801e7f:	6a 00                	push   $0x0
  801e81:	6a 2b                	push   $0x2b
  801e83:	e8 c8 fa ff ff       	call   801950 <syscall>
  801e88:	83 c4 18             	add    $0x18,%esp
}
  801e8b:	c9                   	leave  
  801e8c:	c3                   	ret    

00801e8d <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801e8d:	55                   	push   %ebp
  801e8e:	89 e5                	mov    %esp,%ebp
  801e90:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e93:	6a 00                	push   $0x0
  801e95:	6a 00                	push   $0x0
  801e97:	6a 00                	push   $0x0
  801e99:	6a 00                	push   $0x0
  801e9b:	6a 00                	push   $0x0
  801e9d:	6a 2c                	push   $0x2c
  801e9f:	e8 ac fa ff ff       	call   801950 <syscall>
  801ea4:	83 c4 18             	add    $0x18,%esp
  801ea7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801eaa:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801eae:	75 07                	jne    801eb7 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801eb0:	b8 01 00 00 00       	mov    $0x1,%eax
  801eb5:	eb 05                	jmp    801ebc <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801eb7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ebc:	c9                   	leave  
  801ebd:	c3                   	ret    

00801ebe <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801ebe:	55                   	push   %ebp
  801ebf:	89 e5                	mov    %esp,%ebp
  801ec1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ec4:	6a 00                	push   $0x0
  801ec6:	6a 00                	push   $0x0
  801ec8:	6a 00                	push   $0x0
  801eca:	6a 00                	push   $0x0
  801ecc:	6a 00                	push   $0x0
  801ece:	6a 2c                	push   $0x2c
  801ed0:	e8 7b fa ff ff       	call   801950 <syscall>
  801ed5:	83 c4 18             	add    $0x18,%esp
  801ed8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801edb:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801edf:	75 07                	jne    801ee8 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801ee1:	b8 01 00 00 00       	mov    $0x1,%eax
  801ee6:	eb 05                	jmp    801eed <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801ee8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801eed:	c9                   	leave  
  801eee:	c3                   	ret    

00801eef <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801eef:	55                   	push   %ebp
  801ef0:	89 e5                	mov    %esp,%ebp
  801ef2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ef5:	6a 00                	push   $0x0
  801ef7:	6a 00                	push   $0x0
  801ef9:	6a 00                	push   $0x0
  801efb:	6a 00                	push   $0x0
  801efd:	6a 00                	push   $0x0
  801eff:	6a 2c                	push   $0x2c
  801f01:	e8 4a fa ff ff       	call   801950 <syscall>
  801f06:	83 c4 18             	add    $0x18,%esp
  801f09:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801f0c:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801f10:	75 07                	jne    801f19 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801f12:	b8 01 00 00 00       	mov    $0x1,%eax
  801f17:	eb 05                	jmp    801f1e <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801f19:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f1e:	c9                   	leave  
  801f1f:	c3                   	ret    

00801f20 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801f20:	55                   	push   %ebp
  801f21:	89 e5                	mov    %esp,%ebp
  801f23:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f26:	6a 00                	push   $0x0
  801f28:	6a 00                	push   $0x0
  801f2a:	6a 00                	push   $0x0
  801f2c:	6a 00                	push   $0x0
  801f2e:	6a 00                	push   $0x0
  801f30:	6a 2c                	push   $0x2c
  801f32:	e8 19 fa ff ff       	call   801950 <syscall>
  801f37:	83 c4 18             	add    $0x18,%esp
  801f3a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801f3d:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801f41:	75 07                	jne    801f4a <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801f43:	b8 01 00 00 00       	mov    $0x1,%eax
  801f48:	eb 05                	jmp    801f4f <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801f4a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f4f:	c9                   	leave  
  801f50:	c3                   	ret    

00801f51 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801f51:	55                   	push   %ebp
  801f52:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801f54:	6a 00                	push   $0x0
  801f56:	6a 00                	push   $0x0
  801f58:	6a 00                	push   $0x0
  801f5a:	6a 00                	push   $0x0
  801f5c:	ff 75 08             	pushl  0x8(%ebp)
  801f5f:	6a 2d                	push   $0x2d
  801f61:	e8 ea f9 ff ff       	call   801950 <syscall>
  801f66:	83 c4 18             	add    $0x18,%esp
	return ;
  801f69:	90                   	nop
}
  801f6a:	c9                   	leave  
  801f6b:	c3                   	ret    

00801f6c <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801f6c:	55                   	push   %ebp
  801f6d:	89 e5                	mov    %esp,%ebp
  801f6f:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801f70:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f73:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f76:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f79:	8b 45 08             	mov    0x8(%ebp),%eax
  801f7c:	6a 00                	push   $0x0
  801f7e:	53                   	push   %ebx
  801f7f:	51                   	push   %ecx
  801f80:	52                   	push   %edx
  801f81:	50                   	push   %eax
  801f82:	6a 2e                	push   $0x2e
  801f84:	e8 c7 f9 ff ff       	call   801950 <syscall>
  801f89:	83 c4 18             	add    $0x18,%esp
}
  801f8c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f8f:	c9                   	leave  
  801f90:	c3                   	ret    

00801f91 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801f91:	55                   	push   %ebp
  801f92:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801f94:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f97:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9a:	6a 00                	push   $0x0
  801f9c:	6a 00                	push   $0x0
  801f9e:	6a 00                	push   $0x0
  801fa0:	52                   	push   %edx
  801fa1:	50                   	push   %eax
  801fa2:	6a 2f                	push   $0x2f
  801fa4:	e8 a7 f9 ff ff       	call   801950 <syscall>
  801fa9:	83 c4 18             	add    $0x18,%esp
}
  801fac:	c9                   	leave  
  801fad:	c3                   	ret    

00801fae <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801fae:	55                   	push   %ebp
  801faf:	89 e5                	mov    %esp,%ebp
  801fb1:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801fb4:	83 ec 0c             	sub    $0xc,%esp
  801fb7:	68 c4 41 80 00       	push   $0x8041c4
  801fbc:	e8 8c e7 ff ff       	call   80074d <cprintf>
  801fc1:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801fc4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801fcb:	83 ec 0c             	sub    $0xc,%esp
  801fce:	68 f0 41 80 00       	push   $0x8041f0
  801fd3:	e8 75 e7 ff ff       	call   80074d <cprintf>
  801fd8:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801fdb:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801fdf:	a1 38 51 80 00       	mov    0x805138,%eax
  801fe4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fe7:	eb 56                	jmp    80203f <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801fe9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801fed:	74 1c                	je     80200b <print_mem_block_lists+0x5d>
  801fef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ff2:	8b 50 08             	mov    0x8(%eax),%edx
  801ff5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ff8:	8b 48 08             	mov    0x8(%eax),%ecx
  801ffb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ffe:	8b 40 0c             	mov    0xc(%eax),%eax
  802001:	01 c8                	add    %ecx,%eax
  802003:	39 c2                	cmp    %eax,%edx
  802005:	73 04                	jae    80200b <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802007:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80200b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80200e:	8b 50 08             	mov    0x8(%eax),%edx
  802011:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802014:	8b 40 0c             	mov    0xc(%eax),%eax
  802017:	01 c2                	add    %eax,%edx
  802019:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80201c:	8b 40 08             	mov    0x8(%eax),%eax
  80201f:	83 ec 04             	sub    $0x4,%esp
  802022:	52                   	push   %edx
  802023:	50                   	push   %eax
  802024:	68 05 42 80 00       	push   $0x804205
  802029:	e8 1f e7 ff ff       	call   80074d <cprintf>
  80202e:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802031:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802034:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802037:	a1 40 51 80 00       	mov    0x805140,%eax
  80203c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80203f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802043:	74 07                	je     80204c <print_mem_block_lists+0x9e>
  802045:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802048:	8b 00                	mov    (%eax),%eax
  80204a:	eb 05                	jmp    802051 <print_mem_block_lists+0xa3>
  80204c:	b8 00 00 00 00       	mov    $0x0,%eax
  802051:	a3 40 51 80 00       	mov    %eax,0x805140
  802056:	a1 40 51 80 00       	mov    0x805140,%eax
  80205b:	85 c0                	test   %eax,%eax
  80205d:	75 8a                	jne    801fe9 <print_mem_block_lists+0x3b>
  80205f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802063:	75 84                	jne    801fe9 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802065:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802069:	75 10                	jne    80207b <print_mem_block_lists+0xcd>
  80206b:	83 ec 0c             	sub    $0xc,%esp
  80206e:	68 14 42 80 00       	push   $0x804214
  802073:	e8 d5 e6 ff ff       	call   80074d <cprintf>
  802078:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  80207b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802082:	83 ec 0c             	sub    $0xc,%esp
  802085:	68 38 42 80 00       	push   $0x804238
  80208a:	e8 be e6 ff ff       	call   80074d <cprintf>
  80208f:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802092:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802096:	a1 40 50 80 00       	mov    0x805040,%eax
  80209b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80209e:	eb 56                	jmp    8020f6 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8020a0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8020a4:	74 1c                	je     8020c2 <print_mem_block_lists+0x114>
  8020a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a9:	8b 50 08             	mov    0x8(%eax),%edx
  8020ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020af:	8b 48 08             	mov    0x8(%eax),%ecx
  8020b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020b5:	8b 40 0c             	mov    0xc(%eax),%eax
  8020b8:	01 c8                	add    %ecx,%eax
  8020ba:	39 c2                	cmp    %eax,%edx
  8020bc:	73 04                	jae    8020c2 <print_mem_block_lists+0x114>
			sorted = 0 ;
  8020be:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8020c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c5:	8b 50 08             	mov    0x8(%eax),%edx
  8020c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020cb:	8b 40 0c             	mov    0xc(%eax),%eax
  8020ce:	01 c2                	add    %eax,%edx
  8020d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020d3:	8b 40 08             	mov    0x8(%eax),%eax
  8020d6:	83 ec 04             	sub    $0x4,%esp
  8020d9:	52                   	push   %edx
  8020da:	50                   	push   %eax
  8020db:	68 05 42 80 00       	push   $0x804205
  8020e0:	e8 68 e6 ff ff       	call   80074d <cprintf>
  8020e5:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8020e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8020ee:	a1 48 50 80 00       	mov    0x805048,%eax
  8020f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020f6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020fa:	74 07                	je     802103 <print_mem_block_lists+0x155>
  8020fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ff:	8b 00                	mov    (%eax),%eax
  802101:	eb 05                	jmp    802108 <print_mem_block_lists+0x15a>
  802103:	b8 00 00 00 00       	mov    $0x0,%eax
  802108:	a3 48 50 80 00       	mov    %eax,0x805048
  80210d:	a1 48 50 80 00       	mov    0x805048,%eax
  802112:	85 c0                	test   %eax,%eax
  802114:	75 8a                	jne    8020a0 <print_mem_block_lists+0xf2>
  802116:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80211a:	75 84                	jne    8020a0 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  80211c:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802120:	75 10                	jne    802132 <print_mem_block_lists+0x184>
  802122:	83 ec 0c             	sub    $0xc,%esp
  802125:	68 50 42 80 00       	push   $0x804250
  80212a:	e8 1e e6 ff ff       	call   80074d <cprintf>
  80212f:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802132:	83 ec 0c             	sub    $0xc,%esp
  802135:	68 c4 41 80 00       	push   $0x8041c4
  80213a:	e8 0e e6 ff ff       	call   80074d <cprintf>
  80213f:	83 c4 10             	add    $0x10,%esp

}
  802142:	90                   	nop
  802143:	c9                   	leave  
  802144:	c3                   	ret    

00802145 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802145:	55                   	push   %ebp
  802146:	89 e5                	mov    %esp,%ebp
  802148:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  80214b:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802152:	00 00 00 
  802155:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  80215c:	00 00 00 
  80215f:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802166:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  802169:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802170:	e9 9e 00 00 00       	jmp    802213 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  802175:	a1 50 50 80 00       	mov    0x805050,%eax
  80217a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80217d:	c1 e2 04             	shl    $0x4,%edx
  802180:	01 d0                	add    %edx,%eax
  802182:	85 c0                	test   %eax,%eax
  802184:	75 14                	jne    80219a <initialize_MemBlocksList+0x55>
  802186:	83 ec 04             	sub    $0x4,%esp
  802189:	68 78 42 80 00       	push   $0x804278
  80218e:	6a 46                	push   $0x46
  802190:	68 9b 42 80 00       	push   $0x80429b
  802195:	e8 ff e2 ff ff       	call   800499 <_panic>
  80219a:	a1 50 50 80 00       	mov    0x805050,%eax
  80219f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021a2:	c1 e2 04             	shl    $0x4,%edx
  8021a5:	01 d0                	add    %edx,%eax
  8021a7:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8021ad:	89 10                	mov    %edx,(%eax)
  8021af:	8b 00                	mov    (%eax),%eax
  8021b1:	85 c0                	test   %eax,%eax
  8021b3:	74 18                	je     8021cd <initialize_MemBlocksList+0x88>
  8021b5:	a1 48 51 80 00       	mov    0x805148,%eax
  8021ba:	8b 15 50 50 80 00    	mov    0x805050,%edx
  8021c0:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8021c3:	c1 e1 04             	shl    $0x4,%ecx
  8021c6:	01 ca                	add    %ecx,%edx
  8021c8:	89 50 04             	mov    %edx,0x4(%eax)
  8021cb:	eb 12                	jmp    8021df <initialize_MemBlocksList+0x9a>
  8021cd:	a1 50 50 80 00       	mov    0x805050,%eax
  8021d2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021d5:	c1 e2 04             	shl    $0x4,%edx
  8021d8:	01 d0                	add    %edx,%eax
  8021da:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8021df:	a1 50 50 80 00       	mov    0x805050,%eax
  8021e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021e7:	c1 e2 04             	shl    $0x4,%edx
  8021ea:	01 d0                	add    %edx,%eax
  8021ec:	a3 48 51 80 00       	mov    %eax,0x805148
  8021f1:	a1 50 50 80 00       	mov    0x805050,%eax
  8021f6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021f9:	c1 e2 04             	shl    $0x4,%edx
  8021fc:	01 d0                	add    %edx,%eax
  8021fe:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802205:	a1 54 51 80 00       	mov    0x805154,%eax
  80220a:	40                   	inc    %eax
  80220b:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  802210:	ff 45 f4             	incl   -0xc(%ebp)
  802213:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802216:	3b 45 08             	cmp    0x8(%ebp),%eax
  802219:	0f 82 56 ff ff ff    	jb     802175 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  80221f:	90                   	nop
  802220:	c9                   	leave  
  802221:	c3                   	ret    

00802222 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802222:	55                   	push   %ebp
  802223:	89 e5                	mov    %esp,%ebp
  802225:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802228:	8b 45 08             	mov    0x8(%ebp),%eax
  80222b:	8b 00                	mov    (%eax),%eax
  80222d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802230:	eb 19                	jmp    80224b <find_block+0x29>
	{
		if(va==point->sva)
  802232:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802235:	8b 40 08             	mov    0x8(%eax),%eax
  802238:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80223b:	75 05                	jne    802242 <find_block+0x20>
		   return point;
  80223d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802240:	eb 36                	jmp    802278 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802242:	8b 45 08             	mov    0x8(%ebp),%eax
  802245:	8b 40 08             	mov    0x8(%eax),%eax
  802248:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80224b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80224f:	74 07                	je     802258 <find_block+0x36>
  802251:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802254:	8b 00                	mov    (%eax),%eax
  802256:	eb 05                	jmp    80225d <find_block+0x3b>
  802258:	b8 00 00 00 00       	mov    $0x0,%eax
  80225d:	8b 55 08             	mov    0x8(%ebp),%edx
  802260:	89 42 08             	mov    %eax,0x8(%edx)
  802263:	8b 45 08             	mov    0x8(%ebp),%eax
  802266:	8b 40 08             	mov    0x8(%eax),%eax
  802269:	85 c0                	test   %eax,%eax
  80226b:	75 c5                	jne    802232 <find_block+0x10>
  80226d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802271:	75 bf                	jne    802232 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802273:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802278:	c9                   	leave  
  802279:	c3                   	ret    

0080227a <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80227a:	55                   	push   %ebp
  80227b:	89 e5                	mov    %esp,%ebp
  80227d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  802280:	a1 40 50 80 00       	mov    0x805040,%eax
  802285:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802288:	a1 44 50 80 00       	mov    0x805044,%eax
  80228d:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  802290:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802293:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802296:	74 24                	je     8022bc <insert_sorted_allocList+0x42>
  802298:	8b 45 08             	mov    0x8(%ebp),%eax
  80229b:	8b 50 08             	mov    0x8(%eax),%edx
  80229e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022a1:	8b 40 08             	mov    0x8(%eax),%eax
  8022a4:	39 c2                	cmp    %eax,%edx
  8022a6:	76 14                	jbe    8022bc <insert_sorted_allocList+0x42>
  8022a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ab:	8b 50 08             	mov    0x8(%eax),%edx
  8022ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022b1:	8b 40 08             	mov    0x8(%eax),%eax
  8022b4:	39 c2                	cmp    %eax,%edx
  8022b6:	0f 82 60 01 00 00    	jb     80241c <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  8022bc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8022c0:	75 65                	jne    802327 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  8022c2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022c6:	75 14                	jne    8022dc <insert_sorted_allocList+0x62>
  8022c8:	83 ec 04             	sub    $0x4,%esp
  8022cb:	68 78 42 80 00       	push   $0x804278
  8022d0:	6a 6b                	push   $0x6b
  8022d2:	68 9b 42 80 00       	push   $0x80429b
  8022d7:	e8 bd e1 ff ff       	call   800499 <_panic>
  8022dc:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8022e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e5:	89 10                	mov    %edx,(%eax)
  8022e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ea:	8b 00                	mov    (%eax),%eax
  8022ec:	85 c0                	test   %eax,%eax
  8022ee:	74 0d                	je     8022fd <insert_sorted_allocList+0x83>
  8022f0:	a1 40 50 80 00       	mov    0x805040,%eax
  8022f5:	8b 55 08             	mov    0x8(%ebp),%edx
  8022f8:	89 50 04             	mov    %edx,0x4(%eax)
  8022fb:	eb 08                	jmp    802305 <insert_sorted_allocList+0x8b>
  8022fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802300:	a3 44 50 80 00       	mov    %eax,0x805044
  802305:	8b 45 08             	mov    0x8(%ebp),%eax
  802308:	a3 40 50 80 00       	mov    %eax,0x805040
  80230d:	8b 45 08             	mov    0x8(%ebp),%eax
  802310:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802317:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80231c:	40                   	inc    %eax
  80231d:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802322:	e9 dc 01 00 00       	jmp    802503 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802327:	8b 45 08             	mov    0x8(%ebp),%eax
  80232a:	8b 50 08             	mov    0x8(%eax),%edx
  80232d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802330:	8b 40 08             	mov    0x8(%eax),%eax
  802333:	39 c2                	cmp    %eax,%edx
  802335:	77 6c                	ja     8023a3 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802337:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80233b:	74 06                	je     802343 <insert_sorted_allocList+0xc9>
  80233d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802341:	75 14                	jne    802357 <insert_sorted_allocList+0xdd>
  802343:	83 ec 04             	sub    $0x4,%esp
  802346:	68 b4 42 80 00       	push   $0x8042b4
  80234b:	6a 6f                	push   $0x6f
  80234d:	68 9b 42 80 00       	push   $0x80429b
  802352:	e8 42 e1 ff ff       	call   800499 <_panic>
  802357:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80235a:	8b 50 04             	mov    0x4(%eax),%edx
  80235d:	8b 45 08             	mov    0x8(%ebp),%eax
  802360:	89 50 04             	mov    %edx,0x4(%eax)
  802363:	8b 45 08             	mov    0x8(%ebp),%eax
  802366:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802369:	89 10                	mov    %edx,(%eax)
  80236b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80236e:	8b 40 04             	mov    0x4(%eax),%eax
  802371:	85 c0                	test   %eax,%eax
  802373:	74 0d                	je     802382 <insert_sorted_allocList+0x108>
  802375:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802378:	8b 40 04             	mov    0x4(%eax),%eax
  80237b:	8b 55 08             	mov    0x8(%ebp),%edx
  80237e:	89 10                	mov    %edx,(%eax)
  802380:	eb 08                	jmp    80238a <insert_sorted_allocList+0x110>
  802382:	8b 45 08             	mov    0x8(%ebp),%eax
  802385:	a3 40 50 80 00       	mov    %eax,0x805040
  80238a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80238d:	8b 55 08             	mov    0x8(%ebp),%edx
  802390:	89 50 04             	mov    %edx,0x4(%eax)
  802393:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802398:	40                   	inc    %eax
  802399:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80239e:	e9 60 01 00 00       	jmp    802503 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  8023a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a6:	8b 50 08             	mov    0x8(%eax),%edx
  8023a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023ac:	8b 40 08             	mov    0x8(%eax),%eax
  8023af:	39 c2                	cmp    %eax,%edx
  8023b1:	0f 82 4c 01 00 00    	jb     802503 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8023b7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023bb:	75 14                	jne    8023d1 <insert_sorted_allocList+0x157>
  8023bd:	83 ec 04             	sub    $0x4,%esp
  8023c0:	68 ec 42 80 00       	push   $0x8042ec
  8023c5:	6a 73                	push   $0x73
  8023c7:	68 9b 42 80 00       	push   $0x80429b
  8023cc:	e8 c8 e0 ff ff       	call   800499 <_panic>
  8023d1:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8023d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8023da:	89 50 04             	mov    %edx,0x4(%eax)
  8023dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e0:	8b 40 04             	mov    0x4(%eax),%eax
  8023e3:	85 c0                	test   %eax,%eax
  8023e5:	74 0c                	je     8023f3 <insert_sorted_allocList+0x179>
  8023e7:	a1 44 50 80 00       	mov    0x805044,%eax
  8023ec:	8b 55 08             	mov    0x8(%ebp),%edx
  8023ef:	89 10                	mov    %edx,(%eax)
  8023f1:	eb 08                	jmp    8023fb <insert_sorted_allocList+0x181>
  8023f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f6:	a3 40 50 80 00       	mov    %eax,0x805040
  8023fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8023fe:	a3 44 50 80 00       	mov    %eax,0x805044
  802403:	8b 45 08             	mov    0x8(%ebp),%eax
  802406:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80240c:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802411:	40                   	inc    %eax
  802412:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802417:	e9 e7 00 00 00       	jmp    802503 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  80241c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80241f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802422:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802429:	a1 40 50 80 00       	mov    0x805040,%eax
  80242e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802431:	e9 9d 00 00 00       	jmp    8024d3 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802436:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802439:	8b 00                	mov    (%eax),%eax
  80243b:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  80243e:	8b 45 08             	mov    0x8(%ebp),%eax
  802441:	8b 50 08             	mov    0x8(%eax),%edx
  802444:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802447:	8b 40 08             	mov    0x8(%eax),%eax
  80244a:	39 c2                	cmp    %eax,%edx
  80244c:	76 7d                	jbe    8024cb <insert_sorted_allocList+0x251>
  80244e:	8b 45 08             	mov    0x8(%ebp),%eax
  802451:	8b 50 08             	mov    0x8(%eax),%edx
  802454:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802457:	8b 40 08             	mov    0x8(%eax),%eax
  80245a:	39 c2                	cmp    %eax,%edx
  80245c:	73 6d                	jae    8024cb <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  80245e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802462:	74 06                	je     80246a <insert_sorted_allocList+0x1f0>
  802464:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802468:	75 14                	jne    80247e <insert_sorted_allocList+0x204>
  80246a:	83 ec 04             	sub    $0x4,%esp
  80246d:	68 10 43 80 00       	push   $0x804310
  802472:	6a 7f                	push   $0x7f
  802474:	68 9b 42 80 00       	push   $0x80429b
  802479:	e8 1b e0 ff ff       	call   800499 <_panic>
  80247e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802481:	8b 10                	mov    (%eax),%edx
  802483:	8b 45 08             	mov    0x8(%ebp),%eax
  802486:	89 10                	mov    %edx,(%eax)
  802488:	8b 45 08             	mov    0x8(%ebp),%eax
  80248b:	8b 00                	mov    (%eax),%eax
  80248d:	85 c0                	test   %eax,%eax
  80248f:	74 0b                	je     80249c <insert_sorted_allocList+0x222>
  802491:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802494:	8b 00                	mov    (%eax),%eax
  802496:	8b 55 08             	mov    0x8(%ebp),%edx
  802499:	89 50 04             	mov    %edx,0x4(%eax)
  80249c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249f:	8b 55 08             	mov    0x8(%ebp),%edx
  8024a2:	89 10                	mov    %edx,(%eax)
  8024a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024aa:	89 50 04             	mov    %edx,0x4(%eax)
  8024ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b0:	8b 00                	mov    (%eax),%eax
  8024b2:	85 c0                	test   %eax,%eax
  8024b4:	75 08                	jne    8024be <insert_sorted_allocList+0x244>
  8024b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b9:	a3 44 50 80 00       	mov    %eax,0x805044
  8024be:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8024c3:	40                   	inc    %eax
  8024c4:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  8024c9:	eb 39                	jmp    802504 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8024cb:	a1 48 50 80 00       	mov    0x805048,%eax
  8024d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024d3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024d7:	74 07                	je     8024e0 <insert_sorted_allocList+0x266>
  8024d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024dc:	8b 00                	mov    (%eax),%eax
  8024de:	eb 05                	jmp    8024e5 <insert_sorted_allocList+0x26b>
  8024e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8024e5:	a3 48 50 80 00       	mov    %eax,0x805048
  8024ea:	a1 48 50 80 00       	mov    0x805048,%eax
  8024ef:	85 c0                	test   %eax,%eax
  8024f1:	0f 85 3f ff ff ff    	jne    802436 <insert_sorted_allocList+0x1bc>
  8024f7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024fb:	0f 85 35 ff ff ff    	jne    802436 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802501:	eb 01                	jmp    802504 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802503:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802504:	90                   	nop
  802505:	c9                   	leave  
  802506:	c3                   	ret    

00802507 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802507:	55                   	push   %ebp
  802508:	89 e5                	mov    %esp,%ebp
  80250a:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  80250d:	a1 38 51 80 00       	mov    0x805138,%eax
  802512:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802515:	e9 85 01 00 00       	jmp    80269f <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  80251a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251d:	8b 40 0c             	mov    0xc(%eax),%eax
  802520:	3b 45 08             	cmp    0x8(%ebp),%eax
  802523:	0f 82 6e 01 00 00    	jb     802697 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802529:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252c:	8b 40 0c             	mov    0xc(%eax),%eax
  80252f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802532:	0f 85 8a 00 00 00    	jne    8025c2 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802538:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80253c:	75 17                	jne    802555 <alloc_block_FF+0x4e>
  80253e:	83 ec 04             	sub    $0x4,%esp
  802541:	68 44 43 80 00       	push   $0x804344
  802546:	68 93 00 00 00       	push   $0x93
  80254b:	68 9b 42 80 00       	push   $0x80429b
  802550:	e8 44 df ff ff       	call   800499 <_panic>
  802555:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802558:	8b 00                	mov    (%eax),%eax
  80255a:	85 c0                	test   %eax,%eax
  80255c:	74 10                	je     80256e <alloc_block_FF+0x67>
  80255e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802561:	8b 00                	mov    (%eax),%eax
  802563:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802566:	8b 52 04             	mov    0x4(%edx),%edx
  802569:	89 50 04             	mov    %edx,0x4(%eax)
  80256c:	eb 0b                	jmp    802579 <alloc_block_FF+0x72>
  80256e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802571:	8b 40 04             	mov    0x4(%eax),%eax
  802574:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802579:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257c:	8b 40 04             	mov    0x4(%eax),%eax
  80257f:	85 c0                	test   %eax,%eax
  802581:	74 0f                	je     802592 <alloc_block_FF+0x8b>
  802583:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802586:	8b 40 04             	mov    0x4(%eax),%eax
  802589:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80258c:	8b 12                	mov    (%edx),%edx
  80258e:	89 10                	mov    %edx,(%eax)
  802590:	eb 0a                	jmp    80259c <alloc_block_FF+0x95>
  802592:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802595:	8b 00                	mov    (%eax),%eax
  802597:	a3 38 51 80 00       	mov    %eax,0x805138
  80259c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025af:	a1 44 51 80 00       	mov    0x805144,%eax
  8025b4:	48                   	dec    %eax
  8025b5:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  8025ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025bd:	e9 10 01 00 00       	jmp    8026d2 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  8025c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c5:	8b 40 0c             	mov    0xc(%eax),%eax
  8025c8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025cb:	0f 86 c6 00 00 00    	jbe    802697 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8025d1:	a1 48 51 80 00       	mov    0x805148,%eax
  8025d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  8025d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025dc:	8b 50 08             	mov    0x8(%eax),%edx
  8025df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025e2:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  8025e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025e8:	8b 55 08             	mov    0x8(%ebp),%edx
  8025eb:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8025ee:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8025f2:	75 17                	jne    80260b <alloc_block_FF+0x104>
  8025f4:	83 ec 04             	sub    $0x4,%esp
  8025f7:	68 44 43 80 00       	push   $0x804344
  8025fc:	68 9b 00 00 00       	push   $0x9b
  802601:	68 9b 42 80 00       	push   $0x80429b
  802606:	e8 8e de ff ff       	call   800499 <_panic>
  80260b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80260e:	8b 00                	mov    (%eax),%eax
  802610:	85 c0                	test   %eax,%eax
  802612:	74 10                	je     802624 <alloc_block_FF+0x11d>
  802614:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802617:	8b 00                	mov    (%eax),%eax
  802619:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80261c:	8b 52 04             	mov    0x4(%edx),%edx
  80261f:	89 50 04             	mov    %edx,0x4(%eax)
  802622:	eb 0b                	jmp    80262f <alloc_block_FF+0x128>
  802624:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802627:	8b 40 04             	mov    0x4(%eax),%eax
  80262a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80262f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802632:	8b 40 04             	mov    0x4(%eax),%eax
  802635:	85 c0                	test   %eax,%eax
  802637:	74 0f                	je     802648 <alloc_block_FF+0x141>
  802639:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80263c:	8b 40 04             	mov    0x4(%eax),%eax
  80263f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802642:	8b 12                	mov    (%edx),%edx
  802644:	89 10                	mov    %edx,(%eax)
  802646:	eb 0a                	jmp    802652 <alloc_block_FF+0x14b>
  802648:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80264b:	8b 00                	mov    (%eax),%eax
  80264d:	a3 48 51 80 00       	mov    %eax,0x805148
  802652:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802655:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80265b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80265e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802665:	a1 54 51 80 00       	mov    0x805154,%eax
  80266a:	48                   	dec    %eax
  80266b:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802670:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802673:	8b 50 08             	mov    0x8(%eax),%edx
  802676:	8b 45 08             	mov    0x8(%ebp),%eax
  802679:	01 c2                	add    %eax,%edx
  80267b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267e:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802681:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802684:	8b 40 0c             	mov    0xc(%eax),%eax
  802687:	2b 45 08             	sub    0x8(%ebp),%eax
  80268a:	89 c2                	mov    %eax,%edx
  80268c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268f:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802692:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802695:	eb 3b                	jmp    8026d2 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802697:	a1 40 51 80 00       	mov    0x805140,%eax
  80269c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80269f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026a3:	74 07                	je     8026ac <alloc_block_FF+0x1a5>
  8026a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a8:	8b 00                	mov    (%eax),%eax
  8026aa:	eb 05                	jmp    8026b1 <alloc_block_FF+0x1aa>
  8026ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8026b1:	a3 40 51 80 00       	mov    %eax,0x805140
  8026b6:	a1 40 51 80 00       	mov    0x805140,%eax
  8026bb:	85 c0                	test   %eax,%eax
  8026bd:	0f 85 57 fe ff ff    	jne    80251a <alloc_block_FF+0x13>
  8026c3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026c7:	0f 85 4d fe ff ff    	jne    80251a <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  8026cd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026d2:	c9                   	leave  
  8026d3:	c3                   	ret    

008026d4 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8026d4:	55                   	push   %ebp
  8026d5:	89 e5                	mov    %esp,%ebp
  8026d7:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  8026da:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8026e1:	a1 38 51 80 00       	mov    0x805138,%eax
  8026e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026e9:	e9 df 00 00 00       	jmp    8027cd <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  8026ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f1:	8b 40 0c             	mov    0xc(%eax),%eax
  8026f4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026f7:	0f 82 c8 00 00 00    	jb     8027c5 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  8026fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802700:	8b 40 0c             	mov    0xc(%eax),%eax
  802703:	3b 45 08             	cmp    0x8(%ebp),%eax
  802706:	0f 85 8a 00 00 00    	jne    802796 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  80270c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802710:	75 17                	jne    802729 <alloc_block_BF+0x55>
  802712:	83 ec 04             	sub    $0x4,%esp
  802715:	68 44 43 80 00       	push   $0x804344
  80271a:	68 b7 00 00 00       	push   $0xb7
  80271f:	68 9b 42 80 00       	push   $0x80429b
  802724:	e8 70 dd ff ff       	call   800499 <_panic>
  802729:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272c:	8b 00                	mov    (%eax),%eax
  80272e:	85 c0                	test   %eax,%eax
  802730:	74 10                	je     802742 <alloc_block_BF+0x6e>
  802732:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802735:	8b 00                	mov    (%eax),%eax
  802737:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80273a:	8b 52 04             	mov    0x4(%edx),%edx
  80273d:	89 50 04             	mov    %edx,0x4(%eax)
  802740:	eb 0b                	jmp    80274d <alloc_block_BF+0x79>
  802742:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802745:	8b 40 04             	mov    0x4(%eax),%eax
  802748:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80274d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802750:	8b 40 04             	mov    0x4(%eax),%eax
  802753:	85 c0                	test   %eax,%eax
  802755:	74 0f                	je     802766 <alloc_block_BF+0x92>
  802757:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275a:	8b 40 04             	mov    0x4(%eax),%eax
  80275d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802760:	8b 12                	mov    (%edx),%edx
  802762:	89 10                	mov    %edx,(%eax)
  802764:	eb 0a                	jmp    802770 <alloc_block_BF+0x9c>
  802766:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802769:	8b 00                	mov    (%eax),%eax
  80276b:	a3 38 51 80 00       	mov    %eax,0x805138
  802770:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802773:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802779:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802783:	a1 44 51 80 00       	mov    0x805144,%eax
  802788:	48                   	dec    %eax
  802789:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  80278e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802791:	e9 4d 01 00 00       	jmp    8028e3 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802796:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802799:	8b 40 0c             	mov    0xc(%eax),%eax
  80279c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80279f:	76 24                	jbe    8027c5 <alloc_block_BF+0xf1>
  8027a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a4:	8b 40 0c             	mov    0xc(%eax),%eax
  8027a7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8027aa:	73 19                	jae    8027c5 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  8027ac:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  8027b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b6:	8b 40 0c             	mov    0xc(%eax),%eax
  8027b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  8027bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027bf:	8b 40 08             	mov    0x8(%eax),%eax
  8027c2:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8027c5:	a1 40 51 80 00       	mov    0x805140,%eax
  8027ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027cd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027d1:	74 07                	je     8027da <alloc_block_BF+0x106>
  8027d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d6:	8b 00                	mov    (%eax),%eax
  8027d8:	eb 05                	jmp    8027df <alloc_block_BF+0x10b>
  8027da:	b8 00 00 00 00       	mov    $0x0,%eax
  8027df:	a3 40 51 80 00       	mov    %eax,0x805140
  8027e4:	a1 40 51 80 00       	mov    0x805140,%eax
  8027e9:	85 c0                	test   %eax,%eax
  8027eb:	0f 85 fd fe ff ff    	jne    8026ee <alloc_block_BF+0x1a>
  8027f1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027f5:	0f 85 f3 fe ff ff    	jne    8026ee <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  8027fb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8027ff:	0f 84 d9 00 00 00    	je     8028de <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802805:	a1 48 51 80 00       	mov    0x805148,%eax
  80280a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  80280d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802810:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802813:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802816:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802819:	8b 55 08             	mov    0x8(%ebp),%edx
  80281c:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  80281f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802823:	75 17                	jne    80283c <alloc_block_BF+0x168>
  802825:	83 ec 04             	sub    $0x4,%esp
  802828:	68 44 43 80 00       	push   $0x804344
  80282d:	68 c7 00 00 00       	push   $0xc7
  802832:	68 9b 42 80 00       	push   $0x80429b
  802837:	e8 5d dc ff ff       	call   800499 <_panic>
  80283c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80283f:	8b 00                	mov    (%eax),%eax
  802841:	85 c0                	test   %eax,%eax
  802843:	74 10                	je     802855 <alloc_block_BF+0x181>
  802845:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802848:	8b 00                	mov    (%eax),%eax
  80284a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80284d:	8b 52 04             	mov    0x4(%edx),%edx
  802850:	89 50 04             	mov    %edx,0x4(%eax)
  802853:	eb 0b                	jmp    802860 <alloc_block_BF+0x18c>
  802855:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802858:	8b 40 04             	mov    0x4(%eax),%eax
  80285b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802860:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802863:	8b 40 04             	mov    0x4(%eax),%eax
  802866:	85 c0                	test   %eax,%eax
  802868:	74 0f                	je     802879 <alloc_block_BF+0x1a5>
  80286a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80286d:	8b 40 04             	mov    0x4(%eax),%eax
  802870:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802873:	8b 12                	mov    (%edx),%edx
  802875:	89 10                	mov    %edx,(%eax)
  802877:	eb 0a                	jmp    802883 <alloc_block_BF+0x1af>
  802879:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80287c:	8b 00                	mov    (%eax),%eax
  80287e:	a3 48 51 80 00       	mov    %eax,0x805148
  802883:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802886:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80288c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80288f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802896:	a1 54 51 80 00       	mov    0x805154,%eax
  80289b:	48                   	dec    %eax
  80289c:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  8028a1:	83 ec 08             	sub    $0x8,%esp
  8028a4:	ff 75 ec             	pushl  -0x14(%ebp)
  8028a7:	68 38 51 80 00       	push   $0x805138
  8028ac:	e8 71 f9 ff ff       	call   802222 <find_block>
  8028b1:	83 c4 10             	add    $0x10,%esp
  8028b4:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  8028b7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028ba:	8b 50 08             	mov    0x8(%eax),%edx
  8028bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c0:	01 c2                	add    %eax,%edx
  8028c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028c5:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  8028c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028cb:	8b 40 0c             	mov    0xc(%eax),%eax
  8028ce:	2b 45 08             	sub    0x8(%ebp),%eax
  8028d1:	89 c2                	mov    %eax,%edx
  8028d3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028d6:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  8028d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028dc:	eb 05                	jmp    8028e3 <alloc_block_BF+0x20f>
	}
	return NULL;
  8028de:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028e3:	c9                   	leave  
  8028e4:	c3                   	ret    

008028e5 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  8028e5:	55                   	push   %ebp
  8028e6:	89 e5                	mov    %esp,%ebp
  8028e8:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  8028eb:	a1 28 50 80 00       	mov    0x805028,%eax
  8028f0:	85 c0                	test   %eax,%eax
  8028f2:	0f 85 de 01 00 00    	jne    802ad6 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8028f8:	a1 38 51 80 00       	mov    0x805138,%eax
  8028fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802900:	e9 9e 01 00 00       	jmp    802aa3 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802905:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802908:	8b 40 0c             	mov    0xc(%eax),%eax
  80290b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80290e:	0f 82 87 01 00 00    	jb     802a9b <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802914:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802917:	8b 40 0c             	mov    0xc(%eax),%eax
  80291a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80291d:	0f 85 95 00 00 00    	jne    8029b8 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802923:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802927:	75 17                	jne    802940 <alloc_block_NF+0x5b>
  802929:	83 ec 04             	sub    $0x4,%esp
  80292c:	68 44 43 80 00       	push   $0x804344
  802931:	68 e0 00 00 00       	push   $0xe0
  802936:	68 9b 42 80 00       	push   $0x80429b
  80293b:	e8 59 db ff ff       	call   800499 <_panic>
  802940:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802943:	8b 00                	mov    (%eax),%eax
  802945:	85 c0                	test   %eax,%eax
  802947:	74 10                	je     802959 <alloc_block_NF+0x74>
  802949:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294c:	8b 00                	mov    (%eax),%eax
  80294e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802951:	8b 52 04             	mov    0x4(%edx),%edx
  802954:	89 50 04             	mov    %edx,0x4(%eax)
  802957:	eb 0b                	jmp    802964 <alloc_block_NF+0x7f>
  802959:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295c:	8b 40 04             	mov    0x4(%eax),%eax
  80295f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802964:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802967:	8b 40 04             	mov    0x4(%eax),%eax
  80296a:	85 c0                	test   %eax,%eax
  80296c:	74 0f                	je     80297d <alloc_block_NF+0x98>
  80296e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802971:	8b 40 04             	mov    0x4(%eax),%eax
  802974:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802977:	8b 12                	mov    (%edx),%edx
  802979:	89 10                	mov    %edx,(%eax)
  80297b:	eb 0a                	jmp    802987 <alloc_block_NF+0xa2>
  80297d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802980:	8b 00                	mov    (%eax),%eax
  802982:	a3 38 51 80 00       	mov    %eax,0x805138
  802987:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802990:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802993:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80299a:	a1 44 51 80 00       	mov    0x805144,%eax
  80299f:	48                   	dec    %eax
  8029a0:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  8029a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a8:	8b 40 08             	mov    0x8(%eax),%eax
  8029ab:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  8029b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b3:	e9 f8 04 00 00       	jmp    802eb0 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  8029b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029bb:	8b 40 0c             	mov    0xc(%eax),%eax
  8029be:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029c1:	0f 86 d4 00 00 00    	jbe    802a9b <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8029c7:	a1 48 51 80 00       	mov    0x805148,%eax
  8029cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  8029cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d2:	8b 50 08             	mov    0x8(%eax),%edx
  8029d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029d8:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  8029db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029de:	8b 55 08             	mov    0x8(%ebp),%edx
  8029e1:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8029e4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8029e8:	75 17                	jne    802a01 <alloc_block_NF+0x11c>
  8029ea:	83 ec 04             	sub    $0x4,%esp
  8029ed:	68 44 43 80 00       	push   $0x804344
  8029f2:	68 e9 00 00 00       	push   $0xe9
  8029f7:	68 9b 42 80 00       	push   $0x80429b
  8029fc:	e8 98 da ff ff       	call   800499 <_panic>
  802a01:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a04:	8b 00                	mov    (%eax),%eax
  802a06:	85 c0                	test   %eax,%eax
  802a08:	74 10                	je     802a1a <alloc_block_NF+0x135>
  802a0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a0d:	8b 00                	mov    (%eax),%eax
  802a0f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a12:	8b 52 04             	mov    0x4(%edx),%edx
  802a15:	89 50 04             	mov    %edx,0x4(%eax)
  802a18:	eb 0b                	jmp    802a25 <alloc_block_NF+0x140>
  802a1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a1d:	8b 40 04             	mov    0x4(%eax),%eax
  802a20:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802a25:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a28:	8b 40 04             	mov    0x4(%eax),%eax
  802a2b:	85 c0                	test   %eax,%eax
  802a2d:	74 0f                	je     802a3e <alloc_block_NF+0x159>
  802a2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a32:	8b 40 04             	mov    0x4(%eax),%eax
  802a35:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a38:	8b 12                	mov    (%edx),%edx
  802a3a:	89 10                	mov    %edx,(%eax)
  802a3c:	eb 0a                	jmp    802a48 <alloc_block_NF+0x163>
  802a3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a41:	8b 00                	mov    (%eax),%eax
  802a43:	a3 48 51 80 00       	mov    %eax,0x805148
  802a48:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a4b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a51:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a54:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a5b:	a1 54 51 80 00       	mov    0x805154,%eax
  802a60:	48                   	dec    %eax
  802a61:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802a66:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a69:	8b 40 08             	mov    0x8(%eax),%eax
  802a6c:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802a71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a74:	8b 50 08             	mov    0x8(%eax),%edx
  802a77:	8b 45 08             	mov    0x8(%ebp),%eax
  802a7a:	01 c2                	add    %eax,%edx
  802a7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7f:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802a82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a85:	8b 40 0c             	mov    0xc(%eax),%eax
  802a88:	2b 45 08             	sub    0x8(%ebp),%eax
  802a8b:	89 c2                	mov    %eax,%edx
  802a8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a90:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802a93:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a96:	e9 15 04 00 00       	jmp    802eb0 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802a9b:	a1 40 51 80 00       	mov    0x805140,%eax
  802aa0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802aa3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802aa7:	74 07                	je     802ab0 <alloc_block_NF+0x1cb>
  802aa9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aac:	8b 00                	mov    (%eax),%eax
  802aae:	eb 05                	jmp    802ab5 <alloc_block_NF+0x1d0>
  802ab0:	b8 00 00 00 00       	mov    $0x0,%eax
  802ab5:	a3 40 51 80 00       	mov    %eax,0x805140
  802aba:	a1 40 51 80 00       	mov    0x805140,%eax
  802abf:	85 c0                	test   %eax,%eax
  802ac1:	0f 85 3e fe ff ff    	jne    802905 <alloc_block_NF+0x20>
  802ac7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802acb:	0f 85 34 fe ff ff    	jne    802905 <alloc_block_NF+0x20>
  802ad1:	e9 d5 03 00 00       	jmp    802eab <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802ad6:	a1 38 51 80 00       	mov    0x805138,%eax
  802adb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ade:	e9 b1 01 00 00       	jmp    802c94 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802ae3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae6:	8b 50 08             	mov    0x8(%eax),%edx
  802ae9:	a1 28 50 80 00       	mov    0x805028,%eax
  802aee:	39 c2                	cmp    %eax,%edx
  802af0:	0f 82 96 01 00 00    	jb     802c8c <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802af6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af9:	8b 40 0c             	mov    0xc(%eax),%eax
  802afc:	3b 45 08             	cmp    0x8(%ebp),%eax
  802aff:	0f 82 87 01 00 00    	jb     802c8c <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802b05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b08:	8b 40 0c             	mov    0xc(%eax),%eax
  802b0b:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b0e:	0f 85 95 00 00 00    	jne    802ba9 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802b14:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b18:	75 17                	jne    802b31 <alloc_block_NF+0x24c>
  802b1a:	83 ec 04             	sub    $0x4,%esp
  802b1d:	68 44 43 80 00       	push   $0x804344
  802b22:	68 fc 00 00 00       	push   $0xfc
  802b27:	68 9b 42 80 00       	push   $0x80429b
  802b2c:	e8 68 d9 ff ff       	call   800499 <_panic>
  802b31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b34:	8b 00                	mov    (%eax),%eax
  802b36:	85 c0                	test   %eax,%eax
  802b38:	74 10                	je     802b4a <alloc_block_NF+0x265>
  802b3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b3d:	8b 00                	mov    (%eax),%eax
  802b3f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b42:	8b 52 04             	mov    0x4(%edx),%edx
  802b45:	89 50 04             	mov    %edx,0x4(%eax)
  802b48:	eb 0b                	jmp    802b55 <alloc_block_NF+0x270>
  802b4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4d:	8b 40 04             	mov    0x4(%eax),%eax
  802b50:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802b55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b58:	8b 40 04             	mov    0x4(%eax),%eax
  802b5b:	85 c0                	test   %eax,%eax
  802b5d:	74 0f                	je     802b6e <alloc_block_NF+0x289>
  802b5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b62:	8b 40 04             	mov    0x4(%eax),%eax
  802b65:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b68:	8b 12                	mov    (%edx),%edx
  802b6a:	89 10                	mov    %edx,(%eax)
  802b6c:	eb 0a                	jmp    802b78 <alloc_block_NF+0x293>
  802b6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b71:	8b 00                	mov    (%eax),%eax
  802b73:	a3 38 51 80 00       	mov    %eax,0x805138
  802b78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b7b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b84:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b8b:	a1 44 51 80 00       	mov    0x805144,%eax
  802b90:	48                   	dec    %eax
  802b91:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802b96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b99:	8b 40 08             	mov    0x8(%eax),%eax
  802b9c:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802ba1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba4:	e9 07 03 00 00       	jmp    802eb0 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802ba9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bac:	8b 40 0c             	mov    0xc(%eax),%eax
  802baf:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bb2:	0f 86 d4 00 00 00    	jbe    802c8c <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802bb8:	a1 48 51 80 00       	mov    0x805148,%eax
  802bbd:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802bc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc3:	8b 50 08             	mov    0x8(%eax),%edx
  802bc6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bc9:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802bcc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bcf:	8b 55 08             	mov    0x8(%ebp),%edx
  802bd2:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802bd5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802bd9:	75 17                	jne    802bf2 <alloc_block_NF+0x30d>
  802bdb:	83 ec 04             	sub    $0x4,%esp
  802bde:	68 44 43 80 00       	push   $0x804344
  802be3:	68 04 01 00 00       	push   $0x104
  802be8:	68 9b 42 80 00       	push   $0x80429b
  802bed:	e8 a7 d8 ff ff       	call   800499 <_panic>
  802bf2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bf5:	8b 00                	mov    (%eax),%eax
  802bf7:	85 c0                	test   %eax,%eax
  802bf9:	74 10                	je     802c0b <alloc_block_NF+0x326>
  802bfb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bfe:	8b 00                	mov    (%eax),%eax
  802c00:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802c03:	8b 52 04             	mov    0x4(%edx),%edx
  802c06:	89 50 04             	mov    %edx,0x4(%eax)
  802c09:	eb 0b                	jmp    802c16 <alloc_block_NF+0x331>
  802c0b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c0e:	8b 40 04             	mov    0x4(%eax),%eax
  802c11:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802c16:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c19:	8b 40 04             	mov    0x4(%eax),%eax
  802c1c:	85 c0                	test   %eax,%eax
  802c1e:	74 0f                	je     802c2f <alloc_block_NF+0x34a>
  802c20:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c23:	8b 40 04             	mov    0x4(%eax),%eax
  802c26:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802c29:	8b 12                	mov    (%edx),%edx
  802c2b:	89 10                	mov    %edx,(%eax)
  802c2d:	eb 0a                	jmp    802c39 <alloc_block_NF+0x354>
  802c2f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c32:	8b 00                	mov    (%eax),%eax
  802c34:	a3 48 51 80 00       	mov    %eax,0x805148
  802c39:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c3c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c42:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c45:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c4c:	a1 54 51 80 00       	mov    0x805154,%eax
  802c51:	48                   	dec    %eax
  802c52:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802c57:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c5a:	8b 40 08             	mov    0x8(%eax),%eax
  802c5d:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802c62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c65:	8b 50 08             	mov    0x8(%eax),%edx
  802c68:	8b 45 08             	mov    0x8(%ebp),%eax
  802c6b:	01 c2                	add    %eax,%edx
  802c6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c70:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802c73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c76:	8b 40 0c             	mov    0xc(%eax),%eax
  802c79:	2b 45 08             	sub    0x8(%ebp),%eax
  802c7c:	89 c2                	mov    %eax,%edx
  802c7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c81:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802c84:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c87:	e9 24 02 00 00       	jmp    802eb0 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802c8c:	a1 40 51 80 00       	mov    0x805140,%eax
  802c91:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c94:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c98:	74 07                	je     802ca1 <alloc_block_NF+0x3bc>
  802c9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9d:	8b 00                	mov    (%eax),%eax
  802c9f:	eb 05                	jmp    802ca6 <alloc_block_NF+0x3c1>
  802ca1:	b8 00 00 00 00       	mov    $0x0,%eax
  802ca6:	a3 40 51 80 00       	mov    %eax,0x805140
  802cab:	a1 40 51 80 00       	mov    0x805140,%eax
  802cb0:	85 c0                	test   %eax,%eax
  802cb2:	0f 85 2b fe ff ff    	jne    802ae3 <alloc_block_NF+0x1fe>
  802cb8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cbc:	0f 85 21 fe ff ff    	jne    802ae3 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802cc2:	a1 38 51 80 00       	mov    0x805138,%eax
  802cc7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cca:	e9 ae 01 00 00       	jmp    802e7d <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802ccf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd2:	8b 50 08             	mov    0x8(%eax),%edx
  802cd5:	a1 28 50 80 00       	mov    0x805028,%eax
  802cda:	39 c2                	cmp    %eax,%edx
  802cdc:	0f 83 93 01 00 00    	jae    802e75 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802ce2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce5:	8b 40 0c             	mov    0xc(%eax),%eax
  802ce8:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ceb:	0f 82 84 01 00 00    	jb     802e75 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802cf1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf4:	8b 40 0c             	mov    0xc(%eax),%eax
  802cf7:	3b 45 08             	cmp    0x8(%ebp),%eax
  802cfa:	0f 85 95 00 00 00    	jne    802d95 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802d00:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d04:	75 17                	jne    802d1d <alloc_block_NF+0x438>
  802d06:	83 ec 04             	sub    $0x4,%esp
  802d09:	68 44 43 80 00       	push   $0x804344
  802d0e:	68 14 01 00 00       	push   $0x114
  802d13:	68 9b 42 80 00       	push   $0x80429b
  802d18:	e8 7c d7 ff ff       	call   800499 <_panic>
  802d1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d20:	8b 00                	mov    (%eax),%eax
  802d22:	85 c0                	test   %eax,%eax
  802d24:	74 10                	je     802d36 <alloc_block_NF+0x451>
  802d26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d29:	8b 00                	mov    (%eax),%eax
  802d2b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d2e:	8b 52 04             	mov    0x4(%edx),%edx
  802d31:	89 50 04             	mov    %edx,0x4(%eax)
  802d34:	eb 0b                	jmp    802d41 <alloc_block_NF+0x45c>
  802d36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d39:	8b 40 04             	mov    0x4(%eax),%eax
  802d3c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d44:	8b 40 04             	mov    0x4(%eax),%eax
  802d47:	85 c0                	test   %eax,%eax
  802d49:	74 0f                	je     802d5a <alloc_block_NF+0x475>
  802d4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d4e:	8b 40 04             	mov    0x4(%eax),%eax
  802d51:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d54:	8b 12                	mov    (%edx),%edx
  802d56:	89 10                	mov    %edx,(%eax)
  802d58:	eb 0a                	jmp    802d64 <alloc_block_NF+0x47f>
  802d5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d5d:	8b 00                	mov    (%eax),%eax
  802d5f:	a3 38 51 80 00       	mov    %eax,0x805138
  802d64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d67:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d70:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d77:	a1 44 51 80 00       	mov    0x805144,%eax
  802d7c:	48                   	dec    %eax
  802d7d:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802d82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d85:	8b 40 08             	mov    0x8(%eax),%eax
  802d88:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802d8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d90:	e9 1b 01 00 00       	jmp    802eb0 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802d95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d98:	8b 40 0c             	mov    0xc(%eax),%eax
  802d9b:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d9e:	0f 86 d1 00 00 00    	jbe    802e75 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802da4:	a1 48 51 80 00       	mov    0x805148,%eax
  802da9:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802dac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802daf:	8b 50 08             	mov    0x8(%eax),%edx
  802db2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802db5:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802db8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dbb:	8b 55 08             	mov    0x8(%ebp),%edx
  802dbe:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802dc1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802dc5:	75 17                	jne    802dde <alloc_block_NF+0x4f9>
  802dc7:	83 ec 04             	sub    $0x4,%esp
  802dca:	68 44 43 80 00       	push   $0x804344
  802dcf:	68 1c 01 00 00       	push   $0x11c
  802dd4:	68 9b 42 80 00       	push   $0x80429b
  802dd9:	e8 bb d6 ff ff       	call   800499 <_panic>
  802dde:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802de1:	8b 00                	mov    (%eax),%eax
  802de3:	85 c0                	test   %eax,%eax
  802de5:	74 10                	je     802df7 <alloc_block_NF+0x512>
  802de7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dea:	8b 00                	mov    (%eax),%eax
  802dec:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802def:	8b 52 04             	mov    0x4(%edx),%edx
  802df2:	89 50 04             	mov    %edx,0x4(%eax)
  802df5:	eb 0b                	jmp    802e02 <alloc_block_NF+0x51d>
  802df7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dfa:	8b 40 04             	mov    0x4(%eax),%eax
  802dfd:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e02:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e05:	8b 40 04             	mov    0x4(%eax),%eax
  802e08:	85 c0                	test   %eax,%eax
  802e0a:	74 0f                	je     802e1b <alloc_block_NF+0x536>
  802e0c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e0f:	8b 40 04             	mov    0x4(%eax),%eax
  802e12:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802e15:	8b 12                	mov    (%edx),%edx
  802e17:	89 10                	mov    %edx,(%eax)
  802e19:	eb 0a                	jmp    802e25 <alloc_block_NF+0x540>
  802e1b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e1e:	8b 00                	mov    (%eax),%eax
  802e20:	a3 48 51 80 00       	mov    %eax,0x805148
  802e25:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e28:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e2e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e31:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e38:	a1 54 51 80 00       	mov    0x805154,%eax
  802e3d:	48                   	dec    %eax
  802e3e:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802e43:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e46:	8b 40 08             	mov    0x8(%eax),%eax
  802e49:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802e4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e51:	8b 50 08             	mov    0x8(%eax),%edx
  802e54:	8b 45 08             	mov    0x8(%ebp),%eax
  802e57:	01 c2                	add    %eax,%edx
  802e59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e5c:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802e5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e62:	8b 40 0c             	mov    0xc(%eax),%eax
  802e65:	2b 45 08             	sub    0x8(%ebp),%eax
  802e68:	89 c2                	mov    %eax,%edx
  802e6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e6d:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802e70:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e73:	eb 3b                	jmp    802eb0 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802e75:	a1 40 51 80 00       	mov    0x805140,%eax
  802e7a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e7d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e81:	74 07                	je     802e8a <alloc_block_NF+0x5a5>
  802e83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e86:	8b 00                	mov    (%eax),%eax
  802e88:	eb 05                	jmp    802e8f <alloc_block_NF+0x5aa>
  802e8a:	b8 00 00 00 00       	mov    $0x0,%eax
  802e8f:	a3 40 51 80 00       	mov    %eax,0x805140
  802e94:	a1 40 51 80 00       	mov    0x805140,%eax
  802e99:	85 c0                	test   %eax,%eax
  802e9b:	0f 85 2e fe ff ff    	jne    802ccf <alloc_block_NF+0x3ea>
  802ea1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ea5:	0f 85 24 fe ff ff    	jne    802ccf <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802eab:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802eb0:	c9                   	leave  
  802eb1:	c3                   	ret    

00802eb2 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802eb2:	55                   	push   %ebp
  802eb3:	89 e5                	mov    %esp,%ebp
  802eb5:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802eb8:	a1 38 51 80 00       	mov    0x805138,%eax
  802ebd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802ec0:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802ec5:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802ec8:	a1 38 51 80 00       	mov    0x805138,%eax
  802ecd:	85 c0                	test   %eax,%eax
  802ecf:	74 14                	je     802ee5 <insert_sorted_with_merge_freeList+0x33>
  802ed1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed4:	8b 50 08             	mov    0x8(%eax),%edx
  802ed7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eda:	8b 40 08             	mov    0x8(%eax),%eax
  802edd:	39 c2                	cmp    %eax,%edx
  802edf:	0f 87 9b 01 00 00    	ja     803080 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802ee5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ee9:	75 17                	jne    802f02 <insert_sorted_with_merge_freeList+0x50>
  802eeb:	83 ec 04             	sub    $0x4,%esp
  802eee:	68 78 42 80 00       	push   $0x804278
  802ef3:	68 38 01 00 00       	push   $0x138
  802ef8:	68 9b 42 80 00       	push   $0x80429b
  802efd:	e8 97 d5 ff ff       	call   800499 <_panic>
  802f02:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802f08:	8b 45 08             	mov    0x8(%ebp),%eax
  802f0b:	89 10                	mov    %edx,(%eax)
  802f0d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f10:	8b 00                	mov    (%eax),%eax
  802f12:	85 c0                	test   %eax,%eax
  802f14:	74 0d                	je     802f23 <insert_sorted_with_merge_freeList+0x71>
  802f16:	a1 38 51 80 00       	mov    0x805138,%eax
  802f1b:	8b 55 08             	mov    0x8(%ebp),%edx
  802f1e:	89 50 04             	mov    %edx,0x4(%eax)
  802f21:	eb 08                	jmp    802f2b <insert_sorted_with_merge_freeList+0x79>
  802f23:	8b 45 08             	mov    0x8(%ebp),%eax
  802f26:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f2b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f2e:	a3 38 51 80 00       	mov    %eax,0x805138
  802f33:	8b 45 08             	mov    0x8(%ebp),%eax
  802f36:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f3d:	a1 44 51 80 00       	mov    0x805144,%eax
  802f42:	40                   	inc    %eax
  802f43:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802f48:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f4c:	0f 84 a8 06 00 00    	je     8035fa <insert_sorted_with_merge_freeList+0x748>
  802f52:	8b 45 08             	mov    0x8(%ebp),%eax
  802f55:	8b 50 08             	mov    0x8(%eax),%edx
  802f58:	8b 45 08             	mov    0x8(%ebp),%eax
  802f5b:	8b 40 0c             	mov    0xc(%eax),%eax
  802f5e:	01 c2                	add    %eax,%edx
  802f60:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f63:	8b 40 08             	mov    0x8(%eax),%eax
  802f66:	39 c2                	cmp    %eax,%edx
  802f68:	0f 85 8c 06 00 00    	jne    8035fa <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802f6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f71:	8b 50 0c             	mov    0xc(%eax),%edx
  802f74:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f77:	8b 40 0c             	mov    0xc(%eax),%eax
  802f7a:	01 c2                	add    %eax,%edx
  802f7c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f7f:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802f82:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f86:	75 17                	jne    802f9f <insert_sorted_with_merge_freeList+0xed>
  802f88:	83 ec 04             	sub    $0x4,%esp
  802f8b:	68 44 43 80 00       	push   $0x804344
  802f90:	68 3c 01 00 00       	push   $0x13c
  802f95:	68 9b 42 80 00       	push   $0x80429b
  802f9a:	e8 fa d4 ff ff       	call   800499 <_panic>
  802f9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fa2:	8b 00                	mov    (%eax),%eax
  802fa4:	85 c0                	test   %eax,%eax
  802fa6:	74 10                	je     802fb8 <insert_sorted_with_merge_freeList+0x106>
  802fa8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fab:	8b 00                	mov    (%eax),%eax
  802fad:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802fb0:	8b 52 04             	mov    0x4(%edx),%edx
  802fb3:	89 50 04             	mov    %edx,0x4(%eax)
  802fb6:	eb 0b                	jmp    802fc3 <insert_sorted_with_merge_freeList+0x111>
  802fb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fbb:	8b 40 04             	mov    0x4(%eax),%eax
  802fbe:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802fc3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fc6:	8b 40 04             	mov    0x4(%eax),%eax
  802fc9:	85 c0                	test   %eax,%eax
  802fcb:	74 0f                	je     802fdc <insert_sorted_with_merge_freeList+0x12a>
  802fcd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fd0:	8b 40 04             	mov    0x4(%eax),%eax
  802fd3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802fd6:	8b 12                	mov    (%edx),%edx
  802fd8:	89 10                	mov    %edx,(%eax)
  802fda:	eb 0a                	jmp    802fe6 <insert_sorted_with_merge_freeList+0x134>
  802fdc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fdf:	8b 00                	mov    (%eax),%eax
  802fe1:	a3 38 51 80 00       	mov    %eax,0x805138
  802fe6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fe9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ff2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ff9:	a1 44 51 80 00       	mov    0x805144,%eax
  802ffe:	48                   	dec    %eax
  802fff:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  803004:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803007:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  80300e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803011:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  803018:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80301c:	75 17                	jne    803035 <insert_sorted_with_merge_freeList+0x183>
  80301e:	83 ec 04             	sub    $0x4,%esp
  803021:	68 78 42 80 00       	push   $0x804278
  803026:	68 3f 01 00 00       	push   $0x13f
  80302b:	68 9b 42 80 00       	push   $0x80429b
  803030:	e8 64 d4 ff ff       	call   800499 <_panic>
  803035:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80303b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80303e:	89 10                	mov    %edx,(%eax)
  803040:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803043:	8b 00                	mov    (%eax),%eax
  803045:	85 c0                	test   %eax,%eax
  803047:	74 0d                	je     803056 <insert_sorted_with_merge_freeList+0x1a4>
  803049:	a1 48 51 80 00       	mov    0x805148,%eax
  80304e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803051:	89 50 04             	mov    %edx,0x4(%eax)
  803054:	eb 08                	jmp    80305e <insert_sorted_with_merge_freeList+0x1ac>
  803056:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803059:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80305e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803061:	a3 48 51 80 00       	mov    %eax,0x805148
  803066:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803069:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803070:	a1 54 51 80 00       	mov    0x805154,%eax
  803075:	40                   	inc    %eax
  803076:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80307b:	e9 7a 05 00 00       	jmp    8035fa <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  803080:	8b 45 08             	mov    0x8(%ebp),%eax
  803083:	8b 50 08             	mov    0x8(%eax),%edx
  803086:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803089:	8b 40 08             	mov    0x8(%eax),%eax
  80308c:	39 c2                	cmp    %eax,%edx
  80308e:	0f 82 14 01 00 00    	jb     8031a8 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  803094:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803097:	8b 50 08             	mov    0x8(%eax),%edx
  80309a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80309d:	8b 40 0c             	mov    0xc(%eax),%eax
  8030a0:	01 c2                	add    %eax,%edx
  8030a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a5:	8b 40 08             	mov    0x8(%eax),%eax
  8030a8:	39 c2                	cmp    %eax,%edx
  8030aa:	0f 85 90 00 00 00    	jne    803140 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  8030b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030b3:	8b 50 0c             	mov    0xc(%eax),%edx
  8030b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b9:	8b 40 0c             	mov    0xc(%eax),%eax
  8030bc:	01 c2                	add    %eax,%edx
  8030be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030c1:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  8030c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c7:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  8030ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8030d8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030dc:	75 17                	jne    8030f5 <insert_sorted_with_merge_freeList+0x243>
  8030de:	83 ec 04             	sub    $0x4,%esp
  8030e1:	68 78 42 80 00       	push   $0x804278
  8030e6:	68 49 01 00 00       	push   $0x149
  8030eb:	68 9b 42 80 00       	push   $0x80429b
  8030f0:	e8 a4 d3 ff ff       	call   800499 <_panic>
  8030f5:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8030fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8030fe:	89 10                	mov    %edx,(%eax)
  803100:	8b 45 08             	mov    0x8(%ebp),%eax
  803103:	8b 00                	mov    (%eax),%eax
  803105:	85 c0                	test   %eax,%eax
  803107:	74 0d                	je     803116 <insert_sorted_with_merge_freeList+0x264>
  803109:	a1 48 51 80 00       	mov    0x805148,%eax
  80310e:	8b 55 08             	mov    0x8(%ebp),%edx
  803111:	89 50 04             	mov    %edx,0x4(%eax)
  803114:	eb 08                	jmp    80311e <insert_sorted_with_merge_freeList+0x26c>
  803116:	8b 45 08             	mov    0x8(%ebp),%eax
  803119:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80311e:	8b 45 08             	mov    0x8(%ebp),%eax
  803121:	a3 48 51 80 00       	mov    %eax,0x805148
  803126:	8b 45 08             	mov    0x8(%ebp),%eax
  803129:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803130:	a1 54 51 80 00       	mov    0x805154,%eax
  803135:	40                   	inc    %eax
  803136:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80313b:	e9 bb 04 00 00       	jmp    8035fb <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  803140:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803144:	75 17                	jne    80315d <insert_sorted_with_merge_freeList+0x2ab>
  803146:	83 ec 04             	sub    $0x4,%esp
  803149:	68 ec 42 80 00       	push   $0x8042ec
  80314e:	68 4c 01 00 00       	push   $0x14c
  803153:	68 9b 42 80 00       	push   $0x80429b
  803158:	e8 3c d3 ff ff       	call   800499 <_panic>
  80315d:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803163:	8b 45 08             	mov    0x8(%ebp),%eax
  803166:	89 50 04             	mov    %edx,0x4(%eax)
  803169:	8b 45 08             	mov    0x8(%ebp),%eax
  80316c:	8b 40 04             	mov    0x4(%eax),%eax
  80316f:	85 c0                	test   %eax,%eax
  803171:	74 0c                	je     80317f <insert_sorted_with_merge_freeList+0x2cd>
  803173:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803178:	8b 55 08             	mov    0x8(%ebp),%edx
  80317b:	89 10                	mov    %edx,(%eax)
  80317d:	eb 08                	jmp    803187 <insert_sorted_with_merge_freeList+0x2d5>
  80317f:	8b 45 08             	mov    0x8(%ebp),%eax
  803182:	a3 38 51 80 00       	mov    %eax,0x805138
  803187:	8b 45 08             	mov    0x8(%ebp),%eax
  80318a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80318f:	8b 45 08             	mov    0x8(%ebp),%eax
  803192:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803198:	a1 44 51 80 00       	mov    0x805144,%eax
  80319d:	40                   	inc    %eax
  80319e:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8031a3:	e9 53 04 00 00       	jmp    8035fb <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8031a8:	a1 38 51 80 00       	mov    0x805138,%eax
  8031ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031b0:	e9 15 04 00 00       	jmp    8035ca <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  8031b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031b8:	8b 00                	mov    (%eax),%eax
  8031ba:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  8031bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c0:	8b 50 08             	mov    0x8(%eax),%edx
  8031c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031c6:	8b 40 08             	mov    0x8(%eax),%eax
  8031c9:	39 c2                	cmp    %eax,%edx
  8031cb:	0f 86 f1 03 00 00    	jbe    8035c2 <insert_sorted_with_merge_freeList+0x710>
  8031d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d4:	8b 50 08             	mov    0x8(%eax),%edx
  8031d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031da:	8b 40 08             	mov    0x8(%eax),%eax
  8031dd:	39 c2                	cmp    %eax,%edx
  8031df:	0f 83 dd 03 00 00    	jae    8035c2 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  8031e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031e8:	8b 50 08             	mov    0x8(%eax),%edx
  8031eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ee:	8b 40 0c             	mov    0xc(%eax),%eax
  8031f1:	01 c2                	add    %eax,%edx
  8031f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f6:	8b 40 08             	mov    0x8(%eax),%eax
  8031f9:	39 c2                	cmp    %eax,%edx
  8031fb:	0f 85 b9 01 00 00    	jne    8033ba <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803201:	8b 45 08             	mov    0x8(%ebp),%eax
  803204:	8b 50 08             	mov    0x8(%eax),%edx
  803207:	8b 45 08             	mov    0x8(%ebp),%eax
  80320a:	8b 40 0c             	mov    0xc(%eax),%eax
  80320d:	01 c2                	add    %eax,%edx
  80320f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803212:	8b 40 08             	mov    0x8(%eax),%eax
  803215:	39 c2                	cmp    %eax,%edx
  803217:	0f 85 0d 01 00 00    	jne    80332a <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  80321d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803220:	8b 50 0c             	mov    0xc(%eax),%edx
  803223:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803226:	8b 40 0c             	mov    0xc(%eax),%eax
  803229:	01 c2                	add    %eax,%edx
  80322b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80322e:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803231:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803235:	75 17                	jne    80324e <insert_sorted_with_merge_freeList+0x39c>
  803237:	83 ec 04             	sub    $0x4,%esp
  80323a:	68 44 43 80 00       	push   $0x804344
  80323f:	68 5c 01 00 00       	push   $0x15c
  803244:	68 9b 42 80 00       	push   $0x80429b
  803249:	e8 4b d2 ff ff       	call   800499 <_panic>
  80324e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803251:	8b 00                	mov    (%eax),%eax
  803253:	85 c0                	test   %eax,%eax
  803255:	74 10                	je     803267 <insert_sorted_with_merge_freeList+0x3b5>
  803257:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80325a:	8b 00                	mov    (%eax),%eax
  80325c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80325f:	8b 52 04             	mov    0x4(%edx),%edx
  803262:	89 50 04             	mov    %edx,0x4(%eax)
  803265:	eb 0b                	jmp    803272 <insert_sorted_with_merge_freeList+0x3c0>
  803267:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80326a:	8b 40 04             	mov    0x4(%eax),%eax
  80326d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803272:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803275:	8b 40 04             	mov    0x4(%eax),%eax
  803278:	85 c0                	test   %eax,%eax
  80327a:	74 0f                	je     80328b <insert_sorted_with_merge_freeList+0x3d9>
  80327c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80327f:	8b 40 04             	mov    0x4(%eax),%eax
  803282:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803285:	8b 12                	mov    (%edx),%edx
  803287:	89 10                	mov    %edx,(%eax)
  803289:	eb 0a                	jmp    803295 <insert_sorted_with_merge_freeList+0x3e3>
  80328b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80328e:	8b 00                	mov    (%eax),%eax
  803290:	a3 38 51 80 00       	mov    %eax,0x805138
  803295:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803298:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80329e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032a1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032a8:	a1 44 51 80 00       	mov    0x805144,%eax
  8032ad:	48                   	dec    %eax
  8032ae:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  8032b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032b6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  8032bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032c0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8032c7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8032cb:	75 17                	jne    8032e4 <insert_sorted_with_merge_freeList+0x432>
  8032cd:	83 ec 04             	sub    $0x4,%esp
  8032d0:	68 78 42 80 00       	push   $0x804278
  8032d5:	68 5f 01 00 00       	push   $0x15f
  8032da:	68 9b 42 80 00       	push   $0x80429b
  8032df:	e8 b5 d1 ff ff       	call   800499 <_panic>
  8032e4:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8032ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032ed:	89 10                	mov    %edx,(%eax)
  8032ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032f2:	8b 00                	mov    (%eax),%eax
  8032f4:	85 c0                	test   %eax,%eax
  8032f6:	74 0d                	je     803305 <insert_sorted_with_merge_freeList+0x453>
  8032f8:	a1 48 51 80 00       	mov    0x805148,%eax
  8032fd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803300:	89 50 04             	mov    %edx,0x4(%eax)
  803303:	eb 08                	jmp    80330d <insert_sorted_with_merge_freeList+0x45b>
  803305:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803308:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80330d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803310:	a3 48 51 80 00       	mov    %eax,0x805148
  803315:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803318:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80331f:	a1 54 51 80 00       	mov    0x805154,%eax
  803324:	40                   	inc    %eax
  803325:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  80332a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80332d:	8b 50 0c             	mov    0xc(%eax),%edx
  803330:	8b 45 08             	mov    0x8(%ebp),%eax
  803333:	8b 40 0c             	mov    0xc(%eax),%eax
  803336:	01 c2                	add    %eax,%edx
  803338:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80333b:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  80333e:	8b 45 08             	mov    0x8(%ebp),%eax
  803341:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803348:	8b 45 08             	mov    0x8(%ebp),%eax
  80334b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803352:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803356:	75 17                	jne    80336f <insert_sorted_with_merge_freeList+0x4bd>
  803358:	83 ec 04             	sub    $0x4,%esp
  80335b:	68 78 42 80 00       	push   $0x804278
  803360:	68 64 01 00 00       	push   $0x164
  803365:	68 9b 42 80 00       	push   $0x80429b
  80336a:	e8 2a d1 ff ff       	call   800499 <_panic>
  80336f:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803375:	8b 45 08             	mov    0x8(%ebp),%eax
  803378:	89 10                	mov    %edx,(%eax)
  80337a:	8b 45 08             	mov    0x8(%ebp),%eax
  80337d:	8b 00                	mov    (%eax),%eax
  80337f:	85 c0                	test   %eax,%eax
  803381:	74 0d                	je     803390 <insert_sorted_with_merge_freeList+0x4de>
  803383:	a1 48 51 80 00       	mov    0x805148,%eax
  803388:	8b 55 08             	mov    0x8(%ebp),%edx
  80338b:	89 50 04             	mov    %edx,0x4(%eax)
  80338e:	eb 08                	jmp    803398 <insert_sorted_with_merge_freeList+0x4e6>
  803390:	8b 45 08             	mov    0x8(%ebp),%eax
  803393:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803398:	8b 45 08             	mov    0x8(%ebp),%eax
  80339b:	a3 48 51 80 00       	mov    %eax,0x805148
  8033a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033aa:	a1 54 51 80 00       	mov    0x805154,%eax
  8033af:	40                   	inc    %eax
  8033b0:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8033b5:	e9 41 02 00 00       	jmp    8035fb <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8033ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8033bd:	8b 50 08             	mov    0x8(%eax),%edx
  8033c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c3:	8b 40 0c             	mov    0xc(%eax),%eax
  8033c6:	01 c2                	add    %eax,%edx
  8033c8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033cb:	8b 40 08             	mov    0x8(%eax),%eax
  8033ce:	39 c2                	cmp    %eax,%edx
  8033d0:	0f 85 7c 01 00 00    	jne    803552 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  8033d6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8033da:	74 06                	je     8033e2 <insert_sorted_with_merge_freeList+0x530>
  8033dc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033e0:	75 17                	jne    8033f9 <insert_sorted_with_merge_freeList+0x547>
  8033e2:	83 ec 04             	sub    $0x4,%esp
  8033e5:	68 b4 42 80 00       	push   $0x8042b4
  8033ea:	68 69 01 00 00       	push   $0x169
  8033ef:	68 9b 42 80 00       	push   $0x80429b
  8033f4:	e8 a0 d0 ff ff       	call   800499 <_panic>
  8033f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033fc:	8b 50 04             	mov    0x4(%eax),%edx
  8033ff:	8b 45 08             	mov    0x8(%ebp),%eax
  803402:	89 50 04             	mov    %edx,0x4(%eax)
  803405:	8b 45 08             	mov    0x8(%ebp),%eax
  803408:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80340b:	89 10                	mov    %edx,(%eax)
  80340d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803410:	8b 40 04             	mov    0x4(%eax),%eax
  803413:	85 c0                	test   %eax,%eax
  803415:	74 0d                	je     803424 <insert_sorted_with_merge_freeList+0x572>
  803417:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80341a:	8b 40 04             	mov    0x4(%eax),%eax
  80341d:	8b 55 08             	mov    0x8(%ebp),%edx
  803420:	89 10                	mov    %edx,(%eax)
  803422:	eb 08                	jmp    80342c <insert_sorted_with_merge_freeList+0x57a>
  803424:	8b 45 08             	mov    0x8(%ebp),%eax
  803427:	a3 38 51 80 00       	mov    %eax,0x805138
  80342c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80342f:	8b 55 08             	mov    0x8(%ebp),%edx
  803432:	89 50 04             	mov    %edx,0x4(%eax)
  803435:	a1 44 51 80 00       	mov    0x805144,%eax
  80343a:	40                   	inc    %eax
  80343b:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803440:	8b 45 08             	mov    0x8(%ebp),%eax
  803443:	8b 50 0c             	mov    0xc(%eax),%edx
  803446:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803449:	8b 40 0c             	mov    0xc(%eax),%eax
  80344c:	01 c2                	add    %eax,%edx
  80344e:	8b 45 08             	mov    0x8(%ebp),%eax
  803451:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803454:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803458:	75 17                	jne    803471 <insert_sorted_with_merge_freeList+0x5bf>
  80345a:	83 ec 04             	sub    $0x4,%esp
  80345d:	68 44 43 80 00       	push   $0x804344
  803462:	68 6b 01 00 00       	push   $0x16b
  803467:	68 9b 42 80 00       	push   $0x80429b
  80346c:	e8 28 d0 ff ff       	call   800499 <_panic>
  803471:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803474:	8b 00                	mov    (%eax),%eax
  803476:	85 c0                	test   %eax,%eax
  803478:	74 10                	je     80348a <insert_sorted_with_merge_freeList+0x5d8>
  80347a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80347d:	8b 00                	mov    (%eax),%eax
  80347f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803482:	8b 52 04             	mov    0x4(%edx),%edx
  803485:	89 50 04             	mov    %edx,0x4(%eax)
  803488:	eb 0b                	jmp    803495 <insert_sorted_with_merge_freeList+0x5e3>
  80348a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80348d:	8b 40 04             	mov    0x4(%eax),%eax
  803490:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803495:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803498:	8b 40 04             	mov    0x4(%eax),%eax
  80349b:	85 c0                	test   %eax,%eax
  80349d:	74 0f                	je     8034ae <insert_sorted_with_merge_freeList+0x5fc>
  80349f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034a2:	8b 40 04             	mov    0x4(%eax),%eax
  8034a5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8034a8:	8b 12                	mov    (%edx),%edx
  8034aa:	89 10                	mov    %edx,(%eax)
  8034ac:	eb 0a                	jmp    8034b8 <insert_sorted_with_merge_freeList+0x606>
  8034ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034b1:	8b 00                	mov    (%eax),%eax
  8034b3:	a3 38 51 80 00       	mov    %eax,0x805138
  8034b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034bb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034c4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034cb:	a1 44 51 80 00       	mov    0x805144,%eax
  8034d0:	48                   	dec    %eax
  8034d1:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  8034d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034d9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  8034e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034e3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8034ea:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8034ee:	75 17                	jne    803507 <insert_sorted_with_merge_freeList+0x655>
  8034f0:	83 ec 04             	sub    $0x4,%esp
  8034f3:	68 78 42 80 00       	push   $0x804278
  8034f8:	68 6e 01 00 00       	push   $0x16e
  8034fd:	68 9b 42 80 00       	push   $0x80429b
  803502:	e8 92 cf ff ff       	call   800499 <_panic>
  803507:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80350d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803510:	89 10                	mov    %edx,(%eax)
  803512:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803515:	8b 00                	mov    (%eax),%eax
  803517:	85 c0                	test   %eax,%eax
  803519:	74 0d                	je     803528 <insert_sorted_with_merge_freeList+0x676>
  80351b:	a1 48 51 80 00       	mov    0x805148,%eax
  803520:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803523:	89 50 04             	mov    %edx,0x4(%eax)
  803526:	eb 08                	jmp    803530 <insert_sorted_with_merge_freeList+0x67e>
  803528:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80352b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803530:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803533:	a3 48 51 80 00       	mov    %eax,0x805148
  803538:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80353b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803542:	a1 54 51 80 00       	mov    0x805154,%eax
  803547:	40                   	inc    %eax
  803548:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  80354d:	e9 a9 00 00 00       	jmp    8035fb <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803552:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803556:	74 06                	je     80355e <insert_sorted_with_merge_freeList+0x6ac>
  803558:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80355c:	75 17                	jne    803575 <insert_sorted_with_merge_freeList+0x6c3>
  80355e:	83 ec 04             	sub    $0x4,%esp
  803561:	68 10 43 80 00       	push   $0x804310
  803566:	68 73 01 00 00       	push   $0x173
  80356b:	68 9b 42 80 00       	push   $0x80429b
  803570:	e8 24 cf ff ff       	call   800499 <_panic>
  803575:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803578:	8b 10                	mov    (%eax),%edx
  80357a:	8b 45 08             	mov    0x8(%ebp),%eax
  80357d:	89 10                	mov    %edx,(%eax)
  80357f:	8b 45 08             	mov    0x8(%ebp),%eax
  803582:	8b 00                	mov    (%eax),%eax
  803584:	85 c0                	test   %eax,%eax
  803586:	74 0b                	je     803593 <insert_sorted_with_merge_freeList+0x6e1>
  803588:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80358b:	8b 00                	mov    (%eax),%eax
  80358d:	8b 55 08             	mov    0x8(%ebp),%edx
  803590:	89 50 04             	mov    %edx,0x4(%eax)
  803593:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803596:	8b 55 08             	mov    0x8(%ebp),%edx
  803599:	89 10                	mov    %edx,(%eax)
  80359b:	8b 45 08             	mov    0x8(%ebp),%eax
  80359e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8035a1:	89 50 04             	mov    %edx,0x4(%eax)
  8035a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8035a7:	8b 00                	mov    (%eax),%eax
  8035a9:	85 c0                	test   %eax,%eax
  8035ab:	75 08                	jne    8035b5 <insert_sorted_with_merge_freeList+0x703>
  8035ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8035b0:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8035b5:	a1 44 51 80 00       	mov    0x805144,%eax
  8035ba:	40                   	inc    %eax
  8035bb:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  8035c0:	eb 39                	jmp    8035fb <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8035c2:	a1 40 51 80 00       	mov    0x805140,%eax
  8035c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8035ca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035ce:	74 07                	je     8035d7 <insert_sorted_with_merge_freeList+0x725>
  8035d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035d3:	8b 00                	mov    (%eax),%eax
  8035d5:	eb 05                	jmp    8035dc <insert_sorted_with_merge_freeList+0x72a>
  8035d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8035dc:	a3 40 51 80 00       	mov    %eax,0x805140
  8035e1:	a1 40 51 80 00       	mov    0x805140,%eax
  8035e6:	85 c0                	test   %eax,%eax
  8035e8:	0f 85 c7 fb ff ff    	jne    8031b5 <insert_sorted_with_merge_freeList+0x303>
  8035ee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035f2:	0f 85 bd fb ff ff    	jne    8031b5 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8035f8:	eb 01                	jmp    8035fb <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8035fa:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8035fb:	90                   	nop
  8035fc:	c9                   	leave  
  8035fd:	c3                   	ret    
  8035fe:	66 90                	xchg   %ax,%ax

00803600 <__udivdi3>:
  803600:	55                   	push   %ebp
  803601:	57                   	push   %edi
  803602:	56                   	push   %esi
  803603:	53                   	push   %ebx
  803604:	83 ec 1c             	sub    $0x1c,%esp
  803607:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80360b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80360f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803613:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803617:	89 ca                	mov    %ecx,%edx
  803619:	89 f8                	mov    %edi,%eax
  80361b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80361f:	85 f6                	test   %esi,%esi
  803621:	75 2d                	jne    803650 <__udivdi3+0x50>
  803623:	39 cf                	cmp    %ecx,%edi
  803625:	77 65                	ja     80368c <__udivdi3+0x8c>
  803627:	89 fd                	mov    %edi,%ebp
  803629:	85 ff                	test   %edi,%edi
  80362b:	75 0b                	jne    803638 <__udivdi3+0x38>
  80362d:	b8 01 00 00 00       	mov    $0x1,%eax
  803632:	31 d2                	xor    %edx,%edx
  803634:	f7 f7                	div    %edi
  803636:	89 c5                	mov    %eax,%ebp
  803638:	31 d2                	xor    %edx,%edx
  80363a:	89 c8                	mov    %ecx,%eax
  80363c:	f7 f5                	div    %ebp
  80363e:	89 c1                	mov    %eax,%ecx
  803640:	89 d8                	mov    %ebx,%eax
  803642:	f7 f5                	div    %ebp
  803644:	89 cf                	mov    %ecx,%edi
  803646:	89 fa                	mov    %edi,%edx
  803648:	83 c4 1c             	add    $0x1c,%esp
  80364b:	5b                   	pop    %ebx
  80364c:	5e                   	pop    %esi
  80364d:	5f                   	pop    %edi
  80364e:	5d                   	pop    %ebp
  80364f:	c3                   	ret    
  803650:	39 ce                	cmp    %ecx,%esi
  803652:	77 28                	ja     80367c <__udivdi3+0x7c>
  803654:	0f bd fe             	bsr    %esi,%edi
  803657:	83 f7 1f             	xor    $0x1f,%edi
  80365a:	75 40                	jne    80369c <__udivdi3+0x9c>
  80365c:	39 ce                	cmp    %ecx,%esi
  80365e:	72 0a                	jb     80366a <__udivdi3+0x6a>
  803660:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803664:	0f 87 9e 00 00 00    	ja     803708 <__udivdi3+0x108>
  80366a:	b8 01 00 00 00       	mov    $0x1,%eax
  80366f:	89 fa                	mov    %edi,%edx
  803671:	83 c4 1c             	add    $0x1c,%esp
  803674:	5b                   	pop    %ebx
  803675:	5e                   	pop    %esi
  803676:	5f                   	pop    %edi
  803677:	5d                   	pop    %ebp
  803678:	c3                   	ret    
  803679:	8d 76 00             	lea    0x0(%esi),%esi
  80367c:	31 ff                	xor    %edi,%edi
  80367e:	31 c0                	xor    %eax,%eax
  803680:	89 fa                	mov    %edi,%edx
  803682:	83 c4 1c             	add    $0x1c,%esp
  803685:	5b                   	pop    %ebx
  803686:	5e                   	pop    %esi
  803687:	5f                   	pop    %edi
  803688:	5d                   	pop    %ebp
  803689:	c3                   	ret    
  80368a:	66 90                	xchg   %ax,%ax
  80368c:	89 d8                	mov    %ebx,%eax
  80368e:	f7 f7                	div    %edi
  803690:	31 ff                	xor    %edi,%edi
  803692:	89 fa                	mov    %edi,%edx
  803694:	83 c4 1c             	add    $0x1c,%esp
  803697:	5b                   	pop    %ebx
  803698:	5e                   	pop    %esi
  803699:	5f                   	pop    %edi
  80369a:	5d                   	pop    %ebp
  80369b:	c3                   	ret    
  80369c:	bd 20 00 00 00       	mov    $0x20,%ebp
  8036a1:	89 eb                	mov    %ebp,%ebx
  8036a3:	29 fb                	sub    %edi,%ebx
  8036a5:	89 f9                	mov    %edi,%ecx
  8036a7:	d3 e6                	shl    %cl,%esi
  8036a9:	89 c5                	mov    %eax,%ebp
  8036ab:	88 d9                	mov    %bl,%cl
  8036ad:	d3 ed                	shr    %cl,%ebp
  8036af:	89 e9                	mov    %ebp,%ecx
  8036b1:	09 f1                	or     %esi,%ecx
  8036b3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8036b7:	89 f9                	mov    %edi,%ecx
  8036b9:	d3 e0                	shl    %cl,%eax
  8036bb:	89 c5                	mov    %eax,%ebp
  8036bd:	89 d6                	mov    %edx,%esi
  8036bf:	88 d9                	mov    %bl,%cl
  8036c1:	d3 ee                	shr    %cl,%esi
  8036c3:	89 f9                	mov    %edi,%ecx
  8036c5:	d3 e2                	shl    %cl,%edx
  8036c7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8036cb:	88 d9                	mov    %bl,%cl
  8036cd:	d3 e8                	shr    %cl,%eax
  8036cf:	09 c2                	or     %eax,%edx
  8036d1:	89 d0                	mov    %edx,%eax
  8036d3:	89 f2                	mov    %esi,%edx
  8036d5:	f7 74 24 0c          	divl   0xc(%esp)
  8036d9:	89 d6                	mov    %edx,%esi
  8036db:	89 c3                	mov    %eax,%ebx
  8036dd:	f7 e5                	mul    %ebp
  8036df:	39 d6                	cmp    %edx,%esi
  8036e1:	72 19                	jb     8036fc <__udivdi3+0xfc>
  8036e3:	74 0b                	je     8036f0 <__udivdi3+0xf0>
  8036e5:	89 d8                	mov    %ebx,%eax
  8036e7:	31 ff                	xor    %edi,%edi
  8036e9:	e9 58 ff ff ff       	jmp    803646 <__udivdi3+0x46>
  8036ee:	66 90                	xchg   %ax,%ax
  8036f0:	8b 54 24 08          	mov    0x8(%esp),%edx
  8036f4:	89 f9                	mov    %edi,%ecx
  8036f6:	d3 e2                	shl    %cl,%edx
  8036f8:	39 c2                	cmp    %eax,%edx
  8036fa:	73 e9                	jae    8036e5 <__udivdi3+0xe5>
  8036fc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8036ff:	31 ff                	xor    %edi,%edi
  803701:	e9 40 ff ff ff       	jmp    803646 <__udivdi3+0x46>
  803706:	66 90                	xchg   %ax,%ax
  803708:	31 c0                	xor    %eax,%eax
  80370a:	e9 37 ff ff ff       	jmp    803646 <__udivdi3+0x46>
  80370f:	90                   	nop

00803710 <__umoddi3>:
  803710:	55                   	push   %ebp
  803711:	57                   	push   %edi
  803712:	56                   	push   %esi
  803713:	53                   	push   %ebx
  803714:	83 ec 1c             	sub    $0x1c,%esp
  803717:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80371b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80371f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803723:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803727:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80372b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80372f:	89 f3                	mov    %esi,%ebx
  803731:	89 fa                	mov    %edi,%edx
  803733:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803737:	89 34 24             	mov    %esi,(%esp)
  80373a:	85 c0                	test   %eax,%eax
  80373c:	75 1a                	jne    803758 <__umoddi3+0x48>
  80373e:	39 f7                	cmp    %esi,%edi
  803740:	0f 86 a2 00 00 00    	jbe    8037e8 <__umoddi3+0xd8>
  803746:	89 c8                	mov    %ecx,%eax
  803748:	89 f2                	mov    %esi,%edx
  80374a:	f7 f7                	div    %edi
  80374c:	89 d0                	mov    %edx,%eax
  80374e:	31 d2                	xor    %edx,%edx
  803750:	83 c4 1c             	add    $0x1c,%esp
  803753:	5b                   	pop    %ebx
  803754:	5e                   	pop    %esi
  803755:	5f                   	pop    %edi
  803756:	5d                   	pop    %ebp
  803757:	c3                   	ret    
  803758:	39 f0                	cmp    %esi,%eax
  80375a:	0f 87 ac 00 00 00    	ja     80380c <__umoddi3+0xfc>
  803760:	0f bd e8             	bsr    %eax,%ebp
  803763:	83 f5 1f             	xor    $0x1f,%ebp
  803766:	0f 84 ac 00 00 00    	je     803818 <__umoddi3+0x108>
  80376c:	bf 20 00 00 00       	mov    $0x20,%edi
  803771:	29 ef                	sub    %ebp,%edi
  803773:	89 fe                	mov    %edi,%esi
  803775:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803779:	89 e9                	mov    %ebp,%ecx
  80377b:	d3 e0                	shl    %cl,%eax
  80377d:	89 d7                	mov    %edx,%edi
  80377f:	89 f1                	mov    %esi,%ecx
  803781:	d3 ef                	shr    %cl,%edi
  803783:	09 c7                	or     %eax,%edi
  803785:	89 e9                	mov    %ebp,%ecx
  803787:	d3 e2                	shl    %cl,%edx
  803789:	89 14 24             	mov    %edx,(%esp)
  80378c:	89 d8                	mov    %ebx,%eax
  80378e:	d3 e0                	shl    %cl,%eax
  803790:	89 c2                	mov    %eax,%edx
  803792:	8b 44 24 08          	mov    0x8(%esp),%eax
  803796:	d3 e0                	shl    %cl,%eax
  803798:	89 44 24 04          	mov    %eax,0x4(%esp)
  80379c:	8b 44 24 08          	mov    0x8(%esp),%eax
  8037a0:	89 f1                	mov    %esi,%ecx
  8037a2:	d3 e8                	shr    %cl,%eax
  8037a4:	09 d0                	or     %edx,%eax
  8037a6:	d3 eb                	shr    %cl,%ebx
  8037a8:	89 da                	mov    %ebx,%edx
  8037aa:	f7 f7                	div    %edi
  8037ac:	89 d3                	mov    %edx,%ebx
  8037ae:	f7 24 24             	mull   (%esp)
  8037b1:	89 c6                	mov    %eax,%esi
  8037b3:	89 d1                	mov    %edx,%ecx
  8037b5:	39 d3                	cmp    %edx,%ebx
  8037b7:	0f 82 87 00 00 00    	jb     803844 <__umoddi3+0x134>
  8037bd:	0f 84 91 00 00 00    	je     803854 <__umoddi3+0x144>
  8037c3:	8b 54 24 04          	mov    0x4(%esp),%edx
  8037c7:	29 f2                	sub    %esi,%edx
  8037c9:	19 cb                	sbb    %ecx,%ebx
  8037cb:	89 d8                	mov    %ebx,%eax
  8037cd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8037d1:	d3 e0                	shl    %cl,%eax
  8037d3:	89 e9                	mov    %ebp,%ecx
  8037d5:	d3 ea                	shr    %cl,%edx
  8037d7:	09 d0                	or     %edx,%eax
  8037d9:	89 e9                	mov    %ebp,%ecx
  8037db:	d3 eb                	shr    %cl,%ebx
  8037dd:	89 da                	mov    %ebx,%edx
  8037df:	83 c4 1c             	add    $0x1c,%esp
  8037e2:	5b                   	pop    %ebx
  8037e3:	5e                   	pop    %esi
  8037e4:	5f                   	pop    %edi
  8037e5:	5d                   	pop    %ebp
  8037e6:	c3                   	ret    
  8037e7:	90                   	nop
  8037e8:	89 fd                	mov    %edi,%ebp
  8037ea:	85 ff                	test   %edi,%edi
  8037ec:	75 0b                	jne    8037f9 <__umoddi3+0xe9>
  8037ee:	b8 01 00 00 00       	mov    $0x1,%eax
  8037f3:	31 d2                	xor    %edx,%edx
  8037f5:	f7 f7                	div    %edi
  8037f7:	89 c5                	mov    %eax,%ebp
  8037f9:	89 f0                	mov    %esi,%eax
  8037fb:	31 d2                	xor    %edx,%edx
  8037fd:	f7 f5                	div    %ebp
  8037ff:	89 c8                	mov    %ecx,%eax
  803801:	f7 f5                	div    %ebp
  803803:	89 d0                	mov    %edx,%eax
  803805:	e9 44 ff ff ff       	jmp    80374e <__umoddi3+0x3e>
  80380a:	66 90                	xchg   %ax,%ax
  80380c:	89 c8                	mov    %ecx,%eax
  80380e:	89 f2                	mov    %esi,%edx
  803810:	83 c4 1c             	add    $0x1c,%esp
  803813:	5b                   	pop    %ebx
  803814:	5e                   	pop    %esi
  803815:	5f                   	pop    %edi
  803816:	5d                   	pop    %ebp
  803817:	c3                   	ret    
  803818:	3b 04 24             	cmp    (%esp),%eax
  80381b:	72 06                	jb     803823 <__umoddi3+0x113>
  80381d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803821:	77 0f                	ja     803832 <__umoddi3+0x122>
  803823:	89 f2                	mov    %esi,%edx
  803825:	29 f9                	sub    %edi,%ecx
  803827:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80382b:	89 14 24             	mov    %edx,(%esp)
  80382e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803832:	8b 44 24 04          	mov    0x4(%esp),%eax
  803836:	8b 14 24             	mov    (%esp),%edx
  803839:	83 c4 1c             	add    $0x1c,%esp
  80383c:	5b                   	pop    %ebx
  80383d:	5e                   	pop    %esi
  80383e:	5f                   	pop    %edi
  80383f:	5d                   	pop    %ebp
  803840:	c3                   	ret    
  803841:	8d 76 00             	lea    0x0(%esi),%esi
  803844:	2b 04 24             	sub    (%esp),%eax
  803847:	19 fa                	sbb    %edi,%edx
  803849:	89 d1                	mov    %edx,%ecx
  80384b:	89 c6                	mov    %eax,%esi
  80384d:	e9 71 ff ff ff       	jmp    8037c3 <__umoddi3+0xb3>
  803852:	66 90                	xchg   %ax,%ax
  803854:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803858:	72 ea                	jb     803844 <__umoddi3+0x134>
  80385a:	89 d9                	mov    %ebx,%ecx
  80385c:	e9 62 ff ff ff       	jmp    8037c3 <__umoddi3+0xb3>
