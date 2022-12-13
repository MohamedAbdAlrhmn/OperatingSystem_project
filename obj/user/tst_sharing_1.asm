
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
  80008d:	68 e0 37 80 00       	push   $0x8037e0
  800092:	6a 12                	push   $0x12
  800094:	68 fc 37 80 00       	push   $0x8037fc
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
  8000ae:	68 14 38 80 00       	push   $0x803814
  8000b3:	e8 95 06 00 00       	call   80074d <cprintf>
  8000b8:	83 c4 10             	add    $0x10,%esp
	{
		int freeFrames = sys_calculate_free_frames() ;
  8000bb:	e8 ea 18 00 00       	call   8019aa <sys_calculate_free_frames>
  8000c0:	89 45 e8             	mov    %eax,-0x18(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8000c3:	83 ec 04             	sub    $0x4,%esp
  8000c6:	6a 01                	push   $0x1
  8000c8:	68 00 10 00 00       	push   $0x1000
  8000cd:	68 4b 38 80 00       	push   $0x80384b
  8000d2:	e8 93 16 00 00       	call   80176a <smalloc>
  8000d7:	83 c4 10             	add    $0x10,%esp
  8000da:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (x != (uint32*)USER_HEAP_START) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  8000dd:	81 7d e4 00 00 00 80 	cmpl   $0x80000000,-0x1c(%ebp)
  8000e4:	74 14                	je     8000fa <_main+0xc2>
  8000e6:	83 ec 04             	sub    $0x4,%esp
  8000e9:	68 50 38 80 00       	push   $0x803850
  8000ee:	6a 1e                	push   $0x1e
  8000f0:	68 fc 37 80 00       	push   $0x8037fc
  8000f5:	e8 9f 03 00 00       	call   800499 <_panic>
		expected = 1+1+2 ;
  8000fa:	c7 45 e0 04 00 00 00 	movl   $0x4,-0x20(%ebp)
		if ((freeFrames - sys_calculate_free_frames()) !=  expected) panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);
  800101:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800104:	e8 a1 18 00 00       	call   8019aa <sys_calculate_free_frames>
  800109:	29 c3                	sub    %eax,%ebx
  80010b:	89 d8                	mov    %ebx,%eax
  80010d:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800110:	74 24                	je     800136 <_main+0xfe>
  800112:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800115:	e8 90 18 00 00       	call   8019aa <sys_calculate_free_frames>
  80011a:	29 c3                	sub    %eax,%ebx
  80011c:	89 d8                	mov    %ebx,%eax
  80011e:	83 ec 0c             	sub    $0xc,%esp
  800121:	ff 75 e0             	pushl  -0x20(%ebp)
  800124:	50                   	push   %eax
  800125:	68 bc 38 80 00       	push   $0x8038bc
  80012a:	6a 20                	push   $0x20
  80012c:	68 fc 37 80 00       	push   $0x8037fc
  800131:	e8 63 03 00 00       	call   800499 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800136:	e8 6f 18 00 00       	call   8019aa <sys_calculate_free_frames>
  80013b:	89 45 e8             	mov    %eax,-0x18(%ebp)
		z = smalloc("z", PAGE_SIZE + 4, 1);
  80013e:	83 ec 04             	sub    $0x4,%esp
  800141:	6a 01                	push   $0x1
  800143:	68 04 10 00 00       	push   $0x1004
  800148:	68 54 39 80 00       	push   $0x803954
  80014d:	e8 18 16 00 00       	call   80176a <smalloc>
  800152:	83 c4 10             	add    $0x10,%esp
  800155:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (z != (uint32*)(USER_HEAP_START + 1 * PAGE_SIZE)) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  800158:	81 7d dc 00 10 00 80 	cmpl   $0x80001000,-0x24(%ebp)
  80015f:	74 14                	je     800175 <_main+0x13d>
  800161:	83 ec 04             	sub    $0x4,%esp
  800164:	68 50 38 80 00       	push   $0x803850
  800169:	6a 24                	push   $0x24
  80016b:	68 fc 37 80 00       	push   $0x8037fc
  800170:	e8 24 03 00 00       	call   800499 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  2+0+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800175:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800178:	e8 2d 18 00 00       	call   8019aa <sys_calculate_free_frames>
  80017d:	29 c3                	sub    %eax,%ebx
  80017f:	89 d8                	mov    %ebx,%eax
  800181:	83 f8 04             	cmp    $0x4,%eax
  800184:	74 14                	je     80019a <_main+0x162>
  800186:	83 ec 04             	sub    $0x4,%esp
  800189:	68 58 39 80 00       	push   $0x803958
  80018e:	6a 25                	push   $0x25
  800190:	68 fc 37 80 00       	push   $0x8037fc
  800195:	e8 ff 02 00 00       	call   800499 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  80019a:	e8 0b 18 00 00       	call   8019aa <sys_calculate_free_frames>
  80019f:	89 45 e8             	mov    %eax,-0x18(%ebp)
		y = smalloc("y", 4, 1);
  8001a2:	83 ec 04             	sub    $0x4,%esp
  8001a5:	6a 01                	push   $0x1
  8001a7:	6a 04                	push   $0x4
  8001a9:	68 d6 39 80 00       	push   $0x8039d6
  8001ae:	e8 b7 15 00 00       	call   80176a <smalloc>
  8001b3:	83 c4 10             	add    $0x10,%esp
  8001b6:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if (y != (uint32*)(USER_HEAP_START + 3 * PAGE_SIZE)) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  8001b9:	81 7d d8 00 30 00 80 	cmpl   $0x80003000,-0x28(%ebp)
  8001c0:	74 14                	je     8001d6 <_main+0x19e>
  8001c2:	83 ec 04             	sub    $0x4,%esp
  8001c5:	68 50 38 80 00       	push   $0x803850
  8001ca:	6a 29                	push   $0x29
  8001cc:	68 fc 37 80 00       	push   $0x8037fc
  8001d1:	e8 c3 02 00 00       	call   800499 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  1+0+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  8001d6:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8001d9:	e8 cc 17 00 00       	call   8019aa <sys_calculate_free_frames>
  8001de:	29 c3                	sub    %eax,%ebx
  8001e0:	89 d8                	mov    %ebx,%eax
  8001e2:	83 f8 03             	cmp    $0x3,%eax
  8001e5:	74 14                	je     8001fb <_main+0x1c3>
  8001e7:	83 ec 04             	sub    $0x4,%esp
  8001ea:	68 58 39 80 00       	push   $0x803958
  8001ef:	6a 2a                	push   $0x2a
  8001f1:	68 fc 37 80 00       	push   $0x8037fc
  8001f6:	e8 9e 02 00 00       	call   800499 <_panic>
	}
	cprintf("Step A is completed successfully!!\n\n\n");
  8001fb:	83 ec 0c             	sub    $0xc,%esp
  8001fe:	68 d8 39 80 00       	push   $0x8039d8
  800203:	e8 45 05 00 00       	call   80074d <cprintf>
  800208:	83 c4 10             	add    $0x10,%esp


	cprintf("STEP B: checking reading & writing... \n");
  80020b:	83 ec 0c             	sub    $0xc,%esp
  80020e:	68 00 3a 80 00       	push   $0x803a00
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
  800291:	68 28 3a 80 00       	push   $0x803a28
  800296:	6a 3e                	push   $0x3e
  800298:	68 fc 37 80 00       	push   $0x8037fc
  80029d:	e8 f7 01 00 00       	call   800499 <_panic>
		if( x[PAGE_SIZE/4 - 1] !=  -1)  	panic("Reading/Writing of shared object is failed");
  8002a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002a5:	05 fc 0f 00 00       	add    $0xffc,%eax
  8002aa:	8b 00                	mov    (%eax),%eax
  8002ac:	83 f8 ff             	cmp    $0xffffffff,%eax
  8002af:	74 14                	je     8002c5 <_main+0x28d>
  8002b1:	83 ec 04             	sub    $0x4,%esp
  8002b4:	68 28 3a 80 00       	push   $0x803a28
  8002b9:	6a 3f                	push   $0x3f
  8002bb:	68 fc 37 80 00       	push   $0x8037fc
  8002c0:	e8 d4 01 00 00       	call   800499 <_panic>

		if( y[0] !=  -1)  					panic("Reading/Writing of shared object is failed");
  8002c5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8002c8:	8b 00                	mov    (%eax),%eax
  8002ca:	83 f8 ff             	cmp    $0xffffffff,%eax
  8002cd:	74 14                	je     8002e3 <_main+0x2ab>
  8002cf:	83 ec 04             	sub    $0x4,%esp
  8002d2:	68 28 3a 80 00       	push   $0x803a28
  8002d7:	6a 41                	push   $0x41
  8002d9:	68 fc 37 80 00       	push   $0x8037fc
  8002de:	e8 b6 01 00 00       	call   800499 <_panic>
		if( y[PAGE_SIZE/4 - 1] !=  -1)  	panic("Reading/Writing of shared object is failed");
  8002e3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8002e6:	05 fc 0f 00 00       	add    $0xffc,%eax
  8002eb:	8b 00                	mov    (%eax),%eax
  8002ed:	83 f8 ff             	cmp    $0xffffffff,%eax
  8002f0:	74 14                	je     800306 <_main+0x2ce>
  8002f2:	83 ec 04             	sub    $0x4,%esp
  8002f5:	68 28 3a 80 00       	push   $0x803a28
  8002fa:	6a 42                	push   $0x42
  8002fc:	68 fc 37 80 00       	push   $0x8037fc
  800301:	e8 93 01 00 00       	call   800499 <_panic>

		if( z[0] !=  -1)  					panic("Reading/Writing of shared object is failed");
  800306:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800309:	8b 00                	mov    (%eax),%eax
  80030b:	83 f8 ff             	cmp    $0xffffffff,%eax
  80030e:	74 14                	je     800324 <_main+0x2ec>
  800310:	83 ec 04             	sub    $0x4,%esp
  800313:	68 28 3a 80 00       	push   $0x803a28
  800318:	6a 44                	push   $0x44
  80031a:	68 fc 37 80 00       	push   $0x8037fc
  80031f:	e8 75 01 00 00       	call   800499 <_panic>
		if( z[2*PAGE_SIZE/4 - 1] !=  -1)  	panic("Reading/Writing of shared object is failed");
  800324:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800327:	05 fc 1f 00 00       	add    $0x1ffc,%eax
  80032c:	8b 00                	mov    (%eax),%eax
  80032e:	83 f8 ff             	cmp    $0xffffffff,%eax
  800331:	74 14                	je     800347 <_main+0x30f>
  800333:	83 ec 04             	sub    $0x4,%esp
  800336:	68 28 3a 80 00       	push   $0x803a28
  80033b:	6a 45                	push   $0x45
  80033d:	68 fc 37 80 00       	push   $0x8037fc
  800342:	e8 52 01 00 00       	call   800499 <_panic>
	}

	cprintf("Congratulations!! Test of Shared Variables [Create] [1] completed successfully!!\n\n\n");
  800347:	83 ec 0c             	sub    $0xc,%esp
  80034a:	68 54 3a 80 00       	push   $0x803a54
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
  800363:	e8 22 19 00 00       	call   801c8a <sys_getenvindex>
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
  8003ce:	e8 c4 16 00 00       	call   801a97 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8003d3:	83 ec 0c             	sub    $0xc,%esp
  8003d6:	68 c0 3a 80 00       	push   $0x803ac0
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
  8003fe:	68 e8 3a 80 00       	push   $0x803ae8
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
  80042f:	68 10 3b 80 00       	push   $0x803b10
  800434:	e8 14 03 00 00       	call   80074d <cprintf>
  800439:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80043c:	a1 20 50 80 00       	mov    0x805020,%eax
  800441:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800447:	83 ec 08             	sub    $0x8,%esp
  80044a:	50                   	push   %eax
  80044b:	68 68 3b 80 00       	push   $0x803b68
  800450:	e8 f8 02 00 00       	call   80074d <cprintf>
  800455:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800458:	83 ec 0c             	sub    $0xc,%esp
  80045b:	68 c0 3a 80 00       	push   $0x803ac0
  800460:	e8 e8 02 00 00       	call   80074d <cprintf>
  800465:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800468:	e8 44 16 00 00       	call   801ab1 <sys_enable_interrupt>

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
  800480:	e8 d1 17 00 00       	call   801c56 <sys_destroy_env>
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
  800491:	e8 26 18 00 00       	call   801cbc <sys_exit_env>
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
  8004ba:	68 7c 3b 80 00       	push   $0x803b7c
  8004bf:	e8 89 02 00 00       	call   80074d <cprintf>
  8004c4:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8004c7:	a1 00 50 80 00       	mov    0x805000,%eax
  8004cc:	ff 75 0c             	pushl  0xc(%ebp)
  8004cf:	ff 75 08             	pushl  0x8(%ebp)
  8004d2:	50                   	push   %eax
  8004d3:	68 81 3b 80 00       	push   $0x803b81
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
  8004f7:	68 9d 3b 80 00       	push   $0x803b9d
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
  800523:	68 a0 3b 80 00       	push   $0x803ba0
  800528:	6a 26                	push   $0x26
  80052a:	68 ec 3b 80 00       	push   $0x803bec
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
  8005f5:	68 f8 3b 80 00       	push   $0x803bf8
  8005fa:	6a 3a                	push   $0x3a
  8005fc:	68 ec 3b 80 00       	push   $0x803bec
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
  800665:	68 4c 3c 80 00       	push   $0x803c4c
  80066a:	6a 44                	push   $0x44
  80066c:	68 ec 3b 80 00       	push   $0x803bec
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
  8006bf:	e8 25 12 00 00       	call   8018e9 <sys_cputs>
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
  800736:	e8 ae 11 00 00       	call   8018e9 <sys_cputs>
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
  800780:	e8 12 13 00 00       	call   801a97 <sys_disable_interrupt>
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
  8007a0:	e8 0c 13 00 00       	call   801ab1 <sys_enable_interrupt>
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
  8007ea:	e8 7d 2d 00 00       	call   80356c <__udivdi3>
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
  80083a:	e8 3d 2e 00 00       	call   80367c <__umoddi3>
  80083f:	83 c4 10             	add    $0x10,%esp
  800842:	05 b4 3e 80 00       	add    $0x803eb4,%eax
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
  800995:	8b 04 85 d8 3e 80 00 	mov    0x803ed8(,%eax,4),%eax
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
  800a76:	8b 34 9d 20 3d 80 00 	mov    0x803d20(,%ebx,4),%esi
  800a7d:	85 f6                	test   %esi,%esi
  800a7f:	75 19                	jne    800a9a <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800a81:	53                   	push   %ebx
  800a82:	68 c5 3e 80 00       	push   $0x803ec5
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
  800a9b:	68 ce 3e 80 00       	push   $0x803ece
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
  800ac8:	be d1 3e 80 00       	mov    $0x803ed1,%esi
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
  8014ee:	68 30 40 80 00       	push   $0x804030
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
  8015be:	e8 6a 04 00 00       	call   801a2d <sys_allocate_chunk>
  8015c3:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8015c6:	a1 20 51 80 00       	mov    0x805120,%eax
  8015cb:	83 ec 0c             	sub    $0xc,%esp
  8015ce:	50                   	push   %eax
  8015cf:	e8 df 0a 00 00       	call   8020b3 <initialize_MemBlocksList>
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
  8015fc:	68 55 40 80 00       	push   $0x804055
  801601:	6a 33                	push   $0x33
  801603:	68 73 40 80 00       	push   $0x804073
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
  80167b:	68 80 40 80 00       	push   $0x804080
  801680:	6a 34                	push   $0x34
  801682:	68 73 40 80 00       	push   $0x804073
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
  801713:	e8 e3 06 00 00       	call   801dfb <sys_isUHeapPlacementStrategyFIRSTFIT>
  801718:	85 c0                	test   %eax,%eax
  80171a:	74 11                	je     80172d <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  80171c:	83 ec 0c             	sub    $0xc,%esp
  80171f:	ff 75 e8             	pushl  -0x18(%ebp)
  801722:	e8 4e 0d 00 00       	call   802475 <alloc_block_FF>
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
  801739:	e8 aa 0a 00 00       	call   8021e8 <insert_sorted_allocList>
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
  801759:	68 a4 40 80 00       	push   $0x8040a4
  80175e:	6a 6f                	push   $0x6f
  801760:	68 73 40 80 00       	push   $0x804073
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
  80177f:	75 07                	jne    801788 <smalloc+0x1e>
  801781:	b8 00 00 00 00       	mov    $0x0,%eax
  801786:	eb 7c                	jmp    801804 <smalloc+0x9a>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801788:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80178f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801792:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801795:	01 d0                	add    %edx,%eax
  801797:	48                   	dec    %eax
  801798:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80179b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80179e:	ba 00 00 00 00       	mov    $0x0,%edx
  8017a3:	f7 75 f0             	divl   -0x10(%ebp)
  8017a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017a9:	29 d0                	sub    %edx,%eax
  8017ab:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  8017ae:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  8017b5:	e8 41 06 00 00       	call   801dfb <sys_isUHeapPlacementStrategyFIRSTFIT>
  8017ba:	85 c0                	test   %eax,%eax
  8017bc:	74 11                	je     8017cf <smalloc+0x65>
		mem_block = alloc_block_FF(allocate_space);
  8017be:	83 ec 0c             	sub    $0xc,%esp
  8017c1:	ff 75 e8             	pushl  -0x18(%ebp)
  8017c4:	e8 ac 0c 00 00       	call   802475 <alloc_block_FF>
  8017c9:	83 c4 10             	add    $0x10,%esp
  8017cc:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  8017cf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8017d3:	74 2a                	je     8017ff <smalloc+0x95>
	{
		virtual_address = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  8017d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017d8:	8b 40 08             	mov    0x8(%eax),%eax
  8017db:	89 c2                	mov    %eax,%edx
  8017dd:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8017e1:	52                   	push   %edx
  8017e2:	50                   	push   %eax
  8017e3:	ff 75 0c             	pushl  0xc(%ebp)
  8017e6:	ff 75 08             	pushl  0x8(%ebp)
  8017e9:	e8 92 03 00 00       	call   801b80 <sys_createSharedObject>
  8017ee:	83 c4 10             	add    $0x10,%esp
  8017f1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (virtual_address != -1)
  8017f4:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  8017f8:	74 05                	je     8017ff <smalloc+0x95>
			return (void*)virtual_address;
  8017fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017fd:	eb 05                	jmp    801804 <smalloc+0x9a>
	}
	return NULL;
  8017ff:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801804:	c9                   	leave  
  801805:	c3                   	ret    

00801806 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801806:	55                   	push   %ebp
  801807:	89 e5                	mov    %esp,%ebp
  801809:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80180c:	e8 c6 fc ff ff       	call   8014d7 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801811:	83 ec 04             	sub    $0x4,%esp
  801814:	68 c8 40 80 00       	push   $0x8040c8
  801819:	68 b0 00 00 00       	push   $0xb0
  80181e:	68 73 40 80 00       	push   $0x804073
  801823:	e8 71 ec ff ff       	call   800499 <_panic>

