
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
  80008d:	68 20 37 80 00       	push   $0x803720
  800092:	6a 12                	push   $0x12
  800094:	68 3c 37 80 00       	push   $0x80373c
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
  8000ae:	68 54 37 80 00       	push   $0x803754
  8000b3:	e8 95 06 00 00       	call   80074d <cprintf>
  8000b8:	83 c4 10             	add    $0x10,%esp
	{
		int freeFrames = sys_calculate_free_frames() ;
  8000bb:	e8 35 18 00 00       	call   8018f5 <sys_calculate_free_frames>
  8000c0:	89 45 e8             	mov    %eax,-0x18(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8000c3:	83 ec 04             	sub    $0x4,%esp
  8000c6:	6a 01                	push   $0x1
  8000c8:	68 00 10 00 00       	push   $0x1000
  8000cd:	68 8b 37 80 00       	push   $0x80378b
  8000d2:	e8 46 16 00 00       	call   80171d <smalloc>
  8000d7:	83 c4 10             	add    $0x10,%esp
  8000da:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (x != (uint32*)USER_HEAP_START) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  8000dd:	81 7d e4 00 00 00 80 	cmpl   $0x80000000,-0x1c(%ebp)
  8000e4:	74 14                	je     8000fa <_main+0xc2>
  8000e6:	83 ec 04             	sub    $0x4,%esp
  8000e9:	68 90 37 80 00       	push   $0x803790
  8000ee:	6a 1e                	push   $0x1e
  8000f0:	68 3c 37 80 00       	push   $0x80373c
  8000f5:	e8 9f 03 00 00       	call   800499 <_panic>
		expected = 1+1+2 ;
  8000fa:	c7 45 e0 04 00 00 00 	movl   $0x4,-0x20(%ebp)
		if ((freeFrames - sys_calculate_free_frames()) !=  expected) panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);
  800101:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800104:	e8 ec 17 00 00       	call   8018f5 <sys_calculate_free_frames>
  800109:	29 c3                	sub    %eax,%ebx
  80010b:	89 d8                	mov    %ebx,%eax
  80010d:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800110:	74 24                	je     800136 <_main+0xfe>
  800112:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800115:	e8 db 17 00 00       	call   8018f5 <sys_calculate_free_frames>
  80011a:	29 c3                	sub    %eax,%ebx
  80011c:	89 d8                	mov    %ebx,%eax
  80011e:	83 ec 0c             	sub    $0xc,%esp
  800121:	ff 75 e0             	pushl  -0x20(%ebp)
  800124:	50                   	push   %eax
  800125:	68 fc 37 80 00       	push   $0x8037fc
  80012a:	6a 20                	push   $0x20
  80012c:	68 3c 37 80 00       	push   $0x80373c
  800131:	e8 63 03 00 00       	call   800499 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800136:	e8 ba 17 00 00       	call   8018f5 <sys_calculate_free_frames>
  80013b:	89 45 e8             	mov    %eax,-0x18(%ebp)
		z = smalloc("z", PAGE_SIZE + 4, 1);
  80013e:	83 ec 04             	sub    $0x4,%esp
  800141:	6a 01                	push   $0x1
  800143:	68 04 10 00 00       	push   $0x1004
  800148:	68 94 38 80 00       	push   $0x803894
  80014d:	e8 cb 15 00 00       	call   80171d <smalloc>
  800152:	83 c4 10             	add    $0x10,%esp
  800155:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (z != (uint32*)(USER_HEAP_START + 1 * PAGE_SIZE)) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  800158:	81 7d dc 00 10 00 80 	cmpl   $0x80001000,-0x24(%ebp)
  80015f:	74 14                	je     800175 <_main+0x13d>
  800161:	83 ec 04             	sub    $0x4,%esp
  800164:	68 90 37 80 00       	push   $0x803790
  800169:	6a 24                	push   $0x24
  80016b:	68 3c 37 80 00       	push   $0x80373c
  800170:	e8 24 03 00 00       	call   800499 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  2+0+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800175:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800178:	e8 78 17 00 00       	call   8018f5 <sys_calculate_free_frames>
  80017d:	29 c3                	sub    %eax,%ebx
  80017f:	89 d8                	mov    %ebx,%eax
  800181:	83 f8 04             	cmp    $0x4,%eax
  800184:	74 14                	je     80019a <_main+0x162>
  800186:	83 ec 04             	sub    $0x4,%esp
  800189:	68 98 38 80 00       	push   $0x803898
  80018e:	6a 25                	push   $0x25
  800190:	68 3c 37 80 00       	push   $0x80373c
  800195:	e8 ff 02 00 00       	call   800499 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  80019a:	e8 56 17 00 00       	call   8018f5 <sys_calculate_free_frames>
  80019f:	89 45 e8             	mov    %eax,-0x18(%ebp)
		y = smalloc("y", 4, 1);
  8001a2:	83 ec 04             	sub    $0x4,%esp
  8001a5:	6a 01                	push   $0x1
  8001a7:	6a 04                	push   $0x4
  8001a9:	68 16 39 80 00       	push   $0x803916
  8001ae:	e8 6a 15 00 00       	call   80171d <smalloc>
  8001b3:	83 c4 10             	add    $0x10,%esp
  8001b6:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if (y != (uint32*)(USER_HEAP_START + 3 * PAGE_SIZE)) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  8001b9:	81 7d d8 00 30 00 80 	cmpl   $0x80003000,-0x28(%ebp)
  8001c0:	74 14                	je     8001d6 <_main+0x19e>
  8001c2:	83 ec 04             	sub    $0x4,%esp
  8001c5:	68 90 37 80 00       	push   $0x803790
  8001ca:	6a 29                	push   $0x29
  8001cc:	68 3c 37 80 00       	push   $0x80373c
  8001d1:	e8 c3 02 00 00       	call   800499 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  1+0+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  8001d6:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8001d9:	e8 17 17 00 00       	call   8018f5 <sys_calculate_free_frames>
  8001de:	29 c3                	sub    %eax,%ebx
  8001e0:	89 d8                	mov    %ebx,%eax
  8001e2:	83 f8 03             	cmp    $0x3,%eax
  8001e5:	74 14                	je     8001fb <_main+0x1c3>
  8001e7:	83 ec 04             	sub    $0x4,%esp
  8001ea:	68 98 38 80 00       	push   $0x803898
  8001ef:	6a 2a                	push   $0x2a
  8001f1:	68 3c 37 80 00       	push   $0x80373c
  8001f6:	e8 9e 02 00 00       	call   800499 <_panic>
	}
	cprintf("Step A is completed successfully!!\n\n\n");
  8001fb:	83 ec 0c             	sub    $0xc,%esp
  8001fe:	68 18 39 80 00       	push   $0x803918
  800203:	e8 45 05 00 00       	call   80074d <cprintf>
  800208:	83 c4 10             	add    $0x10,%esp


	cprintf("STEP B: checking reading & writing... \n");
  80020b:	83 ec 0c             	sub    $0xc,%esp
  80020e:	68 40 39 80 00       	push   $0x803940
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
  800291:	68 68 39 80 00       	push   $0x803968
  800296:	6a 3e                	push   $0x3e
  800298:	68 3c 37 80 00       	push   $0x80373c
  80029d:	e8 f7 01 00 00       	call   800499 <_panic>
		if( x[PAGE_SIZE/4 - 1] !=  -1)  	panic("Reading/Writing of shared object is failed");
  8002a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002a5:	05 fc 0f 00 00       	add    $0xffc,%eax
  8002aa:	8b 00                	mov    (%eax),%eax
  8002ac:	83 f8 ff             	cmp    $0xffffffff,%eax
  8002af:	74 14                	je     8002c5 <_main+0x28d>
  8002b1:	83 ec 04             	sub    $0x4,%esp
  8002b4:	68 68 39 80 00       	push   $0x803968
  8002b9:	6a 3f                	push   $0x3f
  8002bb:	68 3c 37 80 00       	push   $0x80373c
  8002c0:	e8 d4 01 00 00       	call   800499 <_panic>

		if( y[0] !=  -1)  					panic("Reading/Writing of shared object is failed");
  8002c5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8002c8:	8b 00                	mov    (%eax),%eax
  8002ca:	83 f8 ff             	cmp    $0xffffffff,%eax
  8002cd:	74 14                	je     8002e3 <_main+0x2ab>
  8002cf:	83 ec 04             	sub    $0x4,%esp
  8002d2:	68 68 39 80 00       	push   $0x803968
  8002d7:	6a 41                	push   $0x41
  8002d9:	68 3c 37 80 00       	push   $0x80373c
  8002de:	e8 b6 01 00 00       	call   800499 <_panic>
		if( y[PAGE_SIZE/4 - 1] !=  -1)  	panic("Reading/Writing of shared object is failed");
  8002e3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8002e6:	05 fc 0f 00 00       	add    $0xffc,%eax
  8002eb:	8b 00                	mov    (%eax),%eax
  8002ed:	83 f8 ff             	cmp    $0xffffffff,%eax
  8002f0:	74 14                	je     800306 <_main+0x2ce>
  8002f2:	83 ec 04             	sub    $0x4,%esp
  8002f5:	68 68 39 80 00       	push   $0x803968
  8002fa:	6a 42                	push   $0x42
  8002fc:	68 3c 37 80 00       	push   $0x80373c
  800301:	e8 93 01 00 00       	call   800499 <_panic>

		if( z[0] !=  -1)  					panic("Reading/Writing of shared object is failed");
  800306:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800309:	8b 00                	mov    (%eax),%eax
  80030b:	83 f8 ff             	cmp    $0xffffffff,%eax
  80030e:	74 14                	je     800324 <_main+0x2ec>
  800310:	83 ec 04             	sub    $0x4,%esp
  800313:	68 68 39 80 00       	push   $0x803968
  800318:	6a 44                	push   $0x44
  80031a:	68 3c 37 80 00       	push   $0x80373c
  80031f:	e8 75 01 00 00       	call   800499 <_panic>
		if( z[2*PAGE_SIZE/4 - 1] !=  -1)  	panic("Reading/Writing of shared object is failed");
  800324:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800327:	05 fc 1f 00 00       	add    $0x1ffc,%eax
  80032c:	8b 00                	mov    (%eax),%eax
  80032e:	83 f8 ff             	cmp    $0xffffffff,%eax
  800331:	74 14                	je     800347 <_main+0x30f>
  800333:	83 ec 04             	sub    $0x4,%esp
  800336:	68 68 39 80 00       	push   $0x803968
  80033b:	6a 45                	push   $0x45
  80033d:	68 3c 37 80 00       	push   $0x80373c
  800342:	e8 52 01 00 00       	call   800499 <_panic>
	}

	cprintf("Congratulations!! Test of Shared Variables [Create] [1] completed successfully!!\n\n\n");
  800347:	83 ec 0c             	sub    $0xc,%esp
  80034a:	68 94 39 80 00       	push   $0x803994
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
  800363:	e8 6d 18 00 00       	call   801bd5 <sys_getenvindex>
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
  8003ce:	e8 0f 16 00 00       	call   8019e2 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8003d3:	83 ec 0c             	sub    $0xc,%esp
  8003d6:	68 00 3a 80 00       	push   $0x803a00
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
  8003fe:	68 28 3a 80 00       	push   $0x803a28
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
  80042f:	68 50 3a 80 00       	push   $0x803a50
  800434:	e8 14 03 00 00       	call   80074d <cprintf>
  800439:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80043c:	a1 20 50 80 00       	mov    0x805020,%eax
  800441:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800447:	83 ec 08             	sub    $0x8,%esp
  80044a:	50                   	push   %eax
  80044b:	68 a8 3a 80 00       	push   $0x803aa8
  800450:	e8 f8 02 00 00       	call   80074d <cprintf>
  800455:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800458:	83 ec 0c             	sub    $0xc,%esp
  80045b:	68 00 3a 80 00       	push   $0x803a00
  800460:	e8 e8 02 00 00       	call   80074d <cprintf>
  800465:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800468:	e8 8f 15 00 00       	call   8019fc <sys_enable_interrupt>

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
  800480:	e8 1c 17 00 00       	call   801ba1 <sys_destroy_env>
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
  800491:	e8 71 17 00 00       	call   801c07 <sys_exit_env>
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
  8004ba:	68 bc 3a 80 00       	push   $0x803abc
  8004bf:	e8 89 02 00 00       	call   80074d <cprintf>
  8004c4:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8004c7:	a1 00 50 80 00       	mov    0x805000,%eax
  8004cc:	ff 75 0c             	pushl  0xc(%ebp)
  8004cf:	ff 75 08             	pushl  0x8(%ebp)
  8004d2:	50                   	push   %eax
  8004d3:	68 c1 3a 80 00       	push   $0x803ac1
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
  8004f7:	68 dd 3a 80 00       	push   $0x803add
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
  800523:	68 e0 3a 80 00       	push   $0x803ae0
  800528:	6a 26                	push   $0x26
  80052a:	68 2c 3b 80 00       	push   $0x803b2c
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
  8005f5:	68 38 3b 80 00       	push   $0x803b38
  8005fa:	6a 3a                	push   $0x3a
  8005fc:	68 2c 3b 80 00       	push   $0x803b2c
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
  800665:	68 8c 3b 80 00       	push   $0x803b8c
  80066a:	6a 44                	push   $0x44
  80066c:	68 2c 3b 80 00       	push   $0x803b2c
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
  8006bf:	e8 70 11 00 00       	call   801834 <sys_cputs>
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
  800736:	e8 f9 10 00 00       	call   801834 <sys_cputs>
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
  800780:	e8 5d 12 00 00       	call   8019e2 <sys_disable_interrupt>
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
  8007a0:	e8 57 12 00 00       	call   8019fc <sys_enable_interrupt>
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
  8007ea:	e8 c9 2c 00 00       	call   8034b8 <__udivdi3>
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
  80083a:	e8 89 2d 00 00       	call   8035c8 <__umoddi3>
  80083f:	83 c4 10             	add    $0x10,%esp
  800842:	05 f4 3d 80 00       	add    $0x803df4,%eax
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
  800995:	8b 04 85 18 3e 80 00 	mov    0x803e18(,%eax,4),%eax
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
  800a76:	8b 34 9d 60 3c 80 00 	mov    0x803c60(,%ebx,4),%esi
  800a7d:	85 f6                	test   %esi,%esi
  800a7f:	75 19                	jne    800a9a <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800a81:	53                   	push   %ebx
  800a82:	68 05 3e 80 00       	push   $0x803e05
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
  800a9b:	68 0e 3e 80 00       	push   $0x803e0e
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
  800ac8:	be 11 3e 80 00       	mov    $0x803e11,%esi
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
  8014ee:	68 70 3f 80 00       	push   $0x803f70
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
  8015be:	e8 b5 03 00 00       	call   801978 <sys_allocate_chunk>
  8015c3:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8015c6:	a1 20 51 80 00       	mov    0x805120,%eax
  8015cb:	83 ec 0c             	sub    $0xc,%esp
  8015ce:	50                   	push   %eax
  8015cf:	e8 2a 0a 00 00       	call   801ffe <initialize_MemBlocksList>
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
  8015fc:	68 95 3f 80 00       	push   $0x803f95
  801601:	6a 33                	push   $0x33
  801603:	68 b3 3f 80 00       	push   $0x803fb3
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
  80167b:	68 c0 3f 80 00       	push   $0x803fc0
  801680:	6a 34                	push   $0x34
  801682:	68 b3 3f 80 00       	push   $0x803fb3
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
  8016f0:	68 e4 3f 80 00       	push   $0x803fe4
  8016f5:	6a 46                	push   $0x46
  8016f7:	68 b3 3f 80 00       	push   $0x803fb3
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
  80170c:	68 0c 40 80 00       	push   $0x80400c
  801711:	6a 61                	push   $0x61
  801713:	68 b3 3f 80 00       	push   $0x803fb3
  801718:	e8 7c ed ff ff       	call   800499 <_panic>

0080171d <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80171d:	55                   	push   %ebp
  80171e:	89 e5                	mov    %esp,%ebp
  801720:	83 ec 18             	sub    $0x18,%esp
  801723:	8b 45 10             	mov    0x10(%ebp),%eax
  801726:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801729:	e8 a9 fd ff ff       	call   8014d7 <InitializeUHeap>
	if (size == 0) return NULL ;
  80172e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801732:	75 07                	jne    80173b <smalloc+0x1e>
  801734:	b8 00 00 00 00       	mov    $0x0,%eax
  801739:	eb 14                	jmp    80174f <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  80173b:	83 ec 04             	sub    $0x4,%esp
  80173e:	68 30 40 80 00       	push   $0x804030
  801743:	6a 76                	push   $0x76
  801745:	68 b3 3f 80 00       	push   $0x803fb3
  80174a:	e8 4a ed ff ff       	call   800499 <_panic>

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80174f:	c9                   	leave  
  801750:	c3                   	ret    

00801751 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801751:	55                   	push   %ebp
  801752:	89 e5                	mov    %esp,%ebp
  801754:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801757:	e8 7b fd ff ff       	call   8014d7 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  80175c:	83 ec 04             	sub    $0x4,%esp
  80175f:	68 58 40 80 00       	push   $0x804058
  801764:	68 93 00 00 00       	push   $0x93
  801769:	68 b3 3f 80 00       	push   $0x803fb3
  80176e:	e8 26 ed ff ff       	call   800499 <_panic>

00801773 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801773:	55                   	push   %ebp
  801774:	89 e5                	mov    %esp,%ebp
  801776:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801779:	e8 59 fd ff ff       	call   8014d7 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80177e:	83 ec 04             	sub    $0x4,%esp
  801781:	68 7c 40 80 00       	push   $0x80407c
  801786:	68 c5 00 00 00       	push   $0xc5
  80178b:	68 b3 3f 80 00       	push   $0x803fb3
  801790:	e8 04 ed ff ff       	call   800499 <_panic>

00801795 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801795:	55                   	push   %ebp
  801796:	89 e5                	mov    %esp,%ebp
  801798:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80179b:	83 ec 04             	sub    $0x4,%esp
  80179e:	68 a4 40 80 00       	push   $0x8040a4
  8017a3:	68 d9 00 00 00       	push   $0xd9
  8017a8:	68 b3 3f 80 00       	push   $0x803fb3
  8017ad:	e8 e7 ec ff ff       	call   800499 <_panic>

008017b2 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8017b2:	55                   	push   %ebp
  8017b3:	89 e5                	mov    %esp,%ebp
  8017b5:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017b8:	83 ec 04             	sub    $0x4,%esp
  8017bb:	68 c8 40 80 00       	push   $0x8040c8
  8017c0:	68 e4 00 00 00       	push   $0xe4
  8017c5:	68 b3 3f 80 00       	push   $0x803fb3
  8017ca:	e8 ca ec ff ff       	call   800499 <_panic>

