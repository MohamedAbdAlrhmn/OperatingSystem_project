
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
  80008d:	68 20 39 80 00       	push   $0x803920
  800092:	6a 12                	push   $0x12
  800094:	68 3c 39 80 00       	push   $0x80393c
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
  8000ae:	68 54 39 80 00       	push   $0x803954
  8000b3:	e8 95 06 00 00       	call   80074d <cprintf>
  8000b8:	83 c4 10             	add    $0x10,%esp
	{
		int freeFrames = sys_calculate_free_frames() ;
  8000bb:	e8 32 1a 00 00       	call   801af2 <sys_calculate_free_frames>
  8000c0:	89 45 e8             	mov    %eax,-0x18(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8000c3:	83 ec 04             	sub    $0x4,%esp
  8000c6:	6a 01                	push   $0x1
  8000c8:	68 00 10 00 00       	push   $0x1000
  8000cd:	68 8b 39 80 00       	push   $0x80398b
  8000d2:	e8 49 17 00 00       	call   801820 <smalloc>
  8000d7:	83 c4 10             	add    $0x10,%esp
  8000da:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (x != (uint32*)USER_HEAP_START) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  8000dd:	81 7d e4 00 00 00 80 	cmpl   $0x80000000,-0x1c(%ebp)
  8000e4:	74 14                	je     8000fa <_main+0xc2>
  8000e6:	83 ec 04             	sub    $0x4,%esp
  8000e9:	68 90 39 80 00       	push   $0x803990
  8000ee:	6a 1e                	push   $0x1e
  8000f0:	68 3c 39 80 00       	push   $0x80393c
  8000f5:	e8 9f 03 00 00       	call   800499 <_panic>
		expected = 1+1+2 ;
  8000fa:	c7 45 e0 04 00 00 00 	movl   $0x4,-0x20(%ebp)
		if ((freeFrames - sys_calculate_free_frames()) !=  expected) panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);
  800101:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800104:	e8 e9 19 00 00       	call   801af2 <sys_calculate_free_frames>
  800109:	29 c3                	sub    %eax,%ebx
  80010b:	89 d8                	mov    %ebx,%eax
  80010d:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800110:	74 24                	je     800136 <_main+0xfe>
  800112:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800115:	e8 d8 19 00 00       	call   801af2 <sys_calculate_free_frames>
  80011a:	29 c3                	sub    %eax,%ebx
  80011c:	89 d8                	mov    %ebx,%eax
  80011e:	83 ec 0c             	sub    $0xc,%esp
  800121:	ff 75 e0             	pushl  -0x20(%ebp)
  800124:	50                   	push   %eax
  800125:	68 fc 39 80 00       	push   $0x8039fc
  80012a:	6a 20                	push   $0x20
  80012c:	68 3c 39 80 00       	push   $0x80393c
  800131:	e8 63 03 00 00       	call   800499 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800136:	e8 b7 19 00 00       	call   801af2 <sys_calculate_free_frames>
  80013b:	89 45 e8             	mov    %eax,-0x18(%ebp)
		z = smalloc("z", PAGE_SIZE + 4, 1);
  80013e:	83 ec 04             	sub    $0x4,%esp
  800141:	6a 01                	push   $0x1
  800143:	68 04 10 00 00       	push   $0x1004
  800148:	68 94 3a 80 00       	push   $0x803a94
  80014d:	e8 ce 16 00 00       	call   801820 <smalloc>
  800152:	83 c4 10             	add    $0x10,%esp
  800155:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (z != (uint32*)(USER_HEAP_START + 1 * PAGE_SIZE)) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  800158:	81 7d dc 00 10 00 80 	cmpl   $0x80001000,-0x24(%ebp)
  80015f:	74 14                	je     800175 <_main+0x13d>
  800161:	83 ec 04             	sub    $0x4,%esp
  800164:	68 90 39 80 00       	push   $0x803990
  800169:	6a 24                	push   $0x24
  80016b:	68 3c 39 80 00       	push   $0x80393c
  800170:	e8 24 03 00 00       	call   800499 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  2+0+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800175:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800178:	e8 75 19 00 00       	call   801af2 <sys_calculate_free_frames>
  80017d:	29 c3                	sub    %eax,%ebx
  80017f:	89 d8                	mov    %ebx,%eax
  800181:	83 f8 04             	cmp    $0x4,%eax
  800184:	74 14                	je     80019a <_main+0x162>
  800186:	83 ec 04             	sub    $0x4,%esp
  800189:	68 98 3a 80 00       	push   $0x803a98
  80018e:	6a 25                	push   $0x25
  800190:	68 3c 39 80 00       	push   $0x80393c
  800195:	e8 ff 02 00 00       	call   800499 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  80019a:	e8 53 19 00 00       	call   801af2 <sys_calculate_free_frames>
  80019f:	89 45 e8             	mov    %eax,-0x18(%ebp)
		y = smalloc("y", 4, 1);
  8001a2:	83 ec 04             	sub    $0x4,%esp
  8001a5:	6a 01                	push   $0x1
  8001a7:	6a 04                	push   $0x4
  8001a9:	68 16 3b 80 00       	push   $0x803b16
  8001ae:	e8 6d 16 00 00       	call   801820 <smalloc>
  8001b3:	83 c4 10             	add    $0x10,%esp
  8001b6:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if (y != (uint32*)(USER_HEAP_START + 3 * PAGE_SIZE)) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  8001b9:	81 7d d8 00 30 00 80 	cmpl   $0x80003000,-0x28(%ebp)
  8001c0:	74 14                	je     8001d6 <_main+0x19e>
  8001c2:	83 ec 04             	sub    $0x4,%esp
  8001c5:	68 90 39 80 00       	push   $0x803990
  8001ca:	6a 29                	push   $0x29
  8001cc:	68 3c 39 80 00       	push   $0x80393c
  8001d1:	e8 c3 02 00 00       	call   800499 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  1+0+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  8001d6:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8001d9:	e8 14 19 00 00       	call   801af2 <sys_calculate_free_frames>
  8001de:	29 c3                	sub    %eax,%ebx
  8001e0:	89 d8                	mov    %ebx,%eax
  8001e2:	83 f8 03             	cmp    $0x3,%eax
  8001e5:	74 14                	je     8001fb <_main+0x1c3>
  8001e7:	83 ec 04             	sub    $0x4,%esp
  8001ea:	68 98 3a 80 00       	push   $0x803a98
  8001ef:	6a 2a                	push   $0x2a
  8001f1:	68 3c 39 80 00       	push   $0x80393c
  8001f6:	e8 9e 02 00 00       	call   800499 <_panic>
	}
	cprintf("Step A is completed successfully!!\n\n\n");
  8001fb:	83 ec 0c             	sub    $0xc,%esp
  8001fe:	68 18 3b 80 00       	push   $0x803b18
  800203:	e8 45 05 00 00       	call   80074d <cprintf>
  800208:	83 c4 10             	add    $0x10,%esp


	cprintf("STEP B: checking reading & writing... \n");
  80020b:	83 ec 0c             	sub    $0xc,%esp
  80020e:	68 40 3b 80 00       	push   $0x803b40
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
  800291:	68 68 3b 80 00       	push   $0x803b68
  800296:	6a 3e                	push   $0x3e
  800298:	68 3c 39 80 00       	push   $0x80393c
  80029d:	e8 f7 01 00 00       	call   800499 <_panic>
		if( x[PAGE_SIZE/4 - 1] !=  -1)  	panic("Reading/Writing of shared object is failed");
  8002a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002a5:	05 fc 0f 00 00       	add    $0xffc,%eax
  8002aa:	8b 00                	mov    (%eax),%eax
  8002ac:	83 f8 ff             	cmp    $0xffffffff,%eax
  8002af:	74 14                	je     8002c5 <_main+0x28d>
  8002b1:	83 ec 04             	sub    $0x4,%esp
  8002b4:	68 68 3b 80 00       	push   $0x803b68
  8002b9:	6a 3f                	push   $0x3f
  8002bb:	68 3c 39 80 00       	push   $0x80393c
  8002c0:	e8 d4 01 00 00       	call   800499 <_panic>

		if( y[0] !=  -1)  					panic("Reading/Writing of shared object is failed");
  8002c5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8002c8:	8b 00                	mov    (%eax),%eax
  8002ca:	83 f8 ff             	cmp    $0xffffffff,%eax
  8002cd:	74 14                	je     8002e3 <_main+0x2ab>
  8002cf:	83 ec 04             	sub    $0x4,%esp
  8002d2:	68 68 3b 80 00       	push   $0x803b68
  8002d7:	6a 41                	push   $0x41
  8002d9:	68 3c 39 80 00       	push   $0x80393c
  8002de:	e8 b6 01 00 00       	call   800499 <_panic>
		if( y[PAGE_SIZE/4 - 1] !=  -1)  	panic("Reading/Writing of shared object is failed");
  8002e3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8002e6:	05 fc 0f 00 00       	add    $0xffc,%eax
  8002eb:	8b 00                	mov    (%eax),%eax
  8002ed:	83 f8 ff             	cmp    $0xffffffff,%eax
  8002f0:	74 14                	je     800306 <_main+0x2ce>
  8002f2:	83 ec 04             	sub    $0x4,%esp
  8002f5:	68 68 3b 80 00       	push   $0x803b68
  8002fa:	6a 42                	push   $0x42
  8002fc:	68 3c 39 80 00       	push   $0x80393c
  800301:	e8 93 01 00 00       	call   800499 <_panic>

		if( z[0] !=  -1)  					panic("Reading/Writing of shared object is failed");
  800306:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800309:	8b 00                	mov    (%eax),%eax
  80030b:	83 f8 ff             	cmp    $0xffffffff,%eax
  80030e:	74 14                	je     800324 <_main+0x2ec>
  800310:	83 ec 04             	sub    $0x4,%esp
  800313:	68 68 3b 80 00       	push   $0x803b68
  800318:	6a 44                	push   $0x44
  80031a:	68 3c 39 80 00       	push   $0x80393c
  80031f:	e8 75 01 00 00       	call   800499 <_panic>
		if( z[2*PAGE_SIZE/4 - 1] !=  -1)  	panic("Reading/Writing of shared object is failed");
  800324:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800327:	05 fc 1f 00 00       	add    $0x1ffc,%eax
  80032c:	8b 00                	mov    (%eax),%eax
  80032e:	83 f8 ff             	cmp    $0xffffffff,%eax
  800331:	74 14                	je     800347 <_main+0x30f>
  800333:	83 ec 04             	sub    $0x4,%esp
  800336:	68 68 3b 80 00       	push   $0x803b68
  80033b:	6a 45                	push   $0x45
  80033d:	68 3c 39 80 00       	push   $0x80393c
  800342:	e8 52 01 00 00       	call   800499 <_panic>
	}

	cprintf("Congratulations!! Test of Shared Variables [Create] [1] completed successfully!!\n\n\n");
  800347:	83 ec 0c             	sub    $0xc,%esp
  80034a:	68 94 3b 80 00       	push   $0x803b94
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
  800363:	e8 6a 1a 00 00       	call   801dd2 <sys_getenvindex>
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
  8003ce:	e8 0c 18 00 00       	call   801bdf <sys_disable_interrupt>
	cprintf("**************************************\n");
  8003d3:	83 ec 0c             	sub    $0xc,%esp
  8003d6:	68 00 3c 80 00       	push   $0x803c00
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
  8003fe:	68 28 3c 80 00       	push   $0x803c28
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
  80042f:	68 50 3c 80 00       	push   $0x803c50
  800434:	e8 14 03 00 00       	call   80074d <cprintf>
  800439:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80043c:	a1 20 50 80 00       	mov    0x805020,%eax
  800441:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800447:	83 ec 08             	sub    $0x8,%esp
  80044a:	50                   	push   %eax
  80044b:	68 a8 3c 80 00       	push   $0x803ca8
  800450:	e8 f8 02 00 00       	call   80074d <cprintf>
  800455:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800458:	83 ec 0c             	sub    $0xc,%esp
  80045b:	68 00 3c 80 00       	push   $0x803c00
  800460:	e8 e8 02 00 00       	call   80074d <cprintf>
  800465:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800468:	e8 8c 17 00 00       	call   801bf9 <sys_enable_interrupt>

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
  800480:	e8 19 19 00 00       	call   801d9e <sys_destroy_env>
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
  800491:	e8 6e 19 00 00       	call   801e04 <sys_exit_env>
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
  8004ba:	68 bc 3c 80 00       	push   $0x803cbc
  8004bf:	e8 89 02 00 00       	call   80074d <cprintf>
  8004c4:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8004c7:	a1 00 50 80 00       	mov    0x805000,%eax
  8004cc:	ff 75 0c             	pushl  0xc(%ebp)
  8004cf:	ff 75 08             	pushl  0x8(%ebp)
  8004d2:	50                   	push   %eax
  8004d3:	68 c1 3c 80 00       	push   $0x803cc1
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
  8004f7:	68 dd 3c 80 00       	push   $0x803cdd
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
  800523:	68 e0 3c 80 00       	push   $0x803ce0
  800528:	6a 26                	push   $0x26
  80052a:	68 2c 3d 80 00       	push   $0x803d2c
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
  8005f5:	68 38 3d 80 00       	push   $0x803d38
  8005fa:	6a 3a                	push   $0x3a
  8005fc:	68 2c 3d 80 00       	push   $0x803d2c
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
  800665:	68 8c 3d 80 00       	push   $0x803d8c
  80066a:	6a 44                	push   $0x44
  80066c:	68 2c 3d 80 00       	push   $0x803d2c
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
  8006bf:	e8 6d 13 00 00       	call   801a31 <sys_cputs>
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
  800736:	e8 f6 12 00 00       	call   801a31 <sys_cputs>
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
  800780:	e8 5a 14 00 00       	call   801bdf <sys_disable_interrupt>
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
  8007a0:	e8 54 14 00 00       	call   801bf9 <sys_enable_interrupt>
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
  8007ea:	e8 c5 2e 00 00       	call   8036b4 <__udivdi3>
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
  80083a:	e8 85 2f 00 00       	call   8037c4 <__umoddi3>
  80083f:	83 c4 10             	add    $0x10,%esp
  800842:	05 f4 3f 80 00       	add    $0x803ff4,%eax
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
  800995:	8b 04 85 18 40 80 00 	mov    0x804018(,%eax,4),%eax
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
  800a76:	8b 34 9d 60 3e 80 00 	mov    0x803e60(,%ebx,4),%esi
  800a7d:	85 f6                	test   %esi,%esi
  800a7f:	75 19                	jne    800a9a <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800a81:	53                   	push   %ebx
  800a82:	68 05 40 80 00       	push   $0x804005
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
  800a9b:	68 0e 40 80 00       	push   $0x80400e
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
  800ac8:	be 11 40 80 00       	mov    $0x804011,%esi
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
  8014ee:	68 70 41 80 00       	push   $0x804170
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
  8015be:	e8 b2 05 00 00       	call   801b75 <sys_allocate_chunk>
  8015c3:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8015c6:	a1 20 51 80 00       	mov    0x805120,%eax
  8015cb:	83 ec 0c             	sub    $0xc,%esp
  8015ce:	50                   	push   %eax
  8015cf:	e8 27 0c 00 00       	call   8021fb <initialize_MemBlocksList>
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
  8015fc:	68 95 41 80 00       	push   $0x804195
  801601:	6a 33                	push   $0x33
  801603:	68 b3 41 80 00       	push   $0x8041b3
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
  80167b:	68 c0 41 80 00       	push   $0x8041c0
  801680:	6a 34                	push   $0x34
  801682:	68 b3 41 80 00       	push   $0x8041b3
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
  801713:	e8 2b 08 00 00       	call   801f43 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801718:	85 c0                	test   %eax,%eax
  80171a:	74 11                	je     80172d <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  80171c:	83 ec 0c             	sub    $0xc,%esp
  80171f:	ff 75 e8             	pushl  -0x18(%ebp)
  801722:	e8 96 0e 00 00       	call   8025bd <alloc_block_FF>
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
  801739:	e8 f2 0b 00 00       	call   802330 <insert_sorted_allocList>
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
  801753:	83 ec 18             	sub    $0x18,%esp
<<<<<<< HEAD
=======
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	struct MemBlock * free_block=find_block(&AllocMemBlocksList,(uint32)virtual_address);
  801756:	8b 45 08             	mov    0x8(%ebp),%eax
  801759:	83 ec 08             	sub    $0x8,%esp
  80175c:	50                   	push   %eax
  80175d:	68 40 50 80 00       	push   $0x805040
  801762:	e8 71 0b 00 00       	call   8022d8 <find_block>
  801767:	83 c4 10             	add    $0x10,%esp
  80176a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(free_block!=NULL)
  80176d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801771:	0f 84 a6 00 00 00    	je     80181d <free+0xcd>
	{
		sys_free_user_mem(free_block->sva,free_block->size);
  801777:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80177a:	8b 50 0c             	mov    0xc(%eax),%edx
  80177d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801780:	8b 40 08             	mov    0x8(%eax),%eax
  801783:	83 ec 08             	sub    $0x8,%esp
  801786:	52                   	push   %edx
  801787:	50                   	push   %eax
  801788:	e8 b0 03 00 00       	call   801b3d <sys_free_user_mem>
  80178d:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,free_block);
  801790:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801794:	75 14                	jne    8017aa <free+0x5a>
  801796:	83 ec 04             	sub    $0x4,%esp
  801799:	68 95 41 80 00       	push   $0x804195
  80179e:	6a 74                	push   $0x74
  8017a0:	68 b3 41 80 00       	push   $0x8041b3
  8017a5:	e8 ef ec ff ff       	call   800499 <_panic>
  8017aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017ad:	8b 00                	mov    (%eax),%eax
  8017af:	85 c0                	test   %eax,%eax
  8017b1:	74 10                	je     8017c3 <free+0x73>
  8017b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017b6:	8b 00                	mov    (%eax),%eax
  8017b8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017bb:	8b 52 04             	mov    0x4(%edx),%edx
  8017be:	89 50 04             	mov    %edx,0x4(%eax)
  8017c1:	eb 0b                	jmp    8017ce <free+0x7e>
  8017c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017c6:	8b 40 04             	mov    0x4(%eax),%eax
  8017c9:	a3 44 50 80 00       	mov    %eax,0x805044
  8017ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017d1:	8b 40 04             	mov    0x4(%eax),%eax
  8017d4:	85 c0                	test   %eax,%eax
  8017d6:	74 0f                	je     8017e7 <free+0x97>
  8017d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017db:	8b 40 04             	mov    0x4(%eax),%eax
  8017de:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017e1:	8b 12                	mov    (%edx),%edx
  8017e3:	89 10                	mov    %edx,(%eax)
  8017e5:	eb 0a                	jmp    8017f1 <free+0xa1>
  8017e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017ea:	8b 00                	mov    (%eax),%eax
  8017ec:	a3 40 50 80 00       	mov    %eax,0x805040
  8017f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017f4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8017fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017fd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801804:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801809:	48                   	dec    %eax
  80180a:	a3 4c 50 80 00       	mov    %eax,0x80504c
		insert_sorted_with_merge_freeList(free_block);
  80180f:	83 ec 0c             	sub    $0xc,%esp
  801812:	ff 75 f4             	pushl  -0xc(%ebp)
  801815:	e8 4e 17 00 00       	call   802f68 <insert_sorted_with_merge_freeList>
  80181a:	83 c4 10             	add    $0x10,%esp
	}
>>>>>>> 6d683e8a06489828f6050ec354ed0ccdd03af7f9

	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