00801828 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801828:	55                   	push   %ebp
  801829:	89 e5                	mov    %esp,%ebp
  80182b:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80182e:	e8 a4 fc ff ff       	call   8014d7 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801833:	83 ec 04             	sub    $0x4,%esp
  801836:	68 ec 40 80 00       	push   $0x8040ec
  80183b:	68 f4 00 00 00       	push   $0xf4
  801840:	68 73 40 80 00       	push   $0x804073
  801845:	e8 4f ec ff ff       	call   800499 <_panic>

0080184a <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80184a:	55                   	push   %ebp
  80184b:	89 e5                	mov    %esp,%ebp
  80184d:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801850:	83 ec 04             	sub    $0x4,%esp
  801853:	68 14 41 80 00       	push   $0x804114
  801858:	68 08 01 00 00       	push   $0x108
  80185d:	68 73 40 80 00       	push   $0x804073
  801862:	e8 32 ec ff ff       	call   800499 <_panic>

00801867 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801867:	55                   	push   %ebp
  801868:	89 e5                	mov    %esp,%ebp
  80186a:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80186d:	83 ec 04             	sub    $0x4,%esp
  801870:	68 38 41 80 00       	push   $0x804138
  801875:	68 13 01 00 00       	push   $0x113
  80187a:	68 73 40 80 00       	push   $0x804073
  80187f:	e8 15 ec ff ff       	call   800499 <_panic>

00801884 <shrink>:

}
void shrink(uint32 newSize)
{
  801884:	55                   	push   %ebp
  801885:	89 e5                	mov    %esp,%ebp
  801887:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80188a:	83 ec 04             	sub    $0x4,%esp
  80188d:	68 38 41 80 00       	push   $0x804138
  801892:	68 18 01 00 00       	push   $0x118
  801897:	68 73 40 80 00       	push   $0x804073
  80189c:	e8 f8 eb ff ff       	call   800499 <_panic>

008018a1 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8018a1:	55                   	push   %ebp
  8018a2:	89 e5                	mov    %esp,%ebp
  8018a4:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018a7:	83 ec 04             	sub    $0x4,%esp
  8018aa:	68 38 41 80 00       	push   $0x804138
  8018af:	68 1d 01 00 00       	push   $0x11d
  8018b4:	68 73 40 80 00       	push   $0x804073
  8018b9:	e8 db eb ff ff       	call   800499 <_panic>

008018be <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8018be:	55                   	push   %ebp
  8018bf:	89 e5                	mov    %esp,%ebp
  8018c1:	57                   	push   %edi
  8018c2:	56                   	push   %esi
  8018c3:	53                   	push   %ebx
  8018c4:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8018c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018cd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018d0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018d3:	8b 7d 18             	mov    0x18(%ebp),%edi
  8018d6:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8018d9:	cd 30                	int    $0x30
  8018db:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8018de:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8018e1:	83 c4 10             	add    $0x10,%esp
  8018e4:	5b                   	pop    %ebx
  8018e5:	5e                   	pop    %esi
  8018e6:	5f                   	pop    %edi
  8018e7:	5d                   	pop    %ebp
  8018e8:	c3                   	ret    

008018e9 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8018e9:	55                   	push   %ebp
  8018ea:	89 e5                	mov    %esp,%ebp
  8018ec:	83 ec 04             	sub    $0x4,%esp
  8018ef:	8b 45 10             	mov    0x10(%ebp),%eax
  8018f2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8018f5:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8018f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fc:	6a 00                	push   $0x0
  8018fe:	6a 00                	push   $0x0
  801900:	52                   	push   %edx
  801901:	ff 75 0c             	pushl  0xc(%ebp)
  801904:	50                   	push   %eax
  801905:	6a 00                	push   $0x0
  801907:	e8 b2 ff ff ff       	call   8018be <syscall>
  80190c:	83 c4 18             	add    $0x18,%esp
}
  80190f:	90                   	nop
  801910:	c9                   	leave  
  801911:	c3                   	ret    

00801912 <sys_cgetc>:

int
sys_cgetc(void)
{
  801912:	55                   	push   %ebp
  801913:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801915:	6a 00                	push   $0x0
  801917:	6a 00                	push   $0x0
  801919:	6a 00                	push   $0x0
  80191b:	6a 00                	push   $0x0
  80191d:	6a 00                	push   $0x0
  80191f:	6a 01                	push   $0x1
  801921:	e8 98 ff ff ff       	call   8018be <syscall>
  801926:	83 c4 18             	add    $0x18,%esp
}
  801929:	c9                   	leave  
  80192a:	c3                   	ret    

0080192b <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80192b:	55                   	push   %ebp
  80192c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80192e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801931:	8b 45 08             	mov    0x8(%ebp),%eax
  801934:	6a 00                	push   $0x0
  801936:	6a 00                	push   $0x0
  801938:	6a 00                	push   $0x0
  80193a:	52                   	push   %edx
  80193b:	50                   	push   %eax
  80193c:	6a 05                	push   $0x5
  80193e:	e8 7b ff ff ff       	call   8018be <syscall>
  801943:	83 c4 18             	add    $0x18,%esp
}
  801946:	c9                   	leave  
  801947:	c3                   	ret    

00801948 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801948:	55                   	push   %ebp
  801949:	89 e5                	mov    %esp,%ebp
  80194b:	56                   	push   %esi
  80194c:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80194d:	8b 75 18             	mov    0x18(%ebp),%esi
  801950:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801953:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801956:	8b 55 0c             	mov    0xc(%ebp),%edx
  801959:	8b 45 08             	mov    0x8(%ebp),%eax
  80195c:	56                   	push   %esi
  80195d:	53                   	push   %ebx
  80195e:	51                   	push   %ecx
  80195f:	52                   	push   %edx
  801960:	50                   	push   %eax
  801961:	6a 06                	push   $0x6
  801963:	e8 56 ff ff ff       	call   8018be <syscall>
  801968:	83 c4 18             	add    $0x18,%esp
}
  80196b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80196e:	5b                   	pop    %ebx
  80196f:	5e                   	pop    %esi
  801970:	5d                   	pop    %ebp
  801971:	c3                   	ret    

00801972 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801972:	55                   	push   %ebp
  801973:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801975:	8b 55 0c             	mov    0xc(%ebp),%edx
  801978:	8b 45 08             	mov    0x8(%ebp),%eax
  80197b:	6a 00                	push   $0x0
  80197d:	6a 00                	push   $0x0
  80197f:	6a 00                	push   $0x0
  801981:	52                   	push   %edx
  801982:	50                   	push   %eax
  801983:	6a 07                	push   $0x7
  801985:	e8 34 ff ff ff       	call   8018be <syscall>
  80198a:	83 c4 18             	add    $0x18,%esp
}
  80198d:	c9                   	leave  
  80198e:	c3                   	ret    

0080198f <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80198f:	55                   	push   %ebp
  801990:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801992:	6a 00                	push   $0x0
  801994:	6a 00                	push   $0x0
  801996:	6a 00                	push   $0x0
  801998:	ff 75 0c             	pushl  0xc(%ebp)
  80199b:	ff 75 08             	pushl  0x8(%ebp)
  80199e:	6a 08                	push   $0x8
  8019a0:	e8 19 ff ff ff       	call   8018be <syscall>
  8019a5:	83 c4 18             	add    $0x18,%esp
}
  8019a8:	c9                   	leave  
  8019a9:	c3                   	ret    

008019aa <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8019aa:	55                   	push   %ebp
  8019ab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8019ad:	6a 00                	push   $0x0
  8019af:	6a 00                	push   $0x0
  8019b1:	6a 00                	push   $0x0
  8019b3:	6a 00                	push   $0x0
  8019b5:	6a 00                	push   $0x0
  8019b7:	6a 09                	push   $0x9
  8019b9:	e8 00 ff ff ff       	call   8018be <syscall>
  8019be:	83 c4 18             	add    $0x18,%esp
}
  8019c1:	c9                   	leave  
  8019c2:	c3                   	ret    

008019c3 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8019c3:	55                   	push   %ebp
  8019c4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8019c6:	6a 00                	push   $0x0
  8019c8:	6a 00                	push   $0x0
  8019ca:	6a 00                	push   $0x0
  8019cc:	6a 00                	push   $0x0
  8019ce:	6a 00                	push   $0x0
  8019d0:	6a 0a                	push   $0xa
  8019d2:	e8 e7 fe ff ff       	call   8018be <syscall>
  8019d7:	83 c4 18             	add    $0x18,%esp
}
  8019da:	c9                   	leave  
  8019db:	c3                   	ret    

008019dc <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8019dc:	55                   	push   %ebp
  8019dd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8019df:	6a 00                	push   $0x0
  8019e1:	6a 00                	push   $0x0
  8019e3:	6a 00                	push   $0x0
  8019e5:	6a 00                	push   $0x0
  8019e7:	6a 00                	push   $0x0
  8019e9:	6a 0b                	push   $0xb
  8019eb:	e8 ce fe ff ff       	call   8018be <syscall>
  8019f0:	83 c4 18             	add    $0x18,%esp
}
  8019f3:	c9                   	leave  
  8019f4:	c3                   	ret    

008019f5 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8019f5:	55                   	push   %ebp
  8019f6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8019f8:	6a 00                	push   $0x0
  8019fa:	6a 00                	push   $0x0
  8019fc:	6a 00                	push   $0x0
  8019fe:	ff 75 0c             	pushl  0xc(%ebp)
  801a01:	ff 75 08             	pushl  0x8(%ebp)
  801a04:	6a 0f                	push   $0xf
  801a06:	e8 b3 fe ff ff       	call   8018be <syscall>
  801a0b:	83 c4 18             	add    $0x18,%esp
	return;
  801a0e:	90                   	nop
}
  801a0f:	c9                   	leave  
  801a10:	c3                   	ret    

00801a11 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801a11:	55                   	push   %ebp
  801a12:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801a14:	6a 00                	push   $0x0
  801a16:	6a 00                	push   $0x0
  801a18:	6a 00                	push   $0x0
  801a1a:	ff 75 0c             	pushl  0xc(%ebp)
  801a1d:	ff 75 08             	pushl  0x8(%ebp)
  801a20:	6a 10                	push   $0x10
  801a22:	e8 97 fe ff ff       	call   8018be <syscall>
  801a27:	83 c4 18             	add    $0x18,%esp
	return ;
  801a2a:	90                   	nop
}
  801a2b:	c9                   	leave  
  801a2c:	c3                   	ret    

00801a2d <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801a2d:	55                   	push   %ebp
  801a2e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801a30:	6a 00                	push   $0x0
  801a32:	6a 00                	push   $0x0
  801a34:	ff 75 10             	pushl  0x10(%ebp)
  801a37:	ff 75 0c             	pushl  0xc(%ebp)
  801a3a:	ff 75 08             	pushl  0x8(%ebp)
  801a3d:	6a 11                	push   $0x11
  801a3f:	e8 7a fe ff ff       	call   8018be <syscall>
  801a44:	83 c4 18             	add    $0x18,%esp
	return ;
  801a47:	90                   	nop
}
  801a48:	c9                   	leave  
  801a49:	c3                   	ret    

00801a4a <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801a4a:	55                   	push   %ebp
  801a4b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801a4d:	6a 00                	push   $0x0
  801a4f:	6a 00                	push   $0x0
  801a51:	6a 00                	push   $0x0
  801a53:	6a 00                	push   $0x0
  801a55:	6a 00                	push   $0x0
  801a57:	6a 0c                	push   $0xc
  801a59:	e8 60 fe ff ff       	call   8018be <syscall>
  801a5e:	83 c4 18             	add    $0x18,%esp
}
  801a61:	c9                   	leave  
  801a62:	c3                   	ret    

00801a63 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801a63:	55                   	push   %ebp
  801a64:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801a66:	6a 00                	push   $0x0
  801a68:	6a 00                	push   $0x0
  801a6a:	6a 00                	push   $0x0
  801a6c:	6a 00                	push   $0x0
  801a6e:	ff 75 08             	pushl  0x8(%ebp)
  801a71:	6a 0d                	push   $0xd
  801a73:	e8 46 fe ff ff       	call   8018be <syscall>
  801a78:	83 c4 18             	add    $0x18,%esp
}
  801a7b:	c9                   	leave  
  801a7c:	c3                   	ret    

00801a7d <sys_scarce_memory>:

void sys_scarce_memory()
{
  801a7d:	55                   	push   %ebp
  801a7e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801a80:	6a 00                	push   $0x0
  801a82:	6a 00                	push   $0x0
  801a84:	6a 00                	push   $0x0
  801a86:	6a 00                	push   $0x0
  801a88:	6a 00                	push   $0x0
  801a8a:	6a 0e                	push   $0xe
  801a8c:	e8 2d fe ff ff       	call   8018be <syscall>
  801a91:	83 c4 18             	add    $0x18,%esp
}
  801a94:	90                   	nop
  801a95:	c9                   	leave  
  801a96:	c3                   	ret    

00801a97 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801a97:	55                   	push   %ebp
  801a98:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801a9a:	6a 00                	push   $0x0
  801a9c:	6a 00                	push   $0x0
  801a9e:	6a 00                	push   $0x0
  801aa0:	6a 00                	push   $0x0
  801aa2:	6a 00                	push   $0x0
  801aa4:	6a 13                	push   $0x13
  801aa6:	e8 13 fe ff ff       	call   8018be <syscall>
  801aab:	83 c4 18             	add    $0x18,%esp
}
  801aae:	90                   	nop
  801aaf:	c9                   	leave  
  801ab0:	c3                   	ret    

00801ab1 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801ab1:	55                   	push   %ebp
  801ab2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801ab4:	6a 00                	push   $0x0
  801ab6:	6a 00                	push   $0x0
  801ab8:	6a 00                	push   $0x0
  801aba:	6a 00                	push   $0x0
  801abc:	6a 00                	push   $0x0
  801abe:	6a 14                	push   $0x14
  801ac0:	e8 f9 fd ff ff       	call   8018be <syscall>
  801ac5:	83 c4 18             	add    $0x18,%esp
}
  801ac8:	90                   	nop
  801ac9:	c9                   	leave  
  801aca:	c3                   	ret    

00801acb <sys_cputc>:


void
sys_cputc(const char c)
{
  801acb:	55                   	push   %ebp
  801acc:	89 e5                	mov    %esp,%ebp
  801ace:	83 ec 04             	sub    $0x4,%esp
  801ad1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801ad7:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801adb:	6a 00                	push   $0x0
  801add:	6a 00                	push   $0x0
  801adf:	6a 00                	push   $0x0
  801ae1:	6a 00                	push   $0x0
  801ae3:	50                   	push   %eax
  801ae4:	6a 15                	push   $0x15
  801ae6:	e8 d3 fd ff ff       	call   8018be <syscall>
  801aeb:	83 c4 18             	add    $0x18,%esp
}
  801aee:	90                   	nop
  801aef:	c9                   	leave  
  801af0:	c3                   	ret    

00801af1 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801af1:	55                   	push   %ebp
  801af2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801af4:	6a 00                	push   $0x0
  801af6:	6a 00                	push   $0x0
  801af8:	6a 00                	push   $0x0
  801afa:	6a 00                	push   $0x0
  801afc:	6a 00                	push   $0x0
  801afe:	6a 16                	push   $0x16
  801b00:	e8 b9 fd ff ff       	call   8018be <syscall>
  801b05:	83 c4 18             	add    $0x18,%esp
}
  801b08:	90                   	nop
  801b09:	c9                   	leave  
  801b0a:	c3                   	ret    

00801b0b <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801b0b:	55                   	push   %ebp
  801b0c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801b0e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b11:	6a 00                	push   $0x0
  801b13:	6a 00                	push   $0x0
  801b15:	6a 00                	push   $0x0
  801b17:	ff 75 0c             	pushl  0xc(%ebp)
  801b1a:	50                   	push   %eax
  801b1b:	6a 17                	push   $0x17
  801b1d:	e8 9c fd ff ff       	call   8018be <syscall>
  801b22:	83 c4 18             	add    $0x18,%esp
}
  801b25:	c9                   	leave  
  801b26:	c3                   	ret    

00801b27 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801b27:	55                   	push   %ebp
  801b28:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b2a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b30:	6a 00                	push   $0x0
  801b32:	6a 00                	push   $0x0
  801b34:	6a 00                	push   $0x0
  801b36:	52                   	push   %edx
  801b37:	50                   	push   %eax
  801b38:	6a 1a                	push   $0x1a
  801b3a:	e8 7f fd ff ff       	call   8018be <syscall>
  801b3f:	83 c4 18             	add    $0x18,%esp
}
  801b42:	c9                   	leave  
  801b43:	c3                   	ret    

00801b44 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b44:	55                   	push   %ebp
  801b45:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b47:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4d:	6a 00                	push   $0x0
  801b4f:	6a 00                	push   $0x0
  801b51:	6a 00                	push   $0x0
  801b53:	52                   	push   %edx
  801b54:	50                   	push   %eax
  801b55:	6a 18                	push   $0x18
  801b57:	e8 62 fd ff ff       	call   8018be <syscall>
  801b5c:	83 c4 18             	add    $0x18,%esp
}
  801b5f:	90                   	nop
  801b60:	c9                   	leave  
  801b61:	c3                   	ret    

00801b62 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b62:	55                   	push   %ebp
  801b63:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b65:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b68:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6b:	6a 00                	push   $0x0
  801b6d:	6a 00                	push   $0x0
  801b6f:	6a 00                	push   $0x0
  801b71:	52                   	push   %edx
  801b72:	50                   	push   %eax
  801b73:	6a 19                	push   $0x19
  801b75:	e8 44 fd ff ff       	call   8018be <syscall>
  801b7a:	83 c4 18             	add    $0x18,%esp
}
  801b7d:	90                   	nop
  801b7e:	c9                   	leave  
  801b7f:	c3                   	ret    

00801b80 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801b80:	55                   	push   %ebp
  801b81:	89 e5                	mov    %esp,%ebp
  801b83:	83 ec 04             	sub    $0x4,%esp
  801b86:	8b 45 10             	mov    0x10(%ebp),%eax
  801b89:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b8c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b8f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b93:	8b 45 08             	mov    0x8(%ebp),%eax
  801b96:	6a 00                	push   $0x0
  801b98:	51                   	push   %ecx
  801b99:	52                   	push   %edx
  801b9a:	ff 75 0c             	pushl  0xc(%ebp)
  801b9d:	50                   	push   %eax
  801b9e:	6a 1b                	push   $0x1b
  801ba0:	e8 19 fd ff ff       	call   8018be <syscall>
  801ba5:	83 c4 18             	add    $0x18,%esp
}
  801ba8:	c9                   	leave  
  801ba9:	c3                   	ret    