008017cf <shrink>:

}
void shrink(uint32 newSize)
{
  8017cf:	55                   	push   %ebp
  8017d0:	89 e5                	mov    %esp,%ebp
  8017d2:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017d5:	83 ec 04             	sub    $0x4,%esp
  8017d8:	68 c8 40 80 00       	push   $0x8040c8
  8017dd:	68 e9 00 00 00       	push   $0xe9
  8017e2:	68 b3 3f 80 00       	push   $0x803fb3
  8017e7:	e8 ad ec ff ff       	call   800499 <_panic>

008017ec <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8017ec:	55                   	push   %ebp
  8017ed:	89 e5                	mov    %esp,%ebp
  8017ef:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017f2:	83 ec 04             	sub    $0x4,%esp
  8017f5:	68 c8 40 80 00       	push   $0x8040c8
  8017fa:	68 ee 00 00 00       	push   $0xee
  8017ff:	68 b3 3f 80 00       	push   $0x803fb3
  801804:	e8 90 ec ff ff       	call   800499 <_panic>

00801809 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801809:	55                   	push   %ebp
  80180a:	89 e5                	mov    %esp,%ebp
  80180c:	57                   	push   %edi
  80180d:	56                   	push   %esi
  80180e:	53                   	push   %ebx
  80180f:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801812:	8b 45 08             	mov    0x8(%ebp),%eax
  801815:	8b 55 0c             	mov    0xc(%ebp),%edx
  801818:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80181b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80181e:	8b 7d 18             	mov    0x18(%ebp),%edi
  801821:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801824:	cd 30                	int    $0x30
  801826:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801829:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80182c:	83 c4 10             	add    $0x10,%esp
  80182f:	5b                   	pop    %ebx
  801830:	5e                   	pop    %esi
  801831:	5f                   	pop    %edi
  801832:	5d                   	pop    %ebp
  801833:	c3                   	ret    

00801834 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801834:	55                   	push   %ebp
  801835:	89 e5                	mov    %esp,%ebp
  801837:	83 ec 04             	sub    $0x4,%esp
  80183a:	8b 45 10             	mov    0x10(%ebp),%eax
  80183d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801840:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801844:	8b 45 08             	mov    0x8(%ebp),%eax
  801847:	6a 00                	push   $0x0
  801849:	6a 00                	push   $0x0
  80184b:	52                   	push   %edx
  80184c:	ff 75 0c             	pushl  0xc(%ebp)
  80184f:	50                   	push   %eax
  801850:	6a 00                	push   $0x0
  801852:	e8 b2 ff ff ff       	call   801809 <syscall>
  801857:	83 c4 18             	add    $0x18,%esp
}
  80185a:	90                   	nop
  80185b:	c9                   	leave  
  80185c:	c3                   	ret    

0080185d <sys_cgetc>:

int
sys_cgetc(void)
{
  80185d:	55                   	push   %ebp
  80185e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801860:	6a 00                	push   $0x0
  801862:	6a 00                	push   $0x0
  801864:	6a 00                	push   $0x0
  801866:	6a 00                	push   $0x0
  801868:	6a 00                	push   $0x0
  80186a:	6a 01                	push   $0x1
  80186c:	e8 98 ff ff ff       	call   801809 <syscall>
  801871:	83 c4 18             	add    $0x18,%esp
}
  801874:	c9                   	leave  
  801875:	c3                   	ret    

00801876 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801876:	55                   	push   %ebp
  801877:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801879:	8b 55 0c             	mov    0xc(%ebp),%edx
  80187c:	8b 45 08             	mov    0x8(%ebp),%eax
  80187f:	6a 00                	push   $0x0
  801881:	6a 00                	push   $0x0
  801883:	6a 00                	push   $0x0
  801885:	52                   	push   %edx
  801886:	50                   	push   %eax
  801887:	6a 05                	push   $0x5
  801889:	e8 7b ff ff ff       	call   801809 <syscall>
  80188e:	83 c4 18             	add    $0x18,%esp
}
  801891:	c9                   	leave  
  801892:	c3                   	ret    

00801893 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801893:	55                   	push   %ebp
  801894:	89 e5                	mov    %esp,%ebp
  801896:	56                   	push   %esi
  801897:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801898:	8b 75 18             	mov    0x18(%ebp),%esi
  80189b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80189e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a7:	56                   	push   %esi
  8018a8:	53                   	push   %ebx
  8018a9:	51                   	push   %ecx
  8018aa:	52                   	push   %edx
  8018ab:	50                   	push   %eax
  8018ac:	6a 06                	push   $0x6
  8018ae:	e8 56 ff ff ff       	call   801809 <syscall>
  8018b3:	83 c4 18             	add    $0x18,%esp
}
  8018b6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018b9:	5b                   	pop    %ebx
  8018ba:	5e                   	pop    %esi
  8018bb:	5d                   	pop    %ebp
  8018bc:	c3                   	ret    

008018bd <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8018bd:	55                   	push   %ebp
  8018be:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8018c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c6:	6a 00                	push   $0x0
  8018c8:	6a 00                	push   $0x0
  8018ca:	6a 00                	push   $0x0
  8018cc:	52                   	push   %edx
  8018cd:	50                   	push   %eax
  8018ce:	6a 07                	push   $0x7
  8018d0:	e8 34 ff ff ff       	call   801809 <syscall>
  8018d5:	83 c4 18             	add    $0x18,%esp
}
  8018d8:	c9                   	leave  
  8018d9:	c3                   	ret    

008018da <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8018da:	55                   	push   %ebp
  8018db:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8018dd:	6a 00                	push   $0x0
  8018df:	6a 00                	push   $0x0
  8018e1:	6a 00                	push   $0x0
  8018e3:	ff 75 0c             	pushl  0xc(%ebp)
  8018e6:	ff 75 08             	pushl  0x8(%ebp)
  8018e9:	6a 08                	push   $0x8
  8018eb:	e8 19 ff ff ff       	call   801809 <syscall>
  8018f0:	83 c4 18             	add    $0x18,%esp
}
  8018f3:	c9                   	leave  
  8018f4:	c3                   	ret    

008018f5 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8018f5:	55                   	push   %ebp
  8018f6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8018f8:	6a 00                	push   $0x0
  8018fa:	6a 00                	push   $0x0
  8018fc:	6a 00                	push   $0x0
  8018fe:	6a 00                	push   $0x0
  801900:	6a 00                	push   $0x0
  801902:	6a 09                	push   $0x9
  801904:	e8 00 ff ff ff       	call   801809 <syscall>
  801909:	83 c4 18             	add    $0x18,%esp
}
  80190c:	c9                   	leave  
  80190d:	c3                   	ret    

0080190e <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80190e:	55                   	push   %ebp
  80190f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801911:	6a 00                	push   $0x0
  801913:	6a 00                	push   $0x0
  801915:	6a 00                	push   $0x0
  801917:	6a 00                	push   $0x0
  801919:	6a 00                	push   $0x0
  80191b:	6a 0a                	push   $0xa
  80191d:	e8 e7 fe ff ff       	call   801809 <syscall>
  801922:	83 c4 18             	add    $0x18,%esp
}
  801925:	c9                   	leave  
  801926:	c3                   	ret    

00801927 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801927:	55                   	push   %ebp
  801928:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80192a:	6a 00                	push   $0x0
  80192c:	6a 00                	push   $0x0
  80192e:	6a 00                	push   $0x0
  801930:	6a 00                	push   $0x0
  801932:	6a 00                	push   $0x0
  801934:	6a 0b                	push   $0xb
  801936:	e8 ce fe ff ff       	call   801809 <syscall>
  80193b:	83 c4 18             	add    $0x18,%esp
}
  80193e:	c9                   	leave  
  80193f:	c3                   	ret    

00801940 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801940:	55                   	push   %ebp
  801941:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801943:	6a 00                	push   $0x0
  801945:	6a 00                	push   $0x0
  801947:	6a 00                	push   $0x0
  801949:	ff 75 0c             	pushl  0xc(%ebp)
  80194c:	ff 75 08             	pushl  0x8(%ebp)
  80194f:	6a 0f                	push   $0xf
  801951:	e8 b3 fe ff ff       	call   801809 <syscall>
  801956:	83 c4 18             	add    $0x18,%esp
	return;
  801959:	90                   	nop
}
  80195a:	c9                   	leave  
  80195b:	c3                   	ret    

0080195c <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80195c:	55                   	push   %ebp
  80195d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80195f:	6a 00                	push   $0x0
  801961:	6a 00                	push   $0x0
  801963:	6a 00                	push   $0x0
  801965:	ff 75 0c             	pushl  0xc(%ebp)
  801968:	ff 75 08             	pushl  0x8(%ebp)
  80196b:	6a 10                	push   $0x10
  80196d:	e8 97 fe ff ff       	call   801809 <syscall>
  801972:	83 c4 18             	add    $0x18,%esp
	return ;
  801975:	90                   	nop
}
  801976:	c9                   	leave  
  801977:	c3                   	ret    

00801978 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801978:	55                   	push   %ebp
  801979:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80197b:	6a 00                	push   $0x0
  80197d:	6a 00                	push   $0x0
  80197f:	ff 75 10             	pushl  0x10(%ebp)
  801982:	ff 75 0c             	pushl  0xc(%ebp)
  801985:	ff 75 08             	pushl  0x8(%ebp)
  801988:	6a 11                	push   $0x11
  80198a:	e8 7a fe ff ff       	call   801809 <syscall>
  80198f:	83 c4 18             	add    $0x18,%esp
	return ;
  801992:	90                   	nop
}
  801993:	c9                   	leave  
  801994:	c3                   	ret    

00801995 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801995:	55                   	push   %ebp
  801996:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801998:	6a 00                	push   $0x0
  80199a:	6a 00                	push   $0x0
  80199c:	6a 00                	push   $0x0
  80199e:	6a 00                	push   $0x0
  8019a0:	6a 00                	push   $0x0
  8019a2:	6a 0c                	push   $0xc
  8019a4:	e8 60 fe ff ff       	call   801809 <syscall>
  8019a9:	83 c4 18             	add    $0x18,%esp
}
  8019ac:	c9                   	leave  
  8019ad:	c3                   	ret    

008019ae <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8019ae:	55                   	push   %ebp
  8019af:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8019b1:	6a 00                	push   $0x0
  8019b3:	6a 00                	push   $0x0
  8019b5:	6a 00                	push   $0x0
  8019b7:	6a 00                	push   $0x0
  8019b9:	ff 75 08             	pushl  0x8(%ebp)
  8019bc:	6a 0d                	push   $0xd
  8019be:	e8 46 fe ff ff       	call   801809 <syscall>
  8019c3:	83 c4 18             	add    $0x18,%esp
}
  8019c6:	c9                   	leave  
  8019c7:	c3                   	ret    

008019c8 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8019c8:	55                   	push   %ebp
  8019c9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8019cb:	6a 00                	push   $0x0
  8019cd:	6a 00                	push   $0x0
  8019cf:	6a 00                	push   $0x0
  8019d1:	6a 00                	push   $0x0
  8019d3:	6a 00                	push   $0x0
  8019d5:	6a 0e                	push   $0xe
  8019d7:	e8 2d fe ff ff       	call   801809 <syscall>
  8019dc:	83 c4 18             	add    $0x18,%esp
}
  8019df:	90                   	nop
  8019e0:	c9                   	leave  
  8019e1:	c3                   	ret    

008019e2 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8019e2:	55                   	push   %ebp
  8019e3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8019e5:	6a 00                	push   $0x0
  8019e7:	6a 00                	push   $0x0
  8019e9:	6a 00                	push   $0x0
  8019eb:	6a 00                	push   $0x0
  8019ed:	6a 00                	push   $0x0
  8019ef:	6a 13                	push   $0x13
  8019f1:	e8 13 fe ff ff       	call   801809 <syscall>
  8019f6:	83 c4 18             	add    $0x18,%esp
}
  8019f9:	90                   	nop
  8019fa:	c9                   	leave  
  8019fb:	c3                   	ret    

008019fc <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8019fc:	55                   	push   %ebp
  8019fd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8019ff:	6a 00                	push   $0x0
  801a01:	6a 00                	push   $0x0
  801a03:	6a 00                	push   $0x0
  801a05:	6a 00                	push   $0x0
  801a07:	6a 00                	push   $0x0
  801a09:	6a 14                	push   $0x14
  801a0b:	e8 f9 fd ff ff       	call   801809 <syscall>
  801a10:	83 c4 18             	add    $0x18,%esp
}
  801a13:	90                   	nop
  801a14:	c9                   	leave  
  801a15:	c3                   	ret    

00801a16 <sys_cputc>:


void
sys_cputc(const char c)
{
  801a16:	55                   	push   %ebp
  801a17:	89 e5                	mov    %esp,%ebp
  801a19:	83 ec 04             	sub    $0x4,%esp
  801a1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801a22:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a26:	6a 00                	push   $0x0
  801a28:	6a 00                	push   $0x0
  801a2a:	6a 00                	push   $0x0
  801a2c:	6a 00                	push   $0x0
  801a2e:	50                   	push   %eax
  801a2f:	6a 15                	push   $0x15
  801a31:	e8 d3 fd ff ff       	call   801809 <syscall>
  801a36:	83 c4 18             	add    $0x18,%esp
}
  801a39:	90                   	nop
  801a3a:	c9                   	leave  
  801a3b:	c3                   	ret    

00801a3c <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a3c:	55                   	push   %ebp
  801a3d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a3f:	6a 00                	push   $0x0
  801a41:	6a 00                	push   $0x0
  801a43:	6a 00                	push   $0x0
  801a45:	6a 00                	push   $0x0
  801a47:	6a 00                	push   $0x0
  801a49:	6a 16                	push   $0x16
  801a4b:	e8 b9 fd ff ff       	call   801809 <syscall>
  801a50:	83 c4 18             	add    $0x18,%esp
}
  801a53:	90                   	nop
  801a54:	c9                   	leave  
  801a55:	c3                   	ret    

00801a56 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801a56:	55                   	push   %ebp
  801a57:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801a59:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5c:	6a 00                	push   $0x0
  801a5e:	6a 00                	push   $0x0
  801a60:	6a 00                	push   $0x0
  801a62:	ff 75 0c             	pushl  0xc(%ebp)
  801a65:	50                   	push   %eax
  801a66:	6a 17                	push   $0x17
  801a68:	e8 9c fd ff ff       	call   801809 <syscall>
  801a6d:	83 c4 18             	add    $0x18,%esp
}
  801a70:	c9                   	leave  
  801a71:	c3                   	ret    

00801a72 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801a72:	55                   	push   %ebp
  801a73:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a75:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a78:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7b:	6a 00                	push   $0x0
  801a7d:	6a 00                	push   $0x0
  801a7f:	6a 00                	push   $0x0
  801a81:	52                   	push   %edx
  801a82:	50                   	push   %eax
  801a83:	6a 1a                	push   $0x1a
  801a85:	e8 7f fd ff ff       	call   801809 <syscall>
  801a8a:	83 c4 18             	add    $0x18,%esp
}
  801a8d:	c9                   	leave  
  801a8e:	c3                   	ret    

00801a8f <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a8f:	55                   	push   %ebp
  801a90:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a92:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a95:	8b 45 08             	mov    0x8(%ebp),%eax
  801a98:	6a 00                	push   $0x0
  801a9a:	6a 00                	push   $0x0
  801a9c:	6a 00                	push   $0x0
  801a9e:	52                   	push   %edx
  801a9f:	50                   	push   %eax
  801aa0:	6a 18                	push   $0x18
  801aa2:	e8 62 fd ff ff       	call   801809 <syscall>
  801aa7:	83 c4 18             	add    $0x18,%esp
}
  801aaa:	90                   	nop
  801aab:	c9                   	leave  
  801aac:	c3                   	ret    

00801aad <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801aad:	55                   	push   %ebp
  801aae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ab0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ab3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab6:	6a 00                	push   $0x0
  801ab8:	6a 00                	push   $0x0
  801aba:	6a 00                	push   $0x0
  801abc:	52                   	push   %edx
  801abd:	50                   	push   %eax
  801abe:	6a 19                	push   $0x19
  801ac0:	e8 44 fd ff ff       	call   801809 <syscall>
  801ac5:	83 c4 18             	add    $0x18,%esp
}
  801ac8:	90                   	nop
  801ac9:	c9                   	leave  
  801aca:	c3                   	ret    

00801acb <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801acb:	55                   	push   %ebp
  801acc:	89 e5                	mov    %esp,%ebp
  801ace:	83 ec 04             	sub    $0x4,%esp
  801ad1:	8b 45 10             	mov    0x10(%ebp),%eax
  801ad4:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801ad7:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801ada:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ade:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae1:	6a 00                	push   $0x0
  801ae3:	51                   	push   %ecx
  801ae4:	52                   	push   %edx
  801ae5:	ff 75 0c             	pushl  0xc(%ebp)
  801ae8:	50                   	push   %eax
  801ae9:	6a 1b                	push   $0x1b
  801aeb:	e8 19 fd ff ff       	call   801809 <syscall>
  801af0:	83 c4 18             	add    $0x18,%esp
}
  801af3:	c9                   	leave  
  801af4:	c3                   	ret    

00801af5 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801af5:	55                   	push   %ebp
  801af6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801af8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801afb:	8b 45 08             	mov    0x8(%ebp),%eax
  801afe:	6a 00                	push   $0x0
  801b00:	6a 00                	push   $0x0
  801b02:	6a 00                	push   $0x0
  801b04:	52                   	push   %edx
  801b05:	50                   	push   %eax
  801b06:	6a 1c                	push   $0x1c
  801b08:	e8 fc fc ff ff       	call   801809 <syscall>
  801b0d:	83 c4 18             	add    $0x18,%esp
}
  801b10:	c9                   	leave  
  801b11:	c3                   	ret    

00801b12 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801b12:	55                   	push   %ebp
  801b13:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801b15:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b18:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b1e:	6a 00                	push   $0x0
  801b20:	6a 00                	push   $0x0
  801b22:	51                   	push   %ecx
  801b23:	52                   	push   %edx
  801b24:	50                   	push   %eax
  801b25:	6a 1d                	push   $0x1d
  801b27:	e8 dd fc ff ff       	call   801809 <syscall>
  801b2c:	83 c4 18             	add    $0x18,%esp
}
  801b2f:	c9                   	leave  
  801b30:	c3                   	ret    