<<<<<<< HEAD

	struct MemBlock * free_block=find_block(&AllocMemBlocksList,(uint32)virtual_address);
  801756:	8b 45 08             	mov    0x8(%ebp),%eax
  801759:	83 ec 08             	sub    $0x8,%esp
  80175c:	50                   	push   %eax
  80175d:	68 40 50 80 00       	push   $0x805040
  801762:	e8 71 0b 00 00       	call   8022d8 <find_block>
  801767:	83 c4 10             	add    $0x10,%esp
  80176a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	    if(free_block!=NULL)
  80176d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801771:	0f 84 a6 00 00 00    	je     80181d <free+0xcd>
	    {
	    	sys_free_user_mem(free_block->sva,free_block->size);
  801777:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80177a:	8b 50 0c             	mov    0xc(%eax),%edx
  80177d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801780:	8b 40 08             	mov    0x8(%eax),%eax
  801783:	83 ec 08             	sub    $0x8,%esp
  801786:	52                   	push   %edx
  801787:	50                   	push   %eax
  801788:	e8 b0 03 00 00       	call   801b3d <sys_free_user_mem>
  80178d:	83 c4 10             	add    $0x10,%esp
	    	LIST_REMOVE(&AllocMemBlocksList,free_block);
  801790:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801794:	75 14                	jne    8017aa <free+0x5a>
  801796:	83 ec 04             	sub    $0x4,%esp
  801799:	68 95 41 80 00       	push   $0x804195
  80179e:	6a 7a                	push   $0x7a
  8017a0:	68 b3 41 80 00       	push   $0x8041b3
  8017a5:	e8 ef ec ff ff       	call   800499 <_panic>
  8017aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017ad:	8b 00                	mov    (%eax),%eax
  8017af:	85 c0                	test   %eax,%eax
  8017b1:	74 10                	je     8017c3 <free+0x73>
  8017b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017b6:	8b 00                	mov    (%eax),%eax
  8017b8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017bb:	8b 52 04             	mov    0x4(%edx),%edx
  8017be:	89 50 04             	mov    %edx,0x4(%eax)
  8017c1:	eb 0b                	jmp    8017ce <free+0x7e>
  8017c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017c6:	8b 40 04             	mov    0x4(%eax),%eax
  8017c9:	a3 44 50 80 00       	mov    %eax,0x805044
  8017ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017d1:	8b 40 04             	mov    0x4(%eax),%eax
  8017d4:	85 c0                	test   %eax,%eax
  8017d6:	74 0f                	je     8017e7 <free+0x97>
  8017d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017db:	8b 40 04             	mov    0x4(%eax),%eax
  8017de:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017e1:	8b 12                	mov    (%edx),%edx
  8017e3:	89 10                	mov    %edx,(%eax)
  8017e5:	eb 0a                	jmp    8017f1 <free+0xa1>
  8017e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017ea:	8b 00                	mov    (%eax),%eax
  8017ec:	a3 40 50 80 00       	mov    %eax,0x805040
  8017f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017f4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8017fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017fd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801804:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801809:	48                   	dec    %eax
  80180a:	a3 4c 50 80 00       	mov    %eax,0x80504c
	        insert_sorted_with_merge_freeList(free_block);
  80180f:	83 ec 0c             	sub    $0xc,%esp
  801812:	ff 75 f4             	pushl  -0xc(%ebp)
  801815:	e8 4e 17 00 00       	call   802f68 <insert_sorted_with_merge_freeList>
  80181a:	83 c4 10             	add    $0x10,%esp



	    }
=======
>>>>>>> 6d683e8a06489828f6050ec354ed0ccdd03af7f9
}
  80181d:	90                   	nop
  80181e:	c9                   	leave  
  80181f:	c3                   	ret    

00801820 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801820:	55                   	push   %ebp
  801821:	89 e5                	mov    %esp,%ebp
  801823:	83 ec 38             	sub    $0x38,%esp
  801826:	8b 45 10             	mov    0x10(%ebp),%eax
  801829:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80182c:	e8 a6 fc ff ff       	call   8014d7 <InitializeUHeap>
	if (size == 0) return NULL ;
  801831:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801835:	75 0a                	jne    801841 <smalloc+0x21>
  801837:	b8 00 00 00 00       	mov    $0x0,%eax
  80183c:	e9 8b 00 00 00       	jmp    8018cc <smalloc+0xac>
	//	   Else, return NULL

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801841:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801848:	8b 55 0c             	mov    0xc(%ebp),%edx
  80184b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80184e:	01 d0                	add    %edx,%eax
  801850:	48                   	dec    %eax
  801851:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801854:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801857:	ba 00 00 00 00       	mov    $0x0,%edx
  80185c:	f7 75 f0             	divl   -0x10(%ebp)
  80185f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801862:	29 d0                	sub    %edx,%eax
  801864:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801867:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  80186e:	e8 d0 06 00 00       	call   801f43 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801873:	85 c0                	test   %eax,%eax
  801875:	74 11                	je     801888 <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  801877:	83 ec 0c             	sub    $0xc,%esp
  80187a:	ff 75 e8             	pushl  -0x18(%ebp)
  80187d:	e8 3b 0d 00 00       	call   8025bd <alloc_block_FF>
  801882:	83 c4 10             	add    $0x10,%esp
  801885:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(mem_block != NULL)
  801888:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80188c:	74 39                	je     8018c7 <smalloc+0xa7>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  80188e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801891:	8b 40 08             	mov    0x8(%eax),%eax
  801894:	89 c2                	mov    %eax,%edx
  801896:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  80189a:	52                   	push   %edx
  80189b:	50                   	push   %eax
  80189c:	ff 75 0c             	pushl  0xc(%ebp)
  80189f:	ff 75 08             	pushl  0x8(%ebp)
  8018a2:	e8 21 04 00 00       	call   801cc8 <sys_createSharedObject>
  8018a7:	83 c4 10             	add    $0x10,%esp
  8018aa:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  8018ad:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  8018b1:	74 14                	je     8018c7 <smalloc+0xa7>
  8018b3:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  8018b7:	74 0e                	je     8018c7 <smalloc+0xa7>
  8018b9:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  8018bd:	74 08                	je     8018c7 <smalloc+0xa7>
			return (void*) mem_block->sva;
  8018bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018c2:	8b 40 08             	mov    0x8(%eax),%eax
  8018c5:	eb 05                	jmp    8018cc <smalloc+0xac>
	}
	return NULL;
  8018c7:	b8 00 00 00 00       	mov    $0x0,%eax

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8018cc:	c9                   	leave  
  8018cd:	c3                   	ret    

008018ce <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8018ce:	55                   	push   %ebp
  8018cf:	89 e5                	mov    %esp,%ebp
  8018d1:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8018d4:	e8 fe fb ff ff       	call   8014d7 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8018d9:	83 ec 08             	sub    $0x8,%esp
  8018dc:	ff 75 0c             	pushl  0xc(%ebp)
  8018df:	ff 75 08             	pushl  0x8(%ebp)
  8018e2:	e8 0b 04 00 00       	call   801cf2 <sys_getSizeOfSharedObject>
  8018e7:	83 c4 10             	add    $0x10,%esp
  8018ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size != E_SHARED_MEM_NOT_EXISTS)
  8018ed:	83 7d f0 f0          	cmpl   $0xfffffff0,-0x10(%ebp)
  8018f1:	74 76                	je     801969 <sget+0x9b>
	{
		uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  8018f3:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8018fa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8018fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801900:	01 d0                	add    %edx,%eax
  801902:	48                   	dec    %eax
  801903:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801906:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801909:	ba 00 00 00 00       	mov    $0x0,%edx
  80190e:	f7 75 ec             	divl   -0x14(%ebp)
  801911:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801914:	29 d0                	sub    %edx,%eax
  801916:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		struct MemBlock * mem_block = NULL;
  801919:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801920:	e8 1e 06 00 00       	call   801f43 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801925:	85 c0                	test   %eax,%eax
  801927:	74 11                	je     80193a <sget+0x6c>
			mem_block = alloc_block_FF(allocate_space);
  801929:	83 ec 0c             	sub    $0xc,%esp
  80192c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80192f:	e8 89 0c 00 00       	call   8025bd <alloc_block_FF>
  801934:	83 c4 10             	add    $0x10,%esp
  801937:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(mem_block != NULL)
  80193a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80193e:	74 29                	je     801969 <sget+0x9b>
		{
			uint32 shared_object_id = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)mem_block->sva);
  801940:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801943:	8b 40 08             	mov    0x8(%eax),%eax
  801946:	83 ec 04             	sub    $0x4,%esp
  801949:	50                   	push   %eax
  80194a:	ff 75 0c             	pushl  0xc(%ebp)
  80194d:	ff 75 08             	pushl  0x8(%ebp)
  801950:	e8 ba 03 00 00       	call   801d0f <sys_getSharedObject>
  801955:	83 c4 10             	add    $0x10,%esp
  801958:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (shared_object_id != E_SHARED_MEM_NOT_EXISTS)
  80195b:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%ebp)
  80195f:	74 08                	je     801969 <sget+0x9b>
				return (void *)mem_block->sva;
  801961:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801964:	8b 40 08             	mov    0x8(%eax),%eax
  801967:	eb 05                	jmp    80196e <sget+0xa0>
		}
	}
	return NULL;
  801969:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80196e:	c9                   	leave  
  80196f:	c3                   	ret    

00801970 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801970:	55                   	push   %ebp
  801971:	89 e5                	mov    %esp,%ebp
  801973:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801976:	e8 5c fb ff ff       	call   8014d7 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80197b:	83 ec 04             	sub    $0x4,%esp
  80197e:	68 e4 41 80 00       	push   $0x8041e4
<<<<<<< HEAD
  801983:	68 fc 00 00 00       	push   $0xfc
=======
  801983:	68 f7 00 00 00       	push   $0xf7
>>>>>>> 6d683e8a06489828f6050ec354ed0ccdd03af7f9
  801988:	68 b3 41 80 00       	push   $0x8041b3
  80198d:	e8 07 eb ff ff       	call   800499 <_panic>

00801992 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801992:	55                   	push   %ebp
  801993:	89 e5                	mov    %esp,%ebp
  801995:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()


	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801998:	83 ec 04             	sub    $0x4,%esp
  80199b:	68 0c 42 80 00       	push   $0x80420c
<<<<<<< HEAD
  8019a0:	68 10 01 00 00       	push   $0x110
=======
  8019a0:	68 0c 01 00 00       	push   $0x10c
>>>>>>> 6d683e8a06489828f6050ec354ed0ccdd03af7f9
  8019a5:	68 b3 41 80 00       	push   $0x8041b3
  8019aa:	e8 ea ea ff ff       	call   800499 <_panic>

008019af <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8019af:	55                   	push   %ebp
  8019b0:	89 e5                	mov    %esp,%ebp
  8019b2:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8019b5:	83 ec 04             	sub    $0x4,%esp
  8019b8:	68 30 42 80 00       	push   $0x804230
<<<<<<< HEAD
  8019bd:	68 1b 01 00 00       	push   $0x11b
=======
  8019bd:	68 44 01 00 00       	push   $0x144
>>>>>>> 6d683e8a06489828f6050ec354ed0ccdd03af7f9
  8019c2:	68 b3 41 80 00       	push   $0x8041b3
  8019c7:	e8 cd ea ff ff       	call   800499 <_panic>

008019cc <shrink>:

}
void shrink(uint32 newSize)
{
  8019cc:	55                   	push   %ebp
  8019cd:	89 e5                	mov    %esp,%ebp
  8019cf:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8019d2:	83 ec 04             	sub    $0x4,%esp
  8019d5:	68 30 42 80 00       	push   $0x804230
<<<<<<< HEAD
  8019da:	68 20 01 00 00       	push   $0x120
=======
  8019da:	68 49 01 00 00       	push   $0x149
>>>>>>> 6d683e8a06489828f6050ec354ed0ccdd03af7f9
  8019df:	68 b3 41 80 00       	push   $0x8041b3
  8019e4:	e8 b0 ea ff ff       	call   800499 <_panic>

008019e9 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8019e9:	55                   	push   %ebp
  8019ea:	89 e5                	mov    %esp,%ebp
  8019ec:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8019ef:	83 ec 04             	sub    $0x4,%esp
  8019f2:	68 30 42 80 00       	push   $0x804230
<<<<<<< HEAD
  8019f7:	68 25 01 00 00       	push   $0x125
=======
  8019f7:	68 4e 01 00 00       	push   $0x14e
>>>>>>> 6d683e8a06489828f6050ec354ed0ccdd03af7f9
  8019fc:	68 b3 41 80 00       	push   $0x8041b3
  801a01:	e8 93 ea ff ff       	call   800499 <_panic>

00801a06 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801a06:	55                   	push   %ebp
  801a07:	89 e5                	mov    %esp,%ebp
  801a09:	57                   	push   %edi
  801a0a:	56                   	push   %esi
  801a0b:	53                   	push   %ebx
  801a0c:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801a0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a12:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a15:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a18:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a1b:	8b 7d 18             	mov    0x18(%ebp),%edi
  801a1e:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801a21:	cd 30                	int    $0x30
  801a23:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801a26:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801a29:	83 c4 10             	add    $0x10,%esp
  801a2c:	5b                   	pop    %ebx
  801a2d:	5e                   	pop    %esi
  801a2e:	5f                   	pop    %edi
  801a2f:	5d                   	pop    %ebp
  801a30:	c3                   	ret    

00801a31 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801a31:	55                   	push   %ebp
  801a32:	89 e5                	mov    %esp,%ebp
  801a34:	83 ec 04             	sub    $0x4,%esp
  801a37:	8b 45 10             	mov    0x10(%ebp),%eax
  801a3a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801a3d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a41:	8b 45 08             	mov    0x8(%ebp),%eax
  801a44:	6a 00                	push   $0x0
  801a46:	6a 00                	push   $0x0
  801a48:	52                   	push   %edx
  801a49:	ff 75 0c             	pushl  0xc(%ebp)
  801a4c:	50                   	push   %eax
  801a4d:	6a 00                	push   $0x0
  801a4f:	e8 b2 ff ff ff       	call   801a06 <syscall>
  801a54:	83 c4 18             	add    $0x18,%esp
}
  801a57:	90                   	nop
  801a58:	c9                   	leave  
  801a59:	c3                   	ret    

00801a5a <sys_cgetc>:

int
sys_cgetc(void)
{
  801a5a:	55                   	push   %ebp
  801a5b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801a5d:	6a 00                	push   $0x0
  801a5f:	6a 00                	push   $0x0
  801a61:	6a 00                	push   $0x0
  801a63:	6a 00                	push   $0x0
  801a65:	6a 00                	push   $0x0
  801a67:	6a 01                	push   $0x1
  801a69:	e8 98 ff ff ff       	call   801a06 <syscall>
  801a6e:	83 c4 18             	add    $0x18,%esp
}
  801a71:	c9                   	leave  
  801a72:	c3                   	ret    

00801a73 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801a73:	55                   	push   %ebp
  801a74:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801a76:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a79:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7c:	6a 00                	push   $0x0
  801a7e:	6a 00                	push   $0x0
  801a80:	6a 00                	push   $0x0
  801a82:	52                   	push   %edx
  801a83:	50                   	push   %eax
  801a84:	6a 05                	push   $0x5
  801a86:	e8 7b ff ff ff       	call   801a06 <syscall>
  801a8b:	83 c4 18             	add    $0x18,%esp
}
  801a8e:	c9                   	leave  
  801a8f:	c3                   	ret    

00801a90 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801a90:	55                   	push   %ebp
  801a91:	89 e5                	mov    %esp,%ebp
  801a93:	56                   	push   %esi
  801a94:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801a95:	8b 75 18             	mov    0x18(%ebp),%esi
  801a98:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a9b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a9e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aa1:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa4:	56                   	push   %esi
  801aa5:	53                   	push   %ebx
  801aa6:	51                   	push   %ecx
  801aa7:	52                   	push   %edx
  801aa8:	50                   	push   %eax
  801aa9:	6a 06                	push   $0x6
  801aab:	e8 56 ff ff ff       	call   801a06 <syscall>
  801ab0:	83 c4 18             	add    $0x18,%esp
}
  801ab3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ab6:	5b                   	pop    %ebx
  801ab7:	5e                   	pop    %esi
  801ab8:	5d                   	pop    %ebp
  801ab9:	c3                   	ret    

00801aba <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801aba:	55                   	push   %ebp
  801abb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801abd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ac0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac3:	6a 00                	push   $0x0
  801ac5:	6a 00                	push   $0x0
  801ac7:	6a 00                	push   $0x0
  801ac9:	52                   	push   %edx
  801aca:	50                   	push   %eax
  801acb:	6a 07                	push   $0x7
  801acd:	e8 34 ff ff ff       	call   801a06 <syscall>
  801ad2:	83 c4 18             	add    $0x18,%esp
}
  801ad5:	c9                   	leave  
  801ad6:	c3                   	ret    

00801ad7 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801ad7:	55                   	push   %ebp
  801ad8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801ada:	6a 00                	push   $0x0
  801adc:	6a 00                	push   $0x0
  801ade:	6a 00                	push   $0x0
  801ae0:	ff 75 0c             	pushl  0xc(%ebp)
  801ae3:	ff 75 08             	pushl  0x8(%ebp)
  801ae6:	6a 08                	push   $0x8
  801ae8:	e8 19 ff ff ff       	call   801a06 <syscall>
  801aed:	83 c4 18             	add    $0x18,%esp
}
  801af0:	c9                   	leave  
  801af1:	c3                   	ret    

00801af2 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801af2:	55                   	push   %ebp
  801af3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801af5:	6a 00                	push   $0x0
  801af7:	6a 00                	push   $0x0
  801af9:	6a 00                	push   $0x0
  801afb:	6a 00                	push   $0x0
  801afd:	6a 00                	push   $0x0
  801aff:	6a 09                	push   $0x9
  801b01:	e8 00 ff ff ff       	call   801a06 <syscall>
  801b06:	83 c4 18             	add    $0x18,%esp
}
  801b09:	c9                   	leave  
  801b0a:	c3                   	ret    

00801b0b <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801b0b:	55                   	push   %ebp
  801b0c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801b0e:	6a 00                	push   $0x0
  801b10:	6a 00                	push   $0x0
  801b12:	6a 00                	push   $0x0
  801b14:	6a 00                	push   $0x0
  801b16:	6a 00                	push   $0x0
  801b18:	6a 0a                	push   $0xa
  801b1a:	e8 e7 fe ff ff       	call   801a06 <syscall>
  801b1f:	83 c4 18             	add    $0x18,%esp
}
  801b22:	c9                   	leave  
  801b23:	c3                   	ret    

00801b24 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801b24:	55                   	push   %ebp
  801b25:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801b27:	6a 00                	push   $0x0
  801b29:	6a 00                	push   $0x0
  801b2b:	6a 00                	push   $0x0
  801b2d:	6a 00                	push   $0x0
  801b2f:	6a 00                	push   $0x0
  801b31:	6a 0b                	push   $0xb
  801b33:	e8 ce fe ff ff       	call   801a06 <syscall>
  801b38:	83 c4 18             	add    $0x18,%esp
}
  801b3b:	c9                   	leave  
  801b3c:	c3                   	ret    

00801b3d <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801b3d:	55                   	push   %ebp
  801b3e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801b40:	6a 00                	push   $0x0
  801b42:	6a 00                	push   $0x0
  801b44:	6a 00                	push   $0x0
  801b46:	ff 75 0c             	pushl  0xc(%ebp)
  801b49:	ff 75 08             	pushl  0x8(%ebp)
  801b4c:	6a 0f                	push   $0xf
  801b4e:	e8 b3 fe ff ff       	call   801a06 <syscall>
  801b53:	83 c4 18             	add    $0x18,%esp
	return;
  801b56:	90                   	nop
}
  801b57:	c9                   	leave  
  801b58:	c3                   	ret    

00801b59 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801b59:	55                   	push   %ebp
  801b5a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801b5c:	6a 00                	push   $0x0
  801b5e:	6a 00                	push   $0x0
  801b60:	6a 00                	push   $0x0
  801b62:	ff 75 0c             	pushl  0xc(%ebp)
  801b65:	ff 75 08             	pushl  0x8(%ebp)
  801b68:	6a 10                	push   $0x10
  801b6a:	e8 97 fe ff ff       	call   801a06 <syscall>
  801b6f:	83 c4 18             	add    $0x18,%esp
	return ;
  801b72:	90                   	nop
}
  801b73:	c9                   	leave  
  801b74:	c3                   	ret    

00801b75 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801b75:	55                   	push   %ebp
  801b76:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801b78:	6a 00                	push   $0x0
  801b7a:	6a 00                	push   $0x0
  801b7c:	ff 75 10             	pushl  0x10(%ebp)
  801b7f:	ff 75 0c             	pushl  0xc(%ebp)
  801b82:	ff 75 08             	pushl  0x8(%ebp)
  801b85:	6a 11                	push   $0x11
  801b87:	e8 7a fe ff ff       	call   801a06 <syscall>
  801b8c:	83 c4 18             	add    $0x18,%esp
	return ;
  801b8f:	90                   	nop
}
  801b90:	c9                   	leave  
  801b91:	c3                   	ret    