00801baa <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801baa:	55                   	push   %ebp
  801bab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801bad:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bb0:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb3:	6a 00                	push   $0x0
  801bb5:	6a 00                	push   $0x0
  801bb7:	6a 00                	push   $0x0
  801bb9:	52                   	push   %edx
  801bba:	50                   	push   %eax
  801bbb:	6a 1c                	push   $0x1c
  801bbd:	e8 fc fc ff ff       	call   8018be <syscall>
  801bc2:	83 c4 18             	add    $0x18,%esp
}
  801bc5:	c9                   	leave  
  801bc6:	c3                   	ret    

00801bc7 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801bc7:	55                   	push   %ebp
  801bc8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801bca:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801bcd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bd0:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd3:	6a 00                	push   $0x0
  801bd5:	6a 00                	push   $0x0
  801bd7:	51                   	push   %ecx
  801bd8:	52                   	push   %edx
  801bd9:	50                   	push   %eax
  801bda:	6a 1d                	push   $0x1d
  801bdc:	e8 dd fc ff ff       	call   8018be <syscall>
  801be1:	83 c4 18             	add    $0x18,%esp
}
  801be4:	c9                   	leave  
  801be5:	c3                   	ret    

00801be6 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801be6:	55                   	push   %ebp
  801be7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801be9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bec:	8b 45 08             	mov    0x8(%ebp),%eax
  801bef:	6a 00                	push   $0x0
  801bf1:	6a 00                	push   $0x0
  801bf3:	6a 00                	push   $0x0
  801bf5:	52                   	push   %edx
  801bf6:	50                   	push   %eax
  801bf7:	6a 1e                	push   $0x1e
  801bf9:	e8 c0 fc ff ff       	call   8018be <syscall>
  801bfe:	83 c4 18             	add    $0x18,%esp
}
  801c01:	c9                   	leave  
  801c02:	c3                   	ret    

00801c03 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801c03:	55                   	push   %ebp
  801c04:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801c06:	6a 00                	push   $0x0
  801c08:	6a 00                	push   $0x0
  801c0a:	6a 00                	push   $0x0
  801c0c:	6a 00                	push   $0x0
  801c0e:	6a 00                	push   $0x0
  801c10:	6a 1f                	push   $0x1f
  801c12:	e8 a7 fc ff ff       	call   8018be <syscall>
  801c17:	83 c4 18             	add    $0x18,%esp
}
  801c1a:	c9                   	leave  
  801c1b:	c3                   	ret    

00801c1c <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801c1c:	55                   	push   %ebp
  801c1d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801c1f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c22:	6a 00                	push   $0x0
  801c24:	ff 75 14             	pushl  0x14(%ebp)
  801c27:	ff 75 10             	pushl  0x10(%ebp)
  801c2a:	ff 75 0c             	pushl  0xc(%ebp)
  801c2d:	50                   	push   %eax
  801c2e:	6a 20                	push   $0x20
  801c30:	e8 89 fc ff ff       	call   8018be <syscall>
  801c35:	83 c4 18             	add    $0x18,%esp
}
  801c38:	c9                   	leave  
  801c39:	c3                   	ret    

00801c3a <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801c3a:	55                   	push   %ebp
  801c3b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801c3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c40:	6a 00                	push   $0x0
  801c42:	6a 00                	push   $0x0
  801c44:	6a 00                	push   $0x0
  801c46:	6a 00                	push   $0x0
  801c48:	50                   	push   %eax
  801c49:	6a 21                	push   $0x21
  801c4b:	e8 6e fc ff ff       	call   8018be <syscall>
  801c50:	83 c4 18             	add    $0x18,%esp
}
  801c53:	90                   	nop
  801c54:	c9                   	leave  
  801c55:	c3                   	ret    

00801c56 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801c56:	55                   	push   %ebp
  801c57:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801c59:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5c:	6a 00                	push   $0x0
  801c5e:	6a 00                	push   $0x0
  801c60:	6a 00                	push   $0x0
  801c62:	6a 00                	push   $0x0
  801c64:	50                   	push   %eax
  801c65:	6a 22                	push   $0x22
  801c67:	e8 52 fc ff ff       	call   8018be <syscall>
  801c6c:	83 c4 18             	add    $0x18,%esp
}
  801c6f:	c9                   	leave  
  801c70:	c3                   	ret    

00801c71 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801c71:	55                   	push   %ebp
  801c72:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801c74:	6a 00                	push   $0x0
  801c76:	6a 00                	push   $0x0
  801c78:	6a 00                	push   $0x0
  801c7a:	6a 00                	push   $0x0
  801c7c:	6a 00                	push   $0x0
  801c7e:	6a 02                	push   $0x2
  801c80:	e8 39 fc ff ff       	call   8018be <syscall>
  801c85:	83 c4 18             	add    $0x18,%esp
}
  801c88:	c9                   	leave  
  801c89:	c3                   	ret    

00801c8a <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c8a:	55                   	push   %ebp
  801c8b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c8d:	6a 00                	push   $0x0
  801c8f:	6a 00                	push   $0x0
  801c91:	6a 00                	push   $0x0
  801c93:	6a 00                	push   $0x0
  801c95:	6a 00                	push   $0x0
  801c97:	6a 03                	push   $0x3
  801c99:	e8 20 fc ff ff       	call   8018be <syscall>
  801c9e:	83 c4 18             	add    $0x18,%esp
}
  801ca1:	c9                   	leave  
  801ca2:	c3                   	ret    

00801ca3 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801ca3:	55                   	push   %ebp
  801ca4:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801ca6:	6a 00                	push   $0x0
  801ca8:	6a 00                	push   $0x0
  801caa:	6a 00                	push   $0x0
  801cac:	6a 00                	push   $0x0
  801cae:	6a 00                	push   $0x0
  801cb0:	6a 04                	push   $0x4
  801cb2:	e8 07 fc ff ff       	call   8018be <syscall>
  801cb7:	83 c4 18             	add    $0x18,%esp
}
  801cba:	c9                   	leave  
  801cbb:	c3                   	ret    

00801cbc <sys_exit_env>:


void sys_exit_env(void)
{
  801cbc:	55                   	push   %ebp
  801cbd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801cbf:	6a 00                	push   $0x0
  801cc1:	6a 00                	push   $0x0
  801cc3:	6a 00                	push   $0x0
  801cc5:	6a 00                	push   $0x0
  801cc7:	6a 00                	push   $0x0
  801cc9:	6a 23                	push   $0x23
  801ccb:	e8 ee fb ff ff       	call   8018be <syscall>
  801cd0:	83 c4 18             	add    $0x18,%esp
}
  801cd3:	90                   	nop
  801cd4:	c9                   	leave  
  801cd5:	c3                   	ret    

00801cd6 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801cd6:	55                   	push   %ebp
  801cd7:	89 e5                	mov    %esp,%ebp
  801cd9:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801cdc:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801cdf:	8d 50 04             	lea    0x4(%eax),%edx
  801ce2:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ce5:	6a 00                	push   $0x0
  801ce7:	6a 00                	push   $0x0
  801ce9:	6a 00                	push   $0x0
  801ceb:	52                   	push   %edx
  801cec:	50                   	push   %eax
  801ced:	6a 24                	push   $0x24
  801cef:	e8 ca fb ff ff       	call   8018be <syscall>
  801cf4:	83 c4 18             	add    $0x18,%esp
	return result;
  801cf7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801cfa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801cfd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d00:	89 01                	mov    %eax,(%ecx)
  801d02:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801d05:	8b 45 08             	mov    0x8(%ebp),%eax
  801d08:	c9                   	leave  
  801d09:	c2 04 00             	ret    $0x4

00801d0c <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801d0c:	55                   	push   %ebp
  801d0d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801d0f:	6a 00                	push   $0x0
  801d11:	6a 00                	push   $0x0
  801d13:	ff 75 10             	pushl  0x10(%ebp)
  801d16:	ff 75 0c             	pushl  0xc(%ebp)
  801d19:	ff 75 08             	pushl  0x8(%ebp)
  801d1c:	6a 12                	push   $0x12
  801d1e:	e8 9b fb ff ff       	call   8018be <syscall>
  801d23:	83 c4 18             	add    $0x18,%esp
	return ;
  801d26:	90                   	nop
}
  801d27:	c9                   	leave  
  801d28:	c3                   	ret    

00801d29 <sys_rcr2>:
uint32 sys_rcr2()
{
  801d29:	55                   	push   %ebp
  801d2a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801d2c:	6a 00                	push   $0x0
  801d2e:	6a 00                	push   $0x0
  801d30:	6a 00                	push   $0x0
  801d32:	6a 00                	push   $0x0
  801d34:	6a 00                	push   $0x0
  801d36:	6a 25                	push   $0x25
  801d38:	e8 81 fb ff ff       	call   8018be <syscall>
  801d3d:	83 c4 18             	add    $0x18,%esp
}
  801d40:	c9                   	leave  
  801d41:	c3                   	ret    

00801d42 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801d42:	55                   	push   %ebp
  801d43:	89 e5                	mov    %esp,%ebp
  801d45:	83 ec 04             	sub    $0x4,%esp
  801d48:	8b 45 08             	mov    0x8(%ebp),%eax
  801d4b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801d4e:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801d52:	6a 00                	push   $0x0
  801d54:	6a 00                	push   $0x0
  801d56:	6a 00                	push   $0x0
  801d58:	6a 00                	push   $0x0
  801d5a:	50                   	push   %eax
  801d5b:	6a 26                	push   $0x26
  801d5d:	e8 5c fb ff ff       	call   8018be <syscall>
  801d62:	83 c4 18             	add    $0x18,%esp
	return ;
  801d65:	90                   	nop
}
  801d66:	c9                   	leave  
  801d67:	c3                   	ret    

00801d68 <rsttst>:
void rsttst()
{
  801d68:	55                   	push   %ebp
  801d69:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801d6b:	6a 00                	push   $0x0
  801d6d:	6a 00                	push   $0x0
  801d6f:	6a 00                	push   $0x0
  801d71:	6a 00                	push   $0x0
  801d73:	6a 00                	push   $0x0
  801d75:	6a 28                	push   $0x28
  801d77:	e8 42 fb ff ff       	call   8018be <syscall>
  801d7c:	83 c4 18             	add    $0x18,%esp
	return ;
  801d7f:	90                   	nop
}
  801d80:	c9                   	leave  
  801d81:	c3                   	ret    

00801d82 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d82:	55                   	push   %ebp
  801d83:	89 e5                	mov    %esp,%ebp
  801d85:	83 ec 04             	sub    $0x4,%esp
  801d88:	8b 45 14             	mov    0x14(%ebp),%eax
  801d8b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d8e:	8b 55 18             	mov    0x18(%ebp),%edx
  801d91:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d95:	52                   	push   %edx
  801d96:	50                   	push   %eax
  801d97:	ff 75 10             	pushl  0x10(%ebp)
  801d9a:	ff 75 0c             	pushl  0xc(%ebp)
  801d9d:	ff 75 08             	pushl  0x8(%ebp)
  801da0:	6a 27                	push   $0x27
  801da2:	e8 17 fb ff ff       	call   8018be <syscall>
  801da7:	83 c4 18             	add    $0x18,%esp
	return ;
  801daa:	90                   	nop
}
  801dab:	c9                   	leave  
  801dac:	c3                   	ret    

00801dad <chktst>:
void chktst(uint32 n)
{
  801dad:	55                   	push   %ebp
  801dae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801db0:	6a 00                	push   $0x0
  801db2:	6a 00                	push   $0x0
  801db4:	6a 00                	push   $0x0
  801db6:	6a 00                	push   $0x0
  801db8:	ff 75 08             	pushl  0x8(%ebp)
  801dbb:	6a 29                	push   $0x29
  801dbd:	e8 fc fa ff ff       	call   8018be <syscall>
  801dc2:	83 c4 18             	add    $0x18,%esp
	return ;
  801dc5:	90                   	nop
}
  801dc6:	c9                   	leave  
  801dc7:	c3                   	ret    

00801dc8 <inctst>:

void inctst()
{
  801dc8:	55                   	push   %ebp
  801dc9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801dcb:	6a 00                	push   $0x0
  801dcd:	6a 00                	push   $0x0
  801dcf:	6a 00                	push   $0x0
  801dd1:	6a 00                	push   $0x0
  801dd3:	6a 00                	push   $0x0
  801dd5:	6a 2a                	push   $0x2a
  801dd7:	e8 e2 fa ff ff       	call   8018be <syscall>
  801ddc:	83 c4 18             	add    $0x18,%esp
	return ;
  801ddf:	90                   	nop
}
  801de0:	c9                   	leave  
  801de1:	c3                   	ret    

00801de2 <gettst>:
uint32 gettst()
{
  801de2:	55                   	push   %ebp
  801de3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801de5:	6a 00                	push   $0x0
  801de7:	6a 00                	push   $0x0
  801de9:	6a 00                	push   $0x0
  801deb:	6a 00                	push   $0x0
  801ded:	6a 00                	push   $0x0
  801def:	6a 2b                	push   $0x2b
  801df1:	e8 c8 fa ff ff       	call   8018be <syscall>
  801df6:	83 c4 18             	add    $0x18,%esp
}
  801df9:	c9                   	leave  
  801dfa:	c3                   	ret    

00801dfb <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801dfb:	55                   	push   %ebp
  801dfc:	89 e5                	mov    %esp,%ebp
  801dfe:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e01:	6a 00                	push   $0x0
  801e03:	6a 00                	push   $0x0
  801e05:	6a 00                	push   $0x0
  801e07:	6a 00                	push   $0x0
  801e09:	6a 00                	push   $0x0
  801e0b:	6a 2c                	push   $0x2c
  801e0d:	e8 ac fa ff ff       	call   8018be <syscall>
  801e12:	83 c4 18             	add    $0x18,%esp
  801e15:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801e18:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801e1c:	75 07                	jne    801e25 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801e1e:	b8 01 00 00 00       	mov    $0x1,%eax
  801e23:	eb 05                	jmp    801e2a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801e25:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e2a:	c9                   	leave  
  801e2b:	c3                   	ret    

00801e2c <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801e2c:	55                   	push   %ebp
  801e2d:	89 e5                	mov    %esp,%ebp
  801e2f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e32:	6a 00                	push   $0x0
  801e34:	6a 00                	push   $0x0
  801e36:	6a 00                	push   $0x0
  801e38:	6a 00                	push   $0x0
  801e3a:	6a 00                	push   $0x0
  801e3c:	6a 2c                	push   $0x2c
  801e3e:	e8 7b fa ff ff       	call   8018be <syscall>
  801e43:	83 c4 18             	add    $0x18,%esp
  801e46:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801e49:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801e4d:	75 07                	jne    801e56 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801e4f:	b8 01 00 00 00       	mov    $0x1,%eax
  801e54:	eb 05                	jmp    801e5b <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801e56:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e5b:	c9                   	leave  
  801e5c:	c3                   	ret    

00801e5d <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801e5d:	55                   	push   %ebp
  801e5e:	89 e5                	mov    %esp,%ebp
  801e60:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e63:	6a 00                	push   $0x0
  801e65:	6a 00                	push   $0x0
  801e67:	6a 00                	push   $0x0
  801e69:	6a 00                	push   $0x0
  801e6b:	6a 00                	push   $0x0
  801e6d:	6a 2c                	push   $0x2c
  801e6f:	e8 4a fa ff ff       	call   8018be <syscall>
  801e74:	83 c4 18             	add    $0x18,%esp
  801e77:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801e7a:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801e7e:	75 07                	jne    801e87 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801e80:	b8 01 00 00 00       	mov    $0x1,%eax
  801e85:	eb 05                	jmp    801e8c <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801e87:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e8c:	c9                   	leave  
  801e8d:	c3                   	ret    

00801e8e <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801e8e:	55                   	push   %ebp
  801e8f:	89 e5                	mov    %esp,%ebp
  801e91:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e94:	6a 00                	push   $0x0
  801e96:	6a 00                	push   $0x0
  801e98:	6a 00                	push   $0x0
  801e9a:	6a 00                	push   $0x0
  801e9c:	6a 00                	push   $0x0
  801e9e:	6a 2c                	push   $0x2c
  801ea0:	e8 19 fa ff ff       	call   8018be <syscall>
  801ea5:	83 c4 18             	add    $0x18,%esp
  801ea8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801eab:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801eaf:	75 07                	jne    801eb8 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801eb1:	b8 01 00 00 00       	mov    $0x1,%eax
  801eb6:	eb 05                	jmp    801ebd <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801eb8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ebd:	c9                   	leave  
  801ebe:	c3                   	ret    

00801ebf <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801ebf:	55                   	push   %ebp
  801ec0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801ec2:	6a 00                	push   $0x0
  801ec4:	6a 00                	push   $0x0
  801ec6:	6a 00                	push   $0x0
  801ec8:	6a 00                	push   $0x0
  801eca:	ff 75 08             	pushl  0x8(%ebp)
  801ecd:	6a 2d                	push   $0x2d
  801ecf:	e8 ea f9 ff ff       	call   8018be <syscall>
  801ed4:	83 c4 18             	add    $0x18,%esp
	return ;
  801ed7:	90                   	nop
}
  801ed8:	c9                   	leave  
  801ed9:	c3                   	ret    

00801eda <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801eda:	55                   	push   %ebp
  801edb:	89 e5                	mov    %esp,%ebp
  801edd:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801ede:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ee1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ee4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ee7:	8b 45 08             	mov    0x8(%ebp),%eax
  801eea:	6a 00                	push   $0x0
  801eec:	53                   	push   %ebx
  801eed:	51                   	push   %ecx
  801eee:	52                   	push   %edx
  801eef:	50                   	push   %eax
  801ef0:	6a 2e                	push   $0x2e
  801ef2:	e8 c7 f9 ff ff       	call   8018be <syscall>
  801ef7:	83 c4 18             	add    $0x18,%esp
}
  801efa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801efd:	c9                   	leave  
  801efe:	c3                   	ret    

00801eff <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801eff:	55                   	push   %ebp
  801f00:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801f02:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f05:	8b 45 08             	mov    0x8(%ebp),%eax
  801f08:	6a 00                	push   $0x0
  801f0a:	6a 00                	push   $0x0
  801f0c:	6a 00                	push   $0x0
  801f0e:	52                   	push   %edx
  801f0f:	50                   	push   %eax
  801f10:	6a 2f                	push   $0x2f
  801f12:	e8 a7 f9 ff ff       	call   8018be <syscall>
  801f17:	83 c4 18             	add    $0x18,%esp
}
  801f1a:	c9                   	leave  
  801f1b:	c3                   	ret    