00801b31 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801b31:	55                   	push   %ebp
  801b32:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b34:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b37:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3a:	6a 00                	push   $0x0
  801b3c:	6a 00                	push   $0x0
  801b3e:	6a 00                	push   $0x0
  801b40:	52                   	push   %edx
  801b41:	50                   	push   %eax
  801b42:	6a 1e                	push   $0x1e
  801b44:	e8 c0 fc ff ff       	call   801809 <syscall>
  801b49:	83 c4 18             	add    $0x18,%esp
}
  801b4c:	c9                   	leave  
  801b4d:	c3                   	ret    

00801b4e <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801b4e:	55                   	push   %ebp
  801b4f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801b51:	6a 00                	push   $0x0
  801b53:	6a 00                	push   $0x0
  801b55:	6a 00                	push   $0x0
  801b57:	6a 00                	push   $0x0
  801b59:	6a 00                	push   $0x0
  801b5b:	6a 1f                	push   $0x1f
  801b5d:	e8 a7 fc ff ff       	call   801809 <syscall>
  801b62:	83 c4 18             	add    $0x18,%esp
}
  801b65:	c9                   	leave  
  801b66:	c3                   	ret    

00801b67 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801b67:	55                   	push   %ebp
  801b68:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801b6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6d:	6a 00                	push   $0x0
  801b6f:	ff 75 14             	pushl  0x14(%ebp)
  801b72:	ff 75 10             	pushl  0x10(%ebp)
  801b75:	ff 75 0c             	pushl  0xc(%ebp)
  801b78:	50                   	push   %eax
  801b79:	6a 20                	push   $0x20
  801b7b:	e8 89 fc ff ff       	call   801809 <syscall>
  801b80:	83 c4 18             	add    $0x18,%esp
}
  801b83:	c9                   	leave  
  801b84:	c3                   	ret    

00801b85 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801b85:	55                   	push   %ebp
  801b86:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801b88:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8b:	6a 00                	push   $0x0
  801b8d:	6a 00                	push   $0x0
  801b8f:	6a 00                	push   $0x0
  801b91:	6a 00                	push   $0x0
  801b93:	50                   	push   %eax
  801b94:	6a 21                	push   $0x21
  801b96:	e8 6e fc ff ff       	call   801809 <syscall>
  801b9b:	83 c4 18             	add    $0x18,%esp
}
  801b9e:	90                   	nop
  801b9f:	c9                   	leave  
  801ba0:	c3                   	ret    

00801ba1 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801ba1:	55                   	push   %ebp
  801ba2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801ba4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba7:	6a 00                	push   $0x0
  801ba9:	6a 00                	push   $0x0
  801bab:	6a 00                	push   $0x0
  801bad:	6a 00                	push   $0x0
  801baf:	50                   	push   %eax
  801bb0:	6a 22                	push   $0x22
  801bb2:	e8 52 fc ff ff       	call   801809 <syscall>
  801bb7:	83 c4 18             	add    $0x18,%esp
}
  801bba:	c9                   	leave  
  801bbb:	c3                   	ret    

00801bbc <sys_getenvid>:

int32 sys_getenvid(void)
{
  801bbc:	55                   	push   %ebp
  801bbd:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801bbf:	6a 00                	push   $0x0
  801bc1:	6a 00                	push   $0x0
  801bc3:	6a 00                	push   $0x0
  801bc5:	6a 00                	push   $0x0
  801bc7:	6a 00                	push   $0x0
  801bc9:	6a 02                	push   $0x2
  801bcb:	e8 39 fc ff ff       	call   801809 <syscall>
  801bd0:	83 c4 18             	add    $0x18,%esp
}
  801bd3:	c9                   	leave  
  801bd4:	c3                   	ret    

00801bd5 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801bd5:	55                   	push   %ebp
  801bd6:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801bd8:	6a 00                	push   $0x0
  801bda:	6a 00                	push   $0x0
  801bdc:	6a 00                	push   $0x0
  801bde:	6a 00                	push   $0x0
  801be0:	6a 00                	push   $0x0
  801be2:	6a 03                	push   $0x3
  801be4:	e8 20 fc ff ff       	call   801809 <syscall>
  801be9:	83 c4 18             	add    $0x18,%esp
}
  801bec:	c9                   	leave  
  801bed:	c3                   	ret    

00801bee <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801bee:	55                   	push   %ebp
  801bef:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801bf1:	6a 00                	push   $0x0
  801bf3:	6a 00                	push   $0x0
  801bf5:	6a 00                	push   $0x0
  801bf7:	6a 00                	push   $0x0
  801bf9:	6a 00                	push   $0x0
  801bfb:	6a 04                	push   $0x4
  801bfd:	e8 07 fc ff ff       	call   801809 <syscall>
  801c02:	83 c4 18             	add    $0x18,%esp
}
  801c05:	c9                   	leave  
  801c06:	c3                   	ret    

00801c07 <sys_exit_env>:


void sys_exit_env(void)
{
  801c07:	55                   	push   %ebp
  801c08:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801c0a:	6a 00                	push   $0x0
  801c0c:	6a 00                	push   $0x0
  801c0e:	6a 00                	push   $0x0
  801c10:	6a 00                	push   $0x0
  801c12:	6a 00                	push   $0x0
  801c14:	6a 23                	push   $0x23
  801c16:	e8 ee fb ff ff       	call   801809 <syscall>
  801c1b:	83 c4 18             	add    $0x18,%esp
}
  801c1e:	90                   	nop
  801c1f:	c9                   	leave  
  801c20:	c3                   	ret    

00801c21 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801c21:	55                   	push   %ebp
  801c22:	89 e5                	mov    %esp,%ebp
  801c24:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c27:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c2a:	8d 50 04             	lea    0x4(%eax),%edx
  801c2d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c30:	6a 00                	push   $0x0
  801c32:	6a 00                	push   $0x0
  801c34:	6a 00                	push   $0x0
  801c36:	52                   	push   %edx
  801c37:	50                   	push   %eax
  801c38:	6a 24                	push   $0x24
  801c3a:	e8 ca fb ff ff       	call   801809 <syscall>
  801c3f:	83 c4 18             	add    $0x18,%esp
	return result;
  801c42:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c45:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c48:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c4b:	89 01                	mov    %eax,(%ecx)
  801c4d:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c50:	8b 45 08             	mov    0x8(%ebp),%eax
  801c53:	c9                   	leave  
  801c54:	c2 04 00             	ret    $0x4

00801c57 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c57:	55                   	push   %ebp
  801c58:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801c5a:	6a 00                	push   $0x0
  801c5c:	6a 00                	push   $0x0
  801c5e:	ff 75 10             	pushl  0x10(%ebp)
  801c61:	ff 75 0c             	pushl  0xc(%ebp)
  801c64:	ff 75 08             	pushl  0x8(%ebp)
  801c67:	6a 12                	push   $0x12
  801c69:	e8 9b fb ff ff       	call   801809 <syscall>
  801c6e:	83 c4 18             	add    $0x18,%esp
	return ;
  801c71:	90                   	nop
}
  801c72:	c9                   	leave  
  801c73:	c3                   	ret    

00801c74 <sys_rcr2>:
uint32 sys_rcr2()
{
  801c74:	55                   	push   %ebp
  801c75:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801c77:	6a 00                	push   $0x0
  801c79:	6a 00                	push   $0x0
  801c7b:	6a 00                	push   $0x0
  801c7d:	6a 00                	push   $0x0
  801c7f:	6a 00                	push   $0x0
  801c81:	6a 25                	push   $0x25
  801c83:	e8 81 fb ff ff       	call   801809 <syscall>
  801c88:	83 c4 18             	add    $0x18,%esp
}
  801c8b:	c9                   	leave  
  801c8c:	c3                   	ret    

00801c8d <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801c8d:	55                   	push   %ebp
  801c8e:	89 e5                	mov    %esp,%ebp
  801c90:	83 ec 04             	sub    $0x4,%esp
  801c93:	8b 45 08             	mov    0x8(%ebp),%eax
  801c96:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801c99:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801c9d:	6a 00                	push   $0x0
  801c9f:	6a 00                	push   $0x0
  801ca1:	6a 00                	push   $0x0
  801ca3:	6a 00                	push   $0x0
  801ca5:	50                   	push   %eax
  801ca6:	6a 26                	push   $0x26
  801ca8:	e8 5c fb ff ff       	call   801809 <syscall>
  801cad:	83 c4 18             	add    $0x18,%esp
	return ;
  801cb0:	90                   	nop
}
  801cb1:	c9                   	leave  
  801cb2:	c3                   	ret    

00801cb3 <rsttst>:
void rsttst()
{
  801cb3:	55                   	push   %ebp
  801cb4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801cb6:	6a 00                	push   $0x0
  801cb8:	6a 00                	push   $0x0
  801cba:	6a 00                	push   $0x0
  801cbc:	6a 00                	push   $0x0
  801cbe:	6a 00                	push   $0x0
  801cc0:	6a 28                	push   $0x28
  801cc2:	e8 42 fb ff ff       	call   801809 <syscall>
  801cc7:	83 c4 18             	add    $0x18,%esp
	return ;
  801cca:	90                   	nop
}
  801ccb:	c9                   	leave  
  801ccc:	c3                   	ret    

00801ccd <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801ccd:	55                   	push   %ebp
  801cce:	89 e5                	mov    %esp,%ebp
  801cd0:	83 ec 04             	sub    $0x4,%esp
  801cd3:	8b 45 14             	mov    0x14(%ebp),%eax
  801cd6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801cd9:	8b 55 18             	mov    0x18(%ebp),%edx
  801cdc:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ce0:	52                   	push   %edx
  801ce1:	50                   	push   %eax
  801ce2:	ff 75 10             	pushl  0x10(%ebp)
  801ce5:	ff 75 0c             	pushl  0xc(%ebp)
  801ce8:	ff 75 08             	pushl  0x8(%ebp)
  801ceb:	6a 27                	push   $0x27
  801ced:	e8 17 fb ff ff       	call   801809 <syscall>
  801cf2:	83 c4 18             	add    $0x18,%esp
	return ;
  801cf5:	90                   	nop
}
  801cf6:	c9                   	leave  
  801cf7:	c3                   	ret    

00801cf8 <chktst>:
void chktst(uint32 n)
{
  801cf8:	55                   	push   %ebp
  801cf9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801cfb:	6a 00                	push   $0x0
  801cfd:	6a 00                	push   $0x0
  801cff:	6a 00                	push   $0x0
  801d01:	6a 00                	push   $0x0
  801d03:	ff 75 08             	pushl  0x8(%ebp)
  801d06:	6a 29                	push   $0x29
  801d08:	e8 fc fa ff ff       	call   801809 <syscall>
  801d0d:	83 c4 18             	add    $0x18,%esp
	return ;
  801d10:	90                   	nop
}
  801d11:	c9                   	leave  
  801d12:	c3                   	ret    

00801d13 <inctst>:

void inctst()
{
  801d13:	55                   	push   %ebp
  801d14:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d16:	6a 00                	push   $0x0
  801d18:	6a 00                	push   $0x0
  801d1a:	6a 00                	push   $0x0
  801d1c:	6a 00                	push   $0x0
  801d1e:	6a 00                	push   $0x0
  801d20:	6a 2a                	push   $0x2a
  801d22:	e8 e2 fa ff ff       	call   801809 <syscall>
  801d27:	83 c4 18             	add    $0x18,%esp
	return ;
  801d2a:	90                   	nop
}
  801d2b:	c9                   	leave  
  801d2c:	c3                   	ret    

00801d2d <gettst>:
uint32 gettst()
{
  801d2d:	55                   	push   %ebp
  801d2e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d30:	6a 00                	push   $0x0
  801d32:	6a 00                	push   $0x0
  801d34:	6a 00                	push   $0x0
  801d36:	6a 00                	push   $0x0
  801d38:	6a 00                	push   $0x0
  801d3a:	6a 2b                	push   $0x2b
  801d3c:	e8 c8 fa ff ff       	call   801809 <syscall>
  801d41:	83 c4 18             	add    $0x18,%esp
}
  801d44:	c9                   	leave  
  801d45:	c3                   	ret    

00801d46 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d46:	55                   	push   %ebp
  801d47:	89 e5                	mov    %esp,%ebp
  801d49:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d4c:	6a 00                	push   $0x0
  801d4e:	6a 00                	push   $0x0
  801d50:	6a 00                	push   $0x0
  801d52:	6a 00                	push   $0x0
  801d54:	6a 00                	push   $0x0
  801d56:	6a 2c                	push   $0x2c
  801d58:	e8 ac fa ff ff       	call   801809 <syscall>
  801d5d:	83 c4 18             	add    $0x18,%esp
  801d60:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801d63:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801d67:	75 07                	jne    801d70 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801d69:	b8 01 00 00 00       	mov    $0x1,%eax
  801d6e:	eb 05                	jmp    801d75 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801d70:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d75:	c9                   	leave  
  801d76:	c3                   	ret    

00801d77 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801d77:	55                   	push   %ebp
  801d78:	89 e5                	mov    %esp,%ebp
  801d7a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d7d:	6a 00                	push   $0x0
  801d7f:	6a 00                	push   $0x0
  801d81:	6a 00                	push   $0x0
  801d83:	6a 00                	push   $0x0
  801d85:	6a 00                	push   $0x0
  801d87:	6a 2c                	push   $0x2c
  801d89:	e8 7b fa ff ff       	call   801809 <syscall>
  801d8e:	83 c4 18             	add    $0x18,%esp
  801d91:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801d94:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801d98:	75 07                	jne    801da1 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801d9a:	b8 01 00 00 00       	mov    $0x1,%eax
  801d9f:	eb 05                	jmp    801da6 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801da1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801da6:	c9                   	leave  
  801da7:	c3                   	ret    

00801da8 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801da8:	55                   	push   %ebp
  801da9:	89 e5                	mov    %esp,%ebp
  801dab:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dae:	6a 00                	push   $0x0
  801db0:	6a 00                	push   $0x0
  801db2:	6a 00                	push   $0x0
  801db4:	6a 00                	push   $0x0
  801db6:	6a 00                	push   $0x0
  801db8:	6a 2c                	push   $0x2c
  801dba:	e8 4a fa ff ff       	call   801809 <syscall>
  801dbf:	83 c4 18             	add    $0x18,%esp
  801dc2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801dc5:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801dc9:	75 07                	jne    801dd2 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801dcb:	b8 01 00 00 00       	mov    $0x1,%eax
  801dd0:	eb 05                	jmp    801dd7 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801dd2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dd7:	c9                   	leave  
  801dd8:	c3                   	ret    

00801dd9 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801dd9:	55                   	push   %ebp
  801dda:	89 e5                	mov    %esp,%ebp
  801ddc:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ddf:	6a 00                	push   $0x0
  801de1:	6a 00                	push   $0x0
  801de3:	6a 00                	push   $0x0
  801de5:	6a 00                	push   $0x0
  801de7:	6a 00                	push   $0x0
  801de9:	6a 2c                	push   $0x2c
  801deb:	e8 19 fa ff ff       	call   801809 <syscall>
  801df0:	83 c4 18             	add    $0x18,%esp
  801df3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801df6:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801dfa:	75 07                	jne    801e03 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801dfc:	b8 01 00 00 00       	mov    $0x1,%eax
  801e01:	eb 05                	jmp    801e08 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801e03:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e08:	c9                   	leave  
  801e09:	c3                   	ret    

00801e0a <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801e0a:	55                   	push   %ebp
  801e0b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e0d:	6a 00                	push   $0x0
  801e0f:	6a 00                	push   $0x0
  801e11:	6a 00                	push   $0x0
  801e13:	6a 00                	push   $0x0
  801e15:	ff 75 08             	pushl  0x8(%ebp)
  801e18:	6a 2d                	push   $0x2d
  801e1a:	e8 ea f9 ff ff       	call   801809 <syscall>
  801e1f:	83 c4 18             	add    $0x18,%esp
	return ;
  801e22:	90                   	nop
}
  801e23:	c9                   	leave  
  801e24:	c3                   	ret    

00801e25 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e25:	55                   	push   %ebp
  801e26:	89 e5                	mov    %esp,%ebp
  801e28:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e29:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e2c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e2f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e32:	8b 45 08             	mov    0x8(%ebp),%eax
  801e35:	6a 00                	push   $0x0
  801e37:	53                   	push   %ebx
  801e38:	51                   	push   %ecx
  801e39:	52                   	push   %edx
  801e3a:	50                   	push   %eax
  801e3b:	6a 2e                	push   $0x2e
  801e3d:	e8 c7 f9 ff ff       	call   801809 <syscall>
  801e42:	83 c4 18             	add    $0x18,%esp
}
  801e45:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e48:	c9                   	leave  
  801e49:	c3                   	ret    

00801e4a <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e4a:	55                   	push   %ebp
  801e4b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e4d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e50:	8b 45 08             	mov    0x8(%ebp),%eax
  801e53:	6a 00                	push   $0x0
  801e55:	6a 00                	push   $0x0
  801e57:	6a 00                	push   $0x0
  801e59:	52                   	push   %edx
  801e5a:	50                   	push   %eax
  801e5b:	6a 2f                	push   $0x2f
  801e5d:	e8 a7 f9 ff ff       	call   801809 <syscall>
  801e62:	83 c4 18             	add    $0x18,%esp
}
  801e65:	c9                   	leave  
  801e66:	c3                   	ret    

