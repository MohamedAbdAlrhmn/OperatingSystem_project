
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
  80008d:	68 a0 37 80 00       	push   $0x8037a0
  800092:	6a 12                	push   $0x12
  800094:	68 bc 37 80 00       	push   $0x8037bc
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
  8000ae:	68 d4 37 80 00       	push   $0x8037d4
  8000b3:	e8 95 06 00 00       	call   80074d <cprintf>
  8000b8:	83 c4 10             	add    $0x10,%esp
	{
		int freeFrames = sys_calculate_free_frames() ;
  8000bb:	e8 9d 18 00 00       	call   80195d <sys_calculate_free_frames>
  8000c0:	89 45 e8             	mov    %eax,-0x18(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8000c3:	83 ec 04             	sub    $0x4,%esp
  8000c6:	6a 01                	push   $0x1
  8000c8:	68 00 10 00 00       	push   $0x1000
  8000cd:	68 0b 38 80 00       	push   $0x80380b
  8000d2:	e8 46 16 00 00       	call   80171d <smalloc>
  8000d7:	83 c4 10             	add    $0x10,%esp
  8000da:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (x != (uint32*)USER_HEAP_START) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  8000dd:	81 7d e4 00 00 00 80 	cmpl   $0x80000000,-0x1c(%ebp)
  8000e4:	74 14                	je     8000fa <_main+0xc2>
  8000e6:	83 ec 04             	sub    $0x4,%esp
  8000e9:	68 10 38 80 00       	push   $0x803810
  8000ee:	6a 1e                	push   $0x1e
  8000f0:	68 bc 37 80 00       	push   $0x8037bc
  8000f5:	e8 9f 03 00 00       	call   800499 <_panic>
		expected = 1+1+2 ;
  8000fa:	c7 45 e0 04 00 00 00 	movl   $0x4,-0x20(%ebp)
		if ((freeFrames - sys_calculate_free_frames()) !=  expected) panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);
  800101:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800104:	e8 54 18 00 00       	call   80195d <sys_calculate_free_frames>
  800109:	29 c3                	sub    %eax,%ebx
  80010b:	89 d8                	mov    %ebx,%eax
  80010d:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800110:	74 24                	je     800136 <_main+0xfe>
  800112:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800115:	e8 43 18 00 00       	call   80195d <sys_calculate_free_frames>
  80011a:	29 c3                	sub    %eax,%ebx
  80011c:	89 d8                	mov    %ebx,%eax
  80011e:	83 ec 0c             	sub    $0xc,%esp
  800121:	ff 75 e0             	pushl  -0x20(%ebp)
  800124:	50                   	push   %eax
  800125:	68 7c 38 80 00       	push   $0x80387c
  80012a:	6a 20                	push   $0x20
  80012c:	68 bc 37 80 00       	push   $0x8037bc
  800131:	e8 63 03 00 00       	call   800499 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800136:	e8 22 18 00 00       	call   80195d <sys_calculate_free_frames>
  80013b:	89 45 e8             	mov    %eax,-0x18(%ebp)
		z = smalloc("z", PAGE_SIZE + 4, 1);
  80013e:	83 ec 04             	sub    $0x4,%esp
  800141:	6a 01                	push   $0x1
  800143:	68 04 10 00 00       	push   $0x1004
  800148:	68 14 39 80 00       	push   $0x803914
  80014d:	e8 cb 15 00 00       	call   80171d <smalloc>
  800152:	83 c4 10             	add    $0x10,%esp
  800155:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (z != (uint32*)(USER_HEAP_START + 1 * PAGE_SIZE)) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  800158:	81 7d dc 00 10 00 80 	cmpl   $0x80001000,-0x24(%ebp)
  80015f:	74 14                	je     800175 <_main+0x13d>
  800161:	83 ec 04             	sub    $0x4,%esp
  800164:	68 10 38 80 00       	push   $0x803810
  800169:	6a 24                	push   $0x24
  80016b:	68 bc 37 80 00       	push   $0x8037bc
  800170:	e8 24 03 00 00       	call   800499 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  2+0+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800175:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800178:	e8 e0 17 00 00       	call   80195d <sys_calculate_free_frames>
  80017d:	29 c3                	sub    %eax,%ebx
  80017f:	89 d8                	mov    %ebx,%eax
  800181:	83 f8 04             	cmp    $0x4,%eax
  800184:	74 14                	je     80019a <_main+0x162>
  800186:	83 ec 04             	sub    $0x4,%esp
  800189:	68 18 39 80 00       	push   $0x803918
  80018e:	6a 25                	push   $0x25
  800190:	68 bc 37 80 00       	push   $0x8037bc
  800195:	e8 ff 02 00 00       	call   800499 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  80019a:	e8 be 17 00 00       	call   80195d <sys_calculate_free_frames>
  80019f:	89 45 e8             	mov    %eax,-0x18(%ebp)
		y = smalloc("y", 4, 1);
  8001a2:	83 ec 04             	sub    $0x4,%esp
  8001a5:	6a 01                	push   $0x1
  8001a7:	6a 04                	push   $0x4
  8001a9:	68 96 39 80 00       	push   $0x803996
  8001ae:	e8 6a 15 00 00       	call   80171d <smalloc>
  8001b3:	83 c4 10             	add    $0x10,%esp
  8001b6:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if (y != (uint32*)(USER_HEAP_START + 3 * PAGE_SIZE)) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  8001b9:	81 7d d8 00 30 00 80 	cmpl   $0x80003000,-0x28(%ebp)
  8001c0:	74 14                	je     8001d6 <_main+0x19e>
  8001c2:	83 ec 04             	sub    $0x4,%esp
  8001c5:	68 10 38 80 00       	push   $0x803810
  8001ca:	6a 29                	push   $0x29
  8001cc:	68 bc 37 80 00       	push   $0x8037bc
  8001d1:	e8 c3 02 00 00       	call   800499 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  1+0+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  8001d6:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8001d9:	e8 7f 17 00 00       	call   80195d <sys_calculate_free_frames>
  8001de:	29 c3                	sub    %eax,%ebx
  8001e0:	89 d8                	mov    %ebx,%eax
  8001e2:	83 f8 03             	cmp    $0x3,%eax
  8001e5:	74 14                	je     8001fb <_main+0x1c3>
  8001e7:	83 ec 04             	sub    $0x4,%esp
  8001ea:	68 18 39 80 00       	push   $0x803918
  8001ef:	6a 2a                	push   $0x2a
  8001f1:	68 bc 37 80 00       	push   $0x8037bc
  8001f6:	e8 9e 02 00 00       	call   800499 <_panic>
	}
	cprintf("Step A is completed successfully!!\n\n\n");
  8001fb:	83 ec 0c             	sub    $0xc,%esp
  8001fe:	68 98 39 80 00       	push   $0x803998
  800203:	e8 45 05 00 00       	call   80074d <cprintf>
  800208:	83 c4 10             	add    $0x10,%esp


	cprintf("STEP B: checking reading & writing... \n");
  80020b:	83 ec 0c             	sub    $0xc,%esp
  80020e:	68 c0 39 80 00       	push   $0x8039c0
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
  800291:	68 e8 39 80 00       	push   $0x8039e8
  800296:	6a 3e                	push   $0x3e
  800298:	68 bc 37 80 00       	push   $0x8037bc
  80029d:	e8 f7 01 00 00       	call   800499 <_panic>
		if( x[PAGE_SIZE/4 - 1] !=  -1)  	panic("Reading/Writing of shared object is failed");
  8002a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002a5:	05 fc 0f 00 00       	add    $0xffc,%eax
  8002aa:	8b 00                	mov    (%eax),%eax
  8002ac:	83 f8 ff             	cmp    $0xffffffff,%eax
  8002af:	74 14                	je     8002c5 <_main+0x28d>
  8002b1:	83 ec 04             	sub    $0x4,%esp
  8002b4:	68 e8 39 80 00       	push   $0x8039e8
  8002b9:	6a 3f                	push   $0x3f
  8002bb:	68 bc 37 80 00       	push   $0x8037bc
  8002c0:	e8 d4 01 00 00       	call   800499 <_panic>

		if( y[0] !=  -1)  					panic("Reading/Writing of shared object is failed");
  8002c5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8002c8:	8b 00                	mov    (%eax),%eax
  8002ca:	83 f8 ff             	cmp    $0xffffffff,%eax
  8002cd:	74 14                	je     8002e3 <_main+0x2ab>
  8002cf:	83 ec 04             	sub    $0x4,%esp
  8002d2:	68 e8 39 80 00       	push   $0x8039e8
  8002d7:	6a 41                	push   $0x41
  8002d9:	68 bc 37 80 00       	push   $0x8037bc
  8002de:	e8 b6 01 00 00       	call   800499 <_panic>
		if( y[PAGE_SIZE/4 - 1] !=  -1)  	panic("Reading/Writing of shared object is failed");
  8002e3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8002e6:	05 fc 0f 00 00       	add    $0xffc,%eax
  8002eb:	8b 00                	mov    (%eax),%eax
  8002ed:	83 f8 ff             	cmp    $0xffffffff,%eax
  8002f0:	74 14                	je     800306 <_main+0x2ce>
  8002f2:	83 ec 04             	sub    $0x4,%esp
  8002f5:	68 e8 39 80 00       	push   $0x8039e8
  8002fa:	6a 42                	push   $0x42
  8002fc:	68 bc 37 80 00       	push   $0x8037bc
  800301:	e8 93 01 00 00       	call   800499 <_panic>

		if( z[0] !=  -1)  					panic("Reading/Writing of shared object is failed");
  800306:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800309:	8b 00                	mov    (%eax),%eax
  80030b:	83 f8 ff             	cmp    $0xffffffff,%eax
  80030e:	74 14                	je     800324 <_main+0x2ec>
  800310:	83 ec 04             	sub    $0x4,%esp
  800313:	68 e8 39 80 00       	push   $0x8039e8
  800318:	6a 44                	push   $0x44
  80031a:	68 bc 37 80 00       	push   $0x8037bc
  80031f:	e8 75 01 00 00       	call   800499 <_panic>
		if( z[2*PAGE_SIZE/4 - 1] !=  -1)  	panic("Reading/Writing of shared object is failed");
  800324:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800327:	05 fc 1f 00 00       	add    $0x1ffc,%eax
  80032c:	8b 00                	mov    (%eax),%eax
  80032e:	83 f8 ff             	cmp    $0xffffffff,%eax
  800331:	74 14                	je     800347 <_main+0x30f>
  800333:	83 ec 04             	sub    $0x4,%esp
  800336:	68 e8 39 80 00       	push   $0x8039e8
  80033b:	6a 45                	push   $0x45
  80033d:	68 bc 37 80 00       	push   $0x8037bc
  800342:	e8 52 01 00 00       	call   800499 <_panic>
	}

	cprintf("Congratulations!! Test of Shared Variables [Create] [1] completed successfully!!\n\n\n");
  800347:	83 ec 0c             	sub    $0xc,%esp
  80034a:	68 14 3a 80 00       	push   $0x803a14
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
  800363:	e8 d5 18 00 00       	call   801c3d <sys_getenvindex>
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
  8003ce:	e8 77 16 00 00       	call   801a4a <sys_disable_interrupt>
	cprintf("**************************************\n");
  8003d3:	83 ec 0c             	sub    $0xc,%esp
  8003d6:	68 80 3a 80 00       	push   $0x803a80
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
  8003fe:	68 a8 3a 80 00       	push   $0x803aa8
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
  80042f:	68 d0 3a 80 00       	push   $0x803ad0
  800434:	e8 14 03 00 00       	call   80074d <cprintf>
  800439:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80043c:	a1 20 50 80 00       	mov    0x805020,%eax
  800441:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800447:	83 ec 08             	sub    $0x8,%esp
  80044a:	50                   	push   %eax
  80044b:	68 28 3b 80 00       	push   $0x803b28
  800450:	e8 f8 02 00 00       	call   80074d <cprintf>
  800455:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800458:	83 ec 0c             	sub    $0xc,%esp
  80045b:	68 80 3a 80 00       	push   $0x803a80
  800460:	e8 e8 02 00 00       	call   80074d <cprintf>
  800465:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800468:	e8 f7 15 00 00       	call   801a64 <sys_enable_interrupt>

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
  800480:	e8 84 17 00 00       	call   801c09 <sys_destroy_env>
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
  800491:	e8 d9 17 00 00       	call   801c6f <sys_exit_env>
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
  8004ba:	68 3c 3b 80 00       	push   $0x803b3c
  8004bf:	e8 89 02 00 00       	call   80074d <cprintf>
  8004c4:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8004c7:	a1 00 50 80 00       	mov    0x805000,%eax
  8004cc:	ff 75 0c             	pushl  0xc(%ebp)
  8004cf:	ff 75 08             	pushl  0x8(%ebp)
  8004d2:	50                   	push   %eax
  8004d3:	68 41 3b 80 00       	push   $0x803b41
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
  8004f7:	68 5d 3b 80 00       	push   $0x803b5d
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
  800523:	68 60 3b 80 00       	push   $0x803b60
  800528:	6a 26                	push   $0x26
  80052a:	68 ac 3b 80 00       	push   $0x803bac
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
  8005f5:	68 b8 3b 80 00       	push   $0x803bb8
  8005fa:	6a 3a                	push   $0x3a
  8005fc:	68 ac 3b 80 00       	push   $0x803bac
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
  800665:	68 0c 3c 80 00       	push   $0x803c0c
  80066a:	6a 44                	push   $0x44
  80066c:	68 ac 3b 80 00       	push   $0x803bac
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
  8006bf:	e8 d8 11 00 00       	call   80189c <sys_cputs>
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
  800736:	e8 61 11 00 00       	call   80189c <sys_cputs>
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
  800780:	e8 c5 12 00 00       	call   801a4a <sys_disable_interrupt>
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
  8007a0:	e8 bf 12 00 00       	call   801a64 <sys_enable_interrupt>
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
  8007ea:	e8 31 2d 00 00       	call   803520 <__udivdi3>
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
  80083a:	e8 f1 2d 00 00       	call   803630 <__umoddi3>
  80083f:	83 c4 10             	add    $0x10,%esp
  800842:	05 74 3e 80 00       	add    $0x803e74,%eax
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
  800995:	8b 04 85 98 3e 80 00 	mov    0x803e98(,%eax,4),%eax
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
  800a76:	8b 34 9d e0 3c 80 00 	mov    0x803ce0(,%ebx,4),%esi
  800a7d:	85 f6                	test   %esi,%esi
  800a7f:	75 19                	jne    800a9a <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800a81:	53                   	push   %ebx
  800a82:	68 85 3e 80 00       	push   $0x803e85
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
  800a9b:	68 8e 3e 80 00       	push   $0x803e8e
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
  800ac8:	be 91 3e 80 00       	mov    $0x803e91,%esi
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
  8014ee:	68 f0 3f 80 00       	push   $0x803ff0
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
  8015be:	e8 1d 04 00 00       	call   8019e0 <sys_allocate_chunk>
  8015c3:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8015c6:	a1 20 51 80 00       	mov    0x805120,%eax
  8015cb:	83 ec 0c             	sub    $0xc,%esp
  8015ce:	50                   	push   %eax
  8015cf:	e8 92 0a 00 00       	call   802066 <initialize_MemBlocksList>
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
  8015fc:	68 15 40 80 00       	push   $0x804015
  801601:	6a 33                	push   $0x33
  801603:	68 33 40 80 00       	push   $0x804033
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
  80167b:	68 40 40 80 00       	push   $0x804040
  801680:	6a 34                	push   $0x34
  801682:	68 33 40 80 00       	push   $0x804033
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
  8016d8:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016db:	e8 f7 fd ff ff       	call   8014d7 <InitializeUHeap>
	if (size == 0) return NULL ;
  8016e0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8016e4:	75 07                	jne    8016ed <malloc+0x18>
  8016e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8016eb:	eb 14                	jmp    801701 <malloc+0x2c>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  8016ed:	83 ec 04             	sub    $0x4,%esp
  8016f0:	68 64 40 80 00       	push   $0x804064
  8016f5:	6a 46                	push   $0x46
  8016f7:	68 33 40 80 00       	push   $0x804033
  8016fc:	e8 98 ed ff ff       	call   800499 <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801701:	c9                   	leave  
  801702:	c3                   	ret    

00801703 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801703:	55                   	push   %ebp
  801704:	89 e5                	mov    %esp,%ebp
  801706:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801709:	83 ec 04             	sub    $0x4,%esp
  80170c:	68 8c 40 80 00       	push   $0x80408c
  801711:	6a 61                	push   $0x61
  801713:	68 33 40 80 00       	push   $0x804033
  801718:	e8 7c ed ff ff       	call   800499 <_panic>

0080171d <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80171d:	55                   	push   %ebp
  80171e:	89 e5                	mov    %esp,%ebp
  801720:	83 ec 38             	sub    $0x38,%esp
  801723:	8b 45 10             	mov    0x10(%ebp),%eax
  801726:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801729:	e8 a9 fd ff ff       	call   8014d7 <InitializeUHeap>
	if (size == 0) return NULL ;
  80172e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801732:	75 07                	jne    80173b <smalloc+0x1e>
  801734:	b8 00 00 00 00       	mov    $0x0,%eax
  801739:	eb 7c                	jmp    8017b7 <smalloc+0x9a>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  80173b:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801742:	8b 55 0c             	mov    0xc(%ebp),%edx
  801745:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801748:	01 d0                	add    %edx,%eax
  80174a:	48                   	dec    %eax
  80174b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80174e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801751:	ba 00 00 00 00       	mov    $0x0,%edx
  801756:	f7 75 f0             	divl   -0x10(%ebp)
  801759:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80175c:	29 d0                	sub    %edx,%eax
  80175e:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801761:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801768:	e8 41 06 00 00       	call   801dae <sys_isUHeapPlacementStrategyFIRSTFIT>
  80176d:	85 c0                	test   %eax,%eax
  80176f:	74 11                	je     801782 <smalloc+0x65>
		mem_block = alloc_block_FF(allocate_space);
  801771:	83 ec 0c             	sub    $0xc,%esp
  801774:	ff 75 e8             	pushl  -0x18(%ebp)
  801777:	e8 ac 0c 00 00       	call   802428 <alloc_block_FF>
  80177c:	83 c4 10             	add    $0x10,%esp
  80177f:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  801782:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801786:	74 2a                	je     8017b2 <smalloc+0x95>
	{
		virtual_address = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801788:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80178b:	8b 40 08             	mov    0x8(%eax),%eax
  80178e:	89 c2                	mov    %eax,%edx
  801790:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801794:	52                   	push   %edx
  801795:	50                   	push   %eax
  801796:	ff 75 0c             	pushl  0xc(%ebp)
  801799:	ff 75 08             	pushl  0x8(%ebp)
  80179c:	e8 92 03 00 00       	call   801b33 <sys_createSharedObject>
  8017a1:	83 c4 10             	add    $0x10,%esp
  8017a4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (virtual_address != -1)
  8017a7:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  8017ab:	74 05                	je     8017b2 <smalloc+0x95>
			return (void*)virtual_address;
  8017ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017b0:	eb 05                	jmp    8017b7 <smalloc+0x9a>
	}
	return NULL;
  8017b2:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8017b7:	c9                   	leave  
  8017b8:	c3                   	ret    