00801f1c <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801f1c:	55                   	push   %ebp
  801f1d:	89 e5                	mov    %esp,%ebp
  801f1f:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801f22:	83 ec 0c             	sub    $0xc,%esp
  801f25:	68 48 41 80 00       	push   $0x804148
  801f2a:	e8 1e e8 ff ff       	call   80074d <cprintf>
  801f2f:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801f32:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801f39:	83 ec 0c             	sub    $0xc,%esp
  801f3c:	68 74 41 80 00       	push   $0x804174
  801f41:	e8 07 e8 ff ff       	call   80074d <cprintf>
  801f46:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801f49:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f4d:	a1 38 51 80 00       	mov    0x805138,%eax
  801f52:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f55:	eb 56                	jmp    801fad <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f57:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f5b:	74 1c                	je     801f79 <print_mem_block_lists+0x5d>
  801f5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f60:	8b 50 08             	mov    0x8(%eax),%edx
  801f63:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f66:	8b 48 08             	mov    0x8(%eax),%ecx
  801f69:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f6c:	8b 40 0c             	mov    0xc(%eax),%eax
  801f6f:	01 c8                	add    %ecx,%eax
  801f71:	39 c2                	cmp    %eax,%edx
  801f73:	73 04                	jae    801f79 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801f75:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f7c:	8b 50 08             	mov    0x8(%eax),%edx
  801f7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f82:	8b 40 0c             	mov    0xc(%eax),%eax
  801f85:	01 c2                	add    %eax,%edx
  801f87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f8a:	8b 40 08             	mov    0x8(%eax),%eax
  801f8d:	83 ec 04             	sub    $0x4,%esp
  801f90:	52                   	push   %edx
  801f91:	50                   	push   %eax
  801f92:	68 89 41 80 00       	push   $0x804189
  801f97:	e8 b1 e7 ff ff       	call   80074d <cprintf>
  801f9c:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fa2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801fa5:	a1 40 51 80 00       	mov    0x805140,%eax
  801faa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fb1:	74 07                	je     801fba <print_mem_block_lists+0x9e>
  801fb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb6:	8b 00                	mov    (%eax),%eax
  801fb8:	eb 05                	jmp    801fbf <print_mem_block_lists+0xa3>
  801fba:	b8 00 00 00 00       	mov    $0x0,%eax
  801fbf:	a3 40 51 80 00       	mov    %eax,0x805140
  801fc4:	a1 40 51 80 00       	mov    0x805140,%eax
  801fc9:	85 c0                	test   %eax,%eax
  801fcb:	75 8a                	jne    801f57 <print_mem_block_lists+0x3b>
  801fcd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fd1:	75 84                	jne    801f57 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801fd3:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801fd7:	75 10                	jne    801fe9 <print_mem_block_lists+0xcd>
  801fd9:	83 ec 0c             	sub    $0xc,%esp
  801fdc:	68 98 41 80 00       	push   $0x804198
  801fe1:	e8 67 e7 ff ff       	call   80074d <cprintf>
  801fe6:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801fe9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801ff0:	83 ec 0c             	sub    $0xc,%esp
  801ff3:	68 bc 41 80 00       	push   $0x8041bc
  801ff8:	e8 50 e7 ff ff       	call   80074d <cprintf>
  801ffd:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802000:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802004:	a1 40 50 80 00       	mov    0x805040,%eax
  802009:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80200c:	eb 56                	jmp    802064 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80200e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802012:	74 1c                	je     802030 <print_mem_block_lists+0x114>
  802014:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802017:	8b 50 08             	mov    0x8(%eax),%edx
  80201a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80201d:	8b 48 08             	mov    0x8(%eax),%ecx
  802020:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802023:	8b 40 0c             	mov    0xc(%eax),%eax
  802026:	01 c8                	add    %ecx,%eax
  802028:	39 c2                	cmp    %eax,%edx
  80202a:	73 04                	jae    802030 <print_mem_block_lists+0x114>
			sorted = 0 ;
  80202c:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802030:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802033:	8b 50 08             	mov    0x8(%eax),%edx
  802036:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802039:	8b 40 0c             	mov    0xc(%eax),%eax
  80203c:	01 c2                	add    %eax,%edx
  80203e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802041:	8b 40 08             	mov    0x8(%eax),%eax
  802044:	83 ec 04             	sub    $0x4,%esp
  802047:	52                   	push   %edx
  802048:	50                   	push   %eax
  802049:	68 89 41 80 00       	push   $0x804189
  80204e:	e8 fa e6 ff ff       	call   80074d <cprintf>
  802053:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802056:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802059:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80205c:	a1 48 50 80 00       	mov    0x805048,%eax
  802061:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802064:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802068:	74 07                	je     802071 <print_mem_block_lists+0x155>
  80206a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80206d:	8b 00                	mov    (%eax),%eax
  80206f:	eb 05                	jmp    802076 <print_mem_block_lists+0x15a>
  802071:	b8 00 00 00 00       	mov    $0x0,%eax
  802076:	a3 48 50 80 00       	mov    %eax,0x805048
  80207b:	a1 48 50 80 00       	mov    0x805048,%eax
  802080:	85 c0                	test   %eax,%eax
  802082:	75 8a                	jne    80200e <print_mem_block_lists+0xf2>
  802084:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802088:	75 84                	jne    80200e <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  80208a:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80208e:	75 10                	jne    8020a0 <print_mem_block_lists+0x184>
  802090:	83 ec 0c             	sub    $0xc,%esp
  802093:	68 d4 41 80 00       	push   $0x8041d4
  802098:	e8 b0 e6 ff ff       	call   80074d <cprintf>
  80209d:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8020a0:	83 ec 0c             	sub    $0xc,%esp
  8020a3:	68 48 41 80 00       	push   $0x804148
  8020a8:	e8 a0 e6 ff ff       	call   80074d <cprintf>
  8020ad:	83 c4 10             	add    $0x10,%esp

}
  8020b0:	90                   	nop
  8020b1:	c9                   	leave  
  8020b2:	c3                   	ret    

008020b3 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8020b3:	55                   	push   %ebp
  8020b4:	89 e5                	mov    %esp,%ebp
  8020b6:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  8020b9:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  8020c0:	00 00 00 
  8020c3:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  8020ca:	00 00 00 
  8020cd:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  8020d4:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  8020d7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8020de:	e9 9e 00 00 00       	jmp    802181 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  8020e3:	a1 50 50 80 00       	mov    0x805050,%eax
  8020e8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020eb:	c1 e2 04             	shl    $0x4,%edx
  8020ee:	01 d0                	add    %edx,%eax
  8020f0:	85 c0                	test   %eax,%eax
  8020f2:	75 14                	jne    802108 <initialize_MemBlocksList+0x55>
  8020f4:	83 ec 04             	sub    $0x4,%esp
  8020f7:	68 fc 41 80 00       	push   $0x8041fc
  8020fc:	6a 46                	push   $0x46
  8020fe:	68 1f 42 80 00       	push   $0x80421f
  802103:	e8 91 e3 ff ff       	call   800499 <_panic>
  802108:	a1 50 50 80 00       	mov    0x805050,%eax
  80210d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802110:	c1 e2 04             	shl    $0x4,%edx
  802113:	01 d0                	add    %edx,%eax
  802115:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80211b:	89 10                	mov    %edx,(%eax)
  80211d:	8b 00                	mov    (%eax),%eax
  80211f:	85 c0                	test   %eax,%eax
  802121:	74 18                	je     80213b <initialize_MemBlocksList+0x88>
  802123:	a1 48 51 80 00       	mov    0x805148,%eax
  802128:	8b 15 50 50 80 00    	mov    0x805050,%edx
  80212e:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802131:	c1 e1 04             	shl    $0x4,%ecx
  802134:	01 ca                	add    %ecx,%edx
  802136:	89 50 04             	mov    %edx,0x4(%eax)
  802139:	eb 12                	jmp    80214d <initialize_MemBlocksList+0x9a>
  80213b:	a1 50 50 80 00       	mov    0x805050,%eax
  802140:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802143:	c1 e2 04             	shl    $0x4,%edx
  802146:	01 d0                	add    %edx,%eax
  802148:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80214d:	a1 50 50 80 00       	mov    0x805050,%eax
  802152:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802155:	c1 e2 04             	shl    $0x4,%edx
  802158:	01 d0                	add    %edx,%eax
  80215a:	a3 48 51 80 00       	mov    %eax,0x805148
  80215f:	a1 50 50 80 00       	mov    0x805050,%eax
  802164:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802167:	c1 e2 04             	shl    $0x4,%edx
  80216a:	01 d0                	add    %edx,%eax
  80216c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802173:	a1 54 51 80 00       	mov    0x805154,%eax
  802178:	40                   	inc    %eax
  802179:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  80217e:	ff 45 f4             	incl   -0xc(%ebp)
  802181:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802184:	3b 45 08             	cmp    0x8(%ebp),%eax
  802187:	0f 82 56 ff ff ff    	jb     8020e3 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  80218d:	90                   	nop
  80218e:	c9                   	leave  
  80218f:	c3                   	ret    