00801e67 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801e67:	55                   	push   %ebp
  801e68:	89 e5                	mov    %esp,%ebp
  801e6a:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801e6d:	83 ec 0c             	sub    $0xc,%esp
  801e70:	68 d8 40 80 00       	push   $0x8040d8
  801e75:	e8 d3 e8 ff ff       	call   80074d <cprintf>
  801e7a:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801e7d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801e84:	83 ec 0c             	sub    $0xc,%esp
  801e87:	68 04 41 80 00       	push   $0x804104
  801e8c:	e8 bc e8 ff ff       	call   80074d <cprintf>
  801e91:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801e94:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801e98:	a1 38 51 80 00       	mov    0x805138,%eax
  801e9d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ea0:	eb 56                	jmp    801ef8 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801ea2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801ea6:	74 1c                	je     801ec4 <print_mem_block_lists+0x5d>
  801ea8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eab:	8b 50 08             	mov    0x8(%eax),%edx
  801eae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801eb1:	8b 48 08             	mov    0x8(%eax),%ecx
  801eb4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801eb7:	8b 40 0c             	mov    0xc(%eax),%eax
  801eba:	01 c8                	add    %ecx,%eax
  801ebc:	39 c2                	cmp    %eax,%edx
  801ebe:	73 04                	jae    801ec4 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801ec0:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801ec4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ec7:	8b 50 08             	mov    0x8(%eax),%edx
  801eca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ecd:	8b 40 0c             	mov    0xc(%eax),%eax
  801ed0:	01 c2                	add    %eax,%edx
  801ed2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ed5:	8b 40 08             	mov    0x8(%eax),%eax
  801ed8:	83 ec 04             	sub    $0x4,%esp
  801edb:	52                   	push   %edx
  801edc:	50                   	push   %eax
  801edd:	68 19 41 80 00       	push   $0x804119
  801ee2:	e8 66 e8 ff ff       	call   80074d <cprintf>
  801ee7:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801eea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eed:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801ef0:	a1 40 51 80 00       	mov    0x805140,%eax
  801ef5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ef8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801efc:	74 07                	je     801f05 <print_mem_block_lists+0x9e>
  801efe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f01:	8b 00                	mov    (%eax),%eax
  801f03:	eb 05                	jmp    801f0a <print_mem_block_lists+0xa3>
  801f05:	b8 00 00 00 00       	mov    $0x0,%eax
  801f0a:	a3 40 51 80 00       	mov    %eax,0x805140
  801f0f:	a1 40 51 80 00       	mov    0x805140,%eax
  801f14:	85 c0                	test   %eax,%eax
  801f16:	75 8a                	jne    801ea2 <print_mem_block_lists+0x3b>
  801f18:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f1c:	75 84                	jne    801ea2 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801f1e:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f22:	75 10                	jne    801f34 <print_mem_block_lists+0xcd>
  801f24:	83 ec 0c             	sub    $0xc,%esp
  801f27:	68 28 41 80 00       	push   $0x804128
  801f2c:	e8 1c e8 ff ff       	call   80074d <cprintf>
  801f31:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801f34:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801f3b:	83 ec 0c             	sub    $0xc,%esp
  801f3e:	68 4c 41 80 00       	push   $0x80414c
  801f43:	e8 05 e8 ff ff       	call   80074d <cprintf>
  801f48:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801f4b:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f4f:	a1 40 50 80 00       	mov    0x805040,%eax
  801f54:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f57:	eb 56                	jmp    801faf <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f59:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f5d:	74 1c                	je     801f7b <print_mem_block_lists+0x114>
  801f5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f62:	8b 50 08             	mov    0x8(%eax),%edx
  801f65:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f68:	8b 48 08             	mov    0x8(%eax),%ecx
  801f6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f6e:	8b 40 0c             	mov    0xc(%eax),%eax
  801f71:	01 c8                	add    %ecx,%eax
  801f73:	39 c2                	cmp    %eax,%edx
  801f75:	73 04                	jae    801f7b <print_mem_block_lists+0x114>
			sorted = 0 ;
  801f77:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f7e:	8b 50 08             	mov    0x8(%eax),%edx
  801f81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f84:	8b 40 0c             	mov    0xc(%eax),%eax
  801f87:	01 c2                	add    %eax,%edx
  801f89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f8c:	8b 40 08             	mov    0x8(%eax),%eax
  801f8f:	83 ec 04             	sub    $0x4,%esp
  801f92:	52                   	push   %edx
  801f93:	50                   	push   %eax
  801f94:	68 19 41 80 00       	push   $0x804119
  801f99:	e8 af e7 ff ff       	call   80074d <cprintf>
  801f9e:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801fa1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fa4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801fa7:	a1 48 50 80 00       	mov    0x805048,%eax
  801fac:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801faf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fb3:	74 07                	je     801fbc <print_mem_block_lists+0x155>
  801fb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb8:	8b 00                	mov    (%eax),%eax
  801fba:	eb 05                	jmp    801fc1 <print_mem_block_lists+0x15a>
  801fbc:	b8 00 00 00 00       	mov    $0x0,%eax
  801fc1:	a3 48 50 80 00       	mov    %eax,0x805048
  801fc6:	a1 48 50 80 00       	mov    0x805048,%eax
  801fcb:	85 c0                	test   %eax,%eax
  801fcd:	75 8a                	jne    801f59 <print_mem_block_lists+0xf2>
  801fcf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fd3:	75 84                	jne    801f59 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801fd5:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801fd9:	75 10                	jne    801feb <print_mem_block_lists+0x184>
  801fdb:	83 ec 0c             	sub    $0xc,%esp
  801fde:	68 64 41 80 00       	push   $0x804164
  801fe3:	e8 65 e7 ff ff       	call   80074d <cprintf>
  801fe8:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801feb:	83 ec 0c             	sub    $0xc,%esp
  801fee:	68 d8 40 80 00       	push   $0x8040d8
  801ff3:	e8 55 e7 ff ff       	call   80074d <cprintf>
  801ff8:	83 c4 10             	add    $0x10,%esp

}
  801ffb:	90                   	nop
  801ffc:	c9                   	leave  
  801ffd:	c3                   	ret    

00801ffe <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801ffe:	55                   	push   %ebp
  801fff:	89 e5                	mov    %esp,%ebp
  802001:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  802004:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  80200b:	00 00 00 
  80200e:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802015:	00 00 00 
  802018:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  80201f:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  802022:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802029:	e9 9e 00 00 00       	jmp    8020cc <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  80202e:	a1 50 50 80 00       	mov    0x805050,%eax
  802033:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802036:	c1 e2 04             	shl    $0x4,%edx
  802039:	01 d0                	add    %edx,%eax
  80203b:	85 c0                	test   %eax,%eax
  80203d:	75 14                	jne    802053 <initialize_MemBlocksList+0x55>
  80203f:	83 ec 04             	sub    $0x4,%esp
  802042:	68 8c 41 80 00       	push   $0x80418c
  802047:	6a 46                	push   $0x46
  802049:	68 af 41 80 00       	push   $0x8041af
  80204e:	e8 46 e4 ff ff       	call   800499 <_panic>
  802053:	a1 50 50 80 00       	mov    0x805050,%eax
  802058:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80205b:	c1 e2 04             	shl    $0x4,%edx
  80205e:	01 d0                	add    %edx,%eax
  802060:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802066:	89 10                	mov    %edx,(%eax)
  802068:	8b 00                	mov    (%eax),%eax
  80206a:	85 c0                	test   %eax,%eax
  80206c:	74 18                	je     802086 <initialize_MemBlocksList+0x88>
  80206e:	a1 48 51 80 00       	mov    0x805148,%eax
  802073:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802079:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80207c:	c1 e1 04             	shl    $0x4,%ecx
  80207f:	01 ca                	add    %ecx,%edx
  802081:	89 50 04             	mov    %edx,0x4(%eax)
  802084:	eb 12                	jmp    802098 <initialize_MemBlocksList+0x9a>
  802086:	a1 50 50 80 00       	mov    0x805050,%eax
  80208b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80208e:	c1 e2 04             	shl    $0x4,%edx
  802091:	01 d0                	add    %edx,%eax
  802093:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802098:	a1 50 50 80 00       	mov    0x805050,%eax
  80209d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020a0:	c1 e2 04             	shl    $0x4,%edx
  8020a3:	01 d0                	add    %edx,%eax
  8020a5:	a3 48 51 80 00       	mov    %eax,0x805148
  8020aa:	a1 50 50 80 00       	mov    0x805050,%eax
  8020af:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020b2:	c1 e2 04             	shl    $0x4,%edx
  8020b5:	01 d0                	add    %edx,%eax
  8020b7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020be:	a1 54 51 80 00       	mov    0x805154,%eax
  8020c3:	40                   	inc    %eax
  8020c4:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  8020c9:	ff 45 f4             	incl   -0xc(%ebp)
  8020cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020cf:	3b 45 08             	cmp    0x8(%ebp),%eax
  8020d2:	0f 82 56 ff ff ff    	jb     80202e <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  8020d8:	90                   	nop
  8020d9:	c9                   	leave  
  8020da:	c3                   	ret    