008017b9 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8017b9:	55                   	push   %ebp
  8017ba:	89 e5                	mov    %esp,%ebp
  8017bc:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8017bf:	e8 13 fd ff ff       	call   8014d7 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8017c4:	83 ec 04             	sub    $0x4,%esp
  8017c7:	68 b0 40 80 00       	push   $0x8040b0
  8017cc:	68 a2 00 00 00       	push   $0xa2
  8017d1:	68 33 40 80 00       	push   $0x804033
  8017d6:	e8 be ec ff ff       	call   800499 <_panic>

008017db <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8017db:	55                   	push   %ebp
  8017dc:	89 e5                	mov    %esp,%ebp
  8017de:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8017e1:	e8 f1 fc ff ff       	call   8014d7 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8017e6:	83 ec 04             	sub    $0x4,%esp
  8017e9:	68 d4 40 80 00       	push   $0x8040d4
  8017ee:	68 e6 00 00 00       	push   $0xe6
  8017f3:	68 33 40 80 00       	push   $0x804033
  8017f8:	e8 9c ec ff ff       	call   800499 <_panic>

008017fd <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8017fd:	55                   	push   %ebp
  8017fe:	89 e5                	mov    %esp,%ebp
  801800:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801803:	83 ec 04             	sub    $0x4,%esp
  801806:	68 fc 40 80 00       	push   $0x8040fc
  80180b:	68 fa 00 00 00       	push   $0xfa
  801810:	68 33 40 80 00       	push   $0x804033
  801815:	e8 7f ec ff ff       	call   800499 <_panic>

0080181a <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  80181a:	55                   	push   %ebp
  80181b:	89 e5                	mov    %esp,%ebp
  80181d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801820:	83 ec 04             	sub    $0x4,%esp
  801823:	68 20 41 80 00       	push   $0x804120
  801828:	68 05 01 00 00       	push   $0x105
  80182d:	68 33 40 80 00       	push   $0x804033
  801832:	e8 62 ec ff ff       	call   800499 <_panic>

00801837 <shrink>:

}
void shrink(uint32 newSize)
{
  801837:	55                   	push   %ebp
  801838:	89 e5                	mov    %esp,%ebp
  80183a:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80183d:	83 ec 04             	sub    $0x4,%esp
  801840:	68 20 41 80 00       	push   $0x804120
  801845:	68 0a 01 00 00       	push   $0x10a
  80184a:	68 33 40 80 00       	push   $0x804033
  80184f:	e8 45 ec ff ff       	call   800499 <_panic>

00801854 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801854:	55                   	push   %ebp
  801855:	89 e5                	mov    %esp,%ebp
  801857:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80185a:	83 ec 04             	sub    $0x4,%esp
  80185d:	68 20 41 80 00       	push   $0x804120
  801862:	68 0f 01 00 00       	push   $0x10f
  801867:	68 33 40 80 00       	push   $0x804033
  80186c:	e8 28 ec ff ff       	call   800499 <_panic>

00801871 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801871:	55                   	push   %ebp
  801872:	89 e5                	mov    %esp,%ebp
  801874:	57                   	push   %edi
  801875:	56                   	push   %esi
  801876:	53                   	push   %ebx
  801877:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80187a:	8b 45 08             	mov    0x8(%ebp),%eax
  80187d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801880:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801883:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801886:	8b 7d 18             	mov    0x18(%ebp),%edi
  801889:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80188c:	cd 30                	int    $0x30
  80188e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801891:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801894:	83 c4 10             	add    $0x10,%esp
  801897:	5b                   	pop    %ebx
  801898:	5e                   	pop    %esi
  801899:	5f                   	pop    %edi
  80189a:	5d                   	pop    %ebp
  80189b:	c3                   	ret    

0080189c <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80189c:	55                   	push   %ebp
  80189d:	89 e5                	mov    %esp,%ebp
  80189f:	83 ec 04             	sub    $0x4,%esp
  8018a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8018a5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8018a8:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8018ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8018af:	6a 00                	push   $0x0
  8018b1:	6a 00                	push   $0x0
  8018b3:	52                   	push   %edx
  8018b4:	ff 75 0c             	pushl  0xc(%ebp)
  8018b7:	50                   	push   %eax
  8018b8:	6a 00                	push   $0x0
  8018ba:	e8 b2 ff ff ff       	call   801871 <syscall>
  8018bf:	83 c4 18             	add    $0x18,%esp
}
  8018c2:	90                   	nop
  8018c3:	c9                   	leave  
  8018c4:	c3                   	ret    

008018c5 <sys_cgetc>:

int
sys_cgetc(void)
{
  8018c5:	55                   	push   %ebp
  8018c6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8018c8:	6a 00                	push   $0x0
  8018ca:	6a 00                	push   $0x0
  8018cc:	6a 00                	push   $0x0
  8018ce:	6a 00                	push   $0x0
  8018d0:	6a 00                	push   $0x0
  8018d2:	6a 01                	push   $0x1
  8018d4:	e8 98 ff ff ff       	call   801871 <syscall>
  8018d9:	83 c4 18             	add    $0x18,%esp
}
  8018dc:	c9                   	leave  
  8018dd:	c3                   	ret    

008018de <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8018de:	55                   	push   %ebp
  8018df:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8018e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e7:	6a 00                	push   $0x0
  8018e9:	6a 00                	push   $0x0
  8018eb:	6a 00                	push   $0x0
  8018ed:	52                   	push   %edx
  8018ee:	50                   	push   %eax
  8018ef:	6a 05                	push   $0x5
  8018f1:	e8 7b ff ff ff       	call   801871 <syscall>
  8018f6:	83 c4 18             	add    $0x18,%esp
}
  8018f9:	c9                   	leave  
  8018fa:	c3                   	ret    

008018fb <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8018fb:	55                   	push   %ebp
  8018fc:	89 e5                	mov    %esp,%ebp
  8018fe:	56                   	push   %esi
  8018ff:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801900:	8b 75 18             	mov    0x18(%ebp),%esi
  801903:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801906:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801909:	8b 55 0c             	mov    0xc(%ebp),%edx
  80190c:	8b 45 08             	mov    0x8(%ebp),%eax
  80190f:	56                   	push   %esi
  801910:	53                   	push   %ebx
  801911:	51                   	push   %ecx
  801912:	52                   	push   %edx
  801913:	50                   	push   %eax
  801914:	6a 06                	push   $0x6
  801916:	e8 56 ff ff ff       	call   801871 <syscall>
  80191b:	83 c4 18             	add    $0x18,%esp
}
  80191e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801921:	5b                   	pop    %ebx
  801922:	5e                   	pop    %esi
  801923:	5d                   	pop    %ebp
  801924:	c3                   	ret    

00801925 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801925:	55                   	push   %ebp
  801926:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801928:	8b 55 0c             	mov    0xc(%ebp),%edx
  80192b:	8b 45 08             	mov    0x8(%ebp),%eax
  80192e:	6a 00                	push   $0x0
  801930:	6a 00                	push   $0x0
  801932:	6a 00                	push   $0x0
  801934:	52                   	push   %edx
  801935:	50                   	push   %eax
  801936:	6a 07                	push   $0x7
  801938:	e8 34 ff ff ff       	call   801871 <syscall>
  80193d:	83 c4 18             	add    $0x18,%esp
}
  801940:	c9                   	leave  
  801941:	c3                   	ret    

00801942 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801942:	55                   	push   %ebp
  801943:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801945:	6a 00                	push   $0x0
  801947:	6a 00                	push   $0x0
  801949:	6a 00                	push   $0x0
  80194b:	ff 75 0c             	pushl  0xc(%ebp)
  80194e:	ff 75 08             	pushl  0x8(%ebp)
  801951:	6a 08                	push   $0x8
  801953:	e8 19 ff ff ff       	call   801871 <syscall>
  801958:	83 c4 18             	add    $0x18,%esp
}
  80195b:	c9                   	leave  
  80195c:	c3                   	ret    

0080195d <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80195d:	55                   	push   %ebp
  80195e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801960:	6a 00                	push   $0x0
  801962:	6a 00                	push   $0x0
  801964:	6a 00                	push   $0x0
  801966:	6a 00                	push   $0x0
  801968:	6a 00                	push   $0x0
  80196a:	6a 09                	push   $0x9
  80196c:	e8 00 ff ff ff       	call   801871 <syscall>
  801971:	83 c4 18             	add    $0x18,%esp
}
  801974:	c9                   	leave  
  801975:	c3                   	ret    

00801976 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801976:	55                   	push   %ebp
  801977:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801979:	6a 00                	push   $0x0
  80197b:	6a 00                	push   $0x0
  80197d:	6a 00                	push   $0x0
  80197f:	6a 00                	push   $0x0
  801981:	6a 00                	push   $0x0
  801983:	6a 0a                	push   $0xa
  801985:	e8 e7 fe ff ff       	call   801871 <syscall>
  80198a:	83 c4 18             	add    $0x18,%esp
}
  80198d:	c9                   	leave  
  80198e:	c3                   	ret    

0080198f <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80198f:	55                   	push   %ebp
  801990:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801992:	6a 00                	push   $0x0
  801994:	6a 00                	push   $0x0
  801996:	6a 00                	push   $0x0
  801998:	6a 00                	push   $0x0
  80199a:	6a 00                	push   $0x0
  80199c:	6a 0b                	push   $0xb
  80199e:	e8 ce fe ff ff       	call   801871 <syscall>
  8019a3:	83 c4 18             	add    $0x18,%esp
}
  8019a6:	c9                   	leave  
  8019a7:	c3                   	ret    

008019a8 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8019a8:	55                   	push   %ebp
  8019a9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8019ab:	6a 00                	push   $0x0
  8019ad:	6a 00                	push   $0x0
  8019af:	6a 00                	push   $0x0
  8019b1:	ff 75 0c             	pushl  0xc(%ebp)
  8019b4:	ff 75 08             	pushl  0x8(%ebp)
  8019b7:	6a 0f                	push   $0xf
  8019b9:	e8 b3 fe ff ff       	call   801871 <syscall>
  8019be:	83 c4 18             	add    $0x18,%esp
	return;
  8019c1:	90                   	nop
}
  8019c2:	c9                   	leave  
  8019c3:	c3                   	ret    

008019c4 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8019c4:	55                   	push   %ebp
  8019c5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8019c7:	6a 00                	push   $0x0
  8019c9:	6a 00                	push   $0x0
  8019cb:	6a 00                	push   $0x0
  8019cd:	ff 75 0c             	pushl  0xc(%ebp)
  8019d0:	ff 75 08             	pushl  0x8(%ebp)
  8019d3:	6a 10                	push   $0x10
  8019d5:	e8 97 fe ff ff       	call   801871 <syscall>
  8019da:	83 c4 18             	add    $0x18,%esp
	return ;
  8019dd:	90                   	nop
}
  8019de:	c9                   	leave  
  8019df:	c3                   	ret    

008019e0 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8019e0:	55                   	push   %ebp
  8019e1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8019e3:	6a 00                	push   $0x0
  8019e5:	6a 00                	push   $0x0
  8019e7:	ff 75 10             	pushl  0x10(%ebp)
  8019ea:	ff 75 0c             	pushl  0xc(%ebp)
  8019ed:	ff 75 08             	pushl  0x8(%ebp)
  8019f0:	6a 11                	push   $0x11
  8019f2:	e8 7a fe ff ff       	call   801871 <syscall>
  8019f7:	83 c4 18             	add    $0x18,%esp
	return ;
  8019fa:	90                   	nop
}
  8019fb:	c9                   	leave  
  8019fc:	c3                   	ret    

008019fd <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8019fd:	55                   	push   %ebp
  8019fe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801a00:	6a 00                	push   $0x0
  801a02:	6a 00                	push   $0x0
  801a04:	6a 00                	push   $0x0
  801a06:	6a 00                	push   $0x0
  801a08:	6a 00                	push   $0x0
  801a0a:	6a 0c                	push   $0xc
  801a0c:	e8 60 fe ff ff       	call   801871 <syscall>
  801a11:	83 c4 18             	add    $0x18,%esp
}
  801a14:	c9                   	leave  
  801a15:	c3                   	ret    

00801a16 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801a16:	55                   	push   %ebp
  801a17:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801a19:	6a 00                	push   $0x0
  801a1b:	6a 00                	push   $0x0
  801a1d:	6a 00                	push   $0x0
  801a1f:	6a 00                	push   $0x0
  801a21:	ff 75 08             	pushl  0x8(%ebp)
  801a24:	6a 0d                	push   $0xd
  801a26:	e8 46 fe ff ff       	call   801871 <syscall>
  801a2b:	83 c4 18             	add    $0x18,%esp
}
  801a2e:	c9                   	leave  
  801a2f:	c3                   	ret    

00801a30 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801a30:	55                   	push   %ebp
  801a31:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801a33:	6a 00                	push   $0x0
  801a35:	6a 00                	push   $0x0
  801a37:	6a 00                	push   $0x0
  801a39:	6a 00                	push   $0x0
  801a3b:	6a 00                	push   $0x0
  801a3d:	6a 0e                	push   $0xe
  801a3f:	e8 2d fe ff ff       	call   801871 <syscall>
  801a44:	83 c4 18             	add    $0x18,%esp
}
  801a47:	90                   	nop
  801a48:	c9                   	leave  
  801a49:	c3                   	ret    

00801a4a <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801a4a:	55                   	push   %ebp
  801a4b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801a4d:	6a 00                	push   $0x0
  801a4f:	6a 00                	push   $0x0
  801a51:	6a 00                	push   $0x0
  801a53:	6a 00                	push   $0x0
  801a55:	6a 00                	push   $0x0
  801a57:	6a 13                	push   $0x13
  801a59:	e8 13 fe ff ff       	call   801871 <syscall>
  801a5e:	83 c4 18             	add    $0x18,%esp
}
  801a61:	90                   	nop
  801a62:	c9                   	leave  
  801a63:	c3                   	ret    

00801a64 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801a64:	55                   	push   %ebp
  801a65:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801a67:	6a 00                	push   $0x0
  801a69:	6a 00                	push   $0x0
  801a6b:	6a 00                	push   $0x0
  801a6d:	6a 00                	push   $0x0
  801a6f:	6a 00                	push   $0x0
  801a71:	6a 14                	push   $0x14
  801a73:	e8 f9 fd ff ff       	call   801871 <syscall>
  801a78:	83 c4 18             	add    $0x18,%esp
}
  801a7b:	90                   	nop
  801a7c:	c9                   	leave  
  801a7d:	c3                   	ret    

00801a7e <sys_cputc>:


void
sys_cputc(const char c)
{
  801a7e:	55                   	push   %ebp
  801a7f:	89 e5                	mov    %esp,%ebp
  801a81:	83 ec 04             	sub    $0x4,%esp
  801a84:	8b 45 08             	mov    0x8(%ebp),%eax
  801a87:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801a8a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a8e:	6a 00                	push   $0x0
  801a90:	6a 00                	push   $0x0
  801a92:	6a 00                	push   $0x0
  801a94:	6a 00                	push   $0x0
  801a96:	50                   	push   %eax
  801a97:	6a 15                	push   $0x15
  801a99:	e8 d3 fd ff ff       	call   801871 <syscall>
  801a9e:	83 c4 18             	add    $0x18,%esp
}
  801aa1:	90                   	nop
  801aa2:	c9                   	leave  
  801aa3:	c3                   	ret    

00801aa4 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801aa4:	55                   	push   %ebp
  801aa5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801aa7:	6a 00                	push   $0x0
  801aa9:	6a 00                	push   $0x0
  801aab:	6a 00                	push   $0x0
  801aad:	6a 00                	push   $0x0
  801aaf:	6a 00                	push   $0x0
  801ab1:	6a 16                	push   $0x16
  801ab3:	e8 b9 fd ff ff       	call   801871 <syscall>
  801ab8:	83 c4 18             	add    $0x18,%esp
}
  801abb:	90                   	nop
  801abc:	c9                   	leave  
  801abd:	c3                   	ret    

00801abe <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801abe:	55                   	push   %ebp
  801abf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801ac1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac4:	6a 00                	push   $0x0
  801ac6:	6a 00                	push   $0x0
  801ac8:	6a 00                	push   $0x0
  801aca:	ff 75 0c             	pushl  0xc(%ebp)
  801acd:	50                   	push   %eax
  801ace:	6a 17                	push   $0x17
  801ad0:	e8 9c fd ff ff       	call   801871 <syscall>
  801ad5:	83 c4 18             	add    $0x18,%esp
}
  801ad8:	c9                   	leave  
  801ad9:	c3                   	ret    

00801ada <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801ada:	55                   	push   %ebp
  801adb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801add:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ae0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae3:	6a 00                	push   $0x0
  801ae5:	6a 00                	push   $0x0
  801ae7:	6a 00                	push   $0x0
  801ae9:	52                   	push   %edx
  801aea:	50                   	push   %eax
  801aeb:	6a 1a                	push   $0x1a
  801aed:	e8 7f fd ff ff       	call   801871 <syscall>
  801af2:	83 c4 18             	add    $0x18,%esp
}
  801af5:	c9                   	leave  
  801af6:	c3                   	ret    

00801af7 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801af7:	55                   	push   %ebp
  801af8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801afa:	8b 55 0c             	mov    0xc(%ebp),%edx
  801afd:	8b 45 08             	mov    0x8(%ebp),%eax
  801b00:	6a 00                	push   $0x0
  801b02:	6a 00                	push   $0x0
  801b04:	6a 00                	push   $0x0
  801b06:	52                   	push   %edx
  801b07:	50                   	push   %eax
  801b08:	6a 18                	push   $0x18
  801b0a:	e8 62 fd ff ff       	call   801871 <syscall>
  801b0f:	83 c4 18             	add    $0x18,%esp
}
  801b12:	90                   	nop
  801b13:	c9                   	leave  
  801b14:	c3                   	ret    

00801b15 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b15:	55                   	push   %ebp
  801b16:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b18:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b1e:	6a 00                	push   $0x0
  801b20:	6a 00                	push   $0x0
  801b22:	6a 00                	push   $0x0
  801b24:	52                   	push   %edx
  801b25:	50                   	push   %eax
  801b26:	6a 19                	push   $0x19
  801b28:	e8 44 fd ff ff       	call   801871 <syscall>
  801b2d:	83 c4 18             	add    $0x18,%esp
}
  801b30:	90                   	nop
  801b31:	c9                   	leave  
  801b32:	c3                   	ret    