00802190 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802190:	55                   	push   %ebp
  802191:	89 e5                	mov    %esp,%ebp
  802193:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802196:	8b 45 08             	mov    0x8(%ebp),%eax
  802199:	8b 00                	mov    (%eax),%eax
  80219b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80219e:	eb 19                	jmp    8021b9 <find_block+0x29>
	{
		if(va==point->sva)
  8021a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021a3:	8b 40 08             	mov    0x8(%eax),%eax
  8021a6:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8021a9:	75 05                	jne    8021b0 <find_block+0x20>
		   return point;
  8021ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021ae:	eb 36                	jmp    8021e6 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8021b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b3:	8b 40 08             	mov    0x8(%eax),%eax
  8021b6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8021b9:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8021bd:	74 07                	je     8021c6 <find_block+0x36>
  8021bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021c2:	8b 00                	mov    (%eax),%eax
  8021c4:	eb 05                	jmp    8021cb <find_block+0x3b>
  8021c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8021cb:	8b 55 08             	mov    0x8(%ebp),%edx
  8021ce:	89 42 08             	mov    %eax,0x8(%edx)
  8021d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d4:	8b 40 08             	mov    0x8(%eax),%eax
  8021d7:	85 c0                	test   %eax,%eax
  8021d9:	75 c5                	jne    8021a0 <find_block+0x10>
  8021db:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8021df:	75 bf                	jne    8021a0 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  8021e1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021e6:	c9                   	leave  
  8021e7:	c3                   	ret    

008021e8 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8021e8:	55                   	push   %ebp
  8021e9:	89 e5                	mov    %esp,%ebp
  8021eb:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  8021ee:	a1 40 50 80 00       	mov    0x805040,%eax
  8021f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  8021f6:	a1 44 50 80 00       	mov    0x805044,%eax
  8021fb:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  8021fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802201:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802204:	74 24                	je     80222a <insert_sorted_allocList+0x42>
  802206:	8b 45 08             	mov    0x8(%ebp),%eax
  802209:	8b 50 08             	mov    0x8(%eax),%edx
  80220c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80220f:	8b 40 08             	mov    0x8(%eax),%eax
  802212:	39 c2                	cmp    %eax,%edx
  802214:	76 14                	jbe    80222a <insert_sorted_allocList+0x42>
  802216:	8b 45 08             	mov    0x8(%ebp),%eax
  802219:	8b 50 08             	mov    0x8(%eax),%edx
  80221c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80221f:	8b 40 08             	mov    0x8(%eax),%eax
  802222:	39 c2                	cmp    %eax,%edx
  802224:	0f 82 60 01 00 00    	jb     80238a <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  80222a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80222e:	75 65                	jne    802295 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802230:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802234:	75 14                	jne    80224a <insert_sorted_allocList+0x62>
  802236:	83 ec 04             	sub    $0x4,%esp
  802239:	68 fc 41 80 00       	push   $0x8041fc
  80223e:	6a 6b                	push   $0x6b
  802240:	68 1f 42 80 00       	push   $0x80421f
  802245:	e8 4f e2 ff ff       	call   800499 <_panic>
  80224a:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802250:	8b 45 08             	mov    0x8(%ebp),%eax
  802253:	89 10                	mov    %edx,(%eax)
  802255:	8b 45 08             	mov    0x8(%ebp),%eax
  802258:	8b 00                	mov    (%eax),%eax
  80225a:	85 c0                	test   %eax,%eax
  80225c:	74 0d                	je     80226b <insert_sorted_allocList+0x83>
  80225e:	a1 40 50 80 00       	mov    0x805040,%eax
  802263:	8b 55 08             	mov    0x8(%ebp),%edx
  802266:	89 50 04             	mov    %edx,0x4(%eax)
  802269:	eb 08                	jmp    802273 <insert_sorted_allocList+0x8b>
  80226b:	8b 45 08             	mov    0x8(%ebp),%eax
  80226e:	a3 44 50 80 00       	mov    %eax,0x805044
  802273:	8b 45 08             	mov    0x8(%ebp),%eax
  802276:	a3 40 50 80 00       	mov    %eax,0x805040
  80227b:	8b 45 08             	mov    0x8(%ebp),%eax
  80227e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802285:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80228a:	40                   	inc    %eax
  80228b:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802290:	e9 dc 01 00 00       	jmp    802471 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802295:	8b 45 08             	mov    0x8(%ebp),%eax
  802298:	8b 50 08             	mov    0x8(%eax),%edx
  80229b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80229e:	8b 40 08             	mov    0x8(%eax),%eax
  8022a1:	39 c2                	cmp    %eax,%edx
  8022a3:	77 6c                	ja     802311 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  8022a5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8022a9:	74 06                	je     8022b1 <insert_sorted_allocList+0xc9>
  8022ab:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022af:	75 14                	jne    8022c5 <insert_sorted_allocList+0xdd>
  8022b1:	83 ec 04             	sub    $0x4,%esp
  8022b4:	68 38 42 80 00       	push   $0x804238
  8022b9:	6a 6f                	push   $0x6f
  8022bb:	68 1f 42 80 00       	push   $0x80421f
  8022c0:	e8 d4 e1 ff ff       	call   800499 <_panic>
  8022c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022c8:	8b 50 04             	mov    0x4(%eax),%edx
  8022cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ce:	89 50 04             	mov    %edx,0x4(%eax)
  8022d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022d7:	89 10                	mov    %edx,(%eax)
  8022d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022dc:	8b 40 04             	mov    0x4(%eax),%eax
  8022df:	85 c0                	test   %eax,%eax
  8022e1:	74 0d                	je     8022f0 <insert_sorted_allocList+0x108>
  8022e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022e6:	8b 40 04             	mov    0x4(%eax),%eax
  8022e9:	8b 55 08             	mov    0x8(%ebp),%edx
  8022ec:	89 10                	mov    %edx,(%eax)
  8022ee:	eb 08                	jmp    8022f8 <insert_sorted_allocList+0x110>
  8022f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f3:	a3 40 50 80 00       	mov    %eax,0x805040
  8022f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022fb:	8b 55 08             	mov    0x8(%ebp),%edx
  8022fe:	89 50 04             	mov    %edx,0x4(%eax)
  802301:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802306:	40                   	inc    %eax
  802307:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80230c:	e9 60 01 00 00       	jmp    802471 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802311:	8b 45 08             	mov    0x8(%ebp),%eax
  802314:	8b 50 08             	mov    0x8(%eax),%edx
  802317:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80231a:	8b 40 08             	mov    0x8(%eax),%eax
  80231d:	39 c2                	cmp    %eax,%edx
  80231f:	0f 82 4c 01 00 00    	jb     802471 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802325:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802329:	75 14                	jne    80233f <insert_sorted_allocList+0x157>
  80232b:	83 ec 04             	sub    $0x4,%esp
  80232e:	68 70 42 80 00       	push   $0x804270
  802333:	6a 73                	push   $0x73
  802335:	68 1f 42 80 00       	push   $0x80421f
  80233a:	e8 5a e1 ff ff       	call   800499 <_panic>
  80233f:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802345:	8b 45 08             	mov    0x8(%ebp),%eax
  802348:	89 50 04             	mov    %edx,0x4(%eax)
  80234b:	8b 45 08             	mov    0x8(%ebp),%eax
  80234e:	8b 40 04             	mov    0x4(%eax),%eax
  802351:	85 c0                	test   %eax,%eax
  802353:	74 0c                	je     802361 <insert_sorted_allocList+0x179>
  802355:	a1 44 50 80 00       	mov    0x805044,%eax
  80235a:	8b 55 08             	mov    0x8(%ebp),%edx
  80235d:	89 10                	mov    %edx,(%eax)
  80235f:	eb 08                	jmp    802369 <insert_sorted_allocList+0x181>
  802361:	8b 45 08             	mov    0x8(%ebp),%eax
  802364:	a3 40 50 80 00       	mov    %eax,0x805040
  802369:	8b 45 08             	mov    0x8(%ebp),%eax
  80236c:	a3 44 50 80 00       	mov    %eax,0x805044
  802371:	8b 45 08             	mov    0x8(%ebp),%eax
  802374:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80237a:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80237f:	40                   	inc    %eax
  802380:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802385:	e9 e7 00 00 00       	jmp    802471 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  80238a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80238d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802390:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802397:	a1 40 50 80 00       	mov    0x805040,%eax
  80239c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80239f:	e9 9d 00 00 00       	jmp    802441 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  8023a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a7:	8b 00                	mov    (%eax),%eax
  8023a9:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  8023ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8023af:	8b 50 08             	mov    0x8(%eax),%edx
  8023b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b5:	8b 40 08             	mov    0x8(%eax),%eax
  8023b8:	39 c2                	cmp    %eax,%edx
  8023ba:	76 7d                	jbe    802439 <insert_sorted_allocList+0x251>
  8023bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8023bf:	8b 50 08             	mov    0x8(%eax),%edx
  8023c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8023c5:	8b 40 08             	mov    0x8(%eax),%eax
  8023c8:	39 c2                	cmp    %eax,%edx
  8023ca:	73 6d                	jae    802439 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  8023cc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023d0:	74 06                	je     8023d8 <insert_sorted_allocList+0x1f0>
  8023d2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023d6:	75 14                	jne    8023ec <insert_sorted_allocList+0x204>
  8023d8:	83 ec 04             	sub    $0x4,%esp
  8023db:	68 94 42 80 00       	push   $0x804294
  8023e0:	6a 7f                	push   $0x7f
  8023e2:	68 1f 42 80 00       	push   $0x80421f
  8023e7:	e8 ad e0 ff ff       	call   800499 <_panic>
  8023ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ef:	8b 10                	mov    (%eax),%edx
  8023f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f4:	89 10                	mov    %edx,(%eax)
  8023f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f9:	8b 00                	mov    (%eax),%eax
  8023fb:	85 c0                	test   %eax,%eax
  8023fd:	74 0b                	je     80240a <insert_sorted_allocList+0x222>
  8023ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802402:	8b 00                	mov    (%eax),%eax
  802404:	8b 55 08             	mov    0x8(%ebp),%edx
  802407:	89 50 04             	mov    %edx,0x4(%eax)
  80240a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80240d:	8b 55 08             	mov    0x8(%ebp),%edx
  802410:	89 10                	mov    %edx,(%eax)
  802412:	8b 45 08             	mov    0x8(%ebp),%eax
  802415:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802418:	89 50 04             	mov    %edx,0x4(%eax)
  80241b:	8b 45 08             	mov    0x8(%ebp),%eax
  80241e:	8b 00                	mov    (%eax),%eax
  802420:	85 c0                	test   %eax,%eax
  802422:	75 08                	jne    80242c <insert_sorted_allocList+0x244>
  802424:	8b 45 08             	mov    0x8(%ebp),%eax
  802427:	a3 44 50 80 00       	mov    %eax,0x805044
  80242c:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802431:	40                   	inc    %eax
  802432:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802437:	eb 39                	jmp    802472 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802439:	a1 48 50 80 00       	mov    0x805048,%eax
  80243e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802441:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802445:	74 07                	je     80244e <insert_sorted_allocList+0x266>
  802447:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244a:	8b 00                	mov    (%eax),%eax
  80244c:	eb 05                	jmp    802453 <insert_sorted_allocList+0x26b>
  80244e:	b8 00 00 00 00       	mov    $0x0,%eax
  802453:	a3 48 50 80 00       	mov    %eax,0x805048
  802458:	a1 48 50 80 00       	mov    0x805048,%eax
  80245d:	85 c0                	test   %eax,%eax
  80245f:	0f 85 3f ff ff ff    	jne    8023a4 <insert_sorted_allocList+0x1bc>
  802465:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802469:	0f 85 35 ff ff ff    	jne    8023a4 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80246f:	eb 01                	jmp    802472 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802471:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802472:	90                   	nop
  802473:	c9                   	leave  
  802474:	c3                   	ret    

00802475 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802475:	55                   	push   %ebp
  802476:	89 e5                	mov    %esp,%ebp
  802478:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  80247b:	a1 38 51 80 00       	mov    0x805138,%eax
  802480:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802483:	e9 85 01 00 00       	jmp    80260d <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802488:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248b:	8b 40 0c             	mov    0xc(%eax),%eax
  80248e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802491:	0f 82 6e 01 00 00    	jb     802605 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802497:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249a:	8b 40 0c             	mov    0xc(%eax),%eax
  80249d:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024a0:	0f 85 8a 00 00 00    	jne    802530 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  8024a6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024aa:	75 17                	jne    8024c3 <alloc_block_FF+0x4e>
  8024ac:	83 ec 04             	sub    $0x4,%esp
  8024af:	68 c8 42 80 00       	push   $0x8042c8
  8024b4:	68 93 00 00 00       	push   $0x93
  8024b9:	68 1f 42 80 00       	push   $0x80421f
  8024be:	e8 d6 df ff ff       	call   800499 <_panic>
  8024c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c6:	8b 00                	mov    (%eax),%eax
  8024c8:	85 c0                	test   %eax,%eax
  8024ca:	74 10                	je     8024dc <alloc_block_FF+0x67>
  8024cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024cf:	8b 00                	mov    (%eax),%eax
  8024d1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024d4:	8b 52 04             	mov    0x4(%edx),%edx
  8024d7:	89 50 04             	mov    %edx,0x4(%eax)
  8024da:	eb 0b                	jmp    8024e7 <alloc_block_FF+0x72>
  8024dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024df:	8b 40 04             	mov    0x4(%eax),%eax
  8024e2:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8024e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ea:	8b 40 04             	mov    0x4(%eax),%eax
  8024ed:	85 c0                	test   %eax,%eax
  8024ef:	74 0f                	je     802500 <alloc_block_FF+0x8b>
  8024f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f4:	8b 40 04             	mov    0x4(%eax),%eax
  8024f7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024fa:	8b 12                	mov    (%edx),%edx
  8024fc:	89 10                	mov    %edx,(%eax)
  8024fe:	eb 0a                	jmp    80250a <alloc_block_FF+0x95>
  802500:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802503:	8b 00                	mov    (%eax),%eax
  802505:	a3 38 51 80 00       	mov    %eax,0x805138
  80250a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802513:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802516:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80251d:	a1 44 51 80 00       	mov    0x805144,%eax
  802522:	48                   	dec    %eax
  802523:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802528:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252b:	e9 10 01 00 00       	jmp    802640 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802530:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802533:	8b 40 0c             	mov    0xc(%eax),%eax
  802536:	3b 45 08             	cmp    0x8(%ebp),%eax
  802539:	0f 86 c6 00 00 00    	jbe    802605 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80253f:	a1 48 51 80 00       	mov    0x805148,%eax
  802544:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802547:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254a:	8b 50 08             	mov    0x8(%eax),%edx
  80254d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802550:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802553:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802556:	8b 55 08             	mov    0x8(%ebp),%edx
  802559:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80255c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802560:	75 17                	jne    802579 <alloc_block_FF+0x104>
  802562:	83 ec 04             	sub    $0x4,%esp
  802565:	68 c8 42 80 00       	push   $0x8042c8
  80256a:	68 9b 00 00 00       	push   $0x9b
  80256f:	68 1f 42 80 00       	push   $0x80421f
  802574:	e8 20 df ff ff       	call   800499 <_panic>
  802579:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80257c:	8b 00                	mov    (%eax),%eax
  80257e:	85 c0                	test   %eax,%eax
  802580:	74 10                	je     802592 <alloc_block_FF+0x11d>
  802582:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802585:	8b 00                	mov    (%eax),%eax
  802587:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80258a:	8b 52 04             	mov    0x4(%edx),%edx
  80258d:	89 50 04             	mov    %edx,0x4(%eax)
  802590:	eb 0b                	jmp    80259d <alloc_block_FF+0x128>
  802592:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802595:	8b 40 04             	mov    0x4(%eax),%eax
  802598:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80259d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025a0:	8b 40 04             	mov    0x4(%eax),%eax
  8025a3:	85 c0                	test   %eax,%eax
  8025a5:	74 0f                	je     8025b6 <alloc_block_FF+0x141>
  8025a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025aa:	8b 40 04             	mov    0x4(%eax),%eax
  8025ad:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025b0:	8b 12                	mov    (%edx),%edx
  8025b2:	89 10                	mov    %edx,(%eax)
  8025b4:	eb 0a                	jmp    8025c0 <alloc_block_FF+0x14b>
  8025b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025b9:	8b 00                	mov    (%eax),%eax
  8025bb:	a3 48 51 80 00       	mov    %eax,0x805148
  8025c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025c3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025cc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025d3:	a1 54 51 80 00       	mov    0x805154,%eax
  8025d8:	48                   	dec    %eax
  8025d9:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  8025de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e1:	8b 50 08             	mov    0x8(%eax),%edx
  8025e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8025e7:	01 c2                	add    %eax,%edx
  8025e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ec:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  8025ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f2:	8b 40 0c             	mov    0xc(%eax),%eax
  8025f5:	2b 45 08             	sub    0x8(%ebp),%eax
  8025f8:	89 c2                	mov    %eax,%edx
  8025fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fd:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802600:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802603:	eb 3b                	jmp    802640 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802605:	a1 40 51 80 00       	mov    0x805140,%eax
  80260a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80260d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802611:	74 07                	je     80261a <alloc_block_FF+0x1a5>
  802613:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802616:	8b 00                	mov    (%eax),%eax
  802618:	eb 05                	jmp    80261f <alloc_block_FF+0x1aa>
  80261a:	b8 00 00 00 00       	mov    $0x0,%eax
  80261f:	a3 40 51 80 00       	mov    %eax,0x805140
  802624:	a1 40 51 80 00       	mov    0x805140,%eax
  802629:	85 c0                	test   %eax,%eax
  80262b:	0f 85 57 fe ff ff    	jne    802488 <alloc_block_FF+0x13>
  802631:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802635:	0f 85 4d fe ff ff    	jne    802488 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  80263b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802640:	c9                   	leave  
  802641:	c3                   	ret    

00802642 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802642:	55                   	push   %ebp
  802643:	89 e5                	mov    %esp,%ebp
  802645:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802648:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  80264f:	a1 38 51 80 00       	mov    0x805138,%eax
  802654:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802657:	e9 df 00 00 00       	jmp    80273b <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  80265c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265f:	8b 40 0c             	mov    0xc(%eax),%eax
  802662:	3b 45 08             	cmp    0x8(%ebp),%eax
  802665:	0f 82 c8 00 00 00    	jb     802733 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  80266b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266e:	8b 40 0c             	mov    0xc(%eax),%eax
  802671:	3b 45 08             	cmp    0x8(%ebp),%eax
  802674:	0f 85 8a 00 00 00    	jne    802704 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  80267a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80267e:	75 17                	jne    802697 <alloc_block_BF+0x55>
  802680:	83 ec 04             	sub    $0x4,%esp
  802683:	68 c8 42 80 00       	push   $0x8042c8
  802688:	68 b7 00 00 00       	push   $0xb7
  80268d:	68 1f 42 80 00       	push   $0x80421f
  802692:	e8 02 de ff ff       	call   800499 <_panic>
  802697:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269a:	8b 00                	mov    (%eax),%eax
  80269c:	85 c0                	test   %eax,%eax
  80269e:	74 10                	je     8026b0 <alloc_block_BF+0x6e>
  8026a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a3:	8b 00                	mov    (%eax),%eax
  8026a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026a8:	8b 52 04             	mov    0x4(%edx),%edx
  8026ab:	89 50 04             	mov    %edx,0x4(%eax)
  8026ae:	eb 0b                	jmp    8026bb <alloc_block_BF+0x79>
  8026b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b3:	8b 40 04             	mov    0x4(%eax),%eax
  8026b6:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8026bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026be:	8b 40 04             	mov    0x4(%eax),%eax
  8026c1:	85 c0                	test   %eax,%eax
  8026c3:	74 0f                	je     8026d4 <alloc_block_BF+0x92>
  8026c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c8:	8b 40 04             	mov    0x4(%eax),%eax
  8026cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026ce:	8b 12                	mov    (%edx),%edx
  8026d0:	89 10                	mov    %edx,(%eax)
  8026d2:	eb 0a                	jmp    8026de <alloc_block_BF+0x9c>
  8026d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d7:	8b 00                	mov    (%eax),%eax
  8026d9:	a3 38 51 80 00       	mov    %eax,0x805138
  8026de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ea:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026f1:	a1 44 51 80 00       	mov    0x805144,%eax
  8026f6:	48                   	dec    %eax
  8026f7:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  8026fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ff:	e9 4d 01 00 00       	jmp    802851 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802704:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802707:	8b 40 0c             	mov    0xc(%eax),%eax
  80270a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80270d:	76 24                	jbe    802733 <alloc_block_BF+0xf1>
  80270f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802712:	8b 40 0c             	mov    0xc(%eax),%eax
  802715:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802718:	73 19                	jae    802733 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  80271a:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802721:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802724:	8b 40 0c             	mov    0xc(%eax),%eax
  802727:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  80272a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272d:	8b 40 08             	mov    0x8(%eax),%eax
  802730:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802733:	a1 40 51 80 00       	mov    0x805140,%eax
  802738:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80273b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80273f:	74 07                	je     802748 <alloc_block_BF+0x106>
  802741:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802744:	8b 00                	mov    (%eax),%eax
  802746:	eb 05                	jmp    80274d <alloc_block_BF+0x10b>
  802748:	b8 00 00 00 00       	mov    $0x0,%eax
  80274d:	a3 40 51 80 00       	mov    %eax,0x805140
  802752:	a1 40 51 80 00       	mov    0x805140,%eax
  802757:	85 c0                	test   %eax,%eax
  802759:	0f 85 fd fe ff ff    	jne    80265c <alloc_block_BF+0x1a>
  80275f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802763:	0f 85 f3 fe ff ff    	jne    80265c <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802769:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80276d:	0f 84 d9 00 00 00    	je     80284c <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802773:	a1 48 51 80 00       	mov    0x805148,%eax
  802778:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  80277b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80277e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802781:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802784:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802787:	8b 55 08             	mov    0x8(%ebp),%edx
  80278a:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  80278d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802791:	75 17                	jne    8027aa <alloc_block_BF+0x168>
  802793:	83 ec 04             	sub    $0x4,%esp
  802796:	68 c8 42 80 00       	push   $0x8042c8
  80279b:	68 c7 00 00 00       	push   $0xc7
  8027a0:	68 1f 42 80 00       	push   $0x80421f
  8027a5:	e8 ef dc ff ff       	call   800499 <_panic>
  8027aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027ad:	8b 00                	mov    (%eax),%eax
  8027af:	85 c0                	test   %eax,%eax
  8027b1:	74 10                	je     8027c3 <alloc_block_BF+0x181>
  8027b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027b6:	8b 00                	mov    (%eax),%eax
  8027b8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8027bb:	8b 52 04             	mov    0x4(%edx),%edx
  8027be:	89 50 04             	mov    %edx,0x4(%eax)
  8027c1:	eb 0b                	jmp    8027ce <alloc_block_BF+0x18c>
  8027c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027c6:	8b 40 04             	mov    0x4(%eax),%eax
  8027c9:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8027ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027d1:	8b 40 04             	mov    0x4(%eax),%eax
  8027d4:	85 c0                	test   %eax,%eax
  8027d6:	74 0f                	je     8027e7 <alloc_block_BF+0x1a5>
  8027d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027db:	8b 40 04             	mov    0x4(%eax),%eax
  8027de:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8027e1:	8b 12                	mov    (%edx),%edx
  8027e3:	89 10                	mov    %edx,(%eax)
  8027e5:	eb 0a                	jmp    8027f1 <alloc_block_BF+0x1af>
  8027e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027ea:	8b 00                	mov    (%eax),%eax
  8027ec:	a3 48 51 80 00       	mov    %eax,0x805148
  8027f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027f4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027fd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802804:	a1 54 51 80 00       	mov    0x805154,%eax
  802809:	48                   	dec    %eax
  80280a:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  80280f:	83 ec 08             	sub    $0x8,%esp
  802812:	ff 75 ec             	pushl  -0x14(%ebp)
  802815:	68 38 51 80 00       	push   $0x805138
  80281a:	e8 71 f9 ff ff       	call   802190 <find_block>
  80281f:	83 c4 10             	add    $0x10,%esp
  802822:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802825:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802828:	8b 50 08             	mov    0x8(%eax),%edx
  80282b:	8b 45 08             	mov    0x8(%ebp),%eax
  80282e:	01 c2                	add    %eax,%edx
  802830:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802833:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802836:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802839:	8b 40 0c             	mov    0xc(%eax),%eax
  80283c:	2b 45 08             	sub    0x8(%ebp),%eax
  80283f:	89 c2                	mov    %eax,%edx
  802841:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802844:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802847:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80284a:	eb 05                	jmp    802851 <alloc_block_BF+0x20f>
	}
	return NULL;
  80284c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802851:	c9                   	leave  
  802852:	c3                   	ret    