00801b92 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801b92:	55                   	push   %ebp
  801b93:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801b95:	6a 00                	push   $0x0
  801b97:	6a 00                	push   $0x0
  801b99:	6a 00                	push   $0x0
  801b9b:	6a 00                	push   $0x0
  801b9d:	6a 00                	push   $0x0
  801b9f:	6a 0c                	push   $0xc
  801ba1:	e8 60 fe ff ff       	call   801a06 <syscall>
  801ba6:	83 c4 18             	add    $0x18,%esp
}
  801ba9:	c9                   	leave  
  801baa:	c3                   	ret    

00801bab <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801bab:	55                   	push   %ebp
  801bac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801bae:	6a 00                	push   $0x0
  801bb0:	6a 00                	push   $0x0
  801bb2:	6a 00                	push   $0x0
  801bb4:	6a 00                	push   $0x0
  801bb6:	ff 75 08             	pushl  0x8(%ebp)
  801bb9:	6a 0d                	push   $0xd
  801bbb:	e8 46 fe ff ff       	call   801a06 <syscall>
  801bc0:	83 c4 18             	add    $0x18,%esp
}
  801bc3:	c9                   	leave  
  801bc4:	c3                   	ret    

00801bc5 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801bc5:	55                   	push   %ebp
  801bc6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801bc8:	6a 00                	push   $0x0
  801bca:	6a 00                	push   $0x0
  801bcc:	6a 00                	push   $0x0
  801bce:	6a 00                	push   $0x0
  801bd0:	6a 00                	push   $0x0
  801bd2:	6a 0e                	push   $0xe
  801bd4:	e8 2d fe ff ff       	call   801a06 <syscall>
  801bd9:	83 c4 18             	add    $0x18,%esp
}
  801bdc:	90                   	nop
  801bdd:	c9                   	leave  
  801bde:	c3                   	ret    

00801bdf <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801bdf:	55                   	push   %ebp
  801be0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801be2:	6a 00                	push   $0x0
  801be4:	6a 00                	push   $0x0
  801be6:	6a 00                	push   $0x0
  801be8:	6a 00                	push   $0x0
  801bea:	6a 00                	push   $0x0
  801bec:	6a 13                	push   $0x13
  801bee:	e8 13 fe ff ff       	call   801a06 <syscall>
  801bf3:	83 c4 18             	add    $0x18,%esp
}
  801bf6:	90                   	nop
  801bf7:	c9                   	leave  
  801bf8:	c3                   	ret    

00801bf9 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801bf9:	55                   	push   %ebp
  801bfa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801bfc:	6a 00                	push   $0x0
  801bfe:	6a 00                	push   $0x0
  801c00:	6a 00                	push   $0x0
  801c02:	6a 00                	push   $0x0
  801c04:	6a 00                	push   $0x0
  801c06:	6a 14                	push   $0x14
  801c08:	e8 f9 fd ff ff       	call   801a06 <syscall>
  801c0d:	83 c4 18             	add    $0x18,%esp
}
  801c10:	90                   	nop
  801c11:	c9                   	leave  
  801c12:	c3                   	ret    

00801c13 <sys_cputc>:


void
sys_cputc(const char c)
{
  801c13:	55                   	push   %ebp
  801c14:	89 e5                	mov    %esp,%ebp
  801c16:	83 ec 04             	sub    $0x4,%esp
  801c19:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801c1f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c23:	6a 00                	push   $0x0
  801c25:	6a 00                	push   $0x0
  801c27:	6a 00                	push   $0x0
  801c29:	6a 00                	push   $0x0
  801c2b:	50                   	push   %eax
  801c2c:	6a 15                	push   $0x15
  801c2e:	e8 d3 fd ff ff       	call   801a06 <syscall>
  801c33:	83 c4 18             	add    $0x18,%esp
}
  801c36:	90                   	nop
  801c37:	c9                   	leave  
  801c38:	c3                   	ret    

00801c39 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801c39:	55                   	push   %ebp
  801c3a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801c3c:	6a 00                	push   $0x0
  801c3e:	6a 00                	push   $0x0
  801c40:	6a 00                	push   $0x0
  801c42:	6a 00                	push   $0x0
  801c44:	6a 00                	push   $0x0
  801c46:	6a 16                	push   $0x16
  801c48:	e8 b9 fd ff ff       	call   801a06 <syscall>
  801c4d:	83 c4 18             	add    $0x18,%esp
}
  801c50:	90                   	nop
  801c51:	c9                   	leave  
  801c52:	c3                   	ret    

00801c53 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801c53:	55                   	push   %ebp
  801c54:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801c56:	8b 45 08             	mov    0x8(%ebp),%eax
  801c59:	6a 00                	push   $0x0
  801c5b:	6a 00                	push   $0x0
  801c5d:	6a 00                	push   $0x0
  801c5f:	ff 75 0c             	pushl  0xc(%ebp)
  801c62:	50                   	push   %eax
  801c63:	6a 17                	push   $0x17
  801c65:	e8 9c fd ff ff       	call   801a06 <syscall>
  801c6a:	83 c4 18             	add    $0x18,%esp
}
  801c6d:	c9                   	leave  
  801c6e:	c3                   	ret    

00801c6f <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801c6f:	55                   	push   %ebp
  801c70:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801c72:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c75:	8b 45 08             	mov    0x8(%ebp),%eax
  801c78:	6a 00                	push   $0x0
  801c7a:	6a 00                	push   $0x0
  801c7c:	6a 00                	push   $0x0
  801c7e:	52                   	push   %edx
  801c7f:	50                   	push   %eax
  801c80:	6a 1a                	push   $0x1a
  801c82:	e8 7f fd ff ff       	call   801a06 <syscall>
  801c87:	83 c4 18             	add    $0x18,%esp
}
  801c8a:	c9                   	leave  
  801c8b:	c3                   	ret    

00801c8c <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801c8c:	55                   	push   %ebp
  801c8d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801c8f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c92:	8b 45 08             	mov    0x8(%ebp),%eax
  801c95:	6a 00                	push   $0x0
  801c97:	6a 00                	push   $0x0
  801c99:	6a 00                	push   $0x0
  801c9b:	52                   	push   %edx
  801c9c:	50                   	push   %eax
  801c9d:	6a 18                	push   $0x18
  801c9f:	e8 62 fd ff ff       	call   801a06 <syscall>
  801ca4:	83 c4 18             	add    $0x18,%esp
}
  801ca7:	90                   	nop
  801ca8:	c9                   	leave  
  801ca9:	c3                   	ret    

00801caa <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801caa:	55                   	push   %ebp
  801cab:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801cad:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cb0:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb3:	6a 00                	push   $0x0
  801cb5:	6a 00                	push   $0x0
  801cb7:	6a 00                	push   $0x0
  801cb9:	52                   	push   %edx
  801cba:	50                   	push   %eax
  801cbb:	6a 19                	push   $0x19
  801cbd:	e8 44 fd ff ff       	call   801a06 <syscall>
  801cc2:	83 c4 18             	add    $0x18,%esp
}
  801cc5:	90                   	nop
  801cc6:	c9                   	leave  
  801cc7:	c3                   	ret    

00801cc8 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801cc8:	55                   	push   %ebp
  801cc9:	89 e5                	mov    %esp,%ebp
  801ccb:	83 ec 04             	sub    $0x4,%esp
  801cce:	8b 45 10             	mov    0x10(%ebp),%eax
  801cd1:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801cd4:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801cd7:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801cdb:	8b 45 08             	mov    0x8(%ebp),%eax
  801cde:	6a 00                	push   $0x0
  801ce0:	51                   	push   %ecx
  801ce1:	52                   	push   %edx
  801ce2:	ff 75 0c             	pushl  0xc(%ebp)
  801ce5:	50                   	push   %eax
  801ce6:	6a 1b                	push   $0x1b
  801ce8:	e8 19 fd ff ff       	call   801a06 <syscall>
  801ced:	83 c4 18             	add    $0x18,%esp
}
  801cf0:	c9                   	leave  
  801cf1:	c3                   	ret    

00801cf2 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801cf2:	55                   	push   %ebp
  801cf3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801cf5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cf8:	8b 45 08             	mov    0x8(%ebp),%eax
  801cfb:	6a 00                	push   $0x0
  801cfd:	6a 00                	push   $0x0
  801cff:	6a 00                	push   $0x0
  801d01:	52                   	push   %edx
  801d02:	50                   	push   %eax
  801d03:	6a 1c                	push   $0x1c
  801d05:	e8 fc fc ff ff       	call   801a06 <syscall>
  801d0a:	83 c4 18             	add    $0x18,%esp
}
  801d0d:	c9                   	leave  
  801d0e:	c3                   	ret    

00801d0f <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801d0f:	55                   	push   %ebp
  801d10:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801d12:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d15:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d18:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1b:	6a 00                	push   $0x0
  801d1d:	6a 00                	push   $0x0
  801d1f:	51                   	push   %ecx
  801d20:	52                   	push   %edx
  801d21:	50                   	push   %eax
  801d22:	6a 1d                	push   $0x1d
  801d24:	e8 dd fc ff ff       	call   801a06 <syscall>
  801d29:	83 c4 18             	add    $0x18,%esp
}
  801d2c:	c9                   	leave  
  801d2d:	c3                   	ret    

00801d2e <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801d2e:	55                   	push   %ebp
  801d2f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801d31:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d34:	8b 45 08             	mov    0x8(%ebp),%eax
  801d37:	6a 00                	push   $0x0
  801d39:	6a 00                	push   $0x0
  801d3b:	6a 00                	push   $0x0
  801d3d:	52                   	push   %edx
  801d3e:	50                   	push   %eax
  801d3f:	6a 1e                	push   $0x1e
  801d41:	e8 c0 fc ff ff       	call   801a06 <syscall>
  801d46:	83 c4 18             	add    $0x18,%esp
}
  801d49:	c9                   	leave  
  801d4a:	c3                   	ret    

00801d4b <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801d4b:	55                   	push   %ebp
  801d4c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801d4e:	6a 00                	push   $0x0
  801d50:	6a 00                	push   $0x0
  801d52:	6a 00                	push   $0x0
  801d54:	6a 00                	push   $0x0
  801d56:	6a 00                	push   $0x0
  801d58:	6a 1f                	push   $0x1f
  801d5a:	e8 a7 fc ff ff       	call   801a06 <syscall>
  801d5f:	83 c4 18             	add    $0x18,%esp
}
  801d62:	c9                   	leave  
  801d63:	c3                   	ret    

00801d64 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801d64:	55                   	push   %ebp
  801d65:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801d67:	8b 45 08             	mov    0x8(%ebp),%eax
  801d6a:	6a 00                	push   $0x0
  801d6c:	ff 75 14             	pushl  0x14(%ebp)
  801d6f:	ff 75 10             	pushl  0x10(%ebp)
  801d72:	ff 75 0c             	pushl  0xc(%ebp)
  801d75:	50                   	push   %eax
  801d76:	6a 20                	push   $0x20
  801d78:	e8 89 fc ff ff       	call   801a06 <syscall>
  801d7d:	83 c4 18             	add    $0x18,%esp
}
  801d80:	c9                   	leave  
  801d81:	c3                   	ret    

00801d82 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801d82:	55                   	push   %ebp
  801d83:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801d85:	8b 45 08             	mov    0x8(%ebp),%eax
  801d88:	6a 00                	push   $0x0
  801d8a:	6a 00                	push   $0x0
  801d8c:	6a 00                	push   $0x0
  801d8e:	6a 00                	push   $0x0
  801d90:	50                   	push   %eax
  801d91:	6a 21                	push   $0x21
  801d93:	e8 6e fc ff ff       	call   801a06 <syscall>
  801d98:	83 c4 18             	add    $0x18,%esp
}
  801d9b:	90                   	nop
  801d9c:	c9                   	leave  
  801d9d:	c3                   	ret    

00801d9e <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801d9e:	55                   	push   %ebp
  801d9f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801da1:	8b 45 08             	mov    0x8(%ebp),%eax
  801da4:	6a 00                	push   $0x0
  801da6:	6a 00                	push   $0x0
  801da8:	6a 00                	push   $0x0
  801daa:	6a 00                	push   $0x0
  801dac:	50                   	push   %eax
  801dad:	6a 22                	push   $0x22
  801daf:	e8 52 fc ff ff       	call   801a06 <syscall>
  801db4:	83 c4 18             	add    $0x18,%esp
}
  801db7:	c9                   	leave  
  801db8:	c3                   	ret    

00801db9 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801db9:	55                   	push   %ebp
  801dba:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801dbc:	6a 00                	push   $0x0
  801dbe:	6a 00                	push   $0x0
  801dc0:	6a 00                	push   $0x0
  801dc2:	6a 00                	push   $0x0
  801dc4:	6a 00                	push   $0x0
  801dc6:	6a 02                	push   $0x2
  801dc8:	e8 39 fc ff ff       	call   801a06 <syscall>
  801dcd:	83 c4 18             	add    $0x18,%esp
}
  801dd0:	c9                   	leave  
  801dd1:	c3                   	ret    

00801dd2 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801dd2:	55                   	push   %ebp
  801dd3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801dd5:	6a 00                	push   $0x0
  801dd7:	6a 00                	push   $0x0
  801dd9:	6a 00                	push   $0x0
  801ddb:	6a 00                	push   $0x0
  801ddd:	6a 00                	push   $0x0
  801ddf:	6a 03                	push   $0x3
  801de1:	e8 20 fc ff ff       	call   801a06 <syscall>
  801de6:	83 c4 18             	add    $0x18,%esp
}
  801de9:	c9                   	leave  
  801dea:	c3                   	ret    

00801deb <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801deb:	55                   	push   %ebp
  801dec:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801dee:	6a 00                	push   $0x0
  801df0:	6a 00                	push   $0x0
  801df2:	6a 00                	push   $0x0
  801df4:	6a 00                	push   $0x0
  801df6:	6a 00                	push   $0x0
  801df8:	6a 04                	push   $0x4
  801dfa:	e8 07 fc ff ff       	call   801a06 <syscall>
  801dff:	83 c4 18             	add    $0x18,%esp
}
  801e02:	c9                   	leave  
  801e03:	c3                   	ret    

00801e04 <sys_exit_env>:


void sys_exit_env(void)
{
  801e04:	55                   	push   %ebp
  801e05:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801e07:	6a 00                	push   $0x0
  801e09:	6a 00                	push   $0x0
  801e0b:	6a 00                	push   $0x0
  801e0d:	6a 00                	push   $0x0
  801e0f:	6a 00                	push   $0x0
  801e11:	6a 23                	push   $0x23
  801e13:	e8 ee fb ff ff       	call   801a06 <syscall>
  801e18:	83 c4 18             	add    $0x18,%esp
}
  801e1b:	90                   	nop
  801e1c:	c9                   	leave  
  801e1d:	c3                   	ret    

00801e1e <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801e1e:	55                   	push   %ebp
  801e1f:	89 e5                	mov    %esp,%ebp
  801e21:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801e24:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e27:	8d 50 04             	lea    0x4(%eax),%edx
  801e2a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e2d:	6a 00                	push   $0x0
  801e2f:	6a 00                	push   $0x0
  801e31:	6a 00                	push   $0x0
  801e33:	52                   	push   %edx
  801e34:	50                   	push   %eax
  801e35:	6a 24                	push   $0x24
  801e37:	e8 ca fb ff ff       	call   801a06 <syscall>
  801e3c:	83 c4 18             	add    $0x18,%esp
	return result;
  801e3f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e42:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e45:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e48:	89 01                	mov    %eax,(%ecx)
  801e4a:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801e4d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e50:	c9                   	leave  
  801e51:	c2 04 00             	ret    $0x4

00801e54 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801e54:	55                   	push   %ebp
  801e55:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801e57:	6a 00                	push   $0x0
  801e59:	6a 00                	push   $0x0
  801e5b:	ff 75 10             	pushl  0x10(%ebp)
  801e5e:	ff 75 0c             	pushl  0xc(%ebp)
  801e61:	ff 75 08             	pushl  0x8(%ebp)
  801e64:	6a 12                	push   $0x12
  801e66:	e8 9b fb ff ff       	call   801a06 <syscall>
  801e6b:	83 c4 18             	add    $0x18,%esp
	return ;
  801e6e:	90                   	nop
}
  801e6f:	c9                   	leave  
  801e70:	c3                   	ret    

00801e71 <sys_rcr2>:
uint32 sys_rcr2()
{
  801e71:	55                   	push   %ebp
  801e72:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801e74:	6a 00                	push   $0x0
  801e76:	6a 00                	push   $0x0
  801e78:	6a 00                	push   $0x0
  801e7a:	6a 00                	push   $0x0
  801e7c:	6a 00                	push   $0x0
  801e7e:	6a 25                	push   $0x25
  801e80:	e8 81 fb ff ff       	call   801a06 <syscall>
  801e85:	83 c4 18             	add    $0x18,%esp
}
  801e88:	c9                   	leave  
  801e89:	c3                   	ret    

00801e8a <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801e8a:	55                   	push   %ebp
  801e8b:	89 e5                	mov    %esp,%ebp
  801e8d:	83 ec 04             	sub    $0x4,%esp
  801e90:	8b 45 08             	mov    0x8(%ebp),%eax
  801e93:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801e96:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801e9a:	6a 00                	push   $0x0
  801e9c:	6a 00                	push   $0x0
  801e9e:	6a 00                	push   $0x0
  801ea0:	6a 00                	push   $0x0
  801ea2:	50                   	push   %eax
  801ea3:	6a 26                	push   $0x26
  801ea5:	e8 5c fb ff ff       	call   801a06 <syscall>
  801eaa:	83 c4 18             	add    $0x18,%esp
	return ;
  801ead:	90                   	nop
}
  801eae:	c9                   	leave  
  801eaf:	c3                   	ret    

00801eb0 <rsttst>:
void rsttst()
{
  801eb0:	55                   	push   %ebp
  801eb1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801eb3:	6a 00                	push   $0x0
  801eb5:	6a 00                	push   $0x0
  801eb7:	6a 00                	push   $0x0
  801eb9:	6a 00                	push   $0x0
  801ebb:	6a 00                	push   $0x0
  801ebd:	6a 28                	push   $0x28
  801ebf:	e8 42 fb ff ff       	call   801a06 <syscall>
  801ec4:	83 c4 18             	add    $0x18,%esp
	return ;
  801ec7:	90                   	nop
}
  801ec8:	c9                   	leave  
  801ec9:	c3                   	ret    

00801eca <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801eca:	55                   	push   %ebp
  801ecb:	89 e5                	mov    %esp,%ebp
  801ecd:	83 ec 04             	sub    $0x4,%esp
  801ed0:	8b 45 14             	mov    0x14(%ebp),%eax
  801ed3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801ed6:	8b 55 18             	mov    0x18(%ebp),%edx
  801ed9:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801edd:	52                   	push   %edx
  801ede:	50                   	push   %eax
  801edf:	ff 75 10             	pushl  0x10(%ebp)
  801ee2:	ff 75 0c             	pushl  0xc(%ebp)
  801ee5:	ff 75 08             	pushl  0x8(%ebp)
  801ee8:	6a 27                	push   $0x27
  801eea:	e8 17 fb ff ff       	call   801a06 <syscall>
  801eef:	83 c4 18             	add    $0x18,%esp
	return ;
  801ef2:	90                   	nop
}
  801ef3:	c9                   	leave  
  801ef4:	c3                   	ret    

00801ef5 <chktst>:
void chktst(uint32 n)
{
  801ef5:	55                   	push   %ebp
  801ef6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801ef8:	6a 00                	push   $0x0
  801efa:	6a 00                	push   $0x0
  801efc:	6a 00                	push   $0x0
  801efe:	6a 00                	push   $0x0
  801f00:	ff 75 08             	pushl  0x8(%ebp)
  801f03:	6a 29                	push   $0x29
  801f05:	e8 fc fa ff ff       	call   801a06 <syscall>
  801f0a:	83 c4 18             	add    $0x18,%esp
	return ;
  801f0d:	90                   	nop
}
  801f0e:	c9                   	leave  
  801f0f:	c3                   	ret    