00801b33 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801b33:	55                   	push   %ebp
  801b34:	89 e5                	mov    %esp,%ebp
  801b36:	83 ec 04             	sub    $0x4,%esp
  801b39:	8b 45 10             	mov    0x10(%ebp),%eax
  801b3c:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b3f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b42:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b46:	8b 45 08             	mov    0x8(%ebp),%eax
  801b49:	6a 00                	push   $0x0
  801b4b:	51                   	push   %ecx
  801b4c:	52                   	push   %edx
  801b4d:	ff 75 0c             	pushl  0xc(%ebp)
  801b50:	50                   	push   %eax
  801b51:	6a 1b                	push   $0x1b
  801b53:	e8 19 fd ff ff       	call   801871 <syscall>
  801b58:	83 c4 18             	add    $0x18,%esp
}
  801b5b:	c9                   	leave  
  801b5c:	c3                   	ret    

00801b5d <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801b5d:	55                   	push   %ebp
  801b5e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b60:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b63:	8b 45 08             	mov    0x8(%ebp),%eax
  801b66:	6a 00                	push   $0x0
  801b68:	6a 00                	push   $0x0
  801b6a:	6a 00                	push   $0x0
  801b6c:	52                   	push   %edx
  801b6d:	50                   	push   %eax
  801b6e:	6a 1c                	push   $0x1c
  801b70:	e8 fc fc ff ff       	call   801871 <syscall>
  801b75:	83 c4 18             	add    $0x18,%esp
}
  801b78:	c9                   	leave  
  801b79:	c3                   	ret    

00801b7a <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801b7a:	55                   	push   %ebp
  801b7b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801b7d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b80:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b83:	8b 45 08             	mov    0x8(%ebp),%eax
  801b86:	6a 00                	push   $0x0
  801b88:	6a 00                	push   $0x0
  801b8a:	51                   	push   %ecx
  801b8b:	52                   	push   %edx
  801b8c:	50                   	push   %eax
  801b8d:	6a 1d                	push   $0x1d
  801b8f:	e8 dd fc ff ff       	call   801871 <syscall>
  801b94:	83 c4 18             	add    $0x18,%esp
}
  801b97:	c9                   	leave  
  801b98:	c3                   	ret    

00801b99 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801b99:	55                   	push   %ebp
  801b9a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b9c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba2:	6a 00                	push   $0x0
  801ba4:	6a 00                	push   $0x0
  801ba6:	6a 00                	push   $0x0
  801ba8:	52                   	push   %edx
  801ba9:	50                   	push   %eax
  801baa:	6a 1e                	push   $0x1e
  801bac:	e8 c0 fc ff ff       	call   801871 <syscall>
  801bb1:	83 c4 18             	add    $0x18,%esp
}
  801bb4:	c9                   	leave  
  801bb5:	c3                   	ret    

00801bb6 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801bb6:	55                   	push   %ebp
  801bb7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801bb9:	6a 00                	push   $0x0
  801bbb:	6a 00                	push   $0x0
  801bbd:	6a 00                	push   $0x0
  801bbf:	6a 00                	push   $0x0
  801bc1:	6a 00                	push   $0x0
  801bc3:	6a 1f                	push   $0x1f
  801bc5:	e8 a7 fc ff ff       	call   801871 <syscall>
  801bca:	83 c4 18             	add    $0x18,%esp
}
  801bcd:	c9                   	leave  
  801bce:	c3                   	ret    

00801bcf <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801bcf:	55                   	push   %ebp
  801bd0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801bd2:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd5:	6a 00                	push   $0x0
  801bd7:	ff 75 14             	pushl  0x14(%ebp)
  801bda:	ff 75 10             	pushl  0x10(%ebp)
  801bdd:	ff 75 0c             	pushl  0xc(%ebp)
  801be0:	50                   	push   %eax
  801be1:	6a 20                	push   $0x20
  801be3:	e8 89 fc ff ff       	call   801871 <syscall>
  801be8:	83 c4 18             	add    $0x18,%esp
}
  801beb:	c9                   	leave  
  801bec:	c3                   	ret    

00801bed <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801bed:	55                   	push   %ebp
  801bee:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801bf0:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf3:	6a 00                	push   $0x0
  801bf5:	6a 00                	push   $0x0
  801bf7:	6a 00                	push   $0x0
  801bf9:	6a 00                	push   $0x0
  801bfb:	50                   	push   %eax
  801bfc:	6a 21                	push   $0x21
  801bfe:	e8 6e fc ff ff       	call   801871 <syscall>
  801c03:	83 c4 18             	add    $0x18,%esp
}
  801c06:	90                   	nop
  801c07:	c9                   	leave  
  801c08:	c3                   	ret    

00801c09 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801c09:	55                   	push   %ebp
  801c0a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801c0c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0f:	6a 00                	push   $0x0
  801c11:	6a 00                	push   $0x0
  801c13:	6a 00                	push   $0x0
  801c15:	6a 00                	push   $0x0
  801c17:	50                   	push   %eax
  801c18:	6a 22                	push   $0x22
  801c1a:	e8 52 fc ff ff       	call   801871 <syscall>
  801c1f:	83 c4 18             	add    $0x18,%esp
}
  801c22:	c9                   	leave  
  801c23:	c3                   	ret    

00801c24 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801c24:	55                   	push   %ebp
  801c25:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801c27:	6a 00                	push   $0x0
  801c29:	6a 00                	push   $0x0
  801c2b:	6a 00                	push   $0x0
  801c2d:	6a 00                	push   $0x0
  801c2f:	6a 00                	push   $0x0
  801c31:	6a 02                	push   $0x2
  801c33:	e8 39 fc ff ff       	call   801871 <syscall>
  801c38:	83 c4 18             	add    $0x18,%esp
}
  801c3b:	c9                   	leave  
  801c3c:	c3                   	ret    

00801c3d <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c3d:	55                   	push   %ebp
  801c3e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c40:	6a 00                	push   $0x0
  801c42:	6a 00                	push   $0x0
  801c44:	6a 00                	push   $0x0
  801c46:	6a 00                	push   $0x0
  801c48:	6a 00                	push   $0x0
  801c4a:	6a 03                	push   $0x3
  801c4c:	e8 20 fc ff ff       	call   801871 <syscall>
  801c51:	83 c4 18             	add    $0x18,%esp
}
  801c54:	c9                   	leave  
  801c55:	c3                   	ret    

00801c56 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c56:	55                   	push   %ebp
  801c57:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c59:	6a 00                	push   $0x0
  801c5b:	6a 00                	push   $0x0
  801c5d:	6a 00                	push   $0x0
  801c5f:	6a 00                	push   $0x0
  801c61:	6a 00                	push   $0x0
  801c63:	6a 04                	push   $0x4
  801c65:	e8 07 fc ff ff       	call   801871 <syscall>
  801c6a:	83 c4 18             	add    $0x18,%esp
}
  801c6d:	c9                   	leave  
  801c6e:	c3                   	ret    

00801c6f <sys_exit_env>:


void sys_exit_env(void)
{
  801c6f:	55                   	push   %ebp
  801c70:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801c72:	6a 00                	push   $0x0
  801c74:	6a 00                	push   $0x0
  801c76:	6a 00                	push   $0x0
  801c78:	6a 00                	push   $0x0
  801c7a:	6a 00                	push   $0x0
  801c7c:	6a 23                	push   $0x23
  801c7e:	e8 ee fb ff ff       	call   801871 <syscall>
  801c83:	83 c4 18             	add    $0x18,%esp
}
  801c86:	90                   	nop
  801c87:	c9                   	leave  
  801c88:	c3                   	ret    

00801c89 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801c89:	55                   	push   %ebp
  801c8a:	89 e5                	mov    %esp,%ebp
  801c8c:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c8f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c92:	8d 50 04             	lea    0x4(%eax),%edx
  801c95:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c98:	6a 00                	push   $0x0
  801c9a:	6a 00                	push   $0x0
  801c9c:	6a 00                	push   $0x0
  801c9e:	52                   	push   %edx
  801c9f:	50                   	push   %eax
  801ca0:	6a 24                	push   $0x24
  801ca2:	e8 ca fb ff ff       	call   801871 <syscall>
  801ca7:	83 c4 18             	add    $0x18,%esp
	return result;
  801caa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801cad:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801cb0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801cb3:	89 01                	mov    %eax,(%ecx)
  801cb5:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801cb8:	8b 45 08             	mov    0x8(%ebp),%eax
  801cbb:	c9                   	leave  
  801cbc:	c2 04 00             	ret    $0x4

00801cbf <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801cbf:	55                   	push   %ebp
  801cc0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801cc2:	6a 00                	push   $0x0
  801cc4:	6a 00                	push   $0x0
  801cc6:	ff 75 10             	pushl  0x10(%ebp)
  801cc9:	ff 75 0c             	pushl  0xc(%ebp)
  801ccc:	ff 75 08             	pushl  0x8(%ebp)
  801ccf:	6a 12                	push   $0x12
  801cd1:	e8 9b fb ff ff       	call   801871 <syscall>
  801cd6:	83 c4 18             	add    $0x18,%esp
	return ;
  801cd9:	90                   	nop
}
  801cda:	c9                   	leave  
  801cdb:	c3                   	ret    

00801cdc <sys_rcr2>:
uint32 sys_rcr2()
{
  801cdc:	55                   	push   %ebp
  801cdd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801cdf:	6a 00                	push   $0x0
  801ce1:	6a 00                	push   $0x0
  801ce3:	6a 00                	push   $0x0
  801ce5:	6a 00                	push   $0x0
  801ce7:	6a 00                	push   $0x0
  801ce9:	6a 25                	push   $0x25
  801ceb:	e8 81 fb ff ff       	call   801871 <syscall>
  801cf0:	83 c4 18             	add    $0x18,%esp
}
  801cf3:	c9                   	leave  
  801cf4:	c3                   	ret    

00801cf5 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801cf5:	55                   	push   %ebp
  801cf6:	89 e5                	mov    %esp,%ebp
  801cf8:	83 ec 04             	sub    $0x4,%esp
  801cfb:	8b 45 08             	mov    0x8(%ebp),%eax
  801cfe:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801d01:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801d05:	6a 00                	push   $0x0
  801d07:	6a 00                	push   $0x0
  801d09:	6a 00                	push   $0x0
  801d0b:	6a 00                	push   $0x0
  801d0d:	50                   	push   %eax
  801d0e:	6a 26                	push   $0x26
  801d10:	e8 5c fb ff ff       	call   801871 <syscall>
  801d15:	83 c4 18             	add    $0x18,%esp
	return ;
  801d18:	90                   	nop
}
  801d19:	c9                   	leave  
  801d1a:	c3                   	ret    

00801d1b <rsttst>:
void rsttst()
{
  801d1b:	55                   	push   %ebp
  801d1c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801d1e:	6a 00                	push   $0x0
  801d20:	6a 00                	push   $0x0
  801d22:	6a 00                	push   $0x0
  801d24:	6a 00                	push   $0x0
  801d26:	6a 00                	push   $0x0
  801d28:	6a 28                	push   $0x28
  801d2a:	e8 42 fb ff ff       	call   801871 <syscall>
  801d2f:	83 c4 18             	add    $0x18,%esp
	return ;
  801d32:	90                   	nop
}
  801d33:	c9                   	leave  
  801d34:	c3                   	ret    

00801d35 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d35:	55                   	push   %ebp
  801d36:	89 e5                	mov    %esp,%ebp
  801d38:	83 ec 04             	sub    $0x4,%esp
  801d3b:	8b 45 14             	mov    0x14(%ebp),%eax
  801d3e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d41:	8b 55 18             	mov    0x18(%ebp),%edx
  801d44:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d48:	52                   	push   %edx
  801d49:	50                   	push   %eax
  801d4a:	ff 75 10             	pushl  0x10(%ebp)
  801d4d:	ff 75 0c             	pushl  0xc(%ebp)
  801d50:	ff 75 08             	pushl  0x8(%ebp)
  801d53:	6a 27                	push   $0x27
  801d55:	e8 17 fb ff ff       	call   801871 <syscall>
  801d5a:	83 c4 18             	add    $0x18,%esp
	return ;
  801d5d:	90                   	nop
}
  801d5e:	c9                   	leave  
  801d5f:	c3                   	ret    

00801d60 <chktst>:
void chktst(uint32 n)
{
  801d60:	55                   	push   %ebp
  801d61:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d63:	6a 00                	push   $0x0
  801d65:	6a 00                	push   $0x0
  801d67:	6a 00                	push   $0x0
  801d69:	6a 00                	push   $0x0
  801d6b:	ff 75 08             	pushl  0x8(%ebp)
  801d6e:	6a 29                	push   $0x29
  801d70:	e8 fc fa ff ff       	call   801871 <syscall>
  801d75:	83 c4 18             	add    $0x18,%esp
	return ;
  801d78:	90                   	nop
}
  801d79:	c9                   	leave  
  801d7a:	c3                   	ret    

00801d7b <inctst>:

void inctst()
{
  801d7b:	55                   	push   %ebp
  801d7c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d7e:	6a 00                	push   $0x0
  801d80:	6a 00                	push   $0x0
  801d82:	6a 00                	push   $0x0
  801d84:	6a 00                	push   $0x0
  801d86:	6a 00                	push   $0x0
  801d88:	6a 2a                	push   $0x2a
  801d8a:	e8 e2 fa ff ff       	call   801871 <syscall>
  801d8f:	83 c4 18             	add    $0x18,%esp
	return ;
  801d92:	90                   	nop
}
  801d93:	c9                   	leave  
  801d94:	c3                   	ret    

00801d95 <gettst>:
uint32 gettst()
{
  801d95:	55                   	push   %ebp
  801d96:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d98:	6a 00                	push   $0x0
  801d9a:	6a 00                	push   $0x0
  801d9c:	6a 00                	push   $0x0
  801d9e:	6a 00                	push   $0x0
  801da0:	6a 00                	push   $0x0
  801da2:	6a 2b                	push   $0x2b
  801da4:	e8 c8 fa ff ff       	call   801871 <syscall>
  801da9:	83 c4 18             	add    $0x18,%esp
}
  801dac:	c9                   	leave  
  801dad:	c3                   	ret    

00801dae <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801dae:	55                   	push   %ebp
  801daf:	89 e5                	mov    %esp,%ebp
  801db1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801db4:	6a 00                	push   $0x0
  801db6:	6a 00                	push   $0x0
  801db8:	6a 00                	push   $0x0
  801dba:	6a 00                	push   $0x0
  801dbc:	6a 00                	push   $0x0
  801dbe:	6a 2c                	push   $0x2c
  801dc0:	e8 ac fa ff ff       	call   801871 <syscall>
  801dc5:	83 c4 18             	add    $0x18,%esp
  801dc8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801dcb:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801dcf:	75 07                	jne    801dd8 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801dd1:	b8 01 00 00 00       	mov    $0x1,%eax
  801dd6:	eb 05                	jmp    801ddd <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801dd8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ddd:	c9                   	leave  
  801dde:	c3                   	ret    

00801ddf <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801ddf:	55                   	push   %ebp
  801de0:	89 e5                	mov    %esp,%ebp
  801de2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801de5:	6a 00                	push   $0x0
  801de7:	6a 00                	push   $0x0
  801de9:	6a 00                	push   $0x0
  801deb:	6a 00                	push   $0x0
  801ded:	6a 00                	push   $0x0
  801def:	6a 2c                	push   $0x2c
  801df1:	e8 7b fa ff ff       	call   801871 <syscall>
  801df6:	83 c4 18             	add    $0x18,%esp
  801df9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801dfc:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801e00:	75 07                	jne    801e09 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801e02:	b8 01 00 00 00       	mov    $0x1,%eax
  801e07:	eb 05                	jmp    801e0e <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801e09:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e0e:	c9                   	leave  
  801e0f:	c3                   	ret    

00801e10 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
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
  801e22:	e8 4a fa ff ff       	call   801871 <syscall>
  801e27:	83 c4 18             	add    $0x18,%esp
  801e2a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801e2d:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801e31:	75 07                	jne    801e3a <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801e33:	b8 01 00 00 00       	mov    $0x1,%eax
  801e38:	eb 05                	jmp    801e3f <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801e3a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e3f:	c9                   	leave  
  801e40:	c3                   	ret    

00801e41 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
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
  801e53:	e8 19 fa ff ff       	call   801871 <syscall>
  801e58:	83 c4 18             	add    $0x18,%esp
  801e5b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801e5e:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801e62:	75 07                	jne    801e6b <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801e64:	b8 01 00 00 00       	mov    $0x1,%eax
  801e69:	eb 05                	jmp    801e70 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801e6b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e70:	c9                   	leave  
  801e71:	c3                   	ret    

00801e72 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801e72:	55                   	push   %ebp
  801e73:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e75:	6a 00                	push   $0x0
  801e77:	6a 00                	push   $0x0
  801e79:	6a 00                	push   $0x0
  801e7b:	6a 00                	push   $0x0
  801e7d:	ff 75 08             	pushl  0x8(%ebp)
  801e80:	6a 2d                	push   $0x2d
  801e82:	e8 ea f9 ff ff       	call   801871 <syscall>
  801e87:	83 c4 18             	add    $0x18,%esp
	return ;
  801e8a:	90                   	nop
}
  801e8b:	c9                   	leave  
  801e8c:	c3                   	ret    

00801e8d <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e8d:	55                   	push   %ebp
  801e8e:	89 e5                	mov    %esp,%ebp
  801e90:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e91:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e94:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e97:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e9a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e9d:	6a 00                	push   $0x0
  801e9f:	53                   	push   %ebx
  801ea0:	51                   	push   %ecx
  801ea1:	52                   	push   %edx
  801ea2:	50                   	push   %eax
  801ea3:	6a 2e                	push   $0x2e
  801ea5:	e8 c7 f9 ff ff       	call   801871 <syscall>
  801eaa:	83 c4 18             	add    $0x18,%esp
}
  801ead:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801eb0:	c9                   	leave  
  801eb1:	c3                   	ret    

00801eb2 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801eb2:	55                   	push   %ebp
  801eb3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801eb5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eb8:	8b 45 08             	mov    0x8(%ebp),%eax
  801ebb:	6a 00                	push   $0x0
  801ebd:	6a 00                	push   $0x0
  801ebf:	6a 00                	push   $0x0
  801ec1:	52                   	push   %edx
  801ec2:	50                   	push   %eax
  801ec3:	6a 2f                	push   $0x2f
  801ec5:	e8 a7 f9 ff ff       	call   801871 <syscall>
  801eca:	83 c4 18             	add    $0x18,%esp
}
  801ecd:	c9                   	leave  
  801ece:	c3                   	ret    