008020db <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8020db:	55                   	push   %ebp
  8020dc:	89 e5                	mov    %esp,%ebp
  8020de:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8020e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e4:	8b 00                	mov    (%eax),%eax
  8020e6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8020e9:	eb 19                	jmp    802104 <find_block+0x29>
	{
		if(va==point->sva)
  8020eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020ee:	8b 40 08             	mov    0x8(%eax),%eax
  8020f1:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8020f4:	75 05                	jne    8020fb <find_block+0x20>
		   return point;
  8020f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020f9:	eb 36                	jmp    802131 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8020fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8020fe:	8b 40 08             	mov    0x8(%eax),%eax
  802101:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802104:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802108:	74 07                	je     802111 <find_block+0x36>
  80210a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80210d:	8b 00                	mov    (%eax),%eax
  80210f:	eb 05                	jmp    802116 <find_block+0x3b>
  802111:	b8 00 00 00 00       	mov    $0x0,%eax
  802116:	8b 55 08             	mov    0x8(%ebp),%edx
  802119:	89 42 08             	mov    %eax,0x8(%edx)
  80211c:	8b 45 08             	mov    0x8(%ebp),%eax
  80211f:	8b 40 08             	mov    0x8(%eax),%eax
  802122:	85 c0                	test   %eax,%eax
  802124:	75 c5                	jne    8020eb <find_block+0x10>
  802126:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80212a:	75 bf                	jne    8020eb <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  80212c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802131:	c9                   	leave  
  802132:	c3                   	ret    

00802133 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802133:	55                   	push   %ebp
  802134:	89 e5                	mov    %esp,%ebp
  802136:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  802139:	a1 40 50 80 00       	mov    0x805040,%eax
  80213e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802141:	a1 44 50 80 00       	mov    0x805044,%eax
  802146:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  802149:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80214c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80214f:	74 24                	je     802175 <insert_sorted_allocList+0x42>
  802151:	8b 45 08             	mov    0x8(%ebp),%eax
  802154:	8b 50 08             	mov    0x8(%eax),%edx
  802157:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80215a:	8b 40 08             	mov    0x8(%eax),%eax
  80215d:	39 c2                	cmp    %eax,%edx
  80215f:	76 14                	jbe    802175 <insert_sorted_allocList+0x42>
  802161:	8b 45 08             	mov    0x8(%ebp),%eax
  802164:	8b 50 08             	mov    0x8(%eax),%edx
  802167:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80216a:	8b 40 08             	mov    0x8(%eax),%eax
  80216d:	39 c2                	cmp    %eax,%edx
  80216f:	0f 82 60 01 00 00    	jb     8022d5 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802175:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802179:	75 65                	jne    8021e0 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  80217b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80217f:	75 14                	jne    802195 <insert_sorted_allocList+0x62>
  802181:	83 ec 04             	sub    $0x4,%esp
  802184:	68 8c 41 80 00       	push   $0x80418c
  802189:	6a 6b                	push   $0x6b
  80218b:	68 af 41 80 00       	push   $0x8041af
  802190:	e8 04 e3 ff ff       	call   800499 <_panic>
  802195:	8b 15 40 50 80 00    	mov    0x805040,%edx
  80219b:	8b 45 08             	mov    0x8(%ebp),%eax
  80219e:	89 10                	mov    %edx,(%eax)
  8021a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a3:	8b 00                	mov    (%eax),%eax
  8021a5:	85 c0                	test   %eax,%eax
  8021a7:	74 0d                	je     8021b6 <insert_sorted_allocList+0x83>
  8021a9:	a1 40 50 80 00       	mov    0x805040,%eax
  8021ae:	8b 55 08             	mov    0x8(%ebp),%edx
  8021b1:	89 50 04             	mov    %edx,0x4(%eax)
  8021b4:	eb 08                	jmp    8021be <insert_sorted_allocList+0x8b>
  8021b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b9:	a3 44 50 80 00       	mov    %eax,0x805044
  8021be:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c1:	a3 40 50 80 00       	mov    %eax,0x805040
  8021c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021d0:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8021d5:	40                   	inc    %eax
  8021d6:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8021db:	e9 dc 01 00 00       	jmp    8023bc <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  8021e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e3:	8b 50 08             	mov    0x8(%eax),%edx
  8021e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021e9:	8b 40 08             	mov    0x8(%eax),%eax
  8021ec:	39 c2                	cmp    %eax,%edx
  8021ee:	77 6c                	ja     80225c <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  8021f0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8021f4:	74 06                	je     8021fc <insert_sorted_allocList+0xc9>
  8021f6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021fa:	75 14                	jne    802210 <insert_sorted_allocList+0xdd>
  8021fc:	83 ec 04             	sub    $0x4,%esp
  8021ff:	68 c8 41 80 00       	push   $0x8041c8
  802204:	6a 6f                	push   $0x6f
  802206:	68 af 41 80 00       	push   $0x8041af
  80220b:	e8 89 e2 ff ff       	call   800499 <_panic>
  802210:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802213:	8b 50 04             	mov    0x4(%eax),%edx
  802216:	8b 45 08             	mov    0x8(%ebp),%eax
  802219:	89 50 04             	mov    %edx,0x4(%eax)
  80221c:	8b 45 08             	mov    0x8(%ebp),%eax
  80221f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802222:	89 10                	mov    %edx,(%eax)
  802224:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802227:	8b 40 04             	mov    0x4(%eax),%eax
  80222a:	85 c0                	test   %eax,%eax
  80222c:	74 0d                	je     80223b <insert_sorted_allocList+0x108>
  80222e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802231:	8b 40 04             	mov    0x4(%eax),%eax
  802234:	8b 55 08             	mov    0x8(%ebp),%edx
  802237:	89 10                	mov    %edx,(%eax)
  802239:	eb 08                	jmp    802243 <insert_sorted_allocList+0x110>
  80223b:	8b 45 08             	mov    0x8(%ebp),%eax
  80223e:	a3 40 50 80 00       	mov    %eax,0x805040
  802243:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802246:	8b 55 08             	mov    0x8(%ebp),%edx
  802249:	89 50 04             	mov    %edx,0x4(%eax)
  80224c:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802251:	40                   	inc    %eax
  802252:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802257:	e9 60 01 00 00       	jmp    8023bc <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  80225c:	8b 45 08             	mov    0x8(%ebp),%eax
  80225f:	8b 50 08             	mov    0x8(%eax),%edx
  802262:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802265:	8b 40 08             	mov    0x8(%eax),%eax
  802268:	39 c2                	cmp    %eax,%edx
  80226a:	0f 82 4c 01 00 00    	jb     8023bc <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802270:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802274:	75 14                	jne    80228a <insert_sorted_allocList+0x157>
  802276:	83 ec 04             	sub    $0x4,%esp
  802279:	68 00 42 80 00       	push   $0x804200
  80227e:	6a 73                	push   $0x73
  802280:	68 af 41 80 00       	push   $0x8041af
  802285:	e8 0f e2 ff ff       	call   800499 <_panic>
  80228a:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802290:	8b 45 08             	mov    0x8(%ebp),%eax
  802293:	89 50 04             	mov    %edx,0x4(%eax)
  802296:	8b 45 08             	mov    0x8(%ebp),%eax
  802299:	8b 40 04             	mov    0x4(%eax),%eax
  80229c:	85 c0                	test   %eax,%eax
  80229e:	74 0c                	je     8022ac <insert_sorted_allocList+0x179>
  8022a0:	a1 44 50 80 00       	mov    0x805044,%eax
  8022a5:	8b 55 08             	mov    0x8(%ebp),%edx
  8022a8:	89 10                	mov    %edx,(%eax)
  8022aa:	eb 08                	jmp    8022b4 <insert_sorted_allocList+0x181>
  8022ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8022af:	a3 40 50 80 00       	mov    %eax,0x805040
  8022b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b7:	a3 44 50 80 00       	mov    %eax,0x805044
  8022bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8022bf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022c5:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8022ca:	40                   	inc    %eax
  8022cb:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8022d0:	e9 e7 00 00 00       	jmp    8023bc <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  8022d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  8022db:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8022e2:	a1 40 50 80 00       	mov    0x805040,%eax
  8022e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022ea:	e9 9d 00 00 00       	jmp    80238c <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  8022ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f2:	8b 00                	mov    (%eax),%eax
  8022f4:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  8022f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fa:	8b 50 08             	mov    0x8(%eax),%edx
  8022fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802300:	8b 40 08             	mov    0x8(%eax),%eax
  802303:	39 c2                	cmp    %eax,%edx
  802305:	76 7d                	jbe    802384 <insert_sorted_allocList+0x251>
  802307:	8b 45 08             	mov    0x8(%ebp),%eax
  80230a:	8b 50 08             	mov    0x8(%eax),%edx
  80230d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802310:	8b 40 08             	mov    0x8(%eax),%eax
  802313:	39 c2                	cmp    %eax,%edx
  802315:	73 6d                	jae    802384 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802317:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80231b:	74 06                	je     802323 <insert_sorted_allocList+0x1f0>
  80231d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802321:	75 14                	jne    802337 <insert_sorted_allocList+0x204>
  802323:	83 ec 04             	sub    $0x4,%esp
  802326:	68 24 42 80 00       	push   $0x804224
  80232b:	6a 7f                	push   $0x7f
  80232d:	68 af 41 80 00       	push   $0x8041af
  802332:	e8 62 e1 ff ff       	call   800499 <_panic>
  802337:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80233a:	8b 10                	mov    (%eax),%edx
  80233c:	8b 45 08             	mov    0x8(%ebp),%eax
  80233f:	89 10                	mov    %edx,(%eax)
  802341:	8b 45 08             	mov    0x8(%ebp),%eax
  802344:	8b 00                	mov    (%eax),%eax
  802346:	85 c0                	test   %eax,%eax
  802348:	74 0b                	je     802355 <insert_sorted_allocList+0x222>
  80234a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80234d:	8b 00                	mov    (%eax),%eax
  80234f:	8b 55 08             	mov    0x8(%ebp),%edx
  802352:	89 50 04             	mov    %edx,0x4(%eax)
  802355:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802358:	8b 55 08             	mov    0x8(%ebp),%edx
  80235b:	89 10                	mov    %edx,(%eax)
  80235d:	8b 45 08             	mov    0x8(%ebp),%eax
  802360:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802363:	89 50 04             	mov    %edx,0x4(%eax)
  802366:	8b 45 08             	mov    0x8(%ebp),%eax
  802369:	8b 00                	mov    (%eax),%eax
  80236b:	85 c0                	test   %eax,%eax
  80236d:	75 08                	jne    802377 <insert_sorted_allocList+0x244>
  80236f:	8b 45 08             	mov    0x8(%ebp),%eax
  802372:	a3 44 50 80 00       	mov    %eax,0x805044
  802377:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80237c:	40                   	inc    %eax
  80237d:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802382:	eb 39                	jmp    8023bd <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802384:	a1 48 50 80 00       	mov    0x805048,%eax
  802389:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80238c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802390:	74 07                	je     802399 <insert_sorted_allocList+0x266>
  802392:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802395:	8b 00                	mov    (%eax),%eax
  802397:	eb 05                	jmp    80239e <insert_sorted_allocList+0x26b>
  802399:	b8 00 00 00 00       	mov    $0x0,%eax
  80239e:	a3 48 50 80 00       	mov    %eax,0x805048
  8023a3:	a1 48 50 80 00       	mov    0x805048,%eax
  8023a8:	85 c0                	test   %eax,%eax
  8023aa:	0f 85 3f ff ff ff    	jne    8022ef <insert_sorted_allocList+0x1bc>
  8023b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023b4:	0f 85 35 ff ff ff    	jne    8022ef <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8023ba:	eb 01                	jmp    8023bd <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8023bc:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8023bd:	90                   	nop
  8023be:	c9                   	leave  
  8023bf:	c3                   	ret    

008023c0 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8023c0:	55                   	push   %ebp
  8023c1:	89 e5                	mov    %esp,%ebp
  8023c3:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8023c6:	a1 38 51 80 00       	mov    0x805138,%eax
  8023cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023ce:	e9 85 01 00 00       	jmp    802558 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  8023d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d6:	8b 40 0c             	mov    0xc(%eax),%eax
  8023d9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023dc:	0f 82 6e 01 00 00    	jb     802550 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  8023e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e5:	8b 40 0c             	mov    0xc(%eax),%eax
  8023e8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023eb:	0f 85 8a 00 00 00    	jne    80247b <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  8023f1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023f5:	75 17                	jne    80240e <alloc_block_FF+0x4e>
  8023f7:	83 ec 04             	sub    $0x4,%esp
  8023fa:	68 58 42 80 00       	push   $0x804258
  8023ff:	68 93 00 00 00       	push   $0x93
  802404:	68 af 41 80 00       	push   $0x8041af
  802409:	e8 8b e0 ff ff       	call   800499 <_panic>
  80240e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802411:	8b 00                	mov    (%eax),%eax
  802413:	85 c0                	test   %eax,%eax
  802415:	74 10                	je     802427 <alloc_block_FF+0x67>
  802417:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80241a:	8b 00                	mov    (%eax),%eax
  80241c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80241f:	8b 52 04             	mov    0x4(%edx),%edx
  802422:	89 50 04             	mov    %edx,0x4(%eax)
  802425:	eb 0b                	jmp    802432 <alloc_block_FF+0x72>
  802427:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80242a:	8b 40 04             	mov    0x4(%eax),%eax
  80242d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802432:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802435:	8b 40 04             	mov    0x4(%eax),%eax
  802438:	85 c0                	test   %eax,%eax
  80243a:	74 0f                	je     80244b <alloc_block_FF+0x8b>
  80243c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243f:	8b 40 04             	mov    0x4(%eax),%eax
  802442:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802445:	8b 12                	mov    (%edx),%edx
  802447:	89 10                	mov    %edx,(%eax)
  802449:	eb 0a                	jmp    802455 <alloc_block_FF+0x95>
  80244b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244e:	8b 00                	mov    (%eax),%eax
  802450:	a3 38 51 80 00       	mov    %eax,0x805138
  802455:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802458:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80245e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802461:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802468:	a1 44 51 80 00       	mov    0x805144,%eax
  80246d:	48                   	dec    %eax
  80246e:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802473:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802476:	e9 10 01 00 00       	jmp    80258b <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  80247b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247e:	8b 40 0c             	mov    0xc(%eax),%eax
  802481:	3b 45 08             	cmp    0x8(%ebp),%eax
  802484:	0f 86 c6 00 00 00    	jbe    802550 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80248a:	a1 48 51 80 00       	mov    0x805148,%eax
  80248f:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802492:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802495:	8b 50 08             	mov    0x8(%eax),%edx
  802498:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80249b:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  80249e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024a1:	8b 55 08             	mov    0x8(%ebp),%edx
  8024a4:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8024a7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8024ab:	75 17                	jne    8024c4 <alloc_block_FF+0x104>
  8024ad:	83 ec 04             	sub    $0x4,%esp
  8024b0:	68 58 42 80 00       	push   $0x804258
  8024b5:	68 9b 00 00 00       	push   $0x9b
  8024ba:	68 af 41 80 00       	push   $0x8041af
  8024bf:	e8 d5 df ff ff       	call   800499 <_panic>
  8024c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024c7:	8b 00                	mov    (%eax),%eax
  8024c9:	85 c0                	test   %eax,%eax
  8024cb:	74 10                	je     8024dd <alloc_block_FF+0x11d>
  8024cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024d0:	8b 00                	mov    (%eax),%eax
  8024d2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024d5:	8b 52 04             	mov    0x4(%edx),%edx
  8024d8:	89 50 04             	mov    %edx,0x4(%eax)
  8024db:	eb 0b                	jmp    8024e8 <alloc_block_FF+0x128>
  8024dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024e0:	8b 40 04             	mov    0x4(%eax),%eax
  8024e3:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8024e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024eb:	8b 40 04             	mov    0x4(%eax),%eax
  8024ee:	85 c0                	test   %eax,%eax
  8024f0:	74 0f                	je     802501 <alloc_block_FF+0x141>
  8024f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024f5:	8b 40 04             	mov    0x4(%eax),%eax
  8024f8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024fb:	8b 12                	mov    (%edx),%edx
  8024fd:	89 10                	mov    %edx,(%eax)
  8024ff:	eb 0a                	jmp    80250b <alloc_block_FF+0x14b>
  802501:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802504:	8b 00                	mov    (%eax),%eax
  802506:	a3 48 51 80 00       	mov    %eax,0x805148
  80250b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80250e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802514:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802517:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80251e:	a1 54 51 80 00       	mov    0x805154,%eax
  802523:	48                   	dec    %eax
  802524:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802529:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252c:	8b 50 08             	mov    0x8(%eax),%edx
  80252f:	8b 45 08             	mov    0x8(%ebp),%eax
  802532:	01 c2                	add    %eax,%edx
  802534:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802537:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  80253a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253d:	8b 40 0c             	mov    0xc(%eax),%eax
  802540:	2b 45 08             	sub    0x8(%ebp),%eax
  802543:	89 c2                	mov    %eax,%edx
  802545:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802548:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  80254b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80254e:	eb 3b                	jmp    80258b <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802550:	a1 40 51 80 00       	mov    0x805140,%eax
  802555:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802558:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80255c:	74 07                	je     802565 <alloc_block_FF+0x1a5>
  80255e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802561:	8b 00                	mov    (%eax),%eax
  802563:	eb 05                	jmp    80256a <alloc_block_FF+0x1aa>
  802565:	b8 00 00 00 00       	mov    $0x0,%eax
  80256a:	a3 40 51 80 00       	mov    %eax,0x805140
  80256f:	a1 40 51 80 00       	mov    0x805140,%eax
  802574:	85 c0                	test   %eax,%eax
  802576:	0f 85 57 fe ff ff    	jne    8023d3 <alloc_block_FF+0x13>
  80257c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802580:	0f 85 4d fe ff ff    	jne    8023d3 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802586:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80258b:	c9                   	leave  
  80258c:	c3                   	ret    

0080258d <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  80258d:	55                   	push   %ebp
  80258e:	89 e5                	mov    %esp,%ebp
  802590:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802593:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  80259a:	a1 38 51 80 00       	mov    0x805138,%eax
  80259f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025a2:	e9 df 00 00 00       	jmp    802686 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  8025a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025aa:	8b 40 0c             	mov    0xc(%eax),%eax
  8025ad:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025b0:	0f 82 c8 00 00 00    	jb     80267e <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  8025b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b9:	8b 40 0c             	mov    0xc(%eax),%eax
  8025bc:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025bf:	0f 85 8a 00 00 00    	jne    80264f <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  8025c5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025c9:	75 17                	jne    8025e2 <alloc_block_BF+0x55>
  8025cb:	83 ec 04             	sub    $0x4,%esp
  8025ce:	68 58 42 80 00       	push   $0x804258
  8025d3:	68 b7 00 00 00       	push   $0xb7
  8025d8:	68 af 41 80 00       	push   $0x8041af
  8025dd:	e8 b7 de ff ff       	call   800499 <_panic>
  8025e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e5:	8b 00                	mov    (%eax),%eax
  8025e7:	85 c0                	test   %eax,%eax
  8025e9:	74 10                	je     8025fb <alloc_block_BF+0x6e>
  8025eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ee:	8b 00                	mov    (%eax),%eax
  8025f0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025f3:	8b 52 04             	mov    0x4(%edx),%edx
  8025f6:	89 50 04             	mov    %edx,0x4(%eax)
  8025f9:	eb 0b                	jmp    802606 <alloc_block_BF+0x79>
  8025fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fe:	8b 40 04             	mov    0x4(%eax),%eax
  802601:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802606:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802609:	8b 40 04             	mov    0x4(%eax),%eax
  80260c:	85 c0                	test   %eax,%eax
  80260e:	74 0f                	je     80261f <alloc_block_BF+0x92>
  802610:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802613:	8b 40 04             	mov    0x4(%eax),%eax
  802616:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802619:	8b 12                	mov    (%edx),%edx
  80261b:	89 10                	mov    %edx,(%eax)
  80261d:	eb 0a                	jmp    802629 <alloc_block_BF+0x9c>
  80261f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802622:	8b 00                	mov    (%eax),%eax
  802624:	a3 38 51 80 00       	mov    %eax,0x805138
  802629:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802632:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802635:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80263c:	a1 44 51 80 00       	mov    0x805144,%eax
  802641:	48                   	dec    %eax
  802642:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802647:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264a:	e9 4d 01 00 00       	jmp    80279c <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  80264f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802652:	8b 40 0c             	mov    0xc(%eax),%eax
  802655:	3b 45 08             	cmp    0x8(%ebp),%eax
  802658:	76 24                	jbe    80267e <alloc_block_BF+0xf1>
  80265a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265d:	8b 40 0c             	mov    0xc(%eax),%eax
  802660:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802663:	73 19                	jae    80267e <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802665:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  80266c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266f:	8b 40 0c             	mov    0xc(%eax),%eax
  802672:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802675:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802678:	8b 40 08             	mov    0x8(%eax),%eax
  80267b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  80267e:	a1 40 51 80 00       	mov    0x805140,%eax
  802683:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802686:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80268a:	74 07                	je     802693 <alloc_block_BF+0x106>
  80268c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268f:	8b 00                	mov    (%eax),%eax
  802691:	eb 05                	jmp    802698 <alloc_block_BF+0x10b>
  802693:	b8 00 00 00 00       	mov    $0x0,%eax
  802698:	a3 40 51 80 00       	mov    %eax,0x805140
  80269d:	a1 40 51 80 00       	mov    0x805140,%eax
  8026a2:	85 c0                	test   %eax,%eax
  8026a4:	0f 85 fd fe ff ff    	jne    8025a7 <alloc_block_BF+0x1a>
  8026aa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026ae:	0f 85 f3 fe ff ff    	jne    8025a7 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  8026b4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8026b8:	0f 84 d9 00 00 00    	je     802797 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  8026be:	a1 48 51 80 00       	mov    0x805148,%eax
  8026c3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  8026c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026c9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8026cc:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  8026cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026d2:	8b 55 08             	mov    0x8(%ebp),%edx
  8026d5:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  8026d8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8026dc:	75 17                	jne    8026f5 <alloc_block_BF+0x168>
  8026de:	83 ec 04             	sub    $0x4,%esp
  8026e1:	68 58 42 80 00       	push   $0x804258
  8026e6:	68 c7 00 00 00       	push   $0xc7
  8026eb:	68 af 41 80 00       	push   $0x8041af
  8026f0:	e8 a4 dd ff ff       	call   800499 <_panic>
  8026f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026f8:	8b 00                	mov    (%eax),%eax
  8026fa:	85 c0                	test   %eax,%eax
  8026fc:	74 10                	je     80270e <alloc_block_BF+0x181>
  8026fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802701:	8b 00                	mov    (%eax),%eax
  802703:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802706:	8b 52 04             	mov    0x4(%edx),%edx
  802709:	89 50 04             	mov    %edx,0x4(%eax)
  80270c:	eb 0b                	jmp    802719 <alloc_block_BF+0x18c>
  80270e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802711:	8b 40 04             	mov    0x4(%eax),%eax
  802714:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802719:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80271c:	8b 40 04             	mov    0x4(%eax),%eax
  80271f:	85 c0                	test   %eax,%eax
  802721:	74 0f                	je     802732 <alloc_block_BF+0x1a5>
  802723:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802726:	8b 40 04             	mov    0x4(%eax),%eax
  802729:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80272c:	8b 12                	mov    (%edx),%edx
  80272e:	89 10                	mov    %edx,(%eax)
  802730:	eb 0a                	jmp    80273c <alloc_block_BF+0x1af>
  802732:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802735:	8b 00                	mov    (%eax),%eax
  802737:	a3 48 51 80 00       	mov    %eax,0x805148
  80273c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80273f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802745:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802748:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80274f:	a1 54 51 80 00       	mov    0x805154,%eax
  802754:	48                   	dec    %eax
  802755:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  80275a:	83 ec 08             	sub    $0x8,%esp
  80275d:	ff 75 ec             	pushl  -0x14(%ebp)
  802760:	68 38 51 80 00       	push   $0x805138
  802765:	e8 71 f9 ff ff       	call   8020db <find_block>
  80276a:	83 c4 10             	add    $0x10,%esp
  80276d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802770:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802773:	8b 50 08             	mov    0x8(%eax),%edx
  802776:	8b 45 08             	mov    0x8(%ebp),%eax
  802779:	01 c2                	add    %eax,%edx
  80277b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80277e:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802781:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802784:	8b 40 0c             	mov    0xc(%eax),%eax
  802787:	2b 45 08             	sub    0x8(%ebp),%eax
  80278a:	89 c2                	mov    %eax,%edx
  80278c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80278f:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802792:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802795:	eb 05                	jmp    80279c <alloc_block_BF+0x20f>
	}
	return NULL;
  802797:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80279c:	c9                   	leave  
  80279d:	c3                   	ret    