00802853 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802853:	55                   	push   %ebp
  802854:	89 e5                	mov    %esp,%ebp
  802856:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802859:	a1 28 50 80 00       	mov    0x805028,%eax
  80285e:	85 c0                	test   %eax,%eax
  802860:	0f 85 de 01 00 00    	jne    802a44 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802866:	a1 38 51 80 00       	mov    0x805138,%eax
  80286b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80286e:	e9 9e 01 00 00       	jmp    802a11 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802873:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802876:	8b 40 0c             	mov    0xc(%eax),%eax
  802879:	3b 45 08             	cmp    0x8(%ebp),%eax
  80287c:	0f 82 87 01 00 00    	jb     802a09 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802882:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802885:	8b 40 0c             	mov    0xc(%eax),%eax
  802888:	3b 45 08             	cmp    0x8(%ebp),%eax
  80288b:	0f 85 95 00 00 00    	jne    802926 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802891:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802895:	75 17                	jne    8028ae <alloc_block_NF+0x5b>
  802897:	83 ec 04             	sub    $0x4,%esp
  80289a:	68 c8 42 80 00       	push   $0x8042c8
  80289f:	68 e0 00 00 00       	push   $0xe0
  8028a4:	68 1f 42 80 00       	push   $0x80421f
  8028a9:	e8 eb db ff ff       	call   800499 <_panic>
  8028ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b1:	8b 00                	mov    (%eax),%eax
  8028b3:	85 c0                	test   %eax,%eax
  8028b5:	74 10                	je     8028c7 <alloc_block_NF+0x74>
  8028b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ba:	8b 00                	mov    (%eax),%eax
  8028bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028bf:	8b 52 04             	mov    0x4(%edx),%edx
  8028c2:	89 50 04             	mov    %edx,0x4(%eax)
  8028c5:	eb 0b                	jmp    8028d2 <alloc_block_NF+0x7f>
  8028c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ca:	8b 40 04             	mov    0x4(%eax),%eax
  8028cd:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8028d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d5:	8b 40 04             	mov    0x4(%eax),%eax
  8028d8:	85 c0                	test   %eax,%eax
  8028da:	74 0f                	je     8028eb <alloc_block_NF+0x98>
  8028dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028df:	8b 40 04             	mov    0x4(%eax),%eax
  8028e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028e5:	8b 12                	mov    (%edx),%edx
  8028e7:	89 10                	mov    %edx,(%eax)
  8028e9:	eb 0a                	jmp    8028f5 <alloc_block_NF+0xa2>
  8028eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ee:	8b 00                	mov    (%eax),%eax
  8028f0:	a3 38 51 80 00       	mov    %eax,0x805138
  8028f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802901:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802908:	a1 44 51 80 00       	mov    0x805144,%eax
  80290d:	48                   	dec    %eax
  80290e:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802913:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802916:	8b 40 08             	mov    0x8(%eax),%eax
  802919:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  80291e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802921:	e9 f8 04 00 00       	jmp    802e1e <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802926:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802929:	8b 40 0c             	mov    0xc(%eax),%eax
  80292c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80292f:	0f 86 d4 00 00 00    	jbe    802a09 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802935:	a1 48 51 80 00       	mov    0x805148,%eax
  80293a:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  80293d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802940:	8b 50 08             	mov    0x8(%eax),%edx
  802943:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802946:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802949:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80294c:	8b 55 08             	mov    0x8(%ebp),%edx
  80294f:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802952:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802956:	75 17                	jne    80296f <alloc_block_NF+0x11c>
  802958:	83 ec 04             	sub    $0x4,%esp
  80295b:	68 c8 42 80 00       	push   $0x8042c8
  802960:	68 e9 00 00 00       	push   $0xe9
  802965:	68 1f 42 80 00       	push   $0x80421f
  80296a:	e8 2a db ff ff       	call   800499 <_panic>
  80296f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802972:	8b 00                	mov    (%eax),%eax
  802974:	85 c0                	test   %eax,%eax
  802976:	74 10                	je     802988 <alloc_block_NF+0x135>
  802978:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80297b:	8b 00                	mov    (%eax),%eax
  80297d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802980:	8b 52 04             	mov    0x4(%edx),%edx
  802983:	89 50 04             	mov    %edx,0x4(%eax)
  802986:	eb 0b                	jmp    802993 <alloc_block_NF+0x140>
  802988:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80298b:	8b 40 04             	mov    0x4(%eax),%eax
  80298e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802993:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802996:	8b 40 04             	mov    0x4(%eax),%eax
  802999:	85 c0                	test   %eax,%eax
  80299b:	74 0f                	je     8029ac <alloc_block_NF+0x159>
  80299d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029a0:	8b 40 04             	mov    0x4(%eax),%eax
  8029a3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029a6:	8b 12                	mov    (%edx),%edx
  8029a8:	89 10                	mov    %edx,(%eax)
  8029aa:	eb 0a                	jmp    8029b6 <alloc_block_NF+0x163>
  8029ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029af:	8b 00                	mov    (%eax),%eax
  8029b1:	a3 48 51 80 00       	mov    %eax,0x805148
  8029b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029b9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029c2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029c9:	a1 54 51 80 00       	mov    0x805154,%eax
  8029ce:	48                   	dec    %eax
  8029cf:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  8029d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029d7:	8b 40 08             	mov    0x8(%eax),%eax
  8029da:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  8029df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e2:	8b 50 08             	mov    0x8(%eax),%edx
  8029e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e8:	01 c2                	add    %eax,%edx
  8029ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ed:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  8029f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f3:	8b 40 0c             	mov    0xc(%eax),%eax
  8029f6:	2b 45 08             	sub    0x8(%ebp),%eax
  8029f9:	89 c2                	mov    %eax,%edx
  8029fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029fe:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802a01:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a04:	e9 15 04 00 00       	jmp    802e1e <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802a09:	a1 40 51 80 00       	mov    0x805140,%eax
  802a0e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a11:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a15:	74 07                	je     802a1e <alloc_block_NF+0x1cb>
  802a17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1a:	8b 00                	mov    (%eax),%eax
  802a1c:	eb 05                	jmp    802a23 <alloc_block_NF+0x1d0>
  802a1e:	b8 00 00 00 00       	mov    $0x0,%eax
  802a23:	a3 40 51 80 00       	mov    %eax,0x805140
  802a28:	a1 40 51 80 00       	mov    0x805140,%eax
  802a2d:	85 c0                	test   %eax,%eax
  802a2f:	0f 85 3e fe ff ff    	jne    802873 <alloc_block_NF+0x20>
  802a35:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a39:	0f 85 34 fe ff ff    	jne    802873 <alloc_block_NF+0x20>
  802a3f:	e9 d5 03 00 00       	jmp    802e19 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802a44:	a1 38 51 80 00       	mov    0x805138,%eax
  802a49:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a4c:	e9 b1 01 00 00       	jmp    802c02 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802a51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a54:	8b 50 08             	mov    0x8(%eax),%edx
  802a57:	a1 28 50 80 00       	mov    0x805028,%eax
  802a5c:	39 c2                	cmp    %eax,%edx
  802a5e:	0f 82 96 01 00 00    	jb     802bfa <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802a64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a67:	8b 40 0c             	mov    0xc(%eax),%eax
  802a6a:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a6d:	0f 82 87 01 00 00    	jb     802bfa <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802a73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a76:	8b 40 0c             	mov    0xc(%eax),%eax
  802a79:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a7c:	0f 85 95 00 00 00    	jne    802b17 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802a82:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a86:	75 17                	jne    802a9f <alloc_block_NF+0x24c>
  802a88:	83 ec 04             	sub    $0x4,%esp
  802a8b:	68 c8 42 80 00       	push   $0x8042c8
  802a90:	68 fc 00 00 00       	push   $0xfc
  802a95:	68 1f 42 80 00       	push   $0x80421f
  802a9a:	e8 fa d9 ff ff       	call   800499 <_panic>
  802a9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa2:	8b 00                	mov    (%eax),%eax
  802aa4:	85 c0                	test   %eax,%eax
  802aa6:	74 10                	je     802ab8 <alloc_block_NF+0x265>
  802aa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aab:	8b 00                	mov    (%eax),%eax
  802aad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ab0:	8b 52 04             	mov    0x4(%edx),%edx
  802ab3:	89 50 04             	mov    %edx,0x4(%eax)
  802ab6:	eb 0b                	jmp    802ac3 <alloc_block_NF+0x270>
  802ab8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802abb:	8b 40 04             	mov    0x4(%eax),%eax
  802abe:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ac3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac6:	8b 40 04             	mov    0x4(%eax),%eax
  802ac9:	85 c0                	test   %eax,%eax
  802acb:	74 0f                	je     802adc <alloc_block_NF+0x289>
  802acd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad0:	8b 40 04             	mov    0x4(%eax),%eax
  802ad3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ad6:	8b 12                	mov    (%edx),%edx
  802ad8:	89 10                	mov    %edx,(%eax)
  802ada:	eb 0a                	jmp    802ae6 <alloc_block_NF+0x293>
  802adc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802adf:	8b 00                	mov    (%eax),%eax
  802ae1:	a3 38 51 80 00       	mov    %eax,0x805138
  802ae6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802aef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802af9:	a1 44 51 80 00       	mov    0x805144,%eax
  802afe:	48                   	dec    %eax
  802aff:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802b04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b07:	8b 40 08             	mov    0x8(%eax),%eax
  802b0a:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802b0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b12:	e9 07 03 00 00       	jmp    802e1e <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802b17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1a:	8b 40 0c             	mov    0xc(%eax),%eax
  802b1d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b20:	0f 86 d4 00 00 00    	jbe    802bfa <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802b26:	a1 48 51 80 00       	mov    0x805148,%eax
  802b2b:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802b2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b31:	8b 50 08             	mov    0x8(%eax),%edx
  802b34:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b37:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802b3a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b3d:	8b 55 08             	mov    0x8(%ebp),%edx
  802b40:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802b43:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802b47:	75 17                	jne    802b60 <alloc_block_NF+0x30d>
  802b49:	83 ec 04             	sub    $0x4,%esp
  802b4c:	68 c8 42 80 00       	push   $0x8042c8
  802b51:	68 04 01 00 00       	push   $0x104
  802b56:	68 1f 42 80 00       	push   $0x80421f
  802b5b:	e8 39 d9 ff ff       	call   800499 <_panic>
  802b60:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b63:	8b 00                	mov    (%eax),%eax
  802b65:	85 c0                	test   %eax,%eax
  802b67:	74 10                	je     802b79 <alloc_block_NF+0x326>
  802b69:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b6c:	8b 00                	mov    (%eax),%eax
  802b6e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b71:	8b 52 04             	mov    0x4(%edx),%edx
  802b74:	89 50 04             	mov    %edx,0x4(%eax)
  802b77:	eb 0b                	jmp    802b84 <alloc_block_NF+0x331>
  802b79:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b7c:	8b 40 04             	mov    0x4(%eax),%eax
  802b7f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b84:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b87:	8b 40 04             	mov    0x4(%eax),%eax
  802b8a:	85 c0                	test   %eax,%eax
  802b8c:	74 0f                	je     802b9d <alloc_block_NF+0x34a>
  802b8e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b91:	8b 40 04             	mov    0x4(%eax),%eax
  802b94:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b97:	8b 12                	mov    (%edx),%edx
  802b99:	89 10                	mov    %edx,(%eax)
  802b9b:	eb 0a                	jmp    802ba7 <alloc_block_NF+0x354>
  802b9d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ba0:	8b 00                	mov    (%eax),%eax
  802ba2:	a3 48 51 80 00       	mov    %eax,0x805148
  802ba7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802baa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bb0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bb3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bba:	a1 54 51 80 00       	mov    0x805154,%eax
  802bbf:	48                   	dec    %eax
  802bc0:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802bc5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bc8:	8b 40 08             	mov    0x8(%eax),%eax
  802bcb:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802bd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd3:	8b 50 08             	mov    0x8(%eax),%edx
  802bd6:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd9:	01 c2                	add    %eax,%edx
  802bdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bde:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802be1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be4:	8b 40 0c             	mov    0xc(%eax),%eax
  802be7:	2b 45 08             	sub    0x8(%ebp),%eax
  802bea:	89 c2                	mov    %eax,%edx
  802bec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bef:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802bf2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bf5:	e9 24 02 00 00       	jmp    802e1e <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802bfa:	a1 40 51 80 00       	mov    0x805140,%eax
  802bff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c02:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c06:	74 07                	je     802c0f <alloc_block_NF+0x3bc>
  802c08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0b:	8b 00                	mov    (%eax),%eax
  802c0d:	eb 05                	jmp    802c14 <alloc_block_NF+0x3c1>
  802c0f:	b8 00 00 00 00       	mov    $0x0,%eax
  802c14:	a3 40 51 80 00       	mov    %eax,0x805140
  802c19:	a1 40 51 80 00       	mov    0x805140,%eax
  802c1e:	85 c0                	test   %eax,%eax
  802c20:	0f 85 2b fe ff ff    	jne    802a51 <alloc_block_NF+0x1fe>
  802c26:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c2a:	0f 85 21 fe ff ff    	jne    802a51 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802c30:	a1 38 51 80 00       	mov    0x805138,%eax
  802c35:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c38:	e9 ae 01 00 00       	jmp    802deb <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802c3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c40:	8b 50 08             	mov    0x8(%eax),%edx
  802c43:	a1 28 50 80 00       	mov    0x805028,%eax
  802c48:	39 c2                	cmp    %eax,%edx
  802c4a:	0f 83 93 01 00 00    	jae    802de3 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802c50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c53:	8b 40 0c             	mov    0xc(%eax),%eax
  802c56:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c59:	0f 82 84 01 00 00    	jb     802de3 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802c5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c62:	8b 40 0c             	mov    0xc(%eax),%eax
  802c65:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c68:	0f 85 95 00 00 00    	jne    802d03 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802c6e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c72:	75 17                	jne    802c8b <alloc_block_NF+0x438>
  802c74:	83 ec 04             	sub    $0x4,%esp
  802c77:	68 c8 42 80 00       	push   $0x8042c8
  802c7c:	68 14 01 00 00       	push   $0x114
  802c81:	68 1f 42 80 00       	push   $0x80421f
  802c86:	e8 0e d8 ff ff       	call   800499 <_panic>
  802c8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c8e:	8b 00                	mov    (%eax),%eax
  802c90:	85 c0                	test   %eax,%eax
  802c92:	74 10                	je     802ca4 <alloc_block_NF+0x451>
  802c94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c97:	8b 00                	mov    (%eax),%eax
  802c99:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c9c:	8b 52 04             	mov    0x4(%edx),%edx
  802c9f:	89 50 04             	mov    %edx,0x4(%eax)
  802ca2:	eb 0b                	jmp    802caf <alloc_block_NF+0x45c>
  802ca4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca7:	8b 40 04             	mov    0x4(%eax),%eax
  802caa:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802caf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb2:	8b 40 04             	mov    0x4(%eax),%eax
  802cb5:	85 c0                	test   %eax,%eax
  802cb7:	74 0f                	je     802cc8 <alloc_block_NF+0x475>
  802cb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cbc:	8b 40 04             	mov    0x4(%eax),%eax
  802cbf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cc2:	8b 12                	mov    (%edx),%edx
  802cc4:	89 10                	mov    %edx,(%eax)
  802cc6:	eb 0a                	jmp    802cd2 <alloc_block_NF+0x47f>
  802cc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ccb:	8b 00                	mov    (%eax),%eax
  802ccd:	a3 38 51 80 00       	mov    %eax,0x805138
  802cd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cde:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ce5:	a1 44 51 80 00       	mov    0x805144,%eax
  802cea:	48                   	dec    %eax
  802ceb:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802cf0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf3:	8b 40 08             	mov    0x8(%eax),%eax
  802cf6:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802cfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cfe:	e9 1b 01 00 00       	jmp    802e1e <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802d03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d06:	8b 40 0c             	mov    0xc(%eax),%eax
  802d09:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d0c:	0f 86 d1 00 00 00    	jbe    802de3 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802d12:	a1 48 51 80 00       	mov    0x805148,%eax
  802d17:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802d1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d1d:	8b 50 08             	mov    0x8(%eax),%edx
  802d20:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d23:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802d26:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d29:	8b 55 08             	mov    0x8(%ebp),%edx
  802d2c:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802d2f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802d33:	75 17                	jne    802d4c <alloc_block_NF+0x4f9>
  802d35:	83 ec 04             	sub    $0x4,%esp
  802d38:	68 c8 42 80 00       	push   $0x8042c8
  802d3d:	68 1c 01 00 00       	push   $0x11c
  802d42:	68 1f 42 80 00       	push   $0x80421f
  802d47:	e8 4d d7 ff ff       	call   800499 <_panic>
  802d4c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d4f:	8b 00                	mov    (%eax),%eax
  802d51:	85 c0                	test   %eax,%eax
  802d53:	74 10                	je     802d65 <alloc_block_NF+0x512>
  802d55:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d58:	8b 00                	mov    (%eax),%eax
  802d5a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d5d:	8b 52 04             	mov    0x4(%edx),%edx
  802d60:	89 50 04             	mov    %edx,0x4(%eax)
  802d63:	eb 0b                	jmp    802d70 <alloc_block_NF+0x51d>
  802d65:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d68:	8b 40 04             	mov    0x4(%eax),%eax
  802d6b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d70:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d73:	8b 40 04             	mov    0x4(%eax),%eax
  802d76:	85 c0                	test   %eax,%eax
  802d78:	74 0f                	je     802d89 <alloc_block_NF+0x536>
  802d7a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d7d:	8b 40 04             	mov    0x4(%eax),%eax
  802d80:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d83:	8b 12                	mov    (%edx),%edx
  802d85:	89 10                	mov    %edx,(%eax)
  802d87:	eb 0a                	jmp    802d93 <alloc_block_NF+0x540>
  802d89:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d8c:	8b 00                	mov    (%eax),%eax
  802d8e:	a3 48 51 80 00       	mov    %eax,0x805148
  802d93:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d96:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d9c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d9f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802da6:	a1 54 51 80 00       	mov    0x805154,%eax
  802dab:	48                   	dec    %eax
  802dac:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802db1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802db4:	8b 40 08             	mov    0x8(%eax),%eax
  802db7:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802dbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dbf:	8b 50 08             	mov    0x8(%eax),%edx
  802dc2:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc5:	01 c2                	add    %eax,%edx
  802dc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dca:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802dcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd0:	8b 40 0c             	mov    0xc(%eax),%eax
  802dd3:	2b 45 08             	sub    0x8(%ebp),%eax
  802dd6:	89 c2                	mov    %eax,%edx
  802dd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ddb:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802dde:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802de1:	eb 3b                	jmp    802e1e <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802de3:	a1 40 51 80 00       	mov    0x805140,%eax
  802de8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802deb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802def:	74 07                	je     802df8 <alloc_block_NF+0x5a5>
  802df1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df4:	8b 00                	mov    (%eax),%eax
  802df6:	eb 05                	jmp    802dfd <alloc_block_NF+0x5aa>
  802df8:	b8 00 00 00 00       	mov    $0x0,%eax
  802dfd:	a3 40 51 80 00       	mov    %eax,0x805140
  802e02:	a1 40 51 80 00       	mov    0x805140,%eax
  802e07:	85 c0                	test   %eax,%eax
  802e09:	0f 85 2e fe ff ff    	jne    802c3d <alloc_block_NF+0x3ea>
  802e0f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e13:	0f 85 24 fe ff ff    	jne    802c3d <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802e19:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e1e:	c9                   	leave  
  802e1f:	c3                   	ret    