00801ecf <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801ecf:	55                   	push   %ebp
  801ed0:	89 e5                	mov    %esp,%ebp
  801ed2:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801ed5:	83 ec 0c             	sub    $0xc,%esp
  801ed8:	68 30 41 80 00       	push   $0x804130
  801edd:	e8 6b e8 ff ff       	call   80074d <cprintf>
  801ee2:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801ee5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801eec:	83 ec 0c             	sub    $0xc,%esp
  801eef:	68 5c 41 80 00       	push   $0x80415c
  801ef4:	e8 54 e8 ff ff       	call   80074d <cprintf>
  801ef9:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801efc:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f00:	a1 38 51 80 00       	mov    0x805138,%eax
  801f05:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f08:	eb 56                	jmp    801f60 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f0a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f0e:	74 1c                	je     801f2c <print_mem_block_lists+0x5d>
  801f10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f13:	8b 50 08             	mov    0x8(%eax),%edx
  801f16:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f19:	8b 48 08             	mov    0x8(%eax),%ecx
  801f1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f1f:	8b 40 0c             	mov    0xc(%eax),%eax
  801f22:	01 c8                	add    %ecx,%eax
  801f24:	39 c2                	cmp    %eax,%edx
  801f26:	73 04                	jae    801f2c <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801f28:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f2f:	8b 50 08             	mov    0x8(%eax),%edx
  801f32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f35:	8b 40 0c             	mov    0xc(%eax),%eax
  801f38:	01 c2                	add    %eax,%edx
  801f3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f3d:	8b 40 08             	mov    0x8(%eax),%eax
  801f40:	83 ec 04             	sub    $0x4,%esp
  801f43:	52                   	push   %edx
  801f44:	50                   	push   %eax
  801f45:	68 71 41 80 00       	push   $0x804171
  801f4a:	e8 fe e7 ff ff       	call   80074d <cprintf>
  801f4f:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f55:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f58:	a1 40 51 80 00       	mov    0x805140,%eax
  801f5d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f60:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f64:	74 07                	je     801f6d <print_mem_block_lists+0x9e>
  801f66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f69:	8b 00                	mov    (%eax),%eax
  801f6b:	eb 05                	jmp    801f72 <print_mem_block_lists+0xa3>
  801f6d:	b8 00 00 00 00       	mov    $0x0,%eax
  801f72:	a3 40 51 80 00       	mov    %eax,0x805140
  801f77:	a1 40 51 80 00       	mov    0x805140,%eax
  801f7c:	85 c0                	test   %eax,%eax
  801f7e:	75 8a                	jne    801f0a <print_mem_block_lists+0x3b>
  801f80:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f84:	75 84                	jne    801f0a <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801f86:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f8a:	75 10                	jne    801f9c <print_mem_block_lists+0xcd>
  801f8c:	83 ec 0c             	sub    $0xc,%esp
  801f8f:	68 80 41 80 00       	push   $0x804180
  801f94:	e8 b4 e7 ff ff       	call   80074d <cprintf>
  801f99:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801f9c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801fa3:	83 ec 0c             	sub    $0xc,%esp
  801fa6:	68 a4 41 80 00       	push   $0x8041a4
  801fab:	e8 9d e7 ff ff       	call   80074d <cprintf>
  801fb0:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801fb3:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801fb7:	a1 40 50 80 00       	mov    0x805040,%eax
  801fbc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fbf:	eb 56                	jmp    802017 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801fc1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801fc5:	74 1c                	je     801fe3 <print_mem_block_lists+0x114>
  801fc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fca:	8b 50 08             	mov    0x8(%eax),%edx
  801fcd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fd0:	8b 48 08             	mov    0x8(%eax),%ecx
  801fd3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fd6:	8b 40 0c             	mov    0xc(%eax),%eax
  801fd9:	01 c8                	add    %ecx,%eax
  801fdb:	39 c2                	cmp    %eax,%edx
  801fdd:	73 04                	jae    801fe3 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801fdf:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801fe3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fe6:	8b 50 08             	mov    0x8(%eax),%edx
  801fe9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fec:	8b 40 0c             	mov    0xc(%eax),%eax
  801fef:	01 c2                	add    %eax,%edx
  801ff1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ff4:	8b 40 08             	mov    0x8(%eax),%eax
  801ff7:	83 ec 04             	sub    $0x4,%esp
  801ffa:	52                   	push   %edx
  801ffb:	50                   	push   %eax
  801ffc:	68 71 41 80 00       	push   $0x804171
  802001:	e8 47 e7 ff ff       	call   80074d <cprintf>
  802006:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802009:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80200c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80200f:	a1 48 50 80 00       	mov    0x805048,%eax
  802014:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802017:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80201b:	74 07                	je     802024 <print_mem_block_lists+0x155>
  80201d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802020:	8b 00                	mov    (%eax),%eax
  802022:	eb 05                	jmp    802029 <print_mem_block_lists+0x15a>
  802024:	b8 00 00 00 00       	mov    $0x0,%eax
  802029:	a3 48 50 80 00       	mov    %eax,0x805048
  80202e:	a1 48 50 80 00       	mov    0x805048,%eax
  802033:	85 c0                	test   %eax,%eax
  802035:	75 8a                	jne    801fc1 <print_mem_block_lists+0xf2>
  802037:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80203b:	75 84                	jne    801fc1 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  80203d:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802041:	75 10                	jne    802053 <print_mem_block_lists+0x184>
  802043:	83 ec 0c             	sub    $0xc,%esp
  802046:	68 bc 41 80 00       	push   $0x8041bc
  80204b:	e8 fd e6 ff ff       	call   80074d <cprintf>
  802050:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802053:	83 ec 0c             	sub    $0xc,%esp
  802056:	68 30 41 80 00       	push   $0x804130
  80205b:	e8 ed e6 ff ff       	call   80074d <cprintf>
  802060:	83 c4 10             	add    $0x10,%esp

}
  802063:	90                   	nop
  802064:	c9                   	leave  
  802065:	c3                   	ret    

00802066 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802066:	55                   	push   %ebp
  802067:	89 e5                	mov    %esp,%ebp
  802069:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  80206c:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802073:	00 00 00 
  802076:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  80207d:	00 00 00 
  802080:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802087:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  80208a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802091:	e9 9e 00 00 00       	jmp    802134 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  802096:	a1 50 50 80 00       	mov    0x805050,%eax
  80209b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80209e:	c1 e2 04             	shl    $0x4,%edx
  8020a1:	01 d0                	add    %edx,%eax
  8020a3:	85 c0                	test   %eax,%eax
  8020a5:	75 14                	jne    8020bb <initialize_MemBlocksList+0x55>
  8020a7:	83 ec 04             	sub    $0x4,%esp
  8020aa:	68 e4 41 80 00       	push   $0x8041e4
  8020af:	6a 46                	push   $0x46
  8020b1:	68 07 42 80 00       	push   $0x804207
  8020b6:	e8 de e3 ff ff       	call   800499 <_panic>
  8020bb:	a1 50 50 80 00       	mov    0x805050,%eax
  8020c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020c3:	c1 e2 04             	shl    $0x4,%edx
  8020c6:	01 d0                	add    %edx,%eax
  8020c8:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8020ce:	89 10                	mov    %edx,(%eax)
  8020d0:	8b 00                	mov    (%eax),%eax
  8020d2:	85 c0                	test   %eax,%eax
  8020d4:	74 18                	je     8020ee <initialize_MemBlocksList+0x88>
  8020d6:	a1 48 51 80 00       	mov    0x805148,%eax
  8020db:	8b 15 50 50 80 00    	mov    0x805050,%edx
  8020e1:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8020e4:	c1 e1 04             	shl    $0x4,%ecx
  8020e7:	01 ca                	add    %ecx,%edx
  8020e9:	89 50 04             	mov    %edx,0x4(%eax)
  8020ec:	eb 12                	jmp    802100 <initialize_MemBlocksList+0x9a>
  8020ee:	a1 50 50 80 00       	mov    0x805050,%eax
  8020f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020f6:	c1 e2 04             	shl    $0x4,%edx
  8020f9:	01 d0                	add    %edx,%eax
  8020fb:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802100:	a1 50 50 80 00       	mov    0x805050,%eax
  802105:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802108:	c1 e2 04             	shl    $0x4,%edx
  80210b:	01 d0                	add    %edx,%eax
  80210d:	a3 48 51 80 00       	mov    %eax,0x805148
  802112:	a1 50 50 80 00       	mov    0x805050,%eax
  802117:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80211a:	c1 e2 04             	shl    $0x4,%edx
  80211d:	01 d0                	add    %edx,%eax
  80211f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802126:	a1 54 51 80 00       	mov    0x805154,%eax
  80212b:	40                   	inc    %eax
  80212c:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  802131:	ff 45 f4             	incl   -0xc(%ebp)
  802134:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802137:	3b 45 08             	cmp    0x8(%ebp),%eax
  80213a:	0f 82 56 ff ff ff    	jb     802096 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  802140:	90                   	nop
  802141:	c9                   	leave  
  802142:	c3                   	ret    