00801f10 <inctst>:

void inctst()
{
  801f10:	55                   	push   %ebp
  801f11:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801f13:	6a 00                	push   $0x0
  801f15:	6a 00                	push   $0x0
  801f17:	6a 00                	push   $0x0
  801f19:	6a 00                	push   $0x0
  801f1b:	6a 00                	push   $0x0
  801f1d:	6a 2a                	push   $0x2a
  801f1f:	e8 e2 fa ff ff       	call   801a06 <syscall>
  801f24:	83 c4 18             	add    $0x18,%esp
	return ;
  801f27:	90                   	nop
}
  801f28:	c9                   	leave  
  801f29:	c3                   	ret    

00801f2a <gettst>:
uint32 gettst()
{
  801f2a:	55                   	push   %ebp
  801f2b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801f2d:	6a 00                	push   $0x0
  801f2f:	6a 00                	push   $0x0
  801f31:	6a 00                	push   $0x0
  801f33:	6a 00                	push   $0x0
  801f35:	6a 00                	push   $0x0
  801f37:	6a 2b                	push   $0x2b
  801f39:	e8 c8 fa ff ff       	call   801a06 <syscall>
  801f3e:	83 c4 18             	add    $0x18,%esp
}
  801f41:	c9                   	leave  
  801f42:	c3                   	ret    

00801f43 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801f43:	55                   	push   %ebp
  801f44:	89 e5                	mov    %esp,%ebp
  801f46:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f49:	6a 00                	push   $0x0
  801f4b:	6a 00                	push   $0x0
  801f4d:	6a 00                	push   $0x0
  801f4f:	6a 00                	push   $0x0
  801f51:	6a 00                	push   $0x0
  801f53:	6a 2c                	push   $0x2c
  801f55:	e8 ac fa ff ff       	call   801a06 <syscall>
  801f5a:	83 c4 18             	add    $0x18,%esp
  801f5d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801f60:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801f64:	75 07                	jne    801f6d <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801f66:	b8 01 00 00 00       	mov    $0x1,%eax
  801f6b:	eb 05                	jmp    801f72 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801f6d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f72:	c9                   	leave  
  801f73:	c3                   	ret    

00801f74 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801f74:	55                   	push   %ebp
  801f75:	89 e5                	mov    %esp,%ebp
  801f77:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f7a:	6a 00                	push   $0x0
  801f7c:	6a 00                	push   $0x0
  801f7e:	6a 00                	push   $0x0
  801f80:	6a 00                	push   $0x0
  801f82:	6a 00                	push   $0x0
  801f84:	6a 2c                	push   $0x2c
  801f86:	e8 7b fa ff ff       	call   801a06 <syscall>
  801f8b:	83 c4 18             	add    $0x18,%esp
  801f8e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801f91:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801f95:	75 07                	jne    801f9e <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801f97:	b8 01 00 00 00       	mov    $0x1,%eax
  801f9c:	eb 05                	jmp    801fa3 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801f9e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fa3:	c9                   	leave  
  801fa4:	c3                   	ret    

00801fa5 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801fa5:	55                   	push   %ebp
  801fa6:	89 e5                	mov    %esp,%ebp
  801fa8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fab:	6a 00                	push   $0x0
  801fad:	6a 00                	push   $0x0
  801faf:	6a 00                	push   $0x0
  801fb1:	6a 00                	push   $0x0
  801fb3:	6a 00                	push   $0x0
  801fb5:	6a 2c                	push   $0x2c
  801fb7:	e8 4a fa ff ff       	call   801a06 <syscall>
  801fbc:	83 c4 18             	add    $0x18,%esp
  801fbf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801fc2:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801fc6:	75 07                	jne    801fcf <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801fc8:	b8 01 00 00 00       	mov    $0x1,%eax
  801fcd:	eb 05                	jmp    801fd4 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801fcf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fd4:	c9                   	leave  
  801fd5:	c3                   	ret    

00801fd6 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801fd6:	55                   	push   %ebp
  801fd7:	89 e5                	mov    %esp,%ebp
  801fd9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fdc:	6a 00                	push   $0x0
  801fde:	6a 00                	push   $0x0
  801fe0:	6a 00                	push   $0x0
  801fe2:	6a 00                	push   $0x0
  801fe4:	6a 00                	push   $0x0
  801fe6:	6a 2c                	push   $0x2c
  801fe8:	e8 19 fa ff ff       	call   801a06 <syscall>
  801fed:	83 c4 18             	add    $0x18,%esp
  801ff0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801ff3:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801ff7:	75 07                	jne    802000 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801ff9:	b8 01 00 00 00       	mov    $0x1,%eax
  801ffe:	eb 05                	jmp    802005 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802000:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802005:	c9                   	leave  
  802006:	c3                   	ret    

00802007 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802007:	55                   	push   %ebp
  802008:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80200a:	6a 00                	push   $0x0
  80200c:	6a 00                	push   $0x0
  80200e:	6a 00                	push   $0x0
  802010:	6a 00                	push   $0x0
  802012:	ff 75 08             	pushl  0x8(%ebp)
  802015:	6a 2d                	push   $0x2d
  802017:	e8 ea f9 ff ff       	call   801a06 <syscall>
  80201c:	83 c4 18             	add    $0x18,%esp
	return ;
  80201f:	90                   	nop
}
  802020:	c9                   	leave  
  802021:	c3                   	ret    

00802022 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802022:	55                   	push   %ebp
  802023:	89 e5                	mov    %esp,%ebp
  802025:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802026:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802029:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80202c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80202f:	8b 45 08             	mov    0x8(%ebp),%eax
  802032:	6a 00                	push   $0x0
  802034:	53                   	push   %ebx
  802035:	51                   	push   %ecx
  802036:	52                   	push   %edx
  802037:	50                   	push   %eax
  802038:	6a 2e                	push   $0x2e
  80203a:	e8 c7 f9 ff ff       	call   801a06 <syscall>
  80203f:	83 c4 18             	add    $0x18,%esp
}
  802042:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802045:	c9                   	leave  
  802046:	c3                   	ret    

00802047 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802047:	55                   	push   %ebp
  802048:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80204a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80204d:	8b 45 08             	mov    0x8(%ebp),%eax
  802050:	6a 00                	push   $0x0
  802052:	6a 00                	push   $0x0
  802054:	6a 00                	push   $0x0
  802056:	52                   	push   %edx
  802057:	50                   	push   %eax
  802058:	6a 2f                	push   $0x2f
  80205a:	e8 a7 f9 ff ff       	call   801a06 <syscall>
  80205f:	83 c4 18             	add    $0x18,%esp
}
  802062:	c9                   	leave  
  802063:	c3                   	ret    

00802064 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802064:	55                   	push   %ebp
  802065:	89 e5                	mov    %esp,%ebp
  802067:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  80206a:	83 ec 0c             	sub    $0xc,%esp
  80206d:	68 40 42 80 00       	push   $0x804240
  802072:	e8 d6 e6 ff ff       	call   80074d <cprintf>
  802077:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  80207a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802081:	83 ec 0c             	sub    $0xc,%esp
  802084:	68 6c 42 80 00       	push   $0x80426c
  802089:	e8 bf e6 ff ff       	call   80074d <cprintf>
  80208e:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802091:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802095:	a1 38 51 80 00       	mov    0x805138,%eax
  80209a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80209d:	eb 56                	jmp    8020f5 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80209f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8020a3:	74 1c                	je     8020c1 <print_mem_block_lists+0x5d>
  8020a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a8:	8b 50 08             	mov    0x8(%eax),%edx
  8020ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020ae:	8b 48 08             	mov    0x8(%eax),%ecx
  8020b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020b4:	8b 40 0c             	mov    0xc(%eax),%eax
  8020b7:	01 c8                	add    %ecx,%eax
  8020b9:	39 c2                	cmp    %eax,%edx
  8020bb:	73 04                	jae    8020c1 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8020bd:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8020c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c4:	8b 50 08             	mov    0x8(%eax),%edx
  8020c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ca:	8b 40 0c             	mov    0xc(%eax),%eax
  8020cd:	01 c2                	add    %eax,%edx
  8020cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020d2:	8b 40 08             	mov    0x8(%eax),%eax
  8020d5:	83 ec 04             	sub    $0x4,%esp
  8020d8:	52                   	push   %edx
  8020d9:	50                   	push   %eax
  8020da:	68 81 42 80 00       	push   $0x804281
  8020df:	e8 69 e6 ff ff       	call   80074d <cprintf>
  8020e4:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8020e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8020ed:	a1 40 51 80 00       	mov    0x805140,%eax
  8020f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020f5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020f9:	74 07                	je     802102 <print_mem_block_lists+0x9e>
  8020fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020fe:	8b 00                	mov    (%eax),%eax
  802100:	eb 05                	jmp    802107 <print_mem_block_lists+0xa3>
  802102:	b8 00 00 00 00       	mov    $0x0,%eax
  802107:	a3 40 51 80 00       	mov    %eax,0x805140
  80210c:	a1 40 51 80 00       	mov    0x805140,%eax
  802111:	85 c0                	test   %eax,%eax
  802113:	75 8a                	jne    80209f <print_mem_block_lists+0x3b>
  802115:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802119:	75 84                	jne    80209f <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  80211b:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80211f:	75 10                	jne    802131 <print_mem_block_lists+0xcd>
  802121:	83 ec 0c             	sub    $0xc,%esp
  802124:	68 90 42 80 00       	push   $0x804290
  802129:	e8 1f e6 ff ff       	call   80074d <cprintf>
  80212e:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802131:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802138:	83 ec 0c             	sub    $0xc,%esp
  80213b:	68 b4 42 80 00       	push   $0x8042b4
  802140:	e8 08 e6 ff ff       	call   80074d <cprintf>
  802145:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802148:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80214c:	a1 40 50 80 00       	mov    0x805040,%eax
  802151:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802154:	eb 56                	jmp    8021ac <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802156:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80215a:	74 1c                	je     802178 <print_mem_block_lists+0x114>
  80215c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80215f:	8b 50 08             	mov    0x8(%eax),%edx
  802162:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802165:	8b 48 08             	mov    0x8(%eax),%ecx
  802168:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80216b:	8b 40 0c             	mov    0xc(%eax),%eax
  80216e:	01 c8                	add    %ecx,%eax
  802170:	39 c2                	cmp    %eax,%edx
  802172:	73 04                	jae    802178 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802174:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802178:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80217b:	8b 50 08             	mov    0x8(%eax),%edx
  80217e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802181:	8b 40 0c             	mov    0xc(%eax),%eax
  802184:	01 c2                	add    %eax,%edx
  802186:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802189:	8b 40 08             	mov    0x8(%eax),%eax
  80218c:	83 ec 04             	sub    $0x4,%esp
  80218f:	52                   	push   %edx
  802190:	50                   	push   %eax
  802191:	68 81 42 80 00       	push   $0x804281
  802196:	e8 b2 e5 ff ff       	call   80074d <cprintf>
  80219b:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80219e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8021a4:	a1 48 50 80 00       	mov    0x805048,%eax
  8021a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021ac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021b0:	74 07                	je     8021b9 <print_mem_block_lists+0x155>
  8021b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b5:	8b 00                	mov    (%eax),%eax
  8021b7:	eb 05                	jmp    8021be <print_mem_block_lists+0x15a>
  8021b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8021be:	a3 48 50 80 00       	mov    %eax,0x805048
  8021c3:	a1 48 50 80 00       	mov    0x805048,%eax
  8021c8:	85 c0                	test   %eax,%eax
  8021ca:	75 8a                	jne    802156 <print_mem_block_lists+0xf2>
  8021cc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021d0:	75 84                	jne    802156 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8021d2:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8021d6:	75 10                	jne    8021e8 <print_mem_block_lists+0x184>
  8021d8:	83 ec 0c             	sub    $0xc,%esp
  8021db:	68 cc 42 80 00       	push   $0x8042cc
  8021e0:	e8 68 e5 ff ff       	call   80074d <cprintf>
  8021e5:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8021e8:	83 ec 0c             	sub    $0xc,%esp
  8021eb:	68 40 42 80 00       	push   $0x804240
  8021f0:	e8 58 e5 ff ff       	call   80074d <cprintf>
  8021f5:	83 c4 10             	add    $0x10,%esp

}
  8021f8:	90                   	nop
  8021f9:	c9                   	leave  
  8021fa:	c3                   	ret    

008021fb <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8021fb:	55                   	push   %ebp
  8021fc:	89 e5                	mov    %esp,%ebp
  8021fe:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  802201:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802208:	00 00 00 
  80220b:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802212:	00 00 00 
  802215:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  80221c:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  80221f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802226:	e9 9e 00 00 00       	jmp    8022c9 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  80222b:	a1 50 50 80 00       	mov    0x805050,%eax
  802230:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802233:	c1 e2 04             	shl    $0x4,%edx
  802236:	01 d0                	add    %edx,%eax
  802238:	85 c0                	test   %eax,%eax
  80223a:	75 14                	jne    802250 <initialize_MemBlocksList+0x55>
  80223c:	83 ec 04             	sub    $0x4,%esp
  80223f:	68 f4 42 80 00       	push   $0x8042f4
  802244:	6a 46                	push   $0x46
  802246:	68 17 43 80 00       	push   $0x804317
  80224b:	e8 49 e2 ff ff       	call   800499 <_panic>
  802250:	a1 50 50 80 00       	mov    0x805050,%eax
  802255:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802258:	c1 e2 04             	shl    $0x4,%edx
  80225b:	01 d0                	add    %edx,%eax
  80225d:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802263:	89 10                	mov    %edx,(%eax)
  802265:	8b 00                	mov    (%eax),%eax
  802267:	85 c0                	test   %eax,%eax
  802269:	74 18                	je     802283 <initialize_MemBlocksList+0x88>
  80226b:	a1 48 51 80 00       	mov    0x805148,%eax
  802270:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802276:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802279:	c1 e1 04             	shl    $0x4,%ecx
  80227c:	01 ca                	add    %ecx,%edx
  80227e:	89 50 04             	mov    %edx,0x4(%eax)
  802281:	eb 12                	jmp    802295 <initialize_MemBlocksList+0x9a>
  802283:	a1 50 50 80 00       	mov    0x805050,%eax
  802288:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80228b:	c1 e2 04             	shl    $0x4,%edx
  80228e:	01 d0                	add    %edx,%eax
  802290:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802295:	a1 50 50 80 00       	mov    0x805050,%eax
  80229a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80229d:	c1 e2 04             	shl    $0x4,%edx
  8022a0:	01 d0                	add    %edx,%eax
  8022a2:	a3 48 51 80 00       	mov    %eax,0x805148
  8022a7:	a1 50 50 80 00       	mov    0x805050,%eax
  8022ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022af:	c1 e2 04             	shl    $0x4,%edx
  8022b2:	01 d0                	add    %edx,%eax
  8022b4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022bb:	a1 54 51 80 00       	mov    0x805154,%eax
  8022c0:	40                   	inc    %eax
  8022c1:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  8022c6:	ff 45 f4             	incl   -0xc(%ebp)
  8022c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022cc:	3b 45 08             	cmp    0x8(%ebp),%eax
  8022cf:	0f 82 56 ff ff ff    	jb     80222b <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  8022d5:	90                   	nop
  8022d6:	c9                   	leave  
  8022d7:	c3                   	ret    