0080279e <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  80279e:	55                   	push   %ebp
  80279f:	89 e5                	mov    %esp,%ebp
  8027a1:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  8027a4:	a1 28 50 80 00       	mov    0x805028,%eax
  8027a9:	85 c0                	test   %eax,%eax
  8027ab:	0f 85 de 01 00 00    	jne    80298f <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8027b1:	a1 38 51 80 00       	mov    0x805138,%eax
  8027b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027b9:	e9 9e 01 00 00       	jmp    80295c <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  8027be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c1:	8b 40 0c             	mov    0xc(%eax),%eax
  8027c4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027c7:	0f 82 87 01 00 00    	jb     802954 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  8027cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d0:	8b 40 0c             	mov    0xc(%eax),%eax
  8027d3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027d6:	0f 85 95 00 00 00    	jne    802871 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  8027dc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027e0:	75 17                	jne    8027f9 <alloc_block_NF+0x5b>
  8027e2:	83 ec 04             	sub    $0x4,%esp
  8027e5:	68 58 42 80 00       	push   $0x804258
  8027ea:	68 e0 00 00 00       	push   $0xe0
  8027ef:	68 af 41 80 00       	push   $0x8041af
  8027f4:	e8 a0 dc ff ff       	call   800499 <_panic>
  8027f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027fc:	8b 00                	mov    (%eax),%eax
  8027fe:	85 c0                	test   %eax,%eax
  802800:	74 10                	je     802812 <alloc_block_NF+0x74>
  802802:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802805:	8b 00                	mov    (%eax),%eax
  802807:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80280a:	8b 52 04             	mov    0x4(%edx),%edx
  80280d:	89 50 04             	mov    %edx,0x4(%eax)
  802810:	eb 0b                	jmp    80281d <alloc_block_NF+0x7f>
  802812:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802815:	8b 40 04             	mov    0x4(%eax),%eax
  802818:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80281d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802820:	8b 40 04             	mov    0x4(%eax),%eax
  802823:	85 c0                	test   %eax,%eax
  802825:	74 0f                	je     802836 <alloc_block_NF+0x98>
  802827:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282a:	8b 40 04             	mov    0x4(%eax),%eax
  80282d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802830:	8b 12                	mov    (%edx),%edx
  802832:	89 10                	mov    %edx,(%eax)
  802834:	eb 0a                	jmp    802840 <alloc_block_NF+0xa2>
  802836:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802839:	8b 00                	mov    (%eax),%eax
  80283b:	a3 38 51 80 00       	mov    %eax,0x805138
  802840:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802843:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802849:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802853:	a1 44 51 80 00       	mov    0x805144,%eax
  802858:	48                   	dec    %eax
  802859:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  80285e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802861:	8b 40 08             	mov    0x8(%eax),%eax
  802864:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  802869:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286c:	e9 f8 04 00 00       	jmp    802d69 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802871:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802874:	8b 40 0c             	mov    0xc(%eax),%eax
  802877:	3b 45 08             	cmp    0x8(%ebp),%eax
  80287a:	0f 86 d4 00 00 00    	jbe    802954 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802880:	a1 48 51 80 00       	mov    0x805148,%eax
  802885:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802888:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288b:	8b 50 08             	mov    0x8(%eax),%edx
  80288e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802891:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802894:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802897:	8b 55 08             	mov    0x8(%ebp),%edx
  80289a:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80289d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8028a1:	75 17                	jne    8028ba <alloc_block_NF+0x11c>
  8028a3:	83 ec 04             	sub    $0x4,%esp
  8028a6:	68 58 42 80 00       	push   $0x804258
  8028ab:	68 e9 00 00 00       	push   $0xe9
  8028b0:	68 af 41 80 00       	push   $0x8041af
  8028b5:	e8 df db ff ff       	call   800499 <_panic>
  8028ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028bd:	8b 00                	mov    (%eax),%eax
  8028bf:	85 c0                	test   %eax,%eax
  8028c1:	74 10                	je     8028d3 <alloc_block_NF+0x135>
  8028c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028c6:	8b 00                	mov    (%eax),%eax
  8028c8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028cb:	8b 52 04             	mov    0x4(%edx),%edx
  8028ce:	89 50 04             	mov    %edx,0x4(%eax)
  8028d1:	eb 0b                	jmp    8028de <alloc_block_NF+0x140>
  8028d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028d6:	8b 40 04             	mov    0x4(%eax),%eax
  8028d9:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8028de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028e1:	8b 40 04             	mov    0x4(%eax),%eax
  8028e4:	85 c0                	test   %eax,%eax
  8028e6:	74 0f                	je     8028f7 <alloc_block_NF+0x159>
  8028e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028eb:	8b 40 04             	mov    0x4(%eax),%eax
  8028ee:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028f1:	8b 12                	mov    (%edx),%edx
  8028f3:	89 10                	mov    %edx,(%eax)
  8028f5:	eb 0a                	jmp    802901 <alloc_block_NF+0x163>
  8028f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028fa:	8b 00                	mov    (%eax),%eax
  8028fc:	a3 48 51 80 00       	mov    %eax,0x805148
  802901:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802904:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80290a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80290d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802914:	a1 54 51 80 00       	mov    0x805154,%eax
  802919:	48                   	dec    %eax
  80291a:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  80291f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802922:	8b 40 08             	mov    0x8(%eax),%eax
  802925:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  80292a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292d:	8b 50 08             	mov    0x8(%eax),%edx
  802930:	8b 45 08             	mov    0x8(%ebp),%eax
  802933:	01 c2                	add    %eax,%edx
  802935:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802938:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  80293b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293e:	8b 40 0c             	mov    0xc(%eax),%eax
  802941:	2b 45 08             	sub    0x8(%ebp),%eax
  802944:	89 c2                	mov    %eax,%edx
  802946:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802949:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  80294c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80294f:	e9 15 04 00 00       	jmp    802d69 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802954:	a1 40 51 80 00       	mov    0x805140,%eax
  802959:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80295c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802960:	74 07                	je     802969 <alloc_block_NF+0x1cb>
  802962:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802965:	8b 00                	mov    (%eax),%eax
  802967:	eb 05                	jmp    80296e <alloc_block_NF+0x1d0>
  802969:	b8 00 00 00 00       	mov    $0x0,%eax
  80296e:	a3 40 51 80 00       	mov    %eax,0x805140
  802973:	a1 40 51 80 00       	mov    0x805140,%eax
  802978:	85 c0                	test   %eax,%eax
  80297a:	0f 85 3e fe ff ff    	jne    8027be <alloc_block_NF+0x20>
  802980:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802984:	0f 85 34 fe ff ff    	jne    8027be <alloc_block_NF+0x20>
  80298a:	e9 d5 03 00 00       	jmp    802d64 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  80298f:	a1 38 51 80 00       	mov    0x805138,%eax
  802994:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802997:	e9 b1 01 00 00       	jmp    802b4d <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  80299c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299f:	8b 50 08             	mov    0x8(%eax),%edx
  8029a2:	a1 28 50 80 00       	mov    0x805028,%eax
  8029a7:	39 c2                	cmp    %eax,%edx
  8029a9:	0f 82 96 01 00 00    	jb     802b45 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  8029af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b2:	8b 40 0c             	mov    0xc(%eax),%eax
  8029b5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029b8:	0f 82 87 01 00 00    	jb     802b45 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  8029be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c1:	8b 40 0c             	mov    0xc(%eax),%eax
  8029c4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029c7:	0f 85 95 00 00 00    	jne    802a62 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8029cd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029d1:	75 17                	jne    8029ea <alloc_block_NF+0x24c>
  8029d3:	83 ec 04             	sub    $0x4,%esp
  8029d6:	68 58 42 80 00       	push   $0x804258
  8029db:	68 fc 00 00 00       	push   $0xfc
  8029e0:	68 af 41 80 00       	push   $0x8041af
  8029e5:	e8 af da ff ff       	call   800499 <_panic>
  8029ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ed:	8b 00                	mov    (%eax),%eax
  8029ef:	85 c0                	test   %eax,%eax
  8029f1:	74 10                	je     802a03 <alloc_block_NF+0x265>
  8029f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f6:	8b 00                	mov    (%eax),%eax
  8029f8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029fb:	8b 52 04             	mov    0x4(%edx),%edx
  8029fe:	89 50 04             	mov    %edx,0x4(%eax)
  802a01:	eb 0b                	jmp    802a0e <alloc_block_NF+0x270>
  802a03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a06:	8b 40 04             	mov    0x4(%eax),%eax
  802a09:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802a0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a11:	8b 40 04             	mov    0x4(%eax),%eax
  802a14:	85 c0                	test   %eax,%eax
  802a16:	74 0f                	je     802a27 <alloc_block_NF+0x289>
  802a18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1b:	8b 40 04             	mov    0x4(%eax),%eax
  802a1e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a21:	8b 12                	mov    (%edx),%edx
  802a23:	89 10                	mov    %edx,(%eax)
  802a25:	eb 0a                	jmp    802a31 <alloc_block_NF+0x293>
  802a27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2a:	8b 00                	mov    (%eax),%eax
  802a2c:	a3 38 51 80 00       	mov    %eax,0x805138
  802a31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a34:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a44:	a1 44 51 80 00       	mov    0x805144,%eax
  802a49:	48                   	dec    %eax
  802a4a:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802a4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a52:	8b 40 08             	mov    0x8(%eax),%eax
  802a55:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802a5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5d:	e9 07 03 00 00       	jmp    802d69 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802a62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a65:	8b 40 0c             	mov    0xc(%eax),%eax
  802a68:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a6b:	0f 86 d4 00 00 00    	jbe    802b45 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802a71:	a1 48 51 80 00       	mov    0x805148,%eax
  802a76:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802a79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7c:	8b 50 08             	mov    0x8(%eax),%edx
  802a7f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a82:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802a85:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a88:	8b 55 08             	mov    0x8(%ebp),%edx
  802a8b:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802a8e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802a92:	75 17                	jne    802aab <alloc_block_NF+0x30d>
  802a94:	83 ec 04             	sub    $0x4,%esp
  802a97:	68 58 42 80 00       	push   $0x804258
  802a9c:	68 04 01 00 00       	push   $0x104
  802aa1:	68 af 41 80 00       	push   $0x8041af
  802aa6:	e8 ee d9 ff ff       	call   800499 <_panic>
  802aab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802aae:	8b 00                	mov    (%eax),%eax
  802ab0:	85 c0                	test   %eax,%eax
  802ab2:	74 10                	je     802ac4 <alloc_block_NF+0x326>
  802ab4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ab7:	8b 00                	mov    (%eax),%eax
  802ab9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802abc:	8b 52 04             	mov    0x4(%edx),%edx
  802abf:	89 50 04             	mov    %edx,0x4(%eax)
  802ac2:	eb 0b                	jmp    802acf <alloc_block_NF+0x331>
  802ac4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ac7:	8b 40 04             	mov    0x4(%eax),%eax
  802aca:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802acf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ad2:	8b 40 04             	mov    0x4(%eax),%eax
  802ad5:	85 c0                	test   %eax,%eax
  802ad7:	74 0f                	je     802ae8 <alloc_block_NF+0x34a>
  802ad9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802adc:	8b 40 04             	mov    0x4(%eax),%eax
  802adf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ae2:	8b 12                	mov    (%edx),%edx
  802ae4:	89 10                	mov    %edx,(%eax)
  802ae6:	eb 0a                	jmp    802af2 <alloc_block_NF+0x354>
  802ae8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802aeb:	8b 00                	mov    (%eax),%eax
  802aed:	a3 48 51 80 00       	mov    %eax,0x805148
  802af2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802af5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802afb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802afe:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b05:	a1 54 51 80 00       	mov    0x805154,%eax
  802b0a:	48                   	dec    %eax
  802b0b:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802b10:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b13:	8b 40 08             	mov    0x8(%eax),%eax
  802b16:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802b1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1e:	8b 50 08             	mov    0x8(%eax),%edx
  802b21:	8b 45 08             	mov    0x8(%ebp),%eax
  802b24:	01 c2                	add    %eax,%edx
  802b26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b29:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802b2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b2f:	8b 40 0c             	mov    0xc(%eax),%eax
  802b32:	2b 45 08             	sub    0x8(%ebp),%eax
  802b35:	89 c2                	mov    %eax,%edx
  802b37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b3a:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802b3d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b40:	e9 24 02 00 00       	jmp    802d69 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802b45:	a1 40 51 80 00       	mov    0x805140,%eax
  802b4a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b4d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b51:	74 07                	je     802b5a <alloc_block_NF+0x3bc>
  802b53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b56:	8b 00                	mov    (%eax),%eax
  802b58:	eb 05                	jmp    802b5f <alloc_block_NF+0x3c1>
  802b5a:	b8 00 00 00 00       	mov    $0x0,%eax
  802b5f:	a3 40 51 80 00       	mov    %eax,0x805140
  802b64:	a1 40 51 80 00       	mov    0x805140,%eax
  802b69:	85 c0                	test   %eax,%eax
  802b6b:	0f 85 2b fe ff ff    	jne    80299c <alloc_block_NF+0x1fe>
  802b71:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b75:	0f 85 21 fe ff ff    	jne    80299c <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802b7b:	a1 38 51 80 00       	mov    0x805138,%eax
  802b80:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b83:	e9 ae 01 00 00       	jmp    802d36 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802b88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8b:	8b 50 08             	mov    0x8(%eax),%edx
  802b8e:	a1 28 50 80 00       	mov    0x805028,%eax
  802b93:	39 c2                	cmp    %eax,%edx
  802b95:	0f 83 93 01 00 00    	jae    802d2e <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802b9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9e:	8b 40 0c             	mov    0xc(%eax),%eax
  802ba1:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ba4:	0f 82 84 01 00 00    	jb     802d2e <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802baa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bad:	8b 40 0c             	mov    0xc(%eax),%eax
  802bb0:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bb3:	0f 85 95 00 00 00    	jne    802c4e <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802bb9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bbd:	75 17                	jne    802bd6 <alloc_block_NF+0x438>
  802bbf:	83 ec 04             	sub    $0x4,%esp
  802bc2:	68 58 42 80 00       	push   $0x804258
  802bc7:	68 14 01 00 00       	push   $0x114
  802bcc:	68 af 41 80 00       	push   $0x8041af
  802bd1:	e8 c3 d8 ff ff       	call   800499 <_panic>
  802bd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd9:	8b 00                	mov    (%eax),%eax
  802bdb:	85 c0                	test   %eax,%eax
  802bdd:	74 10                	je     802bef <alloc_block_NF+0x451>
  802bdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be2:	8b 00                	mov    (%eax),%eax
  802be4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802be7:	8b 52 04             	mov    0x4(%edx),%edx
  802bea:	89 50 04             	mov    %edx,0x4(%eax)
  802bed:	eb 0b                	jmp    802bfa <alloc_block_NF+0x45c>
  802bef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf2:	8b 40 04             	mov    0x4(%eax),%eax
  802bf5:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802bfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bfd:	8b 40 04             	mov    0x4(%eax),%eax
  802c00:	85 c0                	test   %eax,%eax
  802c02:	74 0f                	je     802c13 <alloc_block_NF+0x475>
  802c04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c07:	8b 40 04             	mov    0x4(%eax),%eax
  802c0a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c0d:	8b 12                	mov    (%edx),%edx
  802c0f:	89 10                	mov    %edx,(%eax)
  802c11:	eb 0a                	jmp    802c1d <alloc_block_NF+0x47f>
  802c13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c16:	8b 00                	mov    (%eax),%eax
  802c18:	a3 38 51 80 00       	mov    %eax,0x805138
  802c1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c20:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c29:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c30:	a1 44 51 80 00       	mov    0x805144,%eax
  802c35:	48                   	dec    %eax
  802c36:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802c3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c3e:	8b 40 08             	mov    0x8(%eax),%eax
  802c41:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802c46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c49:	e9 1b 01 00 00       	jmp    802d69 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802c4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c51:	8b 40 0c             	mov    0xc(%eax),%eax
  802c54:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c57:	0f 86 d1 00 00 00    	jbe    802d2e <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802c5d:	a1 48 51 80 00       	mov    0x805148,%eax
  802c62:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802c65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c68:	8b 50 08             	mov    0x8(%eax),%edx
  802c6b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c6e:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802c71:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c74:	8b 55 08             	mov    0x8(%ebp),%edx
  802c77:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802c7a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802c7e:	75 17                	jne    802c97 <alloc_block_NF+0x4f9>
  802c80:	83 ec 04             	sub    $0x4,%esp
  802c83:	68 58 42 80 00       	push   $0x804258
  802c88:	68 1c 01 00 00       	push   $0x11c
  802c8d:	68 af 41 80 00       	push   $0x8041af
  802c92:	e8 02 d8 ff ff       	call   800499 <_panic>
  802c97:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c9a:	8b 00                	mov    (%eax),%eax
  802c9c:	85 c0                	test   %eax,%eax
  802c9e:	74 10                	je     802cb0 <alloc_block_NF+0x512>
  802ca0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ca3:	8b 00                	mov    (%eax),%eax
  802ca5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ca8:	8b 52 04             	mov    0x4(%edx),%edx
  802cab:	89 50 04             	mov    %edx,0x4(%eax)
  802cae:	eb 0b                	jmp    802cbb <alloc_block_NF+0x51d>
  802cb0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cb3:	8b 40 04             	mov    0x4(%eax),%eax
  802cb6:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802cbb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cbe:	8b 40 04             	mov    0x4(%eax),%eax
  802cc1:	85 c0                	test   %eax,%eax
  802cc3:	74 0f                	je     802cd4 <alloc_block_NF+0x536>
  802cc5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cc8:	8b 40 04             	mov    0x4(%eax),%eax
  802ccb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802cce:	8b 12                	mov    (%edx),%edx
  802cd0:	89 10                	mov    %edx,(%eax)
  802cd2:	eb 0a                	jmp    802cde <alloc_block_NF+0x540>
  802cd4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cd7:	8b 00                	mov    (%eax),%eax
  802cd9:	a3 48 51 80 00       	mov    %eax,0x805148
  802cde:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ce1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ce7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cea:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cf1:	a1 54 51 80 00       	mov    0x805154,%eax
  802cf6:	48                   	dec    %eax
  802cf7:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802cfc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cff:	8b 40 08             	mov    0x8(%eax),%eax
  802d02:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802d07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0a:	8b 50 08             	mov    0x8(%eax),%edx
  802d0d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d10:	01 c2                	add    %eax,%edx
  802d12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d15:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802d18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d1b:	8b 40 0c             	mov    0xc(%eax),%eax
  802d1e:	2b 45 08             	sub    0x8(%ebp),%eax
  802d21:	89 c2                	mov    %eax,%edx
  802d23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d26:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802d29:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d2c:	eb 3b                	jmp    802d69 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802d2e:	a1 40 51 80 00       	mov    0x805140,%eax
  802d33:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d36:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d3a:	74 07                	je     802d43 <alloc_block_NF+0x5a5>
  802d3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3f:	8b 00                	mov    (%eax),%eax
  802d41:	eb 05                	jmp    802d48 <alloc_block_NF+0x5aa>
  802d43:	b8 00 00 00 00       	mov    $0x0,%eax
  802d48:	a3 40 51 80 00       	mov    %eax,0x805140
  802d4d:	a1 40 51 80 00       	mov    0x805140,%eax
  802d52:	85 c0                	test   %eax,%eax
  802d54:	0f 85 2e fe ff ff    	jne    802b88 <alloc_block_NF+0x3ea>
  802d5a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d5e:	0f 85 24 fe ff ff    	jne    802b88 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802d64:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d69:	c9                   	leave  
  802d6a:	c3                   	ret    