00802143 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802143:	55                   	push   %ebp
  802144:	89 e5                	mov    %esp,%ebp
  802146:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802149:	8b 45 08             	mov    0x8(%ebp),%eax
  80214c:	8b 00                	mov    (%eax),%eax
  80214e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802151:	eb 19                	jmp    80216c <find_block+0x29>
	{
		if(va==point->sva)
  802153:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802156:	8b 40 08             	mov    0x8(%eax),%eax
  802159:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80215c:	75 05                	jne    802163 <find_block+0x20>
		   return point;
  80215e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802161:	eb 36                	jmp    802199 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802163:	8b 45 08             	mov    0x8(%ebp),%eax
  802166:	8b 40 08             	mov    0x8(%eax),%eax
  802169:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80216c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802170:	74 07                	je     802179 <find_block+0x36>
  802172:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802175:	8b 00                	mov    (%eax),%eax
  802177:	eb 05                	jmp    80217e <find_block+0x3b>
  802179:	b8 00 00 00 00       	mov    $0x0,%eax
  80217e:	8b 55 08             	mov    0x8(%ebp),%edx
  802181:	89 42 08             	mov    %eax,0x8(%edx)
  802184:	8b 45 08             	mov    0x8(%ebp),%eax
  802187:	8b 40 08             	mov    0x8(%eax),%eax
  80218a:	85 c0                	test   %eax,%eax
  80218c:	75 c5                	jne    802153 <find_block+0x10>
  80218e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802192:	75 bf                	jne    802153 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802194:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802199:	c9                   	leave  
  80219a:	c3                   	ret    

0080219b <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80219b:	55                   	push   %ebp
  80219c:	89 e5                	mov    %esp,%ebp
  80219e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  8021a1:	a1 40 50 80 00       	mov    0x805040,%eax
  8021a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  8021a9:	a1 44 50 80 00       	mov    0x805044,%eax
  8021ae:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  8021b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021b4:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8021b7:	74 24                	je     8021dd <insert_sorted_allocList+0x42>
  8021b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021bc:	8b 50 08             	mov    0x8(%eax),%edx
  8021bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021c2:	8b 40 08             	mov    0x8(%eax),%eax
  8021c5:	39 c2                	cmp    %eax,%edx
  8021c7:	76 14                	jbe    8021dd <insert_sorted_allocList+0x42>
  8021c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021cc:	8b 50 08             	mov    0x8(%eax),%edx
  8021cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021d2:	8b 40 08             	mov    0x8(%eax),%eax
  8021d5:	39 c2                	cmp    %eax,%edx
  8021d7:	0f 82 60 01 00 00    	jb     80233d <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  8021dd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8021e1:	75 65                	jne    802248 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  8021e3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021e7:	75 14                	jne    8021fd <insert_sorted_allocList+0x62>
  8021e9:	83 ec 04             	sub    $0x4,%esp
  8021ec:	68 e4 41 80 00       	push   $0x8041e4
  8021f1:	6a 6b                	push   $0x6b
  8021f3:	68 07 42 80 00       	push   $0x804207
  8021f8:	e8 9c e2 ff ff       	call   800499 <_panic>
  8021fd:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802203:	8b 45 08             	mov    0x8(%ebp),%eax
  802206:	89 10                	mov    %edx,(%eax)
  802208:	8b 45 08             	mov    0x8(%ebp),%eax
  80220b:	8b 00                	mov    (%eax),%eax
  80220d:	85 c0                	test   %eax,%eax
  80220f:	74 0d                	je     80221e <insert_sorted_allocList+0x83>
  802211:	a1 40 50 80 00       	mov    0x805040,%eax
  802216:	8b 55 08             	mov    0x8(%ebp),%edx
  802219:	89 50 04             	mov    %edx,0x4(%eax)
  80221c:	eb 08                	jmp    802226 <insert_sorted_allocList+0x8b>
  80221e:	8b 45 08             	mov    0x8(%ebp),%eax
  802221:	a3 44 50 80 00       	mov    %eax,0x805044
  802226:	8b 45 08             	mov    0x8(%ebp),%eax
  802229:	a3 40 50 80 00       	mov    %eax,0x805040
  80222e:	8b 45 08             	mov    0x8(%ebp),%eax
  802231:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802238:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80223d:	40                   	inc    %eax
  80223e:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802243:	e9 dc 01 00 00       	jmp    802424 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802248:	8b 45 08             	mov    0x8(%ebp),%eax
  80224b:	8b 50 08             	mov    0x8(%eax),%edx
  80224e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802251:	8b 40 08             	mov    0x8(%eax),%eax
  802254:	39 c2                	cmp    %eax,%edx
  802256:	77 6c                	ja     8022c4 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802258:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80225c:	74 06                	je     802264 <insert_sorted_allocList+0xc9>
  80225e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802262:	75 14                	jne    802278 <insert_sorted_allocList+0xdd>
  802264:	83 ec 04             	sub    $0x4,%esp
  802267:	68 20 42 80 00       	push   $0x804220
  80226c:	6a 6f                	push   $0x6f
  80226e:	68 07 42 80 00       	push   $0x804207
  802273:	e8 21 e2 ff ff       	call   800499 <_panic>
  802278:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80227b:	8b 50 04             	mov    0x4(%eax),%edx
  80227e:	8b 45 08             	mov    0x8(%ebp),%eax
  802281:	89 50 04             	mov    %edx,0x4(%eax)
  802284:	8b 45 08             	mov    0x8(%ebp),%eax
  802287:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80228a:	89 10                	mov    %edx,(%eax)
  80228c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80228f:	8b 40 04             	mov    0x4(%eax),%eax
  802292:	85 c0                	test   %eax,%eax
  802294:	74 0d                	je     8022a3 <insert_sorted_allocList+0x108>
  802296:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802299:	8b 40 04             	mov    0x4(%eax),%eax
  80229c:	8b 55 08             	mov    0x8(%ebp),%edx
  80229f:	89 10                	mov    %edx,(%eax)
  8022a1:	eb 08                	jmp    8022ab <insert_sorted_allocList+0x110>
  8022a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a6:	a3 40 50 80 00       	mov    %eax,0x805040
  8022ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022ae:	8b 55 08             	mov    0x8(%ebp),%edx
  8022b1:	89 50 04             	mov    %edx,0x4(%eax)
  8022b4:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8022b9:	40                   	inc    %eax
  8022ba:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8022bf:	e9 60 01 00 00       	jmp    802424 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  8022c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c7:	8b 50 08             	mov    0x8(%eax),%edx
  8022ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022cd:	8b 40 08             	mov    0x8(%eax),%eax
  8022d0:	39 c2                	cmp    %eax,%edx
  8022d2:	0f 82 4c 01 00 00    	jb     802424 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8022d8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022dc:	75 14                	jne    8022f2 <insert_sorted_allocList+0x157>
  8022de:	83 ec 04             	sub    $0x4,%esp
  8022e1:	68 58 42 80 00       	push   $0x804258
  8022e6:	6a 73                	push   $0x73
  8022e8:	68 07 42 80 00       	push   $0x804207
  8022ed:	e8 a7 e1 ff ff       	call   800499 <_panic>
  8022f2:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8022f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fb:	89 50 04             	mov    %edx,0x4(%eax)
  8022fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802301:	8b 40 04             	mov    0x4(%eax),%eax
  802304:	85 c0                	test   %eax,%eax
  802306:	74 0c                	je     802314 <insert_sorted_allocList+0x179>
  802308:	a1 44 50 80 00       	mov    0x805044,%eax
  80230d:	8b 55 08             	mov    0x8(%ebp),%edx
  802310:	89 10                	mov    %edx,(%eax)
  802312:	eb 08                	jmp    80231c <insert_sorted_allocList+0x181>
  802314:	8b 45 08             	mov    0x8(%ebp),%eax
  802317:	a3 40 50 80 00       	mov    %eax,0x805040
  80231c:	8b 45 08             	mov    0x8(%ebp),%eax
  80231f:	a3 44 50 80 00       	mov    %eax,0x805044
  802324:	8b 45 08             	mov    0x8(%ebp),%eax
  802327:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80232d:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802332:	40                   	inc    %eax
  802333:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802338:	e9 e7 00 00 00       	jmp    802424 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  80233d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802340:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802343:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80234a:	a1 40 50 80 00       	mov    0x805040,%eax
  80234f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802352:	e9 9d 00 00 00       	jmp    8023f4 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802357:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80235a:	8b 00                	mov    (%eax),%eax
  80235c:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  80235f:	8b 45 08             	mov    0x8(%ebp),%eax
  802362:	8b 50 08             	mov    0x8(%eax),%edx
  802365:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802368:	8b 40 08             	mov    0x8(%eax),%eax
  80236b:	39 c2                	cmp    %eax,%edx
  80236d:	76 7d                	jbe    8023ec <insert_sorted_allocList+0x251>
  80236f:	8b 45 08             	mov    0x8(%ebp),%eax
  802372:	8b 50 08             	mov    0x8(%eax),%edx
  802375:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802378:	8b 40 08             	mov    0x8(%eax),%eax
  80237b:	39 c2                	cmp    %eax,%edx
  80237d:	73 6d                	jae    8023ec <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  80237f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802383:	74 06                	je     80238b <insert_sorted_allocList+0x1f0>
  802385:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802389:	75 14                	jne    80239f <insert_sorted_allocList+0x204>
  80238b:	83 ec 04             	sub    $0x4,%esp
  80238e:	68 7c 42 80 00       	push   $0x80427c
  802393:	6a 7f                	push   $0x7f
  802395:	68 07 42 80 00       	push   $0x804207
  80239a:	e8 fa e0 ff ff       	call   800499 <_panic>
  80239f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a2:	8b 10                	mov    (%eax),%edx
  8023a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a7:	89 10                	mov    %edx,(%eax)
  8023a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ac:	8b 00                	mov    (%eax),%eax
  8023ae:	85 c0                	test   %eax,%eax
  8023b0:	74 0b                	je     8023bd <insert_sorted_allocList+0x222>
  8023b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b5:	8b 00                	mov    (%eax),%eax
  8023b7:	8b 55 08             	mov    0x8(%ebp),%edx
  8023ba:	89 50 04             	mov    %edx,0x4(%eax)
  8023bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c0:	8b 55 08             	mov    0x8(%ebp),%edx
  8023c3:	89 10                	mov    %edx,(%eax)
  8023c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023cb:	89 50 04             	mov    %edx,0x4(%eax)
  8023ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d1:	8b 00                	mov    (%eax),%eax
  8023d3:	85 c0                	test   %eax,%eax
  8023d5:	75 08                	jne    8023df <insert_sorted_allocList+0x244>
  8023d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8023da:	a3 44 50 80 00       	mov    %eax,0x805044
  8023df:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8023e4:	40                   	inc    %eax
  8023e5:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  8023ea:	eb 39                	jmp    802425 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8023ec:	a1 48 50 80 00       	mov    0x805048,%eax
  8023f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023f4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023f8:	74 07                	je     802401 <insert_sorted_allocList+0x266>
  8023fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023fd:	8b 00                	mov    (%eax),%eax
  8023ff:	eb 05                	jmp    802406 <insert_sorted_allocList+0x26b>
  802401:	b8 00 00 00 00       	mov    $0x0,%eax
  802406:	a3 48 50 80 00       	mov    %eax,0x805048
  80240b:	a1 48 50 80 00       	mov    0x805048,%eax
  802410:	85 c0                	test   %eax,%eax
  802412:	0f 85 3f ff ff ff    	jne    802357 <insert_sorted_allocList+0x1bc>
  802418:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80241c:	0f 85 35 ff ff ff    	jne    802357 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802422:	eb 01                	jmp    802425 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802424:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802425:	90                   	nop
  802426:	c9                   	leave  
  802427:	c3                   	ret    

00802428 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802428:	55                   	push   %ebp
  802429:	89 e5                	mov    %esp,%ebp
  80242b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  80242e:	a1 38 51 80 00       	mov    0x805138,%eax
  802433:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802436:	e9 85 01 00 00       	jmp    8025c0 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  80243b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243e:	8b 40 0c             	mov    0xc(%eax),%eax
  802441:	3b 45 08             	cmp    0x8(%ebp),%eax
  802444:	0f 82 6e 01 00 00    	jb     8025b8 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  80244a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244d:	8b 40 0c             	mov    0xc(%eax),%eax
  802450:	3b 45 08             	cmp    0x8(%ebp),%eax
  802453:	0f 85 8a 00 00 00    	jne    8024e3 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802459:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80245d:	75 17                	jne    802476 <alloc_block_FF+0x4e>
  80245f:	83 ec 04             	sub    $0x4,%esp
  802462:	68 b0 42 80 00       	push   $0x8042b0
  802467:	68 93 00 00 00       	push   $0x93
  80246c:	68 07 42 80 00       	push   $0x804207
  802471:	e8 23 e0 ff ff       	call   800499 <_panic>
  802476:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802479:	8b 00                	mov    (%eax),%eax
  80247b:	85 c0                	test   %eax,%eax
  80247d:	74 10                	je     80248f <alloc_block_FF+0x67>
  80247f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802482:	8b 00                	mov    (%eax),%eax
  802484:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802487:	8b 52 04             	mov    0x4(%edx),%edx
  80248a:	89 50 04             	mov    %edx,0x4(%eax)
  80248d:	eb 0b                	jmp    80249a <alloc_block_FF+0x72>
  80248f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802492:	8b 40 04             	mov    0x4(%eax),%eax
  802495:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80249a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249d:	8b 40 04             	mov    0x4(%eax),%eax
  8024a0:	85 c0                	test   %eax,%eax
  8024a2:	74 0f                	je     8024b3 <alloc_block_FF+0x8b>
  8024a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a7:	8b 40 04             	mov    0x4(%eax),%eax
  8024aa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024ad:	8b 12                	mov    (%edx),%edx
  8024af:	89 10                	mov    %edx,(%eax)
  8024b1:	eb 0a                	jmp    8024bd <alloc_block_FF+0x95>
  8024b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b6:	8b 00                	mov    (%eax),%eax
  8024b8:	a3 38 51 80 00       	mov    %eax,0x805138
  8024bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024d0:	a1 44 51 80 00       	mov    0x805144,%eax
  8024d5:	48                   	dec    %eax
  8024d6:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  8024db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024de:	e9 10 01 00 00       	jmp    8025f3 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  8024e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e6:	8b 40 0c             	mov    0xc(%eax),%eax
  8024e9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024ec:	0f 86 c6 00 00 00    	jbe    8025b8 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8024f2:	a1 48 51 80 00       	mov    0x805148,%eax
  8024f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  8024fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024fd:	8b 50 08             	mov    0x8(%eax),%edx
  802500:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802503:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802506:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802509:	8b 55 08             	mov    0x8(%ebp),%edx
  80250c:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80250f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802513:	75 17                	jne    80252c <alloc_block_FF+0x104>
  802515:	83 ec 04             	sub    $0x4,%esp
  802518:	68 b0 42 80 00       	push   $0x8042b0
  80251d:	68 9b 00 00 00       	push   $0x9b
  802522:	68 07 42 80 00       	push   $0x804207
  802527:	e8 6d df ff ff       	call   800499 <_panic>
  80252c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80252f:	8b 00                	mov    (%eax),%eax
  802531:	85 c0                	test   %eax,%eax
  802533:	74 10                	je     802545 <alloc_block_FF+0x11d>
  802535:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802538:	8b 00                	mov    (%eax),%eax
  80253a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80253d:	8b 52 04             	mov    0x4(%edx),%edx
  802540:	89 50 04             	mov    %edx,0x4(%eax)
  802543:	eb 0b                	jmp    802550 <alloc_block_FF+0x128>
  802545:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802548:	8b 40 04             	mov    0x4(%eax),%eax
  80254b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802550:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802553:	8b 40 04             	mov    0x4(%eax),%eax
  802556:	85 c0                	test   %eax,%eax
  802558:	74 0f                	je     802569 <alloc_block_FF+0x141>
  80255a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80255d:	8b 40 04             	mov    0x4(%eax),%eax
  802560:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802563:	8b 12                	mov    (%edx),%edx
  802565:	89 10                	mov    %edx,(%eax)
  802567:	eb 0a                	jmp    802573 <alloc_block_FF+0x14b>
  802569:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80256c:	8b 00                	mov    (%eax),%eax
  80256e:	a3 48 51 80 00       	mov    %eax,0x805148
  802573:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802576:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80257c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80257f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802586:	a1 54 51 80 00       	mov    0x805154,%eax
  80258b:	48                   	dec    %eax
  80258c:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802591:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802594:	8b 50 08             	mov    0x8(%eax),%edx
  802597:	8b 45 08             	mov    0x8(%ebp),%eax
  80259a:	01 c2                	add    %eax,%edx
  80259c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259f:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  8025a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a5:	8b 40 0c             	mov    0xc(%eax),%eax
  8025a8:	2b 45 08             	sub    0x8(%ebp),%eax
  8025ab:	89 c2                	mov    %eax,%edx
  8025ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b0:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  8025b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025b6:	eb 3b                	jmp    8025f3 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8025b8:	a1 40 51 80 00       	mov    0x805140,%eax
  8025bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025c0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025c4:	74 07                	je     8025cd <alloc_block_FF+0x1a5>
  8025c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c9:	8b 00                	mov    (%eax),%eax
  8025cb:	eb 05                	jmp    8025d2 <alloc_block_FF+0x1aa>
  8025cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8025d2:	a3 40 51 80 00       	mov    %eax,0x805140
  8025d7:	a1 40 51 80 00       	mov    0x805140,%eax
  8025dc:	85 c0                	test   %eax,%eax
  8025de:	0f 85 57 fe ff ff    	jne    80243b <alloc_block_FF+0x13>
  8025e4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025e8:	0f 85 4d fe ff ff    	jne    80243b <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  8025ee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025f3:	c9                   	leave  
  8025f4:	c3                   	ret    

008025f5 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8025f5:	55                   	push   %ebp
  8025f6:	89 e5                	mov    %esp,%ebp
  8025f8:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  8025fb:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802602:	a1 38 51 80 00       	mov    0x805138,%eax
  802607:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80260a:	e9 df 00 00 00       	jmp    8026ee <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  80260f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802612:	8b 40 0c             	mov    0xc(%eax),%eax
  802615:	3b 45 08             	cmp    0x8(%ebp),%eax
  802618:	0f 82 c8 00 00 00    	jb     8026e6 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  80261e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802621:	8b 40 0c             	mov    0xc(%eax),%eax
  802624:	3b 45 08             	cmp    0x8(%ebp),%eax
  802627:	0f 85 8a 00 00 00    	jne    8026b7 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  80262d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802631:	75 17                	jne    80264a <alloc_block_BF+0x55>
  802633:	83 ec 04             	sub    $0x4,%esp
  802636:	68 b0 42 80 00       	push   $0x8042b0
  80263b:	68 b7 00 00 00       	push   $0xb7
  802640:	68 07 42 80 00       	push   $0x804207
  802645:	e8 4f de ff ff       	call   800499 <_panic>
  80264a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264d:	8b 00                	mov    (%eax),%eax
  80264f:	85 c0                	test   %eax,%eax
  802651:	74 10                	je     802663 <alloc_block_BF+0x6e>
  802653:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802656:	8b 00                	mov    (%eax),%eax
  802658:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80265b:	8b 52 04             	mov    0x4(%edx),%edx
  80265e:	89 50 04             	mov    %edx,0x4(%eax)
  802661:	eb 0b                	jmp    80266e <alloc_block_BF+0x79>
  802663:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802666:	8b 40 04             	mov    0x4(%eax),%eax
  802669:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80266e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802671:	8b 40 04             	mov    0x4(%eax),%eax
  802674:	85 c0                	test   %eax,%eax
  802676:	74 0f                	je     802687 <alloc_block_BF+0x92>
  802678:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267b:	8b 40 04             	mov    0x4(%eax),%eax
  80267e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802681:	8b 12                	mov    (%edx),%edx
  802683:	89 10                	mov    %edx,(%eax)
  802685:	eb 0a                	jmp    802691 <alloc_block_BF+0x9c>
  802687:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268a:	8b 00                	mov    (%eax),%eax
  80268c:	a3 38 51 80 00       	mov    %eax,0x805138
  802691:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802694:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80269a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026a4:	a1 44 51 80 00       	mov    0x805144,%eax
  8026a9:	48                   	dec    %eax
  8026aa:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  8026af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b2:	e9 4d 01 00 00       	jmp    802804 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  8026b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ba:	8b 40 0c             	mov    0xc(%eax),%eax
  8026bd:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026c0:	76 24                	jbe    8026e6 <alloc_block_BF+0xf1>
  8026c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c5:	8b 40 0c             	mov    0xc(%eax),%eax
  8026c8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8026cb:	73 19                	jae    8026e6 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  8026cd:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  8026d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d7:	8b 40 0c             	mov    0xc(%eax),%eax
  8026da:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  8026dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e0:	8b 40 08             	mov    0x8(%eax),%eax
  8026e3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8026e6:	a1 40 51 80 00       	mov    0x805140,%eax
  8026eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026ee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026f2:	74 07                	je     8026fb <alloc_block_BF+0x106>
  8026f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f7:	8b 00                	mov    (%eax),%eax
  8026f9:	eb 05                	jmp    802700 <alloc_block_BF+0x10b>
  8026fb:	b8 00 00 00 00       	mov    $0x0,%eax
  802700:	a3 40 51 80 00       	mov    %eax,0x805140
  802705:	a1 40 51 80 00       	mov    0x805140,%eax
  80270a:	85 c0                	test   %eax,%eax
  80270c:	0f 85 fd fe ff ff    	jne    80260f <alloc_block_BF+0x1a>
  802712:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802716:	0f 85 f3 fe ff ff    	jne    80260f <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  80271c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802720:	0f 84 d9 00 00 00    	je     8027ff <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802726:	a1 48 51 80 00       	mov    0x805148,%eax
  80272b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  80272e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802731:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802734:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802737:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80273a:	8b 55 08             	mov    0x8(%ebp),%edx
  80273d:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802740:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802744:	75 17                	jne    80275d <alloc_block_BF+0x168>
  802746:	83 ec 04             	sub    $0x4,%esp
  802749:	68 b0 42 80 00       	push   $0x8042b0
  80274e:	68 c7 00 00 00       	push   $0xc7
  802753:	68 07 42 80 00       	push   $0x804207
  802758:	e8 3c dd ff ff       	call   800499 <_panic>
  80275d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802760:	8b 00                	mov    (%eax),%eax
  802762:	85 c0                	test   %eax,%eax
  802764:	74 10                	je     802776 <alloc_block_BF+0x181>
  802766:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802769:	8b 00                	mov    (%eax),%eax
  80276b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80276e:	8b 52 04             	mov    0x4(%edx),%edx
  802771:	89 50 04             	mov    %edx,0x4(%eax)
  802774:	eb 0b                	jmp    802781 <alloc_block_BF+0x18c>
  802776:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802779:	8b 40 04             	mov    0x4(%eax),%eax
  80277c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802781:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802784:	8b 40 04             	mov    0x4(%eax),%eax
  802787:	85 c0                	test   %eax,%eax
  802789:	74 0f                	je     80279a <alloc_block_BF+0x1a5>
  80278b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80278e:	8b 40 04             	mov    0x4(%eax),%eax
  802791:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802794:	8b 12                	mov    (%edx),%edx
  802796:	89 10                	mov    %edx,(%eax)
  802798:	eb 0a                	jmp    8027a4 <alloc_block_BF+0x1af>
  80279a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80279d:	8b 00                	mov    (%eax),%eax
  80279f:	a3 48 51 80 00       	mov    %eax,0x805148
  8027a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027a7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027b0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027b7:	a1 54 51 80 00       	mov    0x805154,%eax
  8027bc:	48                   	dec    %eax
  8027bd:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  8027c2:	83 ec 08             	sub    $0x8,%esp
  8027c5:	ff 75 ec             	pushl  -0x14(%ebp)
  8027c8:	68 38 51 80 00       	push   $0x805138
  8027cd:	e8 71 f9 ff ff       	call   802143 <find_block>
  8027d2:	83 c4 10             	add    $0x10,%esp
  8027d5:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  8027d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027db:	8b 50 08             	mov    0x8(%eax),%edx
  8027de:	8b 45 08             	mov    0x8(%ebp),%eax
  8027e1:	01 c2                	add    %eax,%edx
  8027e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027e6:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  8027e9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027ec:	8b 40 0c             	mov    0xc(%eax),%eax
  8027ef:	2b 45 08             	sub    0x8(%ebp),%eax
  8027f2:	89 c2                	mov    %eax,%edx
  8027f4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027f7:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  8027fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027fd:	eb 05                	jmp    802804 <alloc_block_BF+0x20f>
	}
	return NULL;
  8027ff:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802804:	c9                   	leave  
  802805:	c3                   	ret    