008022d8 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8022d8:	55                   	push   %ebp
  8022d9:	89 e5                	mov    %esp,%ebp
  8022db:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8022de:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e1:	8b 00                	mov    (%eax),%eax
  8022e3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8022e6:	eb 19                	jmp    802301 <find_block+0x29>
	{
		if(va==point->sva)
  8022e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8022eb:	8b 40 08             	mov    0x8(%eax),%eax
  8022ee:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8022f1:	75 05                	jne    8022f8 <find_block+0x20>
		   return point;
  8022f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8022f6:	eb 36                	jmp    80232e <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8022f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fb:	8b 40 08             	mov    0x8(%eax),%eax
  8022fe:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802301:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802305:	74 07                	je     80230e <find_block+0x36>
  802307:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80230a:	8b 00                	mov    (%eax),%eax
  80230c:	eb 05                	jmp    802313 <find_block+0x3b>
  80230e:	b8 00 00 00 00       	mov    $0x0,%eax
  802313:	8b 55 08             	mov    0x8(%ebp),%edx
  802316:	89 42 08             	mov    %eax,0x8(%edx)
  802319:	8b 45 08             	mov    0x8(%ebp),%eax
  80231c:	8b 40 08             	mov    0x8(%eax),%eax
  80231f:	85 c0                	test   %eax,%eax
  802321:	75 c5                	jne    8022e8 <find_block+0x10>
  802323:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802327:	75 bf                	jne    8022e8 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802329:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80232e:	c9                   	leave  
  80232f:	c3                   	ret    

00802330 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802330:	55                   	push   %ebp
  802331:	89 e5                	mov    %esp,%ebp
  802333:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  802336:	a1 40 50 80 00       	mov    0x805040,%eax
  80233b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  80233e:	a1 44 50 80 00       	mov    0x805044,%eax
  802343:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  802346:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802349:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80234c:	74 24                	je     802372 <insert_sorted_allocList+0x42>
  80234e:	8b 45 08             	mov    0x8(%ebp),%eax
  802351:	8b 50 08             	mov    0x8(%eax),%edx
  802354:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802357:	8b 40 08             	mov    0x8(%eax),%eax
  80235a:	39 c2                	cmp    %eax,%edx
  80235c:	76 14                	jbe    802372 <insert_sorted_allocList+0x42>
  80235e:	8b 45 08             	mov    0x8(%ebp),%eax
  802361:	8b 50 08             	mov    0x8(%eax),%edx
  802364:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802367:	8b 40 08             	mov    0x8(%eax),%eax
  80236a:	39 c2                	cmp    %eax,%edx
  80236c:	0f 82 60 01 00 00    	jb     8024d2 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802372:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802376:	75 65                	jne    8023dd <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802378:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80237c:	75 14                	jne    802392 <insert_sorted_allocList+0x62>
  80237e:	83 ec 04             	sub    $0x4,%esp
  802381:	68 f4 42 80 00       	push   $0x8042f4
  802386:	6a 6b                	push   $0x6b
  802388:	68 17 43 80 00       	push   $0x804317
  80238d:	e8 07 e1 ff ff       	call   800499 <_panic>
  802392:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802398:	8b 45 08             	mov    0x8(%ebp),%eax
  80239b:	89 10                	mov    %edx,(%eax)
  80239d:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a0:	8b 00                	mov    (%eax),%eax
  8023a2:	85 c0                	test   %eax,%eax
  8023a4:	74 0d                	je     8023b3 <insert_sorted_allocList+0x83>
  8023a6:	a1 40 50 80 00       	mov    0x805040,%eax
  8023ab:	8b 55 08             	mov    0x8(%ebp),%edx
  8023ae:	89 50 04             	mov    %edx,0x4(%eax)
  8023b1:	eb 08                	jmp    8023bb <insert_sorted_allocList+0x8b>
  8023b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b6:	a3 44 50 80 00       	mov    %eax,0x805044
  8023bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8023be:	a3 40 50 80 00       	mov    %eax,0x805040
  8023c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023cd:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8023d2:	40                   	inc    %eax
  8023d3:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8023d8:	e9 dc 01 00 00       	jmp    8025b9 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  8023dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e0:	8b 50 08             	mov    0x8(%eax),%edx
  8023e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023e6:	8b 40 08             	mov    0x8(%eax),%eax
  8023e9:	39 c2                	cmp    %eax,%edx
  8023eb:	77 6c                	ja     802459 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  8023ed:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8023f1:	74 06                	je     8023f9 <insert_sorted_allocList+0xc9>
  8023f3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023f7:	75 14                	jne    80240d <insert_sorted_allocList+0xdd>
  8023f9:	83 ec 04             	sub    $0x4,%esp
  8023fc:	68 30 43 80 00       	push   $0x804330
  802401:	6a 6f                	push   $0x6f
  802403:	68 17 43 80 00       	push   $0x804317
  802408:	e8 8c e0 ff ff       	call   800499 <_panic>
  80240d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802410:	8b 50 04             	mov    0x4(%eax),%edx
  802413:	8b 45 08             	mov    0x8(%ebp),%eax
  802416:	89 50 04             	mov    %edx,0x4(%eax)
  802419:	8b 45 08             	mov    0x8(%ebp),%eax
  80241c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80241f:	89 10                	mov    %edx,(%eax)
  802421:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802424:	8b 40 04             	mov    0x4(%eax),%eax
  802427:	85 c0                	test   %eax,%eax
  802429:	74 0d                	je     802438 <insert_sorted_allocList+0x108>
  80242b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80242e:	8b 40 04             	mov    0x4(%eax),%eax
  802431:	8b 55 08             	mov    0x8(%ebp),%edx
  802434:	89 10                	mov    %edx,(%eax)
  802436:	eb 08                	jmp    802440 <insert_sorted_allocList+0x110>
  802438:	8b 45 08             	mov    0x8(%ebp),%eax
  80243b:	a3 40 50 80 00       	mov    %eax,0x805040
  802440:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802443:	8b 55 08             	mov    0x8(%ebp),%edx
  802446:	89 50 04             	mov    %edx,0x4(%eax)
  802449:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80244e:	40                   	inc    %eax
  80244f:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802454:	e9 60 01 00 00       	jmp    8025b9 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802459:	8b 45 08             	mov    0x8(%ebp),%eax
  80245c:	8b 50 08             	mov    0x8(%eax),%edx
  80245f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802462:	8b 40 08             	mov    0x8(%eax),%eax
  802465:	39 c2                	cmp    %eax,%edx
  802467:	0f 82 4c 01 00 00    	jb     8025b9 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  80246d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802471:	75 14                	jne    802487 <insert_sorted_allocList+0x157>
  802473:	83 ec 04             	sub    $0x4,%esp
  802476:	68 68 43 80 00       	push   $0x804368
  80247b:	6a 73                	push   $0x73
  80247d:	68 17 43 80 00       	push   $0x804317
  802482:	e8 12 e0 ff ff       	call   800499 <_panic>
  802487:	8b 15 44 50 80 00    	mov    0x805044,%edx
  80248d:	8b 45 08             	mov    0x8(%ebp),%eax
  802490:	89 50 04             	mov    %edx,0x4(%eax)
  802493:	8b 45 08             	mov    0x8(%ebp),%eax
  802496:	8b 40 04             	mov    0x4(%eax),%eax
  802499:	85 c0                	test   %eax,%eax
  80249b:	74 0c                	je     8024a9 <insert_sorted_allocList+0x179>
  80249d:	a1 44 50 80 00       	mov    0x805044,%eax
  8024a2:	8b 55 08             	mov    0x8(%ebp),%edx
  8024a5:	89 10                	mov    %edx,(%eax)
  8024a7:	eb 08                	jmp    8024b1 <insert_sorted_allocList+0x181>
  8024a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ac:	a3 40 50 80 00       	mov    %eax,0x805040
  8024b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b4:	a3 44 50 80 00       	mov    %eax,0x805044
  8024b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8024bc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024c2:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8024c7:	40                   	inc    %eax
  8024c8:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8024cd:	e9 e7 00 00 00       	jmp    8025b9 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  8024d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  8024d8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8024df:	a1 40 50 80 00       	mov    0x805040,%eax
  8024e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024e7:	e9 9d 00 00 00       	jmp    802589 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  8024ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ef:	8b 00                	mov    (%eax),%eax
  8024f1:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  8024f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f7:	8b 50 08             	mov    0x8(%eax),%edx
  8024fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024fd:	8b 40 08             	mov    0x8(%eax),%eax
  802500:	39 c2                	cmp    %eax,%edx
  802502:	76 7d                	jbe    802581 <insert_sorted_allocList+0x251>
  802504:	8b 45 08             	mov    0x8(%ebp),%eax
  802507:	8b 50 08             	mov    0x8(%eax),%edx
  80250a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80250d:	8b 40 08             	mov    0x8(%eax),%eax
  802510:	39 c2                	cmp    %eax,%edx
  802512:	73 6d                	jae    802581 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802514:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802518:	74 06                	je     802520 <insert_sorted_allocList+0x1f0>
  80251a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80251e:	75 14                	jne    802534 <insert_sorted_allocList+0x204>
  802520:	83 ec 04             	sub    $0x4,%esp
  802523:	68 8c 43 80 00       	push   $0x80438c
  802528:	6a 7f                	push   $0x7f
  80252a:	68 17 43 80 00       	push   $0x804317
  80252f:	e8 65 df ff ff       	call   800499 <_panic>
  802534:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802537:	8b 10                	mov    (%eax),%edx
  802539:	8b 45 08             	mov    0x8(%ebp),%eax
  80253c:	89 10                	mov    %edx,(%eax)
  80253e:	8b 45 08             	mov    0x8(%ebp),%eax
  802541:	8b 00                	mov    (%eax),%eax
  802543:	85 c0                	test   %eax,%eax
  802545:	74 0b                	je     802552 <insert_sorted_allocList+0x222>
  802547:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254a:	8b 00                	mov    (%eax),%eax
  80254c:	8b 55 08             	mov    0x8(%ebp),%edx
  80254f:	89 50 04             	mov    %edx,0x4(%eax)
  802552:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802555:	8b 55 08             	mov    0x8(%ebp),%edx
  802558:	89 10                	mov    %edx,(%eax)
  80255a:	8b 45 08             	mov    0x8(%ebp),%eax
  80255d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802560:	89 50 04             	mov    %edx,0x4(%eax)
  802563:	8b 45 08             	mov    0x8(%ebp),%eax
  802566:	8b 00                	mov    (%eax),%eax
  802568:	85 c0                	test   %eax,%eax
  80256a:	75 08                	jne    802574 <insert_sorted_allocList+0x244>
  80256c:	8b 45 08             	mov    0x8(%ebp),%eax
  80256f:	a3 44 50 80 00       	mov    %eax,0x805044
  802574:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802579:	40                   	inc    %eax
  80257a:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  80257f:	eb 39                	jmp    8025ba <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802581:	a1 48 50 80 00       	mov    0x805048,%eax
  802586:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802589:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80258d:	74 07                	je     802596 <insert_sorted_allocList+0x266>
  80258f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802592:	8b 00                	mov    (%eax),%eax
  802594:	eb 05                	jmp    80259b <insert_sorted_allocList+0x26b>
  802596:	b8 00 00 00 00       	mov    $0x0,%eax
  80259b:	a3 48 50 80 00       	mov    %eax,0x805048
  8025a0:	a1 48 50 80 00       	mov    0x805048,%eax
  8025a5:	85 c0                	test   %eax,%eax
  8025a7:	0f 85 3f ff ff ff    	jne    8024ec <insert_sorted_allocList+0x1bc>
  8025ad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025b1:	0f 85 35 ff ff ff    	jne    8024ec <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8025b7:	eb 01                	jmp    8025ba <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8025b9:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8025ba:	90                   	nop
  8025bb:	c9                   	leave  
  8025bc:	c3                   	ret    

008025bd <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8025bd:	55                   	push   %ebp
  8025be:	89 e5                	mov    %esp,%ebp
  8025c0:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8025c3:	a1 38 51 80 00       	mov    0x805138,%eax
  8025c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025cb:	e9 85 01 00 00       	jmp    802755 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  8025d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d3:	8b 40 0c             	mov    0xc(%eax),%eax
  8025d6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025d9:	0f 82 6e 01 00 00    	jb     80274d <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  8025df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e2:	8b 40 0c             	mov    0xc(%eax),%eax
  8025e5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025e8:	0f 85 8a 00 00 00    	jne    802678 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  8025ee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025f2:	75 17                	jne    80260b <alloc_block_FF+0x4e>
  8025f4:	83 ec 04             	sub    $0x4,%esp
  8025f7:	68 c0 43 80 00       	push   $0x8043c0
  8025fc:	68 93 00 00 00       	push   $0x93
  802601:	68 17 43 80 00       	push   $0x804317
  802606:	e8 8e de ff ff       	call   800499 <_panic>
  80260b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80260e:	8b 00                	mov    (%eax),%eax
  802610:	85 c0                	test   %eax,%eax
  802612:	74 10                	je     802624 <alloc_block_FF+0x67>
  802614:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802617:	8b 00                	mov    (%eax),%eax
  802619:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80261c:	8b 52 04             	mov    0x4(%edx),%edx
  80261f:	89 50 04             	mov    %edx,0x4(%eax)
  802622:	eb 0b                	jmp    80262f <alloc_block_FF+0x72>
  802624:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802627:	8b 40 04             	mov    0x4(%eax),%eax
  80262a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80262f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802632:	8b 40 04             	mov    0x4(%eax),%eax
  802635:	85 c0                	test   %eax,%eax
  802637:	74 0f                	je     802648 <alloc_block_FF+0x8b>
  802639:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263c:	8b 40 04             	mov    0x4(%eax),%eax
  80263f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802642:	8b 12                	mov    (%edx),%edx
  802644:	89 10                	mov    %edx,(%eax)
  802646:	eb 0a                	jmp    802652 <alloc_block_FF+0x95>
  802648:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264b:	8b 00                	mov    (%eax),%eax
  80264d:	a3 38 51 80 00       	mov    %eax,0x805138
  802652:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802655:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80265b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802665:	a1 44 51 80 00       	mov    0x805144,%eax
  80266a:	48                   	dec    %eax
  80266b:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802670:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802673:	e9 10 01 00 00       	jmp    802788 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802678:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267b:	8b 40 0c             	mov    0xc(%eax),%eax
  80267e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802681:	0f 86 c6 00 00 00    	jbe    80274d <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802687:	a1 48 51 80 00       	mov    0x805148,%eax
  80268c:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  80268f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802692:	8b 50 08             	mov    0x8(%eax),%edx
  802695:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802698:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  80269b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80269e:	8b 55 08             	mov    0x8(%ebp),%edx
  8026a1:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8026a4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8026a8:	75 17                	jne    8026c1 <alloc_block_FF+0x104>
  8026aa:	83 ec 04             	sub    $0x4,%esp
  8026ad:	68 c0 43 80 00       	push   $0x8043c0
  8026b2:	68 9b 00 00 00       	push   $0x9b
  8026b7:	68 17 43 80 00       	push   $0x804317
  8026bc:	e8 d8 dd ff ff       	call   800499 <_panic>
  8026c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026c4:	8b 00                	mov    (%eax),%eax
  8026c6:	85 c0                	test   %eax,%eax
  8026c8:	74 10                	je     8026da <alloc_block_FF+0x11d>
  8026ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026cd:	8b 00                	mov    (%eax),%eax
  8026cf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8026d2:	8b 52 04             	mov    0x4(%edx),%edx
  8026d5:	89 50 04             	mov    %edx,0x4(%eax)
  8026d8:	eb 0b                	jmp    8026e5 <alloc_block_FF+0x128>
  8026da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026dd:	8b 40 04             	mov    0x4(%eax),%eax
  8026e0:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8026e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026e8:	8b 40 04             	mov    0x4(%eax),%eax
  8026eb:	85 c0                	test   %eax,%eax
  8026ed:	74 0f                	je     8026fe <alloc_block_FF+0x141>
  8026ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026f2:	8b 40 04             	mov    0x4(%eax),%eax
  8026f5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8026f8:	8b 12                	mov    (%edx),%edx
  8026fa:	89 10                	mov    %edx,(%eax)
  8026fc:	eb 0a                	jmp    802708 <alloc_block_FF+0x14b>
  8026fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802701:	8b 00                	mov    (%eax),%eax
  802703:	a3 48 51 80 00       	mov    %eax,0x805148
  802708:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80270b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802711:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802714:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80271b:	a1 54 51 80 00       	mov    0x805154,%eax
  802720:	48                   	dec    %eax
  802721:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802726:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802729:	8b 50 08             	mov    0x8(%eax),%edx
  80272c:	8b 45 08             	mov    0x8(%ebp),%eax
  80272f:	01 c2                	add    %eax,%edx
  802731:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802734:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802737:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273a:	8b 40 0c             	mov    0xc(%eax),%eax
  80273d:	2b 45 08             	sub    0x8(%ebp),%eax
  802740:	89 c2                	mov    %eax,%edx
  802742:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802745:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802748:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80274b:	eb 3b                	jmp    802788 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  80274d:	a1 40 51 80 00       	mov    0x805140,%eax
  802752:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802755:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802759:	74 07                	je     802762 <alloc_block_FF+0x1a5>
  80275b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275e:	8b 00                	mov    (%eax),%eax
  802760:	eb 05                	jmp    802767 <alloc_block_FF+0x1aa>
  802762:	b8 00 00 00 00       	mov    $0x0,%eax
  802767:	a3 40 51 80 00       	mov    %eax,0x805140
  80276c:	a1 40 51 80 00       	mov    0x805140,%eax
  802771:	85 c0                	test   %eax,%eax
  802773:	0f 85 57 fe ff ff    	jne    8025d0 <alloc_block_FF+0x13>
  802779:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80277d:	0f 85 4d fe ff ff    	jne    8025d0 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802783:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802788:	c9                   	leave  
  802789:	c3                   	ret    

0080278a <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  80278a:	55                   	push   %ebp
  80278b:	89 e5                	mov    %esp,%ebp
  80278d:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802790:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802797:	a1 38 51 80 00       	mov    0x805138,%eax
  80279c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80279f:	e9 df 00 00 00       	jmp    802883 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  8027a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a7:	8b 40 0c             	mov    0xc(%eax),%eax
  8027aa:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027ad:	0f 82 c8 00 00 00    	jb     80287b <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  8027b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b6:	8b 40 0c             	mov    0xc(%eax),%eax
  8027b9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027bc:	0f 85 8a 00 00 00    	jne    80284c <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  8027c2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027c6:	75 17                	jne    8027df <alloc_block_BF+0x55>
  8027c8:	83 ec 04             	sub    $0x4,%esp
  8027cb:	68 c0 43 80 00       	push   $0x8043c0
  8027d0:	68 b7 00 00 00       	push   $0xb7
  8027d5:	68 17 43 80 00       	push   $0x804317
  8027da:	e8 ba dc ff ff       	call   800499 <_panic>
  8027df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e2:	8b 00                	mov    (%eax),%eax
  8027e4:	85 c0                	test   %eax,%eax
  8027e6:	74 10                	je     8027f8 <alloc_block_BF+0x6e>
  8027e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027eb:	8b 00                	mov    (%eax),%eax
  8027ed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027f0:	8b 52 04             	mov    0x4(%edx),%edx
  8027f3:	89 50 04             	mov    %edx,0x4(%eax)
  8027f6:	eb 0b                	jmp    802803 <alloc_block_BF+0x79>
  8027f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027fb:	8b 40 04             	mov    0x4(%eax),%eax
  8027fe:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802803:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802806:	8b 40 04             	mov    0x4(%eax),%eax
  802809:	85 c0                	test   %eax,%eax
  80280b:	74 0f                	je     80281c <alloc_block_BF+0x92>
  80280d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802810:	8b 40 04             	mov    0x4(%eax),%eax
  802813:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802816:	8b 12                	mov    (%edx),%edx
  802818:	89 10                	mov    %edx,(%eax)
  80281a:	eb 0a                	jmp    802826 <alloc_block_BF+0x9c>
  80281c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281f:	8b 00                	mov    (%eax),%eax
  802821:	a3 38 51 80 00       	mov    %eax,0x805138
  802826:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802829:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80282f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802832:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802839:	a1 44 51 80 00       	mov    0x805144,%eax
  80283e:	48                   	dec    %eax
  80283f:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802844:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802847:	e9 4d 01 00 00       	jmp    802999 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  80284c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284f:	8b 40 0c             	mov    0xc(%eax),%eax
  802852:	3b 45 08             	cmp    0x8(%ebp),%eax
  802855:	76 24                	jbe    80287b <alloc_block_BF+0xf1>
  802857:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285a:	8b 40 0c             	mov    0xc(%eax),%eax
  80285d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802860:	73 19                	jae    80287b <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802862:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802869:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286c:	8b 40 0c             	mov    0xc(%eax),%eax
  80286f:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802872:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802875:	8b 40 08             	mov    0x8(%eax),%eax
  802878:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  80287b:	a1 40 51 80 00       	mov    0x805140,%eax
  802880:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802883:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802887:	74 07                	je     802890 <alloc_block_BF+0x106>
  802889:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288c:	8b 00                	mov    (%eax),%eax
  80288e:	eb 05                	jmp    802895 <alloc_block_BF+0x10b>
  802890:	b8 00 00 00 00       	mov    $0x0,%eax
  802895:	a3 40 51 80 00       	mov    %eax,0x805140
  80289a:	a1 40 51 80 00       	mov    0x805140,%eax
  80289f:	85 c0                	test   %eax,%eax
  8028a1:	0f 85 fd fe ff ff    	jne    8027a4 <alloc_block_BF+0x1a>
  8028a7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028ab:	0f 85 f3 fe ff ff    	jne    8027a4 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  8028b1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8028b5:	0f 84 d9 00 00 00    	je     802994 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  8028bb:	a1 48 51 80 00       	mov    0x805148,%eax
  8028c0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  8028c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028c6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8028c9:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  8028cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028cf:	8b 55 08             	mov    0x8(%ebp),%edx
  8028d2:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  8028d5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8028d9:	75 17                	jne    8028f2 <alloc_block_BF+0x168>
  8028db:	83 ec 04             	sub    $0x4,%esp
  8028de:	68 c0 43 80 00       	push   $0x8043c0
  8028e3:	68 c7 00 00 00       	push   $0xc7
  8028e8:	68 17 43 80 00       	push   $0x804317
  8028ed:	e8 a7 db ff ff       	call   800499 <_panic>
  8028f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028f5:	8b 00                	mov    (%eax),%eax
  8028f7:	85 c0                	test   %eax,%eax
  8028f9:	74 10                	je     80290b <alloc_block_BF+0x181>
  8028fb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028fe:	8b 00                	mov    (%eax),%eax
  802900:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802903:	8b 52 04             	mov    0x4(%edx),%edx
  802906:	89 50 04             	mov    %edx,0x4(%eax)
  802909:	eb 0b                	jmp    802916 <alloc_block_BF+0x18c>
  80290b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80290e:	8b 40 04             	mov    0x4(%eax),%eax
  802911:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802916:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802919:	8b 40 04             	mov    0x4(%eax),%eax
  80291c:	85 c0                	test   %eax,%eax
  80291e:	74 0f                	je     80292f <alloc_block_BF+0x1a5>
  802920:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802923:	8b 40 04             	mov    0x4(%eax),%eax
  802926:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802929:	8b 12                	mov    (%edx),%edx
  80292b:	89 10                	mov    %edx,(%eax)
  80292d:	eb 0a                	jmp    802939 <alloc_block_BF+0x1af>
  80292f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802932:	8b 00                	mov    (%eax),%eax
  802934:	a3 48 51 80 00       	mov    %eax,0x805148
  802939:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80293c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802942:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802945:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80294c:	a1 54 51 80 00       	mov    0x805154,%eax
  802951:	48                   	dec    %eax
  802952:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802957:	83 ec 08             	sub    $0x8,%esp
  80295a:	ff 75 ec             	pushl  -0x14(%ebp)
  80295d:	68 38 51 80 00       	push   $0x805138
  802962:	e8 71 f9 ff ff       	call   8022d8 <find_block>
  802967:	83 c4 10             	add    $0x10,%esp
  80296a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  80296d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802970:	8b 50 08             	mov    0x8(%eax),%edx
  802973:	8b 45 08             	mov    0x8(%ebp),%eax
  802976:	01 c2                	add    %eax,%edx
  802978:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80297b:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  80297e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802981:	8b 40 0c             	mov    0xc(%eax),%eax
  802984:	2b 45 08             	sub    0x8(%ebp),%eax
  802987:	89 c2                	mov    %eax,%edx
  802989:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80298c:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  80298f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802992:	eb 05                	jmp    802999 <alloc_block_BF+0x20f>
	}
	return NULL;
  802994:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802999:	c9                   	leave  
  80299a:	c3                   	ret    