00802d6b <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802d6b:	55                   	push   %ebp
  802d6c:	89 e5                	mov    %esp,%ebp
  802d6e:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802d71:	a1 38 51 80 00       	mov    0x805138,%eax
  802d76:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802d79:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802d7e:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802d81:	a1 38 51 80 00       	mov    0x805138,%eax
  802d86:	85 c0                	test   %eax,%eax
  802d88:	74 14                	je     802d9e <insert_sorted_with_merge_freeList+0x33>
  802d8a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d8d:	8b 50 08             	mov    0x8(%eax),%edx
  802d90:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d93:	8b 40 08             	mov    0x8(%eax),%eax
  802d96:	39 c2                	cmp    %eax,%edx
  802d98:	0f 87 9b 01 00 00    	ja     802f39 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802d9e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802da2:	75 17                	jne    802dbb <insert_sorted_with_merge_freeList+0x50>
  802da4:	83 ec 04             	sub    $0x4,%esp
  802da7:	68 8c 41 80 00       	push   $0x80418c
  802dac:	68 38 01 00 00       	push   $0x138
  802db1:	68 af 41 80 00       	push   $0x8041af
  802db6:	e8 de d6 ff ff       	call   800499 <_panic>
  802dbb:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802dc1:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc4:	89 10                	mov    %edx,(%eax)
  802dc6:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc9:	8b 00                	mov    (%eax),%eax
  802dcb:	85 c0                	test   %eax,%eax
  802dcd:	74 0d                	je     802ddc <insert_sorted_with_merge_freeList+0x71>
  802dcf:	a1 38 51 80 00       	mov    0x805138,%eax
  802dd4:	8b 55 08             	mov    0x8(%ebp),%edx
  802dd7:	89 50 04             	mov    %edx,0x4(%eax)
  802dda:	eb 08                	jmp    802de4 <insert_sorted_with_merge_freeList+0x79>
  802ddc:	8b 45 08             	mov    0x8(%ebp),%eax
  802ddf:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802de4:	8b 45 08             	mov    0x8(%ebp),%eax
  802de7:	a3 38 51 80 00       	mov    %eax,0x805138
  802dec:	8b 45 08             	mov    0x8(%ebp),%eax
  802def:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802df6:	a1 44 51 80 00       	mov    0x805144,%eax
  802dfb:	40                   	inc    %eax
  802dfc:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802e01:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e05:	0f 84 a8 06 00 00    	je     8034b3 <insert_sorted_with_merge_freeList+0x748>
  802e0b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e0e:	8b 50 08             	mov    0x8(%eax),%edx
  802e11:	8b 45 08             	mov    0x8(%ebp),%eax
  802e14:	8b 40 0c             	mov    0xc(%eax),%eax
  802e17:	01 c2                	add    %eax,%edx
  802e19:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e1c:	8b 40 08             	mov    0x8(%eax),%eax
  802e1f:	39 c2                	cmp    %eax,%edx
  802e21:	0f 85 8c 06 00 00    	jne    8034b3 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802e27:	8b 45 08             	mov    0x8(%ebp),%eax
  802e2a:	8b 50 0c             	mov    0xc(%eax),%edx
  802e2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e30:	8b 40 0c             	mov    0xc(%eax),%eax
  802e33:	01 c2                	add    %eax,%edx
  802e35:	8b 45 08             	mov    0x8(%ebp),%eax
  802e38:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802e3b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e3f:	75 17                	jne    802e58 <insert_sorted_with_merge_freeList+0xed>
  802e41:	83 ec 04             	sub    $0x4,%esp
  802e44:	68 58 42 80 00       	push   $0x804258
  802e49:	68 3c 01 00 00       	push   $0x13c
  802e4e:	68 af 41 80 00       	push   $0x8041af
  802e53:	e8 41 d6 ff ff       	call   800499 <_panic>
  802e58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e5b:	8b 00                	mov    (%eax),%eax
  802e5d:	85 c0                	test   %eax,%eax
  802e5f:	74 10                	je     802e71 <insert_sorted_with_merge_freeList+0x106>
  802e61:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e64:	8b 00                	mov    (%eax),%eax
  802e66:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e69:	8b 52 04             	mov    0x4(%edx),%edx
  802e6c:	89 50 04             	mov    %edx,0x4(%eax)
  802e6f:	eb 0b                	jmp    802e7c <insert_sorted_with_merge_freeList+0x111>
  802e71:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e74:	8b 40 04             	mov    0x4(%eax),%eax
  802e77:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e7f:	8b 40 04             	mov    0x4(%eax),%eax
  802e82:	85 c0                	test   %eax,%eax
  802e84:	74 0f                	je     802e95 <insert_sorted_with_merge_freeList+0x12a>
  802e86:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e89:	8b 40 04             	mov    0x4(%eax),%eax
  802e8c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e8f:	8b 12                	mov    (%edx),%edx
  802e91:	89 10                	mov    %edx,(%eax)
  802e93:	eb 0a                	jmp    802e9f <insert_sorted_with_merge_freeList+0x134>
  802e95:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e98:	8b 00                	mov    (%eax),%eax
  802e9a:	a3 38 51 80 00       	mov    %eax,0x805138
  802e9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ea2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ea8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eab:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802eb2:	a1 44 51 80 00       	mov    0x805144,%eax
  802eb7:	48                   	dec    %eax
  802eb8:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802ebd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ec0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802ec7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eca:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802ed1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ed5:	75 17                	jne    802eee <insert_sorted_with_merge_freeList+0x183>
  802ed7:	83 ec 04             	sub    $0x4,%esp
  802eda:	68 8c 41 80 00       	push   $0x80418c
  802edf:	68 3f 01 00 00       	push   $0x13f
  802ee4:	68 af 41 80 00       	push   $0x8041af
  802ee9:	e8 ab d5 ff ff       	call   800499 <_panic>
  802eee:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802ef4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ef7:	89 10                	mov    %edx,(%eax)
  802ef9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802efc:	8b 00                	mov    (%eax),%eax
  802efe:	85 c0                	test   %eax,%eax
  802f00:	74 0d                	je     802f0f <insert_sorted_with_merge_freeList+0x1a4>
  802f02:	a1 48 51 80 00       	mov    0x805148,%eax
  802f07:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f0a:	89 50 04             	mov    %edx,0x4(%eax)
  802f0d:	eb 08                	jmp    802f17 <insert_sorted_with_merge_freeList+0x1ac>
  802f0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f12:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f17:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f1a:	a3 48 51 80 00       	mov    %eax,0x805148
  802f1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f22:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f29:	a1 54 51 80 00       	mov    0x805154,%eax
  802f2e:	40                   	inc    %eax
  802f2f:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802f34:	e9 7a 05 00 00       	jmp    8034b3 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802f39:	8b 45 08             	mov    0x8(%ebp),%eax
  802f3c:	8b 50 08             	mov    0x8(%eax),%edx
  802f3f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f42:	8b 40 08             	mov    0x8(%eax),%eax
  802f45:	39 c2                	cmp    %eax,%edx
  802f47:	0f 82 14 01 00 00    	jb     803061 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802f4d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f50:	8b 50 08             	mov    0x8(%eax),%edx
  802f53:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f56:	8b 40 0c             	mov    0xc(%eax),%eax
  802f59:	01 c2                	add    %eax,%edx
  802f5b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f5e:	8b 40 08             	mov    0x8(%eax),%eax
  802f61:	39 c2                	cmp    %eax,%edx
  802f63:	0f 85 90 00 00 00    	jne    802ff9 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802f69:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f6c:	8b 50 0c             	mov    0xc(%eax),%edx
  802f6f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f72:	8b 40 0c             	mov    0xc(%eax),%eax
  802f75:	01 c2                	add    %eax,%edx
  802f77:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f7a:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802f7d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f80:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802f87:	8b 45 08             	mov    0x8(%ebp),%eax
  802f8a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802f91:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f95:	75 17                	jne    802fae <insert_sorted_with_merge_freeList+0x243>
  802f97:	83 ec 04             	sub    $0x4,%esp
  802f9a:	68 8c 41 80 00       	push   $0x80418c
  802f9f:	68 49 01 00 00       	push   $0x149
  802fa4:	68 af 41 80 00       	push   $0x8041af
  802fa9:	e8 eb d4 ff ff       	call   800499 <_panic>
  802fae:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802fb4:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb7:	89 10                	mov    %edx,(%eax)
  802fb9:	8b 45 08             	mov    0x8(%ebp),%eax
  802fbc:	8b 00                	mov    (%eax),%eax
  802fbe:	85 c0                	test   %eax,%eax
  802fc0:	74 0d                	je     802fcf <insert_sorted_with_merge_freeList+0x264>
  802fc2:	a1 48 51 80 00       	mov    0x805148,%eax
  802fc7:	8b 55 08             	mov    0x8(%ebp),%edx
  802fca:	89 50 04             	mov    %edx,0x4(%eax)
  802fcd:	eb 08                	jmp    802fd7 <insert_sorted_with_merge_freeList+0x26c>
  802fcf:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd2:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802fd7:	8b 45 08             	mov    0x8(%ebp),%eax
  802fda:	a3 48 51 80 00       	mov    %eax,0x805148
  802fdf:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fe9:	a1 54 51 80 00       	mov    0x805154,%eax
  802fee:	40                   	inc    %eax
  802fef:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802ff4:	e9 bb 04 00 00       	jmp    8034b4 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802ff9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ffd:	75 17                	jne    803016 <insert_sorted_with_merge_freeList+0x2ab>
  802fff:	83 ec 04             	sub    $0x4,%esp
  803002:	68 00 42 80 00       	push   $0x804200
  803007:	68 4c 01 00 00       	push   $0x14c
  80300c:	68 af 41 80 00       	push   $0x8041af
  803011:	e8 83 d4 ff ff       	call   800499 <_panic>
  803016:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  80301c:	8b 45 08             	mov    0x8(%ebp),%eax
  80301f:	89 50 04             	mov    %edx,0x4(%eax)
  803022:	8b 45 08             	mov    0x8(%ebp),%eax
  803025:	8b 40 04             	mov    0x4(%eax),%eax
  803028:	85 c0                	test   %eax,%eax
  80302a:	74 0c                	je     803038 <insert_sorted_with_merge_freeList+0x2cd>
  80302c:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803031:	8b 55 08             	mov    0x8(%ebp),%edx
  803034:	89 10                	mov    %edx,(%eax)
  803036:	eb 08                	jmp    803040 <insert_sorted_with_merge_freeList+0x2d5>
  803038:	8b 45 08             	mov    0x8(%ebp),%eax
  80303b:	a3 38 51 80 00       	mov    %eax,0x805138
  803040:	8b 45 08             	mov    0x8(%ebp),%eax
  803043:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803048:	8b 45 08             	mov    0x8(%ebp),%eax
  80304b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803051:	a1 44 51 80 00       	mov    0x805144,%eax
  803056:	40                   	inc    %eax
  803057:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80305c:	e9 53 04 00 00       	jmp    8034b4 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803061:	a1 38 51 80 00       	mov    0x805138,%eax
  803066:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803069:	e9 15 04 00 00       	jmp    803483 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  80306e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803071:	8b 00                	mov    (%eax),%eax
  803073:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  803076:	8b 45 08             	mov    0x8(%ebp),%eax
  803079:	8b 50 08             	mov    0x8(%eax),%edx
  80307c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80307f:	8b 40 08             	mov    0x8(%eax),%eax
  803082:	39 c2                	cmp    %eax,%edx
  803084:	0f 86 f1 03 00 00    	jbe    80347b <insert_sorted_with_merge_freeList+0x710>
  80308a:	8b 45 08             	mov    0x8(%ebp),%eax
  80308d:	8b 50 08             	mov    0x8(%eax),%edx
  803090:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803093:	8b 40 08             	mov    0x8(%eax),%eax
  803096:	39 c2                	cmp    %eax,%edx
  803098:	0f 83 dd 03 00 00    	jae    80347b <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  80309e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a1:	8b 50 08             	mov    0x8(%eax),%edx
  8030a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a7:	8b 40 0c             	mov    0xc(%eax),%eax
  8030aa:	01 c2                	add    %eax,%edx
  8030ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8030af:	8b 40 08             	mov    0x8(%eax),%eax
  8030b2:	39 c2                	cmp    %eax,%edx
  8030b4:	0f 85 b9 01 00 00    	jne    803273 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8030ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8030bd:	8b 50 08             	mov    0x8(%eax),%edx
  8030c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c3:	8b 40 0c             	mov    0xc(%eax),%eax
  8030c6:	01 c2                	add    %eax,%edx
  8030c8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030cb:	8b 40 08             	mov    0x8(%eax),%eax
  8030ce:	39 c2                	cmp    %eax,%edx
  8030d0:	0f 85 0d 01 00 00    	jne    8031e3 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  8030d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d9:	8b 50 0c             	mov    0xc(%eax),%edx
  8030dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030df:	8b 40 0c             	mov    0xc(%eax),%eax
  8030e2:	01 c2                	add    %eax,%edx
  8030e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e7:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8030ea:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8030ee:	75 17                	jne    803107 <insert_sorted_with_merge_freeList+0x39c>
  8030f0:	83 ec 04             	sub    $0x4,%esp
  8030f3:	68 58 42 80 00       	push   $0x804258
  8030f8:	68 5c 01 00 00       	push   $0x15c
  8030fd:	68 af 41 80 00       	push   $0x8041af
  803102:	e8 92 d3 ff ff       	call   800499 <_panic>
  803107:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80310a:	8b 00                	mov    (%eax),%eax
  80310c:	85 c0                	test   %eax,%eax
  80310e:	74 10                	je     803120 <insert_sorted_with_merge_freeList+0x3b5>
  803110:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803113:	8b 00                	mov    (%eax),%eax
  803115:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803118:	8b 52 04             	mov    0x4(%edx),%edx
  80311b:	89 50 04             	mov    %edx,0x4(%eax)
  80311e:	eb 0b                	jmp    80312b <insert_sorted_with_merge_freeList+0x3c0>
  803120:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803123:	8b 40 04             	mov    0x4(%eax),%eax
  803126:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80312b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80312e:	8b 40 04             	mov    0x4(%eax),%eax
  803131:	85 c0                	test   %eax,%eax
  803133:	74 0f                	je     803144 <insert_sorted_with_merge_freeList+0x3d9>
  803135:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803138:	8b 40 04             	mov    0x4(%eax),%eax
  80313b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80313e:	8b 12                	mov    (%edx),%edx
  803140:	89 10                	mov    %edx,(%eax)
  803142:	eb 0a                	jmp    80314e <insert_sorted_with_merge_freeList+0x3e3>
  803144:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803147:	8b 00                	mov    (%eax),%eax
  803149:	a3 38 51 80 00       	mov    %eax,0x805138
  80314e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803151:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803157:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80315a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803161:	a1 44 51 80 00       	mov    0x805144,%eax
  803166:	48                   	dec    %eax
  803167:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  80316c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80316f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803176:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803179:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803180:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803184:	75 17                	jne    80319d <insert_sorted_with_merge_freeList+0x432>
  803186:	83 ec 04             	sub    $0x4,%esp
  803189:	68 8c 41 80 00       	push   $0x80418c
  80318e:	68 5f 01 00 00       	push   $0x15f
  803193:	68 af 41 80 00       	push   $0x8041af
  803198:	e8 fc d2 ff ff       	call   800499 <_panic>
  80319d:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8031a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031a6:	89 10                	mov    %edx,(%eax)
  8031a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ab:	8b 00                	mov    (%eax),%eax
  8031ad:	85 c0                	test   %eax,%eax
  8031af:	74 0d                	je     8031be <insert_sorted_with_merge_freeList+0x453>
  8031b1:	a1 48 51 80 00       	mov    0x805148,%eax
  8031b6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031b9:	89 50 04             	mov    %edx,0x4(%eax)
  8031bc:	eb 08                	jmp    8031c6 <insert_sorted_with_merge_freeList+0x45b>
  8031be:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031c1:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8031c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031c9:	a3 48 51 80 00       	mov    %eax,0x805148
  8031ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031d1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031d8:	a1 54 51 80 00       	mov    0x805154,%eax
  8031dd:	40                   	inc    %eax
  8031de:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  8031e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031e6:	8b 50 0c             	mov    0xc(%eax),%edx
  8031e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ec:	8b 40 0c             	mov    0xc(%eax),%eax
  8031ef:	01 c2                	add    %eax,%edx
  8031f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031f4:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  8031f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8031fa:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803201:	8b 45 08             	mov    0x8(%ebp),%eax
  803204:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80320b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80320f:	75 17                	jne    803228 <insert_sorted_with_merge_freeList+0x4bd>
  803211:	83 ec 04             	sub    $0x4,%esp
  803214:	68 8c 41 80 00       	push   $0x80418c
  803219:	68 64 01 00 00       	push   $0x164
  80321e:	68 af 41 80 00       	push   $0x8041af
  803223:	e8 71 d2 ff ff       	call   800499 <_panic>
  803228:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80322e:	8b 45 08             	mov    0x8(%ebp),%eax
  803231:	89 10                	mov    %edx,(%eax)
  803233:	8b 45 08             	mov    0x8(%ebp),%eax
  803236:	8b 00                	mov    (%eax),%eax
  803238:	85 c0                	test   %eax,%eax
  80323a:	74 0d                	je     803249 <insert_sorted_with_merge_freeList+0x4de>
  80323c:	a1 48 51 80 00       	mov    0x805148,%eax
  803241:	8b 55 08             	mov    0x8(%ebp),%edx
  803244:	89 50 04             	mov    %edx,0x4(%eax)
  803247:	eb 08                	jmp    803251 <insert_sorted_with_merge_freeList+0x4e6>
  803249:	8b 45 08             	mov    0x8(%ebp),%eax
  80324c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803251:	8b 45 08             	mov    0x8(%ebp),%eax
  803254:	a3 48 51 80 00       	mov    %eax,0x805148
  803259:	8b 45 08             	mov    0x8(%ebp),%eax
  80325c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803263:	a1 54 51 80 00       	mov    0x805154,%eax
  803268:	40                   	inc    %eax
  803269:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  80326e:	e9 41 02 00 00       	jmp    8034b4 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803273:	8b 45 08             	mov    0x8(%ebp),%eax
  803276:	8b 50 08             	mov    0x8(%eax),%edx
  803279:	8b 45 08             	mov    0x8(%ebp),%eax
  80327c:	8b 40 0c             	mov    0xc(%eax),%eax
  80327f:	01 c2                	add    %eax,%edx
  803281:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803284:	8b 40 08             	mov    0x8(%eax),%eax
  803287:	39 c2                	cmp    %eax,%edx
  803289:	0f 85 7c 01 00 00    	jne    80340b <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  80328f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803293:	74 06                	je     80329b <insert_sorted_with_merge_freeList+0x530>
  803295:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803299:	75 17                	jne    8032b2 <insert_sorted_with_merge_freeList+0x547>
  80329b:	83 ec 04             	sub    $0x4,%esp
  80329e:	68 c8 41 80 00       	push   $0x8041c8
  8032a3:	68 69 01 00 00       	push   $0x169
  8032a8:	68 af 41 80 00       	push   $0x8041af
  8032ad:	e8 e7 d1 ff ff       	call   800499 <_panic>
  8032b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032b5:	8b 50 04             	mov    0x4(%eax),%edx
  8032b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8032bb:	89 50 04             	mov    %edx,0x4(%eax)
  8032be:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032c4:	89 10                	mov    %edx,(%eax)
  8032c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032c9:	8b 40 04             	mov    0x4(%eax),%eax
  8032cc:	85 c0                	test   %eax,%eax
  8032ce:	74 0d                	je     8032dd <insert_sorted_with_merge_freeList+0x572>
  8032d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032d3:	8b 40 04             	mov    0x4(%eax),%eax
  8032d6:	8b 55 08             	mov    0x8(%ebp),%edx
  8032d9:	89 10                	mov    %edx,(%eax)
  8032db:	eb 08                	jmp    8032e5 <insert_sorted_with_merge_freeList+0x57a>
  8032dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e0:	a3 38 51 80 00       	mov    %eax,0x805138
  8032e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032e8:	8b 55 08             	mov    0x8(%ebp),%edx
  8032eb:	89 50 04             	mov    %edx,0x4(%eax)
  8032ee:	a1 44 51 80 00       	mov    0x805144,%eax
  8032f3:	40                   	inc    %eax
  8032f4:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  8032f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8032fc:	8b 50 0c             	mov    0xc(%eax),%edx
  8032ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803302:	8b 40 0c             	mov    0xc(%eax),%eax
  803305:	01 c2                	add    %eax,%edx
  803307:	8b 45 08             	mov    0x8(%ebp),%eax
  80330a:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80330d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803311:	75 17                	jne    80332a <insert_sorted_with_merge_freeList+0x5bf>
  803313:	83 ec 04             	sub    $0x4,%esp
  803316:	68 58 42 80 00       	push   $0x804258
  80331b:	68 6b 01 00 00       	push   $0x16b
  803320:	68 af 41 80 00       	push   $0x8041af
  803325:	e8 6f d1 ff ff       	call   800499 <_panic>
  80332a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80332d:	8b 00                	mov    (%eax),%eax
  80332f:	85 c0                	test   %eax,%eax
  803331:	74 10                	je     803343 <insert_sorted_with_merge_freeList+0x5d8>
  803333:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803336:	8b 00                	mov    (%eax),%eax
  803338:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80333b:	8b 52 04             	mov    0x4(%edx),%edx
  80333e:	89 50 04             	mov    %edx,0x4(%eax)
  803341:	eb 0b                	jmp    80334e <insert_sorted_with_merge_freeList+0x5e3>
  803343:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803346:	8b 40 04             	mov    0x4(%eax),%eax
  803349:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80334e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803351:	8b 40 04             	mov    0x4(%eax),%eax
  803354:	85 c0                	test   %eax,%eax
  803356:	74 0f                	je     803367 <insert_sorted_with_merge_freeList+0x5fc>
  803358:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80335b:	8b 40 04             	mov    0x4(%eax),%eax
  80335e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803361:	8b 12                	mov    (%edx),%edx
  803363:	89 10                	mov    %edx,(%eax)
  803365:	eb 0a                	jmp    803371 <insert_sorted_with_merge_freeList+0x606>
  803367:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80336a:	8b 00                	mov    (%eax),%eax
  80336c:	a3 38 51 80 00       	mov    %eax,0x805138
  803371:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803374:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80337a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80337d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803384:	a1 44 51 80 00       	mov    0x805144,%eax
  803389:	48                   	dec    %eax
  80338a:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  80338f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803392:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803399:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80339c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8033a3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8033a7:	75 17                	jne    8033c0 <insert_sorted_with_merge_freeList+0x655>
  8033a9:	83 ec 04             	sub    $0x4,%esp
  8033ac:	68 8c 41 80 00       	push   $0x80418c
  8033b1:	68 6e 01 00 00       	push   $0x16e
  8033b6:	68 af 41 80 00       	push   $0x8041af
  8033bb:	e8 d9 d0 ff ff       	call   800499 <_panic>
  8033c0:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8033c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033c9:	89 10                	mov    %edx,(%eax)
  8033cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033ce:	8b 00                	mov    (%eax),%eax
  8033d0:	85 c0                	test   %eax,%eax
  8033d2:	74 0d                	je     8033e1 <insert_sorted_with_merge_freeList+0x676>
  8033d4:	a1 48 51 80 00       	mov    0x805148,%eax
  8033d9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8033dc:	89 50 04             	mov    %edx,0x4(%eax)
  8033df:	eb 08                	jmp    8033e9 <insert_sorted_with_merge_freeList+0x67e>
  8033e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033e4:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8033e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033ec:	a3 48 51 80 00       	mov    %eax,0x805148
  8033f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033f4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033fb:	a1 54 51 80 00       	mov    0x805154,%eax
  803400:	40                   	inc    %eax
  803401:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803406:	e9 a9 00 00 00       	jmp    8034b4 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  80340b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80340f:	74 06                	je     803417 <insert_sorted_with_merge_freeList+0x6ac>
  803411:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803415:	75 17                	jne    80342e <insert_sorted_with_merge_freeList+0x6c3>
  803417:	83 ec 04             	sub    $0x4,%esp
  80341a:	68 24 42 80 00       	push   $0x804224
  80341f:	68 73 01 00 00       	push   $0x173
  803424:	68 af 41 80 00       	push   $0x8041af
  803429:	e8 6b d0 ff ff       	call   800499 <_panic>
  80342e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803431:	8b 10                	mov    (%eax),%edx
  803433:	8b 45 08             	mov    0x8(%ebp),%eax
  803436:	89 10                	mov    %edx,(%eax)
  803438:	8b 45 08             	mov    0x8(%ebp),%eax
  80343b:	8b 00                	mov    (%eax),%eax
  80343d:	85 c0                	test   %eax,%eax
  80343f:	74 0b                	je     80344c <insert_sorted_with_merge_freeList+0x6e1>
  803441:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803444:	8b 00                	mov    (%eax),%eax
  803446:	8b 55 08             	mov    0x8(%ebp),%edx
  803449:	89 50 04             	mov    %edx,0x4(%eax)
  80344c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80344f:	8b 55 08             	mov    0x8(%ebp),%edx
  803452:	89 10                	mov    %edx,(%eax)
  803454:	8b 45 08             	mov    0x8(%ebp),%eax
  803457:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80345a:	89 50 04             	mov    %edx,0x4(%eax)
  80345d:	8b 45 08             	mov    0x8(%ebp),%eax
  803460:	8b 00                	mov    (%eax),%eax
  803462:	85 c0                	test   %eax,%eax
  803464:	75 08                	jne    80346e <insert_sorted_with_merge_freeList+0x703>
  803466:	8b 45 08             	mov    0x8(%ebp),%eax
  803469:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80346e:	a1 44 51 80 00       	mov    0x805144,%eax
  803473:	40                   	inc    %eax
  803474:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803479:	eb 39                	jmp    8034b4 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  80347b:	a1 40 51 80 00       	mov    0x805140,%eax
  803480:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803483:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803487:	74 07                	je     803490 <insert_sorted_with_merge_freeList+0x725>
  803489:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80348c:	8b 00                	mov    (%eax),%eax
  80348e:	eb 05                	jmp    803495 <insert_sorted_with_merge_freeList+0x72a>
  803490:	b8 00 00 00 00       	mov    $0x0,%eax
  803495:	a3 40 51 80 00       	mov    %eax,0x805140
  80349a:	a1 40 51 80 00       	mov    0x805140,%eax
  80349f:	85 c0                	test   %eax,%eax
  8034a1:	0f 85 c7 fb ff ff    	jne    80306e <insert_sorted_with_merge_freeList+0x303>
  8034a7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034ab:	0f 85 bd fb ff ff    	jne    80306e <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8034b1:	eb 01                	jmp    8034b4 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8034b3:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8034b4:	90                   	nop
  8034b5:	c9                   	leave  
  8034b6:	c3                   	ret    
  8034b7:	90                   	nop