00802806 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802806:	55                   	push   %ebp
  802807:	89 e5                	mov    %esp,%ebp
  802809:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  80280c:	a1 28 50 80 00       	mov    0x805028,%eax
  802811:	85 c0                	test   %eax,%eax
  802813:	0f 85 de 01 00 00    	jne    8029f7 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802819:	a1 38 51 80 00       	mov    0x805138,%eax
  80281e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802821:	e9 9e 01 00 00       	jmp    8029c4 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802826:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802829:	8b 40 0c             	mov    0xc(%eax),%eax
  80282c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80282f:	0f 82 87 01 00 00    	jb     8029bc <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802835:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802838:	8b 40 0c             	mov    0xc(%eax),%eax
  80283b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80283e:	0f 85 95 00 00 00    	jne    8028d9 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802844:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802848:	75 17                	jne    802861 <alloc_block_NF+0x5b>
  80284a:	83 ec 04             	sub    $0x4,%esp
  80284d:	68 b0 42 80 00       	push   $0x8042b0
  802852:	68 e0 00 00 00       	push   $0xe0
  802857:	68 07 42 80 00       	push   $0x804207
  80285c:	e8 38 dc ff ff       	call   800499 <_panic>
  802861:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802864:	8b 00                	mov    (%eax),%eax
  802866:	85 c0                	test   %eax,%eax
  802868:	74 10                	je     80287a <alloc_block_NF+0x74>
  80286a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286d:	8b 00                	mov    (%eax),%eax
  80286f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802872:	8b 52 04             	mov    0x4(%edx),%edx
  802875:	89 50 04             	mov    %edx,0x4(%eax)
  802878:	eb 0b                	jmp    802885 <alloc_block_NF+0x7f>
  80287a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287d:	8b 40 04             	mov    0x4(%eax),%eax
  802880:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802885:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802888:	8b 40 04             	mov    0x4(%eax),%eax
  80288b:	85 c0                	test   %eax,%eax
  80288d:	74 0f                	je     80289e <alloc_block_NF+0x98>
  80288f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802892:	8b 40 04             	mov    0x4(%eax),%eax
  802895:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802898:	8b 12                	mov    (%edx),%edx
  80289a:	89 10                	mov    %edx,(%eax)
  80289c:	eb 0a                	jmp    8028a8 <alloc_block_NF+0xa2>
  80289e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a1:	8b 00                	mov    (%eax),%eax
  8028a3:	a3 38 51 80 00       	mov    %eax,0x805138
  8028a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ab:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028bb:	a1 44 51 80 00       	mov    0x805144,%eax
  8028c0:	48                   	dec    %eax
  8028c1:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  8028c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c9:	8b 40 08             	mov    0x8(%eax),%eax
  8028cc:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  8028d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d4:	e9 f8 04 00 00       	jmp    802dd1 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  8028d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028dc:	8b 40 0c             	mov    0xc(%eax),%eax
  8028df:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028e2:	0f 86 d4 00 00 00    	jbe    8029bc <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8028e8:	a1 48 51 80 00       	mov    0x805148,%eax
  8028ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  8028f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f3:	8b 50 08             	mov    0x8(%eax),%edx
  8028f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028f9:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  8028fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028ff:	8b 55 08             	mov    0x8(%ebp),%edx
  802902:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802905:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802909:	75 17                	jne    802922 <alloc_block_NF+0x11c>
  80290b:	83 ec 04             	sub    $0x4,%esp
  80290e:	68 b0 42 80 00       	push   $0x8042b0
  802913:	68 e9 00 00 00       	push   $0xe9
  802918:	68 07 42 80 00       	push   $0x804207
  80291d:	e8 77 db ff ff       	call   800499 <_panic>
  802922:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802925:	8b 00                	mov    (%eax),%eax
  802927:	85 c0                	test   %eax,%eax
  802929:	74 10                	je     80293b <alloc_block_NF+0x135>
  80292b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80292e:	8b 00                	mov    (%eax),%eax
  802930:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802933:	8b 52 04             	mov    0x4(%edx),%edx
  802936:	89 50 04             	mov    %edx,0x4(%eax)
  802939:	eb 0b                	jmp    802946 <alloc_block_NF+0x140>
  80293b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80293e:	8b 40 04             	mov    0x4(%eax),%eax
  802941:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802946:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802949:	8b 40 04             	mov    0x4(%eax),%eax
  80294c:	85 c0                	test   %eax,%eax
  80294e:	74 0f                	je     80295f <alloc_block_NF+0x159>
  802950:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802953:	8b 40 04             	mov    0x4(%eax),%eax
  802956:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802959:	8b 12                	mov    (%edx),%edx
  80295b:	89 10                	mov    %edx,(%eax)
  80295d:	eb 0a                	jmp    802969 <alloc_block_NF+0x163>
  80295f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802962:	8b 00                	mov    (%eax),%eax
  802964:	a3 48 51 80 00       	mov    %eax,0x805148
  802969:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80296c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802972:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802975:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80297c:	a1 54 51 80 00       	mov    0x805154,%eax
  802981:	48                   	dec    %eax
  802982:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802987:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80298a:	8b 40 08             	mov    0x8(%eax),%eax
  80298d:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802992:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802995:	8b 50 08             	mov    0x8(%eax),%edx
  802998:	8b 45 08             	mov    0x8(%ebp),%eax
  80299b:	01 c2                	add    %eax,%edx
  80299d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a0:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  8029a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a6:	8b 40 0c             	mov    0xc(%eax),%eax
  8029a9:	2b 45 08             	sub    0x8(%ebp),%eax
  8029ac:	89 c2                	mov    %eax,%edx
  8029ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b1:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  8029b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029b7:	e9 15 04 00 00       	jmp    802dd1 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8029bc:	a1 40 51 80 00       	mov    0x805140,%eax
  8029c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029c4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029c8:	74 07                	je     8029d1 <alloc_block_NF+0x1cb>
  8029ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029cd:	8b 00                	mov    (%eax),%eax
  8029cf:	eb 05                	jmp    8029d6 <alloc_block_NF+0x1d0>
  8029d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8029d6:	a3 40 51 80 00       	mov    %eax,0x805140
  8029db:	a1 40 51 80 00       	mov    0x805140,%eax
  8029e0:	85 c0                	test   %eax,%eax
  8029e2:	0f 85 3e fe ff ff    	jne    802826 <alloc_block_NF+0x20>
  8029e8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029ec:	0f 85 34 fe ff ff    	jne    802826 <alloc_block_NF+0x20>
  8029f2:	e9 d5 03 00 00       	jmp    802dcc <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8029f7:	a1 38 51 80 00       	mov    0x805138,%eax
  8029fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029ff:	e9 b1 01 00 00       	jmp    802bb5 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802a04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a07:	8b 50 08             	mov    0x8(%eax),%edx
  802a0a:	a1 28 50 80 00       	mov    0x805028,%eax
  802a0f:	39 c2                	cmp    %eax,%edx
  802a11:	0f 82 96 01 00 00    	jb     802bad <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802a17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1a:	8b 40 0c             	mov    0xc(%eax),%eax
  802a1d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a20:	0f 82 87 01 00 00    	jb     802bad <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802a26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a29:	8b 40 0c             	mov    0xc(%eax),%eax
  802a2c:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a2f:	0f 85 95 00 00 00    	jne    802aca <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802a35:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a39:	75 17                	jne    802a52 <alloc_block_NF+0x24c>
  802a3b:	83 ec 04             	sub    $0x4,%esp
  802a3e:	68 b0 42 80 00       	push   $0x8042b0
  802a43:	68 fc 00 00 00       	push   $0xfc
  802a48:	68 07 42 80 00       	push   $0x804207
  802a4d:	e8 47 da ff ff       	call   800499 <_panic>
  802a52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a55:	8b 00                	mov    (%eax),%eax
  802a57:	85 c0                	test   %eax,%eax
  802a59:	74 10                	je     802a6b <alloc_block_NF+0x265>
  802a5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5e:	8b 00                	mov    (%eax),%eax
  802a60:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a63:	8b 52 04             	mov    0x4(%edx),%edx
  802a66:	89 50 04             	mov    %edx,0x4(%eax)
  802a69:	eb 0b                	jmp    802a76 <alloc_block_NF+0x270>
  802a6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6e:	8b 40 04             	mov    0x4(%eax),%eax
  802a71:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802a76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a79:	8b 40 04             	mov    0x4(%eax),%eax
  802a7c:	85 c0                	test   %eax,%eax
  802a7e:	74 0f                	je     802a8f <alloc_block_NF+0x289>
  802a80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a83:	8b 40 04             	mov    0x4(%eax),%eax
  802a86:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a89:	8b 12                	mov    (%edx),%edx
  802a8b:	89 10                	mov    %edx,(%eax)
  802a8d:	eb 0a                	jmp    802a99 <alloc_block_NF+0x293>
  802a8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a92:	8b 00                	mov    (%eax),%eax
  802a94:	a3 38 51 80 00       	mov    %eax,0x805138
  802a99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802aa2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802aac:	a1 44 51 80 00       	mov    0x805144,%eax
  802ab1:	48                   	dec    %eax
  802ab2:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802ab7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aba:	8b 40 08             	mov    0x8(%eax),%eax
  802abd:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802ac2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac5:	e9 07 03 00 00       	jmp    802dd1 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802aca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802acd:	8b 40 0c             	mov    0xc(%eax),%eax
  802ad0:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ad3:	0f 86 d4 00 00 00    	jbe    802bad <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802ad9:	a1 48 51 80 00       	mov    0x805148,%eax
  802ade:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802ae1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae4:	8b 50 08             	mov    0x8(%eax),%edx
  802ae7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802aea:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802aed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802af0:	8b 55 08             	mov    0x8(%ebp),%edx
  802af3:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802af6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802afa:	75 17                	jne    802b13 <alloc_block_NF+0x30d>
  802afc:	83 ec 04             	sub    $0x4,%esp
  802aff:	68 b0 42 80 00       	push   $0x8042b0
  802b04:	68 04 01 00 00       	push   $0x104
  802b09:	68 07 42 80 00       	push   $0x804207
  802b0e:	e8 86 d9 ff ff       	call   800499 <_panic>
  802b13:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b16:	8b 00                	mov    (%eax),%eax
  802b18:	85 c0                	test   %eax,%eax
  802b1a:	74 10                	je     802b2c <alloc_block_NF+0x326>
  802b1c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b1f:	8b 00                	mov    (%eax),%eax
  802b21:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b24:	8b 52 04             	mov    0x4(%edx),%edx
  802b27:	89 50 04             	mov    %edx,0x4(%eax)
  802b2a:	eb 0b                	jmp    802b37 <alloc_block_NF+0x331>
  802b2c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b2f:	8b 40 04             	mov    0x4(%eax),%eax
  802b32:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b37:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b3a:	8b 40 04             	mov    0x4(%eax),%eax
  802b3d:	85 c0                	test   %eax,%eax
  802b3f:	74 0f                	je     802b50 <alloc_block_NF+0x34a>
  802b41:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b44:	8b 40 04             	mov    0x4(%eax),%eax
  802b47:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b4a:	8b 12                	mov    (%edx),%edx
  802b4c:	89 10                	mov    %edx,(%eax)
  802b4e:	eb 0a                	jmp    802b5a <alloc_block_NF+0x354>
  802b50:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b53:	8b 00                	mov    (%eax),%eax
  802b55:	a3 48 51 80 00       	mov    %eax,0x805148
  802b5a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b5d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b63:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b66:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b6d:	a1 54 51 80 00       	mov    0x805154,%eax
  802b72:	48                   	dec    %eax
  802b73:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802b78:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b7b:	8b 40 08             	mov    0x8(%eax),%eax
  802b7e:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802b83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b86:	8b 50 08             	mov    0x8(%eax),%edx
  802b89:	8b 45 08             	mov    0x8(%ebp),%eax
  802b8c:	01 c2                	add    %eax,%edx
  802b8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b91:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802b94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b97:	8b 40 0c             	mov    0xc(%eax),%eax
  802b9a:	2b 45 08             	sub    0x8(%ebp),%eax
  802b9d:	89 c2                	mov    %eax,%edx
  802b9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba2:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802ba5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ba8:	e9 24 02 00 00       	jmp    802dd1 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802bad:	a1 40 51 80 00       	mov    0x805140,%eax
  802bb2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bb5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bb9:	74 07                	je     802bc2 <alloc_block_NF+0x3bc>
  802bbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bbe:	8b 00                	mov    (%eax),%eax
  802bc0:	eb 05                	jmp    802bc7 <alloc_block_NF+0x3c1>
  802bc2:	b8 00 00 00 00       	mov    $0x0,%eax
  802bc7:	a3 40 51 80 00       	mov    %eax,0x805140
  802bcc:	a1 40 51 80 00       	mov    0x805140,%eax
  802bd1:	85 c0                	test   %eax,%eax
  802bd3:	0f 85 2b fe ff ff    	jne    802a04 <alloc_block_NF+0x1fe>
  802bd9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bdd:	0f 85 21 fe ff ff    	jne    802a04 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802be3:	a1 38 51 80 00       	mov    0x805138,%eax
  802be8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802beb:	e9 ae 01 00 00       	jmp    802d9e <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802bf0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf3:	8b 50 08             	mov    0x8(%eax),%edx
  802bf6:	a1 28 50 80 00       	mov    0x805028,%eax
  802bfb:	39 c2                	cmp    %eax,%edx
  802bfd:	0f 83 93 01 00 00    	jae    802d96 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802c03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c06:	8b 40 0c             	mov    0xc(%eax),%eax
  802c09:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c0c:	0f 82 84 01 00 00    	jb     802d96 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802c12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c15:	8b 40 0c             	mov    0xc(%eax),%eax
  802c18:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c1b:	0f 85 95 00 00 00    	jne    802cb6 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802c21:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c25:	75 17                	jne    802c3e <alloc_block_NF+0x438>
  802c27:	83 ec 04             	sub    $0x4,%esp
  802c2a:	68 b0 42 80 00       	push   $0x8042b0
  802c2f:	68 14 01 00 00       	push   $0x114
  802c34:	68 07 42 80 00       	push   $0x804207
  802c39:	e8 5b d8 ff ff       	call   800499 <_panic>
  802c3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c41:	8b 00                	mov    (%eax),%eax
  802c43:	85 c0                	test   %eax,%eax
  802c45:	74 10                	je     802c57 <alloc_block_NF+0x451>
  802c47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4a:	8b 00                	mov    (%eax),%eax
  802c4c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c4f:	8b 52 04             	mov    0x4(%edx),%edx
  802c52:	89 50 04             	mov    %edx,0x4(%eax)
  802c55:	eb 0b                	jmp    802c62 <alloc_block_NF+0x45c>
  802c57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c5a:	8b 40 04             	mov    0x4(%eax),%eax
  802c5d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c65:	8b 40 04             	mov    0x4(%eax),%eax
  802c68:	85 c0                	test   %eax,%eax
  802c6a:	74 0f                	je     802c7b <alloc_block_NF+0x475>
  802c6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c6f:	8b 40 04             	mov    0x4(%eax),%eax
  802c72:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c75:	8b 12                	mov    (%edx),%edx
  802c77:	89 10                	mov    %edx,(%eax)
  802c79:	eb 0a                	jmp    802c85 <alloc_block_NF+0x47f>
  802c7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c7e:	8b 00                	mov    (%eax),%eax
  802c80:	a3 38 51 80 00       	mov    %eax,0x805138
  802c85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c88:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c91:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c98:	a1 44 51 80 00       	mov    0x805144,%eax
  802c9d:	48                   	dec    %eax
  802c9e:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802ca3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca6:	8b 40 08             	mov    0x8(%eax),%eax
  802ca9:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802cae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb1:	e9 1b 01 00 00       	jmp    802dd1 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802cb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb9:	8b 40 0c             	mov    0xc(%eax),%eax
  802cbc:	3b 45 08             	cmp    0x8(%ebp),%eax
  802cbf:	0f 86 d1 00 00 00    	jbe    802d96 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802cc5:	a1 48 51 80 00       	mov    0x805148,%eax
  802cca:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802ccd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd0:	8b 50 08             	mov    0x8(%eax),%edx
  802cd3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cd6:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802cd9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cdc:	8b 55 08             	mov    0x8(%ebp),%edx
  802cdf:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802ce2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802ce6:	75 17                	jne    802cff <alloc_block_NF+0x4f9>
  802ce8:	83 ec 04             	sub    $0x4,%esp
  802ceb:	68 b0 42 80 00       	push   $0x8042b0
  802cf0:	68 1c 01 00 00       	push   $0x11c
  802cf5:	68 07 42 80 00       	push   $0x804207
  802cfa:	e8 9a d7 ff ff       	call   800499 <_panic>
  802cff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d02:	8b 00                	mov    (%eax),%eax
  802d04:	85 c0                	test   %eax,%eax
  802d06:	74 10                	je     802d18 <alloc_block_NF+0x512>
  802d08:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d0b:	8b 00                	mov    (%eax),%eax
  802d0d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d10:	8b 52 04             	mov    0x4(%edx),%edx
  802d13:	89 50 04             	mov    %edx,0x4(%eax)
  802d16:	eb 0b                	jmp    802d23 <alloc_block_NF+0x51d>
  802d18:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d1b:	8b 40 04             	mov    0x4(%eax),%eax
  802d1e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d23:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d26:	8b 40 04             	mov    0x4(%eax),%eax
  802d29:	85 c0                	test   %eax,%eax
  802d2b:	74 0f                	je     802d3c <alloc_block_NF+0x536>
  802d2d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d30:	8b 40 04             	mov    0x4(%eax),%eax
  802d33:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d36:	8b 12                	mov    (%edx),%edx
  802d38:	89 10                	mov    %edx,(%eax)
  802d3a:	eb 0a                	jmp    802d46 <alloc_block_NF+0x540>
  802d3c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d3f:	8b 00                	mov    (%eax),%eax
  802d41:	a3 48 51 80 00       	mov    %eax,0x805148
  802d46:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d49:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d4f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d52:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d59:	a1 54 51 80 00       	mov    0x805154,%eax
  802d5e:	48                   	dec    %eax
  802d5f:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802d64:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d67:	8b 40 08             	mov    0x8(%eax),%eax
  802d6a:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802d6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d72:	8b 50 08             	mov    0x8(%eax),%edx
  802d75:	8b 45 08             	mov    0x8(%ebp),%eax
  802d78:	01 c2                	add    %eax,%edx
  802d7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d7d:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802d80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d83:	8b 40 0c             	mov    0xc(%eax),%eax
  802d86:	2b 45 08             	sub    0x8(%ebp),%eax
  802d89:	89 c2                	mov    %eax,%edx
  802d8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d8e:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802d91:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d94:	eb 3b                	jmp    802dd1 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802d96:	a1 40 51 80 00       	mov    0x805140,%eax
  802d9b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d9e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802da2:	74 07                	je     802dab <alloc_block_NF+0x5a5>
  802da4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da7:	8b 00                	mov    (%eax),%eax
  802da9:	eb 05                	jmp    802db0 <alloc_block_NF+0x5aa>
  802dab:	b8 00 00 00 00       	mov    $0x0,%eax
  802db0:	a3 40 51 80 00       	mov    %eax,0x805140
  802db5:	a1 40 51 80 00       	mov    0x805140,%eax
  802dba:	85 c0                	test   %eax,%eax
  802dbc:	0f 85 2e fe ff ff    	jne    802bf0 <alloc_block_NF+0x3ea>
  802dc2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dc6:	0f 85 24 fe ff ff    	jne    802bf0 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802dcc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802dd1:	c9                   	leave  
  802dd2:	c3                   	ret    