0080299b <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  80299b:	55                   	push   %ebp
  80299c:	89 e5                	mov    %esp,%ebp
  80299e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  8029a1:	a1 28 50 80 00       	mov    0x805028,%eax
  8029a6:	85 c0                	test   %eax,%eax
  8029a8:	0f 85 de 01 00 00    	jne    802b8c <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8029ae:	a1 38 51 80 00       	mov    0x805138,%eax
  8029b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029b6:	e9 9e 01 00 00       	jmp    802b59 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  8029bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029be:	8b 40 0c             	mov    0xc(%eax),%eax
  8029c1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029c4:	0f 82 87 01 00 00    	jb     802b51 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  8029ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029cd:	8b 40 0c             	mov    0xc(%eax),%eax
  8029d0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029d3:	0f 85 95 00 00 00    	jne    802a6e <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  8029d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029dd:	75 17                	jne    8029f6 <alloc_block_NF+0x5b>
  8029df:	83 ec 04             	sub    $0x4,%esp
  8029e2:	68 c0 43 80 00       	push   $0x8043c0
  8029e7:	68 e0 00 00 00       	push   $0xe0
  8029ec:	68 17 43 80 00       	push   $0x804317
  8029f1:	e8 a3 da ff ff       	call   800499 <_panic>
  8029f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f9:	8b 00                	mov    (%eax),%eax
  8029fb:	85 c0                	test   %eax,%eax
  8029fd:	74 10                	je     802a0f <alloc_block_NF+0x74>
  8029ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a02:	8b 00                	mov    (%eax),%eax
  802a04:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a07:	8b 52 04             	mov    0x4(%edx),%edx
  802a0a:	89 50 04             	mov    %edx,0x4(%eax)
  802a0d:	eb 0b                	jmp    802a1a <alloc_block_NF+0x7f>
  802a0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a12:	8b 40 04             	mov    0x4(%eax),%eax
  802a15:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802a1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1d:	8b 40 04             	mov    0x4(%eax),%eax
  802a20:	85 c0                	test   %eax,%eax
  802a22:	74 0f                	je     802a33 <alloc_block_NF+0x98>
  802a24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a27:	8b 40 04             	mov    0x4(%eax),%eax
  802a2a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a2d:	8b 12                	mov    (%edx),%edx
  802a2f:	89 10                	mov    %edx,(%eax)
  802a31:	eb 0a                	jmp    802a3d <alloc_block_NF+0xa2>
  802a33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a36:	8b 00                	mov    (%eax),%eax
  802a38:	a3 38 51 80 00       	mov    %eax,0x805138
  802a3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a40:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a49:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a50:	a1 44 51 80 00       	mov    0x805144,%eax
  802a55:	48                   	dec    %eax
  802a56:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802a5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5e:	8b 40 08             	mov    0x8(%eax),%eax
  802a61:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  802a66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a69:	e9 f8 04 00 00       	jmp    802f66 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802a6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a71:	8b 40 0c             	mov    0xc(%eax),%eax
  802a74:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a77:	0f 86 d4 00 00 00    	jbe    802b51 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802a7d:	a1 48 51 80 00       	mov    0x805148,%eax
  802a82:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802a85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a88:	8b 50 08             	mov    0x8(%eax),%edx
  802a8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a8e:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802a91:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a94:	8b 55 08             	mov    0x8(%ebp),%edx
  802a97:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802a9a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a9e:	75 17                	jne    802ab7 <alloc_block_NF+0x11c>
  802aa0:	83 ec 04             	sub    $0x4,%esp
  802aa3:	68 c0 43 80 00       	push   $0x8043c0
  802aa8:	68 e9 00 00 00       	push   $0xe9
  802aad:	68 17 43 80 00       	push   $0x804317
  802ab2:	e8 e2 d9 ff ff       	call   800499 <_panic>
  802ab7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aba:	8b 00                	mov    (%eax),%eax
  802abc:	85 c0                	test   %eax,%eax
  802abe:	74 10                	je     802ad0 <alloc_block_NF+0x135>
  802ac0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ac3:	8b 00                	mov    (%eax),%eax
  802ac5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ac8:	8b 52 04             	mov    0x4(%edx),%edx
  802acb:	89 50 04             	mov    %edx,0x4(%eax)
  802ace:	eb 0b                	jmp    802adb <alloc_block_NF+0x140>
  802ad0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ad3:	8b 40 04             	mov    0x4(%eax),%eax
  802ad6:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802adb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ade:	8b 40 04             	mov    0x4(%eax),%eax
  802ae1:	85 c0                	test   %eax,%eax
  802ae3:	74 0f                	je     802af4 <alloc_block_NF+0x159>
  802ae5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ae8:	8b 40 04             	mov    0x4(%eax),%eax
  802aeb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802aee:	8b 12                	mov    (%edx),%edx
  802af0:	89 10                	mov    %edx,(%eax)
  802af2:	eb 0a                	jmp    802afe <alloc_block_NF+0x163>
  802af4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802af7:	8b 00                	mov    (%eax),%eax
  802af9:	a3 48 51 80 00       	mov    %eax,0x805148
  802afe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b01:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b0a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b11:	a1 54 51 80 00       	mov    0x805154,%eax
  802b16:	48                   	dec    %eax
  802b17:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802b1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b1f:	8b 40 08             	mov    0x8(%eax),%eax
  802b22:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802b27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b2a:	8b 50 08             	mov    0x8(%eax),%edx
  802b2d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b30:	01 c2                	add    %eax,%edx
  802b32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b35:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802b38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b3b:	8b 40 0c             	mov    0xc(%eax),%eax
  802b3e:	2b 45 08             	sub    0x8(%ebp),%eax
  802b41:	89 c2                	mov    %eax,%edx
  802b43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b46:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802b49:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b4c:	e9 15 04 00 00       	jmp    802f66 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802b51:	a1 40 51 80 00       	mov    0x805140,%eax
  802b56:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b59:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b5d:	74 07                	je     802b66 <alloc_block_NF+0x1cb>
  802b5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b62:	8b 00                	mov    (%eax),%eax
  802b64:	eb 05                	jmp    802b6b <alloc_block_NF+0x1d0>
  802b66:	b8 00 00 00 00       	mov    $0x0,%eax
  802b6b:	a3 40 51 80 00       	mov    %eax,0x805140
  802b70:	a1 40 51 80 00       	mov    0x805140,%eax
  802b75:	85 c0                	test   %eax,%eax
  802b77:	0f 85 3e fe ff ff    	jne    8029bb <alloc_block_NF+0x20>
  802b7d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b81:	0f 85 34 fe ff ff    	jne    8029bb <alloc_block_NF+0x20>
  802b87:	e9 d5 03 00 00       	jmp    802f61 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802b8c:	a1 38 51 80 00       	mov    0x805138,%eax
  802b91:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b94:	e9 b1 01 00 00       	jmp    802d4a <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802b99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9c:	8b 50 08             	mov    0x8(%eax),%edx
  802b9f:	a1 28 50 80 00       	mov    0x805028,%eax
  802ba4:	39 c2                	cmp    %eax,%edx
  802ba6:	0f 82 96 01 00 00    	jb     802d42 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802bac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802baf:	8b 40 0c             	mov    0xc(%eax),%eax
  802bb2:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bb5:	0f 82 87 01 00 00    	jb     802d42 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802bbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bbe:	8b 40 0c             	mov    0xc(%eax),%eax
  802bc1:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bc4:	0f 85 95 00 00 00    	jne    802c5f <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802bca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bce:	75 17                	jne    802be7 <alloc_block_NF+0x24c>
  802bd0:	83 ec 04             	sub    $0x4,%esp
  802bd3:	68 c0 43 80 00       	push   $0x8043c0
  802bd8:	68 fc 00 00 00       	push   $0xfc
  802bdd:	68 17 43 80 00       	push   $0x804317
  802be2:	e8 b2 d8 ff ff       	call   800499 <_panic>
  802be7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bea:	8b 00                	mov    (%eax),%eax
  802bec:	85 c0                	test   %eax,%eax
  802bee:	74 10                	je     802c00 <alloc_block_NF+0x265>
  802bf0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf3:	8b 00                	mov    (%eax),%eax
  802bf5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bf8:	8b 52 04             	mov    0x4(%edx),%edx
  802bfb:	89 50 04             	mov    %edx,0x4(%eax)
  802bfe:	eb 0b                	jmp    802c0b <alloc_block_NF+0x270>
  802c00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c03:	8b 40 04             	mov    0x4(%eax),%eax
  802c06:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0e:	8b 40 04             	mov    0x4(%eax),%eax
  802c11:	85 c0                	test   %eax,%eax
  802c13:	74 0f                	je     802c24 <alloc_block_NF+0x289>
  802c15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c18:	8b 40 04             	mov    0x4(%eax),%eax
  802c1b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c1e:	8b 12                	mov    (%edx),%edx
  802c20:	89 10                	mov    %edx,(%eax)
  802c22:	eb 0a                	jmp    802c2e <alloc_block_NF+0x293>
  802c24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c27:	8b 00                	mov    (%eax),%eax
  802c29:	a3 38 51 80 00       	mov    %eax,0x805138
  802c2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c31:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c3a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c41:	a1 44 51 80 00       	mov    0x805144,%eax
  802c46:	48                   	dec    %eax
  802c47:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802c4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4f:	8b 40 08             	mov    0x8(%eax),%eax
  802c52:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802c57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c5a:	e9 07 03 00 00       	jmp    802f66 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802c5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c62:	8b 40 0c             	mov    0xc(%eax),%eax
  802c65:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c68:	0f 86 d4 00 00 00    	jbe    802d42 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802c6e:	a1 48 51 80 00       	mov    0x805148,%eax
  802c73:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802c76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c79:	8b 50 08             	mov    0x8(%eax),%edx
  802c7c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c7f:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802c82:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c85:	8b 55 08             	mov    0x8(%ebp),%edx
  802c88:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802c8b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802c8f:	75 17                	jne    802ca8 <alloc_block_NF+0x30d>
  802c91:	83 ec 04             	sub    $0x4,%esp
  802c94:	68 c0 43 80 00       	push   $0x8043c0
  802c99:	68 04 01 00 00       	push   $0x104
  802c9e:	68 17 43 80 00       	push   $0x804317
  802ca3:	e8 f1 d7 ff ff       	call   800499 <_panic>
  802ca8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cab:	8b 00                	mov    (%eax),%eax
  802cad:	85 c0                	test   %eax,%eax
  802caf:	74 10                	je     802cc1 <alloc_block_NF+0x326>
  802cb1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cb4:	8b 00                	mov    (%eax),%eax
  802cb6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802cb9:	8b 52 04             	mov    0x4(%edx),%edx
  802cbc:	89 50 04             	mov    %edx,0x4(%eax)
  802cbf:	eb 0b                	jmp    802ccc <alloc_block_NF+0x331>
  802cc1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cc4:	8b 40 04             	mov    0x4(%eax),%eax
  802cc7:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ccc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ccf:	8b 40 04             	mov    0x4(%eax),%eax
  802cd2:	85 c0                	test   %eax,%eax
  802cd4:	74 0f                	je     802ce5 <alloc_block_NF+0x34a>
  802cd6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cd9:	8b 40 04             	mov    0x4(%eax),%eax
  802cdc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802cdf:	8b 12                	mov    (%edx),%edx
  802ce1:	89 10                	mov    %edx,(%eax)
  802ce3:	eb 0a                	jmp    802cef <alloc_block_NF+0x354>
  802ce5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ce8:	8b 00                	mov    (%eax),%eax
  802cea:	a3 48 51 80 00       	mov    %eax,0x805148
  802cef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cf2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cf8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cfb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d02:	a1 54 51 80 00       	mov    0x805154,%eax
  802d07:	48                   	dec    %eax
  802d08:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802d0d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d10:	8b 40 08             	mov    0x8(%eax),%eax
  802d13:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802d18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d1b:	8b 50 08             	mov    0x8(%eax),%edx
  802d1e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d21:	01 c2                	add    %eax,%edx
  802d23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d26:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802d29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d2c:	8b 40 0c             	mov    0xc(%eax),%eax
  802d2f:	2b 45 08             	sub    0x8(%ebp),%eax
  802d32:	89 c2                	mov    %eax,%edx
  802d34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d37:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802d3a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d3d:	e9 24 02 00 00       	jmp    802f66 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802d42:	a1 40 51 80 00       	mov    0x805140,%eax
  802d47:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d4a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d4e:	74 07                	je     802d57 <alloc_block_NF+0x3bc>
  802d50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d53:	8b 00                	mov    (%eax),%eax
  802d55:	eb 05                	jmp    802d5c <alloc_block_NF+0x3c1>
  802d57:	b8 00 00 00 00       	mov    $0x0,%eax
  802d5c:	a3 40 51 80 00       	mov    %eax,0x805140
  802d61:	a1 40 51 80 00       	mov    0x805140,%eax
  802d66:	85 c0                	test   %eax,%eax
  802d68:	0f 85 2b fe ff ff    	jne    802b99 <alloc_block_NF+0x1fe>
  802d6e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d72:	0f 85 21 fe ff ff    	jne    802b99 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802d78:	a1 38 51 80 00       	mov    0x805138,%eax
  802d7d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d80:	e9 ae 01 00 00       	jmp    802f33 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802d85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d88:	8b 50 08             	mov    0x8(%eax),%edx
  802d8b:	a1 28 50 80 00       	mov    0x805028,%eax
  802d90:	39 c2                	cmp    %eax,%edx
  802d92:	0f 83 93 01 00 00    	jae    802f2b <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802d98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d9b:	8b 40 0c             	mov    0xc(%eax),%eax
  802d9e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802da1:	0f 82 84 01 00 00    	jb     802f2b <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802da7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802daa:	8b 40 0c             	mov    0xc(%eax),%eax
  802dad:	3b 45 08             	cmp    0x8(%ebp),%eax
  802db0:	0f 85 95 00 00 00    	jne    802e4b <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802db6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dba:	75 17                	jne    802dd3 <alloc_block_NF+0x438>
  802dbc:	83 ec 04             	sub    $0x4,%esp
  802dbf:	68 c0 43 80 00       	push   $0x8043c0
  802dc4:	68 14 01 00 00       	push   $0x114
  802dc9:	68 17 43 80 00       	push   $0x804317
  802dce:	e8 c6 d6 ff ff       	call   800499 <_panic>
  802dd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd6:	8b 00                	mov    (%eax),%eax
  802dd8:	85 c0                	test   %eax,%eax
  802dda:	74 10                	je     802dec <alloc_block_NF+0x451>
  802ddc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ddf:	8b 00                	mov    (%eax),%eax
  802de1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802de4:	8b 52 04             	mov    0x4(%edx),%edx
  802de7:	89 50 04             	mov    %edx,0x4(%eax)
  802dea:	eb 0b                	jmp    802df7 <alloc_block_NF+0x45c>
  802dec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802def:	8b 40 04             	mov    0x4(%eax),%eax
  802df2:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802df7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dfa:	8b 40 04             	mov    0x4(%eax),%eax
  802dfd:	85 c0                	test   %eax,%eax
  802dff:	74 0f                	je     802e10 <alloc_block_NF+0x475>
  802e01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e04:	8b 40 04             	mov    0x4(%eax),%eax
  802e07:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e0a:	8b 12                	mov    (%edx),%edx
  802e0c:	89 10                	mov    %edx,(%eax)
  802e0e:	eb 0a                	jmp    802e1a <alloc_block_NF+0x47f>
  802e10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e13:	8b 00                	mov    (%eax),%eax
  802e15:	a3 38 51 80 00       	mov    %eax,0x805138
  802e1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e1d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e26:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e2d:	a1 44 51 80 00       	mov    0x805144,%eax
  802e32:	48                   	dec    %eax
  802e33:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802e38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e3b:	8b 40 08             	mov    0x8(%eax),%eax
  802e3e:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802e43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e46:	e9 1b 01 00 00       	jmp    802f66 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802e4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e4e:	8b 40 0c             	mov    0xc(%eax),%eax
  802e51:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e54:	0f 86 d1 00 00 00    	jbe    802f2b <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802e5a:	a1 48 51 80 00       	mov    0x805148,%eax
  802e5f:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802e62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e65:	8b 50 08             	mov    0x8(%eax),%edx
  802e68:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e6b:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802e6e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e71:	8b 55 08             	mov    0x8(%ebp),%edx
  802e74:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802e77:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802e7b:	75 17                	jne    802e94 <alloc_block_NF+0x4f9>
  802e7d:	83 ec 04             	sub    $0x4,%esp
  802e80:	68 c0 43 80 00       	push   $0x8043c0
  802e85:	68 1c 01 00 00       	push   $0x11c
  802e8a:	68 17 43 80 00       	push   $0x804317
  802e8f:	e8 05 d6 ff ff       	call   800499 <_panic>
  802e94:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e97:	8b 00                	mov    (%eax),%eax
  802e99:	85 c0                	test   %eax,%eax
  802e9b:	74 10                	je     802ead <alloc_block_NF+0x512>
  802e9d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ea0:	8b 00                	mov    (%eax),%eax
  802ea2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ea5:	8b 52 04             	mov    0x4(%edx),%edx
  802ea8:	89 50 04             	mov    %edx,0x4(%eax)
  802eab:	eb 0b                	jmp    802eb8 <alloc_block_NF+0x51d>
  802ead:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802eb0:	8b 40 04             	mov    0x4(%eax),%eax
  802eb3:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802eb8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ebb:	8b 40 04             	mov    0x4(%eax),%eax
  802ebe:	85 c0                	test   %eax,%eax
  802ec0:	74 0f                	je     802ed1 <alloc_block_NF+0x536>
  802ec2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ec5:	8b 40 04             	mov    0x4(%eax),%eax
  802ec8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ecb:	8b 12                	mov    (%edx),%edx
  802ecd:	89 10                	mov    %edx,(%eax)
  802ecf:	eb 0a                	jmp    802edb <alloc_block_NF+0x540>
  802ed1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ed4:	8b 00                	mov    (%eax),%eax
  802ed6:	a3 48 51 80 00       	mov    %eax,0x805148
  802edb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ede:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ee4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ee7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802eee:	a1 54 51 80 00       	mov    0x805154,%eax
  802ef3:	48                   	dec    %eax
  802ef4:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802ef9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802efc:	8b 40 08             	mov    0x8(%eax),%eax
  802eff:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802f04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f07:	8b 50 08             	mov    0x8(%eax),%edx
  802f0a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f0d:	01 c2                	add    %eax,%edx
  802f0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f12:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802f15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f18:	8b 40 0c             	mov    0xc(%eax),%eax
  802f1b:	2b 45 08             	sub    0x8(%ebp),%eax
  802f1e:	89 c2                	mov    %eax,%edx
  802f20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f23:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802f26:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f29:	eb 3b                	jmp    802f66 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802f2b:	a1 40 51 80 00       	mov    0x805140,%eax
  802f30:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f33:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f37:	74 07                	je     802f40 <alloc_block_NF+0x5a5>
  802f39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f3c:	8b 00                	mov    (%eax),%eax
  802f3e:	eb 05                	jmp    802f45 <alloc_block_NF+0x5aa>
  802f40:	b8 00 00 00 00       	mov    $0x0,%eax
  802f45:	a3 40 51 80 00       	mov    %eax,0x805140
  802f4a:	a1 40 51 80 00       	mov    0x805140,%eax
  802f4f:	85 c0                	test   %eax,%eax
  802f51:	0f 85 2e fe ff ff    	jne    802d85 <alloc_block_NF+0x3ea>
  802f57:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f5b:	0f 85 24 fe ff ff    	jne    802d85 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802f61:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f66:	c9                   	leave  
  802f67:	c3                   	ret    