00802e20 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802e20:	55                   	push   %ebp
  802e21:	89 e5                	mov    %esp,%ebp
  802e23:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802e26:	a1 38 51 80 00       	mov    0x805138,%eax
  802e2b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802e2e:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802e33:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802e36:	a1 38 51 80 00       	mov    0x805138,%eax
  802e3b:	85 c0                	test   %eax,%eax
  802e3d:	74 14                	je     802e53 <insert_sorted_with_merge_freeList+0x33>
  802e3f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e42:	8b 50 08             	mov    0x8(%eax),%edx
  802e45:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e48:	8b 40 08             	mov    0x8(%eax),%eax
  802e4b:	39 c2                	cmp    %eax,%edx
  802e4d:	0f 87 9b 01 00 00    	ja     802fee <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802e53:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e57:	75 17                	jne    802e70 <insert_sorted_with_merge_freeList+0x50>
  802e59:	83 ec 04             	sub    $0x4,%esp
  802e5c:	68 fc 41 80 00       	push   $0x8041fc
  802e61:	68 38 01 00 00       	push   $0x138
  802e66:	68 1f 42 80 00       	push   $0x80421f
  802e6b:	e8 29 d6 ff ff       	call   800499 <_panic>
  802e70:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802e76:	8b 45 08             	mov    0x8(%ebp),%eax
  802e79:	89 10                	mov    %edx,(%eax)
  802e7b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e7e:	8b 00                	mov    (%eax),%eax
  802e80:	85 c0                	test   %eax,%eax
  802e82:	74 0d                	je     802e91 <insert_sorted_with_merge_freeList+0x71>
  802e84:	a1 38 51 80 00       	mov    0x805138,%eax
  802e89:	8b 55 08             	mov    0x8(%ebp),%edx
  802e8c:	89 50 04             	mov    %edx,0x4(%eax)
  802e8f:	eb 08                	jmp    802e99 <insert_sorted_with_merge_freeList+0x79>
  802e91:	8b 45 08             	mov    0x8(%ebp),%eax
  802e94:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e99:	8b 45 08             	mov    0x8(%ebp),%eax
  802e9c:	a3 38 51 80 00       	mov    %eax,0x805138
  802ea1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802eab:	a1 44 51 80 00       	mov    0x805144,%eax
  802eb0:	40                   	inc    %eax
  802eb1:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802eb6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802eba:	0f 84 a8 06 00 00    	je     803568 <insert_sorted_with_merge_freeList+0x748>
  802ec0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec3:	8b 50 08             	mov    0x8(%eax),%edx
  802ec6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec9:	8b 40 0c             	mov    0xc(%eax),%eax
  802ecc:	01 c2                	add    %eax,%edx
  802ece:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ed1:	8b 40 08             	mov    0x8(%eax),%eax
  802ed4:	39 c2                	cmp    %eax,%edx
  802ed6:	0f 85 8c 06 00 00    	jne    803568 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802edc:	8b 45 08             	mov    0x8(%ebp),%eax
  802edf:	8b 50 0c             	mov    0xc(%eax),%edx
  802ee2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ee5:	8b 40 0c             	mov    0xc(%eax),%eax
  802ee8:	01 c2                	add    %eax,%edx
  802eea:	8b 45 08             	mov    0x8(%ebp),%eax
  802eed:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802ef0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ef4:	75 17                	jne    802f0d <insert_sorted_with_merge_freeList+0xed>
  802ef6:	83 ec 04             	sub    $0x4,%esp
  802ef9:	68 c8 42 80 00       	push   $0x8042c8
  802efe:	68 3c 01 00 00       	push   $0x13c
  802f03:	68 1f 42 80 00       	push   $0x80421f
  802f08:	e8 8c d5 ff ff       	call   800499 <_panic>
  802f0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f10:	8b 00                	mov    (%eax),%eax
  802f12:	85 c0                	test   %eax,%eax
  802f14:	74 10                	je     802f26 <insert_sorted_with_merge_freeList+0x106>
  802f16:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f19:	8b 00                	mov    (%eax),%eax
  802f1b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f1e:	8b 52 04             	mov    0x4(%edx),%edx
  802f21:	89 50 04             	mov    %edx,0x4(%eax)
  802f24:	eb 0b                	jmp    802f31 <insert_sorted_with_merge_freeList+0x111>
  802f26:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f29:	8b 40 04             	mov    0x4(%eax),%eax
  802f2c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f34:	8b 40 04             	mov    0x4(%eax),%eax
  802f37:	85 c0                	test   %eax,%eax
  802f39:	74 0f                	je     802f4a <insert_sorted_with_merge_freeList+0x12a>
  802f3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f3e:	8b 40 04             	mov    0x4(%eax),%eax
  802f41:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f44:	8b 12                	mov    (%edx),%edx
  802f46:	89 10                	mov    %edx,(%eax)
  802f48:	eb 0a                	jmp    802f54 <insert_sorted_with_merge_freeList+0x134>
  802f4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f4d:	8b 00                	mov    (%eax),%eax
  802f4f:	a3 38 51 80 00       	mov    %eax,0x805138
  802f54:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f57:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f60:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f67:	a1 44 51 80 00       	mov    0x805144,%eax
  802f6c:	48                   	dec    %eax
  802f6d:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802f72:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f75:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802f7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f7f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802f86:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f8a:	75 17                	jne    802fa3 <insert_sorted_with_merge_freeList+0x183>
  802f8c:	83 ec 04             	sub    $0x4,%esp
  802f8f:	68 fc 41 80 00       	push   $0x8041fc
  802f94:	68 3f 01 00 00       	push   $0x13f
  802f99:	68 1f 42 80 00       	push   $0x80421f
  802f9e:	e8 f6 d4 ff ff       	call   800499 <_panic>
  802fa3:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802fa9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fac:	89 10                	mov    %edx,(%eax)
  802fae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fb1:	8b 00                	mov    (%eax),%eax
  802fb3:	85 c0                	test   %eax,%eax
  802fb5:	74 0d                	je     802fc4 <insert_sorted_with_merge_freeList+0x1a4>
  802fb7:	a1 48 51 80 00       	mov    0x805148,%eax
  802fbc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802fbf:	89 50 04             	mov    %edx,0x4(%eax)
  802fc2:	eb 08                	jmp    802fcc <insert_sorted_with_merge_freeList+0x1ac>
  802fc4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fc7:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802fcc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fcf:	a3 48 51 80 00       	mov    %eax,0x805148
  802fd4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fd7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fde:	a1 54 51 80 00       	mov    0x805154,%eax
  802fe3:	40                   	inc    %eax
  802fe4:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802fe9:	e9 7a 05 00 00       	jmp    803568 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802fee:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff1:	8b 50 08             	mov    0x8(%eax),%edx
  802ff4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ff7:	8b 40 08             	mov    0x8(%eax),%eax
  802ffa:	39 c2                	cmp    %eax,%edx
  802ffc:	0f 82 14 01 00 00    	jb     803116 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  803002:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803005:	8b 50 08             	mov    0x8(%eax),%edx
  803008:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80300b:	8b 40 0c             	mov    0xc(%eax),%eax
  80300e:	01 c2                	add    %eax,%edx
  803010:	8b 45 08             	mov    0x8(%ebp),%eax
  803013:	8b 40 08             	mov    0x8(%eax),%eax
  803016:	39 c2                	cmp    %eax,%edx
  803018:	0f 85 90 00 00 00    	jne    8030ae <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  80301e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803021:	8b 50 0c             	mov    0xc(%eax),%edx
  803024:	8b 45 08             	mov    0x8(%ebp),%eax
  803027:	8b 40 0c             	mov    0xc(%eax),%eax
  80302a:	01 c2                	add    %eax,%edx
  80302c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80302f:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  803032:	8b 45 08             	mov    0x8(%ebp),%eax
  803035:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  80303c:	8b 45 08             	mov    0x8(%ebp),%eax
  80303f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803046:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80304a:	75 17                	jne    803063 <insert_sorted_with_merge_freeList+0x243>
  80304c:	83 ec 04             	sub    $0x4,%esp
  80304f:	68 fc 41 80 00       	push   $0x8041fc
  803054:	68 49 01 00 00       	push   $0x149
  803059:	68 1f 42 80 00       	push   $0x80421f
  80305e:	e8 36 d4 ff ff       	call   800499 <_panic>
  803063:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803069:	8b 45 08             	mov    0x8(%ebp),%eax
  80306c:	89 10                	mov    %edx,(%eax)
  80306e:	8b 45 08             	mov    0x8(%ebp),%eax
  803071:	8b 00                	mov    (%eax),%eax
  803073:	85 c0                	test   %eax,%eax
  803075:	74 0d                	je     803084 <insert_sorted_with_merge_freeList+0x264>
  803077:	a1 48 51 80 00       	mov    0x805148,%eax
  80307c:	8b 55 08             	mov    0x8(%ebp),%edx
  80307f:	89 50 04             	mov    %edx,0x4(%eax)
  803082:	eb 08                	jmp    80308c <insert_sorted_with_merge_freeList+0x26c>
  803084:	8b 45 08             	mov    0x8(%ebp),%eax
  803087:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80308c:	8b 45 08             	mov    0x8(%ebp),%eax
  80308f:	a3 48 51 80 00       	mov    %eax,0x805148
  803094:	8b 45 08             	mov    0x8(%ebp),%eax
  803097:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80309e:	a1 54 51 80 00       	mov    0x805154,%eax
  8030a3:	40                   	inc    %eax
  8030a4:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8030a9:	e9 bb 04 00 00       	jmp    803569 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  8030ae:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030b2:	75 17                	jne    8030cb <insert_sorted_with_merge_freeList+0x2ab>
  8030b4:	83 ec 04             	sub    $0x4,%esp
  8030b7:	68 70 42 80 00       	push   $0x804270
  8030bc:	68 4c 01 00 00       	push   $0x14c
  8030c1:	68 1f 42 80 00       	push   $0x80421f
  8030c6:	e8 ce d3 ff ff       	call   800499 <_panic>
  8030cb:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  8030d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d4:	89 50 04             	mov    %edx,0x4(%eax)
  8030d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8030da:	8b 40 04             	mov    0x4(%eax),%eax
  8030dd:	85 c0                	test   %eax,%eax
  8030df:	74 0c                	je     8030ed <insert_sorted_with_merge_freeList+0x2cd>
  8030e1:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8030e6:	8b 55 08             	mov    0x8(%ebp),%edx
  8030e9:	89 10                	mov    %edx,(%eax)
  8030eb:	eb 08                	jmp    8030f5 <insert_sorted_with_merge_freeList+0x2d5>
  8030ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f0:	a3 38 51 80 00       	mov    %eax,0x805138
  8030f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f8:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8030fd:	8b 45 08             	mov    0x8(%ebp),%eax
  803100:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803106:	a1 44 51 80 00       	mov    0x805144,%eax
  80310b:	40                   	inc    %eax
  80310c:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803111:	e9 53 04 00 00       	jmp    803569 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803116:	a1 38 51 80 00       	mov    0x805138,%eax
  80311b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80311e:	e9 15 04 00 00       	jmp    803538 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  803123:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803126:	8b 00                	mov    (%eax),%eax
  803128:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  80312b:	8b 45 08             	mov    0x8(%ebp),%eax
  80312e:	8b 50 08             	mov    0x8(%eax),%edx
  803131:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803134:	8b 40 08             	mov    0x8(%eax),%eax
  803137:	39 c2                	cmp    %eax,%edx
  803139:	0f 86 f1 03 00 00    	jbe    803530 <insert_sorted_with_merge_freeList+0x710>
  80313f:	8b 45 08             	mov    0x8(%ebp),%eax
  803142:	8b 50 08             	mov    0x8(%eax),%edx
  803145:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803148:	8b 40 08             	mov    0x8(%eax),%eax
  80314b:	39 c2                	cmp    %eax,%edx
  80314d:	0f 83 dd 03 00 00    	jae    803530 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  803153:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803156:	8b 50 08             	mov    0x8(%eax),%edx
  803159:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80315c:	8b 40 0c             	mov    0xc(%eax),%eax
  80315f:	01 c2                	add    %eax,%edx
  803161:	8b 45 08             	mov    0x8(%ebp),%eax
  803164:	8b 40 08             	mov    0x8(%eax),%eax
  803167:	39 c2                	cmp    %eax,%edx
  803169:	0f 85 b9 01 00 00    	jne    803328 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  80316f:	8b 45 08             	mov    0x8(%ebp),%eax
  803172:	8b 50 08             	mov    0x8(%eax),%edx
  803175:	8b 45 08             	mov    0x8(%ebp),%eax
  803178:	8b 40 0c             	mov    0xc(%eax),%eax
  80317b:	01 c2                	add    %eax,%edx
  80317d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803180:	8b 40 08             	mov    0x8(%eax),%eax
  803183:	39 c2                	cmp    %eax,%edx
  803185:	0f 85 0d 01 00 00    	jne    803298 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  80318b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80318e:	8b 50 0c             	mov    0xc(%eax),%edx
  803191:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803194:	8b 40 0c             	mov    0xc(%eax),%eax
  803197:	01 c2                	add    %eax,%edx
  803199:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80319c:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80319f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8031a3:	75 17                	jne    8031bc <insert_sorted_with_merge_freeList+0x39c>
  8031a5:	83 ec 04             	sub    $0x4,%esp
  8031a8:	68 c8 42 80 00       	push   $0x8042c8
  8031ad:	68 5c 01 00 00       	push   $0x15c
  8031b2:	68 1f 42 80 00       	push   $0x80421f
  8031b7:	e8 dd d2 ff ff       	call   800499 <_panic>
  8031bc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031bf:	8b 00                	mov    (%eax),%eax
  8031c1:	85 c0                	test   %eax,%eax
  8031c3:	74 10                	je     8031d5 <insert_sorted_with_merge_freeList+0x3b5>
  8031c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031c8:	8b 00                	mov    (%eax),%eax
  8031ca:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031cd:	8b 52 04             	mov    0x4(%edx),%edx
  8031d0:	89 50 04             	mov    %edx,0x4(%eax)
  8031d3:	eb 0b                	jmp    8031e0 <insert_sorted_with_merge_freeList+0x3c0>
  8031d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031d8:	8b 40 04             	mov    0x4(%eax),%eax
  8031db:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8031e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031e3:	8b 40 04             	mov    0x4(%eax),%eax
  8031e6:	85 c0                	test   %eax,%eax
  8031e8:	74 0f                	je     8031f9 <insert_sorted_with_merge_freeList+0x3d9>
  8031ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ed:	8b 40 04             	mov    0x4(%eax),%eax
  8031f0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031f3:	8b 12                	mov    (%edx),%edx
  8031f5:	89 10                	mov    %edx,(%eax)
  8031f7:	eb 0a                	jmp    803203 <insert_sorted_with_merge_freeList+0x3e3>
  8031f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031fc:	8b 00                	mov    (%eax),%eax
  8031fe:	a3 38 51 80 00       	mov    %eax,0x805138
  803203:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803206:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80320c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80320f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803216:	a1 44 51 80 00       	mov    0x805144,%eax
  80321b:	48                   	dec    %eax
  80321c:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  803221:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803224:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  80322b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80322e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803235:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803239:	75 17                	jne    803252 <insert_sorted_with_merge_freeList+0x432>
  80323b:	83 ec 04             	sub    $0x4,%esp
  80323e:	68 fc 41 80 00       	push   $0x8041fc
  803243:	68 5f 01 00 00       	push   $0x15f
  803248:	68 1f 42 80 00       	push   $0x80421f
  80324d:	e8 47 d2 ff ff       	call   800499 <_panic>
  803252:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803258:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80325b:	89 10                	mov    %edx,(%eax)
  80325d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803260:	8b 00                	mov    (%eax),%eax
  803262:	85 c0                	test   %eax,%eax
  803264:	74 0d                	je     803273 <insert_sorted_with_merge_freeList+0x453>
  803266:	a1 48 51 80 00       	mov    0x805148,%eax
  80326b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80326e:	89 50 04             	mov    %edx,0x4(%eax)
  803271:	eb 08                	jmp    80327b <insert_sorted_with_merge_freeList+0x45b>
  803273:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803276:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80327b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80327e:	a3 48 51 80 00       	mov    %eax,0x805148
  803283:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803286:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80328d:	a1 54 51 80 00       	mov    0x805154,%eax
  803292:	40                   	inc    %eax
  803293:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803298:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80329b:	8b 50 0c             	mov    0xc(%eax),%edx
  80329e:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a1:	8b 40 0c             	mov    0xc(%eax),%eax
  8032a4:	01 c2                	add    %eax,%edx
  8032a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032a9:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  8032ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8032af:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  8032b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8032c0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032c4:	75 17                	jne    8032dd <insert_sorted_with_merge_freeList+0x4bd>
  8032c6:	83 ec 04             	sub    $0x4,%esp
  8032c9:	68 fc 41 80 00       	push   $0x8041fc
  8032ce:	68 64 01 00 00       	push   $0x164
  8032d3:	68 1f 42 80 00       	push   $0x80421f
  8032d8:	e8 bc d1 ff ff       	call   800499 <_panic>
  8032dd:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8032e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e6:	89 10                	mov    %edx,(%eax)
  8032e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8032eb:	8b 00                	mov    (%eax),%eax
  8032ed:	85 c0                	test   %eax,%eax
  8032ef:	74 0d                	je     8032fe <insert_sorted_with_merge_freeList+0x4de>
  8032f1:	a1 48 51 80 00       	mov    0x805148,%eax
  8032f6:	8b 55 08             	mov    0x8(%ebp),%edx
  8032f9:	89 50 04             	mov    %edx,0x4(%eax)
  8032fc:	eb 08                	jmp    803306 <insert_sorted_with_merge_freeList+0x4e6>
  8032fe:	8b 45 08             	mov    0x8(%ebp),%eax
  803301:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803306:	8b 45 08             	mov    0x8(%ebp),%eax
  803309:	a3 48 51 80 00       	mov    %eax,0x805148
  80330e:	8b 45 08             	mov    0x8(%ebp),%eax
  803311:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803318:	a1 54 51 80 00       	mov    0x805154,%eax
  80331d:	40                   	inc    %eax
  80331e:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803323:	e9 41 02 00 00       	jmp    803569 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803328:	8b 45 08             	mov    0x8(%ebp),%eax
  80332b:	8b 50 08             	mov    0x8(%eax),%edx
  80332e:	8b 45 08             	mov    0x8(%ebp),%eax
  803331:	8b 40 0c             	mov    0xc(%eax),%eax
  803334:	01 c2                	add    %eax,%edx
  803336:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803339:	8b 40 08             	mov    0x8(%eax),%eax
  80333c:	39 c2                	cmp    %eax,%edx
  80333e:	0f 85 7c 01 00 00    	jne    8034c0 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803344:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803348:	74 06                	je     803350 <insert_sorted_with_merge_freeList+0x530>
  80334a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80334e:	75 17                	jne    803367 <insert_sorted_with_merge_freeList+0x547>
  803350:	83 ec 04             	sub    $0x4,%esp
  803353:	68 38 42 80 00       	push   $0x804238
  803358:	68 69 01 00 00       	push   $0x169
  80335d:	68 1f 42 80 00       	push   $0x80421f
  803362:	e8 32 d1 ff ff       	call   800499 <_panic>
  803367:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80336a:	8b 50 04             	mov    0x4(%eax),%edx
  80336d:	8b 45 08             	mov    0x8(%ebp),%eax
  803370:	89 50 04             	mov    %edx,0x4(%eax)
  803373:	8b 45 08             	mov    0x8(%ebp),%eax
  803376:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803379:	89 10                	mov    %edx,(%eax)
  80337b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80337e:	8b 40 04             	mov    0x4(%eax),%eax
  803381:	85 c0                	test   %eax,%eax
  803383:	74 0d                	je     803392 <insert_sorted_with_merge_freeList+0x572>
  803385:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803388:	8b 40 04             	mov    0x4(%eax),%eax
  80338b:	8b 55 08             	mov    0x8(%ebp),%edx
  80338e:	89 10                	mov    %edx,(%eax)
  803390:	eb 08                	jmp    80339a <insert_sorted_with_merge_freeList+0x57a>
  803392:	8b 45 08             	mov    0x8(%ebp),%eax
  803395:	a3 38 51 80 00       	mov    %eax,0x805138
  80339a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80339d:	8b 55 08             	mov    0x8(%ebp),%edx
  8033a0:	89 50 04             	mov    %edx,0x4(%eax)
  8033a3:	a1 44 51 80 00       	mov    0x805144,%eax
  8033a8:	40                   	inc    %eax
  8033a9:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  8033ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b1:	8b 50 0c             	mov    0xc(%eax),%edx
  8033b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033b7:	8b 40 0c             	mov    0xc(%eax),%eax
  8033ba:	01 c2                	add    %eax,%edx
  8033bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8033bf:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8033c2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8033c6:	75 17                	jne    8033df <insert_sorted_with_merge_freeList+0x5bf>
  8033c8:	83 ec 04             	sub    $0x4,%esp
  8033cb:	68 c8 42 80 00       	push   $0x8042c8
  8033d0:	68 6b 01 00 00       	push   $0x16b
  8033d5:	68 1f 42 80 00       	push   $0x80421f
  8033da:	e8 ba d0 ff ff       	call   800499 <_panic>
  8033df:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033e2:	8b 00                	mov    (%eax),%eax
  8033e4:	85 c0                	test   %eax,%eax
  8033e6:	74 10                	je     8033f8 <insert_sorted_with_merge_freeList+0x5d8>
  8033e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033eb:	8b 00                	mov    (%eax),%eax
  8033ed:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8033f0:	8b 52 04             	mov    0x4(%edx),%edx
  8033f3:	89 50 04             	mov    %edx,0x4(%eax)
  8033f6:	eb 0b                	jmp    803403 <insert_sorted_with_merge_freeList+0x5e3>
  8033f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033fb:	8b 40 04             	mov    0x4(%eax),%eax
  8033fe:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803403:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803406:	8b 40 04             	mov    0x4(%eax),%eax
  803409:	85 c0                	test   %eax,%eax
  80340b:	74 0f                	je     80341c <insert_sorted_with_merge_freeList+0x5fc>
  80340d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803410:	8b 40 04             	mov    0x4(%eax),%eax
  803413:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803416:	8b 12                	mov    (%edx),%edx
  803418:	89 10                	mov    %edx,(%eax)
  80341a:	eb 0a                	jmp    803426 <insert_sorted_with_merge_freeList+0x606>
  80341c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80341f:	8b 00                	mov    (%eax),%eax
  803421:	a3 38 51 80 00       	mov    %eax,0x805138
  803426:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803429:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80342f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803432:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803439:	a1 44 51 80 00       	mov    0x805144,%eax
  80343e:	48                   	dec    %eax
  80343f:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803444:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803447:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  80344e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803451:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803458:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80345c:	75 17                	jne    803475 <insert_sorted_with_merge_freeList+0x655>
  80345e:	83 ec 04             	sub    $0x4,%esp
  803461:	68 fc 41 80 00       	push   $0x8041fc
  803466:	68 6e 01 00 00       	push   $0x16e
  80346b:	68 1f 42 80 00       	push   $0x80421f
  803470:	e8 24 d0 ff ff       	call   800499 <_panic>
  803475:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80347b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80347e:	89 10                	mov    %edx,(%eax)
  803480:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803483:	8b 00                	mov    (%eax),%eax
  803485:	85 c0                	test   %eax,%eax
  803487:	74 0d                	je     803496 <insert_sorted_with_merge_freeList+0x676>
  803489:	a1 48 51 80 00       	mov    0x805148,%eax
  80348e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803491:	89 50 04             	mov    %edx,0x4(%eax)
  803494:	eb 08                	jmp    80349e <insert_sorted_with_merge_freeList+0x67e>
  803496:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803499:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80349e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034a1:	a3 48 51 80 00       	mov    %eax,0x805148
  8034a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034a9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034b0:	a1 54 51 80 00       	mov    0x805154,%eax
  8034b5:	40                   	inc    %eax
  8034b6:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8034bb:	e9 a9 00 00 00       	jmp    803569 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  8034c0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034c4:	74 06                	je     8034cc <insert_sorted_with_merge_freeList+0x6ac>
  8034c6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034ca:	75 17                	jne    8034e3 <insert_sorted_with_merge_freeList+0x6c3>
  8034cc:	83 ec 04             	sub    $0x4,%esp
  8034cf:	68 94 42 80 00       	push   $0x804294
  8034d4:	68 73 01 00 00       	push   $0x173
  8034d9:	68 1f 42 80 00       	push   $0x80421f
  8034de:	e8 b6 cf ff ff       	call   800499 <_panic>
  8034e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034e6:	8b 10                	mov    (%eax),%edx
  8034e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8034eb:	89 10                	mov    %edx,(%eax)
  8034ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8034f0:	8b 00                	mov    (%eax),%eax
  8034f2:	85 c0                	test   %eax,%eax
  8034f4:	74 0b                	je     803501 <insert_sorted_with_merge_freeList+0x6e1>
  8034f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034f9:	8b 00                	mov    (%eax),%eax
  8034fb:	8b 55 08             	mov    0x8(%ebp),%edx
  8034fe:	89 50 04             	mov    %edx,0x4(%eax)
  803501:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803504:	8b 55 08             	mov    0x8(%ebp),%edx
  803507:	89 10                	mov    %edx,(%eax)
  803509:	8b 45 08             	mov    0x8(%ebp),%eax
  80350c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80350f:	89 50 04             	mov    %edx,0x4(%eax)
  803512:	8b 45 08             	mov    0x8(%ebp),%eax
  803515:	8b 00                	mov    (%eax),%eax
  803517:	85 c0                	test   %eax,%eax
  803519:	75 08                	jne    803523 <insert_sorted_with_merge_freeList+0x703>
  80351b:	8b 45 08             	mov    0x8(%ebp),%eax
  80351e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803523:	a1 44 51 80 00       	mov    0x805144,%eax
  803528:	40                   	inc    %eax
  803529:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  80352e:	eb 39                	jmp    803569 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803530:	a1 40 51 80 00       	mov    0x805140,%eax
  803535:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803538:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80353c:	74 07                	je     803545 <insert_sorted_with_merge_freeList+0x725>
  80353e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803541:	8b 00                	mov    (%eax),%eax
  803543:	eb 05                	jmp    80354a <insert_sorted_with_merge_freeList+0x72a>
  803545:	b8 00 00 00 00       	mov    $0x0,%eax
  80354a:	a3 40 51 80 00       	mov    %eax,0x805140
  80354f:	a1 40 51 80 00       	mov    0x805140,%eax
  803554:	85 c0                	test   %eax,%eax
  803556:	0f 85 c7 fb ff ff    	jne    803123 <insert_sorted_with_merge_freeList+0x303>
  80355c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803560:	0f 85 bd fb ff ff    	jne    803123 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803566:	eb 01                	jmp    803569 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803568:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803569:	90                   	nop
  80356a:	c9                   	leave  
  80356b:	c3                   	ret    