00802dd3 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802dd3:	55                   	push   %ebp
  802dd4:	89 e5                	mov    %esp,%ebp
  802dd6:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802dd9:	a1 38 51 80 00       	mov    0x805138,%eax
  802dde:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802de1:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802de6:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802de9:	a1 38 51 80 00       	mov    0x805138,%eax
  802dee:	85 c0                	test   %eax,%eax
  802df0:	74 14                	je     802e06 <insert_sorted_with_merge_freeList+0x33>
  802df2:	8b 45 08             	mov    0x8(%ebp),%eax
  802df5:	8b 50 08             	mov    0x8(%eax),%edx
  802df8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dfb:	8b 40 08             	mov    0x8(%eax),%eax
  802dfe:	39 c2                	cmp    %eax,%edx
  802e00:	0f 87 9b 01 00 00    	ja     802fa1 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802e06:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e0a:	75 17                	jne    802e23 <insert_sorted_with_merge_freeList+0x50>
  802e0c:	83 ec 04             	sub    $0x4,%esp
  802e0f:	68 e4 41 80 00       	push   $0x8041e4
  802e14:	68 38 01 00 00       	push   $0x138
  802e19:	68 07 42 80 00       	push   $0x804207
  802e1e:	e8 76 d6 ff ff       	call   800499 <_panic>
  802e23:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802e29:	8b 45 08             	mov    0x8(%ebp),%eax
  802e2c:	89 10                	mov    %edx,(%eax)
  802e2e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e31:	8b 00                	mov    (%eax),%eax
  802e33:	85 c0                	test   %eax,%eax
  802e35:	74 0d                	je     802e44 <insert_sorted_with_merge_freeList+0x71>
  802e37:	a1 38 51 80 00       	mov    0x805138,%eax
  802e3c:	8b 55 08             	mov    0x8(%ebp),%edx
  802e3f:	89 50 04             	mov    %edx,0x4(%eax)
  802e42:	eb 08                	jmp    802e4c <insert_sorted_with_merge_freeList+0x79>
  802e44:	8b 45 08             	mov    0x8(%ebp),%eax
  802e47:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e4c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e4f:	a3 38 51 80 00       	mov    %eax,0x805138
  802e54:	8b 45 08             	mov    0x8(%ebp),%eax
  802e57:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e5e:	a1 44 51 80 00       	mov    0x805144,%eax
  802e63:	40                   	inc    %eax
  802e64:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802e69:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e6d:	0f 84 a8 06 00 00    	je     80351b <insert_sorted_with_merge_freeList+0x748>
  802e73:	8b 45 08             	mov    0x8(%ebp),%eax
  802e76:	8b 50 08             	mov    0x8(%eax),%edx
  802e79:	8b 45 08             	mov    0x8(%ebp),%eax
  802e7c:	8b 40 0c             	mov    0xc(%eax),%eax
  802e7f:	01 c2                	add    %eax,%edx
  802e81:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e84:	8b 40 08             	mov    0x8(%eax),%eax
  802e87:	39 c2                	cmp    %eax,%edx
  802e89:	0f 85 8c 06 00 00    	jne    80351b <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802e8f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e92:	8b 50 0c             	mov    0xc(%eax),%edx
  802e95:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e98:	8b 40 0c             	mov    0xc(%eax),%eax
  802e9b:	01 c2                	add    %eax,%edx
  802e9d:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea0:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802ea3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ea7:	75 17                	jne    802ec0 <insert_sorted_with_merge_freeList+0xed>
  802ea9:	83 ec 04             	sub    $0x4,%esp
  802eac:	68 b0 42 80 00       	push   $0x8042b0
  802eb1:	68 3c 01 00 00       	push   $0x13c
  802eb6:	68 07 42 80 00       	push   $0x804207
  802ebb:	e8 d9 d5 ff ff       	call   800499 <_panic>
  802ec0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ec3:	8b 00                	mov    (%eax),%eax
  802ec5:	85 c0                	test   %eax,%eax
  802ec7:	74 10                	je     802ed9 <insert_sorted_with_merge_freeList+0x106>
  802ec9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ecc:	8b 00                	mov    (%eax),%eax
  802ece:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ed1:	8b 52 04             	mov    0x4(%edx),%edx
  802ed4:	89 50 04             	mov    %edx,0x4(%eax)
  802ed7:	eb 0b                	jmp    802ee4 <insert_sorted_with_merge_freeList+0x111>
  802ed9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802edc:	8b 40 04             	mov    0x4(%eax),%eax
  802edf:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ee4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ee7:	8b 40 04             	mov    0x4(%eax),%eax
  802eea:	85 c0                	test   %eax,%eax
  802eec:	74 0f                	je     802efd <insert_sorted_with_merge_freeList+0x12a>
  802eee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ef1:	8b 40 04             	mov    0x4(%eax),%eax
  802ef4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ef7:	8b 12                	mov    (%edx),%edx
  802ef9:	89 10                	mov    %edx,(%eax)
  802efb:	eb 0a                	jmp    802f07 <insert_sorted_with_merge_freeList+0x134>
  802efd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f00:	8b 00                	mov    (%eax),%eax
  802f02:	a3 38 51 80 00       	mov    %eax,0x805138
  802f07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f0a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f10:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f13:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f1a:	a1 44 51 80 00       	mov    0x805144,%eax
  802f1f:	48                   	dec    %eax
  802f20:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802f25:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f28:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802f2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f32:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802f39:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f3d:	75 17                	jne    802f56 <insert_sorted_with_merge_freeList+0x183>
  802f3f:	83 ec 04             	sub    $0x4,%esp
  802f42:	68 e4 41 80 00       	push   $0x8041e4
  802f47:	68 3f 01 00 00       	push   $0x13f
  802f4c:	68 07 42 80 00       	push   $0x804207
  802f51:	e8 43 d5 ff ff       	call   800499 <_panic>
  802f56:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802f5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f5f:	89 10                	mov    %edx,(%eax)
  802f61:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f64:	8b 00                	mov    (%eax),%eax
  802f66:	85 c0                	test   %eax,%eax
  802f68:	74 0d                	je     802f77 <insert_sorted_with_merge_freeList+0x1a4>
  802f6a:	a1 48 51 80 00       	mov    0x805148,%eax
  802f6f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f72:	89 50 04             	mov    %edx,0x4(%eax)
  802f75:	eb 08                	jmp    802f7f <insert_sorted_with_merge_freeList+0x1ac>
  802f77:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f7a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f82:	a3 48 51 80 00       	mov    %eax,0x805148
  802f87:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f8a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f91:	a1 54 51 80 00       	mov    0x805154,%eax
  802f96:	40                   	inc    %eax
  802f97:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802f9c:	e9 7a 05 00 00       	jmp    80351b <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802fa1:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa4:	8b 50 08             	mov    0x8(%eax),%edx
  802fa7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802faa:	8b 40 08             	mov    0x8(%eax),%eax
  802fad:	39 c2                	cmp    %eax,%edx
  802faf:	0f 82 14 01 00 00    	jb     8030c9 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802fb5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fb8:	8b 50 08             	mov    0x8(%eax),%edx
  802fbb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fbe:	8b 40 0c             	mov    0xc(%eax),%eax
  802fc1:	01 c2                	add    %eax,%edx
  802fc3:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc6:	8b 40 08             	mov    0x8(%eax),%eax
  802fc9:	39 c2                	cmp    %eax,%edx
  802fcb:	0f 85 90 00 00 00    	jne    803061 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802fd1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fd4:	8b 50 0c             	mov    0xc(%eax),%edx
  802fd7:	8b 45 08             	mov    0x8(%ebp),%eax
  802fda:	8b 40 0c             	mov    0xc(%eax),%eax
  802fdd:	01 c2                	add    %eax,%edx
  802fdf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fe2:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802fe5:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe8:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802fef:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802ff9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ffd:	75 17                	jne    803016 <insert_sorted_with_merge_freeList+0x243>
  802fff:	83 ec 04             	sub    $0x4,%esp
  803002:	68 e4 41 80 00       	push   $0x8041e4
  803007:	68 49 01 00 00       	push   $0x149
  80300c:	68 07 42 80 00       	push   $0x804207
  803011:	e8 83 d4 ff ff       	call   800499 <_panic>
  803016:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80301c:	8b 45 08             	mov    0x8(%ebp),%eax
  80301f:	89 10                	mov    %edx,(%eax)
  803021:	8b 45 08             	mov    0x8(%ebp),%eax
  803024:	8b 00                	mov    (%eax),%eax
  803026:	85 c0                	test   %eax,%eax
  803028:	74 0d                	je     803037 <insert_sorted_with_merge_freeList+0x264>
  80302a:	a1 48 51 80 00       	mov    0x805148,%eax
  80302f:	8b 55 08             	mov    0x8(%ebp),%edx
  803032:	89 50 04             	mov    %edx,0x4(%eax)
  803035:	eb 08                	jmp    80303f <insert_sorted_with_merge_freeList+0x26c>
  803037:	8b 45 08             	mov    0x8(%ebp),%eax
  80303a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80303f:	8b 45 08             	mov    0x8(%ebp),%eax
  803042:	a3 48 51 80 00       	mov    %eax,0x805148
  803047:	8b 45 08             	mov    0x8(%ebp),%eax
  80304a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803051:	a1 54 51 80 00       	mov    0x805154,%eax
  803056:	40                   	inc    %eax
  803057:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80305c:	e9 bb 04 00 00       	jmp    80351c <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  803061:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803065:	75 17                	jne    80307e <insert_sorted_with_merge_freeList+0x2ab>
  803067:	83 ec 04             	sub    $0x4,%esp
  80306a:	68 58 42 80 00       	push   $0x804258
  80306f:	68 4c 01 00 00       	push   $0x14c
  803074:	68 07 42 80 00       	push   $0x804207
  803079:	e8 1b d4 ff ff       	call   800499 <_panic>
  80307e:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803084:	8b 45 08             	mov    0x8(%ebp),%eax
  803087:	89 50 04             	mov    %edx,0x4(%eax)
  80308a:	8b 45 08             	mov    0x8(%ebp),%eax
  80308d:	8b 40 04             	mov    0x4(%eax),%eax
  803090:	85 c0                	test   %eax,%eax
  803092:	74 0c                	je     8030a0 <insert_sorted_with_merge_freeList+0x2cd>
  803094:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803099:	8b 55 08             	mov    0x8(%ebp),%edx
  80309c:	89 10                	mov    %edx,(%eax)
  80309e:	eb 08                	jmp    8030a8 <insert_sorted_with_merge_freeList+0x2d5>
  8030a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a3:	a3 38 51 80 00       	mov    %eax,0x805138
  8030a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ab:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8030b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030b9:	a1 44 51 80 00       	mov    0x805144,%eax
  8030be:	40                   	inc    %eax
  8030bf:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8030c4:	e9 53 04 00 00       	jmp    80351c <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8030c9:	a1 38 51 80 00       	mov    0x805138,%eax
  8030ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030d1:	e9 15 04 00 00       	jmp    8034eb <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  8030d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d9:	8b 00                	mov    (%eax),%eax
  8030db:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  8030de:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e1:	8b 50 08             	mov    0x8(%eax),%edx
  8030e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e7:	8b 40 08             	mov    0x8(%eax),%eax
  8030ea:	39 c2                	cmp    %eax,%edx
  8030ec:	0f 86 f1 03 00 00    	jbe    8034e3 <insert_sorted_with_merge_freeList+0x710>
  8030f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f5:	8b 50 08             	mov    0x8(%eax),%edx
  8030f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030fb:	8b 40 08             	mov    0x8(%eax),%eax
  8030fe:	39 c2                	cmp    %eax,%edx
  803100:	0f 83 dd 03 00 00    	jae    8034e3 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  803106:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803109:	8b 50 08             	mov    0x8(%eax),%edx
  80310c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80310f:	8b 40 0c             	mov    0xc(%eax),%eax
  803112:	01 c2                	add    %eax,%edx
  803114:	8b 45 08             	mov    0x8(%ebp),%eax
  803117:	8b 40 08             	mov    0x8(%eax),%eax
  80311a:	39 c2                	cmp    %eax,%edx
  80311c:	0f 85 b9 01 00 00    	jne    8032db <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803122:	8b 45 08             	mov    0x8(%ebp),%eax
  803125:	8b 50 08             	mov    0x8(%eax),%edx
  803128:	8b 45 08             	mov    0x8(%ebp),%eax
  80312b:	8b 40 0c             	mov    0xc(%eax),%eax
  80312e:	01 c2                	add    %eax,%edx
  803130:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803133:	8b 40 08             	mov    0x8(%eax),%eax
  803136:	39 c2                	cmp    %eax,%edx
  803138:	0f 85 0d 01 00 00    	jne    80324b <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  80313e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803141:	8b 50 0c             	mov    0xc(%eax),%edx
  803144:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803147:	8b 40 0c             	mov    0xc(%eax),%eax
  80314a:	01 c2                	add    %eax,%edx
  80314c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80314f:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803152:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803156:	75 17                	jne    80316f <insert_sorted_with_merge_freeList+0x39c>
  803158:	83 ec 04             	sub    $0x4,%esp
  80315b:	68 b0 42 80 00       	push   $0x8042b0
  803160:	68 5c 01 00 00       	push   $0x15c
  803165:	68 07 42 80 00       	push   $0x804207
  80316a:	e8 2a d3 ff ff       	call   800499 <_panic>
  80316f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803172:	8b 00                	mov    (%eax),%eax
  803174:	85 c0                	test   %eax,%eax
  803176:	74 10                	je     803188 <insert_sorted_with_merge_freeList+0x3b5>
  803178:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80317b:	8b 00                	mov    (%eax),%eax
  80317d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803180:	8b 52 04             	mov    0x4(%edx),%edx
  803183:	89 50 04             	mov    %edx,0x4(%eax)
  803186:	eb 0b                	jmp    803193 <insert_sorted_with_merge_freeList+0x3c0>
  803188:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80318b:	8b 40 04             	mov    0x4(%eax),%eax
  80318e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803193:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803196:	8b 40 04             	mov    0x4(%eax),%eax
  803199:	85 c0                	test   %eax,%eax
  80319b:	74 0f                	je     8031ac <insert_sorted_with_merge_freeList+0x3d9>
  80319d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031a0:	8b 40 04             	mov    0x4(%eax),%eax
  8031a3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031a6:	8b 12                	mov    (%edx),%edx
  8031a8:	89 10                	mov    %edx,(%eax)
  8031aa:	eb 0a                	jmp    8031b6 <insert_sorted_with_merge_freeList+0x3e3>
  8031ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031af:	8b 00                	mov    (%eax),%eax
  8031b1:	a3 38 51 80 00       	mov    %eax,0x805138
  8031b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031b9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031c2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031c9:	a1 44 51 80 00       	mov    0x805144,%eax
  8031ce:	48                   	dec    %eax
  8031cf:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  8031d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031d7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  8031de:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031e1:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8031e8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8031ec:	75 17                	jne    803205 <insert_sorted_with_merge_freeList+0x432>
  8031ee:	83 ec 04             	sub    $0x4,%esp
  8031f1:	68 e4 41 80 00       	push   $0x8041e4
  8031f6:	68 5f 01 00 00       	push   $0x15f
  8031fb:	68 07 42 80 00       	push   $0x804207
  803200:	e8 94 d2 ff ff       	call   800499 <_panic>
  803205:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80320b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80320e:	89 10                	mov    %edx,(%eax)
  803210:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803213:	8b 00                	mov    (%eax),%eax
  803215:	85 c0                	test   %eax,%eax
  803217:	74 0d                	je     803226 <insert_sorted_with_merge_freeList+0x453>
  803219:	a1 48 51 80 00       	mov    0x805148,%eax
  80321e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803221:	89 50 04             	mov    %edx,0x4(%eax)
  803224:	eb 08                	jmp    80322e <insert_sorted_with_merge_freeList+0x45b>
  803226:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803229:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80322e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803231:	a3 48 51 80 00       	mov    %eax,0x805148
  803236:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803239:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803240:	a1 54 51 80 00       	mov    0x805154,%eax
  803245:	40                   	inc    %eax
  803246:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  80324b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80324e:	8b 50 0c             	mov    0xc(%eax),%edx
  803251:	8b 45 08             	mov    0x8(%ebp),%eax
  803254:	8b 40 0c             	mov    0xc(%eax),%eax
  803257:	01 c2                	add    %eax,%edx
  803259:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80325c:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  80325f:	8b 45 08             	mov    0x8(%ebp),%eax
  803262:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803269:	8b 45 08             	mov    0x8(%ebp),%eax
  80326c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803273:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803277:	75 17                	jne    803290 <insert_sorted_with_merge_freeList+0x4bd>
  803279:	83 ec 04             	sub    $0x4,%esp
  80327c:	68 e4 41 80 00       	push   $0x8041e4
  803281:	68 64 01 00 00       	push   $0x164
  803286:	68 07 42 80 00       	push   $0x804207
  80328b:	e8 09 d2 ff ff       	call   800499 <_panic>
  803290:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803296:	8b 45 08             	mov    0x8(%ebp),%eax
  803299:	89 10                	mov    %edx,(%eax)
  80329b:	8b 45 08             	mov    0x8(%ebp),%eax
  80329e:	8b 00                	mov    (%eax),%eax
  8032a0:	85 c0                	test   %eax,%eax
  8032a2:	74 0d                	je     8032b1 <insert_sorted_with_merge_freeList+0x4de>
  8032a4:	a1 48 51 80 00       	mov    0x805148,%eax
  8032a9:	8b 55 08             	mov    0x8(%ebp),%edx
  8032ac:	89 50 04             	mov    %edx,0x4(%eax)
  8032af:	eb 08                	jmp    8032b9 <insert_sorted_with_merge_freeList+0x4e6>
  8032b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b4:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8032b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8032bc:	a3 48 51 80 00       	mov    %eax,0x805148
  8032c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032cb:	a1 54 51 80 00       	mov    0x805154,%eax
  8032d0:	40                   	inc    %eax
  8032d1:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8032d6:	e9 41 02 00 00       	jmp    80351c <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8032db:	8b 45 08             	mov    0x8(%ebp),%eax
  8032de:	8b 50 08             	mov    0x8(%eax),%edx
  8032e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e4:	8b 40 0c             	mov    0xc(%eax),%eax
  8032e7:	01 c2                	add    %eax,%edx
  8032e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032ec:	8b 40 08             	mov    0x8(%eax),%eax
  8032ef:	39 c2                	cmp    %eax,%edx
  8032f1:	0f 85 7c 01 00 00    	jne    803473 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  8032f7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8032fb:	74 06                	je     803303 <insert_sorted_with_merge_freeList+0x530>
  8032fd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803301:	75 17                	jne    80331a <insert_sorted_with_merge_freeList+0x547>
  803303:	83 ec 04             	sub    $0x4,%esp
  803306:	68 20 42 80 00       	push   $0x804220
  80330b:	68 69 01 00 00       	push   $0x169
  803310:	68 07 42 80 00       	push   $0x804207
  803315:	e8 7f d1 ff ff       	call   800499 <_panic>
  80331a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80331d:	8b 50 04             	mov    0x4(%eax),%edx
  803320:	8b 45 08             	mov    0x8(%ebp),%eax
  803323:	89 50 04             	mov    %edx,0x4(%eax)
  803326:	8b 45 08             	mov    0x8(%ebp),%eax
  803329:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80332c:	89 10                	mov    %edx,(%eax)
  80332e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803331:	8b 40 04             	mov    0x4(%eax),%eax
  803334:	85 c0                	test   %eax,%eax
  803336:	74 0d                	je     803345 <insert_sorted_with_merge_freeList+0x572>
  803338:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80333b:	8b 40 04             	mov    0x4(%eax),%eax
  80333e:	8b 55 08             	mov    0x8(%ebp),%edx
  803341:	89 10                	mov    %edx,(%eax)
  803343:	eb 08                	jmp    80334d <insert_sorted_with_merge_freeList+0x57a>
  803345:	8b 45 08             	mov    0x8(%ebp),%eax
  803348:	a3 38 51 80 00       	mov    %eax,0x805138
  80334d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803350:	8b 55 08             	mov    0x8(%ebp),%edx
  803353:	89 50 04             	mov    %edx,0x4(%eax)
  803356:	a1 44 51 80 00       	mov    0x805144,%eax
  80335b:	40                   	inc    %eax
  80335c:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803361:	8b 45 08             	mov    0x8(%ebp),%eax
  803364:	8b 50 0c             	mov    0xc(%eax),%edx
  803367:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80336a:	8b 40 0c             	mov    0xc(%eax),%eax
  80336d:	01 c2                	add    %eax,%edx
  80336f:	8b 45 08             	mov    0x8(%ebp),%eax
  803372:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803375:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803379:	75 17                	jne    803392 <insert_sorted_with_merge_freeList+0x5bf>
  80337b:	83 ec 04             	sub    $0x4,%esp
  80337e:	68 b0 42 80 00       	push   $0x8042b0
  803383:	68 6b 01 00 00       	push   $0x16b
  803388:	68 07 42 80 00       	push   $0x804207
  80338d:	e8 07 d1 ff ff       	call   800499 <_panic>
  803392:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803395:	8b 00                	mov    (%eax),%eax
  803397:	85 c0                	test   %eax,%eax
  803399:	74 10                	je     8033ab <insert_sorted_with_merge_freeList+0x5d8>
  80339b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80339e:	8b 00                	mov    (%eax),%eax
  8033a0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8033a3:	8b 52 04             	mov    0x4(%edx),%edx
  8033a6:	89 50 04             	mov    %edx,0x4(%eax)
  8033a9:	eb 0b                	jmp    8033b6 <insert_sorted_with_merge_freeList+0x5e3>
  8033ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033ae:	8b 40 04             	mov    0x4(%eax),%eax
  8033b1:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8033b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033b9:	8b 40 04             	mov    0x4(%eax),%eax
  8033bc:	85 c0                	test   %eax,%eax
  8033be:	74 0f                	je     8033cf <insert_sorted_with_merge_freeList+0x5fc>
  8033c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033c3:	8b 40 04             	mov    0x4(%eax),%eax
  8033c6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8033c9:	8b 12                	mov    (%edx),%edx
  8033cb:	89 10                	mov    %edx,(%eax)
  8033cd:	eb 0a                	jmp    8033d9 <insert_sorted_with_merge_freeList+0x606>
  8033cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033d2:	8b 00                	mov    (%eax),%eax
  8033d4:	a3 38 51 80 00       	mov    %eax,0x805138
  8033d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033dc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033e5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033ec:	a1 44 51 80 00       	mov    0x805144,%eax
  8033f1:	48                   	dec    %eax
  8033f2:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  8033f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033fa:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803401:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803404:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80340b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80340f:	75 17                	jne    803428 <insert_sorted_with_merge_freeList+0x655>
  803411:	83 ec 04             	sub    $0x4,%esp
  803414:	68 e4 41 80 00       	push   $0x8041e4
  803419:	68 6e 01 00 00       	push   $0x16e
  80341e:	68 07 42 80 00       	push   $0x804207
  803423:	e8 71 d0 ff ff       	call   800499 <_panic>
  803428:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80342e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803431:	89 10                	mov    %edx,(%eax)
  803433:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803436:	8b 00                	mov    (%eax),%eax
  803438:	85 c0                	test   %eax,%eax
  80343a:	74 0d                	je     803449 <insert_sorted_with_merge_freeList+0x676>
  80343c:	a1 48 51 80 00       	mov    0x805148,%eax
  803441:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803444:	89 50 04             	mov    %edx,0x4(%eax)
  803447:	eb 08                	jmp    803451 <insert_sorted_with_merge_freeList+0x67e>
  803449:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80344c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803451:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803454:	a3 48 51 80 00       	mov    %eax,0x805148
  803459:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80345c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803463:	a1 54 51 80 00       	mov    0x805154,%eax
  803468:	40                   	inc    %eax
  803469:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  80346e:	e9 a9 00 00 00       	jmp    80351c <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803473:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803477:	74 06                	je     80347f <insert_sorted_with_merge_freeList+0x6ac>
  803479:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80347d:	75 17                	jne    803496 <insert_sorted_with_merge_freeList+0x6c3>
  80347f:	83 ec 04             	sub    $0x4,%esp
  803482:	68 7c 42 80 00       	push   $0x80427c
  803487:	68 73 01 00 00       	push   $0x173
  80348c:	68 07 42 80 00       	push   $0x804207
  803491:	e8 03 d0 ff ff       	call   800499 <_panic>
  803496:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803499:	8b 10                	mov    (%eax),%edx
  80349b:	8b 45 08             	mov    0x8(%ebp),%eax
  80349e:	89 10                	mov    %edx,(%eax)
  8034a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8034a3:	8b 00                	mov    (%eax),%eax
  8034a5:	85 c0                	test   %eax,%eax
  8034a7:	74 0b                	je     8034b4 <insert_sorted_with_merge_freeList+0x6e1>
  8034a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034ac:	8b 00                	mov    (%eax),%eax
  8034ae:	8b 55 08             	mov    0x8(%ebp),%edx
  8034b1:	89 50 04             	mov    %edx,0x4(%eax)
  8034b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034b7:	8b 55 08             	mov    0x8(%ebp),%edx
  8034ba:	89 10                	mov    %edx,(%eax)
  8034bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8034bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8034c2:	89 50 04             	mov    %edx,0x4(%eax)
  8034c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8034c8:	8b 00                	mov    (%eax),%eax
  8034ca:	85 c0                	test   %eax,%eax
  8034cc:	75 08                	jne    8034d6 <insert_sorted_with_merge_freeList+0x703>
  8034ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8034d1:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8034d6:	a1 44 51 80 00       	mov    0x805144,%eax
  8034db:	40                   	inc    %eax
  8034dc:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  8034e1:	eb 39                	jmp    80351c <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8034e3:	a1 40 51 80 00       	mov    0x805140,%eax
  8034e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8034eb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034ef:	74 07                	je     8034f8 <insert_sorted_with_merge_freeList+0x725>
  8034f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034f4:	8b 00                	mov    (%eax),%eax
  8034f6:	eb 05                	jmp    8034fd <insert_sorted_with_merge_freeList+0x72a>
  8034f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8034fd:	a3 40 51 80 00       	mov    %eax,0x805140
  803502:	a1 40 51 80 00       	mov    0x805140,%eax
  803507:	85 c0                	test   %eax,%eax
  803509:	0f 85 c7 fb ff ff    	jne    8030d6 <insert_sorted_with_merge_freeList+0x303>
  80350f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803513:	0f 85 bd fb ff ff    	jne    8030d6 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803519:	eb 01                	jmp    80351c <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80351b:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80351c:	90                   	nop
  80351d:	c9                   	leave  
  80351e:	c3                   	ret    
  80351f:	90                   	nop