00802f68 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802f68:	55                   	push   %ebp
  802f69:	89 e5                	mov    %esp,%ebp
  802f6b:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802f6e:	a1 38 51 80 00       	mov    0x805138,%eax
  802f73:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802f76:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802f7b:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802f7e:	a1 38 51 80 00       	mov    0x805138,%eax
  802f83:	85 c0                	test   %eax,%eax
  802f85:	74 14                	je     802f9b <insert_sorted_with_merge_freeList+0x33>
  802f87:	8b 45 08             	mov    0x8(%ebp),%eax
  802f8a:	8b 50 08             	mov    0x8(%eax),%edx
  802f8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f90:	8b 40 08             	mov    0x8(%eax),%eax
  802f93:	39 c2                	cmp    %eax,%edx
  802f95:	0f 87 9b 01 00 00    	ja     803136 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802f9b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f9f:	75 17                	jne    802fb8 <insert_sorted_with_merge_freeList+0x50>
  802fa1:	83 ec 04             	sub    $0x4,%esp
  802fa4:	68 f4 42 80 00       	push   $0x8042f4
  802fa9:	68 38 01 00 00       	push   $0x138
  802fae:	68 17 43 80 00       	push   $0x804317
  802fb3:	e8 e1 d4 ff ff       	call   800499 <_panic>
  802fb8:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802fbe:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc1:	89 10                	mov    %edx,(%eax)
  802fc3:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc6:	8b 00                	mov    (%eax),%eax
  802fc8:	85 c0                	test   %eax,%eax
  802fca:	74 0d                	je     802fd9 <insert_sorted_with_merge_freeList+0x71>
  802fcc:	a1 38 51 80 00       	mov    0x805138,%eax
  802fd1:	8b 55 08             	mov    0x8(%ebp),%edx
  802fd4:	89 50 04             	mov    %edx,0x4(%eax)
  802fd7:	eb 08                	jmp    802fe1 <insert_sorted_with_merge_freeList+0x79>
  802fd9:	8b 45 08             	mov    0x8(%ebp),%eax
  802fdc:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802fe1:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe4:	a3 38 51 80 00       	mov    %eax,0x805138
  802fe9:	8b 45 08             	mov    0x8(%ebp),%eax
  802fec:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ff3:	a1 44 51 80 00       	mov    0x805144,%eax
  802ff8:	40                   	inc    %eax
  802ff9:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802ffe:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803002:	0f 84 a8 06 00 00    	je     8036b0 <insert_sorted_with_merge_freeList+0x748>
  803008:	8b 45 08             	mov    0x8(%ebp),%eax
  80300b:	8b 50 08             	mov    0x8(%eax),%edx
  80300e:	8b 45 08             	mov    0x8(%ebp),%eax
  803011:	8b 40 0c             	mov    0xc(%eax),%eax
  803014:	01 c2                	add    %eax,%edx
  803016:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803019:	8b 40 08             	mov    0x8(%eax),%eax
  80301c:	39 c2                	cmp    %eax,%edx
  80301e:	0f 85 8c 06 00 00    	jne    8036b0 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  803024:	8b 45 08             	mov    0x8(%ebp),%eax
  803027:	8b 50 0c             	mov    0xc(%eax),%edx
  80302a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80302d:	8b 40 0c             	mov    0xc(%eax),%eax
  803030:	01 c2                	add    %eax,%edx
  803032:	8b 45 08             	mov    0x8(%ebp),%eax
  803035:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  803038:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80303c:	75 17                	jne    803055 <insert_sorted_with_merge_freeList+0xed>
  80303e:	83 ec 04             	sub    $0x4,%esp
  803041:	68 c0 43 80 00       	push   $0x8043c0
  803046:	68 3c 01 00 00       	push   $0x13c
  80304b:	68 17 43 80 00       	push   $0x804317
  803050:	e8 44 d4 ff ff       	call   800499 <_panic>
  803055:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803058:	8b 00                	mov    (%eax),%eax
  80305a:	85 c0                	test   %eax,%eax
  80305c:	74 10                	je     80306e <insert_sorted_with_merge_freeList+0x106>
  80305e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803061:	8b 00                	mov    (%eax),%eax
  803063:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803066:	8b 52 04             	mov    0x4(%edx),%edx
  803069:	89 50 04             	mov    %edx,0x4(%eax)
  80306c:	eb 0b                	jmp    803079 <insert_sorted_with_merge_freeList+0x111>
  80306e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803071:	8b 40 04             	mov    0x4(%eax),%eax
  803074:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803079:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80307c:	8b 40 04             	mov    0x4(%eax),%eax
  80307f:	85 c0                	test   %eax,%eax
  803081:	74 0f                	je     803092 <insert_sorted_with_merge_freeList+0x12a>
  803083:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803086:	8b 40 04             	mov    0x4(%eax),%eax
  803089:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80308c:	8b 12                	mov    (%edx),%edx
  80308e:	89 10                	mov    %edx,(%eax)
  803090:	eb 0a                	jmp    80309c <insert_sorted_with_merge_freeList+0x134>
  803092:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803095:	8b 00                	mov    (%eax),%eax
  803097:	a3 38 51 80 00       	mov    %eax,0x805138
  80309c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80309f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030a8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030af:	a1 44 51 80 00       	mov    0x805144,%eax
  8030b4:	48                   	dec    %eax
  8030b5:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  8030ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030bd:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  8030c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030c7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  8030ce:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8030d2:	75 17                	jne    8030eb <insert_sorted_with_merge_freeList+0x183>
  8030d4:	83 ec 04             	sub    $0x4,%esp
  8030d7:	68 f4 42 80 00       	push   $0x8042f4
  8030dc:	68 3f 01 00 00       	push   $0x13f
  8030e1:	68 17 43 80 00       	push   $0x804317
  8030e6:	e8 ae d3 ff ff       	call   800499 <_panic>
  8030eb:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8030f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030f4:	89 10                	mov    %edx,(%eax)
  8030f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030f9:	8b 00                	mov    (%eax),%eax
  8030fb:	85 c0                	test   %eax,%eax
  8030fd:	74 0d                	je     80310c <insert_sorted_with_merge_freeList+0x1a4>
  8030ff:	a1 48 51 80 00       	mov    0x805148,%eax
  803104:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803107:	89 50 04             	mov    %edx,0x4(%eax)
  80310a:	eb 08                	jmp    803114 <insert_sorted_with_merge_freeList+0x1ac>
  80310c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80310f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803114:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803117:	a3 48 51 80 00       	mov    %eax,0x805148
  80311c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80311f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803126:	a1 54 51 80 00       	mov    0x805154,%eax
  80312b:	40                   	inc    %eax
  80312c:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803131:	e9 7a 05 00 00       	jmp    8036b0 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  803136:	8b 45 08             	mov    0x8(%ebp),%eax
  803139:	8b 50 08             	mov    0x8(%eax),%edx
  80313c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80313f:	8b 40 08             	mov    0x8(%eax),%eax
  803142:	39 c2                	cmp    %eax,%edx
  803144:	0f 82 14 01 00 00    	jb     80325e <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  80314a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80314d:	8b 50 08             	mov    0x8(%eax),%edx
  803150:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803153:	8b 40 0c             	mov    0xc(%eax),%eax
  803156:	01 c2                	add    %eax,%edx
  803158:	8b 45 08             	mov    0x8(%ebp),%eax
  80315b:	8b 40 08             	mov    0x8(%eax),%eax
  80315e:	39 c2                	cmp    %eax,%edx
  803160:	0f 85 90 00 00 00    	jne    8031f6 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  803166:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803169:	8b 50 0c             	mov    0xc(%eax),%edx
  80316c:	8b 45 08             	mov    0x8(%ebp),%eax
  80316f:	8b 40 0c             	mov    0xc(%eax),%eax
  803172:	01 c2                	add    %eax,%edx
  803174:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803177:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  80317a:	8b 45 08             	mov    0x8(%ebp),%eax
  80317d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  803184:	8b 45 08             	mov    0x8(%ebp),%eax
  803187:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80318e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803192:	75 17                	jne    8031ab <insert_sorted_with_merge_freeList+0x243>
  803194:	83 ec 04             	sub    $0x4,%esp
  803197:	68 f4 42 80 00       	push   $0x8042f4
  80319c:	68 49 01 00 00       	push   $0x149
  8031a1:	68 17 43 80 00       	push   $0x804317
  8031a6:	e8 ee d2 ff ff       	call   800499 <_panic>
  8031ab:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8031b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b4:	89 10                	mov    %edx,(%eax)
  8031b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b9:	8b 00                	mov    (%eax),%eax
  8031bb:	85 c0                	test   %eax,%eax
  8031bd:	74 0d                	je     8031cc <insert_sorted_with_merge_freeList+0x264>
  8031bf:	a1 48 51 80 00       	mov    0x805148,%eax
  8031c4:	8b 55 08             	mov    0x8(%ebp),%edx
  8031c7:	89 50 04             	mov    %edx,0x4(%eax)
  8031ca:	eb 08                	jmp    8031d4 <insert_sorted_with_merge_freeList+0x26c>
  8031cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8031cf:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8031d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d7:	a3 48 51 80 00       	mov    %eax,0x805148
  8031dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8031df:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031e6:	a1 54 51 80 00       	mov    0x805154,%eax
  8031eb:	40                   	inc    %eax
  8031ec:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8031f1:	e9 bb 04 00 00       	jmp    8036b1 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  8031f6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031fa:	75 17                	jne    803213 <insert_sorted_with_merge_freeList+0x2ab>
  8031fc:	83 ec 04             	sub    $0x4,%esp
  8031ff:	68 68 43 80 00       	push   $0x804368
  803204:	68 4c 01 00 00       	push   $0x14c
  803209:	68 17 43 80 00       	push   $0x804317
  80320e:	e8 86 d2 ff ff       	call   800499 <_panic>
  803213:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803219:	8b 45 08             	mov    0x8(%ebp),%eax
  80321c:	89 50 04             	mov    %edx,0x4(%eax)
  80321f:	8b 45 08             	mov    0x8(%ebp),%eax
  803222:	8b 40 04             	mov    0x4(%eax),%eax
  803225:	85 c0                	test   %eax,%eax
  803227:	74 0c                	je     803235 <insert_sorted_with_merge_freeList+0x2cd>
  803229:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80322e:	8b 55 08             	mov    0x8(%ebp),%edx
  803231:	89 10                	mov    %edx,(%eax)
  803233:	eb 08                	jmp    80323d <insert_sorted_with_merge_freeList+0x2d5>
  803235:	8b 45 08             	mov    0x8(%ebp),%eax
  803238:	a3 38 51 80 00       	mov    %eax,0x805138
  80323d:	8b 45 08             	mov    0x8(%ebp),%eax
  803240:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803245:	8b 45 08             	mov    0x8(%ebp),%eax
  803248:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80324e:	a1 44 51 80 00       	mov    0x805144,%eax
  803253:	40                   	inc    %eax
  803254:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803259:	e9 53 04 00 00       	jmp    8036b1 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  80325e:	a1 38 51 80 00       	mov    0x805138,%eax
  803263:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803266:	e9 15 04 00 00       	jmp    803680 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  80326b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80326e:	8b 00                	mov    (%eax),%eax
  803270:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  803273:	8b 45 08             	mov    0x8(%ebp),%eax
  803276:	8b 50 08             	mov    0x8(%eax),%edx
  803279:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80327c:	8b 40 08             	mov    0x8(%eax),%eax
  80327f:	39 c2                	cmp    %eax,%edx
  803281:	0f 86 f1 03 00 00    	jbe    803678 <insert_sorted_with_merge_freeList+0x710>
  803287:	8b 45 08             	mov    0x8(%ebp),%eax
  80328a:	8b 50 08             	mov    0x8(%eax),%edx
  80328d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803290:	8b 40 08             	mov    0x8(%eax),%eax
  803293:	39 c2                	cmp    %eax,%edx
  803295:	0f 83 dd 03 00 00    	jae    803678 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  80329b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80329e:	8b 50 08             	mov    0x8(%eax),%edx
  8032a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032a4:	8b 40 0c             	mov    0xc(%eax),%eax
  8032a7:	01 c2                	add    %eax,%edx
  8032a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ac:	8b 40 08             	mov    0x8(%eax),%eax
  8032af:	39 c2                	cmp    %eax,%edx
  8032b1:	0f 85 b9 01 00 00    	jne    803470 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8032b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ba:	8b 50 08             	mov    0x8(%eax),%edx
  8032bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c0:	8b 40 0c             	mov    0xc(%eax),%eax
  8032c3:	01 c2                	add    %eax,%edx
  8032c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032c8:	8b 40 08             	mov    0x8(%eax),%eax
  8032cb:	39 c2                	cmp    %eax,%edx
  8032cd:	0f 85 0d 01 00 00    	jne    8033e0 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  8032d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032d6:	8b 50 0c             	mov    0xc(%eax),%edx
  8032d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032dc:	8b 40 0c             	mov    0xc(%eax),%eax
  8032df:	01 c2                	add    %eax,%edx
  8032e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032e4:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8032e7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8032eb:	75 17                	jne    803304 <insert_sorted_with_merge_freeList+0x39c>
  8032ed:	83 ec 04             	sub    $0x4,%esp
  8032f0:	68 c0 43 80 00       	push   $0x8043c0
  8032f5:	68 5c 01 00 00       	push   $0x15c
  8032fa:	68 17 43 80 00       	push   $0x804317
  8032ff:	e8 95 d1 ff ff       	call   800499 <_panic>
  803304:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803307:	8b 00                	mov    (%eax),%eax
  803309:	85 c0                	test   %eax,%eax
  80330b:	74 10                	je     80331d <insert_sorted_with_merge_freeList+0x3b5>
  80330d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803310:	8b 00                	mov    (%eax),%eax
  803312:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803315:	8b 52 04             	mov    0x4(%edx),%edx
  803318:	89 50 04             	mov    %edx,0x4(%eax)
  80331b:	eb 0b                	jmp    803328 <insert_sorted_with_merge_freeList+0x3c0>
  80331d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803320:	8b 40 04             	mov    0x4(%eax),%eax
  803323:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803328:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80332b:	8b 40 04             	mov    0x4(%eax),%eax
  80332e:	85 c0                	test   %eax,%eax
  803330:	74 0f                	je     803341 <insert_sorted_with_merge_freeList+0x3d9>
  803332:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803335:	8b 40 04             	mov    0x4(%eax),%eax
  803338:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80333b:	8b 12                	mov    (%edx),%edx
  80333d:	89 10                	mov    %edx,(%eax)
  80333f:	eb 0a                	jmp    80334b <insert_sorted_with_merge_freeList+0x3e3>
  803341:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803344:	8b 00                	mov    (%eax),%eax
  803346:	a3 38 51 80 00       	mov    %eax,0x805138
  80334b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80334e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803354:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803357:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80335e:	a1 44 51 80 00       	mov    0x805144,%eax
  803363:	48                   	dec    %eax
  803364:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  803369:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80336c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803373:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803376:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80337d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803381:	75 17                	jne    80339a <insert_sorted_with_merge_freeList+0x432>
  803383:	83 ec 04             	sub    $0x4,%esp
  803386:	68 f4 42 80 00       	push   $0x8042f4
  80338b:	68 5f 01 00 00       	push   $0x15f
  803390:	68 17 43 80 00       	push   $0x804317
  803395:	e8 ff d0 ff ff       	call   800499 <_panic>
  80339a:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8033a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033a3:	89 10                	mov    %edx,(%eax)
  8033a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033a8:	8b 00                	mov    (%eax),%eax
  8033aa:	85 c0                	test   %eax,%eax
  8033ac:	74 0d                	je     8033bb <insert_sorted_with_merge_freeList+0x453>
  8033ae:	a1 48 51 80 00       	mov    0x805148,%eax
  8033b3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8033b6:	89 50 04             	mov    %edx,0x4(%eax)
  8033b9:	eb 08                	jmp    8033c3 <insert_sorted_with_merge_freeList+0x45b>
  8033bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033be:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8033c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033c6:	a3 48 51 80 00       	mov    %eax,0x805148
  8033cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033ce:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033d5:	a1 54 51 80 00       	mov    0x805154,%eax
  8033da:	40                   	inc    %eax
  8033db:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  8033e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033e3:	8b 50 0c             	mov    0xc(%eax),%edx
  8033e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e9:	8b 40 0c             	mov    0xc(%eax),%eax
  8033ec:	01 c2                	add    %eax,%edx
  8033ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033f1:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  8033f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  8033fe:	8b 45 08             	mov    0x8(%ebp),%eax
  803401:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803408:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80340c:	75 17                	jne    803425 <insert_sorted_with_merge_freeList+0x4bd>
  80340e:	83 ec 04             	sub    $0x4,%esp
  803411:	68 f4 42 80 00       	push   $0x8042f4
  803416:	68 64 01 00 00       	push   $0x164
  80341b:	68 17 43 80 00       	push   $0x804317
  803420:	e8 74 d0 ff ff       	call   800499 <_panic>
  803425:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80342b:	8b 45 08             	mov    0x8(%ebp),%eax
  80342e:	89 10                	mov    %edx,(%eax)
  803430:	8b 45 08             	mov    0x8(%ebp),%eax
  803433:	8b 00                	mov    (%eax),%eax
  803435:	85 c0                	test   %eax,%eax
  803437:	74 0d                	je     803446 <insert_sorted_with_merge_freeList+0x4de>
  803439:	a1 48 51 80 00       	mov    0x805148,%eax
  80343e:	8b 55 08             	mov    0x8(%ebp),%edx
  803441:	89 50 04             	mov    %edx,0x4(%eax)
  803444:	eb 08                	jmp    80344e <insert_sorted_with_merge_freeList+0x4e6>
  803446:	8b 45 08             	mov    0x8(%ebp),%eax
  803449:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80344e:	8b 45 08             	mov    0x8(%ebp),%eax
  803451:	a3 48 51 80 00       	mov    %eax,0x805148
  803456:	8b 45 08             	mov    0x8(%ebp),%eax
  803459:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803460:	a1 54 51 80 00       	mov    0x805154,%eax
  803465:	40                   	inc    %eax
  803466:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  80346b:	e9 41 02 00 00       	jmp    8036b1 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803470:	8b 45 08             	mov    0x8(%ebp),%eax
  803473:	8b 50 08             	mov    0x8(%eax),%edx
  803476:	8b 45 08             	mov    0x8(%ebp),%eax
  803479:	8b 40 0c             	mov    0xc(%eax),%eax
  80347c:	01 c2                	add    %eax,%edx
  80347e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803481:	8b 40 08             	mov    0x8(%eax),%eax
  803484:	39 c2                	cmp    %eax,%edx
  803486:	0f 85 7c 01 00 00    	jne    803608 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  80348c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803490:	74 06                	je     803498 <insert_sorted_with_merge_freeList+0x530>
  803492:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803496:	75 17                	jne    8034af <insert_sorted_with_merge_freeList+0x547>
  803498:	83 ec 04             	sub    $0x4,%esp
  80349b:	68 30 43 80 00       	push   $0x804330
  8034a0:	68 69 01 00 00       	push   $0x169
  8034a5:	68 17 43 80 00       	push   $0x804317
  8034aa:	e8 ea cf ff ff       	call   800499 <_panic>
  8034af:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034b2:	8b 50 04             	mov    0x4(%eax),%edx
  8034b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8034b8:	89 50 04             	mov    %edx,0x4(%eax)
  8034bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8034be:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8034c1:	89 10                	mov    %edx,(%eax)
  8034c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034c6:	8b 40 04             	mov    0x4(%eax),%eax
  8034c9:	85 c0                	test   %eax,%eax
  8034cb:	74 0d                	je     8034da <insert_sorted_with_merge_freeList+0x572>
  8034cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034d0:	8b 40 04             	mov    0x4(%eax),%eax
  8034d3:	8b 55 08             	mov    0x8(%ebp),%edx
  8034d6:	89 10                	mov    %edx,(%eax)
  8034d8:	eb 08                	jmp    8034e2 <insert_sorted_with_merge_freeList+0x57a>
  8034da:	8b 45 08             	mov    0x8(%ebp),%eax
  8034dd:	a3 38 51 80 00       	mov    %eax,0x805138
  8034e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034e5:	8b 55 08             	mov    0x8(%ebp),%edx
  8034e8:	89 50 04             	mov    %edx,0x4(%eax)
  8034eb:	a1 44 51 80 00       	mov    0x805144,%eax
  8034f0:	40                   	inc    %eax
  8034f1:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  8034f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8034f9:	8b 50 0c             	mov    0xc(%eax),%edx
  8034fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034ff:	8b 40 0c             	mov    0xc(%eax),%eax
  803502:	01 c2                	add    %eax,%edx
  803504:	8b 45 08             	mov    0x8(%ebp),%eax
  803507:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80350a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80350e:	75 17                	jne    803527 <insert_sorted_with_merge_freeList+0x5bf>
  803510:	83 ec 04             	sub    $0x4,%esp
  803513:	68 c0 43 80 00       	push   $0x8043c0
  803518:	68 6b 01 00 00       	push   $0x16b
  80351d:	68 17 43 80 00       	push   $0x804317
  803522:	e8 72 cf ff ff       	call   800499 <_panic>
  803527:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80352a:	8b 00                	mov    (%eax),%eax
  80352c:	85 c0                	test   %eax,%eax
  80352e:	74 10                	je     803540 <insert_sorted_with_merge_freeList+0x5d8>
  803530:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803533:	8b 00                	mov    (%eax),%eax
  803535:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803538:	8b 52 04             	mov    0x4(%edx),%edx
  80353b:	89 50 04             	mov    %edx,0x4(%eax)
  80353e:	eb 0b                	jmp    80354b <insert_sorted_with_merge_freeList+0x5e3>
  803540:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803543:	8b 40 04             	mov    0x4(%eax),%eax
  803546:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80354b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80354e:	8b 40 04             	mov    0x4(%eax),%eax
  803551:	85 c0                	test   %eax,%eax
  803553:	74 0f                	je     803564 <insert_sorted_with_merge_freeList+0x5fc>
  803555:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803558:	8b 40 04             	mov    0x4(%eax),%eax
  80355b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80355e:	8b 12                	mov    (%edx),%edx
  803560:	89 10                	mov    %edx,(%eax)
  803562:	eb 0a                	jmp    80356e <insert_sorted_with_merge_freeList+0x606>
  803564:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803567:	8b 00                	mov    (%eax),%eax
  803569:	a3 38 51 80 00       	mov    %eax,0x805138
  80356e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803571:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803577:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80357a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803581:	a1 44 51 80 00       	mov    0x805144,%eax
  803586:	48                   	dec    %eax
  803587:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  80358c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80358f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803596:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803599:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8035a0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8035a4:	75 17                	jne    8035bd <insert_sorted_with_merge_freeList+0x655>
  8035a6:	83 ec 04             	sub    $0x4,%esp
  8035a9:	68 f4 42 80 00       	push   $0x8042f4
  8035ae:	68 6e 01 00 00       	push   $0x16e
  8035b3:	68 17 43 80 00       	push   $0x804317
  8035b8:	e8 dc ce ff ff       	call   800499 <_panic>
  8035bd:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8035c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035c6:	89 10                	mov    %edx,(%eax)
  8035c8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035cb:	8b 00                	mov    (%eax),%eax
  8035cd:	85 c0                	test   %eax,%eax
  8035cf:	74 0d                	je     8035de <insert_sorted_with_merge_freeList+0x676>
  8035d1:	a1 48 51 80 00       	mov    0x805148,%eax
  8035d6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8035d9:	89 50 04             	mov    %edx,0x4(%eax)
  8035dc:	eb 08                	jmp    8035e6 <insert_sorted_with_merge_freeList+0x67e>
  8035de:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035e1:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8035e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035e9:	a3 48 51 80 00       	mov    %eax,0x805148
  8035ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035f1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035f8:	a1 54 51 80 00       	mov    0x805154,%eax
  8035fd:	40                   	inc    %eax
  8035fe:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803603:	e9 a9 00 00 00       	jmp    8036b1 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803608:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80360c:	74 06                	je     803614 <insert_sorted_with_merge_freeList+0x6ac>
  80360e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803612:	75 17                	jne    80362b <insert_sorted_with_merge_freeList+0x6c3>
  803614:	83 ec 04             	sub    $0x4,%esp
  803617:	68 8c 43 80 00       	push   $0x80438c
  80361c:	68 73 01 00 00       	push   $0x173
  803621:	68 17 43 80 00       	push   $0x804317
  803626:	e8 6e ce ff ff       	call   800499 <_panic>
  80362b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80362e:	8b 10                	mov    (%eax),%edx
  803630:	8b 45 08             	mov    0x8(%ebp),%eax
  803633:	89 10                	mov    %edx,(%eax)
  803635:	8b 45 08             	mov    0x8(%ebp),%eax
  803638:	8b 00                	mov    (%eax),%eax
  80363a:	85 c0                	test   %eax,%eax
  80363c:	74 0b                	je     803649 <insert_sorted_with_merge_freeList+0x6e1>
  80363e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803641:	8b 00                	mov    (%eax),%eax
  803643:	8b 55 08             	mov    0x8(%ebp),%edx
  803646:	89 50 04             	mov    %edx,0x4(%eax)
  803649:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80364c:	8b 55 08             	mov    0x8(%ebp),%edx
  80364f:	89 10                	mov    %edx,(%eax)
  803651:	8b 45 08             	mov    0x8(%ebp),%eax
  803654:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803657:	89 50 04             	mov    %edx,0x4(%eax)
  80365a:	8b 45 08             	mov    0x8(%ebp),%eax
  80365d:	8b 00                	mov    (%eax),%eax
  80365f:	85 c0                	test   %eax,%eax
  803661:	75 08                	jne    80366b <insert_sorted_with_merge_freeList+0x703>
  803663:	8b 45 08             	mov    0x8(%ebp),%eax
  803666:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80366b:	a1 44 51 80 00       	mov    0x805144,%eax
  803670:	40                   	inc    %eax
  803671:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803676:	eb 39                	jmp    8036b1 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803678:	a1 40 51 80 00       	mov    0x805140,%eax
  80367d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803680:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803684:	74 07                	je     80368d <insert_sorted_with_merge_freeList+0x725>
  803686:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803689:	8b 00                	mov    (%eax),%eax
  80368b:	eb 05                	jmp    803692 <insert_sorted_with_merge_freeList+0x72a>
  80368d:	b8 00 00 00 00       	mov    $0x0,%eax
  803692:	a3 40 51 80 00       	mov    %eax,0x805140
  803697:	a1 40 51 80 00       	mov    0x805140,%eax
  80369c:	85 c0                	test   %eax,%eax
  80369e:	0f 85 c7 fb ff ff    	jne    80326b <insert_sorted_with_merge_freeList+0x303>
  8036a4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036a8:	0f 85 bd fb ff ff    	jne    80326b <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8036ae:	eb 01                	jmp    8036b1 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8036b0:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8036b1:	90                   	nop
  8036b2:	c9                   	leave  
  8036b3:	c3                   	ret    