0080356c <__udivdi3>:
  80356c:	55                   	push   %ebp
  80356d:	57                   	push   %edi
  80356e:	56                   	push   %esi
  80356f:	53                   	push   %ebx
  803570:	83 ec 1c             	sub    $0x1c,%esp
  803573:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803577:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80357b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80357f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803583:	89 ca                	mov    %ecx,%edx
  803585:	89 f8                	mov    %edi,%eax
  803587:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80358b:	85 f6                	test   %esi,%esi
  80358d:	75 2d                	jne    8035bc <__udivdi3+0x50>
  80358f:	39 cf                	cmp    %ecx,%edi
  803591:	77 65                	ja     8035f8 <__udivdi3+0x8c>
  803593:	89 fd                	mov    %edi,%ebp
  803595:	85 ff                	test   %edi,%edi
  803597:	75 0b                	jne    8035a4 <__udivdi3+0x38>
  803599:	b8 01 00 00 00       	mov    $0x1,%eax
  80359e:	31 d2                	xor    %edx,%edx
  8035a0:	f7 f7                	div    %edi
  8035a2:	89 c5                	mov    %eax,%ebp
  8035a4:	31 d2                	xor    %edx,%edx
  8035a6:	89 c8                	mov    %ecx,%eax
  8035a8:	f7 f5                	div    %ebp
  8035aa:	89 c1                	mov    %eax,%ecx
  8035ac:	89 d8                	mov    %ebx,%eax
  8035ae:	f7 f5                	div    %ebp
  8035b0:	89 cf                	mov    %ecx,%edi
  8035b2:	89 fa                	mov    %edi,%edx
  8035b4:	83 c4 1c             	add    $0x1c,%esp
  8035b7:	5b                   	pop    %ebx
  8035b8:	5e                   	pop    %esi
  8035b9:	5f                   	pop    %edi
  8035ba:	5d                   	pop    %ebp
  8035bb:	c3                   	ret    
  8035bc:	39 ce                	cmp    %ecx,%esi
  8035be:	77 28                	ja     8035e8 <__udivdi3+0x7c>
  8035c0:	0f bd fe             	bsr    %esi,%edi
  8035c3:	83 f7 1f             	xor    $0x1f,%edi
  8035c6:	75 40                	jne    803608 <__udivdi3+0x9c>
  8035c8:	39 ce                	cmp    %ecx,%esi
  8035ca:	72 0a                	jb     8035d6 <__udivdi3+0x6a>
  8035cc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8035d0:	0f 87 9e 00 00 00    	ja     803674 <__udivdi3+0x108>
  8035d6:	b8 01 00 00 00       	mov    $0x1,%eax
  8035db:	89 fa                	mov    %edi,%edx
  8035dd:	83 c4 1c             	add    $0x1c,%esp
  8035e0:	5b                   	pop    %ebx
  8035e1:	5e                   	pop    %esi
  8035e2:	5f                   	pop    %edi
  8035e3:	5d                   	pop    %ebp
  8035e4:	c3                   	ret    
  8035e5:	8d 76 00             	lea    0x0(%esi),%esi
  8035e8:	31 ff                	xor    %edi,%edi
  8035ea:	31 c0                	xor    %eax,%eax
  8035ec:	89 fa                	mov    %edi,%edx
  8035ee:	83 c4 1c             	add    $0x1c,%esp
  8035f1:	5b                   	pop    %ebx
  8035f2:	5e                   	pop    %esi
  8035f3:	5f                   	pop    %edi
  8035f4:	5d                   	pop    %ebp
  8035f5:	c3                   	ret    
  8035f6:	66 90                	xchg   %ax,%ax
  8035f8:	89 d8                	mov    %ebx,%eax
  8035fa:	f7 f7                	div    %edi
  8035fc:	31 ff                	xor    %edi,%edi
  8035fe:	89 fa                	mov    %edi,%edx
  803600:	83 c4 1c             	add    $0x1c,%esp
  803603:	5b                   	pop    %ebx
  803604:	5e                   	pop    %esi
  803605:	5f                   	pop    %edi
  803606:	5d                   	pop    %ebp
  803607:	c3                   	ret    
  803608:	bd 20 00 00 00       	mov    $0x20,%ebp
  80360d:	89 eb                	mov    %ebp,%ebx
  80360f:	29 fb                	sub    %edi,%ebx
  803611:	89 f9                	mov    %edi,%ecx
  803613:	d3 e6                	shl    %cl,%esi
  803615:	89 c5                	mov    %eax,%ebp
  803617:	88 d9                	mov    %bl,%cl
  803619:	d3 ed                	shr    %cl,%ebp
  80361b:	89 e9                	mov    %ebp,%ecx
  80361d:	09 f1                	or     %esi,%ecx
  80361f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803623:	89 f9                	mov    %edi,%ecx
  803625:	d3 e0                	shl    %cl,%eax
  803627:	89 c5                	mov    %eax,%ebp
  803629:	89 d6                	mov    %edx,%esi
  80362b:	88 d9                	mov    %bl,%cl
  80362d:	d3 ee                	shr    %cl,%esi
  80362f:	89 f9                	mov    %edi,%ecx
  803631:	d3 e2                	shl    %cl,%edx
  803633:	8b 44 24 08          	mov    0x8(%esp),%eax
  803637:	88 d9                	mov    %bl,%cl
  803639:	d3 e8                	shr    %cl,%eax
  80363b:	09 c2                	or     %eax,%edx
  80363d:	89 d0                	mov    %edx,%eax
  80363f:	89 f2                	mov    %esi,%edx
  803641:	f7 74 24 0c          	divl   0xc(%esp)
  803645:	89 d6                	mov    %edx,%esi
  803647:	89 c3                	mov    %eax,%ebx
  803649:	f7 e5                	mul    %ebp
  80364b:	39 d6                	cmp    %edx,%esi
  80364d:	72 19                	jb     803668 <__udivdi3+0xfc>
  80364f:	74 0b                	je     80365c <__udivdi3+0xf0>
  803651:	89 d8                	mov    %ebx,%eax
  803653:	31 ff                	xor    %edi,%edi
  803655:	e9 58 ff ff ff       	jmp    8035b2 <__udivdi3+0x46>
  80365a:	66 90                	xchg   %ax,%ax
  80365c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803660:	89 f9                	mov    %edi,%ecx
  803662:	d3 e2                	shl    %cl,%edx
  803664:	39 c2                	cmp    %eax,%edx
  803666:	73 e9                	jae    803651 <__udivdi3+0xe5>
  803668:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80366b:	31 ff                	xor    %edi,%edi
  80366d:	e9 40 ff ff ff       	jmp    8035b2 <__udivdi3+0x46>
  803672:	66 90                	xchg   %ax,%ax
  803674:	31 c0                	xor    %eax,%eax
  803676:	e9 37 ff ff ff       	jmp    8035b2 <__udivdi3+0x46>
  80367b:	90                   	nop

0080367c <__umoddi3>:
  80367c:	55                   	push   %ebp
  80367d:	57                   	push   %edi
  80367e:	56                   	push   %esi
  80367f:	53                   	push   %ebx
  803680:	83 ec 1c             	sub    $0x1c,%esp
  803683:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803687:	8b 74 24 34          	mov    0x34(%esp),%esi
  80368b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80368f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803693:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803697:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80369b:	89 f3                	mov    %esi,%ebx
  80369d:	89 fa                	mov    %edi,%edx
  80369f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8036a3:	89 34 24             	mov    %esi,(%esp)
  8036a6:	85 c0                	test   %eax,%eax
  8036a8:	75 1a                	jne    8036c4 <__umoddi3+0x48>
  8036aa:	39 f7                	cmp    %esi,%edi
  8036ac:	0f 86 a2 00 00 00    	jbe    803754 <__umoddi3+0xd8>
  8036b2:	89 c8                	mov    %ecx,%eax
  8036b4:	89 f2                	mov    %esi,%edx
  8036b6:	f7 f7                	div    %edi
  8036b8:	89 d0                	mov    %edx,%eax
  8036ba:	31 d2                	xor    %edx,%edx
  8036bc:	83 c4 1c             	add    $0x1c,%esp
  8036bf:	5b                   	pop    %ebx
  8036c0:	5e                   	pop    %esi
  8036c1:	5f                   	pop    %edi
  8036c2:	5d                   	pop    %ebp
  8036c3:	c3                   	ret    
  8036c4:	39 f0                	cmp    %esi,%eax
  8036c6:	0f 87 ac 00 00 00    	ja     803778 <__umoddi3+0xfc>
  8036cc:	0f bd e8             	bsr    %eax,%ebp
  8036cf:	83 f5 1f             	xor    $0x1f,%ebp
  8036d2:	0f 84 ac 00 00 00    	je     803784 <__umoddi3+0x108>
  8036d8:	bf 20 00 00 00       	mov    $0x20,%edi
  8036dd:	29 ef                	sub    %ebp,%edi
  8036df:	89 fe                	mov    %edi,%esi
  8036e1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8036e5:	89 e9                	mov    %ebp,%ecx
  8036e7:	d3 e0                	shl    %cl,%eax
  8036e9:	89 d7                	mov    %edx,%edi
  8036eb:	89 f1                	mov    %esi,%ecx
  8036ed:	d3 ef                	shr    %cl,%edi
  8036ef:	09 c7                	or     %eax,%edi
  8036f1:	89 e9                	mov    %ebp,%ecx
  8036f3:	d3 e2                	shl    %cl,%edx
  8036f5:	89 14 24             	mov    %edx,(%esp)
  8036f8:	89 d8                	mov    %ebx,%eax
  8036fa:	d3 e0                	shl    %cl,%eax
  8036fc:	89 c2                	mov    %eax,%edx
  8036fe:	8b 44 24 08          	mov    0x8(%esp),%eax
  803702:	d3 e0                	shl    %cl,%eax
  803704:	89 44 24 04          	mov    %eax,0x4(%esp)
  803708:	8b 44 24 08          	mov    0x8(%esp),%eax
  80370c:	89 f1                	mov    %esi,%ecx
  80370e:	d3 e8                	shr    %cl,%eax
  803710:	09 d0                	or     %edx,%eax
  803712:	d3 eb                	shr    %cl,%ebx
  803714:	89 da                	mov    %ebx,%edx
  803716:	f7 f7                	div    %edi
  803718:	89 d3                	mov    %edx,%ebx
  80371a:	f7 24 24             	mull   (%esp)
  80371d:	89 c6                	mov    %eax,%esi
  80371f:	89 d1                	mov    %edx,%ecx
  803721:	39 d3                	cmp    %edx,%ebx
  803723:	0f 82 87 00 00 00    	jb     8037b0 <__umoddi3+0x134>
  803729:	0f 84 91 00 00 00    	je     8037c0 <__umoddi3+0x144>
  80372f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803733:	29 f2                	sub    %esi,%edx
  803735:	19 cb                	sbb    %ecx,%ebx
  803737:	89 d8                	mov    %ebx,%eax
  803739:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80373d:	d3 e0                	shl    %cl,%eax
  80373f:	89 e9                	mov    %ebp,%ecx
  803741:	d3 ea                	shr    %cl,%edx
  803743:	09 d0                	or     %edx,%eax
  803745:	89 e9                	mov    %ebp,%ecx
  803747:	d3 eb                	shr    %cl,%ebx
  803749:	89 da                	mov    %ebx,%edx
  80374b:	83 c4 1c             	add    $0x1c,%esp
  80374e:	5b                   	pop    %ebx
  80374f:	5e                   	pop    %esi
  803750:	5f                   	pop    %edi
  803751:	5d                   	pop    %ebp
  803752:	c3                   	ret    
  803753:	90                   	nop
  803754:	89 fd                	mov    %edi,%ebp
  803756:	85 ff                	test   %edi,%edi
  803758:	75 0b                	jne    803765 <__umoddi3+0xe9>
  80375a:	b8 01 00 00 00       	mov    $0x1,%eax
  80375f:	31 d2                	xor    %edx,%edx
  803761:	f7 f7                	div    %edi
  803763:	89 c5                	mov    %eax,%ebp
  803765:	89 f0                	mov    %esi,%eax
  803767:	31 d2                	xor    %edx,%edx
  803769:	f7 f5                	div    %ebp
  80376b:	89 c8                	mov    %ecx,%eax
  80376d:	f7 f5                	div    %ebp
  80376f:	89 d0                	mov    %edx,%eax
  803771:	e9 44 ff ff ff       	jmp    8036ba <__umoddi3+0x3e>
  803776:	66 90                	xchg   %ax,%ax
  803778:	89 c8                	mov    %ecx,%eax
  80377a:	89 f2                	mov    %esi,%edx
  80377c:	83 c4 1c             	add    $0x1c,%esp
  80377f:	5b                   	pop    %ebx
  803780:	5e                   	pop    %esi
  803781:	5f                   	pop    %edi
  803782:	5d                   	pop    %ebp
  803783:	c3                   	ret    
  803784:	3b 04 24             	cmp    (%esp),%eax
  803787:	72 06                	jb     80378f <__umoddi3+0x113>
  803789:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80378d:	77 0f                	ja     80379e <__umoddi3+0x122>
  80378f:	89 f2                	mov    %esi,%edx
  803791:	29 f9                	sub    %edi,%ecx
  803793:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803797:	89 14 24             	mov    %edx,(%esp)
  80379a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80379e:	8b 44 24 04          	mov    0x4(%esp),%eax
  8037a2:	8b 14 24             	mov    (%esp),%edx
  8037a5:	83 c4 1c             	add    $0x1c,%esp
  8037a8:	5b                   	pop    %ebx
  8037a9:	5e                   	pop    %esi
  8037aa:	5f                   	pop    %edi
  8037ab:	5d                   	pop    %ebp
  8037ac:	c3                   	ret    
  8037ad:	8d 76 00             	lea    0x0(%esi),%esi
  8037b0:	2b 04 24             	sub    (%esp),%eax
  8037b3:	19 fa                	sbb    %edi,%edx
  8037b5:	89 d1                	mov    %edx,%ecx
  8037b7:	89 c6                	mov    %eax,%esi
  8037b9:	e9 71 ff ff ff       	jmp    80372f <__umoddi3+0xb3>
  8037be:	66 90                	xchg   %ax,%ax
  8037c0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8037c4:	72 ea                	jb     8037b0 <__umoddi3+0x134>
  8037c6:	89 d9                	mov    %ebx,%ecx
  8037c8:	e9 62 ff ff ff       	jmp    80372f <__umoddi3+0xb3>