00803520 <__udivdi3>:
  803520:	55                   	push   %ebp
  803521:	57                   	push   %edi
  803522:	56                   	push   %esi
  803523:	53                   	push   %ebx
  803524:	83 ec 1c             	sub    $0x1c,%esp
  803527:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80352b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80352f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803533:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803537:	89 ca                	mov    %ecx,%edx
  803539:	89 f8                	mov    %edi,%eax
  80353b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80353f:	85 f6                	test   %esi,%esi
  803541:	75 2d                	jne    803570 <__udivdi3+0x50>
  803543:	39 cf                	cmp    %ecx,%edi
  803545:	77 65                	ja     8035ac <__udivdi3+0x8c>
  803547:	89 fd                	mov    %edi,%ebp
  803549:	85 ff                	test   %edi,%edi
  80354b:	75 0b                	jne    803558 <__udivdi3+0x38>
  80354d:	b8 01 00 00 00       	mov    $0x1,%eax
  803552:	31 d2                	xor    %edx,%edx
  803554:	f7 f7                	div    %edi
  803556:	89 c5                	mov    %eax,%ebp
  803558:	31 d2                	xor    %edx,%edx
  80355a:	89 c8                	mov    %ecx,%eax
  80355c:	f7 f5                	div    %ebp
  80355e:	89 c1                	mov    %eax,%ecx
  803560:	89 d8                	mov    %ebx,%eax
  803562:	f7 f5                	div    %ebp
  803564:	89 cf                	mov    %ecx,%edi
  803566:	89 fa                	mov    %edi,%edx
  803568:	83 c4 1c             	add    $0x1c,%esp
  80356b:	5b                   	pop    %ebx
  80356c:	5e                   	pop    %esi
  80356d:	5f                   	pop    %edi
  80356e:	5d                   	pop    %ebp
  80356f:	c3                   	ret    
  803570:	39 ce                	cmp    %ecx,%esi
  803572:	77 28                	ja     80359c <__udivdi3+0x7c>
  803574:	0f bd fe             	bsr    %esi,%edi
  803577:	83 f7 1f             	xor    $0x1f,%edi
  80357a:	75 40                	jne    8035bc <__udivdi3+0x9c>
  80357c:	39 ce                	cmp    %ecx,%esi
  80357e:	72 0a                	jb     80358a <__udivdi3+0x6a>
  803580:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803584:	0f 87 9e 00 00 00    	ja     803628 <__udivdi3+0x108>
  80358a:	b8 01 00 00 00       	mov    $0x1,%eax
  80358f:	89 fa                	mov    %edi,%edx
  803591:	83 c4 1c             	add    $0x1c,%esp
  803594:	5b                   	pop    %ebx
  803595:	5e                   	pop    %esi
  803596:	5f                   	pop    %edi
  803597:	5d                   	pop    %ebp
  803598:	c3                   	ret    
  803599:	8d 76 00             	lea    0x0(%esi),%esi
  80359c:	31 ff                	xor    %edi,%edi
  80359e:	31 c0                	xor    %eax,%eax
  8035a0:	89 fa                	mov    %edi,%edx
  8035a2:	83 c4 1c             	add    $0x1c,%esp
  8035a5:	5b                   	pop    %ebx
  8035a6:	5e                   	pop    %esi
  8035a7:	5f                   	pop    %edi
  8035a8:	5d                   	pop    %ebp
  8035a9:	c3                   	ret    
  8035aa:	66 90                	xchg   %ax,%ax
  8035ac:	89 d8                	mov    %ebx,%eax
  8035ae:	f7 f7                	div    %edi
  8035b0:	31 ff                	xor    %edi,%edi
  8035b2:	89 fa                	mov    %edi,%edx
  8035b4:	83 c4 1c             	add    $0x1c,%esp
  8035b7:	5b                   	pop    %ebx
  8035b8:	5e                   	pop    %esi
  8035b9:	5f                   	pop    %edi
  8035ba:	5d                   	pop    %ebp
  8035bb:	c3                   	ret    
  8035bc:	bd 20 00 00 00       	mov    $0x20,%ebp
  8035c1:	89 eb                	mov    %ebp,%ebx
  8035c3:	29 fb                	sub    %edi,%ebx
  8035c5:	89 f9                	mov    %edi,%ecx
  8035c7:	d3 e6                	shl    %cl,%esi
  8035c9:	89 c5                	mov    %eax,%ebp
  8035cb:	88 d9                	mov    %bl,%cl
  8035cd:	d3 ed                	shr    %cl,%ebp
  8035cf:	89 e9                	mov    %ebp,%ecx
  8035d1:	09 f1                	or     %esi,%ecx
  8035d3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8035d7:	89 f9                	mov    %edi,%ecx
  8035d9:	d3 e0                	shl    %cl,%eax
  8035db:	89 c5                	mov    %eax,%ebp
  8035dd:	89 d6                	mov    %edx,%esi
  8035df:	88 d9                	mov    %bl,%cl
  8035e1:	d3 ee                	shr    %cl,%esi
  8035e3:	89 f9                	mov    %edi,%ecx
  8035e5:	d3 e2                	shl    %cl,%edx
  8035e7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8035eb:	88 d9                	mov    %bl,%cl
  8035ed:	d3 e8                	shr    %cl,%eax
  8035ef:	09 c2                	or     %eax,%edx
  8035f1:	89 d0                	mov    %edx,%eax
  8035f3:	89 f2                	mov    %esi,%edx
  8035f5:	f7 74 24 0c          	divl   0xc(%esp)
  8035f9:	89 d6                	mov    %edx,%esi
  8035fb:	89 c3                	mov    %eax,%ebx
  8035fd:	f7 e5                	mul    %ebp
  8035ff:	39 d6                	cmp    %edx,%esi
  803601:	72 19                	jb     80361c <__udivdi3+0xfc>
  803603:	74 0b                	je     803610 <__udivdi3+0xf0>
  803605:	89 d8                	mov    %ebx,%eax
  803607:	31 ff                	xor    %edi,%edi
  803609:	e9 58 ff ff ff       	jmp    803566 <__udivdi3+0x46>
  80360e:	66 90                	xchg   %ax,%ax
  803610:	8b 54 24 08          	mov    0x8(%esp),%edx
  803614:	89 f9                	mov    %edi,%ecx
  803616:	d3 e2                	shl    %cl,%edx
  803618:	39 c2                	cmp    %eax,%edx
  80361a:	73 e9                	jae    803605 <__udivdi3+0xe5>
  80361c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80361f:	31 ff                	xor    %edi,%edi
  803621:	e9 40 ff ff ff       	jmp    803566 <__udivdi3+0x46>
  803626:	66 90                	xchg   %ax,%ax
  803628:	31 c0                	xor    %eax,%eax
  80362a:	e9 37 ff ff ff       	jmp    803566 <__udivdi3+0x46>
  80362f:	90                   	nop

00803630 <__umoddi3>:
  803630:	55                   	push   %ebp
  803631:	57                   	push   %edi
  803632:	56                   	push   %esi
  803633:	53                   	push   %ebx
  803634:	83 ec 1c             	sub    $0x1c,%esp
  803637:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80363b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80363f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803643:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803647:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80364b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80364f:	89 f3                	mov    %esi,%ebx
  803651:	89 fa                	mov    %edi,%edx
  803653:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803657:	89 34 24             	mov    %esi,(%esp)
  80365a:	85 c0                	test   %eax,%eax
  80365c:	75 1a                	jne    803678 <__umoddi3+0x48>
  80365e:	39 f7                	cmp    %esi,%edi
  803660:	0f 86 a2 00 00 00    	jbe    803708 <__umoddi3+0xd8>
  803666:	89 c8                	mov    %ecx,%eax
  803668:	89 f2                	mov    %esi,%edx
  80366a:	f7 f7                	div    %edi
  80366c:	89 d0                	mov    %edx,%eax
  80366e:	31 d2                	xor    %edx,%edx
  803670:	83 c4 1c             	add    $0x1c,%esp
  803673:	5b                   	pop    %ebx
  803674:	5e                   	pop    %esi
  803675:	5f                   	pop    %edi
  803676:	5d                   	pop    %ebp
  803677:	c3                   	ret    
  803678:	39 f0                	cmp    %esi,%eax
  80367a:	0f 87 ac 00 00 00    	ja     80372c <__umoddi3+0xfc>
  803680:	0f bd e8             	bsr    %eax,%ebp
  803683:	83 f5 1f             	xor    $0x1f,%ebp
  803686:	0f 84 ac 00 00 00    	je     803738 <__umoddi3+0x108>
  80368c:	bf 20 00 00 00       	mov    $0x20,%edi
  803691:	29 ef                	sub    %ebp,%edi
  803693:	89 fe                	mov    %edi,%esi
  803695:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803699:	89 e9                	mov    %ebp,%ecx
  80369b:	d3 e0                	shl    %cl,%eax
  80369d:	89 d7                	mov    %edx,%edi
  80369f:	89 f1                	mov    %esi,%ecx
  8036a1:	d3 ef                	shr    %cl,%edi
  8036a3:	09 c7                	or     %eax,%edi
  8036a5:	89 e9                	mov    %ebp,%ecx
  8036a7:	d3 e2                	shl    %cl,%edx
  8036a9:	89 14 24             	mov    %edx,(%esp)
  8036ac:	89 d8                	mov    %ebx,%eax
  8036ae:	d3 e0                	shl    %cl,%eax
  8036b0:	89 c2                	mov    %eax,%edx
  8036b2:	8b 44 24 08          	mov    0x8(%esp),%eax
  8036b6:	d3 e0                	shl    %cl,%eax
  8036b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8036bc:	8b 44 24 08          	mov    0x8(%esp),%eax
  8036c0:	89 f1                	mov    %esi,%ecx
  8036c2:	d3 e8                	shr    %cl,%eax
  8036c4:	09 d0                	or     %edx,%eax
  8036c6:	d3 eb                	shr    %cl,%ebx
  8036c8:	89 da                	mov    %ebx,%edx
  8036ca:	f7 f7                	div    %edi
  8036cc:	89 d3                	mov    %edx,%ebx
  8036ce:	f7 24 24             	mull   (%esp)
  8036d1:	89 c6                	mov    %eax,%esi
  8036d3:	89 d1                	mov    %edx,%ecx
  8036d5:	39 d3                	cmp    %edx,%ebx
  8036d7:	0f 82 87 00 00 00    	jb     803764 <__umoddi3+0x134>
  8036dd:	0f 84 91 00 00 00    	je     803774 <__umoddi3+0x144>
  8036e3:	8b 54 24 04          	mov    0x4(%esp),%edx
  8036e7:	29 f2                	sub    %esi,%edx
  8036e9:	19 cb                	sbb    %ecx,%ebx
  8036eb:	89 d8                	mov    %ebx,%eax
  8036ed:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8036f1:	d3 e0                	shl    %cl,%eax
  8036f3:	89 e9                	mov    %ebp,%ecx
  8036f5:	d3 ea                	shr    %cl,%edx
  8036f7:	09 d0                	or     %edx,%eax
  8036f9:	89 e9                	mov    %ebp,%ecx
  8036fb:	d3 eb                	shr    %cl,%ebx
  8036fd:	89 da                	mov    %ebx,%edx
  8036ff:	83 c4 1c             	add    $0x1c,%esp
  803702:	5b                   	pop    %ebx
  803703:	5e                   	pop    %esi
  803704:	5f                   	pop    %edi
  803705:	5d                   	pop    %ebp
  803706:	c3                   	ret    
  803707:	90                   	nop
  803708:	89 fd                	mov    %edi,%ebp
  80370a:	85 ff                	test   %edi,%edi
  80370c:	75 0b                	jne    803719 <__umoddi3+0xe9>
  80370e:	b8 01 00 00 00       	mov    $0x1,%eax
  803713:	31 d2                	xor    %edx,%edx
  803715:	f7 f7                	div    %edi
  803717:	89 c5                	mov    %eax,%ebp
  803719:	89 f0                	mov    %esi,%eax
  80371b:	31 d2                	xor    %edx,%edx
  80371d:	f7 f5                	div    %ebp
  80371f:	89 c8                	mov    %ecx,%eax
  803721:	f7 f5                	div    %ebp
  803723:	89 d0                	mov    %edx,%eax
  803725:	e9 44 ff ff ff       	jmp    80366e <__umoddi3+0x3e>
  80372a:	66 90                	xchg   %ax,%ax
  80372c:	89 c8                	mov    %ecx,%eax
  80372e:	89 f2                	mov    %esi,%edx
  803730:	83 c4 1c             	add    $0x1c,%esp
  803733:	5b                   	pop    %ebx
  803734:	5e                   	pop    %esi
  803735:	5f                   	pop    %edi
  803736:	5d                   	pop    %ebp
  803737:	c3                   	ret    
  803738:	3b 04 24             	cmp    (%esp),%eax
  80373b:	72 06                	jb     803743 <__umoddi3+0x113>
  80373d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803741:	77 0f                	ja     803752 <__umoddi3+0x122>
  803743:	89 f2                	mov    %esi,%edx
  803745:	29 f9                	sub    %edi,%ecx
  803747:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80374b:	89 14 24             	mov    %edx,(%esp)
  80374e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803752:	8b 44 24 04          	mov    0x4(%esp),%eax
  803756:	8b 14 24             	mov    (%esp),%edx
  803759:	83 c4 1c             	add    $0x1c,%esp
  80375c:	5b                   	pop    %ebx
  80375d:	5e                   	pop    %esi
  80375e:	5f                   	pop    %edi
  80375f:	5d                   	pop    %ebp
  803760:	c3                   	ret    
  803761:	8d 76 00             	lea    0x0(%esi),%esi
  803764:	2b 04 24             	sub    (%esp),%eax
  803767:	19 fa                	sbb    %edi,%edx
  803769:	89 d1                	mov    %edx,%ecx
  80376b:	89 c6                	mov    %eax,%esi
  80376d:	e9 71 ff ff ff       	jmp    8036e3 <__umoddi3+0xb3>
  803772:	66 90                	xchg   %ax,%ax
  803774:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803778:	72 ea                	jb     803764 <__umoddi3+0x134>
  80377a:	89 d9                	mov    %ebx,%ecx
  80377c:	e9 62 ff ff ff       	jmp    8036e3 <__umoddi3+0xb3>