008034b8 <__udivdi3>:
  8034b8:	55                   	push   %ebp
  8034b9:	57                   	push   %edi
  8034ba:	56                   	push   %esi
  8034bb:	53                   	push   %ebx
  8034bc:	83 ec 1c             	sub    $0x1c,%esp
  8034bf:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8034c3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8034c7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8034cb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8034cf:	89 ca                	mov    %ecx,%edx
  8034d1:	89 f8                	mov    %edi,%eax
  8034d3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8034d7:	85 f6                	test   %esi,%esi
  8034d9:	75 2d                	jne    803508 <__udivdi3+0x50>
  8034db:	39 cf                	cmp    %ecx,%edi
  8034dd:	77 65                	ja     803544 <__udivdi3+0x8c>
  8034df:	89 fd                	mov    %edi,%ebp
  8034e1:	85 ff                	test   %edi,%edi
  8034e3:	75 0b                	jne    8034f0 <__udivdi3+0x38>
  8034e5:	b8 01 00 00 00       	mov    $0x1,%eax
  8034ea:	31 d2                	xor    %edx,%edx
  8034ec:	f7 f7                	div    %edi
  8034ee:	89 c5                	mov    %eax,%ebp
  8034f0:	31 d2                	xor    %edx,%edx
  8034f2:	89 c8                	mov    %ecx,%eax
  8034f4:	f7 f5                	div    %ebp
  8034f6:	89 c1                	mov    %eax,%ecx
  8034f8:	89 d8                	mov    %ebx,%eax
  8034fa:	f7 f5                	div    %ebp
  8034fc:	89 cf                	mov    %ecx,%edi
  8034fe:	89 fa                	mov    %edi,%edx
  803500:	83 c4 1c             	add    $0x1c,%esp
  803503:	5b                   	pop    %ebx
  803504:	5e                   	pop    %esi
  803505:	5f                   	pop    %edi
  803506:	5d                   	pop    %ebp
  803507:	c3                   	ret    
  803508:	39 ce                	cmp    %ecx,%esi
  80350a:	77 28                	ja     803534 <__udivdi3+0x7c>
  80350c:	0f bd fe             	bsr    %esi,%edi
  80350f:	83 f7 1f             	xor    $0x1f,%edi
  803512:	75 40                	jne    803554 <__udivdi3+0x9c>
  803514:	39 ce                	cmp    %ecx,%esi
  803516:	72 0a                	jb     803522 <__udivdi3+0x6a>
  803518:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80351c:	0f 87 9e 00 00 00    	ja     8035c0 <__udivdi3+0x108>
  803522:	b8 01 00 00 00       	mov    $0x1,%eax
  803527:	89 fa                	mov    %edi,%edx
  803529:	83 c4 1c             	add    $0x1c,%esp
  80352c:	5b                   	pop    %ebx
  80352d:	5e                   	pop    %esi
  80352e:	5f                   	pop    %edi
  80352f:	5d                   	pop    %ebp
  803530:	c3                   	ret    
  803531:	8d 76 00             	lea    0x0(%esi),%esi
  803534:	31 ff                	xor    %edi,%edi
  803536:	31 c0                	xor    %eax,%eax
  803538:	89 fa                	mov    %edi,%edx
  80353a:	83 c4 1c             	add    $0x1c,%esp
  80353d:	5b                   	pop    %ebx
  80353e:	5e                   	pop    %esi
  80353f:	5f                   	pop    %edi
  803540:	5d                   	pop    %ebp
  803541:	c3                   	ret    
  803542:	66 90                	xchg   %ax,%ax
  803544:	89 d8                	mov    %ebx,%eax
  803546:	f7 f7                	div    %edi
  803548:	31 ff                	xor    %edi,%edi
  80354a:	89 fa                	mov    %edi,%edx
  80354c:	83 c4 1c             	add    $0x1c,%esp
  80354f:	5b                   	pop    %ebx
  803550:	5e                   	pop    %esi
  803551:	5f                   	pop    %edi
  803552:	5d                   	pop    %ebp
  803553:	c3                   	ret    
  803554:	bd 20 00 00 00       	mov    $0x20,%ebp
  803559:	89 eb                	mov    %ebp,%ebx
  80355b:	29 fb                	sub    %edi,%ebx
  80355d:	89 f9                	mov    %edi,%ecx
  80355f:	d3 e6                	shl    %cl,%esi
  803561:	89 c5                	mov    %eax,%ebp
  803563:	88 d9                	mov    %bl,%cl
  803565:	d3 ed                	shr    %cl,%ebp
  803567:	89 e9                	mov    %ebp,%ecx
  803569:	09 f1                	or     %esi,%ecx
  80356b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80356f:	89 f9                	mov    %edi,%ecx
  803571:	d3 e0                	shl    %cl,%eax
  803573:	89 c5                	mov    %eax,%ebp
  803575:	89 d6                	mov    %edx,%esi
  803577:	88 d9                	mov    %bl,%cl
  803579:	d3 ee                	shr    %cl,%esi
  80357b:	89 f9                	mov    %edi,%ecx
  80357d:	d3 e2                	shl    %cl,%edx
  80357f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803583:	88 d9                	mov    %bl,%cl
  803585:	d3 e8                	shr    %cl,%eax
  803587:	09 c2                	or     %eax,%edx
  803589:	89 d0                	mov    %edx,%eax
  80358b:	89 f2                	mov    %esi,%edx
  80358d:	f7 74 24 0c          	divl   0xc(%esp)
  803591:	89 d6                	mov    %edx,%esi
  803593:	89 c3                	mov    %eax,%ebx
  803595:	f7 e5                	mul    %ebp
  803597:	39 d6                	cmp    %edx,%esi
  803599:	72 19                	jb     8035b4 <__udivdi3+0xfc>
  80359b:	74 0b                	je     8035a8 <__udivdi3+0xf0>
  80359d:	89 d8                	mov    %ebx,%eax
  80359f:	31 ff                	xor    %edi,%edi
  8035a1:	e9 58 ff ff ff       	jmp    8034fe <__udivdi3+0x46>
  8035a6:	66 90                	xchg   %ax,%ax
  8035a8:	8b 54 24 08          	mov    0x8(%esp),%edx
  8035ac:	89 f9                	mov    %edi,%ecx
  8035ae:	d3 e2                	shl    %cl,%edx
  8035b0:	39 c2                	cmp    %eax,%edx
  8035b2:	73 e9                	jae    80359d <__udivdi3+0xe5>
  8035b4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8035b7:	31 ff                	xor    %edi,%edi
  8035b9:	e9 40 ff ff ff       	jmp    8034fe <__udivdi3+0x46>
  8035be:	66 90                	xchg   %ax,%ax
  8035c0:	31 c0                	xor    %eax,%eax
  8035c2:	e9 37 ff ff ff       	jmp    8034fe <__udivdi3+0x46>
  8035c7:	90                   	nop

008035c8 <__umoddi3>:
  8035c8:	55                   	push   %ebp
  8035c9:	57                   	push   %edi
  8035ca:	56                   	push   %esi
  8035cb:	53                   	push   %ebx
  8035cc:	83 ec 1c             	sub    $0x1c,%esp
  8035cf:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8035d3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8035d7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8035db:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8035df:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8035e3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8035e7:	89 f3                	mov    %esi,%ebx
  8035e9:	89 fa                	mov    %edi,%edx
  8035eb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8035ef:	89 34 24             	mov    %esi,(%esp)
  8035f2:	85 c0                	test   %eax,%eax
  8035f4:	75 1a                	jne    803610 <__umoddi3+0x48>
  8035f6:	39 f7                	cmp    %esi,%edi
  8035f8:	0f 86 a2 00 00 00    	jbe    8036a0 <__umoddi3+0xd8>
  8035fe:	89 c8                	mov    %ecx,%eax
  803600:	89 f2                	mov    %esi,%edx
  803602:	f7 f7                	div    %edi
  803604:	89 d0                	mov    %edx,%eax
  803606:	31 d2                	xor    %edx,%edx
  803608:	83 c4 1c             	add    $0x1c,%esp
  80360b:	5b                   	pop    %ebx
  80360c:	5e                   	pop    %esi
  80360d:	5f                   	pop    %edi
  80360e:	5d                   	pop    %ebp
  80360f:	c3                   	ret    
  803610:	39 f0                	cmp    %esi,%eax
  803612:	0f 87 ac 00 00 00    	ja     8036c4 <__umoddi3+0xfc>
  803618:	0f bd e8             	bsr    %eax,%ebp
  80361b:	83 f5 1f             	xor    $0x1f,%ebp
  80361e:	0f 84 ac 00 00 00    	je     8036d0 <__umoddi3+0x108>
  803624:	bf 20 00 00 00       	mov    $0x20,%edi
  803629:	29 ef                	sub    %ebp,%edi
  80362b:	89 fe                	mov    %edi,%esi
  80362d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803631:	89 e9                	mov    %ebp,%ecx
  803633:	d3 e0                	shl    %cl,%eax
  803635:	89 d7                	mov    %edx,%edi
  803637:	89 f1                	mov    %esi,%ecx
  803639:	d3 ef                	shr    %cl,%edi
  80363b:	09 c7                	or     %eax,%edi
  80363d:	89 e9                	mov    %ebp,%ecx
  80363f:	d3 e2                	shl    %cl,%edx
  803641:	89 14 24             	mov    %edx,(%esp)
  803644:	89 d8                	mov    %ebx,%eax
  803646:	d3 e0                	shl    %cl,%eax
  803648:	89 c2                	mov    %eax,%edx
  80364a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80364e:	d3 e0                	shl    %cl,%eax
  803650:	89 44 24 04          	mov    %eax,0x4(%esp)
  803654:	8b 44 24 08          	mov    0x8(%esp),%eax
  803658:	89 f1                	mov    %esi,%ecx
  80365a:	d3 e8                	shr    %cl,%eax
  80365c:	09 d0                	or     %edx,%eax
  80365e:	d3 eb                	shr    %cl,%ebx
  803660:	89 da                	mov    %ebx,%edx
  803662:	f7 f7                	div    %edi
  803664:	89 d3                	mov    %edx,%ebx
  803666:	f7 24 24             	mull   (%esp)
  803669:	89 c6                	mov    %eax,%esi
  80366b:	89 d1                	mov    %edx,%ecx
  80366d:	39 d3                	cmp    %edx,%ebx
  80366f:	0f 82 87 00 00 00    	jb     8036fc <__umoddi3+0x134>
  803675:	0f 84 91 00 00 00    	je     80370c <__umoddi3+0x144>
  80367b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80367f:	29 f2                	sub    %esi,%edx
  803681:	19 cb                	sbb    %ecx,%ebx
  803683:	89 d8                	mov    %ebx,%eax
  803685:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803689:	d3 e0                	shl    %cl,%eax
  80368b:	89 e9                	mov    %ebp,%ecx
  80368d:	d3 ea                	shr    %cl,%edx
  80368f:	09 d0                	or     %edx,%eax
  803691:	89 e9                	mov    %ebp,%ecx
  803693:	d3 eb                	shr    %cl,%ebx
  803695:	89 da                	mov    %ebx,%edx
  803697:	83 c4 1c             	add    $0x1c,%esp
  80369a:	5b                   	pop    %ebx
  80369b:	5e                   	pop    %esi
  80369c:	5f                   	pop    %edi
  80369d:	5d                   	pop    %ebp
  80369e:	c3                   	ret    
  80369f:	90                   	nop
  8036a0:	89 fd                	mov    %edi,%ebp
  8036a2:	85 ff                	test   %edi,%edi
  8036a4:	75 0b                	jne    8036b1 <__umoddi3+0xe9>
  8036a6:	b8 01 00 00 00       	mov    $0x1,%eax
  8036ab:	31 d2                	xor    %edx,%edx
  8036ad:	f7 f7                	div    %edi
  8036af:	89 c5                	mov    %eax,%ebp
  8036b1:	89 f0                	mov    %esi,%eax
  8036b3:	31 d2                	xor    %edx,%edx
  8036b5:	f7 f5                	div    %ebp
  8036b7:	89 c8                	mov    %ecx,%eax
  8036b9:	f7 f5                	div    %ebp
  8036bb:	89 d0                	mov    %edx,%eax
  8036bd:	e9 44 ff ff ff       	jmp    803606 <__umoddi3+0x3e>
  8036c2:	66 90                	xchg   %ax,%ax
  8036c4:	89 c8                	mov    %ecx,%eax
  8036c6:	89 f2                	mov    %esi,%edx
  8036c8:	83 c4 1c             	add    $0x1c,%esp
  8036cb:	5b                   	pop    %ebx
  8036cc:	5e                   	pop    %esi
  8036cd:	5f                   	pop    %edi
  8036ce:	5d                   	pop    %ebp
  8036cf:	c3                   	ret    
  8036d0:	3b 04 24             	cmp    (%esp),%eax
  8036d3:	72 06                	jb     8036db <__umoddi3+0x113>
  8036d5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8036d9:	77 0f                	ja     8036ea <__umoddi3+0x122>
  8036db:	89 f2                	mov    %esi,%edx
  8036dd:	29 f9                	sub    %edi,%ecx
  8036df:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8036e3:	89 14 24             	mov    %edx,(%esp)
  8036e6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8036ea:	8b 44 24 04          	mov    0x4(%esp),%eax
  8036ee:	8b 14 24             	mov    (%esp),%edx
  8036f1:	83 c4 1c             	add    $0x1c,%esp
  8036f4:	5b                   	pop    %ebx
  8036f5:	5e                   	pop    %esi
  8036f6:	5f                   	pop    %edi
  8036f7:	5d                   	pop    %ebp
  8036f8:	c3                   	ret    
  8036f9:	8d 76 00             	lea    0x0(%esi),%esi
  8036fc:	2b 04 24             	sub    (%esp),%eax
  8036ff:	19 fa                	sbb    %edi,%edx
  803701:	89 d1                	mov    %edx,%ecx
  803703:	89 c6                	mov    %eax,%esi
  803705:	e9 71 ff ff ff       	jmp    80367b <__umoddi3+0xb3>
  80370a:	66 90                	xchg   %ax,%ax
  80370c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803710:	72 ea                	jb     8036fc <__umoddi3+0x134>
  803712:	89 d9                	mov    %ebx,%ecx
  803714:	e9 62 ff ff ff       	jmp    80367b <__umoddi3+0xb3>