008036b4 <__udivdi3>:
  8036b4:	55                   	push   %ebp
  8036b5:	57                   	push   %edi
  8036b6:	56                   	push   %esi
  8036b7:	53                   	push   %ebx
  8036b8:	83 ec 1c             	sub    $0x1c,%esp
  8036bb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8036bf:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8036c3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8036c7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8036cb:	89 ca                	mov    %ecx,%edx
  8036cd:	89 f8                	mov    %edi,%eax
  8036cf:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8036d3:	85 f6                	test   %esi,%esi
  8036d5:	75 2d                	jne    803704 <__udivdi3+0x50>
  8036d7:	39 cf                	cmp    %ecx,%edi
  8036d9:	77 65                	ja     803740 <__udivdi3+0x8c>
  8036db:	89 fd                	mov    %edi,%ebp
  8036dd:	85 ff                	test   %edi,%edi
  8036df:	75 0b                	jne    8036ec <__udivdi3+0x38>
  8036e1:	b8 01 00 00 00       	mov    $0x1,%eax
  8036e6:	31 d2                	xor    %edx,%edx
  8036e8:	f7 f7                	div    %edi
  8036ea:	89 c5                	mov    %eax,%ebp
  8036ec:	31 d2                	xor    %edx,%edx
  8036ee:	89 c8                	mov    %ecx,%eax
  8036f0:	f7 f5                	div    %ebp
  8036f2:	89 c1                	mov    %eax,%ecx
  8036f4:	89 d8                	mov    %ebx,%eax
  8036f6:	f7 f5                	div    %ebp
  8036f8:	89 cf                	mov    %ecx,%edi
  8036fa:	89 fa                	mov    %edi,%edx
  8036fc:	83 c4 1c             	add    $0x1c,%esp
  8036ff:	5b                   	pop    %ebx
  803700:	5e                   	pop    %esi
  803701:	5f                   	pop    %edi
  803702:	5d                   	pop    %ebp
  803703:	c3                   	ret    
  803704:	39 ce                	cmp    %ecx,%esi
  803706:	77 28                	ja     803730 <__udivdi3+0x7c>
  803708:	0f bd fe             	bsr    %esi,%edi
  80370b:	83 f7 1f             	xor    $0x1f,%edi
  80370e:	75 40                	jne    803750 <__udivdi3+0x9c>
  803710:	39 ce                	cmp    %ecx,%esi
  803712:	72 0a                	jb     80371e <__udivdi3+0x6a>
  803714:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803718:	0f 87 9e 00 00 00    	ja     8037bc <__udivdi3+0x108>
  80371e:	b8 01 00 00 00       	mov    $0x1,%eax
  803723:	89 fa                	mov    %edi,%edx
  803725:	83 c4 1c             	add    $0x1c,%esp
  803728:	5b                   	pop    %ebx
  803729:	5e                   	pop    %esi
  80372a:	5f                   	pop    %edi
  80372b:	5d                   	pop    %ebp
  80372c:	c3                   	ret    
  80372d:	8d 76 00             	lea    0x0(%esi),%esi
  803730:	31 ff                	xor    %edi,%edi
  803732:	31 c0                	xor    %eax,%eax
  803734:	89 fa                	mov    %edi,%edx
  803736:	83 c4 1c             	add    $0x1c,%esp
  803739:	5b                   	pop    %ebx
  80373a:	5e                   	pop    %esi
  80373b:	5f                   	pop    %edi
  80373c:	5d                   	pop    %ebp
  80373d:	c3                   	ret    
  80373e:	66 90                	xchg   %ax,%ax
  803740:	89 d8                	mov    %ebx,%eax
  803742:	f7 f7                	div    %edi
  803744:	31 ff                	xor    %edi,%edi
  803746:	89 fa                	mov    %edi,%edx
  803748:	83 c4 1c             	add    $0x1c,%esp
  80374b:	5b                   	pop    %ebx
  80374c:	5e                   	pop    %esi
  80374d:	5f                   	pop    %edi
  80374e:	5d                   	pop    %ebp
  80374f:	c3                   	ret    
  803750:	bd 20 00 00 00       	mov    $0x20,%ebp
  803755:	89 eb                	mov    %ebp,%ebx
  803757:	29 fb                	sub    %edi,%ebx
  803759:	89 f9                	mov    %edi,%ecx
  80375b:	d3 e6                	shl    %cl,%esi
  80375d:	89 c5                	mov    %eax,%ebp
  80375f:	88 d9                	mov    %bl,%cl
  803761:	d3 ed                	shr    %cl,%ebp
  803763:	89 e9                	mov    %ebp,%ecx
  803765:	09 f1                	or     %esi,%ecx
  803767:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80376b:	89 f9                	mov    %edi,%ecx
  80376d:	d3 e0                	shl    %cl,%eax
  80376f:	89 c5                	mov    %eax,%ebp
  803771:	89 d6                	mov    %edx,%esi
  803773:	88 d9                	mov    %bl,%cl
  803775:	d3 ee                	shr    %cl,%esi
  803777:	89 f9                	mov    %edi,%ecx
  803779:	d3 e2                	shl    %cl,%edx
  80377b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80377f:	88 d9                	mov    %bl,%cl
  803781:	d3 e8                	shr    %cl,%eax
  803783:	09 c2                	or     %eax,%edx
  803785:	89 d0                	mov    %edx,%eax
  803787:	89 f2                	mov    %esi,%edx
  803789:	f7 74 24 0c          	divl   0xc(%esp)
  80378d:	89 d6                	mov    %edx,%esi
  80378f:	89 c3                	mov    %eax,%ebx
  803791:	f7 e5                	mul    %ebp
  803793:	39 d6                	cmp    %edx,%esi
  803795:	72 19                	jb     8037b0 <__udivdi3+0xfc>
  803797:	74 0b                	je     8037a4 <__udivdi3+0xf0>
  803799:	89 d8                	mov    %ebx,%eax
  80379b:	31 ff                	xor    %edi,%edi
  80379d:	e9 58 ff ff ff       	jmp    8036fa <__udivdi3+0x46>
  8037a2:	66 90                	xchg   %ax,%ax
  8037a4:	8b 54 24 08          	mov    0x8(%esp),%edx
  8037a8:	89 f9                	mov    %edi,%ecx
  8037aa:	d3 e2                	shl    %cl,%edx
  8037ac:	39 c2                	cmp    %eax,%edx
  8037ae:	73 e9                	jae    803799 <__udivdi3+0xe5>
  8037b0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8037b3:	31 ff                	xor    %edi,%edi
  8037b5:	e9 40 ff ff ff       	jmp    8036fa <__udivdi3+0x46>
  8037ba:	66 90                	xchg   %ax,%ax
  8037bc:	31 c0                	xor    %eax,%eax
  8037be:	e9 37 ff ff ff       	jmp    8036fa <__udivdi3+0x46>
  8037c3:	90                   	nop

008037c4 <__umoddi3>:
  8037c4:	55                   	push   %ebp
  8037c5:	57                   	push   %edi
  8037c6:	56                   	push   %esi
  8037c7:	53                   	push   %ebx
  8037c8:	83 ec 1c             	sub    $0x1c,%esp
  8037cb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8037cf:	8b 74 24 34          	mov    0x34(%esp),%esi
  8037d3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8037d7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8037db:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8037df:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8037e3:	89 f3                	mov    %esi,%ebx
  8037e5:	89 fa                	mov    %edi,%edx
  8037e7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8037eb:	89 34 24             	mov    %esi,(%esp)
  8037ee:	85 c0                	test   %eax,%eax
  8037f0:	75 1a                	jne    80380c <__umoddi3+0x48>
  8037f2:	39 f7                	cmp    %esi,%edi
  8037f4:	0f 86 a2 00 00 00    	jbe    80389c <__umoddi3+0xd8>
  8037fa:	89 c8                	mov    %ecx,%eax
  8037fc:	89 f2                	mov    %esi,%edx
  8037fe:	f7 f7                	div    %edi
  803800:	89 d0                	mov    %edx,%eax
  803802:	31 d2                	xor    %edx,%edx
  803804:	83 c4 1c             	add    $0x1c,%esp
  803807:	5b                   	pop    %ebx
  803808:	5e                   	pop    %esi
  803809:	5f                   	pop    %edi
  80380a:	5d                   	pop    %ebp
  80380b:	c3                   	ret    
  80380c:	39 f0                	cmp    %esi,%eax
  80380e:	0f 87 ac 00 00 00    	ja     8038c0 <__umoddi3+0xfc>
  803814:	0f bd e8             	bsr    %eax,%ebp
  803817:	83 f5 1f             	xor    $0x1f,%ebp
  80381a:	0f 84 ac 00 00 00    	je     8038cc <__umoddi3+0x108>
  803820:	bf 20 00 00 00       	mov    $0x20,%edi
  803825:	29 ef                	sub    %ebp,%edi
  803827:	89 fe                	mov    %edi,%esi
  803829:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80382d:	89 e9                	mov    %ebp,%ecx
  80382f:	d3 e0                	shl    %cl,%eax
  803831:	89 d7                	mov    %edx,%edi
  803833:	89 f1                	mov    %esi,%ecx
  803835:	d3 ef                	shr    %cl,%edi
  803837:	09 c7                	or     %eax,%edi
  803839:	89 e9                	mov    %ebp,%ecx
  80383b:	d3 e2                	shl    %cl,%edx
  80383d:	89 14 24             	mov    %edx,(%esp)
  803840:	89 d8                	mov    %ebx,%eax
  803842:	d3 e0                	shl    %cl,%eax
  803844:	89 c2                	mov    %eax,%edx
  803846:	8b 44 24 08          	mov    0x8(%esp),%eax
  80384a:	d3 e0                	shl    %cl,%eax
  80384c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803850:	8b 44 24 08          	mov    0x8(%esp),%eax
  803854:	89 f1                	mov    %esi,%ecx
  803856:	d3 e8                	shr    %cl,%eax
  803858:	09 d0                	or     %edx,%eax
  80385a:	d3 eb                	shr    %cl,%ebx
  80385c:	89 da                	mov    %ebx,%edx
  80385e:	f7 f7                	div    %edi
  803860:	89 d3                	mov    %edx,%ebx
  803862:	f7 24 24             	mull   (%esp)
  803865:	89 c6                	mov    %eax,%esi
  803867:	89 d1                	mov    %edx,%ecx
  803869:	39 d3                	cmp    %edx,%ebx
  80386b:	0f 82 87 00 00 00    	jb     8038f8 <__umoddi3+0x134>
  803871:	0f 84 91 00 00 00    	je     803908 <__umoddi3+0x144>
  803877:	8b 54 24 04          	mov    0x4(%esp),%edx
  80387b:	29 f2                	sub    %esi,%edx
  80387d:	19 cb                	sbb    %ecx,%ebx
  80387f:	89 d8                	mov    %ebx,%eax
  803881:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803885:	d3 e0                	shl    %cl,%eax
  803887:	89 e9                	mov    %ebp,%ecx
  803889:	d3 ea                	shr    %cl,%edx
  80388b:	09 d0                	or     %edx,%eax
  80388d:	89 e9                	mov    %ebp,%ecx
  80388f:	d3 eb                	shr    %cl,%ebx
  803891:	89 da                	mov    %ebx,%edx
  803893:	83 c4 1c             	add    $0x1c,%esp
  803896:	5b                   	pop    %ebx
  803897:	5e                   	pop    %esi
  803898:	5f                   	pop    %edi
  803899:	5d                   	pop    %ebp
  80389a:	c3                   	ret    
  80389b:	90                   	nop
  80389c:	89 fd                	mov    %edi,%ebp
  80389e:	85 ff                	test   %edi,%edi
  8038a0:	75 0b                	jne    8038ad <__umoddi3+0xe9>
  8038a2:	b8 01 00 00 00       	mov    $0x1,%eax
  8038a7:	31 d2                	xor    %edx,%edx
  8038a9:	f7 f7                	div    %edi
  8038ab:	89 c5                	mov    %eax,%ebp
  8038ad:	89 f0                	mov    %esi,%eax
  8038af:	31 d2                	xor    %edx,%edx
  8038b1:	f7 f5                	div    %ebp
  8038b3:	89 c8                	mov    %ecx,%eax
  8038b5:	f7 f5                	div    %ebp
  8038b7:	89 d0                	mov    %edx,%eax
  8038b9:	e9 44 ff ff ff       	jmp    803802 <__umoddi3+0x3e>
  8038be:	66 90                	xchg   %ax,%ax
  8038c0:	89 c8                	mov    %ecx,%eax
  8038c2:	89 f2                	mov    %esi,%edx
  8038c4:	83 c4 1c             	add    $0x1c,%esp
  8038c7:	5b                   	pop    %ebx
  8038c8:	5e                   	pop    %esi
  8038c9:	5f                   	pop    %edi
  8038ca:	5d                   	pop    %ebp
  8038cb:	c3                   	ret    
  8038cc:	3b 04 24             	cmp    (%esp),%eax
  8038cf:	72 06                	jb     8038d7 <__umoddi3+0x113>
  8038d1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8038d5:	77 0f                	ja     8038e6 <__umoddi3+0x122>
  8038d7:	89 f2                	mov    %esi,%edx
  8038d9:	29 f9                	sub    %edi,%ecx
  8038db:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8038df:	89 14 24             	mov    %edx,(%esp)
  8038e2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8038e6:	8b 44 24 04          	mov    0x4(%esp),%eax
  8038ea:	8b 14 24             	mov    (%esp),%edx
  8038ed:	83 c4 1c             	add    $0x1c,%esp
  8038f0:	5b                   	pop    %ebx
  8038f1:	5e                   	pop    %esi
  8038f2:	5f                   	pop    %edi
  8038f3:	5d                   	pop    %ebp
  8038f4:	c3                   	ret    
  8038f5:	8d 76 00             	lea    0x0(%esi),%esi
  8038f8:	2b 04 24             	sub    (%esp),%eax
  8038fb:	19 fa                	sbb    %edi,%edx
  8038fd:	89 d1                	mov    %edx,%ecx
  8038ff:	89 c6                	mov    %eax,%esi
  803901:	e9 71 ff ff ff       	jmp    803877 <__umoddi3+0xb3>
  803906:	66 90                	xchg   %ax,%ax
  803908:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80390c:	72 ea                	jb     8038f8 <__umoddi3+0x134>
  80390e:	89 d9                	mov    %ebx,%ecx
  803910:	e9 62 ff ff ff       	jmp    803877 <__umoddi3+0xb3>
